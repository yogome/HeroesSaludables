local director = require( "libs.helpers.director" )
local buttonList = require("data.buttonlist")
local widget = require("widget")


----------------------------Variables
local scene = director.newScene()
local tipGroup, tip
local previousTip
local nextScene
local worldIndex, levelIndex
local okButton

----------------------------Constants
local NUMBER_TIPS = 204
-- -------------------------------------------------------------------------------

local function closeOverlay(event)
	event.target:setEnabled(false)
	transition.to(scene.view, {alpha = 0, time = 500, onComplete = function()
		director.gotoScene(nextScene, {effect = "fade", time = 500, params = {worldIndex = worldIndex, levelIndex = levelIndex}})
	end})
end

local function showTip()
	local randomTip = math.random(NUMBER_TIPS)
		
	while randomTip == previousTip do 
		randomTip = math.random(NUMBER_TIPS)
	end

	previousTip = randomTip

	tip = display.newImage("images/tips/tipsphase1/".. randomTip ..".png")

	okButton:setEnabled(true)
	tip.height = display.contentHeight
	tip.x = display.contentCenterX
	tip.y = display.contentCenterY

	tipGroup:insert(tip)
end
------------------------------Module functions
function scene:create( event )

    local sceneGroup = self.view
	
	previousTip = 1
	local tipbg = display.newImage("images/backgrounds/tips.png")
	tipbg.x = display.contentCenterX
	tipbg.y = display.contentCenterY
	tipbg.width = display.contentWidth
	tipbg.height = display.contentHeight
	sceneGroup:insert(tipbg)
	
	local logoProfeco = display.newImage("images/profeco_02.png")
	logoProfeco:scale(0.7, 0.7)
	logoProfeco.x = display.screenOriginX + logoProfeco.contentWidth * 0.6
	logoProfeco.y = display.screenOriginY + logoProfeco.contentHeight * 0.6
	sceneGroup:insert(logoProfeco)
	
	tipGroup = display.newGroup()
	sceneGroup:insert(tipGroup)
	
	buttonList.ok.onRelease = closeOverlay
	okButton = widget.newButton(buttonList.ok)
	okButton.x = display.screenOriginX + display.viewableContentWidth - 100
	okButton.y = display.screenOriginY + display.viewableContentHeight - 100
	
	sceneGroup:insert(okButton)
end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
	
	local params = event.params or {}
	worldIndex = params.worldIndex
	levelIndex = params.levelIndex
	nextScene = event.params.nextScene or "scenes.menus.loading"
	
    if ( phase == "will" ) then
		showTip()
	elseif ( phase == "did" ) then
	
    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
	elseif ( phase == "did" ) then
		display.remove(tip)
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
