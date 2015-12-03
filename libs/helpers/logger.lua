---------------------------------------------- Logger
local json = require( "json" ) 
local logger = {}
---------------------------------------------- Variables
---------------------------------------------- Constants
---------------------------------------------- Functions
function logger.log(message)
	if logger.enabled then
		if "table" == type(message) then
			print(json.prettify(json.encode(message)))
		else
			print(tostring(message))
		end
	end
end

function logger.error(message)
	print(message)
end

return logger
