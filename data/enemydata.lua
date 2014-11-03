local enemies = {
	["canoner"] = {
		asset = "images/enemies/canon.png",
		speed = 1,
		viewRadius = 400,
		onHasTarget = "shoot",
		projectileData = {
			fireFrame = 25,
			speed = 7,
			asset = "images/enemies/proyectil-02.png",
		},
	},
	["shooter"] = {
		asset = "images/enemies/shooter.png",
		speed = 1,
		viewRadius = 300,
		onHasTarget = "shoot",
		projectileData = {
			fireFrame = 15,
			speed = 2.5,
			asset = "images/enemies/proyectil-02.png",
		},
	},
	["follower"] = {
		asset = "images/enemies/follower.png",
		speed = 1,
		viewRadius = 300,
		onHasTarget = "follow",
		projectileData = {
			fireFrame = 50,
			speed = 5,
			asset = "images/enemies/proyectil-02.png",
		},
	}
}

return enemies
