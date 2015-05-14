local director = require( "libs.helpers.director" )
local sound = require( "libs.helpers.sound" )
local settings = require( "settings" )
local widget = require("widget")
local buttonList = require("data.buttonlist")
local localization = require("libs.helpers.localization")
local settings = require("settings")
local players = require("models.players")

local game = director.newScene() 
local menuPanel
local titleText
local currentPlayer
----------------------------------------------- Variables

------------------------------------------------- Constants

------------------------------------------------- Functions
--
local function createUnlockedMenus()
	
	local startX = -200
	local startY = 0
	for indexTitle = 1, 3 do
		local lock = display.newImage("images/foodmenu/icon.png")
		--lock:setFillColor(0)
		lock:scale(0.6,0.6)
		lock.x = startX + (lock.contentWidth * 1.40 * (indexTitle - 1))
		lock.y = startY
		menuPanel:insert(lock)
	end
end

local function initialize()
	
	currentPlayer = players.getCurrent()
	titleText.text = "Menús para dieta de "..currentPlayer.playerCalories.." Kcal"
	
end

function game:create(event)
	local sceneGroup = self.view
	
	local scale = display.contentWidth / 1024
	local background = display.newImage("images/infoscreen/Background.png")
	background:scale(scale, scale)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)
	
	menuPanel = display.newGroup()
	menuPanel.x = display.contentCenterX
	menuPanel.y = display.contentCenterY
	sceneGroup:insert(menuPanel)
	
	local panel = display.newImage("images/foodmenu/ventana.png")
	panel:scale(1.3,1.3)
	menuPanel:insert(panel)
	
	local startX = -200
	local startY = -230
	for indexTitle = 1, 3 do
		local worldTitle = display.newText("Mundo " .. indexTitle, 0, 0, settings.fontName, 38)
		worldTitle.x = startX + (worldTitle.contentWidth * 1.45 * (indexTitle - 1))
		worldTitle.y = startY
		menuPanel:insert(worldTitle)
	end
	
	local titleRectWidth = 600
	local titleRectHeight = 75
	
	local titleRect = display.newGroup()
	titleRect.x = display.contentCenterX
	titleRect.y = display.screenOriginY + titleRectHeight * 0.6
	sceneGroup:insert(titleRect)
	
	local rect = display.newRoundedRect(0, 0, titleRectWidth, titleRectHeight, 10)
	rect.alpha = 0.5
	rect:setFillColor(0)
	titleRect:insert(rect)
	
	titleText = display.newText("Menus para dieta de XXXX Kcal", 0, 0, settings.fontName, 36)
	titleRect:insert(titleText)
	
end

function game:destroy()
end

function game:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if ( phase == "will" ) then
		initialize()
		createUnlockedMenus()
		
	elseif ( phase == "did" ) then

	end
end

function game:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if ( phase == "will" ) then
	    
	elseif ( phase == "did" ) then
		
	end
end
----------------------------------------------- Execution
game:addEventListener( "create", game )
game:addEventListener( "destroy", game )
game:addEventListener( "hide", game )
game:addEventListener( "show", game )

return game