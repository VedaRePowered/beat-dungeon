local player = {}
local playerX = 8
local playerY = 10
function player.getPosition()
	return playerX, playerY
end
function player.update(delta)
	joystick = love.joystick.getJoysticks()[1]
	if math.abs(joystick:getAxis(1)) > 0.1 then
		playerX = playerX + joystick:getAxis(1) * delta * 4
	end
	if math.abs(joystick:getAxis(2)) > 0.1 then
		playerY = playerY - joystick:getAxis(2) * delta * 4
	end

end
return player
