local music = {}

local songPath = "assets/music/bensound-house.mp3"
local songDataShared = nil

function getSongData()
	if songDataShared == nil then
		songDataShared = love.sound.newSoundData(songPath)
	end

	return songDataShared
end

-- the frequency used for the low pass filter
local lowPassFreq = 500
-- the beat butoff amount
local beatCutoff = 0.5

function getBeats()
	local songData = getSongData()
	-- print(songData.getDuration())
	debug.debug()
	local sampleRate = songData.getSampleRate()
	print(sampleRate)
	local sampleCount = songData.getSampleCount()
	print(sampleCount)
	local samples = {}

	for i = 1, sampleCount do
		samples[i] = songData.getSample(i - 1) + 1
	end

	-- tau is the number of seconds in one wavelength of the low pass frequency
	local tau = 1 / lowPassFreq
	-- formula for alpha from https://www.embeddedrelated.com/showarticle/779.php
	local alpha = (1 / sampleRate) / tau

	local lowPasSamples = {}
	local yk = samples[1]
	lowPasSamples[1] = yk
	for i = 2, sampleCount do
		yk = yk + alpha * (samples[i] - yk)
		lowPasSamples[k] = yk
	end

	local beats = {}
	for i = 2, sampleCount do
		if lowPasSamples[i] > lowPasSamples[i - 1] + beatCutoff then
			table.insert(beats, i / sampleRate)
		end
	end

	return beats
end

local beats = getBeats()

function music.getSongLength()
	return getSongData().getDuration()
end

local lastTime = 0
local nextBeat = 1

function music.getBeatsPassed(delta)
	local beatCount = 0
	local newTime = lastTime + delta

	while beats[nextBeat] < newTime do
		beatCount = beatCount + 1
		nextBeat = nextBeat + 1
	end

	lastTime = newTime

	return beatCount
end

return music
