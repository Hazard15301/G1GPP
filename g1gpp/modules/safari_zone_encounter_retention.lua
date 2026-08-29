-- Red/Blue retained-grass encounter compatibility for the Fight Safari Zone
-- Pokemon trick. The cartridge only replaces wGrassMons when the newly
-- loaded map has a nonzero grass rate. Route 20's left-facing shore then uses
-- the current water rate but selects from that retained grass table.
--
-- Gen1Recomp keeps each map's encounters in immutable structured data, so
-- this module recreates the volatile observation without touching the engine,
-- the imported cache, or save data. Yellow corrected the shore-tile test and
-- is intentionally excluded.
return function(config)
  local mod = assert(config and config.mod,
    "Safari encounter retention requires mod")
  local logger = assert(config.logger,
    "Safari encounter retention requires logger")
  local getGame = assert(config.getGame,
    "Safari encounter retention requires game callback")
  local oldManArmed = config.isOldManArmed or function() return false end

  local GameVersion = require("src.core.GameVersion")
  local Retention = {}
  local retainedSlots = nil
  local retainedMap = nil
  local observedMap = nil
  local lastStep = nil
  local coastLogged = false
  local captureLogged = {}

  local function supported()
    local id = GameVersion.get()
    return id == "red" or id == "blue"
  end

  local function copySlots(slots)
    local out = {}
    for index, slot in ipairs(slots or {}) do
      out[index] = { species = slot.species, level = slot.level }
    end
    return out
  end

  local function grassFor(game, mapId)
    local enc = game and game.data and game.data.encounters
      and game.data.encounters[mapId] or nil
    local grass = enc and enc.grass or nil
    if grass and tonumber(grass.rate) and tonumber(grass.rate) > 0
       and type(grass.slots) == "table" and #grass.slots > 0 then
      return grass
    end
    return nil
  end

  local function retainGrass(mapId, grass, source)
    if not (grass and tonumber(grass.rate) and tonumber(grass.rate) > 0
      and type(grass.slots) == "table" and #grass.slots > 0) then
      return false
    end

    retainedSlots = copySlots(grass.slots)
    retainedMap = mapId
    if not captureLogged[mapId] then
      captureLogged[mapId] = true
      logger:log("RETAINED GRASS TABLE LOADED",
        "map=" .. logger:safeField(mapId)
          .. " rate=" .. logger:safeField(grass.rate)
          .. " slots=" .. logger:safeField(#retainedSlots)
          .. " safari=" .. logger:safeField(
            type(mapId) == "string"
              and mapId:find("SAFARI_ZONE_", 1, true) == 1)
          .. " source=" .. logger:safeField(source)
          .. " runtimeOnly=true")
    end
    return true
  end

  local function observeMap(mapId)
    if not supported() or not mapId or mapId == observedMap then return end
    observedMap = mapId
    coastLogged = false
    local grass = grassFor(getGame(), mapId)
    if not grass then return end
    retainGrass(mapId, grass, "map_observer")
  end

  local function coastStep(ev)
    if not (ev and ev.mapId == "ROUTE_20") then return false end
    local x, y = tonumber(ev.x), tonumber(ev.y)
    if not (x and y) then return false end
    -- Public Gen1Recomp crosses Cinnabar's east connection into the accepted
    -- playable Route 20 lane at x=0. The Seafoam left-shore cells retain their
    -- extracted Route 20 coordinates at x=62, y=2..9.
    return (x == 0 and y >= 0 and y <= 11)
      or (x == 62 and y >= 2 and y <= 9)
  end

  mod.events:on("world.stepped", function(ev)
    lastStep = ev
    observeMap(ev and ev.mapId)
    if supported() and retainedSlots and coastStep(ev) and not coastLogged then
      coastLogged = true
      logger:log("RETAINED GRASS COAST LANE ENTERED",
        "map=" .. logger:safeField(ev.mapId)
          .. " cell=" .. logger:safeField(ev.x) .. ","
          .. logger:safeField(ev.y)
          .. " sourceMap=" .. logger:safeField(retainedMap)
          .. " runtimeOnly=true")
    end
  end)

  mod.hooks:wrap("encounter.roll", function(next, encounterDef, context)
    -- Capture directly from the encounter definition used by the engine.
    -- This is the authoritative path and remains reliable when map data is
    -- exposed through a keyed/proxied view that cannot be indexed by map name.
    -- Never treat a water roll as grass: Route 20 deliberately places its
    -- water table in the same `grass` field passed to this hook.
    if supported() and context and context.terrain ~= "water" then
      retainGrass(context.mapId, encounterDef and encounterDef.grass,
        "encounter_roll")
    end

    if not (supported() and retainedSlots and not oldManArmed()
      and context and context.terrain == "water" and coastStep(lastStep)) then
      return next(encounterDef, context)
    end

    local current = encounterDef and encounterDef.grass or nil
    local waterRate = current and tonumber(current.rate) or 0
    if waterRate <= 0 then return next(encounterDef, context) end

    local replacement = {
      grass = { rate = waterRate, slots = copySlots(retainedSlots) },
    }
    local result = next(replacement, context)
    if result then
      logger:log("RETAINED GRASS COAST ENCOUNTER",
        "sourceMap=" .. logger:safeField(retainedMap)
          .. " map=" .. logger:safeField(context.mapId)
          .. " cell=" .. logger:safeField(lastStep and lastStep.x) .. ","
          .. logger:safeField(lastStep and lastStep.y)
          .. " species=" .. logger:safeField(result.species)
          .. " level=" .. logger:safeField(result.level)
          .. " waterRate=" .. logger:safeField(waterRate)
          .. " standardBattle=true runtimeOnly=true")
    end
    return result
  end)

  function Retention:retainedMapForTest() return retainedMap end
  function Retention:isCoastStepForTest(ev) return coastStep(ev) end

  logger:log("SAFARI RETENTION INSTALLED",
    "versions=red,blue capture=encounter_roll,map_observer runtimeOnly=true")

  return Retention
end
