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
local howToRead
local middleLayer, frontLayer
local gamePhase
local portionSize, energeticContent, totalPerPack
local operandMultiply, operandEqual
local operationGroup
local tutorialHand
local tutorialTimer

----------------------------Constants
local COLOR_OPERAND1 = {0.2, 0.3, 0.5}
local COLOR_OPERAND2 = {0.5, 0.2, 0.3}
local COLOR_RESULT = {0.2, 0.6, 0.2}
local INDEX_PORTION = 1
------------------------------------------------------------------------------
local function moveHand(point1, point2, travelTime)
	
	tutorialHand.x = point1.x
	tutorialHand.y = point1.y
	tutorialHand.alpha = 0
	transition.to(tutorialHand, {alpha = 1, onComplete = function()
		transition.to(tutorialHand, {time = travelTime, x = point2.x, y = point2.y, transition = easing.outSine, onComplete = function()
			transition.to(tutorialHand, {alpha = 0})
		end})
	end})
end

local function animateTutorial()
	local point1 ={
		x = operationLabel.x + operationLabel.contentWidth * 0.1,
		y = operationLabel.y - operationLabel.contentHeight * 0.3
	}

	local operandX, operandY = operationGroup:localToContent(operationGroup.operand1.x, operationGroup.operand1.y)
	local point2 = {
		x = operandX + 20,
		y = operandY + 50,
	}

	moveHand(point1, point2, 1000)
	tutorialTimer = timer.performWithDelay(2000, function()
		point1.x = operationLabel.x + operationLabel.contentWidth * 0.4
		point1.y = operationLabel.y - operationLabel.contentHeight * 0.2

		operandX, operandY = operationGroup:localToContent(operationGroup.operand2.x, operationGroup.operand2.y)
		point2.x = operandX + 50
		point2.y = operandY + 50
		moveHand(point1, point2, 1000)
		tutorialTimer = timer.performWithDelay(2000, animateTutorial)
	end)
end

local function labelComplete()
	
	nextSceneButton:setEnabled(true)
	transition.to(nextSceneButton, {alpha = 1, time = 300})
	transition.to(descriptionText, {alpha = 1, time = 300})
	transition.to(descriptionRect, {alpha = 0.6, time = 300})
	
end

local function createOperation(operands)
	
	operands = operands or {0,0}
	local operation = display.newGroup()
	
	local operand1 = display.newText(operands[1], 0, 0, settings.fontName, 38)
	operand1:setFillColor(unpack(COLOR_OPERAND1))
	operation:insert(operand1)
	
	local multiply = display.newImage("images/label/multiply.png")
	multiply:scale(0.5, 0.5)
	multiply.x = operand1.x + (operand1.contentWidth * 0.5) + multiply.contentWidth
	operation:insert(multiply)
	
	local operand2 = display.newText(operands[2], operation.x + operation.contentWidth, 0, settings.fontName, 38)
	operand2:setFillColor(unpack(COLOR_OPERAND2))
	operand2.x =  multiply.x + multiply.contentWidth + (operand2.contentWidth * 0.5)
	operation:insert(operand2)
	
	local equal = display.newImage("images/label/equalsGreen.png")
	equal:scale(0.5, 0.5)
	equal.x = operand2.x + (operand2.contentWidth * 0.5) + equal.contentWidth
	operation:insert(equal)
	
	local result = display.newText(operands[1] * operands[2], operation.x + operation.contentWidth, 0, settings.fontName, 38)
	result:setFillColor(unpack(COLOR_RESULT))
	result.x =  equal.x + multiply.contentWidth + (result.contentWidth * 0.5)
	operation:insert(result)
	
	local function animateResult()
		transition.to(result, {xScale = 1.5, yScale = 1.5, transition = easing.inSine, onComplete = function()
			transition.to(result, {xScale = 1, yScale = 1, transition = easing.outSine, onComplete = function()
				animateResult()
			end})
		end})
	end
	
	animateResult()
	
	operation.operand1 = operand1
	operation.operand2 = operand2
	
	return operation
end

