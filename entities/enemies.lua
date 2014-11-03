---------------------------------------------- Enemies
local extramath = require( "libs.helpers.extramath" ) 
local physics = require( "physics" )
local enemydata = require("data.enemydata")
local extratable = require( "libs.helpers.extratable" )
local enemyFactory = {}
---------------------------------------------- Variables

---------------------------------------------- Constants
local COLOR_OUTER_RANGE_CIRCLE = {0.5,0.1}
local COLOR_INNER_RANGE_CIRCLE = {0.5,0.1}
local THRESHOLD_PATROLTIME = 8
local TOLERANCE_PATROL = 10
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
			return not rayCast[1].object.name == "asteroid"
		end
	end
end

local function updatePatrol(self)
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
---------------------------------------------- Module functions
function enemyFactory.newEnemy(enemySpawnData)
	local currentEnemyData = enemydata[enemySpawnData.type]
	
	local enemy = display.newGroup()
	enemy.spawnData = extratable.deepcopy(enemySpawnData)
	
	enemy.x = enemy.spawnData.spawnPoint.x
	enemy.y = enemy.spawnData.spawnPoint.y
	
	enemy.viewRadius = currentEnemyData.viewRadius
	enemy.speed = currentEnemyData.speed
	
	enemy.targetPatrolPoint = 1
	enemy.target = nil
	enemy.isPatroling = false
	
	enemy.isTargetViewable = isTargetViewable
	enemy.updatePatrol = updatePatrol
	
	function enemy:update()
		if self.target then
			if self:isTargetViewable() then
				
			else
				self:updatePatrol()
			end
		else
			self:updatePatrol()
		end
	end
	
	function enemy:setTarget(newTarget)
		self.target = newTarget
	end
	
	local enemyImage = display.newImage(currentEnemyData.asset)
	enemyImage:scale(0.25, 0.25)
	enemy:insert(enemyImage)
	
	local enemyRange = createVisualRange(enemy.viewRadius)
	enemy:insert(enemyRange)
	
	return enemy
end


return enemyFactory

