----------------------------------------------- Worlds
local composer = require( "composer" )
local widget = require( "widget" )
local buttonlist = require( "data.buttonlist" )
local logger = require( "libs.helpers.logger" )
local sound = require( "libs.helpers.sound" )
local scrollmenu = require( "libs.helpers.scrollmenu" )
local players = require( "models.players" )
local robot = require( "libs.helpers.robot" )
local database = require( "libs.helpers.database" )
local settings = require("settings")
local worldsdata = require( "data.worldsdata" )

local scene = composer.newScene() 
----------------------------------------------- Variables
local buttonBack, menu
local buttonNext, buttonPrevious
local spaceObjects, objectDespawnX, objectSpawnX
local spawnZoneWidth, halfSpawnZoneWidth
local titleGroup, title, language
local selectedWorldIndex, movingMenu
local currentPlayer
local minigamesButton
----------------------------------------------- Constants
local DATA_TITLE = {x = display.contentCenterX, y = display.screenOriginY + 100, scale = 0.7} 
local COLOR_BACKGROUND = {47/255,190/255,196/255}
local SIZE_BACKGROUND = 1024
local SIZE_WORLD_ITEM = 800
local MAX_STARS_PER_LEVEL = 3
local MARGIN = 20
local OFFSET_COMPLETION_BACKGROUND = {x = 0, y = 257}
local OFFSET_COMPLETION_TEXT = {x = 0, y = 255}
local STARS_LAYERS = 6
local STARS_LAYER_DEPTH_RATIO = 0.08
local STARS_PER_LAYER = 8

local OBJECTS_TOLERANCE_X = 100
----------------------------------------------- Functions
local function enableMenu()
	Runtime:addEventListener("enterFrame", menu)
	menu:scrollTo("right", {time = 0, onComplete = function()
		menu:scrollTo("left", {time = 800,})
	end})
end

local function disableMenu()
	Runtime:removeEventListener("enterFrame", menu)
end

local function onReleasedBack()
	composer.gotoScene( "scenes.menus.home", { effect = "zoomInOutFade", time = 600, } )
	--director.gotoScene( "scenes.menus.profiles", { effect = "zoomInOutFade", time = 600, } )
end

local function onReleasedMinigames()
	composer.gotoScene("scenes.minigames.gallery", { effect = "zoomInOutFade", time = 600, })
end

local function onReleasedNext()
	if not movingMenu then
		movingMenu = true
		selectedWorldIndex = selectedWorldIndex + 1
		if selectedWorldIndex >= #worldsdata then
			selectedWorldIndex = 0
		end
		menu:scrollToPosition({time = 400, x = selectedWorldIndex * -SIZE_WORLD_ITEM, onComplete = function()
			movingMenu = false
		end})
	end
end

local function onReleasedPrevious()
	if not movingMenu then
		movingMenu = true
		selectedWorldIndex = selectedWorldIndex - 1
		if selectedWorldIndex < 0 then
			selectedWorldIndex = #worldsdata - 1
		end
		menu:scrollToPosition({time = 400, x = selectedWorldIndex * -SIZE_WORLD_ITEM, onComplete = function()
			movingMenu = false
		end})
	end
end

local function onMenuTapped(event)
	if not movingMenu then
		if not event.target.locked then
			sound.play("pop")
			composer.gotoScene( "scenes.menus.levels", { effect = "zoomInOutFade", time = 600, params = {worldIndex = event.index}} )
		else
			sound.play("wrongAnswer")
		end
	end
end

