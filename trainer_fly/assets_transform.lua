return function(ctx)
  local tilesets = {
    "overworld", "plateau", "gym", "facility", "interior", "cavern",
    "forest", "house", "gate", "underground", "ship", "ship_port",
    "cemetery", "lobby", "mansion", "lab", "club", "reds_house",
    "pokecenter", "spinners", "flower1", "flower2", "flower3",
    "beach_house",
  }

  local font = ctx.readImage("fonts/font.png")
  local extra = ctx.readImage("fonts/font_extra.png")
  local fw, fh = font:getDimensions()
  local ew, eh = extra:getDimensions()

  for _, name in ipairs(tilesets) do
    local rel = "tilesets/" .. name .. ".png"
    if ctx.exists(rel) then
      local base = ctx.readImage(rel)
      local bw, bh = base:getDimensions()
      -- Preserve the source atlas width/ordering, then append both font pages
      -- in four opaque contrast themes. Every glyph tile owns its background;
      -- no transparent character can expose noisy terrain beneath it.
      local themes = {
        { bg = 1.00, ink = 0.00 },
        { bg = 0.67, ink = 0.00 },
        { bg = 0.33, ink = 1.00 },
        { bg = 0.00, ink = 1.00 },
      }
      local outW = math.max(bw, fw, ew)
      local outH = bh + (fh + eh) * #themes
      local out = ctx.blank(outW, outH, 1, 1, 1, 1)

      ctx.blit(out, base, 0, 0)
      local pageY = bh
      for _, theme in ipairs(themes) do
        local fontSolid = ctx.blank(fw, fh, theme.bg, theme.bg, theme.bg, 1)
        local extraSolid = ctx.blank(ew, eh, theme.bg, theme.bg, theme.bg, 1)
        for y = 0, fh - 1 do
          for x = 0, fw - 1 do
            local _, _, _, a = font:getPixel(x, y)
            local alpha = a or 1
            local shade = theme.ink * alpha + theme.bg * (1 - alpha)
            fontSolid:setPixel(x, y, shade, shade, shade, 1)
          end
        end
        for y = 0, eh - 1 do
          for x = 0, ew - 1 do
            local _, _, _, a = extra:getPixel(x, y)
            local alpha = a or 1
            local shade = theme.ink * alpha + theme.bg * (1 - alpha)
            extraSolid:setPixel(x, y, shade, shade, shade, 1)
          end
        end
        ctx.blit(out, fontSolid, 0, pageY)
        ctx.blit(out, extraSolid, 0, pageY + fh)
        pageY = pageY + fh + eh
      end
      ctx.writeImage(out, "tilesets/g1gpp_" .. name .. ".png")
    end
  end
end
