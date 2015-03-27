--------------------------------Label Minigame
local director = require( "libs.helpers.director" )
local settings = require( "settings" )
local widget = require("widget")
local buttonList = require("data.buttonlist")
local animator = require("services.animator")
local players = require("models.players")
local heroList = require("data.herolist")
local shipList = require("data.shiplist")
local sound = require("libs.helpers.sound")
local operations = require("data.operationlist")

local scene = director.newScene()

--------------------------Variables
local answerPanelGroup
local panelText, titleText, okButton, itemText, item2Text, initScreen, x, line, tipText
local marks, puzzleIndex, answerRect, currentQuestion, bgShine
local playerShip, shipGroup, currentPlayer, questionCounter
local worldIndex, levelIndex, opPanelGroup,iconGroup

---------------------------Constants 

local SIZE_BACKGROUND = 1024
local NUMBER_PIECES = 9
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenLeft = display.screenOriginX
local screenWidth = display.viewableContentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.viewableContentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight 
local imageNames = {"cereal","chocochispas","jugomanzana","jugonatural","leche","lechechoco","pastelchoco","queso","refresco","yogurt"}
local orderIndex = {9,10,3,5,3,2,8,6,11,4}
local itemForOperations={
[1] = {"1 porción","110 kcal"},
[2] = {"2 porciones","134 kcal"},
[3] = {"1.25 porciones","14 mg"},
[4] = {"1.75 porciones","39.84 kcal"},
[5] = {"1 porción","114 kcal"},
[6] = {"1 porción","121 kcal"},
[7] = {"1 porción","200 kcal"},
[8] = {"1.6 porciones","162 kcal"},
[9] = {"1 porción","47 mg"},
[10] = {"1 porción","68 kcal"},
}
----------------------------Cached Functions
local mathSqrt = math.sqrt
local mathSin = math.sin
local mathAbs = math.abs
local mathRandom = math.random
-- -------------------------------------------------------------------------------

local function checkAnswers(time)
	if answerRect.isVisible then
		local scale = mathAbs(mathSin(time * 0.005)) * 0.05
		answerRect.xScale = (scale + 1)
		answerRect.yScale = (scale + 1)
	end
end

local function updateGameloop(event)
	checkAnswers(event.time)
end

local function setQuestion()
	if questionCounter == 1 then
		currentQuestion = operations.firstQuestions[puzzleIndex]
	elseif questionCounter == 2 then
		currentQuestion = operations.secondQuestions[puzzleIndex]
	else
		currentQuestion = operations.thirdQuestions[puzzleIndex]
	end
	
	titleText.text = currentQuestion.text

	--Shuffle id's
	for indexAnswer = 1, #answerPanelGroup.answerPanels do
		local randomPosition = mathRandom(1, 3)
		local currentAnswerPanel = answerPanelGroup.answerPanels[indexAnswer]
		
		local swapid = currentAnswerPanel.id
		currentAnswerPanel.id = answerPanelGroup.answerPanels[randomPosition].id
		answerPanelGroup.answerPanels[randomPosition].id = swapid
	end
	
	--Assign question Text
	local yOffset = 0
	local startingY = -180
	for indexAnswer = 1, #answerPanelGroup.answerPanels do
		local currentAnswerPanel = answerPanelGroup.answerPanels[indexAnswer]
		currentAnswerPanel.x = 20
		currentAnswerPanel.y = startingY + yOffset
		currentAnswerPanel.answer.text = currentQuestion.answers[currentAnswerPanel.id]
		yOffset = yOffset + 90
	end
	
	
	answerRect.isVisible = false
	answerRect.alpha = 0.7
	
	marks.correct.isVisible = false
	marks.wrong.isVisible = false
end
local function animateScene()
	if questionCounter == 1 then
		transition.to(iconGroup[puzzleIndex],{delay = 400, alpha = 1, time = 300})
		opPanelGroup[puzzleIndex].alpha = 1
		transition.to(opPanelGroup,{delay = 400, transition = easing.outBounce, x = screenLeft + 300, time = 1000})
	elseif questionCounter == 3 then
		answerPanelGroup.y = centerY + 180
		transition.to(itemText,{ alpha = 1, x = screenRight - 300, delay = 300, time = 800})
		transition.to(item2Text,{ alpha = 1, x = screenRight - 300, delay = 300, time = 800})
		transition.to(x,{alpha = 1, time = 300})
		transition.to(line,{alpha = 1, time = 300})
	end
	transition.to(titleText, {alpha = 1,delay = 300, transition = easing.outBounce, y = screenTop + 50, time=1000})
	transition.to(answerPanelGroup, {alpha = 1, delay = 300, transition = easing.outBounce, x = display.contentCenterX * 1.45, time=1000})
	timer.performWithDelay(750, function()
		sound.play("ironshield")
	end)
