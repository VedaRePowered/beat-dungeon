local tiles = {}
local tileList = {}

function tiles.declareTiles()
	tiles.declare("pillar", "none", "tiles/pillar")
	tiles.declare("spikes", "none", "tiles/spikes1")
end

function tiles.declare(name, patternFile, image)
	id = #tileList + 1
	p = io.open("assets/patterns/" .. patternFile .. ".txt")
	pattern = {}
	for _, action in p:lines() do
		table.insert(pattern, action)
	end
	tileList[id] = {name=name, pattern=pattern, image=love.graphics.newImage("assets/" .. image .. ".png")}
	p.close()
end
function tiles.random()
	return math.random(1, #tileList)
end
function tiles.get(id)
	return tileList[id]
end
return tiles
