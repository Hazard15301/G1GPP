-- Safe native reconstructions for glitch cries documented as music channels.
-- These become real one-channel Music programs, so they keep playing instead
-- of leaving silence after the ordinary five-second SFX renderer ends.
return function(ctx)
  local logger = assert(ctx and ctx.logger, "song_cry_compat needs logger")
  local getGame = assert(ctx and ctx.getGame, "song_cry_compat needs getGame")
  local Sound = require("src.core.Sound")
  local Music = require("src.core.Music")
  local ChipSynth = require("src.core.ChipSynth")

  if not Sound._g1gppOriginalPlayCrySongCompat then
    Sound._g1gppOriginalPlayCrySongCompat = Sound.playCry
  end
  local originalPlayCry = Sound._g1gppOriginalPlayCrySongCompat

  local battleSpecs = {
    TF_GLITCH_201={song="Music_FinalBattle", address=0x42D9, bank=8, engine=2},
    TF_GLITCH_209={song="Music_DefeatedTrainer", address=0x42E2, bank=8, engine=2, tempo=0x120},
    TF_GLITCH_214={song="Music_FinalBattle", address=0x42D9, bank=8, engine=2},
    TF_GLITCH_222={song="Music_Routes3", address=0x42D9, bank=2, engine=1},
  }
  local outsideBattleSpecs = {
    TF_GLITCH_201={song="Music_Routes4", address=0x42E5, bank=2, engine=1, tempo=0x180},
    TF_GLITCH_214={song="Music_Routes4", address=0x42E5, bank=2, engine=1, tempo=0x180},
  }
  local registered = {}

  local function battleActive()
    local game = getGame()
    local states = game and game.stack and game.stack.states or {}
    for i = #states, 1, -1 do
      local state = states[i]
      if state and state.enemy and type(state.onFinish) == "function" then
        return true
      end
    end
    return false
  end

  local function registerSong(data, species, spec, context)
    local key = species .. ":" .. context
    local label = registered[key]
    if label and data.audio and data.audio.songs
        and data.audio.songs[label] then return label end
    local banks = ChipSynth._loadBanksForTest(data)
    local blob = banks and banks[spec.bank]
    if type(blob) ~= "string" then return nil, "native audio bank unavailable" end
    local offset = spec.address - 0x4000 + 1
    local descriptor, low, high = blob:byte(offset, offset + 2)
    if not (descriptor and low and high) then return nil, "song header unavailable" end
    local channel = bit.band(descriptor, 0x0F) + 1
    local address = low + high * 0x100
    label = "G1GPP_SONG_CRY_" .. species .. "_" .. context
    data.audio.songs[label] = {
      tempo=spec.tempo,
      chip={blob=blob, engine=spec.engine,
        channels={{number=channel,address=address}}},
    }
    registered[key] = label
    logger:log("SONG CRY BUILD",
      ("species=%s context=%s song=%s channel=%d address=%04X persistent=true"):format(
        logger:safeField(species), context, spec.song, channel, address))
    return label
  end

  Sound.playCry = function(data, species, pikaClip)
    local inBattle = battleActive()
    local context = inBattle and "battle" or "stats"
    local spec = (not inBattle and outsideBattleSpecs[species])
      or battleSpecs[species]
    if not spec then return originalPlayCry(data, species, pikaClip) end
    local ok, label, err = pcall(registerSong, data, species, spec, context)
    if not (ok and label) then
      logger:log("SONG CRY ERROR",
        "species=" .. logger:safeField(species)
          .. " context=" .. logger:safeField(context)
          .. " error=" .. logger:safeField(ok and err or label))
      return originalPlayCry(data, species, pikaClip)
    end
    Music.play(data, label, true,
      {selected=true, reason="g1gpp-song-cry"})
    logger:log("SONG CRY PLAY",
      "species=" .. logger:safeField(species)
        .. " context=" .. logger:safeField(context)
        .. " song=" .. logger:safeField(spec.song)
        .. " persistent=true")
    -- Do not return the persistent Music source: battle introductions wait
    -- for an ordinary returned cry Source to finish, and this replacement is
    -- intentionally active until the next music cue. Returning nil lets the
    -- battle continue while the glitch song remains audible.
    return nil
  end

  return true
end
