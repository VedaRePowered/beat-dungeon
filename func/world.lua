local world = {}
local tiles = {}
function world.get(x, y)

end
function world.set()
function world.gen()
	for y = 1, music.getSongLength() do
		tiles[y] = {}
		for x = 1, 16 do
			tiles[y][x] = blocks.random()
		end
	end
end
return world
