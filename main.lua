require "CiderDebugger";------------------------------------------------ Main
local extrafile = require( "libs.helpers.extrafile" )
local director = require( "libs.helpers.director" )
local logger = require( "libs.helpers.logger" )
local database = require( "libs.helpers.database" )
local protector = require( "libs.helpers.protector" )
local music = require( "libs.helpers.music" )
local sound = require( "libs.helpers.sound" )
local sceneloader = require( "libs.helpers.sceneloader" )
local dialog = require( "libs.helpers.dialog" )
local musiclist = require( "data.musiclist" )
local scenelist = require( "data.scenelist" )
local settings = require( "settings" )
local players = require( "models.players" )
local internet = require( "libs.helpers.internet" )
local eventCounter = require( "libs.helpers.eventcounter" )
local localization = require( "libs.helpers.localization" )
local testMenu = require( "libs.helpers.testmenu" )
local testActions = require( "data.testactions" )
local soundList = require( "data.soundlist" )
local launchArgs = ... 
----------------------------------------------- Constants
----------------------------------------------- Local functions
local function setupLanguage()
	local localizationParams = {
		dataPath = settings.languagesDataPath,
	}
	localization.initialize(localizationParams)
	logger.log([[[Main] Language is set to "]]..localization.getLanguage()..[[".]])
end

local function setupMusic()
	music.setTracks(musiclist)
	local musicEnabled = database.config( "music" )
	if musicEnabled == nil then
		musicEnabled = true
		database.config( "music", musicEnabled )
	end
	logger.log([[[Main] Music is set to "]]..tostring(musicEnabled)..[[".]])
	music.setEnabled(musicEnabled, true)
end

local function setupSound()
	sound.loadSounds(soundList)
	local soundEnabled = database.config( "sound" )
	if soundEnabled == nil then
		soundEnabled = true
		database.config( "sound", soundEnabled )
	end
	logger.log([[[Main] Sound is set to "]]..tostring(soundEnabled)..[[".]])
	sound.setEnabled(soundEnabled)
end

local function checkSecurity()
	if settings.databaseChecksum then
		if not database.compareChecksum() then
			timer.performWithDelay(500, function()
				local alertOptions = {
					text = "Database was corrupt, will erase all database content.",
					time = 3000,
				}
				dialog.newAlert(alertOptions)
			end)
			logger.error("[Main] Database checksum does not match or is inexistent.")
			database.delete()
		else
			logger.log("[Main] Security check OK.")
		end
	else
		logger.log("[Main] Skipping security check.")
	end
end

local function errorListener( event )
	logger.error("[Main] There was an error: "..(event.errorMessage or "Unknown error")..": "..(event.stackTrace or "No trace"))
	director.gotoScene( settings.errorScene, { effect = "fade", time = 800} )
	return true
end

local function notificationListener( event )
	native.setProperty( "applicationIconBadgeNumber", 1)
	native.setProperty( "applicationIconBadgeNumber", 0)
	system.cancelNotification()
end

local function loadScenes()
	if settings.autoLoadScenes then
		sceneloader.loadScenes(scenelist.menus)
		sceneloader.loadScenes(scenelist.game)
	end
end

local function loadTestActions()
	for index = 1, #testActions do
		testMenu.addButton(unpack(testActions[index]))
	end
end

local function initialize()
	extrafile.cacheFileSystem()
	protector.enabled = settings.enableProtector
	logger.enabled = settings.enableLog
	internet.initialize()
	display.setDefault( "minTextureFilter", "nearest" )
	display.setDefault("background", 0, 0, 0)
	logger.log("[Main] Initializing game...")
	display.setStatusBar( settings.statusBar )
	math.randomseed( os.time() )
	system.setIdleTimer( false )
	eventCounter.initialize()
	Runtime:addEventListener( "notification", notificationListener )
	Runtime:addEventListener( "unhandledError", errorListener)
	logger.log("[Main] Resolution width:"..display.viewableContentWidth..", height:"..display.viewableContentHeight)
	checkSecurity()
	setupLanguage()
	setupMusic()
	setupSound()
	loadScenes()
	loadTestActions()
	players.initialize()
end

local function startGame()
	if launchArgs and launchArgs.notification then
		logger.log("[Main] Received notification as launch argument.")
		notificationListener(launchArgs.notification)
	end
	
	if settings.testMenu then
		director.gotoScene( "testMenu", { effect = "fade", time = 800} )
	else
		director.gotoScene( "scenes.intro.yogome", { effect = "fade", time = 800} )
	end
	
end

local function start()
	logger.log("[Main] Mode is set to "..settings.mode..".")
	initialize()
	startGame()
end
----------------------------------------------- Execution
start() 
