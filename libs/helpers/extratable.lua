-------------------------------------------- Extra table functions
local extratable = {}
-------------------------------------------- Functions
-------------------------------------------- Module functions
function extratable.deepcopy(originalTable)
	local typeOriginal = type(originalTable)
	local copyTable
	if typeOriginal == "table" then
		copyTable = {}
		for key, value in next, originalTable, nil do
			copyTable[extratable.deepcopy(key)] = extratable.deepcopy(value)
		end
		setmetatable(copyTable, extratable.deepcopy(getmetatable(originalTable)))
	else
		copyTable = originalTable
	end
	return copyTable
end

function extratable.shuffle(tab)
	local numberElements, order, resultTable = #tab, {}, {}
	
	for index = 1,numberElements do
		order[index] = { rnd = math.random(), idx = index }
	end
	
	table.sort(order, function(a,b)
		return a.rnd < b.rnd 
	end)
	
	for index = 1,numberElements do
		resultTable[index] = tab[order[index].idx]
	end
	return resultTable
end

function extratable.sortDescByKey(tab, keyName)
	local function compare(a,b)
		return a[keyName] > b[keyName]
	end
	table.sort(tab, compare)
end

function extratable.sortAscByKey(tab, keyName)
	local function compare(a,b)
		return a[keyName] < b[keyName]
	end
	table.sort(tab, compare)
end

function extratable.isEmpty(tab)
	return next(tab) == nil
end

function extratable.merge(t1, t2)
	t1 = t1 or {}
	for key, value in pairs(t2) do
		if type(value) == "table" and type(t1[key] or false == "table") then
			t1[key] = extratable.merge(t1[key], t2[key])
		else
			t1[key] = value
		end
	end
	return t1
end

function extratable.contains(tab, value)
	for index = 1, #tab do
		if tab[index] == value then
			return true
		end
	end
	return false
end

function extratable.getRandom(t1, count)
	local function permute(tab, n, count)
		n = n or #tab
		for i = 1, count or n do
			local j = math.random(i, n)
			tab[i], tab[j] = tab[j], tab[i]
		end
		return tab
	end

	local meta = {
		__index = function (self, key)
			return key
		end
	}
	local function getInfiniteTable() return setmetatable({}, meta) end

	local randomIndices = {unpack(permute(getInfiniteTable(), #t1, count), 1, count)}
	
	local randomNewTable = {}
	for index = 1, #randomIndices do
		randomNewTable[index] = extratable.deepcopy(t1[randomIndices[index]])
	end
	return randomNewTable
end

return extratable
