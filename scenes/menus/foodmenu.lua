local director = require( "libs.helpers.director" )
local sound = require( "libs.helpers.sound" )
local settings = require( "settings" )
local widget = require("widget")
local buttonList = require("data.buttonlist")
local localization = require("libs.helpers.localization")
local settings = require("settings")

local game = director.newScene() 
----------------------------------------------- Variables

------------------------------------------------- Constants

------------------------------------------------- Functions

function game:create(event)
	local sceneGroup = self.view
	
	local scale = display.contentWidth / 1024
	local background = display.newImage("images/infoscreen/Background.png")
	background:scale(scale, scale)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)
	
	local menuPanel = display.newGroup()
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
	
	
end

function game:destroy()
end

function game:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if ( phase == "will" ) then
	    
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