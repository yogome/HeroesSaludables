
local director = require( "libs.helpers.director" )
local players = require( "models.players" )

local function goGame()
	director.gotoScene("scenes.game.shooter")
end

local function goLabelQuiz()
	director.gotoScene("scenes.game.labelpuzzle")
end

local function goWorlds()
	director.gotoScene("scenes.menus.worlds")
end

local function goLevels()
	director.gotoScene("scenes.menus.levels")
end

local function goLabel()
	director.gotoScene("scenes.game.labelquiz")
end

local function goQuestion()
	director.gotoScene("scenes.game.questionquiz")
end


local function goHero()
	director.gotoScene("scenes.menus.selecthero")
end

local function goHome()
	director.gotoScene("scenes.menus.home")
end

local function giveCoins()
	local player = players.getCurrent()
	if player.coins then
		player.coins = player.coins + 100
	else
		player.coins = 100
	end
	players.save(player)
end

local function resetPlayer()
	local currentPlayer = players.getCurrent()
	local playerID = currentPlayer.id
	local remoteID = currentPlayer.remoteID
	if playerID then
		currentPlayer = players.new()
		currentPlayer.id = playerID
		currentPlayer.remoteID = remoteID
		players.save(currentPlayer)
	end
end


local testActions = {

	{"Go Worlds", goWorlds, {0.5,0.5,0.5}},
	{"Go Levels", goLevels, {0.5,0.5,0.5}},

	{"Go Home", goHome, {0.5,0.5,0.5}},
	{"Go Hero", goHero, {0.5,0.5,0.5}},
	{"Go Game", goGame, {0.5,0.5,0.5}},
	{"Go Label", goLabel, {0.5,0.5,0.5}},
	{"Go Label Quiz", goLabelQuiz, {0.5,0.5,0.5}},
	{"Go Question Quiz", goQuestion, {0.5,0.5,0.5}},
	{"Clear queue", clearQueue, {0.5,0.6,0.3}},
	
	{"Give Coins", giveCoins,{0.2,0.8,0.2}},
	{"Toggle FPS", toggleFPS,{0.3,0.3,0.8}},
	{"Reset player", resetPlayer,{0.8,0.2,0.2}},
}

return testActions
