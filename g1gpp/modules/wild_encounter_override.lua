-- Runtime-only wild encounter species override for repeatable debug testing.
-- The selected species remains active across battles until UNCHANGED is chosen
-- or the application process exits. Encounter level and all other rolled data
-- remain untouched.
return function(config)
  local mod = assert(config and config.mod,
    "wild encounter override requires mod")
  local logger = assert(config.debugLogger,
    "wild encounter override requires debugLogger")
  local ListMenu = assert(config.ListMenu,
    "wild encounter override requires ListMenu")

  local Override = {}
  local selectedSpecies = nil
  local selectedLabel = "UNCHANGED"

  local function speciesMenuItems(game)
    local items = {
      { label = "UNCHANGED", value = { species = nil, label = "UNCHANGED" } },
    }
    local ordered = {}
    local pokemon = game and game.data and game.data.pokemon or {}

    for key, definition in pairs(pokemon) do
      local dex = tonumber(definition and definition.dex)
      if dex and dex >= 1 and dex <= 151 then
        ordered[#ordered + 1] = {
          dex = math.floor(dex),
          species = definition.id or key,
          name = definition.name or definition.id or key,
        }
      end
    end

    table.sort(ordered, function(a, b)
      if a.dex ~= b.dex then return a.dex < b.dex end
      return tostring(a.species) < tostring(b.species)
    end)

    local seenDex = {}
    for _, entry in ipairs(ordered) do
      if not seenDex[entry.dex] then
        seenDex[entry.dex] = true
        local label = string.format("%03d %s", entry.dex,
          tostring(entry.name):upper())
        items[#items + 1] = {
          label = label,
          value = { species = entry.species, label = label, dex = entry.dex },
        }
      end
    end

    return items
  end

  function Override:getLabel()
    return selectedLabel
  end

  function Override:openMenu(game)
    if not (game and game.stack) then return false end
    local items = speciesMenuItems(game)
    logger:log("WILD ENCOUNTER OVERRIDE MENU OPENED",
      "choices=" .. logger:safeField(#items)
        .. " expected=152 current=" .. logger:safeField(selectedLabel))
    game.stack:push(ListMenu.new(game, "WILD POKEMON", items, {
      pageJump = true,
      keyRepeat = true,
      wrap = true,
      onChoose = function(item, list)
        local choice = item and item.value or nil
        if not choice then return end
        selectedSpecies = choice.species
        selectedLabel = choice.label or "UNCHANGED"
        list:close()
        logger:log("WILD ENCOUNTER OVERRIDE SELECTED",
          "species=" .. logger:safeField(selectedSpecies)
            .. " dex=" .. logger:safeField(choice.dex)
            .. " label=" .. logger:safeField(selectedLabel)
            .. " persistentUntilUnchanged=true saved=false")
      end,
    }))
    return true
  end

  function Override:decorateRow(row, manager)
    row.step = nil
    row.value = function() return self:getLabel() end
    row.activate = function() self:openMenu(manager.game) end
  end

  mod.hooks:wrap("encounter.species", function(next, encounter, context)
    local resolved = next(encounter, context)
    if not resolved or not selectedSpecies then return resolved end

    local changed = {}
    for key, value in pairs(resolved) do changed[key] = value end
    local originalSpecies = changed.species
    changed.species = selectedSpecies
    logger:log("WILD ENCOUNTER OVERRIDE APPLIED",
      "originalSpecies=" .. logger:safeField(originalSpecies)
        .. " selectedSpecies=" .. logger:safeField(selectedSpecies)
        .. " level=" .. logger:safeField(changed.level)
        .. " map=" .. logger:safeField(context and context.mapId)
        .. " terrain=" .. logger:safeField(context and context.terrain)
        .. " remainsActive=true")
    return changed
  end)

  return Override
end
