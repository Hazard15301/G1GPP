-- Safe presentation for the sixteen Red/Blue glitch-Pokemon indices whose
-- dedicated species paths never produced a playable encounter. These are not
-- Pokemon definitions and can never enter battle, capture, party, storage, or
-- Pokedex state. The generic blackout is intentionally bounded and recoverable.
return function(ctx)
  local encounterData = assert(ctx and ctx.encounterData,
    "retired glitch failures need encounter data")
  local logger = assert(ctx.logger,
    "retired glitch failures need logger")

  local retired = {
    193, 196, 199, 202, 210, 213, 216, 219,
    225, 226, 229, 232, 236, 237, 239, 245,
  }

  for _, index in ipairs(retired) do
    encounterData.crashEffects[index] = {
      class = "retired_species_crash",
      retiredSpecies = true,
      captureAllowed = false,
      playable = false,
      useNativeBattleIntro = true,
      randomRetainedSprite = true,
      showName = false,
      showBattleMenu = false,
    }
  end

  logger:log("RETIRED GLITCH FAILURE ROSTER INSTALLED",
    "count=" .. tostring(#retired)
      .. " captureAllowed=false playable=false saveMutation=false")

  return { count = #retired, indices = retired }
end
