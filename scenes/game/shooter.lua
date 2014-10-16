----------------------------------------------- Shooter space game
local composer = require( "composer" )
local widget = require( "widget" )
local buttonList = require( "data.buttonlist" )
local sound = require( "libs.helpers.sound" )
local perspective = require( "libs.helpers.perspective" )
local robot = require( "libs.helpers.robot" )
local spaceships = require( "entities.spaceships" )
local physics = require( "physics" )
local worldsData = require("data.worldsdata")

local scene = composer.newScene() 

--physics.setDrawMode("hybrid")
----------------------------------------------- Variables
local buttonBack 
local camera
local playerCharacter
local dynamicObjects
local analogX, analogY
local analogCircleBegan
local analogCircleMove
----------------------------------------------- Background stars data
local spaceObjects, objectDespawnX, objectSpawnX, objectDespawnY, objectSpawnY
local spawnZoneWidth, spawnZoneHeight, halfSpawnZoneWidth, halfSpawnZoneHeight
-----------------------------------------------

local backgroundGroup
-----------------------------------------------Vars used by level loader
local levelBackground
local levelSize
local levelSpaceshipPosition
local levelPlanets

-----------------------------------------------Temporal vars
local current_level = 1
----------------------------------------------- Constants
local padding = 16
local SIZE_BACKGROUND = 1024
local OBJECTS_TOLERANCE_X = 100
local OBJECTS_TOLERANCE_Y = 100
local STARS_LAYER_DEPTH_RATIO = 0.08
local STARS_PER_LAYER = 20
local STARS_LAYERS = 6

local BOUNDARY_SIZE = 200
----------------------------------------------- Functions
--

local function updateParallax()
	if spaceObjects then
		for index = 1, #spaceObjects do
			local object = spaceObjects[index]
			object.x = (object.xOffset + camera.scrollX * object.xVelocity) % spawnZoneWidth - halfSpawnZoneWidth
			object.y = (object.yOffset + camera.scrollY * object.xVelocity) % spawnZoneHeight - halfSpawnZoneHeight
		end
	end
end


