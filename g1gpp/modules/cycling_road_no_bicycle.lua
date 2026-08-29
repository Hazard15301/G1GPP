-- Red/Blue Cycling Road gate input-conflict preservation.
--
-- In the original games the guard's simulated PAD_RIGHT can lose to a held
-- PAD_LEFT when the refusal closes.  That leaves the player west of the
-- counter, and the Cycling Road boundary then forces the bicycle state even
-- though no BICYCLE is owned.  Gen1Recomp's collision-safe scripted shove
-- deliberately serializes the movement, so preserve the observable result
-- here without granting the key item or persisting any extra save state.

return function(ctx)
  local mod = assert(ctx and ctx.mod, "cycling road module requires mod")
  local logger = ctx.logger
  local TextBox = require("src.render.TextBox")
  local Input = require("src.core.Input")
  local GameVersion = require("src.core.GameVersion")
  local Music = require("src.core.Music")

  local armedGate
  local armedRoute

  local function log(message, details)
    if logger and type(logger.log) == "function" then
      logger:log(message, details or "")
    end
  end

  local function clear(reason)
    if armedGate then
      log("CYCLING ROAD BYPASS CLEARED",
        "gate=" .. tostring(armedGate) .. " reason=" .. tostring(reason))
    end
    armedGate = nil
    armedRoute = nil
  end

  local function noBike(game)
    return not game.save.inventory.BICYCLE
      or game.save.inventory.BICYCLE == 0
  end

  local function inRows(rows, x, y)
    return x == 4 and rows[y] == true
  end

  local function gateHandler(spec)
    return function(game, ow, x, y)
      -- This is the documented Red/Blue behavior. Yellow remains on the
      -- recomp's ordinary guard path until separately researched.
      if GameVersion.isYellow() or not noBike(game)
          or not inRows(spec.rows, x, y) then
        return false
      end

      local distance = y - spec.closestY
      local text = game.data.text or {}

      game.stack:push(TextBox.new(game,
        text[spec.stopText] or spec.stopFallback, function()
          game.stack:push(TextBox.new(game,
            text[spec.explainText] or spec.explainFallback, function()
              local bypass = Input:isDown("left")

              local function finalStep()
                if bypass then
                  armedGate = spec.gate
                  armedRoute = spec.route
                  log("CYCLING ROAD BYPASS ARMED",
                    "gate=" .. spec.gate .. " heldLeft=true bicycleGranted=false")
                  ow:scriptMove(ow.player, "left", 1, nil, { collide = true })
                else
                  clear("ordinary_guard_shove")
                  ow:scriptMove(ow.player, "right", 1, nil, { collide = true })
                end
              end

              if distance > 0 then
                ow:scriptMove(ow.player, "up", distance, finalStep,
                  { collide = true })
              else
                finalStep()
              end
            end))
        end))
      return true
    end
  end

  local gates = {
    {
      gate = "ROUTE_16_GATE_1F",
      route = "ROUTE_16",
      rows = { [7] = true, [8] = true, [9] = true, [10] = true },
      closestY = 7,
      stopText = "_Route16Gate1FGuardWaitUpText",
      explainText = "_Route16Gate1FGuardNoPedestriansAllowedText",
      stopFallback = "Hey! Wait up!",
      explainFallback = "You need a\nBICYCLE for\nCYCLING ROAD!",
    },
    {
      gate = "ROUTE_18_GATE_1F",
      route = "ROUTE_18",
      rows = { [3] = true, [4] = true, [5] = true, [6] = true },
      closestY = 3,
      stopText = "_Route18Gate1FGuardExcuseMeText",
      explainText = "_Route18Gate1FGuardYouNeedABicycleText",
      stopFallback = "Excuse me!",
      explainFallback = "You need a\nBICYCLE for\nCYCLING ROAD!",
    },
  }

  for _, spec in ipairs(gates) do
    mod.content.map_scripts:register(spec.gate, {
      onStep = gateHandler(spec),
    })
  end

  mod.events:on("player.warped", function(ev)
    if not armedGate then return end

    -- Both gatehouses use their west edge for the Cycling Road side. A
    -- retreat through the east edge must not mount the player.
    if ev.fromMap == armedGate and ev.toMap == armedRoute
        and ev.warp and ev.warp.x == 0 then
      local Game = require("src.core.Game")
      Game.save.onBike = true
      Game.save.forcedBike = true
      Music.playMap(Game.data, ev.toMap, true)
      log("CYCLING ROAD BYPASS COMPLETED",
        "gate=" .. armedGate
          .. " route=" .. armedRoute
          .. " bicycleOwned=" .. tostring(
            (Game.save.inventory.BICYCLE or 0) > 0))
      armedGate = nil
      armedRoute = nil
      return
    end

    clear("unrelated_or_east_warp")
  end)

  mod.events:on("save.loaded", function() clear("save_loaded") end)
  mod.events:on("save.created", function() clear("save_created") end)
  mod.events:on("game.ready", function() clear("game_ready") end)

  return {
    clear = clear,
  }
end
