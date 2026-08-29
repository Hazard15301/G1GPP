-- G1GPP late Trainer 246/247 preservation data.
--
-- Evidence sources: accepted original-Blue validator sessions
-- 20260809_112041_blue_246_247_validation (tool/server v1.5.10) for the
-- full runtime battle structs/sprites, plus the clean v1.6.1 session
-- 20260809_170503_blue_246_247_validation for raw active nicknames and
-- cry-selection provenance.
--
-- This module does NOT emulate a literal unsafe ROM overread. It encodes only
-- the party results actually validated on original Blue for 246/247 selectors.
-- Species 250 borrows the live recomp Nidorino front sprite, matching the
-- observed original-ROM appearance while retaining species-250 battle data.
-- Species 208/200/230 are generated at runtime from compact 2bpp corruption
-- patterns; no captured research PNGs are shipped in the mod package.

return function(ctx)
  local mod = assert(ctx and ctx.mod, "late_trainer_246_247 needs mod")
  local M = {}

  -- Exact cry variants needed by the validated late Agatha/Lance parties.
  -- v1.6.1 captured the *effective* SFX headers while the Elite Four battle
  -- audio engine was live in ROM bank 8. wSfxHeaderPointer is unusual: the
  -- engine stores H then L, so a capture that reads those two WRAM bytes as a
  -- normal little-endian word reports e.g. $D240 while the engine itself
  -- reconstructs HL=$40D2. These addresses below are the actual addresses the
  -- original engine dereferenced, not byte-swapped guesses.
  --
  --   MissingNo 61/87/135 -> bank 8:$403C, pitch $00, length $00
  --   181               -> bank 8:$4141, pitch $00, length $80
  --   250               -> bank 8:$403C, pitch $09, length $36
  --   208               -> raw CryData $66/$D0/$21 -> sound id $46,
  --                        bank 8:$40D2. The cry IDs are header-table byte
  --                        offsets spaced by 3; $46 is inside CRY_SFX_START..END
  --                        but is misaligned between legitimate cry headers.
  --                        Audio1_IsCry therefore remains true and $D0/$21
  --                        ARE applied to the malformed four-channel result.
  --   200               -> bank 8:$40B1, pitch $C8, length $18
  --   230               -> bank 8:$4177, pitch $3E, length $07
  --
  -- All playback is synthesized from the player's own Gen1Recomp-extracted
  -- bank-8 chip programs. No captured audio or ROM-derived sound asset ships.
  local function tracedCry(address, pitch, length)
    return {
      header = { address = address, bank = 8, engine = 2 },
      pitch = pitch, length = length,
    }
  end
  -- The four ordinary MissingNo. cry records used by these trainer parties
  -- are registered centrally by missingno_common.lua. Keeping a second copy
  -- here makes the public mod registry reject the entire mod as a duplicate.
  mod.content.cries:register("TF_OOB_250", tracedCry(0x403C, 0x09, 0x36))
  -- 208 is the important malformed case. GetCryData produces sound id $46,
  -- which is inside the broad cry-id range even though it is not aligned to
  -- a legitimate three-descriptor cry header. Preserve the original raw
  -- modifiers while Gen1Recomp's malformed-header renderer is diagnosed.
  mod.content.cries:register("TF_OOB_208", tracedCry(0x40D2, 0xD0, 0x21))
  mod.content.cries:register("TF_OOB_200", tracedCry(0x40B1, 0xC8, 0x18))
  mod.content.cries:register("TF_OOB_230", tracedCry(0x4177, 0x3E, 0x07))
  -- BattleState calls Sound.playCry(data, species), so audio.cries is keyed
  -- directly by the runtime species IDs above.

  -- Unused/glitch type bytes observed in the final runtime structs. No damage
  -- matchup behavior was established by this research session, so these are
  -- neutral transport types with the correct raw index/name rather than a
  -- fabricated effectiveness table.
  local glitchTypes = {
    { id = "TF_TYPE_0B", index = 0x0B },
    { id = "TF_TYPE_27", index = 0x27 },
    { id = "TF_TYPE_61", index = 0x61 },
    { id = "TF_TYPE_70", index = 0x70 },
    { id = "TF_TYPE_7B", index = 0x7B },
  }
  for _, t in ipairs(glitchTypes) do
    mod.content.type_chart:register(t.id, {
      name = ("0x%02X"):format(t.index), category = "physical", index = t.index,
    })
  end

  -- Raw active nickname bytes from the clean v1.6.1 session include unused
  -- values that PlaceString writes straight into the original tilemap. For
  -- bytes that live on Gen1Recomp's extracted $80-$FF font page, register a
  -- private token that draws that exact native tile. Low VRAM/control bytes
  -- are deliberately NOT executed here; doing so could scroll/retarget modern
  -- UI state. This removes normalized research labels while preserving the
  -- release-safe, directly-renderable portion of the observed byte stream.
  local rawFontCodes = { 0xC0,0xC1,0xC4,0xC6,0xCB,0xCD,0xCF,0xD7,0xEA }
  local rawToken = {}
  for _, code in ipairs(rawFontCodes) do
    local seq = ("<TF%02X>"):format(code)
    rawToken[code] = seq
    mod.content.font:register("charmap:" .. seq, { seq = seq, code = code })
  end

  -- Content-schema-safe records. Two captured base stats are zero (208 Attack,
  -- 230 Speed); those are installed as 1 here and corrected to zero after the
  -- content merge in installRuntime(), matching how G1GPP already handles
  -- exceptional ROM data through engine_internals.
  local mons = {
    {
      id = "TF_OOB_250", index = 250,
      -- Raw: 47 D7 CB C6 21 4B D7 CB C6 3E 50. $47/$21/$3E and
      -- $_CONT are dynamic tile/control effects; preserve the directly
      -- renderable native font bytes rather than the old fake "GLITCH FA".
      name = rawToken[0xD7] .. rawToken[0xCB] .. rawToken[0xC6]
          .. rawToken[0xD7] .. rawToken[0xCB] .. rawToken[0xC6],
      cry = "TF_OOB_250",
      types = { "POISON", "POISON" }, stats = {61,72,57,65,55}, catch = 120,
      moves = { "RAZOR_WIND" },
    },
    {
      id = "TF_OOB_208", index = 208,
      -- Raw: 38 4A 73 4A 06 2B CD 93 34 C0 50. The visible original
      -- presentation is dominated by the two <PK><MN> expansions and T.
      name = "<PK><MN><PK><MN> T", cry = "TF_OOB_208",
      types = { "TF_TYPE_0B", "NORMAL" }, stats = {37,1,40,178,19}, catch = 23,
      moves = { "ICE_PUNCH", "THUNDERPUNCH", "MEGA_PUNCH", "COUNTER" },
    },
    {
      id = "TF_OOB_200", index = 200,
      -- Raw: CF 3E 04 EA 94 CF CD E6 2B C1 50. Keep every byte that maps
      -- safely to an extracted font tile; low dynamic tile ids are omitted.
      name = rawToken[0xCF] .. rawToken[0xEA] .. "U" .. rawToken[0xCF]
          .. rawToken[0xCD] .. "?" .. rawToken[0xC1],
      cry = "TF_OOB_200",
      types = { "TF_TYPE_61", "TF_TYPE_27" }, stats = {179,96,209,96,21}, catch = 97,
      moves = { "AGILITY", "SOLARBEAM" },
    },
    {
      id = "TF_OOB_230", index = 230,
      -- Raw: D7 CB 77 C4 76 50. $77/$76 are on the extracted extra font
      -- page; the remaining high bytes use their exact native tiles.
      name = rawToken[0xD7] .. rawToken[0xCB] .. "ぇ" .. rawToken[0xC4] .. "ぁ",
      cry = "TF_OOB_230",
      types = { "TF_TYPE_7B", "TF_TYPE_70" }, stats = {19,114,114,1,20}, catch = 65,
      moves = { "SWORDS_DANCE", "POISON_STING", "MEGA_KICK", "HORN_DRILL" },
    },
  }

  for _, p in ipairs(mons) do
    mod.content.pokemon:register(p.id, {
      id = p.id, index = p.index, name = p.name, dex = 152,
      dexEntry = { heightFt = 0, heightIn = 0, kind = "", weight = 0,
                   text = "_TrainerFlyMissingNoBlankDex" },
      types = p.types,
      baseStats = { hp=p.stats[1], attack=p.stats[2], defense=p.stats[3],
                    speed=p.stats[4], special=p.stats[5] },
      catchRate = p.catch, baseExp = 0, growthRate = "MEDIUM_FAST",
      cry = p.cry,
      level1Moves = p.moves, learnset = {}, tmhm = {}, evolutions = {},
      -- Safe startup fallback. installRuntime replaces 250 with the imported
      -- Nidorino art and assigns transform-generated fronts to 200/208/230.
      spriteFront = "save/mod-derived/g1gpp/battle/front/g1gpp_missingno.png",
      spriteBack = "save/mod-derived/g1gpp/battle/back/g1gpp_missingno.png",
      frontSize = 7, palette = "MEWMON",
    })
    mod.content.icons:register(p.id, "MON")
  end

  local function copyTable(t)
    local out = {}
    for k, v in pairs(t or {}) do
      if type(v) == "table" then out[k] = copyTable(v) else out[k] = v end
    end
    return out
  end

  local invalidMoves = {
    { id="TF_MOVE_F2", index=0xF2, name="GLITCH F2", pp=27 },
    { id="TF_MOVE_EA", index=0xEA, name="GLITCH EA", pp=3 },
    { id="TF_MOVE_D3", index=0xD3, name="GLITCH D3", pp=21 },
    { id="TF_MOVE_E4", index=0xE4, name="GLITCH E4", pp=54 % 64 },
    { id="TF_MOVE_CD", index=0xCD, name="GLITCH CD", pp=33 % 64 },
  }

  -- Sprite images are generated by assets_transform.lua from deterministic
  -- geometry or borrowed from the player-owned imported cache.

  local function findPokemon(game, id, name)
    local data = game and game.data and game.data.pokemon or {}
    if data[id] then return data[id] end
    for _, def in pairs(data) do
      if def and def.name == name then return def end
    end
    return nil
  end

  function M.installRuntime(game)
    if not (game and game.data and game.data.pokemon) then
      return false, "game_data_unavailable"
    end
    local status = { nidorino = false, generated = {},
      nameCryEvidence = "v1.6.1", cry208Header = "08:40D2", cryPath = "direct_bank8_headers",
      cry208Raw = "66/D0/21", cry208SoundId = "46",
      cry208Effective = "misaligned_cry_D0_21" }

    -- Restore the two genuine zero base-stat bytes that the public content
    -- schema cannot express.
    if game.data.pokemon.TF_OOB_208 then
      game.data.pokemon.TF_OOB_208.baseStats.attack = 0
    end
    if game.data.pokemon.TF_OOB_230 then
      game.data.pokemon.TF_OOB_230.baseStats.speed = 0
    end

    -- Species 250's validated sprite is ordinary Nidorino graphics. Borrow the
    -- live imported game's own Nidorino front asset/palette rather than carrying
    -- a duplicate image. Identity/stats/types/moves remain species 250's.
    local donor = findPokemon(game, "NIDORINO", "NIDORINO")
    local p250 = game.data.pokemon.TF_OOB_250
    if donor and p250 then
      p250.spriteFront = donor.spriteFront
      p250.frontSize = donor.frontSize or p250.frontSize
      p250.palette = donor.palette or p250.palette
      status.nidorino = true
    end

    -- Assign the three transform-generated, release-safe approximations.
    for _, index in ipairs({ 200, 208, 230 }) do
      local id = ("TF_OOB_%03d"):format(index)
      local def = game.data.pokemon[id]
      if def then
        def.spriteFront = "save/mod-derived/g1gpp/battle/front/g1gpp_species_"
          .. tostring(index) .. ".png"
        status.generated[index] = "transform"
      end
    end

    -- The final session proves the raw invalid move bytes but not their full
    -- out-of-table move effects. Give them safe inert runtime definitions so
    -- the exact four move slots can exist without inventing harmful behavior.
    local moves = game.data.moves or {}
    local template = moves.SPLASH or moves.GROWL or moves.LEER or moves.TACKLE
    if template then
      for _, row in ipairs(invalidMoves) do
        if not moves[row.id] then
          local def = copyTable(template)
          def.id, def.index, def.name = row.id, row.index, row.name
          def.power, def.accuracy, def.pp = 0, 100, row.pp
          moves[row.id] = def
        end
      end
    end

    if p250 then p250.level1Moves = { "RAZOR_WIND", "TF_MOVE_F2", "TF_MOVE_EA", "TF_MOVE_D3" } end
    local p200 = game.data.pokemon.TF_OOB_200
    if p200 then p200.level1Moves = { "TF_MOVE_E4", "AGILITY", "TF_MOVE_CD", "SOLARBEAM" } end
    return true, status
  end

  local function slot(level, species) return { level = level, species = species } end

  function M.curatedParty(classIndex, trainerSet, pokemonByIndex)
    if classIndex == 46 and trainerSet == 3 or classIndex == 47 and trainerSet == 2 then
      return {
        slot(167, "TF_OOB_250"), slot(167, "TF_GLITCH_087"),
        slot(167, "TF_OOB_208"), slot(167, "TF_GLITCH_061"),
        slot(167, "TF_OOB_200"), slot(167, "TF_OOB_250"),
      }, 48, "first_oob"
    end
    if classIndex == 46 and trainerSet == 7 then
      local p = pokemonByIndex or {}
      if not (p[58] and p[84] and p[93] and p[33]) then return nil end
      return {
        slot(205, "TF_GLITCH_135"), slot(205, p[58]), slot(205, p[84]),
        slot(205, p[93]), slot(205, p[33]), slot(205, "TF_OOB_230"),
      }, 48, "deep_oob"
    end
    if classIndex == 47 and trainerSet == 7 then
      return { slot(205, "TF_GLITCH_181") }, 48, "deep_oob_single"
    end
    return nil
  end

  return M
end
