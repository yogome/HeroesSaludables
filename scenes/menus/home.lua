----------------------------------------------- Home
local composer = require( "composer" )
local widget = require( "widget" )
local buttonList = require( "data.buttonlist" )
local database = require( "libs.helpers.database" )
local parentgate = require( "libs.helpers.parentgate" )
local logger = require( "libs.helpers.logger" )
local music = require( "libs.helpers.music" )
local players = require( "models.players" )
local mixpanel = require( "libs.helpers.mixpanel" )

local scene = composer.newScene() 
----------------------------------------------- Variables
local buttonPlay, buttonSettings
local logoGroup, starfieldGroup
local currentPlayer
----------------------------------------------- Constants 
local SIZE_BACKGROUND = 1024
local NUMBER_STARS = 500
local SPEED_STARS = 0.5
--local MARGIN_BUTTON = 20
--local SCALE_LOGO = 1
----------------------------------------------- Functions

local function updateStarField()
	for indexStar = 1, #starfieldGroup.stars do
		
		local currentStar = starfieldGroup.stars[indexStar]
						
		currentStar.x = currentStar.x + (currentStar.x - currentStar.dx) * 0.001
		currentStar.y = currentStar.y + (currentStar.y - currentStar.dy) * 0.001
		currentStar:scale(1.0001, 1.0001)
				
	end
end

local function updateGameLoop()
	updateStarField()
end

local function createBackground(group)
	
	local ratio = display.viewableContentWidth / SIZE_BACKGROUND
	local background = display.newImage("images/backgrounds/space.png")
	background:scale(ratio, ratio)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	group:insert(background)
	
end

local function createLogo(group)
	
	logoGroup = display.newGroup()
	logoGroup.x = display.contentCenterX
	logoGroup.y = display.contentCenterY * 0.75
	
	local logo = display.newImage("images/menus/logo.png")
	logo:scale(0.75, 0.75)
	logoGroup:insert(logo)
	
	group:insert(logoGroup)
end

local function createStarfield(group)
	starfieldGroup = display.newGroup()
	starfieldGroup.stars = {}
	for indexStar = 1, NUMBER_STARS do
		local randomSize = math.random(5, 15)
		local star = display.newCircle(math.random(display.contentWidth * 0.5 * -1, display.contentWidth * 0.5), math.random(display.contentHeight * 0.5 * -1, display.contentHeight * 0.5), randomSize)
		starfieldGroup.stars[indexStar] = star
		starfieldGroup:insert(star)
	end
	starfieldGroup.x = display.contentCenterX
	starfieldGroup.y = display.contentCenterY
	group:insert(starfieldGroup)
end

local function initializeStarField()
	
	local step = 0
	for indexStar = 1, #starfieldGroup.stars do
		
		local currentStar = starfieldGroup.stars[indexStar]
		
		currentStar.dx = math.sin(currentStar.x + step) * display.contentWidth
		currentStar.dy = math.cos(currentStar.y + step) * display.contentHeight
		
		step = step + 50		
	end
	
end

function scene:create(event)
	local sceneGroup = self.view
	
	createBackground(sceneGroup)
	createLogo(sceneGroup)
	createStarfield(sceneGroup)
end

function scene:destroy()
	
end

function scene:show( event )
	local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		
		initializeStarField()
		
	elseif ( phase == "did" ) then
		
		Runtime:addEventListener("enterFrame", updateGameLoop)
		
	end
end

function scene:hide( event )
	local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		--self.disableButtons()
	elseif ( phase == "did" ) then
		--cancelPlayTransition()
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "show", scene )

return scene

