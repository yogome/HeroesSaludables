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
local extratable = require( "libs.helpers.extratable" )
local loseScene = require( "scenes.game.lose" )
local winScene = require( "scenes.game.win" )
local dataSaver = require("services.datasaver")
local obstacles = require("entities.obstacles")
local tutorial = require("services.tutorial")
local music = require("libs.helpers.music")

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
local controlGroup, objetivesGroup
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
local distanceLines 
local indicator
local earthIndicator
local disabledControl
local objetives
local currentTutorials
local circleGroup
local obstacleList
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
local gradientGroup
local foodBubbleIndex
-----------------------------------------------Vars used by level loader
local debugText
----------------------------------------------- Caches
local squareRoot = math.sqrt 
local mathRandom = math.random
local mathSin = math.sin
local mathCos = math.cos
local mathCeil = math.ceil
----------------------------------------------- Constants
local SIZE_GRID  = 100
local PADDING = 16
local RADIUS_TUTORIAL = 180
local SCALE_HEARTINDICATOR = 0.3
local SIZE_BACKGROUND = 1024
local OBJECTS_TOLERANCE_X = 100
local OBJECTS_TOLERANCE_Y = 100
local STARS_LAYER_DEPTH_RATIO = 0.08
local STARS_PER_LAYER = 30
local STARS_LAYERS = 3
local SCALE_BUTTON_BACK = 0.9
local NUMBER_HEARTS = 3
local BOUNDARY_SIZE = 200
local SIZE_FOOD_CONTAINER = {width = 140, height = 260}
local OFFSET_GRABFRUIT = {x = -62, y = 17}
local SCALE_EXPLOSION = 0.75
local SPEED_CAMERA = 100
local RADIUS_ANALOG = 300
local CONTROL = {
	DPAD = false,
	ANALOG = false,
	DRAG = true,
}
local MATH_PI = math.pi
----------------------------------------------- Functions

local function startTutorial(data)
	analogX = 0
	analogY = 0
	--analogCircleMove.x = 0
	--analogCircleMove.y = 0
	director.showOverlay("scenes.overlays.tutorial", {isModal = true, effect = "flip", params = {data = data}})
	scene:pause(true)
end

