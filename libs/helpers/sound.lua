---------------------------------------------- Sound
local path = ...
local folder = path:match("(.-)[^%.]+$")
local logger = require( folder.."logger" )
local extrafile = require( folder.."extrafile" )
local extrastring = require( folder.."extrastring" )
local al = require( "al" )
local json = require( "json" )
 
local sound = {}
--------------------------------------------- Variables
local enabled = true
local soundTable
local currentChannel

local completeFlagTable
local pitchSource, resultingChannel
local initialized
--------------------------------------------- Constants
local pitchChannel = 31
--------------------------------------------- Functions
function sound.setEnabled( value )
	enabled = value
	if not enabled then
		for channelIndex = 1, pitchChannel - 1 do
			audio.stop(channelIndex)
		end
	end
end

local function nextChannel()
	currentChannel = currentChannel + 1
	if currentChannel >= pitchChannel then
		currentChannel = 1
	end
end

local function playSound( sound, completeSound)
	completeFlagTable[currentChannel] = completeSound
	if completeSound then
		audio.play(sound, { channel = currentChannel, onComplete = function()
			completeFlagTable[currentChannel] = false
		end})
	else
		if not completeFlagTable[currentChannel] then
			if audio.isChannelActive(currentChannel) then
				audio.stop(currentChannel)
			end
			audio.play(sound, { channel = currentChannel})
		end
	end
	
	nextChannel()
end

function sound.loadSounds(soundlist)
	soundlist = soundlist or {}
	if not soundTable then
		soundTable = {}
	end
	
	if "table" == type(soundlist) then
		if #soundlist > 0 then
			logger.log("[Sound] Will load "..#soundlist.." sounds...")
			for index = 1, #soundlist do
				if soundlist[index] and soundlist[index].id and soundlist[index].path then
					soundTable[soundlist[index].id] = audio.loadSound(soundlist[index].path)
				end
			end
		else
			logger.log("[Sound] There were no sounds to load.")
		end
	elseif "string" == type(soundlist) then
		local soundFile = soundlist
		
		local path = system.pathForFile(soundFile, system.ResourceDirectory )
		local jsonSoundlist
		
		if pcall(function()
			local soundFile = io.open( path, "r" )
			local fileData = soundFile:read( "*a" )
			jsonSoundlist = json.decode(fileData)
			io.close(soundFile)
		end) then
			local realSoundList = {}
			for key, value in pairs(jsonSoundlist) do
				realSoundList[#realSoundList + 1] = {id = key, path = value}
			end
			sound.loadSounds(realSoundList)
		else
			logger.error([[[Sound] File "]]..fileName..[[" was not found.]])
		end
	end
end

function sound.loadDirectory(directoryPath)
	local allFiles = extrafile.getFiles(directoryPath)
	for index = 1, #allFiles do
		local fileName = allFiles[index]
		if string.len(fileName) >= 5 then -- "a.aaa"
			local split = extrastring.split(fileName, ".")
			if #split == 2 then
				if split[2] == "json" then
					sound.loadSounds(directoryPath..fileName)
				end
			end
		end
	end
end

function sound.playPitch( soundID , loopForever, pitch)
	local loops = loopForever and -1 or 0
	pitch = pitch or 1
	if not audio.isChannelActive( pitchChannel ) then
		resultingChannel, pitchSource = audio.play(soundTable[soundID], { channel = pitchChannel, loops = loops,})
		al.Source(pitchSource, al.PITCH, pitch)
		if resultingChannel == 0 then
			-- TODO handle not playing the sound
		end
	end
end

function sound.setPitch( pitch )
	if audio.isChannelActive( pitchChannel ) then
		pitch = pitch or 1
		if pitch and type(pitch) == "number" then
			al.Source(pitchSource, al.PITCH, pitch)
		end
	end
end

function sound.stopPitch()
	if audio.isChannelActive( pitchChannel ) then
		al.Source(pitchSource, al.PITCH, 1)
		audio.stop(pitchChannel)
	end
end

function sound.playRepeat(soundID)
	
end

function sound.play( soundID, completeSound)
	if enabled then	
		if soundTable[soundID] then
			playSound(soundTable[soundID], completeSound)
		else
			logger.error("[Sound] "..soundID.." is nil.")
		end
	end
end

local function initialize()
	if not initialized then
		initialized = true
		completeFlagTable = {}
		currentChannel = 1
		for index = currentChannel, pitchChannel - 1 do
			completeFlagTable[index] = false
		end
	end
end

initialize()

return sound