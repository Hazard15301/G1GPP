-- Original-style display for Red/Blue Bag quantities above 99.
--
-- The original PrintNumber owns only two quantity cells.  For 100..255 its
-- tens value runs beyond digit 9 and wraps from font tile $f6 into live BG
-- tile ids $00..$0f; the final decimal digit remains ordinary.  Gen1Recomp
-- stores the safe byte-wide count correctly but normally prints all three
-- decimal digits, which overwrites the quantity marker.  This module changes
-- only each open Bag row's presentation and never changes inventory data.
return function(config)
  local mod = assert(config and config.mod,
    "MissingNo quantity display requires mod")
  local logger = assert(config.logger,
    "MissingNo quantity display requires logger")
  local getGame = assert(config.getGame,
    "MissingNo quantity display requires game accessor")

  -- Map definitions use logical Gen I tileset IDs, several of which share
  -- the same extracted image.  Keep that distinction explicit so every
  -- Red/Blue/Yellow map selects the correct player-derived glyph page.
  local tilesetPages = {
    overworld = "overworld",
    plateau = "plateau",
    gym = "gym",
    dojo = "gym",
    facility = "facility",
    interior = "interior",
    cavern = "cavern",
    forest = "forest",
    forest_gate = "gate",
    house = "house",
    gate = "gate",
    underground = "underground",
    ship = "ship",
    ship_port = "ship_port",
    cemetery = "cemetery",
    lobby = "lobby",
    mansion = "mansion",
    lab = "lab",
    club = "club",
    reds_house_1 = "reds_house",
    reds_house_2 = "reds_house",
    pokecenter = "pokecenter",
    mart = "pokecenter",
    museum = "gate",
    beach_house = "beach_house",
  }
  local glyphPages = {
    "overworld", "plateau", "gym", "facility", "interior", "cavern",
    "forest", "house", "gate", "underground", "ship", "ship_port",
    "cemetery", "lobby", "mansion", "lab", "club", "reds_house",
    "pokecenter", "beach_house",
  }
  local known = {}
  local tokens = {}
  local BASE = 0xD000
  for pageIndex, name in ipairs(glyphPages) do
    known[name] = true
    tokens[name] = {}
    local charmap = {}
    local base = BASE + (pageIndex - 1) * 0x20
    for tile = 0, 15 do
      local token = ("<G1GPPQ_%s_%02X>"):format(name, tile)
      tokens[name][tile] = token
      charmap[#charmap + 1] = { seq = token, code = base + tile }
    end
    mod.content.font:register("g1gpp_item_quantity_" .. name, {
      image = "save/mod-derived/g1gpp/fonts/"
        .. "g1gpp_item_quantity_" .. name .. ".png",
      base = base,
      glyphsPerRow = 16,
      charmap = charmap,
    })
  end

  local function activeTileset(game)
    -- save.player.map is only refreshed when the overworld is captured for a
    -- save/checkpoint.  Immediately after an ordinary door transition it can
    -- still name the exterior map, so prefer the live overworld instance.
    local world = game and (game.overworld or game.world)
    local activeMap = world and world.map
    local mapId = activeMap and activeMap.id
    local mapDef = activeMap and activeMap.def
    local source = mapDef and "active_map" or nil
    if not mapDef then
      local save = game and game.save
      mapId = save and save.player and save.player.map
      mapDef = game and game.data and game.data.maps
        and game.data.maps[mapId]
      source = mapDef and "saved_map" or "fallback"
    end
    local logical = mapDef and mapDef.tileset
    logical = type(logical) == "string" and logical:lower() or "overworld"
    local page = tilesetPages[logical]
    if not page then
      page = "overworld"
      source = source .. "_unknown_tileset"
    end
    return page, mapId, source, logical
  end

  local function displayCount(count, tileset)
    count = tonumber(count)
    if not count or count < 100 or count > 255
       or count ~= math.floor(count) then
      return count and tostring(count) or nil
    end
    tileset = known[tileset] and tileset or "overworld"
    -- ($f6 + floor(count / 10)) & $ff = $00..$0f for 100..255.
    local tile = math.floor(count / 10) - 10
    return tokens[tileset][tile] .. tostring(count % 10)
  end

  local function formatBagRows(state)
    if not (state and state.itemBox and state.kind == "bag"
       and type(state.items) == "table") then return false end
    local game = getGame()
    local inventory = game and game.save and game.save.inventory
    if type(inventory) ~= "table" then return false end
    local tileset = activeTileset(game)
    local changed = false
    for _, item in ipairs(state.items) do
      if item and item.value and item.right then
        local count = inventory[item.value]
        if type(count) == "number" and count >= 100 and count <= 255 then
          item.right = "x" .. displayCount(count, tileset)
          changed = true
        end
      end
    end
    return changed
  end

  mod.events:on("screen.pushed", function(ev)
    local state = ev and ev.state
    if not (state and state.itemBox and state.kind == "bag") then return end
    formatBagRows(state)
    if state._g1gppQuantityDisplayWrapped then return end
    state._g1gppQuantityDisplayWrapped = true
    local baseUpdate = state.update
    if type(baseUpdate) == "function" then
      state.update = function(self, dt)
        baseUpdate(self, dt)
        formatBagRows(self)
      end
    end
    local tileset, mapId, source, logical = activeTileset(getGame())
    logger:log("MISSINGNO QUANTITY DISPLAY ACTIVE",
      "mode=gen1_two_cell map="
        .. logger:safeField(mapId)
        .. " mapTileset="
        .. logger:safeField(logical)
        .. " glyphPage="
        .. logger:safeField(tileset)
        .. " tilesetSource="
        .. logger:safeField(source)
        .. " saveMutation=false")
  end)

  return {
    displayCount = displayCount,
    formatBagRows = formatBagRows,
    activeTileset = activeTileset,
    tilesetPages = tilesetPages,
  }
end
