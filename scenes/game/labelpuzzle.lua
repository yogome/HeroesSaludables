--------------------------------Label Minigame
local director = require( "libs.helpers.director" )
local settings = require( "settings" )
local widget = require("widget")
local buttonList = require("data.buttonlist")
local sound = require("libs.helpers.sound")

local scene = director.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "director.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local puzzleContainer, largePanelGroup, smallPanel, secondsTimer, isCounting
local piecesGroup, pieceBackScale
local panelText, titleText, productName
local okButton
local bgShine
local worldIndex, levelIndex, puzzleIndex, pieceEndScl, pieceScale

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
local puzzlePanels, iconGroup
local puzzlePieces 
local productNames = {"","Leche sabor chocolate","Leche Natural","Yoghurt","Jugo Natural","Frituras de Queso","Jugo de Manzana","Pastelito de chocolate","Cereal azucarado","Galletas con chispas","Refresco de Cola","Pastelito de chocolate","Frituras de queso"}
local labelpositions = {
 [1] = {
	[1] = {x = -220, y = -240},
	[2] = {x = 120, y = -30},
	[3] = {x = -220, y = -100},
	[4] = {x = 120, y = -190},
	[5] = {x = -220, y = 80},
	},
[2] = {
	[1] = {x = -220, y = -240},
	[2] = {x = 120, y = -30},
	[3] = {x = -220, y = -100},
	[4] = {x = 120, y = -190},
	[5] = {x = -220, y = 80},
	},
[3] = {
	[1] = {x = -220, y = -240},
	[2] = {x = 120, y = -30},
	[3] = {x = -220, y = -100},
	[4] = {x = 120, y = -190},
	[5] = {x = -220, y = 80},
	},
[4] = {
	[1] = {x = -220, y = -240},
	[2] = {x = 120, y = -30},
	[3] = {x = -220, y = -100},
	[4] = {x = 120, y = -190},
	[5] = {x = -220, y = 80},
	},
[5] = {
	[1] = {x = -220, y = -240},
	[2] = {x = 120, y = -30},
	[3] = {x = -220, y = -100},
	[4] = {x = 120, y = -190},
	[5] = {x = -220, y = 80},
	},
[6] = {
	[1] = {x = -220, y = -241},
	[2] = {x = 120, y = -33},
	[3] = {x = -220, y = -103},
	[4] = {x = 120, y = -193},
	[5] = {x = -220, y = 80},
	},
[7] = {
	[1] = {x = -220, y = -240},
	[2] = {x = 120, y = -30},
	[3] = {x = -220, y = -100},
	[4] = {x = 120, y = -190},
	[5] = {x = -220, y = 80},
	},
[8] = {
	[1] = {x = -220, y = -240},
	[2] = {x = 120, y = -30},
	[3] = {x = -220, y = -100},
	[4] = {x = 120, y = -190},
	[5] = {x = -220, y = 80},
	},
[9] = {
	[1] = {x = -220, y = -240},
	[2] = {x = 120, y = -30},
	[3] = {x = -220, y = -100},
	[4] = {x = 120, y = -190},
	[5] = {x = -220, y = 80},
	},
[10] = {
	[1] = {x = -220, y = -240},
	[2] = {x = 120, y = -30},
	[3] = {x = -220, y = -100},
	[4] = {x = 120, y = -190},
	[5] = {x = -220, y = 80},
	},
[11] = {
	[1] = {x = -220, y = -240},
	[2] = {x = 120, y = -30},
	[3] = {x = -220, y = -100},
	[4] = {x = 120, y = -190},
	[5] = {x = -220, y = 80},
	},
[12] = {
	[1] = {x = -600, y = 100},
	[2] = {x = -500, y = 100},
	[3] = {x = -400, y = 100},
	[4] = {x = -300, y = 100},
	[5] = {x = -200, y = 100},
	[6] = {x = -100, y = 100},
	},
[13] = {
	[1] = {x = -600, y = 100},
	[2] = {x = -500, y = 100},
	[3] = {x = -400, y = 100},
	[4] = {x = -300, y = 100},
	[5] = {x = -200, y = 100},
	[6] = {x = -100, y = 100},
	},
}

