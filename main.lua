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

function love.update(delta)
	player.update(delta)
end

function love.draw()
	backgrounds.draw("cobblestone")
	world.draw()
end
