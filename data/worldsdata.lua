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
	[1] = {
		path = {easingX = easing.linear, easingY = easing.inOutCubic},
		icon = "images/worlds/mundos01.png",
		--Level 1
		[1] = {
			x = scale * .067,
			y = 100,
			background = "images/backgrounds/space.png",
			levelWidth = 3000,
			levelHeight = 1500 ,
			ship = {position = {x = 1100, y = 0}},
			levelDescription = "Recolecta las porciones necesarias",
			objetives = {
				fruit = {
					portions = 2,
				},
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
--		--Level 2
--		[2] = {
--			x = scale * .12,
--			y = -50,
--			background = "images/backgrounds/space.png",
--			levelWidth = 3000,
--			levelHeight = 1500,
--			ship = {position = {x = 1300, y = 100}},
--			objectives = {
--				fruit = 0,
--				vegetable = 0,
--				protein = 3,
--			},
--			enemySpawnData = {
--				{
--					type = "follower",
--					spawnPoint = { x = -390, y = 500},
--					patrolPath = {
--						[1] = { x = -400, y = 550},
--						[2] = {x = -400, y = -550}
--					}
--				},
--				{
--					type = "follower",
--					spawnPoint = { x = 410, y = -500},
--					patrolPath = {
--						[1] = { x = 400, y = -550},
--						[2] = {x = 400, y = 550}
--					}
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = 0, y = -550},
--					angle = 270
--				},
--			},
--			asteroids = {
--				[1] = {
--						lineStart = {x = -1450, y = -600},
--						lineEnd = {x = -850, y = -150},
--						easingX = easing.inSine,
--						easingY = easing.outSine,
--				},
--				[2] = {
--						lineStart = {x = -1450, y = 600},
--						lineEnd = {x = -850, y = 150},
--						easingX = easing.inSine,
--						easingY = easing.outSine,
--				},
--				[3] = {
--						lineStart = {x = 1450, y = 600},
--						lineEnd = {x = 850, y = 150},
--						easingX = easing.inSine,
--						easingY = easing.outSine,
--				},
--				[4] = {
--						lineStart = {x = 1450, y = -600},
--						lineEnd = {x = 850, y = -150},
--						easingX = easing.inSine,
--						easingY = easing.outSine,
--				},
--			},
--			earth = {
--				name = "earth",
--				assetPath = "images/planets/earth/",
--				position = {x = -1200, y = 0},
--				scaleFactor = 1.5
--			},
--			planets = {
--				[1] = {
--					foodType = "protein",
--					asset = "images/planets/proteins_1.png",
--					position = {x = 1200, y = 0}
--				},
--			}
--		},
--		--Level 3
--		[3] = {
--			x = scale * .18,
--			y = 80,
--			background = "images/backgrounds/space.png",
--			levelWidth = 3000,
--			levelHeight = 1500,
--			ship = {position = {x = 1400, y =  300}},
--			objectives = {
--				fruit = 0,
--				vegetable = 0,
--				protein = 3,
--			},
--			enemySpawnData = {
--				{
--					type = "follower",
--					spawnPoint = { x = -1290, y = 450},
--					patrolPath = {
--						[1] = { x = -1300, y = 450},
--						[2] = {x = -300, y = -450},
--					}
--				},
--				{
--					type = "follower",
--					spawnPoint = { x = 410, y = -500},
--					patrolPath = {
--						[1] = { x = 300, y = 450},
--						[2] = {x = 1300, y = -450},
--					}
--				},
--			},
--			earth = {
--				name = "earth",
--				assetPath = "images/planets/earth/",
--				position = {x = -1300, y = -550},
--				scaleFactor = 1.5
--			},
--			planets = {
--				[1] = {
--					foodType = "protein",
--					asset = "images/planets/proteins_1.png",
--					position = {x = 1300, y = 500}
--				},
--			},
--			asteroids = {
--				[1] = {
--					lineStart = {x = -450, y = 600},
--					lineEnd = {x = 450, y = -600},
--					easingX = easing.inOutSine,
--					easingY = easing.outInSine,
--				},
--			},
--		},
--		--Level 4
--		[4] = {
--			x = scale * .24,
--			y = -80,
--			background = "images/backgrounds/space.png",
--			levelWidth = 3000,
--			levelHeight = 1500,
--			ship = {position = {x = 900, y = 100}},
--			objectives = {
--				fruit = 2,
--				vegetable = 0,
--				protein = 0,
--			},
--			enemySpawnData = {
--				{
--					type = "follower",
--					spawnPoint = { x = -1320, y = 0},
--					patrolPath = {
--						[1] = { x = -1300, y = 600},
--						[2] = {x = -1300, y = -600}
--					}
--				},
--				{
--					type = "follower",
--					spawnPoint = { x = 1310, y = 0},
--					patrolPath = {
--						[1] = { x = 1300, y = 600},
--						[2] = {x = 1300, y = -600}
--					}
--				},
--				{
--					type = "follower",
--					spawnPoint = { x = 0, y = 0},
--					patrolPath = {
--						[1] = { x = -400, y = 600},
--						[2] = {x = 400, y = -600},
--					}
--				},
--			},
--			earth = {
--				name = "earth",
--				assetPath = "images/planets/earth/",
--				position = {x = -700, y = 0},
--				scaleFactor = 1.5
--			},
--			planets = {
--				[1] = {
--					foodType = "fruit",
--					asset = "images/planets/fruits_1.png",
--					position = {x = 700, y = 0}
--				},
--			},
--			asteroids = {
--				[1] = {
--					lineStart = {x = -1200, y = 550},
--					lineEnd = {x = -500, y = 0},
--					easingX = easing.inSine,
--					easingY = easing.outSine,
--				},
--				[2] = {
--					lineStart = {x = -500, y = 0},
--					lineEnd = {x = -1200, y = -550},
--					easingX = easing.outSine,
--					easingY = easing.inSine,
--				},
--				[3] = {
--					lineStart = {x = 1200, y = 550},
--					lineEnd = {x = 500, y = 0},
--					easingX = easing.inSine,
--					easingY = easing.outSine,
--				},
--				[4] = {
--					lineStart = {x = 500, y = 0},
--					lineEnd = {x = 1200, y = -550},
--					easingX = easing.outSine,
--					easingY = easing.inSine,
--				},
--			},
--		},
--		--Level 5
--		[5] = {
--			x = scale * .3,
--			y = 100,
--			background = "images/backgrounds/space.png",
--			levelWidth = 3000,
--			levelHeight = 1500,
--			ship = {position = {x = 700, y = 250}},
--			objectives = {
--				fruit = 0,
--				vegetable = 3,
--				protein = 0,
--			},
--			enemySpawnData = {
--				{
--					type = "shooter",
--					spawnPoint = { x = -1400, y = 0},
--					angle = 45
--				},
--				{
--					type = "follower",
--					spawnPoint = { x = -1300, y = 300},
--					patrolPath = {
--						[1] = { x = -100, y = 300},
--						[2] = {x = -1400, y = 300}
--					}
--				},
--				{
--					type = "follower",
--					spawnPoint = { x = -1300, y = -300},
--					patrolPath = {
--						[1] = { x = -100, y = -300},
--						[2] = {x = -1400, y = -300}
--					}
--				},
--			},
--			earth = {
--				name = "earth",
--				assetPath = "images/planets/earth/",
--				position = {x = 1100, y = -400},
--				scaleFactor = 1.5
--			},
--			planets = {
--				[1] = {
--					foodType = "vegetable",
--					asset = "images/planets/vegetables_1.png",
--					position = {x = 1100, y = 400}
--				}
--			},
--			asteroids = {
--				[1] = {
--					lineStart = {x = -350, y = 0},
--					lineEnd = {x = 1500, y = 0},
--				},
--			},
--		},
--		--Level 6
--		[6] = {
--			x = scale * .36,
--			y = -110,
--			background = "images/backgrounds/space.png",
--			levelWidth = 3000,
--			levelHeight = 1500,
--			ship = {position = {x = 1300, y = -500}},
--			objectives = {
--				fruit = 3,
--				vegetable = 0,
--				protein = 0,
--			},
--			enemySpawnData = {
--				{
--					type = "shooter",
--					spawnPoint = { x = -900, y = -600},
--					angle = 270
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = -500, y = 600},
--					angle = 90
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = -100, y = -600},
--					angle = 270
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = 100, y = 600},
--					angle = 90
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = 500, y = -600},
--					angle = 270
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = 900, y = 600},
--					angle = 90
--				},
--			},
--			earth = {
--				name = "earth",
--				assetPath = "images/planets/earth/",
--				position = {x = 1300, y = 0},
--				scaleFactor = 1.5
--			},
--			planets = {
--				[1] = {
--					foodType = "fruit",
--					asset = "images/planets/fruits_1.png",
--					position = {x = -1300, y = 0}
--				},
--			},
--			asteroids = {
--	
--			},
--		},
--		--Level 7
--		[7] = {
--			x = scale * .42,
--			y = 100,
--			background = "images/backgrounds/space.png",
--			levelWidth = 3000,
--			levelHeight = 1500,
--			ship = {position = {x = -1100, y = 600}},
--			objectives = {
--				fruit = 3,
--				vegetable = 0,
--				protein = 0,
--			},
--			enemySpawnData = {
--				{
--					type = "follower",
--					spawnPoint = { x = -590, y = -400},
--					patrolPath = {
--						[1] = { x = -1200, y = 400},
--						[2] = {x = -600, y = -400}
--					}
--				},
--				{
--					type = "follower",
--					spawnPoint = { x = 590, y = -400},
--					patrolPath = {
--						[1] = { x = 1200, y = 400},
--						[2] = {x = 600, y = -400}
--					}
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = -100, y = -600},
--					angle = 225
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = -100, y = 600},
--					angle = 45
--				},
--			},
--			earth = {
--				name = "earth",
--				assetPath = "images/planets/earth/",
--				position = {x = -1200, y = -550},
--				scaleFactor = 1.5
--			},
--			planets = {
--				[1] = {
--					foodType = "fruit",
--					asset = "images/planets/fruits_1.png",
--					position = {x = 1200, y = 550}
--				},
--			},
--			asteroids = {
--
--			},
--		},
--		--Level 8
--		[8] = {
--			x = scale * .48,
--			y = 0,
--			background = "images/backgrounds/space.png",
--			levelWidth = 3000,
--			levelHeight = 1500,
--			ship = {position = {x = -1200, y = 400}},
--			objectives = {
--				fruit = 0,
--				vegetable = 0,
--				protein = 3,
--			},
--			enemySpawnData = {
--				{
--					type = "canoner",
--					spawnPoint = { x = -300, y = -499},
--					patrolPath = {
--						[1] = { x = -300, y = -500},
--						[2] = {x = -300, y = 500}
--					}
--				},
--				{
--					type = "canoner",
--					spawnPoint = { x = 300, y = 499},
--					patrolPath = {
--						[1] = { x = 300, y = -500},
--						[2] = {x = 300, y = 500}
--					}
--				},
--			},
--			earth = {
--				name = "earth",
--				assetPath = "images/planets/earth/",
--				position = {x = -1100, y = 0},
--				scaleFactor = 1.5
--			},
--			planets = {
--				[1] = {
--					foodType = "protein",
--					asset = "images/planets/proteins_1.png",
--					position = {x = 1100, y = 0}
--				},
--			},
--			asteroids = {
--
--			},
--		},
--		--Level 9
--		[9] = {
--			x = scale * .54,
--			y = 130,
--			background = "images/backgrounds/space.png",
--			levelWidth = 3000,
--			levelHeight = 1500,
--			ship = {position = {x = 1300, y = 400}},
--			objectives = {
--				fruit = 0,
--				vegetable = 3,
--				protein = 0,
--			},
--			enemySpawnData = {
--				{
--					type = "follower",
--					spawnPoint = { x = 0, y = 490},
--					patrolPath = {
--						[1] = { x = 500, y = 0},
--						[2] = {x = 0, y = -500},
--						[3] = { x = -500, y = 0},
--						[4] = {x = 0, y = 500},
--					}
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = -600, y = -600},
--					angle = 315
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = -600, y = 600},
--					angle = 45
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = -700, y = 0},
--					angle = 0
--				},
--			},
--			earth = {
--				name = "earth",
--				assetPath = "images/planets/earth/",
--				position = {x = -1300, y = 0},
--				scaleFactor = 1.5
--			},
--			planets = {
--				[1] = {
--					foodType = "vegetable",
--					asset = "images/planets/vegetables_1.png",
--					position = {x = 1300, y = 0}
--				}
--			},
--			asteroids = {
--				[1] = {
--					lineStart = {x = 0, y = -300},
--					lineEnd = {x = 0, y = 300},
--				},
--			},
--		},
--		--Level 10
--		[10] = {
--			x = scale * .6,
--			y = -130,
--			background = "images/backgrounds/space.png",
--			levelWidth = 3000,
--			levelHeight = 1500,
--			ship = {position = {x = 1300, y = 500}},
--			objectives = {
--				fruit = 3,
--				vegetable = 0,
--				protein = 0,
--			},
--			enemySpawnData = {
--				{
--					type = "canoner",
--					spawnPoint = { x = 0, y = 0},
--					patrolPath = {
--						[1] = { x = -600, y = 400},
--						[2] = {x = 600, y = -400},
--					}
--				},
--			},
--			earth = {
--				name = "earth",
--				assetPath = "images/planets/earth/",
--				position = {x = 1300, y = 0},
--				scaleFactor = 1.5
--			},
--			planets = {
--				[1] = {
--					foodType = "fruit",
--					asset = "images/planets/fruits_1.png",
--					position = {x = -1300, y = 0}
--				},
--			},
--			asteroids = {
--				[1] = {
--					lineStart = {x = 200, y = 500},
--					lineEnd = {x = 1000, y = -500},
--					easingX = easing.inSine,
--					easingY = easing.outSine,
--				},
--			},
--		},
--		--Level 11
--		[11] = {
--			x = scale * .66,
--			y = 100,
--			background = "images/backgrounds/space.png",
--			levelWidth = 4000,
--			levelHeight = 2000,
--			ship = {position = {x = 1600, y = 600}},
--			objectives = {
--				fruit = 1,
--				vegetable = 1,
--				protein = 1,
--			},
--			enemySpawnData = {
--				{
--					type = "follower",
--					spawnPoint = { x = 0, y = 300},
--					patrolPath = {
--						[1] = { x = -1000, y = 100},
--						[2] = {x = 1000, y = 700},
--					}
--				},
--				{
--					type = "canoner",
--					spawnPoint = { x = 800, y = -800},
--					patrolPath = {
--						[1] = { x = -800, y = -200},
--						[2] = {x = 800, y = -800},
--					}
--				},
--			},
--			earth = {
--				name = "earth",
--				assetPath = "images/planets/earth/",
--				position = {x = -1800, y = -800},
--				scaleFactor = 1.5
--			},
--			planets = {
--				[1] = {
--					foodType = "fruit",
--					asset = "images/planets/fruits_1.png",
--					position = {x = 1800, y = -800}
--				},
--				[2] = {
--					foodType = "protein",
--					asset = "images/planets/proteins_1.png",
--					position = {x = 1800, y = 800}
--				},
--				[3] = {
--					foodType = "vegetable",
--					asset = "images/planets/vegetables_1.png",
--					position = {x = -1800, y = 800}
--				}
--			},
--			asteroids = {
--				[1] = {
--					lineStart = {x = 400, y = -200},
--					lineEnd = {x = 1500, y = -750},
--					easingX = easing.inSine,
--					easingY = easing.outSine,
--				},
--				[2] = {
--					lineStart = {x = -1700, y = 200},
--					lineEnd = {x = -400, y = 800},
--					easingX = easing.inSine,
--					easingY = easing.outSine,
--				},
--			},
--		},
--		--Level 12
--		[12] = {
--			x = scale * .72,
--			y = -80,
--			background = "images/backgrounds/space.png",
--			levelWidth = 4000,
--			levelHeight = 2000,
--			ship = {position = {x = 1900, y = -900}},
--			objectives = {
--				fruit = 2,
--				vegetable = 1,
--				protein = 0,
--			},
--			enemySpawnData = {
--				{
--					type = "follower",
--					spawnPoint = { x = -1000, y = -500},
--					patrolPath = {
--						[1] = { x = -1800, y = -300},
--						[2] = {x = -500, y = -500},
--						[3] = {x = -800, y = -800},
--						[4] = {x = -500, y = -500},
--					}
--				},
--				{
--					type = "follower",
--					spawnPoint = { x = -400, y = -400},
--					patrolPath = {
--						[1] = { x = -1800, y = -100},
--						[2] = {x = -300, y = -200},
--						[3] = {x = -200, y = -800},
--						[4] = {x = -300, y = -200},
--					}
--				},
--
--				{
--					type = "follower",
--					spawnPoint = { x = 0, y = 0},
--					patrolPath = {
--						[1] = { x = -1800, y = 400},
--						[2] = {x = -100, y = 100},
--						[3] = {x = 400, y = -800},
--						[4] = {x = -100, y = 100},
--					}
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = 400, y = 0},
--					angle = 0
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = 800, y = -900},
--					angle = 270
--				},
--				{
--					type = "canoner",
--					spawnPoint = { x = -800 , y = -800},
--					patrolPath = {
--						[1] = { x = -1800, y = 800 },
--						[2] = {x = -1600, y = 700},
--						[3] = {x = -800, y = 600},
--						[4] = {x = -200, y = 500},
--						[5] = {x = 200, y = 400},
--					}
--				},
--			},
--			earth = {
--				name = "earth",
--				assetPath = "images/planets/earth/",
--				position = {x = -1800, y = -700},
--				scaleFactor = 1.5
--			},
--			planets = {
--				[1] = {
--					foodType = "fruit",
--					asset = "images/planets/fruits_1.png",
--					position = {x = 1800, y = -500}
--				},
--				[2] = {
--					foodType = "protein",
--					asset = "images/planets/proteins_1.png",
--					position = {x = 1700, y = 600}
--				},
--			},
--			asteroids = {
--
--			},
--		},
--		--Level 13
--		[13] = {
--			x = scale * .78 ,
--			y = 70,
--			background = "images/backgrounds/space.png",
--			levelWidth = 4000,
--			levelHeight = 2000,
--			ship = {position = {x = 1600, y = 600}},
--			objectives = {
--				fruit = 1,
--				vegetable = 1,
--				protein = 1,
--			},
--			enemySpawnData = {
--				{
--					type = "follower",
--					spawnPoint = { x = -500, y = 0},
--					patrolPath = {
--						[1] = { x = -500, y = 0},
--						[2] = {x = 0, y = 500}
--					}
--				},
--				{
--					type = "canoner",
--					spawnPoint = { x = -690, y = -900},
--					patrolPath = {
--						[1] = { x = -700, y = -900},
--						[2] = { x = -500, y = -600},
--						[3] = {x = -600, y = -400},
--						[4] = {x = -1100, y = -100},
--						[5] = {x = -1700, y = -400},
--						[6] = {x = -1100, y = -100},
--						[7] = {x = -600, y = -400},
--						[8] = { x = -500, y = -600},
--					}
--				},
--				{
--					type = "canoner",
--					spawnPoint = { x = 600, y = -100},
--					patrolPath = {
--						[1] = { x = 610, y = -100},
--						[2] = { x = 700, y = 200},
--						[3] = {x = 700, y = 500},
--						[4] = {x = 400, y = 700},
--						[5] = {x = -100, y = 500},
--						[6] = {x = 400, y = 700},
--						[7] = {x = 700, y = 500},
--						[8] = { x = 610, y = -100},
--					}
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = -1800, y = 200},
--					angle = 0
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = -800, y = 900},
--					angle = 90
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = 600, y = -900},
--					angle = 270
--				},
--			},
--			earth = {
--				name = "earth",
--				assetPath = "images/planets/earth/",
--				position = {x = -1400, y = -500},
--				scaleFactor = 1.5
--			},
--			planets = {
--				[1] = {
--					foodType = "fruit",
--					asset = "images/planets/fruits_1.png",
--					position = {x = 1800, y = -800}
--				},
--				[2] = {
--					foodType = "protein",
--					asset = "images/planets/proteins_1.png",
--					position = {x = 1800, y = 800}
--				},
--				[3] = {
--					foodType = "vegetable",
--					asset = "images/planets/vegetables_1.png",
--					position = {x = -1800, y = 800}
--				}
--			},
--			asteroids = {
--				[1] = {
--					lineStart = {x = -1000, y = 500},
--					lineEnd = {x = 1000, y = -500},
--				},
--			},
--		},
--		--Level 14
--		[14] = {
--			x = scale * .86,
--			y = -80,
--			background = "images/backgrounds/space.png",
--			levelWidth = 4000,
--			levelHeight = 2000,
--			ship = {position = {x = -1900, y = -500}},
--			objectives = {
--				fruit = 1,
--				vegetable = 0,
--				protein = 1,
--			},
--			enemySpawnData = {
--				{
--					type = "follower",
--					spawnPoint = { x = -380, y = 0},
--					patrolPath = {
--						[1] = { x = -400, y = 0},
--						[2] = {x = 0, y = -400},
--						[3] = {x = 400, y = 0},
--						[4] = {x = 0, y = -400},
--					}
--				},
--				{
--					type = "follower",
--					spawnPoint = { x = 380, y = 0},
--					patrolPath = {
--						[1] = { x = 400, y = 0},
--						[2] = {x = 0, y = -400},
--						[3] = {x = -400, y = 0},
--						[4] = {x = 0, y = 400},
--					}
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = -600, y = 0},
--					angle = 180
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = 600, y = 0},
--					angle = 0
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = 0, y = -600},
--					angle = 90
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = 0, y = 600},
--					angle = 270
--				},
--				{
--					type = "canoner",
--					spawnPoint = { x = -800, y = -100},
--					patrolPath = {
--						[1] = { x = -1000, y = -100},
--						[2] = { x = -200, y = -700},
--					}
--				},
--				{
--					type = "canoner",
--					spawnPoint = { x = 800, y = -100},
--					patrolPath = {
--						[1] = { x = 1000, y = -100},
--						[2] = { x = 200, y = -700},
--					}
--				},
--				{
--					type = "canoner",
--					spawnPoint = { x = 800, y = -100},
--					patrolPath = {
--						[1] = { x = 1000, y = 100},
--						[2] = { x = 200, y = 700},
--					}
--				},
--				{
--					type = "canoner",
--					spawnPoint = { x = -800, y = -100},
--					patrolPath = {
--						[1] = { x = -1000, y = 100},
--						[2] = { x = -200, y = 700},
--					}
--				},
--			},
--			earth = {
--				name = "earth",
--				assetPath = "images/planets/earth/",
--				position = {x = 0, y = 0},
--				scaleFactor = 1.2
--			},
--			planets = {
--				[1] = {
--					foodType = "fruit",
--					asset = "images/planets/fruits_1.png",
--					position = {x = -1700, y = -700}
--				},
--				[2] = {
--					foodType = "protein",
--					asset = "images/planets/proteins_1.png",
--					position = {x = 1700, y = -700}
--				},
--			},
--			asteroids = {
--				
--			},
--		},
--		--Level 15
--		[15] = {
--			x = scale * .92,
--			y = 100,
--			background = "images/backgrounds/space.png",
--			levelWidth = 4000,
--			levelHeight = 2000,
--			ship = {position = {x = -1700, y = 200}},
--			objectives = {
--				fruit = 1,
--				vegetable = 1,
--				protein = 1,
--			},
--			enemySpawnData = {
--				{
--					type = "shooter",
--					spawnPoint = { x = -1200, y = 400},
--					angle = 315
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = -1200, y = -400},
--					angle = 45
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = 500, y = -300},
--					angle = 270
--				},
--				{
--					type = "shooter",
--					spawnPoint = { x = 1900, y = 900},
--					angle = 180
--				},
--				{
--					type = "canoner",
--					spawnPoint = { x = 1600, y = -800},
--					patrolPath = {
--						[1] = { x = 1700, y = -100},
--						[2] = {x = 1600, y = -800}
--					}
--				},
--				{
--					type = "canoner",
--					spawnPoint = { x = 1600, y = 300},
--					patrolPath = {
--						[1] = { x = 1100, y = 800},
--						[2] = {x = 1600, y = 300}
--					}
--				},
--			},
--			earth = {
--				name = "earth",
--				assetPath = "images/planets/earth/",
--				position = {x = 0, y = 0},
--				scaleFactor = 1.5
--			},
--			planets = {
--				[1] = {
--					foodType = "fruit",
--					asset = "images/planets/fruits_1.png",
--					position = {x = 0, y = -700}
--				},
--				[2] = {
--					foodType = "protein",
--					asset = "images/planets/proteins_1.png",
--					position = {x = 0, y = 700}
--				},
--				[3] = {
--					foodType = "vegetable",
--					asset = "images/planets/vegetables_1.png",
--					position = {x = -1300, y = 0}
--				}
--			},
--			asteroids = {
--				[1] = {
--					lineStart = {x = -1700, y = -400},
--					lineEnd = {x = -800, y = 0},
--					easingX = easing.inSine,
--					easingY = easing.outSine,
--				},
--				[2] = {
--					lineStart = {x = -800, y = 0},
--					lineEnd = {x = -1700, y = 400},
--					easingX = easing.outSine,
--					easingY = easing.inSine,
--				},
--				[3] = {
--					lineStart = {x = -600, y = -900},
--					lineEnd = {x = 0, y = -300},
--					easingX = easing.outSine,
--					easingY = easing.inSine,
--				},
--				[4] = {
--					lineStart = {x = 0, y = -300},
--					lineEnd = {x = 500, y = -600},
--					easingX = easing.inSine,
--					easingY = easing.outSine,
--				},
--				[5] = {
--					lineStart = {x = -600, y = 900},
--					lineEnd = {x = 0, y = 300},
--					easingX = easing.outSine,
--					easingY = easing.inSine,
--				},
--				[6] = {
--					lineStart = {x = 0, y = 300},
--					lineEnd = {x = 500, y = 600},
--					easingX = easing.inSine,
--					easingY = easing.outSine,
--				},
--				[7] = {
--					lineStart = {x = 900, y = -600},
--					lineEnd = {x = 1100, y = 0},
--					easingX = easing.inSine,
--					easingY = easing.outSine,
--				},
--				[8] = {
--					lineStart = {x = 1100, y = 0},
--					lineEnd = {x = 700, y = 400},
--					easingX = easing.outSine,
--					easingY = easing.inSine,
--				},
--			},
--		},
--	},
	
	-- World 2
	[2] = {
		path = {easingX = easing.linear, easingY = easing.inOutCubic},
		icon = "images/worlds/mundos02.png",
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