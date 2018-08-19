local world = {}
local worldTiles = {}

local heightInBlocks
local widthInBlocks
local tileSize, tileFactor = tiles.getTileSizeAndFactor()
local tileFullSize = tileSize * tileFactor

function world.get(x, y)
	if worldTiles[y] and worldTiles[y][x] then
		local worldTile = worldTiles[y][x]
		return tiles.get(worldTile.tileId), worldTile.rotation
	else
		return false
	end
end
function world.set(x, y, tileId, rotation)
	if not worldTiles[y] then
		worldTiles[y] = {}
	end
	worldTiles[y][x] = {
		tileId=tileId,
		rotation = rotation
	}
end
function world.unset(x, y)
	if worldTiles[y] then
		worldTiles[y][x] = nil
	end
end
function world.gen(width, height)
	widthInBlocks = width
	heightInBlocks = height

	playerX, playerY = player.resetPosition(width)

	worldTiles = {}
	for y = 1, height do
		world.set(0, y, tiles.randomWall("left"), 1)
		world.set(width + 1, y, tiles.randomWall("right"), 1)

		for x = 1, width do
			local nearPlayer = math.abs(x - playerX) < 4 and math.abs(y - playerY) < 4
			if not nearPlayer and math.random(1, 15) == 1 then
				local tile = tiles.random()
				world.set(x, y, tile, 1)
				if tiles.get(tile).pattern then
					ai.new(x, y, tiles.get(tile).pattern)
				end
			end
		end
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
function drawRow(middleX, tilePlayerX, tilePlayerY, pOffsetX, screenBlocksX, y, rowTop, underPlayer)
	for x = math.floor(-screenBlocksX/2), screenBlocksX/2 do
		local tile, rotation = world.get(tilePlayerX + x, tilePlayerY + y)
		if tile and tile.underPlayer == underPlayer then
			local image = tiles.getImage(tile.id, rotation)
			local columnLeft = middleX + ((x - pOffsetX) * tileFullSize)
			love.graphics.draw(
				image,
				columnLeft,
				rowTop - tileFullSize, -- tiles are double-tall to allow covering sprites behind
				0,
				tileFactor,
				tileFactor)
		end
	end
end
function world.draw()
	local width, height = love.window.getMode()
	local middleX = width / 2
	local middleY = height / 2
	local playerX, playerY = player.getPosition()
	local tilePlayerX = math.floor(playerX)
	local tilePlayerY = math.floor(playerY)
	local pOffsetX = playerX - tilePlayerX
	local pOffsetY = playerY - tilePlayerY
	local screenBlocksX = math.ceil(middleX / tileSize)
	local screenBlocksY = math.ceil(middleY / tileSize)

	love.graphics.setColor(34/255, 17/255, 17/255)
	-- draw black-ish bar on the bottom
	local bottomBlackStart = middleY + ((playerY - 1) * tileFullSize)
	if bottomBlackStart < height then
		love.graphics.rectangle("fill", 0, bottomBlackStart, width, height - bottomBlackStart)
	end

	-- draw black-ish bars on right and left
	local leftBlackEnd = middleX - (playerX * tileFullSize)
	if leftBlackEnd > 0 then
		love.graphics.rectangle("fill", 0, 0, leftBlackEnd, height)
	end
	local rightBlackStart = (widthInBlocks - playerX + 2) * tileFullSize + middleX
	if rightBlackStart < width then
		love.graphics.rectangle("fill", rightBlackStart, 0, width - rightBlackStart, height)
	end
	love.graphics.setColor(1, 1, 1)

	-- draw visible tiles
	for y = math.floor(screenBlocksY/2), -screenBlocksY/2-1, -1 do
		local rowTop = middleY - ((y - pOffsetY + 1) * tileFullSize)

		drawRow(middleX, tilePlayerX, tilePlayerY, pOffsetX, screenBlocksX, y, rowTop, true)
		if y == -1 then
			player.draw()
		end
		drawRow(middleX, tilePlayerX, tilePlayerY, pOffsetX, screenBlocksX, y, rowTop, false)
	end
end
return world
