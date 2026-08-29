local root = assert(arg[1], "repository root argument required")

local events = {}
local pages = {}
local mod = {
  events = { on = function(_, name, callback) events[name] = callback end },
  content = { font = { register = function(_, id, def)
    pages[id] = def
  end } },
}
local logs = {}
local logger = {
  safeField = function(_, value) return tostring(value) end,
  log = function(_, name, details)
    logs[#logs + 1] = name .. " " .. tostring(details)
  end,
}
local game = {
  overworld = {
    map = { id = "MT_MOON_1F", def = { tileset = "CAVERN" } },
  },
  save = {
    player = { map = "CINNABAR_ISLAND" },
    inventory = { RARE_CANDY = 129, POTION = 99 },
  },
  data = { maps = { CINNABAR_ISLAND = { tileset = "OVERWORLD" } } },
}

local controller = assert(loadfile(root
  .. "/g1gpp/modules/missingno_item_quantity_display.lua"))()({
    mod = mod, logger = logger, getGame = function() return game end,
  })

assert(pages.g1gpp_item_quantity_overworld)
assert(#pages.g1gpp_item_quantity_overworld.charmap == 16)
local expectedTilesetPages = {
  cavern = "cavern", cemetery = "cemetery", club = "club",
  dojo = "gym", facility = "facility", forest = "forest",
  forest_gate = "gate", gate = "gate", gym = "gym", house = "house",
  interior = "interior", lab = "lab", lobby = "lobby",
  mansion = "mansion", mart = "pokecenter", museum = "gate",
  overworld = "overworld", plateau = "plateau",
  pokecenter = "pokecenter", reds_house_1 = "reds_house",
  reds_house_2 = "reds_house", ship = "ship", ship_port = "ship_port",
  underground = "underground", beach_house = "beach_house",
}
for logical, page in pairs(expectedTilesetPages) do
  assert(controller.tilesetPages[logical] == page,
    "missing or incorrect tileset mapping: " .. logical)
  game.overworld.map.def.tileset = logical:upper()
  local gotPage, _, gotSource, gotLogical = controller.activeTileset(game)
  assert(gotPage == page, logical .. " selected " .. tostring(gotPage))
  assert(gotSource == "active_map")
  assert(gotLogical == logical)
end
game.overworld.map.def.tileset = "CAVERN"
local tileset, mapId, source, logical = controller.activeTileset(game)
assert(tileset == "cavern")
assert(mapId == "MT_MOON_1F")
assert(source == "active_map")
assert(logical == "cavern")
game.overworld = nil
tileset, mapId, source = controller.activeTileset(game)
assert(tileset == "overworld")
assert(mapId == "CINNABAR_ISLAND")
assert(source == "saved_map")
game.overworld = {
  map = { id = "MT_MOON_1F", def = { tileset = "CAVERN" } },
}
assert(controller.displayCount(99, "overworld") == "99")
assert(controller.displayCount(129, "overworld")
  == "<G1GPPQ_overworld_02>9")
assert(controller.displayCount(148, "overworld")
  == "<G1GPPQ_overworld_04>8")
assert(controller.displayCount(255, "overworld")
  == "<G1GPPQ_overworld_0F>5")

local updates = 0
local state = {
  kind = "bag", itemBox = true,
  items = {
    { value = "RARE_CANDY", right = "x129" },
    { value = "POTION", right = "x99" },
    { cancel = true, label = "CANCEL" },
  },
  update = function() updates = updates + 1 end,
}
events["screen.pushed"]({ state = state })
assert(state.items[1].right == "x<G1GPPQ_cavern_02>9")
assert(state.items[2].right == "x99")
assert(state._g1gppQuantityDisplayWrapped)
assert(logs[#logs]:find("saveMutation=false", 1, true))
assert(logs[#logs]:find("map=MT_MOON_1F", 1, true))
assert(logs[#logs]:find("mapTileset=cavern", 1, true))
assert(logs[#logs]:find("glyphPage=cavern", 1, true))
assert(logs[#logs]:find("tilesetSource=active_map", 1, true))

-- BagMenu can rebuild its rows after a swap/toss.  The wrapped update must
-- reapply the two-cell presentation without touching the stored quantity.
state.items[1].right = "x129"
state:update(0)
assert(updates == 1)
assert(state.items[1].right == "x<G1GPPQ_cavern_02>9")
assert(game.save.inventory.RARE_CANDY == 129)

print("PASS: MissingNo original-style item quantity display")
