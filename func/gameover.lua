local gameover = {}

function gameover.update(delta)
	if love.mouse.isDown(1) or joystick.getActionButton() or love.keyboard.isDown("space") or love.keyboard.isDown("return") then
		mode = "menu"
	end
end

function gameover.draw()
	local score = player.getScore()
	love.graphics.print("Score: " .. score, 450, 300)
	love.graphics.print("Click the mouse, press a button\n or press space or enter...", 450, 350)
end

return gameover
