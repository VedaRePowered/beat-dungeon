local menu = {}
local logo = love.graphics.newImage("assets/logo.png")
local menuSong = music.loadSong("assets/music/bensound-summer.mp3")
local menuFont = love.graphics.newFont("assets/fonts/pixelated.ttf", 36)
menuSong.play()

function menu.update(delta)
	beatsPassed, hasEnded = menuSong.getBeatsPassed(delta)
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
	love.graphics.setFont(menuFont)
	love.graphics.print("Play", math.max(18-math.abs(mouseY-168), 0), 150)
	love.graphics.print("Select Song", math.max(18-math.abs(mouseY-204), 0), 186)
	love.graphics.print("Exit", math.max(18-math.abs(mouseY-240), 0), 222)
end

return menu
