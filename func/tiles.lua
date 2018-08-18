local tiles = {}
local tileList = {}

local tileSize = 32
local tileFactor = 2

function tiles.declareTiles()
	tiles.declare("pillar", false, "tiles/pillar", false, false)
	tiles.declare("spikes", false, "tiles/spikes1", true, false)
	tiles.declare("skeleton", "skeleton", "tiles/skelebones", false, true)
end

function tiles.declare(name, patternFile, image, underPlayer, rotatable)
	id = #tileList + 1
	if patternFile then
		p = io.open("assets/patterns/" .. patternFile .. ".txt")
		pattern = {}
		for action in p:lines() do
			table.insert(pattern, action)
		end
		p.close()
	else
		pattern = false
	end
	local images = {}
	if rotatable then
		table.insert(images, love.graphics.newImage("assets/" .. image .. "Right.png"))
		table.insert(images, love.graphics.newImage("assets/" .. image .. "Up.png"))
		table.insert(images, love.graphics.newImage("assets/" .. image .. "Left.png"))
		table.insert(images, love.graphics.newImage("assets/" .. image .. "Down.png"))
	else
		local img = love.graphics.newImage("assets/" .. image .. ".png")
		for i = 1, 4 do
			table.insert(images, img)
		end
	end
	for _, img in ipairs(images) do
		img:setFilter("nearest")
	end
	tileList[id] = {
		id=id,
		name=name,
		pattern=pattern,
		images=images,
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
function tiles.getImage(id, rotation)
	return tileList[id].images[rotation]
end
return tiles