local correctPositions = {
[1] = {
	[1] = {x = 0.1, y = -208},
	[2] = {x = 0.1, y = -156},
	[3] = {x = 0.1, y = -54},
	[4] = {x = 0.1, y = 0},
	[5] = {x = 0.1, y = 167},
	},
[2] = {
	[1] = {x = 0.1, y = -160},
	[2] = {x = 0.1, y = -108},
	[3] = {x = 0.1, y = -6},
	[4] = {x = 0.1, y = 48},
	[5] = {x = 0.1, y = 167},
	},
[3] = {
	[1] = {x = 0.1, y = -142},
	[2] = {x = 0.1, y = -91},
	[3] = {x = 0.1, y = 12},
	[4] = {x = 0.1, y = 66},
	[5] = {x = 0.1, y = 167},
	},
[4] = {
	[1] = {x = 0.1, y = -155},
	[2] = {x = 0.1, y = -103},
	[3] = {x = 0.1, y = 2},
	[4] = {x = 0.1, y = 53},
	[5] = {x = 0.1, y = 167},
	},
[5] = {
	[1] = {x = 0.1, y = -155},
	[2] = {x = 0.1, y = -103},
	[3] = {x = 0.1, y = 2},
	[4] = {x = 0.1, y = 53},
	[5] = {x = 0.1, y = 167},
	},
[6] = {
	[1] = {x = 0.1, y = -156},
	[2] = {x = 0.1, y = -106},
	[3] = {x = 0.1, y = -4},
	[4] = {x = 0.1, y = 47},
	[5] = {x = 0.1, y = 167},
	},
[7] = {
	[1] = {x = 0.1, y = -155},
	[2] = {x = 0.1, y = -103},
	[3] = {x = 0.1, y = 2},
	[4] = {x = 0.1, y = 53},
	[5] = {x = 0.1, y = 167},
	},
[8] = {
	[1] = {x = 0.1, y = -158},
	[2] = {x = 0.1, y = -106},
	[3] = {x = 0.1, y = -1},
	[4] = {x = 0.1, y = 50},
	[5] = {x = 0.1, y = 167},
	},
[9] = {
	[1] = {x = 0.1, y = -149},
	[2] = {x = 0.1, y = -97},
	[3] = {x = 0.1, y = 8},
	[4] = {x = 0.1, y = 59},
	[5] = {x = 0.1, y = 167},
	},
[10] = {
	[1] = {x = 0.1, y = -158},
	[2] = {x = 0.1, y = -105},
	[3] = {x = 0.1, y = 0},
	[4] = {x = 0.1, y = 51},
	[5] = {x = 0.1, y = 167},
	},
[11] = {
	[1] = {x = 0.1, y = -148.5},
	[2] = {x = 0.1, y = -95.5},
	[3] = {x = 0.1, y = 9.5},
	[4] = {x = 0.1, y = 60.5},
	[5] = {x = 0.1, y = 167},
	},
[12] = {
	[1] = {x = -265, y = -23},
	[2] = {x = -160, y = -23},
	[3] = {x = -55, y = -23},
	[4] = {x = 270, y = -23},
	[5] = {x = 160, y = -23},
	[6] = {x = 55, y = -23},
	},
[13] = {
	[1] = {x = -265, y = -23},
	[2] = {x = -160, y = -23},
	[3] = {x = -55, y = -23},
	[4] = {x = 270, y = -23},
	[5] = {x = 160, y = -23},
	[6] = {x = 55, y = -23},
	},
}

----------------------Cached functions
local mathSqrt = math.sqrt 
-- -------------------------------------------------------------------------------

local function updateGameLoop()
	bgShine.rotation = bgShine.rotation + 1
end

