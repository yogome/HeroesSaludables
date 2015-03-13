local settings = require("settings")
local buttons = require("data.buttonlist")
local widget = require("widget")
local itemlist = require("data.itemlist")
local phraselist = require("data.phraselist")
local textbox = require("libs.helpers.textbox")
local battlefield = require("services.battlefield")
local particleList = require("data.particlelistdata")
local sound = require ("libs.helpers.sound")

local ui = {}
local currentScene
local pauseButton

local itemsIndex=1

local SCALE_CIRCLE_BG = 0.60
local SCALE_POWERICON = 0.35
local SIZE_CIRCLE = 128 * SCALE_CIRCLE_BG
local DISTANCE_CIRCLE = 12.5
local TOTAL_CIRCLES = 4

function ui.createPlayerInfo(playerName, coins, isEditable)
    
    local infoGroup = display.newGroup()

    local coinHolder = display.newImage("images/ui/coinsmenu.png")
    coinHolder:scale(0.5, 0.5)
    coinHolder.x = display.contentWidth * 0.80
    coinHolder.y = coinHolder.contentHeight * 0.5
    infoGroup:insert(coinHolder)
    
    
    local coinText = display.newText(coins, coinHolder.x + (coinHolder.x * 0.02), coinHolder.y, settings.fontName, 48)
    infoGroup:insert(coinText)
    infoGroup.coins = coinText

    function infoGroup:updateCoins(coins, animationDelay)
        
        local currentCoins = tonumber(self.coins.text)
        local newCoins = tonumber(coins)
        
        local sumText = display.newText("+" .. newCoins - currentCoins, self.coins.x * 1.15, self.coins.y * 1.40, settings.fontName, 36)
        sumText.rotation = 15
        self:insert(sumText)
        
        transition.to(sumText, {tag="updateCoins", y = self.coins.y * 1.10, time = 500, transition = easing.outSine, alpha = 0, onComplete = function()
            self.coins.text = coins
            transition.to(self.coins, {tag="updateCoins", time = 300, xScale = 1.2, yScale = 1.2, onComplete = function()
                self.coins.xScale = 1
                self.coins.yScale = 1
                display.remove(sumText)
            end})
        end})
    end
    
    return infoGroup
    
end

