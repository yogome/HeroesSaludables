local dataSaver = require ("services.datasaver")

local  upgrader = {}
local MAX_LEVEL = 50
local BASE_ATTACK = 8
local BASE_HP = 100
local BASE_PRICE = 250

function upgrader.calculateEnemyAttack(level)
	if level >= 1 and level <= 20 then
		local BASE_ATTACK = 20
		local attack = math.floor(BASE_ATTACK + (BASE_ATTACK * (0.10 * (level - 3))) + 0.5)
		return attack
	end
end

function upgrader.calculateEnemyHP(level)
	
	if level >= 1 and level <= 20 then
		local BASE_HP = 120
		local hp = math.floor(BASE_HP + (BASE_HP * (0.10 * (level - 3))) + 0.5)
		return hp
	end
	
end

function upgrader.calculateNextCost(level)
	if level >= 1 and level <= 50 then
		local price = BASE_PRICE * level
		return price
	else
		return 0
	end
end

function upgrader.calculateAttack(level)
	if level >= 1 and level <= 50 then
		local attack = math.floor(BASE_ATTACK + (BASE_ATTACK * (0.10 * (level - 1))) + 0.5)
		return attack
	else
		return 0
	end
end

function upgrader.calculateHP(level)
	
	if level >= 1 and level <= 50 then
		local hp = math.floor(BASE_HP + (BASE_HP * (0.10 * (level - 1))) + 0.5)
		return hp
	else
		return 0
	end
end

function upgrader.levelUp()
	dataSaver:initialize()
	local currentLevel = dataSaver:getCurrentLevel()
	if currentLevel >= 1 and currentLevel <= 50 then
		dataSaver:setCurrentLevel(currentLevel + 1)
	end
	return dataSaver:getCurrentLevel()
end


return upgrader