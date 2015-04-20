----------------------------------------------- Lluvia Minigame
local director = require( "libs.helpers.director" )
local tabla = require( "libs.helpers.extratable" )
local colors = require( "libs.helpers.colors" )
local buttonList = require("data.buttonlist")
local labelData = require("data.labeldata")
local settings = require("settings")
local widget = require("widget")

local game = director.newScene()
----------------------------------------------- Variables
local backgroundLayer
local dynamicLayer

local currentPortion
local labelBG
local puzzlePieces
local descriptionText
local nextSceneButton
local iconPortion, portionDescriptionText
local okButton
local queue = {}
----------------------------------------------- Constants
local NUMBER_PIECES = 5 

local SCALE_BOXES = 0.83
local SCALE_OKBUTTON = 1.2

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenLeft = display.screenOriginX
local screenWidth = display.viewableContentWidth - screenLeft * 2
local screenTop = display.screenOriginY
local screenHeight = display.viewableContentHeight - screenTop * 2

local iniX = display.contentWidth * 0.65
local iniY = screenTop - 150

local snapTreshold = 0--50
-----------------------------------------------Cached functions
local mathRandom = math.random  
local mathSqrt = math.sqrt
----------------------------------------------- Functions
local function startGame()
	local dly = 0
	queue = tabla.shuffle(queue)
	for i=1, 5 do
		local currentPiece = queue[i]
		transition.to(currentPiece,{delay = dly, y=screenHeight+200, time=5000, iterations = -1})
		dly = dly + 1000
	end
end

local function stopGame()
	nextSceneButton:setEnabled(true)
	transition.to(nextSceneButton, {alpha = 1, time = 300})
	transition.to(descriptionText, {alpha = 1, time = 300})
end

local function magnet(obj)
	local dx = obj.x - obj.destX
	local dy = obj.y - obj.destY

	local distance = mathSqrt( dx*dx + dy*dy )
	local objectSize = obj.contentWidth*0.3 + snapTreshold 

	if ( distance < objectSize ) then
		return true
	end
	return false
end

local function dragnDrop(event)
	local target = event.target
	if not target.preventTouch then
		if event.phase == "began" then
			target:toFront()
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
				target.preventTouch=true

				if magnet(target) then
					transition.cancel(target)
					target:removeEventListener("touch", dragnDrop)
					transition.to(target, {x = target.destX, y = target.destY, time = 300})
					target.correct = true
				else
					transition.to(target[2] , {alpha = 0, time = 300, onComplete = function() 
						target.x = iniX + mathRandom(-200, 200)
						transition.resume(target)
						target.preventTouch=false
					end})
					transition.to(target[1] , {alpha = 1, time = 300, delay = 2500})
					transition.to(target[2] , {alpha = 1, time = 300, delay = 2500})
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
	local pzzl = mathRandom(1, 10)
	
	currentPortion = labelData[pzzl]
	puzzlePieces = display.newGroup()
	
	descriptionText = display.newEmbossedText({
		highlight = { r=0.3, g=0.3, b=0.3 },
		shadow = { r=1, g=1, b=1 },
		text = currentPortion.description,
		width = display.contentWidth * 0.45,
		height = display.contentHeight * 0.5,
		font = settings.fontName,
		fontSize = 32,
		align = "left"
	})
	descriptionText.x = display.contentWidth * 0.75
	descriptionText.y = display.contentCenterY
	descriptionText.alpha = 0
	group:insert(descriptionText)
	
	labelBG = display.newImage(currentPortion.labelBG)
	labelBG.x = screenLeft + 180
	labelBG.y = centerY
	group:insert(labelBG)

	local height = labelBG.y - labelBG.height * 0.5

	for index = 1, NUMBER_PIECES do
		local piece_ = display.newImage(currentPortion.pieces[index].assets[1])
		local box = display.newImage("images/label/piecesBoxes/etiqueta_0" .. index .. ".png")
		box:scale(SCALE_BOXES, SCALE_BOXES)
		
		local piece = display.newGroup()
		piece.x = iniX
		piece.y = iniY
		piece.correct = false
		piece:insert(box)
		piece:insert(piece_)
		piece:addEventListener("touch", dragnDrop)
		
		piece.destX = labelBG.x
		if index == 3 then
			local ax1 = display.newImage(currentPortion.pieces[5].assets[1])
			local ax2 = display.newImage(currentPortion.pieces[4].assets[1])
			
			piece.destY =  height + piece[2].height*0.5 + 1
			height = labelBG.y + labelBG.height * 0.5 - ax1.height - ax2.height + 12
			
			ax1:removeSelf()
			ax2:removeSelf()
		else
			piece.destY =  height + piece[2].height*0.5
			height = height + piece[2].height -15
		end		
		
		queue[index] = piece
		puzzlePieces:insert(piece)
	end
	group:insert(puzzlePieces)
	
	local portionDescriptionBG = display.newImage("images/minigames/panel_producto.png")
	portionDescriptionBG:scale( 1.2, 1 )
	portionDescriptionBG.x = display.contentWidth - (portionDescriptionBG.contentWidth * 0.45)
	portionDescriptionBG.y = display.screenOriginY + (portionDescriptionBG.contentHeight * 0.3)
	group:insert(portionDescriptionBG)
	
	iconPortion = display.newImage(currentPortion.iconAsset)
	iconPortion:scale(1.4, 1.4)
	iconPortion.x = iniX
	iconPortion.y = display.contentHeight * 0.5
	group:insert(iconPortion)

	portionDescriptionText = display.newText(currentPortion.name, iconPortion.x, iconPortion.y * 0.4, settings.fontName, 45)
	colors.addColorTransition(portionDescriptionText)
	portionDescriptionText.alpha = 1
	portionDescriptionText:setFillColor(0.1)	
	group:insert(portionDescriptionText)
