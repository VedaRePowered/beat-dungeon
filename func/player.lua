local player = {}
local playerX
local playerY
local playerWidth = 64
local playerHeight = 64
local heart = tiles.loadImage("assets/heart.png")
local health = 4
local moveTime = 0
local hurtCooldown = 0
local lastHit
local weaponCooldown = 1
local weaponPhase = 0

local axe = tiles.loadImage("assets/tools/axe1.png")
local dagger = tiles.loadImage("assets/tools/dagger.png")
local axeOut = 0
local daggerOut = 0

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
	health = 4
	lastHit = nil
	hurtCooldown = 0

	return player.getPosition()
end
function player.update(delta)
	hurtCooldown = hurtCooldown - delta * 2
	if hurtCooldown < 0 then
		hurtCooldown = 0
	end
	weaponCooldown = weaponCooldown - delta * 1
	if weaponCooldown < 0 then
		weaponCooldown = 0
	end
	axeOut = axeOut - delta * 5
	if axeOut < 0 then
		axeOut = 0
	end
	daggerOut = daggerOut - delta * 5
	if daggerOut < 0 then
		daggerOut = 0
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
		if joystick.getRightBumper() then
			player.attack("axe")
		end
		if joystick.getLeftBumper() then
			player.attack("dagger")
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
		if love.keyboard.isDown("z") then
			player.attack("axe")
		end
		if love.keyboard.isDown("x") then
			player.attack("dagger")
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

	if daggerOut ~= 0 then
		local xDagger, yDagger, rot = 0, 0, 0
		yDagger = math.abs(daggerOut-0.5)*32
		if playerDirection == "down" or playerDirection == "right" then
			yDagger = yDagger * -1
			rot = math.pi
		end
		if playerDirection == "left" or playerDirection == "right" then
			xDagger = yDagger
			yDagger = 0
			rot = rot - math.pi/2
		end
		love.graphics.draw(dagger,  width / 2 - 16 + xDagger, height / 2 - 96 + yDagger, rot, 2, 2)
	end
	if axeOut ~= 0 then
		local rot = axeOut + math.pi * 1.75
		if playerDirection == "down" or playerDirection == "right" then
			rot = rot + math.pi
		end
		if playerDirection == "left" or playerDirection == "right" then
			rot = rot - math.pi/2
		end
		love.graphics.draw(axe, width / 2 - 16, height / 2 - 64, rot, 1, 1, 16, 32)
	end

	love.graphics.draw(playerImages[playerDirection][frame], width / 2 - playerWidth / 2, height / 2 - playerHeight * 1.5, 0, 2, 2)
end
function player.changeHealth(by, damageSource)
	health = health + by
	hurtCooldown = 1
	lastHit = damageSource
	joystick.vibrate(0.5)
	if health < 1 then
		mode = "end"
		song.stop()
	end
end
function player.getEndReason()
	if health > 0 then
		return "Ran out of time!"
	else
		return "Killed by " .. lastHit
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
	if seconds < 10 then
		seconds = "0" .. seconds
	end
	love.graphics.print(minuets .. ":" .. seconds, 15, 669)
	if hurtCooldown > 0 then
		love.graphics.setColor(231/256, 76/256, 60/256, hurtCooldown)
		love.graphics.rectangle("fill", 0, 0, width, height)
		love.graphics.setColor(1, 1, 1, 1)
	end
end
function player.attack(weapon)
	if weaponCooldown == 0 then
		local damage, areaOfEffect = 0, 0
		if weapon == "dagger" then
			daggerOut = 1
			weaponCooldown = 0.5
			if math.random(1, 5) == 1 then
				local xOffset, yOffset = 1, 0
				if playerDirection == "left" or playerDirection == "down" then
					xOffset = xOffset * -1
				end
				if playerDirection == "up" or playerDirection == "down" then
					yOffset = xOffset
					xOffset = 0
				end
				world.unset(math.floor(playerX+xOffset), math.floor(playerY+yOffset))
			end
		elseif weapon == "axe" then
			axeOut = math.pi / 2
			weaponCooldown = 2.5
			for i = -1, 1 do
				if math.random(1, 2) == 1 then
					local xOffset, yOffset = 1, i
					if playerDirection == "left" or playerDirection == "down" then
						xOffset = xOffset * -1
						yOffset = yOffset * -1
					end
					if playerDirection == "up" or playerDirection == "down" then
						local tmp = yOffset
						yOffset = xOffset
						xOffset = tmp
					end
					world.unset(math.floor(playerX+xOffset), math.floor(playerY+yOffset))
				end
			end
		end
	end
end
return player
