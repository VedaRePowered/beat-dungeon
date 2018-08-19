ai = {}
ais = {}
function ai.new(x, y, pattern)
	ais[#ais+1] = {x=x, y=y, pattern=pattern}
end
function ai.update()
	for _, tile in ipairs(ais) do
		local action = tile.pattern[song.getBeat() % #tile.pattern + 1]
		if string.sub(action, 1, 4) == "move" then
			local type, rotation = world.get(tile.x, tile.y)
			local newX, newY = tile.x, tile.y
			if rotation == 1 then
				newX = newX + 1
			elseif rotation == 2 then
				newY = newY + 1
			elseif rotation == 3 then
				newX = newX - 1
			elseif rotation == 4 then
				newY = newY - 1
			end
			if not world.get(newX, newY) then
				--print("moved", type, "to", newX, newY)
				world.set(newX, newY, type.id, rotation)
				world.unset(tile.x, tile.y)
				tile.x = newX
				tile.y = newY
			end
		elseif string.sub(action, 1, 5) == "right" then
			local type, rotation = world.get(tile.x, tile.y)
			rotation = rotation + 1
			if rotation > 4 then
				rotation = 1
			end
			world.set(tile.x, tile.y, type.id, rotation)
		elseif string.sub(action, 1, 5) == "left" then
			local type, rotation = world.get(tile.x, tile.y)
			rotation = rotation - 1
			if rotation < 1 then
				rotation = 4
			end
			world.set(tile.x, tile.y, type.id, rotation)
		elseif string.sub(action, 1, 4) == "east" then
			local type, rotation = world.get(tile.x, tile.y)
			if not world.get(tile.x+1, tile.y) then
				--print("moved", type, "to", newX, newY)
				world.set(tile.x+1, tile.y, type.id, 1)
				world.unset(tile.x, tile.y)
				tile.x = tile.x + 1
			end
		elseif string.sub(action, 1, 4) == "west" then
			local type, rotation = world.get(tile.x, tile.y)
			if not world.get(tile.x-1, tile.y) then
				--print("moved", type, "to", newX, newY)
				world.set(tile.x-1, tile.y, type.id, 3)
				world.unset(tile.x, tile.y)
				tile.x = tile.x - 1
			end
		elseif string.sub(action, 1, 5) == "north" then
			local type, rotation = world.get(tile.x, tile.y)
			if not world.get(tile.x, tile.y+1) then
				--print("moved", type, "to", newX, newY)
				world.set(tile.x, tile.y+1, type.id, 2)
				world.unset(tile.x, tile.y)
				tile.y = tile.y + 1
			end
		elseif string.sub(action, 1, 5) == "south" then
			local type, rotation = world.get(tile.x, tile.y)
			if not world.get(tile.x, tile.y-1) then
				--print("moved", type, "to", newX, newY)
				world.set(tile.x, tile.y-1, type.id, 4)
				world.unset(tile.x, tile.y)
				tile.y = tile.y - 1
			end
		end
		local playerX, playerY = player.getPosition()
		if tile.x == math.floor(playerX) and tile.y == math.floor(playerY) then
			player.changeHealth(-1)
		end
	end
end
return ai
