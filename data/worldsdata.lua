-----------------Constants
local numberOfBacks = 4
local scale = (display.viewableContentHeight / 768) * 1024 * numberOfBacks
--------------------------------------

local worldsData = {
	[1] = require("data.levels.world1"),
	[2] = require("data.levels.world2"),
	[3] = require("data.levels.world3")
	
}

return worldsData