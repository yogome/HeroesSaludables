--------------------------------Label Minigame
local composer = require( "composer" )
local settings = require( "settings" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local puzzlePanel, puzzleContainer, smallPanelGroup, largePanelGroup
local piecesGroup

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

local function onTouchPiece(event)
	local label = event.target
	local phase = event.phase
	local parent = label.parent
	if "began" == phase then
		
		parent:insert( label )
		display.getCurrentStage():setFocus( label )

		label.isFocus = true
		
		if label.scaledUp then
			label:scale(0.7, 0.7)
			label.scaledUp = false
		end
		
		label.x0 = event.x - label.x
		label.y0 = event.y - label.y
		
		-------Coordinate Dumper
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
				local correctX, correctY = puzzlePanel:localToContent(correctPositions[label.id].x, correctPositions[label.id].y)
				local X, Y = puzzleContainer:contentToLocal(correctX, correctY)
				
				transition.to(label, {x = X, y = Y, time=100, xScale = 1.3, yScale = 1.3})

			end

			print(distanceToAnswer)
		end
	end		

	-- Important to return true. This tells the system that the event
	-- should not be propagated to listeners of any objects underneath.
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
	for indexPiece = 1, NUMBER_PIECES do
		local piece = display.newImage("images/label/piece"..indexPiece..".png")
		piece.id = indexPiece
		piece.x = labelpositions[indexPiece].x
		piece.y = labelpositions[indexPiece].y
		piece:addEventListener("touch", onTouchPiece)
		piecesGroup:insert(piece)
	end
	piecesGroup.isVisible = false
	piecesGroup.alpha = 0
	group:insert(piecesGroup)
end

---------------------------------------------------------------------------------
function scene:create( event )

    local sceneGroup = self.view
	
	createBackground(sceneGroup)
	
	puzzlePanel = display.newImage("images/label/panel_02.png")
	puzzlePanel.y = display.contentCenterY * 1.15
	puzzlePanel.x = display.viewableContentWidth + puzzlePanel.width
	sceneGroup:insert(puzzlePanel)
	
	puzzleContainer = display.newImage("images/label/panel_01.png")
	puzzleContainer.y = display.contentCenterY * 1.35
	puzzleContainer.x = display.screenOriginX - puzzleContainer.width
	sceneGroup:insert(puzzleContainer)
	
	smallPanelGroup = display.newGroup()
	
	local smallPanel = display.newImage("images/label/smallpanel.png")
	smallPanelGroup.x = display.contentCenterX * 0.50
	smallPanelGroup.y = display.screenOriginY - smallPanel.height
	smallPanelGroup:insert(smallPanel)
	
	local panelText =  display.newText("Arma la etiqueta nutricional", smallPanel.x, smallPanel.y, settings.fontName, 28)
	smallPanelGroup:insert(panelText)
	
	sceneGroup:insert(smallPanelGroup)
	
	createPuzzlePieces(sceneGroup)
	--local background = display.newImage("images/backgrounds/label.png")
	--background.x = display.contentCenterX
	--background.y = display.contentCenterY
	--sceneGroup:insert(background)
end

function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
	elseif ( phase == "did" ) then
		transition.to(puzzlePanel, {transition = easing.outBounce, x = display.contentCenterX * 1.50, time=1000})
		transition.to(puzzleContainer, {transition = easing.outBounce, x = display.contentCenterX * 0.50, time=1000, onComplete = function()
			piecesGroup.isVisible = true;
			piecesGroup.x = puzzleContainer.x
			piecesGroup.y = puzzleContainer.y
			transition.to(piecesGroup, {time = 500, alpha = 1})
		end})
		transition.to(smallPanelGroup, {transition = easing.outBounce, y = display.contentCenterY * 0.30, time=1000})
			
		timer.performWithDelay()
    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		
	elseif ( phase == "did" ) then
		

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


