----------------------------------------------- Button data list
local sound = require( "libs.helpers.sound" )
----------------------------------------------- Functions
local function playSound()
	sound.play("pop")
end
----------------------------------------------- Data
local buttonlist = {
	back = { width = 128, height = 128, defaultFile = "images/buttons/back_01.png", overFile = "images/buttons/back_02.png", onPress = playSound},
	retry = { width = 128, height = 128, defaultFile = "images/buttons/retry_1.png", overFile = "images/buttons/retry_2.png", onPress = playSound},
	play = { width = 128, height = 128, defaultFile = "images/buttons/play_01.png", overFile = "images/buttons/play_02.png", onPress = playSound},
	music = { width = 140, height = 140, defaultFile = "images/buttons/music_1.png", overFile = "images/buttons/music_2.png", onPress = playSound},
	sound = { width = 140, height = 140, defaultFile = "images/buttons/sound_1.png", overFile = "images/buttons/sound_2.png", onPress = playSound},
	ok = { width = 150, height = 150, defaultFile = "images/buttons/ok_1.png", overFile = "images/buttons/ok_2.png", onPress = playSound},
	settings = { width = 128, height = 128, defaultFile = "images/buttons/settings_1.png", overFile = "images/buttons/settings_2.png", onPress = playSound},
	next = { width = 128, height = 112, defaultFile = "images/buttons/adelante.png", overFile = "images/buttons/adelante_02.png", onPress = playSound},
	previous = { width = 128, height = 112, defaultFile = "images/buttons/atras.png", overFile = "images/buttons/atras_02.png", onPress = playSound},
	left = { width = 90, height = 128, defaultFile = "images/buttons/izquierda_1.png", overFile = "images/buttons/izquierda_2.png", onPress = playSound},
	right = { width = 90, height = 128, defaultFile = "images/buttons/derecha_1.png", overFile = "images/buttons/derecha_2.png", onPress = playSound},
	
}

return buttonlist