end

local function checkAnswer()
	if questionCounter == 3 then
		okButton.isVisible = true
		transition.to(itemText,{alpha = 0})
		transition.to(item2Text,{alpha = 0})
		x.alpha = 0
		line.alpha = 0
		transition.to(answerPanelGroup,{delay = 600, alpha = 0, time = 600, onComplete = function()
			titleText.text = "Tip Nutrimental"
		end})
		transition.to(tipText,{delay = 600, alpha = 1, time = 300})
		transition.to(okButton, {alpha = 1, onComplete = function()
			okButton:setEnabled(true)
		end})
		return
	else
		timer.performWithDelay(1500,function()
			transition.to(titleText,{alpha = 0, time = 300, y = screenTop - screenHeight})
			transition.to(answerPanelGroup,{x=display.viewableContentWidth + answerPanelGroup.width,alpha = 0, time = 300})
		end)
	end
	questionCounter = questionCounter + 1
	timer.performWithDelay(1800,function()
		setQuestion()
		animateScene()
	end)
end
local function onCorrectAnswer()
	
	sound.play("correct")
	titleText.text = "¡Respuesta Correcta!"
	titleText.size = 42
	
	marks.correct.isVisible = true
	marks.correct:play()
	
	checkAnswer()
	
end

local function onWrongAnswer()
	
	sound.play("wrong")
	titleText.text = [[¡Respuesta Incorrecta!
						La respuesta correcta es:]]
	titleText.size = 34
		
	marks.wrong.isVisible = true
	marks.wrong:play()
	
	checkAnswer()
	
end
local function onTouchListener(event)
	local selectedAnswer = event.target
	local phase = event.phase
	local parent = selectedAnswer.parent
	
	if "began" == phase then
		
		parent:insert( selectedAnswer )
		display.getCurrentStage():setFocus( selectedAnswer )

		selectedAnswer.isFocus = true
		selectedAnswer.isCorrect = false
		
		selectedAnswer.x0 = event.x - selectedAnswer.x
		selectedAnswer.y0 = event.y - selectedAnswer.y
		
		-------Coordinates Dumper
		--local labelX, labelY = label:localToContent(0,0)
		--local stageX, stageY = puzzlePanel:contentToLocal(labelX, labelY)
		--print(string.format("{x = %d, y = %d},", label.x, label.y))
		
	elseif selectedAnswer.isFocus then
		if "moved" == phase then
			
	
		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			selectedAnswer.isFocus = false
			
			answerRect.isVisible = true
			if questionCounter == 3 then
				for indexAnswer = 1, 3 do
					answerPanelGroup.answerPanels[indexAnswer]:removeEventListener("touch", onTouchListener)
				end
			end
			answerRect.width = selectedAnswer.width
			answerRect.height = selectedAnswer.height
			
--			print(selectedAnswer.id)
			--print(currentQuestion.answerid)

			if selectedAnswer.id == currentQuestion.answerid then
				answerRect.x = selectedAnswer.x
				answerRect.y = selectedAnswer.y
				answerRect:setStrokeColor(0, 0.5, 0)
				onCorrectAnswer()
			else
				
				local function searchAnswerById(id)
					for indexAnswer = 1, 3 do
						if answerPanelGroup.answerPanels[indexAnswer].id == id then
							return indexAnswer
						end
					end
				end
				
				local correctAnswer = searchAnswerById(currentQuestion.answerid)
--				print(correctAnswer)
				answerRect.x = answerPanelGroup.answerPanels[correctAnswer].x
				answerRect.y = answerPanelGroup.answerPanels[correctAnswer].y
				answerRect:setStrokeColor(0.5, 0, 0)
				onWrongAnswer()
			end
		end
	end
	
	return true
end	

