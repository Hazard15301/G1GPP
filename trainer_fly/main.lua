-- Gen 1 Glitch Preservation Project (G1GPP) v1.1.0-beta1-glitchcity12.13.25-camera-local-glyph-drift
--
-- Milestone:
--   * Preserve the vanilla trainer "!" and approach state while StartMenu is open.
--   * Teleport cleanly abandons that pending approach while retaining the glitch.
--   * Capture the last opposing battler's live Special stat during the
--     intermediary trainer battle (including Transform/stat changes).
--   * Resolve that value through Gen1Recomp's preserved Gen-I internal index.
--   * After that battle, re-entering the escaped trainer's map forces StartMenu.
--   * Closing that forced menu starts the resolved level-7 encounter.
--
-- This is a self-contained runtime patch using engine_internals. No game files
-- are replaced on disk.

-- Embedded generated encounter data.
-- The installed mod loader could not reliably open a secondary Lua file,
-- so v1.0.1 keeps the runtime table inside main.lua.
local TrainerFlyEncounterData = (function()
  local Data = {}

  Data.glitchPokemon = {
    [31] = {
      id = "TF_GLITCH_031",
      index = 31,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_031_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [32] = {
      id = "TF_GLITCH_032",
      index = 32,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_032_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [50] = {
      id = "TF_GLITCH_050",
      index = 50,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_050_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [52] = {
      id = "TF_GLITCH_052",
      index = 52,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_052_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [56] = {
      id = "TF_GLITCH_056",
      index = 56,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_056_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [61] = {
      id = "TF_GLITCH_061",
      index = 61,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_061_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [62] = {
      id = "TF_GLITCH_062",
      index = 62,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_062_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [63] = {
      id = "TF_GLITCH_063",
      index = 63,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_063_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [67] = {
      id = "TF_GLITCH_067",
      index = 67,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_067_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [68] = {
      id = "TF_GLITCH_068",
      index = 68,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_068_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [69] = {
      id = "TF_GLITCH_069",
      index = 69,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_069_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [79] = {
      id = "TF_GLITCH_079",
      index = 79,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_079_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [80] = {
      id = "TF_GLITCH_080",
      index = 80,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_080_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [81] = {
      id = "TF_GLITCH_081",
      index = 81,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_081_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [86] = {
      id = "TF_GLITCH_086",
      index = 86,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_086_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [87] = {
      id = "TF_GLITCH_087",
      index = 87,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_087_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [94] = {
      id = "TF_GLITCH_094",
      index = 94,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_094_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [95] = {
      id = "TF_GLITCH_095",
      index = 95,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_095_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [115] = {
      id = "TF_GLITCH_115",
      index = 115,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_115_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [121] = {
      id = "TF_GLITCH_121",
      index = 121,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_121_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [122] = {
      id = "TF_GLITCH_122",
      index = 122,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_122_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [127] = {
      id = "TF_GLITCH_127",
      index = 127,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_127_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [134] = {
      id = "TF_GLITCH_134",
      index = 134,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_134_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [135] = {
      id = "TF_GLITCH_135",
      index = 135,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_135_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [137] = {
      id = "TF_GLITCH_137",
      index = 137,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_137_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [140] = {
      id = "TF_GLITCH_140",
      index = 140,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_140_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [146] = {
      id = "TF_GLITCH_146",
      index = 146,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_146_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [156] = {
      id = "TF_GLITCH_156",
      index = 156,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_156_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [159] = {
      id = "TF_GLITCH_159",
      index = 159,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_159_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [160] = {
      id = "TF_GLITCH_160",
      index = 160,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_160_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [161] = {
      id = "TF_GLITCH_161",
      index = 161,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_161_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [162] = {
      id = "TF_GLITCH_162",
      index = 162,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_162_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [172] = {
      id = "TF_GLITCH_172",
      index = 172,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_172_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [174] = {
      id = "TF_GLITCH_174",
      index = 174,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_174_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [175] = {
      id = "TF_GLITCH_175",
      index = 175,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_175_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
    [181] = {
      id = "TF_GLITCH_181",
      index = 181,
      name = "MISSINGNO.",
      sprite = "assets/glitch/index_181_front.png",
      spriteSha1 = "35b4ecc245d5baa7bad87c8d507ff94ede8f5e22",
      sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
      observed = {
        types = { "BIRD", "NORMAL" },
        catchRate = 29,
        moves = { "WATER_GUN", "SKY_ATTACK" },
      },
    },
  [182] = {
    id = "TF_GLITCH_182",
    index = 182,
    name = "MISSINGNO.",
    specialForm = "fossil_kabutops",
    sprite = "assets/glitch/index_182_front.png",
    spriteSha1 = "52c9fb65cfbfcfc19f40f877e2726ebe5c8d9d1f",
    sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
    observed = {
      types = { "FIRE", "FIRE" },
      catchRate = 45,
      moves = { "WATER_GUN", "SKY_ATTACK" },
    },
  },
  [183] = {
    id = "TF_GLITCH_183",
    index = 183,
    name = "MISSINGNO.",
    specialForm = "fossil_aerodactyl",
    sprite = "assets/glitch/index_183_front.png",
    spriteSha1 = "2b8103ce478b79931f4a9264602e3ee01fb76b8d",
    sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
    observed = {
      types = { "FIRE", "FIRE" },
      catchRate = 45,
      moves = { "WATER_GUN", "SKY_ATTACK" },
    },
  },
  [184] = {
    id = "TF_GLITCH_184",
    index = 184,
    name = "MISSINGNO.",
    specialForm = "ghost",
    sprite = "assets/glitch/index_184_front.png",
    spriteSha1 = "7e97aa3a22bf5399addfefd90b615428dae171cf",
    sourceNameHex = "8C 88 92 92 88 8D 86 8D 8E E8 50",
    observed = {
      types = { "FIRE", "FIRE" },
      catchRate = 45,
      moves = { "WATER_GUN", "SKY_ATTACK" },
    },
  },
  }

  Data.crashEffects = {
    [193] = {
      class = "blank_lock_early",
      lowHealthAlarm = true,
      message = "THE BATTLE COULD NOT\nFINISH FORMING.",
    },
    [196] = {
      class = "blank_lock_early",
      lowHealthAlarm = false,
      message = "THE BATTLE COULD NOT\nFINISH FORMING.",
    },
    [199] = {
      class = "blank_lock_early",
      lowHealthAlarm = false,
      message = "THE BATTLE COULD NOT\nFINISH FORMING.",
    },
    [248] = {
      class = "persistent_corruption",
      lowHealthAlarm = true,
      message = "THE BATTLE BECAME\nUNSTABLE.",
    },
    [249] = {
      class = "corruption_then_blank",
      lowHealthAlarm = true,
      message = "THE BATTLE BECAME\nUNSTABLE.",
    },
    [250] = {
      class = "corruption_then_blank",
      lowHealthAlarm = true,
      message = "THE BATTLE BECAME\nUNSTABLE.",
    },
    [251] = {
      class = "corruption_then_blank",
      lowHealthAlarm = true,
      message = "THE BATTLE BECAME\nUNSTABLE.",
    },
    [252] = {
      class = "white_failure",
      lowHealthAlarm = false,
      message = "THE BATTLE COULD NOT\nBE STABILIZED.",
    },
    [253] = {
      class = "corruption_then_blank",
      lowHealthAlarm = true,
      message = "THE BATTLE BECAME\nUNSTABLE.",
    },
    [254] = {
      class = "corruption_then_blank",
      lowHealthAlarm = true,
      message = "THE BATTLE BECAME\nUNSTABLE.",
    },
    [255] = {
      class = "corruption_then_blank",
      lowHealthAlarm = true,
      message = "THE BATTLE BECAME\nUNSTABLE.",
    },
  }

  function Data.resolve(index, pokemonByIndex)
    index = tonumber(index)
    if not index then
      return { kind = "invalid", index = index }
    end

    local glitch = Data.glitchPokemon[index]
    if glitch then
      return {
        kind = "pokemon",
        subtype = "glitch",
        index = index,
        species = glitch.id,
        definition = glitch,
      }
    end

    local species = pokemonByIndex and pokemonByIndex[index]
    if species then
      return {
        kind = "pokemon",
        subtype = "normal",
        index = index,
        species = species,
      }
    end

    local crash = Data.crashEffects[index]
    if crash then
      return {
        kind = "crash_effect",
        index = index,
        effect = crash,
      }
    end

    if index >= 191 and index <= 255 then
      return {
        kind = "upper_pending",
        index = index,
      }
    end

    return {
      kind = "unsupported",
      index = index,
    }
  end

  return Data
end)()

return function(mod)
  local EncounterData = TrainerFlyEncounterData

  -- Register every unused internal slot captured from Pokémon Blue as a
  -- distinct, save-safe recomp species. They share canonical MissingNo.
  -- battle data but retain their exact index-specific front graphics.
  -- Keep the recomp's internal positive dex key for schema safety, but leave
  -- the ordinary list at 001-151. Runtime presentation patches below render
  -- MissingNo. as No.000 and keep it out of the selectable index.
  mod.content.constants:patch("dexSize", 151)
  mod.content.text:register("_TrainerFlyMissingNoDex",
    "NO DATA EXISTS.\nITS FORM CHANGES\nEACH TIME IT IS\nOBSERVED.")
  -- DexEntryMenu prints its localized "Data unknown." fallback when no text
  -- key is present. A newline is intentionally non-empty data to the renderer
  -- but draws no visible description glyphs, preserving the blank RB record.
  mod.content.text:register("_TrainerFlyMissingNoBlankDex", "\n")

  for index, entry in pairs(EncounterData.glitchPokemon) do
    mod.content.pokemon:register(entry.id, {
      id = entry.id,
      index = index,
      name = entry.name,
      dex = 152,
      dexEntry = {
        -- Red/Blue's No.000 record has real measurements even though its
        -- description is blank: 10'0" and 3507.2 lb. Presentation mode may
        -- replace only the description; canonical data stays identical.
        heightFt = 10, heightIn = 0, kind = "", weight = 35072,
        text = "_TrainerFlyMissingNoDex",
      },
      types = entry.observed.types,
      baseStats = {
        hp = 33, attack = 136, defense = 0, speed = 29, special = 6,
      },
      catchRate = entry.observed.catchRate,
      baseExp = 0,
      growthRate = "MEDIUM_FAST",
      -- Normal Red/Blue MissingNo. really owns two separate Water Gun slots.
      -- Special Fossil/Ghost forms (182-184) are contextual and must not use
      -- this fixed record; their later fidelity pass will borrow valid data.
      level1Moves = index <= 181
        and { "WATER_GUN", "WATER_GUN", "SKY_ATTACK" }
        or entry.observed.moves,
      learnset = {},
      -- Red/Blue normal MissingNo.'s TM/HM flags come from the wrapped
      -- No.000 base-data lookup rather than a real species record. Register
      -- the exact decoded move list only on those two versions.
      -- Yellow and the contextual Fossil/Ghost forms remain isolated for
      -- their own later fidelity passes.
      tmhm = (function()
        if index > 181 then return {} end
        local loaded, GameVersion = pcall(require, "src.core.GameVersion")
        if not loaded or type(GameVersion) ~= "table"
            or type(GameVersion.get) ~= "function" then return {} end
        local gotVersion, version = pcall(GameVersion.get)
        if not gotVersion or (version ~= "red" and version ~= "blue") then
          return {}
        end
        return {
          "MEGA_PUNCH", "RAZOR_WIND", "SWORDS_DANCE", "MEGA_KICK",
          "TOXIC", "TAKE_DOWN", "DOUBLE_EDGE", "BUBBLEBEAM",
          "ICE_BEAM", "BLIZZARD", "SUBMISSION", "SEISMIC_TOSS", "RAGE",
          "THUNDER", "EARTHQUAKE", "FISSURE", "PSYCHIC_M", "TELEPORT",
          "SKY_ATTACK", "REST", "THUNDER_WAVE", "TRI_ATTACK", "CUT", "FLY",
        }
      end)(),
      evolutions = {},
      cry = "NIDORAN_M",
      spriteFront = mod.assets:path(entry.sprite),
      spriteBack = mod.assets:path("assets/glitch/missingno_back.png"),
      frontSize = 7,
      palette = "MEWMON",
    })
    mod.content.icons:register(entry.id, "MON")
  end

  mod.options:define({
    { key = "missingno_presentation", label = "MISSINGNO. ENTRY",
      type = "choice", default = "LORE_FRIENDLY",
      choices = {
        { "LORE-FRIENDLY", "LORE_FRIENDLY" },
        { "ENHANCED", "ENHANCED" },
      } },
    { key = "timing_mode", label = "TIMING MODE",
      type = "choice", default = "RELAXED",
      choices = {
        { "STRICT", "STRICT" },
        { "RELAXED", "RELAXED" },
        { "EASY", "EASY" },
      } },
    { key = "debug_special_enabled", label = "DEBUG SPECIAL",
      type = "toggle", default = false },
    { key = "debug_special_value", label = "SPECIAL VALUE",
      type = "number", default = 21, min = 0, max = 255, step = 1 },
    { key = "debug_attack_modifier", label = "ATTACK MOD",
      type = "number", default = 7, min = 1, max = 13, step = 1 },
    { key = "debug_start_battle", label = "START TEST BATTLE",
      type = "toggle", default = false },
    { key = "debug_start_glitch_city", label = "START GLITCH CITY",
      type = "toggle", default = false },
    { key = "debug_inverted_sprites", label = "TEST INVERTED SPRITES",
      type = "toggle", default = false },
    { key = "debug_add_master_ball", label = "ADD MASTER BALL",
      type = "toggle", default = false },
    { key = "debug_add_tmhm_test_kit", label = "ADD TM/HM TEST KIT",
      type = "toggle", default = false },
    { key = "debug_cubone_seen", label = "CUBONE SEEN FLAG",
      type = "toggle", default = false },
    { key = "debug_wipe_missingno", label = "WIPE MISSINGNO STATE",
      type = "toggle", default = false },
    { key = "debug_warp_anywhere", label = "WARP ANYWHERE",
      type = "toggle", default = false },
    { key = "quick_warp_set", label = "SET WARP POINT",
      type = "toggle", default = false },
    { key = "quick_warp_clear", label = "CLEAR WARP POINT",
      type = "toggle", default = false },
    { key = "debug_log_snapshot", label = "WRITE DEBUG SNAPSHOT",
      type = "toggle", default = false },
    { key = "debug_log_clear", label = "CLEAR DEBUG LOG",
      type = "toggle", default = false },
  })

  local TIMING_WINDOWS = {
    STRICT = 1,
    RELAXED = 3,
    EASY = 5,
  }

  local function timingMode()
    local mode = tostring(
      mod.options:get("timing_mode") or "RELAXED"
    ):upper()

    if not TIMING_WINDOWS[mode] then
      mode = "RELAXED"
    end

    return mode
  end

  local function timingWindow()
    return TIMING_WINDOWS[timingMode()] or 3
  end

  local function debugSettings()
    local enabled = mod.options:get("debug_special_enabled") == true
    local value = tonumber(mod.options:get("debug_special_value")) or 21
    local attackModifier =
      tonumber(mod.options:get("debug_attack_modifier")) or 7
    value = math.max(0, math.min(255, math.floor(value)))
    attackModifier =
      math.max(1, math.min(13, math.floor(attackModifier)))
    return enabled, value, attackModifier
  end

  local Overworld = require("src.world.OverworldController")
  local Player = require("src.world.Player")
  local Screens = require("src.ui.Screens")

  local ManagerState = require("src.mods.ManagerState")
  local Font = require("src.render.Font")
  local Sound = require("src.core.Sound")
  local Music = require("src.core.Music")
  local TextBox = require("src.render.TextBox")
  local BattleState = require("src.battle.BattleState")
  local SummaryMenu = require("src.ui.SummaryMenu")
  local DexEntryMenu = require("src.ui.DexEntryMenu")
  local PokedexMenu = require("src.ui.PokedexMenu")
  local Bag = require("src.inventory.Bag")
  local ListMenu = require("src.ui.ListMenu")
  ManagerState.G1 = {
    Theme = require("src.ui.Theme"),
    OptionRows = require("src.ui.OptionRows"),
    Pokemon = require("src.pokemon.Pokemon"),
    Stats = require("src.pokemon.Stats"),
    Growth = require("src.pokemon.Growth"),
    marqueeKey = nil,
    marqueeStartedAt = 0,
  }

  local game
  local activeWorld
  local quickWarpPoint = nil
  local debugTestBattlePending = false
  local debugGlitchCityPending = false
  local setQuickWarpPoint
  local clearQuickWarpPoint
  local performQuickWarp
  local quickWarpMenuPending = false
  local quickWarpConfirmPending = false
  local quickWarpHotkeyArmed = false
  local warpAnywherePending = nil
  local openWarpAnywhereMenu
  local performWarpAnywhere
  -- Declare the Trainer-Fly transient state before debug-warp closures so
  -- those closures clear the intended locals rather than same-named globals.
  local escape = nil
  local intermediaryBattle = nil
  local capturedSpecial = nil
  local capturedAttackModifier = nil
  local capturedEnemySpecies = nil
  local pokemonByIndex = {}
  local forceMenuPending = false
  local forcedMenu = nil
  local startPressAge = 9999

  -- Persistent diagnostics live in a separate module so main.lua remains
  -- an entry/wiring surface instead of accumulating locals indefinitely.
  -- Load through love.filesystem using the mod root exposed by Gen1Recomp;
  -- this works for both unpacked development mods and ZIP-mounted mods.
  local debugLogger = assert(love.filesystem.load(
    mod.path .. "/modules/debug_logger.lua"))({
      buildVersion = "1.1.0-beta1-missingno12.13.52-modular-debug-logger",
      logDir = "trainer_fly",
      maxBytes = 1024 * 1024,
      driveMirrorEnabled = true,
      driveMirrorFile = [[G:\My Drive\Glitch Project\Project Documentation\g1gpp_debug.log]],
    })
  local debugGameLoadedMarked = false
  local playerStateSummary

  -- Gen1Recomp correctly deduplicates ordinary starting moves. Red/Blue's
  -- normal MissingNo. records are a narrow ROM-data exception: their first
  -- three slots are WATER GUN / WATER GUN / SKY ATTACK. Wrap only the shared
  -- move-list helper, only for our normal MissingNo. IDs, and only on Red or
  -- Blue. Yellow and the contextual Fossil/Ghost forms keep the native path.
  if not ManagerState.G1.Pokemon._g1gppOriginalMovesAtLevel then
    ManagerState.G1.Pokemon._g1gppOriginalMovesAtLevel =
      ManagerState.G1.Pokemon.movesAtLevel
  end
  ManagerState.G1.Pokemon.movesAtLevel = function(speciesDef, level)
    local loaded, GameVersion = pcall(require, "src.core.GameVersion")
    local gotVersion, version = false, nil
    if loaded and type(GameVersion) == "table"
        and type(GameVersion.get) == "function" then
      gotVersion, version = pcall(GameVersion.get)
    end
    local speciesId = speciesDef and speciesDef.id
    local index = type(speciesId) == "string"
      and tonumber(speciesId:match("^TF_GLITCH_(%d+)$")) or nil
    if gotVersion and (version == "red" or version == "blue")
        and index and index <= 181
        and speciesDef.name == "MISSINGNO." then
      debugLogger:log("MISSINGNO MOVESET PRESERVED",
        "species=" .. debugLogger:safeField(speciesId)
          .. " level=" .. debugLogger:safeField(level)
          .. " gameVersion=" .. debugLogger:safeField(version)
          .. " moves=WATER_GUN,WATER_GUN,SKY_ATTACK"
          .. " globalDeduplicationChanged=false")
      return { "WATER_GUN", "WATER_GUN", "SKY_ATTACK" }
    end
    return ManagerState.G1.Pokemon._g1gppOriginalMovesAtLevel(
      speciesDef, level)
  end

  -- MissingNo.'s inverted-sprite side effect is a volatile RAM condition on
  -- the original hardware. Keep the recomp recreation equally temporary: it
  -- is never written to SaveData or any Pokémon record and dies with the
  -- process. Viewing ordinary Pokémon data clears it through the same screens
  -- that clear wSpriteFlipped in Generation I.
  local invertedSpriteState = {
    active = false,
    activationCount = 0,
    recoveryCount = 0,
    affectedBattles = 0,
    sourceSpecies = nil,
    sourceScreen = nil,
  }

  local function isMissingNoSpecies(data, species)
    local def = data and data.pokemon and data.pokemon[species]
    return type(species) == "string"
      and species:match("^TF_GLITCH_%d+$") ~= nil
      and def ~= nil
      and def.name == "MISSINGNO."
  end

  ManagerState.G1.MissingNoState = ManagerState.G1.MissingNoState or {}

  function ManagerState.G1.MissingNoState.count(save, data)
    local total = 0
    for _, mon in ipairs((save and save.party) or {}) do
      if isMissingNoSpecies(data, mon and mon.species) then total = total + 1 end
    end
    for _, box in ipairs((save and save.boxes) or {}) do
      for _, mon in ipairs(box or {}) do
        if isMissingNoSpecies(data, mon and mon.species) then total = total + 1 end
      end
    end
    local daycare = save and save.daycare
    if daycare and isMissingNoSpecies(data,
        daycare.mon and daycare.mon.species) then
      total = total + 1
    end
    for _, mon in ipairs((save and save.orphaned
        and save.orphaned.mons) or {}) do
      if isMissingNoSpecies(data, mon and mon.species) then total = total + 1 end
    end
    return total
  end

  function ManagerState.G1.MissingNoState.countSpecies(save, data, species)
    if not isMissingNoSpecies(data, species) then return 0 end
    local total = 0
    for _, mon in ipairs((save and save.party) or {}) do
      if mon and mon.species == species then total = total + 1 end
    end
    for _, box in ipairs((save and save.boxes) or {}) do
      for _, mon in ipairs(box or {}) do
        if mon and mon.species == species then total = total + 1 end
      end
    end
    local daycare = save and save.daycare
    if daycare and daycare.mon and daycare.mon.species == species then
      total = total + 1
    end
    for _, mon in ipairs((save and save.orphaned
        and save.orphaned.mons) or {}) do
      if mon and mon.species == species then total = total + 1 end
    end
    return total
  end

  function ManagerState.G1.MissingNoState.wipe(save, data)
    local removed = { party = 0, boxes = 0, daycare = 0, orphaned = 0,
      seen = 0, owned = 0 }
    if not save then return removed end

    for i = #(save.party or {}), 1, -1 do
      if isMissingNoSpecies(data, save.party[i] and save.party[i].species) then
        table.remove(save.party, i)
        removed.party = removed.party + 1
      end
    end
    for _, box in ipairs(save.boxes or {}) do
      for i = #(box or {}), 1, -1 do
        if isMissingNoSpecies(data, box[i] and box[i].species) then
          table.remove(box, i)
          removed.boxes = removed.boxes + 1
        end
      end
    end
    if save.daycare and isMissingNoSpecies(data,
        save.daycare.mon and save.daycare.mon.species) then
      save.daycare.mon = nil
      removed.daycare = 1
    end
    if save.orphaned and type(save.orphaned.mons) == "table" then
      for i = #save.orphaned.mons, 1, -1 do
        local mon = save.orphaned.mons[i]
        if isMissingNoSpecies(data, mon and mon.species) then
          table.remove(save.orphaned.mons, i)
          removed.orphaned = removed.orphaned + 1
        end
      end
    end

    save.pokedex = save.pokedex or {}
    save.pokedex.seen = save.pokedex.seen or {}
    save.pokedex.owned = save.pokedex.owned or {}
    for species in pairs((data and data.pokemon) or {}) do
      if isMissingNoSpecies(data, species) then
        if save.pokedex.seen[species] then removed.seen = removed.seen + 1 end
        if save.pokedex.owned[species] then removed.owned = removed.owned + 1 end
        save.pokedex.seen[species] = nil
        save.pokedex.owned[species] = nil
      end
    end
    -- No.000 shares Cubone's seen bit on the original. This debug reset is
    -- intentionally a complete test-fixture reset, but never removes Cubone.
    save.pokedex.seen.CUBONE = nil

    invertedSpriteState.active = false
    invertedSpriteState.sourceSpecies = nil
    invertedSpriteState.sourceScreen = nil
    return removed
  end

  local function missingNoPresentationMode()
    local mode = tostring(mod.options:get("missingno_presentation")
      or "LORE_FRIENDLY"):upper()
    if mode ~= "ENHANCED" then mode = "LORE_FRIENDLY" end
    return mode
  end

  local function cuboneSeen(save)
    return save and save.pokedex and save.pokedex.seen
      and save.pokedex.seen.CUBONE == true
  end

  local function convertCapturedMissingNoToRhydon(pending)
    local mon = pending and pending.mon
    local captureGame = pending and pending.game
    local data = captureGame and captureGame.data
    local save = captureGame and captureGame.save
    local rhydon = data and data.pokemon and data.pokemon.RHYDON
    if not (mon and rhydon) then
      debugLogger:log("RHYDON GLITCH CONVERSION FAILED",
        "reason=record_or_rhydon_unavailable originalSpecies="
          .. debugLogger:safeField(pending and pending.originalSpecies))
      return false
    end

    local originalSpecies = pending.originalSpecies
    local level = math.max(1, math.floor(tonumber(mon.level) or 1))
    local oldHp = tonumber(mon.hp) or 1
    local newMoves = {}
    for _, moveId in ipairs(
        ManagerState.G1.Pokemon.movesAtLevel(rhydon, level)) do
      local moveDef = data.moves and data.moves[moveId]
      newMoves[#newMoves + 1] = {
        id = moveId,
        pp = moveDef and moveDef.pp or 0,
      }
    end

    mon.species = "RHYDON"
    mon.exp = ManagerState.G1.Growth.expForLevel(
      rhydon.growthRate, level, data.growth_rates)
    mon.moves = newMoves
    mon.stats = ManagerState.G1.Stats.calc(
      rhydon, level, mon.dvs or {}, mon.statExp)
    mon.hp = math.max(1, math.min(oldHp, mon.stats.hp))
    mon.catchRate = rhydon.catchRate

    -- Reconcile the safe recomp ownership bit with the actual stored records.
    -- A converted capture must not erase species-wide ownership while another
    -- MissingNo. of this exact form remains in party, PC, Day Care, or orphaned
    -- storage. This also keeps other mods that read the canonical owned table
    -- (such as caught-indicator features) in sync without a direct dependency.
    local remainingOriginal = ManagerState.G1.MissingNoState.countSpecies(
      save, data, originalSpecies)
    if save and save.pokedex then
      if save.pokedex.owned then
        save.pokedex.owned[originalSpecies] = remainingOriginal > 0
          and true or nil
      end
      if save.pokedex.seen then
        save.pokedex.seen[originalSpecies] = remainingOriginal > 0
          and true or nil
        save.pokedex.seen.CUBONE = true
      end
    end

    debugLogger:log("RHYDON GLITCH CONVERSION COMPLETE",
      "originalSpecies=" .. debugLogger:safeField(originalSpecies)
        .. " resultSpecies=RHYDON level=" .. debugLogger:safeField(level)
        .. " moves=" .. debugLogger:safeField(#newMoves)
        .. " cuboneSeen=true hp=" .. debugLogger:safeField(mon.hp)
        .. "/" .. debugLogger:safeField(mon.stats and mon.stats.hp)
        .. " remainingOriginal=" .. debugLogger:safeField(remainingOriginal)
        .. " ownershipRetained=" .. debugLogger:safeField(remainingOriginal > 0)
        .. " saveSchemaMutation=false")
    mod.log:info(
      "G1GPP safely converted caught %s to Rhydon after No.000 page",
      tostring(originalSpecies))
    return true
  end

  -- No.000's capture flag overlaps Cubone's seen flag in Generation I. When
  -- Cubone is already seen, make the stock capture path treat this preserved
  -- MissingNo. as previously registered so it skips both the announcement and
  -- entry page. When Cubone is unseen, remember the caught record and set the
  -- overlapping flag; buildScreen below performs the conversion only after
  -- the resulting No.000 page has actually closed.
  BattleState._g1gppOriginalStoreCaughtMon =
    BattleState._g1gppOriginalStoreCaughtMon or BattleState.storeCaughtMon
  local originalStoreCaughtMon = BattleState._g1gppOriginalStoreCaughtMon
  function BattleState:storeCaughtMon()
    local captureGame = self.game
    local mon = self.enemy and self.enemy.mon
    local species = mon and mon.species
    if not isMissingNoSpecies(captureGame and captureGame.data, species) then
      return originalStoreCaughtMon(self)
    end

    local save = captureGame and captureGame.save
    local dex = save and save.pokedex
    local wasSeen = cuboneSeen(save)
    debugLogger:log("MISSINGNO CAPTURE FLAG CHECK",
      "species=" .. debugLogger:safeField(species)
        .. " cuboneSeen=" .. debugLogger:safeField(wasSeen)
        .. " outcome=" .. (wasSeen and "skip_page_retain_missingno"
          or "show_page_convert_rhydon"))

    if wasSeen then
      dex.owned = dex.owned or {}
      dex.owned[species] = true
      debugLogger:log("MISSINGNO CAPTURE PAGE SKIPPED",
        "species=" .. debugLogger:safeField(species)
          .. " reason=cubone_seen conversion=false")
      return originalStoreCaughtMon(self)
    end

    -- The recomp's safe internal MissingNo. ownership bit must not override
    -- the authentic shared No.000/Cubone gate. This also makes the debug reset
    -- usable on a save that has already caught one of our preserved forms.
    dex.owned = dex.owned or {}
    dex.seen = dex.seen or {}
    dex.owned[species] = nil
    dex.seen[species] = nil
    dex.seen.CUBONE = true
    self._g1gppRhydonCapturePending = {
      mon = mon,
      game = captureGame,
      originalSpecies = species,
    }
    debugLogger:log("MISSINGNO CAPTURE PAGE ARMED",
      "species=" .. debugLogger:safeField(species)
        .. " cuboneSeenBefore=false cuboneSeenAfter=true conversion=pending")
    return originalStoreCaughtMon(self)
  end

  BattleState._g1gppOriginalBuildScreen =
    BattleState._g1gppOriginalBuildScreen or BattleState.buildScreen
  local originalBattleBuildScreen = BattleState._g1gppOriginalBuildScreen
  function BattleState:buildScreen(id, ...)
    local pending = self._g1gppRhydonCapturePending
    if id ~= "DexEntryMenu" or not pending then
      return originalBattleBuildScreen(self, id, ...)
    end
    self._g1gppRhydonCapturePending = nil
    local args = { ... }
    local priorDone = args[2]
    args[2] = function()
      convertCapturedMissingNoToRhydon(pending)
      if type(priorDone) == "function" then priorDone() end
    end
    debugLogger:log("RHYDON GLITCH PAGE CONSTRUCTED",
      "species=" .. debugLogger:safeField(pending.originalSpecies)
        .. " conversionTiming=after_page_close")
    return originalBattleBuildScreen(self, id, unpack(args))
  end

  local function invertedSpriteSummary()
    return "active=" .. debugLogger:safeField(invertedSpriteState.active)
      .. " sourceSpecies=" .. debugLogger:safeField(invertedSpriteState.sourceSpecies)
      .. " sourceScreen=" .. debugLogger:safeField(invertedSpriteState.sourceScreen)
      .. " activations=" .. debugLogger:safeField(invertedSpriteState.activationCount)
      .. " recoveries=" .. debugLogger:safeField(invertedSpriteState.recoveryCount)
      .. " affectedBattles=" .. debugLogger:safeField(invertedSpriteState.affectedBattles)
  end

  local function activateInvertedSprites(species, source)
    local alreadyActive = invertedSpriteState.active
    invertedSpriteState.active = true
    invertedSpriteState.activationCount = invertedSpriteState.activationCount + 1
    invertedSpriteState.sourceSpecies = species or "debug"
    invertedSpriteState.sourceScreen = source or "unknown"
    debugLogger:log(alreadyActive and "INVERTED SPRITES REARMED"
      or "INVERTED SPRITES ACTIVATED",
      invertedSpriteSummary())
  end

  local function recoverInvertedSprites(species, source)
    if not invertedSpriteState.active then return end
    invertedSpriteState.active = false
    invertedSpriteState.recoveryCount = invertedSpriteState.recoveryCount + 1
    debugLogger:log("INVERTED SPRITES RECOVERED",
      "normalSpecies=" .. debugLogger:safeField(species)
        .. " recoveryScreen=" .. debugLogger:safeField(source)
        .. " " .. invertedSpriteSummary())
    invertedSpriteState.sourceSpecies = nil
    invertedSpriteState.sourceScreen = nil
  end

  local function observePokemonDataScreen(screen, screenGame, species)
    local data = screenGame and screenGame.data
    if isMissingNoSpecies(data, species) then
      activateInvertedSprites(species, screen)
    else
      recoverInvertedSprites(species, screen)
    end
  end

  -- Constructor patches are deliberately narrow. They observe the exact
  -- moment a real status or Pokédex page is opened, then allow the recomp to
  -- build and display that screen normally.
  SummaryMenu._g1gppOriginalNew = SummaryMenu._g1gppOriginalNew
    or SummaryMenu.new
  local originalSummaryMenuNew = SummaryMenu._g1gppOriginalNew
  SummaryMenu.new = function(screenGame, mon)
    observePokemonDataScreen("summary", screenGame, mon and mon.species)
    return originalSummaryMenuNew(screenGame, mon)
  end

  -- SummaryMenu reads the live species definition on every draw. Temporarily
  -- expose the authentic display number while drawing MissingNo., then restore
  -- the schema-safe internal value before any other system can observe it.
  SummaryMenu._g1gppOriginalDraw = SummaryMenu._g1gppOriginalDraw
    or SummaryMenu.draw
  local originalSummaryMenuDraw = SummaryMenu._g1gppOriginalDraw
  function SummaryMenu:draw()
    local species = self.mon and self.mon.species
    local def = self.game and self.game.data and self.game.data.pokemon
      and self.game.data.pokemon[species]
    if not (def and isMissingNoSpecies(self.game.data, species)) then
      return originalSummaryMenuDraw(self)
    end
    local internalDex = def.dex
    def.dex = 0
    local ok, drawError = pcall(originalSummaryMenuDraw, self)
    def.dex = internalDex
    if not ok then error(drawError, 0) end
  end

  DexEntryMenu._g1gppOriginalNew = DexEntryMenu._g1gppOriginalNew
    or DexEntryMenu.new
  local originalDexEntryMenuNew = DexEntryMenu._g1gppOriginalNew
  DexEntryMenu.new = function(screenGame, speciesOrOpts, onDone)
    local species = type(speciesOrOpts) == "table"
      and (speciesOrOpts.species or speciesOrOpts[1]) or speciesOrOpts
    observePokemonDataScreen("pokedex", screenGame, species)
    local missingNo = isMissingNoSpecies(screenGame and screenGame.data, species)
    local mode = missingNo and missingNoPresentationMode() or nil
    local liveDef = missingNo and screenGame.data.pokemon[species] or nil
    local savedCry = liveDef and liveDef.cry or nil
    -- Original Red/Blue plays Rhydon's cry before MissingNo.'s blank record.
    -- Substitute it only for construction of the lore-friendly page, then
    -- restore the registered battle cry immediately.
    if liveDef and mode == "LORE_FRIENDLY" then liveDef.cry = "RHYDON" end
    local ok, screenOrError = pcall(originalDexEntryMenuNew,
      screenGame, speciesOrOpts, onDone)
    if liveDef and mode == "LORE_FRIENDLY" then liveDef.cry = savedCry end
    if not ok then error(screenOrError, 0) end
    local screen = screenOrError
    if screen and isMissingNoSpecies(screenGame and screenGame.data, species)
       and screen.def then
      local displayDef = {}
      for key, value in pairs(screen.def) do displayDef[key] = value end
      displayDef.dex = 0
      local canonicalEntry = {}
      for key, value in pairs(displayDef.dexEntry or {}) do
        canonicalEntry[key] = value
      end
      canonicalEntry.kind = ""
      canonicalEntry.heightFt = 10
      canonicalEntry.heightIn = 0
      canonicalEntry.weight = 35072
      if mode == "LORE_FRIENDLY" then
        -- The original entry's description is blank, but its canonical
        -- measurements still render. It remains capture-only and is not added
        -- to the ordinary Pokédex index.
        canonicalEntry.text = "_TrainerFlyMissingNoBlankDex"
      else
        -- Enhanced changes only the description and index accessibility.
        canonicalEntry.text = "_TrainerFlyMissingNoDex"
      end
      displayDef.dexEntry = canonicalEntry
      screen.forceOwned = true
      screen.def = displayDef
      debugLogger:log("MISSINGNO DEX PAGE PREPARED",
        "species=" .. debugLogger:safeField(species)
          .. " mode=" .. debugLogger:safeField(mode)
          .. " displayDex=000 forceOwned=" .. debugLogger:safeField(screen.forceOwned)
          .. " kind=" .. debugLogger:safeField(displayDef.dexEntry
            and displayDef.dexEntry.kind)
          .. " onDone=" .. debugLogger:safeField(type(onDone) == "function"))
    end
    return screen
  end


  -- The registered positive dex value is an internal compatibility detail.
  -- Always mask it while the stock 001-151 list is constructed. Lore-Friendly
  -- stops there, matching original Red/Blue. Enhanced may then add one explicit
  -- No.000 row for an owned preserved MissingNo. without exposing internal 152.
  PokedexMenu._g1gppOriginalNew = PokedexMenu._g1gppOriginalNew
    or PokedexMenu.new
  local originalPokedexMenuNew = PokedexMenu._g1gppOriginalNew
  PokedexMenu.new = function(menuGame, opts)
    local masked = {}
    local ownedMissingNo = nil
    local ownedMissingNoIndex = math.huge
    local pokedex = menuGame.save and menuGame.save.pokedex or {}
    local owned = pokedex.owned or {}
    for species, def in pairs((menuGame.data and menuGame.data.pokemon) or {}) do
      if isMissingNoSpecies(menuGame.data, species) then
        masked[#masked + 1] = { def = def, dex = def.dex }
        def.dex = 0
        if owned[species] then
          local index = tonumber(species:match("(%d+)$")) or math.huge
          if species == "TF_GLITCH_031" or index < ownedMissingNoIndex then
            ownedMissingNo = species
            ownedMissingNoIndex = index
          end
        end
      end
    end
    local ok, menuOrError = pcall(originalPokedexMenuNew, menuGame, opts)
    for _, entry in ipairs(masked) do entry.def.dex = entry.dex end
    if not ok then error(menuOrError, 0) end
    local mode = missingNoPresentationMode()
    local exposed = false
    if mode == "ENHANCED" and ownedMissingNo
       and type(menuOrError) == "table"
       and type(menuOrError.items) == "table" then
      table.insert(menuOrError.items, 1, {
        label = "000 MISSINGNO.",
        ball = true,
        value = ownedMissingNo,
      })
      exposed = true
      debugLogger:log("MISSINGNO DEX INDEX EXPOSED",
        "mode=ENHANCED species=" .. debugLogger:safeField(ownedMissingNo)
          .. " displayDex=000 listPosition=1 internalDexHidden=true")
    end
    debugLogger:log("MISSINGNO DEX LIST MASKED",
      "speciesCount=" .. debugLogger:safeField(#masked)
        .. " visibleRange=001-151 mode=" .. debugLogger:safeField(mode)
        .. " enhanced000Exposed=" .. debugLogger:safeField(exposed))
    return menuOrError
  end

  -- Build a temporary transformed battle picture. The source image is already
  -- colored by the recomp, so the canvas preserves the active SGB/GBC palette.
  -- Tile movement is deterministic and grid-based, echoing the original's
  -- incorrect tile-copy orientation rather than adding free-form static.
  local function transformedBattlePic(source, kind)
    if not (source and love and love.graphics and love.graphics.newCanvas) then
      return nil, "graphics_unavailable"
    end
    local okSize, w, h = pcall(source.getDimensions, source)
    if not okSize or not w or not h or w < 1 or h < 1 then
      return nil, "invalid_source_dimensions"
    end

    local okCanvas, canvas = pcall(love.graphics.newCanvas, w, h)
    if not okCanvas or not canvas then return nil, canvas end
    if canvas.setFilter then pcall(canvas.setFilter, canvas, "nearest", "nearest") end

    local g = love.graphics
    local previousCanvas = g.getCanvas and g.getCanvas() or nil
    local okDraw, drawError = pcall(function()
      g.push("all")
      g.setCanvas(canvas)
      g.clear(0, 0, 0, 0)
      g.setColor(1, 1, 1, 1)

      if kind == "reverse" then
        -- Red/Blue's first affected opposing picture is a clean whole-sprite
        -- horizontal reversal. This is the pre-redraw state observed in mGBA.
        g.draw(source, w, 0, 0, -1, 1)
      elseif kind == "enemy_tile_flip" then
        -- Verified against original Pokémon Blue VRAM: after the first player
        -- attack redraw, every 8x8 enemy-front tile remains in its normal tile
        -- position while the pixels inside that tile are mirrored horizontally.
        -- For the canonical 56x56 front picture this produces seven visibly
        -- scrambled 8-pixel vertical bands, pixel-perfect to the mGBA capture.
        local tile = 8
        for sy = 0, h - 1, tile do
          for sx = 0, w - 1, tile do
            local tw = math.min(tile, w - sx)
            local th = math.min(tile, h - sy)
            local quad = g.newQuad(sx, sy, tw, th, w, h)
            g.draw(source, quad, sx + tw, sy, 0, -1, 1)
          end
        end
      elseif kind == "player_column_reverse" then
        -- Verified against original Pokémon Blue VRAM for the player Pokémon
        -- back picture: the 8-pixel tile columns are emitted in reverse order,
        -- but the pixels inside each column are NOT mirrored. This is a distinct
        -- corruption path from the opposing front sprite and reproduces the
        -- characteristic striped/scrambled back picture from actual runtime art.
        local tile = 8
        local cols = math.ceil(w / tile)
        for destCol = 0, cols - 1 do
          local sourceCol = cols - 1 - destCol
          local sx = sourceCol * tile
          local dx = destCol * tile
          local tw = math.min(tile, w - sx, w - dx)
          if tw > 0 then
            local quad = g.newQuad(sx, 0, tw, h, w, h)
            g.draw(source, quad, dx, 0)
          end
        end
      elseif kind == "trainer_postscale_bg_reverse" then
        -- BG Trainer path: use the same post-ScaleSpriteByTwo-equivalent
        -- corrupted data as the moving OAM head, but place the seven 8px
        -- hardware columns in reverse order. In source space, each hardware
        -- column is a 4px block inside the effective 28x28 area.
        local effectiveW = math.min(w, 28)
        local effectiveH = math.min(h, 28)
        local sourceBlock = 4
        local sourceHalf = 2
        local cols = math.floor(effectiveW / sourceBlock)
        for sy = 0, effectiveH - 1 do
          for destCol = 0, cols - 1 do
            local sourceCol = cols - 1 - destCol
            local sx = sourceCol * sourceBlock
            local dx = destCol * sourceBlock
            local qRight = g.newQuad(sx + sourceHalf, sy, sourceHalf, 1, w, h)
            local qLeft = g.newQuad(sx, sy, sourceHalf, 1, w, h)
            g.draw(source, qRight, dx, sy)
            g.draw(source, qLeft, dx + sourceHalf, sy)
          end
        end
      elseif kind == "trainer_postscale_nibble_swap" then
        -- Authentic Red/Blue Trainer-back corruption, expressed in
        -- Gen1Recomp's pre-draw source space.
        --
        -- Original pipeline:
        --   32x32 back source
        --   -> ScaleSpriteByTwo (right/bottom 4px ignored)
        --   -> 56x56 / 7x7 hardware-tile buffer
        --   -> InterlaceMergeSpriteBuffers
        --   -> swap [hl] on every byte when wSpriteFlipped != 0
        --
        -- Each final 8px hardware-tile row therefore swaps pixels 0..3
        -- with 4..7. Because Gen1Recomp later draws this source at 2x
        -- nearest-neighbor, the exact source-space equivalent is to swap
        -- 2px halves inside every 4px source block. Only the effective
        -- 28x28 source area participates, matching ScaleSpriteByTwo's
        -- ignored rightmost/bottommost four pixels.
        local effectiveW = math.min(w, 28)
        local effectiveH = math.min(h, 28)
        local sourceBlock = 4
        local sourceHalf = 2
        for sy = 0, effectiveH - 1 do
          for sx = 0, effectiveW - 1, sourceBlock do
            local blockW = math.min(sourceBlock, effectiveW - sx)
            if blockW >= 4 then
              local qRight = g.newQuad(sx + sourceHalf, sy, sourceHalf, 1, w, h)
              local qLeft = g.newQuad(sx, sy, sourceHalf, 1, w, h)
              g.draw(source, qRight, sx, sy)
              g.draw(source, qLeft, sx + sourceHalf, sy)
            elseif blockW > 0 then
              local q = g.newQuad(sx, sy, blockW, 1, w, h)
              g.draw(source, q, sx, sy)
            end
          end
        end
      elseif kind == "trainer_nibble_swap" then
        -- Moving Trainer head/OAM path. The original wSpriteFlipped data
        -- corruption is still the byte-level high/low nibble swap, but the
        -- 7x3 OBJ head is assembled in normal left-to-right column order.
        -- This is intentionally distinct from the BG body path below.
        local tile = 8
        local half = 4
        for sy = 0, h - 1, tile do
          for sx = 0, w - 1, tile do
            local th = math.min(tile, h - sy)
            local leftW = math.min(half, math.max(0, w - sx))
            local rightX = sx + half
            local rightW = math.min(half, math.max(0, w - rightX))
            if rightW > 0 then
              local qRight = g.newQuad(rightX, sy, rightW, th, w, h)
              g.draw(source, qRight, sx, sy)
            end
            if leftW > 0 and sx + half < w then
              local qLeft = g.newQuad(sx, sy, leftW, th, w, h)
              g.draw(source, qLeft, sx + half, sy)
            end
          end
        end
      elseif kind == "trainer_column_reverse_nibble_swap" then
        -- Pokémon Red/Blue's InterlaceMergeSpriteBuffers applies `swap [hl]`
        -- to every byte when wSpriteFlipped is non-zero. Each byte is one
        -- 8-pixel row of a 1bpp plane, so the visible operation is NOT a full
        -- horizontal mirror: within every 8x8 tile row, pixels 0..3 exchange
        -- places with pixels 4..7 while each 4-pixel group keeps its order.
        -- LoadPlayerBackPic performs this after ScaleSpriteByTwo and uses the
        -- resulting data for both the BG body and the 7x3 OAM head group.
        local tile = 8
        local half = 4
        local cols = math.ceil(w / tile)
        for sy = 0, h - 1, tile do
          for sourceCol = 0, cols - 1 do
            local sx = sourceCol * tile
            local destCol = cols - 1 - sourceCol
            local dx = destCol * tile
            local th = math.min(tile, h - sy)
            local leftW = math.min(half, math.max(0, w - sx))
            local rightX = sx + half
            local rightW = math.min(half, math.max(0, w - rightX))
            -- The original battle presentation is not merely byte-corrupted:
            -- Red's overall 8px tile-column placement reads reversed as well.
            -- Reversing columns gives the left-facing silhouette seen on the
            -- affected hardware while the nibble swap preserves the measured
            -- within-tile corruption instead of turning this into a clean mirror.
            if rightW > 0 and dx < w then
              local qRight = g.newQuad(rightX, sy, rightW, th, w, h)
              g.draw(source, qRight, dx, sy)
            end
            if leftW > 0 and dx + half < w then
              local qLeft = g.newQuad(sx, sy, leftW, th, w, h)
              g.draw(source, qLeft, dx + half, sy)
            end
          end
        end
      else
        -- Retained only as a defensive fallback for any older call site. New
        -- MissingNo. fidelity paths above are evidence-derived, not artistic.
        g.draw(source, 0, 0)
      end
      g.setCanvas(previousCanvas)
      g.pop()
    end)

    if not okDraw then
      pcall(g.setCanvas, previousCanvas)
      pcall(g.pop)
      pcall(canvas.release, canvas)
      return nil, drawError
    end
    return canvas, nil
  end

  BattleState._g1gppOriginalPicImage = BattleState._g1gppOriginalPicImage
    or BattleState.picImage
  local originalPicImage = BattleState._g1gppOriginalPicImage
  function BattleState:picImage(img)
    local resolved = originalPicImage(self, img)
    if not self._g1gppInvertedSprites or not resolved then return resolved end

    local kind
    if img == self.playerBackPic then
      -- MissingNo. uses the normal runtime Trainer back picture and reproduces
      -- the original split behavior with one shared corrupted 7x7 buffer:
      -- the BG body uses reversed 7-column placement, while the temporary OAM
      -- head uses ordinary column order. Gen1Recomp performs the 2x draw scale,
      -- so trainer_postscale_bg_reverse applies the source-space equivalent of
      -- post-ScaleSpriteByTwo nibble corruption plus reversed 4px source columns.
      kind = "trainer_postscale_bg_reverse"
    elseif img == self.trainerPic then
      kind = "reverse"
    elseif self.player and img == self.player.sprite then
      kind = "player_column_reverse"
    elseif self.enemy and img == self.enemy.sprite then
      kind = self._g1gppEnemySpriteBroken and "enemy_tile_flip" or "reverse"
    end
    if not kind then return resolved end

    self._g1gppInvertedCache = self._g1gppInvertedCache or {}
    local bySource = self._g1gppInvertedCache[resolved]
    if not bySource then
      bySource = {}
      self._g1gppInvertedCache[resolved] = bySource
    end
    if bySource[kind] then return bySource[kind] end

    local transformed, transformError = transformedBattlePic(resolved, kind)
    if transformed then
      bySource[kind] = transformed
      self._g1gppInvertedCanvases = self._g1gppInvertedCanvases or {}
      self._g1gppInvertedCanvases[#self._g1gppInvertedCanvases + 1] = transformed
      debugLogger:log("INVERTED SPRITE RENDERED",
        "battle=" .. debugLogger:safeField(self)
          .. " role=" .. debugLogger:safeField(kind)
          .. " width=" .. debugLogger:safeField(resolved:getWidth())
          .. " height=" .. debugLogger:safeField(resolved:getHeight()))
      return transformed
    end

    debugLogger:log("INVERTED SPRITE RENDER FAILED",
      "battle=" .. debugLogger:safeField(self)
        .. " role=" .. debugLogger:safeField(kind)
        .. " error=" .. debugLogger:safeField(transformError))
    return resolved
  end

  -- MissingNo Trainer intro: reproduce the original split presentation.
  -- BG body and temporary OAM head share the same post-ScaleSpriteByTwo-
  -- equivalent corrupted data, but NOT the same spatial assembly.
  -- The BG body uses reversed 7-column placement so it reads left-facing.
  -- The temporary OAM head uses ordinary 7x3 tile order so it reads right-
  -- facing while Gen1Recomp's native introSlide is active. When introSlide
  -- reaches zero the overlay disappears and the BG head is revealed.
  BattleState._g1gppOriginalDrawPicsLayer = BattleState._g1gppOriginalDrawPicsLayer
    or BattleState.drawPicsLayer
  local originalDrawPicsLayer = BattleState._g1gppOriginalDrawPicsLayer

  local function measureTrainerSourcePadding(source)
    if not (source and love and love.graphics and love.graphics.newCanvas) then
      return 0, 0
    end
    local okSize, w, h = pcall(source.getDimensions, source)
    if not okSize or not w or not h then return 0, 0 end
    local okCanvas, c = pcall(love.graphics.newCanvas, w, h)
    if not okCanvas or not c then return 0, 0 end
    local g = love.graphics
    local prev = g.getCanvas and g.getCanvas() or nil
    local ok = pcall(function()
      g.push("all")
      g.setCanvas(c)
      g.clear(0, 0, 0, 0)
      g.setColor(1, 1, 1, 1)
      g.draw(source, 0, 0)
      g.setCanvas(prev)
      g.pop()
    end)
    if not ok then
      pcall(g.setCanvas, prev); pcall(g.pop); pcall(c.release, c)
      return 0, 0
    end
    local okData, data = pcall(c.newImageData, c)
    pcall(c.release, c)
    if not okData or not data then return 0, 0 end
    local padL = 0
    while padL < w do
      local opaque = false
      for y = 0, h - 1 do
        local _, _, _, a = data:getPixel(padL, y)
        if a > 0 then opaque = true break end
      end
      if opaque then break end
      padL = padL + 1
    end
    local bottom = h - 1
    while bottom >= 0 do
      local opaque = false
      for x = 0, w - 1 do
        local _, _, _, a = data:getPixel(x, bottom)
        if a > 0 then opaque = true break end
      end
      if opaque then break end
      bottom = bottom - 1
    end
    return padL, h - 1 - bottom
  end

  local function invertedTrainerHeadImage(battle)
    local source = originalPicImage(battle, battle.playerBackPic)
    if not source then return nil end
    battle._g1gppInvertedCache = battle._g1gppInvertedCache or {}
    local bySource = battle._g1gppInvertedCache[source]
    if not bySource then
      bySource = {}
      battle._g1gppInvertedCache[source] = bySource
    end
    if not bySource.trainer_postscale_nibble_swap then
      local transformed, err = transformedBattlePic(source, "trainer_postscale_nibble_swap")
      if not transformed then
        debugLogger:log("INVERTED TRAINER OAM BUILD FAILED", "error=" .. debugLogger:safeField(err))
        return nil
      end
      bySource.trainer_postscale_nibble_swap = transformed
      battle._g1gppInvertedCanvases = battle._g1gppInvertedCanvases or {}
      battle._g1gppInvertedCanvases[#battle._g1gppInvertedCanvases + 1] = transformed
      local padL, padBottom = measureTrainerSourcePadding(source)
      battle._g1gppTrainerSourcePadL = padL
      battle._g1gppTrainerSourcePadBottom = padBottom
      debugLogger:log("INVERTED TRAINER POST-SCALE BUFFER READY",
        "sourceW=" .. debugLogger:safeField(source:getWidth())
          .. " sourceH=" .. debugLogger:safeField(source:getHeight())
          .. " effectiveW=28 effectiveH=28"
          .. " finalActiveW=56 finalActiveH=56"
          .. " padL=" .. debugLogger:safeField(padL)
          .. " padBottom=" .. debugLogger:safeField(padBottom))
    end
    if not bySource.trainer_oam_21tile then
      local buffer = bySource.trainer_postscale_nibble_swap
      local bw, bh = buffer:getDimensions()
      local tile = 4 -- source-space equivalent of one final 8x8 hardware tile
      local cols = 7
      local rows = 3
      local canvas = love.graphics.newCanvas(cols * tile, rows * tile)
      local g = love.graphics
      local previousCanvas = g.getCanvas and g.getCanvas() or nil
      local okDraw, drawError = xpcall(function()
        g.push("all")
        g.setCanvas(canvas)
        g.clear(0, 0, 0, 0)
        g.setColor(1, 1, 1, 1)
        for row = 0, rows - 1 do
          for col = 0, cols - 1 do
            local sx = col * tile
            local sy = row * tile
            local q = g.newQuad(sx, sy, tile, tile, bw, bh)
            g.draw(buffer, q, col * tile, row * tile)
          end
        end
        g.setCanvas(previousCanvas)
        g.pop()
      end, debug.traceback)
      if not okDraw then
        pcall(g.setCanvas, previousCanvas)
        pcall(g.pop)
        pcall(canvas.release, canvas)
        debugLogger:log("INVERTED TRAINER OAM BUILD FAILED", "error=" .. debugLogger:safeField(drawError))
        return nil
      end
      bySource.trainer_oam_21tile = canvas
      battle._g1gppInvertedCanvases[#battle._g1gppInvertedCanvases + 1] = canvas
      debugLogger:log("INVERTED TRAINER OAM TILE MAP",
        "cols=7 rows=3 sourceTile=4 order=normal topRows=0..2")
    end
    return bySource.trainer_oam_21tile
  end

  function BattleState:drawPicsLayer(slide, sx, sy, onlySide, skipMenuClip)
    originalDrawPicsLayer(self, slide, sx, sy, onlySide, skipMenuClip)
    if not self._g1gppInvertedSprites
       or onlySide == "enemy"
       or not self.showPlayerBack
       or not self.playerBackPic
       or not self.introSlide
       or self.introSlide <= 0 then
      return
    end

    local head = invertedTrainerHeadImage(self)
    if not head then return end
    local w, h = head:getDimensions()
    local scale = BattleState.BATTLE_SCALE_DEFAULT
      and BattleState.BATTLE_SCALE_DEFAULT.back or 2
    local padL = self._g1gppTrainerSourcePadL or 0
    local padBottom = self._g1gppTrainerSourcePadBottom or 0
    local dx, dy = BattleState.backPlacement(w, h, padBottom, padL, scale)
    if not self._g1gppTrainerHeadGeometryLogged then
      self._g1gppTrainerHeadGeometryLogged = true
      debugLogger:log("INVERTED TRAINER OAM GEOMETRY",
        "pipeline=post_scale_equivalent"
          .. " sourceW=" .. debugLogger:safeField(w)
          .. " sourceH=" .. debugLogger:safeField(h)
          .. " scale=" .. debugLogger:safeField(scale)
          .. " finalW=" .. debugLogger:safeField(w * scale)
          .. " finalH=" .. debugLogger:safeField(h * scale))
    end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(head,
      dx + (slide or 0) + (sx or 0) + self:picOffset("back"),
      dy + (sy or 0), 0, scale, scale)
  end

  mod.events:on("battle.started", function(ev)
    if not invertedSpriteState.active or not (ev and ev.battle) then return end
    local affected = ev.battle
    affected._g1gppInvertedSprites = true
    affected._g1gppEnemySpriteBroken = false
    invertedSpriteState.affectedBattles = invertedSpriteState.affectedBattles + 1
    debugLogger:log("INVERTED BATTLE STARTED",
      "kind=" .. debugLogger:safeField(ev.kind)
        .. " trainerId=" .. debugLogger:safeField(ev.trainerId)
        .. " enemySpecies=" .. debugLogger:safeField(ev.species)
        .. " " .. invertedSpriteSummary())
  end)

  mod.events:on("battle.move_used", function(ev)
    local affected = ev and ev.battle
    if not (affected and affected._g1gppInvertedSprites
      and ev.user and ev.user.isPlayer and not affected._g1gppEnemySpriteBroken) then
      return
    end
    -- Queue after the attack animation row. On the original, the opposing
    -- front sprite begins as a clean reversal and breaks when that tilemap is
    -- redrawn during the first player attack.
    affected:actNext(function()
      affected._g1gppEnemySpriteBroken = true
      debugLogger:log("INVERTED ENEMY SPRITE BROKEN",
        "move=" .. debugLogger:safeField(ev.move and ev.move.id)
          .. " enemySpecies=" .. debugLogger:safeField(
            affected.enemy and affected.enemy.mon and affected.enemy.mon.species))
    end)
  end)

  mod.events:on("battle.ended", function(ev)
    local affected = ev and ev.battle
    if not (affected and affected._g1gppInvertedSprites) then return end
    local released = 0
    for _, canvas in ipairs(affected._g1gppInvertedCanvases or {}) do
      local ok = pcall(canvas.release, canvas)
      if ok then released = released + 1 end
    end
    debugLogger:log("INVERTED BATTLE ENDED",
      "result=" .. debugLogger:safeField(ev.result)
        .. " canvasesReleased=" .. debugLogger:safeField(released)
        .. " effectRemainsActive=" .. debugLogger:safeField(invertedSpriteState.active))
    affected._g1gppInvertedCanvases = nil
    affected._g1gppInvertedCache = nil
  end)

  playerStateSummary = function(world)
    if not world then return "world=nil" end
    local map = world.map
    local player = world.player
    local stackTop = game and game.stack and game.stack.top and game.stack:top() or nil
    local runnerRunning = world.runner and world.runner.isRunning and world.runner:isRunning() or nil
    if not player then
      return ("map=%s player=nil transitioning=%s runner=%s stackTop=%s"):format(
        debugLogger:safeField(map and map.id), debugLogger:safeField(world.transitioning),
        debugLogger:safeField(runnerRunning), debugLogger:safeField(stackTop))
    end
    return table.concat({
      "map=" .. debugLogger:safeField(map and map.id),
      "cell=" .. debugLogger:safeField(player.cellX) .. "," .. debugLogger:safeField(player.cellY),
      "pixel=" .. debugLogger:safeField(player.px) .. "," .. debugLogger:safeField(player.py),
      "target=" .. debugLogger:safeField(player.targetX) .. "," .. debugLogger:safeField(player.targetY),
      "moving=" .. debugLogger:safeField(player.moving),
      "progress=" .. debugLogger:safeField(player.progress),
      "facing=" .. debugLogger:safeField(player.facing),
      "inputLocked=" .. debugLogger:safeField(player.inputLocked),
      "transitioning=" .. debugLogger:safeField(world.transitioning),
      "runner=" .. debugLogger:safeField(runnerRunning),
      "stackTop=" .. debugLogger:safeField(stackTop),
    }, " ")
  end


  -- Shared Jacred hidden-ball state. These declarations must appear before
  -- every screen/event closure that reads or writes them.
  local pendingJacredBallExitBattle = nil
  local pendingJacredBallMessage = false
  local jacredPatch22BannerPending = false

  -- Glitch City runtime-map probe. A qualifying ZZAZZ hidden-Poke-Ball
  -- exit waits for the ordinary overworld to be safely restored, then
  -- snapshots the live map block grid and rearranges those real blocks.
  -- Because Map:setBlock drives both rendering and collision, the result is
  -- an actual temporary malformed map rather than a screen overlay.
  local glitchCityHandoff = {
    armed = false,
    pending = false,
    idleFrames = 0,
    origin = nil,

    active = false,
    mapRef = nil,
    mapId = nil,
    originalBlocks = nil,
    originalTilesetImage = nil,
    originalTilesetBlocks = nil,
    originalRenderer = nil,
    containmentInstalled = false,
    originalWarpAt = nil,
    originalConnections = nil,
    originalWalkable = nil,
    originalDoorTiles = nil,
    originalWarpTiles = nil,
    blockedWarpCells = nil,
    blockedExitAttempts = 0,
    durationFrames = 1800, -- final 30-second Glitch City duration
    remainingFrames = 0,
    glyphMutationCells = nil,
    glyphMutationIntervalFrames = 75,
    glyphMutationCountdown = 0,
    glyphMutationCursor = 0,
    glyphMutationCount = 0,
    recoveryMessagePending = false,
    recoveryWarpPending = false,
    recoveryWarpOrigin = nil,
    recoveryWarpReason = nil,
    recoveryWarpAttempts = 0,
    recoveryWarpIssued = false,

    -- Audio probe state. The source-map song label is captured before battle;
    -- during Glitch City we apply a stable slowed/filtered corruption treatment
    -- to the live music source, then restart the normal map theme on recovery.
    audioActive = false,
    audioCapturedSong = nil,
    audioCapturedMapSong = nil,
    audioCapturedChip = nil,
    audioReverseSource = nil,
    audioReverseNextSource = nil,
    audioReversePosition = nil,
    audioReverseDuration = nil,
    audioReverseChunkSeconds = 0.35,
    audioReverseCrossfadeSeconds = 0.08,
    audioReversePitch = 0.50,
    audioReverseElapsed = 0,
    audioReverseCrossfadeElapsed = 0,
    audioReverseCrossfading = false,
    audioReverseChunkCount = 0,
    audioOriginalSource = nil,
    audioOriginalLoopSource = nil,
    audioOriginalVolume = 1,
    audioOriginalLoopVolume = 1,
    audioExclusiveMuteCount = 0,

    -- Post-recovery intro-to-loop handoff watcher. The engine may restore an
    -- intro source with a separate dormant loop source. Start only that loop
    -- after the intro actually stops, avoiding both silence and duplicate music.
    recoveryMusicWatchActive = false,
    recoveryMusicMainSource = nil,
    recoveryMusicLoopSource = nil,
    recoveryMusicLoopTargetVolume = 1,
    recoveryMusicWatchFrames = 0,
  }

  local function musicRuntimeState()
    if not (debug and debug.getupvalue and Music and Music.play) then
      return nil, "debug.getupvalue unavailable"
    end
    for i = 1, 32 do
      local name, value = debug.getupvalue(Music.play, i)
      if not name then break end
      if type(value) == "table"
         and (value.current ~= nil or value.source ~= nil or value.mapSong ~= nil)
         and value.failed ~= nil then
        return value
      end
    end
    return nil, "Music state upvalue not found"
  end

  local function musicStateSummary()
    local state, err = musicRuntimeState()
    if not state then return "musicState=nil error=" .. debugLogger:safeField(err) end
    local source = state.source
    local playing, sourceType, pitch
    if source then
      local ok, value = pcall(source.isPlaying, source)
      playing = ok and value or "error"
      local okType, valueType = pcall(source.getType, source)
      sourceType = okType and valueType or type(source)
      local okPitch, valuePitch = pcall(source.getPitch, source)
      pitch = okPitch and valuePitch or "unavailable"
    end
    return table.concat({
      "current=" .. debugLogger:safeField(state.current),
      "mapSong=" .. debugLogger:safeField(state.mapSong),
      "chip=" .. debugLogger:safeField(state.chip),
      "playing=" .. debugLogger:safeField(playing),
      "sourceType=" .. debugLogger:safeField(sourceType),
      "pitch=" .. debugLogger:safeField(pitch),
    }, " ")
  end

  local function captureGlitchCityAudio(reason)
    local state, err = musicRuntimeState()
    if not state then
      debugLogger:log("AUDIO CAPTURE FAILED", debugLogger:safeField(reason) .. " error=" .. debugLogger:safeField(err))
      return
    end
    glitchCityHandoff.audioCapturedSong = state.current
    glitchCityHandoff.audioCapturedMapSong = state.mapSong
    glitchCityHandoff.audioCapturedChip = state.chip
    debugLogger:log("AUDIO CAPTURED", debugLogger:safeField(reason) .. " " .. musicStateSummary())
  end

  local function prepareReverseSource(src, volume)
    pcall(src.setLooping, src, false)
    pcall(src.setVolume, src, volume or 0)
    pcall(src.setPitch, src, glitchCityHandoff.audioReversePitch or 0.50)
    pcall(src.setFilter, src, {
      type = "lowpass", volume = 1, highgain = 0.25,
    })
  end

  local function seekAndPlayReverseChunk(src, position, volume)
    if not src then return false, "source=nil" end
    pcall(src.stop, src)
    prepareReverseSource(src, volume or 0)
    local okSeek, seekErr = pcall(src.seek, src, position, "seconds")
    local okPlay, playErr = pcall(src.play, src)
    if not okSeek then return false, "seek=" .. debugLogger:safeField(seekErr) end
    if not okPlay then return false, "play=" .. debugLogger:safeField(playErr) end
    return true, nil
  end

  local function startGlitchCityAudio()
    debugLogger:log("AUDIO REVERSE START REQUEST", "capturedSong="
      .. debugLogger:safeField(glitchCityHandoff.audioCapturedSong)
      .. " capturedMapSong=" .. debugLogger:safeField(glitchCityHandoff.audioCapturedMapSong)
      .. " before=" .. musicStateSummary())
    local state, err = musicRuntimeState()
    if not state or not state.source then
      glitchCityHandoff.audioActive = false
      debugLogger:log("AUDIO REVERSE START FAILED", "error=" .. debugLogger:safeField(err)
        .. " state=" .. musicStateSummary())
      return false
    end

    local src = state.source
    local okTell, position = pcall(src.tell, src, "seconds")
    local okDuration, duration = pcall(src.getDuration, src, "seconds")
    local okCloneA, reverseSource = pcall(src.clone, src)
    local okCloneB, reverseNextSource = pcall(src.clone, src)
    if not (okTell and type(position) == "number"
       and okDuration and type(duration) == "number" and duration > 0
       and okCloneA and reverseSource and okCloneB and reverseNextSource) then
      glitchCityHandoff.audioActive = false
      debugLogger:log("AUDIO REVERSE START FAILED", "tellOk=" .. debugLogger:safeField(okTell)
        .. " position=" .. debugLogger:safeField(position)
        .. " durationOk=" .. debugLogger:safeField(okDuration)
        .. " duration=" .. debugLogger:safeField(duration)
        .. " cloneA=" .. debugLogger:safeField(okCloneA)
        .. " cloneB=" .. debugLogger:safeField(okCloneB))
      return false
    end

    local chunk = glitchCityHandoff.audioReverseChunkSeconds
    local reversePosition = math.max(0, math.min(position, duration - chunk))
    glitchCityHandoff.audioOriginalSource = src
    glitchCityHandoff.audioOriginalLoopSource = state.loopSource
    local okVolume, originalVolume = pcall(src.getVolume, src)
    glitchCityHandoff.audioOriginalVolume = okVolume and originalVolume or 1
    local okLoopVolume, originalLoopVolume = false, 1
    if state.loopSource then
      okLoopVolume, originalLoopVolume = pcall(state.loopSource.getVolume, state.loopSource)
    end
    glitchCityHandoff.audioOriginalLoopVolume = okLoopVolume and originalLoopVolume or 1
    glitchCityHandoff.audioExclusiveMuteCount = 0

    pcall(src.setVolume, src, 0)
    pcall(src.pause, src)
    if state.loopSource then
      pcall(state.loopSource.setVolume, state.loopSource, 0)
      pcall(state.loopSource.pause, state.loopSource)
    end

    prepareReverseSource(reverseSource, glitchCityHandoff.audioOriginalVolume or 1)
    prepareReverseSource(reverseNextSource, 0)
    local okStart, startErr = seekAndPlayReverseChunk(
      reverseSource, reversePosition, glitchCityHandoff.audioOriginalVolume or 1)

    glitchCityHandoff.audioReverseSource = reverseSource
    glitchCityHandoff.audioReverseNextSource = reverseNextSource
    glitchCityHandoff.audioReversePosition = reversePosition
    glitchCityHandoff.audioReverseDuration = duration
    glitchCityHandoff.audioReverseElapsed = 0
    glitchCityHandoff.audioReverseCrossfadeElapsed = 0
    glitchCityHandoff.audioReverseCrossfading = false
    glitchCityHandoff.audioReverseChunkCount = 1
    glitchCityHandoff.audioActive = okStart
    debugLogger:log(okStart and "AUDIO REVERSE STARTED" or "AUDIO REVERSE START FAILED",
      "mode=dual_source_crossfade chunkSeconds=" .. debugLogger:safeField(chunk)
      .. " crossfadeSeconds=" .. debugLogger:safeField(glitchCityHandoff.audioReverseCrossfadeSeconds)
      .. " pitch=" .. debugLogger:safeField(glitchCityHandoff.audioReversePitch)
      .. " startPosition=" .. debugLogger:safeField(reversePosition)
      .. " duration=" .. debugLogger:safeField(duration)
      .. " error=" .. debugLogger:safeField(startErr))
    return glitchCityHandoff.audioActive
  end

  local function updateGlitchCityReverseAudio(dt)
    if not glitchCityHandoff.audioActive then return end
    local src = glitchCityHandoff.audioReverseSource
    local nextSrc = glitchCityHandoff.audioReverseNextSource
    local duration = glitchCityHandoff.audioReverseDuration
    local chunk = glitchCityHandoff.audioReverseChunkSeconds
    local crossfade = glitchCityHandoff.audioReverseCrossfadeSeconds
    local delta = tonumber(dt) or (1 / 60)

    local state = musicRuntimeState()
    if state then
      local muted = 0
      if state.source and state.source ~= src and state.source ~= nextSrc then
        pcall(state.source.setVolume, state.source, 0)
        pcall(state.source.pause, state.source)
        muted = muted + 1
      end
      if state.loopSource and state.loopSource ~= src and state.loopSource ~= nextSrc then
        pcall(state.loopSource.setVolume, state.loopSource, 0)
        pcall(state.loopSource.pause, state.loopSource)
        muted = muted + 1
      end
      if muted > 0 then
        glitchCityHandoff.audioExclusiveMuteCount =
          (glitchCityHandoff.audioExclusiveMuteCount or 0) + 1
        if glitchCityHandoff.audioExclusiveMuteCount == 1
           or glitchCityHandoff.audioExclusiveMuteCount % 60 == 0 then
          debugLogger:log("AUDIO EXCLUSIVE MUTE ENFORCED",
            "managedSources=" .. debugLogger:safeField(muted)
            .. " count=" .. debugLogger:safeField(glitchCityHandoff.audioExclusiveMuteCount))
        end
      end
    end

    if not (src and nextSrc and duration and duration > chunk) then
      debugLogger:log("AUDIO REVERSE UPDATE FAILED", "source=" .. debugLogger:safeField(src)
        .. " nextSource=" .. debugLogger:safeField(nextSrc)
        .. " duration=" .. debugLogger:safeField(duration))
      glitchCityHandoff.audioActive = false
      return
    end

    glitchCityHandoff.audioReverseElapsed =
      glitchCityHandoff.audioReverseElapsed + delta

    if not glitchCityHandoff.audioReverseCrossfading
       and glitchCityHandoff.audioReverseElapsed >= (chunk - crossfade) then
      local nextPosition = (glitchCityHandoff.audioReversePosition or 0) - chunk
      if nextPosition < 0 then
        nextPosition = math.max(0, duration - chunk)
        debugLogger:log("AUDIO REVERSE WRAPPED", "duration=" .. debugLogger:safeField(duration)
          .. " chunkCount=" .. debugLogger:safeField(glitchCityHandoff.audioReverseChunkCount))
      end
      local okChunk, chunkErr = seekAndPlayReverseChunk(nextSrc, nextPosition, 0)
      if not okChunk then
        debugLogger:log("AUDIO REVERSE CHUNK FAILED", "position=" .. debugLogger:safeField(nextPosition)
          .. " error=" .. debugLogger:safeField(chunkErr))
        glitchCityHandoff.audioActive = false
        return
      end
      glitchCityHandoff.audioReversePosition = nextPosition
      glitchCityHandoff.audioReverseCrossfadeElapsed = 0
      glitchCityHandoff.audioReverseCrossfading = true
      glitchCityHandoff.audioReverseChunkCount =
        glitchCityHandoff.audioReverseChunkCount + 1
    end

    if glitchCityHandoff.audioReverseCrossfading then
      glitchCityHandoff.audioReverseCrossfadeElapsed =
        glitchCityHandoff.audioReverseCrossfadeElapsed + delta
      local t = math.min(1,
        glitchCityHandoff.audioReverseCrossfadeElapsed / crossfade)
      local volume = glitchCityHandoff.audioOriginalVolume or 1
      pcall(src.setVolume, src, volume * (1 - t))
      pcall(nextSrc.setVolume, nextSrc, volume * t)
      if t >= 1 then
        pcall(src.stop, src)
        glitchCityHandoff.audioReverseSource = nextSrc
        glitchCityHandoff.audioReverseNextSource = src
        glitchCityHandoff.audioReverseElapsed = 0
        glitchCityHandoff.audioReverseCrossfadeElapsed = 0
        glitchCityHandoff.audioReverseCrossfading = false
        if glitchCityHandoff.audioReverseChunkCount % 25 == 0 then
          debugLogger:log("AUDIO REVERSE PROGRESS",
            "position=" .. debugLogger:safeField(glitchCityHandoff.audioReversePosition)
            .. " chunks=" .. debugLogger:safeField(glitchCityHandoff.audioReverseChunkCount)
            .. " crossfades=" .. debugLogger:safeField(glitchCityHandoff.audioReverseChunkCount - 1))
        end
      end
    end
  end

  local function stopGlitchCityAudio(reason)
    debugLogger:log("AUDIO STOP REQUEST", "reason=" .. debugLogger:safeField(reason)
      .. " active=" .. debugLogger:safeField(glitchCityHandoff.audioActive)
      .. " before=" .. musicStateSummary())
    local reverseSource = glitchCityHandoff.audioReverseSource
    local reverseNextSource = glitchCityHandoff.audioReverseNextSource
    if reverseSource then pcall(reverseSource.stop, reverseSource) end
    if reverseNextSource then pcall(reverseNextSource.stop, reverseNextSource) end
    local originalSource = glitchCityHandoff.audioOriginalSource
    local originalLoopSource = glitchCityHandoff.audioOriginalLoopSource
    if originalSource then
      pcall(originalSource.setVolume, originalSource,
        glitchCityHandoff.audioOriginalVolume or 1)
    end
    if originalLoopSource then
      pcall(originalLoopSource.setVolume, originalLoopSource,
        glitchCityHandoff.audioOriginalLoopVolume or 1)
    end
    glitchCityHandoff.audioReverseSource = nil
    glitchCityHandoff.audioReverseNextSource = nil
    glitchCityHandoff.audioOriginalSource = nil
    glitchCityHandoff.audioOriginalLoopSource = nil
    glitchCityHandoff.audioExclusiveMuteCount = 0
    glitchCityHandoff.audioReversePosition = nil
    glitchCityHandoff.audioReverseDuration = nil
    glitchCityHandoff.audioReverseElapsed = 0
    glitchCityHandoff.audioReverseCrossfadeElapsed = 0
    glitchCityHandoff.audioReverseCrossfading = false
    local state = musicRuntimeState()
    if state then
      if state.source then pcall(state.source.setPitch, state.source, 1) end
      if state.loopSource then pcall(state.loopSource.setPitch, state.loopSource, 1) end
    end
    local ok, err = pcall(function()
      if game and game.data then Music.restoreMap(game.data) end
    end)
    glitchCityHandoff.audioActive = false
    debugLogger:log(ok and "AUDIO RESTORED" or "AUDIO RESTORE FAILED",
      "reason=" .. debugLogger:safeField(reason) .. " error=" .. debugLogger:safeField(err)
      .. " after=" .. musicStateSummary())
  end

  local function captureGlitchCityOrigin(world, reason)
    if not (world and world.map and world.player) then
      debugLogger:log("ORIGIN CAPTURE FAILED", (reason or "unknown") .. " " .. playerStateSummary(world))
      return nil
    end
    local player = world.player
    local origin = {
      mapId = world.map.id,
      x = tonumber(player.cellX),
      y = tonumber(player.cellY),
      px = tonumber(player.px),
      py = tonumber(player.py),
      targetX = tonumber(player.targetX),
      targetY = tonumber(player.targetY),
      facing = player.facing or "down",
      capturedReason = reason,
      capturedAt = debugLogger:timestamp(),
    }
    glitchCityHandoff.origin = origin
    captureGlitchCityAudio(reason or "origin_capture")
    debugLogger:log("ORIGIN CAPTURED", (reason or "unknown") .. " " .. playerStateSummary(world)
      .. " " .. musicStateSummary())
    return origin
  end

  debugLogger:beginSession()
  debugLogger:log("MOD INITIALIZED", "session=" .. debugLogger:safeField(debugLogger.sessionId)
    .. " version=" .. debugLogger.buildVersion .. " " .. debugLogger:gameVersionSummary()
    .. " log=" .. debugLogger.logFile)

  -- Clean shutdown marker. If the process crashes or is force-closed, the
  -- marker remains and the next launch records PREVIOUS SESSION UNCLEAN END.
  if love then
    local previousLoveQuit = love.quit
    love.quit = function(...)
      local cancel = false
      local ok, result = true, nil
      if previousLoveQuit then ok, result = pcall(previousLoveQuit, ...) end
      if ok and result == true then cancel = true end
      if cancel then
        debugLogger:log("SESSION END CANCELLED", "session=" .. debugLogger:safeField(debugLogger.sessionId))
      else
        debugLogger:endSession(ok and "love.quit" or ("love.quit error=" .. debugLogger:safeField(result)), playerStateSummary(activeWorld))
      end
      if not ok then error(result) end
      return result
    end
  end

  local JacredPostBattleMessageScreen = {}
  JacredPostBattleMessageScreen.__index =
    JacredPostBattleMessageScreen
  JacredPostBattleMessageScreen.isOpaque = false

  function JacredPostBattleMessageScreen.new(game_, battle_)
    local self =
      setmetatable({}, JacredPostBattleMessageScreen)
    self.game = game_
    self.battle = battle_
    self.frames = 0
    self.finished = false
    self.releaseFrames = 0
    self.page = 1
    self.pageOpen = false
    self.phase = "fade"
    self.whiteAlpha = 0
    self.fadeFrames = 60
    self.whiteHoldFrames = 24
    self.pages = {
      -- Keep the hidden Poké Ball battle ending minimal. The detailed
      -- corruption/recovery messaging now belongs to the overworld-side
      -- Glitch City flow that follows this safe battle teardown.
      "THE BATTLE ENDED\nSAFELY.",
    }
    return self
  end

  function JacredPostBattleMessageScreen:finish()
    if self.finished then return end
    self.finished = true

    if self.game.stack:top() == self then
      self.game.stack:pop()
    end

    -- Mirror the POKéTRAINER recovery path: keep the malformed battle alive
    -- beneath the full-screen white recovery presentation, and only tear it
    -- down after the player has read and dismissed every message page.
    local battle = self.battle
    if battle and self.game.stack:top() == battle then
      battle.result = "run"
      battle:finish()
    end

    -- Arm the overworld-side handoff only after the stable hidden-ball
    -- recovery sequence has completely finished and native battle teardown
    -- has been requested. No Glitch City subsystem runs inside the battle.
    if glitchCityHandoff.armed then
      glitchCityHandoff.armed = false
      glitchCityHandoff.pending = true
      glitchCityHandoff.idleFrames = 0
    end
  end

  function JacredPostBattleMessageScreen:showCurrentPage()
    if self.finished or self.pageOpen then return end

    local message = self.pages[self.page]
    if not message then
      self:finish()
      return
    end

    self.pageOpen = true
    local controller = self
    self.game.stack:push(TextBox.new(
      self.game,
      message,
      function()
        -- Return to the controller between pages. The next page is not pushed
        -- until A and B have both been released for several frames, preventing
        -- one held button press from skipping the complete recovery message.
        controller.pageOpen = false
        controller.page = controller.page + 1
        controller.frames = 0
        controller.releaseFrames = 0
      end
    ))
  end

  function JacredPostBattleMessageScreen:update(_dt)
    if self.finished or self.pageOpen then return end
    self.frames = self.frames + 1

    if self.phase == "fade" then
      self.whiteAlpha = math.min(1, self.frames / self.fadeFrames)
      if self.frames >= self.fadeFrames then
        self.phase = "white_hold"
        self.frames = 0
        self.whiteAlpha = 1
      end
      return
    end

    if self.phase == "white_hold" then
      self.whiteAlpha = 1
      if self.frames >= self.whiteHoldFrames then
        self.phase = "message"
        self.frames = 0
        self.releaseFrames = 0
      end
      return
    end

    local input = self.game and self.game.input
    local released =
      input
      and not input:isDown("a")
      and not input:isDown("b")

    if released then
      self.releaseFrames = self.releaseFrames + 1
    else
      self.releaseFrames = 0
    end

    -- Require both a short visual pause and a clean button release before
    -- presenting every page, including the first one after battle teardown.
    if self.frames >= 12 and self.releaseFrames >= 8 then
      self:showCurrentPage()
    end
  end

  function JacredPostBattleMessageScreen:draw()
    -- Mirror the POKéTRAINER recovery presentation exactly: the active battle
    -- remains underneath while a full-screen white field fades in and stays
    -- behind every readable recovery page until the sequence is dismissed.
    if self.whiteAlpha > 0 then
      love.graphics.setColor(1, 1, 1, self.whiteAlpha)
      love.graphics.rectangle("fill", 0, 0, 160, 144)
      love.graphics.setColor(1, 1, 1, 1)
    end
  end

  local JacredSafeExitScreen = {}
  JacredSafeExitScreen.__index = JacredSafeExitScreen
  JacredSafeExitScreen.isOpaque = false

  function JacredSafeExitScreen.new(game_, battle_)
    local self = setmetatable({}, JacredSafeExitScreen)
    self.game = game_
    self.battle = battle_
    self.frames = 0
    self.finished = false
    return self
  end

  function JacredSafeExitScreen:update(_dt)
    if self.finished then return end
    self.frames = self.frames + 1

    -- Wait until the battle action callback has fully returned before
    -- changing the screen stack or invoking native battle teardown.
    if self.frames < 2 then return end

    self.finished = true

    if self.game.stack:top() == self then
      self.game.stack:pop()
    end

    local battle = self.battle
    if battle and self.game.stack:top() == battle then
      -- Do not end the battle yet. Keep its completed blocked-ball frame under
      -- the same full-screen white recovery presentation used by POKéTRAINER.
      -- JacredPostBattleMessageScreen performs safe teardown only after the
      -- final page has been read and dismissed.
      self.game.stack:push(
        JacredPostBattleMessageScreen.new(self.game, battle)
      )
    end
  end

  function JacredSafeExitScreen:draw()
    -- Preserve the completed blocked-ball battle frame underneath.
  end

  local TrainerFlyDiagnosticScreen = {}
  TrainerFlyDiagnosticScreen.__index = TrainerFlyDiagnosticScreen
  TrainerFlyDiagnosticScreen.isOpaque = false

  function TrainerFlyDiagnosticScreen.new(game_, message, onClose)
    local self = setmetatable({}, TrainerFlyDiagnosticScreen)
    self.game = game_
    self.message = message or "TRAINER-FLY\nDIAGNOSTIC"
    self.onClose = onClose
    self.frames = 0
    self.closed = false
    return self
  end

  function TrainerFlyDiagnosticScreen:close()
    if self.closed then return end
    self.closed = true

    if self.game.stack:top() == self then
      self.game.stack:pop()
    end

    if self.onClose then
      local callback = self.onClose
      self.onClose = nil
      callback()
    end
  end

  function TrainerFlyDiagnosticScreen:update(_dt)
    self.frames = self.frames + 1
    local input = self.game.input

    if self.frames >= 30
       and (input:wasPressed("a") or input:wasPressed("b")) then
      self:close()
      return
    end

    if self.frames >= 150 then
      self:close()
    end
  end

  function TrainerFlyDiagnosticScreen:draw()
    love.graphics.setColor(1, 1, 1, 1)
    Font.drawBox(1, 1, 18, 6)
    love.graphics.setColor(0, 0, 0, 1)

    local lines = {}
    local message = tostring(self.message) .. "\n"
    for line in message:gmatch("(.-)\n") do
      lines[#lines + 1] = line
    end

    local firstY = #lines > 1 and 24 or 32
    for i, line in ipairs(lines) do
      local width = #line * 8
      local x = math.floor((160 - width) / 2)
      Font.draw(line, x, firstY + ((i - 1) * 16))
    end

    local prompt = "A/B: CONTINUE"
    Font.draw(prompt, math.floor((160 - (#prompt * 8)) / 2), 64)
    love.graphics.setColor(1, 1, 1, 1)
  end

  local CrashRecoveryScreen = {}
  CrashRecoveryScreen.__index = CrashRecoveryScreen
  CrashRecoveryScreen.isOpaque = false

  function CrashRecoveryScreen.new(game_, opts)
    local self = setmetatable({}, CrashRecoveryScreen)
    self.game = game_
    self.opts = opts or {}
    self.battle = self.opts.battle
    self.frame = 0
    self.phase = "battle"
    self.whiteAlpha = 0
    self.messageShown = false
    self.finished = false
    self.hangSource = nil

    local ok, source = pcall(
      love.audio.newSource,
      self.opts.hangTonePath,
      "static"
    )
    if ok and source then
      source:setLooping(true)
      source:setVolume(0.55)
      self.hangSource = source
    else
      mod.log:error("Could not create crash hang tone: %s", tostring(source))
    end

    return self
  end

  function CrashRecoveryScreen:startHang()
    if self.phase ~= "battle" then return end
    self.phase = "hang"
    self.frame = 0

    -- The original crash leaves the music engine stuck on one sustained
    -- channel state. Stop the song and replace it with a single looping tone.
    Music.stop()
    Sound.stopLoop("Low_Health_Alarm")
    if self.hangSource then self.hangSource:play() end
  end

  function CrashRecoveryScreen:showMessage()
    if self.messageShown then return end
    self.messageShown = true
    self.phase = "message"

    local pages = self.opts.messagePages or {
      "MEMORY CORRUPTION\nDETECTED!",
      "YOUR SAVE FILE WAS\nPROTECTED FROM DAMAGE.",
    }

    local function showPage(index)
      if not pages[index] then
        self:finish()
        return
      end

      self.game.stack:push(TextBox.new(
        self.game,
        pages[index],
        function() showPage(index + 1) end
      ))
    end

    showPage(1)
  end

  function CrashRecoveryScreen:finish()
    if self.finished then return end
    self.finished = true

    if self.hangSource then
      pcall(self.hangSource.stop, self.hangSource)
    end
    Sound.stopLoop("Low_Health_Alarm")

    if self.game.stack:top() == self then
      self.game.stack:pop()
    end

    local battle = self.battle
    if battle and self.game.stack:top() == battle then
      battle.result = "run"
      battle:finish()
    end
  end

  function CrashRecoveryScreen:update(_dt)
    if self.finished or self.messageShown then return end

    -- Because this controller is the top stack state, the underlying battle
    -- does not receive Game:update calls automatically. Advance only its
    -- presentation clock so introSlide, player/enemy sprite motion, palette
    -- effects, and other battle visuals continue without opening menus or
    -- processing combat.
    if self.battle and self.phase == "battle" then
      self.battle:tickFx()
    end

    self.frame = self.frame + 1

    local battleFrames = self.opts.battleFrames or 150
    local hangFrames = self.opts.hangFrames or 75
    local fadeFrames = self.opts.fadeFrames or 90
    local whiteFrames = self.opts.whiteFrames or 180

    if self.phase == "battle" then
      if self.frame >= battleFrames then
        self:startHang()
      end
      return
    end

    if self.phase == "hang" then
      if self.frame >= hangFrames then
        self.phase = "fade"
        self.frame = 0
      end
      return
    end

    if self.phase == "fade" then
      self.whiteAlpha = math.min(1, self.frame / fadeFrames)
      if self.frame >= fadeFrames then
        self.phase = "white"
        self.frame = 0
        self.whiteAlpha = 1
      end
      return
    end

    if self.phase == "white" then
      self.whiteAlpha = 1
      if self.frame >= whiteFrames then
        self:showMessage()
      end
    end
  end

  function CrashRecoveryScreen:draw()
    if self.opts.junkLines
       and (self.phase == "hang" or self.phase == "fade") then
      love.graphics.setColor(1, 1, 1, 1)
      for index, line in ipairs(self.opts.junkLines) do
        Font.draw(line, 8, 8 + (index - 1) * 16)
      end
    end

    if self.phase == "fade" or self.phase == "white"
       or self.phase == "message" then
      love.graphics.setColor(1, 1, 1, self.whiteAlpha)
      love.graphics.rectangle("fill", 0, 0, 160, 144)
      love.graphics.setColor(1, 1, 1, 1)
    end
  end

  local PokeTrainerBagScreen = {}
  PokeTrainerBagScreen.__index = PokeTrainerBagScreen
  PokeTrainerBagScreen.isOpaque = false

  local POKETRAINER_ROWS = 12
  local CANCEL_ROW = 13
  local FIRST_BLANK_ROW = 14
  local LAST_BLANK_ROW = 18
  local POKEBALL_ROW = 19
  local POKETRAINER_BAG_ROWS = 19
  local VISIBLE_BAG_ROWS = 5

  function PokeTrainerBagScreen.new(game_, opts)
    local self = setmetatable({}, PokeTrainerBagScreen)
    self.game = game_
    self.opts = opts or {}
    self.battle = self.opts.battle
    self.frame = 0
    self.cursor = 1
    self.scroll = 0
    self.introFrames = self.opts.introFrames or 105
    self.ready = false
    self.used = false
    return self
  end

  function PokeTrainerBagScreen:itemAt(row)
    if row <= POKETRAINER_ROWS then
      return "POKéTRAINER", "poketrainer", "×99"
    end

    if row == CANCEL_ROW then
      return "CANCEL", "cancel", ""
    end

    if row >= FIRST_BLANK_ROW and row <= LAST_BLANK_ROW then
      return "", "blank", ""
    end

    if row == POKEBALL_ROW then
      return "POKé BALL", "pokeball", "×1"
    end

    return "", "blank", ""
  end

  function PokeTrainerBagScreen:ensureVisible()
    if self.cursor <= self.scroll then
      self.scroll = self.cursor - 1
    elseif self.cursor > self.scroll + VISIBLE_BAG_ROWS then
      self.scroll = self.cursor - VISIBLE_BAG_ROWS
    end

    local maxScroll = POKETRAINER_BAG_ROWS - VISIBLE_BAG_ROWS
    self.scroll = math.max(0, math.min(maxScroll, self.scroll))
  end

  function PokeTrainerBagScreen:usePokeTrainer()
    if self.used then return end
    self.used = true

    if self.game.stack:top() == self then
      self.game.stack:pop()
    end

    self.game.stack:push(CrashRecoveryScreen.new(self.game, {
      battle = self.battle,
      hangTonePath = mod.assets:path(
        "assets/audio/music_hang_note.wav"),
      battleFrames = 30,
      hangFrames = 180,
      fadeFrames = 90,
      whiteFrames = 120,
      message =
        "POKéTRAINER\\nDISCARDED.\\f"
          .. "NO PERMANENT\\nDAMAGE WAS FOUND.",
      junkLines = {
        "99 99 99 99",
        "POKéTRAINER",
        "×♀7MN  99",
        "?????  ♂",
        "TRAINER 99",
      },
    }))

  end

  function PokeTrainerBagScreen:useHiddenPokeBall()
    if self.used then return end
    self.used = true

    -- This screen only exists for the documented ZZAZZ fake-Bag variants
    -- (Attack Modifier 5/6). Record a passive handoff marker, but do not run
    -- any Glitch City code until the stable battle recovery has fully ended.
    glitchCityHandoff.armed = true
    local world = activeWorld
    debugLogger:log("HIDDEN BALL SELECTED", playerStateSummary(world))
    if not glitchCityHandoff.origin then
      captureGlitchCityOrigin(world, "hidden_ball_fallback")
    else
      debugLogger:log("ORIGIN PRESERVED", "map=" .. debugLogger:safeField(glitchCityHandoff.origin.mapId)
        .. " cell=" .. debugLogger:safeField(glitchCityHandoff.origin.x) .. ","
        .. debugLogger:safeField(glitchCityHandoff.origin.y)
        .. " capturedReason=" .. debugLogger:safeField(glitchCityHandoff.origin.capturedReason))
    end

    -- Remove the temporary corrupted Bag first. This is a simulated item, so
    -- no real Poké Ball is consumed and the player's inventory is untouched.
    if self.game.stack:top() == self then
      self.game.stack:pop()
    end

    local battle = self.battle
    if not battle then return end

    Sound.stopLoop("Low_Health_Alarm")

    -- Reproduce ThrowBallAtTrainerMon using BattleState's native animation
    -- queue, but replace the normal enemy turn with the historical corrupted
    -- instant-exit result.
    battle.phase = "messages"
    battle.queue = {}
    battle.afterQueue = nil

    require("src.core.Sound").play(battle.data, "Ball_Toss")
    battle:animNext("TOSS_ANIM", true, nil, "POKE_BALL")
    battle:actNext(function()
      require("src.core.Sound").play(battle.data, "Faint_Thud")
    end)
    battle:animNext("BLOCKBALL_ANIM", true)

    local text = battle.data.text
    battle:sayNext(
      text._ThrowBallAtTrainerMonText1
        or battle:romText(
          "_ThrowBallAtTrainerMonText1",
          "The trainer\nblocked the BALL!"
        )
    )
    battle:sayNext(
      text._ThrowBallAtTrainerMonText2
        or battle:romText(
          "_ThrowBallAtTrainerMonText2",
          "Don't be a thief!"
        )
    )

    battle:actNext(function()
      -- Never finish a battle while its action queue is still executing.
      -- Hand control to a temporary top-level screen and perform teardown on
      -- the following update tick.
      battle.game.stack:push(
        JacredSafeExitScreen.new(battle.game, battle)
      )
    end)

  end

  function PokeTrainerBagScreen:useSelectedItem()
    local _name, kind = self:itemAt(self.cursor)

    if kind == "pokeball" then
      self:useHiddenPokeBall()
      return
    end

    if kind == "poketrainer" then
      self:usePokeTrainer()
      return
    end

    -- The fake CANCEL and blank entries are part of the corrupted inventory
    -- layout. They do not close the Bag and do not touch the real inventory.
    Sound.play(self.game.data, "Press_AB")
  end

  function PokeTrainerBagScreen:update(_dt)
    self.frame = self.frame + 1

    if not self.ready then
      if self.battle then self.battle:tickFx() end
      if self.frame >= self.introFrames then
        self.ready = true
        self.frame = 0
      end
      return
    end

    local input = self.game.input
    if input:wasPressed("up") then
      self.cursor = self.cursor - 1
      if self.cursor < 1 then
        self.cursor = POKETRAINER_BAG_ROWS
      end
      self:ensureVisible()
    elseif input:wasPressed("down") then
      self.cursor = self.cursor + 1
      if self.cursor > POKETRAINER_BAG_ROWS then
        self.cursor = 1
      end
      self:ensureVisible()
    elseif input:wasPressed("a") then
      self:useSelectedItem()
    end
  end

  function PokeTrainerBagScreen:draw()
    if not self.ready then return end

    love.graphics.setColor(1, 1, 1, 1)
    Font.drawBox(1, 1, 18, 16)
    Font.draw("ITEM", 16, 16)

    for visibleRow = 1, VISIBLE_BAG_ROWS do
      local itemRow = self.scroll + visibleRow
      local itemName, _kind, quantity = self:itemAt(itemRow)
      local y = 32 + (visibleRow - 1) * 16
      local cursor = itemRow == self.cursor and "▶" or " "

      Font.draw(cursor .. itemName, 16, y)
      if quantity ~= "" then
        Font.draw(quantity, 120, y)
      end
    end

    if self.scroll > 0 then
      Font.draw("▲", 144, 16)
    end
    if self.scroll < POKETRAINER_BAG_ROWS - VISIBLE_BAG_ROWS then
      Font.draw("▼", 144, 112)
    end

    Font.draw("A:USE", 16, 120)
  end

  local GlitchEffectScreen = {}
  GlitchEffectScreen.__index = GlitchEffectScreen
  GlitchEffectScreen.isOpaque = true

  local DMG_SHADES = { 1.0, 0.67, 0.33, 0.0 }

  local function readBinary(path)
    -- Mod assets are mounted in LÖVE's virtual filesystem. io.open() only
    -- sees the host filesystem, which caused alpha7 to crash even though the
    -- files were correctly packaged.
    local ok, data = pcall(love.filesystem.read, path)
    if ok and data then return data end

    -- Development-tree fallback for unpacked local testing.
    local file = io.open(path, "rb")
    if file then
      data = file:read("*a")
      file:close()
      return data
    end

    mod.log:error("G1GPP raw effect asset missing: %s", tostring(path))
    return nil
  end

  local function byte(data, offset)
    return string.byte(data, offset + 1) or 0
  end

  local function paletteShade(palette, color)
    local shade = math.floor(palette / (2 ^ (color * 2))) % 4
    return DMG_SHADES[shade + 1]
  end

  local function tilePixel(vram, tileIndex, px, py, unsignedMode)
    local tileOffset
    if unsignedMode then
      tileOffset = tileIndex * 16
    else
      local signed = tileIndex >= 128 and tileIndex - 256 or tileIndex
      tileOffset = 0x1000 + signed * 16
    end
    local lo = byte(vram, tileOffset + py * 2)
    local hi = byte(vram, tileOffset + py * 2 + 1)
    local bit = 7 - px
    return math.floor(lo / (2 ^ bit)) % 2
      + 2 * (math.floor(hi / (2 ^ bit)) % 2)
  end

  local function renderGameBoyFrame(vram, oam, regs, suppressSprites)
    local lcdc = byte(regs, 0)
    local scy = byte(regs, 2)
    local scx = byte(regs, 3)
    local bgp = byte(regs, 7)
    local obp0 = byte(regs, 8)
    local obp1 = byte(regs, 9)
    local wy = byte(regs, 10)
    local wx = byte(regs, 11) - 7

    local bgEnabled = lcdc % 2 == 1
    local spritesEnabled = math.floor(lcdc / 2) % 2 == 1
    local spriteHeight = math.floor(lcdc / 4) % 2 == 1 and 16 or 8
    local bgMap = math.floor(lcdc / 8) % 2 == 1 and 0x1C00 or 0x1800
    local unsignedTiles = math.floor(lcdc / 16) % 2 == 1
    local windowEnabled = math.floor(lcdc / 32) % 2 == 1
    local windowMap = math.floor(lcdc / 64) % 2 == 1 and 0x1C00 or 0x1800

    local imageData = love.image.newImageData(160, 144)
    local bgColors = {}

    for y = 0, 143 do
      bgColors[y] = {}
      for x = 0, 159 do
        local color = 0
        if bgEnabled then
          local useWindow = windowEnabled and y >= wy and x >= wx
          local mapBase, mapX, mapY
          if useWindow then
            mapBase = windowMap
            mapX = x - wx
            mapY = y - wy
          else
            mapBase = bgMap
            mapX = (x + scx) % 256
            mapY = (y + scy) % 256
          end
          local tileX = math.floor(mapX / 8)
          local tileY = math.floor(mapY / 8)
          local tileIndex = byte(vram, mapBase + tileY * 32 + tileX)
          color = tilePixel(vram, tileIndex, mapX % 8, mapY % 8, unsignedTiles)
        end
        bgColors[y][x] = color
        local shade = paletteShade(bgp, color)
        imageData:setPixel(x, y, shade, shade, shade, 1)
      end
    end

    if spritesEnabled and not suppressSprites then
      -- Draw later OAM entries first so lower-index sprites retain priority.
      for sprite = 39, 0, -1 do
        local base = sprite * 4
        local sy = byte(oam, base) - 16
        local sx = byte(oam, base + 1) - 8
        local tile = byte(oam, base + 2)
        local attr = byte(oam, base + 3)
        local xflip = math.floor(attr / 32) % 2 == 1
        local yflip = math.floor(attr / 64) % 2 == 1
        local behind = math.floor(attr / 128) % 2 == 1
        local palette = math.floor(attr / 16) % 2 == 1 and obp1 or obp0
        if spriteHeight == 16 then tile = tile - (tile % 2) end

        for oy = 0, spriteHeight - 1 do
          local py = yflip and (spriteHeight - 1 - oy) or oy
          local tileNumber = tile + math.floor(py / 8)
          local tileY = py % 8
          local yy = sy + oy
          if yy >= 0 and yy < 144 then
            for ox = 0, 7 do
              local xx = sx + ox
              if xx >= 0 and xx < 160 then
                local tileX = xflip and (7 - ox) or ox
                local color = tilePixel(vram, tileNumber, tileX, tileY, true)
                if color ~= 0 and (not behind or bgColors[yy][xx] == 0) then
                  local shade = paletteShade(palette, color)
                  imageData:setPixel(xx, yy, shade, shade, shade, 1)
                end
              end
            end
          end
        end
      end
    end

    local image = love.graphics.newImage(imageData)
    image:setFilter("nearest", "nearest")
    return image, imageData
  end

  function GlitchEffectScreen.new(game_, opts)
    local self = setmetatable({}, GlitchEffectScreen)
    self.game = game_
    self.opts = opts or {}
    self.battle = self.opts.battle
    self.frame = 0
    self.finished = false
    self.renderedFrames = {}
    self.backgroundFrames = {}
    self.trainerComposite = nil
    return self
  end

  function GlitchEffectScreen:loadRenderedFrame(index)
    if self.renderedFrames[index] then return self.renderedFrames[index] end
    local entry = self.opts.rawFrames[index]
    if not entry then return nil end
    local vram = readBinary(entry.vram)
    local oam = readBinary(entry.oam)
    local regs = readBinary(entry.regs)
    if not (vram and oam and regs) then
      return nil
    end
    local image = renderGameBoyFrame(vram, oam, regs)
    self.renderedFrames[index] = image
    return image
  end

  function GlitchEffectScreen:loadBackgroundFrame(index)
    if self.backgroundFrames[index] then
      return self.backgroundFrames[index]
    end
    local entry = self.opts.rawFrames[index]
    if not entry then return nil end
    local vram = readBinary(entry.vram)
    local oam = readBinary(entry.oam)
    local regs = readBinary(entry.regs)
    if not (vram and oam and regs) then return nil end
    local image = renderGameBoyFrame(vram, oam, regs, true)
    self.backgroundFrames[index] = image
    return image
  end

  function GlitchEffectScreen:loadTrainerComposite()
    if self.trainerComposite then return self.trainerComposite end
    local frames = self.opts.rawFrames or {}
    if #frames == 0 then return nil end

    local entry = frames[#frames]
    local vram = readBinary(entry.vram)
    local oam = readBinary(entry.oam)
    local regs = readBinary(entry.regs)
    if not (vram and oam and regs) then return nil end

    -- renderGameBoyFrame returns the ImageData it used to create the GPU
    -- image. Image:newImageData() is not available in this recomp's LÖVE
    -- version, so retain the CPU-side data directly.
    local _fullImage, full = renderGameBoyFrame(vram, oam, regs, false)
    local _baseImage, base = renderGameBoyFrame(vram, oam, regs, true)
    if not (full and base) then
      mod.log:error("Could not build trainer composite ImageData")
      return nil
    end

    -- Assemble the complete lower-left player-trainer sprite by retaining
    -- every pixel contributed by OAM in the final captured frame.
    local x0, y0, width, height = 0, 32, 88, 104
    local composite = love.image.newImageData(width, height)

    for y = 0, height - 1 do
      for x = 0, width - 1 do
        local fr, fg, fb, fa = full:getPixel(x0 + x, y0 + y)
        local br, bg, bb = base:getPixel(x0 + x, y0 + y)
        local different =
          math.abs(fr - br) > 0.01
          or math.abs(fg - bg) > 0.01
          or math.abs(fb - bb) > 0.01

        if different then
          composite:setPixel(x, y, fr, fg, fb, fa)
        else
          composite:setPixel(x, y, 1, 1, 1, 0)
        end
      end
    end

    local image = love.graphics.newImage(composite)
    image:setFilter("nearest", "nearest")
    self.trainerComposite = image
    return image
  end

  function GlitchEffectScreen:finish()
    if self.finished then return end
    self.finished = true
    Sound.stopLoop("Low_Health_Alarm")
    if self.game.stack:top() == self then self.game.stack:pop() end
    local battle = self.battle
    if battle and self.game.stack:top() == battle then
      battle.result = "run"
      battle:finish()
    end
  end

  function GlitchEffectScreen:update(_dt)
    self.frame = self.frame + 1
    local input = self.game.input
    if self.frame >= (self.opts.minimumFrames or 120)
       and (input:wasPressed("a") or input:wasPressed("b")) then
      self:finish()
      return
    end
    if self.frame >= (self.opts.totalFrames or 300) then self:finish() end
  end

  function GlitchEffectScreen:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, 160, 144)
    local frames = self.opts.rawFrames or {}
    if #frames == 0 then return end

    local cadence = self.opts.frameCadence or 3
    local index = math.min(#frames, math.floor(self.frame / cadence) + 1)

    if self.opts.compositeTrainerEntry then
      -- Replay captured VRAM/window animation without raw OAM. This removes
      -- both the detached head movement and the lingering glitch Pokémon.
      local background = self:loadBackgroundFrame(index)
      if background then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(background, 0, 0)
      end

      local trainer = self:loadTrainerComposite()
      if trainer then
        local entryFrames = self.opts.trainerEntryFrames or 54
        local progress = math.min(1, self.frame / entryFrames)
        progress = progress * progress * (3 - 2 * progress)

        local startX = self.opts.trainerStartX or 160
        local finalX = self.opts.trainerFinalX or 0
        local drawX = math.floor(startX + (finalX - startX) * progress)
        local drawY = self.opts.trainerFinalY or 32

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(trainer, drawX, drawY)
      end
    else
      local image = self:loadRenderedFrame(index)
      if image then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(image, 0, 0)
      end
    end
  end

  -- Dedicated 0-255 Special-value editor.
  --
  -- The stock number option allows left/right changes directly on the row and
  -- its QuantityBox only reacts to fresh button presses. This screen is scoped
  -- to Trainer-Fly's debug value and provides intentional A-to-edit behavior
  -- plus accelerating held input.

  local QUICK_WARP_FILE = "trainer_fly/quick_warp_v1.dat"

  -- Curated from the actual Red/Blue/Yellow extracted map warp tables. Each
  -- exterior landing is one cell below its destination door and faces up, so
  -- selecting a testing landmark never spawns the player on an active warp.
  -- The three supported editions currently share these IDs and coordinates;
  -- live map validation still rejects a missing destination safely.
  local WARP_ANYWHERE_DESTINATIONS = {
    { label = "PC - VIRIDIAN", mapId = "VIRIDIAN_CITY", x = 23, y = 26 },
    { label = "PC - PEWTER", mapId = "PEWTER_CITY", x = 13, y = 26 },
    { label = "PC - MT MOON", mapId = "ROUTE_4", x = 11, y = 6 },
    { label = "PC - CERULEAN", mapId = "CERULEAN_CITY", x = 19, y = 18 },
    { label = "PC - ROCK TUNNEL", mapId = "ROUTE_10", x = 11, y = 20 },
    { label = "PC - LAVENDER", mapId = "LAVENDER_TOWN", x = 3, y = 6 },
    { label = "PC - VERMILION", mapId = "VERMILION_CITY", x = 11, y = 4 },
    { label = "PC - CELADON", mapId = "CELADON_CITY", x = 41, y = 10 },
    { label = "PC - FUCHSIA", mapId = "FUCHSIA_CITY", x = 19, y = 28 },
    { label = "PC - SAFFRON", mapId = "SAFFRON_CITY", x = 9, y = 30 },
    { label = "PC - CINNABAR", mapId = "CINNABAR_ISLAND", x = 11, y = 12 },
    { label = "INDIGO PLATEAU", mapId = "INDIGO_PLATEAU", x = 9, y = 6 },

    { label = "OAK'S LAB", mapId = "PALLET_TOWN", x = 12, y = 12 },
    { label = "BILL'S HOUSE", mapId = "ROUTE_25", x = 45, y = 4 },
    { label = "S.S. ANNE", mapId = "VERMILION_DOCK", x = 14, y = 3 },
    { label = "POKEMON TOWER", mapId = "LAVENDER_TOWN", x = 14, y = 6 },
    { label = "SILPH CO.", mapId = "SAFFRON_CITY", x = 18, y = 22 },
    { label = "SAFARI ZONE", mapId = "FUCHSIA_CITY", x = 18, y = 4 },
    { label = "POWER PLANT", mapId = "ROUTE_10", x = 6, y = 40 },
    { label = "POKEMON MANSION", mapId = "CINNABAR_ISLAND", x = 6, y = 4 },
    { label = "CINNABAR LAB", mapId = "CINNABAR_ISLAND", x = 6, y = 10 },
    { label = "CERULEAN CAVE", mapId = "CERULEAN_CITY", x = 4, y = 12 },
    { label = "DAY CARE", mapId = "ROUTE_5", x = 10, y = 22 },
    { label = "ROCKET HIDEOUT", mapId = "GAME_CORNER", x = 17, y = 5 },
    { label = "FIGHTING DOJO", mapId = "SAFFRON_CITY", x = 26, y = 4 },
    { label = "VICTORY ROAD", mapId = "ROUTE_23", x = 4, y = 32 },
    { label = "MT. MOON", mapId = "ROUTE_4", x = 18, y = 6 },
    { label = "ROCK TUNNEL", mapId = "ROUTE_10", x = 8, y = 18 },
    { label = "SEAFOAM - WEST", mapId = "ROUTE_20", x = 48, y = 6 },
    { label = "SEAFOAM - EAST", mapId = "ROUTE_20", x = 58, y = 10 },
    { label = "DIGLETT - ROUTE 2", mapId = "DIGLETTS_CAVE_ROUTE_2", x = 4, y = 5 },
    { label = "DIGLETT - ROUTE 11", mapId = "DIGLETTS_CAVE_ROUTE_11", x = 4, y = 5 },

    { label = "GYM - PEWTER", mapId = "PEWTER_CITY", x = 16, y = 18 },
    { label = "GYM - CERULEAN", mapId = "CERULEAN_CITY", x = 30, y = 20 },
    { label = "GYM - VERMILION", mapId = "VERMILION_CITY", x = 12, y = 20 },
    { label = "GYM - CELADON", mapId = "CELADON_CITY", x = 12, y = 28 },
    { label = "GYM - FUCHSIA", mapId = "FUCHSIA_CITY", x = 5, y = 28 },
    { label = "GYM - SAFFRON", mapId = "SAFFRON_CITY", x = 34, y = 4 },
    { label = "GYM - CINNABAR", mapId = "CINNABAR_ISLAND", x = 18, y = 4 },
    { label = "GYM - VIRIDIAN", mapId = "VIRIDIAN_CITY", x = 32, y = 8 },
  }

  local function validateQuickWarp(point)
    return type(point) == "table"
      and type(point.mapId) == "string" and point.mapId ~= ""
      and type(point.x) == "number" and type(point.y) == "number"
      and type(point.facing) == "string"
  end

  local function saveQuickWarpFile(point)
    local ok = pcall(function()
      love.filesystem.createDirectory("trainer_fly")
      local payload = table.concat({
        "version=1",
        "map=" .. tostring(point.mapId),
        "x=" .. tostring(math.floor(point.x)),
        "y=" .. tostring(math.floor(point.y)),
        "facing=" .. tostring(point.facing),
      }, "\n")
      assert(love.filesystem.write(QUICK_WARP_FILE, payload))
    end)
    return ok
  end

  local function loadQuickWarpFile()
    if not love.filesystem.getInfo(QUICK_WARP_FILE) then return nil end
    local ok, payload = pcall(love.filesystem.read, QUICK_WARP_FILE)
    if not ok or type(payload) ~= "string" then return nil end
    local fields = {}
    for line in payload:gmatch("[^\r\n]+") do
      local k, v = line:match("^([^=]+)=(.*)$")
      if k then fields[k] = v end
    end
    local point = {
      version = tonumber(fields.version),
      mapId = fields.map,
      x = tonumber(fields.x),
      y = tonumber(fields.y),
      facing = fields.facing,
    }
    if point.version ~= 1 or not validateQuickWarp(point) then return nil end
    return point
  end

  setQuickWarpPoint = function()
    local world = activeWorld
    local player = world and world.player
    local map = world and world.map
    -- This action runs from the mod-options screen, with the overworld
    -- underneath it. Capturing coordinates is read-only, so require only a
    -- valid current map/player position.
    if not (world and player and map and game
       and type(map.id) == "string"
       and type(player.cellX) == "number"
       and type(player.cellY) == "number") then
      if game then
        game.stack:push(TextBox.new(
          game,
          "WARP POINT CANNOT\nBE SET RIGHT NOW."
        ))
      end
      return false
    end

    local point = {
      version = 1, mapId = map.id,
      x = player.cellX, y = player.cellY,
      facing = player.facing or "down",
    }

    if not saveQuickWarpFile(point) then
      game.stack:push(TextBox.new(game, "WARP POINT COULD\nNOT BE SAVED."))
      return false
    end

    quickWarpPoint = point
    game.stack:push(TextBox.new(game,
      "WARP POINT SET.\n" .. tostring(point.mapId) ..
      "  " .. tostring(point.x) .. "," .. tostring(point.y)))
    return true
  end

  clearQuickWarpPoint = function()
    quickWarpPoint = nil
    pcall(love.filesystem.remove, QUICK_WARP_FILE)
    if game then
      game.stack:push(TextBox.new(game, "WARP POINT CLEARED."))
    end
    return true
  end

  performQuickWarp = function()
    local world = activeWorld
    local point = quickWarpPoint
    if not (world and validateQuickWarp(point)
       and game and game.stack:top() == world
       and not world.transitioning
       and not world.runner:isRunning()) then
      return false
    end

    escape = nil
    intermediaryBattle = nil
    forceMenuPending = false
    forcedMenu = nil
    world.emote = nil
    world.engaging = false
    if world.player then world.player.inputLocked = false end

    -- Use the same departure sound as Abra's native TELEPORT field move.
    Sound.play(game.data, "Teleport_Exit1")

    local ok = pcall(function()
      world:setMap(point.mapId, math.floor(point.x), math.floor(point.y),
        point.facing, { via = "trainer_fly_quick_warp" })
    end)
    if not ok then
      game.stack:push(TextBox.new(game, "WARP POINT IS\nNO LONGER VALID."))
      return false
    end
    return true
  end

  local function validateCatalogDestination(liveGame, point)
    return validateQuickWarp(point)
      and liveGame and liveGame.data and liveGame.data.maps
      and liveGame.data.maps[point.mapId] ~= nil
  end

  openWarpAnywhereMenu = function(menuGame)
    if not (menuGame and menuGame.stack) then return false end
    local items = {}
    for _, destination in ipairs(WARP_ANYWHERE_DESTINATIONS) do
      if validateCatalogDestination(menuGame, {
          mapId = destination.mapId, x = destination.x, y = destination.y,
          facing = destination.facing or "up",
        }) then
        items[#items + 1] = {
          label = destination.label,
          value = destination,
        }
      end
    end
    debugLogger:log("WARP ANYWHERE MENU OPENED",
      "available=" .. debugLogger:safeField(#items)
        .. " catalog=" .. debugLogger:safeField(#WARP_ANYWHERE_DESTINATIONS)
        .. " " .. debugLogger:gameVersionSummary())
    menuGame.stack:push(ListMenu.new(menuGame, "WARP ANYWHERE", items, {
      pageJump = true,
      keyRepeat = true,
      wrap = true,
      onChoose = function(item, list)
        local destination = item and item.value
        if not destination then return end
        warpAnywherePending = {
          mapId = destination.mapId,
          x = destination.x,
          y = destination.y,
          facing = destination.facing or "up",
          label = destination.label,
        }
        list:close()
        debugLogger:log("WARP ANYWHERE QUEUED",
          "label=" .. debugLogger:safeField(destination.label)
            .. " map=" .. debugLogger:safeField(destination.mapId)
            .. " x=" .. debugLogger:safeField(destination.x)
            .. " y=" .. debugLogger:safeField(destination.y)
            .. " executeAfterModsClose=true")
      end,
    }))
    return true
  end

  performWarpAnywhere = function()
    local world = activeWorld
    local point = warpAnywherePending
    if not (world and validateCatalogDestination(game, point)
       and game and game.stack:top() == world
       and not world.transitioning
       and not world.runner:isRunning()) then
      return false
    end
    warpAnywherePending = nil
    escape = nil
    intermediaryBattle = nil
    forceMenuPending = false
    forcedMenu = nil
    world.emote = nil
    world.engaging = false
    if world.player then world.player.inputLocked = false end
    debugLogger:log("WARP ANYWHERE START",
      "label=" .. debugLogger:safeField(point.label)
        .. " map=" .. debugLogger:safeField(point.mapId)
        .. " x=" .. debugLogger:safeField(point.x) .. " y=" .. debugLogger:safeField(point.y))
    Sound.play(game.data, "Teleport_Exit1")
    local ok, warpError = pcall(function()
      world:setMap(point.mapId, math.floor(point.x), math.floor(point.y),
        point.facing, { via = "trainer_fly_warp_anywhere" })
    end)
    if not ok then
      debugLogger:log("WARP ANYWHERE FAILED",
        "label=" .. debugLogger:safeField(point.label)
          .. " error=" .. debugLogger:safeField(warpError))
      game.stack:push(TextBox.new(game, "WARP DESTINATION\nIS NOT AVAILABLE."))
      return false
    end
    debugLogger:log("WARP ANYWHERE COMPLETE",
      "label=" .. debugLogger:safeField(point.label) .. " " .. playerStateSummary(world))
    return true
  end

  -- Quick Warp now integrates directly into the native Start menu.
  -- The menu item is added only while a valid saved point exists.

  function ManagerState.G1.open(menuGame)
    local manager = ManagerState.new(menuGame)
    menuGame.stack:push(manager)
    local target = manager.byId and manager.byId[mod.id]
    local schema = target and manager:schemaFor(target)
    if not (target and schema) then
      debugLogger:log("START MENU DEBUG SHORTCUT FAILED",
        "targetAvailable=" .. debugLogger:safeField(target ~= nil)
          .. " schemaAvailable=" .. debugLogger:safeField(schema ~= nil))
      manager:notify("G1GPP OPTIONS UNAVAILABLE")
      return false
    end

    manager.currentMod = target
    manager.optionRows = manager:buildOptionRows(target, schema)
    manager.screen = "options"
    manager.cursor = 1
    manager.scroll = 0
    manager.backStack = {}
    manager._g1gppDirectOptions = true
    debugLogger:log("START MENU DEBUG SHORTCUT OPENED",
      "rows=" .. debugLogger:safeField(#(manager.optionRows or {}))
        .. " returnTarget=overworld")
    return true
  end

  -- Add Quick Warp to the real Start menu without replacing any vanilla
  -- entries. A cleared/invalid point removes the row automatically the next
  -- time the menu is opened.
  mod.hooks:wrap("ui.start_menu.items", function(next, game_, items)
    items = next(game_, items) or items

    -- Compact native-menu shortcut. The stock Start menu is only eleven tiles
    -- wide, so the row uses the recognizable project acronym; it opens this
    -- mod's option rows directly and B returns to the overworld.
    -- SAVE immediately follows the Trainer-name row in the native menu.
    mod.ui.insertBefore(items, "SAVE", {
      label = "G1GPP",
      onSelect = function()
        ManagerState.G1.open(game_)
      end,
    })

    if glitchCityHandoff.active then
      for _, item in ipairs(items or {}) do
        if tostring(item.label or ""):upper() == "SAVE" then
          item.label = "S△V?▓"
          item.onSelect = function()
            game_.stack:push(TextBox.new(game_, "SAVE DATA IS\nINACCESSIBLE."))
          end
        end
      end
    end

    if validateQuickWarp(quickWarpPoint) then
      mod.ui.insertBefore(items, "QUIT", {
        label = "WARP POINT",
        onSelect = function()
          -- Let the native Start menu close itself, then show the mod-owned
          -- WARP / CANCEL confirmation once the overworld is safely topmost.
          -- This deliberately does not invoke Abra's TELEPORT field move.
          quickWarpConfirmPending = true
        end,
      })
    end

    return items
  end)

  local QuickWarpConfirmMenu = {}
  QuickWarpConfirmMenu.__index = QuickWarpConfirmMenu
  QuickWarpConfirmMenu.isOpaque = false

  function QuickWarpConfirmMenu.new(game_)
    local self = setmetatable({}, QuickWarpConfirmMenu)
    self.game = game_
    self.cursor = 1
    self.released = false
    return self
  end

  function QuickWarpConfirmMenu:update(_dt)
    local input = self.game.input
    if not self.released then
      self.released = not input:isDown("start")
        and not input:isDown("select")
        and not input:isDown("a") and not input:isDown("b")
      return
    end

    if input:wasPressed("up") or input:wasPressed("down") then
      self.cursor = self.cursor == 1 and 2 or 1
      Sound.play(self.game.data, "Press_AB")
    elseif input:wasPressed("b") then
      self.game.stack:pop()
    elseif input:wasPressed("a") then
      local doWarp = self.cursor == 1
      self.game.stack:pop()
      if doWarp then
        -- Execute only after this confirmation screen has popped and the
        -- overworld is topmost again.
        quickWarpMenuPending = true
      end
    end
  end

  function QuickWarpConfirmMenu:draw()
    love.graphics.setColor(1, 1, 1, 1)
    Font.drawBox(9, 9, 11, 6)
    love.graphics.setColor(0, 0, 0, 1)
    Font.draw("WARP", 88, 88)
    Font.draw("CANCEL", 88, 104)
    Font.draw("▶", 72, self.cursor == 1 and 88 or 104)
    love.graphics.setColor(1, 1, 1, 1)
  end

  local SpecialValueEditor = {}
  SpecialValueEditor.__index = SpecialValueEditor
  SpecialValueEditor.isOpaque = false

  function SpecialValueEditor.new(game_, opts)
    local self = setmetatable({}, SpecialValueEditor)
    self.game = game_
    self.minimum = tonumber(opts.minimum) or 0
    self.maximum = tonumber(opts.maximum) or 255
    self.value = math.max(self.minimum, math.min(self.maximum,
      math.floor(tonumber(opts.start) or self.minimum)))
    self.onDone = opts.onDone
    self.heldDirection = nil
    self.heldFrames = 0
    return self
  end

  function SpecialValueEditor:step(direction)
    self.value = self.value + direction
    if self.value < self.minimum then
      self.value = self.maximum
    elseif self.value > self.maximum then
      self.value = self.minimum
    end
  end

  function SpecialValueEditor:update(_dt)
    local input = self.game.input
    local direction

    if input:isDown("up") then
      direction = 1
    elseif input:isDown("down") then
      direction = -1
    end

    if direction ~= self.heldDirection then
      self.heldDirection = direction
      self.heldFrames = 0

      -- A fresh press changes the value immediately.
      if direction then self:step(direction) end
    elseif direction then
      self.heldFrames = self.heldFrames + 1

      -- Initial pause, then deliberate repeat, then fast repeat.
      local repeatNow = false
      if self.heldFrames >= 18 and self.heldFrames < 54 then
        repeatNow = ((self.heldFrames - 18) % 6) == 0
      elseif self.heldFrames >= 54 and self.heldFrames < 90 then
        repeatNow = ((self.heldFrames - 54) % 3) == 0
      elseif self.heldFrames >= 90 then
        repeatNow = true
      end

      if repeatNow then self:step(direction) end
    else
      self.heldFrames = 0
    end

    if input:wasPressed("a") then
      self.game.stack:pop()
      if self.onDone then self.onDone(self.value) end
    elseif input:wasPressed("b") then
      self.game.stack:pop()
      if self.onDone then self.onDone(nil) end
    end
  end

  function SpecialValueEditor:draw()
    -- Same compact presentation as the stock quantity selector, but byte-wide
    -- and explicitly hexadecimal-looking through the leading multiply glyph.
    local tx, ty = 14, 9
    Font.drawBox(tx, ty, 6, 3)
    love.graphics.setColor(0, 0, 0, 1)
    Font.draw(("×%02d"):format(self.value), (tx + 1) * 8, (ty + 1) * 8)
    love.graphics.setColor(1, 1, 1, 1)
  end

  -- Patch only Trainer-Fly's SPECIAL VALUE row. Other mods and number options
  -- keep the engine's stock behavior.
  ManagerState.__trainerFlyOriginalBuildOptionRows =
    ManagerState.__trainerFlyOriginalBuildOptionRows
    or ManagerState.buildOptionRows

  local originalBuildOptionRows =
    ManagerState.__trainerFlyOriginalBuildOptionRows

  ManagerState.buildOptionRows = function(manager, m, schema)
    local rows = originalBuildOptionRows(manager, m, schema)

    -- Some Mod Manager schema passes legitimately return nil instead of an
    -- empty row table. Never iterate that value: preserve the engine result and
    -- record enough context for future diagnosis rather than crashing the Mods
    -- screen itself.
    if type(rows) ~= "table" then
      if m and m.id == mod.id then
        debugLogger:log("MOD MENU ROWS UNAVAILABLE",
          "rowsType=" .. type(rows)
            .. " schemaType=" .. type(schema)
            .. " modId=" .. debugLogger:safeField(m.id))
      end
      return rows
    end

    if not (m and m.id == mod.id) then return rows end

    for _, row in ipairs(rows) do
      row._g1gppMarquee = true
      if row.id == "debug_start_battle" then
        -- Action row: queue a direct Trainer-Fly result using the currently
        -- selected Special ID and Attack Modifier. The battle begins only
        -- after the Mods screen has closed and the overworld is safely idle.
        row.step = nil
        row.value = function()
          return debugTestBattlePending and "QUEUED" or "START"
        end
        row.activate = function()
          debugGlitchCityPending = false
          debugTestBattlePending = true
          mod.log:info("G1GPP direct test battle queued")
          debugLogger:log("DIRECT TEST BATTLE QUEUED", playerStateSummary(activeWorld))
        end
      elseif row.id == "debug_start_glitch_city" then
        -- Action row: close the Mods screen normally, then activate the exact
        -- production Glitch City runtime on the idle overworld. This bypasses
        -- only battle setup; containment, dialogue, timer, audio and recovery
        -- all flow through corruptRuntimeMap and the ordinary active-state loop.
        row.step = nil
        row.value = function()
          if glitchCityHandoff.active then return "ACTIVE" end
          return debugGlitchCityPending and "QUEUED" or "START"
        end
        row.activate = function()
          if glitchCityHandoff.active then
            debugLogger:log("DIRECT GLITCH CITY QUEUE BLOCKED", "reason=already_active "
              .. playerStateSummary(activeWorld))
            return
          end
          debugTestBattlePending = false
          debugGlitchCityPending = true
          mod.log:info("G1GPP direct Glitch City activation queued")
          debugLogger:log("DIRECT GLITCH CITY QUEUED", playerStateSummary(activeWorld))
        end
      elseif row.id == "debug_inverted_sprites" then
        -- One-shot development action. It reproduces the volatile flag that a
        -- MissingNo. Pokédex/stat display normally sets, allowing the next
        -- battle and ordinary-Pokémon recovery path to be tested immediately.
        row.step = nil
        row.value = function()
          return invertedSpriteState.active and "ARMED" or "ARM"
        end
        row.activate = function()
          activateInvertedSprites("debug", "mod_menu")
          mod.log:info("G1GPP inverted-sprite test armed")
        end
      elseif row.id == "debug_add_master_ball" then
        -- Intentional development-only inventory mutation. Every activation
        -- uses the engine's canonical Bag API to add exactly one Master Ball,
        -- preserving slot capacity, acquisition order and quantity limits.
        row.step = nil
        row.value = function()
          local liveGame = manager.game or game
          local count = liveGame and liveGame.save and liveGame.save.inventory
            and liveGame.save.inventory.MASTER_BALL or 0
          return "x" .. debugLogger:safeField(count)
        end
        row.activate = function()
          local liveGame = manager.game or game
          local save = liveGame and liveGame.save
          local data = liveGame and liveGame.data
          local before = save and save.inventory
            and (save.inventory.MASTER_BALL or 0) or 0
          debugLogger:log("DEBUG MASTER BALL REQUEST",
            "before=" .. debugLogger:safeField(before)
              .. " bagSlots=" .. debugLogger:safeField(save and Bag.slots(save))
              .. " bagCapacity=" .. debugLogger:safeField(data and Bag.capacity(data)))
          if not (save and data and data.items and data.items.MASTER_BALL) then
            debugLogger:log("DEBUG MASTER BALL FAILED",
              "reason=game_or_item_unavailable before=" .. debugLogger:safeField(before))
            return
          end
          local ok, added = pcall(Bag.add, save, "MASTER_BALL", 1, data)
          local after = save.inventory.MASTER_BALL or 0
          if ok and added and after == before + 1 then
            mod.log:info("G1GPP debug added one Master Ball (now %d)", after)
            debugLogger:log("DEBUG MASTER BALL ADDED",
              "before=" .. debugLogger:safeField(before) .. " after=" .. debugLogger:safeField(after)
                .. " delta=" .. debugLogger:safeField(after - before))
          else
            debugLogger:log("DEBUG MASTER BALL FAILED",
              "before=" .. debugLogger:safeField(before) .. " after=" .. debugLogger:safeField(after)
                .. " bagAddOk=" .. debugLogger:safeField(ok)
                .. " bagAddResult=" .. debugLogger:safeField(added)
                .. " reason=" .. debugLogger:safeField(ok and "bag_full_or_limit" or added))
          end
        end
      elseif row.id == "debug_add_tmhm_test_kit" then
        -- Development-only compatibility kit. TMs gain one copy per use;
        -- HMs are ensured present without creating duplicate key machines.
        -- The canonical Bag API preserves capacity and ordering behavior.
        row.step = nil
        row.value = function() return "ADD 8" end
        row.activate = function()
          local liveGame = manager.game or game
          local save = liveGame and liveGame.save
          local data = liveGame and liveGame.data
          local items = {
            "TM_MEGA_PUNCH", "TM_WATER_GUN", "TM_SKY_ATTACK",
            "HM_CUT", "HM_FLY", "HM_SURF", "HM_STRENGTH", "HM_FLASH",
          }
          debugLogger:log("DEBUG TMHM KIT REQUEST",
            "items=" .. table.concat(items, ",")
              .. " bagSlots=" .. debugLogger:safeField(save and Bag.slots(save))
              .. " bagCapacity=" .. debugLogger:safeField(data and Bag.capacity(data)))
          if not (save and save.inventory and data and data.items) then
            debugLogger:log("DEBUG TMHM KIT FAILED", "reason=game_unavailable")
            return
          end
          local addedCount, presentCount, failedCount = 0, 0, 0
          for _, itemId in ipairs(items) do
            local before = save.inventory[itemId] or 0
            local isHm = itemId:sub(1, 3) == "HM_"
            if isHm and before > 0 then
              presentCount = presentCount + 1
              debugLogger:log("DEBUG TMHM ITEM PRESENT",
                "item=" .. itemId .. " count=" .. debugLogger:safeField(before))
            elseif not data.items[itemId] then
              failedCount = failedCount + 1
              debugLogger:log("DEBUG TMHM ITEM FAILED",
                "item=" .. itemId .. " reason=item_unavailable")
            else
              local ok, added = pcall(Bag.add, save, itemId, 1, data)
              local after = save.inventory[itemId] or 0
              if ok and added and after == before + 1 then
                addedCount = addedCount + 1
                debugLogger:log("DEBUG TMHM ITEM ADDED",
                  "item=" .. itemId .. " before=" .. debugLogger:safeField(before)
                    .. " after=" .. debugLogger:safeField(after))
              else
                failedCount = failedCount + 1
                debugLogger:log("DEBUG TMHM ITEM FAILED",
                  "item=" .. itemId .. " before=" .. debugLogger:safeField(before)
                    .. " after=" .. debugLogger:safeField(after)
                    .. " bagAddOk=" .. debugLogger:safeField(ok)
                    .. " bagAddResult=" .. debugLogger:safeField(added))
              end
            end
          end
          mod.log:info(
            "G1GPP TM/HM test kit: %d added, %d already present, %d failed",
            addedCount, presentCount, failedCount)
          debugLogger:log("DEBUG TMHM KIT COMPLETE",
            "added=" .. debugLogger:safeField(addedCount)
              .. " alreadyPresent=" .. debugLogger:safeField(presentCount)
              .. " failed=" .. debugLogger:safeField(failedCount)
              .. " bagSlots=" .. debugLogger:safeField(Bag.slots(save)))
        end
      elseif row.id == "debug_cubone_seen" then
        -- One action controls the exact vanilla gate used by No.000. The
        -- displayed value is always read from the live save; pressing A flips
        -- only Cubone's seen flag and never changes Cubone's owned flag.
        row.step = nil
        row.value = function()
          local liveGame = manager.game or game
          return cuboneSeen(liveGame and liveGame.save) and "SEEN" or "UNSEEN"
        end
        row.activate = function()
          local liveGame = manager.game or game
          local save = liveGame and liveGame.save
          local dex = save and save.pokedex
          if not dex then
            debugLogger:log("DEBUG CUBONE FLAG FAILED",
              "reason=pokedex_unavailable")
            return
          end
          dex.seen = dex.seen or {}
          local before = dex.seen.CUBONE == true
          if before then
            dex.seen.CUBONE = nil
          else
            dex.seen.CUBONE = true
          end
          local after = dex.seen.CUBONE == true
          mod.log:info("G1GPP debug set Cubone seen flag to %s",
            after and "SEEN" or "UNSEEN")
          debugLogger:log("DEBUG CUBONE FLAG CHANGED",
            "before=" .. debugLogger:safeField(before)
              .. " after=" .. debugLogger:safeField(after)
              .. " cuboneOwned=" .. debugLogger:safeField(dex.owned
                and dex.owned.CUBONE == true)
              .. " scope=seen_flag_only")
        end
      elseif row.id == "debug_wipe_missingno" then
        -- Destructive development fixture requested for clean Rhydon-path
        -- testing. It touches only preserved MissingNo. records/flags, the
        -- shared Cubone seen gate, and the volatile inverted-sprite state.
        row.step = nil
        row.value = function()
          local liveGame = manager.game or game
          local count = ManagerState.G1.MissingNoState.count(
            liveGame and liveGame.save, liveGame and liveGame.data)
          return "x" .. debugLogger:safeField(count)
        end
        row.activate = function()
          local liveGame = manager.game or game
          local save = liveGame and liveGame.save
          local data = liveGame and liveGame.data
          if not (save and data) then
            debugLogger:log("DEBUG MISSINGNO WIPE FAILED",
              "reason=game_or_save_unavailable")
            return
          end
          local before = ManagerState.G1.MissingNoState.count(save, data)
          local removed = ManagerState.G1.MissingNoState.wipe(save, data)
          local after = ManagerState.G1.MissingNoState.count(save, data)
          mod.log:info("G1GPP debug wiped %d MissingNo. records", before - after)
          debugLogger:log("DEBUG MISSINGNO STATE WIPED",
            "before=" .. debugLogger:safeField(before)
              .. " after=" .. debugLogger:safeField(after)
              .. " party=" .. debugLogger:safeField(removed.party)
              .. " boxes=" .. debugLogger:safeField(removed.boxes)
              .. " daycare=" .. debugLogger:safeField(removed.daycare)
              .. " orphaned=" .. debugLogger:safeField(removed.orphaned)
              .. " seenFlags=" .. debugLogger:safeField(removed.seen)
              .. " ownedFlags=" .. debugLogger:safeField(removed.owned)
              .. " cuboneSeen=false invertedSprites=false"
              .. " remainingParty=" .. debugLogger:safeField(#(save.party or {})))
        end
      elseif row.id == "debug_warp_anywhere" then
        row.step = nil
        row.value = function()
          return warpAnywherePending and "QUEUED" or "OPEN"
        end
        row.activate = function()
          openWarpAnywhereMenu(manager.game or game)
        end
      elseif row.id == "quick_warp_set" then
        -- Treat this schema toggle as an action row. Its right-hand value is
        -- live status, not a persisted ON/OFF setting.
        row.step = nil
        row.value = function()
          return validateQuickWarp(quickWarpPoint) and "READY" or "EMPTY"
        end
        row.activate = function()
          if setQuickWarpPoint then setQuickWarpPoint() end
        end
      elseif row.id == "quick_warp_clear" then
        row.step = nil
        row.value = function()
          return validateQuickWarp(quickWarpPoint) and "READY" or "EMPTY"
        end
        row.activate = function()
          if clearQuickWarpPoint then clearQuickWarpPoint() end
        end
      elseif row.id == "debug_log_snapshot" then
        row.step = nil
        row.value = function() return "WRITE" end
        row.activate = function()
          debugLogger:log("MANUAL SNAPSHOT", playerStateSummary(activeWorld))
        end
      elseif row.id == "debug_log_clear" then
        row.step = nil
        row.value = function() return "CLEAR" end
        row.activate = function()
          debugLogger:clear(playerStateSummary(activeWorld))
        end
      end

      local config
      if row.id == "debug_special_value" then
        config = {
          key = "debug_special_value",
          default = 21,
          minimum = 0,
          maximum = 255,
        }
      elseif row.id == "debug_attack_modifier" then
        config = {
          key = "debug_attack_modifier",
          default = 7,
          minimum = 1,
          maximum = 13,
        }
      end

      if config then
        -- No left/right adjustment while merely highlighting the row.
        row.step = nil
        row.activate = function()
          local current =
            tonumber(manager:optionValue(m.id, {
              key = config.key,
              default = config.default,
            })) or config.default

          manager.game.stack:push(SpecialValueEditor.new(manager.game, {
            start = current,
            minimum = config.minimum,
            maximum = config.maximum,
            onDone = function(value)
              if value ~= nil then
                manager:setOption(m.id, config.key, value)
              end
            end,
          }))
        end
      end
    end

    return rows
  end

  -- The stock option renderer prints labels without clipping, so long schema
  -- names run into the right border. Limit all G1GPP labels to the 16-character
  -- interior and marquee only the focused row after a short reading pause.
  -- Rows belonging to the base game or other mods continue using the untouched
  -- renderer.
  ManagerState.G1.OptionRows.__g1gppOriginalDraw =
    ManagerState.G1.OptionRows.__g1gppOriginalDraw
      or ManagerState.G1.OptionRows.draw

  function ManagerState.G1.clock()
    if love and love.timer and love.timer.getTime then
      return love.timer.getTime()
    end
    return os.clock()
  end

  function ManagerState.G1.label(rows, index, selected)
    local row = rows[index]
    local label = tostring(row and row.label or "")
    local width = 16
    if #label <= width then return label end
    if not selected then return label:sub(1, width) end

    local key = tostring(rows) .. ":" .. debugLogger:safeField(index) .. ":" .. label
    local now = ManagerState.G1.clock()
    if ManagerState.G1.marqueeKey ~= key then
      ManagerState.G1.marqueeKey = key
      ManagerState.G1.marqueeStartedAt = now
    end
    local elapsed = now - ManagerState.G1.marqueeStartedAt
    if elapsed < 0.9 then return label:sub(1, width) end

    local sequence = label .. "   "
    local step = math.floor((elapsed - 0.9) / 0.16)
    local start = (step % #sequence) + 1
    local repeated = sequence .. sequence
    return repeated:sub(start, start + width - 1)
  end

  ManagerState.G1.OptionRows.draw = function(optionGame, rows, index, scroll,
      bottomLabel, bottomRow)
    local owned = false
    for _, row in ipairs(rows or {}) do
      if row._g1gppMarquee then owned = true break end
    end
    if not owned then
      return ManagerState.G1.OptionRows.__g1gppOriginalDraw(
        optionGame, rows, index, scroll,
        bottomLabel, bottomRow)
    end

    local focusLabel = tostring(rows[index] and rows[index].label or "")
    local focusKey = tostring(rows) .. ":" .. debugLogger:safeField(index)
      .. ":" .. focusLabel
    if ManagerState.G1.marqueeKey ~= focusKey then
      ManagerState.G1.marqueeKey = focusKey
      ManagerState.G1.marqueeStartedAt = ManagerState.G1.clock()
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, 160, 144)
    for slot = 1, ManagerState.G1.OptionRows.VISIBLE do
      local i = scroll + slot
      local row = rows[i]
      if not row then break end
      Font.drawBox(0, (slot - 1) * 4, 20, 4)
      love.graphics.setColor(0, 0, 0, 1)
      Font.draw(ManagerState.G1.label(rows, i, i == index),
        16, ((slot - 1) * 4 + 1) * 8)
      Font.draw(row.value and row.value(optionGame) or "",
        24, ((slot - 1) * 4 + 2) * 8)
      if i == index then
        Font.drawCode(ManagerState.G1.Theme.cursor,
          8, ((slot - 1) * 4 + 1) * 8)
      end
    end
    if scroll + ManagerState.G1.OptionRows.VISIBLE < #rows then
      Font.drawCode(ManagerState.G1.Theme.moreArrow, 144, 128)
    end
    if bottomLabel then
      love.graphics.setColor(0, 0, 0, 1)
      Font.draw(bottomLabel, 16, 136)
      if bottomRow and index == bottomRow then
        Font.drawCode(ManagerState.G1.Theme.cursor, 8, 136)
      end
    end
    love.graphics.setColor(1, 1, 1, 1)
  end

  -- Preserve the engine's native Gen-I-style Start latch, with an optional
  -- accessibility buffer. STRICT requires the landing frame, RELAXED accepts
  -- the preceding three frames, and EASY accepts the preceding five.
  local function startWasBuffered(world)
    if not (game and game.input) then return false end

    local input = game.input
    local latch = world and world.joyLatch
    local nativeBuffered =
      input:wasPressed("start") == true
      or (latch and latch.start == true and input:isDown("start") == true)

    if nativeBuffered then return true end
    return startPressAge < timingWindow()
  end

  local function trainerIdentity(npc)
    local def = npc and npc.def or {}
    return tostring(def.trainerClass or ""),
           tonumber(def.trainerParty or def.partyIndex or def.party or 0)
  end

  local function isTargetTrainer(world, npc)
    if not (world and npc and npc.def) then return false end
    local class, party = trainerIdentity(npc)
    class = class:upper()
    local correctClass = class == "OPP_JR_TRAINER_F"
      or class:find("JUNIOR", 1, true) ~= nil
      or class:find("JR_TRAINER", 1, true) ~= nil
    local mapId = world.map and world.map.id or ""
    local routeOkay = mapId == "ROUTE_24" or mapId == "ROUTE_25"
      or mapId:find("ROUTE_24", 1, true) ~= nil
      or mapId:find("ROUTE_25", 1, true) ~= nil
    return correctClass and party == 2 and routeOkay
  end

  local function speciesOf(value)
    if not value then return nil end
    local mon = value.mon or value
    local species = mon.species or mon.id
    if type(species) == "table" then species = species.id end
    return species and tostring(species):upper() or nil
  end

  -- The original glitch reads the live enemy Special byte left by the last
  -- opposing battler. Prefer curStats so Transform and in-battle stat changes
  -- are represented. Fall back to the underlying monster's calculated stats.
  local function specialOf(value)
    if not value then return nil end
    local mon = value.mon or value
    local candidates = {
      value.curStats and value.curStats.special,
      value.stats and value.stats.special,
      mon.stats and mon.stats.special,
    }
    for _, v in ipairs(candidates) do
      v = tonumber(v)
      if v then return math.max(0, math.min(255, math.floor(v))) end
    end
    return nil
  end

  local function attackModifierOf(value)
    if not value then return 7 end
    local stage = value.stages and tonumber(value.stages.attack) or 0
    stage = math.max(-6, math.min(6, math.floor(stage or 0)))
    return stage + 7
  end

  local function captureEnemy(value)
    if not value or value.isPlayer == true then return end
    local special = specialOf(value)
    if special == nil then return end
    capturedSpecial = special
    capturedAttackModifier = attackModifierOf(value)
    capturedEnemySpecies = speciesOf(value)
    mod.log:info(
      "G1GPP captured enemy %s Special=%d AttackMod=%d",
      tostring(capturedEnemySpecies),
      capturedSpecial,
      capturedAttackModifier)
  end

  local function captureCurrentEnemy(battle)
    if battle and battle.enemy then captureEnemy(battle.enemy) end
  end

  local function releaseTrainerApproach(world)
    if not world then return end
    -- The vanilla approach created the emote and engagement lock before the
    -- menu opened. Teleport abandons that approach, so clear those transient
    -- pieces while leaving our own escape record intact.
    world.emote = nil
    world.engaging = false
    if world.player then world.player.inputLocked = false end
    if escape and escape.npc then escape.npc.frozen = false end
  end

  Overworld.__trainerFlyOriginalStartTrainerApproach =
    Overworld.__trainerFlyOriginalStartTrainerApproach
    or Overworld.startTrainerApproach
  Overworld.__trainerFlyOriginalBeginTeleportOut =
    Overworld.__trainerFlyOriginalBeginTeleportOut
    or Overworld.beginTeleportOut
  Overworld.__trainerFlyOriginalHandleInput =
    Overworld.__trainerFlyOriginalHandleInput
    or Overworld.handleInput
  Overworld.__trainerFlyOriginalUpdate =
    Overworld.__trainerFlyOriginalUpdate
    or Overworld.update
  Overworld.__g1gppOriginalInteract =
    Overworld.__g1gppOriginalInteract
    or Overworld.interact
  Overworld.__g1gppOriginalDraw =
    Overworld.__g1gppOriginalDraw
    or Overworld.draw

  local originalStart = Overworld.__trainerFlyOriginalStartTrainerApproach
  local originalTeleport = Overworld.__trainerFlyOriginalBeginTeleportOut
  local originalHandleInput = Overworld.__trainerFlyOriginalHandleInput
  local originalUpdate = Overworld.__trainerFlyOriginalUpdate
  local originalInteract = Overworld.__g1gppOriginalInteract
  local originalOverworldDraw = Overworld.__g1gppOriginalDraw

  -- Glitch City now mutates the live map block grid. No draw hook or
  -- fullscreen overlay is installed in this build.

  local function snapshotMapBlocks(map)
    if not (map and map.def and map.blockAt) then return nil end
    local width = tonumber(map.def.width) or 0
    local height = tonumber(map.def.height) or 0
    if width <= 0 or height <= 0 then return nil end

    local snapshot = { width = width, height = height, blocks = {} }
    for by = 0, height - 1 do
      local row = {}
      for bx = 0, width - 1 do row[bx + 1] = map:blockAt(bx, by) end
      snapshot.blocks[by + 1] = row
    end
    return snapshot
  end

  local function rebuildMapRenderer(map)
    if not (map and map.renderer and map.renderer.rebuild) then
      return false, "renderer_rebuild_unavailable"
    end
    local ok, err = pcall(map.renderer.rebuild, map.renderer)
    return ok, err
  end

  -- Discover the complete block palette exposed by the active tileset, not
  -- merely the blocks already used by the current map. Real Gen-I maps often
  -- leave many valid metatiles unused on a particular route. Pulling from that
  -- larger palette makes the corruption look like unrelated graphics data has
  -- been interpreted as world geometry while keeping every replacement inside
  -- the renderer's real block/collision system.
  local function numericKeyRange(t)
    if type(t) ~= "table" then return nil, nil end
    local minKey, maxKey
    for k, _ in pairs(t) do
      if type(k) == "number" and k == math.floor(k) then
        if not minKey or k < minKey then minKey = k end
        if not maxKey or k > maxKey then maxKey = k end
      end
    end
    return minKey, maxKey
  end

  local function discoverTilesetBlocks(map)
    local candidates = {
      map and map.tileset and map.tileset.blocks,
      map and map.tileset and map.tileset.blockDefs,
      map and map.renderer and map.renderer.tileset and map.renderer.tileset.blocks,
      map and map.renderer and map.renderer.tileset and map.renderer.tileset.blockDefs,
      map and map.renderer and map.renderer.blocks,
      map and map.def and map.def.tileset and map.def.tileset.blocks,
    }

    local best
    for _, t in ipairs(candidates) do
      if type(t) == "table" then
        local minKey, maxKey = numericKeyRange(t)
        local count = 0
        for _ in pairs(t) do count = count + 1 end
        if count > 0 and (not best or count > best.count) then
          best = { tableRef = t, minKey = minKey, maxKey = maxKey, count = count }
        end
      end
    end

    local ids = {}
    if best then
      local seen = {}
      for k, _ in pairs(best.tableRef) do
        local id
        if type(k) == "number" and k == math.floor(k) then
          -- Most engine tables are either 0-based block IDs or 1-based Lua
          -- arrays. Preserve 0-based keys; convert obvious 1-based arrays.
          id = k
          if best.minKey == 1 then id = k - 1 end
        end
        if id and id >= 0 and id <= 255 and not seen[id] then
          seen[id] = true
          ids[#ids + 1] = id
        end
      end
      table.sort(ids)
    end

    -- Some builds expose only a block count on the tileset object. Use that
    -- as a conservative fallback.
    if #ids == 0 then
      local countCandidates = {
        map and map.tileset and map.tileset.blockCount,
        map and map.renderer and map.renderer.tileset and map.renderer.tileset.blockCount,
        map and map.renderer and map.renderer.blockCount,
      }
      for _, value in ipairs(countCandidates) do
        local n = tonumber(value)
        if n and n > 0 and n <= 256 then
          for id = 0, math.floor(n) - 1 do ids[#ids + 1] = id end
          break
        end
      end
    end

    return ids
  end

  local rebuildRendererForTileset

  local function logBlockedExit(kind, world, targetX, targetY, detail)
    local state = glitchCityHandoff
    state.blockedExitAttempts = (state.blockedExitAttempts or 0) + 1
    local player = world and world.player
    debugLogger:log("CONTAINMENT EXIT BLOCKED", "kind=" .. debugLogger:safeField(kind)
      .. " attempt=" .. debugLogger:safeField(state.blockedExitAttempts)
      .. " map=" .. debugLogger:safeField(world and world.map and world.map.id)
      .. " player=" .. debugLogger:safeField(player and player.cellX) .. ","
      .. debugLogger:safeField(player and player.cellY)
      .. " target=" .. debugLogger:safeField(targetX) .. "," .. debugLogger:safeField(targetY)
      .. " detail=" .. debugLogger:safeField(detail))
  end

  local function installGlitchCityContainment(world, map)
    local state = glitchCityHandoff
    if state.containmentInstalled then return true end
    if not (world and map and map.def) then
      debugLogger:log("CONTAINMENT INSTALL FAILED", "world/map/definition unavailable")
      return false
    end

    state.originalWarpAt = map.warpAt
    state.originalConnections = map.def.connections
    state.originalWalkable = map.walkable
    state.originalDoorTiles = map.doorTiles
    state.originalWarpTiles = map.warpTiles
    state.blockedWarpCells = {}
    local warpCount = 0
    for key, entry in pairs(map.warpAt or {}) do
      state.blockedWarpCells[key] = entry
      warpCount = warpCount + 1
    end
    local connectionCount = 0
    for _ in pairs(map.def.connections or {}) do connectionCount = connectionCount + 1 end

    -- Disable the live transition indexes themselves. Collision guarding below
    -- makes their cells solid before a step starts; these empty tables are the
    -- second line of defense against arrival, collision, edge, and scripted
    -- transition paths. The exact original references are restored on recovery.
    map.warpAt = {}
    map.def.connections = {}
    state.containmentInstalled = true
    state.blockedExitAttempts = 0
    debugLogger:log("CONTAINMENT INSTALLED", "map=" .. debugLogger:safeField(map.id)
      .. " warps=" .. debugLogger:safeField(warpCount)
      .. " connections=" .. debugLogger:safeField(connectionCount)
      .. " mode=solid_inert_no_clamp")
    mod.log:info("G1GPP physical Glitch City containment installed on %s", tostring(map.id))
    return true
  end

  local function restoreGlitchCityContainment(reason)
    local state = glitchCityHandoff
    local map = state.mapRef
    if state.containmentInstalled and map then
      map.warpAt = state.originalWarpAt or map.warpAt
      map.walkable = state.originalWalkable or map.walkable
      map.doorTiles = state.originalDoorTiles or map.doorTiles
      map.warpTiles = state.originalWarpTiles or map.warpTiles
      if map.def then map.def.connections = state.originalConnections end
      debugLogger:log("CONTAINMENT RESTORED", "reason=" .. debugLogger:safeField(reason)
        .. " map=" .. debugLogger:safeField(map.id)
        .. " blockedAttempts=" .. debugLogger:safeField(state.blockedExitAttempts))
      mod.log:info("G1GPP Glitch City containment restored on %s", tostring(map.id))
    elseif state.containmentInstalled then
      debugLogger:log("CONTAINMENT RESTORE FAILED", "reason=" .. debugLogger:safeField(reason)
        .. " map reference unavailable")
    end
    state.containmentInstalled = false
    state.originalWarpAt = nil
    state.originalConnections = nil
    state.originalWalkable = nil
    state.originalDoorTiles = nil
    state.originalWarpTiles = nil
    state.blockedWarpCells = nil
    state.blockedExitAttempts = 0
  end

  local function restoreGlitchCityMap(reason, world, warpToOrigin)
    local state = glitchCityHandoff
    stopGlitchCityAudio(reason)
    local map = state.mapRef
    local snapshot = state.originalBlocks
    local origin = state.origin
    debugLogger:log("RECOVERY REQUEST", "reason=" .. debugLogger:safeField(reason)
      .. " warpToOrigin=" .. debugLogger:safeField(warpToOrigin)
      .. " target=" .. debugLogger:safeField(origin and origin.mapId) .. "@"
      .. debugLogger:safeField(origin and origin.x) .. "," .. debugLogger:safeField(origin and origin.y)
      .. " current=" .. playerStateSummary(world))
    restoreGlitchCityContainment(reason)
    if map and snapshot and map.setBlock then
      if state.originalTilesetImage then map.tileset.image = state.originalTilesetImage end
      if state.originalTilesetBlocks then map.tileset.blocks = state.originalTilesetBlocks end
      for by = 0, snapshot.height - 1 do
        local row = snapshot.blocks[by + 1]
        for bx = 0, snapshot.width - 1 do map:setBlock(bx, by, row[bx + 1]) end
      end
      if not rebuildRendererForTileset(map) then rebuildMapRenderer(map) end
      debugLogger:log("MAP DATA RESTORED", "map=" .. debugLogger:safeField(map.id)
        .. " size=" .. debugLogger:safeField(snapshot.width) .. "x" .. debugLogger:safeField(snapshot.height))
    else
      debugLogger:log("MAP DATA RESTORE SKIPPED", "map/snapshot/setBlock unavailable")
    end

    state.active = false
    state.mapRef = nil
    state.mapId = nil
    state.originalBlocks = nil
    state.originalTilesetImage = nil
    state.originalTilesetBlocks = nil
    state.originalRenderer = nil
    state.remainingFrames = 0
    state.glyphMutationCells = nil
    state.glyphMutationCountdown = 0
    state.glyphMutationCursor = 0
    state.glyphMutationCount = 0
    state.recoveryWarpPending = false
    state.recoveryWarpOrigin = nil
    state.recoveryWarpReason = nil
    state.recoveryWarpAttempts = 0
    state.recoveryWarpIssued = false

    -- Recovery is called after the native overworld update has completed. Do
    -- not rely on a later idle-frame gate: directly restore the captured map,
    -- then explicitly snap every player-position field used by rendering and
    -- movement. This covers both same-map timer recovery and a route/door
    -- transition that already changed world.map during the update.
    if warpToOrigin and world and origin and origin.mapId then
      local targetX = math.floor(origin.x)
      local targetY = math.floor(origin.y)
      debugLogger:log("DIRECT RESTORE BEGIN", "target=" .. debugLogger:safeField(origin.mapId)
        .. "@" .. debugLogger:safeField(targetX) .. "," .. debugLogger:safeField(targetY)
        .. " storedPixel=" .. debugLogger:safeField(origin.px) .. "," .. debugLogger:safeField(origin.py)
        .. " before=" .. playerStateSummary(world))
      local ok, err = pcall(function()
        if not world.map or world.map.id ~= origin.mapId then
          world:setMap(origin.mapId, targetX, targetY,
            origin.facing or "down", { via = "g1gpp_glitch_city_recovery" })
        end

        local player = world.player
        if not player then error("recovery has no player object") end
        player.cellX, player.cellY = targetX, targetY
        player.px = tonumber(origin.px) or targetX * 16
        player.py = tonumber(origin.py) or targetY * 16
        player.targetX, player.targetY = nil, nil
        player.moving = false
        player.progress = 0
        player.bumpFrames = nil
        player.turnTimer = 0
        player.inputLocked = false
        player.facing = origin.facing or player.facing or "down"

        if world.camera and world.camera.follow then
          local okGame, GameModule = pcall(require, "src.core.Game")
          local viewSize = okGame and GameModule and GameModule.renderer
            and GameModule.renderer.worldViewSize
            and GameModule.renderer:worldViewSize() or nil
          if viewSize then
            world.camera:follow(player.px, player.py, viewSize)
          end
        end
      end)

      if ok then
        state.recoveryMessagePending = true
        mod.log:info("G1GPP direct origin restore complete (%s): %s @ %d,%d",
          tostring(reason), tostring(origin.mapId), targetX, targetY)
        debugLogger:log("DIRECT RESTORE RESULT", "success=true " .. playerStateSummary(world))
      else
        state.recoveryMessagePending = true
        mod.log:error("G1GPP direct origin restore failed (%s): %s",
          tostring(reason), tostring(err))
        debugLogger:log("DIRECT RESTORE RESULT", "success=false error=" .. debugLogger:safeField(err)
          .. " " .. playerStateSummary(world))
      end
    else
      state.recoveryMessagePending = true
    end

    state.origin = nil
    mod.log:info("G1GPP Glitch City map restored (%s)", tostring(reason))
  end

  -- Timed Glitch City recovery presentation. The corrupted audio briefly
  -- hangs, the world fades to white, restoration and the origin warp occur
  -- while fully concealed, the recovery message is shown over white, and the
  -- normal overworld fades back in together with its restored map music.
  local GlitchCityRecoveryScreen = {}
  GlitchCityRecoveryScreen.__index = GlitchCityRecoveryScreen
  GlitchCityRecoveryScreen.isOpaque = false

  -- Source-informed renderer integration. Gen1Recomp calls the official
  -- render.letterbox hook after filling the physical drawable surround and
  -- before compositing the world/UI canvases. Publishing the recovery alpha
  -- here lets the engine draw the playfield and TextBoxes normally above a
  -- resolution-, DPI-, aspect-ratio-, and renderer-independent white surround.
  local recoveryLetterboxWhiteAlpha = 0
  local recoveryLetterboxLogged = false

  mod.hooks:wrap("render.letterbox", function(next, ctx)
    local result = next(ctx)
    local alpha = recoveryLetterboxWhiteAlpha or 0
    if alpha > 0 and ctx and ctx.ww and ctx.wh then
      love.graphics.push("all")
      love.graphics.setCanvas()
      love.graphics.origin()
      love.graphics.setScissor()
      love.graphics.setShader()
      love.graphics.setColor(1, 1, 1, alpha)
      love.graphics.rectangle("fill", 0, 0, ctx.ww, ctx.wh)
      love.graphics.pop()
      if not recoveryLetterboxLogged then
        recoveryLetterboxLogged = true
        debugLogger:log("RECOVERY LETTERBOX WHITE",
          "width=" .. debugLogger:safeField(ctx.ww) .. " height=" .. debugLogger:safeField(ctx.wh)
          .. " pixelWidth=" .. debugLogger:safeField(ctx.pw) .. " pixelHeight=" .. debugLogger:safeField(ctx.ph)
          .. " worldActive=" .. debugLogger:safeField(ctx.worldActive))
      end
    else
      recoveryLetterboxLogged = false
    end
    return result
  end)

  function GlitchCityRecoveryScreen.new(game_, world_, reason_)
    local self = setmetatable({}, GlitchCityRecoveryScreen)
    self.game = game_
    self.world = world_
    self.reason = reason_ or "timer"
    self.phase = "hang"
    self.frames = 0
    self.hangFrames = 36
    self.fadeFrames = 60
    self.whiteAlpha = 0
    self.restored = false
    self.messageOpen = false
    self.normalMusicSource = nil
    self.normalMusicLoopSource = nil
    self.normalMusicTargetVolume = 1
    self.normalMusicLoopTargetVolume = 1
    self.normalMusicSourceWasPlaying = false
    self.normalMusicLoopSourceWasPlaying = false
    self.previousBackgroundColor = { love.graphics.getBackgroundColor() }
    self.hangSource = nil
    self.hangPosition = 0
    self.hangRestartFrames = 6
    self.hangPitch = 0.45
    -- Freeze the reverse-chunk scheduler so the ending can genuinely stick
    -- on one tiny fragment instead of merely sweeping pitch downward.
    glitchCityHandoff.audioActive = false
    local a = glitchCityHandoff.audioReverseSource
    local b = glitchCityHandoff.audioReverseNextSource
    local av, bv = 0, 0
    if a then local ok, v = pcall(a.getVolume, a); if ok then av = v or 0 end end
    if b then local ok, v = pcall(b.getVolume, b); if ok then bv = v or 0 end end
    self.hangSource = (bv > av) and b or a
    local other = (self.hangSource == a) and b or a
    if other then pcall(other.stop, other) end
    if self.hangSource then
      local okTell, pos = pcall(self.hangSource.tell, self.hangSource, "seconds")
      self.hangPosition = (okTell and tonumber(pos)) or
        tonumber(glitchCityHandoff.audioReversePosition) or 0
      pcall(self.hangSource.setPitch, self.hangSource, self.hangPitch)
      pcall(self.hangSource.setLooping, self.hangSource, false)
    end
    if world_ and world_.player then world_.player.inputLocked = true end
    debugLogger:log("RECOVERY SEQUENCE START", "reason=" .. debugLogger:safeField(self.reason)
      .. " hangFrames=" .. debugLogger:safeField(self.hangFrames)
      .. " fadeFrames=" .. debugLogger:safeField(self.fadeFrames)
      .. " " .. playerStateSummary(world_))
    return self
  end

  function GlitchCityRecoveryScreen:muteRestoredMusic()
    local state = musicRuntimeState()
    local src = state and state.source or nil
    if src then
      local okVol, vol = pcall(src.getVolume, src)
      local okPlaying, playing = pcall(src.isPlaying, src)
      self.normalMusicTargetVolume = okVol and vol or 1
      self.normalMusicSource = src
      self.normalMusicSourceWasPlaying = okPlaying and playing == true
      pcall(src.setVolume, src, 0)
    end
    if state and state.loopSource then
      local okLoopVol, loopVol = pcall(state.loopSource.getVolume, state.loopSource)
      local okLoopPlaying, loopPlaying = pcall(state.loopSource.isPlaying, state.loopSource)
      self.normalMusicLoopTargetVolume = okLoopVol and loopVol or 1
      self.normalMusicLoopSource = state.loopSource
      self.normalMusicLoopSourceWasPlaying = okLoopPlaying and loopPlaying == true
      pcall(state.loopSource.setVolume, state.loopSource, 0)
    end
    debugLogger:log("RECOVERY NORMAL MUSIC HELD",
      musicStateSummary()
      .. " sourceRef=" .. debugLogger:safeField(tostring(self.normalMusicSource))
      .. " sourcePlaying=" .. debugLogger:safeField(self.normalMusicSourceWasPlaying)
      .. " loopRef=" .. debugLogger:safeField(tostring(self.normalMusicLoopSource))
      .. " loopPlaying=" .. debugLogger:safeField(self.normalMusicLoopSourceWasPlaying))
  end

  function GlitchCityRecoveryScreen:hardStopCorruptedAudio(reason)
    local stopped = 0
    local seen = {}
    local candidates = {
      self.hangSource,
      glitchCityHandoff.audioReverseSource,
      glitchCityHandoff.audioReverseNextSource,
    }
    for _, src in ipairs(candidates) do
      if src and not seen[src] then
        seen[src] = true
        pcall(src.setVolume, src, 0)
        pcall(src.stop, src)
        stopped = stopped + 1
      end
    end
    self.hangSource = nil
    debugLogger:log("RECOVERY CORRUPTED AUDIO HARD STOP",
      "reason=" .. debugLogger:safeField(reason) .. " sources=" .. debugLogger:safeField(stopped))
  end

  function GlitchCityRecoveryScreen:restoreBehindWhite()
    if self.restored then return end
    self.restored = true
    restoreGlitchCityMap(self.reason, self.world, true)
    -- This controller owns the recovery message; suppress the legacy
    -- overworld-side message gate set by restoreGlitchCityMap.
    glitchCityHandoff.recoveryMessagePending = false
    self:muteRestoredMusic()
    debugLogger:log("RECOVERY RESTORED BEHIND WHITE", playerStateSummary(self.world))
  end

  function GlitchCityRecoveryScreen:showMessage()
    if self.messageOpen then return end
    self.messageOpen = true
    local controller = self
    self.game.stack:push(TextBox.new(
      self.game,
      "WORLD DATA\nRECOVERED.",
      function()
        controller.game.stack:push(TextBox.new(
          controller.game,
          "YOUR SAVE FILE WAS\nPROTECTED FROM DAMAGE.",
          function()
            controller.messageOpen = false
            controller:hardStopCorruptedAudio("message_complete")
            controller.phase = "fade_out"
            controller.isOpaque = false
            controller.frames = 0
            debugLogger:log("RECOVERY MESSAGE COMPLETE", playerStateSummary(controller.world))
          end
        ))
      end
    ))
  end

  function GlitchCityRecoveryScreen:update(_dt)
    self.frames = self.frames + 1

    if self.phase == "hang" then
      -- Re-trigger the same short source fragment at a fixed low pitch. This
      -- creates a real stuck/hanging cadence instead of a quick pitch dip.
      if self.hangSource and (self.frames == 1 or self.frames % self.hangRestartFrames == 0) then
        pcall(self.hangSource.stop, self.hangSource)
        pcall(self.hangSource.setPitch, self.hangSource, self.hangPitch)
        pcall(self.hangSource.seek, self.hangSource, self.hangPosition, "seconds")
        pcall(self.hangSource.play, self.hangSource)
      end
      if self.frames >= self.hangFrames then
        self.phase = "fade_in_white"
        self.frames = 0
        debugLogger:log("RECOVERY AUDIO HANG COMPLETE",
          "mode=fixed_fragment position=" .. debugLogger:safeField(self.hangPosition)
          .. " pitch=" .. debugLogger:safeField(self.hangPitch)
          .. " restartFrames=" .. debugLogger:safeField(self.hangRestartFrames))
      end
      return
    end

    if self.phase == "fade_in_white" then
      local t = math.min(1, self.frames / self.fadeFrames)
      self.whiteAlpha = t
      -- The engine presents the 160x144 game canvas inside a larger window.
      -- Match the clear/background color to the recovery field so letterbox
      -- and overscan regions also fade white edge-to-edge.
      love.graphics.setBackgroundColor(1, 1, 1, self.whiteAlpha)
      local volume = (glitchCityHandoff.audioOriginalVolume or 1) * (1 - t)
      if glitchCityHandoff.audioReverseSource then
        pcall(glitchCityHandoff.audioReverseSource.setVolume,
          glitchCityHandoff.audioReverseSource, volume)
      end
      if glitchCityHandoff.audioReverseNextSource then
        pcall(glitchCityHandoff.audioReverseNextSource.setVolume,
          glitchCityHandoff.audioReverseNextSource, volume)
      end
      if t >= 1 then
        self.whiteAlpha = 1
        -- The corrupted clone must be completely silent before any recovery
        -- text appears. Fading its volume is not sufficient because a detached
        -- clone may continue playing after the message closes.
        self:hardStopCorruptedAudio("full_white_before_message")
        self.phase = "message"
        self.isOpaque = true
        self.frames = 0
        self:restoreBehindWhite()
        self:showMessage()
      end
      return
    end

    if self.phase == "message" then
      self.isOpaque = true
      self.whiteAlpha = 1
      -- Stop the final-present overlay while text boxes are on top. This
      -- recovery screen is now opaque, so the overworld is not drawn beneath
      -- it; the white logical framebuffer and white clear color remain, while
      -- the normal TextBox screens can render visibly above this screen.
      recoveryLetterboxWhiteAlpha = 1
      -- Music.update may hand the intro source to its loop while the player is
      -- reading. Keep whichever engine-managed sources are current silent;
      -- do not stop, restart, or swap them ourselves.
      local heldState = musicRuntimeState()
      if heldState and heldState.source then pcall(heldState.source.setVolume, heldState.source, 0) end
      if heldState and heldState.loopSource then pcall(heldState.loopSource.setVolume, heldState.loopSource, 0) end
      return
    end

    if self.phase == "fade_out" then
      local t = math.min(1, self.frames / self.fadeFrames)
      self.whiteAlpha = 1 - t
      local bg = self.previousBackgroundColor or { 0, 0, 0, 1 }
      love.graphics.setBackgroundColor(
        1 + ((bg[1] or 0) - 1) * t,
        1 + ((bg[2] or 0) - 1) * t,
        1 + ((bg[3] or 0) - 1) * t,
        1 + ((bg[4] or 1) - 1) * t)
      -- Music.restoreMap selected the song and Music.update owns the native
      -- intro-to-loop handoff. Fade whichever managed sources are current on
      -- this frame, without calling play(), stop(), seek(), or replacing refs.
      local managed = musicRuntimeState()
      local targetVolume = self.normalMusicTargetVolume or 1
      if managed and managed.source then
        pcall(managed.source.setPitch, managed.source, 1)
        pcall(managed.source.setVolume, managed.source, targetVolume * t)
      end
      if managed and managed.loopSource then
        pcall(managed.loopSource.setPitch, managed.loopSource, 1)
        pcall(managed.loopSource.setVolume, managed.loopSource, targetVolume * t)
      end
      if t >= 1 then
        self.whiteAlpha = 0
        recoveryLetterboxWhiteAlpha = 0
        local finalManaged = musicRuntimeState()
        if finalManaged and finalManaged.source then
          pcall(finalManaged.source.setPitch, finalManaged.source, 1)
          pcall(finalManaged.source.setVolume, finalManaged.source,
            self.normalMusicTargetVolume or 1)
        end
        if finalManaged and finalManaged.loopSource then
          pcall(finalManaged.loopSource.setPitch, finalManaged.loopSource, 1)
          pcall(finalManaged.loopSource.setVolume, finalManaged.loopSource,
            self.normalMusicTargetVolume or 1)
        end
        local bg = self.previousBackgroundColor or { 0, 0, 0, 1 }
        love.graphics.setBackgroundColor(bg[1] or 0, bg[2] or 0, bg[3] or 0, bg[4] or 1)
        glitchCityHandoff.recoveryMusicWatchActive = false
        debugLogger:log("RECOVERY MUSIC NATIVE LIFECYCLE COMPLETE", musicStateSummary())
        if self.world and self.world.player then self.world.player.inputLocked = false end
        debugLogger:log("RECOVERY SEQUENCE COMPLETE", playerStateSummary(self.world)
          .. " " .. musicStateSummary())
        if self.game.stack:top() == self then self.game.stack:pop() end
      end
    end
  end

  function GlitchCityRecoveryScreen:draw()
    -- The logical recovery field remains part of the normal UI canvas. The
    -- official render.letterbox hook independently paints the physical surround
    -- at the same alpha before this canvas is composited.
    recoveryLetterboxWhiteAlpha = self.whiteAlpha or 0
    if self.whiteAlpha > 0 then
      -- During the message phase, the final-present overlay must be disabled so
      -- the TextBox can remain visible. Instead, draw an intentionally oversized
      -- white field *under* the TextBox using the active logical transform. The
      -- huge logical rectangle extends far beyond every widescreen/overscan edge,
      -- while later stack entries (the recovery TextBoxes) still render on top.
      love.graphics.setColor(1, 1, 1, self.whiteAlpha)
      love.graphics.rectangle("fill", 0, 0, 160, 144)
      love.graphics.setColor(1, 1, 1, 1)
    end
  end

  rebuildRendererForTileset = function(map)
    local ok, TileRenderer = pcall(require, "src.render.TileRenderer")
    if not ok or not TileRenderer or not TileRenderer.new then return false end
    if map.renderer and map.renderer.release then pcall(map.renderer.release, map.renderer) end
    local okNew, renderer = pcall(TileRenderer.new, map, game and game.data or nil)
    if not okNew or not renderer then return false end
    map.renderer = renderer
    return true
  end

  local function derivedGlitchAtlasPath(imagePath)
    local base = type(imagePath) == "string" and imagePath:match("([^/]+)%.png$")
    if not base then return nil end
    return "assets/generated/tilesets/g1gpp_" .. base .. ".png"
  end

  local function corruptRuntimeMap(world)
    local map = world and world.map
    if not (map and map.def and map.blockAt and map.setBlock and map.tileset) then
      mod.log:warn("G1GPP hybrid-metatile probe could not access live map data")
      return false
    end
    local snapshot = snapshotMapBlocks(map)
    if not snapshot then return false end

    local Assets = require("src.render.Assets")
    local sourceImagePath = map.tileset.image
    local glitchImagePath = derivedGlitchAtlasPath(sourceImagePath)
    if not glitchImagePath or not Assets.exists(Assets.resolve(glitchImagePath)) then
      mod.log:warn("G1GPP hybrid atlas unavailable for %s", tostring(sourceImagePath))
      return false
    end

    local baseData = Assets.imageData(sourceImagePath)
    local fontData = Assets.imageData("assets/generated/fonts/font.png")
    local extraData = Assets.imageData("assets/generated/fonts/font_extra.png")
    local bw, bh = baseData:getDimensions()
    local fw, fh = fontData:getDimensions()
    local ew, eh = extraData:getDimensions()
    local baseTileCount = math.floor(bw / 8) * math.floor(bh / 8)
    local fontTileCount = math.floor(fw / 8) * math.floor(fh / 8)
    local extraTileCount = math.floor(ew / 8) * math.floor(eh / 8)
    local glyphThemeCount = 4
    local glyphThemeStride = fontTileCount + extraTileCount

    local width, height = snapshot.width, snapshot.height
    local source = snapshot.blocks
    local px = world.player and world.player.cellX or 0
    local py = world.player and world.player.cellY or 0
    local playerBX = math.floor(px / 2)
    local playerBY = math.floor(py / 2)

    local localBlocks, localSeen = {}, {}
    local terrainTiles, terrainSeen = {}, {}
    for by = 0, height - 1 do
      for bx = 0, width - 1 do
        local id = source[by + 1][bx + 1]
        if not localSeen[id] then
          localSeen[id] = true
          localBlocks[#localBlocks + 1] = id
          local block = map.tileset.blocks[id + 1]
          if block then
            for _, tile in ipairs(block) do
              if not terrainSeen[tile] then
                terrainSeen[tile] = true
                terrainTiles[#terrainTiles + 1] = tile
              end
            end
          end
        end
      end
    end
    if #localBlocks == 0 or #terrainTiles == 0 then return false end

    local fullPalette = discoverTilesetBlocks(map)
    local foreignBlocks = {}
    for _, id in ipairs(fullPalette) do
      if not localSeen[id] then foreignBlocks[#foreignBlocks + 1] = id end
    end

    local glyphTiles, symbolGlyphTiles = {}, {}
    local calmSymbolGlyphTiles = {}
    -- Codes verified against data/generated/font.lua. These emphasize visible
    -- UI corruption: punctuation, brackets, currency, multiplication/gender,
    -- arrows, triangles and the text-box border pieces.
    local symbolCodes = {
      96, 97, 112, 113, 114, 115, 116, 117, 121, 122, 123, 124, 125, 126,
      154, 155, 156, 157, 158, 159, 224, 226, 227, 228, 230, 231, 232,
      237, 238, 239, 240, 241, 243, 244, 245,
    }
    for theme = 0, glyphThemeCount - 1 do
      local fontBase = baseTileCount + theme * glyphThemeStride
      local extraBase = fontBase + fontTileCount
      for i = 0, fontTileCount - 1 do
        glyphTiles[#glyphTiles + 1] = fontBase + i
      end
      for i = 0, extraTileCount - 1 do
        glyphTiles[#glyphTiles + 1] = extraBase + i
      end
      for _, code in ipairs(symbolCodes) do
        if code >= 128 and code < 128 + fontTileCount then
          symbolGlyphTiles[#symbolGlyphTiles + 1] = fontBase + code - 128
        elseif code >= 96 and code < 96 + extraTileCount then
          symbolGlyphTiles[#symbolGlyphTiles + 1] = extraBase + code - 96
        end
      end
      -- Animation uses only the two middle-contrast themes. Avoiding direct
      -- white-to-black swaps keeps the occasional mutation visually gentle.
      if theme == 1 or theme == 2 then
        for _, code in ipairs(symbolCodes) do
          if code >= 128 and code < 128 + fontTileCount then
            calmSymbolGlyphTiles[#calmSymbolGlyphTiles + 1] = fontBase + code - 128
          elseif code >= 96 and code < 96 + extraTileCount then
            calmSymbolGlyphTiles[#calmSymbolGlyphTiles + 1] = extraBase + code - 96
          end
        end
      end
    end

    local function pick(pool, seed)
      return pool[(seed % #pool) + 1]
    end

    local collisionPos = { [5] = true, [7] = true, [13] = true, [15] = true }
    local originalBlocks = map.tileset.blocks
    local customBlocks = {}
    for i, block in ipairs(originalBlocks) do
      local copy = {}
      for j = 1, 16 do copy[j] = block[j] end
      customBlocks[i] = copy
    end

    -- Use the player's starting block as the canonical walkable collision
    -- template so Glitch City remains explorable instead of trapping the player
    -- inside a tiny legal pocket.
    local safeSourceId = source[playerBY + 1][playerBX + 1]
    local safeSourceBlock = originalBlocks[safeSourceId + 1] or originalBlocks[1]
    local safeCollisionTiles = {
      [5] = safeSourceBlock[5],
      [7] = safeSourceBlock[7],
      [13] = safeSourceBlock[13],
      [15] = safeSourceBlock[15],
    }

    local walkableIdByOriginal = {}
    for originalId = 0, #originalBlocks - 1 do
      local baseBlock = originalBlocks[originalId + 1]
      local clone = {}
      for pos = 1, 16 do clone[pos] = baseBlock[pos] end
      clone[5]  = safeCollisionTiles[5]
      clone[7]  = safeCollisionTiles[7]
      clone[13] = safeCollisionTiles[13]
      clone[15] = safeCollisionTiles[15]
      local newId = #customBlocks
      customBlocks[#customBlocks + 1] = clone
      walkableIdByOriginal[originalId] = newId
    end

    local function makeLightHybrid(seed)
      local sourceId = pick(localBlocks, seed * 7 + 3)
      local sourceBlock = originalBlocks[sourceId + 1]
      local block = {}
      for pos = 1, 16 do block[pos] = sourceBlock[pos] end
      -- preserve recognizable structure and only replace a few non-collision tiles
      local replaceBudget = 2 + (seed % 3) -- 2-4 tiles
      local replaced = 0
      for step = 0, 15 do
        if replaced >= replaceBudget then break end
        local pos = ((seed + step * 5) % 16) + 1
        if pos ~= 5 and pos ~= 7 and pos ~= 13 and pos ~= 15 then
          local h = (seed + pos * 29 + step * 11) % 100
          if h < 55 then
            local pool = ((seed + pos + step) % 100) < 72
              and symbolGlyphTiles or glyphTiles
            block[pos] = pick(pool, seed + pos * 41 + step * 3)
          elseif #foreignBlocks > 0 and h < 80 then
            local foreign = originalBlocks[pick(foreignBlocks, seed + pos * 17 + step * 7) + 1]
            block[pos] = foreign[pos]
          else
            block[pos] = pick(terrainTiles, seed + pos * 67 + step * 13)
          end
          replaced = replaced + 1
        end
      end
      block[5]  = safeCollisionTiles[5]
      block[7]  = safeCollisionTiles[7]
      block[13] = safeCollisionTiles[13]
      block[15] = safeCollisionTiles[15]
      return block
    end

    local function makeHeavyHybrid(seed)
      local collisionSourceId = pick(localBlocks, seed * 11 + 5)
      local collisionSource = originalBlocks[collisionSourceId + 1]
      local block = {}
      for pos = 1, 16 do
        local h = (seed + pos * 97 + seed * pos * 3) % 100
        if h < 38 then
          local pool = ((seed + pos * 3) % 100) < 72
            and symbolGlyphTiles or glyphTiles
          block[pos] = pick(pool, seed + pos * 131)
        elseif h < 70 then
          if #foreignBlocks > 0 then
            local foreign = originalBlocks[pick(foreignBlocks, seed + pos * 23 + 0x63) + 1]
            block[pos] = foreign[pos]
          else
            block[pos] = pick(terrainTiles, seed + pos * 67)
          end
        else
          block[pos] = pick(terrainTiles, seed + pos * 43 + 0x21)
        end
      end
      block[5]  = safeCollisionTiles[5]
      block[7]  = safeCollisionTiles[7]
      block[13] = safeCollisionTiles[13]
      block[15] = safeCollisionTiles[15]
      return block
    end

    local firstCustomId = #customBlocks
    local lightStart = firstCustomId
    local lightCount = 112
    for n = 0, lightCount - 1 do
      customBlocks[#customBlocks + 1] = makeLightHybrid(0x99 + n * 73)
    end
    local heavyStart = #customBlocks
    local heavyCount = 56
    for n = 0, heavyCount - 1 do
      customBlocks[#customBlocks + 1] = makeHeavyHybrid(0x199 + n * 173)
    end

    glitchCityHandoff.originalTilesetImage = sourceImagePath
    glitchCityHandoff.originalTilesetBlocks = originalBlocks
    map.tileset.image = glitchImagePath
    map.tileset.blocks = customBlocks

    -- Blend intact chunks and hybrid artifacts. This preserves recognizable map
    -- fragments while still injecting text/UI corruption frequently enough to
    -- feel unstable rather than simply rearranged.
    local chosen = {}
    for by = 0, height - 1 do
      chosen[by + 1] = {}
      for bx = 0, width - 1 do
        if bx == playerBX and by == playerBY then
          chosen[by + 1][bx + 1] = source[by + 1][bx + 1]
        else
          local seed = 0x99 + bx * 251 + by * 379 + bx * by * 43
          local hash = seed % 100
          local id
          if hash < 22 then
            -- intact local map chunk, displaced
            local sx = (bx + math.floor(width / 3) + by * 2) % width
            local sy = (by + math.floor(height / 4) + bx * 3) % height
            id = walkableIdByOriginal[source[sy + 1][sx + 1]] or source[sy + 1][sx + 1]
          elseif hash < 45 then
            -- intact metatiles, including foreign tileset blocks when available
            local pool = #foreignBlocks > 0 and ((seed % 4) == 0) and foreignBlocks or localBlocks
            local picked = pick(pool, seed + bx * 13 + by * 19)
            id = walkableIdByOriginal[picked] or picked
          elseif hash < 75 then
            -- lightly corrupted hybrids dominate
            id = lightStart + (seed % lightCount)
          elseif hash < 90 then
            -- heavy hybrids are rarer accent blocks
            id = heavyStart + (seed % heavyCount)
          else
            -- deterministic out-of-order repeated-memory stream
            local pool = #foreignBlocks > 0 and ((seed % 3) == 0) and foreignBlocks or localBlocks
            local picked = pick(pool, seed + bx * 31 + by * 47 + 0x63)
            id = walkableIdByOriginal[picked] or picked
          end
          chosen[by + 1][bx + 1] = id
        end
      end
    end

    -- Short repeat runs only; avoid large coherent clustering.
    for by = 0, height - 1 do
      for bx = 0, width - 1 do
        if not (bx == playerBX and by == playerBY) then
          local seed = (bx * 83 + by * 149 + 0x99)
          local mode = seed % 29
          if bx > 0 and mode == 0 then
            chosen[by + 1][bx + 1] = chosen[by + 1][bx]
          elseif by > 0 and mode == 1 then
            chosen[by + 1][bx + 1] = chosen[by][bx + 1]
          end
        end
      end
    end

    -- Add a controlled 15% amount of real random collision while keeping the
    -- overall map broadly explorable. Each obstacle variant preserves the
    -- selected block's visuals and swaps only its four collision-defining
    -- tiles. Never place one in the immediate 3x3 area around the player.
    for by = 0, height - 1 do
      for bx = 0, width - 1 do
        local nearPlayer = math.abs(bx - playerBX) <= 1 and math.abs(by - playerBY) <= 1
        local seed = 0x463 + bx * 191 + by * 283 + bx * by * 37
        if not nearPlayer and (seed % 100) < 15 then
          local id = chosen[by + 1][bx + 1]
          local visualBlock = customBlocks[id + 1]
          local collisionSourceId = pick(localBlocks, seed + 0x99)
          local collisionSource = originalBlocks[collisionSourceId + 1]
          if visualBlock and collisionSource then
            local obstacle = {}
            for pos = 1, 16 do obstacle[pos] = visualBlock[pos] end
            obstacle[5]  = collisionSource[5]
            obstacle[7]  = collisionSource[7]
            obstacle[13] = collisionSource[13]
            obstacle[15] = collisionSource[15]
            local obstacleId = #customBlocks
            customBlocks[#customBlocks + 1] = obstacle
            chosen[by + 1][bx + 1] = obstacleId
          end
        end
      end
    end

    -- Prebuild a very small set of visual-only animation variants after all
    -- obstacle decisions are final. Every variant inherits all four collision-
    -- defining positions from the block actually installed at that coordinate.
    local mutationCells = {}
    local mutationPositions = { 1, 2, 3, 4, 6, 8, 9, 10, 11, 12, 14, 16 }
    for by = 0, height - 1 do
      for bx = 0, width - 1 do
        local seed = 0x721 + bx * 211 + by * 307 + bx * by * 17
        if #mutationCells < 64 and (seed % 3) == 0 then
          local baseId = chosen[by + 1][bx + 1]
          local baseBlock = customBlocks[baseId + 1]
          if baseBlock then
            local ids = { baseId }
            for variant = 1, 2 do
              local clone = {}
              for pos = 1, 16 do clone[pos] = baseBlock[pos] end
              for glyph = 0, 3 do
                local pos = mutationPositions[
                  ((seed + variant * 5 + glyph * 3) % #mutationPositions) + 1
                ]
                clone[pos] = pick(calmSymbolGlyphTiles,
                  seed + variant * 137 + glyph * 191 + pos * 29)
              end
              clone[5] = baseBlock[5]
              clone[7] = baseBlock[7]
              clone[13] = baseBlock[13]
              clone[15] = baseBlock[15]
              ids[#ids + 1] = #customBlocks
              customBlocks[#customBlocks + 1] = clone
            end
            mutationCells[#mutationCells + 1] = {
              x = bx, y = by, ids = ids, phase = 1,
            }
          end
        end
      end
    end

    for by = 0, height - 1 do
      for bx = 0, width - 1 do
        map:setBlock(bx, by, chosen[by + 1][bx + 1])
      end
    end

    if not rebuildRendererForTileset(map) then
      map.tileset.image = sourceImagePath
      map.tileset.blocks = originalBlocks
      return false
    end

    glitchCityHandoff.active = true
    glitchCityHandoff.mapRef = map
    glitchCityHandoff.mapId = map.id
    glitchCityHandoff.originalBlocks = snapshot
    glitchCityHandoff.remainingFrames = glitchCityHandoff.durationFrames
    glitchCityHandoff.glyphMutationCells = mutationCells
    glitchCityHandoff.glyphMutationCountdown = glitchCityHandoff.glyphMutationIntervalFrames
    glitchCityHandoff.glyphMutationCursor = 0
    glitchCityHandoff.glyphMutationCount = 0
    if not installGlitchCityContainment(world, map) then
      glitchCityHandoff.active = false
      glitchCityHandoff.mapRef = nil
      glitchCityHandoff.mapId = nil
      glitchCityHandoff.originalBlocks = nil
      return false
    end
    mod.log:info("G1GPP opaque multishade UI-glyph 15pct-collision area-locked Glitch City active on %s", tostring(map.id))
    debugLogger:log("GLITCH GLYPH TERRAIN INSTALLED",
      "map=" .. debugLogger:safeField(map.id)
      .. " themes=" .. debugLogger:safeField(glyphThemeCount)
      .. " glyphTiles=" .. debugLogger:safeField(#glyphTiles)
      .. " symbolTiles=" .. debugLogger:safeField(#symbolGlyphTiles)
      .. " collisionPositionsPreserved=true opaqueBackgrounds=true")
    debugLogger:log("GLITCH GLYPH DRIFT ARMED",
      "map=" .. debugLogger:safeField(map.id)
      .. " eligibleBlocks=" .. debugLogger:safeField(#mutationCells)
      .. " intervalFrames=" .. debugLogger:safeField(glitchCityHandoff.glyphMutationIntervalFrames)
      .. " blocksPerInterval=1 glyphsPerBlock=4 cameraLocal=true"
      .. " middleContrastOnly=true collisionFrozen=true")
    debugLogger:log("GLITCH CITY ACTIVE", "durationFrames=" .. debugLogger:safeField(glitchCityHandoff.durationFrames)
      .. " origin=" .. debugLogger:safeField(glitchCityHandoff.origin and glitchCityHandoff.origin.mapId)
      .. "@" .. debugLogger:safeField(glitchCityHandoff.origin and glitchCityHandoff.origin.x)
      .. "," .. debugLogger:safeField(glitchCityHandoff.origin and glitchCityHandoff.origin.y)
      .. " current=" .. playerStateSummary(world))
    startGlitchCityAudio()
    return true
  end

  local function updateGlitchGlyphDrift(world)
    local state = glitchCityHandoff
    local cells = state.glyphMutationCells
    local map = state.mapRef
    if not (state.active and map and cells and #cells > 0) then return end
    state.glyphMutationCountdown = (state.glyphMutationCountdown or 0) - 1
    if state.glyphMutationCountdown > 0 then return end
    state.glyphMutationCountdown = state.glyphMutationIntervalFrames

    local player = world and world.player
    local playerBX = player and math.floor((player.cellX or 0) / 2) or -99
    local playerBY = player and math.floor((player.cellY or 0) / 2) or -99
    for _ = 1, #cells do
      state.glyphMutationCursor = (state.glyphMutationCursor % #cells) + 1
      local cell = cells[state.glyphMutationCursor]
      local dx = math.abs(cell.x - playerBX)
      local dy = math.abs(cell.y - playerBY)
      local outsideImmediateArea = dx > 1 or dy > 1
      -- A 160x144 Gen-I playfield shows only a small ring of metatiles around
      -- the player. Keep the target inside that camera-local area rather than
      -- the much broader map neighborhood used by earlier probes.
      local inVisibleNeighborhood = dx <= 3 and dy <= 2
      if outsideImmediateArea and inVisibleNeighborhood then
        cell.phase = (cell.phase % #cell.ids) + 1
        map:setBlock(cell.x, cell.y, cell.ids[cell.phase])
        -- TileRenderer caches the visual map. setBlock updates map/collision
        -- state but does not reliably invalidate that cache, so explicitly use
        -- its lightweight rebuild path after the isolated visual mutation.
        local rendererRefreshed, refreshError = rebuildMapRenderer(map)
        if not rendererRefreshed then
          rendererRefreshed = rebuildRendererForTileset(map)
        end
        state.glyphMutationCount = (state.glyphMutationCount or 0) + 1
        debugLogger:log("GLITCH GLYPH DRIFT",
          "mutation=" .. debugLogger:safeField(state.glyphMutationCount)
          .. " map=" .. debugLogger:safeField(map.id)
          .. " block=" .. debugLogger:safeField(cell.x) .. "," .. debugLogger:safeField(cell.y)
          .. " phase=" .. debugLogger:safeField(cell.phase)
          .. " playerBlock=" .. debugLogger:safeField(playerBX) .. "," .. debugLogger:safeField(playerBY)
          .. " cameraLocal=true collisionFrozen=true"
          .. " rendererRefreshed=" .. debugLogger:safeField(rendererRefreshed)
          .. " refreshError=" .. debugLogger:safeField(refreshError))
        return
      end
    end
  end

  -- No Overworld.draw override is installed. All Glitch City corruption
  -- is represented by actual live map blocks and collision data.

  -- Keep a tiny rolling edge age in case the exact landing frame consumes the
  -- edge before startTrainerApproach sees it. The native joyLatch remains the
  -- authoritative path.
  mod.hooks:wrap("input.step", function(next, game_, dt)
    next(game_, dt)
    if game_ and game_.input and game_.input:wasPressed("start") then
      startPressAge = 0
    else
      startPressAge = math.min(startPressAge + 1, 9999)
    end
  end)

  -- Glitch City is an unstable overworld state, not a valid battle context.
  -- Suppress every supported battle-entry path until recovery or escape.
  mod.hooks:wrap("encounter.roll", function(next, ctx, ...)
    if glitchCityHandoff.active then return nil end
    return next(ctx, ...)
  end)

  mod.hooks:wrap("script.command", function(next, ctx, name, args)
    if glitchCityHandoff.active then
      local exitCommand = name == "warp" or name == "move_player"
        or name == "push_screen" or name == "fade"
      debugLogger:log(exitCommand and "CONTAINMENT EXIT BLOCKED" or "SCRIPT BLOCKED",
        "kind=script_command command=" .. debugLogger:safeField(name)
        .. " args=" .. debugLogger:safeField(args) .. " " .. playerStateSummary(activeWorld))
      return nil
    end
    if name == "start_battle" then
      debugLogger:log("SCRIPT START_BATTLE", "active=" .. debugLogger:safeField(glitchCityHandoff.active)
        .. " args=" .. debugLogger:safeField(args) .. " " .. playerStateSummary(activeWorld))
      if glitchCityHandoff.active then
        mod.log:info("G1GPP blocked scripted battle during Glitch City")
        debugLogger:log("BATTLE BLOCKED", "scripted battle suppressed during Glitch City")
        return nil
      end
      if not glitchCityHandoff.origin then
        captureGlitchCityOrigin(activeWorld, "script_command_start_battle_fallback")
      end
    end
    return next(ctx, name, args)
  end)

  mod.hooks:wrap("save.write", function(next, game_)
    if glitchCityHandoff.active then
      mod.log:info("G1GPP blocked save write during Glitch City")
      return false
    end
    return next(game_)
  end)

  Overworld.startTrainerApproach = function(world, npc, dist)
    if glitchCityHandoff.active then
      mod.log:info("G1GPP blocked trainer engagement during Glitch City")
      return
    end
    if escape or not isTargetTrainer(world, npc) or not startWasBuffered(world) then
      return originalStart(world, npc, dist)
    end

    -- Let vanilla create the music sting, engagement lock, frozen NPC, and
    -- 60-frame exclamation emote. Pushing StartMenu on top pauses that exact
    -- state. Closing the menu normally therefore resumes the same approach;
    -- no synthetic second exclamation is needed.
    originalStart(world, npc, dist)

    local class, party = trainerIdentity(npc)
    escape = {
      world = world,
      npc = npc,
      dist = dist,
      originMap = world.map and world.map.id,
      trainerClass = class,
      partyIndex = party,
      teleported = false,
      qualified = false,
      returnTriggered = false,
    }
    activeWorld = world
    world.joyLatch = nil
    startPressAge = 9999

    mod.log:info("G1GPP interrupted %s#%s on %s",
      tostring(class), tostring(party), tostring(escape.originMap))
    Screens.push(game, "StartMenu")
  end

  local function armDebugReturnIfEnabled(reason)
    if not (escape and escape.teleported and not escape.qualified) then return false end
    local debugEnabled, debugValue, debugAttackModifier = debugSettings()
    if not debugEnabled then return false end
    escape.qualified = true
    escape.special = debugValue
    escape.attackModifier = debugAttackModifier
    escape.lastEnemySpecies = "DEBUG_OVERRIDE"
    escape.resolvedEncounter = EncounterData.resolve(debugValue, pokemonByIndex)
    mod.log:info(
      "G1GPP debug qualified at %s: Special=%d kind=%s species=%s; return to %s",
      tostring(reason), debugValue,
      tostring(escape.resolvedEncounter and escape.resolvedEncounter.kind),
      tostring(escape.resolvedEncounter and escape.resolvedEncounter.species),
      tostring(escape.originMap))
    return true
  end

  Overworld.beginTeleportOut = function(world, onDone)
    if escape and escape.world == world and not escape.teleported then
      escape.teleported = true
      activeWorld = world
      releaseTrainerApproach(world)
      -- Debug mode skips the intermediary battle. Arm the return immediately
      -- when Teleport is actually selected, rather than depending on a later
      -- warp event whose exact path varies between engine builds.
      armDebugReturnIfEnabled("teleport_begin")
      mod.log:info("G1GPP Teleport escape armed")
    end
    return originalTeleport(world, onDone)
  end

  -- Every entry below is verified against the recomp's extracted Gen-I
  -- charmap. The loader's shared font and the Blue/Yellow edition fonts are
  -- byte-identical, so none of these depend on another ROM being installed.
  local GLITCH_DIALOGUE_POOLS = {
    latin = {
      "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
      "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
      "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
      "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
      "é",
    },
    symbols = {
      "!", "?", ".", ",", "'", "\"", ":", ";", "-", "/", "(", ")",
      "[", "]", "¥", "·", "×", "‘", "’", "“", "”", "…", "′", "″",
      "№", "⋯", "─", "│", "┌", "┐", "└", "┘", "▲", "▶", "▷", "▼",
      "♀", "♂", "。", "「", "」", "『", "』", "ー", "円", "！", "．",
      "／", "？", "ﾞ", "ﾟ",
    },
    digits = {
      "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
      "０", "１", "２", "３", "４", "５", "６", "７", "８", "９",
    },
    kana = {
      "ぁ", "あ", "ぃ", "い", "ぅ", "う", "ぇ", "え", "ぉ", "お",
      "か", "き", "く", "け", "こ", "さ", "し", "す", "せ", "そ",
      "た", "ち", "っ", "つ", "て", "と", "な", "に", "ぬ", "ね",
      "の", "は", "ひ", "ふ", "へ", "ほ", "ま", "み", "む", "め",
      "も", "ゃ", "や", "ゅ", "ゆ", "ょ", "よ", "ら", "り", "る",
      "れ", "ろ", "わ", "を", "ん", "ァ", "ア", "ィ", "イ", "ゥ",
      "ウ", "ェ", "エ", "ォ", "オ", "カ", "キ", "ク", "ケ", "コ",
      "サ", "シ", "ス", "セ", "ソ", "タ", "チ", "ッ", "ツ", "テ",
      "ト", "ナ", "ニ", "ヌ", "ネ", "ノ", "ハ", "ヒ", "フ", "ホ",
      "マ", "ミ", "ム", "メ", "モ", "ャ", "ヤ", "ュ", "ユ", "ョ",
      "ヨ", "ラ", "ル", "レ", "ロ", "ワ", "ヲ", "ン",
    },
  }

  local GLITCH_DIALOGUE_POOL_ORDER = {
    "symbols", "symbols", "latin", "latin", "digits", "kana", "kana",
  }

  local function randomGlitchGlyph()
    local poolName = GLITCH_DIALOGUE_POOL_ORDER[
      love.math.random(1, #GLITCH_DIALOGUE_POOL_ORDER)]
    local pool = GLITCH_DIALOGUE_POOLS[poolName]
    return pool[love.math.random(1, #pool)]
  end

  local function glitchDialogueSource(world, npc)
    local d = npc and npc.def or {}
    local data = game and game.data
    if data and d.trainerClass and data.trainerHeader then
      local ok, header = pcall(data.trainerHeader, data,
        world.map and world.map.def and world.map.def.label, d.index)
      if ok and header then
        local key = header.before or header.after
        if key and data.text and data.text[key] then return data.text[key] end
      end
    end
    if data and data.resolveText and world.map and world.map.def then
      local ok, text = pcall(data.resolveText, data, world.map.def.label, d.text)
      if ok and type(text) == "string" and text ~= "" then return text end
    end
    return "THE SIGNAL IS LOST\nPLEASE TRY AGAIN"
  end

  local function corruptDialogue(text)
    text = tostring(text or "")
    -- Keep one compact page. Preserve whitespace and line/page breaks so the
    -- result reads like corrupted speech instead of an undifferentiated wall.
    text = text:match("^[^\f]*") or text
    local out, visible = {}, 0
    for i = 1, #text do
      local ch = text:sub(i, i)
      if ch == "\r" then
        -- Ignore CR in CRLF text; the following LF carries the line break.
      elseif ch == "\n" or ch == "\v" then
        out[#out + 1] = "\n"
      elseif ch == " " or ch == "\t" then
        out[#out + 1] = " "
      else
        visible = visible + 1
        if visible > 54 then break end
        out[#out + 1] = randomGlitchGlyph()
      end
    end
    local result = table.concat(out):gsub("[ \n]+$", "")
    if result == "" then result = "?×? ×?×\n×??!" end
    return result
  end

  local function showGlitchNpcDialogue(world, npc)
    npc.frozen = true
    if npc.facePlayer and not npc.moving then
      pcall(npc.facePlayer, npc, world.player)
    end
    local source = glitchDialogueSource(world, npc)
    local text = corruptDialogue(source)
    debugLogger:log("GLITCH NPC DIALOGUE",
      "map=" .. debugLogger:safeField(world.map and world.map.id)
      .. " npc=" .. debugLogger:safeField(npc.id)
      .. " trainer=" .. debugLogger:safeField(npc.def and npc.def.trainerClass)
      .. " moving=" .. debugLogger:safeField(npc.moving)
      .. " sourceLength=" .. debugLogger:safeField(#tostring(source))
      .. " outputLength=" .. debugLogger:safeField(#text))
    game.stack:push(TextBox.new(game, text, function()
      npc.frozen = false
      debugLogger:log("GLITCH NPC DIALOGUE CLOSED",
        "map=" .. debugLogger:safeField(world.map and world.map.id)
        .. " npc=" .. debugLogger:safeField(npc.id))
    end))
  end

  -- During Glitch City, NPCs and stationary trainers may answer with a safe,
  -- synthetic corrupted text box. Their real scripts never run. Signs,
  -- hidden objects, terminals, switches, and map-object scripts remain inert.
  Overworld.interact = function(world)
    if glitchCityHandoff.active then
      local player = world and world.player
      local fx, fy
      if player and player.facingCell then
        local ok, x, y = pcall(player.facingCell, player)
        if ok then fx, fy = x, y end
      end
      local npc = fx and fy and world.npcAtCell and world:npcAtCell(fx, fy)
      if not npc and fx and fy and world.map and world.map.isCounterCell
         and world.map:isCounterCell(fx, fy) and player then
        local dx, dy = 0, 0
        if player.facing == "up" then dy = -1
        elseif player.facing == "down" then dy = 1
        elseif player.facing == "left" then dx = -1
        elseif player.facing == "right" then dx = 1 end
        npc = world:npcAtCell(fx + dx, fy + dy)
      end
      if npc and not npc.pikachuFollower then
        showGlitchNpcDialogue(world, npc)
        return
      end
      debugLogger:log("INTERACTION BLOCKED", "map=" .. debugLogger:safeField(world and world.map and world.map.id)
        .. " player=" .. debugLogger:safeField(player and player.cellX) .. ","
        .. debugLogger:safeField(player and player.cellY)
        .. " facing=" .. debugLogger:safeField(player and player.facing)
        .. " target=" .. debugLogger:safeField(fx) .. "," .. debugLogger:safeField(fy)
        .. " runner=" .. debugLogger:safeField(world and world.runner and world.runner.isRunning
          and world.runner:isRunning()))
      return nil
    end
    return originalInteract(world)
  end

  Player.__g1gppOriginalTryMove = Player.__g1gppOriginalTryMove or Player.tryMove
  local originalPlayerTryMove = Player.__g1gppOriginalTryMove
  Player.tryMove = function(player, dir, map, entities)
    if glitchCityHandoff.active and map == glitchCityHandoff.mapRef then
      local dx, dy = 0, 0
      if dir == "up" then dy = -1
      elseif dir == "down" then dy = 1
      elseif dir == "left" then dx = -1
      elseif dir == "right" then dx = 1 end
      local tx, ty = player.cellX + dx, player.cellY + dy
      local key = ty * map.widthCells + tx
      if not map:inBounds(tx, ty) then
        logBlockedExit("map_edge", activeWorld, tx, ty, dir)
        return "blocked", "containment"
      end
      if glitchCityHandoff.blockedWarpCells
         and glitchCityHandoff.blockedWarpCells[key] then
        logBlockedExit("warp_cell", activeWorld, tx, ty, dir)
        return "blocked", "containment"
      end
    end
    return originalPlayerTryMove(player, dir, map, entities)
  end

  Overworld.__g1gppOriginalOnStepComplete =
    Overworld.__g1gppOriginalOnStepComplete or Overworld.onStepComplete
  local originalOnStepComplete = Overworld.__g1gppOriginalOnStepComplete
  Overworld.onStepComplete = function(world)
    if glitchCityHandoff.active then
      -- Movement completes normally, but every step-triggered script, warp,
      -- encounter, forced movement, ladder, hole, and environmental event is
      -- inert for the lifetime of the corrupted zone.
      return nil
    end
    return originalOnStepComplete(world)
  end

  Overworld.__g1gppOriginalTakeWarp =
    Overworld.__g1gppOriginalTakeWarp or Overworld.takeWarp
  local originalTakeWarp = Overworld.__g1gppOriginalTakeWarp
  Overworld.takeWarp = function(world, warpDef)
    if glitchCityHandoff.active then
      logBlockedExit("warp_dispatch", world,
        world.player and world.player.cellX, world.player and world.player.cellY,
        warpDef and warpDef.destMap)
      return nil
    end
    return originalTakeWarp(world, warpDef)
  end

  Overworld.__g1gppOriginalStartWarpTo =
    Overworld.__g1gppOriginalStartWarpTo or Overworld.startWarpTo
  local originalStartWarpTo = Overworld.__g1gppOriginalStartWarpTo
  Overworld.startWarpTo = function(world, mapId, x, y, facing, onDone, opts)
    if glitchCityHandoff.active then
      logBlockedExit("scripted_warp", world, x, y,
        "dest=" .. debugLogger:safeField(mapId) .. " via=" .. debugLogger:safeField(opts and opts.via))
      return nil
    end
    return originalStartWarpTo(world, mapId, x, y, facing, onDone, opts)
  end

  -- During the escaped/pending state, only Start is suppressed. Movement,
  -- interaction, doors, and trainer battles remain vanilla until Glitch City
  -- itself becomes active; active interactions are blocked above.
  Overworld.handleInput = function(world)
    local input = game and game.input
    local latch = world.joyLatch

    if escape and escape.teleported and activeWorld == world and input then
      local requested = input:wasPressed("start")
        or (latch and latch.start and input:isDown("start"))
      if requested then
        if latch then latch.start = nil end
        return
      end
    end

    return originalHandleInput(world)
  end

  Overworld.update = function(world, dt)
    -- Continuously retain the ordinary active overworld for debug tools.
    activeWorld = world
    if not debugGameLoadedMarked then
      debugGameLoadedMarked = true
      debugLogger:log("GAME LOADED", "session=" .. debugLogger:safeField(debugLogger.sessionId)
        .. " " .. debugLogger:gameVersionSummary() .. " " .. playerStateSummary(world)
        .. " " .. musicStateSummary())
    end

    -- Complete the engine's restored intro-to-loop music handoff without
    -- restarting the pre-glitch source. Wait until the restored main source
    -- actually stops, then start only its designated loop source.
    if glitchCityHandoff.recoveryMusicWatchActive then
      glitchCityHandoff.recoveryMusicWatchFrames =
        (glitchCityHandoff.recoveryMusicWatchFrames or 0) + 1
      local main = glitchCityHandoff.recoveryMusicMainSource
      local loop = glitchCityHandoff.recoveryMusicLoopSource
      local mainPlaying = false
      local loopPlaying = false
      if main then
        local ok, value = pcall(main.isPlaying, main)
        mainPlaying = ok and value == true
      end
      if loop then
        local ok, value = pcall(loop.isPlaying, loop)
        loopPlaying = ok and value == true
      end
      if not mainPlaying then
        if loop and not loopPlaying then
          pcall(loop.setPitch, loop, 1)
          pcall(loop.setVolume, loop,
            glitchCityHandoff.recoveryMusicLoopTargetVolume or 1)
          pcall(loop.setLooping, loop, true)
          local okPlay, playErr = pcall(loop.play, loop)
          debugLogger:log("RECOVERY MUSIC LOOP HANDOFF",
            "ok=" .. debugLogger:safeField(okPlay)
            .. " error=" .. debugLogger:safeField(playErr)
            .. " frames=" .. debugLogger:safeField(glitchCityHandoff.recoveryMusicWatchFrames)
            .. " mainRef=" .. debugLogger:safeField(tostring(main))
            .. " loopRef=" .. debugLogger:safeField(tostring(loop))
            .. " " .. musicStateSummary())
        else
          debugLogger:log("RECOVERY MUSIC LOOP HANDOFF",
            "loopAlreadyPlaying=" .. debugLogger:safeField(loopPlaying)
            .. " frames=" .. debugLogger:safeField(glitchCityHandoff.recoveryMusicWatchFrames)
            .. " " .. musicStateSummary())
        end
        glitchCityHandoff.recoveryMusicWatchActive = false
      elseif glitchCityHandoff.recoveryMusicWatchFrames >= 1800 then
        debugLogger:log("RECOVERY MUSIC LOOP WATCH TIMEOUT", musicStateSummary())
        glitchCityHandoff.recoveryMusicWatchActive = false
      end
    end

    -- Direct Glitch City action. It is queued from the Mods screen and begins
    -- only after that screen has closed and the native overworld is safely idle.
    -- The only skipped stage is battle creation; runtime activation is shared.
    if debugGlitchCityPending
       and game and game.stack:top() == world
       and not world.transitioning
       and not world.runner:isRunning() then
      debugGlitchCityPending = false
      if glitchCityHandoff.active then
        debugLogger:log("DIRECT GLITCH CITY START BLOCKED", "reason=already_active "
          .. playerStateSummary(world))
      else
        escape = nil
        glitchCityHandoff.armed = false
        glitchCityHandoff.pending = false
        glitchCityHandoff.idleFrames = 0
        captureGlitchCityOrigin(world, "direct_debug_glitch_city")
        debugLogger:log("DIRECT GLITCH CITY START REQUEST",
          "battleBypassed=true durationFrames=" .. debugLogger:safeField(glitchCityHandoff.durationFrames)
          .. " " .. playerStateSummary(world))
        local ok, activated = pcall(corruptRuntimeMap, world)
        if ok and activated then
          debugLogger:log("DIRECT GLITCH CITY STARTED",
            "battleBypassed=true " .. playerStateSummary(world))
        else
          glitchCityHandoff.origin = nil
          debugLogger:log("DIRECT GLITCH CITY START FAILED",
            "error=" .. debugLogger:safeField(ok and "activation_returned_false" or activated)
            .. " " .. playerStateSummary(world))
        end
      end
    end

    -- Direct test-battle action. Reuse the exact existing encounter resolver by
    -- creating the same finished-escape payload and silently opening/closing
    -- the forced Start menu state. Nothing is drawn; its screen.popped handler
    -- immediately queues the selected trainer/glitch encounter.
    if debugTestBattlePending
       and game and game.stack:top() == world
       and not world.transitioning
       and not world.runner:isRunning() then
      debugTestBattlePending = false
      local _, debugValue, debugAttackModifier = debugSettings()
      captureGlitchCityOrigin(world, "direct_test_before_battle")
      debugLogger:log("DIRECT TEST BATTLE START", "special=" .. debugLogger:safeField(debugValue)
        .. " attackMod=" .. debugLogger:safeField(debugAttackModifier) .. " " .. playerStateSummary(world))
      escape = {
        world = world,
        originMap = world.map and world.map.id,
        teleported = true,
        qualified = true,
        returnTriggered = true,
        special = debugValue,
        attackModifier = debugAttackModifier,
        lastEnemySpecies = "DIRECT_TEST",
        resolvedEncounter = EncounterData.resolve(debugValue, pokemonByIndex),
      }
      Screens.push(game, "StartMenu")
      forcedMenu = game.stack:top()
      game.stack:pop()
      return
    end

    -- A native Start-menu selection closes through the menu's own lifecycle.
    -- Once the overworld is safely topmost, present our own WARP / CANCEL box
    -- rather than entering the game's TELEPORT field-move confirmation.
    if quickWarpConfirmPending
       and game and game.stack:top() == world
       and not world.transitioning
       and not world.runner:isRunning() then
      quickWarpConfirmPending = false
      game.stack:push(QuickWarpConfirmMenu.new(game))
      return
    end

    -- Perform a confirmed Quick Warp only after the confirmation screen has
    -- popped and control has safely returned to the overworld.
    if quickWarpMenuPending
       and game and game.stack:top() == world
       and not world.transitioning
       and not world.runner:isRunning() then
      quickWarpMenuPending = false
      performQuickWarp()
      return
    end

    -- A Warp Anywhere selection is made inside a child list above the Mods
    -- screen. Wait until every menu has closed and the idle overworld is
    -- topmost before changing maps.
    if warpAnywherePending
       and game and game.stack:top() == world
       and not world.transitioning
       and not world.runner:isRunning() then
      performWarpAnywhere()
      return
    end

    local input = game and game.input
    local latch = world.joyLatch
    local safeForQuickWarp =
      quickWarpPoint
      and game
      and game.stack:top() == world
      and input
      and not world.transitioning
      and not world.runner:isRunning()

    if safeForQuickWarp then
      -- Emergency Quick Warp is deliberately isolated from START and SELECT
      -- so it cannot collide with the native menu or other field-action mods.
      -- A must already be held before a fresh B press. Simultaneous presses,
      -- B followed by A, and latched presses do not trigger the shortcut.
      if not input:isDown("b") then
        quickWarpHotkeyArmed = input:isDown("a")
      elseif not input:isDown("a") then
        quickWarpHotkeyArmed = false
      end

      if quickWarpHotkeyArmed
         and input:isDown("a")
         and input:wasPressed("b") then
        quickWarpHotkeyArmed = false
        if latch then
          latch.a = nil
          latch.b = nil
        end
        performQuickWarp()
        return
      end

      -- START and SELECT are never intercepted here. Their normal behavior,
      -- including functionality supplied by other mods, remains untouched.
    else
      quickWarpHotkeyArmed = false
    end

    local result = originalUpdate(world, dt)

    if glitchCityHandoff.active then
      updateGlitchCityReverseAudio(dt)
      updateGlitchGlyphDrift(world)
      if world.map ~= glitchCityHandoff.mapRef
         or (world.map and world.map.id ~= glitchCityHandoff.mapId) then
        -- Glitch City is confined to the corrupted source area. Any route,
        -- door, cave, building, or warp transition is immediately cancelled by
        -- restoring the clean source map and returning to the exact pre-battle
        -- origin. This prevents destination-map state from interfering with
        -- the timed recovery warp.
        debugLogger:log("AREA TRANSITION DETECTED", "expected=" .. debugLogger:safeField(glitchCityHandoff.mapId)
          .. " current=" .. playerStateSummary(world))
        restoreGlitchCityMap("blocked_area_transition", world, true)
      else
        glitchCityHandoff.remainingFrames = glitchCityHandoff.remainingFrames - 1
        if glitchCityHandoff.remainingFrames <= 0 then
          debugLogger:log("TIMER EXPIRED", playerStateSummary(world))
          glitchCityHandoff.remainingFrames = 0
          game.stack:push(GlitchCityRecoveryScreen.new(game, world, "timer"))
        end
      end
    end

    -- setMap/map.entered can happen inside a transition. Wait until the live
    -- overworld is topmost and idle before forcing the return menu.
    if forceMenuPending and escape and escape.qualified
       and world.map and world.map.id == escape.originMap
       and game and game.stack:top() == world
       and not world.transitioning and not world.runner:isRunning() then
      forceMenuPending = false
      escape.returnTriggered = true
      Screens.push(game, "StartMenu")
      forcedMenu = game.stack:top()
      mod.log:info("G1GPP forced return menu on %s", escape.originMap)
    end

    local overworldReady =
      game
      and game.stack:top() == world
      and not world.transitioning
      and not world.runner:isRunning()


    if glitchCityHandoff.recoveryMessagePending and overworldReady then
      glitchCityHandoff.recoveryMessagePending = false
      game.stack:push(TextBox.new(
        game,
        "WORLD DATA\nRECOVERED.",
        function()
          game.stack:push(TextBox.new(
            game,
            "YOUR SAVE FILE WAS\nPROTECTED FROM DAMAGE."
          ))
        end
      ))
      return result
    end

    -- Do not activate immediately on the first frame back from battle. Wait
    -- for a clean, stable overworld for half a second, then show only the
    -- intended corruption warning.
    if glitchCityHandoff.pending and overworldReady then
      glitchCityHandoff.idleFrames = glitchCityHandoff.idleFrames + 1
      if glitchCityHandoff.idleFrames >= 30 then
        glitchCityHandoff.pending = false
        glitchCityHandoff.idleFrames = 0
        debugLogger:log("GLITCH CITY HANDOFF READY", playerStateSummary(world))

        game.stack:push(TextBox.new(
          game,
          "MEMORY OVERWRITE\nDETECTED!",
          function()
            game.stack:push(TextBox.new(
              game,
              "WORLD DATA HAS\nBEEN CORRUPTED.",
              function()
                corruptRuntimeMap(world)
              end
            ))
          end
        ))
      end
    elseif pendingJacredBallMessage
       and overworldReady then
      pendingJacredBallMessage = false
      pendingJacredBallExitBattle = nil
      game.stack:push(
        JacredPostBattleMessageScreen.new(game)
      )
    end

    return result
  end


  local crashRawFrames248 = {
    {
      vram = mod.assets:path("assets/effects_raw/248/000.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/000.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/000.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/001.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/001.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/001.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/002.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/002.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/002.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/003.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/003.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/003.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/004.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/004.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/004.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/005.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/005.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/005.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/006.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/006.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/006.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/007.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/007.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/007.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/008.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/008.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/008.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/009.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/009.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/009.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/010.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/010.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/010.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/011.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/011.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/011.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/012.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/012.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/012.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/013.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/013.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/013.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/014.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/014.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/014.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/015.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/015.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/015.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/016.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/016.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/016.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/017.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/017.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/017.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/018.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/018.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/018.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/019.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/019.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/019.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/020.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/020.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/020.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/021.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/021.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/021.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/022.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/022.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/022.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/023.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/023.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/023.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/024.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/024.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/024.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/025.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/025.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/025.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/026.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/026.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/026.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/027.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/027.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/027.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/028.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/028.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/028.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/029.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/029.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/029.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/248/030.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/248/030.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/248/030.regs.bin"),
    },
  }

  local crashRawFrames254 = {
    {
      vram = mod.assets:path("assets/effects_raw/254/000.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/000.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/000.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/001.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/001.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/001.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/002.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/002.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/002.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/003.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/003.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/003.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/004.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/004.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/004.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/005.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/005.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/005.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/006.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/006.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/006.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/007.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/007.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/007.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/008.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/008.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/008.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/009.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/009.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/009.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/010.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/010.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/010.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/011.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/011.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/011.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/012.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/012.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/012.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/013.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/013.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/013.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/014.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/014.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/014.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/015.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/015.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/015.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/016.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/016.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/016.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/017.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/017.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/017.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/018.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/018.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/018.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/019.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/019.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/019.regs.bin"),
    },
    {
      vram = mod.assets:path("assets/effects_raw/254/020.vram.bin"),
      oam = mod.assets:path("assets/effects_raw/254/020.oam.bin"),
      regs = mod.assets:path("assets/effects_raw/254/020.regs.bin"),
    },
  }

  local trainerByClassIndex = {}
  local generatedTrainerParties = {}
  local jacredTrainerId = "TF_JACRED"
  local crashBridgeTrainerId = "TF_CRASH_BRIDGE"

  -- Jacred has no stable trainer-name pointer in the original game. The
  -- displayed text may be blank, resemble a Pokémon or trainer name, or
  -- decode as garbage. Keep the internal trainer ID stable while changing
  -- only the user-facing name before each encounter.
  local function randomArrayValue(values)
    if not values or #values == 0 then return nil end
    return values[math.random(1, #values)]
  end

  local function collectPokemonDisplayNames()
    local names = {}
    for id, def in pairs((game.data and game.data.pokemon) or {}) do
      local name =
        def and (def.name or def.displayName or def.display_name) or nil
      if type(name) ~= "string" or name == "" then
        name = tostring(id or "")
      end
      if name ~= "" and not string.match(name, "^TF_") then
        names[#names + 1] = string.upper(name)
      end
    end
    return names
  end

  local function collectTrainerDisplayNames()
    local names = {}
    for id, def in pairs((game.data and game.data.trainers) or {}) do
      if id ~= jacredTrainerId and id ~= crashBridgeTrainerId then
        local name = def and def.name or nil
        if type(name) == "string" and name ~= "" then
          names[#names + 1] = string.upper(name)
        end
      end
    end
    return names
  end

  local function generateJacredGarbageName()
    local length = math.random(1, 10)
    local output = {}
    for _ = 1, length do
      output[#output + 1] = randomGlitchGlyph() or "?"
    end

    -- Occasionally create an early terminator-like truncation by returning
    -- only the first portion, including the possibility of one glyph.
    if length >= 3 and math.random(1, 4) == 1 then
      local keep = math.random(1, length - 1)
      while #output > keep do table.remove(output) end
    end

    return table.concat(output)
  end

  local function clampJacredDisplayName(name)
    name = tostring(name or "")
    -- Font.split follows the recomp's greedy extracted charmap and therefore
    -- treats UTF-8 symbols, kana, and ligatures as complete display glyphs.
    -- Never byte-truncate an expanded name: that could split a glyph and turn
    -- the remainder into blank replacement cells in the battle header.
    local spans = Font.split(name)
    if #spans > 10 then return name:sub(1, spans[10].to) end
    return name
  end

  local recentJacredDisplayNames = { standard = {}, zzazz_bag = {} }
  local RECENT_JACRED_NAME_LIMIT = 8

  local function jacredNameWasRecent(variant, name)
    for _, prior in ipairs(recentJacredDisplayNames[variant] or {}) do
      if prior == name then return true end
    end
    return false
  end

  local function rememberJacredName(variant, name)
    local recent = recentJacredDisplayNames[variant]
    if not recent then
      recent = {}
      recentJacredDisplayNames[variant] = recent
    end
    recent[#recent + 1] = name
    while #recent > RECENT_JACRED_NAME_LIMIT do table.remove(recent, 1) end
  end

  local function chooseJacredDisplayName(variant)
    variant = variant == "zzazz_bag" and "zzazz_bag" or "standard"
    local lastName, lastCategory

    -- Generated corruption is deliberately doubled from 35% to 70%.
    -- The old non-garbage categories retain approximately their relative
    -- proportions inside the remaining 30%: Pokémon 12, blank 7, trainer 7,
    -- literal JACRED 4.
    for _ = 1, 12 do
      local roll = math.random(1, 100)
      local category, name
      if roll <= 70 then
        category = "garbage"
        name = generateJacredGarbageName()
      elseif roll <= 82 then
        category = "pokemon"
        name = randomArrayValue(collectPokemonDisplayNames())
      elseif roll <= 89 then
        category = "blank"
        name = ""
      elseif roll <= 96 then
        category = "trainer"
        name = randomArrayValue(collectTrainerDisplayNames())
      else
        category = "jacred"
        name = "JACRED"
      end
      if name == nil then
        category = "garbage_fallback"
        name = generateJacredGarbageName()
      end
      name = clampJacredDisplayName(name)
      lastName, lastCategory = name, category
      if not jacredNameWasRecent(variant, name) then
        rememberJacredName(variant, name)
        return name, category
      end
    end

    -- The fixed-name categories can exhaust their options in a short history;
    -- an independently generated glyph name guarantees a fresh-looking exit.
    lastName, lastCategory = generateJacredGarbageName(), "garbage_repeat_fallback"
    lastName = clampJacredDisplayName(lastName)
    rememberJacredName(variant, lastName)
    return lastName, lastCategory
  end
  local pendingCrashEffect = nil
  local activeNativeCrashBattle = nil
  local pendingJacredVariant = nil

  local trainerFlyEncounterState = {
    kind = nil,
    variant = nil,
    battleActive = false,
    fakeBagEnabled = false,
    battle = nil,
  }

  local function resetTrainerFlyEncounterState()
    trainerFlyEncounterState.kind = nil
    trainerFlyEncounterState.variant = nil
    trainerFlyEncounterState.battleActive = false
    trainerFlyEncounterState.fakeBagEnabled = false
    trainerFlyEncounterState.battle = nil
  end

  local function trainerMusicKind(trainerId)
    if trainerId == "OPP_RIVAL3" then
      return "final"
    end

    if trainerId == "OPP_LANCE" then
      return "gym"
    end

    local victories = require("data.scripts.victories")
    for key, reward in pairs(victories or {}) do
      if reward.badge
         and string.find(key, tostring(trainerId) .. "#", 1, true) == 1 then
        return "gym"
      end
    end

    return "trainer"
  end

  local function startTrainerFlyBattleMusic(kind, trainerId)
    -- The original game switches to battle music before the entry wipe.
    -- Trainer-Fly's forced Start menu creates an earlier, visible boundary:
    -- begin the theme the instant that menu closes, then let pushBattle()
    -- no-op when it requests the same song again.
    if kind == "trainer" then
      Music.playBattle(
        game.data,
        trainerMusicKind(trainerId),
        trainerId
      )
    else
      Music.playBattle(game.data, "wild")
    end
  end

  local function installCrashBridgeTrainer()
    if not (game and game.data and game.data.trainers) then return false end
    if game.data.trainers[crashBridgeTrainerId] then return true end

    local base = trainerByClassIndex[1]
    local baseDef = base and base.def or {}
    game.data.trainers[crashBridgeTrainerId] = {
      id = crashBridgeTrainerId,
      index = 0xFE,
      name = "",
      baseMoney = 0,
      pic = mod.assets:path(
        "assets/native_glitch/corrupted_enemy_trainer.png"),
      parties = {
        {
          { level = 7, species = "PIDGEY" },
        },
      },
    }
    return true
  end

  local function installJacredTrainer()
    if not (game and game.data and game.data.trainers) then return false end
    if game.data.trainers[jacredTrainerId] then return true end

    -- Class zero reads live I/O bytes in Pokemon Blue. The captured $FF70
    -- record begins FF FF 00 00: variable-level format, level 255, invalid
    -- species zero, then termination. Gen1Recomp cannot instantiate species
    -- zero safely, so use the preserved MissingNo. body while retaining the
    -- observed level-255/class-zero presentation.
    local base = trainerByClassIndex[1]
    local baseDef = base and base.def or {}
    game.data.trainers[jacredTrainerId] = {
      id = jacredTrainerId,
      index = 0,
      name = "JACRED",
      baseMoney = 0,
      pic = mod.assets:path("assets/effects/jacred.png"),
      parties = {
        {
          { level = 255, species = "TF_GLITCH_031" },
        },
      },
    }
    return true
  end

  local function rebuildTrainerClassIndex()
    trainerByClassIndex = {}
    for id, def in pairs((game.data and game.data.trainers) or {}) do
      local index = def and tonumber(def.index)
      if index then
        trainerByClassIndex[index] = { id = id, def = def }
      end
    end
  end

  local function classPartiesForRawWalk(classIndex)
    -- These classes have no ROM party records. Gen1Recomp may supply a
    -- convenience override for cut content, but the original unchecked
    -- loader falls straight into the next class's bytes.
    if classIndex == 13 or classIndex == 27 then
      return {}
    end
    local entry = trainerByClassIndex[classIndex]
    return (entry and entry.def and entry.def.parties) or {}
  end

  local function rawTrainerParty(classIndex, trainerSet)
    local remaining =
      math.max(1, math.min(13, math.floor(tonumber(trainerSet) or 7)))

    -- ReadTrainer starts at the selected class pointer, then skips
    -- zero-terminated records. It never checks the next class pointer.
    for index = classIndex, 47 do
      local parties = classPartiesForRawWalk(index)
      if remaining <= #parties then
        return parties[remaining], index
      end
      remaining = remaining - #parties
    end

    -- Past Lance, the original begins parsing unrelated ROM bytes. That
    -- requires the separate out-of-table decoder; do not fabricate a team.
    return nil, nil
  end

  local function ensureTrainerParty(classIndex, trainerSet)
    local presented = trainerByClassIndex[classIndex]
    if not presented then return nil, "missing_class" end

    local key = ("%d:%d"):format(classIndex, trainerSet)
    local cached = generatedTrainerParties[key]
    if cached then return cached end

    local party, sourceClassIndex = rawTrainerParty(classIndex, trainerSet)
    if not party then return nil, "past_trainer_table" end

    -- Append to the real presented class instead of creating a fake class.
    -- This preserves the trainer's built-in name, portrait, music, AI and
    -- class-specific move behavior.
    local copied = {}
    for i, slot in ipairs(party) do
      copied[i] = {
        species = slot.species,
        level = slot.level,
        moves = slot.moves,
      }
    end

    local parties = presented.def.parties
    parties[#parties + 1] = copied
    cached = {
      trainerClass = presented.id,
      partyIndex = #parties,
      presentedClassIndex = classIndex,
      sourceClassIndex = sourceClassIndex,
      trainerSet = trainerSet,
    }
    generatedTrainerParties[key] = cached
    return cached
  end

  local function classifyUpperTrainer(special, trainerSet)
    special = tonumber(special)
    trainerSet =
      math.max(1, math.min(13, math.floor(tonumber(trainerSet) or 7)))

    if special == 200 then
      return {
        kind = "jacred",
        special = special,
        trainerSet = trainerSet,
        trainerClass = jacredTrainerId,
        partyIndex = 1,
      }
    end

    if special >= 201 and special <= 247 then
      local classIndex = special - 200
      local generated, reason = ensureTrainerParty(classIndex, trainerSet)
      if not generated then
        return {
          kind = "trainer_unstable",
          special = special,
          trainerSet = trainerSet,
          classIndex = classIndex,
          reason = reason,
        }
      end
      generated.kind = "trainer"
      generated.special = special
      return generated
    end

    if special == 248 or special == 252 or special == 254 then
      return {
        kind = "captured_crash_effect",
        special = special,
        trainerSet = trainerSet,
        effect = EncounterData.crashEffects[special],
      }
    end

    if special == 251 or special == 255 then
      return {
        kind = "zzazz_pending",
        special = special,
        trainerSet = trainerSet,
      }
    end

    if special >= 248 and special <= 255 then
      return {
        kind = "out_of_table_trainer_pending",
        special = special,
        trainerSet = trainerSet,
      }
    end

    return nil
  end

  mod.events:on("game.ready", function(ev)
    game = ev.game
    mod.log:info(
      "G1GPP timing mode: %s (%d frame window)",
      timingMode(), timingWindow())
    pokemonByIndex = {}
    rebuildTrainerClassIndex()
    installJacredTrainer()
    installCrashBridgeTrainer()
    for id, def in pairs((game.data and game.data.pokemon) or {}) do
      local index = def and tonumber(def.index)
      if index then pokemonByIndex[index] = id end
    end
    quickWarpPoint = loadQuickWarpFile()

    mod.log:info("G1GPP indexed %d internal species values",
      (function() local n = 0; for _ in pairs(pokemonByIndex) do n = n + 1 end; return n end)())

  end)

  BattleState._trainerFlyOriginalOpenItems =
    BattleState._trainerFlyOriginalOpenItems
    or BattleState.openItems

  local originalOpenItems =
    BattleState._trainerFlyOriginalOpenItems

  BattleState._trainerFlyJacredBagPatchVersion =
    "v1.1.0-beta1-jacred30.8-a-then-b-warp-hotkey"

  function BattleState:openItems()
    local trainerId =
      self.trainer and self.trainer.id or nil

    local useFakeBag =
      trainerFlyEncounterState.fakeBagEnabled
      and trainerFlyEncounterState.battleActive
      and (
        trainerId == jacredTrainerId
        or trainerFlyEncounterState.kind == "jacred"
      )

    if useFakeBag then
      trainerFlyEncounterState.battle = self
      self.phase = "messages"
      self.afterQueue = "menu"

      -- The fake Bag is now opened directly. The temporary Jacred test
      -- diagnostic has been removed; this does not change the Bag layout or
      -- any of its item behaviors.
      self.game.stack:push(PokeTrainerBagScreen.new(
        self.game,
        {
          battle = self,
          introFrames = 0,
        }
      ))

      return
    end

    -- Non-Jacred battles must fall through invisibly to the real Bag.
    -- Never expose interception diagnostics to normal gameplay.
    originalOpenItems(self)
  end

  mod.log:info(
    "Installed Jacred ITEM interception patch %s",
    tostring(BattleState._trainerFlyJacredBagPatchVersion))

  mod.hooks:wrap("player.sprite", function(next, path, ctx)
    local resolved = next(path, ctx)
    if ctx and ctx.kind == "battle" and ctx.side == "back" then
      local battle = ctx.battle
      local trainerId =
        battle and battle.trainer and battle.trainer.id or nil

      local bridge =
        (pendingCrashEffect ~= nil)
        or trainerId == crashBridgeTrainerId

      -- The player back picture is resolved before battle.started marks the
      -- individual battle. For MissingNo. inversion we deliberately keep the
      -- engine's native Trainer back path; BattleState:picImage transforms that
      -- live image with Red/Blue's measured wSpriteFlipped nibble-swap rule.
      if invertedSpriteState.active
          or (battle and battle._g1gppInvertedSprites) then
        debugLogger:log("INVERTED TRAINER SOURCE PRESERVED",
          "battle=" .. debugLogger:safeField(battle)
            .. " path=" .. debugLogger:safeField(resolved))
        return resolved
      end

      if trainerId == jacredTrainerId then
        -- JACRED and its ZZAZZ Bag variant use the exact opposite-facing copy
        -- of the validated corrupted back sprite. The two packaged images are
        -- pixel-perfect horizontal mirrors; this changes facing only.
        ctx.trueColor = false
        return mod.assets:path(
          "assets/native_glitch/corrupted_trainer_back.png")
      end

      if bridge then
        ctx.trueColor = false
        return mod.assets:path(
          "assets/native_glitch/corrupted_trainer_back.png")
      end
    end
    return resolved
  end)

  mod.events:on("player.warped", function(_ev)
    if not (escape and escape.teleported) then return end
    activeWorld = escape.world
    releaseTrainerApproach(activeWorld)
    -- Fallback for builds that emit player.warped after beginTeleportOut.
    armDebugReturnIfEnabled("player_warped")
  end)

  mod.events:on("battle.started", function(ev)
    if pendingJacredBallMessage
       and ev.trainerId ~= jacredTrainerId then
      pendingJacredBallExitBattle = nil
      pendingJacredBallMessage = false
    end

    if ev.trainerId ~= jacredTrainerId
       and trainerFlyEncounterState.kind == "jacred" then
      resetTrainerFlyEncounterState()
    end

    if pendingJacredVariant
       and ev.kind == "trainer"
       and ev.trainerId == jacredTrainerId then
      local variant = pendingJacredVariant
      pendingJacredVariant = nil

      trainerFlyEncounterState.kind = "jacred"
      trainerFlyEncounterState.variant = variant
      trainerFlyEncounterState.battleActive = true
      trainerFlyEncounterState.fakeBagEnabled =
        variant == "zzazz_bag"
      trainerFlyEncounterState.battle = ev.battle

      mod.log:warn(
        "Started Jacred variant=%s; fake Bag enabled=%s",
        tostring(variant),
        tostring(trainerFlyEncounterState.fakeBagEnabled))
    end

    -- Crash recreations enter through a real trainer battle. By the time this
    -- event fires, Gen1Recomp has already played the native overworld battle
    -- wipe and started trainer battle music. Replace the newly-created battle
    -- display with the captured corruption while retaining the battle beneath.
    if pendingCrashEffect
       and ev.kind == "trainer"
       and ev.trainerId == crashBridgeTrainerId then
      local opts = pendingCrashEffect
      pendingCrashEffect = nil
      opts.battle = ev.battle

      if opts.special == 252 then
        game.stack:push(GlitchEffectScreen.new(game, opts))
      else
        -- Keep the real BattleState visible. Its native introSlide moves the
        -- complete hooked player back pic into position, and other rendering
        -- mods see the same engine-owned sprite rather than an overlay.
        activeNativeCrashBattle = opts
        opts.battle = ev.battle
        opts.hangTonePath = mod.assets:path(
          "assets/audio/music_hang_note.wav")
        opts.battleFrames = 150
        opts.hangFrames = 75
        opts.fadeFrames = 90
        opts.whiteFrames = 180

        -- Leave the native battle state idle underneath the recovery screen.
        -- The controller owns the simulated crash, message, and safe teardown.
        ev.battle.queue = {}
        ev.battle.afterQueue = "menu"
        game.stack:push(CrashRecoveryScreen.new(game, opts))
      end

      mod.log:warn(
        "G1GPP started native crash battle Special %s",
        tostring(opts.special))
      return
    end

    if not (escape and escape.teleported and not escape.qualified) then return end
    intermediaryBattle = ev.kind == "trainer" and ev.battle or nil
    capturedSpecial = nil
    capturedAttackModifier = nil
    capturedEnemySpecies = nil
    if intermediaryBattle then captureCurrentEnemy(intermediaryBattle) end
  end)

  mod.events:on("battle.ended", function(ev)
    if pendingJacredBallMessage then
      -- The overworld-ready gate is the actual teardown confirmation.
      -- Event payloads may expose a different battle wrapper/reference, so
      -- never require object identity before allowing the message.
      pendingJacredBallExitBattle = nil
    end

    if activeNativeCrashBattle
       and ev.battle == activeNativeCrashBattle.battle then
      Sound.stopLoop("Low_Health_Alarm")
      activeNativeCrashBattle = nil
    end

    local trainerId =
      ev.battle and ev.battle.trainer and ev.battle.trainer.id or nil

    if trainerId == jacredTrainerId
       or ev.battle == trainerFlyEncounterState.battle then
      resetTrainerFlyEncounterState()
    end

    if trainerId == jacredTrainerId and ev.result == "win" then
      -- This appears only after Jacred is actually defeated. The native
      -- battle teardown completes first, then the overworld script displays
      -- the preservation warning.
      mod.world:queueScript({
        {
          "show_text",
          "JACRED ATTEMPTED TO\nCORRUPT YOUR SAVE FILE."
        },
        {
          "show_text",
          "NO PERMANENT DAMAGE\nWAS FOUND."
        },
      }, { source = mod.id, persistAcrossWarp = true })

      mod.log:info(
        "Jacred defeated; queued protected-save confirmation message")
    end
  end)

  mod.events:on("battle.turn_ended", function(ev)
    if ev.battle == intermediaryBattle then captureCurrentEnemy(ev.battle) end
  end)

  mod.events:on("battle.battler_switched", function(ev)
    if ev.battle == intermediaryBattle then captureEnemy(ev.battler) end
  end)

  mod.events:on("battle.fainted", function(ev)
    if ev.battle == intermediaryBattle then captureEnemy(ev.battler) end
  end)

  mod.events:on("battle.ended", function(ev)
    if not (escape and escape.teleported and not escape.qualified) then return end
    if ev.battle ~= intermediaryBattle then return end
    captureCurrentEnemy(ev.battle)
    if ev.result == "win" and capturedSpecial ~= nil then
      escape.qualified = true
      escape.special = capturedSpecial
      escape.attackModifier = capturedAttackModifier or 7
      escape.lastEnemySpecies = capturedEnemySpecies
      escape.resolvedEncounter =
        EncounterData.resolve(capturedSpecial, pokemonByIndex)
      mod.log:info(
        "G1GPP qualified: last=%s Special=%d AttackMod=%d kind=%s species=%s; return to %s",
        tostring(capturedEnemySpecies), capturedSpecial,
        tonumber(escape.attackModifier) or 7,
        tostring(escape.resolvedEncounter and escape.resolvedEncounter.kind),
        tostring(escape.resolvedEncounter and escape.resolvedEncounter.species),
        tostring(escape.originMap))
    end
    intermediaryBattle = nil
    capturedSpecial = nil
    capturedAttackModifier = nil
    capturedEnemySpecies = nil
  end)

  mod.events:on("map.entered", function(ev)
    if not (escape and escape.teleported) then return end
    -- Final fallback: if a build bypassed player.warped, debug mode still arms
    -- on the first map entry after Teleport.
    armDebugReturnIfEnabled("map_entered")
    if not escape.qualified then return end
    if ev.mapId == escape.originMap and not escape.returnTriggered then
      forceMenuPending = true
    end
  end)

  mod.events:on("mod.options_changed", function(ev)
    if ev and ev.mod == mod.id and ev.key == "missingno_presentation" then
      local mode = missingNoPresentationMode()
      mod.log:info("G1GPP MissingNo. presentation changed to %s", mode)
      debugLogger:log("MISSINGNO PRESENTATION CHANGED",
        "mode=" .. debugLogger:safeField(mode) .. " saveMutation=false")
    elseif ev and ev.mod == mod.id and ev.key == "timing_mode" then
      mod.log:info(
        "G1GPP timing changed to %s (%d frame window)",
        timingMode(), timingWindow())
    end
  end)

  mod.events:on("screen.popped", function(ev)
    if not forcedMenu or ev.state ~= forcedMenu then return end
    forcedMenu = nil

    -- Closing the automatically forced menu resumes the stale encounter
    -- sequence. The captured live Special value is used as the original Gen-I
    -- internal species index. Valid recomp species start a normal level-7
    -- encounter; unmapped/glitch values take a safe placeholder path for now.
    local finishedEscape = escape
    local special = finishedEscape and finishedEscape.special
    local encounter = finishedEscape and finishedEscape.resolvedEncounter
    escape = nil
    forceMenuPending = false
    activeWorld = nil

    if not encounter then
      encounter = EncounterData.resolve(special, pokemonByIndex)
    end

    local attackModifier =
      math.max(1, math.min(13,
        math.floor(tonumber(finishedEscape and finishedEscape.attackModifier)
          or 7)))
    local upper = classifyUpperTrainer(special, attackModifier)
    local battleWorld = finishedEscape and finishedEscape.world or activeWorld
    captureGlitchCityOrigin(battleWorld, "screen_popped_before_start_battle")
    debugLogger:log("BATTLE RESOLUTION", "special=" .. debugLogger:safeField(special)
      .. " attackMod=" .. debugLogger:safeField(attackModifier)
      .. " upperKind=" .. debugLogger:safeField(upper and upper.kind)
      .. " " .. playerStateSummary(battleWorld))

    if upper and upper.kind == "trainer" then
      startTrainerFlyBattleMusic("trainer", upper.trainerClass)

      mod.world:queueScript({
        { "start_battle", "trainer",
          upper.trainerClass, upper.partyIndex },
      }, { source = mod.id, persistAcrossWarp = true })

      mod.log:info(
        "G1GPP started class=%s Special=%s AttackMod=%d party=%d sourceClass=%d",
        tostring(upper.trainerClass),
        tostring(special),
        attackModifier,
        tonumber(upper.partyIndex) or -1,
        tonumber(upper.sourceClassIndex) or -1)
      return
    end

    if upper and upper.kind == "jacred" then
      local jacred = game.data.trainers[jacredTrainerId]
      local variant = (attackModifier == 5 or attackModifier == 6)
        and "zzazz_bag" or "standard"
      local displayName, nameCategory = chooseJacredDisplayName(variant)

      if jacred then
        jacred.name = displayName
      end

      resetTrainerFlyEncounterState()
      trainerFlyEncounterState.kind = "jacred"

      if variant == "zzazz_bag" then
        pendingJacredVariant = variant
        trainerFlyEncounterState.variant = variant
        trainerFlyEncounterState.fakeBagEnabled = true
      else
        pendingJacredVariant = variant
        trainerFlyEncounterState.variant = variant
      end

      startTrainerFlyBattleMusic("trainer", jacredTrainerId)

      mod.world:queueScript({
        { "start_battle", "trainer",
          upper.trainerClass, upper.partyIndex },
      }, { source = mod.id, persistAcrossWarp = true })

      mod.log:warn(
        "G1GPP started Jacred: displayName=%q category=%s AttackMod=%d variant=%s",
        tostring(displayName), tostring(nameCategory),
        attackModifier, tostring(pendingJacredVariant))
      return
    end

    if upper and upper.kind == "captured_crash_effect" then
      local opts

      if special == 248 then
        opts = {
          special = special,
          lowHealthAlarm = true,
          totalFrames = 270,
          nativeTrainerSprite = true,
        }
      elseif special == 252 then
        opts = {
          special = special,
          lowHealthAlarm = false,
          minimumFrames = 90,
          totalFrames = 180,
          rawFrames = {},
        }
      elseif special == 254 then
        opts = {
          special = special,
          lowHealthAlarm = true,
          totalFrames = 270,
          nativeTrainerSprite = true,
        }
      end

      if opts then
        pendingCrashEffect = opts
        startTrainerFlyBattleMusic("trainer", crashBridgeTrainerId)

        -- Start the alarm before start_battle is drained so it begins with
        -- the same overworld transition frame as the original crash cases.
        -- The real trainer battle starts its music during pushBattle().
        if opts.lowHealthAlarm then
          Sound.startLoop(game.data, "Low_Health_Alarm")
        else
          Sound.stopLoop("Low_Health_Alarm")
        end

        mod.world:queueScript({
          { "start_battle", "trainer", crashBridgeTrainerId, 1 },
        }, { source = mod.id, persistAcrossWarp = true })

        mod.log:warn(
          "G1GPP queued native battle bridge for Special %s",
          tostring(special))
        return
      end
    end

    if upper and upper.kind == "zzazz_pending" then
      mod.world:queueScript({
        { "show_text", "THIS COMBINATION\nTRIGGERS ZZAZZ." },
        { "show_text", "SAVE CORRUPTION IS\nBLOCKED FOR SAFETY." },
        { "show_text", "THE SAFE ZZAZZ EFFECT\nCOMES IN v1.2." },
      }, { source = mod.id, persistAcrossWarp = true })
      return
    end

    if upper and upper.kind == "out_of_table_trainer_pending" then
      mod.world:queueScript({
        { "show_text", "THIS VALUE READS A\nTRAINER POINTER OUTSIDE" },
        { "show_text", "THE NORMAL TABLE.\nDECODER PENDING." },
      }, { source = mod.id, persistAcrossWarp = true })
      return
    end

    if upper and upper.kind == "trainer_unstable" then
      mod.world:queueScript({
        { "show_text", "THE TRAINER PARTY READ\nPAST LANCE'S DATA." },
        { "show_text", "THE RECOMP STOPPED THE\nUNSAFE ROM READ." },
      }, { source = mod.id, persistAcrossWarp = true })
      return
    end

    if encounter.kind == "pokemon" and encounter.species then
      startTrainerFlyBattleMusic("wild")

      mod.world:queueScript({
        { "start_battle", "wild", encounter.species, 7 },
      }, { source = mod.id, persistAcrossWarp = true })

      mod.log:info(
        "G1GPP started level-7 %s from Special/index %s (%s)",
        tostring(encounter.species), tostring(special),
        tostring(encounter.subtype))
      return
    end

    if encounter.kind == "crash_effect" then
      local effect = encounter.effect or {}
      local script

      if effect.class == "white_failure" then
        script = {
          { "fade", "out", 2 },
          { "wait", 45 },
          { "fade", "in", 2 },
          { "show_text", effect.message or "THE BATTLE BECAME\nUNSTABLE." },
          { "show_text", "THE RECOMP RETURNED\nYOU SAFELY." },
        }
      elseif effect.class == "persistent_corruption" then
        script = {
          { "fade", "out", 3 },
          { "fade", "in", 1 },
          { "fade", "out", 1 },
          { "fade", "in", 1 },
          { "wait", 90 },
          { "show_text", effect.message or "THE BATTLE BECAME\nUNSTABLE." },
          { "show_text", "THE RECOMP RETURNED\nYOU SAFELY." },
        }
      elseif effect.class == "corruption_then_blank" then
        script = {
          { "fade", "out", 3 },
          { "fade", "in", 1 },
          { "fade", "out", 1 },
          { "wait", 90 },
          { "fade", "in", 3 },
          { "show_text", effect.message or "THE BATTLE BECAME\nUNSTABLE." },
          { "show_text", "THE RECOMP RETURNED\nYOU SAFELY." },
        }
      else
        script = {
          { "fade", "out", 4 },
          { "wait", 90 },
          { "fade", "in", 4 },
          { "show_text", effect.message or "THE BATTLE COULD NOT\nFINISH FORMING." },
          { "show_text", "THE RECOMP RETURNED\nYOU SAFELY." },
        }
      end

      mod.world:queueScript(
        script,
        { source = mod.id, persistAcrossWarp = true }
      )
      mod.log:warn(
        "G1GPP safely reproduced crash class %s for Special/index %s",
        tostring(effect.class), tostring(special))
      return
    end

    if encounter.kind == "upper_pending" then
      mod.world:queueScript({
        { "show_text", "THIS SPECIAL VALUE\nBECOMES A GLITCH TRAINER." },
        { "show_text", "TRAINER SUPPORT IS\nBEING ADDED NEXT." },
        { "show_text", "SPECIAL INDEX " .. tostring(special or "?") .. "." },
      }, { source = mod.id, persistAcrossWarp = true })
      mod.log:warn(
        "G1GPP deferred upper-range trainer/index %s",
        tostring(special))
      return
    end

    mod.world:queueScript({
      { "show_text", "THE ENCOUNTER DATA\nBECAME UNSTABLE!" },
      { "show_text", "SPECIAL INDEX " .. tostring(special or "?") ..
                     " HAS NO SAFE\nRESULT YET." },
    }, { source = mod.id, persistAcrossWarp = true })
    mod.log:warn(
      "G1GPP safely rejected unresolved Special/index %s",
      tostring(special))

  end)

  mod.log:info("G1GPP v%s loaded", mod.version)
end
