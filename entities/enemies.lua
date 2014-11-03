---------------------------------------------- Enemies
local extramath = require( "libs.helpers.extramath" ) 
local physics = require( "physics" )
local enemydata = require("data.enemydata")

local enemyEntity = {}
---------------------------------------------- Variables

---------------------------------------------- Constants
local COLOR_OUTER_RANGE_CIRCLE = {0.5,0.1}
local COLOR_INNER_RANGE_CIRCLE = {0.5,0.1}
---------------------------------------------- Caches
local mathAbs = math.abs 
---------------------------------------------- Functions

--physics.setDrawMode("hybrid")

function enemyEntity.newEnemy(enemyType, patrolData)
	local currentEnemyData = enemydata[enemyType]
	local enemy = {}
	enemy.radius = currentEnemyData.viewRadius
	enemy.pathStart = patrolData.startPoint
	enemy.pathEnd = patrolData.endPoint
	enemy.shipSpeed = currentEnemyData.speed
	
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
	
	local function createVisualRange()
		local visualRange = display.newGroup()
		local outerRangeCircle = display.newCircle(0, 0, enemy.radius)
		outerRangeCircle:setFillColor(unpack(COLOR_OUTER_RANGE_CIRCLE))
		visualRange:insert(outerRangeCircle)
		
		local innerRangeCircle = display.newCircle(0, 0, enemy.radius * 0.8)
		innerRangeCircle:setFillColor(unpack(COLOR_INNER_RANGE_CIRCLE))
		visualRange:insert(innerRangeCircle)
		return visualRange
	end

	local enemyImage = display.newImage(currentEnemyData.asset)
	enemyImage:scale(0.25, 0.25)
	enemy.group:insert(enemyImage)
	
	local enemyRange = createVisualRange()
	enemy.group:insert(enemyRange)
	
	enemy:setPosition(enemy.pathStart)
	
	physics.addBody(enemy.group, "dynamic",  {radius = enemy.radius, isSensor = true})
	enemy.group.gravityScale = 0
	
	return enemy
end


return enemyEntity

