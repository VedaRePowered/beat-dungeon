local player = {}
local playerX = 8
local playerY = 10
local joystick
function player.initializeJoystick()
	joystick = love.joystick.getJoysticks()[1]

	if joystick == nil then
		print("Please plug in a joystick before starting the game.")
		love.event.quit(-1)
	end
end
function player.getPosition()
	return playerX, playerY
end
function player.update(delta)
	if math.abs(joystick:getAxis(1)) > 0.1 then
		playerX = playerX + joystick:getAxis(1) * delta * 4
	end
	if math.abs(joystick:getAxis(2)) > 0.1 then
		playerY = playerY - joystick:getAxis(2) * delta * 4
	end

end
return player
