------------------------------------------- Localization
local path = ...
local folder = path:match("(.-)[^%.]+$") 
local logger = require( folder.."logger" )
local database = require( folder.."database" )
local extrafile = require( folder.."extrafile" )
local extratable = require( folder.."extratable" )
local json = require ( "json" )

local localization = {}
------------------------------------------- Variables
local initialized
local dictionary
local customDictionary
------------------------------------------- Constants
local STRING_MISSING = "MISSING STRING"
local LANGUAGE_DEFAULT = "en"
------------------------------------------- Functions
local function addEntries(languageDictionary, fileName, language)
	local path = system.pathForFile(localization.dataPath..fileName, system.ResourceDirectory )
	
	local isOriginalFile = fileName == (language..".json")
	
	local fileEntries
	if pcall(function()
		local languageFile = io.open( path, "r" )
		local savedData = languageFile:read( "*a" )
		fileEntries = json.decode(savedData)
		io.close(languageFile)
	end) then
		logger.log([[[Localization] File "]]..fileName..[[" was loaded to "]]..language..[[".]])
	else
		logger.error([[[Localization] File "]]..fileName..[[" for "]]..language..[[" was not found.]])
	end
	
	if fileEntries and not extratable.isEmpty(fileEntries) then
		for key, value in pairs(fileEntries) do
			if not languageDictionary[key] then
				languageDictionary[key] = value
			elseif isOriginalFile then
				languageDictionary[key] = value
				logger.error([[[Localization] String "]]..key..[[" is present in other language file, will overwrite with main entry.]])
			else
				logger.error([[[Localization] String "]]..key..[[" is present in other language file.]])
			end
		end
	end
end


local function loadLanguageFiles(language)
	local fileList = extrafile.getFiles(localization.dataPath)
	
	local languageDictionary = {}
	if fileList and #fileList > 0 then
		for index = 1, #fileList do
			local fileName = fileList[index]
			if string.len(fileName) >= 7 then -- Seven characters at least. "en.json"
				if string.sub(fileName, 1, 2) == language then
					addEntries(languageDictionary, fileName, language)
				end
			end
		end
	end
	
	return languageDictionary
end
------------------------------------------- Module functions
function localization.setLanguage(language)
	language = language or LANGUAGE_DEFAULT
	localization.language = language
	
	dictionary = loadLanguageFiles(language)
	
	if dictionary and not extratable.isEmpty(dictionary) then
		database.config("language", language)
	else
		logger.error([[[Localization] Language "]]..language..[[" contains no data.]])
	end
end

function localization.format(stringIn)
	if initialized then
		return string.format(stringIn, localization.language)
	else
		logger.error("[Localization] You must initialize first.")
	end
	return ""
end

function localization.getLanguage()
	return localization.language or "en"
end

function localization.initialize(parameters)
	parameters = parameters or {}
	if not initialized then 
		logger.log("[Localization] Initializing.")
		initialized = true
		customDictionary = {}
		
		local language = database.config( "language" )
		if not language then
			logger.log("[Localization] Autodetecting language.")
			local systemLanguage = system.getPreference( "locale", "language" )
			logger.log("[Localization] Detected language "..systemLanguage)
			language = systemLanguage
		end
		
		localization.dataPath = parameters.dataPath or ""
		local languageFileExists = extrafile.exists(localization.dataPath..language..".json")
		localization.language = languageFileExists and language or "en"
		localization.setLanguage(localization.language)
	else
		logger.error("[Localization] Is already initialized.")
	end
end

function localization.addString(language, stringID, stringValue)
	if initialized then
		customDictionary[language] = customDictionary[language] or {}
		customDictionary[language][stringID] = stringValue
	else
		logger.error("[Localization] You must initialize first.")
	end
end

function localization.getString(stringID)
	if dictionary[stringID] then
		return dictionary[stringID]
	else
		if customDictionary[localization.language] and customDictionary[localization.language][stringID] then
			return customDictionary[localization.language][stringID]
		else
			logger.error([[[Localization] ID:"]]..stringID..[[" in language:"]]..localization.language..[[" does not contain a string.]])
		end
	end
	return STRING_MISSING
end

return localization




