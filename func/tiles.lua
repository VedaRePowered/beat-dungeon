local tiles = {}
local tileList = {}
local leftWallsList = {}
local rightWallsList = {}
local nonWallList = {}

local tileSize = 32
local tileFactor = 2

function tiles.declareTiles()
	tiles.declare("pillar", false, "tiles/pillar", false, false)
	tiles.declare("spikes", false, "tiles/spikes1", true, false)
	tiles.declare("skeleton", "skeleton", "tiles/skelebones", false, true)
	tiles.declare("green slime", "slime1", "tiles/greenslime", false, true)
	tiles.declare("blue slime", "slime2", "tiles/blueslime", false, true)

	tiles.declareWall("left", "tiles/wall-left1")
	tiles.declareWall("left", "tiles/wall-left2")
	tiles.declareWall("left", "tiles/wall-left3")
	tiles.declareWall("left", "tiles/wall-left4")
	tiles.declareWall("right", "tiles/wall-right1")
	tiles.declareWall("right", "tiles/wall-right2")
	tiles.declareWall("right", "tiles/wall-right3")
	tiles.declareWall("right", "tiles/wall-right4")
end

function createTile(id, name, patternFile, image, underPlayer, rotatable)
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
	return {
		id=id,
		name=name,
		pattern=pattern,
		images=images,
		underPlayer=underPlayer
	}
end
function tiles.declare(name, patternFile, image, underPlayer, rotatable)
	id = #tileList + 1
	local newTile = createTile(id, name, patternFile, image, underPlayer, rotatable)
	tileList[id] = newTile
	table.insert(nonWallList, newTile)
end
function tiles.declareWall(type, image)
	local wallList
	if type == "left" then
		wallList = leftWallsList
	elseif type == "right" then
		wallList = rightWallsList
	else
		print("Got invalid wall type in tiles.declareWall: '" .. type .. "'")
	end

	id = #tileList + 1
	local newTile = createTile(id, type .. id, false, image, false, false)
	tileList[id] = newTile
	table.insert(wallList, newTile)
end
function tiles.getTileSizeAndFactor()
	return tileSize, tileFactor
end
function tiles.random()
	return nonWallList[math.random(1, #nonWallList)].id
end
function tiles.randomWall(type)
	if type == "left" then
		return leftWallsList[math.random(1, #leftWallsList)].id
	elseif type == "right" then
		return rightWallsList[math.random(1, #rightWallsList)].id
	else
		print("Got invalid wall type in tiles.randomWall: '" .. type .. "'")
	end
end

function tiles.get(id)
	return tileList[id]
end
function tiles.getImage(id, rotation)
	return tileList[id].images[rotation]
end
return tiles
