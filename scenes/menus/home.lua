----------------------------------------------- Home
local director = require( "libs.helpers.director" )
local widget = require( "widget" )
local buttonList = require( "data.buttonlist" )
local database = require( "libs.helpers.database" )
local sound = require( "libs.helpers.sound" )
local parentgate = require( "libs.helpers.parentgate" )
local logger = require( "libs.helpers.logger" )
local music = require( "libs.helpers.music" )
local players = require( "models.players" )
local mixpanel = require( "libs.helpers.mixpanel" )

local scene = director.newScene() 
----------------------------------------------- Variables
local buttonPlay, settingsBtn, musicBtn, soundBtn, okBtn, musicOff, soundOff, backBtn
local logoGroup, starfieldGroup, asteroidGroup, shineStarGroup, settingsScreen
local currentPlayer
----------------------------------------------- Constants 
local SIZE_BACKGROUND = 1024
local NUMBER_STARS = 50
local NUMBER_ASTEROIDS = 3
local SPEED_STARS = 0.5
--local MARGIN_BUTTON = 20
--local SCALE_LOGO = 1
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenLeft = display.screenOriginX
local screenWidth = display.viewableContentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.viewableContentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight 
local mRandom = math.random
----------------------------------------------- Caches
local doublePi = math.pi * 2
local mathRandom = math.random
local mathSin = math.sin
local mathCos = math.cos
local mathAbs = math.abs

local contentWidth = display.contentWidth
local contentHeight = display.contentHeight

local halfContentWidth = contentWidth * 0.5
local halfContentHeight = contentHeight * 0.5
----------------------------------------------- Functions

local function updateAsteroids()
	
	for indexAsteroid = 1, NUMBER_ASTEROIDS do
		
		local currentAsteroid = asteroidGroup.asteroids[indexAsteroid]
		
		currentAsteroid.x = currentAsteroid.x + 1
		currentAsteroid.y = currentAsteroid.y + 1
		
		currentAsteroid.rotation = currentAsteroid.rotation + 0.5
		
		if currentAsteroid.x > contentWidth + 50 then
			currentAsteroid.x = display.screenOriginX - 50
		end
		
		if  currentAsteroid.y > contentHeight + 50 then	
			currentAsteroid.y = display.screenOriginY - 50
		end
		
	end
	
end

local function updateStarField()
	for indexStar = 1, #starfieldGroup.stars do
		
		local currentStar = starfieldGroup.stars[indexStar]
		
		local currentX = currentStar.x
		local currentY = currentStar.y
		
		local currentSpeed = currentStar.speed
						
		currentStar.x = currentX + (currentX - currentStar.dx) * currentSpeed
		currentStar.y = currentY + (currentY - currentStar.dy) * currentSpeed
		
		currentStar.xScale = currentStar.xScale + 0.009
		currentStar.yScale = currentStar.yScale + 0.009
		
		local condition1 = currentStar.x > halfContentWidth or currentStar.x < -halfContentWidth
		local condition2 = currentStar.y > halfContentHeight or currentStar.y < -halfContentHeight
		
		if condition1 or condition2 then
			currentStar.x = 0
			currentStar.y = 0
			currentStar.alpha = mathRandom(1,5) * 0.1
			
			currentStar.xScale = 1
			currentStar.yScale = 1
			
			local step = mathRandom(1,360)
			
			local vX = mathSin(step)
			local vY = mathCos(step)
			
			currentStar.x = vX * 30
			currentStar.y = vY * 30
		
			currentStar.dx = vX
			currentStar.dy = vY
		end
				
	end
end

local function updateShineStars(time)
	for indexStar = 1, #shineStarGroup.stars do
		local currentShine = shineStarGroup.stars[indexStar]
		local shineFactor = mathSin((time + (currentShine.shineOffset))  * 0.001)
		
		if shineFactor <= 0 and currentShine.changedPosition then
			shineFactor = 0
			currentShine.changedPosition = false
		else
			currentShine.changedPosition = true
			currentShine.x = math.random(display.screenOriginX, display.contentWidth)
			currentShine.y = math.random(display.screenOriginY, display.contentHeight)
			currentShine.alpha = shineFactor
		end
		
	end
	
end

local function updateGameLoop(event)
	updateAsteroids()
	updateStarField()
	--updateShineStars(event.time)
end