local function createBackground(sceneGroup)
	backgroundGroup = display.newGroup()
	
	local dynamicScale = display.viewableContentWidth / SIZE_BACKGROUND
    local backgroundContainer = display.newContainer(display.viewableContentWidth + 2, display.viewableContentHeight + 2)
    backgroundContainer.x = display.contentCenterX
    backgroundContainer.y = display.contentCenterY
    sceneGroup:insert(backgroundContainer)
    
    local background = display.newImage("images/backgrounds/space.png", true)
    background.xScale = dynamicScale
    background.yScale = dynamicScale
	--background.fill.effect = "filter.monotone"
	--background.fill.effect.r, background.fill.effect.g, background.fill.effect.b = unpack(COLOR_BACKGROUND)
    backgroundContainer:insert(background)
	
	local containerHalfWidth = backgroundContainer.width * 0.5
	local containerHalfHeight = backgroundContainer.height * 0.5
	
	spaceObjects = {}
	
	objectDespawnX = containerHalfWidth + OBJECTS_TOLERANCE_X
	objectSpawnX = -containerHalfWidth - OBJECTS_TOLERANCE_X
	
	objectDespawnY = containerHalfHeight + OBJECTS_TOLERANCE_Y
	objectSpawnY = -containerHalfHeight - OBJECTS_TOLERANCE_Y
	
	spawnZoneWidth = -objectSpawnX + objectDespawnX
	spawnZoneHeight = -objectSpawnY + objectDespawnY
	halfSpawnZoneWidth = spawnZoneWidth * 0.5
	halfSpawnZoneHeight = spawnZoneHeight * 0.5
	
	for layerIndex = 1, STARS_LAYERS do
		local starLayer = display.newGroup()
		backgroundContainer:insert(starLayer)
		for starsIndex = 1, STARS_PER_LAYER do
			local scale =  0.05 + layerIndex * 0.04
			
			local randomStarIndex = math.random(1,3)
			local star
			if randomStarIndex == 1 then
				star = display.newCircle(500, 0, 20)
			elseif randomStarIndex == 2 then
				star = display.newImage("images/backgrounds/star01.png")
			elseif randomStarIndex == 3 then
				star = display.newImage("images/backgrounds/star02.png")
			end
			
			star.xOffset = math.random(objectSpawnX, objectDespawnX)
			star.yOffset = math.random(objectSpawnY, objectDespawnY)
			star.y = math.random(-containerHalfHeight, containerHalfHeight)
			star.xScale = scale
			star.yScale = scale
			star.xVelocity = STARS_LAYER_DEPTH_RATIO * layerIndex
			starLayer:insert(star)
			
			spaceObjects[#spaceObjects + 1] = star
		end
	end
	
	
	backgroundGroup:insert(backgroundContainer)
end

local function onReleasedBack()
	composer.gotoScene( "scenes.menus.map", { effect = "fade", time = 800, } )
end 

local function addDynamicObject(object)
	dynamicObjects[#dynamicObjects + 1] = object
end

local function testTouch(event)
	if "began" == event.phase then
		analogCircleBegan.x = event.x
		analogCircleBegan.y = event.y
		analogCircleMove.x = event.x
		analogCircleMove.y = event.y
		analogCircleBegan.isVisible = true
		analogCircleMove.isVisible = true
	elseif "moved" == event.phase then
		analogX = event.x - event.xStart 
		analogY = event.y - event.yStart
		analogCircleMove.x = event.x
		analogCircleMove.y = event.y
	elseif "ended" == event.phase then
		analogX = 0
		analogY = 0
		analogCircleBegan.isVisible = false
		analogCircleMove.isVisible = false
	end	
end

local function createrBorders(level, world)
	
	local levelData = worldsData[level][world]
	local levelWidth = levelData.levelWidth
	local levelHeight = levelData.levelHeight
	
	local wallPositionX 
	local wallPositionY
	
	wallPositionX = (levelWidth * 0.5 * -1) - (BOUNDARY_SIZE * 0.5)
	wallPositionY = 0
	local leftWall = display.newRect(wallPositionX, wallPositionY, BOUNDARY_SIZE, levelHeight)
	physics.addBody( leftWall, {density = 1.0, friction = 0.1, bounce = 0.5})
	--testRect1:setFillColor(1,1,0)
	leftWall.bodyType = "static"
	camera:add(leftWall)
	
	
	wallPositionX = (levelWidth * 0.5) + (BOUNDARY_SIZE * 0.5)
	wallPositionY = 0
	local rightWall = display.newRect(wallPositionX, wallPositionY ,BOUNDARY_SIZE, levelHeight)
	physics.addBody( rightWall, {density = 1.0, friction = 0.1, bounce = 0.5})
	--testRect2:setFillColor(1,1,0)
	rightWall.bodyType = "static"
	camera:add(rightWall)
	
	wallPositionX = 0
	wallPositionY = (levelHeight * 0.5 * -1) - (BOUNDARY_SIZE * 0.5)
	local bottomWall = display.newRect(wallPositionX, wallPositionY, levelWidth, BOUNDARY_SIZE)
	physics.addBody( bottomWall, {density = 1.0, friction = 0.1, bounce = 0.5})
	--testRect3:setFillColor(1,1,0)
	bottomWall.bodyType = "static"
	camera:add(bottomWall)
	
	wallPositionX = 0
	wallPositionY = (levelHeight * 0.5) + (BOUNDARY_SIZE * 0.5)
	local topWall = display.newRect(wallPositionX, wallPositionY, levelWidth, BOUNDARY_SIZE)
	physics.addBody( topWall, {density = 1.0, friction = 0.1, bounce = 0.5})
	--testRect4:setFillColor(1,1,0)
	topWall.bodyType = "static"
	camera:add(topWall)
	
	addDynamicObject(leftWall)
	addDynamicObject(rightWall)
	addDynamicObject(bottomWall)
	addDynamicObject(topWall)
end

local function createTestCubes()
	local testRect1 = display.newRect(-300,0,300,100)
	physics.addBody( testRect1, {density = 1.0, friction = 0.3, bounce = 0.2})
	testRect1:setFillColor(1,0,0)
	testRect1.gravityScale = 0
	camera:add(testRect1)
	
	addDynamicObject(testRect1)
	
	for indexA = 1, 8 do
		for indexB = 1, 5 do
			local testRect = display.newRect(-300 + 50 * indexA, -400 + 50 * indexB,40,40)
			physics.addBody( testRect, {density = 1.0, friction = 0.3, bounce = 0.2})
			testRect:setFillColor(1,0.5,0)
			testRect.gravityScale = 0
			camera:add(testRect)
			
			addDynamicObject(testRect)
		end
	end
end

local function createEnemy()
	for index = 1, 4 do
		local shipData = {

		}
		local enemy = spaceships.new(shipData)
		enemy.y = 200
		enemy.x = -200 + 100 * index
		camera:add(enemy)

		addDynamicObject(enemy)
	end
end

local function setUpCamera()
	
	local levelData = worldsData[1][1]
	local levelWidth = levelData.levelWidth
	local levelHeight = levelData.levelHeight
	
	camera = perspective.newCamera()
	--camera:setBounds((levelWidth * 0.35 * -1), (levelWidth * 0.35), levelHeight * 0.35 * -1, levelHeight * 0.35)
	camera:setBounds(false)
end

local function createPlayerCharacter()
	local shipData = {
	
	}
	playerCharacter = spaceships.new(shipData)
	playerCharacter.x = -1500
	playerCharacter.y = -700
	camera:add(playerCharacter)
	
	addDynamicObject(playerCharacter)
end

local function enterFrame()
	local velocityX, velocityY = playerCharacter:getLinearVelocity()
	if analogX and analogY then
		playerCharacter:analog(analogX, analogY)
	end
end

local function loadEarth(world, level)
	local earthData = worldsData[world][level].earth
	local earth = display.newImage(earthData.asset)
	
	earth.x = earthData.position.x
	earth.y = earthData.position.y
	
	camera:add(earth)
end

local function loadPlanets(world, level)
	local planets = {}
	local planetsData = worldsData[world][level].planets
	
	for planetIndex = 1, #planetsData do
		local currentPlanet = planetsData[planetIndex]
		local planet = display.newImage(currentPlanet.asset)
		planet.x = currentPlanet.position.x
		planet.y = currentPlanet.position.y
		planets[planetIndex] = planet
		camera:add(planet)
	end
end

local function loadAsteroids(world, level)
	local asteroidData = worldsData[world][level].asteroids
	
	for indexAsteroidLine = 1, #asteroidData do
		local currentAsteroidLine = asteroidData[indexAsteroidLine]
		local x1 = currentAsteroidLine.lineStart.x
		local x2 = currentAsteroidLine.lineEnd.x
		local y1 = currentAsteroidLine.lineStart.y
		local y2 = currentAsteroidLine.lineEnd.y
		
		local asteroidsPerLine = math.sqrt((x1 - x2)*(x1 - x2) + (y1 - y2 )*(y1 - y2 ))/60
		local asteroidStepX = math.abs(x1 - x2) / asteroidsPerLine
		local asteroidStepY = math.abs(y1 - y2)/ asteroidsPerLine
		local asteroidStartX = x1
		local asteroidStartY = y1
		
		for indexAsteroid = 1, asteroidsPerLine do
			local asteroid = display.newImage("images/enviroment/asteroid.png")
			asteroid.rotation = math.random(0, 350)
			
			asteroid.x = asteroidStartX
			asteroid.y = asteroidStartY
			
			asteroidStartX = asteroidStartX + asteroidStepX
			asteroidStartY = asteroidStartY - asteroidStepY
			
			physics.addBody(asteroid, {density = 1000, friction = 10, bounce = 0.5})
			asteroid.gravityScale = 0
			asteroid.bodyType = "static"
			camera:add(asteroid)
		end
		
	end
	
end

local function loadLevel()
	loadEarth(1,1)
	loadPlanets(1, current_level)
	loadAsteroids(1,1)
end
----------------------------------------------- Class functions 
function scene.backAction()
	robot.press(buttonBack)
	return true
end  

function scene.enableButtons()
	buttonBack:setEnabled(true)
end

function scene.disableButtons()
	buttonBack:setEnabled(false)
end

function scene:createGame()
	system.activate("multitouch")
	Runtime:addEventListener("touch", testTouch)
	Runtime:addEventListener("enterFrame", enterFrame)
	
	physics.setPositionIterations(1)
	physics.setVelocityIterations(1)
	physics.start()
	physics.setContinuous(false)
	physics.setGravity(0, 10)
	
	dynamicObjects = {}
	
	loadLevel()
	
	createPlayerCharacter()
	--createEnemy()
	--createTestCubes()
	createrBorders(1, 1)
	
	spaceships.start()
	camera:setFocus(playerCharacter)
	camera:start()
end

function scene:destroyGame()
	system.deactivate("multitouch")
	physics.pause()
	sound.stopPitch()
	Runtime:removeEventListener("touch", testTouch)
	Runtime:removeEventListener("enterFrame", enterFrame)
	camera:stop()
	
	for index = #dynamicObjects, 1, -1 do
		display.remove(dynamicObjects[index])
		dynamicObjects[index] = nil
	end
	dynamicObjects = nil
	
	spaceships.stop()
	physics.stop()
end

function scene:create(event)
	local sceneGroup = self.view

	createBackground(sceneGroup)
	sceneGroup:insert(backgroundGroup)
	
	setUpCamera()
	sceneGroup:insert(camera)
	
	buttonList.back.onRelease = onReleasedBack
	buttonBack = widget.newButton(buttonList.back)
	buttonBack.x = display.screenOriginX + 64 + padding
	buttonBack.y = display.screenOriginY + 64 + padding
	sceneGroup:insert(buttonBack)
	
	analogCircleBegan = display.newCircle(0, 0, 30)
	analogCircleBegan.alpha = 0.2
	analogCircleBegan.isVisible = false
	sceneGroup:insert(analogCircleBegan)
	
	analogCircleMove = display.newCircle(0, 0, 30)
	analogCircleMove.alpha = 0.2
	analogCircleMove.isVisible = false
	sceneGroup:insert(analogCircleMove)
	
end

function scene:destroy()
	
end

function scene:show( event )
	local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		
		Runtime:addEventListener("enterFrame", updateParallax)
		self:createGame()
		self.disableButtons()
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
		self:destroyGame()
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "show", scene )

return scene