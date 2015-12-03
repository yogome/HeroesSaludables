
local path = ...
local folder = path:match("(.-)[^%.]+$") 
local logger = require( folder.."logger" )

local extraString = {}

function extraString.split(inputstr, separator)
	if separator == nil then
		separator = "%s"
	end
	local result = {}
	local iteration = 1
	for str in string.gmatch(inputstr, "([^"..separator.."]+)") do
		result[iteration] = str
		iteration = iteration + 1
	end
	return result
end

function extraString.firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

return extraString
