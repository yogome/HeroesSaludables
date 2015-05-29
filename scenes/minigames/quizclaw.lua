----------------------------------------------- Math Claw
local scenePath = ...
local folder = scenePath:match("(.-)[^%.]+$")
local assetPath = "images/minigames/quizclaw/"
local localization = require( "libs.helpers.localization" )
local director = require( "libs.helpers.director" )
local sound = require( "libs.helpers.sound" )
local tutorials = require( "libs.helpers.tutorials" )
local settings = require( "settings" )
local buttonList = require("data.buttonlist")
local widget = require("widget")
local labeldata = require("data.labeldata")

local game = director.newScene() 
----------------------------------------------- Variables
local manager
local background
local sceneGroup
local currentGametype
local correctAnswer

local answerList
local hasAnswered
local clawGroup
local claw, rope
local timerGenerateAnswers
local questionMarkText
local equalityString
local answerStrings
local answerBackgroundGroup
local gameTutorial
local startButton
local bandGroup
local panelBlocks
local currentPortion
local questionGroup
----------------------------------------------- Constants

local POSITION_Y_EQUATION = display.contentCenterY - 270
local SIZE_TEXT = 60
local SCALE_SIGNS = .50

local RADIUS_COLLISION = 50
local DEFAULT_COLOR_BACKGROUND = {0.5,0.7,0.3}
local POSITION_X_ANSWER = 10

local blockData = {
	[1] = "images/minigames/quizclaw/etiqueta_01.png",
	[2] = "images/minigames/quizclaw/etiqueta_02.png",
	[3] = "images/minigames/quizclaw/etiqueta_03.png",
	[4] = "images/minigames/quizclaw/etiqueta_04.png",
	[5] = "images/minigames/quizclaw/etiqueta_05.png",
	
}

----------------------------------------------- Functions

local function hasCollided( object1, object2 )
	if object1 and object2 then
		local distanceX = object1.x - object2.x
		local distanceY = object1.y - object2.y

		local distanceSquared = distanceX * distanceX + distanceY * distanceY
		local radiusSum = object2.radius + object1.radius
		local radii = radiusSum * radiusSum

		if distanceSquared < radii then
		   return true
		end
	end
	return false
end

local function clawTouch( event )
	local self = event.target

		if event.phase == "began" then
			sound.play("dragtrash")
			tutorials.cancel(gameTutorial,300)
			display.getCurrentStage():setFocus( self )
			self.isFocus = true
			claw.deltaX = event.x - claw.x
			claw.deltaY = event.y - claw.y
		elseif self.isFocus then
			if event.phase == "moved" then
				claw.x = event.x - claw.deltaX
				claw.y = event.y - claw.deltaY
				if claw.y < claw.startY then
					claw.y = claw.startY
				end
			elseif event.phase == "ended" or event.phase == "cancelled" then
				display.getCurrentStage():setFocus( nil )
				self.isFocus = nil
				sound.play("pop")
			end
		end
end

local function contains(tableToCheck, valueToCompare)
	for  index, value in ipairs(tableToCheck) do
		if (value == valueToCompare) then
			return false
		end
	end	
	return true
end

local function updateGame()
	for answerIndex = #answerList, 1, -1 do
		local answer = answerList[answerIndex]
		
		if not hasAnswered and hasCollided(answer, claw) then
			hasAnswered = true
			claw:removeEventListener("touch", clawTouch)
			
			answerStrings = { answer.number }
			local data = {equalityString = equalityString, answerStrings = answerStrings}

			if answer.isCorrect then
				if manager and manager.correct then
					manager.correct(data)
				end
			else
				if manager and manager.wrong then
					manager.wrong({id = "text", text = correctAnswer})
				end
			end
			
			sound.play("minigamesMachineLock")
			director.to(scenePath, claw, {x = answer.x, y = answer.y - 60, time = 500, onComplete = function ()
				local tempX = claw.x
				local tempY = claw.y
				display.remove(claw)
				claw = display.newImage(assetPath .. "minigames-elements-46.png")
				clawGroup:insert(claw)
				claw.x = tempX
				claw.y = tempY
				claw.radius = RADIUS_COLLISION
				sound.play("minigamesMachineDrag")
				director.to(scenePath, claw, {y = claw.startY, time = 1200})
				answerBackgroundGroup:insert(answer)
				director.to(scenePath, answer, {y = claw.startY + 60, time = 1200, onComplete = function()
					sound.stopAll(200)
					director.to(scenePath, answer, {time = 500, xScale = 1, yScale = 1, transition = easing.outQuad})
					director.to(scenePath, questionMarkText, {time = 500, alpha = 0, transition = easing.outQuad})
					director.to(scenePath, answer, {time = 500, x = POSITION_X_ANSWER, y = POSITION_Y_EQUATION , transition = easing.outQuad})
					sound.play("pop")
				end})
			end})
			display.getCurrentStage():setFocus( nil )
			claw.isFocus = nil
		end
	end
	
	rope.x = claw.x
	rope.height = claw.y - claw.startY
end

local function generateClaw(sceneGroup)	
	
	claw = display.newImage(assetPath.."minigames-elements-45.png")
	claw.x = display.contentCenterX
	claw.startY = questionGroup.contentHeight
	claw.y = claw.startY
	claw.radius = RADIUS_COLLISION
	
	rope = display.newImage(assetPath.."cadena.png")
	rope.x = display.contentCenterX
	rope.y = claw.startY - 50
	rope.anchorY = 0
	clawGroup = display.newGroup()
	clawGroup:insert(rope)
	clawGroup:insert(claw)
	sceneGroup:insert(clawGroup)
	
	claw:addEventListener("touch", clawTouch)
end

