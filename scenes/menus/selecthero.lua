----------------------------------------------- Hero select (Boy or girl)
local director = require( "libs.helpers.director" )
local widget = require("widget")
local sound = require( "libs.helpers.sound" )
local buttonList = require( "data.buttonlist" )
local hatlist = require( "data.hatlist" )
local herolist = require( "data.herolist" )
local settings = require( "settings" )
local colors = require( "libs.helpers.colors" )
local music = require("libs.helpers.music")
--local ui = require("services.ui")
local localization = require("libs.helpers.localization")
--local helperDoors = require ("scenes.game.helper")
local animator = require("services.animator")
local textbox = require("libs.helpers.textbox")
local dataSaver = require("services.datasaver")
local sound = require("libs.helpers.sound")
local music = require("libs.helpers.music")
local logger = require( "libs.helpers.logger" )
local shiplist = require("data.shiplist")
--local map = require("scenes.menus.map")
--local manager = require( "scenes.minigames.manager" )
local extratable = require("libs.helpers.extratable")
--local upgrader = require("services.upgrader")
--local tutorial = require("services.tutorial")


local scene = director.newScene()
----------------------------------------------- Variables
-- 
local parent
local backgroundGroup
local buttonPowercubes
local buttonGoLevel
local buttonPowercubesGroup
local buttonGoLevelGroup
local popupGroup
local selectPanelGroup
local heroPreviewGroup
local buyButtonGroup
local yogotarGroup
local animationGroup
local uiGroup
local buttonTabs
local panels
local currentPanel, currentPage, currentSelectedItem
local selectedStroke
local buttonNextPage, buttonBackPage
local yogotar
local animatedLines, animatedCircle
local currentWorld, currentLevel
local nameTextbox
local buttonBack
local playerUnlockedHats, playerUnlockedYogotars, playerInventoryYogotars, playerInventoryHats, playerInventoryShips
local currentYogotarType, currentSelectedYogotar, currentCoins, currentPowercubes, currentHat
local currentPlayerLevel, upgradePrice, currentShip, playerUnlockedShips
local coinText
local powercubeText
local powercubeBar
local isAnimatingBar
local frameCounter = 0
local earnedCubes
local upgradeText
local powerUp
local upgradeGroup
local showTutorial
local tutorialGroup
local shipGroup

----------------------------------------------- Constants

local assetPath = "images/selecthero/new/"
local mRandom = math.random
local ITEMS_PER_PAGE = 6
local NUMBER_COLUMNS = 3
local LEVEL_COST = 25
	
local tabs = {
    [1] = {
        name = "boys",
        icon = "btn_boy_01.png",
        selectedIcon = "btn_boy_02.png",
        itemList = herolist[1]
    },
    [2] = {
        name = "girls",
        icon = "btn_girl_01.png",
        selectedIcon = "btn_girl_02.png",
        itemList = herolist[2]
    },
    [3] = {
        name = "hats",
        icon = "btn_hat_01.png",
        selectedIcon = "btn_hat_02.png",
        itemList = hatlist
    },
	[4] = {
		name = "ships",
		icon = "selector-09.png",
		selectedIcon = "selector-08.png",
		itemList = shiplist,
	},
}

----------------------------------------------- Functions

local function updateGame()
    yogotar.enterFrame()
    frameCounter = frameCounter + 1
    if isAnimatingBar then
        if frameCounter % 5 == 0 then
            powercubeBar:setFillColor(0.9)
        else
            --local redColor = 1 - ((1/powercubeBar.fullWidth) * powercubeBar.width)
            --local greenColor = (0.4 / powercubeBar.fullWidth) * powercubeBar.width
            --local blueColor = (powercubeBar.width / 300)
            --powercubeBar:setFillColor(redColor, greenColor, blueColor)
            powercubeBar:setFillColor(0, 0.4, 1)
        end
        
    end
end

local function buyItem(event)
	
	local buttonType = event.target.id
	sound.play("cashier")
	
	if buttonType == "item" then
		
		local itemPrice = panels[currentPanel][currentPage].items[currentSelectedItem].price
		panels[currentPanel][currentPage].base[currentSelectedItem].isVisible = false
		panels[currentPanel][currentPage].prices[currentSelectedItem].isVisible = false
		panels[currentPanel][currentPage].items[currentSelectedItem].canBuy = false
		panels[currentPanel][currentPage].availableBases[currentSelectedItem].isVisible = true

		buyButtonGroup.button:setEnabled(false)
		buyButtonGroup.isVisible = false

		currentCoins = currentCoins - itemPrice
		coinText.text = currentCoins

		if currentPanel == 1 or currentPanel == 2 then
			dataSaver:setInventoryYogotar(currentPanel, currentSelectedItem)
			dataSaver:setCurrentYogotar(currentSelectedItem)
			dataSaver:setYogotarType(currentPanel)

			currentSelectedYogotar = currentSelectedItem
			currentYogotarType = currentPanel
		elseif currentPanel == 3 then
			dataSaver:setInventoryHat(panels[currentPanel][currentPage].items[currentSelectedItem].id)
			currentHat = panels[currentPanel][currentPage].items[currentSelectedItem].id
			dataSaver:setCurrentHat(currentHat)
			yogotar:setNewAttachment(hatlist[currentHat].name, "hat") 
		elseif currentPanel == 4 then
			
			dataSaver:setInventoryShip(panels[currentPanel][currentPage].items[currentSelectedItem].id)
			dataSaver:setCurrentShip(panels[currentPanel][currentPage].items[currentSelectedItem].id)
			
		end
	end
	
		
	dataSaver:setCoins(currentCoins)
end

local function gotoLevel()
    scene.disableButtons()
	
--	if showTutorial then
--		uiGroup:insert(buttonGoLevelGroup)
--		dataSaver:setShownTutorial(3)
--		display.remove(tutorialGroup)
--	end
        
	local totalTime = 300
	local x, y = buttonPowercubes:localToContent(0,0)
