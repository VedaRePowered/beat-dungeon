local player = {}
local playerX
local playerY
local playerWidth = 32
local playerHeight = 32
local joystick
function player.initializeJoystick()
	joystick = love.joystick.getJoysticks()[1]
end
function player.getPosition()
	return playerX, playerY
end
function player.getScore()
	return math.floor(playerY - 32)
end
function player.resetPosition(width)
	playerX = (width / 2) + 1
	playerY = 32

	return player.getPosition()
end
function player.update(delta)
	local newPlayerX = playerX
	local newPlayerY = playerY
	if joystick then
		if math.abs(joystick:getAxis(1)) > 0.1 then
			newPlayerX = playerX + joystick:getAxis(1) * delta * 4
		end
		if math.abs(joystick:getAxis(2)) > 0.1 then
			newPlayerY = playerY - joystick:getAxis(2) * delta * 4
		end
	else
		if love.keyboard.isDown("up") then
			newPlayerY = playerY + delta * 4
		elseif love.keyboard.isDown("down") then
			newPlayerY = playerY - delta * 4
		end
		if love.keyboard.isDown("right") then
			newPlayerX = playerX + delta * 4
		elseif love.keyboard.isDown("left") then
			newPlayerX = playerX - delta * 4
		end
	end

	playerX, playerY = world.limitMovement(playerX, playerY, newPlayerX, newPlayerY)
	-- print("player: " .. playerX .. ", " .. playerY)
end
function player.draw()
	local width, height = love.window.getMode()

	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("fill", width/2-playerWidth/2, height/2-playerHeight/2, playerWidth, playerHeight)
	love.graphics.setColor(255,255,255)

	-- love.graphics.draw(tile.image, (x-pOffsetX)*32*2+width/2, 720-((y-pOffsetY)*32*2+height/2)-128, 0, 2, 2)
end
return player