local function initScreenElements()
	
	itemText.alpha = 0
	itemText.x = screenLeft + 300
	itemText.text = itemForOperations[puzzleIndex][1]

	item2Text.x = screenLeft + 300
	item2Text.alpha = 0
	item2Text.text = itemForOperations[puzzleIndex][2]

	answerPanelGroup.x = display.viewableContentWidth + answerPanelGroup.width
	answerPanelGroup.y = centerY + 100

	opPanelGroup.x = screenLeft - (screenWidth * 0.5)
	opPanelGroup.y = centerY + 50

	titleText.anchorY = 0
	titleText.x = centerX
	titleText.y = screenTop - (screenHeight * 0.5)
	
	tipText.x = screenRight - 300
	tipText.y = centerY - 70
	tipText.text = operations.tips[puzzleIndex]

	okButton.isVisible = false
	okButton.alpha = 0
	okButton:setEnabled(false)
	okButton.x = screenRight - 150
	okButton.y = screenBottom - 80
	
	bgShine.isVisible = false
	bgShine.alpha = 0
	bgShine.x = display.contentCenterX * 1.50
	bgShine.y = display.contentCenterY * 1.15
	bgShine.rotation = 0
	
	for indexAnswer = 1, #answerPanelGroup.answerPanels do
		local currentAnswerPanel = answerPanelGroup.answerPanels[indexAnswer]
		currentAnswerPanel:addEventListener("touch", onTouchListener)
	end
	setQuestion()
end

local function createMark(group)
	
	local markData = {[1] = {name = "correct", spritesheet = "images/label/correctSpriteSheet.png"},
					  [2] = {name = "wrong", spritesheet = "images/label/wrongSpriteSheet.png"}}
	marks = {}
	for indexMark = 1, #markData do
		local currentMark = markData[indexMark]
		local pathSpriteSheet = currentMark.spritesheet
		local markSequenceData = {
			{name = "play", start = 1 , count = 32, time = 1000, loopCount = 1},
		}
		local markImageSheet = graphics.newImageSheet(pathSpriteSheet, {width = 256, height = 256, numFrames = 32 })
		local markSprite = display.newSprite(markImageSheet, markSequenceData)
		
		markSprite:addEventListener("sprite", function(event)
			local sprite = event.target
			if sprite.sequence == "play" and event.phase == "ended" then
				sprite.isVisible = false
			end
		end)
		
		markSprite.x = display.contentCenterX
		markSprite.y = display.contentCenterY
		markSprite.xScale = 2
		markSprite.yScale = 2
		group:insert(markSprite)
		
		marks[currentMark.name] = markSprite
		
	end
end

local function createBackground(group)
	local dynamicScale = display.viewableContentWidth / SIZE_BACKGROUND
    local background = display.newImage("images/label/labelBackground.png")
	background.x = display.contentCenterX
	background.y = display.contentCenterY
    background.width  = screenWidth
    background.height = screenHeight
    group:insert(background)
end

local function gotoNextScreen()
	
	okButton:setEnabled(false)
--	shipGroup.isVisible = true
	
	timer.performWithDelay(1500, function()
		sound.play("fly")
	end)
	transition.to(iconGroup[puzzleIndex],{alpha = 0, time = 300, delay = 300})
	transition.to(bgShine, {alpha = 0, time = 500})
	transition.to(panelText, {alpha = 0, time = 500})
	transition.to(tipText, {alpha = 0})
	transition.to(opPanelGroup,{delay = 400, transition = easing.inBack, x = screenLeft - 500, time = 1000})
--	transition.to(answerPanelGroup, {delay = 600, transition = easing.inBack, x = screenRight + screenWidth, time=1000})
	transition.to(titleText, {delay = 600, transition = easing.inBack, y = screenTop - screenHeight, time=1000})
	transition.to(answerRect, {alpha = 0, transition = easing.inQuad, time = 1000})
	transition.to(okButton, {delay = 600, transition = easing.inBack, y = display.viewableContentHeight + okButton.width, time = 1000})
