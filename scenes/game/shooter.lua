----------------------------------------------- Shooter space game
local director = require( "libs.helpers.director" )
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
local loseScene = require( "scenes.game.lose" )
local winScene = require( "scenes.game.win" )
local dataSaver = require("services.datasaver")

--physics.setDrawMode("hybrid")
local scene = director.newScene() 
----------------------------------------------- Variables
local buttonPause 
local camera
local playerCharacter
local physicsObjectList
local analogX, analogY
local analogCircleBegan
local analogCircleMove
local analogCircleBounds
local heartIndicator
local worldIndex, levelIndex
local hudGroup
local foodTexts, targetAmounts
local asteroidGroup, disposableAsteroidGroup
local planets, earth
local cameraEdit, editCircle
local editorObjects
local introTimer
local currentEasingXIndex, currentEasingYIndex
local currentEasingX, currentEasingY
local lastTwoCoordinates
local easingFunctions
local editorPreviewGroup, editorPreviewLine
local framecounter = 0
local isPaused
----------------------------------------------- Background stars data
local spaceObjects, objectDespawnX, objectSpawnX, objectDespawnY, objectSpawnY
local spawnZoneWidth, spawnZoneHeight, halfSpawnZoneWidth, halfSpawnZoneHeight
-----------------------------------------------
local isGameover
local backgroundGroup
local foodBubbleGroup
local enemies
local isFoodSpawned
local collectedFood
-----------------------------------------------Vars used by level loader
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
local SIZE_FOOD_CONTAINER = {width = 140, height = 260}
local OFFSET_GRABFRUIT = {x = -62, y = 17}
local SCALE_EXPLOSION = 0.75
local SPEED_CAMERA = 100
local RADIUS_ANALOG = 150
----------------------------------------------- Functions
local function addPhysicsObject(object)
	physicsObjectList[#physicsObjectList + 1] = object
end 

local function createAsteroidLine(point1, point2, easingX, easingY)
	local p2 = {x = point1.x, y = point1.y}
	local p1 = {x = point2.x, y = point2.y}

	local distanceX = p2.x - p1.x
	local distanceY = p2.y - p1.y
	local distance = squareRoot((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y))

	easingX = easingX or easing.linear
	easingY = easingY or easing.linear

	local chainBodyPoints = {}

	local iterations = math.ceil(distance / 55)
	local asteroidGraphics = {}
	for index = 1, iterations do
		local randomSideMultiplier = index % 2 * 2 -3
		local randomScale = math.random(90,110) * 0.01
		local asteroid = display.newImage("images/enviroment/asteroid"..math.random(1,3)..".png")
		asteroid.x = easingX(index, iterations, p1.x, distanceX)
		asteroid.y = easingY(index, iterations, p1.y, distanceY)
		asteroid:scale(randomScale, randomScale)
		asteroid.rotation = math.random(0,360)
		
		asteroidGraphics[index] = asteroid

		disposableAsteroidGroup:insert(asteroid)

		chainBodyPoints[#chainBodyPoints + 1] = asteroid.x
		chainBodyPoints[#chainBodyPoints + 1] = asteroid.y

		asteroid.x = asteroid.x + math.random(0,10) * randomSideMultiplier
		asteroid.y = asteroid.y - math.random(0,10) * randomSideMultiplier
	end

	local asteroidLineBody = display.newRect( 0, 0, 5, 5 )
	asteroidLineBody.name = "asteroid"
	asteroidLineBody.asteroidGraphics = asteroidGraphics
	asteroidLineBody.isVisible = false
	physics.addBody( asteroidLineBody, "static", {
		friction = 2,
		bounce = 0.5,
		chain = chainBodyPoints,
		connectFirstAndLastChainVertex = false,
	})
	camera:add(asteroidLineBody)
	addPhysicsObject(asteroidLineBody)
	
	return asteroidLineBody
end

local function createPreviewLine()
	camera:remove(editorPreviewLine)
	display.remove(editorPreviewLine)
			
	editorPreviewLine = display.newGroup()
	local p2 = lastTwoCoordinates[1]
	local p1 = lastTwoCoordinates[2]

	local distanceX = p2.x - p1.x
	local distanceY = p2.y - p1.y
	local distance = squareRoot((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y))
	
	local easingX = easingFunctions[currentEasingXIndex].value
	local easingY = easingFunctions[currentEasingYIndex].value
	
	local iterations = math.ceil(distance / 55)
	local asteroidGraphics = {}
	for index = 1, iterations do
		local previewCircle = display.newCircle(0,0,5,5)
		previewCircle.alpha = 0.3
		previewCircle.x = easingX(index, iterations, p1.x, distanceX)
		previewCircle.y = easingY(index, iterations, p1.y, distanceY)
		editorPreviewLine:insert(previewCircle)
	end
	
	camera:add(editorPreviewLine)
end

local function onKeyEvent( event )
	local handled = false
	local phase = event.phase
	local nativeKeyCode = event.nativeKeyCode
	
	local isShiftDown = event.isShiftDown
	local multiplier = isShiftDown and 0.1 or 1
	if phase == "down" then
		if 12 == nativeKeyCode then -- Q
			camera:setFocus(playerCharacter)
			editCircle.isVisible = false
		end
		if 14 == nativeKeyCode then -- E
			editCircle.isVisible = true
			camera:setFocus(editCircle)
			debugText.isVisible = true
			if introTimer then timer.cancel(introTimer) end
		end
		if 15 == nativeKeyCode then -- R
			lastTwoCoordinates[1] = lastTwoCoordinates[2]
			lastTwoCoordinates[2] = {x = editCircle.x, y = editCircle.y}
			createPreviewLine()
		end
		if 16 == nativeKeyCode then -- ^
			print("{"..editCircle.x..", "..editCircle.y.."},")
		end
		if 6 == nativeKeyCode then -- Z
			currentEasingXIndex = currentEasingXIndex - 1
			if currentEasingXIndex <= 0 then currentEasingXIndex = #easingFunctions end
			currentEasingX = easingFunctions[currentEasingXIndex].name
			createPreviewLine()
		end
		if 7 == nativeKeyCode then -- X
			currentEasingXIndex = currentEasingXIndex + 1
			if currentEasingXIndex > #easingFunctions then currentEasingXIndex = 1 end
			currentEasingX = easingFunctions[currentEasingXIndex].name
			createPreviewLine()
		end
		if 0 == nativeKeyCode then -- A
			currentEasingYIndex = currentEasingYIndex - 1
			if currentEasingYIndex <= 0 then currentEasingYIndex = #easingFunctions end
			currentEasingY = easingFunctions[currentEasingYIndex].name
			createPreviewLine()
		end
		if 1 == nativeKeyCode then -- S
			currentEasingYIndex = currentEasingYIndex + 1
			if currentEasingYIndex > #easingFunctions then currentEasingYIndex = 1 end
			currentEasingY = easingFunctions[currentEasingYIndex].name
			createPreviewLine()
		end
		if 32 == nativeKeyCode then -- U
			local point1 = lastTwoCoordinates[1]
			local point2 = lastTwoCoordinates[2]
			local easingX = easingFunctions[currentEasingXIndex].value
			local easingY = easingFunctions[currentEasingYIndex].value
			editorObjects[#editorObjects + 1] = createAsteroidLine(point1, point2, easingX, easingY)
		end
		if 34 == nativeKeyCode then -- I
			local lastAsteroids = editorObjects[#editorObjects]
			lastAsteroids.removeFromWorld = true
			for index = 1, #lastAsteroids.asteroidGraphics do
				display.remove(lastAsteroids.asteroidGraphics[index])
			end
			editorObjects[#editorObjects] = nil
		end
		if 123 == nativeKeyCode then -- Left
			editCircle.x = editCircle.x - SPEED_CAMERA * multiplier
		end
		if 124 == nativeKeyCode then -- Right
			editCircle.x = editCircle.x + SPEED_CAMERA * multiplier
		end
		if nativeKeyCode == 125 then -- Down key
			editCircle.y = editCircle.y + SPEED_CAMERA * multiplier
		end
		if nativeKeyCode == 126 then -- Up key
			editCircle.y = editCircle.y - SPEED_CAMERA * multiplier
		end
		if 46 == nativeKeyCode then -- N
			physics.setDrawMode("hybrid")
		end
		if 45 == nativeKeyCode then -- M
			physics.setDrawMode("normal")
		end
	end
	
	return handled
end 

local function destroyGame()
	system.deactivate("multitouch")
	physics.pause()
	sound.stopPitch()
	Runtime:removeEventListener("touch", testTouch)
	camera:stop()
	
	for index = #physicsObjectList, 1, -1 do
		display.remove(physicsObjectList[index])
		physicsObjectList[index] = nil
	end
	physicsObjectList = nil
	
	spaceships.stop()
	physics.stop()
end

local function retryGame()
	director.hideScene("scenes.game.shooter");
	director.gotoScene("scenes.game.shooter",{params = {worldIndex = worldIndex, levelIndex = levelIndex}})
end

local function updateEnemies()
	for indexEnemy = 1, #enemies do
		local currentEnemy = enemies[indexEnemy]
		currentEnemy:update()
	end
end

local function showDebugInformation()
	debugText.text = [[
		Press Q for player mode
		Press E for edit mode
		Press R to store coordinate
		Press T to dump coordinate
		
		Press N,M to set draw mode
		
		Press L to dump level (NOT IMPLEMENTED)
		
		Press U to create asteroids
		Press I to delete asteroids
		
		Press Z for previous easingX
		Press X for next easingX
		Current easingX: ]]..currentEasingX..[[
		
		Press A for previous easingY
		Press S for next easingY
		Current easingY: ]]..currentEasingY..[[
		
		P1 = {]]..lastTwoCoordinates[1].x..[[, ]]..lastTwoCoordinates[1].y..[[}
		P2 = {]]..lastTwoCoordinates[2].x..[[, ]]..lastTwoCoordinates[2].y..[[}
	]]
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
			foundBubble.x = planet.x + planet.foodOffset.x
			foundBubble.y = planet.y + planet.foodOffset.y
			foundBubble.alpha = 0
			foundBubble.isVisible = true
			foundBubble.isSpawned = true
			
			transition.to(foundBubble, {time = 400, alpha = 1, transition = easing.outQuad})

			physics.addBody(foundBubble, "dynamic", {density = 0, friction = 0, bounce = 0.1, radius = 30})
			foundBubble.gravityScale = 0
			foundBubble:applyLinearImpulse( math.random(-5,5)/100, math.random(-5,5)/100, foundBubble.x, foundBubble.y)
		end

		timer.performWithDelay(100, showBubble)
	end
end

local function grabFruit(fruit)
	if not fruit.isGrabbed then
		fruit.isGrabbed = true
		
		physics.removeBody(fruit)
		local contentX, contentY = fruit:localToContent(0,0)
		local firstX, firstY = playerCharacter:contentToLocal(contentX, contentY)

		fruit.x = firstX
		fruit.y = firstY
		playerCharacter:setAnimation("closing")
		transition.to(fruit, {x = OFFSET_GRABFRUIT.x, y = OFFSET_GRABFRUIT.y, time = 500, transition = easing.inOutSine})
		playerCharacter:insert(fruit)
	end
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
	playerCharacter.item.isGrabbed = false
	playerCharacter.isCarringItem = false
	
	isFoodSpawned[playerCharacter.item.type] = false
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

local function checkAmounts()
	local isComplete = true
	for key, value in pairs(collectedFood) do
		if value < targetAmounts[key] then
			isComplete = false
		end
	end
	
	if isComplete then
		if not isGameover then
			isGameover = true
			local function onBackReleased()
				winScene.disableButtons()
				director.gotoScene("scenes.menus.levels", {effect = "fade", time = 500})
			end
			local function onRetryReleased()
				winScene.disableButtons()
				retryGame()
			end
			local function onPlayReleased()
				winScene.disableButtons()
				director.gotoScene("scenes.menus.levels", {effect = "fade", time = 500})
			end
			winScene.show(heartIndicator.currentHearts, 500, onBackReleased, onRetryReleased, onPlayReleased)
		end
	end
end

local function collectBubble(earth)
	if playerCharacter.isCarringItem then
		earth:setSequence("eat")
		earth:play()
		earth:addEventListener("sprite", function(event)
			if event.phase == "ended" then
				earth:setSequence("happy")
				earth:play()
			end
		end)
		foodBubbleGroup:insert(playerCharacter.item)
		playerCharacter.item.x = playerCharacter.x
		playerCharacter.item.y = playerCharacter.y
		playerCharacter:setAnimation("opening")
		transition.to(playerCharacter.item, {transition = easing.outBounce, xScale = 1, yScale = 1, time = 500, onComplete = function()
			transition.to(playerCharacter.item, {alpha = 0, xScale = 0.5, yScale = 0.5, transition = easing.outCubic, time = 1000, x = earth.x, y = earth.y, onComplete = function()
				hideBubble()
			end})
		end})
		local foodType = playerCharacter.item.type
		collectedFood[foodType] = collectedFood[foodType] + 1
		foodTexts[foodType].text = collectedFood[foodType].."/"..targetAmounts[foodType]
		
		checkAmounts()
	end
end

local function gameOver()
	if not isGameover then
		isGameover = true
		playerCharacter:destroy()
	
		local function onBackReleased()
			loseScene.disableButtons()
			director.gotoScene("scenes.menus.levels", {effect = "fade", time = 500})
		end
		local function onRetryReleased()
			loseScene.disableButtons()
			retryGame()
		end

		loseScene.show(onBackReleased, onRetryReleased)
	end
end

local function addDamage(bullet)
	if not bullet.removeFromWorld then
		local explosionData = { width = 128, height = 128, numFrames = 16 }
		local explosionSheet = graphics.newImageSheet( "images/enemies/explosion.png", explosionData )

		local sequenceData = {
			{name = "explosion", sheet = explosionSheet, start = 1, count = 16, 1200, loopCount = 1},
		}

		local explosionSprite = display.newSprite( explosionSheet, sequenceData )
		explosionSprite:scale(SCALE_EXPLOSION, SCALE_EXPLOSION)
		explosionSprite:setSequence("explosion")
		explosionSprite.x = bullet.x
		explosionSprite.y = bullet.y
		explosionSprite:play()
		bullet.parent:insert(explosionSprite)
		bullet.removeFromWorld = true

		explosionSprite:addEventListener("sprite", function(event)
			if event.phase == "ended" then
				if explosionSprite.sequence == "closing" then
					display.remove(explosionSprite)
				end
			end
		end)

		if not heartIndicator:removeHeart() then
			gameOver()
		end
	end
end

local function damagePlayer()
	playerCharacter.isDamaged = true
	timer.performWithDelay(1500, function()
		playerCharacter.isDamaged = false
		playerCharacter.isVisible = true
		playerCharacter.alpha = 1
	end)

end

local function checkPlayerCollision(player, otherObject, element1, element2)
	if player.name == "player" then
		if otherObject.name == "planet" then
			spawnBubble(otherObject)
		elseif otherObject.name == "earth" then
			collectBubble(otherObject)
		elseif otherObject.name == "enemy" then
			if not playerCharacter.isDamaged then
				if element2 == 2 then
					damagePlayer()
					if not heartIndicator:removeHeart() then
						gameOver()
					end
				end
			end
		elseif otherObject.name == "bullet" then
			if element2 == 1 then
				if not playerCharacter.isDamaged then
					addDamage(otherObject)
					damagePlayer()
				end
			end
		end
	end
end
	
local function collisionListener(event)
	if event.phase == "began" then
		addEnemyTarget(event.object1, event.object2)
		addEnemyTarget(event.object2, event.object1)
		
		checkPlayerCollision(event.object1, event.object2, event.element1, event.element2)
		checkPlayerCollision(event.object2, event.object1, event.element2, event.element1)
	end
	
	if event.phase == "ended" then
		if event.element1 == 1 then
			removeEnemyTarget(event.object1, event.object2)
			removeEnemyTarget(event.object2, event.object1)
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
			star.x = math.random(-containerHalfWidth, containerHalfWidth)
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

local function onReleasePause()
	isPaused = true
	director.showOverlay("scenes.menus.youWin",{params = { effect="fromRight", time=500, screen = "pause", worldIndex=worldIndex, levelIndex=levelIndex}})
end 

local function testTouch(event)
	if "began" == event.phase then
		analogCircleBounds.x = event.x
		analogCircleBounds.y = event.y
		analogCircleBegan.x = event.x
		analogCircleBegan.y = event.y
		analogCircleMove.x = event.x
		analogCircleMove.y = event.y
		analogCircleBounds.isVisible = true
		analogCircleBegan.isVisible = true
		analogCircleMove.isVisible = true
	elseif "moved" == event.phase then
		analogX = (event.x - event.xStart) * 2
		analogY = (event.y - event.yStart) * 2
			
		local diffx = (event.x - event.xStart)
		local diffy = (event.y - event.yStart)
		local distance = squareRoot((diffx * diffx) + (diffy * diffy))
		local vx = diffx / distance
		local vy = diffy / distance
		
		if distance >= RADIUS_ANALOG then
			analogCircleMove.x = event.xStart + vx * RADIUS_ANALOG
			analogCircleMove.y = event.yStart + vy * RADIUS_ANALOG
		else
			analogCircleMove.x = event.x
			analogCircleMove.y = event.y
		end

	elseif "ended" == event.phase then
		analogX = 0
		analogY = 0
		analogCircleBegan.isVisible = false
		analogCircleMove.isVisible = false
		analogCircleBounds.isVisible = false
	end	
end

local function drawDebugGrid(levelWidth, levelHeight)
	
	local startX = levelWidth * -0.5
	local startY = levelHeight * -0.5
	
	local lines = 10 
	local lineDistanceX = levelWidth / lines
	local lineDistanceY = levelHeight / lines
	
	for indexVertical = 1, lines do
		local line = display.newLine(startX + (lineDistanceX * (indexVertical - 1)),  startY, startX + (lineDistanceX * (indexVertical - 1)), levelHeight)
		camera:add(line)
		line.strokeWidth = 2
	end
	
	for indexHorizontal = 1, lines do
		local line = display.newLine(startX, startY + (lineDistanceY * (indexHorizontal - 1)), levelWidth, startY + (lineDistanceY * (indexHorizontal - 1)))
		camera:add(line)
		line.strokeWidth = 2
	end
end

local function createBorders()
	
	local levelData = worldsData[worldIndex][levelIndex]
	local levelWidth = levelData.levelWidth
	local levelHeight = levelData.levelHeight
	
--	drawDebugGrid(levelWidth, levelHeight)
	
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
	playerCharacter.isDamaged = false
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
		addPhysicsObject(newBubble)
	end
end

local function enterFrame(event)
	if playerCharacter and not playerCharacter.removeFromWorld then
		local velocityX, velocityY = playerCharacter:getLinearVelocity()
		if analogX and analogY then
			playerCharacter:analog(analogX, analogY)
		end
	end

	for index = #physicsObjectList, 1, -1 do
		local physicsObject = physicsObjectList[index]
		if physicsObject and physicsObject.removeFromWorld then
			if physicsObject.name == "player" then
				camera:setFocus(nil)
			end
			camera:remove(physicsObject)
			display.remove(physicsObject)
			table.remove(physicsObjectList, index)
		end
	end
	
	if playerCharacter.isDamaged then
		framecounter = framecounter + 1
		if framecounter % 6 == 0 then
			playerCharacter.isVisible = false
			playerCharacter.alpha = 0.5
			framecounter = 0
		else
			playerCharacter.isVisible = true
		end
	end
end

local function loadEarth()
	local earthData = worldsData[worldIndex][levelIndex].earth
	earth = display.newImage(earthData.asset)
	
	local sheetHappyData = {
		width = 256,
		height = 256,
		numFrames = 64,
		sheetContentWidth = 2048,
		sheetContentHeight = 2048,
	}
	
	local sheetHappy = graphics.newImageSheet(earthData.assetPath .. "happy.png", sheetHappyData)
	local sheetEating = graphics.newImageSheet(earthData.assetPath .. "eating.png", sheetHappyData)
	local sheetSad = graphics.newImageSheet(earthData.assetPath .. "sad.png", sheetHappyData)
	local sheetBlush = graphics.newImageSheet(earthData.assetPath .. "blush.png", sheetHappyData)
	
	local sequenceData = {
		{name = "happy", sheet = sheetHappy, start = 1, count = 64, time = 1400, loopCount = 0},
		{name = "eat", sheet = sheetEating, start = 1, count = 64, time = 1400, loopCount = 1},
		{name = "sad", sheet = sheetSad, start = 1, count = 64, time = 1400, loopCount = 0},
		{name = "blush", sheet = sheetBlush, start = 1, count = 64, time = 1400, loopCount = 0}
	}
	
	earth = display.newSprite(sheetHappy, sequenceData)
	earth:setSequence("happy")
	earth:play()
	
	earth.xScale = earthData.scaleFactor
	earth.yScale = earthData.scaleFactor
	earth.x = earthData.position.x
	earth.y = earthData.position.y
	earth.name = earthData.name
	
	physics.addBody(earth, "static", {radius = earth.contentWidth * 0.75, isSensor = true})
	camera:add(earth)
	addPhysicsObject(earth)
end

local function loadPlanets()
	planets = {}
	local planetsData = worldsData[worldIndex][levelIndex].planets
	
	for planetIndex = 1, #planetsData do
		local currentPlanetData = planetsData[planetIndex]
		local planet = display.newImage(currentPlanetData.asset)
		physics.addBody(planet, "static", {density = 1, friction = 1, bounce = 1, radius = 200, isSensor = true})
		planet.name = "planet"
		planet.foodType = currentPlanetData.foodType
		
		if currentPlanetData.scale then
			planet:scale(currentPlanetData.scale, currentPlanetData.scale)
		end
		planet.foodOffset = currentPlanetData.foodOffset or {x = 0, y = 0}
		
		planet.x = currentPlanetData.position.x
		planet.y = currentPlanetData.position.y
		planets[planetIndex] = planet
		camera:add(planet)
		addPhysicsObject(planet)
	end
end

local function loadAsteroids()
	local asteroidData = worldsData[worldIndex][levelIndex].asteroids
	
	display.remove(disposableAsteroidGroup)
	disposableAsteroidGroup = display.newGroup()
	
	asteroidGroup:insert(disposableAsteroidGroup)
	
	for indexAsteroidLine = 1, #asteroidData do
		local currentAsteroidLine = asteroidData[indexAsteroidLine]
			
		createAsteroidLine(currentAsteroidLine.lineStart, currentAsteroidLine.lineEnd, currentAsteroidLine.easingX, currentAsteroidLine.easingY)
	end
end

local function loadObjetives()
	
end

local function loadEnemies()
	local enemySpawnData = worldsData[worldIndex][levelIndex].enemySpawnData
	for indexEnemy = 1, #enemySpawnData do
		local currentEnemySpawnData = enemySpawnData[indexEnemy]
		local enemyObject = enemyFactory.newEnemy(currentEnemySpawnData)
		
		enemyObject.onBulletCreate = function(bullet)
			addPhysicsObject(bullet)
		end
		
		physics.addBody(enemyObject, "dynamic",  {radius = enemyObject.viewRadius, isSensor = true}, {density = 0.00001, radius = enemyObject.viewRadius * 0.2})
		enemyObject.gravityScale = 0
		enemyObject.type = enemySpawnData[indexEnemy].type
		enemyObject.name = "enemy"
		enemies[indexEnemy] = enemyObject
		camera:add(enemyObject)
		addPhysicsObject(enemyObject)
	end
end

local function loadLevel()
	loadObjetives()
	loadEarth()
	loadPlanets()
	loadAsteroids()
	loadEnemies()
end

local function createHUD(sceneView)
	local levelData = worldsData[worldIndex][levelIndex]
	
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
		[1] = {image = "images/food/strawberry.png", type = "fruit"},
		[2] = {image = "images/food/carrot.png", type = "vegetable"},
		[3] = {image = "images/food/meat.png", type = "protein"},
	}
	
	for index = 1, #foods do
		local foodIcon = display.newImage(foods[index].image)
		foodIcon:scale(0.5,0.5)
		foodIcon.x = -containerBG.width * 0.25
		foodIcon.y = -containerBG.height * 0.5 + (containerBG.height / (#foods + 1)) * index
		foodContainer:insert(foodIcon)
		
		local targetAmount = levelData.objectives[foods[index].type]
		targetAmounts[foods[index].type] = targetAmount
		
		local foodAmountOptions = {
			x = containerBG.width * 0,
			y = foodIcon.y,
			font = settings.fontName,
			fontSize = 32,
			width = 100,
			text = "0/"..targetAmount,
			align = "left",
		}

		local foodAmount = display.newText(foodAmountOptions)
		foodAmount.anchorX = 0
		foodContainer:insert(foodAmount)
		
		foodTexts[foods[index].type] = foodAmount
	end
	
	heartIndicator = display.newGroup()
	heartIndicator.currentHearts = NUMBER_HEARTS
	heartIndicator.hearts = {}
	
	function heartIndicator:removeHeart() -- Returns false if dead
		if self.currentHearts > 0 then
			transition.to(self.hearts[self.currentHearts], {time = 400, alpha = 0, transition = easing.outinQuad})
			self.currentHearts = self.currentHearts - 1
			return self.currentHearts > 0
		end
		return false
	end
	
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
		
		heartIndicator.hearts[index] = heart
	end
	
	heartIndicator:scale(SCALE_HEARTINDICATOR, SCALE_HEARTINDICATOR)
	heartIndicator.x = display.contentCenterX
	heartIndicator.y = display.screenOriginY + PADDING + heartIndicatorBG.height * 0.5 * SCALE_HEARTINDICATOR
	hudGroup:insert(heartIndicator)
	
	local explainTextOptions = {
		x = display.contentCenterX,
		y = display.contentCenterY,
		font = settings.fontName,
		fontSize = 45,
		width = 550,
		text = "Entrega las porciones adecuadas para tener una alimentación balanceada.",
		align = "center",
	}

	local explainText = display.newText(explainTextOptions)
	explainText.alpha = 0
	transition.to(explainText, {delay = 700, time = 600, alpha = 1, transition = easing.outQuad, onComplete = function()
		transition.to(explainText, {delay = 2600, time = 600, alpha = 0, transition = easing.outQuad, onComplete = function()
			display.remove(explainText)
		end})
	end})
	hudGroup:insert(explainText)
	
	sceneView:insert(hudGroup)
end

local function initialize(event)
	local params = event.params or {}
	
	dataSaver.initialize()
	analogCircleBounds.isVisible = false
	analogCircleBegan.isVisible = false
	analogCircleMove.isVisible = false
	
	isPaused = false
	
	isGameover = false
	isFoodSpawned = {
		["fruit"] = false,
		["vegetable"] = false,
		["protein"] = false,
	}
	
	foodTexts = {}
	targetAmounts = {
		["fruit"] = 0,
		["vegetable"] = 0,
		["protein"] = 0,
	}
	
	worldIndex = params.worldIndex
	levelIndex = params.levelIndex
	
	collectedFood = {
		["fruit"] = 0,
		["vegetable"] = 0,
		["protein"] = 0,
	}
	
	cameraEdit = {x = 0, y = 0}
	
	analogX = 0
	analogY = 0
	
	editCircle.isVisible = false
	
	easingFunctions = {}
--	for key, value in pairs(easing) do
--		easingFunctions[#easingFunctions + 1] = {name = key, value = value}
--	end
	easingFunctions[1] = {name = "linear", value = easing.linear}
	easingFunctions[2] = {name = "inSine", value = easing.inSine}
	easingFunctions[3] = {name = "outSine", value = easing.outSine}
	easingFunctions[4] = {name = "inOutSine", value = easing.inOutSine}
	easingFunctions[5] = {name = "outInSine", value = easing.outInSine}
	
	editorObjects = {}
	lastTwoCoordinates = {[1] = {x = 0, y = 0}, [2] = {x = 0, y = 0}}
	
	currentEasingXIndex = 1
	currentEasingYIndex = 1
	currentEasingX = easingFunctions[currentEasingXIndex].name
	currentEasingY = easingFunctions[currentEasingYIndex].name
	
end

local function updateGameLoop(event)
	if not isPaused then
		updateParallax()
		updateEnemies()
		showDebugInformation()
		enterFrame(event)
	end
end

local function intro()
	local function trackNextPlanet(planetIndex)
		if planetIndex <= #planets then
			camera:setFocus(planets[planetIndex])
			introTimer = timer.performWithDelay(1800, function()
				trackNextPlanet(planetIndex + 1)
			end)
		else
			camera.damping = 10
			camera:setFocus(playerCharacter)
			--transition.to(buttonBack, {alpha = 1, time = 500, transition = easing.outQuad})
			scene.enableButtons()
		end
	end
		
	camera.damping = 35
	camera:setFocus(earth)
	introTimer = timer.performWithDelay(1500, function()
		trackNextPlanet(1)
	end)
	
end
----------------------------------------------- Class functions 
function scene.backAction()
	robot.press(buttonPause)
	return true
end  

function scene.enableButtons()
	buttonPause:setEnabled(true)
end

function scene.disableButtons()
	buttonPause:setEnabled(false)
end

local function createGame()
	system.activate("multitouch")
	
	physics.setPositionIterations(1)
	physics.setVelocityIterations(1)
	physics.start()
--	physics.setDrawMode("hybrid")
	physics.setContinuous(false)
	physics.setGravity(0, 0)
	
	physicsObjectList = {}
	enemies = {}
	
	loadLevel()
	
	createPlayerCharacter()
	createBorders()
	createFoodBubbles()
	
	spaceships.start()
	camera:toPoint(0,0)
	camera:start()
	
	Runtime:addEventListener("touch", testTouch)
	Runtime:addEventListener("collision", collisionListener)
	Runtime:addEventListener("preCollision", preCollisionListener)
end

function scene:create(event)
	local sceneGroup = self.view
	
	createBackground(sceneGroup)
	sceneGroup:insert(backgroundGroup)
	
	camera = perspective.newCamera()
	sceneGroup:insert(camera)
	
	asteroidGroup = display.newGroup()
	camera:add(asteroidGroup)
	
	editorPreviewGroup = display.newGroup()
	camera:add(editorPreviewGroup)
	
	editCircle = display.newCircle(0,0,20,20)
	editCircle.isVisible = false
	asteroidGroup:insert(editCircle)
	
	buttonList.pause.onRelease = onReleasePause
	buttonPause = widget.newButton(buttonList.pause)
	buttonPause:scale(SCALE_BUTTON_BACK, SCALE_BUTTON_BACK)
	buttonPause.x = display.contentWidth - buttonPause.contentWidth * 0.5
	buttonPause.y = display.screenOriginY + buttonPause.contentHeight * 0.5
	sceneGroup:insert(buttonPause)
	
	analogCircleBegan = display.newCircle(0, 0, 30)
	analogCircleBegan.alpha = 0.2
	analogCircleBegan.isVisible = false
	sceneGroup:insert(analogCircleBegan)
	
	analogCircleMove = display.newCircle(0, 0, 30)
	analogCircleMove.alpha = 0.2
	analogCircleMove.isVisible = false
	sceneGroup:insert(analogCircleMove)
	
	analogCircleBounds = display.newCircle(0,0, RADIUS_ANALOG)
	analogCircleBounds.alpha = 0.8
	analogCircleBounds.strokeWidth = 3
	analogCircleBounds:setFillColor(0,0)
	analogCircleBounds:setStrokeColor(1)
	analogCircleBounds.isVisible = false
	sceneGroup:insert(analogCircleBounds)
	
	local debugTextOptions = {
		x = display.contentWidth - 100,
		y = display.screenOriginY + 100,
		font = settings.fontName,
		fontSize = 15,
		width = 400,
		text = "",
	}
	
	debugText = display.newText(debugTextOptions)
	debugText.anchorY = 0
	debugText.isVisible = false
end

function scene:destroy()
	
end

function scene:show( event )
	local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		initialize(event)
		createGame()
		setUpCamera()
		createHUD(sceneGroup)
		Runtime:addEventListener("enterFrame", updateGameLoop)
		Runtime:addEventListener( "key", onKeyEvent )
		self.disableButtons()
	elseif ( phase == "did" ) then
		intro()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		self.disableButtons()
	elseif ( phase == "did" ) then
		if introTimer then timer.cancel(introTimer) end
		playerCharacter:analog(0, 0)
		Runtime:removeEventListener("collision", collisionListener)
		Runtime:removeEventListener("preCollision", preCollisionListener)
		Runtime:removeEventListener("enterFrame", updateGameLoop)
		Runtime:removeEventListener( "key", onKeyEvent )
		director.hideOverlay()
		destroyGame()
	end
end

function scene:pause(pauseFlag)
	
	
	if pauseFlag then
		isPaused = true
		
	else
		
		isPaused = false
		director.hideOverlay()
		
	end
	
	
end

scene:addEventListener( "create" )
scene:addEventListener( "destroy" )
scene:addEventListener( "hide" )
scene:addEventListener( "show" )

return scene
