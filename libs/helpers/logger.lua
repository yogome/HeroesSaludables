---------------------------------------------- Logger
local json = require( "json" ) 

local logger = {
	enabled = true,
}
---------------------------------------------- Variables
local globalMonitorEnabled 

---------------------------------------------- Constants
---------------------------------------------- Functions
local function printTable(luaTable)
	print(json.prettify(json.encode(luaTable)))
end 

function logger.log(message)
	if logger.enabled then
		if "table" == type(message) then
			printTable(message)
		elseif "string" == type(message) or "number" == type(message) then
			print(message)
		else
			logger.error("[Logger] message must be a string or a table")
		end
	end
end

function logger.error(message)
	if logger.enabled then
		pcall(function()
			error(message)
		end)
	end
end

function logger.monitorGlobals()
	if debug and debug.traeback and not globalMonitorEnabled then
		globalMonitorEnabled = true
		local function globalWatch(g, key, value)
			logger.log("[Logger] Global "..tostring(key).." has been added to _G\n"..debug.traceback())
			rawset(g, key, value)
		end
		setmetatable(_G, { __index = globalWatch })
	end
end

return logger
