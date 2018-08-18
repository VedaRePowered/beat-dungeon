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
function world.draw()
	local width, height = love.window.getMode()
	playerX, playerY = player.getPosition()
	for x = -width/32/8, width/32/8 do
		for y = -height/32/8, height/32/8 do
			tile = world.get(math.floor(playerX + x), math.floor(playerY + y))
			if tile then
				love.graphics.draw(tile.image, (x*32*4)+(width/2), (y*32*4)+(height/2), 0, 4, 4)
			end
		end
	end
end
return world
