-- Generated from the authoritative G1GPP workbook and retained private research.
-- Facts and reconstruction paths only: no ROM bytes, captured pixels, saves, or audio.
return function(ctx)
  local mod = assert(ctx and ctx.mod, 'full roster needs mod')
  local encounterData = assert(ctx.encounterData, 'full roster needs encounter resolver')
  local logger = assert(ctx.logger, 'full roster needs logger')
  local Pokemon = require("src.pokemon.Pokemon")
  local SummaryMenu = require("src.ui.SummaryMenu")
  local DexEntryMenu = require("src.ui.DexEntryMenu")
  local PokedexMenu = require("src.ui.PokedexMenu")
  local M = {}
  mod.content.text:register('_G1GPPFullRosterBlankDex', '\n')
  mod.content.text:register('_G1GPPDex000Corrupt',
    '<G000_06><G000_07><G000_08><G000_09>\n<G000_02><G000_04><G000_01><G000_05>')
  mod.content.text:register('_G1GPPDex191CorruptA',
    '<G191_01><G191_03><G191_05><G191_07>\n<G191_02><G191_04><G191_06><G191_08>')
  mod.content.text:register('_G1GPPDex191CorruptB',
    '<G191_08><G191_06><G191_04><G191_02>\n<G191_07><G191_05><G191_03><G191_01>')
  mod.content.text:register('_G1GPPDex191CorruptC',
    '<G191_02><G191_05><G191_08><G191_03>\n<G191_06><G191_01><G191_07><G191_04>')

  mod.content.type_chart:register("TF_TYPE_2B", { name="0x2B", category='physical', index=0x2B })
  mod.content.type_chart:register("TF_TYPE_50", { name="0x50", category='physical', index=0x50 })
  mod.content.type_chart:register("TF_TYPE_80", { name="0x80", category='physical', index=0x80 })
  mod.content.type_chart:register("TF_TYPE_82", { name="0x82", category='physical', index=0x82 })
  mod.content.type_chart:register("TF_TYPE_88", { name="0x88", category='physical', index=0x88 })
  mod.content.type_chart:register("TF_TYPE_A9", { name="0xA9", category='physical', index=0xA9 })
  mod.content.type_chart:register("TF_TYPE_C8", { name="0xC8", category='physical', index=0xC8 })
  mod.content.moves:register("TF_MOVE_A9", { id="TF_MOVE_A9", index=0xA9, name="SUPER GLITCH", type='NORMAL', power=0, accuracy=100, pp=1, effect='SPLASH_EFFECT' })
  mod.content.moves:register("TF_MOVE_BE", { id="TF_MOVE_BE", index=0xBE, name="SUPER GLITCH", type='NORMAL', power=0, accuracy=100, pp=1, effect='SPLASH_EFFECT' })
  mod.content.moves:register("TF_MOVE_BE_194", { id="TF_MOVE_BE_194", index=0xBE, name="GLITCH BE", type='NORMAL', power=0, accuracy=100, pp=11, effect='SPLASH_EFFECT' })
  mod.content.moves:register("TF_MOVE_CD", { id="TF_MOVE_CD", index=0xCD, name="TM05", type='NORMAL', power=0, accuracy=100, pp=1, effect='SPLASH_EFFECT' })
  mod.content.moves:register("TF_MOVE_E4", { id="TF_MOVE_E4", index=0xE4, name="TM28", type='NORMAL', power=0, accuracy=100, pp=1, effect='SPLASH_EFFECT' })
  mod.content.moves:register("TF_MOVE_E4_194", { id="TF_MOVE_E4_194", index=0xE4, name="GLITCH E4", type='NORMAL', power=0, accuracy=100, pp=54, effect='SPLASH_EFFECT' })
  mod.content.moves:register("TF_MOVE_EF", { id="TF_MOVE_EF", index=0xEF, name="TM39", type='NORMAL', power=0, accuracy=100, pp=1, effect='SPLASH_EFFECT' })
  mod.content.moves:register("TF_MOVE_00_214", { id="TF_MOVE_00_214", index=0x00, name="--", type='NORMAL', power=0, accuracy=100, pp=13, effect='SPLASH_EFFECT' })

  local mons = {
    {
      id="TF_GLITCH_000", index=0, isNew=true,
      researchIdentity="'M (00)", name="<G000_01><G000_02><G000_03><G000_04><G000_05><G000_06><G000_07><G000_08><G000_09>", nameCells=9,
      dex=152, capturedDex=250, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 33, 137, 1, 6, 29 }, rawStats={ 33, 137, 0, 6, 29 },
      types={ "BIRD", "NORMAL" }, catch=29, baseExp=143, growth="MEDIUM_FAST",
      moves={ "WATER_GUN", "WATER_GUN", "SKY_ATTACK" }, tmhm={ "MEGA_PUNCH", "RAZOR_WIND", "SWORDS_DANCE", "MEGA_KICK", "TOXIC", "TAKE_DOWN", "DOUBLE_EDGE", "BUBBLEBEAM", "ICE_BEAM", "BLIZZARD", "SUBMISSION", "SEISMIC_TOSS", "RAGE", "THUNDER", "EARTHQUAKE", "FISSURE", "PSYCHIC_M", "TELEPORT", "SKY_ATTACK", "REST", "THUNDER_WAVE", "TRI_ATTACK", "CUT", "FLY" }, frontSize=7,
    },
    {
      id="TF_GLITCH_191", index=191, isNew=true,
      researchIdentity="▶ A", name="<G191_01><G191_02><G191_03><G191_04><G191_05><G191_06><G191_07><G191_08><G191_09>", nameCells=9,
      dex=152, capturedDex=250, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 37, 1, 40, 178, 19 }, rawStats={ 37, 0, 40, 178, 19 },
      types={ "TF_TYPE_0B", "NORMAL" }, catch=23, baseExp=17, growth="MEDIUM_FAST",
      moves={ "GUILLOTINE", "RAZOR_WIND", "PAY_DAY" }, tmhm={ "BUBBLEBEAM", "ICE_BEAM", "COUNTER", "SEISMIC_TOSS", "THUNDER", "EARTHQUAKE", "FISSURE", "PSYCHIC_M", "TELEPORT", "BIDE", "METRONOME", "SOFTBOILED", "SKY_ATTACK", "REST", "PSYWAVE", "ROCK_SLIDE" }, frontSize=2,
    },
    {
      id="TF_GLITCH_192_A", index=192, isNew=false,
      researchIdentity="a", name="<G192_01><G192_02>", nameCells=2,
      dex=61, capturedDex=61, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 65, 65, 65, 90, 50 }, rawStats={ 65, 65, 65, 90, 50 },
      types={ "WATER" }, catch=120, baseExp=131, growth="MEDIUM_SLOW",
      moves={ "BUBBLE", "HYPNOSIS", "WATER_GUN" }, tmhm={ "MEGA_PUNCH", "MEGA_KICK", "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "BUBBLEBEAM", "WATER_GUN", "ICE_BEAM", "BLIZZARD", "SUBMISSION", "COUNTER", "SEISMIC_TOSS", "RAGE", "EARTHQUAKE", "FISSURE", "PSYCHIC_M", "MIMIC", "DOUBLE_TEAM", "BIDE", "METRONOME", "SKULL_BASH", "REST", "PSYWAVE", "SUBSTITUTE", "SURF", "STRENGTH" }, frontSize=6,
    },
    {
      id="TF_GLITCH_194", index=194, isNew=true,
      researchIdentity="ゥ .4", name="<G194_01><G194_02><G194_03><G194_04><G194_05><G194_06><G194_07><G194_08>", nameCells=8,
      dex=152, capturedDex=234, stateDependentDex=false,
      heightFt=216, heightIn=9, rawHeightFt=209, rawHeightIn=93, weight=21501,
      stats={ 179, 96, 209, 96, 21 }, rawStats={ 179, 96, 209, 96, 21 },
      types={ "TF_TYPE_61", "TF_TYPE_27" }, catch=97, baseExp=48, growth="MEDIUM_FAST",
      moves={ "TF_MOVE_BE_194", "AGILITY", "TF_MOVE_E4_194", "AGILITY" }, tmhm={ "RAZOR_WIND", "TOXIC", "HORN_DRILL", "TAKE_DOWN", "HYPER_BEAM", "COUNTER", "SOLARBEAM", "DRAGON_RAGE", "THUNDER", "MIMIC", "BIDE", "FIRE_BLAST", "SWIFT", "DREAM_EATER", "SKY_ATTACK", "REST", "THUNDER_WAVE", "PSYWAVE", "EXPLOSION", "SUBSTITUTE", "STRENGTH", "FLASH" }, frontSize=6,
    },
    {
      id="TF_GLITCH_195", index=195, isNew=true,
      researchIdentity="h POKé", name="<G195_01><G195_02><G195_03><G195_04><G195_05><G195_06><G195_07><G195_08><G195_09><G195_10><G195_11>", nameCells=11,
      dex=94, capturedDex=94, stateDependentDex=false,
      heightFt=80, heightIn=3, rawHeightFt=80, rawHeightIn=3, weight=60990, dexKind='...',
      stats={ 60, 65, 60, 110, 130 }, rawStats={ 60, 65, 60, 110, 130 },
      types={ "GHOST", "POISON" }, catch=45, baseExp=190, growth="MEDIUM_SLOW",
      moves={ "LICK", "CONFUSE_RAY", "NIGHT_SHADE" }, tmhm={ "MEGA_PUNCH", "MEGA_KICK", "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "HYPER_BEAM", "SUBMISSION", "COUNTER", "SEISMIC_TOSS", "RAGE", "MEGA_DRAIN", "THUNDERBOLT", "THUNDER", "PSYCHIC_M", "MIMIC", "DOUBLE_TEAM", "BIDE", "METRONOME", "SELFDESTRUCT", "SKULL_BASH", "DREAM_EATER", "REST", "PSYWAVE", "EXPLOSION", "SUBSTITUTE", "STRENGTH" }, frontSize=6,
    },
    {
      id="TF_GLITCH_197_C5", index=197, isNew=false,
      researchIdentity="State-dependent raw glyph stream (C5)", name="<G197_01><G197_02><G197_03><G197_04>", nameCells=4,
      dex=152, capturedDex=250, stateDependentDex=false,
      heightFt=209, heightIn=9, rawHeightFt=205, rawHeightIn=57, weight=44855,
      stats={ 37, 1, 40, 178, 19 }, rawStats={ 37, 0, 40, 178, 19 },
      types={ "TF_TYPE_0B", "NORMAL" }, catch=23, baseExp=17, growth="MEDIUM_FAST",
      moves={ "GUILLOTINE", "RAZOR_WIND", "PAY_DAY" }, tmhm={ "BUBBLEBEAM", "ICE_BEAM", "COUNTER", "SEISMIC_TOSS", "THUNDER", "EARTHQUAKE", "FISSURE", "PSYCHIC_M", "TELEPORT", "BIDE", "METRONOME", "SOFTBOILED", "SKY_ATTACK", "REST", "PSYWAVE", "ROCK_SLIDE" }, frontSize=2,
    },
    {
      id="TF_GLITCH_198", index=198, isNew=true,
      researchIdentity="ゥL ゥM 4", name="<G198_01><G198_02><G198_03><G198_04><G198_05><G198_06><G198_07><G198_08><G198_09>", nameCells=9,
      dex=62, capturedDex=62, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 90, 85, 95, 70, 70 }, rawStats={ 90, 85, 95, 70, 70 },
      types={ "WATER", "FIGHTING" }, catch=45, baseExp=185, growth="MEDIUM_SLOW",
      moves={ "HYPNOSIS", "WATER_GUN", "DOUBLESLAP", "BODY_SLAM" }, tmhm={ "MEGA_PUNCH", "MEGA_KICK", "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "BUBBLEBEAM", "WATER_GUN", "ICE_BEAM", "BLIZZARD", "HYPER_BEAM", "SUBMISSION", "COUNTER", "SEISMIC_TOSS", "RAGE", "EARTHQUAKE", "FISSURE", "PSYCHIC_M", "MIMIC", "DOUBLE_TEAM", "BIDE", "METRONOME", "SKULL_BASH", "REST", "PSYWAVE", "SUBSTITUTE", "SURF", "STRENGTH" }, frontSize=7,
    },
    {
      id="TF_OOB_200", index=200, isNew=false,
      researchIdentity="ゥU?", name="<G200_01><G200_02><G200_03><G200_04><G200_05><G200_06><G200_07><G200_08>", nameCells=8,
      dex=152, capturedDex=234, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 179, 96, 209, 96, 21 }, rawStats={ 179, 96, 209, 96, 21 },
      types={ "TF_TYPE_61", "TF_TYPE_27" }, catch=97, baseExp=48, growth="MEDIUM_FAST",
      moves={ "TF_MOVE_BE", "AGILITY", "TF_MOVE_E4", "AGILITY" }, tmhm={ "RAZOR_WIND", "TOXIC", "HORN_DRILL", "TAKE_DOWN", "HYPER_BEAM", "COUNTER", "SOLARBEAM", "DRAGON_RAGE", "THUNDER", "MIMIC", "BIDE", "FIRE_BLAST", "SWIFT", "DREAM_EATER", "SKY_ATTACK", "REST", "THUNDER_WAVE", "PSYWAVE", "EXPLOSION", "SUBSTITUTE", "STRENGTH", "FLASH" }, frontSize=6,
    },
    {
      id="TF_GLITCH_201", index=201, isNew=true,
      researchIdentity="◣ゥ 8", name="<G201_01><G201_02><G201_03><G201_04><G201_05><G201_06><G201_07><G201_08><G201_09><G201_10>", nameCells=10,
      dex=95, capturedDex=95, stateDependentDex=false,
      heightFt=23, heightIn=0, rawHeightFt=195, rawHeightIn=57, weight=8806,
      stats={ 35, 45, 160, 70, 30 }, rawStats={ 35, 45, 160, 70, 30 },
      types={ "ROCK", "GROUND" }, catch=45, baseExp=108, growth="MEDIUM_FAST",
      moves={ "TACKLE", "SCREECH" }, tmhm={ "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "RAGE", "EARTHQUAKE", "FISSURE", "DIG", "MIMIC", "DOUBLE_TEAM", "BIDE", "SELFDESTRUCT", "SKULL_BASH", "REST", "EXPLOSION", "ROCK_SLIDE", "SUBSTITUTE", "STRENGTH" }, frontSize=7,
    },
    {
      id="TF_GLITCH_203", index=203, isNew=true,
      researchIdentity="p", name="<G203_01><G203_02><G203_03><G203_04>", nameCells=4,
      dex=17, capturedDex=17, stateDependentDex=false,
      heightFt=80, heightIn=3, rawHeightFt=80, rawHeightIn=3, weight=60990,
      stats={ 63, 60, 55, 71, 50 }, rawStats={ 63, 60, 55, 71, 50 },
      types={ "NORMAL", "FLYING" }, catch=120, baseExp=113, growth="MEDIUM_SLOW",
      moves={ "GUST", "SAND_ATTACK" }, tmhm={ "RAZOR_WIND", "WHIRLWIND", "TOXIC", "TAKE_DOWN", "DOUBLE_EDGE", "RAGE", "MIMIC", "DOUBLE_TEAM", "REFLECT", "BIDE", "SWIFT", "SKY_ATTACK", "REST", "SUBSTITUTE", "FLY" }, frontSize=6,
    },
    {
      id="TF_GLITCH_204", index=204, isNew=true,
      researchIdentity="PKMN ◣ n", name="<G204_01><G204_02><G204_03><G204_04><G204_05><G204_06><G204_07><G204_08><G204_09><G204_10><G204_11>", nameCells=11,
      dex=56, capturedDex=56, stateDependentDex=false,
      heightFt=52, heightIn=0, rawHeightFt=32, rawHeightIn=240, weight=57440,
      stats={ 40, 80, 35, 70, 35 }, rawStats={ 40, 80, 35, 70, 35 },
      types={ "FIGHTING" }, catch=190, baseExp=74, growth="MEDIUM_FAST",
      moves={ "SCRATCH", "LEER" }, tmhm={ "MEGA_PUNCH", "MEGA_KICK", "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "PAY_DAY", "SUBMISSION", "COUNTER", "SEISMIC_TOSS", "RAGE", "THUNDERBOLT", "THUNDER", "DIG", "MIMIC", "DOUBLE_TEAM", "BIDE", "METRONOME", "SWIFT", "SKULL_BASH", "REST", "ROCK_SLIDE", "SUBSTITUTE", "STRENGTH" }, frontSize=5,
    },
    {
      id="TF_GLITCH_205", index=205, isNew=true,
      researchIdentity="Trainer", name="<G205_01><G205_02><G205_03><G205_04><G205_05><G205_06><G205_07>", nameCells=7,
      dex=81, capturedDex=81, stateDependentDex=false,
      heightFt=209, heightIn=9, rawHeightFt=205, rawHeightIn=57, weight=44855,
      stats={ 25, 35, 70, 45, 95 }, rawStats={ 25, 35, 70, 45, 95 },
      types={ "ELECTRIC" }, catch=190, baseExp=89, growth="MEDIUM_FAST",
      moves={ "TACKLE" }, tmhm={ "TOXIC", "TAKE_DOWN", "DOUBLE_EDGE", "RAGE", "THUNDERBOLT", "THUNDER", "TELEPORT", "MIMIC", "DOUBLE_TEAM", "REFLECT", "BIDE", "SWIFT", "REST", "THUNDER_WAVE", "SUBSTITUTE", "FLASH" }, frontSize=5,
    },
    {
      id="TF_GLITCH_206", index=206, isNew=true,
      researchIdentity="▼ W G d", name="<G206_01><G206_02><G206_03><G206_04><G206_05><G206_06><G206_07><G206_08>", nameCells=8,
      dex=24, capturedDex=24, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 60, 85, 69, 80, 65 }, rawStats={ 60, 85, 69, 80, 65 },
      types={ "POISON" }, catch=90, baseExp=147, growth="MEDIUM_FAST",
      moves={ "WRAP", "LEER", "POISON_STING" }, tmhm={ "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "HYPER_BEAM", "RAGE", "MEGA_DRAIN", "EARTHQUAKE", "FISSURE", "DIG", "MIMIC", "DOUBLE_TEAM", "BIDE", "SKULL_BASH", "REST", "ROCK_SLIDE", "SUBSTITUTE", "STRENGTH" }, frontSize=7,
    },
    {
      id="TF_GLITCH_207", index=207, isNew=true,
      researchIdentity="OPKMN4X", name="<G207_01><G207_02><G207_03><G207_04><G207_05><G207_06><G207_07><G207_08><G207_09><G207_10><G207_11>", nameCells=11,
      dex=15, capturedDex=15, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 65, 80, 40, 75, 45 }, rawStats={ 65, 80, 40, 75, 45 },
      types={ "BUG", "POISON" }, catch=45, baseExp=159, growth="MEDIUM_FAST",
      moves={ "FURY_ATTACK" }, tmhm={ "SWORDS_DANCE", "TOXIC", "TAKE_DOWN", "DOUBLE_EDGE", "HYPER_BEAM", "RAGE", "MEGA_DRAIN", "MIMIC", "DOUBLE_TEAM", "REFLECT", "BIDE", "SWIFT", "SKULL_BASH", "REST", "SUBSTITUTE", "CUT" }, frontSize=7,
    },
    {
      id="TF_OOB_208", index=208, isNew=false,
      researchIdentity="PKMN PKMN T", name="<G208_01><G208_02><G208_03><G208_04><G208_05><G208_06><G208_07><G208_08><G208_09><G208_10>", nameCells=10,
      dex=152, capturedDex=250, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 37, 1, 40, 178, 19 }, rawStats={ 37, 0, 40, 178, 19 },
      types={ "TF_TYPE_0B", "NORMAL" }, catch=23, baseExp=17, growth="MEDIUM_FAST",
      moves={ "GUILLOTINE", "RAZOR_WIND", "PAY_DAY" }, tmhm={ "BUBBLEBEAM", "ICE_BEAM", "COUNTER", "SEISMIC_TOSS", "THUNDER", "EARTHQUAKE", "FISSURE", "PSYCHIC_M", "TELEPORT", "BIDE", "METRONOME", "SOFTBOILED", "SKY_ATTACK", "REST", "PSYWAVE", "ROCK_SLIDE" }, frontSize=2,
    },
    {
      id="TF_GLITCH_209", index=209, isNew=true,
      researchIdentity="4B 8 4 8", name="<G209_01><G209_02><G209_03><G209_04><G209_05><G209_06><G209_07><G209_08><G209_09><G209_10>", nameCells=10,
      dex=62, capturedDex=62, stateDependentDex=false,
      heightFt=23, heightIn=0, rawHeightFt=65, rawHeightIn=85, weight=8806,
      stats={ 90, 85, 95, 70, 70 }, rawStats={ 90, 85, 95, 70, 70 },
      types={ "WATER", "FIGHTING" }, catch=45, baseExp=185, growth="MEDIUM_SLOW",
      moves={ "HYPNOSIS", "WATER_GUN", "DOUBLESLAP", "BODY_SLAM" }, tmhm={ "MEGA_PUNCH", "MEGA_KICK", "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "BUBBLEBEAM", "WATER_GUN", "ICE_BEAM", "BLIZZARD", "HYPER_BEAM", "SUBMISSION", "COUNTER", "SEISMIC_TOSS", "RAGE", "EARTHQUAKE", "FISSURE", "PSYCHIC_M", "MIMIC", "DOUBLE_TEAM", "BIDE", "METRONOME", "SKULL_BASH", "REST", "PSYWAVE", "SUBSTITUTE", "SURF", "STRENGTH" }, frontSize=7,
    },
    {
      id="TF_GLITCH_211", index=211, isNew=true,
      researchIdentity="M p'u ゥ", name="<G211_01><G211_02><G211_03><G211_04><G211_05><G211_06><G211_07><G211_08><G211_09><G211_10>", nameCells=10,
      dex=152, capturedDex=234, stateDependentDex=false,
      heightFt=199, heightIn=9, rawHeightFt=195, rawHeightIn=57, weight=8503,
      stats={ 187, 105, 217, 104, 29 }, rawStats={ 187, 105, 217, 104, 29 },
      types={ "TF_TYPE_61", "TF_TYPE_27" }, catch=97, baseExp=48, growth="MEDIUM_FAST",
      moves={ "TF_MOVE_BE", "AGILITY", "TF_MOVE_E4", "AGILITY" }, tmhm={ "RAZOR_WIND", "TOXIC", "HORN_DRILL", "TAKE_DOWN", "HYPER_BEAM", "COUNTER", "SOLARBEAM", "DRAGON_RAGE", "THUNDER", "MIMIC", "BIDE", "FIRE_BLAST", "SWIFT", "DREAM_EATER", "SKY_ATTACK", "REST", "THUNDER_WAVE", "PSYWAVE", "EXPLOSION", "SUBSTITUTE", "STRENGTH", "FLASH" }, frontSize=6,
    },
    {
      id="TF_GLITCH_212", index=212, isNew=true,
      researchIdentity="Aゥ G", name="<G212_01><G212_02><G212_03><G212_04><G212_05><G212_06><G212_07><G212_08><G212_09>", nameCells=9,
      dex=94, capturedDex=94, stateDependentDex=false,
      heightFt=22, heightIn=0, rawHeightFt=22, rawHeightIn=0, weight=6,
      stats={ 60, 65, 60, 110, 130 }, rawStats={ 60, 65, 60, 110, 130 },
      types={ "GHOST", "POISON" }, catch=45, baseExp=190, growth="MEDIUM_SLOW",
      moves={ "LICK", "CONFUSE_RAY", "NIGHT_SHADE" }, tmhm={ "MEGA_PUNCH", "MEGA_KICK", "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "HYPER_BEAM", "SUBMISSION", "COUNTER", "SEISMIC_TOSS", "RAGE", "MEGA_DRAIN", "THUNDERBOLT", "THUNDER", "PSYCHIC_M", "MIMIC", "DOUBLE_TEAM", "BIDE", "METRONOME", "SELFDESTRUCT", "SKULL_BASH", "DREAM_EATER", "REST", "PSYWAVE", "EXPLOSION", "SUBSTITUTE", "STRENGTH" }, frontSize=6,
    },
    {
      id="TF_GLITCH_214", index=214, isNew=true,
      researchIdentity="4 h", name="<G214_01><G214_02><G214_03><G214_04><G214_05><G214_06><G214_07><G214_08><G214_09><G214_10>", nameCells=10,
      dex=152, capturedDex=250, stateDependentDex=false,
      heightFt=23, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=8806,
      stats={ 37, 1, 40, 178, 19 }, rawStats={ 37, 0, 40, 178, 19 },
      types={ "TF_TYPE_0B", "NORMAL" }, catch=23, baseExp=17, growth="MEDIUM_FAST",
      moves={ "TF_MOVE_00_214", "GUILLOTINE", "RAZOR_WIND", "PAY_DAY" }, tmhm={ "BUBBLEBEAM", "ICE_BEAM", "COUNTER", "SEISMIC_TOSS", "THUNDER", "EARTHQUAKE", "FISSURE", "PSYCHIC_M", "TELEPORT", "BIDE", "METRONOME", "SOFTBOILED", "SKY_ATTACK", "REST", "PSYWAVE", "ROCK_SLIDE" }, frontSize=2,
    },
    {
      id="TF_GLITCH_215", index=215, isNew=true,
      researchIdentity="Glitch (D7)", name="<G215_01><G215_02>", nameCells=2,
      dex=61, capturedDex=61, stateDependentDex=false,
      heightFt=209, heightIn=9, rawHeightFt=205, rawHeightIn=57, weight=44855,
      stats={ 65, 65, 65, 90, 50 }, rawStats={ 65, 65, 65, 90, 50 },
      types={ "WATER" }, catch=120, baseExp=131, growth="MEDIUM_SLOW",
      moves={ "BUBBLE", "HYPNOSIS", "WATER_GUN" }, tmhm={ "MEGA_PUNCH", "MEGA_KICK", "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "BUBBLEBEAM", "WATER_GUN", "ICE_BEAM", "BLIZZARD", "SUBMISSION", "COUNTER", "SEISMIC_TOSS", "RAGE", "EARTHQUAKE", "FISSURE", "PSYCHIC_M", "MIMIC", "DOUBLE_TEAM", "BIDE", "METRONOME", "SKULL_BASH", "REST", "PSYWAVE", "SUBSTITUTE", "SURF", "STRENGTH" }, frontSize=6,
    },
    {
      id="TF_GLITCH_217", index=217, isNew=true,
      researchIdentity="PKMNRPKMN \"", name="<G217_01><G217_02><G217_03><G217_04><G217_05><G217_06><G217_07><G217_08>", nameCells=8,
      dex=152, capturedDex=234, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 179, 96, 209, 96, 21 }, rawStats={ 179, 96, 209, 96, 21 },
      types={ "TF_TYPE_61", "TF_TYPE_27" }, catch=97, baseExp=48, growth="MEDIUM_FAST",
      moves={ "TF_MOVE_BE", "AGILITY", "TF_MOVE_E4", "AGILITY" }, tmhm={ "RAZOR_WIND", "TOXIC", "HORN_DRILL", "TAKE_DOWN", "HYPER_BEAM", "COUNTER", "SOLARBEAM", "DRAGON_RAGE", "THUNDER", "MIMIC", "BIDE", "FIRE_BLAST", "SWIFT", "DREAM_EATER", "SKY_ATTACK", "REST", "THUNDER_WAVE", "PSYWAVE", "EXPLOSION", "SUBSTITUTE", "STRENGTH", "FLASH" }, frontSize=6,
    },
    {
      id="TF_GLITCH_218", index=218, isNew=true,
      researchIdentity="B (DA)", name="<G218_01><G218_02>", nameCells=2,
      dex=95, capturedDex=95, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 35, 45, 160, 70, 30 }, rawStats={ 35, 45, 160, 70, 30 },
      types={ "ROCK", "GROUND" }, catch=45, baseExp=108, growth="MEDIUM_FAST",
      moves={ "TACKLE", "SCREECH" }, tmhm={ "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "RAGE", "EARTHQUAKE", "FISSURE", "DIG", "MIMIC", "DOUBLE_TEAM", "BIDE", "SELFDESTRUCT", "SKULL_BASH", "REST", "EXPLOSION", "ROCK_SLIDE", "SUBSTITUTE", "STRENGTH" }, frontSize=7,
    },
    {
      id="TF_GLITCH_220", index=220, isNew=true,
      researchIdentity="Glitch (DC)", name="<G220_01><G220_02>", nameCells=2,
      dex=17, capturedDex=17, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 63, 60, 55, 71, 50 }, rawStats={ 63, 60, 55, 71, 50 },
      types={ "NORMAL", "FLYING" }, catch=120, baseExp=113, growth="MEDIUM_SLOW",
      moves={ "GUST", "SAND_ATTACK" }, tmhm={ "RAZOR_WIND", "WHIRLWIND", "TOXIC", "TAKE_DOWN", "DOUBLE_EDGE", "RAGE", "MIMIC", "DOUBLE_TEAM", "REFLECT", "BIDE", "SWIFT", "SKY_ATTACK", "REST", "SUBSTITUTE", "FLY" }, frontSize=6,
    },
    {
      id="TF_GLITCH_221", index=221, isNew=true,
      researchIdentity="7PKMN 'v", name="<G221_01><G221_02><G221_03><G221_04><G221_05><G221_06><G221_07><G221_08><G221_09>", nameCells=9,
      dex=73, capturedDex=73, stateDependentDex=false,
      heightFt=23, heightIn=0, rawHeightFt=23, rawHeightIn=0, weight=8806,
      stats={ 80, 70, 65, 100, 120 }, rawStats={ 80, 70, 65, 100, 120 },
      types={ "WATER", "POISON" }, catch=60, baseExp=205, growth="SLOW",
      moves={ "ACID", "SUPERSONIC", "WRAP" }, tmhm={ "SWORDS_DANCE", "TOXIC", "TAKE_DOWN", "DOUBLE_EDGE", "BUBBLEBEAM", "WATER_GUN", "ICE_BEAM", "BLIZZARD", "HYPER_BEAM", "RAGE", "MEGA_DRAIN", "MIMIC", "DOUBLE_TEAM", "REFLECT", "BIDE", "SKULL_BASH", "REST", "SUBSTITUTE", "CUT", "SURF" }, frontSize=6,
    },
    {
      id="TF_GLITCH_222", index=222, isNew=true,
      researchIdentity="-PKMN", name="<G222_01><G222_02><G222_03><G222_04><G222_05><G222_06><G222_07><G222_08><G222_09><G222_10>", nameCells=10,
      dex=81, capturedDex=81, stateDependentDex=false,
      heightFt=60, heightIn=33, rawHeightFt=205, rawHeightIn=249, weight=54007,
      stats={ 25, 35, 70, 45, 95 }, rawStats={ 25, 35, 70, 45, 95 },
      types={ "ELECTRIC" }, catch=190, baseExp=89, growth="MEDIUM_FAST",
      moves={ "TACKLE" }, tmhm={ "TOXIC", "TAKE_DOWN", "DOUBLE_EDGE", "RAGE", "THUNDERBOLT", "THUNDER", "TELEPORT", "MIMIC", "DOUBLE_TEAM", "REFLECT", "BIDE", "SWIFT", "REST", "THUNDER_WAVE", "SUBSTITUTE", "FLASH" }, frontSize=5,
    },
    {
      id="TF_GLITCH_223", index=223, isNew=true,
      researchIdentity=".PKMN", name="<G223_01><G223_02><G223_03><G223_04><G223_05><G223_06><G223_07><G223_08><G223_09><G223_10>", nameCells=10,
      dex=152, capturedDex=250, stateDependentDex=false,
      heightFt=10, heightIn=7, rawHeightFt=2, rawHeightIn=103, weight=26220,
      stats={ 37, 1, 40, 178, 19 }, rawStats={ 37, 0, 40, 178, 19 },
      types={ "TF_TYPE_0B", "NORMAL" }, catch=23, baseExp=17, growth="MEDIUM_FAST",
      moves={ "GUILLOTINE", "RAZOR_WIND", "PAY_DAY" }, tmhm={ "BUBBLEBEAM", "ICE_BEAM", "COUNTER", "SEISMIC_TOSS", "THUNDER", "EARTHQUAKE", "FISSURE", "PSYCHIC_M", "TELEPORT", "BIDE", "METRONOME", "SOFTBOILED", "SKY_ATTACK", "REST", "PSYWAVE", "ROCK_SLIDE" }, frontSize=2,
    },
    {
      id="TF_GLITCH_224", index=224, isNew=true,
      researchIdentity="/PKMN ▼PKMN", name="<G224_01><G224_02><G224_03><G224_04><G224_05><G224_06><G224_07><G224_08><G224_09><G224_10><G224_11>", nameCells=11,
      dex=85, capturedDex=85, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 60, 110, 70, 100, 60 }, rawStats={ 60, 110, 70, 100, 60 },
      types={ "NORMAL", "FLYING" }, catch=45, baseExp=158, growth="MEDIUM_FAST",
      moves={ "PECK", "GROWL", "FURY_ATTACK" }, tmhm={ "WHIRLWIND", "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "HYPER_BEAM", "RAGE", "MIMIC", "DOUBLE_TEAM", "REFLECT", "BIDE", "SKULL_BASH", "SKY_ATTACK", "REST", "TRI_ATTACK", "SUBSTITUTE", "FLY" }, frontSize=7,
    },
    {
      id="TF_GLITCH_227", index=227, isNew=true,
      researchIdentity="ゥ (E3)", name="<G227_01>", nameCells=1,
      dex=152, capturedDex=240, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 19, 114, 114, 1, 20 }, rawStats={ 19, 114, 114, 0, 20 },
      types={ "TF_TYPE_7B", "TF_TYPE_70" }, catch=65, baseExp=0, growth="MEDIUM_FAST",
      moves={ "STRUGGLE", "DOUBLESLAP", "SWORDS_DANCE" }, tmhm={ "TAKE_DOWN", "DOUBLE_EDGE", "BUBBLEBEAM", "WATER_GUN", "ICE_BEAM", "SUBMISSION", "SEISMIC_TOSS", "RAGE", "SOLARBEAM", "DRAGON_RAGE", "THUNDER", "FISSURE", "DIG", "TELEPORT", "MIMIC", "BIDE", "METRONOME", "SELFDESTRUCT", "FIRE_BLAST", "TRI_ATTACK", "SUBSTITUTE", "FLY" }, frontSize=7,
    },
    {
      id="TF_GLITCH_228", index=228, isNew=true,
      researchIdentity="Glitch (E4)", name="<G228_01>", nameCells=1,
      dex=152, capturedDex=175, stateDependentDex=false,
      heightFt=199, heightIn=9, rawHeightFt=195, rawHeightIn=57, weight=8503,
      stats={ 14, 1, 12, 121, 254 }, rawStats={ 14, 0, 12, 121, 254 },
      types={ "BUG", "TF_TYPE_C8" }, catch=22, baseExp=0, growth="MEDIUM_FAST",
      moves={ "WRAP", "AURORA_BEAM", "FIRE_PUNCH", "SKULL_BASH" }, tmhm={ "MEGA_PUNCH", "SWORDS_DANCE", "WHIRLWIND", "BLIZZARD", "SUBMISSION", "SEISMIC_TOSS", "MEGA_DRAIN", "SOLARBEAM", "DRAGON_RAGE", "THUNDERBOLT", "EARTHQUAKE", "FISSURE", "DIG", "METRONOME", "SOFTBOILED", "SKY_ATTACK", "REST", "EXPLOSION", "ROCK_SLIDE", "TRI_ATTACK", "FLY", "SURF", "STRENGTH" }, frontSize=7,
    },
    {
      id="TF_OOB_230", index=230, isNew=false,
      researchIdentity="- -", name="<G230_01><G230_02><G230_03><G230_04><G230_05>", nameCells=5,
      dex=152, capturedDex=240, stateDependentDex=false,
      heightFt=18, heightIn=2, rawHeightFt=1, rawHeightIn=206, weight=26349,
      stats={ 19, 114, 114, 1, 20 }, rawStats={ 19, 114, 114, 0, 20 },
      types={ "TF_TYPE_7B", "TF_TYPE_70" }, catch=65, baseExp=0, growth="MEDIUM_FAST",
      moves={ "STRUGGLE", "DOUBLESLAP" }, tmhm={ "TAKE_DOWN", "DOUBLE_EDGE", "BUBBLEBEAM", "WATER_GUN", "ICE_BEAM", "SUBMISSION", "SEISMIC_TOSS", "RAGE", "SOLARBEAM", "DRAGON_RAGE", "THUNDER", "FISSURE", "DIG", "TELEPORT", "MIMIC", "BIDE", "METRONOME", "SELFDESTRUCT", "FIRE_BLAST", "TRI_ATTACK", "SUBSTITUTE", "FLY" }, frontSize=7,
    },
    {
      id="TF_GLITCH_231", index=231, isNew=true,
      researchIdentity="Pゥ 4$", name="<G231_01><G231_02><G231_03><G231_04><G231_05><G231_06><G231_07>", nameCells=7,
      dex=152, capturedDex=174, stateDependentDex=false,
      heightFt=23, heightIn=0, rawHeightFt=23, rawHeightIn=0, weight=8806,
      stats={ 30, 182, 32, 2, 54 }, rawStats={ 30, 182, 32, 2, 54 },
      types={ "FIGHTING", "TF_TYPE_2B" }, catch=201, baseExp=175, growth="MEDIUM_FAST",
      moves={ "TF_MOVE_CD", "TF_MOVE_EF", "BUBBLEBEAM", "TACKLE" }, tmhm={ "MEGA_KICK", "TOXIC", "HORN_DRILL", "DOUBLE_EDGE", "BUBBLEBEAM", "SUBMISSION", "COUNTER", "SEISMIC_TOSS", "RAGE", "THUNDER", "FISSURE", "DIG", "MIMIC", "DOUBLE_TEAM", "BIDE", "METRONOME", "EGG_BOMB", "SWIFT", "SKULL_BASH", "SOFTBOILED", "SKY_ATTACK", "THUNDER_WAVE", "PSYWAVE", "TRI_ATTACK", "STRENGTH" }, frontSize=7,
    },
    {
      id="TF_GLITCH_233", index=233, isNew=true,
      researchIdentity="c", name="<G233_01>", nameCells=1,
      dex=152, capturedDex=175, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 14, 1, 12, 121, 254 }, rawStats={ 14, 0, 12, 121, 254 },
      types={ "BUG", "TF_TYPE_C8" }, catch=22, baseExp=0, growth="MEDIUM_FAST",
      moves={ "WRAP", "AURORA_BEAM", "FIRE_PUNCH", "SKULL_BASH" }, tmhm={ "MEGA_PUNCH", "SWORDS_DANCE", "WHIRLWIND", "BLIZZARD", "SUBMISSION", "SEISMIC_TOSS", "MEGA_DRAIN", "SOLARBEAM", "DRAGON_RAGE", "THUNDERBOLT", "EARTHQUAKE", "FISSURE", "DIG", "METRONOME", "SOFTBOILED", "SKY_ATTACK", "REST", "EXPLOSION", "ROCK_SLIDE", "TRI_ATTACK", "FLY", "SURF", "STRENGTH" }, frontSize=7,
    },
    {
      id="TF_GLITCH_234", index=234, isNew=true,
      researchIdentity="A (EA)", name="<G234_01>", nameCells=1,
      dex=152, capturedDex=234, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 179, 96, 209, 96, 21 }, rawStats={ 179, 96, 209, 96, 21 },
      types={ "TF_TYPE_61", "TF_TYPE_27" }, catch=97, baseExp=48, growth="MEDIUM_FAST",
      moves={ "TF_MOVE_BE", "AGILITY", "TF_MOVE_E4", "AGILITY" }, tmhm={ "RAZOR_WIND", "TOXIC", "HORN_DRILL", "TAKE_DOWN", "HYPER_BEAM", "COUNTER", "SOLARBEAM", "DRAGON_RAGE", "THUNDER", "MIMIC", "BIDE", "FIRE_BLAST", "SWIFT", "DREAM_EATER", "SKY_ATTACK", "REST", "THUNDER_WAVE", "PSYWAVE", "EXPLOSION", "SUBSTITUTE", "STRENGTH", "FLASH" }, frontSize=6,
    },
    {
      id="TF_GLITCH_235", index=235, isNew=true,
      researchIdentity="Glitch (EB)", name="<G235_01>", nameCells=1,
      dex=85, capturedDex=85, stateDependentDex=false,
      heightFt=199, heightIn=9, rawHeightFt=195, rawHeightIn=57, weight=8503,
      stats={ 60, 110, 70, 100, 60 }, rawStats={ 60, 110, 70, 100, 60 },
      types={ "NORMAL", "FLYING" }, catch=45, baseExp=158, growth="MEDIUM_FAST",
      moves={ "PECK", "GROWL", "FURY_ATTACK" }, tmhm={ "WHIRLWIND", "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "HYPER_BEAM", "RAGE", "MIMIC", "DOUBLE_TEAM", "REFLECT", "BIDE", "SKULL_BASH", "SKY_ATTACK", "REST", "TRI_ATTACK", "SUBSTITUTE", "FLY" }, frontSize=7,
    },
    {
      id="TF_GLITCH_238", index=238, isNew=true,
      researchIdentity=".g", name="<G238_01><G238_02><G238_03><G238_04><G238_05><G238_06><G238_07><G238_08><G238_09>", nameCells=9,
      dex=152, capturedDex=175, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 14, 1, 12, 121, 254 }, rawStats={ 14, 0, 12, 121, 254 },
      types={ "BUG", "TF_TYPE_C8" }, catch=22, baseExp=0, growth="MEDIUM_FAST",
      moves={ "WRAP", "AURORA_BEAM", "FIRE_PUNCH", "SKULL_BASH" }, tmhm={ "MEGA_PUNCH", "SWORDS_DANCE", "WHIRLWIND", "BLIZZARD", "SUBMISSION", "SEISMIC_TOSS", "MEGA_DRAIN", "SOLARBEAM", "DRAGON_RAGE", "THUNDERBOLT", "EARTHQUAKE", "FISSURE", "DIG", "METRONOME", "SOFTBOILED", "SKY_ATTACK", "REST", "EXPLOSION", "ROCK_SLIDE", "TRI_ATTACK", "FLY", "SURF", "STRENGTH" }, frontSize=7,
    },
    {
      id="TF_GLITCH_240", index=240, isNew=true,
      researchIdentity="ゥ$ (F0)", name="<G240_01>", nameCells=1,
      dex=152, capturedDex=174, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 30, 182, 32, 2, 54 }, rawStats={ 30, 182, 32, 2, 54 },
      types={ "FIGHTING", "TF_TYPE_2B" }, catch=201, baseExp=175, growth="MEDIUM_FAST",
      moves={ "TF_MOVE_CD", "TF_MOVE_EF", "BUBBLEBEAM", "TACKLE" }, tmhm={ "MEGA_KICK", "TOXIC", "HORN_DRILL", "DOUBLE_EDGE", "BUBBLEBEAM", "SUBMISSION", "COUNTER", "SEISMIC_TOSS", "RAGE", "THUNDER", "FISSURE", "DIG", "MIMIC", "DOUBLE_TEAM", "BIDE", "METRONOME", "EGG_BOMB", "SWIFT", "SKULL_BASH", "SOFTBOILED", "SKY_ATTACK", "THUNDER_WAVE", "PSYWAVE", "TRI_ATTACK", "STRENGTH" }, frontSize=7,
    },
    {
      id="TF_GLITCH_241", index=241, isNew=true,
      researchIdentity="94", name="<G241_01><G241_02><G241_03><G241_04><G241_05><G241_06><G241_07><G241_08><G241_09>", nameCells=9,
      dex=152, capturedDex=213, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 142, 142, 139, 147, 145 }, rawStats={ 142, 142, 139, 147, 145 },
      types={ "TF_TYPE_80", "TF_TYPE_88" }, catch=141, baseExp=132, growth="MEDIUM_FAST",
      moves={ "FLASH", "LEECH_LIFE", "LOVELY_KISS", "PETAL_DANCE" }, tmhm={ "MEGA_PUNCH", "MEGA_KICK", "BODY_SLAM", "DOUBLE_EDGE", "BUBBLEBEAM", "WATER_GUN", "PAY_DAY", "COUNTER", "THUNDERBOLT", "EARTHQUAKE", "DIG", "DOUBLE_TEAM", "EGG_BOMB", "SWIFT", "SKY_ATTACK", "REST", "ROCK_SLIDE", "FLY" }, frontSize=7,
    },
    {
      id="TF_GLITCH_242", index=242, isNew=true,
      researchIdentity="ゥ l (F2)", name="<G242_01><G242_02><G242_03><G242_04><G242_05><G242_06><G242_07><G242_08><G242_09><G242_10>", nameCells=10,
      dex=152, capturedDex=209, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 146, 152, 130, 135, 136 }, rawStats={ 146, 152, 130, 135, 136 },
      types={ "TF_TYPE_82", "TF_TYPE_50" }, catch=145, baseExp=142, growth="MEDIUM_FAST",
      moves={ "GLARE", "FLASH", "KINESIS", "KINESIS" }, tmhm={ "SWORDS_DANCE", "BODY_SLAM", "TAKE_DOWN", "ICE_BEAM", "PAY_DAY", "MEGA_DRAIN", "DRAGON_RAGE", "THUNDER", "EARTHQUAKE", "PSYCHIC_M", "DOUBLE_TEAM", "SKULL_BASH", "SKY_ATTACK", "REST", "ROCK_SLIDE", "CUT" }, frontSize=7,
    },
    {
      id="TF_GLITCH_243", index=243, isNew=true,
      researchIdentity="ゥ l (F3)", name="<G243_01><G243_02><G243_03><G243_04><G243_05><G243_06><G243_07><G243_08><G243_09><G243_10>", nameCells=10,
      dex=26, capturedDex=26, stateDependentDex=false,
      heightFt=40, heightIn=6, rawHeightFt=40, rawHeightIn=6, weight=57519, dexKind='.',
      stats={ 60, 90, 55, 100, 90 }, rawStats={ 60, 90, 55, 100, 90 },
      types={ "ELECTRIC" }, catch=75, baseExp=122, growth="MEDIUM_FAST",
      moves={ "THUNDERSHOCK", "GROWL", "THUNDER_WAVE" }, tmhm={ "MEGA_PUNCH", "MEGA_KICK", "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "HYPER_BEAM", "PAY_DAY", "SUBMISSION", "SEISMIC_TOSS", "RAGE", "THUNDERBOLT", "THUNDER", "MIMIC", "DOUBLE_TEAM", "REFLECT", "BIDE", "SWIFT", "SKULL_BASH", "REST", "THUNDER_WAVE", "SUBSTITUTE", "FLASH" }, frontSize=7,
    },
    {
      id="TF_GLITCH_244", index=244, isNew=true,
      researchIdentity="ゥ$ (F4)", name="<G244_01><G244_02><G244_03><G244_04><G244_05><G244_06><G244_07><G244_08><G244_09><G244_10>", nameCells=10,
      dex=152, capturedDex=254, stateDependentDex=false,
      heightFt=23, heightIn=0, rawHeightFt=23, rawHeightIn=0, weight=8806,
      stats={ 34, 1, 19, 169, 106 }, rawStats={ 34, 0, 19, 169, 106 },
      types={ "TF_TYPE_A9" }, catch=0, baseExp=20, growth="MEDIUM_FAST",
      moves={ "TF_MOVE_A9", "TAIL_WHIP", "SAND_ATTACK" }, tmhm={ "MEGA_PUNCH", "RAZOR_WIND", "SWORDS_DANCE", "MEGA_KICK", "TOXIC", "TAKE_DOWN", "DOUBLE_EDGE", "BUBBLEBEAM", "ICE_BEAM", "BLIZZARD", "THUNDER", "FISSURE", "DIG", "PSYCHIC_M", "REFLECT", "BIDE", "METRONOME", "EGG_BOMB", "FIRE_BLAST", "SOFTBOILED", "SKY_ATTACK", "REST" }, frontSize=2,
    },
    {
      id="TF_GLITCH_246", index=246, isNew=true,
      researchIdentity="G'Mp", name="<G246_01><G246_02><G246_03><G246_04><G246_05><G246_06><G246_07><G246_08><G246_09><G246_10>", nameCells=10,
      dex=40, capturedDex=40, stateDependentDex=false,
      heightFt=154, heightIn=6, rawHeightFt=142, rawHeightIn=150, weight=20621,
      stats={ 140, 70, 45, 45, 50 }, rawStats={ 140, 70, 45, 45, 50 },
      types={ "NORMAL" }, catch=50, baseExp=109, growth="FAST",
      moves={ "SING", "DISABLE", "DEFENSE_CURL", "DOUBLESLAP" }, tmhm={ "MEGA_PUNCH", "MEGA_KICK", "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "BUBBLEBEAM", "WATER_GUN", "ICE_BEAM", "BLIZZARD", "HYPER_BEAM", "SUBMISSION", "COUNTER", "SEISMIC_TOSS", "RAGE", "SOLARBEAM", "THUNDERBOLT", "THUNDER", "PSYCHIC_M", "TELEPORT", "MIMIC", "DOUBLE_TEAM", "REFLECT", "BIDE", "FIRE_BLAST", "SKULL_BASH", "REST", "THUNDER_WAVE", "PSYWAVE", "TRI_ATTACK", "SUBSTITUTE", "STRENGTH", "FLASH" }, frontSize=6,
    },
    {
      id="TF_GLITCH_247", index=247, isNew=true,
      researchIdentity="'Ng'Mp", name="<G247_01><G247_02><G247_03><G247_04><G247_05><G247_06><G247_07><G247_08><G247_09><G247_10>", nameCells=10,
      dex=18, capturedDex=18, stateDependentDex=false,
      heightFt=10, heightIn=7, rawHeightFt=2, rawHeightIn=103, weight=26220,
      stats={ 83, 80, 75, 91, 70 }, rawStats={ 83, 80, 75, 91, 70 },
      types={ "NORMAL", "FLYING" }, catch=45, baseExp=172, growth="MEDIUM_SLOW",
      moves={ "GUST", "SAND_ATTACK", "QUICK_ATTACK" }, tmhm={ "RAZOR_WIND", "WHIRLWIND", "TOXIC", "TAKE_DOWN", "DOUBLE_EDGE", "HYPER_BEAM", "RAGE", "MIMIC", "DOUBLE_TEAM", "REFLECT", "BIDE", "SWIFT", "SKY_ATTACK", "REST", "SUBSTITUTE", "FLY" }, frontSize=7,
    },
    {
      id="TF_GLITCH_248", index=248, isNew=true,
      researchIdentity="'Ng ゥ$", name="<G248_01><G248_02><G248_03><G248_04><G248_05><G248_06><G248_07><G248_08><G248_09>", nameCells=9,
      dex=19, capturedDex=19, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 30, 56, 36, 72, 25 }, rawStats={ 30, 56, 36, 72, 25 },
      types={ "NORMAL" }, catch=255, baseExp=57, growth="MEDIUM_FAST",
      moves={ "TACKLE", "TAIL_WHIP" }, tmhm={ "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "BUBBLEBEAM", "WATER_GUN", "BLIZZARD", "RAGE", "THUNDERBOLT", "THUNDER", "DIG", "MIMIC", "DOUBLE_TEAM", "BIDE", "SWIFT", "SKULL_BASH", "REST", "SUBSTITUTE" }, frontSize=5,
    },
    {
      id="TF_GLITCH_249", index=249, isNew=true,
      researchIdentity="94 h", name="<G249_01><G249_02><G249_03><G249_04><G249_05><G249_06><G249_07><G249_08>", nameCells=8,
      dex=152, capturedDex=213, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 142, 142, 139, 147, 145 }, rawStats={ 142, 142, 139, 147, 145 },
      types={ "TF_TYPE_80", "TF_TYPE_88" }, catch=141, baseExp=132, growth="MEDIUM_FAST",
      moves={ "FLASH", "LEECH_LIFE", "LOVELY_KISS", "PETAL_DANCE" }, tmhm={ "MEGA_PUNCH", "MEGA_KICK", "BODY_SLAM", "DOUBLE_EDGE", "BUBBLEBEAM", "WATER_GUN", "PAY_DAY", "COUNTER", "THUNDERBOLT", "EARTHQUAKE", "DIG", "DOUBLE_TEAM", "EGG_BOMB", "SWIFT", "SKY_ATTACK", "REST", "ROCK_SLIDE", "FLY" }, frontSize=7,
    },
    {
      id="TF_OOB_250", index=250, isNew=false,
      researchIdentity="Glitch (FA)", name="<G250_01><G250_02><G250_03><G250_04><G250_05>", nameCells=5,
      dex=33, capturedDex=33, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 61, 72, 57, 65, 55 }, rawStats={ 61, 72, 57, 65, 55 },
      types={ "POISON" }, catch=120, baseExp=118, growth="MEDIUM_SLOW",
      moves={ "LEER", "TACKLE", "HORN_ATTACK" }, tmhm={ "TOXIC", "HORN_DRILL", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "BUBBLEBEAM", "WATER_GUN", "ICE_BEAM", "BLIZZARD", "RAGE", "THUNDERBOLT", "THUNDER", "MIMIC", "DOUBLE_TEAM", "REFLECT", "BIDE", "SKULL_BASH", "REST", "SUBSTITUTE" }, frontSize=6,
    },
    {
      id="TF_GLITCH_251", index=251, isNew=true,
      researchIdentity="'M 'N g", name="<G251_01><G251_02><G251_03><G251_04><G251_05><G251_06><G251_07><G251_08><G251_09>", nameCells=9,
      dex=95, capturedDex=95, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 35, 45, 160, 70, 30 }, rawStats={ 35, 45, 160, 70, 30 },
      types={ "ROCK", "GROUND" }, catch=45, baseExp=108, growth="MEDIUM_FAST",
      moves={ "TACKLE", "SCREECH" }, tmhm={ "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "RAGE", "EARTHQUAKE", "FISSURE", "DIG", "MIMIC", "DOUBLE_TEAM", "BIDE", "SELFDESTRUCT", "SKULL_BASH", "REST", "EXPLOSION", "ROCK_SLIDE", "SUBSTITUTE", "STRENGTH" }, frontSize=7,
    },
    {
      id="TF_GLITCH_252", index=252, isNew=true,
      researchIdentity="O", name="<G252_01><G252_02><G252_03><G252_04><G252_05><G252_06><G252_07><G252_08>", nameCells=8,
      dex=81, capturedDex=81, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 25, 35, 70, 45, 95 }, rawStats={ 25, 35, 70, 45, 95 },
      types={ "ELECTRIC" }, catch=190, baseExp=89, growth="MEDIUM_FAST",
      moves={ "TACKLE" }, tmhm={ "TOXIC", "TAKE_DOWN", "DOUBLE_EDGE", "RAGE", "THUNDERBOLT", "THUNDER", "TELEPORT", "MIMIC", "DOUBLE_TEAM", "REFLECT", "BIDE", "SWIFT", "REST", "THUNDER_WAVE", "SUBSTITUTE", "FLASH" }, frontSize=5,
    },
    {
      id="TF_GLITCH_253", index=253, isNew=true,
      researchIdentity="ゥ$ 6ゥ", name="<G253_01><G253_02><G253_03><G253_04><G253_05><G253_06><G253_07><G253_08><G253_09><G253_10>", nameCells=10,
      dex=135, capturedDex=135, stateDependentDex=false,
      heightFt=23, heightIn=0, rawHeightFt=23, rawHeightIn=0, weight=8806,
      stats={ 65, 65, 60, 130, 110 }, rawStats={ 65, 65, 60, 130, 110 },
      types={ "ELECTRIC" }, catch=45, baseExp=197, growth="MEDIUM_FAST",
      moves={ "TACKLE", "SAND_ATTACK", "QUICK_ATTACK", "THUNDERSHOCK" }, tmhm={ "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "HYPER_BEAM", "RAGE", "THUNDERBOLT", "THUNDER", "MIMIC", "DOUBLE_TEAM", "REFLECT", "BIDE", "SWIFT", "SKULL_BASH", "REST", "THUNDER_WAVE", "SUBSTITUTE", "FLASH" }, frontSize=6,
    },
    {
      id="TF_GLITCH_254", index=254, isNew=true,
      researchIdentity="'M (FE)", name="<G254_01><G254_02><G254_03><G254_04><G254_05><G254_06>", nameCells=6,
      dex=79, capturedDex=79, stateDependentDex=true,
      heightFt=0, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=0,
      stats={ 90, 65, 65, 15, 40 }, rawStats={ 90, 65, 65, 15, 40 },
      types={ "WATER", "PSYCHIC" }, catch=190, baseExp=99, growth="MEDIUM_FAST",
      moves={ "CONFUSION" }, tmhm={ "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "BUBBLEBEAM", "WATER_GUN", "ICE_BEAM", "BLIZZARD", "PAY_DAY", "RAGE", "EARTHQUAKE", "FISSURE", "DIG", "PSYCHIC_M", "TELEPORT", "MIMIC", "DOUBLE_TEAM", "REFLECT", "BIDE", "FIRE_BLAST", "SWIFT", "SKULL_BASH", "REST", "THUNDER_WAVE", "PSYWAVE", "TRI_ATTACK", "SUBSTITUTE", "SURF", "STRENGTH", "FLASH" }, frontSize=5,
    },
    {
      id="TF_GLITCH_255", index=255, isNew=true,
      researchIdentity="'M (FF)", name="<G255_01><G255_02><G255_03><G255_04><G255_05><G255_06><G255_07><G255_08><G255_09><G255_10>", nameCells=10,
      dex=6, capturedDex=6, stateDependentDex=false,
      heightFt=23, heightIn=0, rawHeightFt=0, rawHeightIn=0, weight=8806,
      stats={ 78, 84, 78, 100, 85 }, rawStats={ 78, 84, 78, 100, 85 },
      types={ "FIRE", "FLYING" }, catch=0, baseExp=209, growth="MEDIUM_SLOW",
      moves={ "SCRATCH", "GROWL", "EMBER", "LEER" }, tmhm={ "MEGA_PUNCH", "SWORDS_DANCE", "MEGA_KICK", "TOXIC", "BODY_SLAM", "TAKE_DOWN", "DOUBLE_EDGE", "HYPER_BEAM", "SUBMISSION", "COUNTER", "SEISMIC_TOSS", "RAGE", "DRAGON_RAGE", "EARTHQUAKE", "FISSURE", "DIG", "MIMIC", "DOUBLE_TEAM", "REFLECT", "BIDE", "FIRE_BLAST", "SWIFT", "SKULL_BASH", "REST", "SUBSTITUTE", "CUT", "STRENGTH" }, frontSize=7,
    },
  }

  -- Index 194's stabilized record contains a duplicate fourth move and a
  -- PP-Up encoded first slot. The stock helper deliberately deduplicates
  -- normal starting moves, so preserve this one captured malformed record
  -- without changing ordinary Pokémon or any other glitch species.
  if not Pokemon._g1gppFullRosterOriginalMovesAtLevel then
    Pokemon._g1gppFullRosterOriginalMovesAtLevel = Pokemon.movesAtLevel
  end
  Pokemon.movesAtLevel = function(speciesDef, level)
    if speciesDef and speciesDef.id == "TF_GLITCH_194" then
      return { "TF_MOVE_BE_194", "AGILITY", "TF_MOVE_E4_194", "AGILITY" }
    end
    return Pokemon._g1gppFullRosterOriginalMovesAtLevel(speciesDef, level)
  end

  if not Pokemon._g1gppFullRosterOriginalNew then
    Pokemon._g1gppFullRosterOriginalNew = Pokemon.new
  end
  local function normalize194Moves(mon, fresh)
    if not (mon and mon.species == "TF_GLITCH_194") then return false end
    local expected = { "TF_MOVE_BE_194", "AGILITY", "TF_MOVE_E4_194", "AGILITY" }
    local correct = #((mon and mon.moves) or {}) == 4
    for i, id in ipairs(expected) do
      if not (mon.moves and mon.moves[i] and mon.moves[i].id == id) then
        correct = false
      end
    end
    if not correct then
      mon.moves = {
        { id="TF_MOVE_BE_194", pp=17, ppUps=3 },
        { id="AGILITY", pp=30 },
        { id="TF_MOVE_E4_194", pp=54 },
        { id="AGILITY", pp=30 },
      }
      return true
    end
    mon.moves[1].ppUps = 3
    if fresh then
      mon.moves[1].pp = 17
      mon.moves[2].pp = 30
      mon.moves[3].pp = 54
      mon.moves[4].pp = 30
    end
    return false
  end

  Pokemon.new = function(data, species, level, rng)
    local mon = Pokemon._g1gppFullRosterOriginalNew(data, species, level, rng)
    normalize194Moves(mon, true)
    return mon
  end

  -- The registered dex value is sometimes only a schema-safe transport value.
  -- Every status and capture page must use the number produced by the original
  -- IndexToPokedex lookup instead. Keeping this table data-driven prevents the
  -- remaining out-of-range species from falling back to No.152.
  local rosterBySpecies = {}
  local displayDex = {}
  for _, p in ipairs(mons) do
    rosterBySpecies[p.id] = p
    displayDex[p.id] = p.capturedDex
  end

  -- Canonical player-visible Pokédex snapshots from each registered
  -- Bulbapedia GlitchDex source. The ROM-pointer audit remains authoritative
  -- for provenance and hazard classification, but raw bytes are not display
  -- values: the original number printer clips, wraps, and sometimes reads
  -- volatile memory. Keep those concerns separate so a safety adaptation can
  -- never replace documented on-screen facts with invented zeroes.
  local publishedDex = {
    [194]={9,93,21501,'IDRocketIDRocket'},
    [195]={80,3,60990,'...'},
    [198]={23,0,8806,'|| ||'}, [200]={23,0,8806,''},
    [201]={23,0,8806,''},
    [203]={80,3,60990,"<PK><MN> 'm <PK><MN> 4"},
    [204]={23,0,8806,'k♀ ♀U'}, [205]={23,0,8806,', |4'},
    [206]={23,0,8806,'|| ||'}, [207]={23,0,8806,''},
    [208]={23,0,8806,''}, [209]={23,0,8806,''},
    [211]={23,0,8806,''},
    [212]={22,0,6,'y 4S <G212_02>ROCKET g 4"'},
    [214]={23,0,8806,'999999999999999999'},
    [215]={23,0,8806,', 4'}, [217]={23,0,8806,'|| ||  || ||'},
    [218]={23,0,8806,''}, [220]={80,3,60990,"Ve 't No"},
    [221]={23,0,8806,"$L 'L ►4k h Ib ◣r 2 <PK><MN> Ib $y 9"},
    [222]={60,33,54007,'-'},
    [223]={2,3,26220,'Unknown'}, [224]={23,0,8806,'IIII'},
    [227]={23,0,8806,"<PK><MN>'<PK><MN>' aa' '' <PK> 2 'lm"},
    [228]={23,0,8806,'KL FIHG'}, [230]={23,0,8806,'9'},
    [231]={23,0,8806,''}, [233]={23,0,8806,''},
    [234]={23,0,8806,''}, [235]={23,0,8806,'HG'},
    [240]={23,0,8806,''}, [241]={23,0,8806,'IIII'},
    [242]={0,23,8806,'<TF192A><TF192B>'},
    [243]={40,6,57519,'.'}, [244]={23,0,8806,''},
    [246]={23,0,8806,'h R'}, [247]={2,3,26220,''},
    [248]={23,0,8806,"$ $' AA"}, [249]={23,0,8806,''},
    [250]={23,0,8806,"/ / 99999 $9$' 9 9 9 9"},
    [251]={23,0,8806,'Q u'}, [253]={23,0,8806,'8 <G253_01>'},
    [254]={23,0,8806,''}, [255]={23,0,8806,''},
  }

  local function controlledDexTextKey(p, variant)
    return ('_G1GPPDexState_%03d_%d'):format(p.index, variant)
  end

  local function controlledDexCells(p, variant, first, count)
    local cells = {}
    local available = math.max(1, tonumber(p.nameCells) or 1)
    for n = 0, count - 1 do
      local cell = ((first + n * (variant + 1) + p.index) % available) + 1
      cells[#cells + 1] = ('<G%03d_%02d>'):format(p.index, cell)
    end
    return table.concat(cells)
  end

  local function controlledDexSeed(game, p)
    local save = game and game.save or {}
    local player = save.player or {}
    return (tonumber(player.id) or 0) + (tonumber(player.money) or 0)
      + #((save and save.party) or {}) + p.index * 131
  end

  local function controlledDexFor(game, p)
    local seed = controlledDexSeed(game, p)
    local variant = (seed % 3) + 1
    return {
      dex=p.capturedDex,
      kind=controlledDexCells(p, variant, variant, 4),
      text=controlledDexTextKey(p, variant),
      -- The original page reads these fields from volatile RAM. Generate
      -- bounded values from controlled local state instead of freezing one
      -- captured screenshot into a universal result.
      heightFt=(seed * 17 + p.index) % 256,
      heightIn=(seed + p.index * 3) % 12,
      weight=(seed * 37 + p.index * 101) % 100000,
      stateDependent=true,
    }
  end

  local function controlledDex191(game)
    local save = game and game.save or {}
    local player = save.player or {}
    local seed = (tonumber(player.id) or 0) + (tonumber(player.money) or 0)
      + #((save and save.party) or {})
    local variants = {
      { kind='<G191_01><G191_03><G191_05><G191_07>',
        text='_G1GPPDex191CorruptA', heightFt=23, heightIn=0, weight=8806,
        sourceSnapshot=true, overlayVariant=1 },
      { kind='<G191_08><G191_06><G191_04><G191_02>',
        text='_G1GPPDex191CorruptB', heightFt=99, heightIn=9, weight=9999 },
      { kind='<G191_02><G191_05><G191_08><G191_03>',
        text='_G1GPPDex191CorruptC', heightFt=9, heightIn=2, weight=9929 },
    }
    return variants[(seed % #variants) + 1]
  end

  local function dexPresentation(game, species)
    if species == "TF_GLITCH_000" then
      return {
        dex=0, kind='<G000_01><G000_03><G000_05><G000_07>',
        text='_G1GPPDex000Corrupt', heightFt=23, heightIn=0, weight=8806,
        sourceSnapshot=true, overlayVariant=1,
      }
    end
    if species == "TF_GLITCH_191" then
      local result = controlledDex191(game)
      result.dex = 250
      result.stateDependent = true
      return result
    end
    -- C0 and C5 already have their own evidence-backed renderers. Do not
    -- replace those accepted implementations with the generalized path.
    if species == "TF_GLITCH_192_A" or species == "TF_GLITCH_197_C5" then
      return nil
    end
    local p = rosterBySpecies[species]
    if not p then return nil end
    if p.index == 238 then
      local seed = controlledDexSeed(game, p)
      local playerName = game and game.save and game.save.player
        and game.save.player.name or 'PLAYER'
      local variants = {
        {23,0,8806,playerName:rep(6)},
        {81,64,20545,playerName:rep(11)},
        {81,80,20561,controlledDexCells(p, 3, 1, 8)},
      }
      local v = variants[(seed % #variants) + 1]
      return {
        dex=p.capturedDex, kind=v[4], text='_G1GPPFullRosterBlankDex',
        heightFt=v[1], heightIn=v[2], weight=v[3],
        stateDependent=true, safelyBounded=true, sourceSnapshot=true,
        overlayVariant=((seed % #variants) + 1),
      }
    end
    local published = publishedDex[p.index]
    if p.stateDependentDex then
      local seed = controlledDexSeed(game, p)
      if published and seed % 3 == 0 then
        return {
          dex=p.capturedDex, kind=published[4], text='_G1GPPFullRosterBlankDex',
          heightFt=published[1], heightIn=published[2], weight=published[3],
          stateDependent=true, safelyBounded=true, sourceSnapshot=true,
          overlayVariant=1,
        }
      end
      local controlled = controlledDexFor(game, p)
      controlled.safelyBounded = true
      return controlled
    end
    if published then
      return {
        dex=p.capturedDex, kind=published[4], text='_G1GPPFullRosterBlankDex',
        heightFt=published[1], heightIn=published[2], weight=published[3],
        stateDependent=false, safelyBounded=true, sourceSnapshot=true,
        overlayVariant=1,
      }
    end
    return {
      dex=p.capturedDex, kind=p.dexKind or '', text='_G1GPPFullRosterBlankDex',
      heightFt=p.heightFt, heightIn=p.heightIn, weight=p.weight,
      stateDependent=false, safelyBounded=true,
    }
  end

  if not SummaryMenu._g1gppFullRosterOriginalNew then
    SummaryMenu._g1gppFullRosterOriginalNew = SummaryMenu.new
  end
  SummaryMenu.new = function(game, mon)
    normalize194Moves(mon)
    return SummaryMenu._g1gppFullRosterOriginalNew(game, mon)
  end

  if not SummaryMenu._g1gppFullRosterOriginalDraw then
    SummaryMenu._g1gppFullRosterOriginalDraw = SummaryMenu.draw
  end
  function SummaryMenu:draw()
    local species = self.mon and self.mon.species
    local shown = displayDex[species]
    local def = shown ~= nil and self.game and self.game.data
      and self.game.data.pokemon and self.game.data.pokemon[species] or nil
    if not def then return SummaryMenu._g1gppFullRosterOriginalDraw(self) end
    local internalDex = def.dex
    def.dex = shown
    local ok, drawError = pcall(SummaryMenu._g1gppFullRosterOriginalDraw, self)
    def.dex = internalDex
    if not ok then error(drawError, 0) end
  end

  if not DexEntryMenu._g1gppFullRosterOriginalNew then
    DexEntryMenu._g1gppFullRosterOriginalNew = DexEntryMenu.new
  end
  DexEntryMenu.new = function(game, speciesOrOpts, onDone)
    local species = type(speciesOrOpts) == "table"
      and (speciesOrOpts.species or speciesOrOpts[1]) or speciesOrOpts
    local screen = DexEntryMenu._g1gppFullRosterOriginalNew(
      game, speciesOrOpts, onDone)
    local presentation = dexPresentation(game, species)
    if not (screen and screen.def) then return screen end
    local roster = rosterBySpecies[species]
    if not presentation then
      if roster and (species == "TF_GLITCH_192_A"
          or species == "TF_GLITCH_197_C5") then
        screen._g1gppFullRosterSpecies = species
        screen._g1gppFullRosterPresentation = {
          sourceSnapshot=true, overlayVariant=1, safelyBounded=true,
        }
      end
      return screen
    end
    local displayDef = {}
    for key, value in pairs(screen.def) do displayDef[key] = value end
    local entry = {}
    for key, value in pairs(displayDef.dexEntry or {}) do entry[key] = value end
    displayDef.dex = presentation.dex
    for _, key in ipairs({ 'kind', 'text', 'heightFt', 'heightIn', 'weight' }) do
      if presentation[key] ~= nil then entry[key] = presentation[key] end
    end
    displayDef.dexEntry = entry
    screen.def = displayDef
    screen.forceOwned = true
    screen._g1gppFullRosterSpecies = species
    screen._g1gppFullRosterPresentation = presentation
    logger:log("FULL ROSTER DEX PAGE PREPARED",
      "species=" .. logger:safeField(species)
        .. " displayDex=" .. logger:safeField(displayDef.dex)
        .. " stateDependent=" .. logger:safeField(
          presentation.stateDependent == true)
        .. " safelyBounded=" .. logger:safeField(
          presentation.safelyBounded == true))
    return screen
  end

  -- The stock renderer substitutes "Data unknown." whenever a description
  -- stream is absent. That is not an original Red/Blue result for this
  -- roster. Overlay each registered source snapshot with an image generated
  -- from ordinary graphics in the player's own imported cache. For records
  -- sourced from volatile memory, other controlled states remain bounded and
  -- visibly variable instead of freezing one screenshot into a false rule.
  if not DexEntryMenu._g1gppFullRosterOriginalDraw then
    DexEntryMenu._g1gppFullRosterOriginalDraw = DexEntryMenu.draw
  end
  local dexOverlayCache = {}
  local function dexOverlay(index, variant)
    variant = variant or 1
    local key = index * 10 + variant
    if dexOverlayCache[key] ~= nil then
      return dexOverlayCache[key] or nil
    end
    local suffix = variant > 1 and ("_" .. variant) or ""
    local path = ("save/mod-derived/g1gpp/ui/g1gpp_dex_%03d%s.png")
      :format(index, suffix)
    local ok, image = pcall(love.graphics.newImage, path)
    dexOverlayCache[key] = ok and image or false
    return ok and image or nil
  end
  local exactFullDex = { [201]=true, [209]=true, [214]=true,
    [222]=true, [255]=true }
  local fullDexOverlayCache = {}
  local function fullDexOverlay(index)
    if fullDexOverlayCache[index] ~= nil then
      return fullDexOverlayCache[index] or nil
    end
    local path = ("save/mod-derived/g1gpp/ui/g1gpp_dex_full_%03d.png")
      :format(index)
    local ok, image = pcall(love.graphics.newImage, path)
    fullDexOverlayCache[index] = ok and image or false
    return ok and image or nil
  end
  function DexEntryMenu:draw()
    DexEntryMenu._g1gppFullRosterOriginalDraw(self)
    local species = self._g1gppFullRosterSpecies
    local presentation = self._g1gppFullRosterPresentation
    local p = species and rosterBySpecies[species] or nil
    if not (p and presentation) then return end
    if exactFullDex[p.index] then
      local full = fullDexOverlay(p.index)
      if full then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(full, 0, 0)
        return
      end
    end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 8, 80, 144, 56)
    local image = presentation.sourceSnapshot
      and dexOverlay(p.index, presentation.overlayVariant) or nil
    if image then
      love.graphics.draw(image, 8, 80)
    elseif presentation.stateDependent or p.index == 220 then
      local seed = controlledDexSeed(self.game, p)
      local variant = (seed % 3) + 1
      local Font = require("src.render.Font")
      love.graphics.setColor(0, 0, 0, 1)
      Font.draw(controlledDexCells(p, variant, variant + 1, 4), 8, 88)
      Font.draw(controlledDexCells(p, variant, variant + 3, 4), 8, 104)
    end
    love.graphics.setColor(1, 1, 1, 1)
  end

  -- Glitch species may share an ordinary Pokédex number, but they are not
  -- extra selectable rows in the original 001-151 list. Mask every full-roster
  -- transport definition while the stock list is assembled. Capture pages and
  -- status screens continue to use the researched number above.
  if not PokedexMenu._g1gppFullRosterOriginalNew then
    PokedexMenu._g1gppFullRosterOriginalNew = PokedexMenu.new
  end
  PokedexMenu.new = function(game, opts)
    local masked = {}
    for species in pairs(rosterBySpecies) do
      local def = game and game.data and game.data.pokemon
        and game.data.pokemon[species]
      if def then
        masked[#masked + 1] = { def=def, dex=def.dex }
        def.dex = 0
      end
    end
    local ok, result = pcall(PokedexMenu._g1gppFullRosterOriginalNew,
      game, opts)
    for _, row in ipairs(masked) do row.def.dex = row.dex end
    if not ok then error(result, 0) end
    return result
  end

  for ordinal, p in ipairs(mons) do
    local base = 0xD000 + (ordinal - 1) * 16
    local charmap = {}
    for cell = 1, 11 do
      local seq = ('<G%03d_%02d>'):format(p.index, cell)
      charmap[#charmap + 1] = { seq=seq, code=base + cell - 1 }
    end
    mod.content.font:register(('g1gpp_name_%03d'):format(p.index), {
      image=('save/mod-derived/g1gpp/fonts/g1gpp_name_%03d.png'):format(p.index),
      base=base, glyphsPerRow=11, charmap=charmap,
    })
    if p.stateDependentDex then
      for variant = 1, 3 do
        mod.content.text:register(controlledDexTextKey(p, variant),
          controlledDexCells(p, variant, variant + 1, 4) .. '\n'
            .. controlledDexCells(p, variant, variant + 3, 4))
      end
    end
  end

  mod.content.cries:register("TF_GLITCH_000", { header={address=0x4114,bank=2,engine=1}, pitch=0xF7, length=0x7E })
  mod.content.cries:register("TF_GLITCH_191", { header={address=0x403C,bank=2,engine=1}, pitch=0xF3, length=0xA7 })
  mod.content.cries:override("TF_GLITCH_192_A", { header={address=0x403C,bank=2,engine=1}, pitch=0x60, length=0xD0 })
  mod.content.cries:register("TF_GLITCH_194", { header={address=0x403C,bank=2,engine=1}, pitch=0x06, length=0xFA })
  mod.content.cries:register("TF_GLITCH_195", { header={address=0x403C,bank=2,engine=1}, pitch=0xD0, length=0x21 })
  mod.content.cries:override("TF_GLITCH_197_C5", { header={address=0x4060,bank=2,engine=1}, pitch=0x47, length=0xCB })
  mod.content.cries:register("TF_GLITCH_198", { header={address=0x403C,bank=2,engine=1}, pitch=0xDC, length=0x9F })
  mod.content.cries:override("TF_OOB_200", { header={address=0x40B1,bank=2,engine=1}, pitch=0xC8, length=0x18 })
  mod.content.cries:register("TF_GLITCH_201", { header={address=0x403C,bank=2,engine=1}, pitch=0x7E, length=0x87 })
  mod.content.cries:register("TF_GLITCH_203", { header={address=0x410B,bank=2,engine=1}, pitch=0x22, length=0xC9 })
  mod.content.cries:register("TF_GLITCH_204", { header={address=0x403C,bank=2,engine=1}, pitch=0xF3, length=0xA7 })
  mod.content.cries:register("TF_GLITCH_205", { header={address=0x403C,bank=2,engine=1}, pitch=0x61, length=0xD0 })
  mod.content.cries:register("TF_GLITCH_206", { header={address=0x4165,bank=2,engine=1}, pitch=0x25, length=0xD0 })
  mod.content.cries:register("TF_GLITCH_207", { header={address=0x403C,bank=2,engine=1}, pitch=0x06, length=0xFA })
  mod.content.cries:override("TF_OOB_208", { header={address=0x403C,bank=2,engine=1}, pitch=0xD0, length=0x21 })
  mod.content.cries:register("TF_GLITCH_209", { header={address=0x403C,bank=2,engine=1}, pitch=0xCF, length=0x0E })
  mod.content.cries:register("TF_GLITCH_211", { header={address=0x403C,bank=2,engine=1}, pitch=0xDC, length=0xC6 })
  mod.content.cries:register("TF_GLITCH_212", { header={address=0x403C,bank=2,engine=1}, pitch=0x23, length=0x23 })
  mod.content.cries:register("TF_GLITCH_214", { header={address=0x403C,bank=2,engine=1}, pitch=0x7E, length=0xCB })
  mod.content.cries:register("TF_GLITCH_215", { header={address=0x403C,bank=2,engine=1}, pitch=0x22, length=0xCB })
  mod.content.cries:register("TF_GLITCH_217", { header={address=0x404E,bank=2,engine=1}, pitch=0x36, length=0x01 })
  mod.content.cries:register("TF_GLITCH_218", { header={address=0x403C,bank=2,engine=1}, pitch=0xC9, length=0xAF })
  mod.content.cries:register("TF_GLITCH_220", { header={address=0x4072,bank=2,engine=1}, pitch=0x01, length=0xCD })
  mod.content.cries:register("TF_GLITCH_221", { header={address=0x403C,bank=2,engine=1}, pitch=0x3D, length=0x21 })
  mod.content.cries:register("TF_GLITCH_222", { header={address=0x403C,bank=2,engine=1}, pitch=0x70, length=0x06 })
  mod.content.cries:register("TF_GLITCH_223", { header={address=0x40C3,bank=2,engine=1}, pitch=0xCD, length=0xD6 })
  mod.content.cries:register("TF_GLITCH_224", { header={address=0x403C,bank=2,engine=1}, pitch=0x21, length=0xB3 })
  mod.content.cries:register("TF_GLITCH_227", { header={address=0x407B,bank=2,engine=1}, pitch=0xC8, length=0x16 })
  mod.content.cries:register("TF_GLITCH_228", { header={address=0x403C,bank=2,engine=1}, pitch=0xC5, length=0xE5 })
  mod.content.cries:override("TF_OOB_230", { header={address=0x4177,bank=2,engine=1}, pitch=0x3E, length=0x07 })
  mod.content.cries:register("TF_GLITCH_231", { header={address=0x403C,bank=2,engine=1}, pitch=0x57, length=0x0D })
  mod.content.cries:register("TF_GLITCH_233", { header={address=0x4060,bank=2,engine=1}, pitch=0xCD, length=0x39 })
  mod.content.cries:register("TF_GLITCH_234", { header={address=0x403C,bank=2,engine=1}, pitch=0xE1, length=0xC1 })
  mod.content.cries:register("TF_GLITCH_235", { header={address=0x403C,bank=2,engine=1}, pitch=0x18, length=0xE2 })
  mod.content.cries:register("TF_GLITCH_238", { header={address=0x4045,bank=2,engine=1}, pitch=0x14, length=0x00 })
  mod.content.cries:register("TF_GLITCH_240", { header={address=0x415C,bank=2,engine=1}, pitch=0xF7, length=0xC1 })
  mod.content.cries:register("TF_GLITCH_241", { header={address=0x403C,bank=2,engine=1}, pitch=0xE1, length=0xC9 })
  mod.content.cries:register("TF_GLITCH_242", { header={address=0x403C,bank=2,engine=1}, pitch=0x0A, length=0x21 })
  mod.content.cries:register("TF_GLITCH_243", { header={address=0x403C,bank=2,engine=1}, pitch=0xCE, length=0x22 })
  mod.content.cries:register("TF_GLITCH_244", { header={address=0x416E,bank=2,engine=1}, pitch=0x22, length=0x77 })
  mod.content.cries:register("TF_GLITCH_246", { header={address=0x403C,bank=2,engine=1}, pitch=0x37, length=0xE6 })
  mod.content.cries:register("TF_GLITCH_247", { header={address=0x40C3,bank=2,engine=1}, pitch=0x28, length=0x0A })
  mod.content.cries:register("TF_GLITCH_248", { header={address=0x4165,bank=2,engine=1}, pitch=0xE9, length=0xCE })
  mod.content.cries:register("TF_GLITCH_249", { header={address=0x403C,bank=2,engine=1}, pitch=0x4F, length=0x06 })
  mod.content.cries:override("TF_OOB_250", { header={address=0x403C,bank=2,engine=1}, pitch=0x09, length=0x36 })
  mod.content.cries:register("TF_GLITCH_251", { header={address=0x403C,bank=2,engine=1}, pitch=0x21, length=0x9B })
  mod.content.cries:register("TF_GLITCH_252", { header={address=0x403C,bank=2,engine=1}, pitch=0xFA, length=0x31 })
  mod.content.cries:register("TF_GLITCH_253", { header={address=0x403C,bank=2,engine=1}, pitch=0x47, length=0x05 })
  mod.content.cries:register("TF_GLITCH_254", { header={address=0x403C,bank=2,engine=1}, pitch=0x06, length=0x2A })
  mod.content.cries:register("TF_GLITCH_255", { header={address=0x403C,bank=2,engine=1}, pitch=0x20, length=0xFC })

  for _, p in ipairs(mons) do
    local definition = {
      id=p.id, index=p.index, name=p.name, dex=p.dex,
      -- API 2 requires a normalized inch field at registration time. The live
      -- captured glitch value (including deliberately out-of-range bytes) is
      -- restored by installRuntime after the registry has been validated.
      dexEntry={heightFt=p.heightFt + math.floor(p.heightIn / 12),
        heightIn=p.heightIn % 12,kind=p.dexKind or '',weight=p.weight,
        text='_G1GPPFullRosterBlankDex'},
      types=p.types, baseStats={hp=p.stats[1],attack=p.stats[2],defense=p.stats[3],speed=p.stats[4],special=p.stats[5]},
      catchRate=p.catch, baseExp=p.baseExp, growthRate=p.growth, cry=p.id,
      level1Moves=p.moves, learnset={}, tmhm=p.tmhm, evolutions={},
      spriteFront=('save/mod-derived/g1gpp/battle/front/g1gpp_species_%03d.png'):format(p.index),
      spriteBack=('save/mod-derived/g1gpp/battle/back/g1gpp_species_%03d.png'):format(p.index),
      frontSize=p.frontSize, palette='MEWMON',
    }
    if p.isNew then mod.content.pokemon:register(p.id, definition)
    else mod.content.pokemon:patch(p.id, definition) end
    local icon = { image=('save/mod-derived/g1gpp/icons/g1gpp_species_%03d.png'):format(p.index), frames=2 }
    if p.isNew then mod.content.icons:register(p.id, icon)
    else mod.content.icons:override(p.id, icon) end
    encounterData.glitchPokemon[p.index] = {
      id=p.id,index=p.index,name=p.name,subtype='full_captured_roster',
      researchIdentity=p.researchIdentity,capturedDex=p.capturedDex,
      stateDependentDex=p.stateDependentDex,
    }
  end

  function M.installRuntime(game)
    local status={installed=0,zeroStats=0}
    for _, p in ipairs(mons) do
      local def=game.data.pokemon[p.id]
      if def then
        def.baseStats.hp=p.rawStats[1]; def.baseStats.attack=p.rawStats[2]
        def.baseStats.defense=p.rawStats[3]; def.baseStats.speed=p.rawStats[4]
        def.baseStats.special=p.rawStats[5]; def.level1Moves=p.moves
        def.name=p.name; def.frontSize=p.frontSize; def.palette='MEWMON'
        -- The recomp expects already-decoded display values. The previous
        -- build replaced them with the source bytes here, producing incorrect
        -- heights and inches even though the roster table held the right data.
        def.dexEntry.heightFt=p.heightFt; def.dexEntry.heightIn=p.heightIn
        def.dexEntry.weight=p.weight
        def.spriteFront=('save/mod-derived/g1gpp/battle/front/g1gpp_species_%03d.png'):format(p.index)
        def.spriteBack=('save/mod-derived/g1gpp/battle/back/g1gpp_species_%03d.png'):format(p.index)
        for _, value in ipairs(p.rawStats) do if value == 0 then status.zeroStats=status.zeroStats+1 end end
        status.installed=status.installed+1
      end
    end
    logger:log('FULL GLITCH ROSTER INSTALL', 'installed='..status.installed..' zeroStats='..status.zeroStats)
    return status.installed == #mons, status
  end
  M.count = #mons
  return M
end
