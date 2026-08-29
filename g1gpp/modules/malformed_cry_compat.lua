-- G1GPP malformed Gen-I cry compatibility layer (development / preservation).
--
-- Some OOB species do not resolve to a normal 3-channel cry header. The real
-- Gen-I sound engine still executes the resulting misaligned header bytes and
-- can start an unusual set of software channels. Gen1Recomp's ordinary cry
-- path assumes a well-formed header, so it cannot represent those cases from
-- a single {bank,address} definition.
--
-- This layer stays release-safe: it reads ONLY Gen1Recomp's own extracted
-- audio programs (programs.bin) at runtime. Research captures contribute only
-- validated addresses / modifiers / channel topology, never ROM bytes/audio.

return function(ctx)
  local logger = assert(ctx and ctx.logger, "malformed_cry_compat needs logger")
  local mod = assert(ctx.mod, "malformed_cry_compat needs mod")
  local Sound = require("src.core.Sound")
  local ChipSynth = require("src.core.ChipSynth")

  if not Sound._g1gppOriginalPlayCryMalformedCompat then
    Sound._g1gppOriginalPlayCryMalformedCompat = Sound.playCry
  end
  local originalPlayCry = Sound._g1gppOriginalPlayCryMalformedCompat

  -- Gold-standard v1.6.1 trace for species 208, exactly at the frame the
  -- malformed sound begins. The original engine has sound id $46 in CH5-8
  -- with these four command pointers. They all read from audio ROM bank 8.
  local malformed = {
    -- Species C0 starts only software channel 8 from a misaligned header.
    -- Values come from the validated Blue trace; the command stream itself is
    -- read from the player's generated audio bank at runtime.
    TF_GLITCH_192_A = {
      sourceBank = 8,
      engine = 2,
      pitch = 0x60,
      length = 0xD0,
      soundId = 0x03,
      channels = {
        { number = 8, address = 0x4305 },
      },
      dominantOnly = true,
    },
    TF_OOB_208 = {
      sourceBank = 8,
      engine = 2,
      pitch = 0xD0,
      length = 0x21,
      soundId = 0x46,
      channels = {
        { number = 5, address = 0x7998 },
        { number = 6, address = 0x79B0 },
        { number = 7, address = 0x62D5 },
        { number = 8, address = 0x4C25 },
      },
      tailSeconds = 0.026,
      pcmGain = 1.9952623149688795,
      dominantOnly = true,
    },
  }

  -- The complete retained roster is generated from each accepted cry trace.
  -- Generated entries replace the two hand-written records above only where
  -- they carry the same validated command pointers and modifiers.
  local generated = assert(love.filesystem.load(
    mod.path .. "/modules/bulk_malformed_specs.lua"))()
  for species, spec in pairs(generated) do malformed[species] = spec end

  local cache = {}

  -- The original mGBA/APU capture remains audibly active for roughly 26 ms
  -- beyond the logical ChipSynth CH5 render. Preserve that hardware-lifetime
  -- tail without embedding captured PCM: continue a tiny slice of the native
  -- synthesized CH5 waveform, attenuated to the measured residual level.
  local function extendHardwareTail(sd, tailSeconds)
    if not (love.sound and love.sound.newSoundData) then
      return sd, "love.sound.newSoundData unavailable"
    end
    local frames = tonumber(sd:getSampleCount()) or 0
    local rate = tonumber(sd:getSampleRate()) or 44100
    local chans = tonumber(sd:getChannelCount()) or 1
    if frames < 64 or rate <= 0 then return sd, "source too short" end

    local extra = math.max(1, math.floor(rate * (tailSeconds or 0.026) + 0.5))
    local loopFrames = math.max(16, math.floor(rate * 0.004 + 0.5))
    if loopFrames >= frames then loopFrames = math.max(1, math.floor(frames / 4)) end
    local out = love.sound.newSoundData(frames + extra, rate, 16, chans)

    for i = 0, frames - 1 do
      for ch = 1, chans do out:setSample(i, ch, sd:getSample(i, ch)) end
    end

    local loopStart = math.max(0, frames - 1 - loopFrames)
    -- Residual mGBA tail is about half the RMS of the final CH5 segment. Use
    -- a fixed 0.45 continuation and a very short terminal taper only to avoid
    -- introducing a new click at the compatibility-tail boundary.
    for j = 0, extra - 1 do
      local srcIndex = loopStart + (j % loopFrames)
      local terminal = 1.0
      local taper = math.max(1, math.floor(rate * 0.002 + 0.5))
      if j >= extra - taper then terminal = (extra - j) / taper end
      local gain = 0.45 * terminal
      for ch = 1, chans do
        out:setSample(frames + j, ch, (tonumber(sd:getSample(srcIndex, ch)) or 0) * gain)
      end
    end
    return out, ("extra=%d duration=%.6f loop=%d gain=0.45"):format(extra, extra / rate, loopFrames)
  end


  -- Final species-208 loudness correction. Gen1Recomp Source volume is already
  -- at 1.0, so apply the remaining gain to this synthesized SoundData only.
  -- This preserves the validated CH5 program/timing while making the malformed
  -- cry competitive with normal in-game cry loudness. Samples are hard-clamped
  -- to the legal LÖVE SoundData range to avoid wraparound.
  local function applyPcmGain(sd, gain)
    if not sd then return sd, "no SoundData" end
    gain = tonumber(gain) or 1
    local count, channels = 0, 1
    pcall(function() count = tonumber(sd:getSampleCount()) or 0 end)
    pcall(function() channels = tonumber(sd:getChannelCount()) or 1 end)
    local clipped, peakIn, peakOut = 0, 0, 0
    for i = 0, count - 1 do
      for ch = 1, channels do
        local v = tonumber(sd:getSample(i, ch)) or 0
        local a = math.abs(v)
        if a > peakIn then peakIn = a end
        local out = v * gain
        if out > 1 then out = 1; clipped = clipped + 1
        elseif out < -1 then out = -1; clipped = clipped + 1 end
        local ao = math.abs(out)
        if ao > peakOut then peakOut = ao end
        sd:setSample(i, ch, out)
      end
    end
    return sd, ("gain=%.6f peakIn=%.8f peakOut=%.8f clipped=%d"):format(
      gain, peakIn, peakOut, clipped)
  end

  local function sourceFor(data, species, spec)
    local cached = cache[species]
    if cached == false then return nil, "cached failure" end
    if cached then return cached end

    if not (love.audio and love.audio.newSource) then
      return nil, "love.audio unavailable"
    end

    local banks = ChipSynth._loadBanksForTest(data)
    local blob = banks and banks[spec.sourceBank]
    if type(blob) ~= "string" or #blob < 0x4000 then
      return nil, ("missing native audio bank %02X"):format(spec.sourceBank)
    end

    -- A def-local chip program normally owns custom bytes. Here the blob is a
    -- private runtime view of Gen1Recomp's already-extracted native bank 8.
    -- Explicit channels are required because the whole point of this glitch
    -- is that the original engine's malformed header setup is not equivalent
    -- to Gen1Recomp's normal header parser.
    -- 12.13.83 final compatibility: CH5 is the dominant original
    -- malformed-cry carrier and was the closest perceptual match in isolated
    -- A/B testing. Keep the validated CH5 start/modifiers exactly, rather than
    -- summing the secondary software channels at Gen1Recomp's PCM mixer gain.
    local header = {
      chip = {
        blob = blob,
        engine = spec.engine,
        channels = spec.dominantOnly and { spec.channels[1] } or spec.channels,
      },
    }

    local sd = ChipSynth.renderEffectData(data, header, {
      frequencyOffset = spec.pitch,
      cryLength = spec.length,
    })
    if not sd then
      cache[species] = false
      return nil, "native malformed render returned nil"
    end

    if spec.tailSeconds then
      local tailInfo
      sd, tailInfo = extendHardwareTail(sd, spec.tailSeconds)
      logger:log("MALFORMED CRY APU TAIL",
        "species=" .. logger:safeField(species)
          .. " info=" .. logger:safeField(tailInfo))
    end

    if spec.pcmGain then
      local gainInfo
      sd, gainInfo = applyPcmGain(sd, spec.pcmGain)
      logger:log("MALFORMED CRY PCM GAIN",
        "species=" .. logger:safeField(species)
          .. " info=" .. logger:safeField(gainInfo))
    end

    local src = love.audio.newSource(sd, "static")
    -- Keep the source at unity. 12.13.83 applies the additional +6 dB inside
    -- the species-208 synthesized PCM above, because Source volume cannot exceed
    -- the normal 1.0 ceiling reliably across the target runtime.
    pcall(src.setVolume, src, 1.0)
    cache[species] = src

    local count, rate, channels = 0, 44100, 1
    pcall(function() count = tonumber(sd:getSampleCount()) or 0 end)
    pcall(function() rate = tonumber(sd:getSampleRate()) or rate end)
    pcall(function() channels = tonumber(sd:getChannelCount()) or channels end)
    local peak, nonzero = 0, 0
    for i = 0, count - 1 do
      local value = sd:getSample(i, 1) or 0
      local a = math.abs(value)
      if a > peak then peak = a end
      if a > 0.000001 then nonzero = nonzero + 1 end
    end
    local topology = {}
    for _, ch in ipairs(spec.channels) do
      topology[#topology + 1] = ("%d@%04X"):format(ch.number, ch.address)
    end
    logger:log("MALFORMED CRY BUILD",
      ("species=%s soundId=%02X bank=%02X playback=%s pitch=%02X length=%02X samples=%d rate=%d duration=%.6f peak=%.8f nonzero=%d outChannels=%d"):format(
        logger:safeField(species), spec.soundId, spec.sourceBank,
        table.concat(topology, ","),
        spec.pitch, spec.length, count, rate,
        rate > 0 and count / rate or 0, peak, nonzero, channels))

    return src
  end

  Sound.playCry = function(data, species, pikaClip)
    local spec = malformed[species]
    if not spec then return originalPlayCry(data, species, pikaClip) end

    logger:log("MALFORMED CRY PLAY", "species=" .. logger:safeField(species))
    local ok, srcOrErr, extra = pcall(sourceFor, data, species, spec)
    if not ok then
      logger:log("MALFORMED CRY ERROR", "species=" .. logger:safeField(species)
        .. " error=" .. logger:safeField(srcOrErr))
      return originalPlayCry(data, species, pikaClip)
    end
    local src, err = srcOrErr, extra
    if not src then
      logger:log("MALFORMED CRY ERROR", "species=" .. logger:safeField(species)
        .. " error=" .. logger:safeField(err))
      return originalPlayCry(data, species, pikaClip)
    end

    pcall(src.stop, src)
    pcall(src.play, src)
    local duration, playing = nil, nil
    pcall(function() duration = src:getDuration() end)
    pcall(function() playing = src:isPlaying() end)
    logger:log("MALFORMED CRY RESULT",
      "species=" .. logger:safeField(species)
        .. " duration=" .. logger:safeField(duration)
        .. " playing=" .. logger:safeField(playing))
    return src
  end

  return true
end
