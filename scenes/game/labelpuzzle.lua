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
local piecesGroup
local panelText, titleText, productName
local okButton
local bgShine
local worldIndex, levelIndex, puzzleIndex

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
local puzzlesNumber = 4
local puzzlePanels, iconGroup
local puzzlePieces 
local productNames = {"","Leche sabor chocolate","Leche Natural"}
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
	}
}

local correctPositions = {
[1] = {
	[1] = {x = -1, y = -208},
	[2] = {x = -1, y = -156},
	[3] = {x = -1, y = -54},
	[4] = {x = -1, y = 0},
	[5] = {x = -1, y = 167},
	},
[2] = {
	[1] = {x = -1, y = -160},
	[2] = {x = -1, y = -108},
	[3] = {x = -1, y = -6},
	[4] = {x = -1, y = 48},
	[5] = {x = -1, y = 167},
	},
[3] = {
	[1] = {x = -1, y = -142},
	[2] = {x = -1, y = -91},
	[3] = {x = -1, y = 12},
	[4] = {x = -1, y = 66},
	[5] = {x = -1, y = 167},
	},
[4] = {
	[1] = {x = -1, y = -155},
	[2] = {x = -1, y = -103},
	[3] = {x = -1, y = 2},
	[4] = {x = -1, y = 53},
	[5] = {x = -1, y = 167},
	}
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
			label:scale(0.7, 0.7)
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
				
				transition.to(label, {x = X, y = Y, time=100, xScale = 1.1, yScale = 1.1})
				
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
		for indexPiece = 1, NUMBER_PIECES do
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

local function gotoNextScreen()
	
	okButton:setEnabled(false)
	
	transition.to(bgShine, {alpha = 0, time = 500})
	transition.to(puzzlePieces[puzzleIndex], {alpha = 0, time = 500})
	transition.to(panelText, {alpha = 0, time = 500})
	transition.to(puzzlePanels[puzzleIndex], {delay = 600, transition = easing.inBack, x = screenLeft - puzzlePanels[puzzleIndex].width, time=1000})
	transition.to(puzzleContainer, {delay = 600, transition = easing.inBack, x = display.screenOriginX - puzzleContainer.width, time=1000})
	transition.to(titleText, {delay = 600, transition = easing.inBack, y = screenTop - 100, time=1000})
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
	
--	titleText.text = "Ordena la etiqueta \n nutricional"
--	titleText.size = 37
--	titleText.width = 300
--	titleText.height = 200
--	titleText.x = screenRight - 350
--	titleText.y = screenTop - 200

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
	
	
	panelText.isVisible = false
	panelText.alpha = 0
	panelText.x = centerX + 300
	panelText.y = centerY  
	
	okButton.isVisible = false
	okButton.alpha = 0
	okButton:setEnabled(false)
	okButton.x = screenRight - 150
	okButton.y = screenBottom - 100
	
	for indexPiece = 1, #puzzlePieces[puzzleIndex].pieces do
		local currentPiece = puzzlePieces[puzzleIndex].pieces[indexPiece]
		currentPiece.x = labelpositions[puzzleIndex][indexPiece].x
		currentPiece.y = labelpositions[puzzleIndex][indexPiece].y
		currentPiece.xScale = 1
		currentPiece.yScale = 1
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
		icon.x = centerX + 50
		icon.y = screenTop + 100
		icon.xScale = 0.5
		icon.yScale = 0.5
		icon.alpha = 0
		iconGroup:insert(icon)
	end
	local puzzlePanel
	for i = 1, puzzlesNumber  do
		puzzlePanel = display.newImage("images/label/panels/" .. i .. ".png")
		puzzlePanel.alpha = 0
		puzzlePanels:insert(puzzlePanel)
	end
	
	sceneGroup:insert(iconGroup)
	sceneGroup:insert(puzzlePanels)
	
	bgShine = display.newImage("images/backgrounds/shine.png")
	sceneGroup:insert(bgShine)
	
	puzzleContainer = display.newImage("images/label/panel_01.png")
	puzzleContainer.alpha = 0
	sceneGroup:insert(puzzleContainer)
	
	titleText =  display.newText("Arma la etiqueta nutricional", 0, 0, settings.fontName, 28)
	sceneGroup:insert(titleText)
	
	productName =  display.newText("Nombre del producto", centerX + 150, screenBottom - 80, settings.fontName, 36)
	sceneGroup:insert(productName)
	
	local textData = {
		text = "Una etiqueta nutricional es aquella información que nos indica el valor energético y contenido del alimento en cuanto a proteínas, hidratos de carbono, grasas, fibra alimentaria, sodio, vitaminas y minerales. Debe expresarse por 100 gramos o 100 miligramos.",
		width = 400,
		font = settings.fontName,   
		fontSize = 28,
		align = "center"
	}
	
	panelText = display.newText(textData)
	sceneGroup:insert(panelText)
	
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
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
	
	local params = event.params or {}
	worldIndex = params.worldIndex
	levelIndex = params.levelIndex
	
    if ( phase == "will" ) then
		puzzleIndex = 4
		secondsTimer = 0
		isCounting = true
		timer.performWithDelay(1000,startTimer)
		initScreenElements()
		Runtime:addEventListener("enterFrame", updateGameLoop)
		puzzlePanels[puzzleIndex].alpha = 1
		if puzzleIndex > 1 then
			transition.to(iconGroup[puzzleIndex - 1],{alpha = 1, delay = 300, time = 300})
		end
		productName.text = productNames[puzzleIndex]
		transition.from(productName,{ alpha = 0, delay = 400, time = 500, transition = easing.outBounce})
	elseif ( phase == "did" ) then
		
		transition.to(puzzlePanels[puzzleIndex], {delay = 300, transition = easing.outBounce, x = screenWidth * 0.25, time=1000})
		transition.to(puzzleContainer, {delay = 300, transition = easing.outBounce, x = screenRight - 350, time=1000, onComplete = function()
			puzzlePieces[puzzleIndex].isVisible = true;
			puzzlePieces[puzzleIndex].x = puzzleContainer.x
			puzzlePieces[puzzleIndex].y = puzzleContainer.y
			transition.to(puzzlePieces[puzzleIndex], {time = 500, alpha = 1})
		end})
		transition.to(titleText, {delay = 300, transition = easing.outBounce, y = screenTop + 160, time=1000})
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


