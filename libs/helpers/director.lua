----------------------------------------------- Director - Scene management
local path = ...
local folder = path:match("(.-)[^%.]+$")
local logger = require( folder.."logger" ) 
local extratable = require( folder.."extratable" )

local director = {
	sceneDictionary = {},
	showingScenes = {},
	mode = "director",
}
----------------------------------------------- Variables
local stage
local touchRect
local variables
local debugDirector
local performanceRecords
----------------------------------------------- Caches
local CONTENT_CENTER_X = display.contentCenterX
local CONTENT_CENTER_Y = display.contentCenterY
local VIEWABLE_CONTENT_WIDTH = display.viewableContentWidth
local VIEWABLE_CONTENT_HEIGHT = display.viewableContentHeight
----------------------------------------------- Constants
local EFFECT_DEFAULT = "crossFade" 
local EFFECT_TIME_DEFAULT = 0

local EVENT_DATA = {
	["director"] = {
		onCreate = {name = "create"},
		onDestroy = {name = "destroy"},
		onWillShow = {name = "show", phase = "will"},
		onDidShow = {name = "show", phase = "did"},
		onWillHide = {name = "hide", phase = "will"},
		onDidHide = {name = "hide", phase = "did"},
	},
	["composer"] = {
		onCreate = {name = "create"},
		onDestroy = {name = "destroy"},
		onWillShow = {name = "show", phase = "will"},
		onDidShow = {name = "show", phase = "did"},
		onWillHide = {name = "hide", phase = "will"},
		onDidHide = {name = "hide", phase = "did"},
	},
	["storyboard"] = {
		onCreate = {name = "createScene"},
		onDestroy = {name = "destroyScene"},
		onWillShow = {name = "willEnterScene"},
		onDidShow = {name = "enterScene"},
		onWillHide = {name = "exitScene"},
		onDidHide = {name = "didExitScene"},
	}
}

