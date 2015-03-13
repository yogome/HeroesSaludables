-----------------Constants
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenLeft = display.screenOriginX
local screenWidth = display.viewableContentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.viewableContentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight 
--------------------------------------

local worldsData = {
	-- World 1
	[1] = {
		path = {easingX = easing.linear, easingY = easing.inOutCubic},
		icon = "images/worlds/Mundos-03.png",
		--Level 1
		[1] = {
			x = 270,
			y = 100,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500 ,
			ship = {position = {x = 1200, y = 500}},
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
				{
					type = "follower",
					spawnPoint = { x = 290, y = -500},
					patrolPath = {
						[1] = { x = 300, y = 600},
						[2] = {x = 300, y = -600}
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
			x = 450,
			y = -50,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = -1300, y = 600}},
			objectives = {
				fruit = 6,
				vegetable = 6,
				protein = 6
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
				{
					type = "shooter",
					spawnPoint = { x = 0, y = -550},
					angle = 270
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
			x = 630,
			y = 80,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 1400, y =  200}},
			objectives = {
				fruit = 0,
				vegetable = 0,
				protein = 3,
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = -1290, y = 450},
					patrolPath = {
						[1] = { x = -1300, y = 450},
						[2] = {x = -300, y = -450},
						easingX = easing.inOutSine,
						easingY = easing.outInSine,
					}
				},
				{
					type = "follower",
					spawnPoint = { x = 410, y = -500},
					patrolPath = {
						[1] = { x = 300, y = 450},
						[2] = {x = 1300, y = -450},
						easingX = easing.inOutSine,
						easingY = easing.outInSine,
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1300, y = -550},
				scaleFactor = 0.75
			},
			planets = {
				[1] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 1300, y = 550}
				},
			},
			asteroids = {
				[1] = {
					lineStart = {x = -450, y = 600},
					lineEnd = {x = 450, y = -600},
					easingX = easing.inOutSine,
					easingY = easing.outInSine,
				},
			},
		},
		--Level 4
		[4] = {
			x = 840,
			y = -80,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 900, y = 500}},
			objectives = {
				fruit = 1,
				vegetable = 1,
				protein = 1,
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
						easingX = easing.inOutSine,
						easingY = easing.outInSine,
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -700, y = 0},
				scaleFactor = 0.75
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
			x = 1000,
			y = 100,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 300, y = -200}},
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
				scaleFactor = 0.75
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
			x = 1180,
			y = -110,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = 1300, y = -500}},
			objectives = {
				fruit = 3,
				vegetable = 0,
				protein = 0,
			},
			enemySpawnData = {
				{
					type = "shooter",
					spawnPoint = { x = -900, y = -600},
					angle = 270
				},
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
				{
					type = "shooter",
					spawnPoint = { x = 900, y = 600},
					angle = 90
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = 1300, y = 0},
				scaleFactor = 0.75
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
			x = 1260,
			y = 210,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = -1100, y = 600}},
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
					spawnPoint = { x = -100, y = 600},
					angle = 45
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1200, y = -550},
				scaleFactor = 0.75
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
			x = 1480,
			y = 0,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500,
			ship = {position = {x = -1200, y = 400}},
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
				scaleFactor = 0.75
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
			x = 1590,
			y = 200,
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
						[1] = { x = 500, y = 0},
						[2] = {x = 0, y = -500},
						[3] = { x = -500, y = 0},
						[4] = {x = 0, y = 500},
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
				{
					type = "shooter",
					spawnPoint = { x = -700, y = 0},
					angle = 0
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1300, y = 0},
				scaleFactor = 0.75
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
			x = 1820,
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
						easingX = easing.inOutSine,
						easingY = easing.outInSine,
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = 1300, y = 0},
				scaleFactor = 0.75
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
			x = 1870,
			y = 230,
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
						easingX = easing.inOutSine,
						easingY = easing.outInSine,
					}
				},
				{
					type = "canoner",
					spawnPoint = { x = -0, y = -500},
					patrolPath = {
						[1] = { x = -800, y = -200},
						[2] = {x = 800, y = -800},
						easingX = easing.inOutSine,
						easingY = easing.outInSine,
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1800, y = -800},
				scaleFactor = 0.75
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
			x = 2110,
			y = -110,
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
						[2] = {x = -800, y = -800},
						easingX = easing.inCubic,
						easingY = easing.outCubic,
					}
				},
				{
					type = "follower",
					spawnPoint = { x = -400, y = -400},
					patrolPath = {
						[1] = { x = -1800, y = -100},
						[2] = {x = -200, y = -800},
						easingX = easing.inCubic,
						easingY = easing.outCubic,
					}
				},

				{
					type = "follower",
					spawnPoint = { x = 0, y = 0},
					patrolPath = {
						[1] = { x = -1800, y = 400},
						[2] = {x = 400, y = -800},
						easingX = easing.inCubic,
						easingY = easing.outCubic,
					}
				},
				{
					type = "shooter",
					spawnPoint = { x = 400, y = 0},
					angle = 0
				},
				{
					type = "shooter",
					spawnPoint = { x = 800, y = -800},
					angle = 270
				},
				{
					type = "canoner",
					spawnPoint = { x = -800 , y = -800},
					patrolPath = {
						[1] = { x = -1800, y = 800 },
						[2] = {x = 200, y = 400},
						easingX = easing.inOutSine,
						easingY = easing.outInSine,
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1800, y = -700},
				scaleFactor = 0.75
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
			x = 2220,
			y = 230,
			background = "images/backgrounds/space.png",
			levelWidth = 10000,
			levelHeight = 10000,
			ship = {position = {x = 0, y = 0}},
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
					spawnPoint = { x = 400, y = -800},
					patrolPath = {
						[1] = { x = 400, y = -800},
						[2] = {x = 0, y = -400}
					}
				},
			},
			earth = {
				name = "earth",
				asset = "images/planets/earth_happy.png",
				position = {x = -600, y = -700},
				scaleFactor = 0.75
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = -700, y = 700}
				},
				[2] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 500, y = 550}
				},
				[3] = {
					foodType = "vegetable",
					asset = "images/planets/vegetables_1.png",
					position = {x = 740, y = -800}
				}
			},
			asteroids = {
				[1] = {
					lineStart = {x = -200, y = 600},
					lineEnd = {x = -700, y = 100},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[2] = {
					lineStart = {x = 100, y = -200},
					lineEnd = {x = 600, y = -700},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
			},
		},
		--Level 14
		[14] = {
			x = 2350,
			y = -135,
			background = "images/backgrounds/space.png",
			levelWidth = 10000,
			levelHeight = 10000,
			ship = {position = {x = 0, y = 0}},
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
					spawnPoint = { x = 400, y = -800},
					patrolPath = {
						[1] = { x = 400, y = -800},
						[2] = {x = 0, y = -400}
					}
				},
			},
			earth = {
				name = "earth",
				asset = "images/planets/earth_happy.png",
				position = {x = -600, y = -700},
				scaleFactor = 0.75
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = -700, y = 700}
				},
				[2] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 500, y = 550}
				},
				[3] = {
					foodType = "vegetable",
					asset = "images/planets/vegetables_1.png",
					position = {x = 740, y = -800}
				}
			},
			asteroids = {
				[1] = {
					lineStart = {x = -200, y = 600},
					lineEnd = {x = -700, y = 100},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[2] = {
					lineStart = {x = 100, y = -200},
					lineEnd = {x = 600, y = -700},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
			},
		},
		--Level 15
		[15] = {
			x = 2600,
			y = 100,
			background = "images/backgrounds/space.png",
			levelWidth = 10000,
			levelHeight = 10000,
			ship = {position = {x = 0, y = 0}},
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
					spawnPoint = { x = 400, y = -800},
					patrolPath = {
						[1] = { x = 400, y = -800},
						[2] = {x = 0, y = -400}
					}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -600, y = -700},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = -700, y = 700}
				},
				[2] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 500, y = 550}
				},
				[3] = {
					foodType = "vegetable",
					asset = "images/planets/vegetables_1.png",
					position = {x = 740, y = -800}
				}
			},
			asteroids = {
				[1] = {
					lineStart = {x = -200, y = 600},
					lineEnd = {x = -700, y = 100},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
				[2] = {
					lineStart = {x = 100, y = -200},
					lineEnd = {x = 600, y = -700},
					easingX = easing.inSine,
					easingY = easing.outSine,
				},
			},
		},
	},
	
	-- World 2
--	[2] = {
--		[1] = {}, -- Level data goes here
--	}
}

return worldsData