local function createHUDGroup(parent)
	
	local sceneGroup = display.newGroup()
	
    sceneGroup.objects = {
        circlesOff = {},
        circlesOn = {},
        circlesIcon = {},
        powerBars =  {},
        coinText = nil,
        movesText = nil,
        enemyText = nil,
        totalHeight = nil,
        shineGroup = nil,
        phraseGroup = nil,
        powerPanelGroup = nil
    }
    
    local assetPath = "images/ui/"
    
    local powerChainTable = {
        [1] = assetPath .. "power/power-01.png",
        [2] = assetPath .. "power/power-02.png",
        [3] = assetPath .. "power/power-03.png",
        [4] = assetPath .. "power/power-04.png"
    }
    
    ------Coin Panel
    
    local coinGroup = display.newGroup()
    local coinHolderAsset = display.newImage(assetPath .. "coins.png")
    coinGroup:insert(coinHolderAsset)
	
    local coinCounterText = display.newText("0", 0, 0, settings.fontName, 42)
    
	sceneGroup.objects.coinText = coinCounterText
    coinGroup:insert(coinCounterText)
    
    coinGroup.x = display.screenOriginX + (coinGroup.width * 0.5) - 2
    coinGroup.y = display.screenOriginY +(coinGroup.height * 0.5)
               
    sceneGroup:insert(coinGroup)
    
    -------Pause Panel
    
    local pauseGroup = display.newGroup()
    local pauseHolder = display.newImage(assetPath .. "pause.png")
    
    pauseGroup:insert(pauseHolder)
    
    local buttonPause = buttons.pause
    buttonPause.onRelease = function()
		if parent and parent.pause then
			parent:pause(true)
		end
    end
    
    pauseButton = widget.newButton(buttonPause)
    pauseButton.x = 0
    pauseButton.y = 0
    
    pauseGroup.x = display.contentWidth - (pauseGroup.contentWidth * 0.5)
    pauseGroup.y = display.screenOriginY + (pauseGroup.contentHeight * 0.5)
    
    pauseGroup:insert(pauseButton)
    
    sceneGroup:insert(pauseGroup)
    
    ----------Objetives panel

    local objetivesPanel = display.newGroup()
    local leftPanel = display.newImage(assetPath .. "panel_left.png")
    leftPanel:scale(1, 1)
    leftPanel.x = display.screenOriginX + (leftPanel.contentWidth * 0.5) 
    leftPanel.y = display.contentCenterY
    
    objetivesPanel:insert(leftPanel)
    
    local movementDescription = display.newText("Moves:", leftPanel.x, leftPanel.y - leftPanel.contentHeight * 0.45, settings.fontName, 20)
    movementDescription:setFillColor(1)
    objetivesPanel:insert(movementDescription)
    
    local moveText = display.newText("10", leftPanel.x, leftPanel.y - leftPanel.contentHeight * 0.25, settings.fontName, 92)
    sceneGroup.objects.movesText = moveText
    
    objetivesPanel:insert(moveText)
    
    local enemyDescription = display.newText("Enemies:", leftPanel.x, leftPanel.y - leftPanel.contentHeight * 0.065, settings.fontName, 20)
    enemyDescription:setFillColor(1)
    
    objetivesPanel:insert(enemyDescription)
    
    local enemyIcon = display.newImage(assetPath .. "bad_3.png")
    enemyIcon:scale(0.7, 0.7)
    enemyIcon.x = leftPanel.x
    enemyIcon.y = leftPanel.y + leftPanel.contentWidth * 0.40
    
    objetivesPanel:insert(enemyIcon)
    
    local enemyText = display.newText("10", leftPanel.x, enemyIcon.y + enemyIcon.contentHeight * 0.85, settings.fontName, 42)
	sceneGroup.objects.enemyText = enemyText
    objetivesPanel:insert(enemyText)
    
    
    sceneGroup:insert(objetivesPanel)
    
    ----------Power up panel
    
    local powerPanel = display.newGroup()
    local barHolder = display.newImage(assetPath .. "panel_right.png")
    sceneGroup.objects.powerPanelGroup = powerPanel
    powerPanel:insert(barHolder)

    powerPanel.x = display.contentWidth - (powerPanel.contentWidth * 0.5) + 2
    powerPanel.y = display.contentCenterY * 1.20
    
    --BackGroup Cirles
    
    local powerCircleBar = display.newGroup()
    local powerCircles = display.newGroup()
    local powerCircleColor = display.newGroup()
    local powerIcons = display.newGroup()
    local powerLine = display.newGroup()
    local itemShine = display.newGroup()
    local itemHolder = display.newGroup()
    
    local currentCircleScale = SCALE_CIRCLE_BG
    local currentIconScale = SCALE_POWERICON
    local circleOffset = powerPanel.contentWidth * 1.15 + (SIZE_CIRCLE * -SCALE_CIRCLE_BG)
    for indexCircle = 1, TOTAL_CIRCLES do
        --Circle Backgrounds(gray)
        local circleBackground = display.newImage(assetPath .. "gray.png")
        circleBackground:scale(currentCircleScale, currentCircleScale)
        circleBackground.y = circleOffset
        
        sceneGroup.objects.circlesOff[indexCircle] = circleBackground
        powerCircles:insert(circleBackground)
        
        --Circle Icons
        local powerIcon = display.newImage(powerChainTable[indexCircle])
        powerIcon:scale(currentIconScale, currentIconScale)
        powerIcon.y = circleOffset
        
		sceneGroup.objects.circlesIcon[#sceneGroup.objects.circlesIcon + 1] = powerIcon
        powerIcons:insert(powerIcon)
        
        circleOffset = circleOffset - circleBackground.contentHeight - DISTANCE_CIRCLE
        currentCircleScale = currentCircleScale + 0.05
        currentIconScale = currentIconScale + 0.05
    end
    
    powerCircleBar:insert(powerLine)
    powerCircleBar:insert(powerCircles)
    powerCircleBar:insert(powerCircleColor)
    powerCircleBar:insert(powerIcons)
    
    powerPanel:insert(powerCircleBar)
    powerPanel:insert(itemShine)
    powerPanel:insert(itemHolder)

    local line = display.newRect(0, powerPanel.contentWidth * 1.30, 15, powerCircleBar.contentHeight - (SIZE_CIRCLE * SCALE_CIRCLE_BG))
    line.anchorY = 1
    powerLine:insert(line)
	sceneGroup.objects.totalHeight = powerCircleBar.height + DISTANCE_CIRCLE
    
    local hexagonHolder = display.newImage(assetPath .. "hexagon.png")
	hexagonHolder.alpha = 0.9
    hexagonHolder:scale(0.7, 0.7)
    hexagonHolder.y = line.y + 35
    itemHolder:insert(hexagonHolder)
    
    local shine = display.newImage(assetPath .. "shine.png")
    shine:scale(0.8, 0.8)
    shine.y = hexagonHolder.y
    shine.alpha = 0
    shine.isVisible = false
	sceneGroup.objects.shineGroup = shine
    itemShine:insert(shine)

    sceneGroup:insert(powerPanel)
	
	
    
    ---Color circles and color power bar
    for indexPower = 1, #itemlist[itemsIndex].id do
        
        local powerColorBar = display.newContainer(powerCircleBar.width, powerCircleBar.height)
        powerColorBar.item = display.newImage(itemlist[itemsIndex].path .. itemlist[itemsIndex].id[indexPower] .. "_c1.png")
        powerColorBar.item:scale(0.20, 0.20)
        powerColorBar.item.y = hexagonHolder.y
        powerColorBar.item.isVisible = false
        powerPanel:insert(powerColorBar.item)
        
        powerColorBar.anchorY = 1
        powerColorBar.anchorChildren = false
        powerColorBar.height = 0
        
         sceneGroup.objects.powerBars[# sceneGroup.objects.powerBars + 1] = powerColorBar
        
        local circleOffset = (SIZE_CIRCLE * -SCALE_CIRCLE_BG)
        
		sceneGroup.objects.circlesOn[indexPower] = {}
        local currentCircleScale = SCALE_CIRCLE_BG
        for indexCircle = 1, TOTAL_CIRCLES do
            
            local powerColorCircle = display.newImage("images/ui/".. indexPower .. "/" .. indexCircle .. ".png")
            powerColorCircle:scale(currentCircleScale, currentCircleScale)
            powerColorCircle.y = circleOffset
                    
			sceneGroup.objects.circlesOn[indexPower][indexCircle] = powerColorCircle
            
            powerColorBar:insert(powerColorCircle)
            circleOffset = circleOffset - powerColorCircle.contentHeight - DISTANCE_CIRCLE
            currentCircleScale = currentCircleScale + 0.05
        end 
        powerCircleColor.y = powerPanel.contentWidth * 1.15
        powerCircleColor:insert(powerColorBar)
    end
	
	for indexMultiplier = 1, 4 do
		
		local multiplier = display.newImage(assetPath .. "x" .. indexMultiplier .. ".png")
		multiplier:scale(0.4, 0.4)
		multiplier.x = sceneGroup.objects.circlesIcon[indexMultiplier].x + powerPanel.contentWidth * 0.25
		multiplier.y = sceneGroup.objects.circlesIcon[indexMultiplier].y + powerPanel.contentHeight * 0.05
		powerPanel:insert(multiplier)
	end
	
    --------Phrase Group

    local phraseGroup = display.newGroup()
    
    sceneGroup.objects.phraseGroup = phraseGroup
    sceneGroup.objects.phraseGroup.phrase = nil
    sceneGroup:insert(phraseGroup)
    
    return sceneGroup
end

function ui:setPauseButton(isPause)
	pauseButton:setEnabled(isPause)
end

function ui:showPhrase(phraseID, isPermanent)
    
    if self.objects.phraseGroup then
        
        local phrase = display.newImage(phraselist[phraseID])
        phrase.alpha = 0
        phrase.xScale = 1.2
        phrase.x = display.contentCenterX
        phrase.y = display.contentCenterY * 0.50 - 100
        self.objects.phraseGroup.phrase = phrase
        self.objects.phraseGroup:insert(phrase)
        
        transition.to(phrase, {tag="phraseTransition", time = 500, xScale = 1, alpha = 1, transition = easing.outSine, y = display.contentCenterY, onComplete = function()
            if isPermanent then
                transition.to(phrase, {tag="phraseTransition", time = 500, rotation = 5, onComplete = function()
                    transition.to(phrase, {tag="phraseTransition", time = 2000, rotation = 0, iterations = -1, transition = easing.continuousLoop})
                end})
            else
                transition.to(phrase, {tag="phraseTransition2", delay = 2500, time = 500, xScale = 1.2, yScale = 0.7, alpha = 0, y = display.contentCenterY + 100, transition = easing.inSine, onComplete = function()    
                    phrase:removeSelf()
                    self.objects.phraseGroup.phrase = nil
                end})
                
            end
        end})
        
    end
end

function ui:removePhrase()
    if self.objects.phraseGroup then
	display.remove(self.objects.phraseGroup)
	self.objects.phraseGroup = nil
	self.objects.phraseGroup = display.newGroup()
    end
end


function ui:showPhraseCombo(phraseID)--, isAnimated)
    sound.play("comboSound")
    if self.objects.phraseGroup then
        
        local phrase = display.newImage(phraselist[phraseID])
        phrase.alpha = 0
        phrase.xScale = 0.8
	phrase.yScale = 0.8
        phrase.x = display.contentCenterX
        phrase.y = display.contentCenterY --* 0.50 - 100
        self.objects.phraseGroup.phrase = phrase
        self.objects.phraseGroup:insert(phrase)
        
        transition.to(phrase, {tag="sparkText", time = 200, rotation=-2, xScale = 1, yScale=1, alpha = 1, transition = easing.outSine, y = display.contentCenterY, onComplete = function()
			local particle = particleList.getParticleEffect("sparksText")
			self.objects.phraseGroup:insert(particle)
			particle.x=display.contentCenterX
			particle.y=display.contentCenterY
	    --phrase.rotation=-2
	    transition.to(phrase, {tag="phraseCombo1", time = 600, iterations = -1, rotation=2, transition=easing.continuousLoop})
	    transition.to(phrase, {tag="phraseCombo2", time = 1000, iterations = -1, xScale=1.7, yScale=1.7, transition=easing.continuousLoop})
	    transition.to(phrase, {tag="phraseCombo3", time = 900+(1200*((phraseID-5)/3)), alpha = 0, transition = easing.inQuint, onComplete = function()    
                    phrase:removeSelf()
                    self.objects.phraseGroup.phrase = nil
		    particle:removeSelf()
                end})
        end})
        
    end
end

function ui:setMoves(moves)
    self.objects.movesText.text = moves
end

function ui:updateMoves(moves)
    self.objects.movesText.text = moves
    transition.to(self.objects.movesText, {tag="updateMovesTransition", time = 150, xScale = 1.5, yScale = 1.5, onComplete = function()
        transition.to(self.objects.movesText, {tag="updateMovesTransition", time = 150, xScale = 1, yScale = 1, transition = easing.outSine})
    end})
end

function ui:updateCoins(coins)
    self.objects.coinText.text = coins
	transition.to(self.objects.coinText, {tag="updateCoinsTransition", time = 150, xScale = 1.5, yScale = 1.5, onComplete = function()
        transition.to(self.objects.coinText, {tag="updateCoinsTransition", time = 150, xScale = 1, yScale = 1, transition = easing.outSine})
    end})
end

function ui:updateEnemyCount(enemies)
    self.objects.enemyText.text = enemies
    transition.to(self.objects.enemyText, {tag="updateEnemyCountTransition", time = 150, xScale = 1.5, yScale = 1.5, onComplete = function()
        transition.to(self.objects.enemyText, {tag="updateEnemyCount", time = 150, xScale = 1, yScale = 1, transition = easing.outSine})
    end})
end

function ui:resetPowerBars()
        
    for indexElement = 1, #self.objects.powerBars do
        self.objects.powerBars[indexElement].height = 0
        self.objects.powerBars[indexElement].alpha = 1
        self.objects.powerBars[indexElement].isVisible = false
        self.objects.powerBars[indexElement].item.isVisible = false
    end
end

function ui:initialize(moves, coins, enemies)
    if self.objects then
        self.objects.enemyText.text = enemies
        self.objects.coinText.text = coins
        self.objects.movesText.text = moves
        self:resetPowerBars()
            
        if self.objects.phraseGroup then
            if self.objects.phraseGroup.phrase then
                self.objects.phraseGroup.phrase:removeSelf()
            end
        end
        
    end 
end

function ui:updatePowerBar(totalItems, itemId)
    
    self:resetPowerBars()
    
    local powerBar = self.objects.powerBars[itemId]
    powerBar.item.isVisible = true
    powerBar.item.alpha = 1
    
    powerBar.alpha = 0.5
    powerBar.isVisible = true
    powerBar.height = totalItems * (self.objects.totalHeight / 12)
    --transition.to()
    
    print(totalItems, itemId)
    
end

function ui:animatePowerBar(powerLevel, itemId, heroXY)
    
    powerLevel = math.floor(powerLevel) or 1
    if powerLevel >= 4 then
        powerLevel = 4
    end
    
    battlefield:setBlockTime(powerLevel)
    
    local powerBars = self.objects.powerBars
    self:resetPowerBars(powerBars)
    
    local powerBarToAnimate = powerBars[itemId]
    powerBarToAnimate.isVisible = true
    local animationLevel = (self.objects.totalHeight / 4) * powerLevel
    
    local itemToAnimate = powerBars[itemId].item
    itemToAnimate.isVisible = true
    itemToAnimate.alpha = 1
    
    local shine = self.objects.shineGroup
    shine.isVisible = true
    
    local transitionDelay = 650
    local attackDelay = 800
    for indexPower = 1, powerLevel do    
        local posX, posY = self.objects.circlesOff[indexPower]:localToContent(0,0)
        local imageFile
		local proyectile
        if indexPower >= 4 then
            imageFile = "characters/attachments/proyectiles/super.png"
            proyectile = display.newImage(imageFile)
            proyectile.xScale = 0.50
            proyectile.yScale = 0.50
        else
            imageFile = itemlist[itemsIndex].path .. itemlist[itemsIndex].id[itemId] .. "_c" .. indexPower .. ".png"
            proyectile = display.newImage(imageFile)
            proyectile.xScale = 0.4
            proyectile.yScale = 0.4
        end
        proyectile.alpha = 0.5
        proyectile.x = posX
        proyectile.y = posY
        currentScene:insert(proyectile)

        local transitionX = display.contentCenterX - (proyectile.contentWidth * 0.5 * (powerLevel - 1))
        transitionX = transitionX + ((proyectile.contentWidth) * (indexPower - 1))
    
        transition.to(proyectile, {tag="_proyectile1", delay = transitionDelay, time = 300, x = transitionX, transition = easing.inSine})
        transition.to(proyectile, {tag="_proyectile2", delay = transitionDelay, time = 300, alpha = 1, y = display.contentCenterY * 1.30, transition = easing.outSine, onComplete = function()
            transition.to(proyectile, {tag="_proyectile3", time = 300, delay = attackDelay * indexPower, x = heroXY.x, transition = easing.outSine})
            transition.to(proyectile, {tag="_proyectile4", time = 300, delay = attackDelay * indexPower, y = heroXY.y, transition = easing.inCubic, onComplete = function()
                battlefield:heroAttack(indexPower, powerLevel, itemId)
                transition.to(proyectile, {tag="_proyectile5", time = 300, alpha = 0})
            end})
        end})

        transitionDelay = transitionDelay + 300
    end
    
    transition.to(powerBarToAnimate, {tag="powerBarAnimate", delay = 600, time = 200 * powerLevel, height = animationLevel, transition = easing.outSine, onComplete = function()
       transition.to(powerBarToAnimate, {tag="powerBarAnimate", delay = 500, time = 1000, alpha = 0, onComplete = function()
            self:resetPowerBars()
       end})
    end})
    
    transition.to(shine, {tag="shine", delay = 600, time = 500, alpha = 1, rotation = 45, transition = easing.inSine, onComplete = function() 
        transition.to(shine, {tag="shine", delay = 600, time = 500, alpha = 0, rotation = 10, transition = easing.outSine})
    end})
    
    transition.to(itemToAnimate, {tag="itemAnimate", delay = 1000, time = 500, alpha = 0, rotation = 10, transition = easing.outSine})
    
end

function ui:getReceptorPosition()
    local x, y = self.objects.shineGroup:localToContent(0,0)
    return x,y
end

function ui.createGameHUD(scene, parent)
	currentScene = scene
	ui.group = createHUDGroup(scene, parent)
    ui.objects = ui.group.objects
end

function ui:destroy()
	display.remove(ui.group)
end

function ui:pause(isPause)
	if isPause then
		transition.pause("updateCoins")
		transition.pause("phraseTransition")
		transition.pause("phraseTransition2")
		transition.pause("sparkText")
		transition.pause("phraseCombo1")
		transition.pause("phraseCombo2")
		transition.pause("phraseCombo3")
		transition.pause("updateMovesTransition")
		transition.pause("updateCoinsTransition")
		transition.pause("updateEnemyCountTransition")
		transition.pause("_proyectile1")
		transition.pause("_proyectile2")
		transition.pause("_proyectile3")
		transition.pause("_proyectile4")
		transition.pause("_proyectile5")
		transition.pause("powerBarAnimate")
		transition.pause("shine")
		transition.pause("itemAnimate")
	else
		transition.resume("updateCoins")
		transition.resume("phraseTransition")
		transition.resume("phraseTransition2")
		transition.resume("sparkText")
		transition.resume("phraseCombo1")
		transition.resume("phraseCombo2")
		transition.resume("phraseCombo3")
		transition.resume("updateMovesTransition")
		transition.resume("updateCoinsTransition")
		transition.resume("updateEnemyCountTransition")
		transition.resume("_proyectile1")
		transition.resume("_proyectile2")
		transition.resume("_proyectile3")
		transition.resume("_proyectile4")
		transition.resume("_proyectile5")
		transition.resume("powerBarAnimate")
		transition.resume("shine")
		transition.resume("itemAnimate")
	end
end

return ui
