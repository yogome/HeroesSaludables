-------------------------------------------- Dialog
local path = ...
local folder = path:match("(.-)[^%.]+$") 
local director = require( folder.."director" ) 

local dialog = {}
------------------------------------------- Constants
local alertWidth = 512
local alertHeight = 256 
local padding = 16
------------------------------------------- Class functions
function dialog.newAlert(options)
	options = options or {}
	if not options then
		error("options must not be nil.", 3)
	end
	
	options.text = options.text or "This is the default alert text."
	if not options.text then
		error("text must not be nil.", 3)
	end
	
	options.time = options.time or 1000
	if not "number" == type(options.time) then
		error("time must be a number.", 3)
	end
	
	local dialog = display.newGroup()
	dialog.x = display.contentCenterX
	dialog.y = display.contentCenterY
	dialog.alpha = 0
	
	local touchCatcher = display.newRect(0, 0, display.viewableContentWidth + 2, display.viewableContentHeight + 2)
	touchCatcher:setFillColor(0,0.5)
	touchCatcher:addEventListener( "tap", function() return true end)
	touchCatcher:addEventListener( "touch", function() return true end)
	dialog:insert(touchCatcher)
	
	local background = display.newRect(0, 0, alertWidth, alertHeight)
	background:setFillColor(0.1)
	dialog:insert(background)
	
	local textOptions = {
		x = 0,
		y = 0,
		width = alertWidth - padding * 2,
		align = "center",
		text = options.text,
		fontSize = 50,
	}
	
	local alertText = display.newText(textOptions)
	alertText:setFillColor(1)
	dialog:insert(alertText)
	
	director.stage:insert(dialog)
	
	local introTime = math.ceil(options.time * 0.1)
	local realTime = math.ceil(options.time * 0.8)
	local outroTime = math.ceil(options.time * 0.1)
	
	dialog.introTransition = transition.to(dialog, {time = introTime, alpha = 1, transition = easing.outQuad})
	dialog.outroTransition = transition.to(dialog, {delay = introTime + realTime, time = outroTime, alpha = 0.0005, transition = easing.outQuad, onComplete = function()
		transition.cancel(dialog.introTransition)
		transition.cancel(dialog.outroTransition)
		dialog.introTransition = nil
		dialog.outroTransition = nil
		
		display.remove(dialog)
		dialog = nil
	end})
end

return dialog
