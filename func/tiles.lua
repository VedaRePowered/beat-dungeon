local tiles = {}
local tileList = {}
local leftWallsList = {}
local rightWallsList = {}
local nonWallList = {}

local tileSize = 32
local tileFactor = 2

function tiles.loadImage(path)
	local image = love.graphics.newImage(path)
	image:setFilter("nearest")
	return image
end

function tiles.declareTiles()
	tiles.declare("pillar", false, "tiles/pillar", false, false, 1)
	tiles.declare("spikes", "spikes", "tiles/spikes", true, false, 3)
	tiles.declare("pit", "pit", "tiles/pit", true, false, 1)
	tiles.declare("skele bones", "skeleton", "tiles/skelebones", false, true, 1)
	tiles.declare("green slime", "slime1", "tiles/greenslime", false, true, 1)
	tiles.declare("blue slime", "slime2", "tiles/blueslime", false, true, 1)
	tiles.declare("zom bob", "zombie", "tiles/zombob", false, true, 1)

	tiles.declareWall("left", "tiles/wall-left1")
	tiles.declareWall("left", "tiles/wall-left2")
	tiles.declareWall("left", "tiles/wall-left3")
	tiles.declareWall("left", "tiles/wall-left4")
	tiles.declareWall("right", "tiles/wall-right1")
	tiles.declareWall("right", "tiles/wall-right2")
	tiles.declareWall("right", "tiles/wall-right3")
	tiles.declareWall("right", "tiles/wall-right4")
end

function createTile(id, name, patternFile, image, underPlayer, rotatable, costumes)
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
	for costume = 1, costumes do
		local costumeName = ""
		if costumes and costumes > 1 then
			costumeName = costume
		end
		if rotatable then
			table.insert(images, tiles.loadImage("assets/" .. image .. "Right" .. costumeName .. ".png"))
			table.insert(images, tiles.loadImage("assets/" .. image .. "Up" .. costumeName .. ".png"))
			table.insert(images, tiles.loadImage("assets/" .. image .. "Left" .. costumeName .. ".png"))
			table.insert(images, tiles.loadImage("assets/" .. image .. "Down" .. costumeName .. ".png"))
		else
			local img = tiles.loadImage("assets/" .. image .. costumeName .. ".png")
			for i = 1, 4 do
				table.insert(images, img)
			end
		end
	end
	return {
		id=id,
		name=name,
		pattern=pattern,
		images=images,
		underPlayer=underPlayer,
		costumes=costumes
	}
end
function tiles.declare(name, patternFile, image, underPlayer, rotatable, costumes)
	id = #tileList + 1
	local newTile = createTile(id, name, patternFile, image, underPlayer, rotatable, costumes)
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
	local newTile = createTile(id, type .. id, false, image, false, false, 1)
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
function tiles.getImage(id, rotation, costume)
	local index = (costume - 1) * 4 + rotation
	return tileList[id].images[index]
end
return tiles
