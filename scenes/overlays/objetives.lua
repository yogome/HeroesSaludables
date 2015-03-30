local director = require( "libs.helpers.director" )
local buttonList = require("data.buttonlist")
local widget = require("widget")
local settings = require("settings")
local foodlist = require("data.foodlist")

----------------------------Variables
local scene = director.newScene()
local okButton
local objetivesGroup
local panelGroup

----------------------------Constants
local NUMBER_TIPS = 13
-- -------------------------------------------------------------------------------

local function closeOverlay(event, parent)
	event.target:setEnabled(false)
	transition.to(scene.view, {alpha = 0, time = 500, onComplete = function()
		parent:introGame()
	end})
end

local function showObjetives(objetives)
	
	objetivesGroup = display.newGroup()
	
	if objetives then
		local xOffset = 50
		local counter = 0
		for key, value in pairs(objetives) do
			local currentFood = foodlist[key].asset
			local food = display.newImage(currentFood)
			food:scale(0.5,0.5)
			
			local startOffset = (food.contentWidth + xOffset) * counter
			
			food.x = startOffset
			food.y = 0
			objetivesGroup:insert(food)
			
			local objetiveName = display.newText(foodlist[key].name, startOffset, food.contentHeight * -0.60, settings.fontName, 25)
			objetivesGroup:insert(objetiveName)
			
			local objetiveText = display.newText(objetives[key].portions, startOffset, food.contentHeight * 0.75, settings.fontName, 58)
			objetivesGroup:insert(objetiveText)
			counter = counter + 1
		end
	end
	
	objetivesGroup.anchorX = 0
	objetivesGroup.anchorChildren = true
	objetivesGroup.x = -(objetivesGroup.contentWidth * 0.5)
	objetivesGroup.y = panelGroup.contentHeight * 0.1
	panelGroup:insert(objetivesGroup)
	
end

------------------------------Module functions
function scene:create( event )

    local sceneGroup = self.view
	
	local parent = event.parent
	panelGroup = display.newGroup()
	
	local background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	background:setFillColor(0, 0.8)
	sceneGroup:insert(background)
	
	local backgroundPanel = display.newImage("images/infoscreen/objetivos.png")
	panelGroup:insert(backgroundPanel)
	
	local objetiveText = display.newText("Objetivos", 0, 0, settings.fontName, 56)
	objetiveText.y = backgroundPanel.contentHeight * -0.32
	panelGroup:insert(objetiveText)
	
	local textParams = {
		text = "Recolecta las siguientes porciones",
		font = settings.fontName,
		fontSize = 38,
		width = backgroundPanel.contentWidth * 0.8,
		align = "center",
		x =  backgroundPanel.contentWidth * 0.02,
		y = backgroundPanel.contentHeight * -0.13,
	}
	
	local descriptionText = display.newEmbossedText(textParams)
	panelGroup:insert(descriptionText)
	
	panelGroup.x = display.contentCenterX
	panelGroup.y = display.contentCenterY
	sceneGroup:insert(panelGroup)
	
	buttonList.ok.onRelease = function(event)
		closeOverlay(event, parent)
	end
		
	okButton = widget.newButton(buttonList.ok)
	okButton.x = 0
	okButton.y = panelGroup.contentHeight * 0.4
	
	panelGroup:insert(okButton)
end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
	
	local params = event.params or {}
	
    if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		okButton:setEnabled(true)
		local objetives = params.objetives
		showObjetives(objetives)
    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
	elseif ( phase == "did" ) then
		display.remove(objetivesGroup)
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
