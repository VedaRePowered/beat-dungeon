local player = {}
local playerX = 8
local playerY = 10
function player.getPosition()
	return playerX, playerY
end
function player.update(delta)
	joystick = love.joystick.getJoysticks()[1]
	playerX = playerX + joystick:getAxis(1) * delta * 10
	playerY = playerY - joystick:getAxis(2) * delta * 10

end
return player
