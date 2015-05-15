----------------------------------------------- Lluvia Minigame
local director = require( "libs.helpers.director" )
local tabla = require( "libs.helpers.extratable" )
local colors = require( "libs.helpers.colors" )
local buttonList = require("data.buttonlist")
local labelData = require("data.frontdata")
local settings = require("settings")
local widget = require("widget")
local sound = require("libs.helpers.sound")
local music = require("libs.helpers.music")

local game = director.newScene()
----------------------------------------------- Variables
local backgroundLayer
local dynamicLayer

local currentPortion
local labelBG
local puzzlePieces
local descriptionText, descriptionRect
local nextSceneButton
local iconPortion, portionDescriptionText
local okButton
local queue = {}
----------------------------------------------- Constants
local NUMBER_PIECES = 6 

local SCALE_OKBUTTON = 1.2

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenLeft = display.screenOriginX
local screenWidth = display.viewableContentWidth - screenLeft * 2
local screenTop = display.screenOriginY
local screenHeight = display.viewableContentHeight - screenTop * 2

local iniX = display.contentWidth + 300
local iniY = screenHeight * 0.4

local snapTreshold = 0
local worldIndex
local levelIndex
-----------------------------------------------Cached functions
local mathRandom = math.random  
local mathSqrt = math.sqrt
----------------------------------------------- Functions
local function startGame()
	local dly = 0
	queue = tabla.shuffle(queue)
	for i=1, NUMBER_PIECES do
		local currentPiece = queue[i]
		transition.to(currentPiece,{delay = dly, x=screenLeft - 200, time=6000, iterations = -1})
		dly = dly + 1000
	end
end

local function stopGame()
	nextSceneButton:toFront()
	sound.play("correct")
	nextSceneButton:setEnabled(true)
	transition.to(nextSceneButton, {alpha = 1, time = 300})
	transition.to(descriptionText, {alpha = 1, time = 300})
	transition.to(descriptionRect, {alpha = 0.6, time = 300})
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
			sound.play("grab")
			target:toFront()
			transition.pause(target)
			display.getCurrentStage():setFocus( target, event.id )
			target.isFocus = true
			target.markX = event.target.x
			target.markY = event.target.y
		elseif target.isFocus then
			if event.phase == "moved" then
				target.x = event.x - event.xStart + target.markX
				target.y = event.y - event.yStart + target.markY
			elseif event.phase == "ended" or event.phase == "cancelled" then
				display.getCurrentStage():setFocus(target, nil)
				target.isFocus = false
				target.preventTouch=true
				sound.play("pop")
				if magnet(target) then
					transition.cancel(target)
					target:removeEventListener("touch", dragnDrop)
					transition.to(target, {x = target.destX, y = target.destY, time = 300})
					target.correct = true
				else
					transition.to(target, {alpha = 0, time = 300, onComplete = function() 
						target.y = iniY
						transition.resume(target)
						target.preventTouch=false
					end})
					transition.to(target, {alpha = 1, time = 300, delay = 2500})
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
	local pzzl = mathRandom(1, 2)
	
	currentPortion = labelData[pzzl]
	puzzlePieces = display.newGroup()
	
	descriptionRect = display.newRoundedRect(screenWidth * 0.7,screenTop + 170, screenWidth * 0.5, screenHeight * 0.4 , 30)
	descriptionRect.x = display.contentCenterX
	descriptionRect.y = display.contentCenterY * 0.8
	descriptionRect:setFillColor(0)
	descriptionRect.alpha = 0
	group:insert(descriptionRect)
	
	descriptionText = display.newEmbossedText({
		highlight = { r=0.3, g=0.3, b=0.3 },
		shadow = { r=1, g=1, b=1 },
		text = currentPortion.description,
		width = screenWidth * 0.45,
		height = screenHeight * 0.5,
		font = settings.fontName,
		fontSize = 32,
		align = "center"
	})
	
	descriptionText.anchorY = 0
	descriptionText.x = descriptionRect.x 
	descriptionText.y = descriptionRect.y - (descriptionRect.contentHeight * 0.4)
	descriptionText.alpha = 0
	group:insert(descriptionText)
	
	
	labelBG = display.newImage(currentPortion.labelBG)
	labelBG.x = centerX
	labelBG.y = screenHeight * 0.83
	group:insert(labelBG)

	local width = labelBG.x - labelBG.width * 0.5 + 25

	for index = 1, NUMBER_PIECES do
		local piece = display.newImage(currentPortion.pieces[index].assets[1])
		piece.x = iniX
		piece.y = iniY
		piece.correct = false
		piece:addEventListener("touch", dragnDrop)
		
		piece.destY = labelBG.y - 20
		piece.destX =  width + piece.width*0.5
		width = width + piece.width
		
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
	iconPortion.x = display.contentWidth * 0.35
	iconPortion.y = display.contentHeight * 0.43
	group:insert(iconPortion)

	portionDescriptionText = display.newText(currentPortion.name, iconPortion.x, iconPortion.y * 0.3, settings.fontName, 45)
	colors.addColorTransition(portionDescriptionText)
	portionDescriptionText.alpha = 1
	portionDescriptionText:setFillColor(0.1)	
	group:insert(portionDescriptionText)
end

local function createBackground()
	local bgElements = display.newGroup()
	
	local background = display.newImage("images/label/labelBackground2.png")	
	background.x = centerX
	background.y = centerY
    background.width = screenWidth
    background.height = screenHeight
	bgElements:insert(background)
	
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
	okButton.x = display.contentWidth * 0.7
	okButton.y = display.contentHeight * 0.43
	
	group:insert(okButton)
end

local function nextSceneButtonListener(event)
	if ( "ended" == event.phase ) then
		nextSceneButton:setEnabled(false)
		director.gotoScene("scenes.overlays.tips", {effect = "fade", time = 350, params = {worldIndex = worldIndex, levelIndex = levelIndex}})
	end
end

local function createNextSceneButton(parentGroup)
	local buttonData = buttonList.ok
	buttonData.onRelease = nextSceneButtonListener
	nextSceneButton = widget.newButton(buttonData)
	nextSceneButton.alpha = 0
	nextSceneButton.x = display.contentCenterX
	nextSceneButton.y = display.contentCenterY * 1.25
	nextSceneButton:setEnabled(false)
	parentGroup:insert(nextSceneButton)
end 
---------------------------------------------
function game:create(event)
	local sceneGroup = self.view
	
	backgroundLayer = display.newGroup()
	sceneGroup:insert(backgroundLayer)

	local bgElements = createBackground()
	backgroundLayer:insert(bgElements)
	
	createButton(backgroundLayer)
	createNextSceneButton(sceneGroup)
end

function game:show(event)
    local sceneGroup = self.view
    local phase = event.phase
	local params = event.params or {}
	
	worldIndex = params.worldIndex or 1
	levelIndex = params.levelIndex or 1
    if phase == "will" then
		dynamicLayer = display.newGroup()
		createPuzzle(dynamicLayer)
		sceneGroup:insert(dynamicLayer)
		
		okButton.alpha=1
		okButton.isVisible=true
		okButton:setEnabled(true)
		
		nextSceneButton.alpha=0

	elseif phase == "did" then
		music.playTrack(2)
    end
end

function game:hide(event)
    local sceneGroup = self.view
    local phase = event.phase
    if phase == "will" then
		
	elseif phase == "did" then
		music.fade(500)
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