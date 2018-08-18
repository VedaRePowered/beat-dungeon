function love.load()
	world = require "func.world"
	music = require "func.music"

	world.gen()
end

function love.update(delta)
end

function love.draw()
	world.draw()
end
