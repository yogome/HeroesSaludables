-----------------Constants
local screenLeft = display.screenOriginX
local screenWidth = display.viewableContentWidth - screenLeft * 2
local screenTop = display.screenOriginY
local screenHeight = display.viewableContentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight 
local numberOfBacks = 4
local scale = (display.viewableContentHeight / 768) * 1024 * numberOfBacks
--------------------------------------

local worldsData = {
	-- World 1
--	[4] = {
--		path = {easingX = easing.linear, easingY = easing.inOutCubic},
--		icon = "images/worlds/mundos01.png",
--		[1] = {
--			levelWidth = 2048,
--			levelHeight = 2048,
--			ship = {position = { x = -724, y = -724}},
--			objetives = {fruit = {portions = 3}},
--			enemySpawnData = {
--			},
--			obstacle = {
--				[1] = {
--					type = "blackhole",
--					position = {x = 76, y = -324},
--				},
--			},
--			earth = {
--				position = { x = 876, y = 876},
--				name = "earth",
--				assetPath = "images/planets/earth/",
--				scaleFactor = 1.5,
--			},
--			planets = {
--				[1] = {
--					foodType = "cereal",
--					position = {x = 76, y = -524},
--				},
--			},
--			asteroids = {
--				[1] = {
--					lineStart = { x = -724, y = -524},
--					lineEnd = { x = -124, y = -524},
--					easingX = easing.linear,
--					easingY = easing.linear,
--				},
--				[2] = {
--					lineStart = { x = -124, y = -924},
--					lineEnd = { x = 276, y = -924},
--					easingX = easing.linear,
--					easingY = easing.linear,
--				},
--				[3] = {
--					lineStart = { x = 276, y = -924},
--					lineEnd = { x = 276, y = -524},
--					easingX = easing.linear,
--					easingY = easing.linear,
--				},
--			},
--		},
--	},
	[1] = {
		path = {easingX = easing.linear, easingY = easing.inOutCubic},
		icon = "images/worlds/mundos01.png",
		--Level 1
		[1] = {
			x = scale * .067,
			y = 100,
			background = "images/backgrounds/space.png",
			levelWidth = 4000,
			levelHeight = 1000,
			ship = {position = {x = 0, y = 0}},
			levelDescription = "Recolecta las porciones necesarias",
			tutorial = {"moveOutCircle", "moveToBase", "baseTutorial", "collectPortion", "finishLevel"},
			objetives = {
				fruit = {
					portions = 2,
				},
			},
			enemySpawnData = {
--				{
--					type = "follower",         
--					spawnPoint = { x = -310, y = 500},
--					patrolPath = {
--						[1] = { x = -300 , y = 600},
--						[2] = {x = -300, y = -600}
--					}
--				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x =	-1250, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					foodOffset = {x = 0, y = -100},
					position = {x = 1250, y = 0}
				},
			},
			asteroids = {

			},
		},
		--Level 2
		[2] = {
			x = scale * .12,
			y = -50,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 1300, y = 100}},
			objetives = {
				protein = { portions = 3,},
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = -390, y = 500},
					patrolPath = {
						[1] = { x = -400, y = 550},
						[2] = {x = -400, y = -550}
					}
				},
				{
					type = "follower",
					spawnPoint = { x = 410, y = -500},
					patrolPath = {
						[1] = { x = 400, y = -550},
						[2] = {x = 400, y = 550}
					}
				},
			},
			asteroids = {
				[1] = {
						lineStart = {x = -1450, y = -600},
						lineEnd = {x = -850, y = -150},
						easingX = easing.inSine,
						easingY = easing.outSine,
				},
				[2] = {
						lineStart = {x = -1450, y = 600},
						lineEnd = {x = -850, y = 150},
						easingX = easing.inSine,
						easingY = easing.outSine,
				},
				[3] = {
						lineStart = {x = 1450, y = 600},
						lineEnd = {x = 850, y = 150},
						easingX = easing.inSine,
						easingY = easing.outSine,
				},
				[4] = {
						lineStart = {x = 1450, y = -600},
						lineEnd = {x = 850, y = -150},
						easingX = easing.inSine,
						easingY = easing.outSine,
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1200, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 1200, y = 0}
				},
			}
		},
		--Level 3
		[3] = {
			x = scale * .18,
			y = 80,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 1400, y =  300}},
			objetives = {
				protein = { portions = 3,},
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = -990, y = 450},
					patrolPath = {
						[1] = { x = -1000, y = 450},
						[2] = {x = -0, y = -450},
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1300, y = -550},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 1300, y = 500}
				},
			},
			asteroids = {
				[1] = {
					lineStart = {x = -200, y = 600},
					lineEnd = {x = 1000, y = -600},
					easingX = easing.inOutSine,
					easingY = easing.outInSine,
				},
			},
		},
		--Level 4
		[4] = {
			x = scale * .24,
			y = -80,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 900, y = 100}},
			objetives = {
				fruit = { portions = 2,},
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = -1320, y = 0},
					patrolPath = {
						[1] = { x = -1300, y = 600},
						[2] = {x = -1300, y = -600}
					}
				},
				{
					type = "follower",
					spawnPoint = { x = 1310, y = 0},
					patrolPath = {
						[1] = { x = 1300, y = 600},
						[2] = {x = 1300, y = -600}
					}
				},
				{
					type = "follower",
					spawnPoint = { x = 0, y = 0},
					patrolPath = {
						[1] = { x = -400, y = 600},
						[2] = {x = 400, y = -600},
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -700, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = 700, y = 0}
				},
			},
			asteroids = {
				[1] = {
					lineStart = {x = -1200, y = 550},
					lineEnd = {x = -500, y = 0},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[2] = {
					lineStart = {x = -500, y = 0},
					lineEnd = {x = -1200, y = -550},
					easingX = easing.outSine,
					easingY = easing.inSine,
				},
				[3] = {
					lineStart = {x = 1200, y = 550},
					lineEnd = {x = 500, y = 0},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[4] = {
					lineStart = {x = 500, y = 0},
					lineEnd = {x = 1200, y = -550},
					easingX = easing.outSine,
					easingY = easing.inSine,
				},
			},
		},
		--Level 5
		[5] = {
			x = scale * .3,
			y = 100,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 700, y = 250}},
			objetives = {
				vegetable = { portions = 3,},
			},
			enemySpawnData = {
				{
					type = "shooter",
					spawnPoint = { x = -1400, y = 0},
					angle = 0
				},
				{
					type = "follower",
					spawnPoint = { x = -1300, y = 300},
					patrolPath = {
						[1] = { x = -100, y = 300},
						[2] = {x = -1400, y = 300}
					}
				},
				{
					type = "follower",
					spawnPoint = { x = -1300, y = -300},
					patrolPath = {
						[1] = { x = -100, y = -300},
						[2] = {x = -1400, y = -300}
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = 1100, y = -400},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "vegetable",
					asset = "images/planets/vegetables_1.png",
					position = {x = 1100, y = 400}
				}
			},
			asteroids = {
				[1] = {
					lineStart = {x = -350, y = 0},
					lineEnd = {x = 1500, y = 0},
				},
			},
		},
		--Level 6
		[6] = {
			x = scale * .36,
			y = -110,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = -1300, y = -500}},
			objetives = {
				fruit = { portions = 3,},
			},
			enemySpawnData = {
				{
					type = "shooter",
					spawnPoint = { x = -500, y = 600},
					angle = 90
				},
				{
					type = "shooter",
					spawnPoint = { x = -100, y = -600},
					angle = 270
				},
				{
					type = "shooter",
					spawnPoint = { x = 100, y = 600},
					angle = 90
				},
				{
					type = "shooter",
					spawnPoint = { x = 500, y = -600},
					angle = 270
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = 1300, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = -1300, y = 0}
				},
			},
			asteroids = {
	
			},
		},
		--Level 7
		[7] = {
			x = scale * .42,
			y = 100,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = -1100, y = -600}},
			objetives = {
				fruit = { portions = 3,},
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = -590, y = -400},
					patrolPath = {
						[1] = { x = -1200, y = 400},
						[2] = {x = -600, y = -400}
					}
				},
				{
					type = "follower",
					spawnPoint = { x = 590, y = -400},
					patrolPath = {
						[1] = { x = 1200, y = 400},
						[2] = {x = 600, y = -400}
					}
				},
				{
					type = "shooter",
					spawnPoint = { x = -100, y = -600},
					angle = 225
				},
				{
					type = "shooter",
					spawnPoint = { x = 50, y = 600},
					angle = 45
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1200, y = -550},
				scaleFactor = 1.5
			},		
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = 1200, y = 550}
				},
			},
			asteroids = {

			},
		},
		--Level 8
		[8] = {
			x = scale * .48,
			y = 0,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 1200, y = 400}},
			objetives = {
				protein = { portions = 3,},
			},
			enemySpawnData = {
				{
					type = "canoner",
					spawnPoint = { x = -300, y = -499},
					patrolPath = {
						[1] = { x = -300, y = -500},
						[2] = {x = -300, y = 500}
					}
				},
				{
					type = "canoner",
					spawnPoint = { x = 300, y = 499},
					patrolPath = {
						[1] = { x = 300, y = -500},
						[2] = {x = 300, y = 500}
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1100, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 1100, y = 0}
				},
			},
			asteroids = {

			},
		},
		--Level 9
		[9] = {
			x = scale * .54,
			y = 130,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 1300, y = 400}},
			objetives = {
				vegetable = { portions = 3,},
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = 0, y = 490},
					patrolPath = {
						[1] = { x = 100, y = -300},
						[2] = {x = 300, y = 0},
						[3] = {x = 100, y = -300},
						[4] = {x = 300, y = 0},
					}
				},
				{
					type = "follower",
					spawnPoint = { x = 0, y = -490},
					patrolPath = {
						[1] = { x = -100, y = -300},
						[2] = {x = -300, y = 0},
						[3] = {x = -100, y = -300},
						[4] = {x = -300, y = 0},
					}
				},
				{
					type = "shooter",
					spawnPoint = { x = -600, y = -600},
					angle = 315
				},
				{
					type = "shooter",
					spawnPoint = { x = -600, y = 600},
					angle = 45
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1300, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "vegetable",
					asset = "images/planets/vegetables_1.png",
					position = {x = 1300, y = 0}
				}
			},
			asteroids = {
				[1] = {
					lineStart = {x = 0, y = -300},
					lineEnd = {x = 0, y = 300},
				},
			},
		},
		--Level 10
		[10] = {
			x = scale * .6,
			y = -130,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 1300, y = 500}},
			objetives = {
				fruit = { portions = 3,},
			},
			enemySpawnData = {
				{
					type = "canoner",
					spawnPoint = { x = 0, y = 0},
					patrolPath = {
						[1] = { x = -600, y = 400},
						[2] = {x = 600, y = -400},
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = 1300, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = -1300, y = 0}
				},
			},
			asteroids = {
				[1] = {
					lineStart = {x = 200, y = 500},
					lineEnd = {x = 1000, y = -500},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
			},
		},
		--Level 11
		[11] = {
			x = scale * .66,
			y = 100,
			background = "images/backgrounds/space.png",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = {x = 1600, y = 600}},
			objetives = {
				fruit = { portions = 1,},
				vegetable = { portions = 1,},
				protein = { portions = 1,},
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = 0, y = 300},
					patrolPath = {
						[1] = { x = -1000, y = 100},
						[2] = {x = 1000, y = 700},
					}
				},
				{
					type = "canoner",
					spawnPoint = { x = 800, y = -800},
					patrolPath = {
						[1] = { x = -800, y = -200},
						[2] = {x = 800, y = -800},
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1800, y = -800},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = 1800, y = -800}
				},
				[2] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 1800, y = 800}
				},
				[3] = {
					foodType = "vegetable",
					asset = "images/planets/vegetables_1.png",
					position = {x = -1800, y = 800}
				}
			},
			asteroids = {
				[1] = {
					lineStart = {x = 400, y = -200},
					lineEnd = {x = 1500, y = -750},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[2] = {
					lineStart = {x = -1700, y = 200},
					lineEnd = {x = -400, y = 800},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
			},
		},
		--Level 12
		[12] = {
			x = scale * .72,
			y = -80,
			background = "images/backgrounds/space.png",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = {x = 1900, y = -900}},
			objetives = {
				fruit = { portions = 1,},
				vegetable = { portions = 1,},
				protein = { portions = 1,},
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = -1000, y = -500},
					patrolPath = {
						[1] = { x = -1800, y = -300},
						[2] = {x = -500, y = -500},
						[3] = {x = -800, y = -800},
						[4] = {x = -500, y = -500},
					}
				},
				{
					type = "follower",
					spawnPoint = { x = -400, y = -400},
					patrolPath = {
						[1] = { x = -1800, y = -100},
						[2] = {x = -300, y = -200},
						[3] = {x = -200, y = -800},
						[4] = {x = -300, y = -200},
					}
				},

				{
					type = "follower",
					spawnPoint = { x = 0, y = 0},
					patrolPath = {
						[1] = { x = -1800, y = 400},
						[2] = {x = -100, y = 100},
						[3] = {x = 400, y = -800},
						[4] = {x = -100, y = 100},
					}
				},
				{
					type = "canoner",
					spawnPoint = { x = -800 , y = -800},
					patrolPath = {
						[1] = { x = -100, y = 800 },
						[2] = {x = 900, y = -400},
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1800, y = -700},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = 1800, y = -500}
				},
				[2] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 1700, y = 600}
				},
			},
			asteroids = {

			},
		},
		--Level 13
		[13] = {
			x = scale * .78 ,
			y = 70,
			background = "images/backgrounds/space.png",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = {x = 1600, y = 600}},
			objetives = {
				fruit = { portions = 1,},
				vegetable = { portions = 1,},
				protein = { portions = 1,},
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = -500, y = 0},
					patrolPath = {
						[1] = { x = -500, y = 0},
						[2] = {x = 0, y = 500}
					}
				},
				{
					type = "canoner",
					spawnPoint = { x = -690, y = -900},
					patrolPath = {
						[1] = { x = -700, y = -900},
						[2] = { x = -500, y = -600},
						[3] = {x = -600, y = -400},
						[4] = {x = -1100, y = -100},
						[5] = {x = -1700, y = -400},
						[6] = {x = -1100, y = -100},
						[7] = {x = -600, y = -400},
						[8] = { x = -500, y = -600},
					}
				},
				{
					type = "canoner",
					spawnPoint = { x = 600, y = -100},
					patrolPath = {
						[1] = { x = 610, y = -100},
						[2] = { x = 700, y = 200},
						[3] = {x = 700, y = 500},
						[4] = {x = 400, y = 700},
						[5] = {x = -100, y = 500},
						[6] = {x = 400, y = 700},
						[7] = {x = 700, y = 500},
						[8] = { x = 610, y = -100},
					}
				},
				{
					type = "shooter",
					spawnPoint = { x = -1800, y = 200},
					angle = 0
				},
				{
					type = "shooter",
					spawnPoint = { x = -800, y = 900},
					angle = 90
				},
				{
					type = "shooter",
					spawnPoint = { x = 600, y = -900},
					angle = 270
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1400, y = -500},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = 1800, y = -800}
				},
				[2] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 1800, y = 800}
				},
				[3] = {
					foodType = "vegetable",
					asset = "images/planets/vegetables_1.png",
					position = {x = -1800, y = 800}
				}
			},
			asteroids = {
				[1] = {
					lineStart = {x = -1000, y = 500},
					lineEnd = {x = 1000, y = -500},
				},
			},
		},
		--Level 14
		[14] = {
			x = scale * .86,
			y = -80,
			background = "images/backgrounds/space.png",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = {x = -1900, y = -500}},
			objetives = {
				fruit = { portions = 1,},
				protein = { portions = 1,},
			},
			enemySpawnData = {
				{
					type = "shooter",
					spawnPoint = { x = -600, y = 0},
					angle = 180
				},
				{
					type = "shooter",
					spawnPoint = { x = 600, y = 0},
					angle = 0
				},
				{
					type = "shooter",
					spawnPoint = { x = 0, y = -600},
					angle = 90
				},
				{
					type = "shooter",
					spawnPoint = { x = 0, y = 600},
					angle = 270
				},
				{
					type = "canoner",
					spawnPoint = { x = 800, y = -100},
					patrolPath = {
						[1] = { x = 1000, y = -100},
						[2] = { x = 200, y = -700},
					}
				},
				{
					type = "canoner",
					spawnPoint = { x = -800, y = -100},
					patrolPath = {
						[1] = { x = -1000, y = 100},
						[2] = { x = -200, y = 700},
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = 0, y = 0},
				scaleFactor = 1.2
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = -1700, y = -700}
				},
				[2] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 1700, y = -700}
				},
			},
			asteroids = {
				
			},
		},
		--Level 15
		[15] = {
			x = scale * .92,
			y = 100,
			background = "images/backgrounds/space.png",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = {x = -1700, y = 200}},
			objetives = {
				fruit = { portions = 1,},
				vegetable = { portions = 1,},
				protein = { portions = 1,},
			},
			enemySpawnData = {
				{
					type = "shooter",
					spawnPoint = { x = -1200, y = 400},
					angle = 315
				},
				{
					type = "shooter",
					spawnPoint = { x = -1200, y = -400},
					angle = 45
				},
				{
					type = "canoner",
					spawnPoint = { x = 1600, y = -800},
					patrolPath = {
						[1] = { x = 1700, y = -100},
						[2] = {x = 1600, y = -800}
					}
				},
				{
					type = "canoner",
					spawnPoint = { x = 1600, y = 300},
					patrolPath = {
						[1] = { x = 1100, y = 800},
						[2] = {x = 1600, y = 300}
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = 0, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = 0, y = -700}
				},
				[2] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 0, y = 700}
				},
				[3] = {
					foodType = "vegetable",
					asset = "images/planets/vegetables_1.png",
					position = {x = -1300, y = 0}
				}
			},
			asteroids = {
				[1] = {
					lineStart = {x = -1700, y = -400},
					lineEnd = {x = -800, y = 0},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[2] = {
					lineStart = {x = -800, y = 0},
					lineEnd = {x = -1700, y = 400},
					easingX = easing.outSine,
					easingY = easing.inSine,
				},
				[3] = {
					lineStart = {x = -600, y = -900},
					lineEnd = {x = 0, y = -300},
					easingX = easing.outSine,
					easingY = easing.inSine,
				},
				[4] = {
					lineStart = {x = 0, y = -300},
					lineEnd = {x = 500, y = -600},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[5] = {
					lineStart = {x = -600, y = 900},
					lineEnd = {x = 0, y = 300},
					easingX = easing.outSine,
					easingY = easing.inSine,
				},
				[6] = {
					lineStart = {x = 0, y = 300},
					lineEnd = {x = 500, y = 600},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[7] = {
					lineStart = {x = 900, y = -600},
					lineEnd = {x = 1100, y = 0},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[8] = {
					lineStart = {x = 1100, y = 0},
					lineEnd = {x = 700, y = 400},
					easingX = easing.outSine,
					easingY = easing.inSine,
				},
			},
		},
	},
	-- World 2
	[2] = {
		path = {easingX = easing.linear, easingY = easing.inOutCubic},
		icon = "images/worlds/mundos02.png",
		--World = 2, Level = 1

		[1] = {
			x = scale * .067,
			y = 100,
			background = "images/backgrounds/space.png",
			levelDescription = "Recolecta las porciones necesarias",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = { x = 1800, y = -800}},
			objetives = {fruit = {portions = 3}},
			enemySpawnData = {
				{
					type = "canoner",
					angle = 0,
					spawnPoint = {x = -1600, y = -800},
					patrolPath = {[1] = {x = -1600, y = -800}},
				},
				{
					type = "canoner",
					angle = 0,
					spawnPoint = {x = -1600, y = 800},
					patrolPath = {[1] = {x = -1600, y = 800}},
				},
			},
			obstacle = {
				[1] = {
					type = "blackhole",
					position = {x = 0, y = 0},
				},
			},
			earth = {
				position = { x = -1400, y = 0},
				name = "earth",
				assetPath = "images/planets/earth/",
				scaleFactor = 1.5,
			},
			planets = {
				[1] = {
					foodType = "fruit",
					position = {x = 1400, y = 0},
				},
			},
			asteroids = {
			},
		},

		--World = 2, Level = 2

		[2] = {
			x = scale * .117,
			y = -100,
			background = "images/backgrounds/space.png",
			levelDescription = "Recolecta las porciones necesarias",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = { x = 1500, y = -500}},
			objetives = {cereal = {portions = 3}},
			enemySpawnData = {
				{
					type = "shooter",
					angle = 0,
					spawnPoint = {x = -1800, y = 0},
					patrolPath = {[1] = {x = -1800, y = 0}},
				},
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = -1700, y = -600},
					patrolPath = {
						[1] = {x = -1700, y = -600},
						[2] = {x = -400, y = -600},
					},
				},
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = -1700, y = 500},
					patrolPath = {
						[1] = {x = -1700, y = 500},
						[2] = {x = -400, y = 500},
					},
				},
			},
			obstacle = {
				[1] = {
					type = "blackhole",
					position = {x = 1900, y = 0},
				},
				[2] = {
					type = "blackhole",
					position = {x = 1700, y = 0},
				},
				[3] = {
					type = "blackhole",
					position = {x = 1500, y = 0},
				},
				[4] = {
					type = "blackhole",
					position = {x = 1300, y = 0},
				},
				[5] = {
					type = "blackhole",
					position = {x = 1100, y = 0},
				},
				[6] = {
					type = "blackhole",
					position = {x = 900, y = 0},
				},
				[7] = {
					type = "blackhole",
					position = {x = 700, y = 0},
				},
				[8] = {
					type = "blackhole",
					position = {x = 500, y = 0},
				},
				[9] = {
					type = "blackhole",
					position = {x = 300, y = 0},
				},
				[10] = {
					type = "blackhole",
					position = {x = 100, y = 0},
				},
				[11] = {
					type = "blackhole",
					position = {x = -100, y = 0},
				},
				[12] = {
					type = "blackhole",
					position = {x = -300, y = 0},
				},
				[13] = {
					type = "blackhole",
					position = {x = -500, y = 0},
				},
			},
			earth = {
				position = { x = 600, y = -500},
				name = "earth",
				assetPath = "images/planets/earth/",
				scaleFactor = 1.5,
			},
			planets = {
				[1] = {
					foodType = "cereal",
					position = {x = 1000, y = 500},
				},
			},
			asteroids = {
				[1] = {
					lineStart = { x = -600, y = 0},
					lineEnd = { x = -700, y = 0},
					easingX = easing.linear,
					easingY = easing.linear,
				},
			},
		},

		--World = 3, Level = 2

		[3] = {
			x = scale * .167,
			y = 100,
			background = "images/backgrounds/space.png",
			levelDescription = "Recolecta las porciones necesarias",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = { x = -1900, y = -500}},
			objetives = {milk = {portions = 2}},
			enemySpawnData = {
				{
					type = "shooter",
					angle = 270,
					spawnPoint = {x = 300, y = -900},
					--patrolPath = {[1] = {x = 300, y = -900}},
				},
				{
					type = "shooter",
					angle = 90,
					spawnPoint = {x = -800, y = 800},
					--patrolPath = {[1] = {x = -800, y = 800}},
				},
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = 800, y = -500},
					patrolPath = {
						[1] = {x = 800, y = -500},
						[2] = {x = 800, y = 500}
					},
				},
			},
			obstacle = {
				[1] = {
					type = "blackhole",
					position = {x = 1900, y = -900},
				},
				[2] = {
					type = "blackhole",
					position = {x = 1900, y = 900},
				},
				[3] = {
					type = "blackhole",
					position = {x = 1700, y = -700},
				},
				[4] = {
					type = "blackhole",
					position = {x = 1700, y = 700},
				},
				[5] = {
					type = "blackhole",
					position = {x = 1500, y = -600},
				},
				[6] = {
					type = "blackhole",
					position = {x = 1500, y = 600},
				},
				[7] = {
					type = "blackhole",
					position = {x = 1300, y = -500},
				},
				[8] = {
					type = "blackhole",
					position = {x = 1300, y = 500},
				},
				[9] = {
					type = "blackhole",
					position = {x = 1100, y = -300},
				},
				[10] = {
					type = "blackhole",
					position = {x = 1100, y = 300},
				},
			},
			earth = {
				position = { x = 1600, y = 0},
				name = "earth",
				assetPath = "images/planets/earth/",
				scaleFactor = 1.5,
			},
			planets = {
				[1] = {
					foodType = "milk",
					position = {x = -1600, y = 0},
				},
			},
			asteroids = {
			},
		},

		--World = 4, Level = 2

		[4] = {
			x = scale * .217,
			y = -100,
			background = "images/backgrounds/space.png",
			levelDescription = "Recolecta las porciones necesarias",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = { x = -1900, y = -700}},
			objetives = {fruit = {portions = 3}},
			enemySpawnData = {
				{
					type = "canoner",
					angle = 0,
					spawnPoint = {x = -900, y = -900},
					patrolPath = {
						[1] = {x = -900, y = -900},
						[2] = {x = -900, y = 900},
					},
				},
				{
					type = "shooter",
					angle = 90,
					spawnPoint = {x = -500, y = 700},
					patrolPath = {[1] = {x = -500, y = 700}},
				},
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = 1000, y = 600},
					patrolPath = {
						[1] = {x = 1000, y = 600},
						[2] = {x = 1000, y = -600},
					},
				},
			},
			obstacle = {
				[1] = {
					type = "blackhole",
					position = {x = 0, y = 0},
				},
			},
			earth = {
				position = { x = 1700, y = 0},
				name = "earth",
				assetPath = "images/planets/earth/",
				scaleFactor = 1.5,
			},
			planets = {
				[1] = {
					foodType = "fruit",
					position = {x = -1700, y = 0},
				},
			},
			asteroids = {
			},
		},

		--World = 5, Level = 2

		[5] = {
			x = scale * .267,
			y = 100,
			background = "images/backgrounds/space.png",
			levelDescription = "Recolecta las porciones necesarias",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = { x = -1900, y = -300}},
			objetives = {protein = {portions = 3}},
			enemySpawnData = {
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = -600, y = -800},
					patrolPath = {
						[1] = {x = -600, y = -800},
						[2] = {x = -600, y = 800},
					},
				},
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = 700, y = 800},
					patrolPath = {
						[1] = {x = 700, y = 800},
						[2] = {x = 1700, y = 0}
						},
				},
				{
					type = "canoner",
					angle = 0,
					spawnPoint = {x = 500, y = -600},
					patrolPath = {
						[1] = {x = 500, y = -600},
						[2] = {x = -150, y = 800}
					},
				},
			},
			obstacle = {
				[1] = {
					type = "blackhole",
					position = {x = 700, y = -800},
				},
				[2] = {
					type = "blackhole",
					position = {x = -300, y = 800},
				},
			},
			earth = {
				position = { x = 1700, y = 700},
				name = "earth",
				assetPath = "images/planets/earth/",
				scaleFactor = 1.5,
			},
			planets = {
				[1] = {
					foodType = "protein",
					position = {x = -1700, y = -700},
				},
			},
			asteroids = {
			},
		},
		--World = 6, Level = 2

		[6] = {
			x = scale * .317,
			y = -100,
			background = "images/backgrounds/space.png",
			levelDescription = "Recolecta las porciones necesarias",
			levelWidth = 4000,
			levelHeight = 4000,
			ship = {position = { x = -1800, y = -500}},
			objetives = {
				protein = {portions = 2},
				fruit = {portions = 2}
			},
			enemySpawnData = {
			},
			obstacle = {
				[1] = {
					type = "blackhole",
					position = {x = -900, y = 0},
				},
				[2] = {
					type = "blackhole",
					position = {x = 900, y = 0},
				},
				[3] = {
					type = "blackhole",
					position = {x = 0, y = -1200},
				},
				[4] = {
					type = "blackhole",
					position = {x = 0, y = 1100},
				},
				[5] = {
					type = "blackhole",
					position = {x = 900, y = -1200},
				},
				[6] = {
					type = "blackhole",
					position = {x = -900, y = -1200},
				},
				[7] = {
					type = "blackhole",
					position = {x = -900, y = 1100},
				},
				[8] = {
					type = "blackhole",
					position = {x = 900, y = 1100},
				},
				[9] = {
					type = "blackhole",
					position = {x = 500, y = 500},
				},
				[10] = {
					type = "blackhole",
					position = {x = -500, y = 500},
				},
				[11] = {
					type = "blackhole",
					position = {x = -500, y = -700},
				},
				[12] = {
					type = "blackhole",
					position = {x = 500, y = -700},
				},
			},
			earth = {
				position = { x = 0, y = 0},
				name = "earth",
				assetPath = "images/planets/earth/",
				scaleFactor = 1.5,
			},
			planets = {
				[1] = {
					foodType = "protein",
					position = {x = -1600, y = 0},
				},
				[2] = {
					foodType = "fruit",
					position = {x = 1600, y = 0},
				},
			},
			asteroids = {
			},
		},

		--World = 7, Level = 2

		[7] = {
			x = scale * .367,
			y = 100,
			background = "images/backgrounds/space.png",
			levelDescription = "Recolecta las porciones necesarias",
			levelWidth = 4000,
			levelHeight = 4000,
			ship = {position = { x = -800, y = -100}},
			objetives = {vegetable = {portions = 3}},
			enemySpawnData = {
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = -200, y = -1600},
					patrolPath = {
						[1] = {x = -200, y = -1600},
						[2] = {x = -400, y = -1000}
					},
				},
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = 300, y = 1600},
					patrolPath = {
						[1] = {x = 300, y = 1600},
						[2] = {x = 600, y = 900}
					},
				},
				{
					type = "canoner",
					angle = 0,
					spawnPoint = {x = 0, y = 0},
					patrolPath = {[1] = {x = 0, y = 0}},
				},
			},
			obstacle = {
				[1] = {
					type = "blackhole",
					position = {x = -700, y = -800},
				},
				[2] = {
					type = "blackhole",
					position = {x = 800, y = 700},
				},
			},
			earth = {
				position = { x = -1500, y = -1200},
				name = "earth",
				assetPath = "images/planets/earth/",
				scaleFactor = 1.5,
			},
			planets = {
				[1] = {
					foodType = "vegetable",
					position = {x = 1500, y = 1100},
				},
			},
			asteroids = {
				[1] = {
					lineStart = { x = -2000, y = -2000},
					lineEnd = { x = -900, y = -1300},
					easingX = easing.inCubic,
					easingY = easing.linear,
				},
				[2] = {
					lineStart = { x = -2000, y = -400},
					lineEnd = { x = -900, y = -1000},
					easingX = easing.inCubic,
					easingY = easing.linear,
				},
				[3] = {
					lineStart = { x = 2000, y = 2000},
					lineEnd = { x = 1000, y = 1300},
					easingX = easing.inCubic,
					easingY = easing.linear,
				},
				[4] = {
					lineStart = { x = 2000, y = 200},
					lineEnd = { x = 1000, y = 900},
					easingX = easing.inCubic,
					easingY = easing.linear,
				},
			},
		},

		--World = 8, Level = 2

		[8] = {
			x = scale * .417,
			y = -100,
			background = "images/backgrounds/space.png",
			levelDescription = "Recolecta las porciones necesarias",
			levelWidth = 4000,
			levelHeight = 4000,
			ship = {position = { x = 500, y = -1000}},
			objetives = {fruit = {portions = 2},
						cereal = {portions = 2}},
			enemySpawnData = {
				{
					type = "canoner",
					angle = 0,
					spawnPoint = {x = 1200, y = 600},
					patrolPath = {
						[1] = {x = 1000, y = 600},
						[2] = {x = -800, y = 600},
					},
				},
				{
					type = "shooter",
					angle = 0,
					spawnPoint = {x = -1900, y = -200},
					patrolPath = {[1] = {x = -1900, y = -200}},
				},
				{
					type = "shooter",
					angle = 180,
					spawnPoint = {x = 1900, y = -200},
					patrolPath = {[1] = {x = 1900, y = -200}},
				},
			},
			obstacle = {
				[1] = {
					type = "blackhole",
					position = {x = 100, y = -200},
				},
				[2] = {
					type = "blackhole",
					position = {x = -1400, y = 1500},
				},
				[3] = {
					type = "blackhole",
					position = {x = 100, y = 1500},
				},
				[4] = {
					type = "blackhole",
					position = {x = 1500, y = 1500},
				},
			},
			earth = {
				position = { x = 100, y = -1700},
				name = "earth",
				assetPath = "images/planets/earth/",
				scaleFactor = 1.5,
			},
			planets = {
				[1] = {
					foodType = "fruit",
					position = {x = -1400, y = -1700},
				},
				[2] = {
					foodType = "cereal",
					position = {x = 1500, y = -1700},
				},
			},
			asteroids = {
				[1] = {
					lineStart = { x = -2000, y = -2000},
					lineEnd = { x = -1600, y = -1300},
					easingX = easing.outCirc,
					easingY = easing.linear,
				},
				[2] = {
					lineStart = { x = -1200, y = -1300},
					lineEnd = { x = -700, y = -2000},
					easingX = easing.inCirc,
					easingY = easing.linear,
				},
				[3] = {
					lineStart = { x = -600, y = -2000},
					lineEnd = { x = -100, y = -1300},
					easingX = easing.outCirc,
					easingY = easing.linear,
				},
				[4] = {
					lineStart = { x = 300, y = -1300},
					lineEnd = { x = 800, y = -2000},
					easingX = easing.inCirc,
					easingY = easing.linear,
				},
				[5] = {
					lineStart = { x = 900, y = -2000},
					lineEnd = { x = 1300, y = -1300},
					easingX = easing.outCirc,
					easingY = easing.linear,
				},
				[6] = {
					lineStart = { x = 2000, y = -2000},
					lineEnd = { x = 1700, y = -1300},
					easingX = easing.outCirc,
					easingY = easing.linear,
				},
				[7] = {
					lineStart = { x = -700, y = -1700},
					lineEnd = { x = -700, y = 400},
					easingX = easing.linear,
					easingY = easing.linear,
				},
				[8] = {
					lineStart = { x = 800, y = -1800},
					lineEnd = { x = 800, y = 400},
					easingX = easing.linear,
					easingY = easing.linear,
				},
			},
		},

		--World = 9, Level = 2

		[9] = {
			x = scale * .467,
			y = 100,
			background = "images/backgrounds/space.png",
			levelDescription = "Recolecta las porciones necesarias",
			levelWidth = 4000,
			levelHeight = 4000,
			ship = {position = { x = -1300, y = -1000}},
			objetives = {
					vegetable = {portions = 2},
					cereal = {portions = 2},
					fruit = {portions = 2}},
			enemySpawnData = {
				{
					type = "shooter",
					angle = 180,
					spawnPoint = {x = 600, y = 1500},
					patrolPath = {[1] = {x = 600, y = 1500}},
				},
				{
					type = "shooter",
					angle = 0,
					spawnPoint = {x = -1700, y = 0},
					patrolPath = {[1] = {x = -1700, y = 0}},
				},
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = -400, y = 1700},
					patrolPath = {
						[1] = {x = -400, y = 1700},
						[2] = {x = 0, y = 1300}},
				},
			},
			obstacle = {
				[1] = {
					type = "blackhole",
					position = {x = -1000, y = 300},
				},
				[2] = {
					type = "blackhole",
					position = {x = -300, y = 900},
				},
			},
			earth = {
				position = { x = 0, y = 0},
				name = "earth",
				assetPath = "images/planets/earth/",
				scaleFactor = 1.5,
			},
			planets = {
				[1] = {
					foodType = "vegetable",
					position = {x = -1500, y = -1600},
				},
				[2] = {
					foodType = "cereal",
					position = {x = 1400, y = -1600},
				},
				[3] = {
					foodType = "fruit",
					position = {x = 1400, y = 1500},
				},
			},
			asteroids = {
				[1] = {
					lineStart = { x = 0, y = -800},
					lineEnd = { x = 800, y = 0},
					easingX = easing.inCirc,
					easingY = easing.linear,
				},
				[2] = {
					lineStart = { x = 800, y = 0},
					lineEnd = { x = 0, y = 800},
					easingX = easing.outCirc,
					easingY = easing.linear,
				},
				[3] = {
					lineStart = { x = 0, y = -800},
					lineEnd = { x = -800, y = 0},
					easingX = easing.inCirc,
					easingY = easing.linear,
				},
				[4] = {
					lineStart = { x = 0, y = 800},
					lineEnd = { x = -400, y = 700},
					easingX = easing.inCirc,
					easingY = easing.linear,
				},
				[5] = {
					lineStart = { x = -800, y = 0},
					lineEnd = { x = -700, y = 400},
					easingX = easing.outCirc,
					easingY = easing.linear,
				},
			},
		},

		--World = 10, Level = 2

		[10] = {
			x = scale * .517,
			y = -100,
			background = "images/backgrounds/space.png",
			levelDescription = "Recolecta las porciones necesarias",
			levelWidth = 4000,
			levelHeight = 4000,
			ship = {position = { x = -1900, y = -1900}},
			objetives = {
				vegetable = {portions = 2},
				cereal = {portions = 2},
				fruit = {portions = 2},
			},
			enemySpawnData = {
				{
					type = "canoner",
					angle = 0,
					spawnPoint = {x = -1200, y = -300},
					patrolPath = {
						[1] = {x = -1200, y = -300},
						[2] = {x = -200, y = -900},
					},
				},
				{
					type = "canoner",
					angle = 0,
					spawnPoint = {x = -400, y = 1200},
					patrolPath = {
						[1] = {x = -400, y = 1200},
						[2] = {x = -900, y = 200},
					},
				},
				{
					type = "canoner",
					angle = 0,
					spawnPoint = {x = 1200, y = 300},
					patrolPath = {
						[1] = {x = 1200, y = 300},
						[2] = {x = 200, y = 1200},
					},
				},
				{
					type = "canoner",
					angle = 0,
					spawnPoint = {x = 400, y = -1200},
					patrolPath = {
						[1] = {x = 400, y = -1200},
						[2] = {x = 1000, y = -400},
					},
				},
			},
			obstacle = {
				[1] = {
					type = "blackhole",
					position = {x = -1000, y = 0},
				},
				[2] = {
					type = "blackhole",
					position = {x = 1000, y = 0},
				},
				[3] = {
					type = "blackhole",
					position = {x = 0, y = -1000},
				},
				[4] = {
					type = "blackhole",
					position = {x = 0, y = 1000},
				},
			},
			earth = {
				position = { x = 0, y = 0},
				name = "earth",
				assetPath = "images/planets/earth/",
				scaleFactor = 1.5,
			},
			planets = {
				[1] = {
					foodType = "vegetable",
					position = {x = -1600, y = -1600},
				},
				[2] = {
					foodType = "cereal",
					position = {x = 1500, y = 1600},
				},
				[3] = {
					foodType = "fruit",
					position = {x = 1500, y = -1600},
				},
			},
			asteroids = {
			},
		},

		--World = 11, Level = 2

		[11] = {
			x = scale * .567,
			y = 100,
			background = "images/backgrounds/space.png",
			levelDescription = "Recolecta las porciones necesarias",
			levelWidth = 4000,
			levelHeight = 4000,
			ship = {position = { x = 1000, y = -300}},
			objetives = {
				vegetable = {portions = 2},
				cereal = {portions = 2},
				protein = {portions = 2},
			},
			enemySpawnData = {
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = -400, y = 800},
					patrolPath = {
						[1] = {x = -400, y = 800},
						[2] = {x = -1100, y = -100},
						},
				},
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = 1500, y = -800},
					patrolPath = {
						[1] = {x = 1500, y = -800},
						[2] = {x = 1500, y = 800},
					},
				},
			},
			obstacle = {
			},
			earth = {
				position = { x = 0, y = 0},
				name = "earth",
				assetPath = "images/planets/earth/",
				scaleFactor = 1.5,
			},
			planets = {
				[1] = {
					foodType = "vegetable",
					position = {x = -1600, y = -1700},
				},
				[2] = {
					foodType = "cereal",
					position = {x = 1600, y = -1600},
				},
				[3] = {
					foodType = "protein",
					position = {x = -1600, y = 1600},
				},
			},
			asteroids = {
				[1] = {
					lineStart = { x = 0, y = -1600},
					lineEnd = { x = -1600, y = 0},
					easingX = easing.linear,
					easingY = easing.linear,
				},
				[2] = {
					lineStart = { x = -1600, y = 0},
					lineEnd = { x = 0, y = 1600},
					easingX = easing.linear,
					easingY = easing.linear,
				},
				[3] = {
					lineStart = { x = 0, y = -1600},
					lineEnd = { x = 1200, y = -400},
					easingX = easing.linear,
					easingY = easing.linear,
				},
				[4] = {
					lineStart = { x = 0, y = 1600},
					lineEnd = { x = 1200, y = 400},
					easingX = easing.linear,
					easingY = easing.linear,
				},
				[5] = {
					lineStart = { x = 0, y = -800},
					lineEnd = { x = -800, y = -100},
					easingX = easing.linear,
					easingY = easing.linear,
				},
				[6] = {
					lineStart = { x = 0, y = -800},
					lineEnd = { x = 800, y = 0},
					easingX = easing.linear,
					easingY = easing.linear,
				},
				[7] = {
					lineStart = { x = 800, y = 0},
					lineEnd = { x = 0, y = 800},
					easingX = easing.linear,
					easingY = easing.linear,
				},
				[8] = {
					lineStart = { x = 0, y = 800},
					lineEnd = { x = -500, y = 300},
					easingX = easing.linear,
					easingY = easing.linear,
				},
			},
		},

		--World = 12, Level = 2

		[12] = {
			x = scale * .617,
			y = -100,
			background = "images/backgrounds/space.png",
			levelDescription = "Recolecta las porciones necesarias",
			levelWidth = 4000,
			levelHeight = 4000,
			ship = {position = { x = -1400, y = -1900}},
			objetives = {
				fruit = {portions = 2},
				cereal = {portions = 2},
				protein = {portions = 2},
			},
			enemySpawnData = {
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = -900, y = -1400},
					patrolPath = {
							[1] = {x = -900, y = -1400},
							[2] = {x = 900, y = -1400},
						},
				},
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = 1400, y = -900},
					patrolPath = {
						[1] = {x = 1400, y = -900},
						[2] = {x = 1400, y = 900},
						},
				},
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = 900, y = 1500},
					patrolPath = {
						[1] = {x = 900, y = 1500},
						[2] = {x = -900, y = 1500},
						},
				},
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = -1500, y = 1000},
					patrolPath = {
						[1] = {x = -1500, y = 1000},
						[2] = {x = -1500, y = -1000}
						},
				},
				{
					type = "shooter",
					angle = 90,
					spawnPoint = {x = 200, y = 1700},
					patrolPath = {[1] = {x = 200, y = 1700}},
				},
				{
					type = "shooter",
					angle = 0,
					spawnPoint = {x = -1700, y = 0},
					patrolPath = {[1] = {x = -1700, y = 0}},
				},
			},
			obstacle = {
				[1] = {
					type = "blackhole",
					position = {x = 500, y = -500},
				},
				[2] = {
					type = "blackhole",
					position = {x = 700, y = -700},
				},
				[3] = {
					type = "blackhole",
					position = {x = 900, y = -900},
				},
				[4] = {
					type = "blackhole",
					position = {x = 1100, y = -1100},
				},
				[5] = {
					type = "blackhole",
					position = {x = -500, y = -500},
				},
				[6] = {
					type = "blackhole",
					position = {x = -700, y = -700},
				},
				[7] = {
					type = "blackhole",
					position = {x = -900, y = -900},
				},
				[8] = {
					type = "blackhole",
					position = {x = -1100, y = -1100},
				},
				[9] = {
					type = "blackhole",
					position = {x = 500, y = 500},
				},
				[10] = {
					type = "blackhole",
					position = {x = 700, y = 700},
				},
				[11] = {
					type = "blackhole",
					position = {x = 900, y = 900},
				},
				[12] = {
					type = "blackhole",
					position = {x = 1100, y = 1100},
				},
				[13] = {
					type = "blackhole",
					position = {x = -500, y = 500},
				},
				[14] = {
					type = "blackhole",
					position = {x = -700, y = 700},
				},
				[15] = {
					type = "blackhole",
					position = {x = -900, y = 900},
				},
				[16] = {
					type = "blackhole",
					position = {x = -1100, y = 1100},
				},
			},
			earth = {
				position = { x = 0, y = 0},
				name = "earth",
				assetPath = "images/planets/earth/",
				scaleFactor = 1.5,
			},
			planets = {
				[1] = {
					foodType = "fruit",
					position = {x = -1700, y = -1700},
				},
				[2] = {
					foodType = "cereal",
					position = {x = 1700, y = -1700},
				},
				[3] = {
					foodType = "protein",
					position = {x = 1700, y = 1700},
				},
			},
			asteroids = {
			},
		},

		--World = 13, Level = 2

		[13] = {
			x = scale * .667,
			y = 100,
			background = "images/backgrounds/space.png",
			levelDescription = "Recolecta las porciones necesarias",
			levelWidth = 4000,
			levelHeight = 4000,
			ship = {position = { x = -1800, y = -1700}},
			objetives = {
				protein = {portions = 2},
				vegetable = {portions = 2},
				cereal = {portions = 2},
			},
			enemySpawnData = {
				{
					type = "shooter",
					angle = 315,
					spawnPoint = {x = 0, y = -1100},
					patrolPath = {[1] = {x = 0, y = -1100}},
				},
				{
					type = "shooter",
					angle = 135,
					spawnPoint = {x = 0, y = -100},
					patrolPath = {[1] = {x = 0, y = -100}},
				},
				{
					type = "shooter",
					angle = 315,
					spawnPoint = {x = -1000, y = -200},
					patrolPath = {[1] = {x = -1000, y = -200}},
				},
				{
					type = "shooter",
					angle = 315,
					spawnPoint = {x = -100, y = 300},
					patrolPath = {[1] = {x = -100, y = 300}},
				},
				{
					type = "shooter",
					angle = 315,
					spawnPoint = {x = 900, y = 400},
					patrolPath = {[1] = {x = 900, y = 400}},
				},
				{
					type = "shooter",
					angle = 135,
					spawnPoint = {x = 700, y = -600},
					patrolPath = {[1] = {x = 700, y = -600}},
				},
				{
					type = "shooter",
					angle = 315,
					spawnPoint = {x = 1200, y = -1100},
					patrolPath = {[1] = {x = 1200, y = -1100}},
				},
			},
			obstacle = {
			},
			earth = {
				position = { x = -900, y = 1000},
				name = "earth",
				assetPath = "images/planets/earth/",
				scaleFactor = 1.5,
			},
			planets = {
				[1] = {
					foodType = "protein",
					position = {x = 1700, y = -1300},
				},
				[2] = {
					foodType = "vegetable",
					position = {x = -1400, y = -1300},
				},
				[3] = {
					foodType = "cereal",
					position = {x = 1400, y = 1100},
				},
			},
			asteroids = {
				[1] = {
					lineStart = { x = -2000, y = 700},
					lineEnd = { x = 0, y = -1300},
					easingX = easing.linear,
					easingY = easing.linear,
				},
				[2] = {
					lineStart = { x = 2000, y = -2000},
					lineEnd = { x = -200, y = 200},
					easingX = easing.linear,
					easingY = easing.linear,
				},
				[3] = {
					lineStart = { x = -500, y = 2000},
					lineEnd = { x = 1400, y = 0},
					easingX = easing.linear,
					easingY = easing.linear,
				},
			},
		},

		--World = 14, Level = 2

		[14] = {
			x = scale * .717,
			y = -100,
			background = "images/backgrounds/space.png",
			levelDescription = "Recolecta las porciones necesarias",
			levelWidth = 4000,
			levelHeight = 4000,
			ship = {position = { x = 1800, y = 1300}},
			objetives = {
				vegetable = {portions = 2},
				cereal = {portions = 2},
				protein = {portions = 2},
			},
			enemySpawnData = {
				{
					type = "shooter",
					angle = 0,
					spawnPoint = {x = -1900, y = -1800},
					patrolPath = {[1] = {x = -1800, y = -1800}},
				},
				{
					type = "shooter",
					angle = 0,
					spawnPoint = {x = -1900, y = -700},
					patrolPath = {[1] = {x = -1900, y = -700}},
				},
				{
					type = "shooter",
					angle = 180,
					spawnPoint = {x = 1900, y = 0},
					patrolPath = {[1] = {x = 1900, y = 0}},
				},
				{
					type = "shooter",
					angle = 270,
					spawnPoint = {x = 300, y = 800},
					patrolPath = {[1] = {x = 300, y = 800}},
				},
				{
					type = "shooter",
					angle = 270,
					spawnPoint = {x = 1100, y = 800},
					patrolPath = {[1] = {x = 1100, y = 800}},
				},
				{
					type = "shooter",
					angle = 90,
					spawnPoint = {x = 700, y = 1900},
					patrolPath = {[1] = {x = 700, y = 1900}},
				},
			},
			obstacle = {
				[1] = {
					type = "blackhole",
					position = {x = 400, y = -1500},
				},
				[2] = {
					type = "blackhole",
					position = {x = -400, y = -1500},
				},
				[3] = {
					type = "blackhole",
					position = {x = -400, y = -400},
				},
				[4] = {
					type = "blackhole",
					position = {x = 400, y = -400},
				},
			},
			earth = {
				position = { x = -1400, y = 1500},
				name = "earth",
				assetPath = "images/planets/earth/",
				scaleFactor = 1.5,
			},
			planets = {
				[1] = {
					foodType = "vegetable",
					position = {x = 1500, y = 1600},
				},
				[2] = {
					foodType = "cereal",
					position = {x = 0, y = -1500},
				},
				[3] = {
					foodType = "protein",
					position = {x = 0, y = -400},
				},
			},
			asteroids = {
				[1] = {
					lineStart = { x = 2000, y = 700},
					lineEnd = { x = 300, y = 700},
					easingX = easing.linear,
					easingY = easing.linear,
				},
				[2] = {
					lineStart = { x = -2000, y = 700},
					lineEnd = { x = -300, y = 700},
					easingX = easing.linear,
					easingY = easing.linear,
				},
			},
		},

		--World = 15, Level = 2

		[15] = {
			x = scale * .767,
			y = 100,
			background = "images/backgrounds/space.png",
			levelDescription = "Recolecta las porciones necesarias",
			levelWidth = 4000,
			levelHeight = 4000,
			ship = {position = { x = -1450, y = -1900}},
			objetives = {
				vegetable = {portions = 2},
				cereal = {portions = 2},
				protein = {portions = 2},
			},
			enemySpawnData = {
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = -150, y = 1050},
					patrolPath = {
						[1] = {x = -150, y = 1050},
						[2] = {x = -850, y = -300},
					},
				},
				{
					type = "follower",
					angle = 0,
					spawnPoint = {x = 1650, y = -500},
					patrolPath = {
						[1] = {x = 1650, y = -500},
						[2] = {x = 1650, y = 500}
					},
				},
			},
			obstacle = {
				[1] = {
					type = "blackhole",
					position = {x = 0, y = -1700},
				},
				[2] = {
					type = "blackhole",
					position = {x = -1600, y = 0},
				},
				[3] = {
					type = "blackhole",
					position = {x = -1450, y = -200},
				},
				[4] = {
					type = "blackhole",
					position = {x = -200, y = -1550},
				},
				[5] = {
					type = "blackhole",
					position = {x = -400, y = -1400},
				},
				[6] = {
					type = "blackhole",
					position = {x = -600, y = -1200},
				},
				[7] = {
					type = "blackhole",
					position = {x = -800, y = -1000},
				},
				[8] = {
					type = "blackhole",
					position = {x = -1000, y = -800},
				},
				[9] = {
					type = "blackhole",
					position = {x = -1200, y = -600},
				},
				[10] = {
					type = "blackhole",
					position = {x = -1350, y = -400},
				},
				[11] = {
					type = "blackhole",
					position = {x = 0, y = 1700},
				},
				[12] = {
					type = "blackhole",
					position = {x = -200, y = 1600},
				},
				[13] = {
					type = "blackhole",
					position = {x = -400, y = 1450},
				},
				[14] = {
					type = "blackhole",
					position = {x = -600, y = 1300},
				},
				[15] = {
					type = "blackhole",
					position = {x = -800, y = 1150},
				},
				[16] = {
					type = "blackhole",
					position = {x = -950, y = 1000},
				},
				[17] = {
					type = "blackhole",
					position = {x = -1100, y = 850},
				},
				[18] = {
					type = "blackhole",
					position = {x = -1250, y = 700},
				},
				[19] = {
					type = "blackhole",
					position = {x = -1400, y = 550},
				},
				[20] = {
					type = "blackhole",
					position = {x = -1600, y = 350},
				},
				[21] = {
					type = "blackhole",
					position = {x = -1500, y = 150},
				},
				[22] = {
					type = "blackhole",
					position = {x = 1450, y = -650},
				},
				[23] = {
					type = "blackhole",
					position = {x = 1300, y = -800},
				},
				[24] = {
					type = "blackhole",
					position = {x = 1150, y = -950},
				},
				[25] = {
					type = "blackhole",
					position = {x = 950, y = -1150},
				},
				[26] = {
					type = "blackhole",
					position = {x = 800, y = -1300},
				},
				[27] = {
					type = "blackhole",
					position = {x = 550, y = -1450},
				},
				[28] = {
					type = "blackhole",
					position = {x = 300, y = -1650},
				},
				[29] = {
					type = "blackhole",
					position = {x = 1450, y = 400},
				},
				[30] = {
					type = "blackhole",
					position = {x = 1300, y = 600},
				},
				[31] = {
					type = "blackhole",
					position = {x = 1150, y = 800},
				},
				[32] = {
					type = "blackhole",
					position = {x = 1000, y = 950},
				},
				[33] = {
					type = "blackhole",
					position = {x = 900, y = 1100},
				},
				[34] = {
					type = "blackhole",
					position = {x = 750, y = 1250},
				},
				[35] = {
					type = "blackhole",
					position = {x = 550, y = 1400},
				},
				[36] = {
					type = "blackhole",
					position = {x = 400, y = 1550},
				},
				[37] = {
					type = "blackhole",
					position = {x = 200, y = 1650},
				},
				[38] = {
					type = "blackhole",
					position = {x = 0, y = -600},
				},
				[39] = {
					type = "blackhole",
					position = {x = 200, y = -450},
				},
				[40] = {
					type = "blackhole",
					position = {x = 400, y = -300},
				},
				[41] = {
					type = "blackhole",
					position = {x = 550, y = -150},
				},
				[42] = {
					type = "blackhole",
					position = {x = 700, y = 0},
				},
				[43] = {
					type = "blackhole",
					position = {x = 600, y = 200},
				},
				[44] = {
					type = "blackhole",
					position = {x = 450, y = 400},
				},
				[45] = {
					type = "blackhole",
					position = {x = 300, y = 550},
				},
				[46] = {
					type = "blackhole",
					position = {x = 150, y = 700},
				},
				[47] = {
					type = "blackhole",
					position = {x = -50, y = 650},
				},
				[48] = {
					type = "blackhole",
					position = {x = -250, y = 500},
				},
				[49] = {
					type = "blackhole",
					position = {x = -200, y = -500},
				},
				[50] = {
					type = "blackhole",
					position = {x = -300, y = -350},
				},
				[51] = {
					type = "blackhole",
					position = {x = -450, y = -200},
				},
			},
			earth = {
				position = { x = 0, y = 0},
				name = "earth",
				assetPath = "images/planets/earth/",
				scaleFactor = 1.5,
			},
			planets = {
				[1] = {
					foodType = "vegetable",
					position = {x = -1750, y = -1750},
				},
				[2] = {
					foodType = "protein",
					position = {x = -1650, y = 1650},
				},
				[3] = {
					foodType = "cereal",
					position = {x = 1600, y = 1650},
				},
			},
			asteroids = {
			},
		},
	},
	-- World 3
	[3] = {
		path = {easingX = easing.linear, easingY = easing.inOutCubic},
		icon = "images/worlds/mundos03.png",
		--Level 1
		[1] = {
			x = scale * .067,
			y = 100,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500 ,
			ship = {position = {x = 1100, y = 600}},
			objectives = {
				fruit = 3,
				vegetable = 0,
				protein = 0,
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = -310, y = 500},
					patrolPath = {
						[1] = { x = -300 , y = 600},
						[2] = {x = -300, y = -600}
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x =	-900, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_2.png",
					scale = 0.5,
					foodOffset = {x = 0, y = -100},
					position = {x = 900, y = 0}
				},
			},
			asteroids = {

			},
		},
		--Level 2
		[2] = {
			x = scale * .12,
			y = -50,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 1300, y = 100}},
			objectives = {
				fruit = 0,
				vegetable = 0,
				protein = 3,
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = -390, y = 500},
					patrolPath = {
						[1] = { x = -400, y = 550},
						[2] = {x = -400, y = -550}
					}
				},
				{
					type = "follower",
					spawnPoint = { x = 410, y = -500},
					patrolPath = {
						[1] = { x = 400, y = -550},
						[2] = {x = 400, y = 550}
					}
				},
			},
			asteroids = {
				[1] = {
						lineStart = {x = -1450, y = -600},
						lineEnd = {x = -850, y = -150},
						easingX = easing.inSine,
						easingY = easing.outSine,
				},
				[2] = {
						lineStart = {x = -1450, y = 600},
						lineEnd = {x = -850, y = 150},
						easingX = easing.inSine,
						easingY = easing.outSine,
				},
				[3] = {
						lineStart = {x = 1450, y = 600},
						lineEnd = {x = 850, y = 150},
						easingX = easing.inSine,
						easingY = easing.outSine,
				},
				[4] = {
						lineStart = {x = 1450, y = -600},
						lineEnd = {x = 850, y = -150},
						easingX = easing.inSine,
						easingY = easing.outSine,
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1200, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 1200, y = 0}
				},
			}
		},
		--Level 3
		[3] = {
			x = scale * .18,
			y = 80,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 1400, y =  300}},
			objectives = {
				fruit = 0,
				vegetable = 0,
				protein = 3,
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = -990, y = 450},
					patrolPath = {
						[1] = { x = -1000, y = 450},
						[2] = {x = -0, y = -450},
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1300, y = -550},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 1300, y = 500}
				},
			},
			asteroids = {
				[1] = {
					lineStart = {x = -200, y = 600},
					lineEnd = {x = 1000, y = -600},
					easingX = easing.inOutSine,
					easingY = easing.outInSine,
				},
			},
		},
		--Level 4
		[4] = {
			x = scale * .24,
			y = -80,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 900, y = 100}},
			objectives = {
				fruit = 2,
				vegetable = 0,
				protein = 0,
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = -1320, y = 0},
					patrolPath = {
						[1] = { x = -1300, y = 600},
						[2] = {x = -1300, y = -600}
					}
				},
				{
					type = "follower",
					spawnPoint = { x = 1310, y = 0},
					patrolPath = {
						[1] = { x = 1300, y = 600},
						[2] = {x = 1300, y = -600}
					}
				},
				{
					type = "follower",
					spawnPoint = { x = 0, y = 0},
					patrolPath = {
						[1] = { x = -400, y = 600},
						[2] = {x = 400, y = -600},
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -700, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = 700, y = 0}
				},
			},
			asteroids = {
				[1] = {
					lineStart = {x = -1200, y = 550},
					lineEnd = {x = -500, y = 0},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[2] = {
					lineStart = {x = -500, y = 0},
					lineEnd = {x = -1200, y = -550},
					easingX = easing.outSine,
					easingY = easing.inSine,
				},
				[3] = {
					lineStart = {x = 1200, y = 550},
					lineEnd = {x = 500, y = 0},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[4] = {
					lineStart = {x = 500, y = 0},
					lineEnd = {x = 1200, y = -550},
					easingX = easing.outSine,
					easingY = easing.inSine,
				},
			},
		},
		--Level 5
		[5] = {
			x = scale * .3,
			y = 100,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 700, y = 250}},
			objectives = {
				fruit = 0,
				vegetable = 3,
				protein = 0,
			},
			enemySpawnData = {
				{
					type = "shooter",
					spawnPoint = { x = -1400, y = 0},
					angle = 0
				},
				{
					type = "follower",
					spawnPoint = { x = -1300, y = 300},
					patrolPath = {
						[1] = { x = -100, y = 300},
						[2] = {x = -1400, y = 300}
					}
				},
				{
					type = "follower",
					spawnPoint = { x = -1300, y = -300},
					patrolPath = {
						[1] = { x = -100, y = -300},
						[2] = {x = -1400, y = -300}
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = 1100, y = -400},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "vegetable",
					asset = "images/planets/vegetables_1.png",
					position = {x = 1100, y = 400}
				}
			},
			asteroids = {
				[1] = {
					lineStart = {x = -350, y = 0},
					lineEnd = {x = 1500, y = 0},
				},
			},
		},
		--Level 6
		[6] = {
			x = scale * .36,
			y = -110,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = -1300, y = -500}},
			objectives = {
				fruit = 3,
				vegetable = 0,
				protein = 0,
			},
			enemySpawnData = {
				{
					type = "shooter",
					spawnPoint = { x = -500, y = 600},
					angle = 90
				},
				{
					type = "shooter",
					spawnPoint = { x = -100, y = -600},
					angle = 270
				},
				{
					type = "shooter",
					spawnPoint = { x = 100, y = 600},
					angle = 90
				},
				{
					type = "shooter",
					spawnPoint = { x = 500, y = -600},
					angle = 270
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = 1300, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = -1300, y = 0}
				},
			},
			asteroids = {
	
			},
		},
		--Level 7
		[7] = {
			x = scale * .42,
			y = 100,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = -1100, y = -600}},
			objectives = {
				fruit = 3,
				vegetable = 0,
				protein = 0,
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = -590, y = -400},
					patrolPath = {
						[1] = { x = -1200, y = 400},
						[2] = {x = -600, y = -400}
					}
				},
				{
					type = "follower",
					spawnPoint = { x = 590, y = -400},
					patrolPath = {
						[1] = { x = 1200, y = 400},
						[2] = {x = 600, y = -400}
					}
				},
				{
					type = "shooter",
					spawnPoint = { x = -100, y = -600},
					angle = 225
				},
				{
					type = "shooter",
					spawnPoint = { x = 50, y = 600},
					angle = 45
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1200, y = -550},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = 1200, y = 550}
				},
			},
			asteroids = {

			},
		},
		--Level 8
		[8] = {
			x = scale * .48,
			y = 0,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 1200, y = 400}},
			objectives = {
				fruit = 0,
				vegetable = 0,
				protein = 3,
			},
			enemySpawnData = {
				{
					type = "canoner",
					spawnPoint = { x = -300, y = -499},
					patrolPath = {
						[1] = { x = -300, y = -500},
						[2] = {x = -300, y = 500}
					}
				},
				{
					type = "canoner",
					spawnPoint = { x = 300, y = 499},
					patrolPath = {
						[1] = { x = 300, y = -500},
						[2] = {x = 300, y = 500}
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1100, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 1100, y = 0}
				},
			},
			asteroids = {

			},
		},
		--Level 9
		[9] = {
			x = scale * .54,
			y = 130,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 1300, y = 400}},
			objectives = {
				fruit = 0,
				vegetable = 3,
				protein = 0,
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = 0, y = 490},
					patrolPath = {
						[1] = { x = 100, y = -300},
						[2] = {x = 300, y = 0},
						[3] = {x = 100, y = -300},
						[4] = {x = 300, y = 0},
					}
				},
				{
					type = "follower",
					spawnPoint = { x = 0, y = -490},
					patrolPath = {
						[1] = { x = -100, y = -300},
						[2] = {x = -300, y = 0},
						[3] = {x = -100, y = -300},
						[4] = {x = -300, y = 0},
					}
				},
				{
					type = "shooter",
					spawnPoint = { x = -600, y = -600},
					angle = 315
				},
				{
					type = "shooter",
					spawnPoint = { x = -600, y = 600},
					angle = 45
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1300, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "vegetable",
					asset = "images/planets/vegetables_1.png",
					position = {x = 1300, y = 0}
				}
			},
			asteroids = {
				[1] = {
					lineStart = {x = 0, y = -300},
					lineEnd = {x = 0, y = 300},
				},
			},
		},
		--Level 10
		[10] = {
			x = scale * .6,
			y = -130,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 1300, y = 500}},
			objectives = {
				fruit = 3,
				vegetable = 0,
				protein = 0,
			},
			enemySpawnData = {
				{
					type = "canoner",
					spawnPoint = { x = 0, y = 0},
					patrolPath = {
						[1] = { x = -600, y = 400},
						[2] = {x = 600, y = -400},
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = 1300, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = -1300, y = 0}
				},
			},
			asteroids = {
				[1] = {
					lineStart = {x = 200, y = 500},
					lineEnd = {x = 1000, y = -500},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
			},
		},
		--Level 11
		[11] = {
			x = scale * .66,
			y = 100,
			background = "images/backgrounds/space.png",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = {x = 1600, y = 600}},
			objectives = {
				fruit = 1,
				vegetable = 1,
				protein = 1,
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = 0, y = 300},
					patrolPath = {
						[1] = { x = -1000, y = 100},
						[2] = {x = 1000, y = 700},
					}
				},
				{
					type = "canoner",
					spawnPoint = { x = 800, y = -800},
					patrolPath = {
						[1] = { x = -800, y = -200},
						[2] = {x = 800, y = -800},
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1800, y = -800},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = 1800, y = -800}
				},
				[2] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 1800, y = 800}
				},
				[3] = {
					foodType = "vegetable",
					asset = "images/planets/vegetables_1.png",
					position = {x = -1800, y = 800}
				}
			},
			asteroids = {
				[1] = {
					lineStart = {x = 400, y = -200},
					lineEnd = {x = 1500, y = -750},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[2] = {
					lineStart = {x = -1700, y = 200},
					lineEnd = {x = -400, y = 800},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
			},
		},
		--Level 12
		[12] = {
			x = scale * .72,
			y = -80,
			background = "images/backgrounds/space.png",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = {x = 1900, y = -900}},
			objectives = {
				fruit = 2,
				vegetable = 1,
				protein = 0,
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = -1000, y = -500},
					patrolPath = {
						[1] = { x = -1800, y = -300},
						[2] = {x = -500, y = -500},
						[3] = {x = -800, y = -800},
						[4] = {x = -500, y = -500},
					}
				},
				{
					type = "follower",
					spawnPoint = { x = -400, y = -400},
					patrolPath = {
						[1] = { x = -1800, y = -100},
						[2] = {x = -300, y = -200},
						[3] = {x = -200, y = -800},
						[4] = {x = -300, y = -200},
					}
				},

				{
					type = "follower",
					spawnPoint = { x = 0, y = 0},
					patrolPath = {
						[1] = { x = -1800, y = 400},
						[2] = {x = -100, y = 100},
						[3] = {x = 400, y = -800},
						[4] = {x = -100, y = 100},
					}
				},
				{
					type = "canoner",
					spawnPoint = { x = -800 , y = -800},
					patrolPath = {
						[1] = { x = -100, y = 800 },
						[2] = {x = 900, y = -400},
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1800, y = -700},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = 1800, y = -500}
				},
				[2] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 1700, y = 600}
				},
			},
			asteroids = {

			},
		},
		--Level 13
		[13] = {
			x = scale * .78 ,
			y = 70,
			background = "images/backgrounds/space.png",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = {x = 1600, y = 600}},
			objectives = {
				fruit = 1,
				vegetable = 1,
				protein = 1,
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = -500, y = 0},
					patrolPath = {
						[1] = { x = -500, y = 0},
						[2] = {x = 0, y = 500}
					}
				},
				{
					type = "canoner",
					spawnPoint = { x = -690, y = -900},
					patrolPath = {
						[1] = { x = -700, y = -900},
						[2] = { x = -500, y = -600},
						[3] = {x = -600, y = -400},
						[4] = {x = -1100, y = -100},
						[5] = {x = -1700, y = -400},
						[6] = {x = -1100, y = -100},
						[7] = {x = -600, y = -400},
						[8] = { x = -500, y = -600},
					}
				},
				{
					type = "canoner",
					spawnPoint = { x = 600, y = -100},
					patrolPath = {
						[1] = { x = 610, y = -100},
						[2] = { x = 700, y = 200},
						[3] = {x = 700, y = 500},
						[4] = {x = 400, y = 700},
						[5] = {x = -100, y = 500},
						[6] = {x = 400, y = 700},
						[7] = {x = 700, y = 500},
						[8] = { x = 610, y = -100},
					}
				},
				{
					type = "shooter",
					spawnPoint = { x = -1800, y = 200},
					angle = 0
				},
				{
					type = "shooter",
					spawnPoint = { x = -800, y = 900},
					angle = 90
				},
				{
					type = "shooter",
					spawnPoint = { x = 600, y = -900},
					angle = 270
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1400, y = -500},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = 1800, y = -800}
				},
				[2] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 1800, y = 800}
				},
				[3] = {
					foodType = "vegetable",
					asset = "images/planets/vegetables_1.png",
					position = {x = -1800, y = 800}
				}
			},
			asteroids = {
				[1] = {
					lineStart = {x = -1000, y = 500},
					lineEnd = {x = 1000, y = -500},
				},
			},
		},
		--Level 14
		[14] = {
			x = scale * .86,
			y = -80,
			background = "images/backgrounds/space.png",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = {x = -1900, y = -500}},
			objectives = {
				fruit = 1,
				vegetable = 0,
				protein = 1,
			},
			enemySpawnData = {
				{
					type = "shooter",
					spawnPoint = { x = -600, y = 0},
					angle = 180
				},
				{
					type = "shooter",
					spawnPoint = { x = 600, y = 0},
					angle = 0
				},
				{
					type = "shooter",
					spawnPoint = { x = 0, y = -600},
					angle = 90
				},
				{
					type = "shooter",
					spawnPoint = { x = 0, y = 600},
					angle = 270
				},
				{
					type = "canoner",
					spawnPoint = { x = 800, y = -100},
					patrolPath = {
						[1] = { x = 1000, y = -100},
						[2] = { x = 200, y = -700},
					}
				},
				{
					type = "canoner",
					spawnPoint = { x = -800, y = -100},
					patrolPath = {
						[1] = { x = -1000, y = 100},
						[2] = { x = -200, y = 700},
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = 0, y = 0},
				scaleFactor = 1.2
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = -1700, y = -700}
				},
				[2] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 1700, y = -700}
				},
			},
			asteroids = {
				
			},
		},
		--Level 15
		[15] = {
			x = scale * .92,
			y = 100,
			background = "images/backgrounds/space.png",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = {x = -1700, y = 200}},
			objectives = {
				fruit = 1,
				vegetable = 1,
				protein = 1,
			},
			enemySpawnData = {
				{
					type = "shooter",
					spawnPoint = { x = -1200, y = 400},
					angle = 315
				},
				{
					type = "shooter",
					spawnPoint = { x = -1200, y = -400},
					angle = 45
				},
				{
					type = "canoner",
					spawnPoint = { x = 1600, y = -800},
					patrolPath = {
						[1] = { x = 1700, y = -100},
						[2] = {x = 1600, y = -800}
					}
				},
				{
					type = "canoner",
					spawnPoint = { x = 1600, y = 300},
					patrolPath = {
						[1] = { x = 1100, y = 800},
						[2] = {x = 1600, y = 300}
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = 0, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = 0, y = -700}
				},
				[2] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 0, y = 700}
				},
				[3] = {
					foodType = "vegetable",
					asset = "images/planets/vegetables_1.png",
					position = {x = -1300, y = 0}
				}
			},
			asteroids = {
				[1] = {
					lineStart = {x = -1700, y = -400},
					lineEnd = {x = -800, y = 0},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[2] = {
					lineStart = {x = -800, y = 0},
					lineEnd = {x = -1700, y = 400},
					easingX = easing.outSine,
					easingY = easing.inSine,
				},
				[3] = {
					lineStart = {x = -600, y = -900},
					lineEnd = {x = 0, y = -300},
					easingX = easing.outSine,
					easingY = easing.inSine,
				},
				[4] = {
					lineStart = {x = 0, y = -300},
					lineEnd = {x = 500, y = -600},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[5] = {
					lineStart = {x = -600, y = 900},
					lineEnd = {x = 0, y = 300},
					easingX = easing.outSine,
					easingY = easing.inSine,
				},
				[6] = {
					lineStart = {x = 0, y = 300},
					lineEnd = {x = 500, y = 600},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[7] = {
					lineStart = {x = 900, y = -600},
					lineEnd = {x = 1100, y = 0},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[8] = {
					lineStart = {x = 1100, y = 0},
					lineEnd = {x = 700, y = 400},
					easingX = easing.outSine,
					easingY = easing.inSine,
				},
			},
		},
	},
	
}

return worldsData