----------------------------------------------- Home
local director = require( "libs.helpers.director" )


local sound = require( "libs.helpers.sound" )
local music = require( "libs.helpers.music" )

local scene = director.newScene() 
----------------------------------------------- Variables

----------------------------------------------- Constants 

----------------------------------------------- Caches

local mRandom = math.random 
local doublePi = math.pi * 2
local mathRandom = math.random
local mathSin = math.sin
local mathCos = math.cos
local mathAbs = math.abs

local contentWidth = display.contentWidth
local contentHeight = display.contentHeight

local halfContentWidth = contentWidth * 0.5
local halfContentHeight = contentHeight * 0.5
----------------------------------------------- Functions
function scene:create(event)
	local sceneGroup = self.view
	
end

function scene:destroy()
	
end

function scene:show( event )
	local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
	
	elseif ( phase == "did" ) then
		music.playTrack(1)
	
	end
end

function scene:hide( event )
	local sceneGroup = self.view
    local phase = event.phase
		
		
    if ( phase == "will" ) then
		
	elseif ( phase == "did" ) then
		
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "show", scene )

return scene

