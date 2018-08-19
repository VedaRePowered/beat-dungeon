local menu = {}
local logo = love.graphics.newImage("assets/logo.png")
local menuSong = music.loadSong("assets/music/Bensound - Summer.mp3", 1)
local menuFont = love.graphics.newFont("assets/fonts/pixelated.ttf", 36)
local selectSong = false
local selectedSong = "Bensound - House.mp3"
local difficulty = 1
menuSong.play()
local selectedColumn = 1
local selectedRow = 6
local lastMouseX
local lastMouseY
local lastMove = false
local lastSelect = false
local hasColumnTwo = false
local numberOfSongs

function drawMenuOption(row, column, text, mouseX, mouseY)
	local mouseColumn = math.floor(mouseX / 640) + 1
	local baseX = (column - 1) * 640
	local baseY = -36 + row * 36
	if selectedRow or selectedColumn then
		if selectedRow == row and selectedColumn == column then
			love.graphics.print(text, baseX + 18, baseY)
		else
			love.graphics.print(text, baseX, baseY)
		end
	elseif mouseColumn == column then
		love.graphics.print(text, math.max(baseX + 18 - math.abs(mouseY - baseY - 20), baseX), baseY)
	else
		love.graphics.print(text, baseX, baseY)
	end
end

function getSelectedMenuOption(mouseX, mouseY)
	if selectedRow and selectedColumn then
		return selectedRow, selectedColumn
	end
	local mouseColumn = math.floor(mouseX / 640) + 1
	local mouseRow = math.floor((mouseY + 36) / 36)

	return mouseRow, mouseColumn
end

function menu.update(delta)
	beatsPassed, hasEnded = menuSong.getBeatsPassed(delta)
	if hasEnded then
		menuSong.play()
	end
	if love.keyboard.isDown("escape") then
		love.event.quit(0)
	end
	local mouseX, mouseY = love.mouse.getPosition()
	if love.mouse.isDown(1) or joystick.getActionButton() then
		if not lastSelect then
			row, column = getSelectedMenuOption(mouseX, mouseY)
			if selectSong then
				if row == 5 and column == 1 then
					selectSong = false
					selectedColumn = 1
					selectedRow = 7
				else
					local songs = love.filesystem.getDirectoryItems("assets/music")
					local index = (row - 6) + (column - 1) * 20
					if songs[index] then
						selectedSong = songs[index]
					end
				end
			else
				if row == 6 and column == 1 then
					menuSong.stop()
					song = music.loadSong("assets/music/" .. selectedSong, difficulty)
					world.gen(16, song.getSongLength() * 4 + 32)
					song.play()
					mode = "game"
				elseif row == 7 and column == 1 then
					selectSong = true
					selectedColumn = 1
					selectedRow = 5
				elseif row == 8 and column == 1 then
					love.event.quit(0)
				elseif row == 10 and column == 1 then
					difficulty = 0.5
					menuSong.setBpmMultiplier(difficulty)
				elseif row == 11 and column == 1 then
					difficulty = 1
					menuSong.setBpmMultiplier(difficulty)
				elseif row == 12 and column == 1 then
					difficulty = 2
					menuSong.setBpmMultiplier(difficulty)
				end
			end
			lastSelect = true
		end
	else
		lastSelect = false
	end
	if not lastMouseX and not lastMouseY then
		lastMouseX = mouseX
		lastMouseY = mouseY
	elseif mouseX ~= lastMouseX or mouseY ~= lastMouseY then
		selectedRow = nil
		selectedColumn = nil
	else
		local yAmount = math.abs(joystick.getVerticalAxis())
		local xAmount = math.abs(joystick.getHorizontalAxis())
		local pushed = yAmount > 0.9 or xAmount > 0.9
		if not selectedRow and pushed then
			selectedRow, selectedColumn = getSelectedMenuOption(mouseX, mouseY)
		end
		if lastMove and not pushed then
			lastMove = false
		elseif not lastMove and pushed then
			if yAmount > 0.9 then
				if joystick.getVerticalAxis() < 0 then
					selectedRow = selectedRow - 1
					if selectSong then
						if selectedColumn == 1 then
							if selectedRow < 7 then
								selectedRow = 5
							end
						end
					else
						if selectedRow < 6 then
							selectedRow = 6
						elseif selectedRow == 9 then
							selectedRow = 8
						end
					end
					if selectedRow < 1 then
						selectedRow = 1
					end
				else
					selectedRow = selectedRow + 1
					if selectSong then
						if selectedColumn == 1 then
							if selectedRow > numberOfSongs + 6 then
								selectedRow = numberOfSongs + 6
							elseif selectedRow == 6 then
								selectedRow = 7
							end
						end
					else
						if selectedRow > 12 then
							selectedRow = 12
						elseif selectedRow == 9 then
							selectedRow = 10
						end
					end
					if selectedRow > 20 then
						selectedRow = 20
					end
				end
				if not hasColumnTwo then
					selectedColumn = 1
				end
				lastMove = true
			end
			if xAmount > 0.9 then
				if joystick:getHorizontalAxis() < 0 then
					selectedColumn = selectedColumn - 1
					if selectedColumn < 1 then
						selectedColumn = 1
					end
				elseif hasColumnTwo then
					selectedColumn = selectedColumn + 1
					if selectedColumn > 2 then
						selectedColumn = 2
					end
				end
				lastMove = true
			end
		end
	end

	lastMouseX = mouseX
	lastMouseY = mouseY
end

function menu.draw()
	local mouseX, mouseY = love.mouse.getPosition()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(logo, 0, 0)

	local brightness = menuSong.getBrightness()
	love.graphics.setColor((86 + ((225 - 86) * brightness)) / 256, (152 + ((242 - 152) * brightness)) / 256, (113 + ((235 - 113) * brightness)) / 256)
	if selectSong then
		local songs = love.filesystem.getDirectoryItems("assets/music")
		drawMenuOption(5, 1, "Done", mouseX, mouseY)
		for i, songName in ipairs(songs) do
			column = 1
			row = 6 + i
			if i > 14 then
				column = 2
				row = row - 20
			end
			songName = string.sub(songName, 1, string.len(songName)-4)
			if songName == string.sub(selectedSong, 1, string.len(selectedSong)-4) then
				songName = songName .. "*"
			end
			drawMenuOption(row, column, songName, mouseX, mouseY)
		end
		numberOfSongs= #songs
		hasColumnTwo = #songs > 14
	else
		love.graphics.setFont(menuFont)
		drawMenuOption(6, 1, "Play", mouseX, mouseY)
		drawMenuOption(7, 1, "Select Song (" .. string.sub(selectedSong, 1, string.len(selectedSong)-4) .. ")", mouseX, mouseY)
		drawMenuOption(8, 1, "Exit", mouseX, mouseY)

		local de, dn, dh = "", "", ""
		if difficulty == 0.5 then
			de = "*"
		elseif difficulty == 1 then
			dn = "*"
		elseif difficulty == 2 then
			dh = "*"
		end
		drawMenuOption(10, 1, "Easy" .. de, mouseX, mouseY)
		drawMenuOption(11, 1, "Normal" .. dn, mouseX, mouseY)
		drawMenuOption(12, 1, "Hard" .. dh, mouseX, mouseY)
		hasColumnTwo = false
	end
end

return menu
