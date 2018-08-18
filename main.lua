local beatsPassed = 0
function love.load()
	tiles		= require "func.tiles"
	world		= require "func.world"
	music		= require "func.music"
	player		= require "func.player"
	backgrounds	= require "func.backgrounds"
	ai			= require "func.ai"

	tiles.declareTiles()
	world.gen()
	player.initializeJoystick()

	song = music.loadSong("assets/music/bensound-house.mp3")
	song.play()
end

function love.update(delta)
	player.update(delta)
	local hasEnded

	beatsPassed, hasEnded = song.getBeatsPassed(delta)

	if hasEnded then
		love.event.quit(0)
	end
end

function love.draw()
	backgrounds.draw("cobblestone")
	world.draw()

	if (beatsPassed > 0) then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	end
end
