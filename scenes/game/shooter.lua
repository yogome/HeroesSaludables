----------------------------------------------- Shooter space game
local composer = require( "composer" )
local widget = require( "widget" )
local settings = require("settings")
local buttonList = require( "data.buttonlist" )
local sound = require( "libs.helpers.sound" )
local perspective = require( "libs.helpers.perspective" )
local robot = require( "libs.helpers.robot" )
local spaceships = require( "entities.spaceships" )
local physics = require( "physics" )
local worldsData = require("data.worldsdata")
local foodlist = require("data.foodlist")
local enemy = require("entities.enemies")

local scene = composer.newScene() 
----------------------------------------------- Variables
local buttonBack 
local camera
local playerCharacter
local physicsObjectList
local analogX, analogY
local analogCircleBegan
local analogCircleMove

local worldIndex, levelIndex
----------------------------------------------- Background stars data
local spaceObjects, objectDespawnX, objectSpawnX, objectDespawnY, objectSpawnY
local spawnZoneWidth, spawnZoneHeight, halfSpawnZoneWidth, halfSpawnZoneHeight
-----------------------------------------------

local backgroundGroup
local foodBubbleGroup
local enemies
local isFruitSpawned, isVegetableSpawned, isProteinSpawned
local totalCollectedFruits, totalCollectedVegetables, totalCollectedProteins
-----------------------------------------------Vars used by level loader
local levelBackground
local levelSize
local levelSpaceshipPosition
local levelPlanets

local debugText
-----------------------------------------------Temporal vars
----------------------------------------------- Constants
local padding = 16
local SIZE_BACKGROUND = 1024
local OBJECTS_TOLERANCE_X = 100
local OBJECTS_TOLERANCE_Y = 100
local STARS_LAYER_DEPTH_RATIO = 0.08
local STARS_PER_LAYER = 20
local STARS_LAYERS = 3

local BOUNDARY_SIZE = 200
----------------------------------------------- Functions

local function updateEnemies()
	for indexEnemy = 1, #enemies do
		local currentEnemy = enemies[indexEnemy]
		if currentEnemy.group.isPlayerOnRange then
			local ray = physics.rayCast(currentEnemy.group.x, currentEnemy.group.y,	playerCharacter.x, playerCharacter.y)
			
			if ray then
				if ray[1].object.name ~= "asteroid" then
					currentEnemy.group.canFollowObject = true
				else
					currentEnemy.group.canFollowObject = false				
				end
			end
			
			if currentEnemy.group.canFollowObject then
				currentEnemy:follow()
				currentEnemy.group.hasToReturn = true
			else
				if currentEnemy.group.hasToReturn then
					currentEnemy:returnToPatrol()
				end
			end
			
			if not currentEnemy.group.canFollowObject and not currentEnemy.group.hasToReturn then
				currentEnemy:patrol()
			end
			
		else
			if currentEnemy.group.hasToReturn then
				
			else
				currentEnemy:patrol()
			end
			
		end
	end
	
end

local function showDebugInformation()
	
	debugText.text = string.format([[
	ShipHasItem: %s
	SpawnedFruit: %s
	SpawnedVegetable: %s
	SpawnedProtein: %s
	Fruits: %d
	Vegetables: %d
	Proteins: %d
	Enemies: %d
	Player x: %d
	Player y: %d]], 
	tostring(playerCharacter.isCarringItem),
	tostring(isFruitSpawned),
	tostring(isVegetableSpawned),
	tostring(isProteinSpawned),
	totalCollectedFruits,
	totalCollectedVegetables,
	totalCollectedProteins,
	#enemies,
	playerCharacter.x,
	playerCharacter.y)
end

