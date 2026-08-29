-- Shared Red/Blue MissingNo. presentation and cry definitions.
--
-- The mod packages no audio. Each variant borrows a normal Gen-I cry header
-- from the player's imported game data, then applies the exact original
-- MissingNo. pitch and length bytes.

return function(ctx)
  local mod = assert(ctx and ctx.mod, "missingno_common needs mod")

  local ordinary = {
    31, 32, 50, 52, 56, 61, 62, 63, 67, 68, 69, 79, 80, 81, 86, 87,
    94, 95, 115, 121, 122, 127, 134, 135, 137, 140, 146, 156, 159, 160,
    161, 162, 172, 174, 175, 181,
  }

  local variants = {
    [67]  = { base = "NIDORAN_M", pitch = 0x80, length = 0x10 },
    [69]  = { base = "TAUROS",    pitch = 0xE0, length = 0x80 },
    [79]  = { base = "RATTATA",   pitch = 0xFF, length = 0x40 },
    [81]  = { base = "PIDGEY",    pitch = 0xE0, length = 0x60 },
    [94]  = { base = "IVYSAUR",   pitch = 0x40, length = 0xC0 },
    [95]  = { base = "IVYSAUR",   pitch = 0x20, length = 0xC0 },
    [127] = { base = "RHYDON",    pitch = 0x20, length = 0x10 },
    [137] = { base = "IVYSAUR",   pitch = 0x40, length = 0x80 },
    [181] = { base = "TAUROS",    pitch = 0x00, length = 0x80 },
  }

  local speciesByIndex = {}
  for _, index in ipairs(ordinary) do
    local species = ("TF_GLITCH_%03d"):format(index)
    local definition = variants[index] or {
      -- SFX_CRY_00, pitch $00, length $00 is the original blank/silent
      -- MissingNo. record. It must still be registered under the glitch
      -- species id; pointing at NIDORAN_M directly would use its audible
      -- $00/$80 modifiers instead.
      base = "NIDORAN_M", pitch = 0x00, length = 0x00,
    }
    -- Sound.playCry looks up data.audio.cries[mon.species] directly. The old
    -- build registered detached TF_MISSINGNO_*_CRY ids, so battle entrances
    -- never reached any of these definitions even though pokemon.cry named
    -- them. Registering by species is the public Recomp contract.
    mod.content.cries:register(species, definition)
    speciesByIndex[index] = species
  end

  return {
    cryForIndex = function(index)
      return speciesByIndex[index]
    end,
    installCryLogging = function(logger)
      local Sound = require("src.core.Sound")
      if Sound._g1gppCommonMissingNoCryLogging then return end
      Sound._g1gppCommonMissingNoCryLogging = true
      local originalPlayCry = Sound.playCry
      Sound.playCry = function(data, species, pikaClip)
        local index = type(species) == "string"
          and tonumber(species:match("^TF_GLITCH_(%d%d%d)$")) or nil
        if not (index and speciesByIndex[index]) then
          return originalPlayCry(data, species, pikaClip)
        end
        local definition = variants[index]
        logger:log("COMMON MISSINGNO CRY PLAY",
          "species=" .. logger:safeField(species)
            .. " base=" .. logger:safeField(
              definition and definition.base or "NIDORAN_M")
            .. (definition
              and (" pitch=%02X length=%02X"):format(
                definition.pitch, definition.length)
              or " pitch=00 length=00 expectedSilent=true"))
        local ok, source = pcall(originalPlayCry, data, species, pikaClip)
        if not ok then
          logger:log("COMMON MISSINGNO CRY ERROR",
            "species=" .. logger:safeField(species)
              .. " error=" .. logger:safeField(source))
          return nil
        end
        local playing, duration = nil, nil
        if source then
          pcall(function() playing = source:isPlaying() end)
          pcall(function() duration = source:getDuration() end)
        end
        logger:log("COMMON MISSINGNO CRY RESULT",
          "species=" .. logger:safeField(species)
            .. " source=" .. logger:safeField(source ~= nil)
            .. " playing=" .. logger:safeField(playing)
            .. " duration=" .. logger:safeField(duration))
        return source
      end
    end,
    icon = {
      image = "save/mod-derived/g1gpp/icons/g1gpp_missingno.png",
      frames = 2,
    },
  }
end
