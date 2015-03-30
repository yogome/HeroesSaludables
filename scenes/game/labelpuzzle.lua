--------------------------------Label Minigame
local director = require( "libs.helpers.director" )
local settings = require( "settings" )
local widget = require("widget")
local buttonList = require("data.buttonlist")
local puzzlepositions = require("data.puzzlepositions")
local sound = require("libs.helpers.sound")
local colors = require( "libs.helpers.colors" )
local scene = director.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "director.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local puzzleContainer, largePanelGroup, smallPanel, secondsTimer, isCounting, timeRect,transitionTimer, rectGroup, screenRatio
local piecesGroup, pieceBackScale, piecesPhaseTwo, marks, piecesPhaseThree, correctPositionsToUse, labelPosToUse
local panelText, titleText, productName
local okButton, puzzlePieces, puzzleToUse
local bgShine
local worldIndex, levelIndex, puzzleIndex, pieceEndScl, pieceScale, gamePhase

-----------------Constants
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenLeft = display.screenOriginX
local screenWidth = display.viewableContentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.viewableContentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight 
local mRandom = math.random  
local SIZE_BACKGROUND = 1024
local NUMBER_PIECES = 5
local puzzlesNumber = 13
local puzzlePanels, iconGroup, panelsThird, panelsToUse
local productNames = {"","Leche sabor chocolate","Leche Natural","Yoghurt","Jugo Natural","Frituras de Queso","Jugo de Manzana","Pastelito de chocolate","Cereal azucarado","Galletas con chispas","Refresco de Cola","Pastelito de chocolate","Frituras de queso"}


----------------------Cached functions
local mathSqrt = math.sqrt 
-- -------------------------------------------------------------------------------

local function updateGameLoop()
	bgShine.rotation = bgShine.rotation + 1
end

local function onCorrect()
	
	if gamePhase == 2 then
		transition.cancel(transitionTimer)
	end
	
	sound.play("correct")
	titleText.text = "¡Felicidades!"
	titleText.size = 48
	
	marks.correct.isVisible = true
	marks.correct:play()
	okButton.isVisible = true
	panelText.isVisible = true
	
	transition.to(okButton, {alpha = 1, onComplete = function()
		okButton:setEnabled(true)
		isCounting = false
		print ( "Tardó " .. secondsTimer .. " segundos en terminar")
	end})
	
	transition.to(panelText, {alpha = 1})
	
	bgShine.isVisible = true
	transition.to(bgShine, {alpha = 0.7})
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
		
		if label.scaledUp then
			label:scale(pieceBackScale, pieceBackScale)
			label.scaledUp = false
		end
		
		label.x0 = event.x - label.x
		label.y0 = event.y - label.y
		
		-------Coordinates Dumper
		--local labelX, labelY = label:localToContent(0,0)
		--local stageX, stageY = puzzlePanel:contentToLocal(labelX, labelY)
		--print(string.format("{x = %d, y = %d},", stageX, stageY))
		
	elseif label.isFocus then
		if "moved" == phase then
			label.x = event.x - label.x0
			label.y = event.y - label.y0
	
		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			label.isFocus = false
			
			local labelContentX, labelContentY = label:localToContent(0, 0)
			local labelInPanelX, labelInPanelY = panelsToUse[puzzleIndex]:contentToLocal(labelContentX, labelContentY)
			
		    local distanceToAnswer = mathSqrt((labelInPanelX - correctPositionsToUse[puzzleIndex][label.id].x)*(labelInPanelX - correctPositionsToUse[puzzleIndex][label.id].x) + 
			(labelInPanelY - correctPositionsToUse[puzzleIndex][label.id].y)*(labelInPanelY - correctPositionsToUse[puzzleIndex][label.id].y))
			if distanceToAnswer <= 45 then
				label.scaledUp = true
				label.isCorrect = true
				local correctX, correctY = panelsToUse[puzzleIndex]:localToContent(correctPositionsToUse[puzzleIndex][label.id].x, correctPositionsToUse[puzzleIndex][label.id].y)
				local X, Y = puzzleContainer:contentToLocal(correctX, correctY)
				
				transition.to(label, {x = X, y = Y, time=100, xScale = pieceEndScl, yScale = pieceEndScl})
				
				local correctPieces = 0
				for indexPiece = 1, #puzzleToUse[puzzleIndex].pieces do
					if puzzleToUse[puzzleIndex].pieces[indexPiece].isCorrect then
						correctPieces = correctPieces + 1
					end
				end
				
				if correctPieces >= #puzzleToUse[puzzleIndex].pieces then
					for indexPiece = 1, #puzzleToUse[puzzleIndex].pieces do
						puzzleToUse[puzzleIndex].pieces[indexPiece]:removeEventListener("touch", onTouchPiece)
					end
					onCorrect()
				end
			end
		end
	end		
	return true