local function randomFoodByType(foodType)
	local bubbleSearchIndexes = {}
	for indexBubble = 1, #foodBubbleGroup.bubbles do
		local currentBubble = foodBubbleGroup.bubbles[indexBubble]
		if currentBubble.type == foodType then
			bubbleSearchIndexes[#bubbleSearchIndexes + 1] = indexBubble
		end
	end
	return bubbleSearchIndexes[math.random(1, #bubbleSearchIndexes)]
end

local function spawnBubble(foodType, planet)
	local foodBubbleIndex = randomFoodByType(foodType)
	local foundBubble = foodBubbleGroup.bubbles[foodBubbleIndex]
	
	local showBubble = function()
		foundBubble.x = planet.x
		foundBubble.y = planet.y + planet.width * 0.5
		foundBubble.alpha = 1
		foundBubble.isVisible = true
		foundBubble.isSpawned = true
		
		physics.addBody(foundBubble, "dynamic", {density = 0, friction = 0, bounce = 0.1, radius = 30})
		foundBubble.gravityScale = 0
		foundBubble:applyLinearImpulse( math.random(-5,5)/100, math.random(-5,5)/100, foundBubble.x, foundBubble.y)
	end
	
	timer.performWithDelay(100, showBubble)
end

local function grabFruit(fruit)
	--transition.to(fruit, { x = playerCharacter.x - 62, y = playerCharacter.y + 5 , onComplete = function()
			physics.removeBody(fruit)
			fruit.x = -62
			fruit.y = 5
			playerCharacter:insert(fruit)
	--end})
end

local function preCollision(self, event)
	if not playerCharacter.isCarringItem then
		if event.object1.name == "player" and event.object2.type == "fruit" or event.object2.type == "protein" or event.object2.type == "vegetable" then
			playerCharacter.isCarringItem = true
			playerCharacter.item = event.object2
			event.object2.isSensor = true
			local function fruitLister()
				grabFruit(event.object2)
			end
			timer.performWithDelay(100, fruitLister)
		end
	end
	
end

local function hideBubble()
	playerCharacter.item.isVisible = false
	playerCharacter.isCarringItem = false
	if playerCharacter.item.type == "fruit" then
		isFruitSpawned = false
	elseif playerCharacter.item.type == "vegetable" then
		isVegetableSpawned = false
	elseif playerCharacter.item.type == "protein" then
		isProteinSpawned = false
	end
	--playerCharacter.item = nil
end

local function updateScore(type)
	if type == "fruit" then
		totalCollectedFruits = totalCollectedFruits + 1
	elseif type == "vegetable" then
		totalCollectedVegetables = totalCollectedVegetables + 1
	elseif type == "protein" then
		totalCollectedProteins = totalCollectedProteins + 1
	end
end
	
local function localCollision(self, event)
	event.object1.name = event.object1.name or "unknown"
	event.object2.name = event.object2.name or "unknown"
	
	if ( event.phase == "began" ) then

		--print("I am " .. event.object2.name) 
		--Collisions on enemy range
		if event.object1.name == "canoner" and event.object1.isPlayerOnRange == false then
			--event.object1:stop()
			event.object1:setReturnPoint()
			event.object1:setFollowing(true, event.object2)
		end
		
		--Collisions on planet range
		if event.object1.name == "fruits" and isFruitSpawned == false then
			spawnBubble("fruit", event.object1)
			isFruitSpawned = true
		elseif event.object1.name == "proteins" and isProteinSpawned == false then
			spawnBubble("protein", event.object1)
			isProteinSpawned = true
		elseif event.object1.name == "vegetables" and isVegetableSpawned == false then
			spawnBubble("vegetable", event.object1)
			isVegetableSpawned = true
		elseif event.object1.name == "earth" and playerCharacter.isCarringItem then
		
			local function bubbleToEarth()
				foodBubbleGroup:insert(playerCharacter.item)
				playerCharacter.item.x = playerCharacter.x
				playerCharacter.item.y = playerCharacter.y
				transition.to(playerCharacter.item, {transition = easing.outBounce, xScale = 1, yScale = 1, time = 500, onComplete = function()
					transition.to(playerCharacter.item, {alpha = 0, xScale = 0.5, yScale = 0.5, transition = easing.outCubic, time = 1000, x = event.object1.x, y = event.object1.y, onComplete = function()
						hideBubble()
					end})
				end})
			end
			
			updateScore(playerCharacter.item.type)
			timer.performWithDelay(100, bubbleToEarth)
		else
			--print("collided with: " .. event.object1.name)
		end
		

    elseif ( event.phase == "ended" ) then
        if(event.object1.name == "fruits" or event.object1.name == "proteins" or event.object1.name == "vegetables") then
			print("Outside range with: " .. event.object1.name)
		end
		
		if event.object1.name == "canoner" and event.object1.isPlayerOnRange then
			--event.object1:move()
			event.object1:setFollowing(false, nil)
			--event.object1:returnToPatrol()
		end
    end
end


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

local function addPhysicsObject(object)
	physicsObjectList[#physicsObjectList + 1] = object
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

local function createBorders()
	
	local levelData = worldsData[worldIndex][levelIndex]
	local levelWidth = levelData.levelWidth
	local levelHeight = levelData.levelHeight
	
	local halfLevelWidth = levelWidth * 0.5
	local halfLevelHeight = levelHeight * 0.5
	
	local halfBoundarySize = BOUNDARY_SIZE * 0.5
	local doubleBoundarySize = BOUNDARY_SIZE * 2
	
	local wallPositionX 
	local wallPositionY
	
	wallPositionX = -halfLevelWidth - halfBoundarySize
	wallPositionY = 0
	local leftWall = display.newRect(wallPositionX, wallPositionY, BOUNDARY_SIZE, levelHeight + doubleBoundarySize)
	physics.addBody( leftWall, {density = 1.0, friction = 0.1, bounce = 0.5})
	leftWall.bodyType = "static"
	camera:add(leftWall)
	
	wallPositionX = halfLevelWidth + halfBoundarySize
	wallPositionY = 0
	local rightWall = display.newRect(wallPositionX, wallPositionY ,BOUNDARY_SIZE, levelHeight + doubleBoundarySize)
	physics.addBody( rightWall, {density = 1.0, friction = 0.1, bounce = 0.5})
	rightWall.bodyType = "static"
	camera:add(rightWall)
	
	wallPositionX = 0
	wallPositionY = -halfLevelHeight - halfBoundarySize
	local bottomWall = display.newRect(wallPositionX, wallPositionY, levelWidth, BOUNDARY_SIZE)
	physics.addBody( bottomWall, {density = 1.0, friction = 0.1, bounce = 0.5})
	bottomWall.bodyType = "static"
	camera:add(bottomWall)
	
	wallPositionX = 0
	wallPositionY = halfLevelHeight + halfBoundarySize
	local topWall = display.newRect(wallPositionX, wallPositionY, levelWidth, BOUNDARY_SIZE)
	physics.addBody( topWall, {density = 1.0, friction = 0.1, bounce = 0.5})
	topWall.bodyType = "static"
	camera:add(topWall)
	
	addPhysicsObject(leftWall)
	addPhysicsObject(rightWall)
	addPhysicsObject(bottomWall)
	addPhysicsObject(topWall)
end

local function setUpCamera()
	local levelData = worldsData[worldIndex][levelIndex]
	local levelWidth = levelData.levelWidth
	local levelHeight = levelData.levelHeight
	
	local halfLevelWidth = levelWidth * 0.5
	local halfLevelHeight = levelHeight * 0.5
	
	local halfViewableContentWidth = display.viewableContentWidth * 0.5
	local halfViewableContentHeight = display.viewableContentHeight * 0.5
	
	camera:setBounds(-halfLevelWidth + halfViewableContentWidth, halfLevelWidth - halfViewableContentWidth, -halfLevelHeight + halfViewableContentHeight, halfLevelHeight - halfViewableContentHeight)
end

local function createPlayerCharacter()
	local shipPosition = worldsData[worldIndex][levelIndex].ship.position
	
	playerCharacter = spaceships.new()
	playerCharacter.isCarringItem = false
	playerCharacter.name = "player"
	playerCharacter.x = shipPosition.x
	playerCharacter.y = shipPosition.y
	camera:add(playerCharacter)
	
	addPhysicsObject(playerCharacter)
end

local function createBubble(type)
	
	local bubble = display.newImage("images/food/bubble.png")
	local food = display.newImage(type.asset)
	local bubbleGroup = display.newGroup()

	bubbleGroup.name = type.name
	bubbleGroup.type = type.type
	bubbleGroup.isSpawned = false
	bubbleGroup.isVisible = false
	bubbleGroup:scale(0.5, 0.5)

	bubbleGroup:insert(bubble)
	bubbleGroup:insert(food)
	
	return bubbleGroup
end

local function createFoodBubbles()
	foodBubbleGroup = display.newGroup()
	foodBubbleGroup.bubbles = {}
	local x = 100
	for foodIndex = 1, #foodlist do
		local currentFood = foodlist[foodIndex]
		
		local newBubble = createBubble(currentFood)
		
		foodBubbleGroup.bubbles[foodIndex] = newBubble

		foodBubbleGroup:insert(newBubble)
		camera:add(foodBubbleGroup)
	end
end

local function enterFrame()
	local velocityX, velocityY = playerCharacter:getLinearVelocity()
	if analogX and analogY then
		playerCharacter:analog(analogX, analogY)
	end
end

local function loadEarth()
	local earthData = worldsData[worldIndex][levelIndex].earth
	local earth = display.newImage(earthData.asset)
	earth.xScale = earthData.scaleFactor
	earth.yScale = earthData.scaleFactor
	earth.x = earthData.position.x
	earth.y = earthData.position.y
	earth.name = earthData.name
	
	physics.addBody(earth, "static", {radius = earth.width * earth.xScale, isSensor = true})
	camera:add(earth)
end

local function loadPlanets()
	local planets = {}
	local planetsData = worldsData[worldIndex][levelIndex].planets
	
	for planetIndex = 1, #planetsData do
		local currentPlanet = planetsData[planetIndex]
		local planet = display.newImage(currentPlanet.asset)
		physics.addBody(planet, "static", {density = 1, friction = 1, bounce = 1, radius = 200, isSensor = true})
		planet.name = currentPlanet.name
		
		planet.x = currentPlanet.position.x
		planet.y = currentPlanet.position.y
		planets[planetIndex] = planet
		camera:add(planet)
	end
end

local function loadAsteroids()
	local asteroidData = worldsData[worldIndex][levelIndex].asteroids
	
	for indexAsteroidLine = 1, #asteroidData do
		local currentAsteroidLine = asteroidData[indexAsteroidLine]
		local x1 = currentAsteroidLine.lineStart.x
		local x2 = currentAsteroidLine.lineEnd.x
		local y1 = currentAsteroidLine.lineStart.y
		local y2 = currentAsteroidLine.lineEnd.y
		
		local asteroidsPerLine = math.ceil(math.sqrt((x1 - x2)*(x1 - x2) + (y1 - y2 )*(y1 - y2 ))/60)
		local asteroidStepX = math.abs(x1 - x2) / asteroidsPerLine
		local asteroidStepY = math.abs(y1 - y2)/ asteroidsPerLine
		local asteroidStartX = x1
		local asteroidStartY = y1
		
		for indexAsteroid = 1, asteroidsPerLine do
			local asteroid = display.newImage("images/enviroment/asteroid1.png")
			asteroid.rotation = math.random(0, 350)
			
			asteroid.x = asteroidStartX
			asteroid.y = asteroidStartY
			
			if x2 > x1 then
				asteroidStartX = asteroidStartX + asteroidStepX
			else
				asteroidStartX = asteroidStartX - asteroidStepX
			end
			
			if y2 > y1 then
				asteroidStartY = asteroidStartY + asteroidStepY
			else
				asteroidStartY = asteroidStartY - asteroidStepY
			end
			
			
			physics.addBody(asteroid, {density = 1000, friction = 10, bounce = 0.5, radius = asteroid.width * 0.5})
			asteroid.gravityScale = 0
			asteroid.bodyType = "static"
			asteroid.name = "asteroid"
			camera:add(asteroid)
		end
		
	end
	
end

local function loadObjetives()
	
end

local function loadEnemies()
	local enemyData = worldsData[worldIndex][levelIndex].enemies
	for indexEnemy = 1, #enemyData do
		local currentEnemy = enemyData[indexEnemy]
		local enemyObject = enemy.newEnemy(currentEnemy.type, currentEnemy.speed, currentEnemy.radius, currentEnemy.position.pathStart, currentEnemy.position.pathEnd)
		enemyObject.group.type = "enemy"
		enemyObject.group.name = enemyData[indexEnemy].type
		enemies[indexEnemy] = enemyObject
		camera:add(enemyObject.group)
	end
end

local function loadLevel()
	loadObjetives()
	loadEarth()
	loadPlanets()
	loadAsteroids()
	loadEnemies()
end

local function createGUI()
	local userGUI = display.newGroup()
	userGUI.x = display.screenOriginX
	userGUI.y = display.screenOriginY
	
	local container =  display.newRoundedRect( 100, 300, 150, 250, 30)
	container.strokeWidth = 3
	container:setFillColor( 0.5, 0.5, 0.5, 0.5 )
	container:setStrokeColor( 0.5,0,0 )
	userGUI:insert(container)
	
	local fruitGroup = display.newGroup()
	local fruitIcon = display.newImage("images/food/strawberry.png")
	fruitIcon:scale(0.5,0.5)
	fruitIcon.x = (container.x - container.width * 0.5) + container.width * 0.2
	fruitIcon.y = container.y - (container.height * 0.5) + container.height * 0.20
	
	
	local vegetableIcon = display.newImage("images/food/carrot.png")
	vegetableIcon:scale(0.5,0.5)
	vegetableIcon.x = (container.x - container.width * 0.5) + container.width * 0.2
	vegetableIcon.y = fruitIcon.y + fruitIcon.height * 0.5
	local proteinIcon= display.newImage("images/food/meat.png")
	proteinIcon:scale(0.5,0.5)
	proteinIcon.x = (container.x - container.width * 0.5) + container.width * 0.2
	proteinIcon.y = vegetableIcon.y + vegetableIcon.height * 0.5
	
	userGUI:insert(fruitIcon)
	userGUI:insert(vegetableIcon)
	userGUI:insert(proteinIcon)
	
end

local function initialize()
	isFruitSpawned = false
	isVegetableSpawned = false
	isProteinSpawned = false
	
	worldIndex = 1
	levelIndex = 2
	
	totalCollectedFruits = 0
	totalCollectedVegetables = 0
	totalCollectedProteins = 0
end

local function updateGameLoop()
	updateParallax()
	updateEnemies()
	showDebugInformation()
	enterFrame()
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

local function createGame()
	system.activate("multitouch")
	
	physics.setPositionIterations(1)
	physics.setVelocityIterations(1)
	physics.start()
	physics.setContinuous(false)
	physics.setGravity(0, 10)
	
	physicsObjectList = {}
	enemies = {}
	
	loadLevel()
	
	createPlayerCharacter(1,2)
	createBorders(1, 2)
	createFoodBubbles()
	
	spaceships.start()
	camera:setFocus(playerCharacter)
	camera:start()
	
	playerCharacter.collision = localCollision
	playerCharacter.preCollision = preCollision
	
	Runtime:addEventListener("touch", testTouch)
	Runtime:addEventListener("collision", playerCharacter)
	Runtime:addEventListener("preCollision", playerCharacter)
end

local function destroyGame()
	system.deactivate("multitouch")
	physics.pause()
	sound.stopPitch()
	Runtime:removeEventListener("touch", testTouch)
	Runtime:removeEventListener("enterFrame", enterFrame)
	camera:stop()
	
	for index = #physicsObjectList, 1, -1 do
		display.remove(physicsObjectList[index])
		physicsObjectList[index] = nil
	end
	physicsObjectList = nil
	
	spaceships.stop()
	physics.stop()
end

function scene:create(event)
	local sceneGroup = self.view

	createGUI(sceneGroup)
	
	createBackground(sceneGroup)
	sceneGroup:insert(backgroundGroup)
	
	camera = perspective.newCamera()

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
	
	local debugTextOptions = {
		x = display.contentWidth - 100,
		y = display.screenOriginY + 100,
		font = settings.fontName,
		fontSize = 15,
		width = 400,
		text = "",
	}
	
	debugText = display.newText(debugTextOptions)
end

function scene:destroy()
	
end

function scene:show( event )
	local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		
		initialize()
		createGame()
		setUpCamera()

		self.disableButtons()
	elseif ( phase == "did" ) then
		
		Runtime:addEventListener("enterFrame", updateGameLoop)
		self.enableButtons()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		self.disableButtons()
	elseif ( phase == "did" ) then
		destroyGame()
	end
end

scene:addEventListener( "create" )
scene:addEventListener( "destroy" )
scene:addEventListener( "hide" )
scene:addEventListener( "show" )

return scene