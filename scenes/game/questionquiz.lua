--------------------------------Label Minigame
local composer = require( "composer" )
local settings = require( "settings" )
local widget = require("widget")
local buttonList = require("data.buttonlist")
local animator = require("units.animator")
local players = require("models.players")
local heroList = require("data.herolist")
local shipList = require("data.shiplist")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local answerPanelGroup, questionPanelGroup, questionPanel
local panelText, titleText
local okButton
local bgShine
local currentQuestion
local playerCharacter
local answerRect
local marks
local currentPlayer
local playerShip, shipGroup


local SIZE_BACKGROUND = 1024
local NUMBER_PIECES = 9

----------------------------Cached Functions
local mathSqrt = math.sqrt
local mathSin = math.sin
local mathAbs = math.abs
local mathRandom = math.random
-- -------------------------------------------------------------------------------

local questions = {
	[1] = {text = "¿Dónde puedes encontrar etiquetas nutrimentales?", answerid = 1, answers = {[1] = "En LA PARTE DE ATRAS todas las bebidas y alimentos empaquetados.", [2] = "En la tiendita.", [3] = "Llamando por teléfono al numero de emergencia.", [4] = "No se encuentra en ningún lugar.",}}, 
	[2] = {text = "¿Qué es un envase?", answerid = 2, answers = {[1] = "Una juguete que sale en los dulces.", [2] = "La bolsita o el paquetito donde viene el producto o alimento.", [3] = "Ninguna de las opciones.", [4] = "Un alimento que se vende en la calle.",}},
	[3] = {text = "¿Qué es una porción?", answerid = 3, answers = {[1] = "Es una parte, pedazo o una fraccion del producto total.", [2] = "Un producto entero", [3] = "Un pedazo de envoltura", [4] = "Es exactamente 20 gramos",}},
	--[4] = {text = "¿Pregunta 4(D)?", answerid = 4, answers = {[1] = "Respuesta A", [2] = "Respuesta B", [3] = "Respuesta C", [4] = "Respuesta D",}},
	--[5] = {text = "¿Pregunta 5(A)?", answerid = 1, answers = {[1] = "Respuesta A", [2] = "Respuesta B", [3] = "Respuesta C", [4] = "Respuesta D",}},
}

local function checkAnswers(time)
	if answerRect.isVisible then
		local scale = mathAbs(mathSin(time * 0.005)) * 0.05
		answerRect.xScale = (scale + 1)
		answerRect.yScale = (scale + 1)
	end
end

local function updateGameloop(event)
	checkAnswers(event.time)
	playerCharacter.enterFrame()
end

local function onCorrectAnswer()
	
	titleText.text = "¡Respuesta Correcta!"
	titleText.size = 42
	
	playerCharacter:setAnimationAndIdle("WIN")
	marks.correct.isVisible = true
	marks.correct:play()
	
	okButton.isVisible = true
	transition.to(okButton, {alpha = 1, onComplete = function()
		okButton:setEnabled(true)
	end})
end

local function onWrongAnswer()
	titleText.text = [[¡Respuesta Incorrecta!
						La respuesta correcta es:]]
	titleText.size = 34
	
	playerCharacter:setAnimationAndIdle("LOSE")
	
	marks.wrong.isVisible = true
	marks.wrong:play()
	
	okButton.isVisible = true
	transition.to(okButton, {alpha = 1, onComplete = function()
		okButton:setEnabled(true)
	end})
	
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
			
			for indexAnswer = 1, 4 do
				answerPanelGroup.answerPanels[indexAnswer]:removeEventListener("touch", onTouchListener)
			end
			
			answerRect.width = selectedAnswer.width
			answerRect.height = selectedAnswer.height
			
			print(selectedAnswer.id)
			--print(currentQuestion.answerid)

			if selectedAnswer.id == currentQuestion.answerid then
				answerRect.x = selectedAnswer.x
				answerRect.y = selectedAnswer.y
				answerRect:setStrokeColor(0, 0.5, 0)
				onCorrectAnswer()
			else
				
				local function searchAnswerById(id)
					for indexAnswer = 1, 4 do
						if answerPanelGroup.answerPanels[indexAnswer].id == id then
							return indexAnswer
						end
					end
				end
				
				local correctAnswer = searchAnswerById(currentQuestion.answerid)
				print(correctAnswer)
				answerRect.x = answerPanelGroup.answerPanels[correctAnswer].x
				answerRect.y = answerPanelGroup.answerPanels[correctAnswer].y
				answerRect:setStrokeColor(0.5, 0, 0)
				onWrongAnswer()
			end
		end
	end
	
	return true
