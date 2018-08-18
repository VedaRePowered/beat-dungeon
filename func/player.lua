local player = {}
local playerX = 8
local playerY = 10
local playerWidth = 32
local playerHeight = 32
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
function player.draw()
	local width, height = love.window.getMode()

	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("fill", width/2-playerWidth/2, height/2-playerHeight/2, playerWidth, playerHeight)
	love.graphics.setColor(255,255,255)

	-- love.graphics.draw(tile.image, (x-pOffsetX)*32*2+width/2, 720-((y-pOffsetY)*32*2+height/2)-128, 0, 2, 2)
end
return player
