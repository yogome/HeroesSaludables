---------------------------------------------- Enemies
local extramath = require( "libs.helpers.extramath" ) 
local physics = require( "physics" )
local enemydata = require("data.enemydata")
local extratable = require( "libs.helpers.extratable" )
local sound = require( "libs.helpers.sound" )
local enemyFactory = {}
---------------------------------------------- Variables

---------------------------------------------- Constants
local COLOR_OUTER_RANGE_CIRCLE = {0.5,0.2}
local COLOR_INNER_RANGE_CIRCLE = {0.5,0.3}
local THRESHOLD_PATROLTIME = 8
local TOLERANCE_PATROL = 10
local THRESHOLD_FOLLOWSPEED = 0.01
local THRESHOLD_ROTATION_ANIMATION = 2
local SCALE_ENEMY = 0.7
---------------------------------------------- Caches
local mathAbs = math.abs 
local squareRoot = math.sqrt
---------------------------------------------- Functions
local function createVisualRange(radius)
	local visualRange = display.newGroup()
	local outerRangeCircle = display.newCircle(0, 0, radius)
	outerRangeCircle:setFillColor(unpack(COLOR_OUTER_RANGE_CIRCLE))
	visualRange:insert(outerRangeCircle)

	local innerRangeCircle = display.newCircle(0, 0, radius * 0.8)
	innerRangeCircle:setFillColor(unpack(COLOR_INNER_RANGE_CIRCLE))
	visualRange:insert(innerRangeCircle)
	return visualRange
end 

local function isTargetViewable(self)
	if self.target then
		local rayCast = physics.rayCast(self.x, self.y,	self.target.x, self.target.y)
			
		if rayCast and rayCast[1] and rayCast[1].object then
			return rayCast[1].object.name ~= "asteroid"
		end
	end
end

local function updatePatrol(self)
	local vY = -(self.oldY - self.y)
	self.rotation = (self.rotation + (vY * THRESHOLD_ROTATION_ANIMATION) * self.xScale) * 0.5
	self.oldY = self.y
		
	local targetPathPoint = self.spawnData.patrolPath[self.targetPatrolPoint]
	local targetX = targetPathPoint.x
	local targetY = targetPathPoint.y
	
	local differenceX = targetX - self.x
	local differenceY = targetY - self.y
	self.xScale = differenceX > 0 and 1 or -1
	
	local function startPatrol()
		local distance = squareRoot(differenceX * differenceX + differenceY * differenceY)
		local patrolTime = (distance / self.speed) * THRESHOLD_PATROLTIME
		transition.cancel(self)
		self.isPatroling = true
		transition.to(self, {delay = 200, time = patrolTime ,x = targetX, y = targetY, transition = easing.inOutQuad})
	end
	
	if not self.isPatroling then
		startPatrol()
	else
		local hasArrivedX = targetX - TOLERANCE_PATROL < self.x and self.x < targetX + TOLERANCE_PATROL
		local hasArrivedY = targetY - TOLERANCE_PATROL < self.y and self.y < targetY + TOLERANCE_PATROL

		if hasArrivedX and hasArrivedY then
			local nextTargetPatrolPoint = self.targetPatrolPoint + 1
			if nextTargetPatrolPoint > #self.spawnData.patrolPath then
				nextTargetPatrolPoint = 1
			end
			self.targetPatrolPoint = nextTargetPatrolPoint
			self.isPatroling = false
		end
	end
end

local function followTarget(self)
	local vY = -(self.oldY - self.y)
	
	self.rotation = (self.rotation + (vY * THRESHOLD_ROTATION_ANIMATION) * self.xScale) * 0.5
	self.oldY = self.y
	
	if self.target and not self.target.removeFromWorld then
		if self.isPatroling then
			transition.cancel(self)
			self.isPatroling = false
		end
		
		local differenceX = self.target.x - self.x
		local differenceY = self.target.y - self.y
		
		local stepX = differenceX * 1.8
		local stepY = differenceY * 1.8
		
		self.xScale = differenceX > 0 and 1 or -1

		self.x = self.x + (stepX  * THRESHOLD_FOLLOWSPEED)
		self.y = self.y + (stepY  * THRESHOLD_FOLLOWSPEED)
	end
end

local function shootTarget(self)
	if self.target and not self.target.removeFromWorld then
		if self.isPatroling then
			transition.cancel(self)
			self.isPatroling = false
			self.currentFireFrame = 0
		end
		
		self.currentFireFrame = self.currentFireFrame + 1
		
		local differenceX = self.target.x - self.x
		local differenceY = self.target.y - self.y
		self.xScale = differenceX > 0 and 1 or -1
		local distance = squareRoot(differenceX * differenceX + differenceY * differenceY)

		local normalX = differenceX / distance
		local normalY = differenceY / distance

		local rotation = extramath.getFullAngle(differenceX, differenceY) + 90
		self.rotation = self.xScale > 0 and rotation or (rotation - 180)
			
		if self.currentFireFrame >= self.data.projectileData.fireFrame then
			local projectileSpeed = self.data.projectileData.speed
			
			self.currentFireFrame = 0
			local bullet = display.newImage(self.data.projectileData.asset)
			self.parent:insert(bullet)
			
			bullet.x = self.x
			bullet.y = self.y
			bullet.rotation = rotation
			bullet.xScale = 0.15
			bullet.yScale = 0.15
			bullet.alpha = 0
			bullet.name = "bullet"

			physics.addBody( bullet, "dynamic", { friction = 1, radius = 15, density=0, isSensor = true } )
			bullet.isBullet = true
			bullet.gravityScale = 0
			bullet.linearDamping = -0.5
			bullet:applyForce(normalX * projectileSpeed, normalY * projectileSpeed, bullet.x, bullet.y)
			
			if self.onBulletCreate then
				self.onBulletCreate(bullet)
			end	
			
			sound.play("enemyshoot")
			transition.to(bullet, {time = 100, alpha = 1, transition = easing.outQuad})
		end
	end
