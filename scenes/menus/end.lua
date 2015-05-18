local director = require( "libs.helpers.director" )
local sound = require( "libs.helpers.sound" )
local settings = require( "settings" )
local widget = require("widget")
local buttonlist = require("data.buttonlist")
local settings = require("settings")
local music = require("libs.helpers.music")

local game = director.newScene() 
local bubble
local worldIndex, levelIndex
local displayElements
local canTap
local buttonOK
----------------------------------------------- Variables

------------------------------------------------- Constants

------------------------------------------------- Functions
--

local TRANSITION_TIME = 1000
local imageElements = {
	[1] = {
		image = "images/end/final_asteroides.png",
		position = {x = display.contentCenterX, y = display.contentCenterY},
		xScale = display.contentWidth / 1024,
		yScale = display.contentWidth / 1024,
	},
	[2] = {
		image = "images/end/final_planetaVerde.png",
		position = {x = display.contentWidth * 0.23, y = display.contentHeight * 0.20},
		transition = {
			from = {x = display.screenOriginX - 200},
			type = easing.outElastic,
			delay = 500,
		}
	},
	[3] = {
		image = "images/end/final_planetaRosa.png",
		position = {x = display.contentWidth * 0.12, y = display.contentHeight * 0.37},
		transition = {
			from = {x = display.screenOriginX - 200},
			type = easing.outElastic,
			delay = 600,
		}
	},
	[4] = {
		image = "images/end/final_planetaAzul.png",
		position = {x = display.contentWidth * 0.28, y = display.contentHeight * 0.59},
		transition = {
			from = {x = display.screenOriginX - 200},
			type = easing.outElastic,
			delay = 700,
		}
	},
	[5] = {
		image = "images/end/final_planetaRojo.png",
		position = {x = display.screenOriginX + 110, y = display.contentHeight - 110},
		transition = {
			from = {x = display.screenOriginX - 200},
			type = easing.outElastic,
			delay = 800,
		}
	},
	[6] = {
		image = "images/end/final_planetaNaranja.png",
		position = {x = display.contentWidth - 125, y = display.contentHeight - 125},
		transition = {
			from = {x = display.contentWidth + 300},
			type = easing.outElastic,
			delay = 900,
		}
	},
	[7] = {
		image = "images/end/final_Yogotar.png",
		alpha = 0,
		position = {x = display.contentWidth * 0.65, y = display.contentCenterY * 1.10},
		transition = {
			alpha = 0,
			from = {x = display.contentCenterX, y = display.contentCenterY * 1.20},
			--type = easing.inElastic,
			delay = 1000,
		}
	},
	[8] = {
		image = "images/end/final_letrero.png",
		position = {
			x = display.contentCenterX, 
			y = display.screenOriginY + 25,
		},
		transition = {
			from = {y = display.screenOriginY - 100},
			type = easing.outElastic,
			delay = 2000,
		}
	},
}

local function goNextScene()
	director.gotoScene("scenes.menus.home", {effect = "fade", time = 500})
end

local function animateElements()
	
	local delaySum = 0
	for indexElement = 1, #imageElements do
		
		local currentElement = imageElements[indexElement]
		displayElements[indexElement].isVisible = true
		if currentElement.transition then
			local currentTransition = currentElement.transition
			currentTransition.from = currentTransition.from or {}
			currentTransition.from.x = currentTransition.from.x or currentElement.x
			currentTransition.from.y = currentTransition.from.y or currentElement.y
			currentTransition.type = currentTransition.type or easing.linear
			currentTransition.delay = currentTransition.delay or 0
			currentTransition.alpha = currentTransition.alpha or 1
			transition.from(displayElements[indexElement], {time = TRANSITION_TIME, delay = currentTransition.delay, x = currentTransition.from.x, y = currentTransition.from.y, transition = currentTransition.type, alpha = currentTransition.alpha})
			delaySum = delaySum + currentTransition.delay
		end		
	end
	
	timer.performWithDelay(delaySum, function()
		transition.to(buttonOK, {alpha = 1})
	end)
	
end

function game:create(event)
	local sceneGroup = self.view
	
	local scale = display.contentWidth / 1024
	local background = display.newImage("images/end/final_espacio.png")
	background:scale(scale, scale)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)

	displayElements = {}
	
	for indexElement = 1, #imageElements do
		
		local currentElement = imageElements[indexElement]
		local image = display.newImage(currentElement.image)
		image.isVisible = false
		image.x = currentElement.position.x
		image.y = currentElement.position.y
		currentElement.xScale = currentElement.xScale or 1
		currentElement.yScale = currentElement.yScale or 1
		
		image:scale(currentElement.xScale, currentElement.yScale)
		
		sceneGroup:insert(image)
		displayElements[#displayElements + 1] = image
	end
	
	local buttonInfo = buttonlist.ok
	buttonInfo.onRelease = goNextScene
	buttonOK = widget.newButton(buttonInfo)
	buttonOK.x = display.contentWidth - buttonOK.contentWidth * 0.7
	buttonOK.y = display.contentHeight - buttonOK.contentHeight * 0.6
	sceneGroup:insert(buttonOK)
	
end

function game:setLevel(world, level)
	worldIndex = world
	levelIndex = world
end

function game:destroy()
	
end

function game:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	local params = event.params
	
	if ( phase == "will" ) then
		canTap = false
		buttonOK.alpha = 0
	elseif ( phase == "did" ) then
		music.playTrack(1, 200)
		animateElements()
	end
end

function game:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if ( phase == "will" ) then
	    
	elseif ( phase == "did" ) then
		
	end
end
----------------------------------------------- Execution
game:addEventListener( "create", game )
game:addEventListener( "destroy", game )
game:addEventListener( "hide", game )
game:addEventListener( "show", game )

return game