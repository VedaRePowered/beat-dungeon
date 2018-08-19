local player = {}
local playerX
local playerY
local playerWidth = 64
local playerHeight = 64
local heart = tiles.loadImage("assets/heart.png")
local health = 4
local moveTime = 0
local hurtCooldown = 0

local playerDirection = "up"
local playerImages = {
	up = {
		tiles.loadImage("assets/character/characterUp1.png"),
		tiles.loadImage("assets/character/characterUp2.png")
	},
	down = {
		tiles.loadImage("assets/character/characterDown1.png"),
		tiles.loadImage("assets/character/characterDown2.png")
	},
	left = {
		tiles.loadImage("assets/character/characterLeft1.png"),
		tiles.loadImage("assets/character/characterLeft2.png")
	},
	right = {
		tiles.loadImage("assets/character/characterRight1.png"),
		tiles.loadImage("assets/character/characterRight2.png")
	}
}

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
	hurtCooldown = hurtCooldown - delta * 2
	if hurtCooldown < 0 then
		hurtCooldown = 0
	end
	local newPlayerX = playerX
	local newPlayerY = playerY
	local moved = false
	if joystick.isPresent() then
		local yAmount = math.abs(joystick.getVerticalAxis())
		local xAmount = math.abs(joystick.getHorizontalAxis())
		if yAmount > 0.1 then
			moved = true
			newPlayerY = playerY - joystick.getVerticalAxis() * delta * 4
			if joystick.getVerticalAxis() < 0 then
				playerDirection = "up"
			else
				playerDirection = "down"
			end
		end
		if xAmount > 0.1 then
			moved = true
			newPlayerX = playerX + joystick:getHorizontalAxis() * delta * 4
			if xAmount > yAmount then
				if joystick:getHorizontalAxis() < 0 then
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

	love.graphics.draw(playerImages[playerDirection][frame], width / 2 - playerWidth / 2, height / 2 - playerHeight * 1.5, 0, 2, 2)
end
function player.changeHealth(by)
	health = health + by
	hurtCooldown = 1
	if health < 1 then
		mode = "end"
		song.stop()
	end
end
function player.drawHUD()
	local width, height = love.window.getMode()
	love.graphics.print("Score: " .. math.floor(playerY - 32), 15, 10)
	for i = 1, health do
		love.graphics.draw(heart, 1280-20*i-15, 15, 0, 2, 2)
	end
	local minuets = math.floor(song.getSongRemaining()/60)
	local seconds = math.floor(song.getSongRemaining()%60)
	love.graphics.print(minuets .. ":" .. seconds, 15, 669)
	if hurtCooldown > 0 then
		love.graphics.setColor(231/256, 76/256, 60/256, hurtCooldown)
		love.graphics.rectangle("fill", 0, 0, width, height)
		love.graphics.setColor(1, 1, 1, 1)
	end
end
return player
