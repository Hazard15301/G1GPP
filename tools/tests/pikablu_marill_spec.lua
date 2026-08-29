local root = assert(arg[1], "repository root required")
package.path = root .. "/?.lua;" .. package.path

package.loaded["src.render.Assets"] = {
  exists = function(path) return path:match("^save/mod%-derived/") ~= nil end,
}
package.loaded["src.core.GameVersion"] = {
  isYellow = function() return false end,
  get = function() return "red" end,
}
package.loaded["src.render.TextBox"] = {
  new = function(_, text, onDone) return { text = text, onDone = onDone } end,
}
local soundCalls = {}
package.loaded["src.core.Sound"] = {
  play = function(_, soundId)
    local source = { volume = 0.4 }
    function source:getVolume() return self.volume end
    function source:setVolume(value) self.volume = value end
    soundCalls[#soundCalls + 1] = { id = soundId, source = source }
    return source
  end,
  playCry = function() end,
}
package.loaded["src.pokemon.Pokemon"] = {
  new = function(_, species, level) return { species = species, level = level } end,
}
package.loaded["src.script.Commands"] = {
  hide_object = function() end,
}
package.loaded["src.script.MapScripts"] = {
  baseTalk = function() return { { "trade", 8 } } end,
}
package.loaded["src.world.OverworldController"] = {
  billsHousePC = function() return "base" end,
}
package.loaded["src.ui.PokedexMenu"] = {
  new = function() return { items = {} } end,
}
local pushedScreens = {}
package.loaded["src.ui.Screens"] = {
  push = function(_, id, species, onDone)
    pushedScreens[#pushedScreens + 1] = { id = id, species = species }
    if onDone then onDone() end
  end,
}

local captured = {}
local function registry(name)
  return {
    register = function(_, id, value)
      captured[name] = captured[name] or {}
      captured[name][id] = value
    end,
    patch = function(_, id, value)
      captured[name] = captured[name] or {}
      captured[name][id] = value
    end,
  }
end

local content = {}
for _, name in ipairs({ "move_effects", "moves", "constants", "text",
                        "cries", "pokemon", "maps", "map_scripts",
                        "commands" }) do
  content[name] = registry(name)
end
local musicVolumeHook
local mod = {
  id = "g1gpp", content = content,
  hooks = {
    wrap = function(_, name, fn)
      if name == "music.volume" then musicVolumeHook = fn end
    end,
  },
}
local install = assert(loadfile(root .. "/g1gpp/modules/pikablu_marill.lua"))()
local result = install({ mod = mod, logger = { log = function() end } })

assert(result.enabled
  and result.sourceVersion == "gold_silver_or_crystal_bootstrap")
local marill = assert(captured.pokemon.MARILL)
assert(marill.dex == 152 and marill.baseStats.special == 50)
assert(marill.learnset[7].move == "RAIN_DANCE")
assert(marill.spriteFront == "save/mod-derived/g1gpp/battle/front/g1gpp_marill.png")
assert(marill.spriteBack == "save/mod-derived/g1gpp/battle/back/g1gpp_marill_back.png")
assert(captured.cries.MARILL.base == "PIKACHU")
assert(marill.icon == "FAIRY")
assert(marill.palette == "CYANMON")
assert(marill.tmhm[#marill.tmhm - 1] == "SURF")
for _, move in ipairs(marill.tmhm) do assert(move ~= "FLY") end
local garden = assert(captured.maps.G1GPP_BILLS_GARDEN)
assert(garden.width == 8 and garden.height == 7 and #garden.blocks == 56)
assert(garden.borderBlock == 44)
assert(garden.label == "Bill's Secret Garden")
assert(garden.objects[1].x == 7 and garden.objects[1].y == 5)
assert(garden.objects[2].x == 8 and garden.objects[2].y == 13)
assert(garden.warps[1].x == 6 and garden.warps[4].x == 9)
assert(garden.warps[1].y == 13 and garden.warps[4].y == 13)
-- Route 25's pale block 1 is the ground directly behind Bill's house. Keep
-- that surface across all four exit cells so the opening remains legible
-- against Gen1Recomp's out-of-bounds tree fill.
assert(garden.blocks[52] == 1 and garden.blocks[53] == 1)
-- The four-cell entrance and the route directly below Marill stay on
-- verified walkable lawn. Flowers/shrubs dress both sides without blocking
-- the central approach, while Route 25 mountain blocks enclose the edge.
for _, cell in ipairs({ {8,12}, {8,11}, {8,10}, {8,9}, {8,8},
                         {8,7}, {8,6}, {7,6} }) do
  local bx, by = math.floor(cell[1] / 2), math.floor(cell[2] / 2)
  local block = garden.blocks[by * garden.width + bx + 1]
  assert(block == 1 or block == 10 or block == 11)
end
local flowerCount, shrubCount = 0, 0
for _, block in ipairs(garden.blocks) do
  if block == 116 then flowerCount = flowerCount + 1 end
  if block == 96 or block == 109 then shrubCount = shrubCount + 1 end
end
assert(flowerCount >= 6 and shrubCount >= 3)

-- Every Marill message is its own acknowledged TextBox.  No branch may use
-- form-feed auto-continuations or a third line that scrolls out of view.
local gardenScript = assert(captured.map_scripts.G1GPP_BILLS_GARDEN)
local marillPages, marillDone = {}, 0
local marillGame = {
  data = {},
  save = {
    modData = {}, party = {}, pokedex = { seen = {}, owned = {} },
  },
}
marillGame.stack = {
  push = function(_, box)
    marillPages[#marillPages + 1] = box.text
    if box.onDone then box.onDone() end
  end,
}
gardenScript.talk.TEXT_G1GPP_GARDEN_MARILL(marillGame, {}, {},
  function() marillDone = marillDone + 1 end)
assert(#marillPages == 9 and marillDone == 1)
assert(#marillGame.save.party == 1
  and marillGame.save.party[1].species == "MARILL")
assert(#pushedScreens == 1 and pushedScreens[1].id == "DexEntryMenu"
  and pushedScreens[1].species == "MARILL")
assert(soundCalls[#soundCalls].id == "Caught_Mon"
  and soundCalls[#soundCalls].source.volume == 0.8)
assert(marillPages[7] == "The new POKéMON,\nPIKAB- ..oops!")
assert(marillPages[8] == "MARILL, has joined")
assert(marillPages[9] == "you on your\njourney!")
for _, page in ipairs(marillPages) do
  assert(not page:find("\f", 1, true))
  local lines = 0
  for line in (page .. "\n"):gmatch("(.-)\n") do
    lines = lines + 1
    assert(#line <= 19)
  end
  assert(lines <= 2)
end
local dexText = assert(captured.text._G1GPPMarillDex)
local dexPages = 0
for page in (dexText .. "\f"):gmatch("(.-)\f") do
  dexPages = dexPages + 1
  local lines = 0
  for line in (page .. "\n"):gmatch("(.-)\n") do
    lines = lines + 1
    assert(#line <= 19)
  end
  assert(lines <= 3)
end
assert(dexPages == 2)

-- Crossing the garden exit after Marill joins closes the private door and
-- arms a one-shot repair for Bill's vanilla LAST_MAP exit.
marillGame.save.modData.g1gpp.pikablu.gardenOpened = true
assert(gardenScript.onStep(marillGame, {}, 8, 13) == false)
assert(not marillGame.save.modData.g1gpp.pikablu.gardenOpened)
assert(marillGame.save.modData.g1gpp.pikablu.returningFromGarden)

-- The deliberate public-ID migration preserves compatible state written by
-- private builds under the historical trainer_fly namespace.
local legacyRoot = { pikablu = { gardenOpened = true, marillJoined = true } }
local legacyGame = { save = { modData = { trainer_fly = legacyRoot } } }
assert(gardenScript.onStep(legacyGame, {}, 8, 13) == false)
assert(legacyGame.save.modData.g1gpp == legacyRoot)
assert(not legacyRoot.pikablu.gardenOpened)
assert(legacyRoot.pikablu.returningFromGarden)
assert(captured.moves.ROLLOUT and captured.moves.RAIN_DANCE)
assert(captured.constants.dexSize == 152)
assert(musicVolumeHook)
assert(musicVolumeHook(function(v) return v end, 0.35, {
  song = "Music_SafariZone", mapId = "CINNABAR_LAB_TRADE_ROOM",
}) == 0.7)
assert(musicVolumeHook(function(v) return v end, 0.35, {
  song = "Music_SafariZone", mapId = "SAFARI_ZONE_CENTER",
}) == 0.35)

-- A successful Red/Blue trade immediately arms Bill's lead, queues the
-- Eureka departure, and removes only the live scientist object.  No vanilla
-- object toggle is involved, so an unmodded load naturally restores him.
local room = assert(captured.map_scripts.CINNABAR_LAB_TRADE_ROOM)
local scientist = { def = { index = 2 }, cellX = 1, cellY = 4 }
local otherNpc = { def = { index = 3 } }
local queued
local doneCount = 0
local game = {
  save = {
    flags = {}, modData = {}, party = {},
    pokedex = { seen = {}, owned = {} },
  },
}
local ow = {
  npcs = { scientist, otherNpc },
  entities = { scientist, otherNpc },
  player = { cellX = 2, cellY = 4 },
  npcByIndex = function(self, index)
    for _, npc in ipairs(self.npcs) do
      if npc.def.index == index then return npc end
    end
  end,
  queueScript = function(_, script, extra)
    queued = { script = script, extra = extra }
  end,
}
ow.runner = {
  run = function(_, _, extra)
    game.save.flags.EVENT_TRADED_RAICHU_FOR_ELECTRODE = true
    extra.onDone()
  end,
}
room.talk.TEXT_CINNABARLABTRADEROOM_GRAMPS(game, ow, scientist,
  function() doneCount = doneCount + 1 end)
local pikabluState = game.save.modData.g1gpp.pikablu
assert(pikabluState.gardenLead and pikabluState.scientistLeft)
assert(queued and queued.script[1][1] == "stop_music")
assert(queued.script[2][1] == "emote")
assert(queued.script[3][1] == "play_music"
  and queued.script[3][2] == "Music_SafariZone")
assert(queued.script[4][1] == "wait" and queued.script[4][2] == 55)
assert(queued.script[5][1] == "play_default_music")
assert(queued.script[6][2] == "Wh.. Wh... What???")
assert(queued.script[7][2]:find("RAICHU is.....", 1, true))
assert(queued.script[8][2] == "Incredible!")
assert(queued.script[9][2]:find("My friend, BILL,", 1, true))
assert(queued.script[9][2] == "My friend, BILL,\nneeds to see this")
assert(queued.script[10][2] == "right away!")
assert(queued.script[11][1] == "walk_npc")
assert(table.concat(queued.script[11][3], ",") == "down,down,right,down")
assert(queued.script[12][1] == "g1gpp_boosted_door_sound")
assert(scientist.stepFrames == 16 and doneCount == 0)
queued.extra.onDone()
assert(#ow.npcs == 1 and ow.npcs[1] == otherNpc)
assert(#ow.entities == 1 and ow.entities[1] == otherNpc)
assert(doneCount == 1)

-- Re-entering with the private departure marker suppresses the scientist
-- again at runtime without writing save.objectToggles.
local restoredScientist = { def = { index = 2 } }
ow.npcs = { restoredScientist, otherNpc }
ow.entities = { restoredScientist, otherNpc }
room.onEnter(game, ow)
assert(#ow.npcs == 1 and ow.npcs[1] == otherNpc)
assert(game.save.objectToggles == nil)

-- The alternate legal approach (player directly below the scientist) makes
-- him sidestep before heading down instead of walking through the player.
local scientist2 = { def = { index = 2 }, cellX = 1, cellY = 4 }
local game2 = {
  save = {
    flags = { EVENT_TRADED_RAICHU_FOR_ELECTRODE = true },
    modData = {}, party = {}, pokedex = { seen = {}, owned = {} },
  },
}
local queued2
local ow2 = {
  npcs = { scientist2 }, entities = { scientist2 },
  player = { cellX = 1, cellY = 5 },
  npcByIndex = function() return scientist2 end,
  queueScript = function(_, script, extra)
    queued2 = { script = script, extra = extra }
  end,
}
room.talk.TEXT_CINNABARLABTRADEROOM_GRAMPS(game2, ow2, scientist2,
  function() end)
assert(table.concat(queued2.script[11][3], ",") == "right,down,down,down")

-- Bill's PC sequence replaces only the pipe half of block 5 with a private
-- single-width door.  Bill then leads tile-by-tile, the player stays one step
-- behind, and both disappear at the door before the warp.
local game3 = {
  save = {
    flags = { EVENT_GOT_SS_TICKET = true }, party = {},
    modData = { g1gpp = { pikablu = {
      gardenLead = true, notesRead = true,
    } } },
  },
}
local billPages = {}
game3.stack = {
  push = function(_, box)
    billPages[#billPages + 1] = box.text
    if box.onDone then box.onDone() end
  end,
}
package.loaded["src.core.Game"] = game3
local bill = {
  def = { index = 3, name = "BILLSHOUSE_BILL2" },
  cellX = 6, cellY = 5,
}
local queued3
local baseBillBlocks = { 4,5,6,7, 8,9,10,11, 1,2,14,14, 3,12,3,3 }
local baseInteriorBlocks = {}
for id = 0, 57 do
  local block = {}
  for i = 1, 16 do block[i] = id * 100 + i end
  baseInteriorBlocks[id + 1] = block
end
local baseInteriorTileset = { blocks = baseInteriorBlocks }
local ow3 = {
  map = { id = "BILLS_HOUSE", def = {
    width = 4, height = 4, blocks = baseBillBlocks,
  }, tileset = baseInteriorTileset }, npcs = { bill },
  entities = { bill },
  player = { cellX = 1, cellY = 5 },
  npcByIndex = function(self, index)
    for _, npc in ipairs(self.npcs) do
      if npc.def.index == index then return npc end
    end
  end,
  queueScript = function(_, script, extra)
    queued3 = { script = script, extra = extra }
  end,
  replaceBlock = function(self, bx, by, block)
    local width = self.map.def.width
    self.map.def.blocks[by * width + bx + 1] = block
  end,
  scriptMove = function(_, entity, dir, _, onDone)
    local delta = {
      up = { 0, -1 }, down = { 0, 1 },
      left = { -1, 0 }, right = { 1, 0 },
    }
    local d = assert(delta[dir])
    entity.cellX, entity.cellY = entity.cellX + d[1], entity.cellY + d[2]
    entity.px, entity.py = entity.cellX * 16, entity.cellY * 16
    if onDone then onDone() end
  end,
}
local Overworld = package.loaded["src.world.OverworldController"]
Overworld.billsHousePC(ow3)
assert(ow3.emote and ow3.emote.onDone)
ow3.emote.onDone()
assert(#billPages == 18)
for _, page in ipairs(billPages) do
  assert(not page:find("\f", 1, true))
  local lines = 0
  for line in (page .. "\n"):gmatch("(.-)\n") do
    lines = lines + 1
    assert(#line <= 19)
  end
  assert(lines <= 2)
end
assert(queued3 and queued3.script[1][1] == "walk_npc")
assert(queued3.script[5][1] == "replace_block"
  and queued3.script[5][4] == 58)
assert(queued3.script[9][1] == "replace_block"
  and queued3.script[9][4] == 59)
assert(#ow3.map.tileset.blocks == 60)
local sealed = ow3.map.tileset.blocks[59]
local doorway = ow3.map.tileset.blocks[60]
for row = 0, 3 do
  for col = 0, 3 do
    local i = row * 4 + col + 1
    assert(sealed[i] == (col < 2 and baseInteriorBlocks[6][i]
                                     or baseInteriorBlocks[35][i]))
    assert(doorway[i] == (col < 2 and baseInteriorBlocks[6][i]
                                      or baseInteriorBlocks[42][i]))
  end
end
assert(queued3.script[11][1] == "g1gpp_follow_bill_to_door"
  and queued3.script[11][2] == 3)
assert(queued3.script[12][1] == "g1gpp_boosted_door_sound")
assert(queued3.script[13][1] == "g1gpp_hide_door_actor"
  and queued3.script[13][2] == 3)
assert(queued3.script[14][1] == "walk_npc"
  and queued3.script[14][2] == "player"
  and queued3.script[14][3][1] == "up")
assert(queued3.script[15][1] == "g1gpp_boosted_door_sound")
assert(queued3.script[16][1] == "g1gpp_hide_door_actor"
  and queued3.script[16][2] == "player")
assert(queued3.script[17][1] == "warp"
  and queued3.script[17][2] == "G1GPP_BILLS_GARDEN"
  and queued3.script[17][3] == 8 and queued3.script[17][4] == 12)
assert(game3.save.modData.g1gpp.pikablu.gardenOpened)
assert(ow3.map.def.blocks ~= baseBillBlocks)
assert(baseBillBlocks[2] == 5 and baseBillBlocks[3] == 6)
assert(ow3.map.def.blocks[2] == 5 and ow3.map.def.blocks[3] == 6)
assert(ow3.map.tileset ~= baseInteriorTileset)
assert(#baseInteriorTileset.blocks == 58)

-- With a full party, Bill interrupts with an exclamation and a vague refusal
-- before either the door reveal or follow sequence can begin.
local fullPartyPages = {}
local fullPartyGame = {
  save = {
    flags = { EVENT_GOT_SS_TICKET = true },
    party = { {}, {}, {}, {}, {}, {} },
    modData = { g1gpp = { pikablu = {
      gardenLead = true, notesRead = true,
    } } },
  },
  stack = {
    push = function(_, box)
      fullPartyPages[#fullPartyPages + 1] = box.text
      if box.onDone then box.onDone() end
    end,
  },
}
package.loaded["src.core.Game"] = fullPartyGame
local soundsBeforeFullParty = #soundCalls
local fullPartyBill = {
  def = { index = 3, name = "BILLSHOUSE_BILL2" }, hidden = false,
}
local fullPartyOw = {
  map = { id = "BILLS_HOUSE" }, npcs = { fullPartyBill },
}
Overworld.billsHousePC(fullPartyOw)
assert(#fullPartyPages == 0)
assert(#soundCalls == soundsBeforeFullParty + 1
  and soundCalls[#soundCalls].id == "Press_AB")
assert(fullPartyOw.emote and fullPartyOw.emote.npc == fullPartyBill
  and fullPartyOw.emote.bubble == 1 and fullPartyOw.emote.frames == 20)
fullPartyOw.emote.onDone()
assert(#fullPartyPages == 2)
assert(fullPartyPages[1] == "...Hey bud, why\ndon't you come")
assert(fullPartyPages[2] == "back with a few\nless POKéMON?")
assert(not fullPartyGame.save.modData.g1gpp.pikablu.gardenOpened)
package.loaded["src.core.Game"] = game3

-- The paired follow command advances both actors in one uninterrupted chain
-- while keeping the player exactly one cell behind Bill.
bill.cellX, bill.cellY = 1, 5
ow3.player.cellX, ow3.player.cellY = 1, 6
local followResumes, followYields = 0, 0
captured.commands.g1gpp_follow_bill_to_door({
  overworld = ow3,
  runner = {
    resume = function() followResumes = followResumes + 1 end,
    yield = function() followYields = followYields + 1 end,
  },
}, 3)
assert(followResumes == 1 and followYields == 1)
assert(bill.cellX == 3 and bill.cellY == 0)
assert(ow3.player.cellX == 3 and ow3.player.cellY == 1)

-- The cutscene disappearance is runtime-only: no object toggle is written.
captured.commands.g1gpp_hide_door_actor({ overworld = ow3 }, 3)
assert(#ow3.npcs == 0 and #ow3.entities == 0)
captured.commands.g1gpp_hide_door_actor({ overworld = ow3 }, "player")
assert(ow3.playerHidden == true)
assert(game3.save.objectToggles == nil)

local returnState = game3.save.modData.g1gpp.pikablu
returnState.gardenOpened = true
returnState.returningFromGarden = true
-- Simulate returning on the same runtime map object that still contains the
-- visible private door from the reveal cutscene.
ow3.map.def.blocks[2] = ow3.map._g1gppDoorBlock
ow3.lastOutdoor = { id = "G1GPP_BILLS_GARDEN", x = 8, y = 13 }
game3.save.lastOutdoor = ow3.lastOutdoor
captured.map_scripts.BILLS_HOUSE.onEnter(game3, ow3)
assert(ow3.lastOutdoor.id == "ROUTE_25"
  and ow3.lastOutdoor.x == 45 and ow3.lastOutdoor.y == 3)
assert(game3.save.lastOutdoor.id == "ROUTE_25")
assert(not returnState.returningFromGarden and not returnState.gardenOpened)
assert(ow3.map.def.blocks[2] == 5)
assert(ow3.player.cellX == 3 and ow3.player.cellY == 2)
assert(ow3.player.px == 48 and ow3.player.py == 32)
assert(ow3.player.facing == "down" and ow3.playerHidden == false)

print("PASS: Pikablu/Marill registration and Gold gate")