local function createBackground(group)
	
	local ratio = display.viewableContentWidth / SIZE_BACKGROUND
	local background = display.newImage("images/backgrounds/bg2.png")
	background:scale(ratio, ratio)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	group:insert(background)
	
end

local function createLogo(group)
	
	logoGroup = display.newGroup()
	logoGroup.x = display.contentCenterX
	logoGroup.y = display.contentCenterY * 0.75
	
	local logo = display.newImage("images/general/logo.png")
	logo:scale(0.80, 0.80)
	logoGroup:insert(logo)
	
	group:insert(logoGroup)
end

local function initializeStarShine()
	
	for indexStar = 1, #shineStarGroup.stars do
		local currentShine = shineStarGroup.stars[indexStar]
		currentShine.x = math.random(display.screenOriginX, display.contentWidth)
		currentShine.y = math.random(display.screenOriginY, display.contentHeight)
		currentShine.alpha = math.random(1,10) * 0.1
		currentShine.shineOffset = (currentShine.alpha + math.random(1, 10)) * 100000
		currentShine.changedPosition = false
	end
end

local function createStarfield(group)
	starfieldGroup = display.newGroup()
	starfieldGroup.stars = {}
	for indexStar = 1, NUMBER_STARS do
		local randomSize = math.random(1, 3)
		local star = display.newCircle(0,0,randomSize)
		starfieldGroup.stars[indexStar] = star
		starfieldGroup:insert(star)
	end
	starfieldGroup.x = display.contentCenterX
	starfieldGroup.y = display.contentCenterY
	group:insert(starfieldGroup)
end

local function initializeStarField()
	
	for indexStar = 1, #starfieldGroup.stars do
		
		local currentStar = starfieldGroup.stars[indexStar]
		
		local step = (math.pi * 2) / (math.random(1, 1000) / 1000)
		currentStar.speed = math.random(50, 100) * 0.001
		
		currentStar.dx = math.sin(currentStar.x + step) * display.contentWidth
		currentStar.dy = math.cos(currentStar.y + step) * display.contentHeight
		
		local vectorSizeX = (currentStar.x - currentStar.dx)
		local vectorSizeY = (currentStar.y - currentStar.dy)
		
		currentStar.x = currentStar.x + vectorSizeX * math.random(0, math.abs(vectorSizeX)) * currentStar.speed
		currentStar.y = currentStar.y + vectorSizeY * math.random(0, math.abs(vectorSizeY)) * currentStar.speed
	end
end

local function createAsteroids(group)

	asteroidGroup = display.newGroup()
	asteroidGroup.asteroids = {}
	for indexAsteroid = 1, NUMBER_ASTEROIDS do
		local asteroidType = math.random(1, 3)
		local asteroid = display.newImage("images/enviroment/asteroid".. asteroidType ..".png")
		asteroid.x = math.random(display.contentWidth * -0.5, display.contentWidth)
		asteroid.y = math.random(display.contentHeight * -0.5, display.contentHeight)
		
		asteroidGroup.asteroids[indexAsteroid] = asteroid
		asteroidGroup:insert(asteroid)
	end
	
	group:insert(asteroidGroup)
end


local function pressButton(event)
	local tag = event.target.tag
	local enabled
	if tag == "play" then
		director.gotoScene("scenes.menus.selecthero")
	elseif tag == "settings" then
		backBtn:setEnabled(false)
		settingsBtn:setEnabled(false)
		okBtn:setEnabled(true)
		transition.to(settingsScreen,{ alpha = 1, time = 300})
	elseif tag == "music" then
		if musicOff.alpha == 0 then
			musicOff.alpha = 1
		else
			musicOff.alpha = 0
		end
		enabled = not database.config("music")
		music.setEnabled(enabled)
		database.config( "music", enabled)
	elseif tag == "sound" then
		if soundOff.alpha == 0 then
			soundOff.alpha = 1
		else
			soundOff.alpha = 0
		end
		enabled = not database.config("sound")
		sound.setEnabled(enabled)
		database.config( "sound", enabled)
	elseif tag == "ok" then
		backBtn:setEnabled(true)
		settingsBtn:setEnabled(true)
		okBtn:setEnabled(false)
		transition.to(settingsScreen,{alpha = 0, time = 300})
	elseif tag == "back" then
		director.gotoScene("scenes.game.infoscreen", { effect = "fade", time = 300, params = nil})
	end
end

