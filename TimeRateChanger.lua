TimeRateChanger = createClass()

TimeRateChanger.process = function(self, filePath, timeRate)
	local fileLines = {}
	
	local file = io.open(filePath, "r")
	for line in file:lines() do
		table.insert(fileLines, line)
	end
	file:close()
	
	local blockName
	for i = 1, #fileLines do
		local line = fileLines[i]
		while line:trim() == "" do
			i = i + 1
			line = fileLines[i]
		end
		
		if line:sub(1,1) == "[" then
			blockName = line:trim():sub(2, -2)
		elseif blockName == "General" then
			if line:startsWith("PreviewTime") then
				fileLines[i] = "PreviewTime: " .. math.floor(line:sub(#"PreviewTime: ") / timeRate)
			elseif line:startsWith("AudioFilename") then
				local audio = line:sub(#"AudioFilename: "):trim()
				local audioTable = audio:split(".")
				audioTable[#audioTable - 1] = audioTable[#audioTable - 1] .. timeRate
				fileLines[i] = "AudioFilename: " .. table.concat(audioTable, ".")
			end
		elseif blockName == "Metadata" then
			if line:startsWith("Version") then
				fileLines[i] = fileLines[i] .. " [" .. timeRate .. "x]"
			end
		elseif blockName == "Editor" then
			if line:startsWith("Bookmarks") then
				local bookmarksTable = line:sub(#"Bookmarks: "):split(",")
				for i = 1, #bookmarksTable do
					bookmarksTable[i] = math.floor(bookmarksTable[i] / timeRate)
				end
				fileLines[i] = "Bookmarks: " .. table.concat(bookmarksTable, ",")
			end		
		elseif blockName == "Events" then
			if line:startsWith("Sample") or line:startsWith("Video") then
				local sampleTable = line:split(",")
				sampleTable[2] = math.floor(sampleTable[2] / timeRate)
				fileLines[i] = table.concat(sampleTable, ",")
			elseif line:startsWith(" ") or line:startsWith("_") then
				local eventTable = line:split(",")
				eventTable[3] = math.floor(eventTable[3] / timeRate)
				if eventTable[4] ~= "" then
					eventTable[4] = math.floor(eventTable[4] / timeRate)
				end
				fileLines[i] = table.concat(eventTable, ",")
			end
		elseif blockName == "TimingPoints" then
			local timingPointTable = line:split(",")
			timingPointTable[1] = math.floor(timingPointTable[1] / timeRate)
			if tonumber(timingPointTable[2]) > 0 then
				timingPointTable[2] = timingPointTable[2] / timeRate
			end
			fileLines[i] = table.concat(timingPointTable, ",")
		elseif blockName == "HitObjects" then
			local hitObjectTable = line:split(",")
			hitObjectTable[3] = math.floor(hitObjectTable[3] / timeRate)
			hitObjectTable[6] = hitObjectTable[6]:split(":")
			if #hitObjectTable[6] == 5 then
				hitObjectTable[6][1] = math.floor(hitObjectTable[6][1] / timeRate)
			end
			hitObjectTable[6] = table.concat(hitObjectTable[6], ":") .. ":"
			fileLines[i] = table.concat(hitObjectTable, ",")
		end
	end
	
	local ratedFilePath = filePath:sub(1, -6) .. " [" .. timeRate .. "x]].osu"
	local file = io.open(ratedFilePath, "w+")
	file:write(table.concat(fileLines, "\n"))
	file:close()
	
	return ratedFilePath
end