end

local function createBackground(group)
	
    local background = display.newImage("images/label/labelBackground.png")
	background.x = centerX
	background.y = centerY
    background.width = screenWidth
    background.height = screenHeight
    group:insert(background)
end

local function createPuzzlePieces(group,index,puzzleGrp)
	local pieceFolder = "/piece"
	if index == 3 then
		pieceFolder = "/"
		NUMBER_PIECES = 3
		puzzlesNumber = 11
	end
	for i = 1, puzzlesNumber do
		local piecesGroup = display.newGroup()
		piecesGroup.pieces = {}
		local numPieces = NUMBER_PIECES
		if i > 11 then
			numPieces = 6
		end
		for indexPiece = 1, numPieces do
			local piece = display.newImage("images/label/pieces/phase" .. index .. "/" .. i  .. "" .. pieceFolder .. "" .. indexPiece .. ".png")
			piece.id = indexPiece
			piecesGroup.pieces[indexPiece] = piece
			piecesGroup:insert(piece)
		end
		piecesGroup.alpha = 0
		puzzleGrp:insert(piecesGroup)
	end
	group:insert(puzzleGrp)
end

local function hideScreen()
	if puzzleIndex > 1 then
		iconGroup[puzzleIndex-1].alpha = 0
	end
	productName.alpha = 0
	bgShine.alpha = 0
	puzzleToUse[puzzleIndex].alpha = 0
	panelText.alpha = 0
	panelsToUse[puzzleIndex].alpha = 0
	puzzleContainer.alpha = 0
	titleText.alpha = 0
	rectGroup.alpha = 0
	okButton.alpha = 0
end
local function gotoNextScreen()
	
	okButton:setEnabled(false)
	if puzzleIndex > 1 then
		transition.to(iconGroup[puzzleIndex-1],{delay = 200, alpha = 0, time = 500})
	end
	transition.to(productName,{delay = 300, alpha = 0, time = 500})
	transition.to(bgShine, {alpha = 0, time = 500})
	transition.to(puzzleToUse[puzzleIndex], {alpha = 0, time = 500})
	transition.to(panelText, {alpha = 0, time = 500})
	transition.to(rectGroup, {alpha = 0, time = 500})
	transition.to(panelsToUse[puzzleIndex], {delay = 600, transition = easing.inBack, x = screenLeft - panelsToUse[puzzleIndex].width, time=1000})
	transition.to(puzzleContainer, {delay = 600, transition = easing.inBack, x = display.screenOriginX - puzzleContainer.width, time=1000})
	transition.to(titleText, {delay = 600, transition = easing.inBack, y = screenTop - screenTop, time=1000})
	transition.to(iconGroup[puzzleIndex],{ alpha = 0, time = 500, delay = 100})
	transition.to(okButton, {delay = 600, transition = easing.inBack, y = display.viewableContentHeight + okButton.width, time = 1000, onComplete = function()
		--director.gotoScene("scenes.game.labelquiz")
		director.showOverlay("scenes.overlays.tips", {params = {nextScene = "scenes.game.shooter", worldIndex = worldIndex, levelIndex = levelIndex}})
	end})

end

