local director = require( "libs.helpers.director" )
local buttonList = require("data.buttonlist")
local widget = require("widget")
local labelData = require("data.labeldata")
local settings = require("settings")
local sound = require("libs.helpers.sound")
local extratable = require("libs.helpers.extratable")

----------------------------Variables
local scene = director.newScene()
local nextScene
local worldIndex, levelIndex
local startButton
local iconPortion, portionDescription, portionDescriptionBG
local currentPortion
local animationTimer
local descriptionText,descriptionRect
local nextSceneButton
local operationLabel
local middleLayer, frontLayer
local gamePhase
local operandMultiply, operandEqual
local operationGroup
local questionText
local labelGroup
local correctMark, wrongMark

----------------------------Constants
local blockData = {
	[1] = "images/minigames/quizclaw/etiqueta_01.png",
	[2] = "images/minigames/quizclaw/etiqueta_02.png",
	[3] = "images/minigames/quizclaw/etiqueta_05.png",
}

local OFFSET_BLOCKS_Y = 130
-------------------------------------------------------------------------------

local function labelComplete()
	
	nextSceneButton:setEnabled(true)
	transition.to(nextSceneButton, {alpha = 1, time = 300})
	transition.to(descriptionText, {alpha = 1, time = 300})
	transition.to(descriptionRect, {alpha = 0.6, time = 300})
	
end

local function checkAnswer(event)
	local correctBlock
	for indexBlock = 1, #labelGroup.blocks do
		local currentBlock = labelGroup.blocks[indexBlock]
		transition.to(currentBlock, {alpha = 0})
		currentBlock:removeEventListener("tap", checkAnswer)
		if currentBlock.isCorrect then
			correctBlock = currentBlock
		end
	end
	sound.play("pop")
	transition.to(correctBlock, {y = labelGroup.contentWidth * 0.5, xScale = 0.7, yScale = 0.7, alpha = 1, transition = easing.outQuad})
	
	if event.target.isCorrect then
		correctMark.isVisible = true
		correctMark:play()
		sound.play("correct")
	else
		wrongMark.isVisible = true
		wrongMark:play()
		sound.play("wrong")
	end
	
	transition.to(nextSceneButton, {alpha = 1, onComplete = function()
		nextSceneButton:setEnabled(true)
	end})
	
end

local function startMinigame(event)
	
	local target = event.target
		
	transition.to(target, {alpha = 0})
	transition.cancel(iconPortion)
	if animationTimer then
		timer.cancel(animationTimer)
	end

	transition.to(iconPortion, {xScale = 0.3, yScale = 0.3, x = display.contentWidth * 0.95, y = display.contentWidth * 0.05, transition = easing.outQuad})
	transition.to(portionDescription, {alpha = 0, xScale = 0.8, yScale = 0.8, x = display.contentWidth * 0.75, y = display.contentWidth * 0.035, transition = easing.outQuad})
	transition.to(portionDescriptionBG, {alpha = 1, xScale = 0.8, yScale = 0.8, x = display.contentWidth * 0.75, y = display.contentWidth * 0.035, transition = easing.outQuad})

	questionText.isVisible = true
	
	transition.to(questionText, {alpha = 1})
	transition.to(labelGroup, {y = labelGroup.y + 50, alpha = 1})
end

