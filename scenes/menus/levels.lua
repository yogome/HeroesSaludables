----------------------------------------------- Worlds
local director = require( "libs.helpers.director" )
local widget = require( "widget" )
local buttonlist = require( "data.buttonlist" )
local physics = require("physics")
local sound = require( "libs.helpers.sound" )
local players = require( "models.players" )
local robot = require( "libs.helpers.robot" )
local database = require( "libs.helpers.database" )
local worldsdata = require( "data.worldsdata" )
local music = require( "libs.helpers.music" )
local extramath = require( "libs.helpers.extramath" )
local settings = require( "settings" )
local scene = director.newScene() 
local spaceships = require( "entities.spaceships" )

----------------------------------------------- Variables
local buttonBack
local titleGroup, title, language
local buttonsEnabled
local currentPlayer
local scrollView
local scrollViewButtonGroup
local levelsGroup
local worldIndex
local prevLastUnlockedLevel, lastUnlockedLevel
local playerCharacter
local coinText, starText
----------------------------------------------- Constants
local COLOR_BACKGROUND = {47/255,190/255,196/255}
local WIDTH_BACKGROUND = 1024
local HEIGHT_BACKGROUND = 768
local MARGIN = 20
local OFFSET_COMPLETION_BACKGROUND = {x = 0, y = 257}
local OFFSET_COMPLETION_TEXT = {x = 0, y = 255}
local NUM_BACKGROUNDS = 2
local COLOR_CARD_DISABLED = {0.2}
local COST_ENERGY_PLAY = 0
local MAX_LEVEL_STARS = 3
local OFFSET_LEVEL_STARS = {x = 0, y = 22}
local OFFSET_BASE_NUMBER = {x = 0, y = 0}
local OFFSET_LEVEL_LOCK = {x = 0, y = 0}
local SCALE_LEVEL_LOCK = 0.25
local COLOR_LOCKED_LEVEL = {0.5}
local DATA_DECORATIONS = {x = 0, y = 24, scale = 0.8}
local SCALE_PATH = {xScale = 1, yScale = 0.75}
local SIZE_FONT_LEVEL = 30
local OFFSET_X_PLAYER = -20
local OFFSET_Y_PLAYER = -100
local OFFSET_X_COINS = -20
local OFFSET_X_STARS = -30
local FLY_TIME = 1200

local mathSin = math.sin
----------------------------------------------- Functions
local function onReleasedBack()
	director.gotoScene( "scenes.menus.worlds", { effect = "zoomInOutFade", time = 600, } )
end

local function updateCharacterShip(time)
	playerCharacter.y = playerCharacter.y + (mathSin(time * 0.01) * 0.4)
end

local function updateGameLoop(event)
	updateCharacterShip(event.time)
end

local function levelIconTapped(event)
	local levelIcon = event.target
	if buttonsEnabled and not levelIcon.locked then
		buttonsEnabled = false
		scene.disableButtons()
		local levelIcon = event.target
		local levelIndex = levelIcon.index
		local randomTool = math.random(1,3)
		local scene
		if randomTool == 1 then
			scene = "scenes.game.labelpuzzle"
		elseif randomTool == 2 then
			scene = "scenes.game.labelquiz"
		elseif randomTool == 3 then
			scene = "scenes.game.questionquiz"
		end
		director.gotoScene(scene, {effect = "fade", time = 500, params = {worldIndex = worldIndex, levelIndex = levelIndex}})
		--director.gotoScene("scenes.game.shooter", { effect = "zoomInOutFade", time = 600, ,})
	else
		sound.play("enemyRouletteTickOp02")
	end
end

local function removeLevels()
	display.remove(levelsGroup)
	levelsGroup = nil
end

