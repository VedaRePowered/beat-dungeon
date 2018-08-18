local backgrounds = {}
local bg = {}

local tileSize, tileFactor = tiles.getTileSizeAndFactor()

bg.cobblestone = {
	image=love.graphics.newImage("assets/backgrounds/cobblestone.png"),
	width=96,
	height=96,
	scale=1
}
bg.cobblestone2 = {
	image=love.graphics.newImage("assets/backgrounds/cobblestone2.png"),
	width=32,
	height=32,
	scale=1
}
bg.dirt1 = {
	image=love.graphics.newImage("assets/backgrounds/dirt1.png"),
	width=32,
	height=64,
	scale=2
}
bg.dirt2 = {
	image=love.graphics.newImage("assets/backgrounds/dirt2.png"),
	width=32,
	height=64,
	scale=2
}
function backgrounds.draw(type)
	local width, height = love.window.getMode()
	local playerX, playerY = player.getPosition()
	local backGroundFactor = bg[type].scale
	local backgroundWidth = bg[type].width * backGroundFactor
	local backgroundHeight = bg[type].height * backGroundFactor
	local backgroundRatioX = backgroundWidth / (tileSize * tileFactor)
	local backgroundRatioY = backgroundHeight / (tileSize * tileFactor)
	local pOffsetX = (playerX / backgroundRatioX - math.floor(playerX / backgroundRatioX))
	local pOffsetY = (playerY / backgroundRatioY - math.floor(playerY / backgroundRatioY))
	local screenBlocksX = math.ceil(width / backgroundWidth)
	local screenBlocksY = math.ceil(height / backgroundHeight)
	for x = math.floor(-screenBlocksX / 2), screenBlocksX / 2 do
		for y = math.floor(-screenBlocksY / 2), screenBlocksY / 2 do
			love.graphics.draw(
				bg[type].image,
				(x-pOffsetX)*backgroundWidth+width/2,
				720-((y-pOffsetY)*backgroundHeight+height/2)-backgroundHeight,
				0,
				backGroundFactor,
				backGroundFactor)
		end
	end
end
return backgrounds
