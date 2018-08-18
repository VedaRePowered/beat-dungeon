local music = {}

local songPath = "assets/music/bensound-house.mp3"
local songDataShared = nil

function getSongData()
	if songDataShared == nil then
		songDataShared = love.sound.newSoundData(songPath)
	end

	return songDataShared
end


--
-- Sample from the metered energy
--
-- No need to interpolate and it makes a tiny amount of difference; we
-- take a random sample of samples, any errors are averaged out.
--
-- nrg is float array
-- offset is double
function sample(nrg, offset)
	local n = math.floor(offset);

	if nrg[n] ~= nil then
		return nrg[n]
	else
		return 0.0
	end
end


local NRG_SAMPLING_INTERVAL = 128


--
-- Test an autodifference for the given interval
--
-- nrg is float array
-- interval is interval in energy space
function autodifference(nrg, interval, midpoint)
	local beats = { -32, -16, -8, -4, -2, -1, 1, 2, 4, 8, 16, 32 }
	local nobeats = { -0.5, -0.25, 0.25, 0.5 }

	local v = sample(nrg, midpoint)

	local diff = 0.0
	local total = 0.0

	for n = 1, #beats do
		local y = sample(nrg, midpoint + beats[n] * interval)
		local w = 1.0 / math.abs(beats[n])

		diff = diff + w * math.abs(y - v)
		total = total + w
	end

	for n = 1, #nobeats do
		local y = sample(nrg, midpoint + nobeats[n] * interval);
		local w = math.abs(nobeats[n])

		diff = diff - w * math.abs(y - v)
		total = total + w
	end

	return diff / total
end


--
-- Beats-per-minute to a sampling interval in energy space
--
function bpmToInterval(bpm, sampleRate)
	local beatsPerSecond = bpm / 60;
	local samplesPerBeat = sampleRate / beatsPerSecond;
	return samplesPerBeat / NRG_SAMPLING_INTERVAL;
end


--
-- Sampling interval in enery space to beats-per-minute
--
function intervalToBpm(interval, sampleRate)
	local samplesPerBeat = interval * NRG_SAMPLING_INTERVAL;
	local beatsPerSecond = sampleRate / samplesPerBeat;
	return beatsPerSecond * 60;
end


--
-- Scan a range of BPM values for the one with the
-- minimum autodifference
--
-- nrg is float array
-- slowest is the lowest possible BPM
-- fastest is the highest possible BPM
-- steps is ??
-- samples is ??
-- sampleRate is the sample rate of the sone in Hz
function scanForBpmAndOffset(nrg, slowest, fastest, steps, samples, sampleRate)
	local slowestInterval = bpmToInterval(slowest, sampleRate)
	local fastestInterval = bpmToInterval(fastest, sampleRate)
	local step = (slowestInterval - fastestInterval) / steps;

	local height = math.huge
	local trough
	local finalMidpoint

	for interval = fastestInterval, slowestInterval, step do
		local total = 0.0

		local midpointHeight = math.huge
		local bestMidpoint
		for s = 0, samples do
			local midpoint = math.random(1, #nrg)
			local diff = autodifference(nrg, interval, midpoint)

			if (diff < midpointHeight) then
				bestMidpoint = midpoint
				midpointHeight = diff
			end

			total = total + diff
		end

		-- Track the lowest value

		if (total < height) then
			trough = interval
			height = total
			finalMidpoint = bestMidpoint
		end
	end

	local beatsPerMinute = intervalToBpm(trough, sampleRate)

	local midpointSample = finalMidpoint * NRG_SAMPLING_INTERVAL
	local midpointTime = midpointSample / sampleRate
	local secondsPerBeat = 60 / beatsPerMinute
	local midpointOffset = midpointTime - math.floor(midpointTime / secondsPerBeat) * secondsPerBeat
	local offset = secondsPerBeat - midpointOffset

	-- print("Best midpoint is " .. finalMidpoint)
	-- print("Midpoint sample is " .. midpointSample)
	-- print("Midpoint time is " .. midpointTime)
	-- print("Seconds per beat is " .. secondsPerBeat)
	-- print("Midpoint offset is " .. midpointOffset)
	-- print("Offset offset is " .. offset)

	return beatsPerMinute, offset
end


--
-- Convert the given audio samples to sampled energy
-- values.
--
function samplesToNrg(samples)
	local nrg = {}
	local v = 0
	local n = 0

	for i = 1, #samples do
		z = samples[i]

		-- Maintain an energy meter (similar to PPM)

		z = math.abs(z)
		if (z > v) then
			v = v + (z - v) / 8
		else
			v = v- (v - z) / 512
		end

		-- At regular intervals, sample the energy to give a
		-- low-resolution overview of the track

		if i % NRG_SAMPLING_INTERVAL == 0 then
			table.insert(nrg, v)
		end
	end

	return nrg
end


--
-- Compute the BPM and offset for the given audio samples.
--
function computeBpmAndOffset(samples, sampleRate)
	local SLOWEST_BPM = 84
	local FASTEST_BPM = 146
	local BPM_STEPS = 2048
	local BPM_SAMPLES = 2048

	local nrg = samplesToNrg(samples)

	return scanForBpmAndOffset(nrg, SLOWEST_BPM, FASTEST_BPM, BPM_STEPS, BPM_SAMPLES, sampleRate);
end


--
-- Extract the audio samples from the given SongData
-- into a floating point array (table).
--
function getSamples(songData)
	local sampleCount = songData:getSampleCount()
	local samples = {}

	for i = 1, sampleCount do
		samples[i] = songData:getSample(i - 1)
	end

	return samples
end


--
-- Generates an array of beat timing positions in
-- seconds for a song.
--
function getBeats()
	local songData = getSongData()
	local duration = songData:getDuration()
	print("Duration is " .. duration)

	local sampleRate = songData:getSampleRate()
	print("Sample rate is " .. sampleRate)

	local samples = getSamples(songData)
	local beatsPerMinute, offset = computeBpmAndOffset(samples, sampleRate)
	print("BPM is " .. beatsPerMinute)
	print("Offset is " .. offset)

	local secondsPerBeat = 60 / beatsPerMinute
	print("Seconds per beat: " .. secondsPerBeat)
	local nextBeat = offset

	local beats = {}
	while nextBeat < duration do
		table.insert(beats, nextBeat)

		nextBeat = nextBeat + secondsPerBeat
	end

	return beats
end


local beats = getBeats()

local source = love.audio.newSource(getSongData())
love.audio.play(source)

local lastTime = 0
local nextBeat = 1


function music.getSongLength()
	return getSongData():getDuration()
end


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
