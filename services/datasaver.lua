local players = require("models.players")

local dataSaver = {}
dataSaver.currentPlayer = {}

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

function dataSaver:getFirstTime()
	return self.currentPlayer.isFirstTimePlay
end

function dataSaver:setCoins(coins)
    if coins then
        self.currentPlayer.coins = coins
        players.save(self.currentPlayer)
    end
end

function dataSaver:addCoins(coinsToAdd)
    if coinsToAdd then
        self.currentPlayer.coins = self.currentPlayer.coins + coinsToAdd
        players.save(self.currentPlayer)
    end
end

function dataSaver:getCoins()
    return self.currentPlayer.coins
end

function dataSaver:setName(name)
    self.currentPlayer.name = name
    players.save(self.currentPlayer)
end

function dataSaver:getName()
    return self.currentPlayer.name
end

function dataSaver:setPowercubes(powerCubes)
	if powerCubes <= 300 and powerCubes >= 0 then
		self.currentPlayer.powerCubes = powerCubes
		players.save(self.currentPlayer)
	end
end

function dataSaver:addPowercubes(powerCubes)
	local currenPowercubes = self.currentPlayer.powerCubes
	if currenPowercubes + powerCubes >= 300 then
		self.currentPlayer.powerCubes = 300
	else
		self.currentPlayer.powerCubes = currenPowercubes + powerCubes
	end
    players.save(self.currentPlayer)
end

function dataSaver:getPowercubes()
    return self.currentPlayer.powerCubes
    
end

function dataSaver:getKeys()
    return self.currentPlayer.keys
end

function dataSaver:setCurrentHat(hatId)
    self.currentPlayer.hatId = hatId
    players.save(self.currentPlayer)
end

function dataSaver:getCurrentHat()
    return self.currentPlayer.hatId
end

function dataSaver:setCurrentYogotar(yogotarId)
    if type(yogotarId) == "number" then
        self.currentPlayer.yogotarId = yogotarId
        players.save(self.currentPlayer)
    end
end

function dataSaver:getCurrentYogotar()
    return self.currentPlayer.yogotarId
end

function dataSaver:getYogotarType()
    return self.currentPlayer.yogotarType
end

function dataSaver:setYogotarType(typeId)
    if type(typeId) == "number" then
        self.currentPlayer.yogotarType = typeId
        players.save(self.currentPlayer)
    end
end

function dataSaver:setCurrentBundle(bundleId)
    self.currentPlayer.bundleId = bundleId
    players.save(self.currentPlayer)
end

function dataSaver:getCurrentBundle()
    return self.currentPlayer.bundleId
end

function dataSaver:unlockYogotar(type, yogotarId)
    local unlockedYogotars = self.currentPlayer.unlockedYogotars
    if not searchValueOnTable(yogotarId, unlockedYogotars[type]) then
        table.insert(self.currentPlayer.unlockedYogotars[type], yogotarId)
    end
    players.save(self.currentPlayer)
end

function dataSaver:getUnlockedYogotars()
    return self.currentPlayer.unlockedYogotars
end

function dataSaver:setInventoryYogotar(type, yogotarId)
    local inventoryYogotar = self.currentPlayer.playerYogotars
    if not searchValueOnTable(yogotarId, inventoryYogotar[type]) then
        table.insert(self.currentPlayer.playerYogotars[type], yogotarId)
    end
    players.save(self.currentPlayer)
end

function dataSaver:getInventoryYogotars()
    return self.currentPlayer.playerYogotars
end

function dataSaver:setInventoryHat(hatId)
    local inventoryYogotar = self.currentPlayer.playerHats
    if not searchValueOnTable(hatId, inventoryYogotar) then
        table.insert(self.currentPlayer.playerHats, hatId)
    end
    players.save(self.currentPlayer)
end

function dataSaver:getInventoryHats()
    return self.currentPlayer.playerHats
end

function dataSaver:unlockHat(hatId)
    local hatsUnlocked = self.currentPlayer.hatsUnlocked
    if not searchValueOnTable(hatId, hatsUnlocked) then
        table.insert(self.currentPlayer.hatsUnlocked, hatId)
    end
    players.save(self.currentPlayer)
end

