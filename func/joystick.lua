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
	if joystick.isPresent() then
		return gamepad:getAxis(1)
	else
		return false
	end
end
function joystick.getVerticalAxis()
	if joystick.isPresent() then
		return gamepad:getAxis(2)
	else
		return false
	end
end
function joystick.getActionButton()
	if joystick.isPresent() then
		return gamepad:isDown(1, 2, 3, 4)
	else
		return false
	end
end
function joystick.getRightBumper()
	if joystick.isPresent() then
		return gamepad:isDown(6)
	else
		return false
	end
end
function joystick.getLeftBumper()
	if joystick.isPresent() then
		return gamepad:isDown(5)
	else
		return false
	end
end
function joystick.vibrate(time)
	if joystick.isPresent() then
		gamepad:setVibration(1, 1, time)
	end
end
return joystick