local function onCorrect()
	
	sound.play("correct")
	titleText.text = "¡Felicidades!"
	titleText.size = 48
	
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
			local labelInPanelX, labelInPanelY = puzzlePanels[puzzleIndex]:contentToLocal(labelContentX, labelContentY)
			
		    local distanceToAnswer = mathSqrt((labelInPanelX - correctPositions[puzzleIndex][label.id].x)*(labelInPanelX - correctPositions[puzzleIndex][label.id].x) + (labelInPanelY - correctPositions[puzzleIndex][label.id].y)*(labelInPanelY - correctPositions[puzzleIndex][label.id].y))
			if distanceToAnswer <= 45 then
				label.scaledUp = true
				label.isCorrect = true
				local correctX, correctY = puzzlePanels[puzzleIndex]:localToContent(correctPositions[puzzleIndex][label.id].x, correctPositions[puzzleIndex][label.id].y)
				local X, Y = puzzleContainer:contentToLocal(correctX, correctY)
				
				transition.to(label, {x = X, y = Y, time=100, xScale = pieceEndScl, yScale = pieceEndScl})
				
				local correctPieces = 0
				for indexPiece = 1, #puzzlePieces[puzzleIndex].pieces do
					if puzzlePieces[puzzleIndex].pieces[indexPiece].isCorrect then
						correctPieces = correctPieces + 1
					end
				end
				
				if correctPieces >= #puzzlePieces[puzzleIndex].pieces then
					for indexPiece = 1, #puzzlePieces[puzzleIndex].pieces do
						puzzlePieces[puzzleIndex].pieces[indexPiece]:removeEventListener("touch", onTouchPiece)
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

local function createPuzzlePieces(group)
--	piecesGroup = display.newGroup()
--	piecesGroup.pieces = {}
	for i = 1, puzzlesNumber do
		local piecesGroup = display.newGroup()
		piecesGroup.pieces = {}
		local numPieces = NUMBER_PIECES
		if i > 11 then
			numPieces = 6
		end
		for indexPiece = 1, numPieces do
			local piece = display.newImage("images/label/pieces/" .. i .. "/piece" .. indexPiece .. ".png")
			piece.id = indexPiece
			piecesGroup.pieces[indexPiece] = piece
			piecesGroup:insert(piece)
		end
		piecesGroup.alpha = 0
		puzzlePieces:insert(piecesGroup)
	end
	group:insert(puzzlePieces)
end
local function hideScreen()
	if puzzleIndex > 1 then
		iconGroup[puzzleIndex-1].alpha = 0
	end
	productName.alpha = 0
	bgShine.alpha = 0
	puzzlePieces[puzzleIndex].alpha = 0
	panelText.alpha = 0
	puzzlePanels[puzzleIndex].alpha = 0
	puzzleContainer.alpha = 0
	titleText.alpha = 0
end
local function gotoNextScreen()
	
	okButton:setEnabled(false)
	if puzzleIndex > 1 then
		transition.to(iconGroup[puzzleIndex-1],{delay = 200, alpha = 0, time = 500})
	end
	transition.to(productName,{delay = 300, alpha = 0, time = 500})
	transition.to(bgShine, {alpha = 0, time = 500})
	transition.to(puzzlePieces[puzzleIndex], {alpha = 0, time = 500})
	transition.to(panelText, {alpha = 0, time = 500})
	transition.to(puzzlePanels[puzzleIndex], {delay = 600, transition = easing.inBack, x = screenLeft - puzzlePanels[puzzleIndex].width, time=1000})
	transition.to(puzzleContainer, {delay = 600, transition = easing.inBack, x = display.screenOriginX - puzzleContainer.width, time=1000})
	transition.to(titleText, {delay = 600, transition = easing.inBack, y = screenTop - screenTop, time=1000})
	transition.to(iconGroup[puzzleIndex],{ alpha = 0, time = 500, delay = 100})
	transition.to(okButton, {delay = 600, transition = easing.inBack, y = display.viewableContentHeight + okButton.width, time = 1000, onComplete = function()
		--director.gotoScene("scenes.game.labelquiz")
		director.showOverlay("scenes.overlays.tips", {params = {nextScene = "scenes.game.shooter", worldIndex = worldIndex, levelIndex = levelIndex}})
	end})

end

