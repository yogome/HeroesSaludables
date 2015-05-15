local director = require( "libs.helpers.director" )
local sound = require( "libs.helpers.sound" )
local settings = require( "settings" )
local widget = require("widget")
local buttonList = require("data.buttonlist")
local localization = require("libs.helpers.localization")
local settings = require("settings")
local players = require("models.players")
local menudiet = require("services.menudiet")

local game = director.newScene() 
local menuPanel
local titleText
local currentPlayer
local menuIndex
----------------------------------------------- Variables

------------------------------------------------- Constants

------------------------------------------------- Functions
--
local function onTapRecipe(event)
	director.gotoScene("scenes.menus.recipe", {effect = "fade", time = 500, params = {recipeIndex = event.target.index}})
end

local function createUnlockedMenus()
	
	local unlockedMenus = currentPlayer.unlockedMenus
	local startX = -200
	local startY = 0
	menuPanel.icons = {}
	for indexTitle = 1, 3 do
		local lock = display.newImage("images/foodmenu/icon.png")
		lock:scale(0.6,0.6)
		lock.x = startX + (lock.contentWidth * 1.40 * (indexTitle - 1))
		lock.y = startY
		lock.index = indexTitle
		
		if not unlockedMenus[indexTitle] then
			lock:setFillColor(0)
		else
			lock:addEventListener("tap", onTapRecipe)
		end
		
		menuPanel.icons[#menuPanel.icons + 1] = lock
		menuPanel:insert(lock)
	end
end

local function goBackScene()
	director.gotoScene("scenes.menus.home", {effect = "fade", time = 500})
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
	
	local buttonParams = buttonList.back
	buttonParams.onRelease = goBackScene
	
	local buttonBack = widget.newButton(buttonParams)
	buttonBack.x = display.screenOriginX + buttonBack.contentWidth * 0.5
	buttonBack.y = display.screenOriginY + buttonBack.contentHeight * 0.5
	sceneGroup:insert(buttonBack)
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
		for indexIcon = 1, #menuPanel.icons do
			display.remove(menuPanel.icons[indexIcon])
		end
	end
end
----------------------------------------------- Execution
game:addEventListener( "create", game )
game:addEventListener( "destroy", game )
game:addEventListener( "hide", game )
game:addEventListener( "show", game )

return game