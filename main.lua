require "CiderDebugger";------------------------------------------------ Main
local director = require( "libs.helpers.director" )
local logger = require( "libs.helpers.logger" )
local database = require( "libs.helpers.database" )
local protector = require( "libs.helpers.protector" )
local keyboard = require( "libs.helpers.keyboard" )
local music = require( "libs.helpers.music" )
local sound = require( "libs.helpers.sound" )
local sceneloader = require( "libs.helpers.sceneloader" )
local dialog = require( "libs.helpers.dialog" )
local mixpanel = require( "libs.helpers.mixpanel" )
local musiclist = require( "data.musiclist" )
local soundlist = require( "data.soundlist" )
local scenelist = require( "data.scenelist" )
local pathlist = require( "data.pathlist" )
local settings = require( "settings" )
local index = require( "libs.helpers.index" )
local configurationlist = require( "data.configurationlist" )
local players = require( "models.players" )
local internet = require( "libs.helpers.internet" )
local notificationService = require( "services.notification" )
local eventCounter = require( "libs.helpers.eventcounter" )
local localization = require( "libs.helpers.localization" )

local game = require( "models.game" )
local launchArgs = ... 
----------------------------------------------- Constants
----------------------------------------------- Local functions
local function onKeyEvent( event )
	local handled = false
	local phase = event.phase
	local keyName = event.keyName

	if "back" == keyName and phase == "up" then
		local sceneName = director.getSceneName("overlay")
		if not sceneName then sceneName = director.getSceneName("current") end
		local currentScene = director.getScene(sceneName)
		if not currentScene then
			logger.log("[Main] No current scene found!")
			sceneName = director.getSceneName("previous")
			if sceneName then
				director.gotoScene(sceneName)
			end
		else
			if currentScene.backAction ~= nil and type(currentScene.backAction) == "function" then
				handled = currentScene.backAction()
			end
		end
		
	end
	return handled
end 

local function setupLanguage()
	local language = database.config( "language" )
	if not language then
		logger.log("[Main] Detecting language.")
		local systemLanguage = system.getPreference( "ui", "language" )
		logger.log("[Main] Detected language "..systemLanguage)
		if systemLanguage == "es" then
			language = "es"
		else
			language = "en"
		end
		database.config( "language" , language)
	end
	local localizationParams = {
		dataPath = settings.languagesDataPath,
	}
	localization.initialize(localizationParams)
	logger.log([[[Main] Language is set to "]]..language..[[".]])
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
	sound.loadSounds(soundlist)
	local soundEnabled = database.config( "sound" )
	if soundEnabled == nil then
		soundEnabled = true
		database.config( "sound", soundEnabled )
	end
	logger.log([[[Main] Sound is set to "]]..tostring(soundEnabled)..[[".]])
	sound.setEnabled(soundEnabled)
end

local function increaseTimesRan()
	local timesRan = database.config("timesRan") or 0
	timesRan = timesRan + 1
	database.config("timesRan", timesRan)
	logger.log("[Main] Times ran: "..timesRan)
	return timesRan
end

local function setupKeyboard()
	keyboard:setSoundFunction(function()
		sound.play(settings.keySound)
	end)
end

local function initializeDatabase()
	database:initialize({
		name = "default", 
		debug = settings.debugDatabase, 
		onCreate = game.create, 
		validConfigurations = configurationlist,
		onDatabaseClose = function()
			eventCounter.saveCounts()
		end,
	})
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
			initializeDatabase()
		else
			logger.log("[Main] Security check OK.")
		end
	else
		logger.log("[Main] Skipping security check.")
	end
end

local function errorListener( event )
	logger.error("[Main] There was an error: "..(event.errorMessage or "Unknown error")..": "..(event.stackTrace or "No trace"))
	director.gotoScene( "scenes.menus.home", { effect = "fade", time = 800} )
    return true
end

local function notificationListener( event )
	native.setProperty( "applicationIconBadgeNumber", 1)
	native.setProperty( "applicationIconBadgeNumber", 0)
	system.cancelNotification()
	if event then
		notificationService.check(event)
	end
end

local function loadScenes()
	if settings.autoLoadScenes then
		sceneloader.loadScenes(scenelist.menus)
		sceneloader.loadScenes(scenelist.game)
	end
end

local function setupMohound()
	local platformName = system.getInfo("platformName")
	if platformName ~= "Android" then
		local mohound = require("plugin.mohound")
		mohound.init(settings.mohoundKey, settings.mohoundSecret)
	end
end

local function setupMixpanel()
	local mixpanelToken = settings.mixpanelTokens[settings.mode]
	mixpanel.initialize(mixpanelToken, settings.gameName, settings.gameVersion)
	
	local pushToken = database.config("pushToken")
	if pushToken and string.len(pushToken) > 0 then
		mixpanel.setPushToken(pushToken)
	else
		logger.log("[Main] Push token is not valid")
	end
end

local function initialize()
	protector.enabled = settings.enableProtector
	logger.enabled = settings.enableLog
	internet.initialize()
	display.setDefault( "minTextureFilter", "nearest" )
	logger.log("[Main] Initializing game...")
	display.setStatusBar( display.HiddenStatusBar )
	math.randomseed( os.time() )
	system.setIdleTimer( false )
	initializeDatabase()
	setupMixpanel()
	eventCounter.initialize()
	Runtime:addEventListener( "notification", notificationListener )
	Runtime:addEventListener( "key", onKeyEvent )
	Runtime:addEventListener( "unhandledError", errorListener)
	logger.log("[Main] Resolution width:"..display.viewableContentWidth..", height:"..display.viewableContentHeight)
	checkSecurity()
	setupLanguage()
	setupMusic()
	setupSound()
	setupKeyboard()
	loadScenes()
    index.initialize(pathlist)
	players.initialize()
	setupMohound()
end

local function startGame()
	if launchArgs and launchArgs.notification then
		logger.log("[Main] Received notification as launch argument.")
		notificationListener(launchArgs.notification)
	end
	
	mixpanel.logEvent("applicationStarted", {timesRan = increaseTimesRan()})
	if system.getInfo("environment") == "simulator" and settings.testMenu then
		director.gotoScene( "scenes.menus.test", { effect = "fade", time = 800} )
	else
		director.gotoScene( "scenes.intro.yogome" )
	end
end

local function start()
	logger.log("[Main] Mode is set to "..settings.mode..".")
	local function onComplete( event )
		if "clicked" == event.action then
			local buttonIndex = event.index
			if 2 == buttonIndex then
				settings.mode = "prod"
				logger.log("[Main] Changed mode to prod.")
			end
			initialize()
			startGame()
		end
	end
	
--	if settings.mode ~= "prod" and system.getInfo("environment") ~= "simulator" then
--		native.showAlert( "settings.mode", "Game is not in production mode", {"OK", "Use Production"}, onComplete )
--	else
		initialize()
		startGame()
--	end
end
----------------------------------------------- Execution
start() 