local function createSpaceShip()
	playerCharacter = spaceships.new()
	playerCharacter.isCarringItem = false
	playerCharacter.name = "player"
	
	if prevLastUnlockedLevel then
		playerCharacter.x = prevLastUnlockedLevel.x + OFFSET_X_PLAYER
		playerCharacter.y = prevLastUnlockedLevel.y + OFFSET_Y_PLAYER
		
		scrollView:scrollToPosition({x = -playerCharacter.x})
		transition.to(playerCharacter, {delay = 100, time = FLY_TIME,x = lastUnlockedLevel.x, onStart = function()
			timer.performWithDelay(1100, function()
				--sound.play("breakSound")
			end)
			
		end})
		transition.to(playerCharacter, {delay = 100, time = FLY_TIME, y = lastUnlockedLevel.y + OFFSET_Y_PLAYER, transition = easing.inOutCubic, onComplete = function()

		end})
	else
		playerCharacter.x = lastUnlockedLevel.x + OFFSET_X_PLAYER
		playerCharacter.y = lastUnlockedLevel.y + OFFSET_Y_PLAYER
	end
	
	scrollView:insert(playerCharacter)
end

local function createLevels()
	local worldData = worldsdata[worldIndex]
	lastUnlockedLevel = nil
	prevLastUnlockedLevel = nil
	
	if worldData then
		levelsGroup = display.newGroup()
		local decorationGroup = display.newGroup()
		levelsGroup:insert(decorationGroup)
		local pathGroup = display.newGroup()
		levelsGroup:insert(pathGroup)
		
		local filler = display.newRect(0,0,20,20)
		filler.isVisible = false
		filler.anchorX = 0
		
		local squareRoot = math.sqrt
		local playerWorldData = currentPlayer.unlockedWorlds[worldIndex]

		for index = 1, #worldData do
			local levelData = worldData[index]
			local level = display.newGroup()
			level.x = levelData.x
			level.y = scrollView.height * 0.5 + levelData.y
			levelsGroup:insert(level)
			
			level.index = index
			level.data = levelData
			level:addEventListener("tap", levelIconTapped)
			
			local levelImage = display.newImage("images/levels/base0"..math.random(1,3)..".png")
			level:insert(levelImage)
			
--			local levelNumber = display.newText(string.format("%02d", index),  OFFSET_BASE_NUMBER.x, OFFSET_BASE_NUMBER.y, settings.fontName, SIZE_FONT_LEVEL)
--			level:insert(levelNumber)
--			
			if playerWorldData and playerWorldData.levels then
				if playerWorldData.levels[index] and playerWorldData.levels[index].unlocked then
					local starNumber = playerWorldData.levels[index].stars or 0
					level.stars = starNumber
					if "number" == type(starNumber) then
						if starNumber < 0 then
							starNumber = 0
						elseif starNumber > MAX_LEVEL_STARS then
							starNumber = MAX_LEVEL_STARS
						end
											
						if starNumber > 0 then
							local starsImage = display.newImage(string.format("images/levels/estrellas%02d.png", starNumber))
							starsImage.x = OFFSET_LEVEL_STARS.x
							starsImage.y = OFFSET_LEVEL_STARS.y
							level:insert(starsImage)
						end
					end
					prevLastUnlockedLevel = lastUnlockedLevel
					lastUnlockedLevel = level
				else
					level.locked = true
					
					local lockImage = display.newImage("images/general/lock.png")
					lockImage.x = OFFSET_LEVEL_LOCK.x
					lockImage.y = OFFSET_LEVEL_LOCK.y
					lockImage.xScale = SCALE_LEVEL_LOCK
					lockImage.yScale = SCALE_LEVEL_LOCK
					level:insert(lockImage)
					
					levelImage:setFillColor(unpack(COLOR_LOCKED_LEVEL))
				end
			end

			filler.width = levelData.x
			
			if index > 0 and index < #worldData then
				local p2 = worldData[index + 1]
				local p1 = worldData[index]
				
				local distanceX = p2.x - p1.x
				local distanceY = p2.y - p1.y
				local distance = squareRoot((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y))
				
				local iterations = math.ceil(distance / 16)
				local lastPathImage
				for index = 1, iterations do
					local pathImage = display.newImage("images/levels/camino.png")
					pathImage.x = worldData.path.easingX(index, iterations, p1.x, distanceX)
					pathImage.y = scrollView.height * 0.5 + worldData.path.easingY(index, iterations, p1.y, distanceY)
					pathImage.fill.blendMode = {srcColor = "srcColor", srcAlpha = "srcAlpha", dstColor = "one", dstAlpha = "one"}
					pathImage.xScale = SCALE_PATH.xScale
					pathImage.yScale = SCALE_PATH.yScale
					pathGroup:insert(pathImage)
					
					if lastPathImage then
						lastPathImage.rotation = extramath.getFullAngle(pathImage.x - lastPathImage.x, pathImage.y - lastPathImage.y) + 90
					end
					lastPathImage = pathImage
				end
			end
		end
		
		if worldData[1] then
			filler.width = filler.width + worldData[1].x
		end
		levelsGroup:insert(filler)
		
		scrollView:insert(levelsGroup)
	end
