----------------------------------------------- Select player
local scenePath = ... 
local director = require( "libs.helpers.director" )

local music = require( "libs.helpers.music" )
local sound = require( "libs.helpers.sound" )
local logger = require( "libs.helpers.logger" )
local colors = require( "libs.helpers.colors" )

local scene = director.newScene() 
----------------------------------------------- Variables
local buttonsEnabled
local yogome
local extraScript, nextSceneName
local pitch
----------------------------------------------- Constants 
local ANCHOR_YOG = {x = 1, y = 0.5}
local ANCHOR_MAGENTA = {x = 0.5, y = 0.5}
local ANCHOR_HELMET = {x = 0.5, y = 0.5}
local ANCHOR_ME = {x = 0.1, y = 0.5}

local POSITION_YOG = {x = -3, y = 0}
local POSITION_MAGENTA = {x = 0, y = 0}
local POSITION_HELMET = {x = 0, y = 0}
local POSITION_ME = {x = 5, y = 0}

local SCALE_YOG = {x = 0.05, y = 0.05}
local SCALE_MAGENTA = {x = 0.05, y = 0.05}
local SCALE_HELMET = {x = 0.05, y = 0.05}
local SCALE_ME = {x = 0.05, y = 0.05}

local SCALE_LOGO = 0.6
local SCALE_HIGHTLIGHT = 1.2

local TIME_RESTORE = 200

local TIME_ZOOM_ANIMATION = 600 

local DELAY_FADEIN = 500
local TIME_FADEIN = 200

local DELAY_HIGHLIGHT_YOG = 200
local DELAY_HIGHLIGHT_MAGENTA = 500
local DELAY_HIGHLIGHT_HELMET = 600
local DELAY_HIGHLIGHT_ME = 800

local DELAY_HELMET_YES = 900
local OFFSET_Y_HELMET_YES = POSITION_HELMET.y - 5
local ROTATION_HELMET_YES = -5
local TIME_HELMET_YES = 400

local DELAY_RESTORE = DELAY_HELMET_YES + TIME_HELMET_YES + 200

local DELAY_FADEOUT = DELAY_RESTORE + TIME_HELMET_YES + 400
local TIME_FADEOUT = 400

local LIMIT_PITCH = {maximum = 2, minimum = 0.75}
local STEP_PITCH = 0.0005
----------------------------------------------- Functions 
local function executeExtraScript()
	if extraScript and "function" == type(extraScript) then
		return extraScript({view = scene.view, logo = yogome}) or 0
	end
	return 0
end

local function easterEgg(event)
	if buttonsEnabled then
		if "moved" == event.phase then
			pitch = pitch + (event.yStart - event.y) * STEP_PITCH
			pitch = pitch > LIMIT_PITCH.minimum and pitch or LIMIT_PITCH.minimum
			pitch = pitch < LIMIT_PITCH.maximum and pitch or LIMIT_PITCH.maximum
			sound.setPitch(pitch)
		end
	end
end

