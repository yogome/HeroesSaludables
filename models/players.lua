---------------------------------------------- Player model
local database = require( "libs.helpers.database" ) 
local logger = require( "libs.helpers.logger" )
local offlinequeue = require( "libs.helpers.offlinequeue" )
local json = require( "json" )
local settings = require( "settings" )

local players = {}
--------------------------------------------- Variables
local initialized
local currentPlayer
--------------------------------------------- Constants
--------------------------------------------- Functions
local function fixJsonTable(inputTable)
	local result = {}
	for key,value in pairs(inputTable) do
		if not(tonumber(key) == nil) then
			result[tonumber(key)] = value
		elseif "table" == type(inputTable[key]) then
			result[key] = fixJsonTable(inputTable[key])
		else
			result[key] = inputTable[key]
		end
	end

	return result
end 

local function decodePlayer(databasePlayer)
	local decoded = json.decode(databasePlayer.data)
	decoded = fixJsonTable(decoded)
	decoded.id = databasePlayer.id
	return decoded
end

local function sendUpdate(player)
	local bodyData = {
		email = database.config("currentUserEmail"),
		password = database.config("currentUserPassword"),
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

local function sendCreation(newPlayer)
	local bodyData = {
		email = database.config("currentUserEmail"),
		password = database.config("currentUserPassword"),
		player = newPlayer,
		language = system.getPreference("locale","language"),
		localID = newPlayer.id,
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
---------------------------------------------Module Functions
function players.new()
	local player = {
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
				},
			},
		},
	}
	
	return player
end

function players.decodeJson(playerJson)
	local decoded = json.decode(playerJson)
	decoded = fixJsonTable(decoded)
	return decoded
end

function players.getRankLevel(player)
	return 1 + math.floor(players.getStars(player)/10)
end

function players.getCount()
	return database.count("players") or 0
end

function players.getCurrentPlayerID()
	return database.config("currentPlayerID")
end

function players.setCurrentPlayerID(currentPlayerID)
	database.config("currentPlayerID", currentPlayerID)
end

function players.getAll()
	local databasePlayers = database.getTable("players")
	local allPlayers = {}
	if databasePlayers then
		for index = 1, #databasePlayers do
			allPlayers[#allPlayers + 1] = decodePlayer(databasePlayers[index])
		end
	end
	return allPlayers
end

function players.get(playerID)
	playerID = playerID or database.config("currentPlayerID")
	if playerID then
		if currentPlayer and tonumber(currentPlayer.id) == tonumber(playerID) then
			return currentPlayer
		end
		local databasePlayer = database.getRow("players", {id = playerID})
		if databasePlayer then
			return decodePlayer(databasePlayer)
		else
			logger.error("[Players] not a valid playerID.")
		end
	else
		logger.error("[Players] not a valid playerID.")
	end
end

function players.getCurrent()
	local currentID = database.config("currentPlayerID")
	if currentID then
		if not(currentPlayer and currentPlayer.id == currentID) then
			logger.log("[Players] fetching database player.")
			local databasePlayer = database.getRow("players", {id = currentID})
			if databasePlayer then
				currentPlayer = decodePlayer(databasePlayer)
				logger.log("[Players] fetching current player "..(currentPlayer.remoteID and "with remoteID:"..currentPlayer.remoteID or "with no remoteID"))
			end
		else
			logger.log("[Players] fetching current player "..(currentPlayer.remoteID and "with remoteID:"..currentPlayer.remoteID or "with no remoteID").." from memory")
		end
	else
		logger.log("[Players] fetching a new player.")
		currentPlayer = players.new()
	end
	
	return currentPlayer
end

function players.save(player, noSend)
	if player and type(player) == "table" then
		local jsonPlayer = json.encode(player)
		if player.id then
			local sql = [[UPDATE players SET data = :data WHERE id = :id;]]
			database.exec(sql, {data = jsonPlayer, id = player.id})
			logger.log("[Players] Saved profile with ID: "..tostring(player.id))
			if player.remoteID then
				--sendUpdate(player)
			end
		else
			local sql = [[INSERT INTO players (data) VALUES (:data)]]
			database.exec(sql, {data = jsonPlayer})
			local lastRowID = database.lastRowID()
			local sql = "SELECT id FROM players WHERE rowid = "..lastRowID..";"
			local currentPlayerID = tonumber(database.getColumn("id", sql))
			database.config("currentPlayerID", currentPlayerID)
			logger.log("[Players] Created new profile with ID: "..tostring(currentPlayerID))
			if not noSend then
				--sendCreation(players.getCurrent())
			end
		end
	else
		logger.log("[Players] Coould not save player. player must not be nil and be a table.")
	end
end

function players.deleteAll()
	database.exec([[DELETE from players]])
	database.config("currentPlayerID", false)
	logger.log("[Players] Deleted All profiles")
end

function players.delete(player)
	if player and type(player) == "table" then
		if player.id then
			database.exec([[DELETE from players WHERE id = :id]], player)
			logger.log("[Players] Deleted profile with id: "..tostring(player.id))
		else
			logger.log("[Players] Could not delete player. Player is not on database.")
		end
	else
		logger.log("[Players] Could not delete player. player must not be nil and be a table.")
	end
end

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
						logger.log("[Players] Player was sent and received remoteID:"..currentPlayer.remoteID)
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

return players
