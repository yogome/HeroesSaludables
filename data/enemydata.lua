local enemies = {
	["canoner"] = {
		asset = "images/enemies/canon.png",
		speed = 1,
		viewRadius = 200,
		onHasTarget = "shoot",
		projectileData = {
		
		},
	},
	["shooter"] = {
		asset = "images/enemies/shooter.png",
		speed = 1,
		viewRadius = 200,
		onHasTarget = "shoot",
		projectileData = {
		
		},
	},
	["follower"] = {
		asset = "images/enemies/follower.png",
		speed = 1,
		viewRadius = 300,
		onHasTarget = "follow",
		projectileData = {
		
		},
	}
}

return enemies
