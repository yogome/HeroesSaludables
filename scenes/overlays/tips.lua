local composer = require( "composer" )
local buttonList = require("data.buttonlist")
local widget = require("widget")

local scene = composer.newScene()
local tipGroup
local previousTip
local nextScene

local NUMBER_TIPS = 13
-- -------------------------------------------------------------------------------

local function closeOverlay()
	transition.to(scene.view, {alpha = 0, time = 500, onComplete = function()
		composer.gotoScene(nextScene, {effect = "fade", time = 300})
	end})
end

function scene:create( event )

    local sceneGroup = self.view
	
	previousTip = 1
	local tipbg = display.newImage("images/backgrounds/tips.png")
	tipbg.x = display.contentCenterX
	tipbg.y = display.contentCenterY
	tipbg.width = display.contentWidth
	tipbg.height = display.contentHeight
	sceneGroup:insert(tipbg)
	
	tipGroup = display.newGroup()
	sceneGroup:insert(tipGroup)
	
	buttonList.ok.onRelease = closeOverlay
	local okButton = widget.newButton(buttonList.ok)
	okButton.x = display.contentCenterX
	okButton.y = display.contentCenterY * 1.80
	
	sceneGroup:insert(okButton)
end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
	
	nextScene = event.params.nextScene or "scenes.menus.home"
	
    if ( phase == "will" ) then
		
		local randomTip = math.random(1, NUMBER_TIPS)
		
		if randomTip == previousTip then 
			randomTip = math.random(1, NUMBER_TIPS)
		end
		
		previousTip = randomTip
		
		local tip = display.newImage("images/tips/tips-".. randomTip ..".png")
		
		tip.height = display.contentHeight
		tip.x = display.contentCenterX
		tip.y = display.contentCenterY

		tipGroup:insert(tip)
		
	elseif ( phase == "did" ) then
	
    end
end


function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
    end
end


function scene:destroy( event )

    local sceneGroup = self.view
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
