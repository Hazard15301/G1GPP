local root = assert(arg[1], "repository root argument required")

local function equal(actual, expected, label)
  assert(actual == expected,
    (label or "value") .. ": expected " .. tostring(expected)
      .. ", got " .. tostring(actual))
end

local wall, mono = 1000, 0
local stored
local events, hooks = {}, {}
local played = {}
local logs = {}

local mod = {
  id = "g1gpp",
  storage = {
    read = function() return stored, stored and "ok" or "missing" end,
    write = function(_, _, _, value)
      stored = value
      return true, "ok"
    end,
  },
  events = { on = function(_, name, callback) events[name] = callback end },
  hooks = { wrap = function(_, name, callback) hooks[name] = callback end },
}
local logger = {
  safeField = function(_, value) return tostring(value) end,
  log = function(_, name, detail) logs[#logs + 1] = name .. " " .. detail end,
}
local Sound = {
  play = function(_, name) played[#played + 1] = name end,
}
local musicPlayed, musicRestored = {}, 0
local Music = {
  play = function(_, song, loop, context)
    musicPlayed[#musicPlayed + 1] = {
      song = song, loop = loop, reason = context and context.reason,
    }
  end,
  restoreMap = function()
    musicRestored = musicRestored + 1
  end,
}
local TextBox = {
  new = function(_, text, onDone) return { text = text, onDone = onDone } end,
}
local originalCalls = 0
local OverworldState = {}
function OverworldState:openPC(onDone)
  originalCalls = originalCalls + 1
  Sound.play(game.data, "Turn_On_PC")
  game.stack:push(TextBox.new(game, "PLAYER turned on\nthe PC.", onDone))
end

local stack = { states = {} }
function stack:push(state) self.states[#self.states + 1] = state end
function stack:pop() return table.remove(self.states) end
function stack:top() return self.states[#self.states] end

game = {
  data = {
    field = {}, sprites = {},
    font = { charmap = { { code = 0xEA, seq = "%" } } },
  },
  save = { player = { name = "RED" } },
  stack = stack,
}
local overworld = setmetatable({
  map = { def = { tileset = "POKECENTER" } },
}, { __index = OverworldState })
game.overworld = overworld
stack:push(overworld)

local factory = assert(loadfile(
  root .. "/g1gpp/modules/snake_pc_minigame.lua"))()
local fontInvalidations = 0
local api = factory({
  mod = mod,
  logger = logger,
  getGame = function() return game end,
  TextBox = TextBox,
  OverworldState = OverworldState,
  Sound = Sound,
  Music = Music,
  Font = {
    width = function(text) return #text * 8 end,
    invalidate = function() fontInvalidations = fontInvalidations + 1 end,
  },
  Theme = { cursor = 1 },
  Assets = { image = function() error("headless") end },
  FieldDefaults = { fieldValue = function() return "SPRITE_RED" end },
  SpriteRenderer = { new = function() error("headless") end },
  monotonic = function() return mono end,
  wallClock = function() return wall end,
  random = function(first) return first end,
})

events["game.ready"]({ game = game })
equal(api.controller.state.status, "locked", "Initial PC state")
equal(api.constants.requiredCycles, 10, "Ten-cycle trigger")
equal(game.data.font.pages.g1gppSnakePercent.charmap[1].code, 0x100,
  "Percent uses its generated private glyph page")
equal(game.data.font.pages.g1gppSnakePercent.charmap[1].seq, "%",
  "Generated glyph maps the percent character")
equal(#game.data.font.charmap, 0,
  "Incorrect legacy tile-EA percent mapping is removed")
equal(fontInvalidations, 1, "Font cache refreshes after percent registration")

for cycle = 1, 9 do
  OverworldState.openPC(overworld)
  api.controller:onSoundPlayed({ name = "Turn_Off_PC" })
  mono = mono + 1
  equal(api.controller.state.status, "locked", "Still locked before cycle ten")
end
OverworldState.openPC(overworld)
api.controller:onSoundPlayed({ name = "Turn_Off_PC" })
equal(api.controller.state.status, "checking", "Cycle ten arms diagnostic")
equal(stored.deadline, 1180, "Three-minute deadline persisted")

local callsBeforeCheck = originalCalls
OverworldState.openPC(overworld)
equal(originalCalls, callsBeforeCheck, "Checking PC refuses normal boot")
assert(stack:top().text:find("now\nchecking itself", 1, true),
  "First checking message is shown")

wall = 1090
OverworldState.openPC(overworld)
assert(stack:top().text:find("50%", 1, true),
  "Progress message reports elapsed percentage")

-- Restore the overworld as top to model closing the progress text.
stack.states = { overworld }
wall = 1180
hooks["input.step"](function() end, game, 1 / 60)
equal(api.controller.state.status, "ready", "Deadline reaches ready state")
equal(played[#played], "Turn_On_PC", "Completion cue plays in Center")

local soundsBeforeReveal = #played
OverworldState.openPC(overworld)
equal(api.controller.state.status, "unlocked", "First ready interaction unlocks")
equal(#played, soundsBeforeReveal, "Reveal suppresses duplicate boot sound")
assert(stack:top().text:find("new\noptions now", 1, true),
  "One-time reveal replaces normal boot message")

local rows = hooks["ui.pc.items"](
  function(_, items) return items end, game, { { label = "BILL'S PC" } })
equal(rows[#rows].label, "SNAKE.EXE",
  "Snake executable appended before engine LOG OFF")

-- Subsequent PC access uses the normal boot path again.
OverworldState.openPC(overworld)
equal(played[#played], "Turn_On_PC", "Normal boot sound restored")
assert(stack:top().text:find("turned on", 1, true),
  "Normal boot text restored")

local snake = api.SnakeState.new(api.controller, game)
equal(musicPlayed[#musicPlayed].song, "Music_MuseumGuy",
  "Snake uses the Follow Me theme")
equal(musicPlayed[#musicPlayed].loop, true,
  "Follow Me theme loops")
snake.titleParadeRightSteps = 1
snake:updateTitleParade(8 / 28)
equal(snake.titleParadeNodes[1].x, 0,
  "Title parade walks one complete tile to the right")
equal(snake.titleParadeNodes[2].x, -8,
  "Title parade follower takes the leader's prior tile")
equal(snake.titleParadeDirection, "up",
  "Title parade occasionally turns at a tile boundary")
snake:updateTitleParade(8 / 28)
equal(snake.titleParadeNodes[1].y, 32,
  "Title parade vertical movement is one complete tile")
equal(snake.titleParadeNodes[2].y, 40,
  "Title parade train follows the leader's exact path")
snake:startGame()
snake.candy = { x = 7, y = 7 }
snake:advance()
equal(snake.score, 5, "Rare Candy scores 5 points")
equal(#snake.segments, 2, "Rare Candy adds one Poké Ball segment")
equal(snake.candies, 1, "Candy counter increments")
snake.candy = { x = 8, y = 7 }
snake:advance()
equal(snake.speedSteps, 1, "Speed rises one step every two candies")
equal(snake.moveDelay, 0.212, "One speed step adjusts movement delay")
snake.candy = { x = 9, y = 7 }
snake:advance()
equal(snake.speedSteps, 1, "Third candy does not add another speed step")

snake.regularPointsTowardBonus = 45
snake.candy = { x = 10, y = 7 }
snake:advance()
equal(snake.regularPointsTowardBonus, 0,
  "Blue Candy milestone consumes 50 regular points")
assert(snake.bonusCandy, "A bonus Candy appears at the milestone")
equal(snake.bonusKind, "yellow",
  "Deterministic one-in-four roll can replace Blue with Yellow")
equal(snake.bonusTimer, 2.5, "Bonus Candy lasts two and a half seconds")

snake.speedSteps = 5
snake:updateMoveDelay()
local lengthBeforeBlue = #snake.segments
local scoreBeforeBlue = snake.score
snake.bonusCandy = { x = 11, y = 7 }
snake.bonusKind = "blue"
snake.candy = { x = 18, y = 14 }
snake:advance()
equal(snake.score, scoreBeforeBlue + 50, "Blue Candy scores 50 points")
equal(#snake.segments, lengthBeforeBlue - 1,
  "Blue Candy removes one Poké Ball segment")
equal(snake.speedSteps, 4, "Blue Candy lowers speed by one step")
equal(snake.regularPointsTowardBonus, 0,
  "Blue Candy points do not advance its next milestone")
equal(snake.blueCandies, 1, "Blue Candy counter increments")

snake.bonusCandy = { x = 12, y = 7 }
snake.bonusKind = "blue"
snake.bonusTimer = 0.1
snake:updateBonusCandy(0.2)
equal(snake.bonusCandy, nil, "Uncollected Blue Candy expires")

snake.segments = {
  { x = 11, y = 7 }, { x = 10, y = 7 }, { x = 9, y = 7 },
  { x = 8, y = 7 }, { x = 7, y = 7 }, { x = 6, y = 7 },
  { x = 5, y = 7 },
}
snake.speedSteps = 5
snake:updateMoveDelay()
snake.bonusCandy = { x = 12, y = 7 }
snake.bonusKind = "yellow"
snake.bonusTimer = 2.5
snake.candy = { x = 18, y = 14 }
local scoreBeforeYellow = snake.score
snake:advance()
equal(snake.score, scoreBeforeYellow + 50, "Yellow Candy scores 50 points")
equal(#snake.segments, 1, "Yellow Candy removes up to six Poké Balls")
equal(snake.speedSteps, 2, "Yellow Candy lowers speed by three steps")
equal(snake.yellowCandies, 1, "Yellow Candy counter increments")
snake:acceptDirection("left")
equal(snake.nextDirection, "right", "Immediate reversal is rejected")
stack:push(snake)
snake:close()
equal(musicRestored, 1, "Closing Snake restores map music")

api.controller:addHighScore(500)
api.controller:addHighScore(1200)
equal(api.controller.state.highScores[1].score, 1200,
  "High scores sort descending")
equal(api.controller.state.highScores[1].name, "RED",
  "High score records trainer name")

api.controller:resetForDebug(game)
equal(api.controller.state.status, "locked", "Debug reset relocks Snake")
equal(#api.controller.state.highScores, 0, "Debug reset clears high scores")
equal(stored.status, "locked", "Debug reset persists locked state")
equal(#stored.highScores, 0, "Debug reset persists empty scores")

print("PASS: ten-cycle PC diagnostic, persistent Snake unlock, and core game")
