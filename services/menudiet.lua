local menulist = "data.menulist"
local menudiet = {}

local rangeList = {
	[1] = 1200,
	[2] = 1300,
	[3] = 1400,
	[4] = 1500,
	[5] = 1600,
	[6] = 1700,
	[7] = 1800,
	[8] = 1900,
	[9] = 2000,
	[10] = 2100,
	[11] = 2200,
	[12] = 2300,
	[13] = 2400,
	[14] = 2500,
}

function menudiet.getMenu(kcal)
	
	local selectedRange = nil
	for indexRange = 1, #rangeList do
		local currentRange = rangeList[indexRange]
		if currentRange <= currentRange then
			selectedRange
			break;
		end
	end
	
	if selectedRange then
		return menulist[selectedRange]
	else
		return nil
	end
end

return menudiet