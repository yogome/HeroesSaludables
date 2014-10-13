---------------------------------------------- Spaceships
local extramath = require( "libs.helpers.extramath" ) 
local logger = require( "libs.helpers.logger" )
local physics = require( "physics" )

local spaceships = {}
---------------------------------------------- Variables
local started
local spaceshipList
---------------------------------------------- Constants
local ANALOG_MAX = 128
---------------------------------------------- Functions
local function enterFrame()
	for index = #spaceshipList, 1, -1 do
		local spaceship = spaceshipList[index]
		if spaceship then
			local vX, vY = spaceship:getLinearVelocity()
			spaceship.rotation = extramath.getFullAngle(vX, vY) + 90
		end
	end
end

local function createNewShip(newShip, shipData)
	
	physics.addBody( newShip, {density = 0.01, friction = 0.3, bounce = 0.2, radius = 32 * 0.8})
	newShip.gravityScale = 0
	newShip.isFixedRotation = true
	newShip.linearDamping = 2
	
	newShip.speedRatio = 75
	
	local thrustData = { width = 32, height = 32, numFrames = 2, sheetContentWidth = 64, sheetContentHeight = 32 }
	local thrustSheet = graphics.newImageSheet( "images/shooter/thrust.png", thrustData )

	local sequenceData = {
		{ name="thrust", start = 1, count = 2, time = 100, loopCount = 0 },
	}

	local thrust = display.newSprite( thrustSheet, sequenceData )
	thrust.xScale = 0.5
	thrust.yScale = 0.5
	thrust.x = -32
	newShip.thrust = thrust
	newShip:insert(thrust)
	
	thrust:setSequence("thrust")
	thrust:play()
	
	local shipImage = display.newImageRect("images/shooter/spaceship.png", 64, 64)
	newShip:insert(shipImage)
	
	function newShip:analog(analogX, analogY)
		if analogX ~= 0 or analogY ~= 0 then
			if analogX > ANALOG_MAX then analogX = ANALOG_MAX end
			if analogY > ANALOG_MAX then analogY = ANALOG_MAX end
			if analogX < -ANALOG_MAX then analogX = -ANALOG_MAX end
			if analogY < -ANALOG_MAX then analogY = -ANALOG_MAX end
			
			analogX = analogX * self.speedRatio
			analogY = analogY * self.speedRatio
			
			self:setLinearVelocity(analogX, analogY, 0, 0)
		end
	end
end
function spaceships.start()
	if not started then
		started = true
		if not spaceshipList then
			spaceshipList = {}
		end
		Runtime:addEventListener("enterFrame", enterFrame)
	else
		logger.log("[Spaceships] start has already been called.")
	end
end

function spaceships.stop()
	if started then
		started = false
		Runtime:removeEventListener("enterFrame", enterFrame)
		
		for index = #spaceshipList, 1, -1 do
			display.remove(spaceshipList[index])
			spaceshipList[index] = nil
		end
	
		spaceshipList = nil
	else
		logger.log("[Spaceships] Stop should be called after start.")
	end
end

function spaceships.new(shipData)
	if not spaceshipList then
		spaceshipList = {}
	end
	
	local shipData = shipData or {}
	if not "table" == type(shipData) then
		error("shipData must be a table", 3)
	end
		
	local newShip = display.newGroup()
	
	createNewShip(newShip, shipData)
	
	spaceshipList[#spaceshipList + 1] = newShip
	return newShip
end

return spaceships
