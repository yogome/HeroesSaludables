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
local ageSlider, weightSlider, firstPlane, heightSlider, kidWeightText, kidHeightText, hourSlider, thirdPlane, thirdOkBtn, thirdBackBtn,finalYogoKid, finalYogoGirl, finalText, alertGroup, textAlert
local textBox, textCompleted, nextButton,yogoKid, yogoGirl, secondPlane, okButton, backButton, hourText,kidCalories, hand
local kidAge, kdWeight, kdHeight, kidName, kidImc, kidStatus, isBoy, checkFirstScreen, checkSecondScreen, checkFirst, checkSecond, oneCategory, selectGenre
local activityNames = {"Caminar","Correr","Basketbal","Futbol","Beisbol","Nadar","Bicicleta","Gimnasia","Otros","Nada"}
local activityBtnNames = {"caminar","correr","basquet","futbol","baseball","nadar","bici","gimnasia","otros","nada"}
local activityBooleans = {false,false,false,false,false,false, false,false,false,false}
local tableCalBoys = {1810,1900,1990,2070,2150,2150,2240,2310,2440}
local tableCalGirls = {1630,1700,1770,1830,1880,1910,1980,2050,2120}
local tableObesityGirls = {
	[1] =  {min = 12.9, max = 18.1},
	[2] =  {min = 12.9, max = 18.4},
	[3] =  {min = 13, max = 18.8},
	[4] =  {min = 13.2, max = 19.4},
	[5] =  {min = 13.5, max = 20.2},
	[6] =  {min = 13.8, max = 21.1},
	[7] =  {min = 14.3, max = 22.2},
	[8] =  {min = 14.8, max = 23.3},
}
local tableObesityBoys = {
	[1] =  {min = 13.2, max = 17.7},
	[2] =  {min = 13.3, max = 17.9},
	[3] =  {min = 13.4, max = 18.3},
	[4] =  {min = 13.6, max = 18.8},
	[5] =  {min = 13.8, max = 19.5},
	[6] =  {min = 14, max = 20.2},
	[7] =  {min = 14.4, max = 21.1},
	[8] =  {min = 14.8, max = 22.1},
}
local pressedButtons, unpressedButtons
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
 
local function round(what, precision)
   return math.floor(what*math.pow(10,precision)+0.5) / math.pow(10,precision)
end

local function getImc(height, weight) 
	local imc = weight / (height * height)
	return round(imc,2)
end
local function createSpriteAnimation()
	
        local sheetData = { width = 256, height = 256, numFrames = 6, sheetContentWidth = 1024, sheetContentHeight = 512 }
	local masterSheet1 = graphics.newImageSheet( "images/infoscreen/manoTuto.png", sheetData )

	local sequenceData = {
		{ name = "tap", sheet = masterSheet1, start = 1, count = 2, time = 1200, loopCount = 0 },
                { name = "ok", sheet = masterSheet1, start = 3, count = 7, time = 1200, loopCount = 1 },
	}
	local masterWinSprite = display.newSprite( masterSheet1, sequenceData )
	return  masterWinSprite
end
local function getKidStatus(age,imc)
	local index = age - 4
	local tableToUse
	if index < 1 or index > 12 then
		return "Indefinido"
	end
	if isBoy then
		tableToUse = tableObesityBoys
	else
		tableToUse = tableObesityGirls
	end
	if(imc<tableToUse[index].min) then
		return "Delgado"
	elseif imc >= tableToUse[index].min and imc <= tableToUse[index].max then
		return "Normal"
	elseif imc > tableToUse[index].max then
		return "Obeso"
	end
end
local function getCalories(age)
	local index = age - 4
	local tableToUsed
	if kidStatus == "Obeso" then
		if isBoy then
			tableToUsed = tableCalBoys
		else
			tableToUsed = tableCalGirls
		end
		return tableToUsed[index]
	else
		local weekHours = 1.2
		if tonumber(hourSlider.value) >= 3 then
			weekHours = 1.55
			if not isBoy then
				weekHours = 1.56
			end
		end
		if kidAge < 10 then
			if isBoy then
				return ((22.7 * kdWeight)+ 495) * weekHours
			else
				return ((22.7 * kdWeight)+ 495) * weekHours
			end
		else
			if isBoy then
				return ((17.5 * kdWeight)+ 651) * weekHours
			else
				return ((12.2 * kdWeight)+ 746) * weekHours
			end	
		end		
	end
