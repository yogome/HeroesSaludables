----------------------------------------------- Lluvia Minigame
local director = require( "libs.helpers.director" )
local tabla = require( "libs.helpers.extratable" )
local buttonList = require("data.buttonlist")
local labelData = require("data.labeldata")
local settings = require("settings")
local widget = require("widget")

local game = director.newScene()
----------------------------------------------- Variables
local currentPortion
local labelBG
local puzzlePieces
local descriptionText
local nextSceneButton
local iconPortion, portionDescription, portionDescriptionBG
local okButton
local queue = {}
----------------------------------------------- Constants
local numPieces = 5 

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenLeft = display.screenOriginX
local screenWidth = display.viewableContentWidth - screenLeft * 2
local screenTop = display.screenOriginY
local screenHeight = display.viewableContentHeight - screenTop * 2

local iniX = display.contentWidth * 0.65
local iniY = screenTop-150

local snapTreshold = 260
-----------------------------------------------Cached functions
local mRandom = math.random  
----------------------------------------------- Functions
local function startGame()
	local dly = 0
	
	queue = tabla.shuffle(queue)
	
	for i=1, 5 do
		local currentPiece = queue[i]
		transition.to(currentPiece,{delay = dly, y=screenHeight+200, time=5000, iterations = -1})
		dly = dly + 1200
	end
end

local function stopGame()
	nextSceneButton:setEnabled(true)
	transition.to(nextSceneButton, {alpha = 1, time = 300})
	transition.to(descriptionText, {alpha = 1, time = 300})
end

local function dragnDrop(event)
	local target = event.target
	if event.phase == "began" then
		transition.pause(target)
		display.getCurrentStage():setFocus( target, event.id )
		target.isFocus = true
		target.markX = event.target.x
		target.markY = event.target.y
		if target[1] then
			transition.to(target[1] , {alpha = 0, time=300})
		end
	elseif target.isFocus then
		if event.phase == "moved" then
			target.x = event.x - event.xStart + target.markX
			target.y = event.y - event.yStart + target.markY
		elseif event.phase == "ended" or event.phase == "cancelled" then
			display.getCurrentStage():setFocus(target, nil)
			target.isFocus = false
						
			if target[1] then
				if math.abs(target.y - target.destY) < snapTreshold and math.abs(target.x - target.destY) < snapTreshold then
					transition.cancel(target)
					target:removeEventListener("touch", dragnDrop)
					
					transition.to(target, {xScale = 1.1, yScale = 1.1, x = target.destX, y = target.destY, time=300})
					target.correct = true
				else
					transition.to(target[2] , {alpha = 0, time=300})
					transition.to(target[1] , {alpha = 1, time=300, delay=2500})
					transition.to(target[2] , {alpha = 1, time=300, delay=2500})
					transition.to(target , {x = iniX + mRandom(-200, 200)})
					transition.resume(target)
				end
				
				local win = true 
				for i = 1, #queue do
					win = win and queue[i].correct
				end

				if win then
					stopGame()
				end
			end
			
		end
	end
	return true
end  

local function createPuzzle(group)
	local pzzl = mRandom(1, 10)
	
	currentPortion = labelData[pzzl]
	puzzlePieces = display.newGroup()
	
	labelBG = display.newImage(currentPortion.labelBG)
	labelBG.x = screenLeft + 180
	labelBG.y = centerY
	
	local hgt = labelBG.y - labelBG.height*0.5
	
	iconPortion = display.newImage(currentPortion.iconAsset)
	iconPortion:scale(1.4, 1.4)
	iconPortion.x = iniX
	iconPortion.y = display.contentHeight * 0.5
	
	portionDescription = display.newText(currentPortion.name, iconPortion.x, iconPortion.y * 0.4, settings.fontName, 45)
	portionDescription:setFillColor(0.1)
	
	portionDescriptionBG = display.newText(currentPortion.name, iconPortion.x, iconPortion.y * 0.4, settings.fontName, 45)
	portionDescriptionBG.alpha = 0
	portionDescriptionBG:setFillColor(1)	
		
	descriptionText = display.newEmbossedText({
			text = currentPortion.description,
			width = display.contentWidth * 0.45,
			height = display.contentHeight * 0.5,
			font = settings.fontName,
			fontSize = 32,
			align = "left"})
	descriptionText.x = display.contentWidth * 0.75
	descriptionText.y = display.contentCenterY
	descriptionText.alpha = 0
		
	for i = 1, numPieces do
		local piece_ = display.newImage(currentPortion.pieces[i].assets[1])
		local box = display.newImage("images/label/piecesBoxes/etiqueta_0" .. i .. ".png")
		box:scale( 0.7, 0.7 )
		
		local piece =display.newGroup()
		piece:insert(box)
		piece:insert(piece_)
		piece.x = iniX
		piece.y = iniY
		
		piece.destX = labelBG.x
		if i == 3 then
			piece.destY =  hgt + piece[2].height*0.5
			hgt = hgt + piece[2].height*0.3
		else
			piece.destY =  hgt + piece[2].height*0.5
			hgt = hgt + piece[2].height
		end
		
		piece.correct = false
		
		piece:addEventListener("touch", dragnDrop)
		
		queue[i] = piece
		puzzlePieces:insert(piece)
	end
	
	okButton:setEnabled(true)
	okButton.isVisible=true
	okButton.alpha=1
	
	group:insert(descriptionText)
	group:insert(labelBG)
	group:insert(puzzlePieces)
	group:insert(iconPortion)
	group:insert(portionDescription)
	group:insert(portionDescriptionBG)
	group:insert(okButton)
	group:insert(nextSceneButton)
