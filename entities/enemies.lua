---------------------------------------------- Enemies
local extramath = require( "libs.helpers.extramath" ) 
local physics = require( "physics" )
local enemydata = require("data.enemydata")

local enemyEntity = {}
---------------------------------------------- Variables

---------------------------------------------- Constants

---------------------------------------------- Caches
local mathAbs = math.abs 
---------------------------------------------- Functions

--physics.setDrawMode("hybrid")

function enemyEntity.newEnemy(enemyType, speed, radius, pathStart, pathEnd)
	local enemy = {}
	enemy.radius = radius or 250
	enemy.pathStart = pathStart or {x = 0,y = 0}
	enemy.pathEnd = pathEnd or {x = 0, y = 0}
	enemy.shipSpeed = speed
	
	enemy.lengthX = enemy.pathEnd.x - enemy.pathStart.x
	enemy.lengthY = enemy.pathEnd.y - enemy.pathStart.y
	enemy.speedX = enemy.lengthX / enemy.shipSpeed
	enemy.speedY = enemy.lengthY / enemy.shipSpeed
	
	enemy.group = display.newGroup()
	enemy.group.isStoped = false
	enemy.group.isPlayerOnRange = false
	enemy.group.hasToReturn = false
	enemy.group.canFollowObject = false
	enemy.group.objectToFollow = nil
	enemy.group.flipSide = "right"
	enemy.group.returnX = 0
	enemy.group.returnY = 0
	enemy.group.returnSpeedX = 0
	enemy.group.returnSpeedY = 0
	enemy.group.calculatedDistance = false
	
	function enemy.group:flip(side)
		if side == "right" then
			if self.flipSide ~= "right" then
				self.flipSide = "right"
				self.xScale = 1
			end
		elseif side == "left" then
			if self.flipSide ~= "left" then
				self.flipSide = "left"
				self.xScale = -1
			end
		end
	end
	
	function enemy:setPosition(position)
		if self.pathStart.x > self.pathEnd.x then
			self.group:flip("left")
		end
		
		self.group.x = position.x
		self.group.y = position.y
	end
	
	function enemy.group:stop()
		self.isStoped = true
	end
	
	function enemy.group:move()
		self.isStoped = false
	end
	
	function enemy.group:shoot()
		
	end
	
	function enemy:follow()
		local stepX = self.group.objectToFollow.x - self.group.x
		local stepY = self.group.objectToFollow.y - self.group.y
		
		if stepX > 0 then
			self.group:flip("right")
		else
			self.group:flip("left")
		end
		
		self.group.x = self.group.x + (stepX  * 0.006)
		self.group.y = self.group.y + (stepY  * 0.006)
	end
	
	function enemy:returnToPatrol()
		--local distanceFromStart = math.sqrt((enemy.pathEnd.x - enemy.pathStart.x)*(enemy.pathEnd.x - enemy.pathStart.x) + (enemy.pathEnd.y - enemy.pathStart.y)*(enemy.pathEnd.y - enemy.pathStart.y))
		self.group.calculatedDistance = false
		if not self.group.calculatedDistance then
			
			self.group.returnSpeedX = mathAbs(self.group.x - self.group.returnX) * 0.005
			self.group.returnSpeedY = mathAbs(self.group.y - self.group.returnY) * 0.005
			
			self.group.calculatedDistance = true
		end
		
		if self.group.x > self.pathStart.x then
			self.group.returnSpeedX = self.group.returnSpeedX * -1
			self.group:flip("left")
		else
			self.group:flip("right")
		end
		
		if self.group.y > self.pathStart.y then
			self.group.returnSpeedY = self.group.returnSpeedY * -1
		end
		
		self.group.x = self.group.x + self.group.returnSpeedX
		self.group.y = self.group.y + self.group.returnSpeedY
		
	end
	
	function enemy.group:setReturnPoint()
		if enemy.pathStart.x > enemy.pathEnd.x then
			self.returnX = (enemy.pathStart.x - enemy.pathEnd.x)/2	
		else
			self.returnX = (enemy.pathStart.x + enemy.pathEnd.x)/2
		end
		
		if enemy.pathStart.y > enemy.pathEnd.x then
			self.returnY = (enemy.pathStart.y - enemy.pathEnd.y)/2
		else
			self.returnY = (enemy.pathStart.y + enemy.pathEnd.y)/2
		end
		
	end
	
	function enemy.group:setFollowing(onrange, object)
		self.isPlayerOnRange = onrange
		self.objectToFollow = object
	end
	
	function enemy:patrol()
	
		--if not self.group.isStoped and not self.group.isPlayerOnRange and not self.group.hasToReturn then
			if self.pathEnd.x > self.pathStart.x then
				if self.group.x < self.pathStart.x then
					self.group.x = self.pathStart.x
					self.group.y = self.pathStart.y
					self.speedX = self.speedX * -1
					self.group:flip("right")
				end

				if self.group.x > self.pathEnd.x then
					self.group.x = self.pathEnd.x
					self.group.y = self.pathEnd.y
					self.speedX = self.speedX * -1
					self.group:flip("left")
				end
			else

				if self.group.x > self.pathStart.x then
					self.group.x = self.pathStart.x
					self.group.y = self.pathStart.y
					self.speedX = self.speedX * -1
					self.group:flip("left")
				end

				if self.group.x < self.pathEnd.x then
					self.group.x = self.pathEnd.x
					self.group.y = self.pathEnd.y
					self.speedX = self.speedX * -1
					self.group:flip("right")
				end
			end

			if self.pathEnd.y > self.pathStart.y then
				if self.group.y < self.pathStart.y then
					self.group.y = self.pathStart.y
					self.group.x = self.pathStart.x
					self.speedY = self.speedY * -1
				end
				if self.group.y > self.pathEnd.y then
					self.group.y = self.pathEnd.y
					self.group.x = self.pathEnd.x
					self.speedY = self.speedY * -1
				end

			else
				if self.group.y > self.pathStart.y then
					self.group.y = self.pathStart.y
					self.group.y = self.pathStart.y
					self.speedY = self.speedY * -1
				end

				if self.group.y < self.pathEnd.y then
					self.group.y = self.pathEnd.y
					self.group.y = self.pathEnd.y
					self.speedY = self.speedY * -1
				end
			end

			self.group.x = self.group.x + self.speedX
			self.group.y = self.group.y + self.speedY
		--end
	end
	
	local function getEnemyTypes()
		local enemyTypes = {}
		for indexType = 1, #enemydata do
			enemyTypes[enemydata[indexType].type] = enemydata[indexType].asset
		end
		return enemyTypes
	end
	
	local function getAssetByType(type)
		local enemyTypes = getEnemyTypes()
		local asset = enemyTypes[type]
		return asset
	end
	
	local function createDisplayObject(type)
		local enemyAsset = getAssetByType(type)
		local enemyDisplay = display.newImage(enemyAsset)
		return enemyDisplay
	end
	
	local function drawEnemyRange(radius)
		radius = radius or 250
		
		local group = display.newGroup()
		local x, y = 0, 0
		local step = (math.pi * 2)/(enemy.radius * 0.2)
		for indexDots = 0, math.pi*2, step do
			local dot = display.newCircle(radius * math.sin(x), radius * math.cos(y), 5)
			x = x + step
			y = y + step
			
			dot.alpha = 0.5
			group:insert(dot)
		end
		
		return group
	end

	local enemyShip = createDisplayObject(enemyType)
	enemyShip:scale(0.25, 0.25)
	enemy.group:insert(enemyShip)
	
	local enemyRange = drawEnemyRange(enemy.radius)
	enemy.group:insert(enemyRange)
	
	enemy:setPosition(enemy.pathStart)
	
	physics.addBody(enemy.group, "dynamic",  {radius = enemy.radius, isSensor = true})
	enemy.group.gravityScale = 0
	
	return enemy
end


return enemyEntity

