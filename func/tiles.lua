local tiles = {}
local tileList = {}

local tileSize = 32
local tileFactor = 2

function tiles.declareTiles()
	tiles.declare("pillar", false, "tiles/pillar", false)
	tiles.declare("spikes", false, "tiles/spikes1", true)
end

function tiles.declare(name, patternFile, image, underPlayer)
	id = #tileList + 1
	if patternFile then
		p = io.open("assets/patterns/" .. patternFile .. ".txt")
		pattern = {}
		for _, action in p:lines() do
			table.insert(pattern, action)
		end
		p.close()
	else
		pattern = false
	end
	local img = love.graphics.newImage("assets/" .. image .. ".png")
	img:setFilter("nearest")
	tileList[id] = {
		name=name,
		pattern=pattern,
		image=img,
		underPlayer=underPlayer
	}
end
function tiles.getTileSizeAndFactor()
	return tileSize, tileFactor
end
function tiles.random()
	return math.random(1, #tileList)
end
function tiles.get(id)
	return tileList[id]
end
return tiles
