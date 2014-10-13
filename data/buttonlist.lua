----------------------------------------------- Button data list
local sound = require( "libs.helpers.sound" )
----------------------------------------------- Functions
local function playSound()
	sound.play("pop")
end
----------------------------------------------- Data
local buttonlist = {
	back = { width = 128, height = 128, defaultFile = "images/buttons/back_01.png", overFile = "images/buttons/back_02.png", onPress = playSound},
}

return buttonlist
