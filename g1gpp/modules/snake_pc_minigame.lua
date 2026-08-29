-- G1GPP's Pokémon Center PC easter egg and source-only Snake minigame.
-- Every image is resolved from the player's imported Gen I cache at runtime;
-- this module ships no extracted graphics.

return function(config)
  local mod = assert(config and config.mod, "Snake PC requires mod")
  local logger = assert(config.logger, "Snake PC requires logger")
  local getGame = assert(config.getGame, "Snake PC requires getGame")
  local TextBox = config.TextBox or require("src.render.TextBox")
  local OverworldState = config.OverworldState
    or require("src.world.OverworldController")
  local Sound = config.Sound or require("src.core.Sound")
  local Music = config.Music or require("src.core.Music")
  local Font = config.Font or require("src.render.Font")
  local Theme = config.Theme or require("src.ui.Theme")
  local Assets = config.Assets or require("src.render.Assets")
  local FieldDefaults = config.FieldDefaults
    or require("src.world.FieldDefaults")
  local SpriteRenderer = config.SpriteRenderer
    or require("src.render.SpriteRenderer")
  local monotonic = config.monotonic
    or function() return love.timer.getTime() end
  local wallClock = config.wallClock or os.time
  local random = config.random or math.random

  local Controller = {}
  Controller.__index = Controller

  local SnakeState = {}
  SnakeState.__index = SnakeState
  SnakeState.isOpaque = true

  local STORAGE_KEY = "snake/state"
  local STORAGE_FORMAT = 1
  local REQUIRED_CYCLES = 10
  local MAX_CYCLE_GAP = 8
  local DIAGNOSTIC_SECONDS = 180
  local GRID_W, GRID_H = 18, 14
  local GRID_X, GRID_Y = 8, 24
  local SCORE_PER_CANDY = 5
  local BONUS_SCORE = 50
  local BONUS_THRESHOLD = 50
  local BONUS_LIFETIME = 2.5
  local CANDIES_PER_SPEED_STEP = 2
  local YELLOW_BONUS_CHANCE = 4
  local BLUE_SPEED_STEP_REDUCTION = 1
  local BLUE_LENGTH_REDUCTION = 1
  local YELLOW_SPEED_STEP_REDUCTION = 3
  local YELLOW_LENGTH_REDUCTION = 6
  local INITIAL_MOVE_DELAY = 0.22
  local MIN_MOVE_DELAY = 0.07
  local MOVE_DELAY_PER_STEP = 0.008
  local TITLE_PARADE_SPEED = 28
  local TITLE_PARADE_MIN_Y = 32
  local TITLE_PARADE_MAX_Y = 56
  local TITLE_PARADE_TILE = 8
  local TITLE_PARADE_LENGTH = 7
  local MAX_HIGH_SCORES = 5

  local function ensurePercentGlyph(game)
    local font = game and game.data and game.data.font
    if type(font) ~= "table" then return end
    -- Gen I has no normal percent glyph. Build 148 incorrectly mapped '%'
    -- onto cartridge tile $EA, which is unrelated artwork. Remove that stale
    -- mapping if this module is hot-reloaded, then register our generated page.
    local filtered = {}
    for _, entry in ipairs(font.charmap or {}) do
      if entry.seq ~= "%" then filtered[#filtered + 1] = entry end
    end
    font.charmap = filtered
    font.pages = font.pages or {}
    font.pages.g1gppSnakePercent = {
      image = "save/mod-derived/g1gpp/ui/g1gpp_snake_percent.png",
      base = 0x100,
      glyphsPerRow = 1,
      charmap = { { code = 0x100, seq = "%" } },
    }
    if Font.invalidate then Font.invalidate() end
  end

  local function shallowCopy(value)
    local out = {}
    for key, entry in pairs(value or {}) do out[key] = entry end
    return out
  end

  local function isPokemonCenter(game, overworld)
    local world = overworld or (game and game.overworld)
    local map = world and world.map
    local def = map and (map.def or map)
    return def and tostring(def.tileset):upper() == "POKECENTER" or false
  end

  local function cleanName(name)
    name = tostring(name or "PLAYER"):gsub("[^%w%p ]", "")
    if name == "" then name = "PLAYER" end
    return name:sub(1, 7)
  end

  function Controller.new()
    return setmetatable({
      game = nil,
      state = { status = "locked", highScores = {} },
      cycleCount = 0,
      lastShutdownAt = nil,
      pcSessionActive = false,
      completionSoundPending = false,
      completionSoundEligible = false,
    }, Controller)
  end

  function Controller:storageRecord()
    local scores = {}
    for index, row in ipairs(self.state.highScores or {}) do
      if index > MAX_HIGH_SCORES then break end
      scores[index] = {
        name = cleanName(row.name), score = math.max(0,
          math.floor(tonumber(row.score) or 0)),
      }
    end
    return {
      format = STORAGE_FORMAT,
      status = self.state.status,
      deadline = self.state.deadline,
      initialPending = self.state.initialPending == true,
      highScores = scores,
    }
  end

  function Controller:writeState(reason)
    if not self.game then return false end
    local ok, code, message = mod.storage:write(
      self.game, STORAGE_KEY, self:storageRecord())
    logger:log("SNAKE PC STATE SAVED",
      "reason=" .. logger:safeField(reason)
        .. " status=" .. logger:safeField(self.state.status)
        .. " ok=" .. logger:safeField(ok)
        .. " code=" .. logger:safeField(code)
        .. " message=" .. logger:safeField(message))
    return ok == true
  end

  function Controller:loadState(game)
    self.game = game
    self.cycleCount = 0
    self.lastShutdownAt = nil
    self.pcSessionActive = false
    self.completionSoundPending = false
    self.completionSoundEligible = false
    local record, code, message = mod.storage:read(game, STORAGE_KEY)
    if type(record) ~= "table" or record.format ~= STORAGE_FORMAT then
      self.state = { status = "locked", highScores = {} }
    else
      local status = record.status
      if status ~= "locked" and status ~= "checking"
          and status ~= "ready" and status ~= "unlocked" then
        status = "locked"
      end
      self.state = {
        status = status,
        deadline = tonumber(record.deadline),
        initialPending = record.initialPending == true,
        highScores = type(record.highScores) == "table"
          and record.highScores or {},
      }
      if status == "checking" and self.state.deadline
          and wallClock() >= self.state.deadline then
        -- A deadline crossed while the game was closed still unlocks the
        -- reveal, but cannot retroactively play the in-Center completion cue.
        self.state.status = "ready"
        self.state.initialPending = false
        self:writeState("deadline_elapsed_while_closed")
      end
    end
    logger:log("SNAKE PC STATE LOADED",
      "status=" .. logger:safeField(self.state.status)
        .. " deadline=" .. logger:safeField(self.state.deadline)
        .. " scores=" .. logger:safeField(#(self.state.highScores or {}))
        .. " code=" .. logger:safeField(code)
        .. " message=" .. logger:safeField(message))
  end

  function Controller:resetForDebug(game)
    self.game = game or self.game
    self.state = { status = "locked", highScores = {} }
    self.cycleCount = 0
    self.lastShutdownAt = nil
    self.pcSessionActive = false
    self.completionSoundPending = false
    self.completionSoundEligible = false
    local ok = self:writeState("debug_reset")
    logger:log("SNAKE DEBUG RESET",
      "ok=" .. logger:safeField(ok)
        .. " status=" .. logger:safeField(self.state.status)
        .. " scores=0")
    return ok
  end

  function Controller:decorateResetRow(row, manager)
    row.step = nil
    row.value = function()
      return tostring(self.state.status or "locked"):upper()
    end
    row.activate = function()
      self:resetForDebug((manager and manager.game) or self.game)
    end
  end

  function Controller:diagnosticPercent()
    local deadline = tonumber(self.state.deadline) or wallClock()
    local remaining = math.max(0, deadline - wallClock())
    local elapsed = DIAGNOSTIC_SECONDS - remaining
    return math.max(0, math.min(99,
      math.floor(elapsed * 100 / DIAGNOSTIC_SECONDS)))
  end

  function Controller:showChecking(done)
    local initial = self.state.initialPending == true
    if initial then
      self.state.initialPending = false
      self:writeState("initial_check_message")
    end
    local text = initial
      and "The PC is now\nchecking itself for\ferrors. Check back\nlater."
      or ("The PC is still\nchecking for errors.\fIt's currently at\n%d%%.")
        :format(self:diagnosticPercent())
    self.game.stack:push(TextBox.new(self.game, text, done))
    logger:log(initial and "SNAKE PC CHECK START MESSAGE"
        or "SNAKE PC CHECK PROGRESS",
      "percent=" .. logger:safeField(self:diagnosticPercent()))
  end

  function Controller:armDiagnostic()
    self.state.status = "checking"
    self.state.deadline = wallClock() + DIAGNOSTIC_SECONDS
    self.state.initialPending = true
    self.cycleCount = 0
    self.lastShutdownAt = nil
    self:writeState("ten_rapid_cycles")
    logger:log("SNAKE PC DIAGNOSTIC ARMED",
      "seconds=" .. DIAGNOSTIC_SECONDS
        .. " requiredCycles=" .. REQUIRED_CYCLES)
  end

  function Controller:recordShutdown()
    if self.state.status ~= "locked" then return end
    local now = monotonic()
    if self.lastShutdownAt
        and now - self.lastShutdownAt <= MAX_CYCLE_GAP then
      self.cycleCount = self.cycleCount + 1
    else
      self.cycleCount = 1
    end
    self.lastShutdownAt = now
    logger:log("SNAKE PC RAPID CYCLE",
      "count=" .. self.cycleCount .. " required=" .. REQUIRED_CYCLES
        .. " maxGap=" .. MAX_CYCLE_GAP)
    if self.cycleCount >= REQUIRED_CYCLES then self:armDiagnostic() end
  end

  function Controller:onSoundPlayed(event)
    if not self.pcSessionActive or not event
        or event.name ~= "Turn_Off_PC" then return end
    self.pcSessionActive = false
    self:recordShutdown()
  end

  function Controller:updateTimer()
    if not self.game then return end
    if self.state.status == "checking" and self.state.deadline
        and wallClock() >= self.state.deadline then
      self.state.status = "ready"
      self.state.initialPending = false
      self.completionSoundEligible = isPokemonCenter(self.game)
      self.completionSoundPending = self.completionSoundEligible
      self:writeState("diagnostic_complete")
      logger:log("SNAKE PC DIAGNOSTIC COMPLETE",
        "inPokemonCenter=" .. logger:safeField(
          self.completionSoundEligible))
    end
    if not self.completionSoundPending then return end
    if not isPokemonCenter(self.game) then
      self.completionSoundPending = false
      logger:log("SNAKE PC COMPLETION SOUND SKIPPED",
        "reason=left_pokemon_center")
      return
    end
    if self.game.stack and self.game.stack:top() == self.game.overworld then
      self.completionSoundPending = false
      Sound.play(self.game.data, "Turn_On_PC")
      logger:log("SNAKE PC COMPLETION SOUND PLAYED",
        "sound=Turn_On_PC")
    end
  end

  function Controller:openReadyPC(overworld, onDone, original)
    self.state.status = "unlocked"
    self.state.deadline = nil
    self.state.initialPending = false
    self.completionSoundPending = false
    self:writeState("first_reveal")

    -- The normal PC builder is retained in full. For this one interaction,
    -- only its synchronous startup sound and startup sentence are replaced.
    local previousPlay, previousNew = Sound.play, TextBox.new
    local revealPending = true
    Sound.play = function(data, name, ...)
      if name == "Turn_On_PC" then return nil end
      return previousPlay(data, name, ...)
    end
    TextBox.new = function(game, text, done, opts)
      if revealPending then
        revealPending = false
        return previousNew(game, "The PC has new\noptions now.", done, opts)
      end
      return previousNew(game, text, done, opts)
    end
    local ok, result = pcall(original, overworld, onDone)
    Sound.play, TextBox.new = previousPlay, previousNew
    if not ok then error(result, 0) end
    logger:log("SNAKE PC REVEALED",
      "permanentForPlaythrough=true normalBootRestoredAfter=true")
    return result
  end

  function Controller:openPC(overworld, onDone, original)
    local game = getGame()
    if not game or not isPokemonCenter(game, overworld) then
      return original(overworld, onDone)
    end
    self.game = game
    if self.state.status == "checking" then
      if self.state.deadline and wallClock() >= self.state.deadline then
        self.state.status = "ready"
        self.state.initialPending = false
        self:writeState("deadline_seen_at_pc")
      else
        return self:showChecking(onDone or function() end)
      end
    end
    if self.state.status == "ready" then
      return self:openReadyPC(overworld, onDone, original)
    end
    self.pcSessionActive = true
    return original(overworld, onDone)
  end

  function Controller:addHighScore(score)
    score = math.max(0, math.floor(tonumber(score) or 0))
    local rows = self.state.highScores or {}
    rows[#rows + 1] = {
      name = cleanName(self.game and self.game.save
        and self.game.save.player and self.game.save.player.name),
      score = score,
    }
    table.sort(rows, function(a, b)
      if a.score == b.score then return a.name < b.name end
      return a.score > b.score
    end)
    while #rows > MAX_HIGH_SCORES do table.remove(rows) end
    self.state.highScores = rows
    self:writeState("high_score")
    return rows
  end

  local function loadImage(path)
    if not path then return nil end
    local ok, image = pcall(Assets.image, path)
    return ok and image or nil
  end

  local function loadAlphaMasks(path, frameWidth, frameHeight, frameCount)
    if not (love and love.image and love.image.newImageData) then return nil end
    local ok, pixels = pcall(love.image.newImageData, path)
    if not (ok and pixels) then return nil end
    local masks = {}
    for frame = 0, frameCount - 1 do
      local rows = {}
      for y = 0, frameHeight - 1 do
        local row = {}
        for x = 0, frameWidth - 1 do
          local _, _, _, alpha = pixels:getPixel(
            x, frame * frameHeight + y)
          row[x + 1] = (alpha or 0) >= 0.5
        end
        rows[y + 1] = row
      end
      masks[frame + 1] = rows
    end
    return masks
  end

  local function appendMaskZones(zones, colors, x, y, mask, mirror,
      clipX, clipY, clipW, clipH)
    if not (colors and mask) then return end
    for rowIndex, row in ipairs(mask) do
      local column = 1
      while column <= #row do
        local sourceColumn = mirror and (#row - column + 1) or column
        if row[sourceColumn] then
          local first = column
          repeat
            column = column + 1
            sourceColumn = mirror and (#row - column + 1) or column
          until column > #row or not row[sourceColumn]
          local zoneX = x + first - 1
          local zoneY = y + rowIndex - 1
          local zoneW = column - first
          if clipX then
            local right = math.min(zoneX + zoneW, clipX + clipW)
            zoneX = math.max(zoneX, clipX)
            zoneW = right - zoneX
            if zoneY < clipY or zoneY >= clipY + clipH then zoneW = 0 end
          end
          if zoneW > 0 and (not clipY or zoneY < clipY + clipH) then
            zones[#zones + 1] = {
              colors = colors, x = zoneX, y = zoneY, w = zoneW, h = 1,
            }
          end
        else
          column = column + 1
        end
      end
    end
  end

  function SnakeState.new(controller, game)
    local self = setmetatable({}, SnakeState)
    self.controller = controller
    self.game = game
    self.phase = "title"
    self.titleChoice = 1
    self.titleTime = 0
    self.titleScroll = 0
    self.titleParadeNodes = {}
    for index = 1, TITLE_PARADE_LENGTH do
      self.titleParadeNodes[index] = { x = -8 * index, y = 40 }
    end
    self.titleParadeDirection = "right"
    self.titleParadeProgress = 0
    self.titleParadeRightSteps = random(3, 7)
    self.titleParadeVerticalSteps = 0
    self.direction = "right"
    self.nextDirection = "right"
    self.score = 0
    self.candies = 0
    self.blueCandies = 0
    self.yellowCandies = 0
    self.regularPointsTowardBonus = 0
    self.speedSteps = 0
    self.bonusCandy = nil
    self.bonusKind = nil
    self.bonusTimer = 0
    self.tick = 0
    self.moveDelay = INITIAL_MOVE_DELAY
    self.segments = {}
    self:loadRuntimeArt()
    Music.play(game.data, "Music_MuseumGuy", true,
      { reason = "g1gpp_snake" })
    logger:log("SNAKE MUSIC STARTED", "song=Music_MuseumGuy loop=true")
    return self
  end

  function SnakeState:loadRuntimeArt()
    local data = self.game.data or {}
    local walkId = FieldDefaults.fieldValue(data, "playerSprites", "walk")
    local def = data.sprites and data.sprites[walkId]
    if def then
      local ok, sprite = pcall(SpriteRenderer.new, def, "g1gpp-snake")
      if ok then self.playerSprite = sprite end
    end
    local playerPath =
      "save/mod-derived/g1gpp/ui/g1gpp_snake_player.png"
    self.playerMicroImage = loadImage(playerPath)
    self.playerMasks = loadAlphaMasks(playerPath, 8, 8, 6)
    local ballPath = "save/mod-derived/g1gpp/ui/g1gpp_snake_ball.png"
    self.ballImage = loadImage(ballPath)
    self.ballMasks = loadAlphaMasks(ballPath, 8, 8, 1)
    if self.ballImage then
      local w, h = self.ballImage:getDimensions()
      self.ballQuad = love.graphics.newQuad(0, 0, 8, 8, w, h)
    end
    local candyPath = "save/mod-derived/g1gpp/ui/g1gpp_snake_candy.png"
    self.candyImage = loadImage(candyPath)
    self.candyMasks = loadAlphaMasks(candyPath, 8, 8, 1)
    if self.candyImage then
      local w, h = self.candyImage:getDimensions()
      self.candyQuad = love.graphics.newQuad(0, 0, 8, 8, w, h)
    end
  end

  function SnakeState:close()
    if not self.musicRestored then
      self.musicRestored = true
      Music.restoreMap(self.game.data)
      logger:log("SNAKE MUSIC RESTORED", "song=map")
    end
    if self.game.stack:top() == self then self.game.stack:pop() end
  end

  function SnakeState:startGame()
    self.phase = "playing"
    self.direction = "right"
    self.nextDirection = "right"
    self.score = 0
    self.candies = 0
    self.blueCandies = 0
    self.yellowCandies = 0
    self.regularPointsTowardBonus = 0
    self.speedSteps = 0
    self.bonusCandy = nil
    self.bonusKind = nil
    self.bonusTimer = 0
    self.tick = 0
    self.moveDelay = INITIAL_MOVE_DELAY
    self.segments = { { x = 6, y = 7 } }
    self:spawnCandy()
    logger:log("SNAKE GAME STARTED",
      "grid=" .. GRID_W .. "x" .. GRID_H .. " initialLength=1")
  end

  function SnakeState:freeCells(excluded)
    local free = {}
    for y = 1, GRID_H do
      for x = 1, GRID_W do
        local occupied = false
        for _, segment in ipairs(self.segments) do
          if segment.x == x and segment.y == y then
            occupied = true
            break
          end
        end
        if not occupied and excluded
            and excluded.x == x and excluded.y == y then occupied = true end
        if not occupied then free[#free + 1] = { x = x, y = y } end
      end
    end
    return free
  end

  function SnakeState:spawnCandy()
    local free = self:freeCells(self.bonusCandy)
    if #free == 0 then return self:finishGame(true) end
    self.candy = free[random(1, #free)]
  end

  function SnakeState:spawnBonusCandy()
    local free = self:freeCells(self.candy)
    if #free == 0 then return false end
    self.bonusCandy = free[random(1, #free)]
    self.bonusKind = random(1, YELLOW_BONUS_CHANCE) == 1
      and "yellow" or "blue"
    self.bonusTimer = BONUS_LIFETIME
    logger:log("SNAKE BONUS CANDY SPAWNED",
      "kind=" .. self.bonusKind
        .. " x=" .. self.bonusCandy.x .. " y=" .. self.bonusCandy.y
        .. " lifetime=" .. BONUS_LIFETIME)
    return true
  end

  function SnakeState:updateMoveDelay()
    self.moveDelay = math.max(MIN_MOVE_DELAY,
      INITIAL_MOVE_DELAY - self.speedSteps * MOVE_DELAY_PER_STEP)
  end

  function SnakeState:updateBonusCandy(dt)
    if not self.bonusCandy then return end
    self.bonusTimer = self.bonusTimer - dt
    if self.bonusTimer <= 0 then
      logger:log("SNAKE BONUS CANDY EXPIRED",
        "kind=" .. tostring(self.bonusKind)
          .. " score=" .. self.score .. " regularPoints="
          .. self.regularPointsTowardBonus)
      self.bonusCandy = nil
      self.bonusKind = nil
      self.bonusTimer = 0
    end
  end

  function SnakeState:finishGame(boardCleared)
    if self.phase ~= "playing" then return end
    self.phase = "gameover"
    self.boardCleared = boardCleared == true
    self.controller:addHighScore(self.score)
    Sound.play(self.game.data, boardCleared and "Caught_Mon" or "Denied")
    logger:log("SNAKE GAME ENDED",
      "score=" .. self.score .. " candies=" .. self.candies
        .. " blueCandies=" .. self.blueCandies
        .. " yellowCandies=" .. self.yellowCandies
        .. " length=" .. #self.segments
        .. " boardCleared=" .. logger:safeField(boardCleared == true))
  end

  local OPPOSITE = {
    up = "down", down = "up", left = "right", right = "left",
  }
  local DELTA = {
    up = { 0, -1 }, down = { 0, 1 }, left = { -1, 0 }, right = { 1, 0 },
  }

  function SnakeState:resetTitleParade()
    self.titleParadeNodes = {}
    for index = 1, TITLE_PARADE_LENGTH do
      self.titleParadeNodes[index] = { x = -8 * index, y = 40 }
    end
    self.titleParadeDirection = "right"
    self.titleParadeProgress = 0
    self.titleParadeRightSteps = random(3, 7)
    self.titleParadeVerticalSteps = 0
  end

  function SnakeState:chooseTitleParadeDirection()
    local head = self.titleParadeNodes[1]
    if self.titleParadeDirection == "up"
        or self.titleParadeDirection == "down" then
      self.titleParadeVerticalSteps = self.titleParadeVerticalSteps - 1
      if self.titleParadeVerticalSteps > 0 then return end
      self.titleParadeDirection = "right"
      self.titleParadeRightSteps = random(3, 7)
      return
    end

    self.titleParadeRightSteps = self.titleParadeRightSteps - 1
    if self.titleParadeRightSteps > 0 then return end
    local direction
    if head.y <= TITLE_PARADE_MIN_Y then
      direction = "down"
    elseif head.y >= TITLE_PARADE_MAX_Y then
      direction = "up"
    else
      direction = random(0, 1) == 0 and "up" or "down"
    end
    local available = direction == "up"
      and math.floor((head.y - TITLE_PARADE_MIN_Y) / TITLE_PARADE_TILE)
      or math.floor((TITLE_PARADE_MAX_Y - head.y) / TITLE_PARADE_TILE)
    self.titleParadeDirection = direction
    self.titleParadeVerticalSteps = random(1, math.min(2, available))
  end

  function SnakeState:updateTitleParade(dt)
    self.titleParadeProgress = self.titleParadeProgress
      + TITLE_PARADE_SPEED * dt / TITLE_PARADE_TILE
    while self.titleParadeProgress >= 1 do
      self.titleParadeProgress = self.titleParadeProgress - 1
      local delta = DELTA[self.titleParadeDirection]
      for index = #self.titleParadeNodes, 2, -1 do
        self.titleParadeNodes[index].x = self.titleParadeNodes[index - 1].x
        self.titleParadeNodes[index].y = self.titleParadeNodes[index - 1].y
      end
      local head = self.titleParadeNodes[1]
      head.x = head.x + delta[1] * TITLE_PARADE_TILE
      head.y = head.y + delta[2] * TITLE_PARADE_TILE
      if head.x >= 224 then
        self:resetTitleParade()
      else
        self:chooseTitleParadeDirection()
      end
    end
  end

  function SnakeState:titleParadePositions()
    local positions = {}
    local progress = self.titleParadeProgress
    local delta = DELTA[self.titleParadeDirection]
    for index, node in ipairs(self.titleParadeNodes) do
      local tx, ty
      if index == 1 then
        tx = node.x + delta[1] * TITLE_PARADE_TILE
        ty = node.y + delta[2] * TITLE_PARADE_TILE
      else
        tx = self.titleParadeNodes[index - 1].x
        ty = self.titleParadeNodes[index - 1].y
      end
      positions[index] = {
        x = math.floor(node.x + (tx - node.x) * progress + 0.5),
        y = math.floor(node.y + (ty - node.y) * progress + 0.5),
      }
    end
    return positions
  end

  function SnakeState:acceptDirection(direction)
    if OPPOSITE[direction] ~= self.direction then
      self.nextDirection = direction
    end
  end

  function SnakeState:advance()
    self.direction = self.nextDirection
    local delta = DELTA[self.direction]
    local head = self.segments[1]
    local nx, ny = head.x + delta[1], head.y + delta[2]
    if nx < 1 or nx > GRID_W or ny < 1 or ny > GRID_H then
      return self:finishGame(false)
    end
    local grows = self.candy and nx == self.candy.x and ny == self.candy.y
    local getsBonus = self.bonusCandy
      and nx == self.bonusCandy.x and ny == self.bonusCandy.y
    local collisionLimit = grows and #self.segments or #self.segments - 1
    for index = 1, collisionLimit do
      local segment = self.segments[index]
      if segment.x == nx and segment.y == ny then
        return self:finishGame(false)
      end
    end
    table.insert(self.segments, 1, { x = nx, y = ny })
    if grows then
      self.candies = self.candies + 1
      self.score = self.score + SCORE_PER_CANDY
      self.regularPointsTowardBonus = self.regularPointsTowardBonus
        + SCORE_PER_CANDY
      if self.candies % CANDIES_PER_SPEED_STEP == 0 then
        self.speedSteps = self.speedSteps + 1
        self:updateMoveDelay()
      end
      Sound.play(self.game.data, "Press_AB")
      self:spawnCandy()
      if self.phase == "playing" and not self.bonusCandy
          and self.regularPointsTowardBonus >= BONUS_THRESHOLD then
        self.regularPointsTowardBonus = self.regularPointsTowardBonus
          - BONUS_THRESHOLD
        self:spawnBonusCandy()
      end
    else
      table.remove(self.segments)
    end
    if getsBonus then
      local bonusKind = self.bonusKind == "yellow" and "yellow" or "blue"
      local lengthReduction = bonusKind == "yellow"
        and YELLOW_LENGTH_REDUCTION or BLUE_LENGTH_REDUCTION
      local speedReduction = bonusKind == "yellow"
        and YELLOW_SPEED_STEP_REDUCTION or BLUE_SPEED_STEP_REDUCTION
      self.score = self.score + BONUS_SCORE
      if bonusKind == "yellow" then
        self.yellowCandies = self.yellowCandies + 1
      else
        self.blueCandies = self.blueCandies + 1
      end
      self.bonusCandy = nil
      self.bonusKind = nil
      self.bonusTimer = 0
      for _ = 1, lengthReduction do
        if #self.segments <= 1 then break end
        table.remove(self.segments)
      end
      self.speedSteps = math.max(0,
        self.speedSteps - speedReduction)
      self:updateMoveDelay()
      Sound.play(self.game.data, "Press_AB")
      logger:log("SNAKE BONUS CANDY COLLECTED",
        "kind=" .. bonusKind .. " score=" .. self.score
          .. " length=" .. #self.segments
          .. " speedSteps=" .. self.speedSteps)
    end
  end

  function SnakeState:update(dt)
    self.titleTime = self.titleTime + dt
    self.titleScroll = self.titleScroll + dt * 24
    if self.phase == "title" then self:updateTitleParade(dt) end
    local input = self.game.input
    if self.phase == "title" then
      if input:wasPressed("up") then
        self.titleChoice = self.titleChoice > 1 and self.titleChoice - 1 or 3
      elseif input:wasPressed("down") then
        self.titleChoice = self.titleChoice < 3 and self.titleChoice + 1 or 1
      elseif input:wasPressed("b") then
        self:close()
      elseif input:wasPressed("a") or input:wasPressed("start") then
        if self.titleChoice == 1 then
          self:startGame()
        elseif self.titleChoice == 2 then
          self.phase = "scores"
        else
          self:close()
        end
      end
      return
    end
    if self.phase == "scores" then
      if input:wasPressed("a") or input:wasPressed("b")
          or input:wasPressed("start") then self.phase = "title" end
      return
    end
    if self.phase == "gameover" then
      if input:wasPressed("a") or input:wasPressed("b")
          or input:wasPressed("start") then self.phase = "title" end
      return
    end
    if self.phase == "paused" then
      if input:wasPressed("start") or input:wasPressed("a") then
        self.phase = "playing"
      elseif input:wasPressed("b") then
        self.phase = "title"
      end
      return
    end
    if input:wasPressed("start") then self.phase = "paused" return end
    for _, direction in ipairs({ "up", "down", "left", "right" }) do
      if input:wasPressed(direction) then
        self:acceptDirection(direction)
        break
      end
    end
    self:updateBonusCandy(dt)
    self.tick = self.tick + dt
    while self.phase == "playing" and self.tick >= self.moveDelay do
      self.tick = self.tick - self.moveDelay
      self:advance()
    end
  end

  local function centered(text)
    return math.floor((160 - Font.width(text)) / 2)
  end

  function SnakeState:drawPlayer(x, y, direction)
    local sprite = self.playerSprite
    if not sprite then
      Font.drawCode(Theme.cursor, x, y)
      return
    end
    local geometry = sprite:getPoseGeometry(direction or "down", 0, false)
    local image = sprite:resolveImage()
    local qx, qy = geometry.quad:getViewport()
    if self.playerMicroImage then
      local mw, mh = self.playerMicroImage:getDimensions()
      local frame = math.max(0, math.min(5, math.floor(qy / 16)))
      self.playerPaletteFrame = frame + 1
      self.playerPaletteMirror = geometry.mirror == true
      local quad = love.graphics.newQuad(0, frame * 8, 8, 8, mw, mh)
      local sx = geometry.mirror and -1 or 1
      local dx = geometry.mirror and x + 8 or x
      local min, mag = self.playerMicroImage:getFilter()
      self.playerMicroImage:setFilter("nearest", "nearest")
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(self.playerMicroImage, quad, dx, y, 0, sx, 1)
      self.playerMicroImage:setFilter(min, mag)
      return
    end
    local iw, ih = image:getDimensions()
    -- The transform normally supplies an outline-aware 8x8 micro-sprite.
    -- Retain the native head crop only as a cache-generation fallback.
    local headQuad = love.graphics.newQuad(qx + 4, qy, 8, 8, iw, ih)
    local sx = geometry.mirror and -1 or 1
    local dx = geometry.mirror and x + 8 or x
    local min, mag = image:getFilter()
    image:setFilter("nearest", "nearest")
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(image, headQuad, dx, y, 0, sx, 1)
    image:setFilter(min, mag)
  end

  function SnakeState:drawBall(x, y)
    if self.ballImage and self.ballQuad then
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(self.ballImage, self.ballQuad, x, y)
    else
      Font.draw("O", x, y)
    end
  end

  function SnakeState:drawCandy(x, y)
    if self.candyImage and self.candyQuad then
      local min, mag = self.candyImage:getFilter()
      self.candyImage:setFilter("nearest", "nearest")
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(self.candyImage, self.candyQuad, x, y)
      self.candyImage:setFilter(min, mag)
    else
      Font.draw("*", x, y)
    end
  end

  function SnakeState:drawGrassBoard()
    -- A quiet micro-lawn: mostly one green shade with sparse two-pixel grass
    -- blades. The exact overworld grass tile repeated here read as crop rows.
    love.graphics.setColor(2 / 3, 2 / 3, 2 / 3, 1)
    love.graphics.rectangle("fill", GRID_X, GRID_Y, GRID_W * 8, GRID_H * 8)
    love.graphics.setColor(1 / 3, 1 / 3, 1 / 3, 1)
    for gy = 0, GRID_H - 1 do
      for gx = 0, GRID_W - 1 do
        if (gx * 7 + gy * 11) % 13 == 0 then
          local px = GRID_X + gx * 8 + 3
          local py = GRID_Y + gy * 8 + 4
          love.graphics.points(px, py, px + 1, py - 1)
        end
      end
    end
  end

  function SnakeState:scoreTicker()
    local rows = self.controller.state.highScores or {}
    if #rows == 0 then return "NO HIGH SCORES YET" end
    local parts = {}
    for index, row in ipairs(rows) do
      parts[#parts + 1] = ("%d.%s %05d"):format(
        index, cleanName(row.name), math.min(99999, row.score or 0))
    end
    return table.concat(parts, "   ")
  end

  function SnakeState:drawTitle()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, 160, 144)
    love.graphics.setColor(0, 0, 0, 1)
    Font.drawBox(0, 0, 20, 18)
    Font.draw("SNAKE", centered("SNAKE"), 16)
    local parade = self:titleParadePositions()
    local oldX, oldY, oldW, oldH = love.graphics.getScissor()
    love.graphics.setScissor(8, 32, 144, 32)
    self:drawPlayer(parade[1].x, parade[1].y,
      self.titleParadeDirection)
    for index = 2, 4 do
      self:drawBall(parade[index].x, parade[index].y)
    end
    for index = 5, 7 do
      self:drawCandy(parade[index].x, parade[index].y)
    end
    if oldX then
      love.graphics.setScissor(oldX, oldY, oldW, oldH)
    else
      love.graphics.setScissor()
    end
    local labels = { "START", "HIGH SCORES", "EXIT" }
    for index, label in ipairs(labels) do Font.draw(label, 40, 72 + index * 16) end
    Font.drawCode(Theme.cursor, 24, 72 + self.titleChoice * 16)
  end

  function SnakeState:sgbPalettes(game)
    local PaletteFX = require("src.render.PaletteFX")
    local data = game and game.data or self.game and self.game.data
    local base = PaletteFX.pal(data, "ROUTE")
      or PaletteFX.pal(data, "GREENBAR")
    local zones
    if self.phase == "title" then
      zones = { PaletteFX.whole(PaletteFX.GRAYS) }
      local parade = self:titleParadePositions()
      appendMaskZones(zones, PaletteFX.pal(data, "REDMON"),
        parade[1].x, parade[1].y,
        self.playerMasks and self.playerMasks[self.playerPaletteFrame or 1],
        self.playerPaletteMirror, 8, 32, 144, 32)
      for index = 2, 4 do
        appendMaskZones(zones, PaletteFX.pal(data, "REDMON"),
          parade[index].x, parade[index].y,
          self.ballMasks and self.ballMasks[1], false, 8, 32, 144, 32)
      end
      appendMaskZones(zones,
        PaletteFX.pal(data, "PURPLEMON") or PaletteFX.pal(data, "BLUEMON"),
        parade[5].x, parade[5].y, self.candyMasks and self.candyMasks[1],
        false, 8, 32, 144, 32)
      appendMaskZones(zones, PaletteFX.pal(data, "BLUEMON"),
        parade[6].x, parade[6].y, self.candyMasks and self.candyMasks[1],
        false, 8, 32, 144, 32)
      appendMaskZones(zones, PaletteFX.pal(data, "YELLOWMON"),
        parade[7].x, parade[7].y, self.candyMasks and self.candyMasks[1],
        false, 8, 32, 144, 32)
    elseif self.segments and self.segments[1] then
      zones = { PaletteFX.whole(PaletteFX.GRAYS) }
      zones[#zones + 1] = {
        colors = base, x = GRID_X, y = GRID_Y,
        w = GRID_W * 8, h = GRID_H * 8,
      }
      if self.candy then
        appendMaskZones(zones,
          PaletteFX.pal(data, "PURPLEMON")
            or PaletteFX.pal(data, "BLUEMON"),
          GRID_X + (self.candy.x - 1) * 8,
          GRID_Y + (self.candy.y - 1) * 8,
          self.candyMasks and self.candyMasks[1])
      end
      if self.bonusCandy then
        appendMaskZones(zones, PaletteFX.pal(data,
            self.bonusKind == "yellow" and "YELLOWMON" or "BLUEMON"),
          GRID_X + (self.bonusCandy.x - 1) * 8,
          GRID_Y + (self.bonusCandy.y - 1) * 8,
          self.candyMasks and self.candyMasks[1])
      end
      for index = 2, #(self.segments or {}) do
        local segment = self.segments[index]
        appendMaskZones(zones,
          PaletteFX.pal(data, "REDMON"),
          GRID_X + (segment.x - 1) * 8,
          GRID_Y + (segment.y - 1) * 8,
          self.ballMasks and self.ballMasks[1])
      end
      local head = self.segments[1]
      appendMaskZones(zones, PaletteFX.pal(data, "REDMON"),
        GRID_X + (head.x - 1) * 8,
        GRID_Y + (head.y - 1) * 8,
        self.playerMasks and self.playerMasks[self.playerPaletteFrame or 1],
        self.playerPaletteMirror)
    else
      zones = { PaletteFX.whole(PaletteFX.GRAYS) }
    end
    return zones
  end

  function SnakeState:drawScores()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, 160, 144)
    love.graphics.setColor(0, 0, 0, 1)
    Font.drawBox(0, 0, 20, 18)
    Font.draw("HIGH SCORES", centered("HIGH SCORES"), 16)
    local rows = self.controller.state.highScores or {}
    for index = 1, MAX_HIGH_SCORES do
      local row = rows[index]
      local name = row and cleanName(row.name) or "-------"
      local score = row and math.min(99999, row.score or 0) or 0
      Font.draw(("%d.%-7s"):format(index, name), 16, 24 + index * 16)
      Font.draw(("%05d"):format(score), 104, 24 + index * 16)
    end
    Font.draw("A/B:BACK", 48, 120)
  end

  function SnakeState:drawGame()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, 160, 144)
    love.graphics.setColor(0, 0, 0, 1)
    Font.drawBox(0, 0, 20, 3)
    Font.draw(("SCORE %05d"):format(math.min(99999, self.score)), 8, 8)
    Font.draw(("x%02d"):format(math.min(99, self.candies)), 128, 8)
    Font.drawBox(0, 2, 20, 16)
    self:drawGrassBoard()
    if self.candy then
      self:drawCandy(GRID_X + (self.candy.x - 1) * 8,
        GRID_Y + (self.candy.y - 1) * 8)
    end
    if self.bonusCandy then
      self:drawCandy(GRID_X + (self.bonusCandy.x - 1) * 8,
        GRID_Y + (self.bonusCandy.y - 1) * 8)
    end
    for index = #self.segments, 2, -1 do
      local segment = self.segments[index]
      self:drawBall(GRID_X + (segment.x - 1) * 8,
        GRID_Y + (segment.y - 1) * 8)
    end
    local head = self.segments[1]
    if head then
      self:drawPlayer(GRID_X + (head.x - 1) * 8,
        GRID_Y + (head.y - 1) * 8, self.direction)
    end
    if self.phase == "paused" then
      Font.drawBox(4, 6, 12, 6)
      Font.draw("PAUSED", 56, 64)
      Font.draw("START:GO", 40, 80)
      Font.draw("B:QUIT", 48, 96)
    elseif self.phase == "gameover" then
      Font.drawBox(3, 5, 14, 9)
      local title = self.boardCleared and "YOU WIN!" or "GAME OVER"
      Font.draw(title, centered(title), 48)
      Font.draw(("SCORE %05d"):format(math.min(99999, self.score)), 40, 72)
      Font.draw("A:TITLE", 48, 96)
    end
  end

  function SnakeState:draw()
    if self.phase == "title" then self:drawTitle()
    elseif self.phase == "scores" then self:drawScores()
    else self:drawGame() end
    love.graphics.setColor(1, 1, 1, 1)
  end

  local controller = Controller.new()

  local originalOpenPC = OverworldState._g1gppSnakeOriginalOpenPC
    or OverworldState.openPC
  OverworldState._g1gppSnakeOriginalOpenPC = originalOpenPC
  OverworldState.openPC = function(overworld, onDone)
    return controller:openPC(overworld, onDone, originalOpenPC)
  end

  mod.events:on("game.ready", function(event)
    ensurePercentGlyph(event.game)
    controller:loadState(event.game)
  end)

  mod.events:on("save.loaded", function()
    local game = getGame()
    if game then controller:loadState(game) end
  end)

  mod.events:on("save.created", function()
    local game = getGame()
    if game then controller:loadState(game) end
  end)

  mod.events:on("sound.played", function(event)
    controller:onSoundPlayed(event)
  end)

  mod.hooks:wrap("input.step", function(next, game, dt)
    next(game, dt)
    controller:updateTimer()
  end)

  mod.hooks:wrap("ui.pc.items", function(next, game, items)
    local rows = next(game, items)
    if controller.state.status ~= "unlocked" then return rows end
    for _, row in ipairs(rows) do
      if row._g1gppSnake then return rows end
    end
    rows[#rows + 1] = {
      label = "SNAKE.EXE",
      keepOpen = true,
      _g1gppSnake = true,
      onSelect = function()
        Sound.play(game.data, "Enter_PC")
        game.stack:push(SnakeState.new(controller, game))
        logger:log("SNAKE.EXE OPENED",
          "scores=" .. logger:safeField(
            #(controller.state.highScores or {})))
      end,
    }
    return rows
  end)

  return {
    controller = controller,
    SnakeState = SnakeState,
    constants = {
      requiredCycles = REQUIRED_CYCLES,
      maxCycleGap = MAX_CYCLE_GAP,
      diagnosticSeconds = DIAGNOSTIC_SECONDS,
      gridWidth = GRID_W,
      gridHeight = GRID_H,
    },
    isPokemonCenter = isPokemonCenter,
  }
end
