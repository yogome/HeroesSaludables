----------------------------------------------- Lluvia Minigame
local director = require( "libs.helpers.director" )
local buttonList = require("data.buttonlist")
local widget = require("widget")
local sound = require("libs.helpers.sound")
local colors = require( "libs.helpers.colors" )
local game = director.newScene()

----------------------------------------------- Variables
local puzzleContainer
local puzzlePieces

local okButton

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
	if event.phase == "began" then
		display.getCurrentStage():setFocus( event.target, event.id )
		event.target.isFocus = true
		event.target.markX = event.target.x
		event.target.markY = event.target.y
	elseif event.target.isFocus then
		if event.phase == "moved" then
			event.target.x = event.x - event.xStart + event.target.markX
			event.target.y = event.y - event.yStart + event.target.markY
		elseif event.phase == "ended" or event.phase == "cancelled" then
			display.getCurrentStage():setFocus(event.target, nil)
			event.target.isFocus = false
		end
	end
	return true
end  

local function createPuzzle(group)
	local pzzl = mRandom(1, 11)
	puzzlePieces = display.newGroup()
	puzzlePieces.pieces = {}
	
	local numPieces = 5
		
	for i = 1, numPieces do
		local piece_ = display.newImage("images/label/pieces/phase1/" .. pzzl  .. "/piece" .. i .. ".png")
		local box = display.newImage("images/label/piecesBoxes/etiqueta_0" .. i .. ".png")
		box:scale( 0.7, 0.7 )
		local piece =display.newGroup();
		piece:insert(box)
		piece:insert(piece_)
		
		piece:addEventListener("touch", dragnDrop)
		piece.id = i
		puzzlePieces.pieces[i] = piece
		puzzlePieces:insert(piece)
	end
	group:insert(puzzlePieces)
end

local function setElements(group)
	puzzleContainer = display.newImage("images/label/panel_etiquetas.png")
	puzzleContainer.x = screenLeft - 300
	puzzleContainer.y = centerY

    local background = display.newImage("images/label/labelBackground.png")	
	background.x = centerX
	background.y = centerY
    background.width = screenWidth
    background.height = screenHeight

	group:insert(background)
	group:insert(puzzleContainer)
	createPuzzle(group)
end

local function initialize(event)
	okButton.x = display.contentCenterX
	okButton.y = display.contentCenterY
end

local function createButton(event)
	local function comenzarBtn(event)
		if ( "ended" == event.phase ) then
			transition.to(okButton, {alpha = 0, time=300, onComplete = function()
				okButton:setEnabled(false)
			end})
			transition.to(puzzleContainer, {transition = easing.outBounce, x = screenLeft + 213, time=500})
			sound.play("ironshield")
		end
	end
	
	local buttonData = buttonList.minigamestart
	buttonData.onRelease = comenzarBtn
	okButton = widget.newButton(buttonData)
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
		initialize(event)
	elseif phase == "did" then

		
    end
end

function game:hide(event)
    local sceneGroup = self.view
    local phase = event.phase
    if phase == "will" then
		
	elseif phase == "did" then
		stopGame()
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