local LIST_EFFECTS = {
	["fade"] = {
		["from"] = {
			alphaStart = 1.0,
			alphaEnd = 0,
		},

		["to"] = {
			alphaStart = 0,
			alphaEnd = 1.0
		}
	},
	
	["zoomOutIn"] = {
		["from"] = {
			xEnd = CONTENT_CENTER_X,
			yEnd = CONTENT_CENTER_Y,
			xScaleEnd = 0.001,
			yScaleEnd = 0.001
		},

		["to"] = {
			xScaleStart = 0.001,
			yScaleStart = 0.001,
			xScaleEnd = 1.0,
			yScaleEnd = 1.0,
			xStart = CONTENT_CENTER_X,
			yStart = CONTENT_CENTER_Y,
			xEnd = 0,
			yEnd = 0
		},
		hideOnOut = true
	},
	
	["zoomOutInFade"] = {
		["from"] = {
			xEnd = CONTENT_CENTER_X,
			yEnd = CONTENT_CENTER_Y,
			xScaleEnd = 0.001,
			yScaleEnd = 0.001,
			alphaStart = 1.0,
			alphaEnd = 0
		},

		["to"] = {
			xScaleStart = 0.001,
			yScaleStart = 0.001,
			xScaleEnd = 1.0,
			yScaleEnd = 1.0,
			xStart = CONTENT_CENTER_X,
			yStart = CONTENT_CENTER_Y,
			xEnd = 0,
			yEnd = 0,
			alphaStart = 0,
			alphaEnd = 1.0
		},
		hideOnOut = true
	},
	
	["zoomInOut"] = {
		["from"] = {
			xEnd = -CONTENT_CENTER_X,
			yEnd = -CONTENT_CENTER_Y,
			xScaleEnd = 2.0,
			yScaleEnd = 2.0
		},

		["to"] = {
			xScaleStart = 2.0,
			yScaleStart = 2.0,
			xScaleEnd = 1.0,
			yScaleEnd = 1.0,
			xStart = -CONTENT_CENTER_X,
			yStart = -CONTENT_CENTER_Y,
			xEnd = 0,
			yEnd = 0
		},
		hideOnOut = true
	},
	
	["zoomInOutFade"] = {
		["from"] = {
			xEnd = -CONTENT_CENTER_X,
			yEnd = -CONTENT_CENTER_Y,
			xScaleEnd = 2.0,
			yScaleEnd = 2.0,
			alphaStart = 1.0,
			alphaEnd = 0
		},

		["to"] = {
			xScaleStart = 2.0,
			yScaleStart = 2.0,
			xScaleEnd = 1.0,
			yScaleEnd = 1.0,
			xStart = -CONTENT_CENTER_X,
			yStart = -CONTENT_CENTER_Y,
			xEnd = 0,
			yEnd = 0,
			alphaStart = 0,
			alphaEnd = 1.0
		},
		hideOnOut = true
	},
	
	["flip"] = {
		["from"] = {
			xEnd = CONTENT_CENTER_X,
			xScaleEnd = 0.001
		},

		["to"] = {
			xScaleStart = 0.001,
			xScaleEnd = 1.0,
			xStart = CONTENT_CENTER_X,
			xEnd = 0
		}
	},
	
	["flipFadeOutIn"] = {
		["from"] = {
			xEnd = CONTENT_CENTER_X,
			xScaleEnd = 0.001,
			alphaStart = 1.0,
			alphaEnd = 0
		},

		["to"] = {
			xScaleStart = 0.001,
			xScaleEnd = 1.0,
			xStart = CONTENT_CENTER_X,
			xEnd = 0,
			alphaStart = 0,
			alphaEnd = 1.0
		}
	},
	
	["zoomOutInRotate"] = {
		["from"] = {
			xEnd = CONTENT_CENTER_X,
			yEnd = CONTENT_CENTER_Y,
			xScaleEnd = 0.001,
			yScaleEnd = 0.001,
			rotationStart = 0,
			rotationEnd = -360
		},

		["to"] = {
			xScaleStart = 0.001,
			yScaleStart = 0.001,
			xScaleEnd = 1.0,
			yScaleEnd = 1.0,
			xStart = CONTENT_CENTER_X,
			yStart = CONTENT_CENTER_Y,
			xEnd = 0,
			yEnd = 0,
			rotationStart = -360,
			rotationEnd = 0
		},
		hideOnOut = true
	},
	
	["zoomOutInFadeRotate"] = {
		["from"] = {
			xEnd = CONTENT_CENTER_X,
			yEnd = CONTENT_CENTER_Y,
			xScaleEnd = 0.001,
			yScaleEnd = 0.001,
			rotationStart = 0,
			rotationEnd = -360,
			alphaStart = 1.0,
			alphaEnd = 0
		},

		["to"] = {
			xScaleStart = 0.001,
			yScaleStart = 0.001,
			xScaleEnd = 1.0,
			yScaleEnd = 1.0,
			xStart = CONTENT_CENTER_X,
			yStart = CONTENT_CENTER_Y,
			xEnd = 0,
			yEnd = 0,
			rotationStart = -360,
			rotationEnd = 0,
			alphaStart = 0,
			alphaEnd = 1.0
		},
		hideOnOut = true
	},
	
	["zoomInOutRotate"] = {
		["from"] = {
			xEnd = CONTENT_CENTER_X,
			yEnd = CONTENT_CENTER_Y,
			xScaleEnd = 2.0,
			yScaleEnd = 2.0,
			rotationStart = 0,
			rotationEnd = -360
		},

		["to"] = {
			xScaleStart = 2.0,
			yScaleStart = 2.0,
			xScaleEnd = 1.0,
			yScaleEnd = 1.0,
			xStart = CONTENT_CENTER_X,
			yStart = CONTENT_CENTER_Y,
			xEnd = 0,
			yEnd = 0,
			rotationStart = -360,
			rotationEnd = 0
		},
		hideOnOut = true
	},
	
	["zoomInOutFadeRotate"] = {
		["from"] = {
			xEnd = CONTENT_CENTER_X,
			yEnd = CONTENT_CENTER_Y,
			xScaleEnd = 2.0,
			yScaleEnd = 2.0,
			rotationStart = 0,
			rotationEnd = -360,
			alphaStart = 1.0,
			alphaEnd = 0
		},

		["to"] = {
			xScaleStart = 2.0,
			yScaleStart = 2.0,
			xScaleEnd = 1.0,
			yScaleEnd = 1.0,
			xStart = CONTENT_CENTER_X,
			yStart = CONTENT_CENTER_Y,
			xEnd = 0,
			yEnd = 0,
			rotationStart = -360,
			rotationEnd = 0,
			alphaStart = 0,
			alphaEnd = 1.0
		},
		hideOnOut = true
	},
	
	["fromRight"] = {
		["from"] = {
			xStart = 0,
			yStart = 0,
			xEnd = 0,
			yEnd = 0,
			transition = easing.outQuad
		},

		["to"] = {
			xStart = VIEWABLE_CONTENT_WIDTH,
			yStart = 0,
			xEnd = 0,
			yEnd = 0,
			transition = easing.outQuad
		},
		concurrent = true,
		sceneAbove = true
	},
	
	["fromLeft"] = {
		["from"] = {
			xStart = 0,
			yStart = 0,
			xEnd = 0,
			yEnd = 0,
			transition = easing.outQuad
		},

		["to"] = {
			xStart = -VIEWABLE_CONTENT_WIDTH,
			yStart = 0,
			xEnd = 0,
			yEnd = 0,
			transition = easing.outQuad
		},
		concurrent = true,
		sceneAbove = true
	},
	
	["fromTop"] = {
		["from"] = {
			xStart = 0,
			yStart = 0,
			xEnd = 0,
			yEnd = 0,
			transition = easing.outQuad
		},

		["to"] = {
			xStart = 0,
			yStart = -VIEWABLE_CONTENT_HEIGHT,
			xEnd = 0,
			yEnd = 0,
			transition = easing.outQuad
		},
		concurrent = true,
		sceneAbove = true
	},
	
	["fromBottom"] = {
		["from"] = {
			xStart = 0,
			yStart = 0,
			xEnd = 0,
			yEnd = 0,
			transition = easing.outQuad
		},

		["to"] = {
			xStart = 0,
			yStart = VIEWABLE_CONTENT_HEIGHT,
			xEnd = 0,
			yEnd = 0,
			transition = easing.outQuad
		},
		concurrent = true,
		sceneAbove = true
	},
	
	["slideLeft"] = {
		["from"] = {
			xStart = 0,
			yStart = 0,
			xEnd = -VIEWABLE_CONTENT_WIDTH,
			yEnd = 0,
			transition = easing.outQuad
		},

		["to"] = {
			xStart = VIEWABLE_CONTENT_WIDTH,
			yStart = 0,
			xEnd = 0,
			yEnd = 0,
			transition = easing.outQuad
		},
		concurrent = true,
		sceneAbove = true
	},
	
	["slideRight"] = {
		["from"] = {
			xStart = 0,
			yStart = 0,
			xEnd = VIEWABLE_CONTENT_WIDTH,
			yEnd = 0,
			transition = easing.outQuad
		},

		["to"] = {
			xStart = -VIEWABLE_CONTENT_WIDTH,
			yStart = 0,
			xEnd = 0,
			yEnd = 0,
			transition = easing.outQuad
		},
		concurrent = true,
		sceneAbove = true
	},
	
	["slideDown"] = { 
		["from"] = {
			xStart = 0,
			yStart = 0,
			xEnd = 0,
			yEnd = VIEWABLE_CONTENT_HEIGHT,
			transition = easing.outQuad
		},

		["to"] = {
			xStart = 0,
			yStart = -VIEWABLE_CONTENT_HEIGHT,
			xEnd = 0,
			yEnd = 0,
			transition = easing.outQuad
		},
		concurrent = true,
		sceneAbove = true
	},
	
	["slideUp"] = {
		["from"] = {
			xStart = 0,
			yStart = 0,
			xEnd = 0,
			yEnd = -VIEWABLE_CONTENT_HEIGHT,
			transition = easing.outQuad
		},

		["to"] = {
			xStart = 0,
			yStart = VIEWABLE_CONTENT_HEIGHT,
			xEnd = 0,
			yEnd = 0,
			transition = easing.outQuad
		},
		concurrent = true,
		sceneAbove = true
	},
	
	["crossFade"] = {
		["from"] = {
			alphaStart = 1.0,
			alphaEnd = 0,
		},

		["to"] = {
			alphaStart = 0,
			alphaEnd = 1.0
		},
		concurrent = true
	}
}

