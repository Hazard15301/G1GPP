-- Red/Blue MissingNo. sixth-item duplication.
--
-- Loading an ordinary MissingNo. front picture on the original games sets
-- bit 7 of the sixth Bag quantity byte. Gen1Recomp keeps inventory in a safe
-- Lua table, so reproduce that one observable write without exposing adjacent
-- memory or permitting broader save corruption. Key-item and HM quantities
-- are intentionally included; their Bag rows hide the quantity just as the
-- original UI does.
return function(config)
  local mod = assert(config and config.mod,
    "MissingNo item duplication requires mod")
  local logger = assert(config.logger,
    "MissingNo item duplication requires logger")
  local Bag = assert(config.Bag, "MissingNo item duplication requires Bag")
  local getGame = assert(config.getGame,
    "MissingNo item duplication requires game accessor")
  local GameVersion = require("src.core.GameVersion")

  local ordinary = {
    [31] = true, [32] = true, [50] = true, [52] = true,
    [56] = true, [61] = true, [62] = true, [63] = true,
    [67] = true, [68] = true, [69] = true, [79] = true,
    [80] = true, [81] = true, [86] = true, [87] = true,
    [94] = true, [95] = true, [115] = true, [121] = true,
    [122] = true, [127] = true, [134] = true, [135] = true,
    [137] = true, [140] = true, [146] = true, [156] = true,
    [159] = true, [160] = true, [161] = true, [162] = true,
    [172] = true, [174] = true, [175] = true, [181] = true,
  }
  local specialMissingNo = {
    [182] = true, -- Kabutops fossil
    [183] = true, -- Aerodactyl fossil
    [184] = true, -- Pokemon Tower Ghost
  }

  local function supportedEdition()
    local id = GameVersion.get()
    return id == "red" or id == "blue"
  end

  local function duplicationIndex(species)
    if type(species) ~= "string" then return nil end
    local index = tonumber(species:match("^TF_GLITCH_(%d%d%d)$"))
    -- 'M (00) shares MissingNo.'s invalid Pokédex flag and duplicates the
    -- sixth item too. It is a distinct glitch species, so keep it out of the
    -- ordinary-form table while accepting it at this effect boundary.
    if index == 0
       or (index and (ordinary[index] or specialMissingNo[index])) then
      return index
    end
    return nil
  end

  local function apply(battle, species)
    local index = duplicationIndex(species)
    if not index or not supportedEdition() then return false end
    if battle and battle._g1gppMissingNoItemDuplicationApplied then
      return false
    end
    if battle then battle._g1gppMissingNoItemDuplicationApplied = true end

    local game = getGame()
    local save = game and game.save
    local inventory = save and save.inventory
    if type(inventory) ~= "table" then
      logger:log("MISSINGNO ITEM DUPLICATION SKIPPED",
        "index=" .. logger:safeField(index)
          .. " reason=inventory_unavailable")
      return false
    end

    local order = Bag.order(save, game.data)
    local item = order and order[6]
    if not item then
      logger:log("MISSINGNO ITEM DUPLICATION SKIPPED",
        "index=" .. logger:safeField(index)
          .. " reason=fewer_than_six_items slots="
          .. logger:safeField(order and #order or 0))
      return false
    end

    local before = tonumber(inventory[item])
    if not before or before < 1 or before > 255
       or before ~= math.floor(before) then
      logger:log("MISSINGNO ITEM DUPLICATION SKIPPED",
        "index=" .. logger:safeField(index)
          .. " item=" .. logger:safeField(item)
          .. " quantity=" .. logger:safeField(before)
          .. " reason=quantity_outside_byte_range")
      return false
    end

    local after = before < 128 and before + 128 or before
    inventory[item] = after
    local def = game.data and game.data.items and game.data.items[item]
    local hidden = (def and def.keyItem == true)
      or item:find("^HM_") ~= nil
    logger:log("MISSINGNO ITEM DUPLICATION APPLIED",
      "index=" .. logger:safeField(index)
        .. " item=" .. logger:safeField(item)
        .. " before=" .. logger:safeField(before)
        .. " after=" .. logger:safeField(after)
        .. " quantityHidden=" .. logger:safeField(hidden)
        .. " operation=set_bit_7 saveMutation=sixth_item_only")
    return true
  end

  mod.events:on("battle.started", function(ev)
    if not ev then return end
    apply(ev.battle, ev.species)
  end)

  return {
    applyForTest = apply,
    isOrdinaryMissingNo = function(species)
      local index = type(species) == "string"
        and tonumber(species:match("^TF_GLITCH_(%d%d%d)$")) or nil
      return index ~= nil and ordinary[index] == true
    end,
    isDuplicationSpecies = function(species)
      return duplicationIndex(species) ~= nil
    end,
    isSpecialMissingNo = function(species)
      local index = type(species) == "string"
        and tonumber(species:match("^TF_GLITCH_(%d%d%d)$")) or nil
      return index ~= nil and specialMissingNo[index] == true
    end,
  }
end
