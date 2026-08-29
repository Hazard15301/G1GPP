-- Original-style volatile opposing battle-memory model for G1GPP.
-- Every ordinary battle overwrites these runtime values. Nothing here is
-- serialized into save or option data.
return function(config)
  local mod = assert(config and config.mod, "volatile memory requires mod")
  local logger = assert(config.debugLogger,
    "volatile memory requires debugLogger")

  local Memory = {}
  local state = {
    battle = nil,
    special = 0,
    attackModifier = 0,
    species = nil,
  }

  local function speciesOf(value)
    if not value then return nil end
    local mon = value.mon or value
    local species = mon.species or mon.id
    if type(species) == "table" then species = species.id end
    return species and tostring(species):upper() or nil
  end

  local function specialOf(value, useUnderlyingStats)
    if not value then return nil end
    local mon = value.mon or value
    local first, second, third
    if useUnderlyingStats then
      first = mon.stats and mon.stats.special
      second = value.stats and value.stats.special
      third = value.curStats and value.curStats.special
    else
      first = value.curStats and value.curStats.special
      second = value.stats and value.stats.special
      third = mon.stats and mon.stats.special
    end
    local special = tonumber(first) or tonumber(second) or tonumber(third)
    return special and (math.floor(special) % 256) or nil
  end

  local function attackModifierOf(value)
    if not value then return 7 end
    local stage = value.stages and tonumber(value.stages.attack) or 0
    stage = math.max(-6, math.min(6, math.floor(stage or 0)))
    return stage + 7
  end

  local function captureEnemy(value, useUnderlyingStats)
    if not value or value.isPlayer == true then return false end
    local special = specialOf(value, useUnderlyingStats)
    if special == nil then return false end
    state.special = special
    state.attackModifier = useUnderlyingStats and 7
      or attackModifierOf(value)
    state.species = speciesOf(value)
    mod.log:info(
      "G1GPP captured enemy %s Special=%d AttackMod=%d",
      tostring(state.species), state.special, state.attackModifier)
    return true
  end

  local function captureCurrentEnemy(battle)
    return battle and battle.enemy and captureEnemy(battle.enemy) or false
  end

  function Memory:reset(reason)
    state.battle = nil
    state.special = 0
    state.attackModifier = 0
    state.species = nil
    logger:log("VOLATILE ENEMY MEMORY CLEARED",
      "reason=" .. logger:safeField(reason or "reset")
        .. " persisted=false special=0 attackMod=0")
  end

  function Memory:abandonBattle()
    state.battle = nil
  end

  function Memory:getSpecial()
    return state.special
  end

  function Memory:getAttackModifier()
    return state.attackModifier
  end

  function Memory:getSpecies()
    return state.species
  end

  function Memory:isAttackModifierValid()
    local value = tonumber(state.attackModifier)
    return value ~= nil and value >= 1 and value <= 13
  end

  function Memory:setSpecial(value, species)
    state.special = math.floor(tonumber(value) or 0) % 256
    if species ~= nil then state.species = species end
    return state.special
  end

  function Memory:setAttackModifier(value)
    state.attackModifier = math.max(1, math.min(13,
      math.floor(tonumber(value) or 7)))
    return state.attackModifier
  end

  function Memory:beginBattle(ev, trainerFlyActive)
    state.battle = ev and ev.battle or nil
    state.special = nil
    state.attackModifier = nil
    state.species = nil
    captureCurrentEnemy(state.battle)
    logger:log("VOLATILE ENEMY MEMORY TRACKING",
      "kind=" .. logger:safeField(ev and ev.kind)
        .. " special=" .. logger:safeField(state.special)
        .. " attackMod=" .. logger:safeField(state.attackModifier)
        .. " species=" .. logger:safeField(state.species)
        .. " trainerFlyActive=" .. logger:safeField(
          trainerFlyActive == true))
  end

  function Memory:captureTurn(ev)
    if ev and ev.battle == state.battle then
      captureCurrentEnemy(ev.battle)
    end
  end

  function Memory:captureSwitched(ev)
    if ev and ev.battle == state.battle then captureEnemy(ev.battler) end
  end

  function Memory:captureFainted(ev)
    if ev and ev.battle == state.battle then captureEnemy(ev.battler) end
  end

  function Memory:finishBattle(ev)
    if not ev or ev.battle ~= state.battle then return nil end
    captureCurrentEnemy(ev.battle)

    -- The original capture path restores a transformed Ditto's underlying
    -- calculated Special and neutral Attack modifier.
    if ev.result == "caught" and ev.battle.enemy then
      captureEnemy(ev.battle.enemy, true)
      logger:log("TRAINER-FLY CAUGHT ENEMY RESET",
        "species=" .. logger:safeField(state.species)
          .. " special=" .. logger:safeField(state.special)
          .. " attackMod=" .. logger:safeField(state.attackModifier))
    end

    local snapshot = {
      special = state.special,
      attackModifier = state.attackModifier,
      species = state.species,
      result = ev.result,
      qualifyingTrainer = ev.battle and ev.battle.trainer ~= nil,
    }
    logger:log("VOLATILE ENEMY MEMORY COMMITTED",
      "species=" .. logger:safeField(snapshot.species)
        .. " special=" .. logger:safeField(snapshot.special)
        .. " attackMod=" .. logger:safeField(snapshot.attackModifier)
        .. " result=" .. logger:safeField(snapshot.result)
        .. " runtimeOnly=true")
    state.battle = nil
    return snapshot
  end

  return Memory
end
