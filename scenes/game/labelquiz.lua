--------------------------------Label Minigame
local composer = require( "composer" )
local settings = require( "settings" )
local widget = require("widget")
local buttonList = require("data.buttonlist")
local animator = require("units.animator")
local players = require("models.players")
local heroList = require("data.herolist")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local answerPanelGroup, questionPanelGroup, questionPanel
local piecesGroup
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
	[1] = {text = "¿Respuesta 1?", answerid = 1}, 
	[2] = {text = "¿Respuesta 2?", answerid = 2},
	[3] = {text = "¿Respuesta 3?", answerid = 3},
	[4] = {text = "¿Respuesta 4?", answerid = 4},
	[5] = {text = "¿Respuesta 5?", answerid = 5},
}

local labelpositions = {
	[1] = {x = 37, y = -206, answer = 1, centerpos= {x = 36, y = -205, width = 300, height = 85}},	
	[2] = {x = 37, y = -129, answer = 2, centerpos= {x = 36, y = -130, width = 300, height = 50}},	
	[3] = {x = 37, y = -78, answer = 3, centerpos= {x = 36, y = -77, width = 300, height = 30}},	
	[4] = {x = -9, y = 12, answer = 4, centerpos= {x = 36, y = 10, width = 300, height = 110}},	
	[5] = {x = -10, y = 131 , answer = 5, centerpos= {x = 36, y = 165, width = 300, height = 155}},	
	[6] = {x = 143, y = 12, answer = 4, centerpos= {x = 36, y = 10, width = 300, height = 110}},
	[7] = {x = 142, y = 131, answer = 5, centerpos= {x = 36, y = 165, width = 300, height = 155}},	
	[8] = {x = 36, y = 195, answer = 5, centerpos= {x = 36, y = 165, width = 300, height = 155}},	
	[9] = {x = 36, y = 230, answer = 5, centerpos= {x = 36, y = 165, width = 300, height = 155}},
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

local function onTouchPiece(event)
	local label = event.target
	local phase = event.phase
	local parent = label.parent
	
	if "began" == phase then
		
		parent:insert( label )
		display.getCurrentStage():setFocus( label )

		label.isFocus = true
		label.isCorrect = false
		
		label.x0 = event.x - label.x
		label.y0 = event.y - label.y
		
		-------Coordinates Dumper
		--local labelX, labelY = label:localToContent(0,0)
		--local stageX, stageY = puzzlePanel:contentToLocal(labelX, labelY)
		--print(string.format("{x = %d, y = %d},", label.x, label.y))
		
	elseif label.isFocus then
		if "moved" == phase then
			
	
		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			label.isFocus = false
			
			answerRect.isVisible = true
			
			for indexLabel = 1, #piecesGroup.pieces do
				piecesGroup.pieces[indexLabel]:removeEventListener("touch", onTouchPiece)
			end
			
			local selectedLabel = labelpositions[label.id]
			if selectedLabel.answer == currentQuestion.answerid then
				answerRect.x = selectedLabel.centerpos.x
				answerRect.y = selectedLabel.centerpos.y
				answerRect:setStrokeColor(0, 0.5, 0)
				answerRect.width = selectedLabel.centerpos.width
				answerRect.height = selectedLabel.centerpos.height
				onCorrectAnswer()
			else
				local correctAnswer = labelpositions[currentQuestion.answerid]
				answerRect.width = correctAnswer.centerpos.width
				answerRect.height = correctAnswer.centerpos.height
				answerRect:setStrokeColor(0.5, 0, 0)
				answerRect.x = correctAnswer.centerpos.x
				answerRect.y = correctAnswer.centerpos.y
				onWrongAnswer()
			end
		end
	end
	
	return true
end	

local function createPlayerShip(group)
	
	local spritesheet = "images/ships/ship3_a.png"
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

local function createPuzzlePieces(group)
	piecesGroup = display.newGroup()
	piecesGroup.pieces = {}
	for indexPiece = 1, NUMBER_PIECES do
		local piece = display.newImage("images/label/piece"..indexPiece..".png")
		piece.id = indexPiece
		piecesGroup.pieces[indexPiece] = piece
		piecesGroup:insert(piece)
	end
	group:insert(piecesGroup)
end

local function gotoNextScreen()
	
	okButton:setEnabled(false)
	shipGroup.isVisible = true
	
	transition.to(bgShine, {alpha = 0, time = 500})
	transition.to(piecesGroup, {alpha = 0, time = 500})
	transition.to(panelText, {alpha = 0, time = 500})
	transition.to(answerPanelGroup, {delay = 600, transition = easing.inBack, x = display.viewableContentWidth + answerPanelGroup.width, time=1000})
	transition.to(questionPanelGroup, {delay = 600, transition = easing.inBack, y = display.screenOriginY - questionPanelGroup.height, time=1000})
	transition.to(answerRect, {alpha = 0, transition = easing.inQuad, time = 1000})
	transition.to(okButton, {delay = 600, transition = easing.inBack, y = display.viewableContentHeight + okButton.width, time = 1000})
	transition.to(shipGroup, {delay = 1300, transition = easing.inQuad, x = display.viewableContentWidth + 500, time = 1500, onComplete = function()
	--	transition.to(shipGroup, {delay = 1500, transition = easing.inQuad, x = display.contentCenterX, time = 1500, onComplete = function()
		composer.gotoScene("scenes.game.label", {effect = "fade", time = 400})
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

local function initScreenElements()
	
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
	titleText.size = 28
	titleText.x = questionPanel.x
	titleText.y = questionPanel.y
	
	okButton.isVisible = false
	okButton.alpha = 0
	okButton:setEnabled(false)
	okButton.x = display.contentCenterX
	okButton.y = display.contentCenterY * 1.80
	
	for indexPiece = 1, #piecesGroup.pieces do
		local currentPiece = piecesGroup.pieces[indexPiece]
		currentPiece.x = labelpositions[indexPiece].x
		currentPiece.y = labelpositions[indexPiece].y
		currentPiece.xScale = 1.25
		currentPiece.yScale = 1.25
		currentPiece.isCorrect = false
		currentPiece.scaledUp = false
		currentPiece:addEventListener("touch", onTouchPiece)
	end
	
	piecesGroup.isVisible = true
	piecesGroup.alpha = 1
	
	answerRect.isVisible = false
	answerRect.alpha = 1
	
	playerCharacter:setAnimation("WALK")
	playerCharacter.group.x = display.screenOriginX - 200
	playerCharacter.group.y = display.contentCenterY * 1.90
	playerCharacter.group.xScale = 1
	playerCharacter.group.yScale = 1
	
	marks.correct.isVisible = false
	marks.wrong.isVisible = false
	
	shipGroup.isVisible = true
	shipGroup.x = display.screenOriginX - playerShip.width * 2.5
	shipGroup.y = display.contentCenterY
	
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
		text = "Una etiqueta nutricional es aquella información que nos indica el valor energético y contenido del alimento en cuanto a proteínas, hidratos de carbono, grasas, fibra alimentaria, sodio, vitaminas y minerales. Debe expresarse por 100 gramos o 100 miligramos.",
		width = 400,
		font = settings.fontName,   
		fontSize = 28,
		align = "center"
	}
	
	titleText =  display.newText("Arma la etiqueta nutricional", 0, 0, settings.fontName, 28)
	questionPanelGroup:insert(titleText)
	sceneGroup:insert(questionPanelGroup)
	
	local buttonData = buttonList.play
	buttonData.onRelease = gotoNextScreen
	
	okButton = widget.newButton(buttonData)
	sceneGroup:insert(okButton)
	
	local answerPanel = display.newImage("images/label/panel_03.png")
	answerPanelGroup:insert(answerPanel)
	
	createPuzzlePieces(answerPanelGroup)
	
	answerRect = display.newRect(0,0,0,0)
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
		initScreenElements()
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

