local assetPath = "images/food/"
local foodData = {
	types = {
		"vegetable", "fruit", "protein"
	},
	[1] = {
		type = "vegetable",
		name = "carrot",
		asset = assetPath .. "carrot.png"
	},
	[2] = {
		type = "fruit",
		name = "cereal",
		asset = assetPath .. "cereal.png"
	},
	[3] = {
		type = "protein",
		name = "cheese",
		asset = assetPath .. "chesse.png"
	},
	[4] = {
		type = "vegetable",
		name = "corn",
		asset = assetPath .. "corn.png"
	},
	[5] = {
		type = "protein",
		name = "meat",
		asset = assetPath .. "meat.png"
	},
	[6] = {
		type = "fruit",
		name = "strawberry",
		asset = assetPath .. "strawberry.png"
	},
}

return foodData
