-- Red/Blue internal index 192: "a" (C0).
--
-- This module owns the first database-driven glitch-Pokemon pilot. It keeps
-- the entry isolated from MissingNo.'s No.000/Rhydon path, shares Poliwhirl's
-- No.061 capture flag exactly as the cartridge does, and never executes the
-- unsafe Super Glitch learnset records.

return function(ctx)
  local mod = assert(ctx and ctx.mod, "glitch_species_192 needs mod")
  local logger = assert(ctx.logger, "glitch_species_192 needs logger")
  local encounterData = assert(ctx.encounterData,
    "glitch_species_192 needs encounter resolver")
  local BattleState = require("src.battle.BattleState")
  local DexEntryMenu = require("src.ui.DexEntryMenu")
  local PokedexMenu = require("src.ui.PokedexMenu")
  local Font = require("src.render.Font")

  local SPECIES = "TF_GLITCH_192_A"
  local FLAG_SPECIES = "POLIWHIRL"

  local loadedVersion, GameVersion = pcall(require, "src.core.GameVersion")
  local gotVersion, version = false, nil
  if loadedVersion and type(GameVersion) == "table"
      and type(GameVersion.get) == "function" then
    gotVersion, version = pcall(GameVersion.get)
  end
  if not gotVersion or (version ~= "red" and version ~= "blue") then
    logger:log("GLITCH 192 PILOT SKIPPED",
      "version=" .. logger:safeField(version)
        .. " reason=red_blue_species_only yellowEquivalent=4_4_Hy_pending")
    return { species = SPECIES, skipped = true, version = version }
  end

  mod.content.text:register("_G1GPPGlitch192BlankDex", "\n")
  mod.content.pokemon:register(SPECIES, {
    id = SPECIES,
    index = 192,
    name = "a",
    dex = 61,
    dexEntry = {
      -- C0's invalid Pokédex pointer is $8B88 in VRAM. These ordinary
      -- fields are intentionally empty; the capture-only renderer below
      -- supplies inert tile codes and measurement bytes from transient state.
      kind = "",
      heightFt = 0,
      heightIn = 0,
      weight = 0,
      text = "_G1GPPGlitch192BlankDex",
    },
    types = { "WATER", "WATER" },
    baseStats = {
      hp = 65, attack = 65, defense = 65, speed = 90, special = 50,
    },
    catchRate = 120,
    baseExp = 131,
    growthRate = "MEDIUM_SLOW",
    level1Moves = { "BUBBLE", "HYPNOSIS", "WATER_GUN" },
    -- Only valid, stable move IDs are registered. Original out-of-bounds TM
    -- IDs and all eleven Super Glitch reads are preservation hazards, not
    -- executable gameplay in G1GPP.
    learnset = {
      { level = 2, move = "HORN_DRILL" },
      { level = 4, move = "SELFDESTRUCT" },
      { level = 5, move = "TACKLE" },
      { level = 6, move = "SELFDESTRUCT" },
      { level = 8, move = "HORN_DRILL" },
      { level = 14, move = "PAY_DAY" },
      { level = 24, move = "KARATE_CHOP" },
      { level = 31, move = "HORN_DRILL" },
      { level = 32, move = "MEGA_PUNCH" },
      { level = 33, move = "EGG_BOMB" },
      { level = 40, move = "MEGA_KICK" },
      { level = 56, move = "MEGA_PUNCH" },
      { level = 71, move = "LICK" },
      { level = 88, move = "DOUBLE_KICK" },
      { level = 96, move = "DOUBLE_KICK" },
      { level = 119, move = "STRING_SHOT" },
    },
    tmhm = {
      "MEGA_PUNCH", "MEGA_KICK", "TOXIC", "BODY_SLAM", "TAKE_DOWN",
      "DOUBLE_EDGE", "BUBBLEBEAM", "WATER_GUN", "ICE_BEAM", "BLIZZARD",
      "SUBMISSION", "COUNTER", "SEISMIC_TOSS", "RAGE", "EARTHQUAKE",
      "FISSURE", "PSYCHIC_M", "MIMIC", "DOUBLE_TEAM", "BIDE",
      "METRONOME", "SKULL_BASH", "REST", "PSYWAVE", "SUBSTITUTE",
      "SURF", "STRENGTH",
    },
    evolutions = {},
    cry = SPECIES,
    -- Asset transforms write beneath save/mod-derived/<mod id>. Point to that
    -- private output directly; the mod package contains no sprite pixels.
    spriteFront = "save/mod-derived/g1gpp/battle/front/g1gpp_species_192_a.png",
    spriteBack = "save/mod-derived/g1gpp/battle/back/g1gpp_species_192_a.png",
    frontSize = 7,
    palette = "MEWMON",
  })
  mod.content.icons:register(SPECIES, "MON")

  -- The resolver table predates the general Glitch Pokémon roster. Install
  -- C0 explicitly so it wins over the generic internal-index scan and always
  -- resolves to this module's registered species.
  encounterData.glitchPokemon[192] = {
    id = SPECIES,
    index = 192,
    name = "a",
    subtype = "database_pilot",
  }

  local function isSpecies(monOrSpecies)
    if type(monOrSpecies) == "table" then
      monOrSpecies = monOrSpecies.species
    end
    return monOrSpecies == SPECIES
  end

  local function dexTables(game)
    local save = game and game.save
    if not save then return nil end
    save.pokedex = save.pokedex or {}
    save.pokedex.seen = save.pokedex.seen or {}
    save.pokedex.owned = save.pokedex.owned or {}
    return save.pokedex
  end

  -- The cartridge reads C0's entry structure from VRAM $8B88. Recreate the
  -- resulting state dependence without reading or executing arbitrary host
  -- memory: a transient seed produces safe font-tile codes plus the same four
  -- display bytes (height feet/inches, little-endian weight). Font.drawCode
  -- treats every value as inert imagery, so text commands and ACE are
  -- structurally impossible.
  local pageSequence = 0
  local function buildSafeVramPage(game)
    pageSequence = pageSequence + 1
    local now = love.timer and love.timer.getTime and love.timer.getTime()
      or os.clock()
    local partyCount = game and game.save and game.save.party
      and #game.save.party or 0
    local seed = (math.floor((tonumber(now) or 0) * 4096)
      + pageSequence * 0x8B88 + partyCount * 257) % 0x80000000
    local function nextByte()
      seed = (seed * 1103515245 + 12345) % 0x80000000
      return math.floor(seed / 65536) % 256
    end
    local rows = { {}, {} }
    for row = 1, 2 do
      local count = 4 + nextByte() % 5
      for i = 1, count do
        -- $80-$FF is the normal Gen-I font page. No byte is dispatched
        -- through the text engine, even if its original value was a command.
        rows[row][i] = 0x80 + nextByte() % 0x80
      end
    end
    local heightFt = nextByte()
    local heightIn = nextByte()
    local weightLo = nextByte()
    local weightHi = nextByte()
    return {
      rows = rows,
      heightFt = heightFt,
      heightIn = heightIn,
      weight = weightLo + weightHi * 256,
      seed = seed,
    }
  end

  -- BattleState checks the recomp species key, while Red/Blue checks the
  -- mapped Pokédex bit. Mirror No.061 into the private species key only for
  -- engine/QoL compatibility; the duplicate row is masked below.
  BattleState._g1gpp192OriginalStoreCaughtMon =
    BattleState._g1gpp192OriginalStoreCaughtMon or BattleState.storeCaughtMon
  local originalStoreCaughtMon = BattleState._g1gpp192OriginalStoreCaughtMon
  function BattleState:storeCaughtMon()
    local mon = self.enemy and self.enemy.mon
    if not isSpecies(mon) then return originalStoreCaughtMon(self) end

    local dex = dexTables(self.game)
    local wasOwned = dex and dex.owned[FLAG_SPECIES] == true or false
    if dex then
      dex.owned[SPECIES] = wasOwned and true or nil
      dex.seen[SPECIES] = wasOwned and true or nil
    end
    logger:log("GLITCH 192 CAPTURE FLAG CHECK",
      "poliwhirlOwned=" .. logger:safeField(wasOwned)
        .. " outcome=" .. (wasOwned and "skip_page" or "show_capture_page"))

    local result = originalStoreCaughtMon(self)
    if dex then
      dex.seen[FLAG_SPECIES] = true
      dex.owned[FLAG_SPECIES] = true
      dex.seen[SPECIES] = true
      dex.owned[SPECIES] = true
    end
    logger:log("GLITCH 192 CAPTURE STORED",
      "species=" .. SPECIES
        .. " sharedDex=061 poliwhirlSeen=true poliwhirlOwned=true"
        .. " privateCompatibilityFlag=true pageShown="
        .. logger:safeField(not wasOwned))
    return result
  end

  DexEntryMenu._g1gpp192OriginalNew =
    DexEntryMenu._g1gpp192OriginalNew or DexEntryMenu.new
  local originalDexEntryNew = DexEntryMenu._g1gpp192OriginalNew
  DexEntryMenu.new = function(game, speciesOrOpts, onDone)
    local species = type(speciesOrOpts) == "table"
      and (speciesOrOpts.species or speciesOrOpts[1]) or speciesOrOpts
    local screen = originalDexEntryNew(game, speciesOrOpts, onDone)
    if species ~= SPECIES or not (screen and screen.def) then return screen end

    local displayDef = {}
    for key, value in pairs(screen.def) do displayDef[key] = value end
    displayDef.dex = 61
    displayDef.name = "a"
    displayDef.dexEntry = {
      kind = "", text = "_G1GPPGlitch192BlankDex",
    }
    screen.def = displayDef
    screen.forceOwned = true
    screen._g1gpp192VramPage = buildSafeVramPage(game)
    local payload = screen._g1gpp192VramPage
    logger:log("GLITCH 192 CAPTURE PAGE PREPARED",
      "displayDex=061 source=VRAM_8B88 emulation=inert_font_tiles"
        .. " row1Tiles=" .. logger:safeField(#payload.rows[1])
        .. " row2Tiles=" .. logger:safeField(#payload.rows[2])
        .. " height=" .. logger:safeField(payload.heightFt)
        .. "ft_" .. logger:safeField(payload.heightIn) .. "in"
        .. " weightTenths=" .. logger:safeField(payload.weight)
        .. " description=blank controlDispatch=false ace=false")
    return screen
  end

  DexEntryMenu._g1gpp192OriginalDraw =
    DexEntryMenu._g1gpp192OriginalDraw or DexEntryMenu.draw
  local originalDexEntryDraw = DexEntryMenu._g1gpp192OriginalDraw
  function DexEntryMenu:draw()
    local payload = self._g1gpp192VramPage
    if not payload then return originalDexEntryDraw(self) end

    originalDexEntryDraw(self)

    -- Erase the recomp's localized "Data unknown." fallback while preserving
    -- the Pokédex divider and outer frame. Original C0 follows arbitrary text
    -- code after the four measurements; G1GPP leaves that unsafe path blank.
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 8, 80, 144, 56)

    -- Replace the ordinary classification/measurement region with the safe
    -- $8B88-equivalent payload. Two tightly packed rows intentionally overlap
    -- the measurement area as corrupted original pages can.
    love.graphics.rectangle("fill", 72, 32, 80, 40)
    love.graphics.setColor(0, 0, 0, 1)
    for row = 1, 2 do
      for col, code in ipairs(payload.rows[row]) do
        Font.drawCode(code, 72 + (col - 1) * 8, 32 + (row - 1) * 8)
      end
    end
    Font.draw(("HT %d′%02d″"):format(
      payload.heightFt, payload.heightIn), 72, 48)
    Font.draw(("WT %.1flb"):format(payload.weight / 10), 72, 64)
    love.graphics.setColor(1, 1, 1, 1)
  end

  -- The cartridge's ordinary No.061 list entry resolves back to Poliwhirl.
  -- Hide the recomp-only duplicate without deleting its compatibility flags.
  PokedexMenu._g1gpp192OriginalNew =
    PokedexMenu._g1gpp192OriginalNew or PokedexMenu.new
  local originalPokedexNew = PokedexMenu._g1gpp192OriginalNew
  PokedexMenu.new = function(game, opts)
    local def = game and game.data and game.data.pokemon
      and game.data.pokemon[SPECIES]
    if not def then return originalPokedexNew(game, opts) end
    local dex = def.dex
    def.dex = 0
    local ok, result = pcall(originalPokedexNew, game, opts)
    def.dex = dex
    if not ok then error(result, 0) end
    logger:log("GLITCH 192 POKEDEX DUPLICATE MASKED",
      "ordinaryDex061=POLIWHIRL privateSpecies=" .. SPECIES)
    return result
  end

  mod.hooks:wrap("battle.caught_marker_visible", function(next, battle)
    if not (battle and battle.enemy and isSpecies(battle.enemy.mon)) then
      return next(battle)
    end
    local dex = dexTables(battle.game)
    return dex and dex.owned[FLAG_SPECIES] == true or false
  end)

  mod.events:on("game.ready", function(ev)
    local game = ev and ev.game
    local def = game and game.data and game.data.pokemon
      and game.data.pokemon[SPECIES]
    logger:log("GLITCH 192 PILOT INSTALLED",
      "registered=" .. logger:safeField(def ~= nil)
        .. " index=" .. logger:safeField(def and def.index)
        .. " dex=061 flagSpecies=POLIWHIRL icon=MON"
        .. " resolverMapped="
        .. logger:safeField(encounterData.glitchPokemon[192]
          and encounterData.glitchPokemon[192].id == SPECIES)
        .. " superGlitchEntries=guarded unsafeLevels=13,42"
        .. " versionScope=red_blue")
  end)

  return { species = SPECIES, flagSpecies = FLAG_SPECIES }
end
