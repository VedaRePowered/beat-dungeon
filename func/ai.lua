ai = {}
ais = {}
function ai.reset()
	ais = {}
end
function ai.new(x, y, pattern)
	ais[#ais+1] = {x=x, y=y, pattern=pattern, start=math.random(1, #pattern)}
end
function ai.update()
	for _, aiTile in ipairs(ais) do
		local action = aiTile.pattern[(song.getBeat() + aiTile.start) % #aiTile.pattern + 1]
		local tile, rotation, costume = world.get(aiTile.x, aiTile.y)
		local newX = aiTile.x
		local newY = aiTile.y
		local newRotation = rotation
		local newCostume = costume
		local dangerous = not tile.underPlayer
		if string.sub(action, 1, 4) == "move" then
			if rotation == 1 then
				newX = newX + 1
			elseif rotation == 2 then
				newY = newY + 1
			elseif rotation == 3 then
				newX = newX - 1
			elseif rotation == 4 then
				newY = newY - 1
			end
		elseif string.sub(action, 1, 5) == "right" then
			newRotation = rotation + 1
			if newRotation > 4 then
				newRotation = 1
			end
		elseif string.sub(action, 1, 5) == "left" then
			newRotation = rotation - 1
			if newRotation < 1 then
				newRotation = 4
			end
		elseif string.sub(action, 1, 4) == "east" then
			newX = aiTile.x + 1
			newRotation = 1
		elseif string.sub(action, 1, 4) == "west" then
			newX = aiTile.x - 1
			newRotation = 3
		elseif string.sub(action, 1, 5) == "north" then
			newY = aiTile.y + 1
			newRotation = 2
		elseif string.sub(action, 1, 5) == "south" then
			newY = aiTile.y - 1
			newRotation = 4
		elseif string.sub(action, 1, 4) == "wait" then
			-- do nothing
		elseif string.sub(action, 1, 8) == "costume1" then
			newCostume = 1
		elseif string.sub(action, 1, 8) == "costume2" then
			newCostume = 2
		elseif string.sub(action, 1, 8) == "costume3" then
			newCostume = 3
		elseif string.sub(action, 1, 5) == "spike" then
			newCostume = 3
			dangerous = true
		elseif string.sub(action, 1, 4) == "kill" then
			dangerous = true
		else
			error("Invalid AI action: " .. action)
		end

		local turned = newRotation ~= rotation
		local changedCostume = newCostume ~= costume
		local moved = newX ~= aiTile.x or newY ~= aiTile.y
		if moved and not world.get(newX, newY) then
			--print("moved", tile.name, "to", newX, newY)
			world.set(newX, newY, tile.id, newRotation, newCostume)
			world.unset(aiTile.x, aiTile.y)
			aiTile.x = newX
			aiTile.y = newY
		elseif turned or changedCostume then
			world.set(aiTile.x, aiTile.y, tile.id, newRotation, newCostume)
		end

		local playerX, playerY = player.getPosition()
		if dangerous and aiTile.x == math.floor(playerX) and aiTile.y == math.floor(playerY) then
			player.changeHealth(-1)
		end
	end
end
return ai
