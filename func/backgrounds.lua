local backgrounds = {}
local bg = {}

local backgroundSize = 96
local backGroundFactor = 1
local tileSize, tileFactor = tiles.getTileSizeAndFactor()
local backgroundRatio = (backgroundSize * backGroundFactor) / (tileSize * tileFactor)

bg.cobblestone = love.graphics.newImage("assets/backgrounds/cobblestone.png")
function backgrounds.draw(type)
	local width, height = love.window.getMode()
	local playerX, playerY = player.getPosition()
	local pOffsetX = (playerX / backgroundRatio - math.floor(playerX / backgroundRatio))
	local pOffsetY = (playerY / backgroundRatio - math.floor(playerY / backgroundRatio))
	local screenBlocksX = math.ceil(width/backgroundSize)
	local screenBlocksY = math.ceil(height/backgroundSize)
	for x = math.floor(-screenBlocksX/2), screenBlocksX/2 do
		for y = math.floor(-screenBlocksY/2), screenBlocksY/2 do
			love.graphics.draw(bg[type], (x-pOffsetX)*backgroundSize+width/2, 720-((y-pOffsetY)*backgroundSize+height/2)-backgroundSize, 0, backGroundFactor, backGroundFactor)
		end
	end
end
return backgrounds
