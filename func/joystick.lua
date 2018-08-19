local joystick = {}
local gamepad

function joystick.initialize()
	gamepad = love.joystick.getJoysticks()[1]
end
function joystick.isPresent()
	if gamepad then
		return true
	else
		return false
	end
end
function joystick.getHorizontalAxis()
	return gamepad:getAxis(1)
end
function joystick.getVerticalAxis()
	return gamepad:getAxis(2)
end
function joystick.getActionButton()
	return gamepad:isDown(1, 2, 3, 4)
end

return joystick
