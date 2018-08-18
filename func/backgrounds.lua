local backgrounds = {}
local bg = {}
bg.cobblestone = love.graphics.newImage("assets/backgrounds/cobblestone.png")
function backgrounds.draw(type)
	local width, height = love.window.getMode()
	local playerX, playerY = player.getPosition()
	local pOffsetX = (playerX - math.floor(playerX))
	local pOffsetY = (playerY - math.floor(playerY))
	local screenBlocksX = math.ceil(width/96)
	local screenBlocksY = math.ceil(height/96)
	for x = math.floor(-screenBlocksX/2), screenBlocksX/2 do
		for y = math.floor(-screenBlocksY/2), screenBlocksY/2 do
			love.graphics.draw(bg[type], (x-pOffsetX)*96+width/2, 720-((y-pOffsetY)*96+height/2)-96, 0, 1, 1)
		end
	end
end
return backgrounds
