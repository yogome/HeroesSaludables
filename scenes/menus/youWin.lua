local director = require( "libs.helpers.director" )
local sound = require( "libs.helpers.sound" )
local settings = require( "settings" )
local widget = require("widget")
--local ui = require("services.ui")
local buttonList = require("data.buttonlist")
local localization = require("libs.helpers.localization")
--local particleList = require("data.particlelistdata")

local dataSaver = require("services.datasaver")
--local helperDoors = require ("scenes.game.helper")

local game = director.newScene() 
----------------------------------------------- Variables
local pauseGroup
local pauseQuit
local losePrompt
local losePromptText
local winPromptText
local quitPause = false
local masterWinSprite
local currentWorld
local currentLevel
local coinsText
local keysText, keysGiven
local powerCubesText
local powerCubesRestartTextPause
local powerCubesRestartTextLose
local buyMoreText
local buyMoreBtn
local retryBtnPause
local retryBtnLose
local particleEffect
local playBtnWin
local characterData = {
    skin = "Tomiko",
    skeletonFile = "characters/heroes/skeleton.json",
    imagePath = "characters/heroes/",
    attachmentPath = "characters/attachments/",
    scale = 0.8
}
local hero
------------------------------------------------- Constants
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenLeft = display.screenOriginX
local screenWidth = display.viewableContentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.viewableContentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight 
local mRandom = math.random
local sheetData1 = { width = 256, height = 256, numFrames = 16, sheetContentWidth = 1024, sheetContentHeight = 1024 }
--local masterSheetDataPreWin = { width = 256, height = 256, numFrames = 16, sheetContentWidth = 1024, sheetContentHeight = 1024 }
--local masterSheetPreWin = graphics.newImageSheet( "images/Win-lose/masterPreWin.png", masterSheetDataPreWin )
--local sequenceDataPreWin = {{ name = "pre-win", sheet = masterSheet1, start = 1, count = 8, time = 200, loopCount = 1 },}
------------------------------------------------- Functions

local function pressButton(event)
    local tag = event.target.type
    print (tag .. " tag")
    if quitPause then
        if tag == "playQuit" then
			director.hideOverlay()
            transition.to(pauseQuit,{alpha = 0, time = 300, onComplete = function()
				quitPause = false
				director.gotoScene("scenes.menus.levels", {time = 350, effect = "fade", params = {worldIndex = currentWorld}})
            end})
        elseif tag == "backQuit" then
            transition.to(pauseQuit,{alpha = 0, time = 300, onComplete = function()
            quitPause = false
            end
            })
        end
    else
        if tag == "play" then
		playBtnWin:setEnabled(false)
	    director.gotoScene("scenes.game.rewards",{params={ kGiven = keysGiven , world = currentWorld, level = currentLevel}})
	    director.hideOverlay()
	elseif tag == "retry" or tag == "retryPause" then
	    director.hideScene("scenes.game.main");
	    director.gotoScene("scenes.game.main",{ params={worldIndex=currentWorld,levelIndex=currentLevel }})
	elseif tag == "back" then
	    director.hideOverlay()
	    timer.performWithDelay(300,function()
		director.gotoScene( "scenes.menus.map", { effect = "fade", time = 800,  params = nil})	
	    end)
        elseif tag == "backPause" then
            transition.to(pauseQuit,{alpha = 1, time = 300} )
            quitPause = true
        end
    end
end
local function createMaster(sceneGroup)
    
	local masterSheet1 = graphics.newImageSheet( "images/victory/masterWin.png", sheetData1 )

	local sequenceData = {
		{ name = "win", sheet = masterSheet1, start = 1, count = 16, time = 1200, loopCount = 0 },
	}

	masterWinSprite = display.newSprite( masterSheet1, sequenceData )
    masterWinSprite.x = centerX-100
	masterWinSprite.y = centerY+25
	masterWinSprite.xScale = 1.3
	masterWinSprite.yScale = 1.3
	
	return  masterWinSprite
end

local function createFade()
    local fade = display.newRect(centerX, centerY, screenWidth,screenHeight + 100)
    fade:setFillColor(0,0,0)
    fade.alpha = 0.6
    fade:addEventListener("touch",function() return true end)
    fade:addEventListener("tap",function()return true end)
    return fade
end

