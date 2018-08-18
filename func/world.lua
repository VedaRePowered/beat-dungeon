local world = {}
local worldTiles = {}

local heightInBlocks = 100
local widthInBlocks = 16
local tileSize, tileFactor = tiles.getTileSizeAndFactor()

function world.getSize()
	return widthInBlocks, heightInBlocks
end
function world.get(x, y)
	if worldTiles[y] then
		return tiles.get(worldTiles[y][x])
	else
		return false
	end
end
function world.set(x, y, tile)
	if not worldTiles[y] then
		worldTiles[y] = {}
	end
	worldTiles[y][x] = tile
end
function world.gen()
	for y = 1, heightInBlocks do
		for x = 1, widthInBlocks do
			world.set(x, y, tiles.random())
		end
	end
	for x = 3, 13 do
		print(worldTiles[30][x])
	end
end
function world.limitMovement(oldX, oldY, newX, newY)
	-- don't allow the player to move through a tile that blocks movement
	local tile = world.get(math.floor(newX), math.floor(newY))
	if tile and not tile.underPlayer then
		return oldX, oldY
	end

	-- keep player on the map
	if newX < 1 then
		newX = 1
	end
	if newX > widthInBlocks + 1 then
		newX = widthInBlocks + 1
	end
	if newY < 1 then
		newY = 1
	end
	if newY > heightInBlocks + 1 then
		newY = heightInBlocks + 1
	end

	return newX, newY
end
function drawRow(width, height, tilePlayerX, tilePlayerY, pOffsetX, pOffsetY, screenBlocksX, y, underPlayer)
	for x = math.floor(-screenBlocksX/2), screenBlocksX/2 do
		local tile = world.get(tilePlayerX + x, tilePlayerY + y)
		if tile and tile.underPlayer == underPlayer then
			love.graphics.draw(tile.image, (x-pOffsetX)*tileSize*tileFactor+width/2, 720-((y-pOffsetY)*tileSize*tileFactor+height/2)-128, 0, tileFactor, tileFactor)
		end
	end
end
function world.draw()
	local width, height = love.window.getMode()
	local playerX, playerY = player.getPosition()
	local tilePlayerX = math.floor(playerX)
	local tilePlayerY = math.floor(playerY)
	local pOffsetX = playerX - tilePlayerX
	local pOffsetY = playerY - tilePlayerY
	local screenBlocksX = math.ceil(width/tileSize/2)
	local screenBlocksY = math.ceil(height/tileSize/2)
	for y = math.floor(screenBlocksY/2), -screenBlocksY/2-1, -1 do
		drawRow(width, height, tilePlayerX, tilePlayerY, pOffsetX, pOffsetY, screenBlocksX, y, true)
		if y == -1 then
			player.draw()
		end
		drawRow(width, height, tilePlayerX, tilePlayerY, pOffsetX, pOffsetY, screenBlocksX, y, false)
	end
end
return world
