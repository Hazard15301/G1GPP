local root = assert(arg[1], "repository root argument required")

local input = { left = false }
local version = { yellow = false }
local musicCalls = {}
local gameSingleton = {}

package.preload["src.render.TextBox"] = function()
  return { new = function(_game, text, done)
    return { text = text, done = done }
  end }
end
package.preload["src.core.Input"] = function()
  return { isDown = function(_, key) return input[key] == true end }
end
package.preload["src.core.GameVersion"] = function()
  return { isYellow = function() return version.yellow end }
end
package.preload["src.core.Music"] = function()
  return { playMap = function(_data, map, bike)
    musicCalls[#musicCalls + 1] = { map = map, bike = bike }
  end }
end
package.preload["src.core.Game"] = function() return gameSingleton end

local registered, events = {}, {}
local mod = {
  content = { map_scripts = {
    register = function(_, map, value) registered[map] = value end,
  } },
  events = {
    on = function(_, name, callback)
      events[name] = events[name] or {}
      events[name][#events[name] + 1] = callback
    end,
  },
}

local logs = {}
local logger = { log = function(_, message, details)
  logs[#logs + 1] = message .. " " .. tostring(details)
end }

local factory = assert(loadfile(
  root .. "/g1gpp/modules/cycling_road_no_bicycle.lua"))()
factory({ mod = mod, logger = logger })

local function equal(actual, expected, label)
  assert(actual == expected,
    (label or "value") .. ": expected " .. tostring(expected)
      .. ", got " .. tostring(actual))
end

local function newGame()
  local pushed = {}
  gameSingleton.save = { inventory = {} }
  gameSingleton.data = { text = {} }
  gameSingleton.stack = {
    push = function(_, state) pushed[#pushed + 1] = state end,
  }
  return gameSingleton, pushed
end

local function newWorld()
  local moves = {}
  local world = { player = {} }
  function world:scriptMove(_player, direction, count, done)
    moves[#moves + 1] = { direction = direction, count = count }
    if done then done() end
  end
  return world, moves
end

local function closeGuardText(pushed)
  equal(#pushed, 1, "initial guard boxes")
  pushed[1].done()
  equal(#pushed, 2, "complete guard boxes")
  pushed[2].done()
end

assert(registered.ROUTE_16_GATE_1F, "Route 16 handler was not registered")
assert(registered.ROUTE_18_GATE_1F, "Route 18 handler was not registered")
equal(#events["player.warped"], 1, "warp listener count")

-- Route 16: held LEFT reproduces the bypass, including the upward alignment
-- step from a lower trigger row, then the west exit forces riding.
do
  local game, pushed = newGame()
  local world, moves = newWorld()
  input.left = true
  equal(registered.ROUTE_16_GATE_1F.onStep(game, world, 4, 9), true,
    "Route 16 interception")
  closeGuardText(pushed)
  equal(moves[1].direction, "up", "Route 16 alignment")
  equal(moves[1].count, 2, "Route 16 alignment distance")
  equal(moves[2].direction, "left", "Route 16 bypass step")
  events["player.warped"][1]({
    fromMap = "ROUTE_16_GATE_1F", toMap = "ROUTE_16", warp = { x = 0 },
  })
  equal(game.save.onBike, true, "Route 16 bike state")
  equal(game.save.forcedBike, true, "Route 16 forced bike state")
  equal(game.save.inventory.BICYCLE, nil, "Route 16 Bicycle ownership")
  equal(musicCalls[#musicCalls].map, "ROUTE_16", "Route 16 music map")
end

-- Ordinary refusal still shoves right.
do
  local game, pushed = newGame()
  local world, moves = newWorld()
  input.left = false
  equal(registered.ROUTE_16_GATE_1F.onStep(game, world, 4, 7), true,
    "ordinary interception")
  closeGuardText(pushed)
  equal(moves[1].direction, "right", "ordinary guard shove")
  equal(game.save.onBike, nil, "ordinary refusal bike state")
end

-- Route 18 uses the same preservation behavior.
do
  local game, pushed = newGame()
  local world, moves = newWorld()
  input.left = true
  equal(registered.ROUTE_18_GATE_1F.onStep(game, world, 4, 3), true,
    "Route 18 interception")
  closeGuardText(pushed)
  equal(moves[1].direction, "left", "Route 18 bypass step")
  events["player.warped"][1]({
    fromMap = "ROUTE_18_GATE_1F", toMap = "ROUTE_18", warp = { x = 0 },
  })
  equal(game.save.onBike, true, "Route 18 bike state")
  equal(game.save.inventory.BICYCLE, nil, "Route 18 Bicycle ownership")
end

-- An east/city-side retreat consumes the volatile arm without mounting.
do
  local game, pushed = newGame()
  local world = newWorld()
  input.left = true
  registered.ROUTE_16_GATE_1F.onStep(game, world, 4, 7)
  closeGuardText(pushed)
  events["player.warped"][1]({
    fromMap = "ROUTE_16_GATE_1F", toMap = "ROUTE_16", warp = { x = 7 },
  })
  equal(game.save.onBike, nil, "east exit bike state")
  events["player.warped"][1]({
    fromMap = "ROUTE_16_GATE_1F", toMap = "ROUTE_16", warp = { x = 0 },
  })
  equal(game.save.onBike, nil, "cleared arm state")
end

-- Owning the Bicycle and playing Yellow both defer to the base handler.
do
  local game = newGame()
  local world = newWorld()
  game.save.inventory.BICYCLE = 1
  equal(registered.ROUTE_16_GATE_1F.onStep(game, world, 4, 7), false,
    "owned Bicycle deferral")
  game.save.inventory.BICYCLE = nil
  version.yellow = true
  equal(registered.ROUTE_16_GATE_1F.onStep(game, world, 4, 7), false,
    "Yellow deferral")
  version.yellow = false
end

print("PASS: Cycling Road no-Bicycle behavior")
