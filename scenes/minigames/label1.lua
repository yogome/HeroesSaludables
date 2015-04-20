local director = require( "libs.helpers.director" )
local buttonList = require("data.buttonlist")
local widget = require("widget")
local labelData = require("data.labeldata")
local settings = require("settings")

----------------------------Variables
local scene = director.newScene()
local assetPath = "images/minigames/label1/"
local tipGroup, tip
local previousTip
local nextScene
local worldIndex, levelIndex
local okButton
local startButton
local bandSprite
local iconPortion, portionDescription, portionDescriptionBG
local currentPortion
local animationTimer
local middleGroup
local labelDescription
local descriptionText
local nextSceneButton

----------------Groups to remove
-- 
local labelBG
local bandPieces

----------------------------Constants
local NUMBER_TIPS = 45
local PHASE = 1
local SCALE_PIECE = 1.35 * (display.contentHeight / 810)
-- -------------------------------------------------------------------------------
local function updateGame(event)
	
	for indexPiece = 1, #bandPieces do
		
		local piece = bandPieces[indexPiece]
		if piece.x <= display.contentWidth * 0.4 then
			piece.isTouchable = false
		else
			piece.isTouchable = true
		end
	end
	
end

local function labelComplete()
	
	nextSceneButton:setEnabled(true)
	transition.to(nextSceneButton, {alpha = 1, time = 300})
	transition.to(descriptionText, {alpha = 1, time = 300})
	
end

local function startMinigame(event)
	
	event.target:setEnabled(false)
	event.target.isVisible = false
	bandSprite:play()
	
	transition.cancel(iconPortion)
	if animationTimer then
		timer.cancel(animationTimer)
	end
	
	transition.to(iconPortion, {xScale = 0.3, yScale = 0.3, x = display.contentWidth * 0.95, y = display.contentWidth * 0.05, transition = easing.outQuad})
	transition.to(portionDescription, {alpha = 0, xScale = 0.8, yScale = 0.8, x = display.contentWidth * 0.75, y = display.contentWidth * 0.035, transition = easing.outQuad})
	transition.to(portionDescriptionBG, {alpha = 1, xScale = 0.8, yScale = 0.8, x = display.contentWidth * 0.75, y = display.contentWidth * 0.035, transition = easing.outQuad})
	
	local delay = 0
	for pieceIndex = 1, #bandPieces do
		local currentPiece = bandPieces[pieceIndex]
		transition.to(currentPiece, {delay = delay, time = 15000, x = display.contentWidth * -1, iterations = -1})
		delay = delay + 3000
	end
	
end

