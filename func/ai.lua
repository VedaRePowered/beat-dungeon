ai = {}
ais = {}
function ai.new(x, y, pattern)
	ais[#ais+1] = {x=x, y=y, pattern=pattern}
end
function ai.update()
	for _, tile in ipairs(ais) do
		local action = tile.pattern[song.getBeat() % #tile.pattern + 1]
		if string.sub(action, 1, 4) == "move" then
			local type, rotation = world.getID(tile.x, tile.y)
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
				world.set(newX, newY, type, rotation)
				world.unset(tile.x, tile.y)
				tile.x = newX
				tile.y = newY
			end
		elseif string.sub(action, 1, 5) == "right" then
			local type, rotation = world.getID(tile.x, tile.y)
			rotation = rotation + 1
			if rotation > 4 then
				rotation = 1
			end
			world.set(tile.x, tile.y, type, rotation)
		elseif string.sub(action, 1, 5) == "right" then
			local type, rotation = world.getID(tile.x, tile.y)
			rotation = rotation - 1
			if rotation < 1 then
				rotation = 4
			end
			world.set(tile.x, tile.y, type, rotation)
		end
	end
end
return ai
