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
		end
		
		i = i + 1
	end
end

originalBeatmap = Beatmap:new()
originalBeatmap:parse(input.beatmapPath)
originalBeatmap.mods = Mods:new():parse()

timeRateChanger = TimeRateChanger:new()
ratedFilePath = timeRateChanger:process(input.beatmapPath, input.timeRate)
ratedBeatmap = Beatmap:new()
ratedBeatmap:parse(ratedFilePath)
ratedBeatmap.mods = Mods:new():parse()

print("Original starrate:", originalBeatmap:getStarRate())
print("Rated starrate: ", ratedBeatmap:getStarRate())