end
local function getHandPos(alert)
	local positionX, positionY
	if alert == "Nombre" then
		positionX = centerX + 150
		positionY = screenTop + 230
	elseif alert == "Edad" then
		positionX = centerX + 100
		positionY = screenBottom - 110
	elseif alert == "Peso" then
		positionX = centerX + 230
		positionY = centerY 
	elseif alert == "Género" then
		positionX = centerX + 20
		positionY = centerY + 50
	elseif alert == "Altura" then
		positionX = centerX + 220
		positionY = centerY + 160
	end
	return positionX, positionY
end
local function turnOnAlert(alert)
	transition.cancel()
	local positionX, positionY = getHandPos(alert)
	hand.x = positionX
	hand.y = positionY
	transition.to(hand,{ alpha = 1, time = 300})
	transition.to(hand,{ alpha = 0, time = 300, delay = 1000})
	textAlert.text = "Te falta " .. alert
	transition.to ( alertGroup,{ alpha = 1, time = 300})
	transition.to( alertGroup,{ alpha = 0, time =300, delay = 600})
end
local function pressButton(event)
	local tag = event.target.tag
	local genre = "niño"
--	print( " " .. heightSlider.value .. " " .. weightSlider.value )
	if tag == "next" then
		if textCompleted == "" then
			turnOnAlert("Nombre")
			return
		elseif weightSlider.value== 0 or weightSlider.value == "none" then
			turnOnAlert("Peso")
			return
		elseif ageSlider.value == "none" then
			turnOnAlert("Edad")
			return
		elseif heightSlider.value == 0 or heightSlider.value == "none" then
			turnOnAlert("Altura")
			return
		elseif not selectGenre then
			turnOnAlert("Género")
			return
		end
		checkFirst = false
		checkSecond = true
		nextButton:setEnabled(false)
		transition.to(firstPlane,{x = screenWidth + screenWidth, time = 500,rotation = 90 })
		transition.to(secondPlane,{delay = 400, x = screenLeft, time = 500,rotation = 0 })
		kidName = textCompleted
		kdWeight = weightSlider.value
		kdHeight = heightSlider.value
		kidAge = ageSlider.value
		kidImc = getImc(kdHeight, kdWeight)
		kidStatus = getKidStatus(kidAge,kidImc)
		okButton:setEnabled(true)
		backButton:setEnabled(true)
	elseif tag == "back" then
		checkFirst = true
		checkSecond = false
		backButton:setEnabled(false)
		transition.to(secondPlane,{x = screenWidth + screenWidth, time = 500,rotation = 90 })
		transition.to(firstPlane,{delay = 400, x = screenLeft, time = 500,rotation = 0 })
		nextButton:setEnabled(true)
	elseif tag == "ok" then
--		okButton:setEnabled(false)
--		for i=1, #activityBtnNames do
--			local practice
--			if not activityBooleans[i] then
--				practice = "no"
--			else
--				practice = "si"
--			end
--			print( activityBtnNames[i] .. " " .. practice)
--		end
		print ( hourSlider.value .. "horas")
		kidCalories = getCalories(kidAge)
		if isBoy then
			genre = "niño"
		else
			genre = "niña"
		end
		checkSecond = false
		print("Nombre= " .. kidName .. ", Género= " .. genre .. ", Peso=" .. kdWeight ..  ", Edad= " .. kidAge ..  ",IMC= " .. kidImc .. ", Estado del niño= " .. kidStatus .. ", Calorías a consumir= " .. kidCalories .. " .")
		transition.to(secondPlane,{x = screenWidth + screenWidth, time = 500,rotation = 90 })
		transition.to(thirdPlane,{delay = 400, x = screenLeft, time = 500,rotation = 0 })
		finalText.text = kidCalories .. " kcal"
		if isBoy then
			finalYogoKid.alpha = 1
			finalYogoGirl.alpha = 0
		else
			finalYogoKid.alpha = 0
			finalYogoGirl.alpha = 1
		end
	elseif tag == "backThird" then
		backButton:setEnabled(true)
		checkSecond = true
		transition.to(thirdPlane,{x = screenWidth + screenWidth, time = 500,rotation = 90 })
		transition.to(secondPlane,{delay = 400, x = screenLeft, time = 500,rotation = 0 })
	elseif tag == "okFinal" then
		director.gotoScene("scenes.menus.home", { effect = "fade", time = 500, params = nil})
	end
end
local function savePlayerInfo(event)
	textCompleted = event.target.text.text
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
						kidWeightText.text = slider.value .. " kg"
					elseif options.isHeight then
						local x = (((knob.x + halfWidth / width) + 102.5) * 0.04) * .24
						slider.value = round(x,2)
						kidHeightText.text = slider.value .. " mts"
					end
				end
			elseif event.phase == "ended" or event.phase == "cancelled" then
				transition.cancel(knob)
