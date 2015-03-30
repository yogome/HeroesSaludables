local physics = require("physics")
local extratable = require("libs.helpers.extratable")
local obstacleList = require("data.obstaclelist")

-----------------------------------Variables 
local obstacleModule = {}


-----------------------------------Constants


-----------------------------------Local functions

local function createObstacle(obstacleType)
	
	local obstacleData = obstacleList[obstacleType]
	--local scale = obstacleData.scale
	local sprite = obstacleData.spriteSheet
	local image = obstacleData.image
	local name = obstacleData.name
	
	local obstacle
	if sprite and not image then
	
		local spriteOptions = {
			width = 256,
			height = 256,

			sheetContentWidth = 2048,
			sheetContentHeight = 2048,

			numFrames = 64,
		}

		local spriteSheet = graphics.newImageSheet(sprite.path ,spriteOptions)

		local sequenceData = {
			name = "blackhole",
			start = 1,
			count = 64,
			time = 2600,
			loopCount = 0,
			loopDirection = "foward"
		}
		
		obstacle = display.newSprite(spriteSheet, sequenceData)
		obstacle.xScale = 2
		obstacle.yScale = 2
		obstacle:play()
		
	elseif image and not sprite then
		obstacle = display.newImage(image.path)
		
	end
	obstacle.name = name
	
	return obstacle
	
end

-----------------------------------

function obstacleModule.newObstacle(obstacleType)
	
	local obstacle = createObstacle("blackhole")
	
	return obstacle
	
end


return obstacleModule