-- International Red/Blue Old Man glitch compatibility for public
-- Gen1Recomp. The original temporarily stores the player's 11-byte name
-- buffer over the first half of the grass encounter table. Cinnabar's coast
-- then checks the right-hand water tile but reads that grass table.
--
-- Gen1Recomp deliberately keeps names and encounters as separate Lua data,
-- so this module recreates only the observable, runtime-only behavior. It
-- never writes to the recomp installation or to G1GPP save data.
return function(config)
  local mod = assert(config and config.mod, "old man glitch requires mod")
  local logger = assert(config.logger, "old man glitch requires logger")
  local onEncounter = assert(config.onEncounter,
    "old man glitch requires encounter callback")

  local GameVersion = require("src.core.GameVersion")
  local NamingScreen = require("src.ui.NamingScreen")

  local OldMan = {}
  local armed = false
  local buffer = nil
  local sourceMode = nil
  local lastGrassSlots = nil
  local lastStep = nil
  local coastLaneLogged = false

  local buckets = { 51, 102, 141, 166, 191, 216, 229, 242, 253, 256 }

  -- Exact bytes exposed by Red/Blue's five-row naming alphabet. In
  -- particular, its visible period is the naming-screen <DOT> tile ($F2),
  -- not the prose-font period at $E8. Digits and apostrophes exist in the
  -- wider character map but cannot be entered on this naming screen, so they
  -- must not create extra Old Man outcomes.
  local glyphBytes = {
    [" "] = 0x7f, ["("] = 0x9a, [")"] = 0x9b,
    [":"] = 0x9c, [";"] = 0x9d, ["["] = 0x9e, ["]"] = 0x9f,
    ["<PK>"] = 0xe1, ["<MN>"] = 0xe2,
    ["-"] = 0xe3, ["?"] = 0xe6, ["!"] = 0xe7, ["."] = 0xf2,
    ["♂"] = 0xef, ["×"] = 0xf1, ["/"] = 0xf3,
    [","] = 0xf4, ["♀"] = 0xf5,
  }
  for i = 0, 25 do
    glyphBytes[string.char(string.byte("A") + i)] = 0x80 + i
    glyphBytes[string.char(string.byte("a") + i)] = 0xa0 + i
  end

  local function isSupportedEdition()
    local id = GameVersion.get()
    return id == "red" or id == "blue"
  end

  local function playerPresets(game)
    local boot = game and game.data and game.data.field
      and game.data.field.boot or nil
    local presets = boot and boot.namePresets and boot.namePresets.player
    if type(presets) == "table" and #presets > 0 then return presets end
    if GameVersion.isBlue() then return { "BLUE", "GARY", "JOHN" } end
    return { "RED", "ASH", "JACK" }
  end

  local function glyphs(name)
    name = tostring(name or "")
    local out, pos = {}, 1
    while pos <= #name and #out < 7 do
      local token
      if name:sub(pos, pos + 3) == "<PK>" then token = "<PK>"
      elseif name:sub(pos, pos + 3) == "<MN>" then token = "<MN>" end
      if token then
        out[#out + 1] = token
        pos = pos + #token
      else
        local byte = name:byte(pos)
        local len = byte and byte >= 0xf0 and 4
          or byte and byte >= 0xe0 and 3
          or byte and byte >= 0xc0 and 2 or 1
        out[#out + 1] = name:sub(pos, pos + len - 1)
        pos = pos + len
      end
    end
    return out
  end

  local function appendEncoded(out, name)
    for _, glyph in ipairs(glyphs(name)) do
      out[#out + 1] = glyphBytes[glyph] or 0x7f
    end
  end

  local function presetIndex(name, presets)
    for index, preset in ipairs(presets) do
      if name == preset then return index end
    end
    return nil
  end

  local function encodeName(game)
    local name = game and game.save and game.save.player
      and game.save.player.name or "RED"
    local presets = playerPresets(game)
    local selected = presetIndex(name, presets)
    local preset = sourceMode == "preset"
      or (sourceMode == nil and selected ~= nil)
    local out = {}

    if preset and selected then
      for index = selected, #presets do
        appendEncoded(out, presets[index])
        out[#out + 1] = 0x50
      end
      appendEncoded(out, "NEW NAME")
    else
      appendEncoded(out, name)
      out[#out + 1] = 0x50
      while #out < 11 do out[#out + 1] = 0 end
    end

    while #out < 11 do out[#out + 1] = 0 end
    while #out > 11 do table.remove(out) end
    return out, name, preset and "preset" or "custom"
  end

  local function copySlots(slots)
    local out = {}
    for index, slot in ipairs(slots or {}) do
      out[index] = { species = slot.species, level = slot.level }
    end
    return out
  end

  local function grassFor(game, mapId)
    local encounter = game and game.data and game.data.encounters
      and game.data.encounters[mapId] or nil
    local grass = encounter and encounter.grass or nil
    if grass and tonumber(grass.rate) and tonumber(grass.rate) > 0 then
      return grass
    end
    return nil
  end

  local function recordMapGrass(game, mapId)
    local grass = grassFor(game, mapId)
    if not grass then return false end
    lastGrassSlots = copySlots(grass.slots)
    if armed then
      armed, buffer = false, nil
      logger:log("OLD MAN BUFFER OVERWRITTEN",
        "map=" .. logger:safeField(mapId)
          .. " reason=nonzero_grass_table runtimeOnly=true")
    end
    return true
  end

  local function arm(game, trigger)
    if not isSupportedEdition() then return false end
    local name, mode
    buffer, name, mode = encodeName(game)
    armed = true
    coastLaneLogged = false
    logger:log("OLD MAN BUFFER ARMED",
      "name=" .. logger:safeField(name)
        .. " source=" .. logger:safeField(mode)
        .. " trigger=" .. logger:safeField(trigger or "tutorial")
        .. " bytes=" .. table.concat(buffer, ",")
        .. " retainedSlots=" .. logger:safeField(lastGrassSlots and #lastGrassSlots)
        .. " runtimeOnly=true")
    return true
  end

  local function coastStep(ev)
    -- Public Gen1Recomp crosses Cinnabar's east connection as soon as Surf
    -- mounts: land cell (19,y) becomes ROUTE_20 water cell (0,y). That Route
    -- 20 column is therefore the playable equivalent of the original
    -- right-half shore tiles. The coast ends at the southern sea opening.
    return ev and ev.mapId == "ROUTE_20"
      and tonumber(ev.x) == 0 and tonumber(ev.y) >= 0 and tonumber(ev.y) <= 11
  end

  local function slotForPick(pick)
    for index, threshold in ipairs(buckets) do
      if pick < threshold then return index end
    end
    return 10
  end

  local function payloadForSlot(slot)
    if slot <= 5 then
      return {
        special = buffer[slot * 2 + 1],
        level = buffer[slot * 2],
        slot = slot,
        source = "player_name",
      }
    end
    local retained = lastGrassSlots and lastGrassSlots[slot]
    if retained then
      return {
        species = retained.species,
        level = retained.level,
        slot = slot,
        source = "retained_grass",
      }
    end
    return nil
  end

  function OldMan:openNameMenu(game)
    if not (game and game.stack and game.save and game.save.player) then
      return false
    end
    local presets = playerPresets(game)
    game.stack:push(NamingScreen.new(game, {
      title = "YOUR NAME?",
      presets = presets,
      maxLen = 7,
      default = game.save.player.name,
      onDone = function(name, custom)
        game.save.player.name = name
        sourceMode = custom and "custom" or "preset"
        armed, buffer = false, nil
        logger:log("DEBUG PLAYER NAME CHANGED",
          "name=" .. logger:safeField(name)
            .. " source=" .. logger:safeField(sourceMode)
            .. " oldManBufferCleared=true saveUsesNextNormalSave=true")
      end,
    }))
    return true
  end

  function OldMan:decorateDebugRow(row, manager)
    row.step = nil
    row.value = function()
      local player = manager.game and manager.game.save
        and manager.game.save.player or nil
      return player and player.name or "NAME"
    end
    row.activate = function() self:openNameMenu(manager.game) end
  end

  function OldMan:armCurrentName(game)
    return arm(game, "debug")
  end

  function OldMan:decorateArmDebugRow(row, manager)
    row.step = nil
    row.value = function() return armed and "ARMED" or "ARM" end
    row.activate = function() self:armCurrentName(manager.game) end
  end

  function OldMan:isArmed() return armed end
  function OldMan:encodeForTest(game) return encodeName(game) end
  function OldMan:setSourceModeForTest(mode) sourceMode = mode end

  mod.events:on("world.stepped", function(ev)
    lastStep = ev
    local game = config.getGame and config.getGame() or nil
    if game then recordMapGrass(game, ev and ev.mapId) end
    if armed and coastStep(ev) and not coastLaneLogged then
      coastLaneLogged = true
      logger:log("OLD MAN COAST LANE ENTERED",
        "map=" .. logger:safeField(ev.mapId)
          .. " cell=" .. logger:safeField(ev.x) .. ","
          .. logger:safeField(ev.y)
          .. " armed=true runtimeOnly=true")
    end
  end)

  mod.events:on("battle.ended", function(ev)
    local battle = ev and ev.battle
    if not (battle and battle.battleKind) then return end
    local ok, kind = pcall(battle.battleKind, battle)
    if ok and kind == "oldman" then
      local game = config.getGame and config.getGame() or nil
      if game then arm(game, "tutorial") end
    end
  end)

  mod.hooks:wrap("encounter.roll", function(next, encounterDef, context)
    if not (armed and buffer and isSupportedEdition()
      and context and context.terrain == "water" and coastStep(lastStep)) then
      return next(encounterDef, context)
    end

    local rng = context.rng or love.math.random
    if rng(0, 255) >= buffer[1] then return nil end
    local slot = slotForPick(rng(0, 255))
    local payload = payloadForSlot(slot)
    if not payload then return nil end
    payload.mapId = context.mapId
    onEncounter(payload)
    logger:log("OLD MAN COAST ENCOUNTER",
      "slot=" .. logger:safeField(slot)
        .. " level=" .. logger:safeField(payload.level)
        .. " special=" .. logger:safeField(payload.special)
        .. " species=" .. logger:safeField(payload.species)
        .. " source=" .. logger:safeField(payload.source)
        .. " nameRate=" .. logger:safeField(buffer[1]))
    return nil
  end)

  return OldMan
end
