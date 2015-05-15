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


local function initialize()
	
	
end

function game:create(event)
	local sceneGroup = self.view
	
	local scale = display.contentWidth / 1024
	local background = display.newImage("images/infoscreen/Background.png")
	background:scale(scale, scale)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)

end

function game:destroy()
end

function game:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if ( phase == "will" ) then
		initialize()
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