local function setupDisplay(grp,event)
	pauseGroup = display.newGroup()
    pauseGroup:insert(createFade())
	
	pauseQuit = display.newGroup()
    
    local pauseWindow = display.newImage("images/Win-lose/ventana.png")
    pauseWindow.x = centerX
    pauseWindow.y = centerY
    pauseWindow.xScale = 1.1
    pauseWindow.yScale = 1.1
    pauseGroup:insert(pauseWindow)
    
    local pauseText = display.newImage("images/Win-lose/pause_es.png")
    pauseText.x = centerX
    pauseText.y = centerY - 270
    pauseGroup:insert(pauseText)
	
	local okCfg = {
			width = 256,
			height = 256,
			defaultFile = "images/Win-lose/ok_01.png",
			overFile = "images/Win-lose/ok_02.png",
			onPress = function()
			    sound.play("pop")
			end,
			onRelease = function()
			    event.parent:pause(false)
			end
    }
    local okBtn = widget.newButton(okCfg)
    okBtn.x = centerX + 150
    okBtn.y = screenBottom - 90
	okBtn.xScale=0.5
	okBtn.yScale=0.5
    okBtn.type = "ok"
    pauseGroup:insert(okBtn)
	
	local retryCfg = {
			width = 256,
			height = 192,
			defaultFile = "images/Win-lose/retry_01.png",
			overFile = "images/Win-lose/retry_02.png",
			onPress = function()
			    sound.play("pop")
			end,
			onRelease = function()
				director.hideScene("scenes.game.shooter");
				director.gotoScene("scenes.game.shooter",{ params={worldIndex=currentWorld,levelIndex=currentLevel }})
			end
    }

	retryBtnPause = widget.newButton(retryCfg)
    retryBtnPause.x = centerX
    retryBtnPause.y = screenBottom - 70
	retryBtnPause.xScale = 0.6
	retryBtnPause.yScale = 0.6
    retryBtnPause.type = "retryPause"
	retryBtnPause:setEnabled(false)
    pauseGroup:insert(retryBtnPause)
	
	local backCfg = {
			width = 256,
			height = 256,
			defaultFile = "images/Win-lose/map_01.png",
			overFile = "images/Win-lose/map_02.png",
			onPress = function()
			    sound.play("pop")
			end,
			onRelease = pressButton
    }
	
    local backBtn = widget.newButton(backCfg)
    backBtn.x = centerX - 150
    backBtn.y = screenBottom - 90
	backBtn.xScale = 0.5
	backBtn.yScale = 0.5
    backBtn.type = "backPause"
    pauseGroup:insert(backBtn)
    
    pauseGroup.y = pauseGroup.y - 20
    
    -- pauseQuit Screen-----------------------------------------------------
    
    pauseQuit:insert(createFade())
    
    local sureWindow =  display.newImage("images/Win-lose/window.png")
    sureWindow.x = centerX
    sureWindow.y = centerY
    sureWindow.xScale = 0.7
    sureWindow.yScale = 0.7
    pauseQuit:insert(sureWindow)
    
    local quitText = display.newText("¿Salir del juego?",centerX, centerY - 50,"VAGRounded", 45 )
    pauseQuit:insert(quitText)
	
	local okExitCfg = {
			width = 256,
			height = 256,
			defaultFile = "images/Win-lose/palomita_01.png",
			overFile = "images/Win-lose/palomita_02.png",
			onPress = function()
			    sound.play("pop")
			end,
			onRelease = pressButton
    }
	
    local playBtn = widget.newButton(okExitCfg)
    playBtn.x = centerX + 80
    playBtn.y = screenBottom - 260
    playBtn.xScale = 0.4
    playBtn.yScale = 0.4
    playBtn.type = "playQuit"
    pauseQuit:insert(playBtn)
	
	local backExitCfg = {
			width = 256,
			height = 256,
			defaultFile = "images/Win-lose/tacha_01.png",
			overFile = "images/Win-lose/tacha_02.png",
			onPress = function()
			    sound.play("pop")
			end,
			onRelease = pressButton
    }
	
    local backBtn = widget.newButton(backExitCfg)
    backBtn.x = centerX - 80
    backBtn.y = screenBottom - 260
    backBtn.xScale = 0.4
    backBtn.yScale = 0.4
    backBtn.type = "backQuit"
    pauseQuit:insert(backBtn)
    
    pauseQuit.alpha = 0
    pauseGroup:insert(pauseQuit)

    grp:insert(pauseGroup)

end

function game:create(event)
	local sceneView = self.view
        setupDisplay(sceneView,event)
end

function game:destroy()
end

function game:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	local params = event.params.screen or "win"
	currentWorld = event.params.worldIndex
	currentLevel = event.params.levelIndex
	
	if ( phase == "will" ) then
	    dataSaver:initialize()
		--print(params)
		pauseGroup.alpha = 0
		pauseQuit.alpha = 0

		pauseGroup.alpha = 1
		retryBtnPause:setEnabled(true)
		retryBtnPause.alpha=1
	elseif ( phase == "did" ) then

	end
end

function game:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
	    Runtime:removeEventListener("enterFrame", hero)
	    if hero then
			display.remove(hero.group)
	    end
	    hero=nil
	elseif ( phase == "did" ) then
		pauseQuit.alpha = 0
	    --display.remove(winGroup)
	    display.remove(particleEffect)
	end
end
----------------------------------------------- Execution
game:addEventListener( "create", game )
game:addEventListener( "destroy", game )
game:addEventListener( "hide", game )
game:addEventListener( "show", game )

return game