local function initialize()
	startButton:setEnabled(true)
	startButton.isVisible = true
	
	local randomPortion = math.random(1, #labelData)
	currentPortion = labelData[randomPortion]
	
	descriptionText.text = currentPortion.description
	descriptionText.alpha = 0
	nextSceneButton.alpha = 0
	
	bandSprite:pause()
end

local function onPieceTouch(event)
		
		local target = event.target
		
		if event.phase == "began" then
			
			if target.isTouchable then
				target.onUpperLayer = true
			end
			
			if target.onUpperLayer then
				target.focus = true
				transition.cancel(target)
				scene.view:insert(target)
				display.getCurrentStage():setFocus(target)
				target.touchX = target.x - event.x
				target.touchY = target.y - event.y

				transition.to(target, {time = 200, xScale = 1, yScale = 1})
				transition.to(target.bg, {time = 200, alpha = 0})
			end
			
		elseif event.phase == "moved" then
			
			if target.focus then
				target.x = event.x + target.touchX
				target.y = event.y + target.touchY
			end
			
		elseif event.phase == "ended" then
			
			target.focus = false
			display.getCurrentStage():setFocus(nil)
			local positionX = "x = display.contentWidth * "..event.target.x / display.contentWidth
			local positionY = "y = display.contentHeight * "..event.target.y / display.contentHeight
			print("{"..positionX..","..positionY.."},")
			
			if (target.x < target.position.x + 50 and target.x > target.position.x - 50) and
				(target.y < target.position.y + 50 and target.y > target.position.y - 50) then
				target.onPlace = true
				target:removeEventListener("touch", onPieceTouch)
				transition.to(target, {time = 200, xScale = 1.1, yScale = SCALE_PIECE, x = target.position.x, y = target.position.y})
			else
				transition.to(target.bg, {time = 200, alpha = 1})
			end
			
			if target.isTouchable then
				target.onUpperLayer = true
			end
							
			local isLabelComplete = true 
			for indexPiece = 1, #bandPieces do
				
				local piece = bandPieces[indexPiece]
				isLabelComplete = isLabelComplete and piece.onPlace
				
			end
			
			if isLabelComplete then
				labelComplete()
			end
		end
		
		return true
		
	end

local function createLabelElements(sceneGroup)
	
	labelBG = display.newImage(currentPortion.labelBG)
	labelBG.x = display.contentWidth * 0.19
	labelBG.y = display.contentCenterY
	sceneGroup:insert(labelBG)
	
	bandPieces = {}
	
--	local textOptions = {
--		text = currentPortion.
--	}
--	local labelDescription = display.newEmbossedText("")
	
	for indexPiece = 1, #currentPortion.pieces do
		
		local pieceGroup = display.newGroup()
		pieceGroup.x = display.contentCenterX
		pieceGroup.y = display.contentCenterY
		local pieceBG = display.newImage("images/label/pieces/etiqueta_0"..indexPiece..".png")
		pieceBG:scale(0.7,0.7)
		pieceGroup:insert(pieceBG)
		
		local piece = display.newImage(currentPortion.pieces[indexPiece].assets[PHASE])
		--piece:scale(1.1,1.35)
		--piece.answerPosition = currentPortion.pieces[indexPiece].answers[PHASE]
		pieceGroup:insert(piece)
		
		pieceGroup.onUpperLayer = false
		pieceGroup.isTouchable = true
		pieceGroup.onPlace = false
		pieceGroup.id = indexPiece
		pieceGroup.bg = pieceBG
		pieceGroup.position = currentPortion.pieces[indexPiece].answers[PHASE]
		pieceGroup:addEventListener("touch", onPieceTouch)
		bandPieces[indexPiece] = pieceGroup
		
		pieceGroup.y = (display.contentHeight * 0.92) - pieceGroup.contentHeight * 0.5
		pieceGroup.x = display.contentWidth + pieceGroup.contentWidth
		middleGroup:insert(pieceGroup)
	end
end

local function showIcon(sceneGroup)
	
	iconPortion = display.newImage(currentPortion.iconAsset)
	iconPortion.x = display.contentWidth * 0.70
	iconPortion.y = display.contentHeight * 0.6
	sceneGroup:insert(iconPortion)
	
	local function animateIconPortion(animationName)
			transition.to(iconPortion, {tag = "icon", time = 300, y = iconPortion.y - 50, transition = easing.outQuad, onComplete = function()
				transition.to(iconPortion, {time = 100, y = iconPortion.y + 50, transition = easing.inQuad})
			end})
			transition.to(iconPortion, {tag = "icon", time = 200, xScale = 0.8, transition = easing.outBounce, onComplete = function()
				transition.to(iconPortion, {tag = "icon", delay = 0, xScale = 1, transition = easing.outBounce, onComplete = function()
					animationTimer = timer.performWithDelay(3000, animateIconPortion)
				end})
				--animateIconPortion()
			end})
			transition.to(iconPortion, {tag = "icon", time = 200, yScale = 1.2, transition = easing.outBounce, onComplete = function()
				transition.to(iconPortion, {tag = "icon", yScale = 1, transition = easing.outElastic})
			end})
	end
	
	animateIconPortion("squish")
	
	portionDescription = display.newText(currentPortion.name, iconPortion.x, iconPortion.y * 0.60, settings.fontName, 45)
	portionDescription:setFillColor(0.1)
	sceneGroup:insert(portionDescription)
	
	portionDescriptionBG = display.newText(currentPortion.name, iconPortion.x, iconPortion.y * 0.60, settings.fontName, 45)
	portionDescriptionBG.alpha = 0
	portionDescriptionBG:setFillColor(1)
	sceneGroup:insert(portionDescriptionBG)
	
end

local function goToNextScene()
	
	director.gotoScene("scenes.overlays.tips", {effect = "fade", time = 350, params = {worldIndex = worldIndex, levelIndex = levelIndex}})
	--print("next scene")
end

------------------------------Module functions
function scene:create( event )

    local sceneGroup = self.view
	local scale = display.contentWidth / 1024
	local background = display.newImage(assetPath.."background_01.png")
	background:scale(scale, scale)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)
	
	local sheetData = {
		width = 1024,
		height = 256,
		numFrames = 16,
		sheetContentWidth = 2048,
		sheetContentHeight = 2048,
	}
	
	local sequenceData = graphics.newImageSheet(assetPath.."band.png", sheetData)
	
	local sequenceOptions = {
		name = "band",
		start = 1,
		count = 16,
		time = 220,
	}
	
	bandSprite = display.newSprite(sequenceData, sequenceOptions)
	bandSprite.x = display.screenOriginX + (display.contentWidth * 0.7)
	bandSprite.y =  display.contentHeight - (bandSprite.contentHeight * 0.3)
	
	sceneGroup:insert(bandSprite)
	
	middleGroup = display.newGroup()
	sceneGroup:insert(middleGroup)
	
	local descriptionData = {
		text = "[DESCRIPTION]",
		width = display.contentWidth * 0.45,
		height = display.contentHeight * 0.5,
		font = settings.fontName,
		fontSize = 32,
		align = "left"
	}
	
	descriptionText = display.newEmbossedText(descriptionData)
	descriptionText.x = display.contentWidth * 0.75
	descriptionText.y = display.contentCenterY
	sceneGroup:insert(descriptionText)
	
	local bandCover = display.newImage(assetPath.."background_02.png")
	bandCover:scale(scale, scale)
	bandCover.anchorY = 1
	bandCover.x = display.contentWidth * 0.5
	bandCover.y = display.contentHeight
	
	sceneGroup:insert(bandCover)
	
	local buttonData = buttonList.minigamestart
	buttonData.onRelease = startMinigame
	startButton = widget.newButton(buttonData)
	startButton.x = display.contentWidth * 0.8
	startButton.y = display.contentHeight * 0.90
	
	sceneGroup:insert(startButton)
	
	local nameContainer = display.newImage("images/minigames/panel_producto.png")
	nameContainer.x = display.contentWidth - (nameContainer.contentWidth * 0.45)
	nameContainer.y = display.screenOriginY + (nameContainer.contentHeight * 0.4)
	
	sceneGroup:insert(nameContainer)
	
	local buttonData = buttonList.ok
	buttonData.onRelease = goToNextScene
	nextSceneButton = widget.newButton(buttonData)
	nextSceneButton:setEnabled(false)
	nextSceneButton.alpha = 0
	nextSceneButton.x = display.contentWidth - (nextSceneButton.contentWidth)
	nextSceneButton.y = display.contentHeight - (nextSceneButton.contentHeight * 0.80)
	sceneGroup:insert(nextSceneButton)
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
		createLabelElements(sceneGroup)
		showIcon(sceneGroup)
		
		Runtime:addEventListener("enterFrame", updateGame)
		
	elseif ( phase == "did" ) then
	
    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		
	elseif ( phase == "did" ) then
		
		Runtime:removeEventListener("enterFrame", updateGame)
		for indexPiece = 1, #bandPieces do
			display.remove(bandPieces[indexPiece])
		end
		
		transition.cancel("icon")
		if animationTimer then
			timer.cancel(animationTimer)
		end
		display.remove(iconPortion)
		display.remove(portionDescription)
		display.remove(portionDescriptionBG)
		display.remove(labelBG)
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
