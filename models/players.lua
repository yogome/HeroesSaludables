---------------------------------------------- Player model
local database = require( "libs.helpers.database" ) 
local logger = require( "libs.helpers.logger" )
local offlinequeue = require( "libs.helpers.offlinequeue" )
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
		local function newPlayerResultListener(event)
			if event.isError then
				logger.error("[Players] Could not be sent.")
			else
				if event.response then
					local luaResponse = json.decode(event.response)
					if luaResponse then

						local currentPlayer = players.getCurrent()
						if luaResponse.localID then
							currentPlayer = players.get(luaResponse.localID)
						end
						currentPlayer.remoteID = luaResponse.remoteID
						logger.log("[Players] Player "..currentPlayer.id.." was sent and received remoteID:"..currentPlayer.remoteID)
						players.save(currentPlayer)
					else
						logger.error("[Players] Player was sent but did not receive remote ID.")
						return false
					end
				end
			end
		end

		offlinequeue.addResultListener("newPlayerCreated", newPlayerResultListener)
		
		local function updatePlayerResultListener(event)
			if event.isError then
				logger.error("[Players] Could not be updated.")
			else
				if event.response then
					local luaResponse = json.decode(event.response)
					logger.log("[Players] Player was updated remotely.")
				end
			end
		end

		offlinequeue.addResultListener("updatePlayer", updatePlayerResultListener)
	end
end

function players:create(event)
	local player = event.target
	
	if not player.remoteID then
		local bodyData = {
			email = database.config("currentUserEmail"),
			password = database.config("currentUserPassword"),
			gameName = settings.gameName,
			player = player,
			language = system.getPreference("locale","language"),
			localID = player.id,
			pushToken = database.config("pushToken")
		}

		local url = settings.server.hostname.."/users/player/register"
		offlinequeue.request(url, "POST", {
			headers = {
				["Content-Type"] = settings.server.contentType,
				["X-Parse-Application-Id"] = settings.server.appID,
				["X-Parse-REST-API-Key"] = settings.server.restKey,
			},
			body = json.encode(bodyData),
		}, "newPlayerCreated")
	end
end

function players:update(event)
	local player = event.target
	
	if player.remoteID then
		local bodyData = {
			email = database.config("currentUserEmail"),
			password = database.config("currentUserPassword"),
			gameName = settings.gameName,
			remoteID = player.remoteID,
			player = player,
			pushToken = database.config("pushToken")
		}

		local url = settings.server.hostname.."/users/player/update"
		offlinequeue.request(url, "POST", {
			headers = {
				["Content-Type"] = settings.server.contentType,
				["X-Parse-Application-Id"] = settings.server.appID,
				["X-Parse-REST-API-Key"] = settings.server.restKey,
			},
			body = json.encode(bodyData),
		}, "updatePlayer")
	end
end

function players:get(event)
	local player = event.target
	
end

players:addEventListener("create")
players:addEventListener("update")
players:addEventListener("get")

return players

