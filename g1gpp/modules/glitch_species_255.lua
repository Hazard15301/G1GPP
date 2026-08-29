-- Safe visible portion of 'M (FF)'s original party-menu behavior.
-- It keeps the genuine icon and blank displayed row name, but deliberately
-- does not hide other party members or interfere with healing/save data.
return function(ctx)
  local logger = assert(ctx and ctx.logger, "species 255 needs logger")
  local PartyMenu = require("src.ui.PartyMenu")
  if not PartyMenu._g1gpp255OriginalDraw then
    PartyMenu._g1gpp255OriginalDraw = PartyMenu.draw
  end
  PartyMenu.draw = function(menu)
    local party = menu.party or (menu.game and menu.game.save
      and menu.game.save.party) or {}
    local changed = {}
    for _, mon in ipairs(party) do
      if mon.species == "TF_GLITCH_255" then
        changed[#changed + 1] = {mon=mon, nickname=mon.nickname}
        mon.nickname = ""
      end
    end
    local ok, err = pcall(PartyMenu._g1gpp255OriginalDraw, menu)
    for _, row in ipairs(changed) do row.mon.nickname = row.nickname end
    if not ok then error(err, 0) end
    if #changed > 0 then
      logger:log("SPECIES 255 PARTY PRESENTATION",
        "blankName=true genuineIcon=true partyMutation=false")
    end
  end
  return true
end