function dataSaver:getUnlockedHats()
    return self.currentPlayer.hatsUnlocked
end

function dataSaver:unlockLevel(world, level)
    local unlockedLevels = self.currentPlayer.unlockedWorlds
    if unlockedLevels[world] then
		if unlockedLevels[world].unlocked then
			if not unlockedLevels[world].levels[level] then
				unlockedLevels[world].levels[level] = {unlocked = true, stars = 0}
			end
		end
	end
    players.save(self.currentPlayer)
end

function dataSaver:setStars(world, level, stars)
	local unlockedLevels = self.currentPlayer.unlockedWorlds
	
    if unlockedLevels[world] then
		if unlockedLevels[world].unlocked then
			if unlockedLevels[world].levels[level] then
				local currentStars = unlockedLevels[world].levels[level].stars
				if (stars > 0) and (stars > currentStars) and (stars <= 3) then
					unlockedLevels[world].levels[level].stars = stars
				end
			end
		end
	end
	
    players.save(self.currentPlayer)
end

function dataSaver:getUnlockedLevels()
    return self.currentPlayer.unlockedLevels
end

function dataSaver:clearLevel(world, level)
    local clearedLevels = self.currentPlayer.clearedLevels
    
    if clearedLevels[world] then
        if not searchValueOnTable(level, clearedLevels[world]) then
            table.insert(self.currentPlayer.clearedLevels[world], level)
        end
    else
        --table.insert(self.currentPlayer.clearedLevels, world)
	self.currentPlayer.clearedLevels[world] = {}
        table.insert(self.currentPlayer.clearedLevels[world], level)
    end
    
    players.save(self.currentPlayer)
end

function dataSaver:getClearedLevels()
    return self.currentPlayer.clearedLevels
end

function dataSaver:setFirstTimePlay(firstTime)
    if type(firstTime) == "boolean" then
        self.currentPlayer.isFirstTimePlay = firstTime
        players.save(self.currentPlayer)
    end
end

function dataSaver:getFirstTimePlay()
    return self.currentPlayer.isFirstTimePlay
end

function dataSaver:getCurrentLevel()
	return self.currentPlayer.playerLevel
end

function dataSaver:setCurrentLevel(level)
	self.currentPlayer.playerLevel = level
	 players.save(self.currentPlayer)
end

function dataSaver:setShownTutorial(tutorialId)
	if tutorialId == 1 then
		self.currentPlayer.tutorialPowercubes = true
	elseif tutorialId == 2 then
		self.currentPlayer.tutorialUpgrade = true
	elseif tutorialId == 3 then
		self.currentPlayer.tutorialLevel = true
	end
	 players.save(self.currentPlayer)
end

function dataSaver:getShownTutorial(tutorialId)
	local currentTutorial = nil
	if tutorialId == 1 then
		currentTutorial = self.currentPlayer.tutorialPowercubes
	elseif tutorialId == 2 then
		currentTutorial = self.currentPlayer.tutorialUpgrade
	elseif tutorialId == 3 then
		currentTutorial = self.currentPlayer.tutorialLevel
	end
	return currentTutorial
end

function dataSaver:getCurrentShip()
	return self.currentPlayer.shipIndex
end

function dataSaver:setCurrentShip(index)
	if index then
		self.currentPlayer.shipIndex = index
	end
end

function dataSaver:getUnlockedShips()
	return self.currentPlayer.shipsUnlocked
end

function dataSaver:setUnlockedShip(shipId)
	local unlockedShips = self.currentPlayer.shipsUnlocked
	
	if shipId then
		 if not searchValueOnTable(shipId, unlockedShips) then
            table.insert(self.currentPlayer.unlockedShips, shipId)
        end
	end
end

function dataSaver:getInventoryShips()
	return self.currentPlayer.playerShips
end

function dataSaver:setInventoryShip(shipId)
	
	local inventoryShips = self.currentPlayer.playerShips
	
	if shipId then
		 if not searchValueOnTable(shipId, inventoryShips) then
            table.insert(self.currentPlayer.playerShips, shipId)
        end
	end
	
end

function dataSaver.initialize()
    dataSaver.currentPlayer = players.getCurrent()
end


return dataSaver

