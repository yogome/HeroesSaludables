local numberOfBacks = 4
local scale = (display.viewableContentHeight / 768) * 1024 * numberOfBacks
local worldData = {
	--World = 1, Level = 3
	path = {easingX = easing.linear, easingY = easing.inOutCubic},
	icon = "images/worlds/mundos03.png",
	[1] = {
		x = scale * .067,
		y = 100,
		background = "images/backgrounds/space.png",
		levelDescription = "Recolecta las porciones necesarias",
		levelWidth = 4000,
		levelHeight = 2000,
		ship = {position = { x = -1900, y = -400}},
		objetives = {
			fruit = {portions = 3},
		},
		enemySpawnData = {
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = -1000, y = -700},
				patrolPath = {
                                    [1] = {x = -1000, y = -700},
                                    [2] = {x = -1000, y = 700}
                                },
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = -400, y = -800},
				patrolPath = {[1] = {x = -400, y = -800}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = 400, y = 800},
				patrolPath = {[1] = {x = 400, y = 800}},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 1000, y = 600},
				patrolPath = {
                                    [1] = {x = 1000, y = 600},
                                    [2] = {x = 1000, y = -600}
                                },
			},
		},
		obstacle = {
			[1] = {
				type = "blackhole",
				position = {x = -1900, y = -700},
			},
			[2] = {
				type = "blackhole",
				position = {x = -1900, y = 700},
			},
			[3] = {
				type = "blackhole",
				position = {x = -1700, y = 600},
			},
			[4] = {
				type = "blackhole",
				position = {x = -1700, y = -600},
			},
			[5] = {
				type = "blackhole",
				position = {x = -1500, y = -500},
			},
			[6] = {
				type = "blackhole",
				position = {x = -1500, y = 500},
			},
			[7] = {
				type = "blackhole",
				position = {x = -1400, y = -300},
			},
			[8] = {
				type = "blackhole",
				position = {x = -1400, y = 300},
			},
			[9] = {
				type = "blackhole",
				position = {x = 1900, y = -700},
			},
			[10] = {
				type = "blackhole",
				position = {x = 1900, y = 700},
			},
			[11] = {
				type = "blackhole",
				position = {x = 1700, y = 600},
			},
			[12] = {
				type = "blackhole",
				position = {x = 1500, y = 500},
			},
			[13] = {
				type = "blackhole",
				position = {x = 1700, y = -600},
			},
			[14] = {
				type = "blackhole",
				position = {x = 1500, y = -500},
			},
			[15] = {
				type = "blackhole",
				position = {x = 1300, y = -300},
			},
			[16] = {
				type = "blackhole",
				position = {x = 1300, y = 300},
			},
		},
		earth = {
			position = { x = 1800, y = 0},
			name = "earth",
			assetPath = "images/planets/earth/",
			scaleFactor = 1.5,
		},
		planets = {
			[1] = {
				foodType = "fruit",
				position = {x = -1800, y = 0},
			},
		},
		asteroids = {
		},
	},

	--World = 2, Level = 3

	[2] = {
		x = scale * .117,
		y = 100,
		background = "images/backgrounds/space.png",
		levelDescription = "Recolecta las porciones necesarias",
		levelWidth = 4000,
		levelHeight = 2000,
		ship = {position = { x = -1800, y = -300}},
		objetives = {
			vegetable = {portions = 3},
		},
		enemySpawnData = {
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = -1300, y = 900},
				patrolPath = {[1] = {x = -1300, y = 1000}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = -400, y = -900},
				patrolPath = {[1] = {x = -400, y = -1000}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = 500, y = 900},
				patrolPath = {[1] = {x = 500, y = 1000}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = 1300, y = -900},
				patrolPath = {[1] = {x = 1300, y = -1000}},
			},
		},
		obstacle = {
			[1] = {
				type = "blackhole",
				position = {x = 0, y = 0},
			},
			[2] = {
				type = "blackhole",
				position = {x = 900, y = 0},
			},
			[3] = {
				type = "blackhole",
				position = {x = -900, y = 0},
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
				foodType = "vegetable",
				position = {x = -1700, y = 0},
			},
		},
		asteroids = {
		},
	},

	--World = 3, Level = 3

	[3] = {
		x = scale * .167,
		y = 100,
		background = "images/backgrounds/space.png",
		levelDescription = "Recolecta las porciones necesarias",
		levelWidth = 4000,
		levelHeight = 2000,
		ship = {position = { x = -1900, y = -500}},
		objetives = {
			cereal = {portions = 2},
		},
		enemySpawnData = {
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = -1200, y = -700},
				patrolPath = {
                                    [1] = {x = -1200, y = -700},
                                    [2] = {x = -1200, y = 700}
                                },
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = -300, y = 700},
				patrolPath = {
                                    [1] = {x = -300, y = 700},
                                    [2] = {x = -300, y = -700}
                                },
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 700, y = 700},
				patrolPath = {
                                    [1] = {x = 700, y = 700},
                                    [2] = {x = 700, y = -700}
                                },
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 1200, y = -700},
				patrolPath = {
                                    [1] = {x = 1200, y = -700},
                                    [2] = {x = 1200, y = 700}
                                },
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = -700, y = -900},
				patrolPath = {[1] = {x = -700, y = -900}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = 1000, y = 900},
				patrolPath = {[1] = {x = 1000, y = 900}},
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
				foodType = "cereal",
				position = {x = -1700, y = 0},
			},
		},
		asteroids = {
		},
	},

	--World = 4, Level = 3

	[4] = {
		x = scale * .217,
		y = 100,
		background = "images/backgrounds/space.png",
		levelDescription = "Recolecta las porciones necesarias",
		levelWidth = 4000,
		levelHeight = 2000,
		ship = {position = { x = -1900, y = 400}},
		objetives = {dryfruit = { portions= 3}},
		enemySpawnData = {
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 600, y = -700},
				patrolPath = {
                                    [1] = {x = 600, y = -700},
                                    [2] = {x = -600, y = -400},
                                },
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -400, y = 600},
				patrolPath = {
                                    [1] = {x = -400, y = 600},
                                    [2] = {x = 1000, y = -100}
                                },
			},
			{
				type = "shooter",
				angle = 290,
				spawnPoint = {x = -900, y = -600},
				patrolPath = {[1] = {x = -900, y = -300}},
			},
			{
				type = "shooter",
				angle = 120,
				spawnPoint = {x = 1200, y = 100},
				patrolPath = {[1] = {x = 1200, y = -100}},
			},
		},
		obstacle = {
			[1] = {
				type = "blackhole",
				position = {x = 0, y = -200},
			},
		},
		earth = {
			position = { x = 1600, y = -700},
			name = "earth",
			assetPath = "images/planets/earth/",
			scaleFactor = 1.5,
		},
		planets = {
			[1] = {
				foodType = "dryfruit",
				position = {x = -1600, y = 600},
			},
		},
		asteroids = {
			[1] = {
				lineStart = { x = -2000, y = -400},
				lineEnd = { x = 100, y = -1000},
				easingX = easing.linear,
				easingY = easing.linear,
			},
			[2] = {
				lineStart = { x = -400, y = 1000},
				lineEnd = { x = 2000, y = -200},
				easingX = easing.linear,
				easingY = easing.linear,
			},
		},
	},

	--World = 5, Level = 3

	[5] = {
		x = scale * .267,
		y = 100,
		background = "images/backgrounds/space.png",
		levelDescription = "Recolecta las porciones necesarias",
		levelWidth = 4000,
		levelHeight = 2000,
		ship = {position = { x = -1900, y = -300}},
		objetives = {fruit = {portions = 3}},
		enemySpawnData = {
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = -1100, y = -600},
				patrolPath = {[1] = {x = -1100, y = -600}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = -600, y = 600},
				patrolPath = {[1] = {x = -600, y = 600}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = 0, y = -600},
				patrolPath = {[1] = {x = 0, y = -600}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = 400, y = 600},
				patrolPath = {[1] = {x = 400, y = 600}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = 1000, y = -600},
				patrolPath = {[1] = {x = 1000, y = -600}},
			},
		},
		obstacle = {
			[1] = {
				type = "blackhole",
				position = {x = 1600, y = -900},
			},
			[2] = {
				type = "blackhole",
				position = {x = 1600, y = -800},
			},
			[3] = {
				type = "blackhole",
				position = {x = 1600, y = 800},
			},
			[4] = {
				type = "blackhole",
				position = {x = 1600, y = 900},
			},
			[5] = {
				type = "blackhole",
				position = {x = 700, y = 0},
			},
			[6] = {
				type = "blackhole",
				position = {x = -800, y = 0},
			},
			[7] = {
				type = "blackhole",
				position = {x = 0, y = 500},
			},
		},
		earth = {
			position = { x = 1500, y = 0},
			name = "earth",
			assetPath = "images/planets/earth/",
			scaleFactor = 1.5,
		},
		planets = {
			[1] = {
				foodType = "fruit",
				position = {x = -1600, y = 0},
			},
		},
		asteroids = {
			[1] = {
				lineStart = { x = -1400, y = -700},
				lineEnd = { x = -1400, y = -600},
				easingX = easing.linear,
				easingY = easing.linear,
			},
			[2] = {
				lineStart = { x = 1600, y = -600},
				lineEnd = { x = 1600, y = -700},
				easingX = easing.linear,
				easingY = easing.linear,
			},
			[3] = {
				lineStart = { x = -1400, y = -700},
				lineEnd = { x = 1600, y = -700},
				easingX = easing.linear,
				easingY = easing.linear,
			},
			[4] = {
				lineStart = { x = 1600, y = 700},
				lineEnd = { x = -1400, y = 700},
				easingX = easing.linear,
				easingY = easing.linear,
			},
			[5] = {
				lineStart = { x = -1400, y = 700},
				lineEnd = { x = -1400, y = 600},
				easingX = easing.linear,
				easingY = easing.linear,
			},
			[6] = {
				lineStart = { x = 1600, y = 700},
				lineEnd = { x = 1600, y = 600},
				easingX = easing.linear,
				easingY = easing.linear,
			},
		},
	},

	--World = 6, Level = 3

	[6] = {
		x = scale * .317,
		y = 100,
		background = "images/backgrounds/space.png",
		levelDescription = "Recolecta las porciones necesarias",
		levelWidth = 4000,
		levelHeight = 4000,
		ship = {position = { x = -1900, y = -1800}},
		objetives = {
			fruit = {portions = 3},
			vegetable = {portions = 3},
		},
		enemySpawnData = {
			{
				type = "shooter",
				angle = 310,
				spawnPoint = {x = 100, y = -800},
				patrolPath = {[1] = {x = 100, y = -800}},
			},
			{
				type = "shooter",
				angle = 130,
				spawnPoint = {x = -100, y = 900},
				patrolPath = {[1] = {x = -100, y = 900}},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = -900, y = -1600},
				patrolPath = {
                                    [1] = {x = -900, y = -1600},
                                    [2] = {x = -1400, y = -1000}
                                },
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 800, y = 1500},
				patrolPath = {
                                    [1] = {x = 800, y = 1500},
                                    [2] = {x = 1400, y = 1000},
                                },
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 800, y = -800},
				patrolPath = {
                                    [1] = {x = 800, y = -800},
                                    [2] = {x = 1200, y = 1000},
                                },
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -700, y = 800},
				patrolPath = {
                                    [1] = {x = -700, y = 800},
                                    [2] = {x = -1500, y = -800}
                                },
			},
		},
		obstacle = {
			[1] = {
				type = "blackhole",
				position = {x = -700, y = 0},
			},
			[2] = {
				type = "blackhole",
				position = {x = -500, y = -200},
			},
			[3] = {
				type = "blackhole",
				position = {x = -300, y = -400},
			},
			[4] = {
				type = "blackhole",
				position = {x = -100, y = -600},
			},
			[5] = {
				type = "blackhole",
				position = {x = 100, y = 700},
			},
			[6] = {
				type = "blackhole",
				position = {x = 300, y = 500},
			},
			[7] = {
				type = "blackhole",
				position = {x = 500, y = 300},
			},
			[8] = {
				type = "blackhole",
				position = {x = 700, y = 100},
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
				position = {x = -1500, y = -1500},
			},
			[2] = {
				foodType = "vegetable",
				position = {x = 1400, y = 1500},
			},
		},
		asteroids = {
		},
	},

	--World = 7, Level = 3

	[7] = {
		x = scale * .367,
		y = 100,
		background = "images/backgrounds/space.png",
		levelDescription = "Recolecta las porciones necesarias",
		levelWidth = 4000,
		levelHeight = 4000,
		ship = {position = { x = -1800, y = -1100}},
		objetives = {
			fruit = {portions = 2},
			vegetable = {portions = 2},},
		enemySpawnData = {
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = -1200, y = -200},
				patrolPath = {[1] = {x = -1200, y = -200}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = -300, y = 0},
				patrolPath = {[1] = {x = -300, y = 0}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = 500, y = -200},
				patrolPath = {[1] = {x = 500, y = -200}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = 1300, y = 0},
				patrolPath = {[1] = {x = 1300, y = 0}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = -300, y = -1400},
				patrolPath = {[1] = {x = -300, y = -1400}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = 1200, y = -1400},
				patrolPath = {[1] = {x = 1200, y = -1400}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = -1200, y = 1300},
				patrolPath = {[1] = {x = -1200, y = 1300}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = 500, y = 1300},
				patrolPath = {[1] = {x = 500, y = 1300}},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -1600, y = 200},
				patrolPath = {
                                    [1] = {x = -1600, y = 200},
                                    [2] = {x = -1600, y = 1500},
                                },
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 1600, y = 100},
				patrolPath = {
                                    [1] = {x = 1600, y = 100},
                                    [2] = {x = 1600, y = 1500},
                                },
			},
		},
		obstacle = {
			[1] = {
				type = "blackhole",
				position = {x = 0, y = -500},
			},
			[2] = {
				type = "blackhole",
				position = {x = -800, y = -900},
			},
			[3] = {
				type = "blackhole",
				position = {x = 900, y = -900},
			},
			[4] = {
				type = "blackhole",
				position = {x = 0, y = 300},
			},
			[5] = {
				type = "blackhole",
				position = {x = -800, y = 800},
			},
			[6] = {
				type = "blackhole",
				position = {x = 900, y = 800},
			},
		},
		earth = {
			position = { x = 1500, y = -700},
			name = "earth",
			assetPath = "images/planets/earth/",
			scaleFactor = 1.5,
		},
		planets = {
			[1] = {
				foodType = "vegetable",
				position = {x = -1600, y = -700},
			},
			[2] = {
				foodType = "fruit",
				position = {x = 0, y = 1000},
			},
		},
		asteroids = {
			[1] = {
				lineStart = { x = -1300, y = 0},
				lineEnd = { x = -300, y = -200},
				easingX = easing.linear,
				easingY = easing.linear,
			},
			[2] = {
				lineStart = { x = -300, y = -200},
				lineEnd = { x = 500, y = 0},
				easingX = easing.linear,
				easingY = easing.linear,
			},
			[3] = {
				lineStart = { x = 500, y = 0},
				lineEnd = { x = 1400, y = -200},
				easingX = easing.linear,
				easingY = easing.linear,
			},
		},
	},

	--World = 8, Level = 3

	[8] = {
		x = scale * .417,
		y = 100,
		background = "images/backgrounds/space.png",
		levelDescription = "Recolecta las porciones necesarias",
		levelWidth = 4000,
		levelHeight = 4000,
		ship = {position = { x = -100, y = -500}},
		objetives = {
			fruit = {portions = 2},
			dryfruit = {portions = 2}
			},
		enemySpawnData = {
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = 1300, y = -100},
				patrolPath = {[1] = {x = 1300, y = -100}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = -1000, y = -100},
				patrolPath = {[1] = {x = -1000, y = -100}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = 1000, y = -100},
				patrolPath = {[1] = {x = 1000, y = -100}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = -700, y = -100},
				patrolPath = {[1] = {x = -700, y = -100}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = -300, y = -100},
				patrolPath = {[1] = {x = -300, y = -100}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = 600, y = -100},
				patrolPath = {[1] = {x = 600, y = -100}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = 300, y = -100},
				patrolPath = {[1] = {x = 300, y = -100}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = 0, y = -100},
				patrolPath = {[1] = {x = 0, y = -100}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = 600, y = 100},
				patrolPath = {[1] = {x = 600, y = 100}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = 300, y = 100},
				patrolPath = {[1] = {x = 300, y = 100}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = 0, y = 100},
				patrolPath = {[1] = {x = 0, y = 100}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = -300, y = 100},
				patrolPath = {[1] = {x = -300, y = 100}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = -700, y = 100},
				patrolPath = {[1] = {x = -700, y = 100}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = -1000, y = 100},
				patrolPath = {[1] = {x = -1000, y = 100}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = 1000, y = 100},
				patrolPath = {[1] = {x = 1000, y = 100}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = 1300, y = 100},
				patrolPath = {[1] = {x = 1300, y = 100}},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -900, y = -1000},
				patrolPath = {
                                    [1] = {x = -900, y = -1000},
                                    [2] = {x = -1700, y = -500}
                                },
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -1300, y = 0},
				patrolPath = {
                                    [1] = {x = -1300, y = 0},
                                    [2] = {x = -1700, y = 500}
                                },
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -1000, y = 700},
				patrolPath = {
                                    [1] = {x = -1000, y = 700},
                                    [2] = {x = 1700, y = 1700}
                                },
			},
		},
		obstacle = {
		},
		earth = {
			position = { x = 1600, y = 900},
			name = "earth",
			assetPath = "images/planets/earth/",
			scaleFactor = 1.5,
		},
		planets = {
			[1] = {
				foodType = "fruit",
				position = {x = 1600, y = -700},
			},
			[2] = {
				foodType = "dryfruit",
				position = {x = -1500, y = -900},
			},
		},
		asteroids = {
			[1] = {
				lineStart = { x = 2000, y = 0},
				lineEnd = { x = -1000, y = 0},
				easingX = easing.linear,
				easingY = easing.linear,
			},
		},
	},

	--World = 9, Level = 3

	[9] = {
		x = scale * .467,
		y = 100,
		background = "images/backgrounds/space.png",
		levelDescription = "Recolecta las porciones necesarias",
		levelWidth = 4000,
		levelHeight = 4000,
		ship = {position = { x = -1700, y = -300}},
		objetives = {
			fruit = {portions = 3},
			vegetable = {portions = 3},
			protein = {portions = 3},
		},
		enemySpawnData = {
			{
				type = "shooter",
				angle = 30,
				spawnPoint = {x = -1200, y = -400},
				patrolPath = {[1] = {x = -1100, y = -500}},
			},
			{
				type = "shooter",
				angle = 330,
				spawnPoint = {x = -1200, y = 500},
				patrolPath = {[1] = {x = -1200, y = 500}},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 200, y = 1200},
				patrolPath = {
					[1] = {x = 200, y = 1200},
					[2] = {x = -1400, y = 1600},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 300, y = 500},
				patrolPath = {
					[1] = {x = 300, y = 500},
					[2] = {x = -500, y = 200}
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 700, y = -400},
				patrolPath = {
					[1] = {x = 700, y = -400},
					[2] = {x = -800, y = -500}
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 400, y = -1200},
				patrolPath = {
					[1] = {x = 400, y = -1200},
					[2] = {x = -1400, y = -1000}
				},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 800, y = 1300},
				patrolPath = {
					[1] = {x = 800, y = 1300},
					[2] = {x = 1300, y = 1000}
				},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 1500, y = -1300},
				patrolPath = {
						[1] = {x = 1500, y = -1300},
						[2] = {x = 900, y = -1600}
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
				foodType = "fruit",
				position = {x = -1600, y = 0},
			},
			[2] = {
				foodType = "vegetable",
				position = {x = 1100, y = -1000},
			},
			[3] = {
				foodType = "protein",
				position = {x = 900, y = 700},
			},
		},
		asteroids = {
			[1] = {
				lineStart = { x = -1500, y = -500},
				lineEnd = { x = -1100, y = 0},
				easingX = easing.inQuad,
				easingY = easing.linear,
			},
			[2] = {
				lineStart = { x = -1100, y = 0},
				lineEnd = { x = -1500, y = 500},
				easingX = easing.outCirc,
				easingY = easing.linear,
			},
			[3] = {
				lineStart = { x = 800, y = -1400},
				lineEnd = { x = 1100, y = -600},
				easingX = easing.outExpo,
				easingY = easing.linear,
			},
			[4] = {
				lineStart = { x = 1100, y = -600},
				lineEnd = { x = 1400, y = -1100},
				easingX = easing.inExpo,
				easingY = easing.linear,
			},
			[5] = {
				lineStart = { x = 600, y = 1000},
				lineEnd = { x = 800, y = 400},
				easingX = easing.outExpo,
				easingY = easing.linear,
			},
			[6] = {
				lineStart = { x = 800, y = 400},
				lineEnd = { x = 1300, y = 700},
				easingX = easing.inExpo,
				easingY = easing.linear,
			},
		},
	},

	--World = 10, Level = 3

	[10] = {
		x = scale * .517,
		y = 100,
		background = "images/backgrounds/space.png",
		levelDescription = "Recolecta las porciones necesarias",
		levelWidth = 4000,
		levelHeight = 4000,
		ship = {position = { x = -1500, y = -1200}},
		objetives = {
			fruit = {portions = 2},
			protein = {portions = 1},
			dryfruit = {portions = 2},
		},
		enemySpawnData = {
			{
				type = "shooter",
				angle = 315,
				spawnPoint = {x = 100, y = -1000},
				patrolPath = {[1] = {x = 100, y = -1000}},
			},
			{
				type = "shooter",
				angle = 135,
				spawnPoint = {x = -100, y = 700},
				patrolPath = {[1] = {x = -100, y = 700}},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 400, y = -1300},
				patrolPath = {
					[1] = {x = 400, y = -1300},
					[2] = {x = 1300, y = -400}
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -100, y = 1100},
				patrolPath = {
					[1] = {x = -100, y = 1100},
					[2] = {x = -1500, y = 0}
				},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 1700, y = 500},
				patrolPath = {
					[1] = {x = 1700, y = 500},
					[2] = {x = 700, y = 1000}
				},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = -1500, y = -600},
				patrolPath = {
					[1] = {x = -1500, y = -600},
					[2] = {x = -700, y = -1300}
				},
			},
		},
		obstacle = {
			[1] = {
				type = "blackhole",
				position = {x = 100, y = 500},
			},
			[2] = {
				type = "blackhole",
				position = {x = 300, y = 300},
			},
			[3] = {
				type = "blackhole",
				position = {x = 500, y = 100},
			},
			[4] = {
				type = "blackhole",
				position = {x = 700, y = -100},
			},
			[5] = {
				type = "blackhole",
				position = {x = 500, y = -300},
			},
			[6] = {
				type = "blackhole",
				position = {x = 300, y = -500},
			},
			[7] = {
				type = "blackhole",
				position = {x = 100, y = -600},
			},
			[8] = {
				type = "blackhole",
				position = {x = -100, y = -800},
			},
			[9] = {
				type = "blackhole",
				position = {x = -300, y = -600},
			},
			[10] = {
				type = "blackhole",
				position = {x = -500, y = -400},
			},
			[11] = {
				type = "blackhole",
				position = {x = -700, y = -200},
			},
			[12] = {
				type = "blackhole",
				position = {x = -500, y = 0},
			},
			[13] = {
				type = "blackhole",
				position = {x = -100, y = 400},
			},
		},
		earth = {
			position = { x = 0, y = -200},
			name = "earth",
			assetPath = "images/planets/earth/",
			scaleFactor = 1.5,
		},
		planets = {
			[1] = {
				foodType = "fruit",
				position = {x = -1400, y = -1400},
			},
			[2] = {
				foodType = "protein",
				position = {x = 1400, y = 1200},
			},
			[3] = {
				foodType = "vegetable",
				position = {x = 1200, y = -1100},
			},
		},
		asteroids = {
		},
	},

	--World = 11, Level = 3

	[11] = {
		x = scale * .567,
		y = 100,
		background = "images/backgrounds/space.png",
		levelDescription = "Recolecta las porciones necesarias",	
		levelWidth = 3600,
		levelHeight = 3400,
		ship = {position = { x = -900, y = 0}},
		objetives = {
			fruit = {portions = 2},
			vegetable = {portions = 1},
			dryfruit = {portions = 1},
		},
		enemySpawnData = {
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = -300, y = -1500},
				patrolPath = {
					[1] = {x = -300, y = -1500},
					[2] = {x = -1000, y = -500}
				},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = -1100, y = 300},
				patrolPath = {
					[1] = {x = -1100, y = 300},
					[2] = {x = -400, y = 900},
				},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 200, y = -400},
				patrolPath = {
					[1] = {x = 200, y = -400},
					[2] = {x = -500, y = 100},
				},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 1400, y = 300},
				patrolPath = {
					[1] = {x = 1400, y = 300},
					[2] = {x = 600, y = -200},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 1400, y = 700},
				patrolPath = {
					[1] = {x = 1400, y = 700},
					[2] = {x = 200, y = 1200},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 700, y = 300},
				patrolPath = {
					[1] = {x = 700, y = 300},
					[2] = {x = 0, y = 700},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 400, y = 800},
				patrolPath = {
					[1] = {x = 400, y = 800},
					[2] = {x = 1200, y = 200}
				},
			},
		},
		obstacle = {
			[1] = {
				type = "blackhole",
				position = {x = 1400, y = -200},
			},
			[2] = {
				type = "blackhole",
				position = {x = 1600, y = -400},
			},
			[3] = {
				type = "blackhole",
				position = {x = 1800, y = -600},
			},
			[4] = {
				type = "blackhole",
				position = {x = 900, y = -400},
			},
			[5] = {
				type = "blackhole",
				position = {x = 900, y = -600},
			},
			[6] = {
				type = "blackhole",
				position = {x = 900, y = -800},
			},
			[7] = {
				type = "blackhole",
				position = {x = 900, y = -1000},
			},
			[8] = {
				type = "blackhole",
				position = {x = 900, y = -1200},
			},
			[9] = {
				type = "blackhole",
				position = {x = 900, y = -1400},
			},
			[10] = {
				type = "blackhole",
				position = {x = 900, y = -1600},
			},
			[11] = {
				type = "blackhole",
				position = {x = -1300, y = -400},
			},
			[12] = {
				type = "blackhole",
				position = {x = -1500, y = -600},
			},
			[13] = {
				type = "blackhole",
				position = {x = -1700, y = -800},
			},
			[14] = {
				type = "blackhole",
				position = {x = -1100, y = 700},
			},
			[15] = {
				type = "blackhole",
				position = {x = -1300, y = 800},
			},
			[16] = {
				type = "blackhole",
				position = {x = -1500, y = 900},
			},
			[17] = {
				type = "blackhole",
				position = {x = -1700, y = 1000},
			},
			[18] = {
				type = "blackhole",
				position = {x = -700, y = 1000},
			},
			[19] = {
				type = "blackhole",
				position = {x = -600, y = 1200},
			},
			[20] = {
				type = "blackhole",
				position = {x = -500, y = 1400},
			},
			[21] = {
				type = "blackhole",
				position = {x = -400, y = 1600},
			},
		},
		earth = {
			position = { x = 1300, y = -1300},
			name = "earth",
			assetPath = "images/planets/earth/",
			scaleFactor = 1.5,
		},
		planets = {
			[1] = {
				foodType = "fruit",
				position = {x = -1200, y = -800},
			},
			[2] = {
				foodType = "vegetable",
				position = {x = -1100, y = 1200},
			},
			[3] = {
				foodType = "dryfruit",
				position = {x = 1100, y = 1200},
			},
		},
		asteroids = {
		},
	},

	--World = 12, Level = 3

	[12] = {
		x = scale * .617,
		y = 100,
		background = "images/backgrounds/space.png",
		levelDescription = "Recolecta las porciones necesarias",
		levelWidth = 4000,
		levelHeight = 3200,
		ship = {position = { x = -1700, y = -1200}},
		objetives = {
			fruit = {portions = 2},
			vegetable = {portions = 1},
			grain = {portions = 2},
		},
		enemySpawnData = {
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = -900, y = -1500},
				patrolPath = {
					[1] = {x = -900, y = -1500},
					[2] = {x = -1700, y = -600},
				},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 1000, y = -1200},
				patrolPath = {
					[1] = {x = 1000, y = -1200},
					[2] = {x = 1800, y = -600},
				},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 1600, y = 700},
				patrolPath = {
					[1] = {x = 1600, y = 700},
					[2] = {x = 600, y = 1500},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -300, y = -1000},
				patrolPath = {
					[1] = {x = -300, y = -1000},
					[2] = {x = -900, y = -200},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -900, y = 200},
				patrolPath = {
					[1] = {x = -900, y = 200},
					[2] = {x = -300, y = 1000}
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 300, y = 1000},
				patrolPath = {
					[1] = {x = 300, y = 1000},
					[2] = {x = 1200, y = 200},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 1000, y = -300},
				patrolPath = {
					[1] = {x = 1000, y = -300},
					[2] = {x = 200, y = -1000},
				},
			},
			{
				type = "shooter",
				angle = 315,
				spawnPoint = {x = 500, y = -1600},
				patrolPath = {[1] = {x = 500, y = -1600}},
			},
			{
				type = "shooter",
				angle = 225,
				spawnPoint = {x = -400, y = -1600},
				patrolPath = {[1] = {x = -400, y = -1600}},
			},
			{
				type = "shooter",
				angle = 225,
				spawnPoint = {x = 1700, y = 0},
				patrolPath = {[1] = {x = 1700, y = 0}},
			},
		},
		obstacle = {
			[1] = {
				type = "blackhole",
				position = {x = 0, y = -300},
			},
			[2] = {
				type = "blackhole",
				position = {x = -300, y = 0},
			},
			[3] = {
				type = "blackhole",
				position = {x = 0, y = 300},
			},
			[4] = {
				type = "blackhole",
				position = {x = 300, y = 0},
			},
			[5] = {
				type = "blackhole",
				position = {x = 1000, y = 0},
			},
			[6] = {
				type = "blackhole",
				position = {x = 0, y = -1000},
			},
			[7] = {
				type = "blackhole",
				position = {x = -1000, y = 0},
			},
			[8] = {
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
				foodType = "fruit",
				position = {x = -1400, y = -1200},
			},
			[2] = {
				foodType = "vegetable",
				position = {x = 1500, y = -1200},
			},
			[3] = {
				foodType = "grain",
				position = {x = 1500, y = 1200},
			},
		},
		asteroids = {
		},
	},

	--World = 13, Level = 3

	[13] = {
		x = scale * .667,
		y = 100,
		background = "images/backgrounds/space.png",
		levelDescription = "Recolecta las porciones necesarias",
		levelWidth = 4000,
		levelHeight = 4000,
		ship = {position = { x = -1900, y = -500}},
		objetives = {
			protein = {portions = 2},
			vegetable = {portions = 3},
			fat = {portions = 1},
		},
		enemySpawnData = {
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = -1400, y = -300},
				patrolPath = {
					[1] = {x = -1400, y = -300},
					[2] = {x = -1300, y = 300},
				},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 1400, y = 400},
				patrolPath = {
					[1] = {x = 1400, y = 400},
					[2] = {x = -1200, y = -300}
				},
					
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = -800, y = -400},
				patrolPath = {[1] = {x = -800, y = -400}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = 900, y = 500},
				patrolPath = {[1] = {x = 900, y = 500}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = 0, y = -600},
				patrolPath = {[1] = {x = 0, y = -600}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = 0, y = 700},
				patrolPath = {[1] = {x = 0, y = 700}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = -400, y = 500},
				patrolPath = {[1] = {x = -400, y = 500}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = 400, y = -300},
				patrolPath = {[1] = {x = 400, y = -300}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = -1600, y = -600},
				patrolPath = {[1] = {x = -1600, y = -600}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = -1600, y = 600},
				patrolPath = {[1] = {x = -1600, y = 600}},
			},
			{
				type = "shooter",
				angle = 270,
				spawnPoint = {x = 900, y = 900},
				patrolPath = {[1] = {x = 900, y = 900}},
			},
			{
				type = "shooter",
				angle = 90,
				spawnPoint = {x = 900, y = -800},
				patrolPath = {[1] = {x = 900, y = -800}},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -1400, y = 1500},
				patrolPath = {
					[1] = {x = -1400, y = 1500},
					[2] = {x = -200, y = 900},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 0, y = 1500},
				patrolPath = {
					[1] = {x = 0, y = 1500},	
					[2] = {x = 700, y = 900},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -1000, y = -1300},
				patrolPath = {
					[1] = {x = -1000, y = -1300},
					[2] = {x = -200, y = -800},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 200, y = -1300},
				patrolPath = {
					[1] = {x = 200, y = -1300},
					[2] = {x = 700, y = -800},
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
				foodType = "protein",
				position = {x = 1500, y = 1500},
			},
			[2] = {
				foodType = "vegetable",
				position = {x = -1400, y = -1100},
			},
			[3] = {
				foodType = "fat",
				position = {x = 1500, y = -1100},
			},
		},
		asteroids = {
			[1] = {
				lineStart = { x = -1600, y = -400},
				lineEnd = { x = -800, y = -600},
				easingX = easing.linear,
				easingY = easing.linear,
			},
			[2] = {
				lineStart = { x = -800, y = -600},
				lineEnd = { x = 0, y = -400},
				easingX = easing.linear,
				easingY = easing.linear,
			},
			[3] = {
				lineStart = { x = 0, y = -400},
				lineEnd = { x = 900, y = -600},
				easingX = easing.linear,
				easingY = easing.linear,
			},
			[4] = {
				lineStart = { x = 900, y = -600},
				lineEnd = { x = 1600, y = -400},
				easingX = easing.linear,
				easingY = easing.linear,
			},
			[5] = {
				lineStart = { x = -1600, y = 400},
				lineEnd = { x = -800, y = 700},
				easingX = easing.linear,
				easingY = easing.linear,
			},
			[6] = {
				lineStart = { x = -800, y = 700},
				lineEnd = { x = 0, y = 500},
				easingX = easing.linear,
				easingY = easing.linear,
			},
			[7] = {
				lineStart = { x = 0, y = 500},
				lineEnd = { x = 900, y = 700},
				easingX = easing.linear,
				easingY = easing.linear,
			},
			[8] = {
				lineStart = { x = 900, y = 700},
				lineEnd = { x = 1600, y = 500},
				easingX = easing.linear,
				easingY = easing.linear,
			},
		},
	},

	--World = 14, Level = 3

	[14] = {
		x = scale * .717,
		y = 100,
		background = "images/backgrounds/space.png",
		levelDescription = "Recolecta las porciones necesarias",
		levelWidth = 4000,
		levelHeight = 4000,
		ship = {position = { x = -1800, y = -1700}},
		objetives = {
			cereal = {portions = 1},
			fruit = {portions = 3},
			vegetable = {portions = 2},
		},
		enemySpawnData = {
			{
				type = "shooter",
				angle = 320,
				spawnPoint = {x = 400, y = -900},
				patrolPath = {[1] = {x = 400, y = -900}},
			},
			{
				type = "shooter",
				angle = 135,
				spawnPoint = {x = -200, y = 800},
				patrolPath = {[1] = {x = -200, y = 800}},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 1200, y = 100},
				patrolPath = {
					[1] = {x = 1200, y = 100},
					[2] = {x = 300, y = 800},
				},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 1600, y = 800},
				patrolPath = {
					[1] = {x = 1600, y = 800},
					[2] = {x = 500, y = 1800},
				},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = -1400, y = 700},
				patrolPath = {
					[1] = {x = -1400, y = 700},
					[2] = {x = -500, y = 1500}
				},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 1600, y = -700},
				patrolPath = {
					[1] = {x = 1600, y = -700},
					[2] = {x = 1000, y = -1200},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -900, y = -100},
				patrolPath = {
					[1] = {x = -900, y = -100},
					[2] = {x = -300, y = -400},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -300, y = -1100},
				patrolPath = {
					[1] = {x = -300, y = -1100},
					[2] = {x = -1000, y = -1300},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -1700, y = -700},
				patrolPath = {
					[1] = {x = -1700, y = -700},
					[2] = {x = -900, y = -900},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -500, y = 1100},
				patrolPath = {
					[1] = {x = -500, y = 1100},
					[2] = {x = -1200, y = 300},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 1700, y = 0},
				patrolPath = {
					[1] = {x = 1700, y = 0},
					[2] = {x = 1100, y = -600},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 800, y = -1300},
				patrolPath = {
					[1] = {x = 800, y = -1300},
					[2] = {x = 200, y = -1600},
				},
			},
		},
		obstacle = {
			[1] = {
				type = "blackhole",
				position = {x = -600, y = 100},
			},
			[2] = {
				type = "blackhole",
				position = {x = -400, y = -100},
			},
			[3] = {
				type = "blackhole",
				position = {x = -200, y = -300},
			},
			[4] = {
				type = "blackhole",
				position = {x = 0, y = -500},
			},
			[5] = {
				type = "blackhole",
				position = {x = 200, y = -700},
			},
			[6] = {
				type = "blackhole",
				position = {x = 0, y = 600},
			},
			[7] = {
				type = "blackhole",
				position = {x = 200, y = 400},
			},
			[8] = {
				type = "blackhole",
				position = {x = 400, y = 200},
			},
			[9] = {
				type = "blackhole",
				position = {x = 600, y = 0},
			},
			[10] = {
				type = "blackhole",
				position = {x = 800, y = -200},
			},
		},
		earth = {
			position = { x = 100, y = -100},
			name = "earth",
			assetPath = "images/planets/earth/",
			scaleFactor = 1.5,
		},
		planets = {
			[1] = {
				foodType = "cereal",
				position = {x = -1400, y = -1300},
			},
			[2] = {
				foodType = "vegetable",
				position = {x = 1500, y = -1300},
			},
			[3] = {
				foodType = "fruit",
				position = {x = -1400, y = 1300},
			},
		},
		asteroids = {
		},
	},

	--World = 15, Level = 3

	[15] = {
		x = scale * .767,
		y = 100,
		background = "images/backgrounds/space.png",
		levelDescription = "Recolecta las porciones necesarias",
		levelWidth = 3600,
		levelHeight = 3400,
		ship = {position = { x = -1800, y = -1400}},
		objetives = {
			fruit = {portions = 3},
			vegetable = {portions = 2},
			cereal = {portions = 1},
		},
		enemySpawnData = {
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = -1500, y = -700},
				patrolPath = {
					[1] = {x = -1500, y = -700},
					[2] = {x = -800, y = -1500},
				},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 1000, y = -1400},
				patrolPath = {
					[1] = {x = 1000, y = -1400},
					[2] = {x = 1300, y = -700},
				},
			},
			{
				type = "follower",
				angle = 0,
				spawnPoint = {x = 1700, y = 800},
				patrolPath = {
					[1] = {x = 1700, y = 800},
					[2] = {x = 900, y = 1300}
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -500, y = -1100},
				patrolPath = {
					[1] = {x = -500, y = -1100},
					[2] = {x = -1300, y = -300},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 400, y = -1100},
				patrolPath = {
					[1] = {x = 400, y = -1100},
					[2] = {x = 1300, y = -300},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = 1100, y = 300},
				patrolPath = {
					[1] = {x = 1100, y = 300},
					[2] = {x = 400, y = 1300},
				},
			},
			{
				type = "canoner",
				angle = 0,
				spawnPoint = {x = -1200, y = 300},
				patrolPath = {
					[1] = {x = -1200, y = 300},
					[2] = {x = -400, y = 1300},
				},
			},
			{
				type = "shooter",
				angle = 225,
				spawnPoint = {x = -500, y = -1500},
				patrolPath = {
					[1] = {x = -500, y = -1500},
				},
			},
			{
				type = "shooter",
				angle = 315,
				spawnPoint = {x = 500, y = -1500},
				patrolPath = {[1] = {x = 500, y = -1500}},
			},
			{
				type = "shooter",
				angle = 45,
				spawnPoint = {x = 500, y = 1600},
				patrolPath = {[1] = {x = 500, y = 1600}},
			},
			{
				type = "shooter",
				angle = 135,
				spawnPoint = {x = -600, y = 1600},
				patrolPath = {[1] = {x = -600, y = 1600}},
			},
		},
		obstacle = {
			[1] = {
				type = "blackhole",
				position = {x = 0, y = -500},
			},
			[2] = {
				type = "blackhole",
				position = {x = 0, y = -700},
			},
			[3] = {
				type = "blackhole",
				position = {x = 0, y = -900},
			},
			[4] = {
				type = "blackhole",
				position = {x = 0, y = -1100},
			},
			[5] = {
				type = "blackhole",
				position = {x = 0, y = -1300},
			},
			[6] = {
				type = "blackhole",
				position = {x = 0, y = 500},
			},
			[7] = {
				type = "blackhole",
				position = {x = 0, y = 700},
			},
			[8] = {
				type = "blackhole",
				position = {x = 0, y = 900},
			},
			[9] = {
				type = "blackhole",
				position = {x = 0, y = 1100},
			},
			[10] = {
				type = "blackhole",
				position = {x = 0, y = 1300},
			},
			[11] = {
				type = "blackhole",
				position = {x = 500, y = 0},
			},
			[12] = {
				type = "blackhole",
				position = {x = 700, y = 0},
			},
			[13] = {
				type = "blackhole",
				position = {x = 900, y = 0},
			},
			[14] = {
				type = "blackhole",
				position = {x = 1100, y = 0},
			},
			[15] = {
				type = "blackhole",
				position = {x = 1300, y = 0},
			},
			[16] = {
				type = "blackhole",
				position = {x = -500, y = 0},
			},
			[17] = {
				type = "blackhole",
				position = {x = -700, y = 0},
			},
			[18] = {
				type = "blackhole",
				position = {x = -900, y = 0},
			},
			[19] = {
				type = "blackhole",
				position = {x = -1100, y = 0},
			},
			[20] = {
				type = "blackhole",
				position = {x = -1300, y = 0},
			},
			[21] = {
				type = "blackhole",
				position = {x = 600, y = -500},
			},
			[22] = {
				type = "blackhole",
				position = {x = -600, y = -500},
			},
			[23] = {
				type = "blackhole",
				position = {x = 600, y = 600},
			},
			[24] = {
				type = "blackhole",
				position = {x = -600, y = 600},
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
				position = {x = -1500, y = -1200},
			},
			[2] = {
				foodType = "vegetable",
				position = {x = 1500, y = -1200},
			},
			[3] = {
				foodType = "cereal",
				position = {x = 1500, y = 1300},
			},
		},
		asteroids = {
		},
	},
}

return worldData
