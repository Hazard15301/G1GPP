-- The Pikablu schoolyard rumour, realized as a cross-generation reward.
-- Gold, Silver, or Crystal must already be imported into the public
-- Gen1Recomp install, and G1GPP must have been enabled once for that edition
-- so the sanctioned active-cache asset transform can derive Marill's pictures
-- locally.

return function(ctx)
  local mod = assert(ctx and ctx.mod, "pikablu module requires mod")
  local logger = ctx.logger
  local GameVersion = require("src.core.GameVersion")
  local derivedFront = "save/mod-derived/g1gpp/battle/front/g1gpp_marill.png"
  local derivedBack = "save/mod-derived/g1gpp/battle/back/g1gpp_marill_back.png"
  local Assets = require("src.render.Assets")
  local legacyFront =
    "save/mod-derived/trainer_fly/battle/front/g1gpp_marill.png"
  local legacyBack =
    "save/mod-derived/trainer_fly/battle/back/g1gpp_marill_back.png"
  if (not Assets.exists(derivedFront) or not Assets.exists(derivedBack))
      and Assets.exists(legacyFront) and Assets.exists(legacyBack) then
    derivedFront, derivedBack = legacyFront, legacyBack
    if logger then logger:log("PIKABLU LEGACY ART MIGRATED",
      "source=trainer_fly canonicalBootstrap=g1gpp") end
  end
  if not Assets.exists(derivedFront) or not Assets.exists(derivedBack) then
    if logger then logger:log("PIKABLU DISABLED",
      "public-API Gold/Silver/Crystal art bootstrap not found") end
    return { enabled = false }
  end
  local sourceVersion = "gold_silver_or_crystal_bootstrap"

  local function log(message, details)
    if logger and logger.log then logger:log(message, details or "") end
  end

  -- Give the brief evolution pickup its own foreground presence without
  -- changing the player's saved music-volume option. The map constraint
  -- leaves the real Safari Zone theme completely untouched. LÖVE applies its
  -- normal source ceiling if twice the configured level would exceed it.
  mod.hooks:wrap("music.volume", function(next_, volume, audioCtx)
    local base = next_(volume, audioCtx)
    if audioCtx and audioCtx.song == "Music_SafariZone"
       and audioCtx.mapId == "CINNABAR_LAB_TRADE_ROOM" then
      return (tonumber(base) or tonumber(volume) or 0) * 2
    end
    return base
  end)

  local function state(game)
    game.save.modData = game.save.modData or {}
    local root = game.save.modData[mod.id]
    if not root and type(game.save.modData.trainer_fly) == "table" then
      root = game.save.modData.trainer_fly
      game.save.modData[mod.id] = root
      if logger then logger:log("G1GPP SAVE NAMESPACE MIGRATED",
        "from=trainer_fly to=" .. tostring(mod.id)) end
    end
    if not root then root = {}; game.save.modData[mod.id] = root end
    local value = root.pikablu
    if not value then value = {}; root.pikablu = value end
    return value
  end

  -- The two native Gen II moves Marill learns naturally. They are isolated
  -- content additions; no Gen II TM/HM table or general move engine is used.
  -- Public Gen1Recomp does not expose Rollout's escalating/locking damage
  -- stages, so this compatibility version uses its initial 30-power hit.
  mod.content.move_effects:register("G1GPP_RAIN_DANCE_EFFECT", {
    kind = "primary",
    run = function(effect)
      effect.field.weather = "rain"
      effect.field.weatherTurns = 5
      return { "It started to rain!" }
    end,
  })
  mod.content.moves:register("ROLLOUT", {
    id = "ROLLOUT", name = "ROLLOUT", type = "ROCK", power = 30,
    accuracy = 90, pp = 20, effect = "NO_ADDITIONAL_EFFECT", anim = "TACKLE",
  })
  mod.content.moves:register("RAIN_DANCE", {
    id = "RAIN_DANCE", name = "RAIN DANCE", type = "WATER", power = 0,
    accuracy = 100, pp = 5, effect = "G1GPP_RAIN_DANCE_EFFECT", anim = "MIST",
  })

  mod.content.constants:patch("dexSize", 152)
  -- Public Gen1Recomp cannot read a second edition's audio programs from a
  -- Gen I mod. Use a clearly bounded Gen I-compatible cry until that public
  -- API exists; no captured or extracted Gen II sound bytes are distributed.
  mod.content.cries:register("MARILL", {
    base = "PIKACHU", pitch = 230, length = 170,
  })
  mod.content.text:register("_G1GPPMarillDex",
    "The tip of its tail\ncontains oil that\nis lighter than\fwater, letting it\nswim without\ndrowning")
  mod.content.pokemon:register("MARILL", {
    id = "MARILL", name = "MARILL", dex = 152, index = 183,
    types = { "WATER" },
    baseStats = { hp = 70, attack = 20, defense = 50, speed = 40, special = 50 },
    catchRate = 190, baseExp = 58, growthRate = "FAST",
    level1Moves = { "TACKLE" },
    learnset = {
      { level = 3, move = "DEFENSE_CURL" },
      { level = 6, move = "TAIL_WHIP" },
      { level = 10, move = "WATER_GUN" },
      { level = 15, move = "ROLLOUT" },
      { level = 21, move = "BUBBLEBEAM" },
      { level = 28, move = "DOUBLE_EDGE" },
      { level = 36, move = "RAIN_DANCE" },
    },
    tmhm = {
      "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "BUBBLEBEAM",
      "WATER_GUN", "ICE_BEAM", "BLIZZARD", "SUBMISSION", "SEISMIC_TOSS",
      "RAGE", "MIMIC", "DOUBLE_TEAM", "BIDE", "REST", "SUBSTITUTE",
      "SURF", "STRENGTH",
    },
    evolutions = {},
    spriteFront = derivedFront, spriteBack = derivedBack, cry = "MARILL",
    icon = "FAIRY", palette = "CYANMON",
    frontSize = 5, battleScaleBack = 4 / 3,
    dexEntry = { kind = "AQUAMOUSE", heightFt = 1, heightIn = 4,
                 weight = 187, text = "_G1GPPMarillDex" },
  })

  -- A small Route-25 garden enclosed by the same mountain terrain that
  -- surrounds Bill's house.  Its four-cell-wide bottom opening and central
  -- lawn line up with the four-cell-wide house immediately below it.
  mod.content.maps:register("G1GPP_BILLS_GARDEN", {
    id = "G1GPP_BILLS_GARDEN", index = 1001,
    label = "Bill's Secret Garden",
    tileset = "OVERWORLD", width = 8, height = 7, borderBlock = 44,
    blocks = {
      44,44,87,87,87,87,44,44,
      44,96,116,29,30,31,116,44,
      44,10,116,10,10,116,10,44,
      44,96,10,11,10,10,109,44,
      44,10,116,10,10,116,10,44,
      44,10,10,10,10,10,10,44,
      44,44,44,1,1,44,44,44,
    },
    objects = {
      { index = 1, name = "G1GPP_GARDEN_MARILL", sprite = "SPRITE_MONSTER",
        movement = "STAY", range = "NONE", text = "TEXT_G1GPP_GARDEN_MARILL",
        x = 7, y = 5 },
      { index = 2, name = "G1GPP_GARDEN_BILL", sprite = "SPRITE_SUPER_NERD",
        movement = "STAY", range = "NONE", text = "TEXT_G1GPP_GARDEN_BILL",
        x = 8, y = 13 },
    },
    warps = {
      { x = 6, y = 13, destMap = "BILLS_HOUSE", destWarp = 1 },
      { x = 7, y = 13, destMap = "BILLS_HOUSE", destWarp = 1 },
      { x = 8, y = 13, destMap = "BILLS_HOUSE", destWarp = 1 },
      { x = 9, y = 13, destMap = "BILLS_HOUSE", destWarp = 1 },
    }, connections = {}, signs = {},
  })

  local TextBox = require("src.render.TextBox")
  local Sound = require("src.core.Sound")
  local Pokemon = require("src.pokemon.Pokemon")
  local Commands = require("src.script.Commands")
  local MapScripts = require("src.script.MapScripts")

  local function say(game, text, done, opts)
    game.stack:push(TextBox.new(game, text, done, opts))
  end

  -- A form-feed is an automatic continuation inside one TextBox. These
  -- scenes need deliberate pacing, so each page is its own TextBox and must
  -- receive an A/B acknowledgement before the next one is created.
  local function sayPages(game, pages, done)
    local index = 0
    local function nextPage()
      index = index + 1
      if not pages[index] then
        if done then done() end
        return
      end
      say(game, pages[index], nextPage)
    end
    nextPage()
  end

  local function playBoostedSound(game, soundId)
    local source = Sound.play(game.data, soundId)
    if not source then return end
    local ok, volume = pcall(source.getVolume, source)
    if ok and type(volume) == "number" then
      -- Match the evolution cue's 2x gain request while preserving the
      -- player's configured SFX level as the baseline.
      pcall(source.setVolume, source, volume * 2)
    end
  end

  local function playBoostedDoorSound(game)
    playBoostedSound(game, "Go_Inside")
  end

  mod.content.commands:register("g1gpp_boosted_door_sound",
    function(commandCtx) playBoostedDoorSound(commandCtx.game) end)

  local function hideGardenMarill(game, ow)
    Commands.hide_object({ game = game, save = game.save, overworld = ow },
      "G1GPP_BILLS_GARDEN", "G1GPP_GARDEN_MARILL")
  end

  mod.content.map_scripts:register("G1GPP_BILLS_GARDEN", {
    onEnter = function(game, ow)
      local s = state(game)
      if s.marillJoined then hideGardenMarill(game, ow); return end
      if s.gardenIntroPlayed then return end
      s.gardenIntroPlayed = true
      ow:queueScript({ { "wait", 30 } }, { onDone = function()
        Sound.playCry(game.data, "MARILL")
        say(game, "Well, go on...")
      end })
    end,
    onStep = function(game, ow, x, y)
      local s = state(game)
      if s.marillJoined then
        if y >= 13 then
          s.gardenOpened = false
          s.returningFromGarden = true
        end
        return false
      end
      if y < 12 or ow.runner:isRunning() then return false end
      say(game, "Listen, you've\nalready seen too\nmuch.\fI can't let you\nleave just yet.", function()
        ow:scriptMove(ow.player, "up", 1, nil, { collide = true })
      end)
      return true
    end,
    talk = {
      TEXT_G1GPP_GARDEN_MARILL = function(game, ow, npc, done)
        local s = state(game)
        if s.marillJoined then done(); return end
        Sound.playCry(game.data, "MARILL")
        sayPages(game, {
          "The strange, blue\nmouse sniffs at you",
          "with suspicion.",
          "You've never seen a\nPOKéMON like this",
          "before.",
        }, function()
          Sound.playCry(game.data, "MARILL")
          sayPages(game, {
            "It looks like the\nstrange POKéMON",
            "wants to come with\nyou!",
          }, function()
            local mon = Pokemon.new(game.data, "MARILL", 35)
            table.insert(game.save.party, mon)
            game.save.pokedex.seen.MARILL = true
            game.save.pokedex.owned.MARILL = true
            s.marillJoined = true
            hideGardenMarill(game, ow)
            playBoostedSound(game, "Caught_Mon")
            sayPages(game, {
              "The new POKéMON,\nPIKAB- ..oops!",
              "MARILL, has joined",
              "you on your\njourney!",
            }, function()
              require("src.ui.Screens").push(
                game, "DexEntryMenu", "MARILL", done)
            end)
            log("PIKABLU MARILL JOINED", "level=35 party=" .. #game.save.party)
          end)
        end)
      end,
      TEXT_G1GPP_GARDEN_BILL = function(game, _, _, done)
        local s = state(game)
        say(game, s.marillJoined
          and "Stop in from time\nto time and let me\ntake some notes.\fTake care!"
          or "Well, go on...", done)
      end,
    },
  })

  -- Remove an NPC only from the currently loaded room.  The scientist's
  -- departure is remembered in G1GPP's private save namespace, never in
  -- save.objectToggles: disabling or removing the mod therefore restores the
  -- untouched vanilla scientist automatically.
  local function removeRuntimeNpc(ow, npc)
    if not ow or not npc then return end
    for i = #(ow.npcs or {}), 1, -1 do
      if ow.npcs[i] == npc then table.remove(ow.npcs, i) end
    end
    for i = #(ow.entities or {}), 1, -1 do
      if ow.entities[i] == npc then table.remove(ow.entities, i) end
    end
  end

  -- Cutscene-only disappearance.  Neither branch writes an object toggle:
  -- the player is restored by the ensuing map transition, and vanilla Bill
  -- respawns normally if Bill's House is loaded again.
  mod.content.commands:register("g1gpp_hide_door_actor", function(commandCtx, actor)
    local ow = commandCtx.overworld
    if not ow then return end
    if actor == "player" then
      ow.playerHidden = true
      return
    end
    removeRuntimeNpc(ow, ow:npcByIndex(actor))
  end)

  local function scientistDeparture(game, ow, npc, done)
    local s = state(game)
    s.gardenLead = true
    s.scientistLeft = true
    npc = npc or ow:npcByIndex(2)
    if not npc then
      done()
      return
    end

    -- Half the normal NPC step duration reads as a run. Choose the side of
    -- the player that is clear, then finish on the bottom doorway's left mat,
    -- where the live object disappears.
    local approach = "other"
    if ow.player then
      local dx = ow.player.cellX - npc.cellX
      local dy = ow.player.cellY - npc.cellY
      if dx == 0 and dy == 1 then approach = "below"
      elseif dx == 0 and dy == -1 then approach = "above"
      elseif dx == -1 and dy == 0 then approach = "left"
      elseif dx == 1 and dy == 0 then approach = "right" end
    end
    local exitRoutes = {
      below = { "right", "down", "down", "down" },
      above = { "down", "down", "right", "down" },
      left  = { "down", "down", "right", "down" },
      right = { "down", "down", "right", "down" },
      other = { "down", "down", "right", "down" },
    }
    local exitRoute = exitRoutes[approach]
    npc.stepFrames = 16
    ow:queueScript({
      { "stop_music" },
      { "emote", 2, "shock", 30 },
      -- Gen I evolution uses Music_SafariZone. Keep the familiar pickup for
      -- just under one second before restoring the map music.
      { "play_music", "Music_SafariZone" },
      { "wait", 55 },
      { "play_default_music" },
      { "show_text", "Wh.. Wh... What???" },
      { "show_text", "RAICHU is.....\nEVOLVING?" },
      { "show_text", "Incredible!" },
      { "show_text", "My friend, BILL,\nneeds to see this" },
      { "show_text", "right away!" },
      { "walk_npc", 2, exitRoute },
      { "g1gpp_boosted_door_sound" },
    }, { npc = npc, onDone = function()
      removeRuntimeNpc(ow, npc)
      log("PIKABLU SCIENTIST DEPARTED", "gardenLead=true")
      done()
    end })
  end

  -- Red/Blue turns the completed Raichu trade into the Eureka moment that
  -- sends the scientist to Bill. Yellow retains its separate rumour lead.
  mod.content.map_scripts:register("CINNABAR_LAB_TRADE_ROOM", {
    priority = 100,
    onEnter = function(game, ow)
      if GameVersion.isYellow() or not state(game).scientistLeft then return end
      removeRuntimeNpc(ow, ow:npcByIndex(2))
    end,
    talk = {
      TEXT_CINNABARLABTRADEROOM_GRAMPS = function(game, ow, npc, done)
        local traded = game.save.flags.EVENT_TRADED_RAICHU_FOR_ELECTRODE
        local yellow = GameVersion.isYellow()
        if not traded then
          local base = MapScripts.baseTalk("CINNABAR_LAB_TRADE_ROOM",
            "TEXT_CINNABARLABTRADEROOM_GRAMPS")
          ow.runner:run(base, { npc = npc, onDone = function()
            if not yellow
               and game.save.flags.EVENT_TRADED_RAICHU_FOR_ELECTRODE then
              scientistDeparture(game, ow, npc, done)
            else
              done()
            end
          end })
          return
        end
        if not yellow then
          if state(game).scientistLeft then
            removeRuntimeNpc(ow, npc)
            done()
          else
            -- Migration path for a Red/Blue save whose trade was completed
            -- before this departure sequence existed.
            scientistDeparture(game, ow, npc, done)
          end
          return
        end
        local s = state(game)
        s.gardenLead = true
        say(game, "I've heard trading\nwill cause some\nPOKéMON to evolve!\fI hear the famous\nresearcher, BILL,\nrecently learned of\fa new species that\nevolved through\ntrading.\fWhat I wouldn't give\nto study it!", done)
        log("PIKABLU LEAD ARMED", "version=" .. GameVersion.get())
      end,
    },
  })

  -- Bill's PC is a hard-coded hidden event, so intercept only this new armed
  -- state and leave every vanilla Cell Separator / Eevee-list branch intact.
  local Overworld = require("src.world.OverworldController")
  Overworld._g1gppPikabluOriginalBillsHousePC =
    Overworld._g1gppPikabluOriginalBillsHousePC or Overworld.billsHousePC
  local originalBillsPC = Overworld._g1gppPikabluOriginalBillsHousePC

  local function isolateBillsHouseBlocks(ow)
    local map = ow and ow.map
    if not map then return end
    if map._g1gppHiddenDoorOriginalBlock == nil then
      local width = map.def and map.def.width
      local blocks = map.def and map.def.blocks
      if width and blocks then
        -- Block coordinate (1,0) is the second entry in Bill's four-block
        -- row: the original left transporter and connecting pipe.
        map._g1gppHiddenDoorOriginalBlock = blocks[2]
      end
    end
    if map._g1gppPrivateDef then return end
    local original = map.def
    local private = {}
    for key, value in pairs(original) do private[key] = value end
    private.blocks = {}
    for i, block in ipairs(original.blocks or {}) do private.blocks[i] = block end
    map.def = private
    map._g1gppPrivateDef = true
  end

  local function isolateBillsHouseTileset(ow)
    local map = ow and ow.map
    if not map or not map.tileset then return nil, nil end
    if map._g1gppPrivateTileset then
      return map._g1gppSealedBlock, map._g1gppDoorBlock
    end

    local original = map.tileset
    local private = {}
    for key, value in pairs(original) do private[key] = value end
    private.blocks = {}
    for i, block in ipairs(original.blocks or {}) do private.blocks[i] = block end

    -- Block 5 is the original left transporter plus the right half of the
    -- connecting pipe.  Preserve its left half exactly.  The temporary
    -- panel borrows the right half of stock blank-wall block 34; the opened
    -- state borrows the right half of stock door block 41.  This produces a
    -- single normal-width door without touching either transporter.
    local function composite(rightSourceId)
      local left = assert(original.blocks[5 + 1])
      local right = assert(original.blocks[rightSourceId + 1])
      local block = {}
      for row = 0, 3 do
        for col = 0, 3 do
          local i = row * 4 + col + 1
          block[i] = col < 2 and left[i] or right[i]
        end
      end
      private.blocks[#private.blocks + 1] = block
      return #private.blocks - 1
    end

    map.tileset = private
    map._g1gppPrivateTileset = true
    map._g1gppSealedBlock = composite(34)
    map._g1gppDoorBlock = composite(41)
    return map._g1gppSealedBlock, map._g1gppDoorBlock
  end

  local function openBillsHiddenDoor(ow)
    -- Replace only the pipe half of its original block with one ordinary
    -- door.  Both the map and tileset are private to this loaded room, so the
    -- untouched base data returns automatically when the mod is removed.
    isolateBillsHouseBlocks(ow)
    local _, doorBlock = isolateBillsHouseTileset(ow)
    if doorBlock then ow:replaceBlock(1, 0, doorBlock) end
  end

  local function closeBillsHiddenDoor(ow)
    -- Clearing gardenOpened prevents the door from being recreated on later
    -- loads, but the currently reused Bill's House map can still contain the
    -- last rendered door block. Put back the exact block that occupied this
    -- cell before the reveal so the concealed entrance becomes invisible
    -- again immediately, including on a same-map-object return.
    isolateBillsHouseBlocks(ow)
    local map = ow and ow.map
    local originalBlock = map and map._g1gppHiddenDoorOriginalBlock
    if originalBlock ~= nil then ow:replaceBlock(1, 0, originalBlock) end
  end

  local function placePlayerBelowBillsHiddenDoor(ow)
    local player = ow and ow.player
    if not player then return end
    player.cellX, player.cellY = 3, 2
    player.px, player.py = 3 * 16, 2 * 16
    player.facing = "down"
    player.moving = false
    player.targetX, player.targetY = nil, nil
    player.progress = 0
    ow.playerHidden = false
  end

  mod.content.map_scripts:register("BILLS_HOUSE", {
    onEnter = function(game, ow)
      local s = state(game)
      if s.returningFromGarden then
        -- G1GPP_BILLS_GARDEN uses OVERWORLD graphics, so the base engine
        -- briefly records it as LAST_MAP while crossing back indoors. Restore
        -- Bill's real Route 25 exterior before the house's LAST_MAP exit can
        -- resolve, then discard the one-shot marker.
        local outside = { id = "ROUTE_25", x = 45, y = 3 }
        ow.lastOutdoor = outside
        game.save.lastOutdoor = { id = outside.id, x = outside.x, y = outside.y }
        s.returningFromGarden = nil
        s.gardenOpened = false
        placePlayerBelowBillsHiddenDoor(ow)
        closeBillsHiddenDoor(ow)
        log("PIKABLU GARDEN EXIT RESTORED",
          "lastOutdoor=ROUTE_25 doorHidden=true player=3,2")
      end
      if s.gardenOpened then openBillsHiddenDoor(ow) end
    end,
  })

  local function routeTo(entity, tx, ty)
    local dirs = {}
    local x, y = entity.cellX, entity.cellY
    while x > tx do dirs[#dirs + 1] = "left"; x = x - 1 end
    while x < tx do dirs[#dirs + 1] = "right"; x = x + 1 end
    while y > ty do dirs[#dirs + 1] = "up"; y = y - 1 end
    while y < ty do dirs[#dirs + 1] = "down"; y = y + 1 end
    return dirs
  end

  -- Advance Bill and the player together for the hidden-door approach.
  -- Both actors begin each tile on the same frame, so the player follows
  -- Bill's previous cell continuously instead of the old stop-start series
  -- of alternating one-tile commands.
  mod.content.commands:register("g1gpp_follow_bill_to_door",
    function(commandCtx, billIndex)
      local ow = commandCtx.overworld
      local runner = commandCtx.runner
      local bill = ow and ow:npcByIndex(billIndex)
      local player = ow and ow.player
      if not ow or not runner or not bill or not player then return end

      local billPath = { "right", "right", "up", "up", "up", "up", "up" }
      local playerPath = { "up", "right", "right", "up", "up", "up", "up" }
      local stepIndex = 0
      local function nextPair()
        stepIndex = stepIndex + 1
        if not billPath[stepIndex] then
          runner:resume()
          return
        end
        local remaining = 2
        local function arrived()
          remaining = remaining - 1
          if remaining == 0 then nextPair() end
        end
        ow:scriptMove(bill, billPath[stepIndex], 1, arrived)
        ow:scriptMove(player, playerPath[stepIndex], 1, arrived)
      end
      nextPair()
      runner:yield()
    end)

  local function revealDoorAndFollow(game, ow, s, bill)
    isolateBillsHouseBlocks(ow)
    local sealedBlock, doorBlock = isolateBillsHouseTileset(ow)
    if not bill then
      s.gardenOpened = true
      openBillsHiddenDoor(ow)
      ow:startWarpTo("G1GPP_BILLS_GARDEN", 8, 12, "up")
      return
    end

    local billIndex = bill.def.index
    bill.stepFrames = 16
    local rows = {
      -- Bill shoulders past the player, reaches the PC, and removes the pipe.
      { "walk_npc", "player", { "down" } },
      { "walk_npc", billIndex, routeTo(bill, 1, 5) },
      { "face_object", billIndex, "up" },
      { "play_sound", "Switch" },
      { "replace_block", 1, 0, sealedBlock },
      { "wait", 12 },
      -- The low rumble covers the wall panel lifting into its open state.
      { "play_sound", "Earthquake" },
      { "wait", 36 },
      { "replace_block", 1, 0, doorBlock },
      { "wait", 12 },
      -- Bill and the player now move as one continuous follow chain. Each
      -- sprite still vanishes separately as it reaches the doorway.
      { "g1gpp_follow_bill_to_door", billIndex },
      { "g1gpp_boosted_door_sound" },
      { "g1gpp_hide_door_actor", billIndex },
      { "walk_npc", "player", { "up" } },
      { "g1gpp_boosted_door_sound" },
      { "g1gpp_hide_door_actor", "player" },
      { "warp", "G1GPP_BILLS_GARDEN", 8, 12, "up" },
    }
    s.gardenOpened = true
    ow:queueScript(rows, { npc = bill, onDone = function()
      log("PIKABLU GARDEN DOOR OPENED", "pipeRemoved=true followedBill=true")
    end })
  end

  local function inviteToGarden(game, ow, s)
    local bill
    for _, candidate in ipairs(ow.npcs or {}) do
      if candidate.def and (candidate.def.name == "BILLSHOUSE_BILL1"
          or candidate.def.name == "BILLSHOUSE_BILL2") and not candidate.hidden then
        bill = candidate; break
      end
    end
    if #game.save.party >= 6 then
      local function refuse()
        sayPages(game, {
          "...Hey bud, why\ndon't you come",
          "back with a few\nless POKéMON?",
        })
      end
      if bill then
        Sound.play(game.data, "Press_AB")
        ow.emote = { npc = bill, frames = 20, bubble = 1, onDone = refuse }
      else
        refuse()
      end
      return
    end
    local function speech()
      sayPages(game, {
        "Hey! That's\nprivate!",
        "If you hadn't\nhelped me out",
        "earlier, I would\nbe calling the",
        "POLICE right now!",
        ".....",
        "Oh, what's the\nuse.",
        "My studies haven't",
        "been going well\nanyway.",
        "I think I've\ndiscovered a new",
        "species of\nPOKéMON!",
        "But it won't let\nme get near enough",
        "to study...",
        "Hey, I know! Maybe",
        "you could help\nwith my research?",
        "This new POKéMON",
        "doesn't seem to\nlike me much,",
        "but maybe it will\nlike you better.",
        "Come with me.",
      }, function()
        revealDoorAndFollow(game, ow, s, bill)
      end)
    end
    if bill then
      ow.emote = { npc = bill, frames = 20, bubble = 1, onDone = speech }
    else
      speech()
    end
  end

  Overworld.billsHousePC = function(ow)
    local game = require("src.core.Game")
    local s = state(game)
    if ow.map.id ~= "BILLS_HOUSE" or not s.gardenLead
       or not game.save.flags.EVENT_GOT_SS_TICKET or s.marillJoined then
      return originalBillsPC(ow)
    end
    if s.notesRead then
      inviteToGarden(game, ow, s)
      return
    end
    local playerName = game.save.player.name
    say(game, playerName .. " glanced at\nBILL's PC!\fThere are research\nnotes on the screen,\fand a note on the\ndesk that says\n\"PIKABLU???\"", function()
      s.notesRead = true
      game.data.constants.dexSize = 152
      inviteToGarden(game, ow, s)
      log("PIKABLU NOTES READ", "dexSize=152")
    end)
  end

  -- Keep No.152 outside the ordinary list until the notes reveal it. The
  -- existing MissingNo. wrapper remains outside this one and still masks its
  -- own internal 152 records independently.
  local PokedexMenu = require("src.ui.PokedexMenu")
  PokedexMenu._g1gppPikabluOriginalNew =
    PokedexMenu._g1gppPikabluOriginalNew or PokedexMenu.new
  local originalDexNew = PokedexMenu._g1gppPikabluOriginalNew
  PokedexMenu.new = function(game, opts)
    local old = game.data.constants.dexSize
    if not state(game).notesRead then game.data.constants.dexSize = 151 end
    local ok, menu = pcall(originalDexNew, game, opts)
    game.data.constants.dexSize = old
    if not ok then error(menu, 0) end
    return menu
  end

  log("PIKABLU ENABLED", "sourceVersion=" .. sourceVersion)
  return { enabled = true, sourceVersion = sourceVersion }
end