local function createButtons(group)
	
	local buttonData = buttonList.play
	buttonData.onRelease = pressButton
	
	buttonPlay = widget.newButton(buttonData)
	buttonPlay:scale(1.5, 1.5)
	buttonPlay.x = display.contentCenterX
	buttonPlay.y = display.contentCenterY * 1.75
	buttonPlay.tag = "play"
	group:insert(buttonPlay)
	
	buttonList.settings.onRelease = pressButton
    settingsBtn = widget.newButton(buttonList.settings)
	settingsBtn.x = screenRight - 100
	settingsBtn.y = screenBottom - 100
	settingsBtn.tag = "settings"
	group:insert(settingsBtn)
	
	buttonList.back.onRelease = pressButton
	backBtn = widget.newButton(buttonList.back)
	backBtn.x = screenLeft + 100
	backBtn.y = screenBottom - 100
	backBtn.tag = "back"
	group:insert(backBtn)
	
end

local function createShineStars(group)
	shineStarGroup = display.newGroup()
	shineStarGroup.stars = {}
	local totalStars = math.random(3, 6)
	for indexStar = 1, totalStars do
		local star = display.newImage("images/backgrounds/shinestar.png")
		shineStarGroup:insert(star)
		shineStarGroup.stars[indexStar] = star
	end
	group:insert(shineStarGroup)
end

local function enableButtons()
	buttonPlay:setEnabled(true)
end

local function disableButtons()
	buttonPlay:setEnabled(false)
end
local function createScene(sceneGroup)
	
	settingsScreen = display.newGroup()
	
	local setBack = display.newImage("images/settingsscreen/Background.png")
	setBack.x = centerX
	setBack.y = centerY
	setBack.width = screenWidth
	setBack.height = screenHeight
	settingsScreen:insert(setBack)
	
	local settingsBck = display.newImage("images/settingsscreen/settings.png")
	settingsBck.x = centerX
	settingsBck.y = centerY
	settingsBck.xScale = 1.1
	settingsBck.yScale = 1.1
	settingsScreen:insert(settingsBck)
	
	buttonList.music.onRelease = pressButton
	musicBtn = widget.newButton(buttonList.music)
	musicBtn.x = centerX - 100
	musicBtn.y = centerY - 20
	musicBtn.tag = "music"
	settingsScreen:insert(musicBtn)
	
	musicOff = display.newImage("images/buttons/music_2.png")
	musicOff.x = centerX - 100
	musicOff.y = centerY - 20
	musicOff.width = 140
	musicOff.height = 140
	musicOff.alpha = 0
	settingsScreen:insert(musicOff)
	
	buttonList.sound.onRelease = pressButton
	soundBtn = widget.newButton(buttonList.sound)
	soundBtn.x = centerX + 100
	soundBtn.y = centerY - 20
	soundBtn.tag = "sound"
	settingsScreen:insert(soundBtn)
	
	soundOff = display.newImage("images/buttons/sound_2.png")
	soundOff.x = centerX + 100
	soundOff.y = centerY - 20
	soundOff.width = 140
	soundOff.height = 140
	soundOff.alpha = 0
	settingsScreen:insert(soundOff)
	
	buttonList.ok.onRelease = pressButton
	okBtn = widget.newButton(buttonList.ok)
	okBtn.x = centerX
	okBtn.y = centerY + 240
	okBtn.tag = "ok"
	settingsScreen:insert(okBtn)
	
	createBackground(sceneGroup)
	createAsteroids(sceneGroup)
	createShineStars(sceneGroup)
	createStarfield(sceneGroup)
	createLogo(sceneGroup)
	createButtons(sceneGroup)
	
	settingsScreen.alpha = 0
	sceneGroup:insert (settingsScreen)
end
function scene:create(event)
	local sceneGroup = self.view
	createScene(sceneGroup)
end

function scene:destroy()
	
end

function scene:show( event )
	local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		initializeStarField()
		initializeStarShine()
		Runtime:addEventListener("enterFrame", updateGameLoop)
	elseif ( phase == "did" ) then
		music.playTrack(1)
		enableButtons()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
    local phase = event.phase
		
		disableButtons()
		
    if ( phase == "will" ) then
		Runtime:removeEventListener("enterFrame", updateGameLoop)
	elseif ( phase == "did" ) then
		--cancelPlayTransition()
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "show", scene )

return scene