local function initScreenElements()
	
	puzzlePanels[puzzleIndex].x = screenLeft - 300
	puzzlePanels[puzzleIndex].y = centerY 
	puzzlePanels[puzzleIndex].xScale = 1.1
	puzzlePanels[puzzleIndex].yScale = 1.1
	
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
	local screenRatio = screenWidth / screenHeight
	if screenRatio <= 1.6  and puzzleIndex <= 11 then
		pieceScale = 0.8
		pieceBackScale = 0.73
	end
--	print ( " screenRatio is " .. screenRatio .. " ")
	for indexPiece = 1, #puzzlePieces[puzzleIndex].pieces do
		local xPs = labelpositions[puzzleIndex][indexPiece].x
		local yPs = labelpositions[puzzleIndex][indexPiece].y
		if pieceBackScale == 0.73 then
			if xPs == -220 then
				xPs = xPs + 95
			else
				xPs = xPs + 25
			end
		end
		local currentPiece = puzzlePieces[puzzleIndex].pieces[indexPiece]
		currentPiece.x = xPs
		currentPiece.y = yPs
		currentPiece.xScale = pieceScale
		currentPiece.yScale = pieceScale
		currentPiece.isCorrect = false
		currentPiece.scaledUp = false
		currentPiece:addEventListener("touch", onTouchPiece)
	end
	
	puzzlePieces[puzzleIndex].isVisible = false
	puzzlePieces[puzzleIndex].alpha = 0
	
end

---------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view
	createBackground(sceneGroup)
	puzzlePanels = display.newGroup()
	iconGroup = display.newGroup()
	puzzlePieces = display.newGroup()
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
	
	sceneGroup:insert(iconGroup)
	sceneGroup:insert(puzzlePanels)
	
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
	sceneGroup:insert(productName)
	
	local buttonData = buttonList.play
	buttonData.onRelease = gotoNextScreen
	
	okButton = widget.newButton(buttonData)
	
	sceneGroup:insert(okButton)
	
	createPuzzlePieces(sceneGroup)
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
	puzzlePanels[puzzleIndex].alpha = 1
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
		iconGroup[puzzleIndex-1].x = centerX
		iconGroup[puzzleIndex-1].y = screenTop + 100
		iconGroup[puzzleIndex-1].xScale = 0.45
		iconGroup[puzzleIndex-1].yScale = 0.45
	end
	pieceEndScl = 1.1
	bgShine.x = centerX - 350
	local movePos = screenWidth * 0.25
	productName.x = centerX + 150 
	productName.y = screenBottom - 80
	productName.size = 36
	if puzzleIndex > 11 then
		titleText.x = centerX
		titleText.y = centerY - 150
		bgShine.x = centerX - 100
		pieceEndScl = 1
		movePos = screenLeft + 460
		productName.size = 45
		productName.x = centerX 
		productName.y = screenTop + 75
		iconGroup[puzzleIndex-1].x = screenRight -  150
		iconGroup[puzzleIndex-1].y = centerY
		iconGroup[puzzleIndex-1].xScale = 0.7
		iconGroup[puzzleIndex-1].yScale = 0.7
	end
	transition.to(puzzlePanels[puzzleIndex], {delay = 300, transition = easing.outBounce, x = movePos, time=1000})
end
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
	
	local params = event.params or {}
	worldIndex = params.worldIndex
	levelIndex = params.levelIndex
	
    if ( phase == "will" ) then
		puzzleIndex = math.random(2,puzzlesNumber)
--		puzzleIndex = 1
		print( "Toca el rompecabezas número " .. puzzleIndex .. " ")
		secondsTimer = 0
		isCounting = true
		timer.performWithDelay(1000,startTimer)
		initScreenElements()
		Runtime:addEventListener("enterFrame", updateGameLoop)
	elseif ( phase == "did" ) then
		createPanelText(sceneGroup)
		setScreen()
		transition.to(puzzleContainer, {delay = 300, transition = easing.outBounce, x = screenRight - 350, time=1000, onComplete = function()
			puzzlePieces[puzzleIndex].isVisible = true;
			puzzlePieces[puzzleIndex].x = puzzleContainer.x
			puzzlePieces[puzzleIndex].y = puzzleContainer.y
			transition.to(puzzlePieces[puzzleIndex], {time = 500, alpha = 1})
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