end

local function createUI(group)
	local starContainer = display.newImage("images/general/stars.png")
	starContainer.x = display.contentWidth - 450
	starContainer.y = display.screenOriginY + 50
	group:insert(starContainer)
	
	local coinContainer = display.newImage("images/general/coins.png")
	coinContainer.x = display.contentWidth - 200
	coinContainer.y = display.screenOriginY + 50
	group:insert(coinContainer)
	
	coinText = display.newText("C", coinContainer.x + OFFSET_X_COINS, coinContainer.y, settings.fontName, 30)
	group:insert(coinText)
	
	starText = display.newText("S", starContainer.x + OFFSET_X_COINS, starContainer.y, settings.fontName, 30)
	group:insert(starText)
	
end

local function loadLevelData()
	local totalStars = 0
	for indexLevel = 1, #currentPlayer.unlockedWorlds[worldIndex].levels do
		totalStars = totalStars + currentPlayer.unlockedWorlds[worldIndex].levels[indexLevel].stars
	end
	local totalCoins = currentPlayer.coins
	
	coinText.text = totalCoins
	starText.text = totalStars
end

----------------------------------------------- Class functions 
function scene.enableButtons()
	buttonBack:setEnabled(true)
	buttonsEnabled = true
end

function scene.disableButtons()
	buttonBack:setEnabled(false)
	buttonsEnabled = false
end

function scene.backAction()
	robot.press(buttonBack)
	return true
end 

function scene:create(event)
	local sceneGroup = self.view
	
	local scrollViewOptions = {
		x = display.contentCenterX,
		y = display.contentCenterY,
		width = display.viewableContentWidth,
		height = display.viewableContentHeight,
		hideBackground = false,
		verticalScrollDisabled = true,
		isBounceEnabled = false,
	}
	
	scrollView = widget.newScrollView(scrollViewOptions)
	sceneGroup:insert(scrollView)

	local backgroundScale = display.viewableContentHeight / HEIGHT_BACKGROUND
	
	for index = 1, NUM_BACKGROUNDS do
		local background = display.newImage("images/levels/background0"..index..".png")
		background.anchorX = 0
		background.x = ((index - 1) * WIDTH_BACKGROUND) * backgroundScale
		background.y = scrollView.height * 0.5
		background.xScale = backgroundScale
		background.yScale = backgroundScale
		scrollView:insert(background)
	end
	
	scrollViewButtonGroup = display.newGroup()
	scrollView:insert(scrollViewButtonGroup)
	
	titleGroup = display.newGroup()
	sceneGroup:insert(titleGroup)
	
	buttonlist.back.onRelease = onReleasedBack
	buttonBack = widget.newButton(buttonlist.back)
	buttonBack.x = display.screenOriginX + buttonBack.width * 0.5 + MARGIN
	buttonBack.y = display.screenOriginY + buttonBack.height * 0.5 + MARGIN
	sceneGroup:insert(buttonBack)
	
	createUI(sceneGroup)
	
end

function scene:destroy()
	
end

function scene:show( event )
	local sceneGroup = self.view
    local phase = event.phase
	
	local params = event.params or {}
	worldIndex = params.worldIndex or 1

    if ( phase == "will" ) then
		physics.start()
		language = database.config("language") or "en"
		currentPlayer = players.getCurrent()
		createLevels()
		loadLevelData()
		spaceships.start()
		createSpaceShip()
		Runtime:addEventListener("enterFrame", updateGameLoop)
		self.disableButtons()
	elseif ( phase == "did" ) then
		self.enableButtons()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		self.disableButtons()
		system.deactivate("multitouch")
		sound.stopPitch()
		spaceships.stop()
		Runtime:removeEventListener("enterFrame", updateGameLoop)
	elseif ( phase == "did" ) then
		removeLevels()
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "show", scene )

return scene
