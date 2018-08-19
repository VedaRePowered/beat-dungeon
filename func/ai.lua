ai = {}
local ais = {}
local nextId = 1
function ai.reset()
	ais = {}
end
function ai.new(x, y, pattern, start)
	if not start then
		start = math.random(1, #pattern)
	end
	ais[nextId] = {
		id=nextId,
		x=x,
		y=y,
		pattern=pattern,
		start=start
	}
	nextId = nextId + 1
end
function updateTile(aiTile, isProjectile)
end
function ai.update()
	local songBeat = song.getBeat()
	for _, aiTile in pairs(ais) do
		local action = aiTile.pattern[(songBeat + aiTile.start) % #aiTile.pattern + 1]
		local tile, rotation, costume = world.get(aiTile.x, aiTile.y)
		local newX = aiTile.x
		local newY = aiTile.y
		local newRotation = rotation
		local newCostume = costume

		if not tile then
			ais[aiTile.id] = nil
		else
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
			elseif string.sub(action, 1, 8) == "costume4" then
				newCostume = 4
			elseif string.sub(action, 1, 5) == "spike" then
				newCostume = 3
				dangerous = true
			elseif string.sub(action, 1, 4) == "kill" then
				dangerous = true
			elseif string.sub(action, 1, 9) == "throwbomb" then
				newCostume = 4
				local bombtile = tiles.getTileByName("Tiger Balm's Bomb")
				if not world.get(aiTile.x - 1, aiTile.y) then
					world.set(aiTile.x - 1, aiTile.y, bombtile.id, 3, 1)
					ai.new(aiTile.x - 1, aiTile.y, bombtile.pattern, -songBeat)
				elseif not world.get(aiTile.x, aiTile.y - 1) then
					world.set(aiTile.x, aiTile.y - 1, bombtile.id, 4, 1)
					ai.new(aiTile.x, aiTile.y - 1, bombtile.pattern, -songBeat)
				elseif not world.get(aiTile.x + 1, aiTile.y) then
					world.set(aiTile.x + 1, aiTile.y, bombtile.id, 1, 1)
					ai.new(aiTile.x + 1, aiTile.y, bombtile.pattern, -songBeat)
				elseif not world.get(aiTile.x, aiTile.y + 1) then
					world.set(aiTile.x, aiTile.y + 1, bombtile.id, 2, 1)
					ai.new(aiTile.x, aiTile.y + 1, bombtile.pattern, -songBeat)
				end
			elseif string.sub(action, 1, 4) == "boom" then
				newCostume = 3
				dangerous = true
			elseif string.sub(action, 1, 3) == "die" then
				ais[aiTile.id] = nil
				world.unset(aiTile.x, aiTile.y)
			elseif string.sub(action, 1, 12) == "actAsABomber" then
				local playerX, playerY = player.getPosition()
				if costume == 2 then
					dangerous = false
					ais[aiTile.id] = nil
					world.unset(aiTile.x, aiTile.y)
				elseif math.sqrt(math.abs(playerX-aiTile.x)^2 + math.abs(playerX-aiTile.x)^2) < 25 then
					dangerous = false
					local playerDistanceX = playerX-aiTile.x
					local playerDistanceY = playerY-aiTile.y
					if math.abs(playerDistanceX) > math.abs(playerDistanceY) then
						if playerDistanceX > 1 then
							newRotation = 1
						else
							newRotation = 3
						end
					else
						if playerDistanceY > 1 then
							newRotation = 2
						else
							newRotation = 4
						end
					end
					if math.floor(playerDistanceX) < 1 and math.floor(playerDistanceY) < 1 then
						player.changeHealth(-2, tile.name)
						newCostume = 2
					else
						if rotation == 1 then
							newX = newX + 1
						elseif rotation == 2 then
							newY = newY + 1
						elseif rotation == 3 then
							newX = newX - 1
						elseif rotation == 4 then
							newY = newY - 1
						end
					end
				end
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
				player.changeHealth(-1, tile.name)
			end
		end
	end
end
return ai