local function startMinigame(event)
	
	local target = event.target
	if gamePhase == "start" then
		
		target.isVisible = false
		transition.to(howToRead, {alpha = 0})
		transition.to(operationLabel, {y = display.contentHeight * 0.5, transition = easing.outQuad, onComplete = function()
			transition.to(operationLabel, {xScale = operationLabel.xScale * 0.8, yScale = operationLabel.yScale * 0.8, x = display.contentWidth * 0.2, transition = easing.outSine, onComplete = function()
					portionSize.isVisible = true
					energeticContent.isVisible = true
					totalPerPack.isVisible = true
					operandMultiply.isVisible = true
					operandEqual.isVisible = true
					
					portionSize.x = operationLabel.x + display.contentWidth * 0.5
					energeticContent.x = operationLabel.x + display.contentWidth * 0.5
					totalPerPack.x = operationLabel.x + display.contentWidth * 0.5
					
					operandEqual.x = portionSize.x
					operandMultiply.x = portionSize.x
					
					transition.from(operandEqual, {delay = 200, alpha = 0, y = operandEqual.y - 30})
					transition.from(operandMultiply, {delay = 200, alpha = 0, y = operandMultiply.y - 30})
					transition.from(portionSize, {alpha = 0, y = portionSize.y - 100})
					transition.from(energeticContent, {delay = 200, alpha = 0, y = energeticContent.y - 100})
					transition.from(totalPerPack, {delay = 400, alpha = 0, y = totalPerPack.y - 100})
					
					operationGroup = createOperation({currentPortion.operationInfo.portions, currentPortion.operationInfo.energetic})
					operationGroup.anchorChildren = true
					operationGroup:scale(1.5, 1.5)
					operationGroup.x = operandEqual.x
					operationGroup.y = display.contentHeight * 0.6
					middleLayer:insert(operationGroup)
					
					transition.from(operationGroup, {delay = 300, alpha = 0, y = operationGroup.y - 30})
					
					target.isVisible = true
					target.alpha = 0
					
					nextSceneButton:setEnabled(true)
					nextSceneButton.isVisible = true
					transition.to(nextSceneButton, {delay = 500, alpha = 1})
					
					tutorialHand.isVisible = true
					animateTutorial()
			end})
			
		end})	
	end
	
end

local function initialize()

	currentPortion = labelData[INDEX_PORTION]

	howToRead.text = "Cómo leer una etiqueta nutrimental"
	howToRead.isVisible = true
	howToRead.alpha = 0
	
	startButton.isVisible = false
	startButton.alpha = 0
	
	portionSize.text = "Porciones por empaque"
	portionSize.alpha = 1
	portionSize.isVisible = false
	portionSize.x = display.contentWidth * 0.6
	portionSize.y = display.contentHeight * 0.1
	
	operandMultiply.isVisible = false
	operandMultiply.alpha = 1
	operandMultiply.x = portionSize.x + 100
	operandMultiply.y = portionSize.y + 50
	
	energeticContent.text = currentPortion.operationInfo.toCalculate
	energeticContent.isVisible = false
	energeticContent.alpha = 1
	energeticContent.x = display.contentWidth * 0.6
	energeticContent.y = portionSize.y + 100
	
	operandEqual.isVisible = false
	operandEqual.alpha = 1
	operandEqual.x = energeticContent.x + 100
	operandEqual.y = energeticContent.y + 50
	
	totalPerPack.text = "Total por paquete " .. "(" .. currentPortion.operationInfo.units .. ")"
	totalPerPack.isVisible = false
	totalPerPack.alpha = 1
	totalPerPack.x = display.contentWidth * 0.6
	totalPerPack.y = energeticContent.y + 100
	
	operationGroup = display.newGroup()
	
	gamePhase = "start"
	
	tutorialHand.isVisible = false
	tutorialHand.alpha = 0
	
	nextSceneButton:setEnabled(false)
	nextSceneButton.isVisible = false
	nextSceneButton.alpha = 0
end

