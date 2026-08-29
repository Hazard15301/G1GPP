-- Safe recreation of the Safari Zone escape / Glitch City setup.
--
-- The cartridge bug requires a genuine SAVE + reload between declining the
-- first "Leaving early?" prompt and returning to the gate.  The only durable
-- value used here lives in this mod's save.modData namespace, so uninstalling
-- G1GPP leaves the base game, maps, flags and Safari implementation untouched.
-- Once outside, the original Safari counter is represented by this record and
-- decremented on ordinary completed player steps.  At zero the PA returns the
-- player to the gate.  Its LAST_MAP exit naturally resolves warp 5 where one
-- exists; maps without that fifth entry hand off to G1GPP's existing, bounded
-- Glitch City runtime on the source map.
return function(config)
  local mod = assert(config and config.mod,
    "Safari Glitch City requires mod")
  local logger = assert(config.logger,
    "Safari Glitch City requires logger")
  local getGame = assert(config.getGame,
    "Safari Glitch City requires game callback")
  local getWorld = assert(config.getWorld,
    "Safari Glitch City requires overworld callback")

  local GameVersion = require("src.core.GameVersion")
  local TextBox = require("src.render.TextBox")
  local ChoiceBox = require("src.ui.ChoiceBox")
  local Map = require("src.world.Map")
  local FieldDefaults = require("src.world.FieldDefaults")
  local Font = require("src.render.Font")
  local Controller = {}
  Controller.__index = Controller

  local SAVE_KEY = "safari_zone_glitch_city"
  local FORMAT = 1
  local COMMAND = "g1gpp:safari_glitch_gate_prompt"

  local function supported()
    local id = GameVersion.get()
    return id == "red" or id == "blue" or id == "yellow"
  end

  local function copySafari(value)
    if type(value) ~= "table" then return nil end
    return {
      balls = math.max(0, math.floor(tonumber(value.balls) or 0)),
      steps = math.max(0, math.floor(tonumber(value.steps) or 0)),
    }
  end

  local function validRecord(value)
    return type(value) == "table" and value.format == FORMAT
      and (value.stage == "primed" or value.stage == "outside"
        or value.stage == "recall_pending" or value.stage == "recalled"
        or value.stage == "returning")
  end

  function Controller.new()
    return setmetatable({
      reloadedPrimed = false,
      promptQueued = false,
      promptMode = nil,
      heldSafari = nil,
      heldRightSide = false,
      recallPending = false,
      activationPending = nil,
    }, Controller)
  end

  function Controller:record()
    local value = mod.save:get(SAVE_KEY)
    return validRecord(value) and value or nil
  end

  function Controller:remainingSteps(game)
    local safari = game and game.save and copySafari(game.save.safari)
    if safari then return safari.steps end
    local record = self:record()
    if record and (record.stage == "outside"
        or record.stage == "recall_pending") then
      return math.max(0, math.floor(tonumber(record.steps) or 0))
    end
    return nil
  end

  function Controller:write(value, reason)
    mod.save:set(SAVE_KEY, value)
    logger:log("SAFARI GLITCH STATE",
      "reason=" .. logger:safeField(reason)
        .. " stage=" .. logger:safeField(value and value.stage)
        .. " steps=" .. logger:safeField(value and value.steps)
        .. " sourceMap=" .. logger:safeField(value and value.sourceMap)
        .. " saveNamespaceOnly=true")
  end

  function Controller:resetRuntime(reason)
    self.reloadedPrimed = false
    self.promptQueued = false
    self.promptMode = nil
    self.heldSafari = nil
    self.heldRightSide = false
    self.recallPending = false
    self.activationPending = nil
    logger:log("SAFARI GLITCH RUNTIME RESET",
      "reason=" .. logger:safeField(reason) .. " persistedStateUntouched=true")
  end

  function Controller:onSaveLoaded()
    self:resetRuntime("save_loaded")
    local record = self:record()
    if not record then
      local game = getGame()
      local legacy = game and game.save and game.save.modData
        and game.save.modData.trainer_fly
      legacy = legacy and legacy[SAVE_KEY]
      if validRecord(legacy) then
        self:write(legacy, "migrated_trainer_fly_namespace")
        record = legacy
      end
    end
    if not record then return end
    if record.stage == "primed" then
      self.reloadedPrimed = true
      logger:log("SAFARI GLITCH RELOAD RECOGNIZED",
        "stage=primed authenticSaveReload=true")
    elseif record.stage == "outside" then
      logger:log("SAFARI GLITCH OUTSIDE RESUMED",
        "steps=" .. logger:safeField(record.steps)
          .. " normalSaveRequired=true")
    elseif record.stage == "recall_pending" then
      self.recallPending = true
    end
  end

  function Controller:finishPrompt(done)
    self.promptQueued = false
    self.promptMode = nil
    self.heldSafari = nil
    self.heldRightSide = false
    if done then done() end
  end

  function Controller:returnToSafari(game, world, done)
    game.save.safari = copySafari(self.heldSafari)
    local map = game.data and game.data.maps
      and game.data.maps.SAFARI_ZONE_CENTER
    local dest = map and map.warps
      and map.warps[self.heldRightSide and 2 or 1]
    if not dest then
      self:finishPrompt(done)
      return
    end
    local controller = self
    world:startWarpTo("SAFARI_ZONE_CENTER", dest.x, dest.y, "up", function()
      controller:finishPrompt(done)
    end)
  end

  function Controller:leaveNormally(game, world, done)
    game.save.safari = nil
    self:write(nil, "ordinary_early_exit")
    local t = game.data.text or {}
    local controller = self
    game.stack:push(TextBox.new(game,
      t._SafariZoneGateSafariZoneWorker1ReturnSafariBallsText
        or "Please return any\nSAFARI BALLs.", function()
        game.stack:push(TextBox.new(game,
          t._SafariZoneGateSafariZoneWorker1GoodHaulComeAgainText
            or "Good haul! Come\nagain!", function()
            world:scriptMove(world.player, "down", 3, function()
              controller:finishPrompt(done)
            end, { collide = true })
          end))
      end))
  end

  function Controller:declineFirstExit(game, world, done)
    local safari = copySafari(self.heldSafari) or { balls = 30, steps = 500 }
    self:write({
      format = FORMAT,
      stage = "primed",
      steps = safari.steps,
      balls = safari.balls,
    }, "first_exit_declined_awaiting_save_reload")
    local t = game.data.text or {}
    local controller = self
    game.stack:push(TextBox.new(game,
      t._SafariZoneGateSafariZoneWorker1GoodLuckText or "Good Luck!",
      function() controller:returnToSafari(game, world, done) end))
  end

  function Controller:escapeOutside(game, world, done)
    local safari = copySafari(self.heldSafari) or { balls = 30, steps = 500 }
    game.save.safari = nil
    self:write({
      format = FORMAT,
      stage = "outside",
      steps = safari.steps,
      balls = safari.balls,
    }, "reloaded_join_prompt_declined")
    local t = game.data.text or {}
    local controller = self
    game.stack:push(TextBox.new(game,
      t._SafariZoneGateSafariZoneWorker1PleaseComeAgainText
        or "OK! Please come\nagain!", function()
        world:scriptMove(world.player, "down", 3, function()
          controller:finishPrompt(done)
        end, { collide = true })
      end))
  end

  function Controller:openPrompt(game, world, done)
    if self.promptMode == "after_reload" then
      local t = game.data.text or {}
      local controller = self
      game.stack:push(TextBox.new(game,
        t._SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText
          or "For just ¥500 you\ncan join the hunt!\fWould you like to\njoin the hunt?",
        function()
          game.stack:push(ChoiceBox.new(game, function(yes)
            if yes then
              -- Saying YES simply continues the already-paid Safari game.
              -- The saved setup remains armed, so returning and saying NO
              -- still follows the documented route.
              game.stack:push(TextBox.new(game,
                t._SafariZoneGateSafariZoneWorker1GoodLuckText or "Good Luck!",
                function() controller:returnToSafari(game, world, done) end))
            else
              controller:escapeOutside(game, world, done)
            end
          end))
        end))
      return
    end

    local t = game.data.text or {}
    local controller = self
    game.stack:push(TextBox.new(game,
      t._SafariZoneGateSafariZoneWorker1LeavingEarlyText
        or "Leaving early?", function()
        game.stack:push(ChoiceBox.new(game, function(yes)
          if yes then
            controller:leaveNormally(game, world, done)
          else
            controller:declineFirstExit(game, world, done)
          end
        end))
      end))
  end

  function Controller:onGateEnter(game, world)
    if not supported() or self.promptQueued
        or not (game and game.save and game.save.safari)
        or not (world and world.player and world.player.cellY <= 1) then
      return
    end

    self.heldSafari = copySafari(game.save.safari)
    self.heldRightSide = world.player.cellX ~= 3
    self.promptMode = self.reloadedPrimed and self:record()
      and "after_reload" or "ordinary"
    self.promptQueued = true

    -- Suppress the lower-priority base onEnter handler. Our queued command
    -- reproduces that same prompt after the warp transition has finished.
    game.save.safari = nil
    world:queueScript({ { COMMAND } })
    logger:log("SAFARI GLITCH GATE PROMPT QUEUED",
      "mode=" .. logger:safeField(self.promptMode)
        .. " steps=" .. logger:safeField(self.heldSafari and self.heldSafari.steps)
        .. " side=" .. logger:safeField(self.heldRightSide and "right" or "left"))
  end

  function Controller:onStep(ev)
    if not supported() then return end
    local record = self:record()
    if not record or record.stage ~= "outside" then return end
    record.steps = math.max(0, math.floor(tonumber(record.steps) or 0) - 1)
    if record.steps > 0 then
      mod.save:set(SAVE_KEY, record)
      if record.steps % 100 == 0 or record.steps <= 5 then
        logger:log("SAFARI GLITCH OUTSIDE STEP",
          "remaining=" .. logger:safeField(record.steps)
            .. " map=" .. logger:safeField(ev and ev.mapId))
      end
      return
    end

    local game, world = getGame(), getWorld()
    local mapId = ev and ev.mapId
    local source = game and game.data and game.data.maps
      and game.data.maps[mapId]
    local outdoors = source and Map.isOutside(source,
      FieldDefaults.field(game.data, "outsideTilesets"))
    local hasWarp5 = source and type(source.warps) == "table"
      and source.warps[5] ~= nil
    record.stage = "recall_pending"
    record.steps = 0
    record.sourceMap = mapId
    record.sourceX = ev and ev.x
    record.sourceY = ev and ev.y
    record.outdoors = outdoors == true
    record.hasWarp5 = hasWarp5 == true
    record.glitchEligible = outdoors == true and not hasWarp5
    self:write(record, "outside_counter_expired")
    self.recallPending = true
    logger:log("SAFARI GLITCH PA ARMED",
      "map=" .. logger:safeField(mapId)
        .. " cell=" .. logger:safeField(record.sourceX) .. ","
        .. logger:safeField(record.sourceY)
        .. " outdoors=" .. logger:safeField(record.outdoors)
        .. " hasWarp5=" .. logger:safeField(record.hasWarp5)
        .. " glitchEligible=" .. logger:safeField(record.glitchEligible))
  end

  function Controller:poll(game, world)
    if self.recallPending and game and world
        and game.stack:top() == world and not world.transitioning
        and world.runner and not world.runner:isRunning() then
      self.recallPending = false
      local record = self:record()
      if not record or record.stage ~= "recall_pending" then return nil end
      record.stage = "recalled"
      self:write(record, "pa_message_opened")
      local controller = self
      local t = game.data.text or {}
      game.stack:push(TextBox.new(game,
        t._TimesUpText or "PA: Ding-dong!\nTime's up!", function()
          world:startWarpTo("SAFARI_ZONE_GATE", 4, 3, "down")
          logger:log("SAFARI GLITCH PA RECALL",
            "sourceMap=" .. logger:safeField(record.sourceMap)
              .. " glitchEligible=" .. logger:safeField(record.glitchEligible))
        end))
      return "recall"
    end

    local pending = self.activationPending
    if pending and game and world and game.stack:top() == world
        and not world.transitioning and world.runner
        and not world.runner:isRunning()
        and world.map and world.map.id == pending.sourceMap then
      self.activationPending = nil
      self:write(nil, "glitch_city_handoff_consumed")
      return "activate", pending
    end
    return nil
  end

  function Controller:routeGateWarp(next, destMap, x, y, context)
    local record = self:record()
    local warp = context and context.warp
    if not (supported() and record and record.stage == "recalled"
      and warp and warp.destMap == "LAST_MAP") then
      return next(destMap, x, y, context)
    end

    if record.glitchEligible then
      record.stage = "returning"
      self:write(record, "invalid_warp5_glitch_return")
      self.activationPending = {
        sourceMap = record.sourceMap,
        sourceX = tonumber(record.sourceX) or x,
        sourceY = tonumber(record.sourceY) or y,
        hasWarp5 = false,
      }
      logger:log("SAFARI GLITCH INVALID WARP 5",
        "sourceMap=" .. logger:safeField(record.sourceMap)
          .. " returnCell=" .. logger:safeField(record.sourceX) .. ","
          .. logger:safeField(record.sourceY)
          .. " existingGlitchCity=true")
      return record.sourceMap,
        tonumber(record.sourceX) or x, tonumber(record.sourceY) or y
    end

    self:write(nil, "valid_warp5_normal_destination")
    logger:log("SAFARI GLITCH VALID WARP 5",
      "sourceMap=" .. logger:safeField(record.sourceMap)
        .. " resolvedMap=" .. logger:safeField(destMap)
        .. " cell=" .. logger:safeField(x) .. "," .. logger:safeField(y)
        .. " glitchCity=false")
    return next(destMap, x, y, context)
  end

  local controller = Controller.new()

  mod.content.commands:register(COMMAND, {
    foreground = true,
    fn = function(ctx)
      controller:openPrompt(ctx.game, ctx.overworld, function()
        ctx.runner:resume()
      end)
      ctx.runner:yield()
    end,
  })

  mod.content.map_scripts:register("SAFARI_ZONE_GATE", {
    priority = 500,
    onEnter = function(game, world)
      controller:onGateEnter(game, world)
    end,
  })

  mod.events:on("game.ready", function()
    controller:resetRuntime("game_ready")
  end)
  mod.events:on("save.created", function()
    controller:resetRuntime("save_created")
  end)
  mod.events:on("save.loaded", function()
    controller:onSaveLoaded()
  end)
  mod.events:on("world.stepped", function(ev)
    controller:onStep(ev)
  end)

  mod.hooks:wrap("warp.destination", function(next, destMap, x, y, context)
    return controller:routeGateWarp(next, destMap, x, y, context)
  end)

  -- Development HUD drawn after the complete game frame. Keeping it in the
  -- official HUD seam avoids changing the overworld renderer or any map data.
  mod.hooks:wrap("render.hud", function(next, game, viewport)
    next(game, viewport)
    if mod.options:get("debug_safari_step_counter") ~= true then return end

    -- render.hud is global and also runs for the title/main-menu stack. The
    -- counter belongs to the current playfield, so require a live overworld
    -- somewhere in the active stack. Menus layered over the world may keep
    -- the counter; returning to the title removes the world and hides it.
    local hasOverworld = false
    local states = game and game.stack and game.stack.states
    if type(states) == "table" then
      for _, state in ipairs(states) do
        if state and state.isOverworld == true then
          hasOverworld = true
          break
        end
      end
    else
      local top = game and game.stack and game.stack:top()
      hasOverworld = top and top.isOverworld == true or false
    end
    if not hasOverworld then return end

    local steps = controller:remainingSteps(game)
    if steps == nil or not viewport then return end

    local sx = (tonumber(viewport.gameWidth) or 160) / 160
    local sy = (tonumber(viewport.gameHeight) or 144) / 144
    local g = love.graphics
    g.push("all")
    g.origin()
    g.translate(tonumber(viewport.gameX) or 0, tonumber(viewport.gameY) or 0)
    g.scale(sx, sy)
    g.setColor(0, 0, 0, 1)
    g.rectangle("fill", 0, 0, 80, 16)
    g.setColor(1, 1, 1, 1)
    g.rectangle("fill", 1, 1, 78, 14)
    g.setColor(0, 0, 0, 1)
    Font.draw(("STEPS %03d"):format(math.min(999, steps)), 4, 4)
    g.pop()
  end)

  function controller:saveKeyForTest() return SAVE_KEY end

  logger:log("SAFARI GLITCH CITY INSTALLED",
    "versions=red,blue,yellow authenticSaveReload=true outsideSteps=true"
      .. " structuralWarp5=true existingGlitchCity=true")
  return controller
end