local function addPhysicsObject(object)
	physicsObjectList[#physicsObjectList + 1] = object
end 

local function createAsteroidLine(point1, point2, easingX, easingY)
	
	local pathAsteroids = {}
	
	local p2 = {x = point1.x, y = point1.y}
	local p1 = {x = point2.x, y = point2.y}

	local distanceX = p2.x - p1.x
	local distanceY = p2.y - p1.y
	local distance = squareRoot((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y))

	easingX = easingX or easing.linear
	easingY = easingY or easing.linear

	local chainBodyPoints = {}

	local iterations = mathCeil(distance / 90)
	local asteroidGraphics = {}
	for index = 1, iterations do
		local colisionPoints = {
			x = easingX(index - 1, iterations - 1, p1.x, distanceX),
			y = easingY(index - 1, iterations - 1, p1.y, distanceY)
		}
		
		chainBodyPoints[#chainBodyPoints + 1] = colisionPoints.x
		chainBodyPoints[#chainBodyPoints + 1] = colisionPoints.y
		
	end
	
	local iterations = mathCeil(distance)
	local asteroid = display.newImage("images/enviroment/asteroid"..mathRandom(1,3)..".png")
	asteroid.x = p1.x
	asteroid.y = p1.y
	pathAsteroids[#pathAsteroids + 1] = asteroid
	disposableAsteroidGroup:insert(asteroid)
	
	for index = 1, iterations do
		local newPositionX = easingX(index - 1, iterations - 1, p1.x, distanceX)
		local newPositionY = easingY(index - 1, iterations - 1, p1.y, distanceY)
		local lastAsteroid = pathAsteroids[#pathAsteroids]
		local lastAsteroidBoundsX = lastAsteroid.contentWidth * 0.6
		local lastAsteroidBoundsY = lastAsteroid.contentHeight * 0.6

		if (newPositionX >= lastAsteroid.x + lastAsteroidBoundsX or newPositionX <= lastAsteroid.x - lastAsteroidBoundsX) or
			(newPositionY >= lastAsteroid.y + lastAsteroidBoundsY or newPositionY <= lastAsteroid.y - lastAsteroidBoundsY) then
			
			local asteroid = display.newImage("images/enviroment/asteroid"..mathRandom(1,3)..".png")
			asteroid.rotation = mathRandom(0,360)
			 
			asteroid.x = newPositionX
			asteroid.y = newPositionY
			
			pathAsteroids[#pathAsteroids + 1] = asteroid
			disposableAsteroidGroup:insert(asteroid)
		end
	end

	local asteroidLineBody = display.newRect( 0, 0, 5, 5 )
	asteroidLineBody.name = "asteroid"
	asteroidLineBody.asteroidGraphics = pathAsteroids
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

local function successTutorial()
	local success = display.newImage("images/infoscreen/success.png")
	success.xScale = 0.1
	success.yScale = 0.1
	success.alpha = 0
	success.x = display.contentCenterX
	success.y = display.contentCenterY

	transition.to(success, {xScale = 1.2, transition = easing.outElastic, time = 1000})
	transition.to(success, {yScale = 1.2, transition = easing.outSine, time = 500})
	transition.to(success, {alpha = 1, time = 200, onComplete = function()
		transition.to(success, {delay = 500, alpha = 0, transition = easing.inSine, onComplete = function()
			display.remove(success)
		end})
	end})
end

local function updateTutorial()
	
	if currentTutorials and currentTutorials.hasTutorial then
		local shipPosition = worldsData[worldIndex][levelIndex].ship.position
		local diffShipX = shipPosition.x - playerCharacter.x
		local diffShipY = shipPosition.y - playerCharacter.y
		local distance = (diffShipX * diffShipX) + (diffShipY * diffShipY)
		distance = squareRoot(distance)
		if distance >= RADIUS_TUTORIAL then
				currentTutorials.success("moveOutCircle")
				currentTutorials.show("moveToBase", {onSuccess = successTutorial, onStart = startTutorial, delay = 1000})
		end
	end
	
	
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
	
	local iterations = mathCeil(distance / 55)
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

local function retryGame()
	director.hideScene("scenes.game.shooter")
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
		x: ]] .. math.ceil(playerCharacter.x) .. [[
		
		y: ]] .. math.ceil(playerCharacter.y) .. [[
		]]
--	debugText.text = [[
--		Press Q for player mode
--		Press E for edit mode
--		Press R to store coordinate
--		Press T to dump coordinate
--		
--		Press N,M to set draw mode
--		
--		Press L to dump level (NOT IMPLEMENTED)
--		
--		Press U to create asteroids
--		Press I to delete asteroids
--		
--		Press Z for previous easingX
--		Press X for next easingX
--		Current easingX: ]]..currentEasingX..[[
--		
--		Press A for previous easingY
--		Press S for next easingY
--		Current easingY: ]]..currentEasingY..[[
--		
--		P1 = {]]..lastTwoCoordinates[1].x..[[, ]]..lastTwoCoordinates[1].y..[[}
--		P2 = {]]..lastTwoCoordinates[2].x..[[, ]]..lastTwoCoordinates[2].y..[[}
--	]]
end

local function randomFoodByType(foodType)
	local bubbleSearchIndexes = {}
	for indexBubble = 1, #foodBubbleGroup.bubbles do
		local currentBubble = foodBubbleGroup.bubbles[indexBubble]
		if currentBubble.type == foodType then
			if indexBubble == foodBubbleIndex then
				bubbleSearchIndexes[-#bubbleSearchIndexes + 1] = indexBubble
			end
			
		end
	end
	return bubbleSearchIndexes[mathRandom(1, #bubbleSearchIndexes)]
end

local function spawnBubble(planet)
	
	if currentTutorials.hasTutorial then
		currentTutorials.show("baseTutorial", {onSuccess = successTutorial, onStart = startTutorial, delay = 0})
	end
	
	if not isFoodSpawned[planet.foodType] and not planet.isDisabled then
		sound.play("spawn")
		isFoodSpawned[planet.foodType] = true
		foodBubbleIndex = mathRandom(1, #foodlist[planet.foodType].food)
		local foundBubble = foodBubbleGroup.bubbles[planet.foodType][foodBubbleIndex]
		camera:add(foundBubble)

		local showBubble = function()
			foundBubble.x = planet.x + planet.foodOffset.x
			foundBubble.y = planet.y + planet.foodOffset.y
			foundBubble.alpha = 0
			foundBubble.xScale = 0.25
			foundBubble.yScale = 0.25
			foundBubble.isVisible = true
			foundBubble.isSpawned = true
			
			transition.to(foundBubble, {time = 400, alpha = 1, transition = easing.outQuad})

			physics.addBody(foundBubble, "dynamic", {density = 0, friction = 0, bounce = 1, radius = 60})
			foundBubble.gravityScale = 0
			foundBubble:applyLinearImpulse( mathRandom(-5,5)/100, mathRandom(-5,5)/100, foundBubble.x, foundBubble.y)
		end

		timer.performWithDelay(100, showBubble)
	end
end

local function grabFruit(fruit)
	if not fruit.isGrabbed then
		fruit.isGrabbed = true
		sound.play("grab")
		if currentTutorials.hasTutorial then
			currentTutorials.success("baseTutorial")
			currentTutorials.show("collectPortion", {onSuccess = successTutorial, onStart = startTutorial, delay = 1500})
		end
		
		local descriptionIndex = mathRandom(1, #fruit.description)
		hudGroup.infoIndicator.text = fruit.description[descriptionIndex]
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
				local function fruitListener()
					grabFruit(object)
				end
				timer.performWithDelay(100, fruitListener)
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

local function checkAmounts(foodType)
	local isComplete = false
	
	local portions = objetives[foodType].portions - 1
	if portions <= 0 then
		portions = 0
		objetives[foodType].label.isVisible = false
		
		local mark = objetives[foodType].mark
		mark.isVisible = true
		transition.from(mark, {alpha = 0, xScale = 2, yScale = 2, transition = easing.outBounce})
		
		for indexIndicator = 1, #indicator do
			print(indicator[indexIndicator].type)
			print(foodType)
			if indicator[indexIndicator].type == foodType then
				indicator[indexIndicator].disabled = true
			end
		end
		
		for indexPlanet = 1, #planets do
			local currentPlanet = planets[indexPlanet]
			if currentPlanet.foodType == foodType then
				currentPlanet.isDisabled = true
				currentPlanet.alpha = 0.5
			end
		end
	end
	
	objetives[foodType].label.text = portions
	objetives[foodType].portions = portions
	
	local collectedAll = true
	for key, value in pairs(objetives) do
		collectedAll = collectedAll and (objetives[key].portions <= 0)
	end
	
	if collectedAll then
		isComplete = true
	end
	
	if isComplete then
		if not isGameover then
			isGameover = true
			analogX = 0
			analogY = 0
			disabledControl = true
			local function onBackReleased()
				winScene.disableButtons()
				director.gotoScene("scenes.menus.levels", {params = {worldIndex = worldIndex}, effect = "fade", time = 500})
			end
			local function onRetryReleased()
				winScene.disableButtons()
				retryGame()
			end
			local function onPlayReleased()
				winScene.disableButtons()
				if levelIndex + 1 <= #worldsData[worldIndex] then
					dataSaver:unlockLevel(worldIndex, levelIndex+1)
				end
				dataSaver:setStars(worldIndex, levelIndex, heartIndicator.currentHearts)
				
				if levelIndex >= #worldsData[worldIndex] then
					if worldIndex + 1 <= #worldsData then
						dataSaver:unlockWorld(worldIndex + 1)
						director.gotoScene("scenes.menus.worlds", {params = {worldIndex = worldIndex}, effect = "fade", time = 500})	
					end
				else
					director.gotoScene("scenes.menus.levels", {params = {worldIndex = worldIndex}, effect = "fade", time = 500})
				end
				
			end
			winScene.show(heartIndicator.currentHearts, 200, onBackReleased, onRetryReleased, onPlayReleased)
			music.fade(1000)
		end
	end
	
	
end

local function collectBubble(earth)
	if playerCharacter.isCarringItem then
		
		hudGroup.infoIndicator.text = ""
		
		if currentTutorials.hasTutorial then
			currentTutorials.success("collectPortion")
			currentTutorials.show("finishLevel", {onSuccess = successTutorial, onStart = startTutorial, delay = 1000})
		end
		sound.play("planetcollect")
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
		playerCharacter.isCarringItem = false
		playerCharacter:setAnimation("opening")
		transition.to(playerCharacter.item, {transition = easing.outBounce, xScale = 1, yScale = 1, time = 500, onComplete = function()
			transition.to(playerCharacter.item, {alpha = 0, xScale = 0.5, yScale = 0.5, transition = easing.outCubic, time = 1000, x = earth.x, y = earth.y, onComplete = function()
				hideBubble()
			end})
		end})
		local foodType = playerCharacter.item.type
		
		checkAmounts(foodType)
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

local function suckFood(player, otherObject)
	
	if playerCharacter.isCarringItem then
		
		sound.play("hole")
		local foodData = foodlist[player.item.type]
		local fruit = display.newImage(foodData.food[foodBubbleIndex].asset)		
		fruit:scale(0.2,0.2)

		for indexIndicator = 1, #indicator do
			indicator[indexIndicator].isVisible = true
		end
		
		earthIndicator.isVisible = false
		
		local rotatingGroup = display.newGroup()
		camera:add(rotatingGroup)
		rotatingGroup.x = otherObject.x
		rotatingGroup.y = otherObject.y
		
		isFoodSpawned[playerCharacter.item.type] = false
		playerCharacter.isCarringItem = false
		
		local playerX, playerY = player:localToContent(0,0)
		local targetX, targetY = rotatingGroup:contentToLocal(playerX, playerY)
		fruit.x = targetX
		fruit.y = targetY
		rotatingGroup:insert(fruit)
		
		hideBubble()
		
		transition.to(rotatingGroup, {time = 2500, rotation = 900, transition = easing.inQuad})
		transition.to(fruit, {time = 500, xScale = 0.3, yScale = 0.3, transition = easing.outBounce})
		transition.to(fruit, {time = 2500, x = 0, y = 0, transition = easing.inQuad})
		transition.to(fruit, {delay = 2000, time = 500, alpha = 0, transition = easing.outQuad, onComplete = function()
			display.remove(fruit)
		end})
		
	end

	
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
					sound.play("fly2")
					damagePlayer()
					if not heartIndicator:removeHeart() then
						gameOver()
					end
				end
			end
		elseif otherObject.name == "bullet" then
			if element2 == 1 then
				if not playerCharacter.isDamaged then
					sound.play("fly2")
					addDamage(otherObject)
					damagePlayer()
				end
			end
		elseif otherObject.name == "blackhole" then
			suckFood(player, otherObject)
		end
		
	elseif player.name == "bullet" then
		if otherObject.name == "asteroid" then
			
			local explosionData = { width = 128, height = 128, numFrames = 16 }
			local explosionSheet = graphics.newImageSheet( "images/enemies/explosion.png", explosionData )

			local sequenceData = {
				{name = "explosion", sheet = explosionSheet, start = 1, count = 16, 1200, loopCount = 1},
			}

			local explosionSprite = display.newSprite( explosionSheet, sequenceData )
			explosionSprite:scale(SCALE_EXPLOSION, SCALE_EXPLOSION)
			explosionSprite:setSequence("explosion")
			explosionSprite.x = player.x
			explosionSprite.y = player.y
			explosionSprite:play()
			player.parent:insert(explosionSprite)
			player.removeFromWorld = true

			explosionSprite:addEventListener("sprite", function(event)
				if event.phase == "ended" then
					if explosionSprite.sequence == "closing" then
						display.remove(explosionSprite)
					end
				end
			end)
			
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
	
	local elementsTable = {
		--"images/backgrounds/star01.png",
		--"images/backgrounds/star02.png",
		--"images/backgrounds/element1.png",
		--"images/backgrounds/element2.png",
		--"images/backgrounds/element3.png",
		--"images/backgrounds/element4.png",
		--"images/backgrounds/element5.png",
		--"images/backgrounds/element6.png",
		"images/backgrounds/element7.png",
		--"images/backgrounds/element8.png",
		"images/backgrounds/element9.png",
		--"images/backgrounds/element10.png",
	}
	
	for layerIndex = 1, STARS_LAYERS do
		local starLayer = display.newGroup()
		backgroundContainer:insert(starLayer)
		for starsIndex = 1, STARS_PER_LAYER do
			local scale =  0.05 + layerIndex * 0.05
			
			local randomStarIndex = mathRandom(1, 1000)
			local star
			if randomStarIndex >= 1 and randomStarIndex < 900 then
				star = display.newCircle(500, 0, 20)
			elseif randomStarIndex >= 500 then
				local randomIndex = mathRandom(1, #elementsTable)
				star = display.newImage(elementsTable[randomIndex])
			end
			
			star.xOffset = mathRandom(objectSpawnX, objectDespawnX)
			star.yOffset = mathRandom(objectSpawnY, objectDespawnY)
			star.x = mathRandom(-containerHalfWidth, containerHalfWidth)
			star.y = mathRandom(-containerHalfHeight, containerHalfHeight)
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

local function controlDpad(event)
	
	if "began" == event.phase or "moved" == event.phase then
		display.getCurrentStage():setFocus(controlGroup)

		controlGroup.alpha = 0.5
		analogCircleMove.x = event.x - controlGroup.x 
		analogCircleMove.y = event.y - controlGroup.y

		local eventX = event.x - controlGroup.x
		local eventY = event.y - controlGroup.y

		local startX = 0
		local startY = 0

		local diffx = (eventX - startX)
		local diffy = (eventY - startY)
		local distance = squareRoot((diffx * diffx) + (diffy * diffy))
		local vx = diffx / distance
		local vy = diffy / distance

		if distance >= RADIUS_ANALOG then
			--analogX = diffx
			--analogY = diffy

			display.getCurrentStage():setFocus(nil)
			controlGroup.alpha = 1

			analogX = 0
			analogY = 0

			analogCircleMove.x =  0
			analogCircleMove.y =  0
		else
			analogX = diffx
			analogY = diffy

			analogCircleMove.x =  diffx
			analogCircleMove.y =  diffy
			display.getCurrentStage():setFocus(nil)
		end

	elseif "ended" == event.phase then
		analogX = 0
		analogY = 0

		controlGroup.alpha = 1
		analogCircleMove.x = 0
		analogCircleMove.y = 0
	end
end

local function controlDrag(event)
	
	if ("moved" == event.phase or "began" == event.phase) then
		
		local touchPositionX = -camera.scrollX + event.x
		local touchPositionY = -camera.scrollY + event.y
		
		controlGroup.x = touchPositionX
		controlGroup.y = touchPositionY
		
		local diffX = playerCharacter.x - controlGroup.x
		local diffY = playerCharacter.y - controlGroup.y
		
		analogX = -diffX
		analogY = -diffY
	elseif "ended" == event.phase then
		
		analogX = 0
		analogY = 0
		
		controlGroup.x = playerCharacter.x
		controlGroup.y = playerCharacter.y
	end
	
end

local function testTouch(event)
	if not disabledControl then
		if CONTROL.DPAD then
			controlDpad(event)
		elseif CONTROL.DRAG then
			controlDrag(event)
		end
	end
end

local function drawDebugGrid(levelWidth, levelHeight)
	
	local startX = levelWidth * -0.5
	local startY = levelHeight * -0.5
	
	local lineDistanceX = SIZE_GRID
	local lineDistanceY = SIZE_GRID
	local linesX = levelWidth / SIZE_GRID
	local linesY = levelHeight / SIZE_GRID
	
	for indexVertical = 0, linesX do
		local line = display.newLine(startX + (lineDistanceX * (indexVertical)),  startY, startX + (lineDistanceX * (indexVertical)), levelHeight)
		camera:add(line)
		line.strokeWidth = 2
	end
	
	for indexHorizontal = 0, linesY do
		local line = display.newLine(startX, startY + (lineDistanceY * (indexHorizontal)), levelWidth, startY + (lineDistanceY * (indexHorizontal)))
		camera:add(line)
		line.strokeWidth = 2
	end
end

local function createBorders()
	
	local levelData = worldsData[worldIndex][levelIndex]
	local levelWidth = levelData.levelWidth
	local levelHeight = levelData.levelHeight
	
	--drawDebugGrid(levelWidth, levelHeight)
	
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

local function createBubble(params)
	
	local bubbleGroup = display.newGroup()
	local bubble = display.newImage("images/food/bubble.png")
	local food = display.newImage(params.asset)
	food.xScale = 0.75
	food.yScale = 0.75
	
	bubbleGroup.name = "food"
	bubbleGroup.description = params.description
	bubbleGroup.type = params.foodType
	bubbleGroup.isSpawned = false
	bubbleGroup.isVisible = false

	bubbleGroup:insert(bubble)
	bubbleGroup:insert(food)
	
	return bubbleGroup
end

local function createFoodBubbles()
	foodBubbleGroup = display.newGroup()
	foodBubbleGroup.bubbles = {}
	
	for keyFood, valueFood in pairs(foodlist) do
		
		local currentFoodtype = foodlist[keyFood]
		
		foodBubbleGroup.bubbles[keyFood] = {}
		for indexFood = 1, #currentFoodtype.food do
			local currentFood = currentFoodtype.food[indexFood]

			local bubbleParams = {
				name = currentFood.name,
				foodType = keyFood,
				asset = currentFood.asset,
				description = currentFood.description
			}
			
			local newBubble = createBubble(bubbleParams)

			foodBubbleGroup.bubbles[keyFood][indexFood] = newBubble

			foodBubbleGroup:insert(newBubble)
			camera:add(foodBubbleGroup)
			addPhysicsObject(newBubble)
		end
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
	--earth = display.newImage(earthData.asset)
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
	
	physics.addBody(earth, "static", {radius = earth.contentWidth * 0.4, isSensor = true})
	camera:add(earth)
	addPhysicsObject(earth)
end

local function loadPlanets()
	planets = {}
	local planetsData = worldsData[worldIndex][levelIndex].planets
	
	for planetIndex = 1, #planetsData do
		local currentPlanetData = planetsData[planetIndex]
		local planetType = currentPlanetData.foodType
		local planet = display.newImage(foodlist[planetType].asset)
		
		physics.addBody(planet, "static", {density = 1, friction = 1, bounce = 1, radius = planet.contentWidth * 0.6, isSensor = true})
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
	local objetivesData = worldsData[worldIndex][levelIndex].objetives
	objetives = extratable.deepcopy(objetivesData)
end

local function loadEnemies()
	local enemySpawnData = worldsData[worldIndex][levelIndex].enemySpawnData
	for indexEnemy = 1, #enemySpawnData do
		local currentEnemySpawnData = enemySpawnData[indexEnemy]
		currentEnemySpawnData.fireFrame = 1/worldIndex
		local enemyObject = enemyFactory.newEnemy(currentEnemySpawnData)
		
--		local enemyText = display.newText(indexEnemy, 0, 0, settings.fontName, 90)
--		enemyObject:insert(enemyText)
		
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

local function loadObstacles()
	
	local obstacleData = worldsData[worldIndex][levelIndex].obstacle
	
	if obstacleData then
		for obstacleIndex = 1, #obstacleData do
			local currentObstacle = obstacleData[obstacleIndex]
			local obstacle = obstacles.newObstacle(currentObstacle.type)
			obstacle:scale(0.8, 0.8)
			obstacle.x = currentObstacle.position.x
			obstacle.y = currentObstacle.position.y 
			physics.addBody(obstacle, {isSensor = true, radius = 100})
			physicsObjectList[#physicsObjectList+1] = obstacle
			camera:add(obstacle)
		end
	end
	
end

local function loadLevel()
	loadEarth()
	loadPlanets()
	loadAsteroids()
	loadEnemies()
	loadObstacles()
	loadObjetives()
end


local function createObjetives()
	
	objetivesGroup = display.newGroup()
	local startY = 0
	local OFFSET_ICONX = 10
	local OFFSET_ICONY = 10
	for keyObjetive, valueObjetive in pairs(objetives) do
		local objetiveGroup = display.newGroup()
		
		if foodlist[keyObjetive] then
			
			local objetiveBackground = display.newImage("images/shooter/objetivesingle.png")
			objetiveBackground:scale(0.5,0.5)
			objetiveGroup:insert(objetiveBackground)
			
			local objetiveName = display.newText(foodlist[keyObjetive].name, 0, 0, settings.fontName, 15)
			objetiveName.y = -objetiveBackground.contentWidth * 0.27
			objetiveGroup:insert(objetiveName)
			
			local assetPath = foodlist[keyObjetive].asset
			local objetiveImage = display.newImage(assetPath)
			objetiveImage.x = -20
			objetiveImage.y = OFFSET_ICONY
			objetiveImage:scale(0.23, 0.23)
			objetiveGroup:insert(objetiveImage)
			
			local objetiveTextGroup = display.newGroup()
			local objetiveText = display.newText(objetives[keyObjetive].portions, 30, 0, settings.fontName, 32)
			objetives[keyObjetive].label = objetiveText
			objetiveTextGroup:insert(objetiveText)
			
			local objetiveMark = display.newImage("images/general/right_mark.png")
			objetives[keyObjetive].mark = objetiveMark
			objetiveMark.isVisible = false
			objetiveMark.x = 35
			objetiveTextGroup:insert(objetiveMark)
			
			objetiveTextGroup.y = OFFSET_ICONY
			
			objetiveGroup:insert(objetiveTextGroup)

			objetiveGroup.x = display.screenOriginX + (objetiveGroup.contentWidth * 0.4)
			objetiveGroup.y = display.contentHeight * 0.25 + startY

			hudGroup:insert(objetiveGroup)
			
			startY = startY + 125
		end
		
	end
end

local function createHUD(sceneView)
	local levelData = worldsData[worldIndex][levelIndex]
	
	display.remove(hudGroup)
	hudGroup = display.newGroup()
	hudGroup.x = display.screenOriginX
	hudGroup.y = display.screenOriginY
	
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
	
	local heartSpacing = 67
	
	local heartStartX = -((NUMBER_HEARTS - 1) * heartSpacing) * 0.54
	for index = 1, NUMBER_HEARTS do
		local heart = display.newImage("images/shooter/heart.png")
		heart:scale(SCALE_HEARTINDICATOR, SCALE_HEARTINDICATOR)
		heart.x = heartStartX + (index - 1) * heartSpacing
		heartIndicator:insert(heart)
		heartIndicator.hearts[index] = heart
	end
	
	heartIndicator:scale(0.7,0.7)
	heartIndicator.x = display.contentCenterX * 0.50
	heartIndicator.y = display.screenOriginY + PADDING + heartIndicatorBG.height * 0.5 * SCALE_HEARTINDICATOR
	hudGroup:insert(heartIndicator)
	
	local portionIndicator = display.newGroup()
	
	local portionBG = display.newImage("images/shooter/info.png")
	portionIndicator:insert(portionBG)
	
	local portionText = display.newText("", 0, 17, settings.fontName, 30)
	hudGroup.infoIndicator = portionText
	portionIndicator:insert(portionText)
	
	portionIndicator:scale(1, 1)
	portionIndicator.x = display.contentCenterX * 1.3
	portionIndicator.y = display.screenOriginY + PADDING + heartIndicatorBG.height * 0.1 * SCALE_HEARTINDICATOR
	hudGroup:insert(portionIndicator)
	
	createObjetives()
	
	sceneView:insert(hudGroup)
end

local function initialize(event)
	local params = event.params or {}
	
	dataSaver.initialize()
	
	
	disabledControl = true
	
	obstacleList = {}
	isPaused = false
	
	isGameover = false
	isFoodSpawned = {
		["fruit"] = false,
		["vegetable"] = false,
		["protein"] = false,
	}
	
	worldIndex = params.worldIndex
	levelIndex = params.levelIndex
	
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

local function indicatorUpdate(target, indicator)
	
	local currentIndicator = target
	--indicator.foodType = currentIndicator.foodType
				
	local diffX =(-camera.scrollX + display.contentWidth * 0.50) - currentIndicator.x
	local diffY =(-camera.scrollY + display.contentHeight * 0.50) - currentIndicator.y

	local angle = extramath.getFullAngle(-diffX, -diffY)
	indicator.rotation = angle

	local limitX = display.contentWidth * 0.45
	local limitY = display.contentHeight * 0.45
	
	if not indicator.disabled then
		if diffX < limitX and diffX > -limitX and diffY < limitY and diffY > -limitY then
			indicator.x = currentIndicator.x
			indicator.y = currentIndicator.y
			indicator.isVisible = false
		else
			indicator.isVisible = true
			if diffX >= limitX then
				indicator.x = (-camera.scrollX + display.contentWidth * 0.50) - limitX
			end

			if diffX <= -limitX then
				indicator.x = (-camera.scrollX + display.contentWidth * 0.50) + limitX
			end

			if diffY >= limitY then
				indicator.y = (-camera.scrollY + display.contentHeight * 0.50) - limitY
			end

			if diffY <= -limitY then
				indicator.y = (-camera.scrollY + display.contentHeight * 0.50) + limitY
			end
		end
	else
		indicator.isVisible = false
	end
end

local function updateIndicators()
		
		if not isGameover then
			for indexLine = 1, #planets do
				indicatorUpdate(planets[indexLine], indicator[indexLine])
			end
			indicatorUpdate(earth, earthIndicator)
		end
end

local function updateBullets()
	
		for index = #physicsObjectList, 1, -1 do		
			local physicsObject = physicsObjectList[index]
			if physicsObject then
				if physicsObject.x > (camera.contentWidth * 0.5) or physicsObject.x < (camera.contentWidth * -0.5) then
					physicsObject.removeFromWorld = true
				end
				if physicsObject.y > (camera.contentHeight * 0.5) or physicsObject.y < (camera.contentHeight * -0.5) then
					physicsObject.removeFromWorld = true
				end
			end
		end
end

local function updateGameLoop(event)
	if not isPaused and not isGameover then
		updateParallax()
		updateEnemies()
		updateBullets()
		--showDebugInformation()
		enterFrame(event)
		updateIndicators()
		updateTutorial()
	end
end

local function intro()
	local function trackNextPlanet(planetIndex)
		if planetIndex <= #planets then
			camera:setFocus(planets[planetIndex])
			introTimer = timer.performWithDelay(1800, function()
				disabledControl = true
				trackNextPlanet(planetIndex + 1)
			end)
		else
			camera.damping = 10
			disabledControl = false
			camera:setFocus(playerCharacter)
			if currentTutorials.hasTutorial then
				currentTutorials.show("moveOutCircle", {onSuccess = successTutorial, onStart = startTutorial, delay = 250})
			end
			--transition.to(buttonBack, {alpha = 1, time = 500, transition = easing.outQuad})
			scene.enableButtons()
		end
	end
	
	camera.damping = 10
	camera:setFocus(earth)
	introTimer = timer.performWithDelay(1500, function()
		trackNextPlanet(1)
	end)
end

local function createGradients(sceneGroup)
	
	gradientGroup = display.newGroup()
	
	local gradient = display.newImage("images/shooter/gradient_radial.png")
	gradient.alpha = 0.3
	gradient.x = display.contentCenterX
	gradient.y = display.contentCenterY
	gradientGroup:insert(gradient)

	sceneGroup:insert(gradientGroup)	
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
	
	if CONTROL.DPAD then
		controlGroup:addEventListener("touch", testTouch)
	elseif CONTROL.DRAG then
		controlGroup.alpha = 0
		Runtime:addEventListener("touch", testTouch)
	end
	
	Runtime:addEventListener("collision", collisionListener)
	Runtime:addEventListener("preCollision", preCollisionListener)
end

local function destroyGame()
	system.deactivate("multitouch")
	physics.pause()
	sound.stopPitch()
	controlGroup:removeEventListener("touch", testTouch)
	Runtime:removeEventListener("touch", testTouch)
	camera:stop()
	
	display.remove(objetivesGroup)
	display.remove(circleGroup)
	
	for index = #physicsObjectList, 1, -1 do
		camera:remove(physicsObjectList[index])
		display.remove(physicsObjectList[index])
		
		if physicsObjectList[index].asteroidGraphics then
			local currentAsteroidPath = physicsObjectList[index].asteroidGraphics
			for indexPath = 1, #currentAsteroidPath do
				display.remove(currentAsteroidPath[indexPath])
			end
		
		end
		
		physicsObjectList[index] = nil
		
	end
	
	physicsObjectList = nil
	
	spaceships.stop()
	physics.stop()
end

-------------------------

function scene:create(event)
	local sceneGroup = self.view
	
	createBackground(sceneGroup)
	sceneGroup:insert(backgroundGroup)
	
	createGradients(sceneGroup)
	
	camera = perspective.newCamera()
	camera.damping = 0
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
	
	controlGroup = display.newGroup()
	
	local circleControl = display.newCircle(0,0,60)
	circleControl:setFillColor(1)
	controlGroup:insert(circleControl)
	camera:add(controlGroup)
	
	if CONTROL.DPAD or CONTROL.ANALOG then
		
		--analogCircleBegan = display.newCircle(0, 0, 30)
		analogCircleBegan = display.newImage("images/general/dpad.png")
		--analogCircleBegan.alpha = 0.7
		controlGroup:insert(analogCircleBegan)

		analogCircleMove = display.newCircle(0, 0, 30)
		analogCircleMove.alpha = 0.2
		controlGroup:insert(analogCircleMove)

		analogCircleBounds = display.newCircle(0,0, RADIUS_ANALOG)
		analogCircleBounds.strokeWidth = 0
		analogCircleBounds:setFillColor(0,0)
		analogCircleBounds:setStrokeColor(1, 0.5)
		controlGroup:insert(analogCircleBounds)

		sceneGroup:insert(controlGroup)

		controlGroup.x = display.screenOriginX + controlGroup.contentWidth * 0.30
		controlGroup.y = display.contentHeight - controlGroup.contentHeight * 0.30
		
	end

	
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
	debugText.isVisible = true
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
		
		currentTutorials = tutorial.initializeTutorials(worldsData[worldIndex][levelIndex].tutorial)
		if currentTutorials.hasTutorial then
			
			circleGroup = display.newGroup()
			local radian = (MATH_PI / 180) * 50
			for indexDegree = 1, 50 do
				local x = mathSin(radian * indexDegree - 1) * 180
				local y = mathCos(radian * indexDegree - 1) * 180
				local circle = display.newCircle(x, y, 2)
				circle:setFillColor(1, 1)
				circleGroup:insert(circle)
			end

			camera:add(circleGroup)
			transition.to(circleGroup, {rotation = 360, iterations = -1, time = 8000})
		end
		
		distanceLines = {}
		indicator = {}
		
		for indexPlanet = 1, #planets do		
			local arrow = display.newImage("images/shooter/arrow.png")
			arrow.xScale = 0.3
			arrow.yScale = 0.3
			transition.to(arrow, {iterations = -1, xScale = 0.5, yScale = 0.5, transition = easing.continuousLoop})
			indicator[indexPlanet] = arrow
			indicator[indexPlanet].type = planets[indexPlanet].foodType
			camera:add(arrow)
		end
		
		earthIndicator = display.newImage("images/shooter/arrow.png")
		earthIndicator.isVisible = false
		earthIndicator.type = "planet"
		earthIndicator.xScale = 0.4
		earthIndicator.yScale = 0.4
		transition.to(earthIndicator, {iterations = -1, xScale = 0.9, yScale = 0.9, transition = easing.continuousLoop})
		camera:add(earthIndicator)
		
	elseif ( phase == "did" ) then
		--intro()		
		music.playTrack(4, 500)
		scene.enableButtons()
		camera:setFocus(playerCharacter)
		director.showOverlay("scenes.overlays.objetives", {effect = "fade", time = 300, isModal = true, params = {objetives = objetives}})
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
		
		for indexArrow = 1, #indicator do
			display.remove(indicator[indexArrow])
		end
		
		display.remove(earthIndicator)
		
		Runtime:removeEventListener("collision", collisionListener)
		Runtime:removeEventListener("preCollision", preCollisionListener)
		Runtime:removeEventListener("enterFrame", updateGameLoop)
		Runtime:removeEventListener( "key", onKeyEvent )
		director.hideOverlay()
		destroyGame()
	end
end

function scene:introGame()
	intro()
end

function scene:pause(pauseFlag)
	
	if pauseFlag then
		isPaused = true
		physics.pause()
	else
		isPaused = false
		director.hideOverlay()
		physics.start()
	end
end

scene:addEventListener( "create" )
scene:addEventListener( "destroy" )
scene:addEventListener( "hide" )
scene:addEventListener( "show" )

return scene