local DEFAULT_ZINDEX_OVERLAY = 2
local DEFAULT_ZINDEX = 1
----------------------------------------------- Functions
local function performanceHook(object, event)
	performanceRecords = performanceRecords or {}
	
	local totalChildren = 0
	local maxNesting = 0
	
--	local childrenList = {}

	local function countChildren(group, indexNesting)
		indexNesting = indexNesting + 1
		if group.numChildren then
			for index = 1, group.numChildren do
				local displayObject = group[index]
				if displayObject.numChildren then
					countChildren(displayObject, indexNesting)
				end
--				childrenList[#childrenList + 1] = childrenList
				totalChildren = totalChildren + 1
			end
		end
		if indexNesting > maxNesting then
			maxNesting = indexNesting
		end
	end
	
	local function measurePerformance(phase)
		countChildren(object.view, 0)
				
		performanceRecords[object._name] = performanceRecords[object._name] or {}
		performanceRecords[object._name][phase] = performanceRecords[object._name][phase] or {
			name = object._name,
			phase = phase,
			maxNesting = maxNesting,
			totalChildren = totalChildren,
--			childrenList = childrenList,
			measurements = 0,
			nestingWarnings = 0,
			childrenWarnings = 0,
		}

		performanceRecords[object._name][phase].measurements = performanceRecords[object._name][phase].measurements + 1
		local nestingWarning = false
		local childrenWarning = false
		
--		local oldChildrenList = performanceRecords[object._name][phase].childrenList
--		local leakedObjects = {}
--		for index = 1, #childrenList do
--			local child = childrenList[index]
--			if not extratable.contains(oldChildrenList, child) then
--				leakedObjects[#leakedObjects + 1] = child
--			end
--		end
--		performanceRecords[object._name][phase].childrenList = childrenList
		
		if maxNesting > performanceRecords[object._name][phase].maxNesting then
			performanceRecords[object._name][phase].maxNesting = maxNesting
			performanceRecords[object._name][phase].nestingWarnings = performanceRecords[object._name][phase].nestingWarnings + 1
			nestingWarning = true
		end

		if totalChildren > performanceRecords[object._name][phase].totalChildren then
			performanceRecords[object._name][phase].totalChildren = totalChildren
			performanceRecords[object._name][phase].childrenWarnings = performanceRecords[object._name][phase].childrenWarnings + 1
			childrenWarning = true
		end
		
		if performanceRecords[object._name][phase].measurements > 3 then
			if nestingWarning or childrenWarning then
				logger.error([[[Director] scene "]]..object._name..[[" might have a graphic memory leak. C]]..performanceRecords[object._name][phase].totalChildren..[[ N]]..performanceRecords[object._name][phase].maxNesting)
			end
		end
	end
			
	if object and object.view then
		if event.name == "show" and event.phase == "will" then
			measurePerformance("show-will")
		end
	end
end

local function eventDispatcher(object, event)
	if debugDirector then
		logger.log("[Director] Dispatching event:"..event.name..(event.phase and (", phase:"..event.phase) or ""))
	end
	performanceHook(object, event)
	object:dispatchEvent(event)
end

local function cancelSceneTimers(scene)
	if scene and scene._timers and "table" == type(scene._timers) then
		for index = #scene._timers, 1, -1 do
			if scene._timers[index] then
				timer.cancel(scene._timers[index])
			end
		end
		scene._timers = {}
	end
end

local function cancelSceneTransitions(scene)
	if scene and scene._transitions and "table" == type(scene._transitions) then
		for index = #scene._transitions, 1, -1 do
			if scene._transitions[index] then
				transition.cancel(scene._transitions[index])
			end
		end
		scene._transitions = {}
	end
end

local function initialize()
	stage = display.newGroup()
	director.stage = stage
	local generalStage = display.getCurrentStage()
	generalStage:insert(stage)
	
	variables = {}
end

local function modalTouch()
	return true
end

local function checkTouchRect()
	if not touchRect then
		touchRect = display.newRect( CONTENT_CENTER_X, CONTENT_CENTER_Y, VIEWABLE_CONTENT_WIDTH, VIEWABLE_CONTENT_HEIGHT )
		touchRect.isVisible = false
		touchRect:addEventListener( "touch", modalTouch )
		touchRect:addEventListener( "tap", modalTouch )
	end
end

local function createModalRect()
	local modalRect = display.newRect( CONTENT_CENTER_X, CONTENT_CENTER_Y, VIEWABLE_CONTENT_WIDTH, VIEWABLE_CONTENT_HEIGHT )
	modalRect.isVisible = false
	modalRect:addEventListener( "touch", modalTouch )
	modalRect:addEventListener( "tap", modalTouch )

	return modalRect
end

local function disableTouchEvents()
	checkTouchRect()
	touchRect.isHitTestable = true
	stage:insert(touchRect)
end

local function enableTouchEvents()
	checkTouchRect()
	touchRect.isHitTestable = false
	stage:insert(touchRect)
end
----------------------------------------------- Module functions
function director.getSceneName(zIndex)
	zIndex = zIndex or DEFAULT_ZINDEX
	if type(zIndex) == "string" then
		if zIndex == "current" then
			if director.showingScenes[DEFAULT_ZINDEX].currentScene then
				return director.showingScenes[DEFAULT_ZINDEX].currentScene._name
			end
		elseif zIndex == "previous" then
			if director.showingScenes[DEFAULT_ZINDEX].pastScene then
				return director.showingScenes[DEFAULT_ZINDEX].pastScene._name
			end
		elseif zIndex == "overlay" then
			if director.showingScenes[DEFAULT_ZINDEX_OVERLAY] then
				if director.showingScenes[DEFAULT_ZINDEX_OVERLAY].currentScene then
					return director.showingScenes[DEFAULT_ZINDEX_OVERLAY].currentScene._name
				end
			end
		end
	elseif type(zIndex) == "number" then
		if director.showingScenes[zIndex] and director.showingScenes[zIndex].currentScene then
			return director.showingScenes[zIndex].currentScene._name
		end
	end
end

function director.getScene(sceneName)
	return director.sceneDictionary[sceneName]
end

function director.newScene(sceneName)
	local newScene = Runtime._super:new()
	
	if sceneName and not director.sceneDictionary[sceneName] then
		director.sceneDictionary[sceneName] = newScene
		newScene._name = sceneName
		newScene._timers = {}
		newScene._transitions = {}
	end
	
	return newScene
end

function director.loadScene(sceneName, doNotLoadView, params)
	local scene = director.sceneDictionary[sceneName]
	
	local function prepareScene()
		scene.view = display.newGroup()
		scene._modalView = createModalRect()
		scene.view:insert(scene._modalView)
		scene._modalView.isHitTestable = false
		scene.view.isVisible = false
		scene._eventData = scene.createScene and EVENT_DATA["storyboard"] or EVENT_DATA["composer"]
		
		local event = extratable.deepcopy(director.sceneDictionary[sceneName]._eventData.onCreate)
		event.params = params
		eventDispatcher(director.sceneDictionary[sceneName], event)
	end
	
	if scene then
		if scene.view then
			return scene
		elseif not doNotLoadView then
			prepareScene()
		end
	else
		local success, message = pcall(function()
			scene = require(sceneName)
			scene._name = sceneName
			scene._timers = {}
			scene._transitions = {}
			director.sceneDictionary[sceneName] = scene
			scene._eventData = scene.createScene and EVENT_DATA["storyboard"] or EVENT_DATA["composer"]
		end)

		if not success and message then
			logger.error([[[Director] Error with scene "]]..sceneName..[[".]])
			logger.error(message)
			return
		end
		
		if not doNotLoadView then
			prepareScene()
		end
	end
	return scene
end

function director.showScene(sceneName, zIndex, options, parentScene)
	zIndex = zIndex or DEFAULT_ZINDEX
	options = options or {}
	
	if debugDirector then
		logger.log("[Director] will show scene "..sceneName.."")
	end
	
	local params = options.params or {}
	local effectName = options.effect or EFFECT_DEFAULT
	local effectTime = options.time or EFFECT_TIME_DEFAULT
	local isModal = options.isModal
	local transitionEffect = LIST_EFFECTS[effectName]
	
	if not director.showingScenes[zIndex] then
		director.showingScenes[zIndex] = {
			currentScene = nil,
			pastScene = nil,
			view = display.newGroup(),
		}
		stage:insert(zIndex, director.showingScenes[zIndex].view)
	end
	
	disableTouchEvents()
	
	if sceneName then
		local scene = director.sceneDictionary[sceneName]
		
		local function prepareScene()
			if not scene.view then
				scene.view = display.newGroup()
				scene._modalView = createModalRect()
				scene.view:insert(scene._modalView)
				
				scene._modalView.isHitTestable = false
				scene.view.isVisible = false
				scene._eventData = scene.createScene and EVENT_DATA["storyboard"] or EVENT_DATA["composer"]
				
				local event = extratable.deepcopy(director.sceneDictionary[sceneName]._eventData.onCreate)
				event.params = params
				event.parent = parentScene
				eventDispatcher(director.sceneDictionary[sceneName], event)
			end
			
			scene._modalView.isHitTestable = isModal
			scene.zIndex = zIndex
			scene.sceneSlot = "currentScene"
			if director.showingScenes[zIndex].currentScene ~= scene then
				director.showingScenes[zIndex].pastScene = director.showingScenes[zIndex].currentScene
				if director.showingScenes[zIndex].pastScene then
					director.showingScenes[zIndex].pastScene.sceneSlot = "pastScene"
				end
			else
				director.showingScenes[zIndex].pastScene = nil
			end
			director.showingScenes[zIndex].currentScene = scene
			
			if not pcall(function()
				director.showingScenes[zIndex].view:insert(scene.view)
			end) then
				error([[[Director] Scene "]]..sceneName..[[" does not have a valid view. Did you remove it by accident?]], 4)
			end
		end
		
		if scene then
			prepareScene()
		else
			local success, message = pcall(function()
				scene = require(sceneName)
				scene._name = sceneName
				scene._timers = {}
				scene._transitions = {}
				director.sceneDictionary[sceneName] = scene
				scene._eventData = scene.createScene and EVENT_DATA["storyboard"] or EVENT_DATA["composer"]
			end)
			
			if not success and message then
				logger.error([[[Director] Error with scene "]]..sceneName..[[".]])
				logger.error(message)
				return
			end
			
			prepareScene()
		end
		
		local currentScene = director.showingScenes[zIndex].currentScene
		local pastScene = director.showingScenes[zIndex].pastScene
		
		if pastScene then
			local event = extratable.deepcopy(pastScene._eventData.onWillHide)
			event.params = params
			event.parent = parentScene
			event.effectTime = effectTime
			eventDispatcher(pastScene, event)
		end
		
		transition.cancel(currentScene.view)
		currentScene.view.isVisible = false
		if transitionEffect.to then
			currentScene.view.x = transitionEffect.to.xStart or 0
			currentScene.view.y = transitionEffect.to.yStart or 0
			currentScene.view.alpha = transitionEffect.to.alphaStart or 1.0
			currentScene.view.xScale = transitionEffect.to.xScaleStart or 1.0
			currentScene.view.yScale = transitionEffect.to.yScaleStart or 1.0
			currentScene.view.rotation = transitionEffect.to.rotationStart or 0
		end
		
		local function newSceneOnComplete()
			enableTouchEvents()
			if pastScene and pastScene.view then
				pastScene.view.isVisible = false
			end

			local event = extratable.deepcopy(currentScene._eventData.onDidShow)
			event.params = params
			event.parent = parentScene
			eventDispatcher(currentScene, event)
		end
		
		local newSceneTransitionOptions = {
			x = transitionEffect.to.xEnd,
			y = transitionEffect.to.yEnd,
			alpha = transitionEffect.to.alphaEnd,
			xScale = transitionEffect.to.xScaleEnd,
			yScale = transitionEffect.to.yScaleEnd,
			rotation =  transitionEffect.to.rotationEnd,
			time = effectTime or EFFECT_TIME_DEFAULT,
			transition = transitionEffect.to.transition,
			onComplete = newSceneOnComplete,
		}
		
		local function willShowNewScene()
			local event = extratable.deepcopy(currentScene._eventData.onWillShow)
			event.params = params
			event.parent = parentScene
			eventDispatcher(currentScene, event)

			currentScene.view.isVisible = true
			if newSceneTransitionOptions.time <= 0 then
				for key, value in pairs(newSceneTransitionOptions) do
					if key ~= "onComplete" then
						currentScene.view[key] = value
					end
				end
				if newSceneTransitionOptions.onComplete then
					newSceneTransitionOptions.onComplete()
				end
			else
				local sceneTransition = transition.to( currentScene.view, newSceneTransitionOptions )
			end
		end
		
		local function previousSceneOnComplete()
			cancelSceneTimers(pastScene)
			cancelSceneTransitions(pastScene)
			local event = extratable.deepcopy(pastScene._eventData.onDidHide)
			event.params = params
			event.parent = parentScene
			event.effectTime = effectTime
			eventDispatcher(pastScene, event)
			if not transitionEffect.concurrent then
				display.getCurrentStage():setFocus(nil)
				willShowNewScene()
			end
		end
		
		local previousSceneTransitionOptions = {
			x = transitionEffect.from.xEnd,
			y = transitionEffect.from.yEnd,
			alpha = transitionEffect.from.alphaEnd,
			xScale = transitionEffect.from.xScaleEnd,
			yScale = transitionEffect.from.yScaleEnd,
			rotation = transitionEffect.from.rotationEnd,
			time = effectTime or 500,
			transition = transitionEffect.from.transition,
			onComplete = previousSceneOnComplete,
		}
		
		if pastScene then
			if previousSceneTransitionOptions.time <= 0 then
				for key, value in pairs(previousSceneTransitionOptions) do
					if key ~= "onComplete" then
						pastScene.view[key] = value
					end
				end
				if previousSceneTransitionOptions.onComplete then
					previousSceneTransitionOptions.onComplete()
				end
			else
				local sceneTransition = transition.to( pastScene.view, previousSceneTransitionOptions )
			end
			
			if transitionEffect.concurrent then
				willShowNewScene()
			end
		else
			willShowNewScene()
		end
	else
		
	end
end

function director.gotoScene(...)
	local arguments = {...}
	
	director.hideOverlay()
	
	if #arguments == 1 then
		local sceneName = arguments[1]
		director.showScene(sceneName)
	elseif #arguments == 2 then
		local sceneName = arguments[1]
		local options = arguments[2]
		director.showScene(sceneName, 1, options)
	elseif #arguments == 3 then
		local sceneName = arguments[1]
		local zIndex = arguments[2]
		local options = arguments[3]
		director.showScene(sceneName, zIndex, options)
	end
end

function director.showOverlay(sceneName, options)
	local currentSceneName = director.getSceneName("current")
	local parentScene = director.getScene(currentSceneName)
	local currentOverlayName = director.getSceneName("overlay")
	if sceneName ~= currentOverlayName then
		director.showScene(sceneName, DEFAULT_ZINDEX_OVERLAY, options, parentScene)
	end
end

function director.hideOverlay(...)
	local arguments = {...}
	
	local recycleOnly, effectName, effectTime
	if #arguments == 1 then
		effectName = arguments[1]
	elseif #arguments == 2 then
		effectName = arguments[1]
		effectTime = arguments[2]
	elseif #arguments == 3 then
		recycleOnly = arguments[1]
		effectName = arguments[2]
		effectTime = arguments[3]
	end
	
	if director.showingScenes[DEFAULT_ZINDEX_OVERLAY] and director.showingScenes[DEFAULT_ZINDEX_OVERLAY].currentScene then
		disableTouchEvents()
		
		local currentSceneName = director.getSceneName("current")
		local parentScene = director.getScene(currentSceneName)
		
		local overlay = director.showingScenes[DEFAULT_ZINDEX_OVERLAY].currentScene
		director.hideScene(overlay._name, effectName, effectTime, parentScene)
		
		enableTouchEvents()
	end
end

function director.hideScene(sceneName, effectName, effectTime, parentScene)
	local scene = director.sceneDictionary[sceneName]
	if scene and scene.view then
		effectName = effectName or EFFECT_DEFAULT
		effectTime = effectTime or EFFECT_TIME_DEFAULT
		local transitionEffect = LIST_EFFECTS[effectName].from
		
		scene.view.x = transitionEffect.xStart or 0
		scene.view.y = transitionEffect.yStart or 0
		scene.view.alpha = transitionEffect.alphaStart or 1.0
		scene.view.xScale = transitionEffect.xScaleStart or 1.0
		scene.view.yScale = transitionEffect.yScaleStart or 1.0
		scene.view.rotation = transitionEffect.rotationStart or 0
		
		local function onHideTransitionComplete()
			scene.view.isVisible = false
			scene._modalView.isHitTestable = false
				
			cancelSceneTimers(scene)
			cancelSceneTransitions(scene)
			local event = extratable.deepcopy(scene._eventData.onDidHide)
			event.effectTime = effectTime
			event.parent = parentScene
			eventDispatcher(scene, event)
			director.showingScenes[scene.zIndex][scene.sceneSlot] = nil
			display.getCurrentStage():setFocus(nil)
		end

		local transitionOptions = {
			x = transitionEffect.xEnd,
			y = transitionEffect.yEnd,
			alpha = transitionEffect.alphaEnd,
			xScale = transitionEffect.xScaleEnd,
			yScale = transitionEffect.yScaleEnd,
			rotation = transitionEffect.rotationEnd,
			time = effectTime,
			transition = transitionEffect.transition,
			onComplete = onHideTransitionComplete
		}
		
		local event = extratable.deepcopy(scene._eventData.onWillHide)
		event.parent = parentScene
		event.effectTime = effectTime
		eventDispatcher(scene, event)
		
		transition.cancel(scene.view)
		if effectTime > 0 then
			local hideTransition = transition.to( scene.view, transitionOptions ) 
		else
			onHideTransitionComplete()
		end
	end
end

function director.setVariable(variableName, value)
	variables[variableName] = value
end

function director.getVariable(variableName)
	return variables[variableName]
end

function director.removeHidden(shouldRecycle)
	local currentSceneName = director.getSceneName("current")
	local currentOverlayName = director.getSceneName("overlay")
	for sceneName, scene in pairs(director.sceneDictionary) do
		if sceneName ~= currentSceneName and sceneName ~= currentOverlayName then
			director.purgeScene(sceneName, shouldRecycle)
		end
	end
end

function director.purgeScene(sceneName, shouldRecycle)
	local scene = director.sceneDictionary[sceneName]
	if scene and scene.view then
		
		local event = extratable.deepcopy(scene._eventData.onDestroy)
		eventDispatcher(scene, event)
		
		if scene.view then
			display.remove( scene.view )
			scene.view = nil
			if not shouldRecycle then
				director.sceneDictionary[sceneName] = nil
			end
			collectgarbage( "collect" )
		end
	else
		if not scene then
			logger.error([[[Director] Can't purge scene "]]..sceneName..[[". It does not exist.]])
		elseif scene and not scene.view then
			logger.error([[[Director] Can't purge scene "]]..sceneName..[[". It does not have a view.]])
		end
	end
end

function director.reloadScene(sceneName)
	local scene = director.sceneDictionary[sceneName]
	if scene and scene.view then
		local event = extratable.deepcopy(scene._eventData.onWillHide)
		eventDispatcher(scene, event)
		local event = extratable.deepcopy(scene._eventData.onDidHide)
		eventDispatcher(scene, event)
		local event = extratable.deepcopy(scene._eventData.onWillShow)
		eventDispatcher(scene, event)
		local event = extratable.deepcopy(scene._eventData.onDidShow)
		eventDispatcher(scene, event)
	end
end

function director.to(sceneName, target, params)
	local scene = director.sceneDictionary[sceneName]
	if scene and scene._transitions then
		scene._transitions[#scene._transitions + 1] = transition.to(target, params)
	end
end

function director.from(sceneName, target, params)
	local scene = director.sceneDictionary[sceneName]
	if scene and scene._transitions then
		scene._transitions[#scene._transitions + 1] = transition.from(target, params)
	end
end

function director.performWithDelay(sceneName, delay, listener, iterations)
	local scene = director.sceneDictionary[sceneName]
	if scene and scene._timers then
		scene._timers[#scene._timers + 1] = timer.performWithDelay(delay, listener, iterations)
	end
end

function director.setDebug(doDebug)
	debugDirector = doDebug
end
----------------------------------------------- Execution
initialize()

return director

