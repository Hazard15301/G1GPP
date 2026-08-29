local root = assert(arg[1], "repository root argument required")

package.preload["src.core.GameVersion"] = function()
  return { get = function() return "blue" end }
end
package.preload["src.render.TextBox"] = function()
  return { new = function(_, text, callback)
    return { kind = "text", text = text, callback = callback }
  end }
end
package.preload["src.ui.ChoiceBox"] = function()
  return { new = function(_, callback)
    return { kind = "choice", callback = callback }
  end }
end
package.preload["src.world.Map"] = function()
  return { isOutside = function(def)
    return def and (def.tileset == "OVERWORLD" or def.tileset == "PLATEAU")
  end }
end
package.preload["src.world.FieldDefaults"] = function()
  return { field = function(_, key)
    assert(key == "outsideTilesets")
    return { "OVERWORLD", "PLATEAU" }
  end }
end
package.preload["src.render.Font"] = function()
  return { draw = function() end }
end

local events, warpHook, hudHook, commands, scripts = {}, nil, nil, {}, {}
local saveData = {}
local hudEnabled = false
local mod = {
  save = {
    get = function(_, key) return saveData[key] end,
    set = function(_, key, value) saveData[key] = value end,
  },
  events = { on = function(_, name, callback) events[name] = callback end },
  hooks = { wrap = function(_, name, callback)
    if name == "warp.destination" then warpHook = callback
    elseif name == "render.hud" then hudHook = callback
    else error("unexpected hook " .. tostring(name)) end
  end },
  options = { get = function() return hudEnabled end },
  content = {
    commands = { register = function(_, key, value) commands[key] = value end },
    map_scripts = { register = function(_, key, value) scripts[key] = value end },
  },
}
local logs = {}
local logger = {
  safeField = function(_, value) return tostring(value) end,
  log = function(_, name, details)
    logs[#logs + 1] = name .. " " .. tostring(details)
  end,
}

local pushed = {}
local world = {
  isOverworld = true,
  player = { cellX = 3, cellY = 1 },
  map = { id = "SAFARI_ZONE_GATE" },
  -- Deliberately stale, as it normally is while walking on another route.
  lastOutdoor = { id = "FUCHSIA_CITY" },
  transitioning = false,
  runner = { isRunning = function() return false end },
  queueScript = function(self, value) self.queued = value end,
  scriptMove = function(_, _, _, _, callback) if callback then callback() end end,
  startWarpTo = function(self, map, x, y, facing, callback)
    self.warped = { map = map, x = x, y = y, facing = facing }
    if callback then callback() end
  end,
}
local stackTop = world
local game = {
  save = { safari = { balls = 25, steps = 3 } },
  data = {
    text = {},
    maps = {
      SAFARI_ZONE_CENTER = { warps = {
        { x = 3, y = 30 }, { x = 4, y = 30 },
      } },
      ROUTE_1 = { tileset = "OVERWORLD", warps = { {}, {}, {} } },
      ROUTE_2 = { tileset = "OVERWORLD",
        warps = { {}, {}, {}, {}, { x = 1, y = 1 } } },
    },
  },
  stack = {
    states = { world },
    push = function(_, value) pushed[#pushed + 1] = value end,
    top = function() return stackTop end,
  },
}

local controller = assert(loadfile(root
  .. "/g1gpp/modules/safari_zone_glitch_city.lua"))()({
    mod = mod,
    logger = logger,
    getGame = function() return game end,
    getWorld = function() return world end,
  })

assert(commands["g1gpp:safari_glitch_gate_prompt"],
  "custom gate command must register")
assert(scripts.SAFARI_ZONE_GATE and scripts.SAFARI_ZONE_GATE.priority == 500,
  "high-priority gate script must register")
assert(type(warpHook) == "function", "LAST_MAP hook must register")
assert(type(hudHook) == "function", "Safari debug HUD hook must register")

-- First refusal arms only the mod's normal save namespace. It is not enough
-- to leave the zone until that state has actually been reloaded.
controller:onGateEnter(game, world)
assert(controller.promptMode == "ordinary")
assert(game.save.safari == nil, "base gate handler must be suppressed")
controller:declineFirstExit(game, world)
local key = controller:saveKeyForTest()
assert(saveData[key].stage == "primed" and saveData[key].steps == 3)

-- A genuine reload reverses the gate question, matching the cartridge setup.
game.save.safari = { balls = 25, steps = 3 }
events["save.loaded"]()
controller:onGateEnter(game, world)
assert(controller.promptMode == "after_reload")
controller:escapeOutside(game, world)
assert(saveData[key].stage == "outside")
assert(game.save.safari == nil)
assert(controller:remainingSteps(game) == 3)

-- The public HUD hook is global. Returning to the title retains the live
-- in-memory save until CONTINUE replaces it, but must not paint the counter
-- over the title/main menu.
hudEnabled = true
local title = { screenId = "TitleState" }
stackTop = title
game.stack.states = { title }
hudHook(function() end, game, { gameWidth = 160, gameHeight = 144 })
stackTop = world
game.stack.states = { world }
hudEnabled = false

-- The Safari counter continues on the destination map. Route 1 has no fifth
-- warp, so expiration must arm the PA recall and mark it glitch-eligible.
world.map = { id = "ROUTE_1" }
for i = 1, 3 do
  events["world.stepped"]({ mapId = "ROUTE_1", x = 7 + i, y = 9 })
end
assert(saveData[key].stage == "recall_pending")
assert(saveData[key].glitchEligible == true)
assert(saveData[key].hasWarp5 == false)
assert(controller:remainingSteps(game) == 0)

local action = controller:poll(game, world)
assert(action == "recall" and saveData[key].stage == "recalled")
assert(pushed[#pushed].kind == "text")
pushed[#pushed].callback()
assert(world.warped.map == "SAFARI_ZONE_GATE")

-- The missing fifth warp returns to the captured source cell, then activates
-- G1GPP's existing bounded Glitch City only after that map is safely live.
local downstreamCalled = false
local map, x, y = warpHook(function(...)
  downstreamCalled = true
  return ...
end, "LAST_MAP", 99, 99, { warp = { destMap = "LAST_MAP" } })
assert(not downstreamCalled)
assert(map == "ROUTE_1" and x == 10 and y == 9)
world.map = { id = "ROUTE_1" }
local activate, payload = controller:poll(game, world)
assert(activate == "activate" and payload.sourceMap == "ROUTE_1")
assert(saveData[key] == nil, "setup record must be consumed at handoff")

-- A map with a real fifth warp resolves normally and never enters Glitch City.
saveData[key] = {
  format = 1, stage = "recalled", sourceMap = "ROUTE_2",
  sourceX = 4, sourceY = 5, glitchEligible = false, hasWarp5 = true,
}
downstreamCalled = false
map, x, y = warpHook(function(destMap, dx, dy)
  downstreamCalled = true
  return destMap, dx, dy
end, "ROUTE_2", 1, 1, { warp = { destMap = "LAST_MAP" } })
assert(downstreamCalled and map == "ROUTE_2" and x == 1 and y == 1)
assert(saveData[key] == nil)

-- A private-build Safari setup stored in the old save namespace migrates on
-- load and remains armed under the canonical g1gpp identity.
game.save.modData = { trainer_fly = { [key] = {
  format = 1, stage = "primed", steps = 17,
} } }
events["save.loaded"]()
assert(saveData[key].stage == "primed" and saveData[key].steps == 17)
assert(controller.reloadedPrimed)

print("PASS: authentic Safari save/reset Glitch City trigger")
