local settings = require( "settings" )
local widget = require("widget")
local buttonList = require("data.buttonlist")

local tutorial={}

function tutorial.showTip(textToDisplay)
    local group_tutorial_tip=display.newGroup()

    local tuto_tip=display.newImage("images/tutorial_ui/bar_01.png")
    tuto_tip:scale(0.7,0.7)
    group_tutorial_tip:insert(tuto_tip)

    local tuto_master=display.newImage("images/tutorial_ui/t-master.png")
    tuto_master:scale(0.6,0.6)
    group_tutorial_tip:insert(tuto_master)
    tuto_master.x=0-tuto_tip.width/3

    --[[local buttonOk=buttonList.ok
    buttonOk.onRelease=function()
	display.remove(group_tutorial_tip)
    end
    local tuto_ok=widget.newButton(buttonOk)
    tuto_ok:scale(0.7,0.7)
    tuto_ok.x=tuto_tip.width/3
    group_tutorial_tip:insert(tuto_ok)]]--

	local textInfo = {
		text = textToDisplay,
		font = settings.fontName,
		fontSize = 32,
		align = "left",
		x = -tuto_tip.width/4,
		y = 0,
		width = tuto_tip.width * 0.80
	}

    local tuto_text=display.newText(textInfo)
    tuto_text:setFillColor(1)
    tuto_text.anchorX=0
    group_tutorial_tip:insert(tuto_text)
    
    --group_tutorial_tip.anchorChildren=true; group_tutorial_tip.anchorY=1
    --group_tutorial_tip.x=display.contentCenterX ; group_tutorial_tip.y=display.contentHeight
    
    return group_tutorial_tip
end

function tutorial.showHighlightTip(displayObject, message, messagex, messagey, handx, handy)
	
	local tutorialGroup = display.newGroup()
	
	local spriteData = {width=256, height=256, numFrames=6, sheetContentWidth=1024, sheetContentHeight=512}
	local handSprite = graphics.newImageSheet("images/manoTuto.png",spriteData)
	
	local handData = {
		start=1,
		count=2,
		time=1000,
		loopCount=0,
	}
	
	local hand = display.newSprite(handSprite, handData)
	hand.xScale=0.5
	hand.yScale=0.5
	
	hand:play()
	
	local blackOverlay = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	blackOverlay:setFillColor(0, 0.5)
	tutorialGroup:insert(blackOverlay)
	
	local messageBox = tutorial.showTip(message)
	messageBox.x = messagex
	messageBox.y = messagey 
	tutorialGroup:insert(messageBox)
	
	tutorialGroup:insert(displayObject)
	
	hand.x = handx --displayObject.x + displayObject.contentWidth * 0.5
	hand.y = handy --displayObject.y
	tutorialGroup:insert(hand)
	
	return tutorialGroup
end

return tutorial
