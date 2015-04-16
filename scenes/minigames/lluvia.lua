----------------------------------------------- Lluvia Minigame
local director = require( "libs.helpers.director" )
local buttonList = require("data.buttonlist")
local labelData = require("data.labeldata")
local settings = require("settings")
local widget = require("widget")
local sound = require("libs.helpers.sound")
local game = director.newScene()

----------------------------------------------- Variables
local currentPortion
local puzzlePieces
local iconPortion, portionDescription, portionDescriptionBG
local okButton
local lluvia

----------------------------------------------- Constants
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenLeft = display.screenOriginX
local screenWidth = display.viewableContentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.viewableContentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight

-----------------------------------------------Cached functions
local mRandom = math.random  

----------------------------------------------- Functions
local function dragnDrop(event)
	local target = event.target
	if event.phase == "began" then
		transition.cancel(target)
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
		end
	end
	return true
end  

local function createPuzzle()
	local pzzl = mRandom(1, 10)
	currentPortion = labelData[pzzl]
	lluvia = {}
	puzzlePieces = display.newGroup()
--	puzzlePieces.pieces = {}
	
	local numPieces = 5
		
	for i = 1, numPieces do
		local piece_ = display.newImage(currentPortion.pieces[i].assets[1])
		local box = display.newImage("images/label/piecesBoxes/etiqueta_0" .. i .. ".png")
		box:scale( 0.7, 0.7 )
		local piece =display.newGroup()
		piece:insert(box)
		piece:insert(piece_)
		
		piece:addEventListener("touch", dragnDrop)
		lluvia[i] = piece
--		puzzlePieces.pieces[i] = piece
		puzzlePieces:insert(piece)
	end
	
	iconPortion = display.newImage(currentPortion.iconAsset)
	iconPortion:scale(1.4, 1.4)
	iconPortion.x = display.contentWidth * 0.65
	iconPortion.y = display.contentHeight * 0.5
	
	portionDescription = display.newText(currentPortion.name, iconPortion.x, iconPortion.y * 0.4, settings.fontName, 45)
	portionDescription:setFillColor(0.1)
	
	portionDescriptionBG = display.newText(currentPortion.name, iconPortion.x, iconPortion.y * 0.4, settings.fontName, 45)
	portionDescriptionBG.alpha = 0
	portionDescriptionBG:setFillColor(1)
end

local function setElements(group)
	createPuzzle()
	
	okButton:setEnabled(true)
	okButton.isVisible=true
	okButton.alpha=1
	
	local puzzleContainer = display.newImage("images/label/panel_etiquetas.png")
	puzzleContainer.x = screenLeft + 213
	puzzleContainer.y = centerY
	
	local labelBG = display.newImage(currentPortion.labelBG)
	labelBG.x = screenLeft + 180
	labelBG.y = centerY
	
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
	group:insert(labelBG)
	group:insert(puzzlePieces)
	group:insert(okButton)
	group:insert(nameContainer)
	group:insert(iconPortion)
	group:insert(portionDescription)
	group:insert(portionDescriptionBG)
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
				startGame()
			end})
		end
	end
	
	local buttonData = buttonList.minigamestart
	buttonData.onRelease = comenzarBtn
	okButton = widget.newButton(buttonData)
	okButton:scale(1.2, 1.2)
	okButton.x = display.contentWidth * 0.8
	okButton.y = display.contentHeight * 0.85
end

local function startGame()
	repeatLoop()

end

local function repeatLoop()
	lluvia[1].x=centerX
	lluvia[1].y=centerY
	transition.to(lluvia[1], {x = display.contentWidth * 1.3} )	
end

local function stopGame()
	
end

---------------------------------------------
function game:create(event)
	local sceneGroup = self.view
	createButton(event)
	setElements(sceneGroup)
end

function game:show(event)
    local sceneGroup = self.view
    local phase = event.phase
	director = event.parent
    if phase == "will" then
		--startGame(event)
	elseif phase == "did" then
	
    end
end

function game:hide(event)
    local sceneGroup = self.view
    local phase = event.phase
    if phase == "will" then
		
	elseif phase == "did" then
		stopGame()
		setElements(sceneGroup)
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