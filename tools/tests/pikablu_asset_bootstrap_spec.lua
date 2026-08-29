local root = assert(arg[1], "repository root required")
local transform = assert(loadfile(root .. "/g1gpp/assets_transform.lua"))()
local writes = {}
local reads = {}

transform({
  exists = function(path)
    return path == "battle/front/marill.png"
      or path == "battle/back/marill_back.png"
  end,
  readImage = function(path)
    reads[#reads + 1] = path
    return { source = path }
  end,
  writeImage = function(image, path)
    writes[path] = image.source
  end,
})

assert(#reads == 2)
assert(writes["battle/front/g1gpp_marill.png"]
  == "battle/front/marill.png")
assert(writes["battle/back/g1gpp_marill_back.png"]
  == "battle/back/marill_back.png")

print("PASS: public-API Gold/Silver/Crystal Marill art bootstrap")
