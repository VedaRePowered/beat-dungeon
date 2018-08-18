local music = {}

local songPath = "assets/music/bensound-house.mp3"
local songDataShared = nil

function getSongData()
	if songDataShared == nil then
		songDataShared = love.sound.newSoundData(songPath)
	end

	return songDataShared
end

function getMax(table)
	local max = table[1]
	for i = 2, #table do
		if table[i] > max then
			max = table[i]
		end
	end

	return max
end

function getMin(table)
	local min = table[1]
	for i = 2, #table do
		if table[i] < min then
			min = table[i]
		end
	end

	return min
end

-- the frequency used for the low pass filter
local lowPassFreq = 140
-- the beat cutoff amount
local beatCutoff = 100
-- the goal Hz of the analysis
local reduction = 1000

function getBeats()
	local songData = getSongData()
	print("Duration is " .. songData:getDuration())
	local sampleRate = songData:getSampleRate()
	print("Sample rate is " .. sampleRate)
	local sampleCount = songData:getSampleCount()
	print("Sample count is " .. sampleCount)
	local samples = {}

	for i = 1, sampleCount do
		samples[i] = songData:getSample(i - 1)
	end

	-- tau is the number of seconds in one wavelength of the low pass frequency
	local tau = 1 / lowPassFreq
	-- formula for alpha from https://www.embeddedrelated.com/showarticle/779.php
	local alpha = (1 / sampleRate) / tau

	-- perform low pass filtering
	local lowPasSamples = {}
	local yk = 0
	for i = 1, sampleCount do
		yk = yk + alpha * (samples[i] - yk)
		lowPasSamples[i] = yk
	end

	-- average samples in groups of "reduction"
	local reducedSamples = {}
	local reducedSamplesCount = sampleCount / reduction
	for i = 1, reducedSamplesCount do
		-- local total = 0
		-- for j = 1, reduction do
		-- 	local sample = (i - 1) * reduction + j
		-- 	total = total + math.abs(lowPasSamples[sample])
		-- end
		-- reducedSamples[i] = total / reduction

		reducedSamples[i] = lowPasSamples[(i - 1) * reduction + 1]
	end

	-- average samples in groups of "reduction"
	local normalizedSamples = {}
	normalizedSamples[1] = math.abs(reducedSamples[1])
	for i = 2, reducedSamplesCount do
		normalizedSamples[i] = math.abs(reducedSamples[i] - reducedSamples[i - 1])
	end

	-- find min and max to generate a beat threshold
	local max = getMax(normalizedSamples)
	local min = getMin(normalizedSamples)
	local threshold = ((max - min) * 0.3) + min

	-- find the beats
	local beats = {}
	for i = 1, reducedSamplesCount - 2 do
		if normalizedSamples[i] > threshold and normalizedSamples[i + 1] < threshold and normalizedSamples[i + 2] < threshold then
			table.insert(beats, (i * reduction / sampleRate))
			print("Beat at " .. (i * reduction / sampleRate))
		end
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
