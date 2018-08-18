local world = {}
local worldTiles = {}
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
	for y = 1, 100 do
		for x = 1, 16 do
			world.set(x, y, tiles.random())
		end
	end
	for x = 3, 13 do
		print(worldTiles[30][x])
	end
end
function draw(underPlayer)
	local width, height = love.window.getMode()
	local playerX, playerY = player.getPosition()
	local pOffsetX = playerX - math.floor(playerX)
	local pOffsetY = playerY - math.floor(playerY)
	local screenBlocksX = math.ceil(width/32/2)
	local screenBlocksY = math.ceil(height/32/2)
	for x = math.floor(-screenBlocksX/2), screenBlocksX/2 do
		for y = math.floor(screenBlocksY/2), -screenBlocksY/2-1, -1 do
			tile = world.get(math.floor(playerX) + x, math.floor(playerY) + y)
			if tile and tile.underPlayer == underPlayer then
				love.graphics.draw(tile.image, (x-pOffsetX)*32*2+width/2, 720-((y-pOffsetY)*32*2+height/2)-128, 0, 2, 2)
			end
		end
	end
end
function world.draw()
	draw(true)
	player.draw()
	draw(false)
end
return world
