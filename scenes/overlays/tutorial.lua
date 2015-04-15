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
local animationGroup

----------------------------Constants
local NUMBER_TIPS = 13
-- -------------------------------------------------------------------------------

local function closeOverlay(event, parent)
	event.target:setEnabled(false)
	parent:pause(false)
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

local function getAnimation(id)
	
	local animationData = {
		[1] = {	
			asset = "images/tutorialanimation/tutorial1.png",
		},
		[2] = {	
			asset = "images/tutorialanimation/tutorial2.png",
		},
		[3] = {	
			asset = "images/tutorialanimation/tutorial3.png",
		},
		[4] = {	
			asset = "images/tutorialanimation/tutorial4.png",
		}
	}
	
	local animationGroup = display.newGroup()
	if animationData[id] then
		
		local optionsSheet = {
			width = 256,
			height = 256,
			
			numFrames = 64,
			sheeContentWidth = 2048,
			sheetContentHeight  = 2048,
		}
		
		local spriteInfo = graphics.newImageSheet(animationData[id].asset, optionsSheet)
		
		local spriteOptions = {
			name = "tutorial",
			start = 1,
			count = 64,
			time = 2000,
		}
		
		local spriteSheet = display.newSprite(spriteInfo, spriteOptions)
		animationGroup:insert(spriteSheet)
		animationGroup.sprite = spriteSheet
		
		return animationGroup
	else 
		return nil
	end
	
	
end

local function createTutorialScreen(data, parent)
	
	local tutorialTitle = data.name
	local tutorialDescription = data.description[1]
		
	panelGroup.title.text = tutorialTitle
	panelGroup.description.text = tutorialDescription
	
	animationGroup = getAnimation(data.animationId)
	if animationGroup then
		animationGroup.x = panelGroup.contentWidth * -0.20
		animationGroup.sprite:play()
		panelGroup:insert(animationGroup)
	end
	
	buttonList.ok.onRelease = function(event)
		closeOverlay(event, parent)
	end
	
	okButton = widget.newButton(buttonList.ok)
	okButton.x = 0
	okButton.y = panelGroup.contentHeight * 0.4
	
	panelGroup:insert(okButton)
	
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
end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
	
	local parent = event.parent
	local params = event.params or {}
	
    if ( phase == "will" ) then
		
	elseif ( phase == "did" ) then
		local data = params.data
		sceneGroup.alpha = 0
		createTutorialScreen(data, parent)
		transition.to(sceneGroup, {alpha = 1, time = 200})
    end
end

function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
	elseif ( phase == "did" ) then
		display.remove(animationGroup)
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
