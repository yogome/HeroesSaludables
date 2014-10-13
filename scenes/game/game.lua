----------------------------------------------- Game
local composer = require( "composer" )


local scene = composer.newScene() 
----------------------------------------------- Variables
local worldIndex, levelIndex 
----------------------------------------------- Constants 
----------------------------------------------- Functions
local function buildLevel()
	
end
	
local function destroyLevel()
	
end

local function initialize(parameters)
	worldIndex = parameters.worldIndex or 1
	levelIndex = parameters.levelIndex or 1
end
----------------------------------------------- Class functions 
function scene.enableButtons()
	
end

function scene.disableButtons()
	
end

function scene:create(event)
	local sceneGroup = self.view

end

function scene:destroy()
	
end

function scene:show( event )
	local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		self.disableButtons()
		initialize(event.params)
		buildLevel()
	elseif ( phase == "did" ) then
		self.enableButtons()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		self.disableButtons()
	elseif ( phase == "did" ) then
		destroyLevel()
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "show", scene )

return scene