local function initScreenElements()
	
	panelsToUse[puzzleIndex].x = screenLeft - 300
	panelsToUse[puzzleIndex].y = centerY 
	panelsToUse[puzzleIndex].xScale = 1.1
	panelsToUse[puzzleIndex].yScale = 1.1
	
	bgShine.isVisible = false
	bgShine.alpha = 0
	bgShine.x = centerX - 350
	bgShine.y = display.contentCenterY * 1.15
	bgShine.rotation = 0
	
	puzzleContainer.x = screenRight + 300
	puzzleContainer.y = centerY + 100
	
	okButton.isVisible = false
	okButton.alpha = 0
	okButton:setEnabled(false)
	okButton.x = screenRight - 150
	okButton.y = screenBottom - 100
	
	pieceScale = 1
	pieceBackScale = 0.91
	if puzzleIndex > 11 then
		pieceScale = 0.8
	end
	screenRatio = screenWidth / screenHeight
	if screenRatio <= 1.6  and puzzleIndex <= 11 then
		pieceScale = 0.8
		pieceBackScale = 0.73
	end
--	print ( " screenRatio is " .. screenRatio .. " ")
	if gamePhase == 3 then
		pieceBackScale = 1.7
		pieceScale = 1.4
	end
	print("puzzle index pieces" .. puzzleIndex)
	for indexPiece = 1, #puzzleToUse[puzzleIndex].pieces do
		local xPs = labelPosToUse[puzzleIndex][indexPiece].x
		local yPs = labelPosToUse[puzzleIndex][indexPiece].y
		if pieceBackScale == 0.73 then
			if xPs == -220 then
				xPs = xPs + 95
			else
				xPs = xPs + 25
			end
		end
		local currentPiece = puzzleToUse[puzzleIndex].pieces[indexPiece]
		currentPiece.x = xPs
		currentPiece.y = yPs
		currentPiece.xScale = pieceScale
		currentPiece.yScale = pieceScale
		currentPiece.isCorrect = false
		currentPiece.scaledUp = false
		currentPiece:addEventListener("touch", onTouchPiece)
	end
	
	puzzleToUse[puzzleIndex].isVisible = false
	puzzleToUse[puzzleIndex].alpha = 0
	
	marks.correct.isVisible = false
	marks.wrong.isVisible = false
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
---------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view
	createBackground(sceneGroup)
	puzzlePanels = display.newGroup()
	panelsThird = display.newGroup()
	iconGroup = display.newGroup()
	puzzlePieces = display.newGroup()
	piecesPhaseTwo = display.newGroup()
	piecesPhaseThree = display.newGroup()
	local icon
	for i = 2, puzzlesNumber do
		icon = display.newImage("images/label/icons/" .. i .. ".png")
		icon.x = centerX
		icon.y = screenTop + 100
		icon.xScale = 0.5
		icon.yScale = 0.5
		icon.alpha = 0
		iconGroup:insert(icon)
	end
	
	bgShine = display.newImage("images/backgrounds/shine.png")
	sceneGroup:insert(bgShine)
	
	local puzzlePanel
	for i = 1, puzzlesNumber  do
		puzzlePanel = display.newImage("images/label/panels/" .. i .. ".png")
		puzzlePanel.alpha = 0
		puzzlePanels:insert(puzzlePanel)
	end
	
	for i = 1, puzzlesNumber  do
		puzzlePanel = display.newImage("images/label/panelsthird/" .. i .. ".png")
		puzzlePanel.alpha = 0
		panelsThird:insert(puzzlePanel)
	end
	
	sceneGroup:insert(iconGroup)
	sceneGroup:insert(puzzlePanels)
	sceneGroup:insert(panelsThird)
	
	puzzleContainer = display.newImage("images/label/panel_01.png")
	puzzleContainer.alpha = 0
	sceneGroup:insert(puzzleContainer)
	
