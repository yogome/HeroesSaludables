----------------------------------------------- Shooter space game
local composer = require( "composer" )
local widget = require( "widget" )
local buttonList = require( "data.buttonlist" )
local sound = require( "libs.helpers.sound" )
local perspective = require( "libs.helpers.perspective" )
local robot = require( "libs.helpers.robot" )
local spaceships = require( "entities.spaceships" )
local physics = require( "physics" )
local scene = composer.newScene() 
----------------------------------------------- Variables
local buttonBack 
local camera
local playerCharacter
local dynamicObjects
local analogX, analogY
local analogCircleBegan
local analogCircleMove
local spaceObjects, objectDespawnX, objectSpawnX, objectDespawnY, objectSpawnY
local spawnZoneWidth, spawnZoneHeight, halfSpawnZoneWidth, halfSpawnZoneHeight
local backgroundGroup
----------------------------------------------- Constants
local padding = 16
local SIZE_BACKGROUND = 1024
local OBJECTS_TOLERANCE_X = 100
local OBJECTS_TOLERANCE_Y = 100
local STARS_LAYER_DEPTH_RATIO = 0.08
local STARS_PER_LAYER = 8
local STARS_LAYERS = 6
----------------------------------------------- Functions
--

local function updateWorlds()
	--ocal scrollX, scrollY = menu:getContentPosition()
	--if not movingMenu then
	--	selectedWorldIndex = math.round((-scrollX)/ SIZE_WORLD_ITEM)
	--end
	
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
			local scale =  0.05 + layerIndex * 0.05
			
			local star = display.newCircle(500, 0, 20)
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

local function createTestWalls()
	
	local testRect1 = display.newRect(-1000-25,0,50, 2000)
	physics.addBody( testRect1, {density = 1.0, friction = 0.1, bounce = 0.5})
	--testRect1:setFillColor(1,1,0)
	testRect1.bodyType = "static"
	camera:add(testRect1)
	
	local testRect2 = display.newRect(1000+25, 0 ,50,2000)
	physics.addBody( testRect2, {density = 1.0, friction = 0.1, bounce = 0.5})
	--testRect2:setFillColor(1,1,0)
	testRect2.bodyType = "static"
	camera:add(testRect2)
	
	local testRect3 = display.newRect(0,-1000-25,2000,50)
	physics.addBody( testRect3, {density = 1.0, friction = 0.1, bounce = 0.5})
	--testRect3:setFillColor(1,1,0)
	testRect3.bodyType = "static"
	camera:add(testRect3)
	
	local testRect4 = display.newRect(0,1000+25,2000,50)
	physics.addBody( testRect4, {density = 1.0, friction = 0.1, bounce = 0.5})
	--testRect4:setFillColor(1,1,0)
	testRect4.bodyType = "static"
	camera:add(testRect4)
	
	addDynamicObject(testRect1)
	addDynamicObject(testRect2)
	addDynamicObject(testRect3)
	addDynamicObject(testRect4)
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

local function createPlayerCharacter()
	local shipData = {
	
	}
	playerCharacter = spaceships.new(shipData)
	camera:add(playerCharacter)
	
	addDynamicObject(playerCharacter)
end

local function enterFrame()
	local velocityX, velocityY = playerCharacter:getLinearVelocity()
	--sound.setPitch(0.8 + (math.abs(velocityX) + math.abs(velocityY)) * 0.0005)
	
	if analogX and analogY then
		playerCharacter:analog(analogX * 0.01, analogY * 0.01)
	end
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
	sound.playPitch("machine")
	Runtime:addEventListener("touch", testTouch)
	Runtime:addEventListener("enterFrame", enterFrame)
	
	physics.setPositionIterations(1)
	physics.setVelocityIterations(1)
	physics.start()
	physics.setContinuous(false)
	physics.setGravity(0, 10)
	
	dynamicObjects = {}
	
	createPlayerCharacter()
	--createEnemy()
	--createTestCubes()
	createTestWalls()
	
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
	camera = perspective.newCamera()
	camera:setBounds(-500, 500, -750, 750)
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
		
		Runtime:addEventListener("enterFrame", updateWorlds)
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