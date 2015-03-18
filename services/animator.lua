local spine = require ("libs.helpers.spine")
local animator = {}

---------------------constants
local SPEED_ANIMATION = 0.03
local FACTOR_ANIMATION = 0.6

--local animatorParams = {
--    skinName = "Camila",
--    skeletonFile = "/heroes/skeleton.json",
--    imagePath = "/heroes/",
--}

local function createCharacter(characterData)

	characterData = characterData or {}

	local skin  = characterData.skin or "Eagle"
	local skeletonFile = characterData.skeletonFile or "heroes/skeleton.json"
	local imagePath = characterData.imagePath or "heroes/"
	local attachmentPath = characterData.attachmentPath or "characters/attachments/"
	local scale = characterData.scale or 1
        
	local json = spine.SkeletonJson.new()
	json.scale = scale
        
	local skeletonData = json:readSkeletonDataFile(skeletonFile)
	local spineCharacter = spine.Skeleton.new(skeletonData)
        
	spineCharacter:setSkin(skin)
	spineCharacter:setToSetupPose()
	spineCharacter:setSlotsToSetupPose()
	spineCharacter:setBonesToSetupPose()

	function spineCharacter:createImage(attachment)
		if string.find(attachment.name, "hat") then
                    return display.newImage(attachmentPath .. "hats/"..attachment.name..".png")
                elseif string.find(attachment.name, "proyectile") then
                    return display.newImage(attachmentPath .. "proyectiles/"..attachment.name..".png")
		else
                    return display.newImage(imagePath .. self.skin.name.."/"..attachment.name..".png")
		end
	end
	
	local animationStateData = spine.AnimationStateData.new(skeletonData)
	local animationState = spine.AnimationState.new(animationStateData)
        
	function spineCharacter.enterFrame()
		spineCharacter:update()
	end

	function spineCharacter.setAnimationMix(startAnimation, endAnimation, time)
		time = time or 0.1
		animationStateData:setMix(startAnimation, endAnimation, time)
	end
        
	function spineCharacter.setAnimationStack(params)
		if params then
			local loopAnimation = false
			for animationIndex = 1, #params.actions do
				if animationIndex == #params.actions then loopAnimation = true end
				animationState:addAnimationByName(0, params.actions[animationIndex], loopAnimation, params.delays[animationIndex])
			end

		end
	end
        
	function spineCharacter.newAnimationState()
	   animationState = spine.AnimationState.new(animationStateData)
	end

	function spineCharacter:update()
		animationState:update(SPEED_ANIMATION * FACTOR_ANIMATION)
		animationState:apply(self)
		self:updateWorldTransform()
	end
	
	function spineCharacter:setAnimation(animation, loop)
		animationState:setAnimationByName(0, animation, loop)
	end
        
	function spineCharacter:setSlotAttachment(slotName, attachment)

	if not slotName then error("slotName cannot be nil.", 2) end
		for i,slot in ipairs(self.slots) do
			if slot.data.name == slotName then
				if not attachment then 
					slot:setAttachment(nil)
				else
					slot:setAttachment(attachment)
				end
				return
			end
		end
		error("Slot not found = " .. slotName, 2)
	end
        
	function spineCharacter:setNewAttachment(attachmentName, type)
		if type then
			local attachment = self:getAttachment (type, type)
			attachment.name = attachmentName
			self:setSlotAttachment(type, nil)
			self:update()
			if attachmentName then
				self:setSlotAttachment(type, attachment)
			end
		else
			print("Attachment type cannot be nil, i did nothing!")
		end
		
	end
        
	function spineCharacter:setOrientation(orientation)
		self.flipY = false
		if orientation == "right" then
			self.flipX = false
		elseif orientation == "left" then
			self.flipX = true
		end
	end
	
	return spineCharacter
end


function animator.newCharacter(skin, skeletonPath, imagePath, scale)
	return createCharacter(skin, skeletonPath, imagePath, scale)
end


return animator