local function goToNextScene()
	transition.to(operationGroup, {alpha = 0})
	transition.to(operandEqual, {alpha = 0})
	transition.to(operandMultiply, {alpha = 0})
	transition.to(portionSize, {alpha = 0})
	transition.to(energeticContent, {alpha = 0})
	transition.to(totalPerPack, {alpha = 0})
	transition.to(tutorialHand, {alpha = 0})
	transition.to(operationLabel, {time = 750, x = display.screenOriginX, alpha = 0, onComplete = function()
		director.gotoScene("scenes.minigames.quizlabel", {params = {worldIndex = worldIndex, levelIndex = levelIndex}})
	end})
end

local function showLabel()
	operationLabel.isVisible = true
	operationLabel.alpha = 0
	operationLabel.x = display.contentCenterX
	operationLabel.y = display.screenOriginY
	
	transition.to(operationLabel, {alpha = 1})
	transition.to(operationLabel, {time = 1000, y = display.contentHeight * 0.9, transition = easing.inOutQuad, onComplete = function()
		howToRead.isVisible = true
		startButton.isVisible = true
		transition.to(howToRead, {alpha = 1})
		transition.to(startButton, {delay = 100, alpha = 1})
	end})

end

local function loadLabel(sceneGroup)
	
	operationLabel = display.newImage(currentPortion.labelOperation)
	operationLabel.isVisible = false
	local scale = (display.contentHeight / 1024) * 2
	operationLabel:scale(scale, scale)
	middleLayer:insert(operationLabel)
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
	
	local textOptions = {
		text = "[HOW TO READ]",
		font = settings.fontName,
		fontSize = 58,
		align = "center",
		width = display.contentWidth * 0.5
	}
	
	howToRead = display.newText(textOptions)
	howToRead:setFillColor(0)
	howToRead.isVisible = false
	howToRead.x = display.contentCenterX
	howToRead.y = display.contentHeight * 0.20
	frontLayer:insert(howToRead)
	
	textOptions.text = "[PORTION SIZE]"
	textOptions.fontSize = 38
	portionSize = display.newText(textOptions)
	portionSize:setFillColor(unpack(COLOR_OPERAND1))
	portionSize.isVisible = false
	middleLayer:insert(portionSize)
	
	textOptions.text = "[ENERGETIC CONTENT]"
	energeticContent = display.newText(textOptions)
	energeticContent:setFillColor(unpack(COLOR_OPERAND2))
	energeticContent.isVisible = false
	middleLayer:insert(energeticContent)
	
	textOptions.text = "[TOTAL PER PACK]"
	totalPerPack = display.newText(textOptions)
	totalPerPack:setFillColor(unpack(COLOR_RESULT))
	totalPerPack.isVisible = false
	middleLayer:insert(totalPerPack)
	
	operandMultiply = display.newImage("images/label/multiply.png")
	operandMultiply:scale(0.7, 0.7)
	operandMultiply.isVisible = false
	middleLayer:insert(operandMultiply)
	
	operandEqual = display.newImage("images/label/equalsGreen.png")
	operandEqual:scale(0.7, 0.7)
	operandEqual.isVisible = false
	middleLayer:insert(operandEqual)
	
	local buttonData = buttonList.minigamestart
	buttonData.onRelease = startMinigame
	startButton = widget.newButton(buttonData)
	startButton.isVisible = false
	startButton.x = display.contentWidth * 0.8
	startButton.y = display.contentHeight * 0.90
	frontLayer:insert(startButton)
	
	local buttonData = buttonList.ok
	buttonData.onRelease = goToNextScene
	nextSceneButton = widget.newButton(buttonData)
	nextSceneButton:setEnabled(false)
	nextSceneButton.alpha = 0
	nextSceneButton.x = display.contentWidth - (nextSceneButton.contentWidth)
	nextSceneButton.y = display.contentHeight - (nextSceneButton.contentHeight * 0.80)
	frontLayer:insert(nextSceneButton)
	
	tutorialHand = display.newImage("images/general/hand.png")
	tutorialHand.isVisible = false
	tutorialHand:scale(0.5, 0.5)
	frontLayer:insert(tutorialHand)
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
		--showIcon(sceneGroup)
		showLabel(sceneGroup)
    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		
	elseif ( phase == "did" ) then
		display.remove(operationGroup)
		display.remove(operationLabel)
		
		if tutorialTimer then
			timer.cancel(tutorialTimer)
		end
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
