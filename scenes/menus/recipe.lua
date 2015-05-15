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
local recipeData
local desayunoText, refrigerioText, comidaText, colacionText, cenaText, headerMenu
----------------------------------------------- Variables

------------------------------------------------- Constants
local NUMBER_COLUMNS = 5
------------------------------------------------- Functions

local function goBackScene()
	director.gotoScene("scenes.menus.foodmenu", {effect = "fade", time = 500})
end

local function initialize(params)
	currentPlayer = players.getCurrent()
	
	local recipeIndex = params.recipeIndex
	local calories = currentPlayer.playerCalories
	
	recipeData = menudiet.getMenu(calories)
	
	desayunoText.text = recipeData[recipeIndex].desayuno
	refrigerioText.text = recipeData[recipeIndex].refrigerio
	comidaText.text = recipeData[recipeIndex].comida
	colacionText.text = recipeData[recipeIndex].colacion
	cenaText.text = recipeData[recipeIndex].cena
	
	headerMenu.text = "Menús de dieta para "..calories.." kcal, aprox."
	
end

------------------------------------------------Module functions

function game:create(event)
	local sceneGroup = self.view
	
	local scale = display.contentWidth / 1024
	local background = display.newImage("images/menus/background.png")
	background:scale(scale, scale)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)
	
	menuPanel = display.newGroup()
	menuPanel.x = display.contentCenterX
	menuPanel.y = display.contentCenterY
	sceneGroup:insert(menuPanel)
	
	local panel = display.newImage("images/menus/menu.png")
	menuPanel:insert(panel)
	
	local textOptions = {
		text = "DESAYUNO",
		font = settings.fontName,
		fontSize = 15,
		align = "left",
		width = 150,
	}
	
	desayunoText = display.newText(textOptions)
	desayunoText:setFillColor(0)
	desayunoText.x = -435
	desayunoText.y = -115
	desayunoText.anchorX = 0
	desayunoText.anchorY = 0
	menuPanel:insert(desayunoText)
	
	local textOptions = {
		text = "HEADER",
		font = settings.fontName,
		fontSize = 38,
		align = "left",
	}
	
	headerMenu = display.newText(textOptions)
	headerMenu:setFillColor(1)
	headerMenu.y = -190
	menuPanel:insert(headerMenu)
	
	local textOptions = {
		text = "REFIGERIO",
		font = settings.fontName,
		fontSize = 15,
		align = "left",
		width = 150,
	}
	
	refrigerioText = display.newText(textOptions)
	refrigerioText:setFillColor(0)
	refrigerioText.x = -250
	refrigerioText.y = -115
	refrigerioText.anchorX = 0
	refrigerioText.anchorY = 0
	menuPanel:insert(refrigerioText)
	
	local textOptions = {
		text = "COMIDA",
		font = settings.fontName,
		fontSize = 15,
		align = "left",
		width = 150,
	}
	
	comidaText = display.newText(textOptions)
	comidaText:setFillColor(0)
	comidaText.x = -75
	comidaText.y = -115
	comidaText.anchorX = 0
	comidaText.anchorY = 0
	menuPanel:insert(comidaText)
	
	
	local textOptions = {
		text = "COLACION",
		font = settings.fontName,
		fontSize = 15,
		align = "left",
		width = 150,
	}
	
	colacionText = display.newText(textOptions)
	colacionText:setFillColor(0)
	colacionText.x = 105
	colacionText.y = -115
	colacionText.anchorX = 0
	colacionText.anchorY = 0
	menuPanel:insert(colacionText)
	
		local textOptions = {
		text = "CENA",
		font = settings.fontName,
		fontSize = 15,
		align = "left",
		width = 150,
	}
	
	cenaText = display.newText(textOptions)
	cenaText:setFillColor(0)
	cenaText.x = 285
	cenaText.y = -115
	cenaText.anchorX = 0
	cenaText.anchorY = 0
	menuPanel:insert(cenaText)
	
	
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
	local params = event.params
	
	if ( phase == "will" ) then
		initialize(params)
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