--	for indexPowercube = 1, #uiGroup.powercubes do
--		local currentPowercube = uiGroup.powercubes[indexPowercube]
--        uiGroup:insert(currentPowercube)
--		currentPowercube.alpha = 1
--		currentPowercube.isVisible = true
--        currentPowercube.x = buttonGoLevelGroup.x + buttonGoLevelGroup.contentWidth * 0.20
--        currentPowercube.y = buttonGoLevelGroup.y - buttonGoLevelGroup.contentHeight * 0.20
--		transition.from(currentPowercube, {delay = 75 * indexPowercube, time = totalTime, x = x, y = y + buttonPowercubes.contentWidth * 0.25, alpha = 0, onComplete = function()
--			sound.play("scoreGiven")
--			transition.to(currentPowercube, {time = 100, x = currentPowercube.x + 10, y = currentPowercube.y, alpha = 0})
--		end})
--	end
	
    currentPowercubes = currentPowercubes - LEVEL_COST
    powercubeText.text = currentPowercubes
    
    local barUnits = powercubeBar.fullWidth / 300
    local newSize = currentPowercubes * barUnits
    
    isAnimatingBar = true

	if newSize <= 0 then
		newSize = 0
	end
--    transition.to(powercubeBar, {width = newSize, time = 1000, onComplete = function()
--        isAnimatingBar = false
--		
--        --helperDoors.loader("scenes.game.versus", {world = currentWorld, level = currentLevel}, {})
--    end})

    director.gotoScene("scenes.menus.worlds", {effect = "fade", time = 500})
    dataSaver:setYogotarType(currentYogotarType)
    dataSaver:setCurrentYogotar(currentSelectedYogotar)
    dataSaver:setPowercubes(currentPowercubes)
end

local function getPowercubes()
    scene.disableButtons()
	if showTutorial then
		dataSaver:setFirstTimePlay(false)
	end
    local function onManagerComplete(event)
		dataSaver:addPowercubes(event.powerCubes)
		earnedCubes = event.powerCubes
		popupGroup.message.text = string.format("%s\n%d\nPowercubes", localization.getString("you got"), event.powerCubes)
    end
	
	--manager.setOnComplete(onManagerComplete)
	--manager.setNextScene("scenes.menus.map", {fromManager = true, gotPowercubes = true, level = currentLevel, world = currentWorld})
	
	local subjectsScene = require( "scenes.minigames.subjects")
	subjectsScene.setBackScene("scenes.menus.map", {fromManager = true, gotPowercubes = false, level = currentLevel, world = currentWorld})
	subjectsScene.setSubmenuEnabled(false)
	
	dataSaver:setYogotarType(currentYogotarType)
    dataSaver:setCurrentYogotar(currentSelectedYogotar)
    director.gotoScene("scenes.minigames.subjects")
end