local function endMinigame()
	if timerGenerateAnswers then
		timer.cancel(timerGenerateAnswers)
		timerGenerateAnswers = nil
	end
		
	for index = #answerList, 1, -1 do
		display.remove(answerList[index])
		answerList[index] = nil
	end
	
	--display.remove(claw)
	Runtime:removeEventListener("enterFrame", updateGame)
	
end

local function initialize(parameters)
	parameters = parameters or {}
	
	local data = parameters.data or {}
	local colorRGB = parameters.colorBg or DEFAULT_COLOR_BACKGROUND
	
	currentPortion = math.random(1, #labeldata)
	
	currentGametype = data[1]
	
	hasAnswered = false
	answerList = {}
	
	claw.x = display.contentCenterX
	claw.startY = questionGroup.contentHeight
	claw.y = questionGroup.contentHeight
	claw.radius = RADIUS_COLLISION
	
	rope.x = claw.x
	rope.y = questionGroup.contentHeight - 50
	rope.height = 0
	
	Runtime:addEventListener("enterFrame", updateGame)	
end


local function startMinigame()
	
end

local function populateBlocks(sceneGroup)
	
	local labelInfo = labeldata[currentPortion].pieces
	for indexBlocks = 1, #blockData do
		local currentBlock = panelBlocks[indexBlocks]
		--currentBlock:scale(0.7, 0.7)
		currentBlock.index = indexBlocks
		currentBlock.x = display.contentWidth + currentBlock.contentWidth
		
		local currentLabel = labelInfo[indexBlocks]
		
		local label = display.newImage(currentLabel.assets[1])
		currentBlock:insert(label)
		
		local function movePanel()
			transition.to(currentBlock, {time = 10000, delay = 3000 * (currentBlock.index - 1), x = display.screenOriginX - currentBlock.contentWidth, onComplete = function()
				currentBlock.index = (#panelBlocks - 1)
				currentBlock.x = display.contentWidth + currentBlock.contentWidth
				movePanel()
			end})
		end
		
		movePanel()
	end
	
end

----------------------------------------------- Module functions
function game:create(event)
	local sceneGroup = self.view
		
	local background = display.newImageRect("images/label/labelBackground.png", display.viewableContentWidth + 2, display.viewableContentHeight + 2)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	background:toBack()
	sceneGroup:insert(background)
	
	questionGroup = display.newGroup()
	questionGroup.anchorChildren = true
	questionGroup.anchorY = 0
	questionGroup.y = display.screenOriginY
	questionGroup.x = display.contentCenterX
	sceneGroup:insert(questionGroup)
	
	local questionBackground = display.newImage(assetPath .. "/background_03.png")
	questionBackground.width = display.contentWidth
	questionBackground.yScale = 1.1
	questionGroup:insert(questionBackground)
	
	local nameContainer = display.newImage("images/minigames/panel_producto.png")
	nameContainer.x = display.contentWidth + 20
	nameContainer.y = display.screenOriginY + (nameContainer.contentHeight * 0.4)
	nameContainer.anchorX = 1
	nameContainer.xScale = 1.1
	sceneGroup:insert(nameContainer)
	
	local sheetData = {
		width = 1024,
		height = 256,
		numFrames = 16,
		sheetContentWidth = 2048,
		sheetContentHeight = 2048,
	}
	
	local sequenceData = graphics.newImageSheet("images/minigames/label1/band.png", sheetData)
	
	local sequenceOptions = {
		name = "band",
		start = 1,
		count = 16,
		time = 220,
	}
	
	bandGroup = display.newGroup()
	sceneGroup:insert(bandGroup)
	bandGroup.anchorChildren = true
	bandGroup.anchorX = 0
	bandGroup.anchorY = 1
	bandGroup.x = display.screenOriginX
	bandGroup.y = display.contentHeight + 50
	bandGroup.bands = {}
	local bandOffset = 994
	local totalBands = math.floor((display.contentWidth / bandOffset) + 1)
	
	for indexBands = 1, totalBands do
		local band = display.newSprite(sequenceData, sequenceOptions)
		band.anchorX = 0
		band.x = 0 + (bandOffset * indexBands)
		band.y = 0
		bandGroup.bands[indexBands] = band
		bandGroup:insert(band)
	end
	
	panelBlocks = {}
	for indexBlocks = 1, #blockData do
		local blockGroup = display.newGroup()
		blockGroup.anchorChildren = true
		blockGroup.anchorY = 1
		blockGroup.x = display.contentCenterX
		blockGroup.y = display.contentHeight - 75
		
		local block = display.newImage(blockData[indexBlocks])
		blockGroup:insert(block)	
		
		panelBlocks[indexBlocks] = blockGroup
		sceneGroup:insert(blockGroup)
	end
	
	local buttonData = buttonList.minigamestart
	buttonData.onRelease = startMinigame
	startButton = widget.newButton(buttonData)
	startButton.x = display.contentWidth * 0.8
	startButton.y = display.contentHeight * 0.90
	sceneGroup:insert(startButton)
	
	generateClaw(sceneGroup)
end

function game:destroy()
	
end

function game:show( event )
	sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		manager = event.parent
		initialize(event.params)
		populateBlocks(sceneGroup)
		
		for indexBand = 1, #bandGroup.bands do
					
			bandGroup.bands[indexBand]:play()
			
		end
		
		
	elseif ( phase == "did" ) then
	
	end
end

function game:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		
	elseif ( phase == "did" ) then
		tutorials.cancel(gameTutorial)
		endMinigame()
	end
end

----------------------------------------------- Execution
game:addEventListener( "create", game )
game:addEventListener( "destroy", game )
game:addEventListener( "hide", game )
game:addEventListener( "show", game )

return game