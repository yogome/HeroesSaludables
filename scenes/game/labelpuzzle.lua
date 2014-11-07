--------------------------------Label Minigame
local composer = require( "composer" )
local settings = require( "settings" )
local widget = require("widget")
local buttonList = require("data.buttonlist")
local sound = require("libs.helpers.sound")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local puzzlePanel, puzzleContainer, smallPanelGroup, largePanelGroup, smallPanel
local piecesGroup
local panelText, titleText
local okButton
local bgShine
local worldIndex, levelIndex
local SIZE_BACKGROUND = 1024
local NUMBER_PIECES = 9
local mathSqrt = math.sqrt
local labelpositions = {
	[1] = {x = -103, y = -135},
	[2] = {x = 55, y = -33},
	[3] = {x = -95, y = 11},
	[4] = {x = -102, y = 138},
	[5] = {x = 115, y = -135},
	[6] = {x = 138, y = 138},
	[7] = {x = 26, y = 135},
	[8] = {x = 47, y = 54},
	[9] = {x = -95, y = -76},
}

local correctPositions = {
	[1] = {x = 14, y = -173},
	[2] = {x = 14, y = -104},
	[3] = {x = 14, y = -66},
	[4] = {x = -34, y = 5},
	[5] = {x = -34, y = 104},
	[6] = {x = 125, y = 5},
	[7] = {x = 125, y = 104},
	[8] = {x = 14, y = 170},
	[9] = {x = 14, y = 206},
}
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
			local labelInPanelX, labelInPanelY = puzzlePanel:contentToLocal(labelContentX, labelContentY)
			
		    local distanceToAnswer = mathSqrt((labelInPanelX - correctPositions[label.id].x)*(labelInPanelX - correctPositions[label.id].x) + (labelInPanelY - correctPositions[label.id].y)*(labelInPanelY - correctPositions[label.id].y))
			if distanceToAnswer <= 45 then
				label.scaledUp = true
				label.isCorrect = true
				local correctX, correctY = puzzlePanel:localToContent(correctPositions[label.id].x, correctPositions[label.id].y)
				local X, Y = puzzleContainer:contentToLocal(correctX, correctY)
				
				transition.to(label, {x = X, y = Y, time=100, xScale = 1.3, yScale = 1.3})
				
				local correctPieces = 0
				for indexPiece = 1, #piecesGroup.pieces do
					if piecesGroup.pieces[indexPiece].isCorrect then
						correctPieces = correctPieces + 1
					end
				end
				
				if correctPieces >= #piecesGroup.pieces then
					for indexPiece = 1, #piecesGroup.pieces do
						piecesGroup.pieces[indexPiece]:removeEventListener("touch", onTouchPiece)
					end
					onCorrect()
				end
			end
		end
	end		
	return true
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
	
	transition.to(bgShine, {alpha = 0, time = 500})
	transition.to(piecesGroup, {alpha = 0, time = 500})
	transition.to(panelText, {alpha = 0, time = 500})
	transition.to(puzzlePanel, {delay = 600, transition = easing.inBack, x = display.viewableContentWidth + puzzlePanel.width, time=1000})
	transition.to(puzzleContainer, {delay = 600, transition = easing.inBack, x = display.screenOriginX - puzzleContainer.width, time=1000})
	transition.to(smallPanelGroup, {delay = 600, transition = easing.inBack, y = display.screenOriginY - smallPanelGroup.height, time=1000})
	transition.to(okButton, {delay = 600, transition = easing.inBack, y = display.viewableContentHeight + okButton.width, time = 1000, onComplete = function()
		--composer.gotoScene("scenes.game.labelquiz")
		composer.showOverlay("scenes.overlays.tips", {params = {nextScene = "scenes.game.shooter", worldIndex = worldIndex, levelIndex = levelIndex}})
	end})

end

local function initScreenElements()
	
	puzzlePanel.x = display.viewableContentWidth + puzzlePanel.width
	puzzlePanel.y = display.contentCenterY * 1.15
	
	bgShine.isVisible = false
	bgShine.alpha = 0
	bgShine.x = display.contentCenterX * 1.50
	bgShine.y = display.contentCenterY * 1.15
	bgShine.rotation = 0
	
	puzzleContainer.x = display.screenOriginX - puzzleContainer.width
	puzzleContainer.y = display.contentCenterY * 1.35
	
	smallPanelGroup.x = display.contentCenterX * 0.50
	smallPanelGroup.y = display.screenOriginY - smallPanel.height
	
	titleText.text = "Arma la etiqueta nutricional"
	titleText.size = 28
	titleText.x = smallPanel.x
	titleText.y = smallPanel.y
	
	panelText.isVisible = false
	panelText.alpha = 0
	panelText.x = display.contentCenterX * 0.48
	panelText.y = display.contentCenterY * 1.35
	
	okButton.isVisible = false
	okButton.alpha = 0
	okButton:setEnabled(false)
	okButton.x = display.contentCenterX
	okButton.y = display.contentCenterY * 1.80
	
	for indexPiece = 1, #piecesGroup.pieces do
		local currentPiece = piecesGroup.pieces[indexPiece]
		currentPiece.x = labelpositions[indexPiece].x
		currentPiece.y = labelpositions[indexPiece].y
		currentPiece.xScale = 1
		currentPiece.yScale = 1
		currentPiece.isCorrect = false
		currentPiece.scaledUp = false
		currentPiece:addEventListener("touch", onTouchPiece)
	end
	
	piecesGroup.isVisible = false
	piecesGroup.alpha = 0
	
end
---------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view
	
	createBackground(sceneGroup)
	
	puzzlePanel = display.newImage("images/label/panel_02.png")
	sceneGroup:insert(puzzlePanel)
	
	bgShine = display.newImage("images/backgrounds/shine.png")
	sceneGroup:insert(bgShine)
	
	puzzleContainer = display.newImage("images/label/panel_01.png")
	sceneGroup:insert(puzzleContainer)
	
	smallPanelGroup = display.newGroup()
	smallPanel = display.newImage("images/label/smallpanel.png")
	smallPanelGroup:insert(smallPanel)
	
	titleText =  display.newText("Arma la etiqueta nutricional", 0, 0, settings.fontName, 28)
	smallPanelGroup:insert(titleText)
	sceneGroup:insert(smallPanelGroup)
	
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

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
	
	local params = event.params or {}
	worldIndex = params.worldIndex
	levelIndex = params.levelIndex

    if ( phase == "will" ) then
		
		initScreenElements()
		Runtime:addEventListener("enterFrame", updateGameLoop)
		
	elseif ( phase == "did" ) then
		
		transition.to(puzzlePanel, {delay = 300, transition = easing.outBounce, x = display.contentCenterX * 1.50, time=1000})
		transition.to(puzzleContainer, {delay = 300, transition = easing.outBounce, x = display.contentCenterX * 0.50, time=1000, onComplete = function()
			piecesGroup.isVisible = true;
			piecesGroup.x = puzzleContainer.x
			piecesGroup.y = puzzleContainer.y
			transition.to(piecesGroup, {time = 500, alpha = 1})
		end})
		transition.to(smallPanelGroup, {delay = 300, transition = easing.outBounce, y = display.contentCenterY * 0.30, time=1000})
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