end	

local function createPlayerShip(group)
	
	local spritesheet = shipList[currentPlayer.shipIndex].spritesheet
	local markSequenceData = {
		{name = "play", start = 1 , count = 4, time = 500, loopCount = 0},
	}
	local shipSpriteSheet = graphics.newImageSheet(spritesheet, {width = 256, height = 256, numFrames = 4 })
	
	playerShip = display.newSprite(shipSpriteSheet, markSequenceData)

--	shipSprite:addEventListener("sprite", function(event)
--		local sprite = event.target
--	end)

	playerShip.xScale = 2.5
	playerShip.yScale = 2.5
	
	group:insert(playerShip)
	--marks[currentMark.name] = markSprite
	
end

local function createBackground(group)
	local dynamicScale = display.viewableContentWidth / SIZE_BACKGROUND
    local background = display.newImage("images/backgrounds/label.png")
	background.x = display.contentCenterX
	background.y = display.contentCenterY
    background.xScale = dynamicScale
    background.yScale = dynamicScale
    group:insert(background)
end

local function gotoNextScreen()
	
	okButton:setEnabled(false)
	shipGroup.isVisible = true
	
	transition.to(bgShine, {alpha = 0, time = 500})
	transition.to(panelText, {alpha = 0, time = 500})
	transition.to(answerPanelGroup, {delay = 600, transition = easing.inBack, x = display.viewableContentWidth + answerPanelGroup.width, time=1000})
	transition.to(questionPanelGroup, {delay = 600, transition = easing.inBack, y = display.screenOriginY - questionPanelGroup.height, time=1000})
	transition.to(answerRect, {alpha = 0, transition = easing.inQuad, time = 1000})
	transition.to(okButton, {delay = 600, transition = easing.inBack, y = display.viewableContentHeight + okButton.width, time = 1000})
	transition.to(shipGroup, {delay = 1300, transition = easing.inQuad, x = display.viewableContentWidth + 500, time = 1500, onComplete = function()
	--	transition.to(shipGroup, {delay = 1500, transition = easing.inQuad, x = display.contentCenterX, time = 1500, onComplete = function()
		--composer.gotoScene("scenes.game.labelpuzzle", {effect = "fade", time = 400})
		composer.showOverlay("scenes.overlays.tips", {params = {nextScene = "scenes.game.shooter"}})
	end})
	
	local function yogotarJump()
		playerCharacter:setAnimationAndIdle("WIN")
		transition.to(playerCharacter.group, {time = 500, transition = easing.inQuint, xScale = 0.8, yScale = 0.8, y = playerCharacter.group.y - 100, onComplete = function()
			shipGroup:insert(playerCharacter.group)
			shipGroup:insert(playerShip)
			playerCharacter.group.x = 85
			playerCharacter.group.y = 150
		end})
	end
	
	timer.performWithDelay(1700, yogotarJump)
	
end

local function initScreenElements(group)
	
	answerPanelGroup.x = display.viewableContentWidth + answerPanelGroup.width
	answerPanelGroup.y = display.contentCenterY * 1.15
	
	bgShine.isVisible = false
	bgShine.alpha = 0
	bgShine.x = display.contentCenterX * 1.50
	bgShine.y = display.contentCenterY * 1.15
	bgShine.rotation = 0
	
	questionPanelGroup.x = display.contentCenterX * 0.50
	questionPanelGroup.y = display.screenOriginY - questionPanel.height
	
	local randomQuestion = mathRandom(1, #questions)
	
	currentQuestion = questions[randomQuestion]
	titleText.text = currentQuestion.text
	titleText.fontSize = 24
	titleText.x = questionPanel.x
	titleText.y = questionPanel.y
	
	okButton.isVisible = false
	okButton.alpha = 0
	okButton:setEnabled(false)
	okButton.x = display.contentCenterX
	okButton.y = display.contentCenterY * 1.80

	--Shuffle id's
	for indexAnswer = 1, #answerPanelGroup.answerPanels do
		local randomPosition = mathRandom(1, 4)
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
		currentAnswerPanel:addEventListener("touch", onTouchListener)
		yOffset = yOffset + 120
	end
	
	
	answerRect.isVisible = false
	answerRect.alpha = 0.7
	
	playerCharacter:setAnimation("WALK")
	playerCharacter.group.x = display.screenOriginX - 200
	playerCharacter.group.y = display.contentCenterY * 1.90
	playerCharacter.group.xScale = 1
	playerCharacter.group.yScale = 1
	group:insert(playerCharacter.group)
	
	marks.correct.isVisible = false
	marks.wrong.isVisible = false
	
	shipGroup.isVisible = true
	shipGroup.x = display.screenOriginX - playerShip.width * 2.5
	shipGroup.y = display.contentCenterY
	
end

local function createAnswerSquares(group)
	local answersGroup = display.newGroup()
	answerPanelGroup.answerPanels = {}
	for indexRect = 1, 4 do
		local answerGroupRect = display.newGroup()
		answerGroupRect.id = indexRect
		
		local answerRect = display.newRoundedRect(0, 0, 350, 100, 30)
		answerRect:setStrokeColor(0)
		answerRect.strokeWidth = 3
		answerGroupRect:insert(answerRect)
		
		local textData = {
			text = "",
			width = answerRect.width - 20,
			fontSize = 20,
			font = settings.fontName,
			align = "center",
		}
		
		local answerText = display.newText(textData)
		answerText:setFillColor(0)
		answerText.x = 0
		answerText.y = 0
		answerGroupRect:insert(answerText)
		
		answerGroupRect.answer = answerText
		
		answersGroup:insert(answerGroupRect)
		
		answerPanelGroup.answerPanels[indexRect] = answerGroupRect
	end
	group:insert(answersGroup)
	
end

local function createPlayerCharacter(group)
	local heroSkin = heroList[currentPlayer.heroIndex].skinName
	playerCharacter = animator.newCharacter(heroSkin, "PLACEHOLDER", "units/hero/skeleton.json", "units/hero/")
	playerCharacter:setHat(string.format("hat_extra_%02d", (currentPlayer.hatIndex-1)))
	local playerShadow = display.newCircle(0,-10,40)
	playerShadow.xScale = 3
	playerShadow:setFillColor(0)
	playerShadow.alpha = 0.3
	playerCharacter.group:insert(playerShadow)
	group:insert(playerCharacter.group)
end
---------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view
	
	createBackground(sceneGroup)
	
	currentPlayer = players.getCurrent()
	
	answerPanelGroup = display.newGroup()
	sceneGroup:insert(answerPanelGroup)
	
	bgShine = display.newImage("images/backgrounds/shine.png")
	sceneGroup:insert(bgShine)
	
	questionPanelGroup = display.newGroup()
	questionPanel = display.newImage("images/label/bigpanel.png")
	questionPanelGroup:insert(questionPanel)
	
	local textData = {
		text = "",
		width = 350,
		font = settings.fontName,   
		fontSize = 28,
		align = "center"
	}
	
	titleText =  display.newText(textData)
	questionPanelGroup:insert(titleText)
	sceneGroup:insert(questionPanelGroup)
	
	local buttonData = buttonList.play
	buttonData.onRelease = gotoNextScreen
	
	okButton = widget.newButton(buttonData)
	sceneGroup:insert(okButton)
	
	local answerPanel = display.newImage("images/label/panel_04.png")
	answerPanelGroup:insert(answerPanel)
	
	createAnswerSquares(answerPanelGroup)
	
	--createPuzzlePieces(answerPanelGroup)
	
	answerRect = display.newRoundedRect(0,0,0,0,30)
	answerRect.strokeWidth = 10
	answerRect:setStrokeColor(0)
	answerRect:setFillColor(0,0,0,0)
	answerPanelGroup:insert(answerRect)
	
	createPlayerCharacter(sceneGroup)
	
	shipGroup = display.newGroup()
	sceneGroup:insert(shipGroup)
	createPlayerShip(shipGroup)
	
	createMark(sceneGroup)
end

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		initScreenElements(sceneGroup)
		Runtime:addEventListener("enterFrame", updateGameloop)
		
	elseif ( phase == "did" ) then
		transition.to(answerPanelGroup, {delay = 300, transition = easing.outBounce, x = display.contentCenterX * 1.50, time=1000})
		transition.to(questionPanelGroup, {delay = 300, transition = easing.outBounce, y = display.contentCenterY * 0.40, time=1000})
		transition.to(playerCharacter.group, {x = display.contentCenterX * 0.50, time = 1500, onComplete = function()
			playerCharacter:setAnimation("IDLE")
		end})
		timer.performWithDelay()
    end
	
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		
		
	elseif ( phase == "did" ) then
		
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