--	titleText =  display.newText("Arma la etiqueta nutricional", 0, 0, settings.fontName, 28)
	titleText = display.newEmbossedText({
		  text    = "Ordena la etiqueta nutrimental",  
		  x        = screenRight - 300,
		  y        = screenTop - 200,
		  fontSize = 37,
		  font = "VAGRounded",
		  align    = "center",
		  width = 350,
		  height = 200,
		})
	sceneGroup:insert(titleText)
	
	productName =  display.newText("Nombre del producto", centerX + 150, screenBottom - 80, settings.fontName, 36)
	productName.alpha = 0
	sceneGroup:insert(productName)
	
	local buttonData = buttonList.play
	buttonData.onRelease = gotoNextScreen
	
	okButton = widget.newButton(buttonData)
	
	sceneGroup:insert(okButton)
	
	rectGroup = display.newGroup()
	
	timeRect = display.newRect(screenLeft + 200, screenTop + 80, 280, 25)
	timeRect.anchorX = 0
	colors.addColorTransition(timeRect)
--	timeRect:setFillColor(0,1,0)
	rectGroup:insert(timeRect)
	
--	local recti = display.newRect(screenLeft + 320, screenTop + 80, 300, 40)
--	recti:setFillColor(0.2,0.2,0.2)
	local recti = display.newImage("images/label/timebar.png")
	recti.xScale = 0.6
	recti.yScale = 0.6
	recti.x = screenLeft + 320
	recti.y = screenTop + 80
	rectGroup:insert(recti)
	
	rectGroup.alpha = 0
	sceneGroup:insert(rectGroup)
	createPuzzlePieces(sceneGroup,1,puzzlePieces)
	createPuzzlePieces(sceneGroup,2,piecesPhaseTwo)
	createPuzzlePieces(sceneGroup,3,piecesPhaseThree)
	createMark(sceneGroup)
end
local function startTimer()
	secondsTimer = secondsTimer + 1
	if isCounting then
		timer.performWithDelay(1000,startTimer)
	end
end
local function createPanelText(grp)
	local width = 350
	local xPos = screenRight - 300
	local yPos = centerY
	local size = 28
	if puzzleIndex > 11 then
		width = 650
		xPos = centerX
		yPos = screenBottom - 140
		size = 24
	end
	local textData = {
		text = "Una etiqueta nutricional es aquella información que nos indica el valor energético y contenido del alimento en cuanto a proteínas, hidratos de carbono, grasas, fibra alimentaria, sodio, vitaminas y minerales. Debe expresarse por 100 gramos o 100 miligramos.",
		width = width,
		font = settings.fontName,   
		fontSize = size,
		align = "center"
	}
	
	panelText = display.newText(textData)
	panelText.alpha = 0
	panelText.x = xPos
	panelText.y = yPos
	grp:insert(panelText)
end

local function setScreen()
	panelsToUse[puzzleIndex].alpha = 1
	if puzzleIndex > 1 then
		iconGroup[puzzleIndex-1].alpha = 1
		transition.from(iconGroup[puzzleIndex - 1],{alpha = 0, delay = 600, time = 300})
	end
	productName.alpha = 0
	productName.text = productNames[puzzleIndex]
	transition.to(productName,{ alpha = 1, delay = 400, time = 500})
	titleText.x = screenRight - 300
	titleText.y = screenTop + 160
	titleText.alpha = 0
	if puzzleIndex > 1 then
		iconGroup[puzzleIndex-1].x = screenRight - 300
		iconGroup[puzzleIndex-1].y = screenBottom - 100
		iconGroup[puzzleIndex-1].xScale = 0.45
		iconGroup[puzzleIndex-1].yScale = 0.45
	end
	pieceEndScl = 1.1
	bgShine.x = centerX - 350
	local movePos = screenWidth * 0.25
	productName.x = centerX  
	productName.y = screenBottom - 80
	productName.size = 36
	rectGroup.y = screenTop + 20
	rectGroup.x = screenLeft 
	if puzzleIndex > 11 then
		rectGroup.y = screenTop + 120
		rectGroup.x = screenLeft - 30
		titleText.x = centerX
		titleText.y = centerY - 150
		if screenRatio < 1.6 then
			titleText.y = titleText.y - 30
			rectGroup.y = rectGroup.y + 50
		end
		bgShine.x = centerX - 100
		pieceEndScl = 1
		movePos = screenLeft + 460
		productName.size = 45
		productName.x = centerX 
		productName.y = screenTop + 75
		iconGroup[puzzleIndex-1].x = centerX + 300
		iconGroup[puzzleIndex-1].y = screenTop + 120
		iconGroup[puzzleIndex-1].xScale = 0.7
		iconGroup[puzzleIndex-1].yScale = 0.7
	end
	if gamePhase == 3 then
		pieceEndScl = 0.745
		if puzzleIndex == 8 then
			pieceEndScl = 1.14
		end
	end
	transition.to(panelsToUse[puzzleIndex], {delay = 300, transition = easing.outBounce, x = movePos, time=1000})
