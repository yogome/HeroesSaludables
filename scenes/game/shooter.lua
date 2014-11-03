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
local enemyFactory = require("entities.enemies")
local extramath = require( "libs.helpers.extramath" )

local scene = composer.newScene() 
----------------------------------------------- Variables
local buttonBack 
local camera
local playerCharacter
local physicsObjectList
local analogX, analogY
local analogCircleBegan
local analogCircleMove
local heartIndicator
local worldIndex, levelIndex
local hudGroup
----------------------------------------------- Background stars data
local spaceObjects, objectDespawnX, objectSpawnX, objectDespawnY, objectSpawnY
local spawnZoneWidth, spawnZoneHeight, halfSpawnZoneWidth, halfSpawnZoneHeight
-----------------------------------------------

local backgroundGroup
local foodBubbleGroup
local enemies
local isFoodSpawned
local totalCollectedFruits, totalCollectedVegetables, totalCollectedProteins
-----------------------------------------------Vars used by level loader
local levelBackground
local levelSize
local levelSpaceshipPosition
local levelPlanets

local debugText
----------------------------------------------- Caches
local squareRoot = math.sqrt 
----------------------------------------------- Constants
local PADDING = 16
local SCALE_HEARTINDICATOR = 0.3
local SIZE_BACKGROUND = 1024
local OBJECTS_TOLERANCE_X = 100
local OBJECTS_TOLERANCE_Y = 100
local STARS_LAYER_DEPTH_RATIO = 0.08
local STARS_PER_LAYER = 20
local STARS_LAYERS = 3
local SCALE_BUTTON_BACK = 0.9
local NUMBER_HEARTS = 3
local BOUNDARY_SIZE = 200
local  SIZE_FOOD_CONTAINER = {width = 120, height = 260}
----------------------------------------------- Functions

local function updateEnemies()
	for indexEnemy = 1, #enemies do
		local currentEnemy = enemies[indexEnemy]
		currentEnemy:update()
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
	tostring(isFoodSpawned["fruit"]),
	tostring(isFoodSpawned["vegetable"]),
	tostring(isFoodSpawned["protein"]),
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

local function spawnBubble(planet)
	if not isFoodSpawned[planet.foodType] then
		isFoodSpawned[planet.foodType] = true
		local foodBubbleIndex = randomFoodByType(planet.foodType)
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
end

local function grabFruit(fruit)
	--transition.to(fruit, { x = playerCharacter.x - 62, y = playerCharacter.y + 5 , onComplete = function()
			physics.removeBody(fruit)
			fruit.x = -62
			fruit.y = 5
			playerCharacter:insert(fruit)
	--end})
end

local function checkPlayerPreCollision(player, object)
	if player.name == "player" then
		if not player.isCarringItem then
			if object.name == "food" then
				playerCharacter.isCarringItem = true
				playerCharacter.item = object
				object.isSensor = true
				local function fruitLister()
					grabFruit(object)
				end
				timer.performWithDelay(100, fruitLister)
			end
		end
	end
end

local function preCollisionListener(event)
	checkPlayerPreCollision(event.object1, event.object2)
	checkPlayerPreCollision(event.object2, event.object1)
end

local function hideBubble()
	playerCharacter.item.isVisible = false
	playerCharacter.isCarringItem = false
	
	isFoodSpawned[playerCharacter.item.type] = false
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

local function addEnemyTarget(enemy, target)
	if enemy.name == "enemy" then
		if target.name == "player" then
			enemy:setTarget(target)
		end
	end
end

local function removeEnemyTarget(enemy, target)
	if enemy.name == "enemy" then
		if target.name == "player" then
			enemy:setTarget(nil)
		end
	end
end

local function collectBubble(earth)
	if playerCharacter.isCarringItem then
		foodBubbleGroup:insert(playerCharacter.item)
		playerCharacter.item.x = playerCharacter.x
		playerCharacter.item.y = playerCharacter.y
		transition.to(playerCharacter.item, {transition = easing.outBounce, xScale = 1, yScale = 1, time = 500, onComplete = function()
			transition.to(playerCharacter.item, {alpha = 0, xScale = 0.5, yScale = 0.5, transition = easing.outCubic, time = 1000, x = earth.x, y = earth.y, onComplete = function()
				hideBubble()
			end})
		end})

		updateScore(playerCharacter.item.type)
	end
