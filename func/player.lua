local player = {}
local playerX = 8
local playerY = 10
local playerWidth = 32
local playerHeight = 32
local joystick
function player.initializeJoystick()
	joystick = love.joystick.getJoysticks()[1]
end
function player.getPosition()
	return playerX, playerY
end
function player.update(delta)
	if joystick then
		if math.abs(joystick:getAxis(1)) > 0.1 then
			playerX = playerX + joystick:getAxis(1) * delta * 4
		end
		if math.abs(joystick:getAxis(2)) > 0.1 then
			playerY = playerY - joystick:getAxis(2) * delta * 4
		end
	else
		if love.keyboard.isDown("up") then
			playerY = playerY + delta * 4
		elseif love.keyboard.isDown("down") then
			playerY = playerY - delta * 4
		end
		if love.keyboard.isDown("right") then
			playerX = playerX + delta * 4
		elseif love.keyboard.isDown("left") then
			playerX = playerX - delta * 4
		end
	end

	local width, height = world.getSize()
	if playerX < 1 then
		playerX = 1
	end
	if playerX > width + 1 then
		playerX = width + 1
	end
	if playerY < 1 then
		playerY = 1
	end
	if playerY > height + 1 then
		playerY = height + 1
	end
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
