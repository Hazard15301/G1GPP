-- Reusable, save-safe Pokédex anomaly controller.
-- The original glitch may freeze forever or read arbitrary memory; this
-- version corrupts only the visible frame, blocks input, and returns safely.
return function(ctx)
  local logger = assert(ctx and ctx.logger, "pokedex anomaly needs logger")
  local DexEntryMenu = require("src.ui.DexEntryMenu")
  local Runtime = require("src.mods.Runtime")
  local Music = require("src.core.Music")
  local Sound = require("src.core.Sound")

  local Controller = {}
  Controller.__index = Controller
  Controller.isOpaque = false

  local function drawFullDisplayBlack(game, alpha)
    local renderer = game and game.renderer
    if renderer then
      -- screenVeil is applied to the final desktop image, so it also covers
      -- the scaled-canvas edge pixels and letterbox area. This is the same
      -- proven blackout path used by the retired-encounter recovery.
      renderer.screenVeil = { 0, alpha }
      return
    end
    love.graphics.setColor(0, 0, 0, alpha)
    love.graphics.rectangle("fill", -2048, -2048, 4096, 4096)
    love.graphics.setColor(1, 1, 1, 1)
  end

  local function battleBelow(game)
    local states = game and game.stack and game.stack.states or {}
    for i = #states, 1, -1 do
      local state = states[i]
      if state and state.enemy and type(state.onFinish) == "function" then
        return state
      end
    end
  end

  function Controller.new(game, screen, owner)
    return setmetatable({game=game, screen=screen, owner=owner,
      battle=battleBelow(game), phase="glitch", frame=0,
      strips={}, closed=false}, Controller)
  end

  function Controller:closeUnderBlack()
    if self.closed then return true end
    local game, stack = self.game, self.game.stack
    local world = game and game.overworld
    local states = stack and stack.states or {}
    local worldIndex
    for i = #states, 1, -1 do
      if states[i] == world then worldIndex = i break end
    end
    if not worldIndex then
      logger:log("POKEDEX ANOMALY RECOVERY FAILED", "reason=overworld_missing")
      return false
    end

    while #states > worldIndex do stack:pop() end
    local battle = self.battle
    if battle then
      battle.result = "caught"
      Runtime.emit("battle.ended", {battle=battle, result="caught"})
      pcall(battle.onFinish, "caught")
      -- A native return transition is unnecessary while the screen is black.
      while #states > worldIndex do stack:pop() end
    end
    Music.stop()
    Sound.stopLoop("Low_Health_Alarm")
    stack:push(self)
    self.closed = true
    logger:log("POKEDEX ANOMALY RECOVERY VERIFIED",
      "special=214 resultPreserved=" .. tostring(battle ~= nil)
        .. " overworldReady=" .. tostring(stack.states[worldIndex] == world)
        .. " inputBlocked=true")
    return true
  end

  function Controller:update(_dt)
    self.frame = self.frame + 1
    if self.phase == "glitch" then
      if self.frame % 5 == 0 then
        self.strips[#self.strips + 1] = {
          y=math.random(0, 136), h=math.random(2, 12),
          x=math.random(-24, 24), dark=math.random(0, 1) == 1,
        }
        if #self.strips > 18 then table.remove(self.strips, 1) end
      end
      if self.frame >= 90 then self.phase="fade"; self.frame=0 end
    elseif self.phase == "fade" then
      if self.frame >= 45 then
        self.phase="black"; self.frame=0
        if not self:closeUnderBlack() then self.phase="return" end
      end
    elseif self.phase == "black" then
      if self.frame >= 180 then
        local world = self.game and self.game.overworld
        local mapId = world and world.map and world.map.id
        if mapId then
          Music.playMap(self.game.data, mapId,
            self.game.save and self.game.save.onBike,
            world.player and world.player.surfing)
        end
        self.phase="return"; self.frame=0
      end
    elseif self.phase == "return" and self.frame >= 60 then
      if self.game.stack:top() == self then self.game.stack:pop() end
      logger:log("POKEDEX ANOMALY COMPLETE", "special=214 returnedToOverworld=true")
    end
  end

  function Controller:draw()
    if self.phase == "glitch" then
      for _, strip in ipairs(self.strips) do
        love.graphics.setColor(strip.dark and 0 or 1,
          strip.dark and 0 or 1, strip.dark and 0 or 1, 1)
        love.graphics.rectangle("fill", strip.x, strip.y, 160, strip.h)
      end
      love.graphics.setColor(1, 1, 1, 1)
      return
    end
    local alpha = 1
    if self.phase == "fade" then alpha = math.min(1, self.frame / 45)
    elseif self.phase == "return" then alpha = math.max(0, 1 - self.frame / 60) end
    drawFullDisplayBlack(self.game, alpha)
  end

  if not DexEntryMenu._g1gppAnomalyOriginalNew then
    DexEntryMenu._g1gppAnomalyOriginalNew = DexEntryMenu.new
  end
  DexEntryMenu.new = function(game, speciesOrOpts, onDone)
    local species = type(speciesOrOpts) == "table"
      and (speciesOrOpts.species or speciesOrOpts[1]) or speciesOrOpts
    local screen = DexEntryMenu._g1gppAnomalyOriginalNew(
      game, speciesOrOpts, onDone)
    if species == "TF_GLITCH_214" then
      local roll = math.random(1, 12)
      screen._g1gppAnomalyArmed = roll == 1
      screen._g1gppAnomalyStarted = false
      logger:log("POKEDEX ANOMALY ROLL",
        "special=214 roll=" .. logger:safeField(roll)
          .. " triggered=" .. logger:safeField(roll == 1))
    end
    return screen
  end

  if not DexEntryMenu._g1gppAnomalyOriginalUpdate then
    DexEntryMenu._g1gppAnomalyOriginalUpdate = DexEntryMenu.update
  end
  DexEntryMenu.update = function(screen, dt)
    if screen._g1gppAnomalyArmed and not screen._g1gppAnomalyStarted then
      screen._g1gppAnomalyViewFrames =
        (screen._g1gppAnomalyViewFrames or 0) + 1
      if screen._g1gppAnomalyViewFrames >= 30 then
        Controller.startFor(screen, screen)
        return
      end
    end
    return DexEntryMenu._g1gppAnomalyOriginalUpdate(screen, dt)
  end

  function Controller.startFor(screen, owner)
    if not (screen and screen._g1gppAnomalyArmed)
        or screen._g1gppAnomalyStarted then return false end
    screen._g1gppAnomalyStarted = true
    screen.game.stack:push(Controller.new(screen.game, screen, owner))
    logger:log("POKEDEX ANOMALY START", "special=214 chance=1/12")
    return true
  end

  return Controller
end
