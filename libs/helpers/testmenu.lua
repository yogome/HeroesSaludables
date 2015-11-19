------------------------------------------------ Test Menu
local path = ...
local folder = path:match("(.-)[^%.]+$")  
local director = require( folder.."director" )
local internet = require( folder.."internet" )
local logger = require( folder.."logger" )
local widget = require( "widget" )
local settings = require( "settings" )

local scene = director.newScene("testMenu")
----------------------------------------------- Variables
local fpsCounter
local backButton
local buttonList
local menuView
local addedButtons
----------------------------------------------- Constants
local BUTTON_SHOW_WIDTH = 100
local BUTTON_SHOW_HEIGHT = 35
local BUTTON_SHOW_ALPHA = 0.15
local BUTTON_SHOW_SIZE_TEXT = 25
local BUTTON_WIDTH = 460 
local BUTTON_HEIGHT = 85
local BUTTON_MARGIN = 5
local SIZE_TEXT = 45
----------------------------------------------- Functions
local function toggleFPS()
	if fpsCounter.alpha <= 0 then fpsCounter.alpha = 0.7 else fpsCounter.alpha = 0 end
end

local function testInternet(event)
	local result = internet.isConnected()
	event.target.text.text = tostring(result)
end

local function createBackButton()
	local backButton = display.newGroup()
	backButton.anchorChildren = true
	backButton.alpha = BUTTON_SHOW_ALPHA
	
	local buttonBG = display.newRect(0,0,BUTTON_SHOW_WIDTH, BUTTON_SHOW_HEIGHT)
	buttonBG:setFillColor(0.5)
	backButton:insert(buttonBG)
	
	local buttonText = display.newText("BACK", 0, 0, native.systemFont, BUTTON_SHOW_SIZE_TEXT)
	backButton:insert(buttonText)
		
	buttonBG:addEventListener("tap", function()
		director.gotoScene( "testMenu", { effect = "fade", time = 400} )
		return true
	end)
	
	return backButton
end

local function createMenuView()
	local viewOptions = {
		x = display.contentCenterX,
		y = display.contentCenterY,
		width = display.viewableContentWidth,
		height = display.viewableContentHeight,
		scrollWidth = 100,
		scrollHeight = 100,
		hideBackground = true,
	}
	local menuView = widget.newScrollView(viewOptions)
	menuView:scrollToPosition({x = 0, y = -1200, time = 0, onComplete = function()
		menuView:scrollToPosition({x = 0, y = 0, time = 600})
	end})
	return menuView
end

local function initialize()
	if settings and settings.testActions and "string" == type(settings.testActions) and not addedButtons then
		local testActions = require(settings.testActions)
		for index = 1, #testActions do
			scene.addButton(unpack(testActions[index]))
		end
		addedButtons = true
	end
end
----------------------------------------------- Class functions
function scene.addButton(text, listener, rectColor, column)
	if text and listener then
		rectColor = rectColor or {0.1,0.1,0.1}
		column = column or 1
		
		local button = display.newGroup()
		button.listener = listener
		menuView:insert(button)
		
		local background = display.newRect(0,0,BUTTON_WIDTH,BUTTON_HEIGHT)
		button:insert(background)
		background:setFillColor(unpack(rectColor))
		
		local text = display.newText(text, 0, 0, native.systemFont, SIZE_TEXT)
		button:insert(text)
		
		button.text = text
		button.background = background
		
		button:addEventListener("tap", function()
			button.listener({target = button})
			return true
		end)
		buttonList[column] = buttonList[column] or {}
		local row = #buttonList[column]
		button.x = display.screenOriginX + (BUTTON_WIDTH + BUTTON_MARGIN) * 0.5 + ((BUTTON_WIDTH + BUTTON_MARGIN) * (column - 1))
		button.y = display.screenOriginY + (BUTTON_HEIGHT + BUTTON_MARGIN) * 0.5 + ((BUTTON_HEIGHT + BUTTON_MARGIN) * row)
		
		buttonList[column][#buttonList[column] + 1] = button
		
		return button
	end
end

function scene:create(event)
	logger.log("[Test menu] initializing")
	buttonList = {}

	backButton = createBackButton()
	backButton.anchorX = 0
	backButton.anchorY = 0
	backButton.x = display.screenOriginX
	backButton.y = display.screenOriginY
	display.getCurrentStage():insert(backButton)
	backButton.isVisible = false
	
	scene.backButton = backButton
	
	menuView = createMenuView()
	self.view:insert(menuView)
	
	self.addButton("Test internet", testInternet, {0.6,0.8,0.4})
end

function scene:destroy()
	addedButtons = false
end

function scene:show( event )
	if "will" == event.phase then
		display.setDefault("background",0,0,0)
	elseif "did" == event.phase then
		backButton.isVisible = true
	end
end

function scene:hide( event )
	if "will" == event.phase then
	
	end
end

scene:addEventListener( "create" )
scene:addEventListener( "destroy" )
scene:addEventListener( "hide" )
scene:addEventListener( "show" )

director.loadScene( "testMenu" )
initialize()

return scene
