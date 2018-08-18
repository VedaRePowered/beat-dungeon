local beatsPassed = 0
function love.load()
	tiles		= require "func.tiles"
	world		= require "func.world"
	music		= require "func.music"
	player		= require "func.player"
	backgrounds	= require "func.backgrounds"
	ai			= require "func.ai"

	tiles.declareTiles()
	player.initializeJoystick()

	song = music.loadSong("assets/music/bensound-house.mp3")
	world.gen(16, song.getSongLength() * 4 + 32)
	song.play()
end

function love.update(delta)
	player.update(delta)
	local hasEnded

	beatsPassed, hasEnded = song.getBeatsPassed(delta)
	if beatsPassed > 0 then
		for bn = 1, beatsPassed do
			ai.update()
		end
	end

	if hasEnded then
		love.event.quit(0)
	end
end

function love.draw()
	backgrounds.draw("cobblestone")
	world.draw()
end
