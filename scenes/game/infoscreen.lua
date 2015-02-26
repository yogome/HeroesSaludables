local director = require( "libs.helpers.director" )
local colors = require( "libs.helpers.colors" )
local scenePath = ...
local buttonList = require("data.buttonlist")
local widget = require("widget")
local textbox = require("libs.helpers.textbox")
local settings = require("settings")
local music = require("libs.helpers.music")
local sound = require("libs.helpers.sound")

local game = director.newScene() 
----------------------------------------------- Variables
local techPlane,ageSlider, firstPlane, weightSlider, heightSlider, kidWeight, kidHeight
local ageText, textBox, textCompleted, nextButton,yogoKid, yogoGirl, secondPlane, okButton
------------------------------------------------- Constants
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenLeft = display.screenOriginX
local screenWidth = display.viewableContentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.viewableContentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight 
local mRandom = math.random 
------------------------------------------------- Functions
--
local function pressButton(event)
	local tag = event.target.tag
end
local function savePlayerInfo(event)
	textCompleted = event.target.text.text
	if textCompleted ~= "" then
		transition.to(nextButton,{alpha = 1,time = 300})
	else
		transition.to(nextButton,{alpha = 0,time = 300})
	end
end
local function round(what, precision)
   return math.floor(what*math.pow(10,precision)+0.5) / math.pow(10,precision)
