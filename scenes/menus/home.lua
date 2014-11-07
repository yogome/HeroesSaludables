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
local logoGroup, starfieldGroup, asteroidGroup, shineStarGroup
local currentPlayer
----------------------------------------------- Constants 
local SIZE_BACKGROUND = 1024
local NUMBER_STARS = 50
local NUMBER_ASTEROIDS = 3
local SPEED_STARS = 0.5
--local MARGIN_BUTTON = 20
--local SCALE_LOGO = 1
----------------------------------------------- Caches
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

local function updateAsteroids()
	
	for indexAsteroid = 1, NUMBER_ASTEROIDS do
		
		local currentAsteroid = asteroidGroup.asteroids[indexAsteroid]
		
		currentAsteroid.x = currentAsteroid.x + 1
		currentAsteroid.y = currentAsteroid.y + 1
		
		currentAsteroid.rotation = currentAsteroid.rotation + 0.5
		
		if currentAsteroid.x > contentWidth + 50 then
			currentAsteroid.x = display.screenOriginX - 50
		end
		
		if  currentAsteroid.y > contentHeight + 50 then	
			currentAsteroid.y = display.screenOriginY - 50
		end
		
	end
	
end

local function updateStarField()
	for indexStar = 1, #starfieldGroup.stars do
		
		local currentStar = starfieldGroup.stars[indexStar]
		
		local currentX = currentStar.x
		local currentY = currentStar.y
		
		local currentSpeed = currentStar.speed
						
		currentStar.x = currentX + (currentX - currentStar.dx) * currentSpeed
		currentStar.y = currentY + (currentY - currentStar.dy) * currentSpeed
		
		currentStar.xScale = currentStar.xScale + 0.009
		currentStar.yScale = currentStar.yScale + 0.009
		
		local condition1 = currentStar.x > halfContentWidth or currentStar.x < -halfContentWidth
		local condition2 = currentStar.y > halfContentHeight or currentStar.y < -halfContentHeight
		
		if condition1 or condition2 then
			currentStar.x = 0
			currentStar.y = 0
			currentStar.alpha = mathRandom(1,5) * 0.1
			
			currentStar.xScale = 1
			currentStar.yScale = 1
			
			local step = mathRandom(1,360)
			
			local vX = mathSin(step)
			local vY = mathCos(step)
			
			currentStar.x = vX * 30
			currentStar.y = vY * 30
		
			currentStar.dx = vX
			currentStar.dy = vY
		end
				
	end
end

local function updateShineStars(time)
	for indexStar = 1, #shineStarGroup.stars do
		local currentShine = shineStarGroup.stars[indexStar]
		local shineFactor = mathSin((time + (currentShine.shineOffset))  * 0.001)
		
		if shineFactor <= 0 and currentShine.changedPosition then
			shineFactor = 0
			currentShine.changedPosition = false
		else
			currentShine.changedPosition = true
			currentShine.x = math.random(display.screenOriginX, display.contentWidth)
			currentShine.y = math.random(display.screenOriginY, display.contentHeight)
			currentShine.alpha = shineFactor
		end
		
	end
	
end

local function updateGameLoop(event)
	updateAsteroids()
	updateStarField()
	--updateShineStars(event.time)
end

local function createBackground(group)
	
	local ratio = display.viewableContentWidth / SIZE_BACKGROUND
	local background = display.newImage("images/backgrounds/bg2.png")
	background:scale(ratio, ratio)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	group:insert(background)
	
end

local function createLogo(group)
	
	logoGroup = display.newGroup()
	logoGroup.x = display.contentCenterX
	logoGroup.y = display.contentCenterY * 0.75
	
	local logo = display.newImage("images/general/logo.png")
	logo:scale(0.80, 0.80)
	logoGroup:insert(logo)
	
	group:insert(logoGroup)
end

local function initializeStarShine()
	
	for indexStar = 1, #shineStarGroup.stars do
		local currentShine = shineStarGroup.stars[indexStar]
		currentShine.x = math.random(display.screenOriginX, display.contentWidth)
		currentShine.y = math.random(display.screenOriginY, display.contentHeight)
		currentShine.alpha = math.random(1,10) * 0.1
		currentShine.shineOffset = (currentShine.alpha + math.random(1, 10)) * 100000
		currentShine.changedPosition = false
	end
