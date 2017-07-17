require("tweaks.tweaks")
require("omppc.Mods")
require("omppc.Note")
require("omppc.Beatmap")
require("TimeRateChanger")

input = {}

for i = 1, #arg do
	local cArg = arg[i]
	local nArg = arg[i + 1]
	
	if cArg:sub(1, 1) == "-" then
		local key
		if cArg:sub(2, 2) == "-" then
			key = cArg:sub(3, -1)
		else
			key = cArg:sub(2, -1)
		end
		
		if key == "beatmap" or key == "b" then
			input.beatmapPath = nArg
		elseif key == "timerate" or key == "t" then
			input.timeRate = tonumber(nArg)
		elseif key == "interactive" or key == "i" then
			input.interactive = true
		elseif key == "audio" or key == "a" then
			input.audio = true
		elseif key == "starRate" or key == "s" then
			input.starRate = true
		end
		
		i = i + 1
	end
end

if input.interactive then
	if not input.beatmapPath then
		print("enter path to beatmap file")
		input.beatmapPath = io.read()
	end
	if not input.timeRate then
		print("enter time rate")
		input.timeRate = io.read()
	end
	if not input.audio then
		print("would you like to rate audio? (y/n)")
		input.audio = io.read() == "y"
	end
	if not input.starRate then
		print("would you like to calculate star rate? (y/n)")
		input.starRate = io.read() == "y"
	end
end

do
	print("processing beatmap...")
	timeRateChanger = TimeRateChanger:new()
	ratedFilePath = timeRateChanger:process(input.beatmapPath, input.timeRate)
end

if input.starRate then
	print("calculating star rate")
	originalBeatmap = Beatmap:new()
	originalBeatmap:parse(input.beatmapPath)
	originalBeatmap.mods = Mods:new():parse()

	ratedBeatmap = Beatmap:new()
	ratedBeatmap:parse(ratedFilePath)
	ratedBeatmap.mods = Mods:new():parse()

	print(" original: " .. originalBeatmap:getStarRate())
	print(" rated:    " .. ratedBeatmap:getStarRate())
end

if input.audio then
	print("processing audio...")
	local audio = timeRateChanger.mapFolderPath .. "\\" .. timeRateChanger.audio
	local ratedAudio = timeRateChanger.mapFolderPath .. "\\" .. timeRateChanger.ratedAudio
	sox = io.popen("sox\\sox.exe \"" .. audio .. "\" -t mp3 -C 192 \"" .. ratedAudio .. "\" tempo " .. input.timeRate)
	while sox:read(1) ~= nil do end
end

print("press enter to exit")
io.read()