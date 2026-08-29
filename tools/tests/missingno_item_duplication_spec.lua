local root = assert(arg[1], "repository root argument required")

local version = "blue"
package.preload["src.core.GameVersion"] = function()
  return { get = function() return version end }
end

local events = {}
local mod = { events = { on = function(_, name, callback)
  events[name] = callback
end } }
local logs = {}
local logger = {
  safeField = function(_, value) return tostring(value) end,
  log = function(_, name, details)
    logs[#logs + 1] = name .. " " .. tostring(details)
  end,
}
local Bag = { order = function(save) return save.bagOrder end }
local game = {
  save = {
    inventory = {
      POTION = 1, ANTIDOTE = 2, POKE_BALL = 3,
      ESCAPE_ROPE = 4, REPEL = 5, BICYCLE = 1,
    },
    bagOrder = {
      "POTION", "ANTIDOTE", "POKE_BALL",
      "ESCAPE_ROPE", "REPEL", "BICYCLE",
    },
  },
  data = { items = { BICYCLE = { keyItem = true } } },
}

local controller = assert(loadfile(root
  .. "/g1gpp/modules/missingno_item_duplication.lua"))()({
    mod = mod, logger = logger, Bag = Bag,
    getGame = function() return game end,
  })

assert(controller.isOrdinaryMissingNo("TF_GLITCH_031"))
assert(controller.isOrdinaryMissingNo("TF_GLITCH_181"))
assert(not controller.isOrdinaryMissingNo("TF_GLITCH_000"))
assert(not controller.isOrdinaryMissingNo("TF_GLITCH_182"))
assert(controller.isDuplicationSpecies("TF_GLITCH_000"))
assert(controller.isDuplicationSpecies("TF_GLITCH_031"))
assert(controller.isDuplicationSpecies("TF_GLITCH_182"))
assert(controller.isDuplicationSpecies("TF_GLITCH_183"))
assert(controller.isDuplicationSpecies("TF_GLITCH_184"))
assert(controller.isSpecialMissingNo("TF_GLITCH_182"))
assert(not controller.isDuplicationSpecies("TF_GLITCH_227"))

local battle = {}
events["battle.started"]({ battle = battle, species = "TF_GLITCH_031" })
assert(game.save.inventory.BICYCLE == 129,
  "sixth key-item quantity 1 must become 129")
assert(logs[#logs]:find("quantityHidden=true", 1, true))
assert(logs[#logs]:find("operation=set_bit_7", 1, true))

events["battle.started"]({ battle = battle, species = "TF_GLITCH_031" })
assert(game.save.inventory.BICYCLE == 129)
events["battle.started"]({ battle = {}, species = "TF_GLITCH_050" })
assert(game.save.inventory.BICYCLE == 129)

game.save.bagOrder[6] = "RARE_CANDY"
game.save.inventory.RARE_CANDY = 20
events["battle.started"]({ battle = {}, species = "TF_GLITCH_000" })
assert(game.save.inventory.RARE_CANDY == 148)

game.save.inventory.RARE_CANDY = 20
events["battle.started"]({ battle = {}, species = "TF_GLITCH_095" })
assert(game.save.inventory.RARE_CANDY == 148)

game.save.inventory.RARE_CANDY = 20
events["battle.started"]({ battle = {}, species = "TF_GLITCH_184" })
assert(game.save.inventory.RARE_CANDY == 148)

game.save.bagOrder = { "POTION", "ANTIDOTE", "POKE_BALL" }
events["battle.started"]({ battle = {}, species = "TF_GLITCH_127" })
assert(game.save.inventory.POTION == 1)
assert(logs[#logs]:find("fewer_than_six_items", 1, true))

game.save.bagOrder = {
  "POTION", "ANTIDOTE", "POKE_BALL",
  "ESCAPE_ROPE", "REPEL", "RARE_CANDY",
}
game.save.inventory.RARE_CANDY = 20
events["battle.started"]({ battle = {}, species = "TF_GLITCH_227" })
events["battle.started"]({ battle = {}, species = "TENTACOOL" })
assert(game.save.inventory.RARE_CANDY == 20)
version = "yellow"
events["battle.started"]({ battle = {}, species = "TF_GLITCH_031" })
assert(game.save.inventory.RARE_CANDY == 20)

print("PASS: MissingNo sixth-item bit-7 duplication")
