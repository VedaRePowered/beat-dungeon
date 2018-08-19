local menu = {}
local logo = love.graphics.newImage("assets/logo.png")
local menuSong = music.loadSong("assets/music/bensound-summer.mp3")
local menuFont = love.graphics.newFont("assets/fonts/pixelated.ttf", 36)
local selectSong = false
local selectedSong = "bensound-house.mp3"
menuSong.play()

function menu.update(delta)
	beatsPassed, hasEnded = menuSong.getBeatsPassed(delta)
	if hasEnded then
		menuSong.play()
	end
	if love.mouse.isDown(1) then
		local mouseY = love.mouse.getY()
		if selectSong then
			if mouseY > 132 and mouseY < 168 then
				selectSong = false
			end
			local songs = love.filesystem.getDirectoryItems("assets/music")
			for i, songName in ipairs(songs) do
				if mouseY > 150+i*36 and mouseY < 186+i*36 then
					selectedSong = songName
				end
			end
		else
			if mouseY > 150 and mouseY < 183 then
				menuSong.stop()
				song = music.loadSong("assets/music/" .. selectedSong)
				world.gen(16, song.getSongLength() * 4 + 32)
				song.play()
				mode = "game"
			elseif mouseY > 183 and mouseY < 222 then
				selectSong = true
			elseif mouseY > 222 and mouseY < 258 then
				love.event.quit(0)
			end
		end
	end
end

function menu.draw()
	local mouseY = love.mouse.getY()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(logo, 0, 0)
	if beatsPassed > 0 then
		love.graphics.setColor(225/256, 242/256, 235/256)
	else
		love.graphics.setColor(86/256, 152/256, 113/256)
	end
	if selectSong then
		local songs = love.filesystem.getDirectoryItems("assets/music")
		love.graphics.print("Done", math.max(18-math.abs(mouseY-(150)), 0), 132)
		for i, songName in ipairs(songs) do
			local y = i
			local x = 0
			if y > 720 then
				y = y - 720
				x = 640
			end
			love.graphics.print(string.sub(songName, 1, string.len(songName)-4), math.max(18-math.abs(mouseY-(186+y*36))+x, x), 168+y*36)
		end
	else
		love.graphics.setFont(menuFont)
		love.graphics.print("Play", math.max(18-math.abs(mouseY-168), 0), 150)
		love.graphics.print("Select Song", math.max(18-math.abs(mouseY-204), 0), 186)
		love.graphics.print("Exit", math.max(18-math.abs(mouseY-240), 0), 222)
	end
end

return menu
