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

local scene = director.newScene()

----------------------------Variables
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
local worldIndex, levelIndex

----------------------------Constansts
local SIZE_BACKGROUND = 1024
local NUMBER_PIECES = 5
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenLeft = display.screenOriginX
local screenWidth = display.viewableContentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.viewableContentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight 
local mRandom = math.random 
----------------------------Cached Functions
local mathSqrt = math.sqrt
local mathSin = math.sin
local mathAbs = math.abs
local mathRandom = math.random
-- -------------------------------------------------------------------------------

local questions = {
	[1] = {text = "¿Dónde se ven las proteínas del producto?", answerid = 5}, 
	[2] = {text = "¿En que parte se indica el sodio del producto?", answerid = 4},
	[3] = {text = "¿Dónde se indica el tamaño de la porción en el producto?", answerid = 1},
	[4] = {text = "¿Dónde se indica la cantidad por porción del producto?", answerid = 2},
	[5] = {text = "¿Dónde se indican las grasas totales en el producto?", answerid = 4},
}

local labelpositions = {
	[1] = {x = 37, y = -206, answer = 1, centerpos= {x = 36, y = -205, width = 300, height = 85}},	
	[2] = {x = 37, y = -129, answer = 2, centerpos= {x = 36, y = -130, width = 300, height = 50}},	
	[3] = {x = 37, y = -78, answer = 3, centerpos= {x = 36, y = -77, width = 300, height = 30}},	
	[4] = {x = 37, y = 12, answer = 4, centerpos= {x = 36, y = 10, width = 300, height = 110}},	
	[5] = {x = 37, y = 165 , answer = 5, centerpos= {x = 36, y = 165, width = 300, height = 155}},	
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
	
	sound.play("correct")
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
	
	sound.play("wrong")
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
    local background = display.newImage("images/label/labelBackground.png")
	background.x = centerX
	background.y = centerY
    background.width = screenWidth
    background.height = screenHeight
    group:insert(background)
end

local function createPuzzlePieces(group)
	piecesGroup = display.newGroup()
	piecesGroup.pieces = {}
	for indexPiece = 1, NUMBER_PIECES do
		local piece = display.newImage("images/label/btn-0"..indexPiece..".png")
		piece.id = indexPiece
		piecesGroup.pieces[indexPiece] = piece
		piecesGroup:insert(piece)
	end
	group:insert(piecesGroup)
end

local function gotoNextScreen()
	
	okButton:setEnabled(false)
	shipGroup.isVisible = true
	
	timer.performWithDelay(1500, function()
		sound.play("fly")
	end)
	
	transition.to(bgShine, {alpha = 0, time = 500})
	transition.to(piecesGroup, {alpha = 0, time = 500})
	transition.to(panelText, {alpha = 0, time = 500})
	transition.to(answerPanelGroup, {delay = 600, transition = easing.inBack, x = display.viewableContentWidth + answerPanelGroup.width, time=1000})
	transition.to(questionPanelGroup, {delay = 600, transition = easing.inBack, y = display.screenOriginY - questionPanelGroup.height, time=1000})
	transition.to(answerRect, {alpha = 0, transition = easing.inQuad, time = 1000})
	transition.to(okButton, {delay = 600, transition = easing.inBack, y = display.viewableContentHeight + okButton.width, time = 1000})
	transition.to(shipGroup, {delay = 1300, transition = easing.inQuad, x = display.viewableContentWidth + 500, time = 1500, onComplete = function()
	--	transition.to(shipGroup, {delay = 1500, transition = easing.inQuad, x = display.contentCenterX, time = 1500, onComplete = function()
		--director.gotoScene("scenes.game.questionquiz", {effect = "fade", time = 400})
		director.showOverlay("scenes.overlays.tips", {params = {nextScene = "scenes.game.shooter", worldIndex = worldIndex, levelIndex = levelIndex}})
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
	titleText.fontSize = 28
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
	questionPanel.alpha = 0
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
	
	local params = event.params or {}
	worldIndex = params.worldIndex
	levelIndex = params.levelIndex

    if ( phase == "will" ) then
		initScreenElements(sceneGroup)
		Runtime:addEventListener("enterFrame", updateGameloop)
		
	elseif ( phase == "did" ) then
		transition.to(answerPanelGroup, {delay = 300, transition = easing.outBounce, x = display.contentCenterX * 1.50, time=1000})
		transition.to(questionPanelGroup, {delay = 300, transition = easing.outBounce, y = display.contentCenterY * 0.40, time=1000})
		transition.to(playerCharacter.group, {x = display.contentCenterX * 0.50, time = 1500, onComplete = function()
			playerCharacter:setAnimation("IDLE")
		end})
		timer.performWithDelay(750, function()
			sound.play("ironshield")
		end)
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


