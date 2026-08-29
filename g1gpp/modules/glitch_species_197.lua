-- Red/Blue internal index 197 / $C5. The accepted dual-stage audit captured
-- 21 14 4A CD 49 3C 21 7B CF 7D 50. $21/$14 are visible transient glyphs
-- before $4A's <PK><MN>; $7B/$7D are nonblank English extra-font slots later
-- in the buffer. Blank/unsupported middle bytes remain inert and blank.
-- Authority: normalized database sheets 12/13/14/23/24/25 plus accepted Master
-- Research evidence. Legacy sheets are deliberately excluded.

return function(ctx)
  local mod = assert(ctx and ctx.mod, "glitch_species_197 needs mod")
  local logger = assert(ctx.logger, "glitch_species_197 needs logger")
  local encounterData = assert(ctx.encounterData,
    "glitch_species_197 needs encounter resolver")
  local BattleState = require("src.battle.BattleState")
  local DexEntryMenu = require("src.ui.DexEntryMenu")
  local PokedexMenu = require("src.ui.PokedexMenu")
  local Font = require("src.render.Font")
  local Sound = require("src.core.Sound")
  local SPECIES = "TF_GLITCH_197_C5"
  mod.content.font:register("g1gpp_species_197_name", {
    image = "save/mod-derived/g1gpp/fonts/g1gpp_species_197_name.png",
    base = 0xC500,
    glyphsPerRow = 2,
    charmap = {
      { seq = "<TF197A>", code = 0xC500 },
      { seq = "<TF197B>", code = 0xC501 },
    },
  })
  for _, code in ipairs({ 0x7B, 0x7D }) do
    local seq = ("<TF%02X>"):format(code)
    mod.content.font:register("charmap:" .. seq, { seq = seq, code = code })
  end
  local DISPLAY_NAME = "<TF197A><TF197B><PK><MN><TF7B><TF7D>"

  local loadedVersion, GameVersion = pcall(require, "src.core.GameVersion")
  local gotVersion, version = false, nil
  if loadedVersion and type(GameVersion) == "table"
      and type(GameVersion.get) == "function" then
    gotVersion, version = pcall(GameVersion.get)
  end
  if not gotVersion or (version ~= "red" and version ~= "blue") then
    logger:log("GLITCH 197 SKIPPED",
      "version=" .. logger:safeField(version)
        .. " reason=red_blue_species_only yellow_pending")
    return { species = SPECIES, skipped = true, version = version }
  end

  mod.content.text:register("_G1GPPGlitch197BlankDex", "\n")
  mod.content.cries:register(SPECIES, {
    -- The trace's bank-8 $6040 value is the live sound-engine SFX pointer,
    -- not the base cry header expected by Gen1Recomp's cry registry. CryData
    -- byte $04 identifies the Rhyhorn/Charmander family. Borrow its native
    -- extracted program and apply the exact captured modifiers.
    base = "RHYHORN",
    pitch = 0x47, length = 0xCB,
  })
  mod.content.pokemon:register(SPECIES, {
    id = SPECIES, index = 197, name = DISPLAY_NAME,
    -- Private schema-safe key. Capture presentation renders No.250; ordinary
    -- browsing is masked because the cartridge lookup exits the 151-bit table.
    dex = 152,
    dexEntry = {
      kind = "", heightFt = 0, heightIn = 0, weight = 0,
      text = "_G1GPPGlitch197BlankDex",
    },
    types = { "TF_TYPE_0B", "NORMAL" },
    -- Schema rejects zero stats; game.ready restores the raw Attack byte 0.
    baseStats = { hp = 37, attack = 1, defense = 40, speed = 178, special = 19 },
    catchRate = 23, baseExp = 17,
    -- Raw growth byte $37 is invalid. This is a bounded save-safe adapter.
    growthRate = "MEDIUM_FAST",
    level1Moves = { "GUILLOTINE", "RAZOR_WIND", "PAY_DAY" },
    learnset = {},
    tmhm = {
      "BUBBLEBEAM", "ICE_BEAM", "COUNTER", "SEISMIC_TOSS", "THUNDER",
      "EARTHQUAKE", "FISSURE", "PSYCHIC_M", "TELEPORT", "BIDE",
      "METRONOME", "SOFTBOILED", "SKY_ATTACK", "REST", "PSYWAVE",
      "ROCK_SLIDE",
    },
    evolutions = {}, cry = SPECIES,
    spriteFront = "save/mod-derived/g1gpp/battle/front/g1gpp_species_197_c5.png",
    spriteBack = "save/mod-derived/g1gpp/battle/back/g1gpp_species_197_c5.png",
    frontSize = 7, palette = "MEWMON",
  })
  mod.content.icons:register(SPECIES, {
    image = "save/mod-derived/g1gpp/icons/g1gpp_species_197_c5.png",
    frames = 2,
  })
  encounterData.glitchPokemon[197] = {
    id = SPECIES, index = 197, name = DISPLAY_NAME,
    subtype = "retained_roster",
  }

  local function isSpecies(monOrSpecies)
    if type(monOrSpecies) == "table" then monOrSpecies = monOrSpecies.species end
    return monOrSpecies == SPECIES
  end

  if not Sound._g1gpp197OriginalPlayCry then
    Sound._g1gpp197OriginalPlayCry = Sound.playCry
  end
  local originalPlayCry = Sound._g1gpp197OriginalPlayCry
  Sound.playCry = function(data, species, pikaClip)
    if species ~= SPECIES then
      return originalPlayCry(data, species, pikaClip)
    end
    logger:log("GLITCH 197 CRY PLAY",
      "species=" .. SPECIES .. " base=RHYHORN pitch=47 length=CB")
    local ok, source = pcall(originalPlayCry, data, species, pikaClip)
    if not ok then
      logger:log("GLITCH 197 CRY ERROR", "error=" .. logger:safeField(source))
      return nil
    end
    local playing, duration = nil, nil
    if source then
      pcall(function() playing = source:isPlaying() end)
      pcall(function() duration = source:getDuration() end)
    end
    logger:log("GLITCH 197 CRY RESULT",
      "source=" .. logger:safeField(source ~= nil)
        .. " playing=" .. logger:safeField(playing)
        .. " duration=" .. logger:safeField(duration))
    return source
  end
  local function dexTables(game)
    local save = game and game.save
    if not save then return nil end
    save.pokedex = save.pokedex or {}
    save.pokedex.seen = save.pokedex.seen or {}
    save.pokedex.owned = save.pokedex.owned or {}
    return save.pokedex
  end
  local function safeClassification()
    local state, codes = 0x2B40 + 197, {}
    for i = 1, 12 do
      state = (state * 73 + 41) % 997
      codes[i] = 0x80 + (state % 0x80)
    end
    return codes
  end

  BattleState._g1gpp197OriginalStoreCaughtMon =
    BattleState._g1gpp197OriginalStoreCaughtMon or BattleState.storeCaughtMon
  local originalStoreCaughtMon = BattleState._g1gpp197OriginalStoreCaughtMon
  function BattleState:storeCaughtMon()
    local mon = self.enemy and self.enemy.mon
    if not isSpecies(mon) then return originalStoreCaughtMon(self) end
    local dex = dexTables(self.game)
    local wasOwned = dex and dex.owned[SPECIES] == true or false
    local result = originalStoreCaughtMon(self)
    if dex then dex.seen[SPECIES], dex.owned[SPECIES] = true, true end
    logger:log("GLITCH 197 CAPTURE STORED",
      "displayDex=250 privateSafeFlag=true pageShown="
        .. logger:safeField(not wasOwned))
    return result
  end

  DexEntryMenu._g1gpp197OriginalNew =
    DexEntryMenu._g1gpp197OriginalNew or DexEntryMenu.new
  local originalDexEntryNew = DexEntryMenu._g1gpp197OriginalNew
  DexEntryMenu.new = function(game, speciesOrOpts, onDone)
    local species = type(speciesOrOpts) == "table"
      and (speciesOrOpts.species or speciesOrOpts[1]) or speciesOrOpts
    local screen = originalDexEntryNew(game, speciesOrOpts, onDone)
    if species ~= SPECIES or not (screen and screen.def) then return screen end
    local displayDef = {}
    for key, value in pairs(screen.def) do displayDef[key] = value end
    displayDef.dex, displayDef.name = 250, DISPLAY_NAME
    displayDef.dexEntry = { kind = "", text = "_G1GPPGlitch197BlankDex" }
    screen.def, screen.forceOwned = displayDef, true
    screen._g1gpp197Page = { codes = safeClassification() }
    logger:log("GLITCH 197 CAPTURE PAGE PREPARED",
      "displayDex=250 source=ROM0_2B40 classification=inert_bounded_tiles"
        .. " rawHeight=205ft_57in rawWeightTenths=44855"
        .. " descriptionCommand=EA dispatch=false ace=false")
    return screen
  end

  DexEntryMenu._g1gpp197OriginalDraw =
    DexEntryMenu._g1gpp197OriginalDraw or DexEntryMenu.draw
  local originalDexEntryDraw = DexEntryMenu._g1gpp197OriginalDraw
  function DexEntryMenu:draw()
    local payload = self._g1gpp197Page
    if not payload then return originalDexEntryDraw(self) end
    originalDexEntryDraw(self)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 72, 24, 80, 56)
    love.graphics.rectangle("fill", 8, 80, 144, 56)
    love.graphics.setColor(0, 0, 0, 1)
    for i, code in ipairs(payload.codes) do
      Font.drawCode(code, 72 + ((i - 1) % 8) * 8,
        24 + math.floor((i - 1) / 8) * 8)
    end
    Font.draw("HT 205′57″", 72, 48)
    Font.draw("WT 4485.5lb", 72, 64)
    love.graphics.setColor(1, 1, 1, 1)
  end

  PokedexMenu._g1gpp197OriginalNew =
    PokedexMenu._g1gpp197OriginalNew or PokedexMenu.new
  local originalPokedexNew = PokedexMenu._g1gpp197OriginalNew
  PokedexMenu.new = function(game, opts)
    local def = game and game.data and game.data.pokemon
      and game.data.pokemon[SPECIES]
    if not def then return originalPokedexNew(game, opts) end
    local dex = def.dex
    def.dex = 0
    local ok, result = pcall(originalPokedexNew, game, opts)
    def.dex = dex
    if not ok then error(result, 0) end
    return result
  end

  mod.hooks:wrap("battle.caught_marker_visible", function(next, battle)
    if not (battle and battle.enemy and isSpecies(battle.enemy.mon)) then
      return next(battle)
    end
    local dex = dexTables(battle.game)
    return dex and dex.owned[SPECIES] == true or false
  end)

  mod.events:on("game.ready", function(ev)
    local game = ev and ev.game
    local def = game and game.data and game.data.pokemon
      and game.data.pokemon[SPECIES]
    if def and def.baseStats then def.baseStats.attack = 0 end
    logger:log("GLITCH 197 INSTALLED",
      "registered=" .. logger:safeField(def ~= nil)
        .. " index=197 displayDex=250 attack=0 catchRate=23 baseExp=17"
        .. " cryBase=RHYHORN rawSfxPointer=08:6040 pitch=47 length=CB"
        .. " iconClass=0C nameRaw=21_14_4A_CD_49_3C_21_7B_CF_7D_50"
        .. " nameProjection=GLYPH21_GLYPH14_PKMN_7B_7D"
        .. " rawGrowth=37 safeGrowth=MEDIUM_FAST legacySheetsUsed=false")
  end)
  return { species = SPECIES, displayDex = 250 }
end
