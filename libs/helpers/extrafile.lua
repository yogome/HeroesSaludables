----------------------------------------------- Extra file
local path = ...
local folder = path:match("(.-)[^%.]+$")
local logger = require( folder.."logger" ) 
local extrastring = require( folder.."extrastring" )
local lfs = require( "lfs" )
local json = require( "json" )

local extrafile = {}
---------------------------------------------- Variables
local cacheFilesystem 
---------------------------------------------- Constants 
local DATA_DIRECTORY = "data"
local FILESYSTEM_CACHE_FILENAME = "filesystem.json"
---------------------------------------------- Functions
local function fileExists(fileName, directory)
	directory = directory or system.ResourceDirectory
	local absolutePath = system.pathForFile(fileName, directory) -- Works on mac
	if absolutePath then
		local openFile = io.open(absolutePath, "r")
		if openFile then
			logger.log([[[Extrafile] File "]]..tostring(fileName)..[[" was found]])
			openFile:close()
			return true
		else
			logger.error([[[Extrafile] Attempt to open "]]..tostring(fileName)..[[" failed]])
			return false
		end
	else
		logger.error([[[Extrafile] Attempt to open "]]..tostring(fileName)..[[" failed]])
	end
end

local function getFiles(directoryName)
	local filenames = {}
	local baseDir = system.pathForFile().."/" or ""
	for fileName in lfs.dir(baseDir .. directoryName) do
		if string.sub(fileName, 1, 1) ~= "." then
			table.insert(filenames, fileName)
		end
	end
	if #filenames == 0 then return false end
	return filenames
end
---------------------------------------------- Module functions
function extrafile.exists(fileName, directory)
	if fileName and "string" == type(fileName) then
		if cacheFilesystem then
			local fileStrings = extrastring.split(fileName, "/")
			local lastPathTable = cacheFilesystem
			local existsInCache = false
			for index = 1, #fileStrings do
				if lastPathTable then
					lastPathTable = lastPathTable[fileStrings[index]]
					existsInCache = lastPathTable == "file" or type(lastPathTable) == "table"
				else
					existsInCache = false
				end
			end
			if existsInCache then
				return true
			else
				logger.log([[[Extrafile] File "]]..tostring(fileName)..[[" does not exist in cache]])
				return fileExists(fileName, directory)
			end
		else
			if not string.match(fileName, "%.lua") then
				return fileExists(fileName, directory)
			else
				logger.error("[Extrafile] LUA files are not present in device builds, cache the filesystem first.")
				return false
			end
		end
	else
		logger.error("[Extrafile] filename must be a string")
		return false
	end
end

function extrafile.getFiles(directoryName)
	if cacheFilesystem then
		local directoryStrings = extrastring.split(directoryName, "/")
		local lastPathTable = cacheFilesystem
		local existsInCache = false
		for index = 1, #directoryStrings do
			if lastPathTable then
				lastPathTable = lastPathTable[directoryStrings[index]]
				existsInCache = lastPathTable ~= nil
			else
				existsInCache = false
			end
		end
		if existsInCache then
			local files = {}
			for key, value in pairs(lastPathTable) do
				files[#files + 1] = key
			end
			return files
		else
			return getFiles(directoryName)
		end
	else
		return getFiles(directoryName)
	end
end

function extrafile.cacheFileSystem(showGitVersion)
	local function getFileSystemTable(path)
		local files = extrafile.getFiles(path)
		local fileTable = {}
		if files then
			for index = 1, #files do
				local fileName = files[index]
				if not string.find(fileName, "%.") then
					fileTable[fileName] = getFileSystemTable(path.."/"..fileName)
				else
					fileTable[fileName] = "file"
				end
			end
		end
		return fileTable
	end
	
	local environment = system.getInfo("environment")
	if environment == "simulator" then
		logger.log("[Extrafile] Caching filesystem")
		local baseDir = system.pathForFile().."/"
		local fileSystemFile = io.open(baseDir..DATA_DIRECTORY.."/"..FILESYSTEM_CACHE_FILENAME, "w")
		if fileSystemFile then
			cacheFilesystem = getFileSystemTable("")
				
			local filesystemData = {
				cacheFilesystem = cacheFilesystem,
			}
			
			local fileSystemJson = json.encode(filesystemData)
			fileSystemFile:write(tostring(fileSystemJson))
			io.close(fileSystemFile)
		end
	else
		if not cacheFilesystem then
			local path = system.pathForFile(DATA_DIRECTORY.."/"..FILESYSTEM_CACHE_FILENAME, system.ResourceDirectory )
			local fileSystemFile = io.open(path, "r")
			if fileSystemFile then
				local fileString = fileSystemFile:read("*a")
				local filesystemData = json.decode(fileString)
				cacheFilesystem = filesystemData.cacheFilesystem
			else
				logger.error("[Extrafile] Could not load filesystem cache")
			end
		end
	end
end

function extrafile.getLines(fileName)
	if not extrafile.exists(fileName) then
		return {}
	end
	local fileLines = {}
	for readLine in io.lines(fileName) do 
		fileLines[#fileLines + 1] = readLine
	end
	return fileLines
end

return extrafile