local function createBackground(backgroundId)
    
    local animatedBackgrounds = display.newGroup()
    
    backgroundGroup.backgrounds = {}
    local bgScale = display.contentWidth / 1024
	local background = display.newImage("images/selecthero/backgrounds/background-01.png")
	background:scale(bgScale, bgScale)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	animatedBackgrounds:insert(background)
	
	
	backgroundGroup.backgrounds[#backgroundGroup.backgrounds+1] = background

    
    backgroundGroup:insert(animatedBackgrounds)
    
end

local function selectItem(event)
	
    sound.play("pop")
	local target = event.target
    currentSelectedItem = target.index
    selectedStroke.isVisible = true
    selectedStroke.width = target.contentWidth * 1.10
    selectedStroke.height = target.contentHeight * 1.10 
    selectedStroke.x = target.x + 1
    selectedStroke.y = target.y - 1
	
    
    if target.panel == 1 or target.panel == 2 then
        local selectedSkinName = herolist[target.panel][target.id].skinName
		yogotar:setSkin(selectedSkinName)
		yogotar:setNewAttachment(hatlist[currentHat].name, "hat") 
		if not target.canBuy then
			currentSelectedYogotar = target.index
			currentYogotarType = target.panel
		end		
		
    elseif event.target.panel == 3 then
        yogotar:setNewAttachment(hatlist[target.id].name, "hat") 
		if not target.canBuy then
			currentHat = target.id
			dataSaver:setCurrentHat(currentHat)
		end
		
	elseif event.target.panel == 4 then
		
		for indexShip = 1, #shipGroup.ships do
			shipGroup.ships[indexShip].isVisible = false
		end
		shipGroup.ships[target.index].isVisible = true
		
		if not target.canBuy then
			currentShip = target.index
			dataSaver:setCurrentShip(currentShip)
		end
		
		
		
    end
    
    if event.target.canBuy then
        buyButtonGroup.isVisible = true	
        if event.target.price > currentCoins then
            buyButtonGroup.button:setEnabled(false)
            buyButtonGroup.button:setFillColor(0.5)
            buyButtonGroup.text:setFillColor(0.5)
        else
            buyButtonGroup.button:setEnabled(true)
            buyButtonGroup.button:setFillColor(1)
            buyButtonGroup.text:setFillColor(1)
        end
    else
        buyButtonGroup.isVisible = false
    end
    
    
end

local function hideAllLayers()
    for indexPanel = 1, #panels do
        for indexPage = 1, #panels[indexPanel] do
            panels[indexPanel][indexPage].isVisible = false
        end
    end
end

local function setActiveTab(tabId)
    currentPanel = tabId
    currentPage = 1
    currentSelectedItem = 0
	
	buyButtonGroup.button:setEnabled(false)
    buyButtonGroup.isVisible = false

	buyButtonGroup.button:setEnabled(false)
    buyButtonGroup.isVisible = false

    for indexButton = 1, #buttonTabs do
        buttonTabs[indexButton].active.isVisible = false
    end
    buttonTabs[tabId].active.isVisible = true
	
	
	 if #panels[currentPanel] <= 1 then
		buttonNextPage.isVisible = false
		buttonBackPage.isVisible = false
	else
		if currentPage <= 1 then
			buttonNextPage.isVisible = true
			buttonBackPage.isVisible = false
		else
			buttonNextPage.isVisible = true
			buttonBackPage.isVisible = true
		end
	end
	
end

local function showPage()
    panels[currentPanel][currentPage].isVisible = true
    
    local transitionOffset = 100
	local strokeTransitionTime = transitionOffset
    for indexItem = 1, #panels[currentPanel][currentPage].items do
		
		local currentItem = panels[currentPanel][currentPage].items[indexItem]
        local currentBase = panels[currentPanel][currentPage].base[indexItem]
        local currentPrice = panels[currentPanel][currentPage].prices[indexItem]
		--local currentAlternateBase = panels[currentPanel][currentPage].availableBases[indexItem]
		
		if currentPanel == currentYogotarType then
			if currentSelectedYogotar == indexItem then
				selectedStroke.isVisible = true
				selectedStroke.alpha = 1
				selectedStroke.width = currentItem.contentWidth * 1.10
				selectedStroke.height = currentItem.contentHeight * 1.10
				selectedStroke.x = currentItem.x + 1
				selectedStroke.y = currentItem.y
				transition.from(selectedStroke, {delay = transitionOffset, y = currentItem.y * 0.90, time = 300, alpha = 0})
			end
		elseif currentPanel == 3 then
			
			if currentHat == currentItem.id then
				selectedStroke.isVisible = true
				selectedStroke.alpha = 1
				selectedStroke.width = currentItem.contentWidth * 1.10
				selectedStroke.height = currentItem.contentHeight * 1.10
				selectedStroke.x = currentItem.x + 1
				selectedStroke.y = currentItem.y
				transition.from(selectedStroke, {delay = transitionOffset, y = currentItem.y * 0.90, time = 300, alpha = 0})
			end
			
		end

        transition.from(currentItem, {delay = transitionOffset, y = currentItem.y * 0.90, time = 300, alpha = 0})
        transition.from(currentBase, {delay = transitionOffset, y = currentBase.y * 0.90, time = 300, alpha = 0})
        transition.from(currentPrice, {delay = transitionOffset, y = currentPrice.y * 0.90, time = 300, alpha = 0})
		--transition.from(currentAlternateBase, {delay = transitionOffset, y = currentAlternateBase.y * 0.90, time = 300, alpha = 0})
        transitionOffset = transitionOffset + 30

    end
	
	
end

local function selectPanel(event)
    
	yogotar:setSkin(herolist[currentYogotarType][currentSelectedYogotar].skinName)
	yogotar:setNewAttachment(hatlist[currentHat].name, "hat")
    
    if not event.target.active.isVisible then
        currentPage = 1
        currentPanel = event.target.id
        currentSelectedItem = 0
        buyButtonGroup.isVisible = false
        selectedStroke.isVisible = false
        
        setActiveTab(event.target.id)
        hideAllLayers()
        showPage()
        
        if #panels[event.target.id] <= 1 then
            buttonNextPage.isVisible = false
            buttonBackPage.isVisible = false
        else
            if currentPage <= 1 then
                buttonNextPage.isVisible = true
                buttonBackPage.isVisible = false
            else
                buttonNextPage.isVisible = true
                buttonBackPage.isVisible = true
            end
        end
    end
end

local function goNextPage(event)
    
    local totalPages = #panels[currentPanel]
    currentPage = currentPage + 1
    if currentPage >= totalPages then
        buttonNextPage.isVisible = false
        buttonBackPage.isVisible = true
    else
        buttonNextPage.isVisible = true
        buttonBackPage.isVisible = true
    end
    
    selectedStroke.isVisible = false
    currentSelectedItem = 0
    hideAllLayers()
    showPage()
end

local function goBackPage()
    
    local totalPages = #panels[currentPanel]
    currentPage = currentPage - 1
    if currentPage <= 1 then
        buttonNextPage.isVisible = true
        buttonBackPage.isVisible = false
    else
        buttonNextPage.isVisible = true
        buttonBackPage.isVisible = true
    end
    
    selectedStroke.isVisible = false
    currentSelectedItem = 0
    hideAllLayers()
    showPage()
    
end

local function createPageButtons()
    
    local buttonData = buttonList.previous
    buttonData.onRelease = goBackPage
    buttonBackPage = widget.newButton(buttonData)
    buttonBackPage:scale(0.5, 0.5)
    buttonBackPage.x = selectPanelGroup.mainPanel.x - selectPanelGroup.mainPanel.contentWidth * 0.4
    buttonBackPage.y = selectPanelGroup.mainPanel.y + selectPanelGroup.mainPanel.contentHeight * 0.4
    buttonBackPage.isVisible = false
    selectPanelGroup:insert(buttonBackPage)
    
    local buttonData = buttonList.next
    buttonData.onRelease = goNextPage
    buttonNextPage = widget.newButton(buttonData)
    buttonNextPage:scale(0.5, 0.5)
    buttonNextPage.x = selectPanelGroup.mainPanel.x + selectPanelGroup.mainPanel.contentWidth * 0.4
    buttonNextPage.y = selectPanelGroup.mainPanel.y + selectPanelGroup.mainPanel.contentHeight * 0.4
    buttonNextPage.isVisible = false
    selectPanelGroup:insert(buttonNextPage)
    
end

local function createSelectorPanel()
    
    local rectHolder = display.newRoundedRect(display.contentCenterX * 0.50, display.contentCenterY * 1.10, 500, 400, 20)
    rectHolder:setFillColor(0.5, 0.5)
    rectHolder.strokeWidth = 6
    rectHolder:setStrokeColor(0, 1, 1)
    selectPanelGroup.mainPanel = rectHolder
    selectPanelGroup:insert(rectHolder)
    
    buttonTabs = {}
    
    local offsetX = rectHolder.x * 0.70
    for buttonIndex = 1, #tabs do
        local buttonGroup = display.newGroup()
        buttonGroup.id = buttonIndex
        
        local button = display.newImage(assetPath .. tabs[buttonIndex].icon)
        buttonGroup.unactive = button
        buttonGroup:insert(button)
        
        local buttonActive = display.newImage(assetPath .. tabs[buttonIndex].selectedIcon)
        buttonActive.isVisible = false
        buttonGroup.active = buttonActive
        buttonGroup:insert(buttonActive)
        
        buttonGroup:scale(0.65, 0.65)
        buttonGroup.x = offsetX
        buttonGroup.y = rectHolder.y - (rectHolder.contentHeight * 0.65)
        selectPanelGroup:insert(buttonGroup)
        
        buttonGroup:addEventListener("tap", selectPanel)
		
        buttonTabs[buttonIndex] = buttonGroup
        offsetX = offsetX + buttonGroup.contentWidth * 1.20
    end
    
    
    selectedStroke = display.newRoundedRect(0, 0, 0, 0, 25)
    selectedStroke.isVisible = false
    selectedStroke.strokeWidth = 6
    selectedStroke:setStrokeColor(0.3,1,0.3)
    selectedStroke:setFillColor(0,0)
	selectPanelGroup:insert(selectedStroke)
	
    local function zoomStroke()
			local zoomStroke = transition.to(selectedStroke, {xScale = 0.96, yScale = 0.96, onComplete = function()
					transition.to(selectedStroke, {xScale = 0.975, yScale = 0.975, onComplete = function()
						zoomStroke()
				end})
        end})
    end
	
    zoomStroke()
	
    uiGroup:insert(selectedStroke)
    
    buyButtonGroup = display.newGroup()
    local buttonInfo = buttonList.buy
    buttonInfo.onRelease = buyItem
    local buyButton = widget.newButton(buttonInfo)
	buyButton.id = "item"
    buyButton:scale(0.7, 0.7)
    buyButton.x = 0
    buyButton.y = 0
    buyButtonGroup.button = buyButton
    buyButtonGroup:insert(buyButton)
    
    local textButton = display.newText("Comprar", 0, 0, settings.fontName, 32)
    textButton.y = - buyButton.contentWidth * 0.05
    buyButtonGroup.text = textButton
    buyButtonGroup:insert(textButton)
    
    buyButtonGroup.isVisible = false
    buyButtonGroup.x = rectHolder.x
    buyButtonGroup.y = rectHolder.y * 1.40
	uiGroup:insert(buyButtonGroup)
end

local function searchValueOnTable(dataValue, dataTable)
    local isOnTable = false
    for key, value in pairs(dataTable) do
        if value == dataValue then
            isOnTable = true
            break
        end
    end
    return isOnTable
end

local function createItems()
    
    for indexPanel = 1, #tabs do
        local itemlist = tabs[indexPanel].itemList
        local totalItems = #tabs[indexPanel].itemList
        
        local pagesToCreate = math.ceil(totalItems / ITEMS_PER_PAGE)
        
        panels[indexPanel] = {}
        local itemCounter = 0
        for indexPage = 1, pagesToCreate do
            
            local offsetX = selectPanelGroup.mainPanel.x - (selectPanelGroup.mainPanel.contentWidth * 0.3)
            local initX = offsetX
            local offsetY = selectPanelGroup.mainPanel.y - (selectPanelGroup.mainPanel.contentHeight * 0.3)
            local pageGroup = display.newGroup()
            pageGroup.isVisible = false
            pageGroup.items = {}
            pageGroup.base = {}
            pageGroup.prices = {}
            pageGroup.availableBases = {}
            for indexItem = 1, ITEMS_PER_PAGE do
				itemCounter = itemCounter + 1
				if itemCounter <= totalItems then
					
					local isUnlocked = true
					local isInInventory = true
					local backgroundString = "item_5.png"
					if indexPanel == 1 or indexPanel == 2 then
						isUnlocked = searchValueOnTable(itemCounter, playerUnlockedYogotars[indexPanel])
						if isUnlocked then
							isInInventory = searchValueOnTable(itemCounter, playerInventoryYogotars[indexPanel])
							if isInInventory then
								backgroundString = "item_5.png" 
							else
								backgroundString = "selector.png"
							end
						else
							backgroundString = "item_2.png" 
						end
						
					elseif indexPanel == 3 then
						isUnlocked = searchValueOnTable(itemCounter, playerUnlockedHats)
						if isUnlocked then
							isInInventory = searchValueOnTable(itemCounter, playerInventoryHats)
							if isInInventory then
								backgroundString = "item_5.png" 
							else
								backgroundString = "selector.png"
							end
							
						else
							backgroundString = "item_6.png" 
						end
						
					elseif indexPanel == 4 then
						
						isUnlocked = searchValueOnTable(itemCounter, playerUnlockedShips)
						if isUnlocked then
							isInInventory = searchValueOnTable(itemCounter, playerInventoryShips)
							if isInInventory then
								backgroundString = "item_5.png" 
							else
								backgroundString = "selector.png"
							end
							
						else
							backgroundString = "item_6.png" 
						end
						
					end
					
					
					local itemBase
					if not isUnlocked then
                        itemBase = display.newImage(assetPath..backgroundString)
                        itemBase.x = offsetX
                        itemBase.y = offsetY + (selectPanelGroup.mainPanel.contentHeight * 0.045)
                        itemBase:scale(0.57, 0.57)
                        pageGroup.base[indexItem] = itemBase
                        pageGroup:insert(itemBase)
                        local item = display.newGroup()
                        pageGroup.items[indexItem] = item
                        local priceTag = display.newGroup()
                        pageGroup.prices[indexItem] = priceTag
					else
                        itemBase = display.newImage(assetPath..backgroundString)
                        itemBase.x = offsetX
                        itemBase.y = offsetY + (selectPanelGroup.mainPanel.contentHeight * 0.045)
                        itemBase:scale(0.57, 0.57)
                        pageGroup.base[indexItem] = itemBase
                        pageGroup:insert(itemBase)
                        
                        itemBase = display.newImage(assetPath.."item_5.png")
                        itemBase.x = offsetX
                        itemBase.y = offsetY + (selectPanelGroup.mainPanel.contentHeight * 0.045)
                        itemBase:scale(0.57, 0.57)
                        itemBase.isVisible = false
                        pageGroup.availableBases[indexItem] = itemBase
                        pageGroup:insert(itemBase)
                        
                        local priceTag
                        if not isInInventory then
                            priceTag = display.newText(itemlist[itemCounter].price, itemBase.x + itemBase.contentWidth * 0.09, itemBase.y + itemBase.contentHeight * 0.30, settings.fontName, 24)
                            priceTag:setFillColor(0, 0.8)
                        else
                            priceTag = display.newGroup()
                        end
                        
                        pageGroup.prices[indexItem] = priceTag
                        pageGroup:insert(priceTag)
						
                        local item = display.newImage(itemlist[itemCounter].iconPath)
                        item:scale(0.73,0.73)
                        item.id = itemCounter
                        item.index = indexItem
                        item.canBuy = not isInInventory
                        item.price = itemlist[itemCounter].price
                        item.page = indexPage
                        item.panel = indexPanel
                        item.x = offsetX
                        item.y = offsetY
                        item.isBlocked = false
                        item:addEventListener("tap", selectItem)
                        pageGroup.items[indexItem] = item
                        pageGroup:insert(item)
					end
					
                    offsetX = offsetX + itemBase.contentWidth
					
                    if (indexItem % NUMBER_COLUMNS) == 0 then
                        offsetX = initX
                        offsetY = offsetY + itemBase.contentHeight
                    end
                end
            end
            panels[indexPanel][indexPage] = pageGroup
            selectPanelGroup:insert(pageGroup)
        end
    end
end


local function createYogotar()
    
    local characterData = {
        skin = "Eagle",
        skeletonFile = "units/heroes/skeleton.json",
        imagePath = "units/heroes/",
        attachmentPath = "units/attachments/",
        scale = 0.8
    }
    
    yogotar = animator.newCharacter(characterData)
	
	yogotar.setAnimationMix("RAGERUN", "SLIDE")
    yogotar.setAnimationMix("SLIDE", "IDLE") 
	--yogotar.setAnimationMix("RUN", "IDLE") 
	
	
    yogotar:setAnimation("IDLE2", true)
    yogotar.group.x = display.contentWidth * 0.75
    yogotar.group.y = display.contentHeight * 0.71
    yogotarGroup:insert(yogotar.group)
end

local function createAnimatedInterface()
    
    
    local lineGroup = display.newGroup()
    animationGroup:insert(lineGroup)
    
    animatedCircle = display.newImage(assetPath .. "baseyogotar.png")
    animatedCircle.x = yogotar.group.x * 0.99
    animatedCircle.y = yogotar.group.y * 0.70
    animationGroup:insert(animatedCircle)
    
    animatedLines = {}
    local centerLine = display.newLine(selectPanelGroup.mainPanel.x + (selectPanelGroup.mainPanel.contentWidth * 0.5), selectPanelGroup.mainPanel.y, animatedCircle.x - (animatedCircle.contentWidth * 0.475), animatedCircle.y)
    centerLine:setStrokeColor(0,1,1)
    centerLine.strokeWidth = 4
    lineGroup:insert(centerLine)
end

local function createUI()
    
    local powercubeUI = display.newImage(assetPath .. "barPowerCubes.png")
	powercubeUI.isVisible = false
    powercubeUI.x = display.contentWidth * 0.25
    powercubeUI.y = display.contentHeight - (powercubeUI.contentHeight * 0.5)
    uiGroup:insert(powercubeUI)
    
    powercubeText = display.newText("0", powercubeUI.x + (powercubeUI.contentWidth * 0.28), powercubeUI.y - (powercubeUI.contentHeight * 0.21), settings.fontName, 32 )
	powercubeText.isVisible = false
    uiGroup:insert(powercubeText)
    
    powercubeBar = display.newRect(powercubeUI.x + (powercubeUI.contentWidth * 0.32), powercubeUI.y + powercubeUI.contentHeight * 0.14, powercubeUI.contentWidth * 0.68, powercubeUI.contentHeight * 0.30)
	powercubeBar.isVisible = false
    powercubeBar.fullWidth = powercubeUI.contentWidth * 0.76
    powercubeBar.anchorX = 1
    uiGroup:insert(powercubeBar)
    
    local nameEditGroup = display.newGroup()
    uiGroup:insert(nameEditGroup)
    
    local texboxOptions = {
        backgroundImage = assetPath .. "name.png",
        backgroundScale = 1,
        fontSize = 32,
        font = settings.fontName,
        inputType = "text",
        color = { default = { 1, 1, 1 }, selected = { 1, 1, 1}, placeholder = {1, 1, 1} },
        placeholder = "",
        --onComplete = savePlayerInfo,
        --offsetText = {x = 30, y = -20},
    }
    
    nameTextbox = textbox.new(texboxOptions)
    nameTextbox.x = display.contentCenterX * 0.85
    nameTextbox.y = (nameTextbox.contentHeight * 0.6)
    nameEditGroup:insert(nameTextbox)
    
    local buttonInfo = buttonList.edit
    buttonInfo.onRelease = function()
        native.setKeyboardFocus(nameTextbox)
    end
    
    local buttonEdit = widget.newButton(buttonInfo)
    buttonEdit.x = nameTextbox.x + (nameTextbox.contentWidth * 0.48)
    buttonEdit.y = nameTextbox.y 
    nameEditGroup:insert(buttonEdit)
    
    local coinGroup = display.newGroup()
    uiGroup:insert(coinGroup)
    
    local coinAsset = display.newImage(assetPath .. "coin.png")
    coinAsset.x = display.contentWidth * 0.85
    coinAsset.y = coinAsset.contentHeight * 0.60
    coinGroup:insert(coinAsset)
    
    coinText = display.newText("0", coinAsset.x + (coinAsset.contentWidth * 0.10), coinAsset.y, settings.fontName, 36)
    coinGroup:insert(coinText)
    
    buttonGoLevelGroup = display.newGroup()
	
    local buttonInfo = buttonList.gobattle
    buttonInfo.onRelease = gotoLevel
    buttonGoLevel = widget.newButton(buttonInfo)
	buttonGoLevel.isVisible = false
    buttonGoLevel.x = 0
    buttonGoLevel.y = 0
    buttonGoLevelGroup:insert(buttonGoLevel)
    
    local levelCost = display.newText("-" .. LEVEL_COST, 0, buttonGoLevel.contentHeight * -0.29, settings.fontName, 38)
    buttonGoLevelGroup.cost = levelCost
    buttonGoLevelGroup:insert(levelCost)
    
    buttonGoLevelGroup.x = display.contentWidth - (buttonGoLevelGroup.contentWidth * 0.5)
    buttonGoLevelGroup.y = display.contentHeight - (buttonGoLevelGroup.contentHeight * 0.4)
    
    uiGroup:insert(buttonGoLevelGroup)
    
    buttonPowercubesGroup = display.newGroup()
	buttonPowercubesGroup.isVisible = false
    local buttonInfo = buttonList.powercubes
    buttonInfo.onRelease = getPowercubes
    buttonPowercubes = widget.newButton(buttonInfo)
    buttonPowercubes.x = 0
    buttonPowercubes.y = 0
    buttonPowercubesGroup:insert(buttonPowercubes)
    
    local textInfo = {
        text = "Obtener más" .. "\n" .. "Powercubes",
        width = buttonPowercubes.contentWidth * 0.80,
        height = buttonPowercubes.contentHeight,
        font = settings.fontName,
        align = "center",
        fontSize = 22
    }
	
    local buttonText = display.newEmbossedText(textInfo)
	buttonPowercubesGroup.message = buttonText
    buttonText.x = buttonPowercubes.contentWidth * 0.14
    buttonText.y = buttonPowercubes.contentHeight * 0.29
	buttonPowercubesGroup.message = buttonText
    buttonPowercubesGroup:insert(buttonText)
    
    buttonPowercubesGroup.x = powercubeUI.x + (powercubeUI.contentWidth  * 0.5) + (buttonPowercubes.contentWidth * 0.15)
    buttonPowercubesGroup.y = display.contentHeight - (powercubeUI.contentHeight * 0.5)
	
	
    uiGroup:insert(buttonPowercubesGroup)
    
    local buttonInfo = buttonList.back
    buttonInfo.onRelease = function()
		director.gotoScene("scenes.menus.home",{time = 400, effect = "fade"})
        --director.hideOverlay()
		--map.updateYogotar(currentYogotarType, currentSelectedYogotar, currentHat)
    end
	
    buttonBack = widget.newButton(buttonInfo)
    buttonBack.x = display.screenOriginX + (buttonBack.contentWidth * 0.5)
    buttonBack.y = display.screenOriginY + (buttonBack.contentHeight * 0.5)
    uiGroup:insert(buttonBack)
	
	uiGroup.powercubes = {}
	for powercubesIndex = 1, 7 do
		
		local powercube = display.newImage("images/selecthero/popup/powercube1.png")
		powercube:scale(0.3, 0.3)
		uiGroup.powercubes[powercubesIndex] = powercube
		uiGroup:insert(powercube)
	end

end

local function animateUI()
    transition.from(animatedCircle, {alpha = 0, xScale = 1.5, yScale = 1.5})
	transition.from(uiGroup, {x = display.contentCenterX, xScale = 10, alpha = 0, time = 350})
	transition.from(selectPanelGroup, {xScale = 3, alpha = 0, time = 500, onComplete = function()
		if selectedStroke.isVisible then
			transition.to(selectedStroke, {time = 200, alpha = 1})
		end
	end})
	animationGroup.isVisible = true
	uiGroup.isVisible = true
	selectPanelGroup.isVisible = true
end

local function showpopup()
	scene.disableButtons()
	popupGroup.isVisible = true
        
        
	local barUnits = powercubeBar.fullWidth / 300
	powercubeBar.width = (currentPowercubes - earnedCubes) * barUnits
	powercubeText.text = currentPowercubes - earnedCubes
	transition.to(popupGroup, {x = display.contentCenterX, y = display.contentCenterY, time = 300, transition = easing.outBounce})
end

local function animateScene(params)
	
	timer.performWithDelay(2000, function()
		sound.play("yogotarBrake")
	end)	
    local transitionOffset = 0
	--Uncomment this code to add animation to backgrounds
--    for indexLayer = 1, 1 do
--        local randomSign = (math.random(1,2) * 2) - 3
--        local currentBackground = backgroundGroup.backgrounds[indexLayer]
--        transition.from(currentBackground, {time =  250, alpha = 0, transition = easing.inSine, delay = transitionOffset, x = display.contentCenterX + (currentBackground.contentWidth * randomSign)})
--        transitionOffset = transitionOffset + 200
--    end
--	
	timer.performWithDelay(transitionOffset, function()
		yogotar.group.isVisible = true
		
		yogotar.newAnimationState()
		yogotar:setAnimation("RAGERUN", false)
		
		local animationParams = {
			actions = {"SLIDE", "IDLE2"},
			delays = {0,0}
		}

		yogotar.setAnimationStack(animationParams)
		
		yogotar.group.x = display.screenOriginX - display.contentWidth * 0.55
		timer.performWithDelay(1500, function()
			sound.play("brake")
		end)
		transition.to(yogotar.group, {x = display.contentWidth * 0.75, time = 2000, onComplete = function()
			animateUI()
				
--			if currentPowercubes <= 0 and not dataSaver:getShownTutorial(1) then
--				dataSaver:setShownTutorial(1)
--				scene.disableButtons()
--				buttonPowercubes:setEnabled(true)
--				tutorialGroup = tutorial.showHighlightTip(
--					buttonPowercubesGroup, localization.getString("tutorialPowercubes"),
--					buttonPowercubesGroup.x, buttonPowercubesGroup.y + buttonPowercubesGroup.contentHeight * -0.85,
--					buttonPowercubesGroup.x + buttonPowercubesGroup.contentWidth * 0.05, buttonPowercubesGroup.y)
--				uiGroup:insert(tutorialGroup)
--			end
--			
--			if not dataSaver:getShownTutorial(2) then
--				showTutorial = true
--				scene.disableButtons()
--				tutorialGroup = tutorial.showHighlightTip(
--				upgradeGroup, localization.getString("tutorialUpgrade"), 
--				upgradeGroup.x,upgradeGroup.y + upgradeGroup.contentHeight * 1.55,
--				upgradeGroup.x + upgradeGroup.contentWidth * 0.07, upgradeGroup.y + upgradeGroup.contentWidth * 0.02)
--				uiGroup:insert(tutorialGroup)
--			end
			
			if params.fromManager and params.gotPowercubes and earnedCubes > 0 then
				showpopup()
			end
			
		end})
	end)
	
end

local function setPowercubesBar()
    
    local barUnits = powercubeBar.fullWidth / 300
    local newSize = currentPowercubes * barUnits
    
--    local redColor = 1 - ((1/300) * currentPowercubes)
--    local greenColor = (0.4 / 300) * currentPowercubes
--    local blueColor = (currentPowercubes / 300)
--    powercubeBar:setFillColor(redColor, greenColor, blueColor)
    powercubeBar:setFillColor(0, 0.4, 1)
    
    powercubeBar.width = newSize
end

local function initialize(params)
    panels = {}
	
    earnedCubes = earnedCubes or 0
    playerUnlockedHats = dataSaver:getUnlockedHats()
    playerUnlockedYogotars = dataSaver:getUnlockedYogotars()
	playerUnlockedShips = dataSaver:getUnlockedShips()
    playerInventoryYogotars = dataSaver:getInventoryYogotars()
    playerInventoryHats = dataSaver:getInventoryHats()
	playerInventoryShips = dataSaver:getInventoryShips()
	
    currentYogotarType = dataSaver:getYogotarType()
    currentHat = dataSaver:getCurrentHat()
    currentSelectedYogotar = dataSaver:getCurrentYogotar()
    currentCoins = dataSaver:getCoins()
    currentPowercubes = dataSaver:getPowercubes()
    currentPlayerLevel = dataSaver:getCurrentLevel()
	currentShip = dataSaver:getCurrentShip()
	showTutorial = false
	
    powercubeText.text = currentPowercubes
    nameTextbox.text.text = dataSaver:getName()
    coinText.text = currentCoins
    animatedCircle.rotation = 0
    animatedCircle.xScale = 1
    animatedCircle.yScale = 1
    animatedCircle.alpha = 1
    isAnimatingBar = false
    selectedStroke.alpha = 0
	

    --local attack = upgrader.calculateAttack(currentPlayerLevel)
    --local hp = upgrader.calculateHP(currentPlayerLevel)
    --upgradePrice = upgrader.calculateNextCost(currentPlayerLevel)

    --upgradeGroup.hpText.text = "Health: " .. hp
    --upgradeGroup.attackText.text = "Power: " .. attack
--    upgradeGroup.levelText.text = currentPlayerLevel
	for indexShip = 1, #shipGroup.ships do
		shipGroup.ships[indexShip].isVisible = false
	end

	shipGroup.ships[currentShip].isVisible = true
    yogotar.group.isVisible = false
    selectPanelGroup.isVisible = false
    uiGroup.isVisible = false
    animationGroup.isVisible = false
    buyButtonGroup.isVisible = false
    popupGroup.isVisible =  false

    --buttonPowercubesGroup.message.text = localization.getString("getMore") .. "\n" .. "Powercubes"

    buttonGoLevelGroup.button = buttonGoLevel
    buttonGoLevel.isVisible = true

    for indexPowercube = 1, #uiGroup.powercubes do
        popupGroup.button:setEnabled(true)
        local currentPowercube = uiGroup.powercubes[indexPowercube]
        currentPowercube.alpha = 0
        currentPowercube.isVisible = false
    end
	

    if params.fromManager then
            popupGroup.isVisible = true
            popupGroup.alpha = 1
            popupGroup.x = display.contentCenterX
            popupGroup.y = display.screenOriginY - (popupGroup.contentHeight * 0.5)
    end


    Runtime:addEventListener("enterFrame", updateGame)
    yogotar:setSkin(herolist[currentYogotarType][currentSelectedYogotar].skinName)
    yogotar:setNewAttachment(hatlist[currentHat].name, "hat")
	
    transition.to(animatedCircle, {tag = "animatedCircle", time = 7000, rotation = 360, iterations = -1})
	
end

local function createPopup()
	
	local image = display.newImage("images/selecthero/popup/window.png")
	popupGroup:insert(image)
	
	local textParams = {
		width = image.contentWidth * 0.7,
		text = "You have won:\n38\nPowercubes",
		fontSize = 52,
		x = image.contentWidth * 0.12,
		y = image.contentHeight * -0.05,
		font = settings.fontName,
		align = "center",
	}
	
	local confirmButtonInfo = extratable.deepcopy(buttonList.ok)
	confirmButtonInfo.onRelease = function(event)
		scene.enableButtons()
		popupGroup.button:setEnabled(false)
		local barUnits = powercubeBar.fullWidth / 300
		local newSize = currentPowercubes * barUnits

		isAnimatingBar = true

		if newSize <= 0 then
			newSize = 0
		end
		
		local delay = 50
		for indexPowercube = 1, #uiGroup.powercubes do
			local currentPowercube = uiGroup.powercubes[indexPowercube]
			
			currentPowercube.isVisible = true
                        
			currentPowercube.x = image.contentWidth * -0.21
			currentPowercube.y = image.contentHeight * -0.07
                        currentPowercube.xScale = 0.2
			currentPowercube.yScale = 0.2
                        currentPowercube.alpha = 0
                        popupGroup:insert(currentPowercube)	
                    
                        transition.to(currentPowercube, {delay = delay * indexPowercube, xScale = 1.2, yScale = 1.2, alpha =1, time = 300, transition = easing.outBounce, onComplete = function()
                            local x, y = popupGroup:contentToLocal(buttonPowercubesGroup.x, buttonPowercubesGroup.y)
                            transition.to(currentPowercube, {xScale = 0.2, yScale = 0.2, x = x - buttonPowercubesGroup.contentWidth * 0.10, y = y, alpha = 0, onComplete = function()
                                
                            end})
                            
                        end})
				--transition.from(currentPowercube, {delay = 75 * indexPowercube, time = 250, x = popupGroup.x + popupGroup.contentWidth * -0.15, y = popupGroup.y, alpha = 0, onComplete = function()
				--	sound.play("scoreGiven")
				--	transition.to(currentPowercube, {time = 100, x = currentPowercube.x + 10, y = currentPowercube.y, alpha = 0})
				--end})
		end
		
		transition.to(powercubeBar, {width = newSize, time = 1000, onComplete = function()
			powercubeText.text = currentPowercubes
			powercubeBar:setFillColor(0, 0.4, 1)
			isAnimatingBar = false
                        transition.to(popupGroup, {time = 300, alpha = 0, onComplete = function()
                            popupGroup.isVisible = false
                        end})
		end})
	end
	local confirmButton = widget.newButton(confirmButtonInfo)
        popupGroup.button = confirmButton
	popupGroup:insert(confirmButton)
	confirmButton.x = 0
	confirmButton.y = image.contentHeight * 0.28	
	
	local popupText = display.newEmbossedText(textParams)
	popupGroup.message = popupText
	popupGroup:insert(popupText)
end

local function createShips()
	
	shipGroup.ships = {}
	for indexShip = 1, #shiplist do
		
		local ship = display.newImage(shiplist[indexShip].iconPath)
		ship.isVisible = false
		shipGroup.ships[indexShip] = ship
		shipGroup:insert(ship)
		
	end
	
	shipGroup.x = yogotar.group.x * 0.80
	shipGroup.y = yogotar.group.y * 0.30
	
end

local function animateShip()
	
	transition.to(shipGroup, {tag = "SHIP", time = 1000, y = shipGroup.y + 25, transition = easing.inOutQuad, onComplete = function()
		transition.to(shipGroup, {tag = "SHIP", time = 1000, y = shipGroup.y - 25, transition = easing.inOutQuad, onComplete = function()
			animateShip()
		end})
	end})

end
----------------------------------------------- Module functions
function scene.enableButtons()
    buttonPowercubes:setEnabled(true)
	buttonGoLevel:setEnabled(true)
    buttonBack:setEnabled(true)
end

function scene.disableButtons()
    buttonPowercubes:setEnabled(false)
	buttonGoLevel:setEnabled(false)
    buttonBack:setEnabled(false)
end

function scene:create(event)
    local sceneGroup = self.view
    
    backgroundGroup = display.newGroup()
    selectPanelGroup = display.newGroup()
    heroPreviewGroup = display.newGroup()
    animationGroup = display.newGroup()
    yogotarGroup = display.newGroup()
	shipGroup = display.newGroup()
    uiGroup = display.newGroup()
	popupGroup = display.newGroup()
    
    sceneGroup:insert(backgroundGroup)
    sceneGroup:insert(selectPanelGroup)
    sceneGroup:insert(heroPreviewGroup)
    sceneGroup:insert(animationGroup)
    sceneGroup:insert(yogotarGroup)
	sceneGroup:insert(shipGroup)
    sceneGroup:insert(uiGroup)
	sceneGroup:insert(popupGroup)
    
    createSelectorPanel()
    createPageButtons()
    createYogotar()
	createShips()
    createAnimatedInterface()
    createUI()
	createPopup()
	
end


function scene:destroy()
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	local params = event.params or {levelCost = 10, world = 1, level = 1}
	
	if ( phase == "will" ) then
		dataSaver:initialize()
		parent = event.parent
		currentWorld = params.world or 1
		currentLevel = params.level or 1
		createBackground(currentWorld)
		
		initialize(event.params)
		createItems()
		hideAllLayers()
		setActiveTab(currentYogotarType)
		showPage()
		setPowercubesBar()
		
	elseif ( phase == "did" ) then
		music.playTrack(2, 200)
		scene.enableButtons()
		
		animateScene(params)
		animateShip()
		
--		if currentPowercubes < 25 then
--			buttonGoLevel:setEnabled(false)
--			buttonGoLevelGroup.button:setFillColor(0.5)
--			buttonGoLevelGroup.cost:setFillColor(0.7,0,0)
--		else
--			buttonGoLevel:setEnabled(true)
--			buttonGoLevelGroup.button:setFillColor(1)
--			buttonGoLevelGroup.cost:setFillColor(1)
--		end
		
		
		
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if ( phase == "will" ) then
		
		local transitionOffset = 0
		for indexLayer = 1, 1 do
			local randomSign = (math.random(1,2) * 2) - 3
			local currentBackground = backgroundGroup.backgrounds[indexLayer]
                transition.to(currentBackground, {time =  500, transition = easing.inSine, delay = transitionOffset, x = display.contentCenterX + (currentBackground.contentWidth * randomSign), onComplete = function()
					display.remove(currentBackground)
					currentBackground = nil
			end})
			transitionOffset = transitionOffset + 200
		end
		transition.cancel(animatedCircle)
		
	elseif ( phase == "did" ) then
		Runtime:removeEventListener("enterFrame", updateGame)
		dataSaver:setYogotarType(currentYogotarType)
		dataSaver:setCurrentYogotar(currentSelectedYogotar)
		dataSaver:setCurrentHat(currentHat)
		
		transition.cancel("SHIP")
		
		uiGroup:insert(buttonPowercubesGroup)
		display.remove(tutorialGroup)
		
		for indexPanel = 1, #panels do
			for indexPage = 1, #panels[indexPanel] do
				display.remove(panels[indexPanel][indexPage])
			end
		end
		
	end
end

----------------------------------------------- Execution
scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "show", scene )

return scene


