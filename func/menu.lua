local menu = {}
local logo = love.graphics.newImage("assets/logo.png")
local menuSong = music.loadSong("assets/music/Bensound - Summer.mp3", 1)
local menuFont = love.graphics.newFont("assets/fonts/pixelated.ttf", 36)
local selectSong = false
local selectedSong = "Bensound - House.mp3"
local difficulty = 1
menuSong.play()

function drawMenuOption(row, column, text, mouseX, mouseY)
	local mouseColumn = math.floor(mouseX / 640) + 1
	local baseX = (column - 1) * 640
	local baseY = -36 + row * 36
	if mouseColumn == column then
		love.graphics.print(text, math.max(baseX + 18 - math.abs(mouseY - baseY - 20), baseX), baseY)
	else
		love.graphics.print(text, baseX, baseY)
	end
end

function getSelectedMenuOption(mouseX, mouseY)
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
	if love.mouse.isDown(1) then
		local mouseX, mouseY = love.mouse.getPosition()
		if selectSong then
			row, column = getSelectedMenuOption(mouseX, mouseY)
			if row == 5 and column == 1 then
				selectSong = false
			else
				local songs = love.filesystem.getDirectoryItems("assets/music")
				local index = (row - 6) + (column - 1) * 20
				if songs[index] then
					selectedSong = songs[index]
				end
			end
		else
			row, column = getSelectedMenuOption(mouseX, mouseY)
			if row == 6 and column == 1 then
				menuSong.stop()
				song = music.loadSong("assets/music/" .. selectedSong, difficulty)
				world.gen(16, song.getSongLength() * 4 + 32)
				song.play()
				mode = "game"
			elseif row == 7 and column == 1 then
				selectSong = true
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
	end
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
	end
end

return menu