end

local function checkPlayerCollision(player, otherObject)
	if player.name == "player" then
		if otherObject.name == "planet" then
			spawnBubble(otherObject)
		elseif otherObject.name == "earth" then
			collectBubble(otherObject)
		end
	end
end
	
local function collisionListener(event)
	if event.phase == "began" then
		addEnemyTarget(event.object1, event.object2)
		addEnemyTarget(event.object2, event.object1)
		
		checkPlayerCollision(event.object1, event.object2)
		checkPlayerCollision(event.object2, event.object1)
	end
	
	if event.phase == "ended" then
		removeEnemyTarget(event.object1, event.object2)
		removeEnemyTarget(event.object2, event.object1)
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

	bubbleGroup.name = "food"
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
		local currentPlanetData = planetsData[planetIndex]
		local planet = display.newImage(currentPlanetData.asset)
		physics.addBody(planet, "static", {density = 1, friction = 1, bounce = 1, radius = 200, isSensor = true})
		planet.name = "planet"
		planet.foodType = currentPlanetData.foodType
		
		planet.x = currentPlanetData.position.x
		planet.y = currentPlanetData.position.y
		planets[planetIndex] = planet
		camera:add(planet)
	end
end

local function loadAsteroids()
	local asteroidData = worldsData[worldIndex][levelIndex].asteroids
	
	for indexAsteroidLine = 1, #asteroidData do
		local currentAsteroidLine = asteroidData[indexAsteroidLine]
			
		local p2 = {x = currentAsteroidLine.lineStart.x, y = currentAsteroidLine.lineStart.y}
		local p1 = {x = currentAsteroidLine.lineEnd.x, y = currentAsteroidLine.lineEnd.y}

		local distanceX = p2.x - p1.x
		local distanceY = p2.y - p1.y
		local distance = squareRoot((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y))
		
		local asteroidEasingX = currentAsteroidLine.easingX or easing.linear
		local asteroidEasingY = currentAsteroidLine.easingY or easing.linear
		
		local chainBodyPoints = {}

		local iterations = math.ceil(distance / 55)
		for index = 1, iterations do
			local randomSideMultiplier = index % 2 * 2 -3
			local randomScale = math.random(90,110) * 0.01
			local asteroid = display.newImage("images/enviroment/asteroid"..math.random(1,3)..".png")
			asteroid.x = asteroidEasingX(index, iterations, p1.x, distanceX)
			asteroid.y = asteroidEasingY(index, iterations, p1.y, distanceY)
			asteroid:scale(randomScale, randomScale)
			asteroid.rotation = math.random(0,360)
			camera:add(asteroid)
			
			chainBodyPoints[#chainBodyPoints + 1] = asteroid.x
			chainBodyPoints[#chainBodyPoints + 1] = asteroid.y
			
			asteroid.x = asteroid.x + math.random(0,10) * randomSideMultiplier
			asteroid.y = asteroid.y - math.random(0,10) * randomSideMultiplier
		end
		
		local asteroidLineBody = display.newRect( 0, 0, 5, 5 )
		asteroidLineBody.name = "asteroid"
		asteroidLineBody.isVisible = false
		physics.addBody( asteroidLineBody, "static", {
			friction = 2,
			bounce = 0.5,
			chain = chainBodyPoints,
			connectFirstAndLastChainVertex = false,
		})
		camera:add(asteroidLineBody)
		addPhysicsObject(asteroidLineBody)
	end
end

local function loadObjetives()
	
end

local function loadEnemies()
	local enemySpawnData = worldsData[worldIndex][levelIndex].enemySpawnData
	for indexEnemy = 1, #enemySpawnData do
		local currentEnemySpawnData = enemySpawnData[indexEnemy]
		local enemyObject = enemyFactory.newEnemy(currentEnemySpawnData)
		
		physics.addBody(enemyObject, "dynamic",  {radius = enemyObject.viewRadius, isSensor = true})
		enemyObject.gravityScale = 0
		enemyObject.type = enemySpawnData[indexEnemy].type
		enemyObject.name = "enemy"
		enemies[indexEnemy] = enemyObject
		camera:add(enemyObject)
	end
end

local function loadLevel()
	loadObjetives()
	loadEarth()
	loadPlanets()
	loadAsteroids()
	loadEnemies()
end

local function createHUD()
	display.remove(hudGroup)
	hudGroup = display.newGroup()
	hudGroup.x = display.screenOriginX
	hudGroup.y = display.screenOriginY
	
	local foodContainer = display.newGroup()
	foodContainer.x = display.screenOriginX + SIZE_FOOD_CONTAINER.width * 0.5 + PADDING
	foodContainer.y = display.contentCenterY
	hudGroup:insert(foodContainer)
	
	local containerBG =  display.newRoundedRect( 0, 0, SIZE_FOOD_CONTAINER.width, SIZE_FOOD_CONTAINER.height, 30)
	containerBG.strokeWidth = 3
	containerBG:setFillColor( 0.5, 0.5, 0.5, 0.5 )
	containerBG:setStrokeColor( 0.5,0,0 )
	foodContainer:insert(containerBG)
	
	local foods = {
		[1] = {image = "images/food/strawberry.png"},
		[2] = {image = "images/food/carrot.png"},
		[3] = {image = "images/food/meat.png"},
	}
	
	for index = 1, #foods do
		local foodIcon = display.newImage(foods[index].image)
		foodIcon:scale(0.5,0.5)
		foodIcon.x = -containerBG.width * 0.2
		foodIcon.y = -containerBG.height * 0.5 + (containerBG.height / (#foods + 1)) * index
		foodContainer:insert(foodIcon)
		
		local foodAmountOptions = {
			x = containerBG.width * 0.15,
			y = foodIcon.y,
			font = settings.fontName,
			fontSize = 32,
			width = 100,
			text = "0",
			align = "left",
		}

		local foodAmount = display.newText(foodAmountOptions)
		foodAmount.anchorX = 0
		foodContainer:insert(foodAmount)
	end
	
	heartIndicator = display.newGroup()
	
	local heartIndicatorBG = display.newImage("images/shooter/3heart.png")
	heartIndicatorBG.x = 0
	heartIndicatorBG.y = 0
	heartIndicator:insert(heartIndicatorBG)
	
	local heartSpacing = 230
	
	local heartStartX = -((NUMBER_HEARTS - 1) * heartSpacing) * 0.5
	for index = 1, NUMBER_HEARTS do
		local heart = display.newImage("images/shooter/heart.png")
		heart.x = heartStartX + (index - 1) * heartSpacing
		heartIndicator:insert(heart)
	end
	
	heartIndicator:scale(SCALE_HEARTINDICATOR, SCALE_HEARTINDICATOR)
	heartIndicator.x = display.contentCenterX
	heartIndicator.y = display.screenOriginY + PADDING + heartIndicatorBG.height * 0.5 * SCALE_HEARTINDICATOR
	hudGroup:insert(heartIndicator)
	
end

local function initialize()
	isFoodSpawned = {
		["fruit"] = false,
		["vegetable"] = false,
		["protein"] = false,
	}
	
	worldIndex = 1
	levelIndex = 1
	
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
	
	createPlayerCharacter()
	createBorders()
	createFoodBubbles()
	
	spaceships.start()
	camera:setFocus(playerCharacter)
	camera:start()
	
	Runtime:addEventListener("touch", testTouch)
	Runtime:addEventListener("collision", collisionListener)
	Runtime:addEventListener("preCollision", preCollisionListener)
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
	
	createBackground(sceneGroup)
	sceneGroup:insert(backgroundGroup)
	
	camera = perspective.newCamera()

	sceneGroup:insert(camera)
	
	buttonList.back.onRelease = onReleasedBack
	buttonBack = widget.newButton(buttonList.back)
	buttonBack:scale(SCALE_BUTTON_BACK, SCALE_BUTTON_BACK)
	buttonBack.x = display.screenOriginX + buttonBack.width * SCALE_BUTTON_BACK * 0.5 + PADDING
	buttonBack.y = display.screenOriginY + buttonBack.height * SCALE_BUTTON_BACK * 0.5 + PADDING
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
		createHUD(sceneGroup)

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