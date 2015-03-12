local worldsData = {
	-- World 1
	[1] = {
		path = {easingX = easing.linear, easingY = easing.inOutCubic},
		icon = "images/worlds/Mundos-03.png",
		[1] = {
			x = 500,
			y = 0,
			background = "images/backgrounds/space.png",
			levelWidth = 2000,
			levelHeight = 2000,
			ship = {position = {x = 500, y = -200}},
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
				{
					type = "shooter",
					angle = 10,
					spawnPoint = { x = -500, y = -800},
					patrolPath = {
						[1] = { x = -500, y = -800},
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
					asset = "images/planets/fruits_2.png",
					scale = 0.5,
					foodOffset = {x = 0, y = -100},
					position = {x = -700, y = 700}
				},
				[2] = {
					foodType = "protein",
					asset = "images/planets/proteins_2.png",
					scale = 0.5,
					foodOffset = {x = 0, y = 100},
					position = {x = 500, y = 550}
				},
				[3] = {
					foodType = "vegetable",
					asset = "images/planets/vegetables_2.png",
					scale = 0.5,
					foodOffset = {x = -100, y = 15},
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
		--Level 2
		[2] = {
			x = 1000,
			y = 100,
			background = "images/backgrounds/space.png",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = {x = -1500, y = 800}},
			objectives = {
				fruit = 6,
				vegetable = 6,
				protein = 6
			},
			enemySpawnData = {
				{
					type = "follower",
					spawnPoint = { x = 0, y = 0},
					patrolPath = {
						[1] = { x = 0, y = 0},
						[2] = {x = 500, y = 500}
					}
				},
				{
					type = "canoner",
					spawnPoint = { x = 0, y = 0},
					patrolPath = {
						[1] = { x = 0, y = 0},
						[2] = {x = 800, y = -500}
					}
				},
			},
			asteroids = {
				[1] = {
						lineStart = {x = -2000, y = -400},
						lineEnd = {x = -1100, y = -400}
				},
				[2] = {
						lineStart = {x = -1100, y = -400},
						lineEnd = {x = -600, y = -700}
				},
				[3] = {
						lineStart = {x = -600, y = -700},
						lineEnd = {x = 0, y = -700}
				},
				[4] = {
						lineStart = {x = 500, y = -700},
						lineEnd = {x = 1000, y = -700}
				},
				[5] = {
						lineStart = {x = 1000, y = -200},
						lineEnd = {x = 1000, y = -700}
				},
				[6] = {
						lineStart = {x = 1000, y = -200},
						lineEnd = {x = 1600, y = -200}
				},
				[7] = {
						lineStart = {x = 1600, y = 800},
						lineEnd = {x = 1600, y = -200}
				},
				[8] = {
						lineStart = {x = 1100, y = 800},
						lineEnd = {x = 1600, y = 800}
				},
				[9] = {
						lineStart = {x = 1100, y = 1000},
						lineEnd = {x = 1100, y = 800}
				},
				[10] = {
						lineStart = {x = -300, y = 300},
						lineEnd = {x = -300, y = -300}
				},
				[11] = {
						lineStart = {x = -300, y = -300},
						lineEnd = {x = 700, y = -300}
				},
				[12] = {
						lineStart = {x = 700, y = 200},
						lineEnd = {x = 700, y = -300}
				},
				[13] = {
						lineStart = {x = 0, y = 1000},
						lineEnd = {x = 0, y = 0}
				},
				[14] = {
						lineStart = {x = 0, y = 0},
						lineEnd = {x = 400, y = 0}
				},
				[15] = {
						lineStart = {x = 400, y = 500},
						lineEnd = {x = 400, y = 0}
				},
				[16] = {
						lineStart = {x = 400, y = 500},
						lineEnd = {x = 1100, y = 500}
				},
				[17] = {
						lineStart = {x = -400, y = 1000},
						lineEnd = {x = -400, y = 600}
				},
				[18] = {
						lineStart = {x = -1100, y = 600},
						lineEnd = {x = -400, y = 600}
				},
				[19] = {
						lineStart = {x = -1100, y = 600},
						lineEnd = {x = -1100, y = 300}
				},
				[20] = {--
						lineStart = {x = -1800, y = 800},
						lineEnd = {x = -1400, y = 800}
				},
				[21] = {
						lineStart = {x = -1400, y = 800},
						lineEnd = {x = -1400, y = 300}
				},
				[22] = {
						lineStart = {x = -2000, y = 300},
						lineEnd = {x = -1400, y = 300}
				},
			},
			earth = {
				name = "earth",
				assetPath = "images/planets/earth/",
				position = {x = -1400, y = 0},
				scaleFactor = 1.5
			},
			planets = {
				[1] = {
					foodType = "fruit",
					asset = "images/planets/fruits_1.png",
					position = {x = -1400, y = -700}
				},
				[2] = {
					foodType = "protein",
					asset = "images/planets/proteins_1.png",
					position = {x = 1800, y = 900}
				},
				[3] = {
					foodType = "vegetable",
					asset = "images/planets/vegetables_1.png",
					position = {x = -600, y = 800}
				}
			}
		},
		-- Level 3
		[3] = {
			x = 1500,
			y = -100,
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