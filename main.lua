local beatsPassed = 0
function love.load()
	joystick	= require "func.joystick"
	music		= require "func.music"
	tiles		= require "func.tiles"
	world		= require "func.world"
	player		= require "func.player"
	backgrounds	= require "func.backgrounds"
	ai			= require "func.ai"
	menu		= require "func.menu"
	gameover	= require "func.gameover"

	mode = "menu"

	tiles.declareTiles()
	joystick.initialize()

end

function love.update(delta)
	if mode == "menu" then
		menu.update(delta)
	elseif mode == "game" then
		player.update(delta)
		local hasEnded

		beatsPassed, hasEnded = song.getBeatsPassed()
		if beatsPassed > 0 then
			for bn = 1, beatsPassed do
				ai.update()
			end
		end

		if hasEnded then
			mode = "end"
		end
	elseif mode == "end" then
		gameover.update(delta)
	end
end

function love.draw()
	if mode == "menu" then
		menu.draw()
	elseif mode == "game" then
		backgrounds.draw("cobblestone")
		world.draw()
		player.drawHUD()
		song.drawBorder()
	elseif mode == "end" then
		gameover.draw()
	end
end
