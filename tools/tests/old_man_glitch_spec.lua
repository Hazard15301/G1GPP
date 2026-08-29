local root = assert(arg[1], "repository root argument required")

local version = "blue"
package.preload["src.core.GameVersion"] = function()
  return {
    get = function() return version end,
    isBlue = function() return version == "blue" end,
  }
end
package.preload["src.ui.NamingScreen"] = function()
  return { new = function(_game, opts) return { opts = opts } end }
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

local grassSlots = {}
for index = 1, 10 do
  grassSlots[index] = { species = "MON_" .. index, level = index + 4 }
end
local game = {
  save = { player = { name = "BLUE" } },
  data = {
    field = { boot = { namePresets = {
      player = { "BLUE", "GARY", "JOHN" },
    } } },
    encounters = {
      ROUTE_1 = { grass = { rate = 25, slots = grassSlots } },
      CINNABAR_ISLAND = { grass = { rate = 0, slots = {} } },
      ROUTE_20 = { grass = { rate = 0, slots = {} } },
    },
  },
  stack = { push = function() end },
}
local encountered = {}
local factory = assert(loadfile(
  root .. "/g1gpp/modules/old_man_glitch.lua"))()
local controller = factory({
  mod = mod,
  logger = logger,
  getGame = function() return game end,
  onEncounter = function(payload) encountered[#encountered + 1] = payload end,
})

local function equal(actual, expected, label)
  assert(actual == expected,
    (label or "value") .. ": expected " .. tostring(expected)
      .. ", got " .. tostring(actual))
end

local function emit(name, payload)
  for _, callback in ipairs(events[name] or {}) do callback(payload) end
end

-- Selecting BLUE uses the contiguous preset-name ROM sequence, not custom
-- terminator padding: BLUE@GARY@G...
do
  local bytes, name, mode = controller:encodeForTest(game)
  equal(name, "BLUE", "preset name")
  equal(mode, "preset", "preset source")
  local expected = { 129, 139, 148, 132, 80, 134, 128, 145, 152, 80, 137 }
  for index = 1, 11 do
    equal(bytes[index], expected[index], "preset byte " .. index)
  end
end

-- Every symbol on Gen1Recomp's Red/Blue naming grid must use the original
-- naming alphabet byte. The visible period is <DOT> ($F2), not the ordinary
-- prose period ($E8). Characters absent from that grid cannot introduce
-- extra encounter ids.
do
  controller:setSourceModeForTest("custom")
  local expected = {
    [" "] = 127, ["("] = 154, [")"] = 155,
    [":"] = 156, [";"] = 157, ["["] = 158, ["]"] = 159,
    ["<PK>"] = 225, ["<MN>"] = 226, ["-"] = 227,
    ["?"] = 230, ["!"] = 231, ["♂"] = 239, ["×"] = 241,
    ["."] = 242, ["/"] = 243, [","] = 244, ["♀"] = 245,
  }
  for glyph, byte in pairs(expected) do
    game.save.player.name = glyph
    local bytes = controller:encodeForTest(game)
    equal(bytes[1], byte, "naming byte for " .. glyph)
  end
  game.save.player.name = "0"
  local bytes = controller:encodeForTest(game)
  equal(bytes[1], 127, "non-grid digit cannot create an encounter id")
  game.save.player.name = "BLUE"
  controller:setSourceModeForTest("preset")
end

-- Manually typing the same visible name gets the authentic custom padding.
do
  controller:setSourceModeForTest("custom")
  local bytes, _, mode = controller:encodeForTest(game)
  equal(mode, "custom", "custom source")
  local expected = { 129, 139, 148, 132, 80, 0, 0, 0, 0, 0, 0 }
  for index = 1, 11 do
    equal(bytes[index], expected[index], "custom byte " .. index)
  end
  equal(controller:armCurrentName(game), true,
    "debug action arms current custom name")
  equal(controller:isArmed(), true, "debug action leaves buffer armed")
  assert(logs[#logs]:find("source=custom", 1, true),
    "debug arm log preserves custom-name source")
  assert(logs[#logs]:find("trigger=debug", 1, true),
    "debug arm log identifies debug trigger")
  emit("world.stepped", { mapId = "ROUTE_1", x = 0, y = 0, tile = 0x52 })
  equal(controller:isArmed(), false, "real grass clears debug-armed buffer")
  controller:setSourceModeForTest("preset")
end

-- Capture the previously loaded grass table, then the tutorial battle arms
-- the name buffer. Surfing east crosses immediately from Cinnabar (19,y) to
-- the recomp's playable adjacent lane at ROUTE_20 (0,y).
emit("world.stepped", { mapId = "ROUTE_1", x = 0, y = 0, tile = 0x52 })
emit("battle.ended", { battle = {
  battleKind = function() return "oldman" end,
} })
equal(controller:isArmed(), true, "tutorial arms buffer")

-- The obsolete assumed Cinnabar x=3 lane must fall through to vanilla.
emit("world.stepped", { mapId = "CINNABAR_ISLAND", x = 3, y = 5, tile = 0x14 })
do
  local vanilla = {}
  local result = encounterHook(function() return vanilla end,
    {}, { mapId = "CINNABAR_ISLAND", terrain = "water" })
  equal(result, vanilla, "non-coast water uses vanilla encounter")
  equal(#encountered, 0, "non-coast water does not use name buffer")
end

emit("world.stepped", { mapId = "ROUTE_20", x = 0, y = 5, tile = 0x14 })

do
  local rolls = { 0, 0 }
  local call = 0
  local result = encounterHook(function() error("vanilla roll should be suppressed") end,
    { grass = { rate = 0 } }, {
      mapId = "ROUTE_20", terrain = "water",
      rng = function()
        call = call + 1
        return rolls[call]
      end,
    })
  equal(result, nil, "coast hook result")
  equal(#encountered, 1, "name encounter callback")
  equal(encountered[1].level, 139, "BLUE slot-one level")
  equal(encountered[1].special, 148, "BLUE slot-one species index")
  equal(encountered[1].source, "player_name", "name encounter source")
end

-- Slots beyond the five overwritten pairs retain the prior grass table.
do
  local rolls = { 0, 191 }
  local call = 0
  encounterHook(function() error("vanilla roll should be suppressed") end,
    {}, { mapId = "ROUTE_20", terrain = "water",
      rng = function() call = call + 1 return rolls[call] end })
  equal(#encountered, 2, "retained encounter callback")
  equal(encountered[2].species, "MON_6", "retained slot species")
  equal(encountered[2].level, 10, "retained slot level")
end

-- Entering a map with real grass overwrites and clears the volatile buffer.
emit("world.stepped", { mapId = "ROUTE_1", x = 0, y = 0, tile = 0x52 })
equal(controller:isArmed(), false, "grass overwrite disarms buffer")

-- Yellow never arms the Red/Blue glitch.
version = "yellow"
equal(controller:armCurrentName(game), false, "Yellow debug-arm exclusion")
emit("battle.ended", { battle = {
  battleKind = function() return "oldman" end,
} })
equal(controller:isArmed(), false, "Yellow exclusion")

-- Red/Blue compares the encounter byte with opponent offset 200. Therefore
-- name bytes 200+ must use the same trainer-opponent split as the ROM; only
-- the development-only direct Pokemon tester bypasses upper-trainer decoding.
do
  local file = assert(io.open(root .. "/g1gpp/main.lua", "rb"))
  local source = file:read("*a")
  file:close()
  assert(not source:find("or finishedEscape.oldManEncounter", 1, true),
    "Old Man name bytes must not bypass upper-trainer decoding")
  assert(source:find("finishedEscape.debugPokemonTest", 1, true),
    "direct Pokemon tester remains the only upper-trainer bypass")
end

print("PASS: Old Man glitch name buffer and Cinnabar coast")
