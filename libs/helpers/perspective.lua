---------------------------------------------- Perspective
local path = ...
local folder = path:match("(.-)[^%.]+$")
local logger = require( folder.."logger" ) 

local Perspective={}
---------------------------------------------- Cache
local mathAbs = math.abs
local mathHuge = math.huge

local ccx = display.contentCenterX
local ccy = display.contentCenterY
local vcw = display.viewableContentWidth
local vch = display.viewableContentHeight
---------------------------------------------- Functions
function Perspective.newCamera(numLayers)
	logger.log("[Perspective] Creating view.")
	numLayers = (type(numLayers)=="number" and numLayers) or 8

	local isTracking = false
	local layer = {}
	local camera = display.newGroup()
	camera.scrollX = 0
	camera.scrollY = 0
	camera.damping = 10
	camera.values = {
		x1 = 0,
		x2 = vcw,
		y1 = 0,
		y2 = vch,
		prevDamping = 10,
		damping = 0.1
	}
	
	for index = numLayers, 1, -1 do
		layer[index] = display.newGroup()
		layer[index].parallaxRatio = 1
		layer[index]._isPerspectiveLayer = true
		camera:insert(layer[index])
	end
	
	function camera:add(object, level, isFocus)
		local isFocus = isFocus or false
		local level = level or 4
		
		layer[level]:insert(object)
		object.layer=level
		
		if isFocus then
			camera.values.focus = object
		end
		
		function object:toLayer(newLayer)
			if layer[newLayer] then
				layer[newLayer]:insert(self)
				self._perspectiveLayer = newLayer
			end
		end
		
		function object:back()
			if layer[object._perspectiveLayer + 1] then
				local backLayer = layer[object._perspectiveLayer+1]
				backLayer:insert(object)
				object._perspectiveLayer = object.layer+1
			end
		end
		
		function object:forward()
			if layer[object._perspectiveLayer - 1] then
				local frontLayer = layer[object._perspectiveLayer - 1]
				frontLayer:insert(object)
				object._perspectiveLayer=object.layer - 1
			end
		end
		
		function object:toCameraFront()
			layer[1]:insert(object)
			object._perspectiveLayer = 1
			object:toFront()
		end
		
		function object:toCameraBack()
			layer[numLayers]:insert(object)
			object._perspectiveLayer=numLayers
			object:toBack()
		end
	end
	
	function camera:setZoom(zoomLevel, zoomDelay, zoomTime)
		zoomLevel = zoomLevel or 1
		zoomDelay = zoomDelay or 0
		zoomTime = zoomTime or 500
		local targetScale = (1 - zoomLevel) * 0.5
		transition.cancel(camera)
		transition.to(camera, {xScale = zoomLevel, yScale = zoomLevel, x = display.viewableContentWidth * targetScale, y = display.viewableContentHeight * targetScale, time = zoomTime, delay = zoomDelay, transition = easing.inOutQuad})
	end
	
	function camera.trackFocus()
		if camera.values.prevDamping ~= camera.damping then
			camera.values.prevDamping = camera.damping
			camera.values.damping = 1 / camera.damping
		end
		
		if camera.values.focus then
			layer[1].parallaxRatio = 1
			camera.scrollX, camera.scrollY = layer[1].x, layer[1].y
			for index = 1, numLayers do
				
				if camera.values.focus.x <= camera.values.x2 and camera.values.focus.x >= camera.values.x1 then
					if camera.damping ~= 0 then
						layer[index].x = (layer[index].x - (layer[index].x - (-camera.values.focus.x + ccx) * layer[index].parallaxRatio) * camera.values.damping)
					else
						layer[index].x = -camera.values.focus.x+ccx*layer[index].parallaxRatio
					end
				else
					if mathAbs(camera.values.focus.x-camera.values.x1) < mathAbs(camera.values.focus.x - camera.values.x2) then
						if camera.damping ~= 0 then
							layer[index].x = (layer[index].x - (layer[index].x - (-camera.values.x1 + ccx) * layer[index].parallaxRatio) * camera.values.damping)
						else
							layer[index].x = -camera.values.x1 + ccx * layer[index].parallaxRatio
						end
					elseif mathAbs(camera.values.focus.x - camera.values.x1) > mathAbs(camera.values.focus.x - camera.values.x2) then
						if camera.damping ~= 0 then
							layer[index].x = (layer[index].x - (layer[index].x - (-camera.values.x2 + ccx) * layer[index].parallaxRatio) * camera.values.damping)
						else
							layer[index].x = -camera.values.x2 + ccx * layer[index].parallaxRatio
						end
					end
				end
				
				if camera.values.focus.y <= camera.values.y2 and camera.values.focus.y >= camera.values.y1 then
					if camera.damping ~= 0 then
						layer[index].y = (layer[index].y - (layer[index].y - (-camera.values.focus.y + ccy) * layer[index].parallaxRatio) * camera.values.damping)
					else
						layer[index].y = -camera.values.focus.y + ccy * layer[index].parallaxRatio
					end
				else
					if mathAbs(camera.values.focus.y - camera.values.y1) < mathAbs(camera.values.focus.y - camera.values.y2) then
						if camera.damping ~= 0 then
							layer[index].y = (layer[index].y - (layer[index].y - (-camera.values.y1 + ccy) * layer[index].parallaxRatio) * camera.values.damping)
						else
							layer[index].y = -camera.values.y1 + ccy * layer[index].parallaxRatio
						end
					elseif mathAbs(camera.values.focus.y - camera.values.y1) > mathAbs(camera.values.focus.y - camera.values.y2) then
						if camera.damping ~= 0 then
							layer[index].y = (layer[index].y-(layer[index].y-(-camera.values.y2+ccy)*layer[index].parallaxRatio)*camera.values.damping)
						else
							layer[index].y = -camera.values.y2 + ccy * layer[index].parallaxRatio
						end
					end
				end
			end
		end
	end
	
	function camera:start()
		if not isTracking then
			isTracking=true
			Runtime:addEventListener("enterFrame", camera.trackFocus)
		end
	end
	
	function camera:stop()
		if isTracking then
			Runtime:removeEventListener("enterFrame", camera.trackFocus)
			isTracking=false
		end
	end
	
	function camera:setBounds(x1, x2, y1, y2)
		local x = x1
		local x2 = x2
		local y = y1
		local y2 = y2
		
		if "boolean" == type(x) then
			camera.values.x1, camera.values.x2, camera.values.y1, camera.values.y2 =- mathHuge, mathHuge, -mathHuge, mathHuge
		else
			camera.values.x1, camera.values.x2, camera.values.y1, camera.values.y2 = x1, x2, y1, y2
		end
		
		logger.log("[Perspective] Bounds set.")
	end
	
	function camera:toPoint(x, y)
		local x = x or ccx
		local y = y or ccy
		
		camera:stop()
		local tempFocus={x = x, y = y}
		camera:setFocus(tempFocus)
		camera:start()
		
		return tempFocus
	end
	
	function camera:setFocus(object)
		camera.values.focus = object
	end
	
	function camera:layer(index)
		return layer[index]
	end
	
	function camera:setParallax(...)
		for index = 1, #arg do 
			layer[index].parallaxRatio = arg[index]
		end
	end
	
	function camera:remove(object)
		if object and layer[object._perspectiveLayer] then
			layer[object._perspectiveLayer]:remove(object)
		end
	end
	
	function camera:destroy()
		for indexA = 1, numLayers do
			for indexB = 1, #layer[indexA] do
				layer[indexA]:remove(layer[indexA][indexB])
			end
		end
		
		if isTracking then
			Runtime:removeEventListener("enterFrame", camera.trackFocus)
		end
		display.remove(camera)
		camera = nil
		
		logger.log("[Perspective] Deleted view.")
	end
	
	return camera
end

return Perspective