end

local function shootAtAngle(self, angle)
		
		local angle = self.angle
		local angleRadians = (math.pi / 180) * ((90) + angle)
		self.currentFireFrame = self.currentFireFrame + 1
		
		local x = math.sin(angleRadians)
		local y = math.cos(angleRadians)
		
		local differenceX = x
		local differenceY = y
		
		self.xScale = differenceX > 0 and 1 or -1
		local distance = squareRoot(differenceX * differenceX + differenceY * differenceY)

		local normalX = differenceX / distance
		local normalY = differenceY / distance

		local rotation = extramath.getFullAngle(differenceX, differenceY) + 90
		self.rotation = self.xScale > 0 and rotation or (rotation - 180)
			
		if self.currentFireFrame >= self.data.projectileData.fireFrame then
			local projectileSpeed = self.data.projectileData.speed
			
			self.currentFireFrame = 0
			local bullet = display.newImage(self.data.projectileData.asset)
			self.parent:insert(bullet)
			
			bullet.x = self.x
			bullet.y = self.y
			bullet.rotation = rotation
			bullet.xScale = 0.30
			bullet.yScale = 0.30
			bullet.alpha = 0
			bullet.name = "bullet"

			physics.addBody( bullet, "dynamic", { friction = 1, radius = 15, density=0, isSensor = true } )
			bullet.isBullet = true
			bullet.gravityScale = 0
			bullet.linearDamping = 0
			bullet:applyForce(normalX * projectileSpeed, normalY * projectileSpeed, bullet.x, bullet.y)
			
			if self.onBulletCreate then
				self.onBulletCreate(bullet)
			end	
			
			sound.play("enemyshoot")
			transition.to(bullet, {time = 500, alpha = 1, transition = easing.outQuad})
		end
end
---------------------------------------------- Module functions
function enemyFactory.newEnemy(enemySpawnData)
	local currentEnemyData = enemydata[enemySpawnData.type]
	
	local enemy = display.newGroup()
	enemy.spawnData = extratable.deepcopy(enemySpawnData)
	enemy.data = currentEnemyData
	enemy.type = enemySpawnData.type
	enemy.angle = enemySpawnData.angle or 0
	
	enemy.x = enemy.spawnData.spawnPoint.x
	enemy.y = enemy.spawnData.spawnPoint.y
	
	enemy.viewRadius = currentEnemyData.viewRadius
	enemy.speed = currentEnemyData.speed
	enemy.range = currentEnemyData.range
	
	enemy.targetPatrolPoint = 1
	enemy.target = nil
	enemy.isPatroling = false
	enemy.currentFireFrame = 0
	
	enemy.oldY = 0
	
	enemy.isTargetViewable = isTargetViewable
	enemy.updatePatrol = updatePatrol
	enemy.followTarget = followTarget
	enemy.shootTarget = shootTarget
	enemy.shootAtAngle = shootAtAngle
	
	function enemy:update()
		if self.type == "canoner" or self.type == "follower" then
			if self.target then
				if self:isTargetViewable() then
					if currentEnemyData.onHasTarget == "follow" then
						self:followTarget()
					elseif currentEnemyData.onHasTarget == "shoot" then
						self:shootTarget()
					end
				else
					self:updatePatrol()
				end
			else
				self:updatePatrol()
			end
			
		elseif self.type == "shooter" then
			self:shootAtAngle()
		end
		
	end
	
	function enemy:setTarget(newTarget)
		self.target = newTarget
	end
	
	local enemyData = { width = currentEnemyData.spriteSheetWidth / 4, height = currentEnemyData.spriteSheetHeight / 2, numFrames = 8 }
	local enemySprite = graphics.newImageSheet( currentEnemyData.asset, enemyData )

	local enemySequenceData = {
		{name = "enemyAnimation", sheet = enemySprite, start = 1, count = 8, 1200},
	}
	
	local enemyRange = createVisualRange(enemy.viewRadius)
	enemy:insert(enemyRange)
	
	local enemyImage = display.newSprite( enemySprite, enemySequenceData )
	enemyImage:scale(SCALE_ENEMY, SCALE_ENEMY)
	enemyImage:setSequence("idleOpen")
	enemyImage:play()
	
	
--	local enemyImage = display.newImage(currentEnemyData.asset)
--	enemyImage:scale(0.25, 0.25)
	enemy:insert(enemyImage)
	
	return enemy
end


return enemyFactory