local function initialize()
	local randomIndex = math.random(1, #labelData)
	currentPortion = labelData[randomIndex]

	startButton.isVisible = false
	startButton.alpha = 0
	
	questionText.isVisible = false
	questionText.alpha = 0
	questionText.x = display.contentWidth * 0.72
	questionText.y = display.contentHeight * 0.2
	
	operationGroup = display.newGroup()
	
	labelGroup.x = display.contentWidth * 0.7
	labelGroup.y = display.contentHeight * 0.5
	
	for indexBlock = 1, #labelGroup.blocks do
		local currentBlock = labelGroup.blocks[indexBlock]
		currentBlock.xScale = 0.5
		currentBlock.yScale = 0.5
		currentBlock.alpha = 1
		currentBlock.y = (OFFSET_BLOCKS_Y * (indexBlock - 1))
	end
	
	wrongMark.isVisible = false
	correctMark.isVisible = false
	
	labelGroup.alpha = 0 
	
	gamePhase = "start"
end

local function showIcon(sceneGroup)
	
	iconPortion = display.newImage(currentPortion.iconAsset)
	iconPortion.x = display.contentWidth * 0.70
	iconPortion.y = display.contentHeight * 0.6
	sceneGroup:insert(iconPortion)
	
	local function animateIconPortion(animationName)
			transition.to(iconPortion, {tag = "icon", time = 300, y = iconPortion.y - 50, transition = easing.outQuad, onComplete = function()
				transition.to(iconPortion, {time = 100, y = iconPortion.y + 50, transition = easing.inQuad})
			end})
			transition.to(iconPortion, {tag = "icon", time = 200, xScale = 0.8, transition = easing.outBounce, onComplete = function()
				transition.to(iconPortion, {tag = "icon", delay = 0, xScale = 1, transition = easing.outBounce, onComplete = function()
					animationTimer = timer.performWithDelay(3000, animateIconPortion)
				end})
				--animateIconPortion()
			end})
			transition.to(iconPortion, {tag = "icon", time = 200, yScale = 1.2, transition = easing.outBounce, onComplete = function()
				transition.to(iconPortion, {tag = "icon", yScale = 1, transition = easing.outElastic})
			end})
	end
	
	animateIconPortion("squish")
	
	portionDescription = display.newText(currentPortion.name, iconPortion.x, iconPortion.y * 0.60, settings.fontName, 45)
	portionDescription:setFillColor(0.1)
	sceneGroup:insert(portionDescription)
	
	portionDescriptionBG = display.newText(currentPortion.name, iconPortion.x, iconPortion.y * 0.60, settings.fontName, 45)
	portionDescriptionBG.alpha = 0
	portionDescriptionBG:setFillColor(1)
	sceneGroup:insert(portionDescriptionBG)
	
end

local function goToNextScene(event)
	event.target:setEnabled(false)
	director.gotoScene("scenes.overlays.tips", {effect = "fade", time = 350, params = {worldIndex = worldIndex, levelIndex = levelIndex}})
end

local function showLabel()
	operationLabel.isVisible = true
	operationLabel.alpha = 0
	operationLabel:scale(0.8, 0.8)
	operationLabel.x = display.screenOriginX - operationLabel.contentWidth * 0.5
	operationLabel.y = display.contentCenterY
	
	transition.to(operationLabel, {alpha = 1})
	transition.to(operationLabel, {time = 1000, x = display.screenOriginX + operationLabel.contentWidth * 0.5, transition = easing.inOutQuad, onComplete = function()
		startButton.isVisible = true
		transition.to(startButton, {delay = 100, alpha = 1})
	end})

end

local function loadLabel()
	
	operationLabel = display.newImage(currentPortion.labelOperation)
	operationLabel.isVisible = false
	local scale = (display.contentHeight / 1024) * 2
	operationLabel:scale(scale, scale)
	middleLayer:insert(operationLabel)
	
	local randomQuestion = math.random(1, #currentPortion.operationData.questions)
	operationLabel.question = currentPortion.operationData.questions[randomQuestion]
	
	operationLabel.info = currentPortion.operationInfo
	
	questionText.text = operationLabel.question.text
	
	local correctIndex = operationLabel.question.answerId
	for indexBlock = 1, #labelGroup.blocks do
		local currentBlock = labelGroup.blocks[indexBlock]
		currentBlock.label.text = operationLabel.question.answers[indexBlock]
		currentBlock.isCorrect = false
		if correctIndex == indexBlock then
			currentBlock.isCorrect = true
		end
		
		currentBlock:addEventListener("tap", checkAnswer)
	end
	
end

------------------------------Module functions
function scene:create( event )

    local sceneGroup = self.view
	local scale = display.contentWidth / 1024
	local background = display.newImage("images/label/labelBackground.png")
	background:scale(scale, scale)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)
	
	middleLayer = display.newGroup()
	sceneGroup:insert(middleLayer)
	
	frontLayer = display.newGroup()
	sceneGroup:insert(frontLayer)
	
	labelGroup = display.newGroup()
	labelGroup.anchorChildren = true
	labelGroup.blocks = {}
	for indexBlock = 1, #blockData do
		local blockGroup = display.newGroup()
		local block = display.newImage(blockData[indexBlock])
		blockGroup:insert(block)
		
		local blockLabel = display.newText("asd", block.x, block.y, settings.fontName, 48)
		blockGroup.label = blockLabel
		blockGroup:insert(blockLabel)
		
		labelGroup.blocks[indexBlock] = blockGroup
		labelGroup:insert(blockGroup)
	end
	
	middleLayer:insert(labelGroup)
	
	local nameContainer = display.newImage("images/minigames/panel_producto.png")
	nameContainer.x = display.contentWidth + 20
	nameContainer.y = display.screenOriginY + (nameContainer.contentHeight * 0.4)
	nameContainer.anchorX = 1
	nameContainer.xScale = 1.1
	sceneGroup:insert(nameContainer)
	
	local textOptions = {
		text = "[TEMPLATE]",
		font = settings.fontName,
		fontSize = 38,
		align = "center",
		width = display.contentWidth * 0.5
	}
	
	textOptions.text = "[QUESTION]"
	questionText = display.newText(textOptions)
	questionText:setFillColor(0)
	middleLayer:insert(questionText)
	
	local buttonData = buttonList.minigamestart
	buttonData.onRelease = startMinigame
	startButton = widget.newButton(buttonData)
	startButton.isVisible = false
	startButton.x = display.contentWidth * 0.8
	startButton.y = display.contentHeight * 0.90
	
	frontLayer:insert(startButton)
	
	local spriteOptions  = {
		width = 256,
		height = 256,
		numFrames = 32,
		
		sheetContentWidth = 2048, 
		sheetContentHeight = 1024,
	}
	
	local correctSheet = graphics.newImageSheet( "images/label/correctSpriteSheet.png", spriteOptions)
	
	local spriteSettings = {
		name = "correct",
		start = 1,
		count = 32,
		time = 1000,
		loopCount = 1,
	}
	
	correctMark = display.newSprite(correctSheet, spriteSettings)
	correctMark:scale(1.5, 1.5)
	correctMark.x = display.contentCenterX
	correctMark.y = display.contentCenterY
	frontLayer:insert(correctMark)
	
	local spriteOptions  = {
		width = 256,
		height = 256,
		numFrames = 32,
		
		sheetContentWidth = 2048, 
		sheetContentHeight = 1024,
	}
	
	local correctSheet = graphics.newImageSheet( "images/label/wrongSpriteSheet.png", spriteOptions)
	
	local spriteSettings = {
		name = "wrong",
		start = 1,
		count = 32,
		time = 1000,
		loopCount = 1,
	}
	
	wrongMark = display.newSprite(correctSheet, spriteSettings)
	wrongMark:scale(1.5, 1.5)
	wrongMark.x = display.contentCenterX
	wrongMark.y = display.contentCenterY
	frontLayer:insert(wrongMark)
	
	local buttonData = buttonList.ok
	buttonData.onRelease = goToNextScene
	nextSceneButton = widget.newButton(buttonData)
	nextSceneButton:setEnabled(false)
	nextSceneButton.alpha = 0
	nextSceneButton.x = display.contentWidth - (nextSceneButton.contentWidth)
	nextSceneButton.y = display.contentHeight - (nextSceneButton.contentHeight * 0.80)
	frontLayer:insert(nextSceneButton)
end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
	
	local params = event.params or {}
	worldIndex = params.worldIndex
	levelIndex = params.levelIndex
	nextScene = event.params.nextScene or "scenes.menus.home"
	
    if ( phase == "will" ) then
		
		initialize()
		loadLabel(sceneGroup)
		
	elseif ( phase == "did" ) then
		showIcon(sceneGroup)
		showLabel(sceneGroup)
    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		
	elseif ( phase == "did" ) then
		display.remove(operationLabel)
		
		transition.cancel("icon")
		if animationTimer then
			timer.cancel(animationTimer)
		end
		display.remove(iconPortion)
		display.remove(portionDescription)
		display.remove(portionDescriptionBG)
	end
		
end


function scene:destroy( event )

    local sceneGroup = self.view
end

 
-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