--				print(slider.value)
--				print((knob.x + halfWidth) / width)
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
	selectGenre = true
	if(tag == "boy") then
		transition.to(yogoKid,{xScale = 0.6, yScale = 0.6, time = 300})
		transition.to(yogoGirl,{xScale = 0.5, yScale = 0.5, time = 300})
		isBoy = true
	elseif tag == "girl" then
		transition.to(yogoKid,{xScale = 0.5, yScale = 0.5, time = 300})
		transition.to(yogoGirl,{xScale = 0.6, yScale = 0.6, time = 300})
		isBoy = false
	end
end
local function animateScene()
	
	firstPlane.x = screenLeft
	firstPlane.rotation = 0
	
	secondPlane.x = screenWidth + screenWidth
	secondPlane.rotation = 90
	
	thirdPlane.x = screenWidth + screenWidth
	thirdPlane.rotation = 90
	transition.from(firstPlane,{delay = 300, x = screenWidth + screenWidth, time = 500,rotation = 90 })
	
end
local function disableButtons()
	for i = 1, (#activityBooleans - 1) do
		pressedButtons[i].alpha = 1
		unpressedButtons[i].alpha = 0
		activityBooleans[i] = false
	end
	hourSlider:initialize()
end
local function pressedActivity(event)
	sound.play("pop")
	local index = event.target.index
	if activityBooleans[10] and index ~= 10 then
		return
	end
	local typ = event.target.type
	if(typ == "pressed") then
		pressedButtons[index].alpha = 0
		unpressedButtons[index].alpha = 1
		activityBooleans[index] = true
		if(index == 10) then
			transition.to(okButton,{ alpha = 1, time=300})
			transition.to(hourSlider,{alpha = 0, time = 300})
			transition.to(hourText,{alpha = 0, time = 300})
			disableButtons()
		end
	else
		pressedButtons[index].alpha = 1
		unpressedButtons[index].alpha = 0
		activityBooleans[index] = false
		if(index == 10) then
			if(hourSlider.value == "none" or not oneCategory) then
				transition.to(hourSlider,{alpha = 1, time = 300})
				transition.to(hourText,{alpha = 1, time = 300})
				transition.to(okButton,{ alpha = 0, time=300})
			end
		end
	end
	local count = 0
	for i=0, (#activityBooleans - 1) do
		if activityBooleans[i] then
			count = count + 1
		end
	end
	if count < 1 then
		oneCategory = false
	else
		oneCategory = true
	end
end
local function createScene(sceneGrp)
	
	firstPlane = display.newGroup()
	secondPlane = display.newGroup()
	thirdPlane = display.newGroup()
	pressedButtons = display.newGroup()
	unpressedButtons = display.newGroup()
	alertGroup = display.newGroup()
	
	local background = display.newImage("images/infoscreen/Background.png")
	background.x = centerX
	background.y = centerY
	background.width = screenWidth
	background.height = screenHeight
	sceneGrp:insert(background)
	
	local techPlane = display.newImage("images/infoscreen/ventana.png")
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
	nextButton.alpha = 1
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
	
	kidWeightText = display.newText("   kg", centerX + 260, centerY - 102, settings.fontName, 26)
	kidWeightText:setFillColor(0.2,1,0.2)
	firstPlane:insert(kidWeightText)
	
	local heightText = display.newText("Altura", centerX + 130, centerY + 49, settings.fontName, 26)
	heightText:setFillColor(0.2,1,0.2)
	firstPlane:insert(heightText) 
	
	kidHeightText = display.newText("   mts", centerX + 235, centerY + 49 , settings.fontName, 22)
	kidHeightText:setFillColor(0.2,1,0.2)
	firstPlane:insert(kidHeightText)
	
	hand = createSpriteAnimation()
    hand.xScale = 0.6
    hand.yScale = 0.6
    hand.alpha = 0
	firstPlane:insert(hand)
	
	sceneGrp:insert(firstPlane)
--	firstPlane.alpha = 0
	
	techPlane = display.newImage("images/infoscreen/ventana.png")
	techPlane.x = centerX
	techPlane.y = centerY
	techPlane.xScale = 0.9
	techPlane.yScale = 0.9
	secondPlane:insert(techPlane)
	
	buttonList.back.onRelease = pressButton
	backButton = widget.newButton(buttonList.back)
	backButton.x = centerX - 350
	backButton.y = centerY - 250
	backButton.xScale = 0.8
	backButton.yScale = 0.8
	backButton.tag = "back"
	secondPlane:insert(backButton)
	
	buttonList.ok.onRelease = pressButton
	okButton = widget.newButton(buttonList.ok)
	okButton.x = centerX + 362
	okButton.y = ageSlider.y - 10
	okButton.xScale = 0.9
	okButton.yScale = 0.9
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
	
	local pivotX = centerX - 280
	local pivotY = centerY - 100
	local pivotImageY = centerY - 22
	local activityBox
	local activityTxt
	local btnImage
	for i=1, #activityNames do
		activityBox = display.newImage("images/infoscreen/actividad.png")
		activityBox.xScale = 0.45
		activityBox.yScale = 0.6
		activityBox.x = pivotX
		activityBox.y = pivotY
		activityTxt = display.newText(activityNames[i], pivotX, pivotY, settings.fontName, 18)
		activityTxt:setFillColor(0.2,1,0.2)
		secondPlane:insert(activityBox)
		secondPlane:insert(activityTxt)
		for u=1, 2 do
			btnImage = display.newImage("images/infoscreen/activities/" .. activityBtnNames[i] .. "0" .. u .. ".png")
			btnImage.x = pivotX
			btnImage.y = pivotImageY
			btnImage.xScale = 0.7
			btnImage.yScale = 0.7
			btnImage.index = i
			btnImage:addEventListener("tap",pressedActivity)
			if u == 1 then
				btnImage.type = "pressed"
				pressedButtons:insert(btnImage)
			else
				btnImage.type = "unpressed"
				btnImage.x = pivotX
				btnImage.alpha = 0
				unpressedButtons:insert(btnImage)
			end
		end
		pivotX =  pivotX + 135
		if i == 5 then
			pivotX = centerX - 300
			pivotY = pivotY + 155
			pivotImageY = pivotImageY + 150
		end
	end
	
	local ageSliderOptions = {
		background = "images/infoscreen/horas.png",
		knob = "images/infoscreen/marcador.png",
		floatingSlider = false,
		isWeight = false,
		isHeight = false,
		positionIndex = 1,
		knobScale = 0.3,
		positions = {
			{x = 0.48679336934527	, value = "none", color = colors.red},
			{x = 0.55984405606811	, value = 0.5, color = colors.white},
			{x = 0.63569200898704	, value = 1, color = colors.white},
			{x = 0.69179337112992	, value = 2, color = colors.white},
			{x = 0.75417153877124	, value = 3, color = colors.white},
			{x = 0.81460038867378	, value = 4, color = colors.white},
			{x = 0.87665693197566	, value = 5, color = colors.white},
			{x = 0.93604223537631	, value = "+", color = colors.white},
		},
	}
	hourSlider = createSlider(ageSliderOptions)
	hourSlider.x = centerX
	hourSlider.y = centerY + 220
	hourSlider.xScale = 0.8
	hourSlider.yScale = 0.8
	secondPlane:insert(hourSlider)
	
	hourText = display.newText("Horas a la Semana",centerX - 110, ageSlider.y + 20,"VAGRounded", 19 )
	hourText:setFillColor(0.2,1,0.2)
	secondPlane:insert(hourText)
	
	secondPlane:insert(pressedButtons)
	secondPlane:insert(unpressedButtons)
	sceneGrp:insert(secondPlane)
	
	techPlane = display.newImage("images/infoscreen/ventana.png")
	techPlane.x = centerX
	techPlane.y = centerY
	techPlane.xScale = 0.9
	techPlane.yScale = 0.9
	thirdPlane:insert(techPlane)
	
	buttonList.back.onRelease = pressButton
	thirdBackBtn = widget.newButton(buttonList.back)
	thirdBackBtn.x = centerX - 350
	thirdBackBtn.y = centerY - 250
	thirdBackBtn.xScale = 0.8
	thirdBackBtn.yScale = 0.8
	thirdBackBtn.tag = "backThird"
	thirdPlane:insert(thirdBackBtn)
	
	buttonList.ok.onRelease = pressButton
	thirdOkBtn = widget.newButton(buttonList.ok)
	thirdOkBtn.x = centerX + 362
	thirdOkBtn.y = ageSlider.y - 10
	thirdOkBtn.xScale = 0.9
	thirdOkBtn.yScale = 0.9
	thirdOkBtn.tag = "okFinal"
	thirdPlane:insert(thirdOkBtn)
	
	yogotarPlane = display.newImage("images/infoscreen/yogotar.png")
	yogotarPlane.x = centerX - 170
	yogotarPlane.y = centerY
	yogotarPlane.xScale = 0.55
	yogotarPlane.yScale = 0.8
	yogotarPlane.rotation = -25
	thirdPlane:insert(yogotarPlane)
	
	finalYogoKid = display.newImage("images/infoscreen/nino.png")
	finalYogoKid.x = yogotarPlane.x - 20
	finalYogoKid.y = centerY
	finalYogoKid.xScale = 0.6
	finalYogoKid.yScale = 0.6
	thirdPlane:insert(finalYogoKid)
	
	finalYogoGirl = display.newImage("images/infoscreen/nina.png")
	finalYogoGirl.x = yogotarPlane.x - 20
	finalYogoGirl.y = centerY
	finalYogoGirl.xScale = 0.6
	finalYogoGirl.yScale = 0.6
	thirdPlane:insert(finalYogoGirl)
	
	local textFinal = display.newText("Tu consumo diario de ",centerX + 150, centerY - 70,"VAGRounded", 32 )
	textFinal:setFillColor(0.2,1,0.2)
	thirdPlane:insert(textFinal)
	textFinal = display.newText("kilocalorias es de",centerX + 150, centerY - 30,"VAGRounded", 32 )
	textFinal:setFillColor(0.2,1,0.2)
	thirdPlane:insert(textFinal)
	
	local textBack = display.newImage("images/infoscreen/actividad.png")
	textBack.x = centerX + 150
	textBack.y = centerY + 40
	thirdPlane:insert(textBack)
	
	finalText = display.newText("560",centerX + 150, centerY + 40,"VAGRounded", 28 )
	finalText:setFillColor(0.2,1,0.2)
	thirdPlane:insert(finalText)
	
--	firstPlane.alpha = 0
	
	sceneGrp:insert(thirdPlane)
	
	local rect = display.newRoundedRect( centerX, screenTop + 100, 250, 70, 12)
	rect:setFillColor( 165/255,48/255,1)
	alertGroup:insert (rect)
	
	textAlert = display.newText("Te falta ", rect.x , rect.y, settings.fontName, 28)
	textAlert:setFillColor (1,1,1)
	alertGroup:insert (textAlert)
	alertGroup.alpha = 0
	sceneGrp:insert(alertGroup)
	
	
end

function game:create(event)
	local sceneView = self.view
	createScene(sceneView)
end

function game:destroy()
end
local function update()
--	print ( weightSlider.value .. " weight ".. heightSlider.value .. " height " .. ageSlider.value .. " age " )
	if checkFirst then
--		if checkFirstScreen then
--			if(selectGenre and textCompleted ~= "" and weightSlider.value~= "none" and weightSlider.value ~= 0 and heightSlider.value ~= 0 and ageSlider.value ~= "none" and heightSlider.value ~= "none") then
--				transition.to(nextButton,{alpha = 1, time = 300})
--				checkFirstScreen = false
--			end
--		else
--			if(textCompleted == "" or weightSlider.value== 0 or ageSlider.value == "none" or heightSlider.value == 0) then
--				transition.to(nextButton,{alpha = 1, time = 300})
--				checkFirstScreen = true
--			end
--		end
	end
	if checkSecond then
		if checkSecondScreen then
			if(hourSlider.value ~= "none" and oneCategory) then
				transition.to(okButton,{alpha = 1, time = 300})
				checkSecondScreen = false
			end
		else
			if(hourSlider.value == "none" or not oneCategory)then
				if not activityBooleans[10] then
					transition.to(okButton,{alpha = 0, time = 300})
					checkSecondScreen = true
				end
			end
		end
	end
end
function game:show( event )
	local sceneGroup = self.view
	local phase = event.phase
		
	if ( phase == "will" ) then
		oneCategory = false
		if checkSecond == nil then
			checkSecond = false
		end
		disableButtons()
		checkFirst = true
		checkFirstScreen = true
		if yogoKid.xScale == 0.5 and yogoGirl.xScale == 0.5 then
			selectGenre = false
		end
		if textCompleted == nil then
			textCompleted = ""
		end
		Runtime:addEventListener("enterFrame", update)
	    nextButton:setEnabled(true)
		backButton:setEnabled(true)
		okButton:setEnabled(true)
		animateScene()
		hand:setSequence("tap")
        hand:play()
	elseif ( phase == "did" ) then
		
	end
end

function game:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
	    
	elseif ( phase == "did" ) then
		hand:pause()
		Runtime:removeEventListener("enterFrame",update)
	end
end
----------------------------------------------- Execution
game:addEventListener( "create", game )
game:addEventListener( "destroy", game )
game:addEventListener( "hide", game )
game:addEventListener( "show", game )

return game