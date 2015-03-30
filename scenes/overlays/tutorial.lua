local director = require( "libs.helpers.director" )
local buttonList = require("data.buttonlist")
local widget = require("widget")
local settings = require("settings")
local tutorialAnimation = require("services.tutorial")
local tutorialData = require("data.tutorialdata")

----------------------------Variables
local scene = director.newScene()
local okButton
local panelGroup

----------------------------Constants
local NUMBER_TIPS = 13
-- -------------------------------------------------------------------------------

local function closeOverlay(event, parent)
	event.target:setEnabled(false)
	transition.to(scene.view, {alpha = 0, time = 500, onComplete = function()
		director.hideOverlay()
	end})
end

local function searchTutorialName(tutorialName)
	
	local searchIndex = nil
	for indexTutorial = 1, #tutorialData do
		local currentTutorial = tutorialData[indexTutorial]
		if currentTutorial.id == tutorialName then
			searchIndex = indexTutorial
			break
		end
	end
	
	return searchIndex
end

local function createTutorialScreen(tutorialName)
	
	local indexTutorial = searchTutorialName(tutorialName)
	local tutorialTitle = tutorialData[indexTutorial].name
	local tutorialDescription = tutorialData[indexTutorial].description[1]
		
	panelGroup.title.text = tutorialTitle
	panelGroup.description.text = tutorialDescription
	
end

------------------------------Module functions
function scene:create( event )

    local sceneGroup = self.view
	
	local parent = event.parent
	panelGroup = display.newGroup()
	
	local background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	background:setFillColor(0, 0.8)
	sceneGroup:insert(background)
	
	local backgroundPanel = display.newImage("images/infoscreen/tutorial.png")
	panelGroup:insert(backgroundPanel)
	
	local textParams = {
		text = "[Tutorial Title]",
		font = settings.fontName,
		fontSize = 34,
		width = backgroundPanel.contentWidth * 0.3,
		align = "left",
		x =  backgroundPanel.contentWidth * 0.2,
		y = backgroundPanel.contentHeight * -0.23,
	}
	
	local objetiveText = display.newEmbossedText(textParams)
	panelGroup.title = objetiveText
	panelGroup:insert(objetiveText)
	
	textParams = {
		text = "[Tutorial Description]",
		font = settings.fontName,
		fontSize = 28,
		width = backgroundPanel.contentWidth * 0.3,
		align = "left",
		x =  backgroundPanel.contentWidth * 0.2,
		y = backgroundPanel.contentHeight * -0.15,
	}
	
	local descriptionText = display.newEmbossedText(textParams)
	descriptionText.anchorY = 0
	panelGroup.description = descriptionText
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
		local tutorialToShow = params.tutorialName
		createTutorialScreen(tutorialToShow)
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