--	transition.to(shipGroup, {delay = 1300, transition = easing.inQuad, x = display.viewableContentWidth + 500, time = 1500, onComplete = function()
	--	transition.to(shipGroup, {delay = 1500, transition = easing.inQuad, x = display.contentCenterX, time = 1500, onComplete = function()
		--director.gotoScene("scenes.game.labelpuzzle", {effect = "fade", time = 400})
	timer.performWithDelay(1800,function()
		director.showOverlay("scenes.overlays.tips", {params = {nextScene = "scenes.game.shooter", worldIndex = worldIndex, levelIndex = levelIndex}})
	end)
--	end})	
end

local function createAnswerSquares(group)
	local answersGroup = display.newGroup()
	answerPanelGroup.answerPanels = {}
	for indexRect = 1, 3 do
		local answerGroupRect = display.newGroup()
		answerGroupRect.id = indexRect
		
		local answerRect = display.newRect(0, 0, 350, 70)
		answerRect:setFillColor(0.2,0.2,0.2)
		answerGroupRect:insert(answerRect)
		
		local textData = {
			text = "",
			width = answerRect.width - 20,
			fontSize = 30,
			font = settings.fontName,
			align = "center",
		}
		
		local answerText = display.newText(textData)
		answerText:setFillColor(1)
		answerText.x = 0
		answerText.y = 0
		answerGroupRect:insert(answerText)
		
		answerGroupRect.answer = answerText
		
		answersGroup:insert(answerGroupRect)
		
		answerPanelGroup.answerPanels[indexRect] = answerGroupRect
	end
	group:insert(answersGroup)
	
end

local function createIcons(grp)
	local iconImage
	for i = 1, #orderIndex  do
		iconImage = display.newImage("images/label/icons/".. orderIndex[i] .. ".png")
		iconImage.xScale = 0.6
		iconImage.yScale = 0.6
		iconImage.alpha = 0
		iconGroup:insert(iconImage)
	end
	iconGroup.x = screenRight - 150
	iconGroup.y = screenTop + 150
	grp:insert(iconGroup)
end
---------------------------------------------------------------------------------
function scene:create( event )
	
--	puzzleIndex = 8
    local sceneGroup = self.view
	
	createBackground(sceneGroup)
	
	currentPlayer = players.getCurrent()
	iconGroup = display.newGroup()
	answerPanelGroup = display.newGroup()
	opPanelGroup = display.newGroup()
	
	sceneGroup:insert(opPanelGroup)
	sceneGroup:insert(answerPanelGroup)
	
	local image
	for i=1, #imageNames do
		image = display.newImage("images/label/operationPanels/" .. imageNames[i] .. ".png")
		image.xScale = 0.9
		image.yScale = 0.9
		image.alpha = 0
		opPanelGroup:insert(image)
	end
	bgShine = display.newImage("images/backgrounds/shine.png")
	sceneGroup:insert(bgShine)
	
	local textData = {
		text = "",
		width = 600,
		font = settings.fontName,   
		fontSize = 42,
		align = "center"
	}
	
	titleText =  display.newText(textData)
	sceneGroup:insert(titleText)
	
	textData = {
		text = "",
		width = 400,
		font = settings.fontName,   
		fontSize = 28,
		align = "center"
	}
	
	tipText = display.newText(textData)
	sceneGroup:insert (tipText)
	
	itemText = display.newText("   kg", centerX, centerY - 150, settings.fontName, 32)
	item2Text = display.newText("   kg", centerX, centerY - 90, settings.fontName, 32)
	
	x = display.newText("X", screenRight - 160, centerY - 120, settings.fontName, 80)
	
	line = display.newText("_____", screenRight - 270, centerY - 100, settings.fontName, 90)
	
	sceneGroup:insert(line)
	sceneGroup:insert(x)
	sceneGroup:insert(itemText)
	sceneGroup:insert(item2Text)
	
	local buttonData = buttonList.play
	buttonData.onRelease = gotoNextScreen
	
	okButton = widget.newButton(buttonData)
	sceneGroup:insert(okButton)
	
	createAnswerSquares(answerPanelGroup)
	
	--createPuzzlePieces(answerPanelGroup)
	
	answerRect = display.newRect(0,0,0,0)
	answerRect.strokeWidth = 10
	answerRect:setStrokeColor(0)
	answerRect:setFillColor(0,0,0,0)
	answerPanelGroup:insert(answerRect)
		
--	shipGroup = display.newGroup()
--	sceneGroup:insert(shipGroup)
--	createPlayerShip(shipGroup)
	
	createMark(sceneGroup)
	createIcons(sceneGroup)
end


local function enableButtons()
	okButton:setEnabled(true)
end

local function disableButtons()
	okButton:setEnabled(false)
end

local function hideElements()
	answerPanelGroup.y = centerY + 100
	iconGroup[puzzleIndex].alpha = 0
	x.alpha = 0
	line.alpha = 0
	tipText.alpha = 0
end

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
	
	local params = event.params or {}
	worldIndex = params.worldIndex
	levelIndex = params.levelIndex

    if ( phase == "will" ) then
		questionCounter = 1
		puzzleIndex = mathRandom(#imageNames)
		initScreenElements()
		hideElements()
		Runtime:addEventListener("enterFrame", updateGameloop)
		
	elseif ( phase == "did" ) then
		animateScene()
    end
	
end
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		
		
	elseif ( phase == "did" ) then
		hideElements()
--		puzzleIndex = puzzleIndex + 1
		Runtime:removeEventListener("enterFrame", updateGameloop)
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene


