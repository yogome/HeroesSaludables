local worldsData = {
	-- World 1
	[1] = {
		--Level 1
		[1] = {
			background = "images/backgrounds/space.png",
			levelWidth = 4000,
			levelHeight = 2000,
			ship = {position = {x = -1500, y = 800}},
			objectives = {
				fruits = 8,
				vegetables = 10,
				proteins = 5
			},
			enemies = {
				{
					type = "follower",
					patrolData = {
						startPoint = { x = 0, y = 0},
						endPoint = {x = 500, y = 500}
					}
				},
				{
					type = "canoner",
					patrolData = {
						startPoint = { x = 0, y = 0},
						endPoint = {x = 800, y = -500}
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
				asset = "images/planets/earth_happy.png",
				position = {x = -1400, y = 0},
				scaleFactor = 0.75
			},
			planets = {
				[1] = {
					name = "fruits",
					asset = "images/planets/fruits_1.png",
					position = {x = -1400, y = -700}
				},
				[2] = {
					name = "proteins",
					asset = "images/planets/proteins_1.png",
					position = {x = 1800, y = 900}
				},
				[3] = {
					name = "vegetables",
					asset = "images/planets/vegetables_1.png",
					position = {x = -600, y = 800}
				}
			}
		},
		[2] = {
			background = "images/backgrounds/space.png",
			levelWidth = 2000,
			levelHeight = 2000,
			ship = {position = {x = 700, y = -200}},
			objectives = {
				fruits = 8,
				vegetables = 10,
				proteins = 5
			},
			enemies = {
				{
					type = "follower",
					patrolData = {
						startPoint = { x = -500, y = 0},
						endPoint = {x = 0, y = 500}
					}
				},
				{
					type = "canoner",
					patrolData = {
						startPoint = { x = 400, y = -800},
						endPoint = {x = 0, y = -400}
					}
				},
			},
			earth = {
				name = "earth",
				asset = "images/planets/earth_happy.png",
				position = {x = -800, y = -700},
				scaleFactor = 0.75
			},
			planets = {
				[1] = {
					name = "fruits",
					asset = "images/planets/fruits_1.png",
					position = {x = -700, y = 700}
				},
				[2] = {
					name = "proteins",
					asset = "images/planets/proteins_1.png",
					position = {x = 500, y = 400}
				},
--				[3] = {
--					name = "vegetables",
--					asset = "images/planets/vegetables_1.png",
--					position = {x = -600, y = 800}
--				}
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
		}
	},
	-- World 2
	[2] = {
		[1] = {}, -- Level data goes here
	}
}

return worldsData