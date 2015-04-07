local settings = require( "settings" )
local widget = require("widget")
local buttonList = require("data.buttonlist")
local tutorialData = require("data.tutorialdata")
local director = require("libs.helpers.director")
local extratable = require("libs.helpers.extratable")

local tutorial={}

local function getTutorialTable(tutorialList)
	
	local tutorialType = {}
	for indexData = 1, #tutorialData do
		local currentTutorialName = tutorialData[indexData].id
		for indexList = 1, #tutorialList do
			if currentTutorialName == tutorialList[indexList] then
				tutorialType[#tutorialType + 1] = extratable.deepcopy(tutorialData[indexData])
			end
		end
	end
	
	return tutorialType
end

function tutorial.initializeTutorials(tutorialList)
	local tutorialTracker = {}
	tutorialTracker.hasTutorial = false
	tutorialTracker.isTutorialComplete = false
	if tutorialList and #tutorialList > 0 then
		
		tutorialTracker.hasTutorial = true
		tutorialTracker.isTutorialOnScreen = false
		tutorialTracker.tutorialTable = getTutorialTable(tutorialList)
		
		for indexData = 1, #tutorialTracker.tutorialTable do
			local currentData = tutorialTracker.tutorialTable[indexData]
			currentData.page = 1
			currentData.isComplete = false
			currentData.onSucess = nil
			currentData.isShown = false
		end
		
		function tutorialTracker.success(tutorialName)
			for indexTutorial = 1, #tutorialTracker.tutorialTable do
				local currentTutorial = tutorialTracker.tutorialTable[indexTutorial]
				if tutorialName == currentTutorial.id then
					if not currentTutorial.isComplete and currentTutorial.isShown then
						currentTutorial.isComplete = true
						if currentTutorial.onSuccess then
							currentTutorial.onSuccess()
						end
						print("success " .. tutorialName )
					end
				end
			end
		end

		function tutorialTracker.show(tutorialName, params) 	
			params.onSuccess = params.onSuccess or nil
			params.onStart = params.onStart or nil
			params.delay = params.delay or 0
			
			for indexTutorial = 1, #tutorialTracker.tutorialTable do
				local currentTutorial = tutorialTracker.tutorialTable[indexTutorial]
				if tutorialName == currentTutorial.id then
					if not currentTutorial.isShown then
						currentTutorial.onSuccess = params.onSuccess
						timer.performWithDelay(params.delay, function()
							currentTutorial.isShown = true
							params.onStart(currentTutorial)
						end)
					end
				end
			end
		end
		
	end
	
	return tutorialTracker
end

return tutorial