local function createBackground(sceneGroup)
	local dynamicScale = display.viewableContentWidth / SIZE_BACKGROUND
    local backgroundContainer = display.newContainer(display.viewableContentWidth + 2, display.viewableContentHeight + 2)
    backgroundContainer.x = display.contentCenterX
    backgroundContainer.y = display.contentCenterY
    sceneGroup:insert(backgroundContainer)
    
    local background = display.newImage("images/menus/background.png", true)
    background.xScale = dynamicScale
    background.yScale = dynamicScale
	background.fill.effect = "filter.monotone"
	background.fill.effect.r, background.fill.effect.g, background.fill.effect.b = unpack(COLOR_BACKGROUND)
    backgroundContainer:insert(background)
	
	local containerHalfWidth = backgroundContainer.width * 0.5
	local containerHalfHeight = backgroundContainer.height * 0.5
	
	spaceObjects = {}
	
	objectDespawnX = containerHalfWidth + OBJECTS_TOLERANCE_X
	objectSpawnX = -containerHalfWidth - OBJECTS_TOLERANCE_X
	spawnZoneWidth = -objectSpawnX + objectDespawnX
	halfSpawnZoneWidth = spawnZoneWidth * 0.5
	
	for layerIndex = 1, STARS_LAYERS do
		local starLayer = display.newGroup()
		backgroundContainer:insert(starLayer)
		for starsIndex = 1, STARS_PER_LAYER do
			local scale =  0.05 + layerIndex * 0.05
			
			local star = display.newImage("images/menus/star_"..math.random(1,2)..".png")
			star.xOffset = math.random(objectSpawnX, objectDespawnX)
			star.y = math.random(-containerHalfHeight, containerHalfHeight)
			star.xScale = scale
			star.yScale = scale
			star.xVelocity = STARS_LAYER_DEPTH_RATIO * layerIndex
			starLayer:insert(star)
			
			spaceObjects[#spaceObjects + 1] = star
		end
	end
end

local function updateWorlds()
	local scrollX, scrollY = menu:getContentPosition()
	if not movingMenu then
		selectedWorldIndex = math.round((-scrollX)/ SIZE_WORLD_ITEM)
	end
	
	if spaceObjects then
		for index = 1, #spaceObjects do
			local object = spaceObjects[index]
			object.x = (object.xOffset + scrollX * object.xVelocity) % spawnZoneWidth - halfSpawnZoneWidth
		end
	end
end

local function createTitle()
	display.remove(title)
	
	title = display.newImage("images/worlds/worlds_"..language..".png")
	title.x = DATA_TITLE.x
	title.y = DATA_TITLE.y
	title.xScale = DATA_TITLE.scale
	title.yScale = DATA_TITLE.scale
	titleGroup:insert(title)
end

local function updateLocksAndStars()
	if currentPlayer.unlockedWorlds then
		for worldIndex = 1, #worldsdata do
			local levelsOnWorld = #worldsdata[worldIndex] or 0
				
			local playerStarsOnWorld = players.getStarsOnWorld(currentPlayer, worldIndex)
			local totalStars = levelsOnWorld * MAX_STARS_PER_LEVEL
			menu.items[worldIndex].unlockedGroup.completionText.text = tostring(playerStarsOnWorld).."/"..tostring(totalStars)
			
			if currentPlayer.unlockedWorlds[worldIndex] then
				menu:setLocked(worldIndex, not(currentPlayer.unlockedWorlds[worldIndex].unlocked))
			else
				menu:setLocked(worldIndex, true)
			end
		end
		
		-- TODO code to unlock world 2
		menu:setLocked(2, false)
		if not currentPlayer.unlockedWorlds[2] then
			currentPlayer.unlockedWorlds[2] = {
				unlocked = true,
				watchedEnd = false,
				watchedStart = false,
				levels = {
					[1] = {unlocked = true, stars = 0},
				},
			}
		else
			if not currentPlayer.unlockedWorlds[2].levels then
				currentPlayer.unlockedWorlds[2].levels = {
					[1] = {unlocked = true, stars = 0},
				}
			else
				if not currentPlayer.unlockedWorlds[2].levels[1] then
					currentPlayer.unlockedWorlds[2].levels[1] = {unlocked = true, stars = 0}
				else
					if not currentPlayer.unlockedWorlds[2].levels[1].unlocked then
						currentPlayer.unlockedWorlds[2].levels[1].unlocked = true
					end
				end
			end
		end
	else
		for index = 1, #worldsdata do
			menu:setLocked(index, true)
		end
		
		--TODO Code temporary, used to unlock world 1 and 2
		menu:setLocked(1, false)
		menu:setLocked(2, false)
		
		currentPlayer.unlockedWorlds = {
			[1] = {
				unlocked = true,
				watchedEnd = false,
				watchedStart = false,
				levels = {
					[1] = {unlocked = true, stars = 0},
				},
			},
			[2] = {
				unlocked = true,
				watchedEnd = false,
				watchedStart = false,
				levels = {
					[1] = {unlocked = true, stars = 0},
				},
			},
		}
	end
	
	
end

local function createMinigamesButton(sceneGroup)
	display.remove(minigamesButton)
	buttonlist.minigames[language].onRelease = onReleasedMinigames
	minigamesButton = widget.newButton(buttonlist.minigames[language])
	minigamesButton.x = display.screenOriginX + MARGIN + minigamesButton.width * 0.5
	minigamesButton.y = display.screenOriginY + display.viewableContentHeight - MARGIN - minigamesButton.height * 0.5
	minigamesButton.alpha = 0
	sceneGroup:insert(minigamesButton)
	transition.to(minigamesButton, {time = 1500, alpha = 1})
end
----------------------------------------------- Class functions 
function scene.enableButtons()
	menu:setEnabled(true)
	buttonBack:setEnabled(true)
	buttonNext:setEnabled(true)
	buttonPrevious:setEnabled(true)
	minigamesButton:setEnabled(true)
end

function scene.disableButtons()
	menu:setEnabled(false)
	buttonBack:setEnabled(false)
	buttonNext:setEnabled(false)
	buttonPrevious:setEnabled(false)
	minigamesButton:setEnabled(false)
end

function scene.backAction()
	robot.press(buttonBack)
	return true
end 

function scene:create(event)
	local sceneGroup = self.view
	
	movingMenu = false
	selectedWorldIndex = 1
	
	createBackground(sceneGroup)
	
	local items = {}
	for index = 1, #worldsdata do
		local unlockedGroup = display.newGroup()
		local image = display.newImage(worldsdata[index].icon, true)
		unlockedGroup:insert(image)
		unlockedGroup.image = image
		
		local completionBackground = display.newImage("images/worlds/letrero.png")
		completionBackground.x = OFFSET_COMPLETION_BACKGROUND.x
		completionBackground.y = OFFSET_COMPLETION_BACKGROUND.y
		unlockedGroup:insert(completionBackground)
		
		local completionTextOptions = {
			x = OFFSET_COMPLETION_TEXT.x,
			y = OFFSET_COMPLETION_TEXT.y,
			align = "center",
			font = settings.fontName,
			text = "0/20",
			fontSize = 50,
		}

		unlockedGroup.completionText = display.newText(completionTextOptions)
		unlockedGroup:insert(unlockedGroup.completionText)
		
		function unlockedGroup:setFillColor(...)
			unlockedGroup.image:setFillColor(...)
		end
		
		local lockedGroup = display.newGroup()
		local lockImage = display.newImage("images/general/lock.png")
		lockedGroup:insert(lockImage)
	
		items[index] = {unlockedGroup = unlockedGroup, lockedGroup = lockedGroup, locked = false}
	end
	
	local menuOptions = {
		itemSize = SIZE_WORLD_ITEM,
		smallIconScale = 0.5,
		tolerance = 600,
		lock = "images/worlds/level_lock.png",
		lockAlpha = 0.9,
		items = items,
		tapListener = onMenuTapped,
		itemOffsetY = 60,
		lockDarken = 0.3,
	}
	
	menu = scrollmenu.new(menuOptions)
	sceneGroup:insert(menu)
	
	titleGroup = display.newGroup()
	sceneGroup:insert(titleGroup)
	
	buttonlist.back.onRelease = onReleasedBack
	buttonBack = widget.newButton(buttonlist.back)
	buttonBack.x = display.screenOriginX + 64 + MARGIN
	buttonBack.y = display.screenOriginY + 64 + MARGIN
	sceneGroup:insert(buttonBack)
	
	buttonlist.right.onRelease = onReleasedNext
	buttonNext = widget.newButton(buttonlist.right)
	buttonNext.x = display.screenOriginX + display.viewableContentWidth - 64 - MARGIN
	buttonNext.y = display.contentCenterY
	sceneGroup:insert(buttonNext)
	
	buttonlist.left.onRelease = onReleasedPrevious
	buttonPrevious = widget.newButton(buttonlist.left)
	buttonPrevious.x = display.screenOriginX + 64 + MARGIN
	buttonPrevious.y = display.contentCenterY
	sceneGroup:insert(buttonPrevious)
end

function scene:destroy()
	
end

function scene:show( event )
	local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		language = database.config("language") or "en"
		currentPlayer = players.getCurrent()
		createTitle()
		createMinigamesButton(sceneGroup)
		updateLocksAndStars()
		Runtime:addEventListener("enterFrame", updateWorlds)
		self.disableButtons()
		enableMenu()
	elseif ( phase == "did" ) then
		self.enableButtons()
		
		
	end
end

function scene:hide( event )
	local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		self.disableButtons()
	elseif ( phase == "did" ) then
		disableMenu()
		Runtime:removeEventListener("enterFrame", updateWorlds)
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "show", scene )

return scene
