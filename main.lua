
function love.load()
	world		= require "func.world"
	music		= require "func.music"
	tiles		= require "func.tiles"
	player		= require "func.player"
	backgrounds	= require "func.backgrounds"

	tiles.declareTiles()
	world.gen()
	player.initializeJoystick()
end

local beatsPassed = 0

function love.update(delta)
	player.update(delta)
	beatsPassed = music.getBeatsPassed(delta)
end

function love.draw()
	backgrounds.draw("cobblestone")
	world.draw()

	if (beatsPassed > 0) then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	end
end
