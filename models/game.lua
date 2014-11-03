----------------------------------------------- Game model
local mixpanel = require( "libs.helpers.mixpanel" )

local game = {}
----------------------------------------------
function game.create(version, exec)
	if version < 1 then
		local createPlayers = [[CREATE TABLE IF NOT EXISTS players (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			data TEXT);]]
		exec(createPlayers)
		mixpanel.logEvent("installed")
		version = 1
	end
	if version < 2 then
		--version = 2
	end
	return version
end

return game