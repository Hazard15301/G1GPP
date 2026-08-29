local root = assert(arg[1], "repository root argument required")

local version = "blue"
package.preload["src.core.GameVersion"] = function()
  return { get = function() return version end }
end

local events, encounterHook = {}, nil
local mod = {
  events = { on = function(_, name, callback)
    events[name] = events[name] or {}
    events[name][#events[name] + 1] = callback
  end },
  hooks = { wrap = function(_, name, callback)
    assert(name == "encounter.roll")
    encounterHook = callback
  end },
}
local logs = {}
local logger = {
  safeField = function(_, value) return tostring(value) end,
  log = function(_, name, details)
    logs[#logs + 1] = name .. " " .. tostring(details)
  end,
}

local safari, route = {}, {}
for index = 1, 10 do
  safari[index] = { species = "SAFARI_" .. index, level = 20 + index }
  route[index] = { species = "ROUTE_" .. index, level = index + 2 }
end
local game = { data = { encounters = {
  SAFARI_ZONE_CENTER = { grass = { rate = 30, slots = safari } },
  ROUTE_1 = { grass = { rate = 25, slots = route } },
  SAFARI_ZONE_GATE = {}, FUCHSIA_CITY = {}, CINNABAR_ISLAND = {},
  ROUTE_20 = { water = { rate = 5, slots = {} } },
} } }
local oldMan = false
local factory = assert(loadfile(root
  .. "/g1gpp/modules/safari_zone_encounter_retention.lua"))()
local controller = factory({
  mod = mod,
  logger = logger,
  getGame = function() return game end,
  isOldManArmed = function() return oldMan end,
})

local function equal(actual, expected, label)
  assert(actual == expected,
    (label or "value") .. ": expected " .. tostring(expected)
      .. ", got " .. tostring(actual))
end

local function emit(name, payload)
  for _, callback in ipairs(events[name] or {}) do callback(payload) end
end

local function rollAt(step, expectedSlots)
  emit("world.stepped", step)
  local received
  local result = encounterHook(function(def)
    received = def
    return def.grass.slots[1]
  end, { grass = { rate = 5, slots = {} } },
    { mapId = "ROUTE_20", terrain = "water" })
  equal(received.grass.rate, 5, "Route 20 water rate is retained")
  equal(received.grass.slots[1].species, expectedSlots[1].species,
    "retained grass species")
  equal(result.species, expectedSlots[1].species, "rolled species")
end

-- Live builds may expose encounter data through a keyed view that cannot be
-- indexed by the string map name. Capturing the exact table supplied to the
-- encounter hook must therefore work without a preceding world-step lookup.
game.data.encounters.SAFARI_ZONE_CENTER = nil
encounterHook(function() return nil end,
  { grass = { rate = 30, slots = safari } },
  { mapId = "SAFARI_ZONE_CENTER", terrain = "grass" })
equal(controller:retainedMapForTest(), "SAFARI_ZONE_CENTER",
  "Safari table captured from encounter hook")
game.data.encounters.SAFARI_ZONE_CENTER = {
  grass = { rate = 30, slots = safari },
}

-- Entering Safari Center loads its complete table. Gate, city, Fly, and
-- Cinnabar have no grass, so they leave it untouched.
emit("world.stepped", { mapId = "SAFARI_ZONE_CENTER", x = 15, y = 25 })
equal(controller:retainedMapForTest(), "SAFARI_ZONE_CENTER",
  "Safari table loaded")
emit("world.stepped", { mapId = "SAFARI_ZONE_GATE", x = 4, y = 2 })
emit("world.stepped", { mapId = "FUCHSIA_CITY", x = 18, y = 4 })
emit("world.stepped", { mapId = "CINNABAR_ISLAND", x = 19, y = 5 })
rollAt({ mapId = "ROUTE_20", x = 0, y = 5 }, safari)

-- Seafoam's extracted left-facing shore is part of the same glitch family.
rollAt({ mapId = "ROUTE_20", x = 62, y = 5 }, safari)
equal(controller:isCoastStepForTest(
  { mapId = "ROUTE_20", x = 61, y = 5 }), false,
  "Seafoam non-shore water excluded")

-- Visiting any other map with real grass authentically replaces Safari.
emit("world.stepped", { mapId = "ROUTE_1", x = 4, y = 4 })
equal(controller:retainedMapForTest(), "ROUTE_1", "later grass overwrite")
rollAt({ mapId = "ROUTE_20", x = 0, y = 5 }, route)

-- The Old Man name buffer has priority over the previously retained list.
oldMan = true
emit("world.stepped", { mapId = "ROUTE_20", x = 0, y = 5 })
do
  local vanilla = {}
  local passed
  local result = encounterHook(function(def) passed = def return vanilla end,
    { grass = { rate = 5, slots = {} } },
    { mapId = "ROUTE_20", terrain = "water" })
  equal(result, vanilla, "Old Man path delegated")
  equal(#passed.grass.slots, 0, "Old Man path not replaced")
end
oldMan = false

-- Yellow fixed the left-shore test and never receives retained encounters.
version = "yellow"
do
  local vanilla = {}
  local result = encounterHook(function() return vanilla end,
    { grass = { rate = 5, slots = {} } },
    { mapId = "ROUTE_20", terrain = "water" })
  equal(result, vanilla, "Yellow exclusion")
end

print("PASS: Red/Blue retained Safari/grass tables on Route 20 shores")
