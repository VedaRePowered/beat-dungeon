local player = {}
local playerX
local playerY
local playerWidth = 64
local playerHeight = 64
local joystick
local moveTime = 0

local playerDirection = "up"
local playerImages = {
	up = {
		love.graphics.newImage("assets/character/characterUp1.png"),
		love.graphics.newImage("assets/character/characterUp2.png")
	},
	down = {
		love.graphics.newImage("assets/character/characterDown1.png"),
		love.graphics.newImage("assets/character/characterDown2.png")
	},
	left = {
		love.graphics.newImage("assets/character/characterLeft1.png"),
		love.graphics.newImage("assets/character/characterLeft2.png")
	},
	right = {
		love.graphics.newImage("assets/character/characterRight1.png"),
		love.graphics.newImage("assets/character/characterRight2.png")
	}
}

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
	local moved = false
	if joystick then
		local yAmount = math.abs(joystick:getAxis(2))
		local xAmount = math.abs(joystick:getAxis(1))
		if yAmount > 0.1 then
			moved = true
			newPlayerY = playerY - joystick:getAxis(2) * delta * 4
			if joystick:getAxis(2) < 0 then
				playerDirection = "up"
			else
				playerDirection = "down"
			end
		end
		if xAmount > 0.1 then
			moved = true
			newPlayerX = playerX + joystick:getAxis(1) * delta * 4
			if xAmount > yAmount then
				if joystick:getAxis(1) < 0 then
					playerDirection = "left"
				else
					playerDirection = "right"
				end
			end
		end
	else
		if love.keyboard.isDown("up") then
			moved = true
			newPlayerY = playerY + delta * 4
			playerDirection = "up"
		elseif love.keyboard.isDown("down") then
			moved = true
			newPlayerY = playerY - delta * 4
			playerDirection = "down"
		end
		if love.keyboard.isDown("right") then
			moved = true
			newPlayerX = playerX + delta * 4
			playerDirection = "right"
		elseif love.keyboard.isDown("left") then
			moved = true
			newPlayerX = playerX - delta * 4
			playerDirection = "left"
		end
	end
	if moved then
		moveTime = moveTime + delta
	else
		moveTime = 0
	end

	playerX, playerY = world.limitMovement(playerX, playerY, newPlayerX, newPlayerY)
	-- print("player: " .. playerX .. ", " .. playerY)
end
function player.draw()
	local width, height = love.window.getMode()
	local frame = math.floor(moveTime / 0.2) % 2 + 1

	love.graphics.draw(playerImages[playerDirection][frame], width / 2 - 16, height / 2 - playerHeight + 16)
end
return player
