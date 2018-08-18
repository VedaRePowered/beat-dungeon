local music = {}

local songPath = "assets/music/bensound-house.mp3"
local songDataShared = nil

function getSongData()
	if songDataShared == nil then
		songDataShared = love.sound.newSoundData(songPath)
	end

	return songDataShared
end


local beatsPerMinute = 132
local offset = 0.2

function getBeats()
	local songData = getSongData()
	local duration = songData:getDuration()
	print("Duration is " .. duration)

	local secondsPerBeat = 60 / beatsPerMinute
	print("Seconds per beat: " .. secondsPerBeat)
	local nextBeat = offset

	local beats = {}
	while nextBeat < duration do
		table.insert(beats, nextBeat)
		print("Beat at " .. nextBeat)

		nextBeat = nextBeat + secondsPerBeat
	end

	local source = love.audio.newSource(songData)
	love.audio.play(source)

	return beats
end

local beats = getBeats()

function music.getSongLength()
	return getSongData():getDuration()
end

local lastTime = 0
local nextBeat = 1

function music.getBeatsPassed(delta)
	local beatCount = 0
	local newTime = lastTime + delta

	while nextBeat <= #beats and beats[nextBeat] < newTime do
		beatCount = beatCount + 1
		nextBeat = nextBeat + 1
	end

	lastTime = newTime

	return beatCount
end

return music