end

local function setElements(group)
	local puzzleContainer = display.newImage("images/label/panel_etiquetas.png")
	puzzleContainer.x = screenLeft + 213
	puzzleContainer.y = centerY
	
	local nameContainer = display.newImage("images/minigames/panel_producto.png")
	nameContainer:scale( 1.2, 1 )
	nameContainer.x = display.contentWidth - (nameContainer.contentWidth * 0.45)
	nameContainer.y = display.screenOriginY + (nameContainer.contentHeight * 0.3)
	
	local background = display.newImage("images/label/labelBackground.png")	
	background.x = centerX
	background.y = centerY
    background.width = screenWidth
    background.height = screenHeight
	
	group:insert(background)
	group:insert(puzzleContainer)
	group:insert(nameContainer)
end

local function createButton(event)
	local function comenzarBtn(event)
		if ( "ended" == event.phase ) then
			transition.to(okButton, {alpha = 0, time=300, onComplete = function()
				okButton:setEnabled(false)
				okButton.isVisible=false
				transition.to(iconPortion, {xScale = 0.3, yScale = 0.3, x = display.contentWidth * 0.95, y = display.contentWidth * 0.04, transition = easing.outQuad})
				transition.to(portionDescription, {alpha = 0, xScale = 0.8, yScale = 0.8, x = display.contentWidth * 0.75, y = display.contentWidth * 0.03, transition = easing.outQuad})
				transition.to(portionDescriptionBG, {alpha = 1, xScale = 0.8, yScale = 0.8, x = display.contentWidth * 0.75, y = display.contentWidth * 0.03, transition = easing.outQuad})
			end})
			startGame()
		end
	end
	
	local buttonData = buttonList.minigamestart
	buttonData.onRelease = comenzarBtn
	okButton = widget.newButton(buttonData)
	okButton:scale(1.2, 1.2)
	okButton.x = display.contentWidth * 0.8
	okButton.y = display.contentHeight * 0.85
end

local function nextButton(event)
	local function comenzarBtn(event)
		if ( "ended" == event.phase ) then
			director.gotoScene("scenes.overlays.tips", {effect = "fade", time = 350})
		end
	end
	
	local buttonData = buttonList.ok
	buttonData.onRelease = comenzarBtn
	nextSceneButton = widget.newButton(buttonData)
	nextSceneButton:setEnabled(false)
	nextSceneButton.alpha = 0
	nextSceneButton.x = display.contentWidth - (nextSceneButton.contentWidth)
	nextSceneButton.y = display.contentHeight - (nextSceneButton.contentHeight * 0.80)
end 
---------------------------------------------
function game:create(event)
	local sceneGroup = self.view
	createButton(event)
	nextButton(event)
	setElements(sceneGroup)
end

function game:show(event)
    local sceneGroup = self.view
    local phase = event.phase
    if phase == "will" then
		createPuzzle(sceneGroup)
	elseif phase == "did" then
	
    end
end

function game:hide(event)
    local sceneGroup = self.view
    local phase = event.phase
    if phase == "will" then
		
	elseif phase == "did" then
		display.remove(puzzlePieces)
		display.remove(iconPortion)
		display.remove(portionDescription)
		display.remove(portionDescriptionBG)
		display.remove(labelBG)
		display.remove(descriptionText)
		display.remove(nextSceneButton)
    end
end

function game:destroy()
end

----------------------------------------------- Execution
game:addEventListener( "create" )
game:addEventListener( "destroy" )
game:addEventListener( "hide" )
game:addEventListener( "show" )

return game