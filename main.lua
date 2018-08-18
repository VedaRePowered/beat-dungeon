function love.load()
	world  = require "func.world"
	music  = require "func.music"
	tiles  = require "func.tiles"
	player = require "func.player"

	tiles.declareTiles()
	world.gen()
end

function love.update(delta)
end

function love.draw()
	world.draw()
end
