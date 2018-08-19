local beatsPassed = 0
function love.load()
	tiles		= require "func.tiles"
	world		= require "func.world"
	music		= require "func.music"
	player		= require "func.player"
	backgrounds	= require "func.backgrounds"
	ai			= require "func.ai"
	menu		= require "func.menu"

	mode = "menu"

	tiles.declareTiles()
	player.initializeJoystick()

end

function love.update(delta)
	if mode == "menu" then
		menu.update(delta)
	elseif mode == "game" then
		player.update(delta)
		local hasEnded

		beatsPassed, hasEnded = song.getBeatsPassed(delta)
		if beatsPassed > 0 then
			for bn = 1, beatsPassed do
				ai.update()
			end
		end

		if hasEnded then
			mode = "end"
		end
	elseif mode == "end" then

	end
end

function love.draw()
	if mode == "menu" then
		menu.draw()
	elseif mode == "game" then
		backgrounds.draw("cobblestone")
		world.draw()
	elseif mode == "end" then
		local score = player.getScore()
		love.graphics.print("score: " .. score, 640, 300)
	end
end