end

local function createBgElements()
	local bgElements = display.newGroup()
	
	local background = display.newImage("images/label/labelBackground.png")	
	background.x = centerX
	background.y = centerY
    background.width = screenWidth
    background.height = screenHeight
	bgElements:insert(background)
	
	local puzzleContainer = display.newImage("images/label/panel_etiquetas.png")
	puzzleContainer.x = screenLeft + 213
	puzzleContainer.y = centerY
	bgElements:insert(puzzleContainer)
	
	return bgElements
end

local function createButton(group)
	local function comenzarBtn(event)
		if ( "ended" == event.phase ) then
			okButton:setEnabled(false)
			transition.to(okButton, {alpha = 0, time=300, onComplete = function()
				okButton.isVisible=false
				transition.to(iconPortion, {xScale = 0.3, yScale = 0.3, x = display.contentWidth * 0.95, y = display.contentWidth * 0.04, transition = easing.outQuad})
				transition.to(portionDescriptionText, {r = 1, g = 1, b = 1, xScale = 0.8, yScale = 0.8, x = display.contentWidth * 0.75, y = display.contentWidth * 0.03, transition = easing.outQuad})
			end})
			startGame()
		end
	end
	
	local buttonData = buttonList.minigamestart
	buttonData.onRelease = comenzarBtn
	okButton = widget.newButton(buttonData)
	okButton:scale(SCALE_OKBUTTON, SCALE_OKBUTTON)
	okButton:setEnabled(true)
	okButton.isVisible = true
	okButton.alpha = 1
	okButton.x = display.contentWidth * 0.8
	okButton.y = display.contentHeight * 0.85
	
	group:insert(okButton)
end

local function nextSceneButtonListener(event)
	if ( "ended" == event.phase ) then
		nextSceneButton:setEnabled(false)
		director.gotoScene("scenes.overlays.tips", {effect = "fade", time = 350})
	end
end

local function createNextSceneButton(parentGroup)
	local buttonData = buttonList.ok
	buttonData.onRelease = nextSceneButtonListener
	nextSceneButton = widget.newButton(buttonData)
	nextSceneButton.alpha = 0
	nextSceneButton.x = display.contentWidth - (nextSceneButton.contentWidth)
	nextSceneButton.y = display.contentHeight - (nextSceneButton.contentHeight * 0.80)
	nextSceneButton:setEnabled(false)
	parentGroup:insert(nextSceneButton)
end 
---------------------------------------------
function game:create(event)
	local sceneGroup = self.view
	
	backgroundLayer = display.newGroup()
	sceneGroup:insert(backgroundLayer)

	local bgElements = createBgElements()
	backgroundLayer:insert(bgElements)
	
	createButton(backgroundLayer)
	createNextSceneButton(backgroundLayer)
end

function game:show(event)
    local sceneGroup = self.view
    local phase = event.phase
    if phase == "will" then
		dynamicLayer = display.newGroup()
		createPuzzle(dynamicLayer)
		sceneGroup:insert(dynamicLayer)
		
		okButton.alpha=1
		okButton.isVisible=true
		okButton:setEnabled(true)
		
		nextSceneButton.alpha=0

	elseif phase == "did" then
	
    end
end

function game:hide(event)
    local sceneGroup = self.view
    local phase = event.phase
    if phase == "will" then
		
	elseif phase == "did" then
		display.remove(dynamicLayer)
    end
end

function game:destroy()
	display.remove(backgroundLayer)

end

----------------------------------------------- Execution
game:addEventListener( "create" )
game:addEventListener( "destroy" )
game:addEventListener( "hide" )
game:addEventListener( "show" )

return game