local function startAnimation()
	transition.cancel(yogome)
	
	yogome.alpha = 0
	yogome.xScale = SCALE_LOGO
	yogome.yScale = SCALE_LOGO
	
	yogome.yog.xScale, yogome.yog.yScale = SCALE_YOG.x, SCALE_YOG.y
	yogome.magenta.xScale, yogome.magenta.yScale = SCALE_MAGENTA.x, SCALE_MAGENTA.y
	yogome.helmet.xScale, yogome.helmet.yScale = SCALE_HELMET.x, SCALE_HELMET.y
	yogome.me.xScale, yogome.me.yScale = SCALE_ME.x, SCALE_ME.y
	
	yogome.yog.x, yogome.yog.y = POSITION_YOG.x, POSITION_YOG.y
	yogome.magenta.x, yogome.magenta.y = POSITION_MAGENTA.x, POSITION_MAGENTA.y
	yogome.helmet.x, yogome.helmet.y = POSITION_HELMET.x, POSITION_HELMET.y
	yogome.me.x, yogome.me.y = POSITION_ME.x, POSITION_ME.y
	
	yogome.yog.anchorX, yogome.yog.anchorY = ANCHOR_YOG.x, ANCHOR_YOG.y
	yogome.magenta.anchorX, yogome.magenta.anchorY = ANCHOR_MAGENTA.x, ANCHOR_MAGENTA.y
	yogome.helmet.anchorX, yogome.helmet.anchorY = ANCHOR_HELMET.x, ANCHOR_HELMET.y
	yogome.me.anchorX, yogome.me.anchorY = ANCHOR_ME.x, ANCHOR_ME.y
	
	director.to(scenePath, yogome, {delay = DELAY_FADEIN, time = TIME_FADEIN, alpha = 1, transition = easing.outQuad, onComplete = function()
		director.to(scenePath, yogome.yog, {time = TIME_ZOOM_ANIMATION, xScale = 1, yScale = 1, transition = easing.outQuad})
		director.to(scenePath, yogome.magenta, {time = TIME_ZOOM_ANIMATION, xScale = 1, yScale = 1, transition = easing.outQuad})
		director.to(scenePath, yogome.helmet, {time = TIME_ZOOM_ANIMATION, xScale = 1, yScale = 1, transition = easing.outQuad})
		director.to(scenePath, yogome.me, {time = TIME_ZOOM_ANIMATION, xScale = 1, yScale = 1, transition = easing.outQuad})

		director.to(scenePath, yogome.yog, {delay = TIME_ZOOM_ANIMATION + DELAY_HIGHLIGHT_YOG, xScale = SCALE_HIGHTLIGHT, yScale = SCALE_HIGHTLIGHT, transition = easing.outBack, onComplete = function()
			director.to(scenePath, yogome.yog, {time = TIME_RESTORE, delay = DELAY_RESTORE - DELAY_HIGHLIGHT_YOG, xScale = 1, yScale = 1, transition = easing.outQuad})
		end})

		director.to(scenePath, yogome.magenta, {delay = TIME_ZOOM_ANIMATION + DELAY_HIGHLIGHT_MAGENTA, xScale = SCALE_HIGHTLIGHT, yScale = SCALE_HIGHTLIGHT, transition = easing.outBack, onComplete = function()
			director.to(scenePath, yogome.magenta, {time = TIME_RESTORE, delay = DELAY_RESTORE - DELAY_HIGHLIGHT_MAGENTA, xScale = 1, yScale = 1, transition = easing.outQuad})
		end})

		director.to(scenePath, yogome.helmet, {delay = TIME_ZOOM_ANIMATION + DELAY_HIGHLIGHT_HELMET, xScale = SCALE_HIGHTLIGHT, yScale = SCALE_HIGHTLIGHT, transition = easing.outBack, onComplete = function()
			director.to(scenePath, yogome.helmet, {time = TIME_RESTORE, delay = DELAY_RESTORE - DELAY_HIGHLIGHT_HELMET, xScale = 1, yScale = 1, transition = easing.outQuad})
		end})
		director.to(scenePath, yogome.helmet, {delay = TIME_ZOOM_ANIMATION + DELAY_HELMET_YES, time = TIME_HELMET_YES, rotation = ROTATION_HELMET_YES, y = OFFSET_Y_HELMET_YES, transition = easing.outQuad, onComplete = function()
			director.to(scenePath, yogome.helmet, {time = 150, delay = 150, rotation = 0, y = POSITION_HELMET.y, transition = easing.outBack})
		end})

		director.to(scenePath, yogome.me, {delay = TIME_ZOOM_ANIMATION + DELAY_HIGHLIGHT_ME, xScale = SCALE_HIGHTLIGHT, yScale = SCALE_HIGHTLIGHT, transition = easing.outBack, onComplete = function()
			director.to(scenePath, yogome.me, {time = TIME_RESTORE, delay = DELAY_RESTORE - DELAY_HIGHLIGHT_ME, xScale = 1, yScale = 1, transition = easing.outQuad})
		end})
		
		

		director.to(scenePath, yogome, {delay = DELAY_FADEOUT, time = 1, onStart = function()
			local extraDelay = executeExtraScript()
			director.to(scenePath, yogome, {delay = extraDelay, time = TIME_FADEOUT, alpha = 0, xScale = 0.2, yScale = 0.2, transition = easing.inQuad, onComplete = function()
				director.gotoScene(nextSceneName, {time = 600, effect = "fade"})
			end})
		end})
	end})
	
	sound.playPitch("introYogome", pitch)
end

local function initialize(event)
	event = event or {}
	local parameters = event.params or {}
	
	pitch = 1
	
	nextSceneName = nextSceneName or director.getSceneName("previous")
	
end
----------------------------------------------- Class functions 
function scene.setExtraScript(newExtraScript)
	extraScript = newExtraScript
end

function scene.setNextScene(newNextSceneName)
	nextSceneName = newNextSceneName
end

function scene.enableButtons()
	buttonsEnabled = true
end

function scene.disableButtons()
	buttonsEnabled = false
end

function scene:create(event)
	local sceneView = self.view
	
	local background = display.newRect(display.contentCenterX, display.contentCenterY, display.viewableContentWidth, display.viewableContentHeight)
	background:setFillColor(unpack(colors.white))
	background:addEventListener("touch", easterEgg)
	sceneView:insert(background)
	
	yogome = display.newGroup()
	yogome.x, yogome.y = display.contentCenterX, display.contentCenterY
	yogome.xScale, yogome.yScale = SCALE_LOGO, SCALE_LOGO
	sceneView:insert(yogome)
	
	local magenta = display.newImage("images/intro/magenta.png")
	yogome:insert(magenta)
	
	local yog = display.newImage("images/intro/yog.png")
	yogome:insert(yog)
	
	local me = display.newImage("images/intro/me.png")
	yogome:insert(me)
	
	local helmet = display.newImage("images/intro/casco.png")
	yogome:insert(helmet)
	
	yogome.yog = yog
	yogome.magenta = magenta
	yogome.helmet = helmet
	yogome.me = me
end

function scene:destroy()
	
end

function scene:show( event )
	local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
		initialize(event)
		startAnimation()
		self.disableButtons()
	elseif phase == "did" then
		self.enableButtons()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
		self.disableButtons()
	elseif phase == "did" then
		transition.cancel(yogome)
		sound.stopPitch()
	end
end

scene:addEventListener( "create" )
scene:addEventListener( "destroy" )
scene:addEventListener( "hide" )
scene:addEventListener( "show" )

return scene