end
local function setTimer(timer)
	timeRect.xScale = 1
	timeRect:setFillColor(0,1,0)
	timer = timer * 1000
	okButton.isVisible = true
	transitionTimer = transition.to(timeRect,{ r = 1, g = 0, b =0 ,xScale = 0, time = timer, onComplete = function()
		transition.to(okButton, {alpha = 1, onComplete = function()
			okButton:setEnabled(true)
			isCounting = false
			marks.wrong.isVisible = true
			marks.wrong:play()
			titleText.text = "No lo haz conseguido ..."
			for indexPiece = 1, #puzzleToUse[puzzleIndex].pieces do
				puzzleToUse[puzzleIndex].pieces[indexPiece]:removeEventListener("touch", onTouchPiece)
			end
	end})
	end})
end
local function checkPhase()
	if gamePhase == 2 then
		gamePhase = mRandom(2,3)
	end
end
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
	
	local params = event.params or {}
	worldIndex = params.worldIndex
	levelIndex = params.levelIndex
	gamePhase = params.gamePhase or 3
	
    if ( phase == "will" ) then
--		checkPhase()
		puzzlesNumber = 13
		panelsToUse = puzzlePanels
		labelPosToUse = puzzlepositions.labelpositions
		correctPositionsToUse = puzzlepositions.correctPositions
		if gamePhase == 1 then
			puzzleToUse = puzzlePieces
		elseif gamePhase == 2 then
			puzzleToUse = piecesPhaseTwo
			titleText.text = "Ordena la etiqueta con límite de tiempo"
		elseif gamePhase == 3 then
			labelPosToUse = puzzlepositions.Thirdlabelpositions
			correctPositionsToUse = puzzlepositions.correctPositionsThird
			puzzleToUse = piecesPhaseThree
			panelsToUse = panelsThird
			puzzlesNumber = 11
			titleText.text = "Completa los espacios de la etiqueta"
		end
		puzzleIndex = mRandom(2,puzzlesNumber)
--		puzzleIndex = 11
		print( "Toca el rompecabezas número " .. puzzleIndex .. " ")
		secondsTimer = 0
		isCounting = true
		timer.performWithDelay(1000,startTimer)
		initScreenElements()
		Runtime:addEventListener("enterFrame", updateGameLoop)
	elseif ( phase == "did" ) then
		if gamePhase == 2 then
			setTimer(15)
			transition.to(rectGroup, { alpha = 1, time = 600, delay = 300})
		end
		createPanelText(sceneGroup)
		setScreen()
		transition.to(puzzleContainer, {delay = 300, transition = easing.outBounce, x = screenRight - 350, time=1000, onComplete = function()
			puzzleToUse[puzzleIndex].isVisible = true;
			puzzleToUse[puzzleIndex].x = puzzleContainer.x
			puzzleToUse[puzzleIndex].y = puzzleContainer.y
			transition.to(puzzleToUse[puzzleIndex], {time = 500, alpha = 1})
		end})
		timer.performWithDelay(300, function()
			titleText.alpha = 1
		end)
		transition.from(titleText, {delay = 300, transition = easing.outBounce, y = screenTop - screenTop, time=1000})
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
		hideScreen()
		titleText.text = "Ordena la etiqueta nutrimental"
		titleText.size = 37
		panelText:removeSelf()
		transition.cancel(transitionTimer)
		Runtime:removeEventListener("enterFrame", updateGameLoop)

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