end

local function createStarfield(group)
	starfieldGroup = display.newGroup()
	starfieldGroup.stars = {}
	for indexStar = 1, NUMBER_STARS do
		local randomSize = math.random(1, 3)
		local star = display.newCircle(0,0,randomSize)
		starfieldGroup.stars[indexStar] = star
		starfieldGroup:insert(star)
	end
	starfieldGroup.x = display.contentCenterX
	starfieldGroup.y = display.contentCenterY
	group:insert(starfieldGroup)
end

local function initializeStarField()
	
	for indexStar = 1, #starfieldGroup.stars do
		
		local currentStar = starfieldGroup.stars[indexStar]
		
		local step = (math.pi * 2) / (math.random(1, 1000) / 1000)
		currentStar.speed = math.random(50, 100) * 0.001
		
		currentStar.dx = math.sin(currentStar.x + step) * display.contentWidth
		currentStar.dy = math.cos(currentStar.y + step) * display.contentHeight
		
		local vectorSizeX = (currentStar.x - currentStar.dx)
		local vectorSizeY = (currentStar.y - currentStar.dy)
		
		currentStar.x = currentStar.x + vectorSizeX * math.random(0, math.abs(vectorSizeX)) * currentStar.speed
		currentStar.y = currentStar.y + vectorSizeY * math.random(0, math.abs(vectorSizeY)) * currentStar.speed
	end
end

local function createAsteroids(group)

	asteroidGroup = display.newGroup()
	asteroidGroup.asteroids = {}
	for indexAsteroid = 1, NUMBER_ASTEROIDS do
		local asteroidType = math.random(1, 3)
		local asteroid = display.newImage("images/enviroment/asteroid".. asteroidType ..".png")
		asteroid.x = math.random(display.contentWidth * -0.5, display.contentWidth)
		asteroid.y = math.random(display.contentHeight * -0.5, display.contentHeight)
		
		asteroidGroup.asteroids[indexAsteroid] = asteroid
		asteroidGroup:insert(asteroid)
	end
	
	group:insert(asteroidGroup)
end


local function startGame()
	composer.gotoScene("scenes.menus.selecthero")
end

local function createPlayButton(group)
	
	local buttonData = buttonList.play
	buttonData.onRelease = startGame
	
	buttonPlay = widget.newButton(buttonData)
	buttonPlay:scale(1.5, 1.5)
	buttonPlay.x = display.contentCenterX
	buttonPlay.y = display.contentCenterY * 1.75
	
	group:insert(buttonPlay)
end

local function createShineStars(group)
	shineStarGroup = display.newGroup()
	shineStarGroup.stars = {}
	local totalStars = math.random(3, 6)
	for indexStar = 1, totalStars do
		local star = display.newImage("images/backgrounds/shinestar.png")
		shineStarGroup:insert(star)
		shineStarGroup.stars[indexStar] = star
	end
	group:insert(shineStarGroup)
end

local function enableButtons()
	buttonPlay:setEnabled(true)
end

local function disableButtons()
	buttonPlay:setEnabled(false)
end

function scene:create(event)
	local sceneGroup = self.view
	
	createBackground(sceneGroup)
	createAsteroids(sceneGroup)
	createShineStars(sceneGroup)
	createStarfield(sceneGroup)
	createLogo(sceneGroup)
	createPlayButton(sceneGroup)
end

function scene:destroy()
	
end

function scene:show( event )
	local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		initializeStarField()
		initializeStarShine()
		Runtime:addEventListener("enterFrame", updateGameLoop)
	elseif ( phase == "did" ) then
		music.playTrack(1)
		enableButtons()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
    local phase = event.phase
		
		disableButtons()
		
    if ( phase == "will" ) then
		Runtime:removeEventListener("enterFrame", updateGameLoop)
	elseif ( phase == "did" ) then
		--cancelPlayTransition()
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "show", scene )

return scene

