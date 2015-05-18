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
local bubble
local worldIndex, levelIndex
----------------------------------------------- Variables

------------------------------------------------- Constants

------------------------------------------------- Functions
--
local bubbles = {
	[1] = "images/loading/burbuja01.png",
	[2] = "images/loading/burbuja02.png",
	[3] = "images/loading/burbuja03.png",
}

local function animateBubble(sceneGroup, options)
	
	local randomIndex = math.random(1, #bubbles)
	bubble = display.newImage(bubbles[randomIndex])
	bubble:scale(0.5, 0.5)
	bubble.x = display.screenOriginX - bubble.contentWidth
	bubble.y = display.contentCenterY
	sceneGroup:insert(bubble)
	
	transition.to(bubble, {tag = "rotate", time = 2000, x = display.contentWidth})
	transition.to(bubble, {tag = "rotate", time = 2000, y = display.contentHeight - 100, transition = easing.outBounce})
	transition.to(bubble, {tag = "rotate", rotation = 360, iterations = -1})
	transition.to(bubble, {tag = "rotate", delay = 1500, time = 500, alpha = 0, onComplete = function()
		director.removeHidden(true)
		director.gotoScene("scenes.game.shooter", {params = {worldIndex = worldIndex, levelIndex = levelIndex}})
	end})
	
end

function game:create(event)
	local sceneGroup = self.view
	
	local scale = display.contentWidth / 1024
	local background = display.newImage("images/infoscreen/Background.png")
	background:scale(scale, scale)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)
	
	local ship = display.newImage("images/loading/nave.png")
	ship.x = display.contentCenterX
	ship.y = display.contentCenterY * 0.8
	sceneGroup:insert(ship)
	
	local loadingText = display.newText("Preparando viaje...", display.contentCenterX, display.contentCenterY * 1.45, settings.fontName, 50)
	sceneGroup:insert(loadingText)
	
end

function game.setLevel(world, level)
	worldIndex = world
	levelIndex = level
end

function game:destroy()
end

function game:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	local params = event.params
	
	if ( phase == "will" ) then
		animateBubble(sceneGroup)
	elseif ( phase == "did" ) then
		
	end
end

function game:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if ( phase == "will" ) then
	    
	elseif ( phase == "did" ) then
		transition.cancel("rotate")
		display.remove(bubble)
	end
end
----------------------------------------------- Execution
game:addEventListener( "create", game )
game:addEventListener( "destroy", game )
game:addEventListener( "hide", game )
game:addEventListener( "show", game )

return game