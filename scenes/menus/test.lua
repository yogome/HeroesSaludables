------------------------------------------------ Test Menu
local composer = require( "composer" )
local widget = require( "widget" )
local performance = require( "libs.helpers.performance" )
local internet = require( "libs.helpers.internet" )
local logger = require( "libs.helpers.logger" )
local video = require( "libs.helpers.video" )
local banners = require( "libs.helpers.banners" )
local players = require( "models.players" )
local offlinequeue = require( "libs.helpers.offlinequeue")
local sound = require("libs.helpers.sound")

local scene = composer.newScene()
----------------------------------------------- Variables
local counter
local buttonsEnabled
local internetButton
----------------------------------------------- Constants
local BUTTON_SHOW_WIDTH = 100
local BUTTON_SHOW_HEIGHT = 35
local BUTTON_SHOW_ALPHA = 0
local BUTTON_SHOW_SIZE_TEXT = 25
local BUTTON_WIDTH = 460 
local BUTTON_HEIGHT = 60
local BUTTON_MARGIN = 5
local SIZE_TEXT = 45
----------------------------------------------- Functions
local function clearQueue()
	offlinequeue.clear()
end

local function goGame()
	composer.gotoScene("scenes.game.game")
end

local function giveCoins()
	local player = players.getCurrent()
	if player.coins then
		player.coins = player.coins + 100
	else
		player.coins = 100
	end
	players.save(player)
end

local function resetPlayer()
	local currentPlayer = players.getCurrent()
	local playerID = currentPlayer.id
	local remoteID = currentPlayer.remoteID
	if playerID then
		currentPlayer = players.new()
		currentPlayer.id = playerID
		currentPlayer.remoteID = remoteID
		players.save(currentPlayer)
	end
end

local function toggleFPS()
	if counter.alpha <= 0 then counter.alpha = 0.7 else counter.alpha = 0 end
end

local function testInternet()
	local result = internet.isConnected()
	internetButton.text.text = tostring(result)
end
----------------------------------------------- Class functions
function scene.backAction()
	composer.gotoScene("scenes.menus.home")
	return true
end 

function scene:addButton(text, listener, rectColor, silent)
	if text and listener then
		rectColor = rectColor or {0.1,0.1,0.1}
		
		local group = self.scrollView
		local button = display.newGroup()
		group:insert(button)
		
		local rectangle = display.newRect(0,0,BUTTON_WIDTH,BUTTON_HEIGHT)
		rectangle.x = 0
		rectangle.y = 0
		button:insert(rectangle)
		rectangle.listener = listener
		rectangle:setFillColor(rectColor[1],rectColor[2],rectColor[3])
		
		local text = display.newText(text, 0, 0, native.systemFont, SIZE_TEXT)
		text.x = 0
		text.y = 0
		button:insert(text)
		button.text = text
		
		rectangle:addEventListener("tap", function()
			if buttonsEnabled == true then
				sound.play("pop")
				rectangle.listener()
			end
		end)
		
		button.x = display.screenOriginX + (BUTTON_WIDTH + BUTTON_MARGIN) * 0.5 + ((BUTTON_WIDTH + BUTTON_MARGIN) * self.columnSpaces)
		button.y = display.screenOriginY + (BUTTON_HEIGHT + BUTTON_MARGIN) * 0.5 + ((BUTTON_HEIGHT + BUTTON_MARGIN) * self.rowSpaces)
		
		self.rowSpaces = self.rowSpaces + 1
		
		return button
	end
end

function scene:skipRow()
	self.rowSpaces = self.rowSpaces + 1
end

function scene:skipColumn()
	self.columnSpaces = self.columnSpaces + 1
	self.rowSpaces = 0
end

function scene.initialize()
	counter = performance.getGroup()
	counter.x = display.screenOriginX + display.viewableContentWidth - 130
	counter.y = display.screenOriginY + display.viewableContentHeight - 40
	counter.alpha = 0
	
	offlinequeue.addResultListener("testListener", function(event)
		logger.log(event)
	end)
	
	offlinequeue.addResultListener("test2Listener", function(event)
		logger.log(event)
	end)
end

function scene:createView()
	------------------------- Buttons

	self:addButton("Go Game", goGame, {0.5,0.5,0.5})
	self:addButton("Clear queue", clearQueue, {0.5,0.6,0.3})
	
	self:skipColumn()
	self:addButton("Give Coins", giveCoins,{0.2,0.8,0.2})
	self:skipColumn()
	self:addButton("Toggle FPS", toggleFPS,{0.3,0.3,0.8})
    internetButton = self:addButton("Test internet", testInternet, {0.6,0.8,0.4})
	
	self:skipColumn()
	
	self:addButton("Reset player", resetPlayer,{0.8,0.2,0.2})
end

function scene:create(event)
	self.rowSpaces = 0
	self.columnSpaces = 0
	
	self.showMenu = display.newGroup()
	self.showMenu.alpha = BUTTON_SHOW_ALPHA
	local showRectangle = display.newRect(0,0,BUTTON_SHOW_WIDTH, BUTTON_SHOW_HEIGHT)
	showRectangle:setFillColor(0.5)
	self.showMenu:insert(showRectangle)
	local text = display.newText("BACK", 0, 0, native.systemFont, BUTTON_SHOW_SIZE_TEXT)
	self.showMenu:insert(text)
		
	showRectangle:addEventListener("tap", function()
		if buttonsEnabled == true then
			composer.gotoScene( "scenes.menus.test", { effect = "fade", time = 400} )
			return true
		end
	end)
	self.showMenu.x = display.screenOriginX + self.showMenu.width * 0.5
	self.showMenu.y = display.screenOriginY + self.showMenu.height * 0.5
	
	local viewOptions = {
		x = display.contentCenterX,
		y = display.contentCenterY,
		width = display.viewableContentWidth,
		height = display.viewableContentHeight,
		scrollWidth = 100,
		scrollHeight = 100,
		hideBackground = true,
	}
	self.scrollView = widget.newScrollView(viewOptions)
	self.scrollView:scrollToPosition({x = 0, y = -1200, time = 0, onComplete = function()
		self.scrollView:scrollToPosition({x = 0, y = 0, time = 600})
	end})
	self.view:insert(self.scrollView)
	
	self:createView()
	self.initialize()
end

function scene:destroy()
	
end

function scene:show( event )
	buttonsEnabled = false
	timer.performWithDelay(400, function()
		buttonsEnabled = true
	end)
	display.setDefault("background", 0, 0, 0)
end

function scene:hide( event )
	
end

scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "show", scene )

return scene