end
local function createSlider(options)
	local slider = display.newGroup()
	
	local positions = options.positions
	
	local background = display.newImage(options.background)
	slider:insert(background)
	
	local width = background.width
	local halfWidth = width * 0.5
	local leftLimit = -halfWidth + (positions[1].x * width)
	local rightLimit = -halfWidth + (positions[#positions].x * width)
	
	local knob = display.newImage(options.knob)
	knob.x = -halfWidth + (positions[options.positionIndex].x * width)
	knob:setFillColor(1,1,1)
	knob.xScale = options.knobScale
	knob.yScale = options.knobScale
	colors.addColorTransition(knob)
	local knobColor = positions[options.positionIndex].color
	director.to(scenePath, knob, {time = 200, r = knobColor[1], g = knobColor[2], b = knobColor[3]})
	slider.knob = knob
	slider:insert(knob)
	slider.currentIndex = options.positionIndex
	slider.value = positions[options.positionIndex].value
	
	local function knobTouched( event )
		local knob = event.target
		if event.phase == "began" then
			display.getCurrentStage():setFocus( knob, event.id )
			knob.isFocus = true
			knob.markX = knob.x
			transition.cancel(knob)
		elseif knob.isFocus then
			if event.phase == "moved" then
				knob.x = event.x - event.xStart + knob.markX
				if knob.x < leftLimit then
					knob.x = leftLimit
				elseif knob.x > rightLimit then
					knob.x = rightLimit
				end
				local currentX = (knob.x + halfWidth) / width
				if #positions > 1 then
					for index = 2, #positions do
						local beforeIndex = index - 1
						local beforePosition = positions[beforeIndex].x
						local nextPosition = positions[index].x
						
						if beforePosition < currentX and currentX < nextPosition then
							local halfPoint = (beforePosition + nextPosition) * 0.5
							if currentX <= halfPoint then
								slider.currentIndex = beforeIndex
							else
								slider.currentIndex = index
							end
						end
					end
				elseif #positions == 1 then
					slider.currentIndex = 1
				end
				if not options.floatingSlider then
					slider.value = positions[slider.currentIndex].value
				else
					if options.isWeight then
						local x = ((knob.x + halfWidth / width) + 102.5) * 0.4
						slider.value = round(x,0)
						kidWeight.text = slider.value .. " kg"
					elseif options.isHeight then
						local x = (((knob.x + halfWidth / width) + 102.5) * 0.04) * .24
						slider.value = round(x,2)
						kidHeight.text = slider.value .. " mts"
					end
					
				end
			elseif event.phase == "ended" or event.phase == "cancelled" then
				transition.cancel(knob)
--				print(slider.value)
				local knobColor = positions[slider.currentIndex].color
				director.to(scenePath, knob, {time = 200, r = knobColor[1], g = knobColor[2], b = knobColor[3]})
				if not options.floatingSlider then
					director.to(scenePath, knob, {x = -halfWidth + positions[slider.currentIndex].x * width})
				end
				display.getCurrentStage():setFocus( knob, nil )
				knob.isFocus = false
			end
		end
		return true
	end
	knob:addEventListener("touch", knobTouched)
	
	function slider:initialize(initialIndex)
		self.currentIndex = initialIndex or options.positionIndex
		self.value = positions[self.currentIndex].value
		
		local knob = self.knob
		knob.x = -halfWidth + (positions[self.currentIndex].x * width)
		knob:setFillColor(1,1,1)
		colors.addColorTransition(knob)
		local knobColor = positions[self.currentIndex].color
		director.to(scenePath, knob, {time = 200, r = knobColor[1], g = knobColor[2], b = knobColor[3]})
	end
	
	function slider:changeBackground(newBackground)
		display.remove(background)
		background = display.newImage(newBackground)
		self:insert(background)
		background:toBack()
	end
	
	return slider
end
local function tapYogotar(event)
	local tag = event.target.tag
	sound.play("pop")
	if(tag == "boy") then
		transition.to(yogoKid,{xScale = 0.6, yScale = 0.6, time = 300})
		transition.to(yogoGirl,{xScale = 0.5, yScale = 0.5, time = 300})
	elseif tag == "girl" then
		transition.to(yogoKid,{xScale = 0.5, yScale = 0.5, time = 300})
		transition.to(yogoGirl,{xScale = 0.6, yScale = 0.6, time = 300})
	end
end
local function animateScene()
	transition.from(firstPlane,{delay = 300, x = screenWidth + screenWidth, time = 500,rotation = 90 })
end
local function createScene(sceneGrp)
	
	firstPlane = display.newGroup()
	secondPlane = display.newGroup()
	
	local background = display.newImage("images/infoscreen/Background.png")
	background.x = centerX
	background.y = centerY
	background.width = screenWidth
	background.height = screenHeight
	sceneGrp:insert(background)
	
	techPlane = display.newImage("images/infoscreen/ventana.png")
	techPlane.x = centerX
	techPlane.y = centerY
	techPlane.xScale = 0.9
	techPlane.yScale = 0.9
	firstPlane:insert(techPlane)
	
	local ageSliderOptions = {
		background = "images/infoscreen/edad.png",
		knob = "images/infoscreen/marcador.png",
		floatingSlider = false,
		isWeight = false,
		isHeight = false,
		positionIndex = 1,
		knobScale = 0.3,
		positions = {
			{x = 0.32694931476437, value = "none", color = colors.red},
			{x = 0.39907407109965, value = 5, color = colors.white},
			{x = 0.47407407556129, value = 6, color = colors.white},
			{x = 0.53237816883109, value = 7, color = colors.white},
			{x = 0.58847953097397, value = 8, color = colors.white},
			{x = 0.6508576986153, value = 9, color = colors.white},
			{x = 0.72298245495058, value = 10, color = colors.white},
			{x = 0.79673490468522, value = 11, color = colors.white},
			{x = 0.87366406217620, value = 12, color = colors.white},
			{x = 0.94424950077287, value = 13, color = colors.white},
		},
	}
	ageSlider = createSlider(ageSliderOptions)
	ageSlider.x = centerX
	ageSlider.y = centerY + 200
	firstPlane:insert(ageSlider)
	
	local ageText = display.newEmbossedText("Edad",centerX - 180, ageSlider.y,"VAGRounded", 28 )
	ageText:setFillColor(0.2,1,0.2)
	firstPlane:insert(ageText)
	
	buttonList.next.onRelease = pressButton
	nextButton = widget.newButton(buttonList.next)
	nextButton.x = centerX + 350
	nextButton.y = ageSlider.y - 10
	nextButton.xScale = 0.9
	nextButton.alpha = 0
	nextButton.tag = "next"
	firstPlane:insert(nextButton)
	
	local yogotarPlane = display.newImage("images/infoscreen/yogotar.png")
	yogotarPlane.x = centerX - 140
	yogotarPlane.y = centerY
	yogotarPlane.xScale = 0.8
	yogotarPlane.yScale = 0.8
	firstPlane:insert(yogotarPlane)
	
	yogoKid = display.newImage("images/infoscreen/nino.png")
	yogoKid.x = yogotarPlane.x - 100
	yogoKid.y = centerY
	yogoKid:addEventListener("tap",tapYogotar)
	yogoKid.tag = "boy"
	yogoKid.xScale = 0.5
	yogoKid.yScale = 0.5
	firstPlane:insert(yogoKid)
	
	yogoGirl = display.newImage("images/infoscreen/nina.png")
	yogoGirl.x = yogotarPlane.x + 70
	yogoGirl.y = centerY
	yogoGirl:addEventListener("tap",tapYogotar)
	yogoGirl.tag = "girl"
	yogoGirl.xScale = 0.5
	yogoGirl.yScale = 0.5
	firstPlane:insert(yogoGirl)
	
--	local yogoName = display.newImage
	local texboxOptions = {
        backgroundImage = "images/infoscreen/subtitulo.png",
        backgroundScale = 0.8,
        width =  300,
        fontSize = 29,
        font = settings.fontName,
        inputType = "text",
        color = { default = { 0.2, 1, 0.2 }, selected = { 0.2, 1, 0.2 }, placeholder = { 0.2, 1, 0.2 } },
        placeholder = "Nombre",
        onComplete = savePlayerInfo,
		maxChars = 15,
		onChange = savePlayerInfo,
    }
    textBox = textbox.new(texboxOptions)
    textBox.alpha = 1
    textBox.x = centerX
    textBox.y = screenTop + 180
    firstPlane:insert(textBox)
	
	local editTextImage = display.newImage("images/infoscreen/edit_1.png")
	editTextImage.x = centerX + 200
	editTextImage.y = textBox.y
	editTextImage.xScale = 0.35
	editTextImage.yScale = 0.35
	firstPlane:insert(editTextImage)
	
	local weightImage = display.newImage("images/infoscreen/pesoAltura.png")
	weightImage.x = centerX + 200
	weightImage.y = centerY - 100
	firstPlane:insert(weightImage)
	
	local heightImage = display.newImage("images/infoscreen/pesoAltura.png")
	heightImage.x = centerX + 180
	heightImage.y = centerY + 50
	firstPlane:insert(heightImage)
	
	ageSliderOptions = {
		background = "images/infoscreen/barrapeso.png",
		knob = "images/infoscreen/marcadorpeso.png",
		floatingSlider = true,
		isWeight = true,
		isHeight = false,
		positionIndex = 1,
		knobScale = 0.3,
		positions = {
			{x = 0.1, value = "none", color = colors.red},
			{x = 0.2, value = "none", color = colors.white},
			{x = 0.9, value = 5, color = colors.white},
		},
	}
	weightSlider = createSlider(ageSliderOptions)
	weightSlider.x = centerX + 180
	weightSlider.y = centerY - 30
	firstPlane:insert(weightSlider)
	
	
	
	ageSliderOptions = {
		background = "images/infoscreen/barrapeso.png",
		knob = "images/infoscreen/marcadorpeso.png",
		floatingSlider = true,
		isWeight = false,
		isHeight = true,
		positionIndex = 1,
		knobScale = 0.3,
		positions = {
			{x = 0.1, value = "none", color = colors.red},
			{x = 0.2, value = "none", color = colors.white},
			{x = 0.9, value = 5, color = colors.white},
		},
	}
	heightSlider = createSlider(ageSliderOptions)
	heightSlider.x = centerX + 160
	heightSlider.y = centerY + 120
	firstPlane:insert(heightSlider)
	
	local weightText = display.newText("Peso", centerX + 150, centerY - 102, settings.fontName, 26)
	weightText:setFillColor(0.2,1,0.2)
	firstPlane:insert(weightText)
	
	kidWeight = display.newText("   kg", centerX + 260, centerY - 102, settings.fontName, 26)
	kidWeight:setFillColor(0.2,1,0.2)
	firstPlane:insert(kidWeight)
	
	local heightText = display.newText("Altura", centerX + 130, centerY + 49, settings.fontName, 26)
	heightText:setFillColor(0.2,1,0.2)
	firstPlane:insert(heightText) 
	
	kidHeight = display.newText("   mts", centerX + 235, centerY + 49 , settings.fontName, 22)
	kidHeight:setFillColor(0.2,1,0.2)
	firstPlane:insert(kidHeight)
	
	sceneGrp:insert(firstPlane)
	firstPlane.alpha = 0
	
	local techPlane = display.newImage("images/infoscreen/ventana.png")
	techPlane.x = centerX
	techPlane.y = centerY
	techPlane.xScale = 0.9
	techPlane.yScale = 0.9
	secondPlane:insert(techPlane)
	
	buttonList.back.onRelease = pressButton
	local backButton = widget.newButton(buttonList.back)
	backButton.x = centerX - 350
	backButton.y = centerY - 250
	backButton.xScale = 0.8
	backButton.yScale = 0.8
	backButton.tag = "back"
	secondPlane:insert(backButton)
	
	buttonList.ok.onRelease = pressButton
	okButton = widget.newButton(buttonList.ok)
	okButton.x = centerX + 350
	okButton.y = ageSlider.y - 10
	okButton.tag = "ok"
	secondPlane:insert(okButton)
	
	local activityBox = display.newImage("images/infoscreen/actividad.png")
	activityBox.x = centerX
	activityBox.y = centerY - 180
	activityBox.xScale = 1.2
	activityBox.yScale = 1.1
	secondPlane:insert(activityBox)
	
	local activityText = display.newText("Actividad que practicas", centerX, activityBox.y , settings.fontName, 26)
	activityText:setFillColor(0.2,1,0.2)
	secondPlane:insert(activityText)
end

function game:create(event)
	local sceneView = self.view
	createScene(sceneView)
end

function game:destroy()
end

function game:show( event )
	local sceneGroup = self.view
	local phase = event.phase
		
	if ( phase == "will" ) then
	    
	elseif ( phase == "did" ) then
		animateScene()
	end
end

function game:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
	    
	elseif ( phase == "did" ) then
		
	end
end
----------------------------------------------- Execution
game:addEventListener( "create", game )
game:addEventListener( "destroy", game )
game:addEventListener( "hide", game )
game:addEventListener( "show", game )

return game