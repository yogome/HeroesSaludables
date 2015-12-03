---------------------------------------------- Player model
local database = require( "libs.helpers.database" ) 
local logger = require( "libs.helpers.logger" )
local json = require( "json" )
local settings = require( "settings" )

local players = database.newModel("players", "Player")
--------------------------------------------- Variables
local initialized
--------------------------------------------- Constants 
--------------------------------------------- Functions
---------------------------------------------Module Functions
players.default = {
	id = nil,
	remoteID = nil,
	realName = "",
	characterName = "Player",
	age = 5,
	grade = 1,
	educationLevel = 1,
	gender = "none",
	coins = 0,
	hatIndex = 1,
	heroIndex = 1,
	shipIndex = 1,
	firstRun = 1,
	firstMenu = false,
	timePlayed = 0,
	energy = 100,
	unlockedItems = {
		["boys"] = {
			[1] = {locked = false},
		},
		["girls"] = {
			[1] = {locked = false},
		},
		["hats"] = {
			[1] = {locked = false},
		},
		["ships"] = {
			[1] = {locked = false},
		},
	},
	minigamesData = {
		[1] = {timesPlayed = 0, correctAnswers = 0, wrongAnswers = 0},
	},
	unlockedWorlds = {
		[1] = {
			unlocked = true,
			watchedEnd = false,
			watchedStart = false,
			levels = {
				[1] = {unlocked = true, stars = 0},
				[2] = {unlocked = false, stars = 0},
				[3] = {unlocked = false, stars = 0},
			},
		},
	},
}

function players.initialize()
	if not initialized then
		logger.log("[Players] Initializing.")
		initialized = true
	end
end

function players:create(event)
	local player = event.target
end

function players:update(event)
	local player = event.target
end

function players:get(event)
	local player = event.target
	
end

players:addEventListener("create")
players:addEventListener("update")
players:addEventListener("get")

return players

