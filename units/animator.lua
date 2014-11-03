local spine = require ("libs.helpers.spine")
local animator = {}

function animator.createCharacter(skin, cType, skeletonPath, imagePath)
	local spineCharacter = {}
	spineCharacter.currentAnimation = nil
	local frameCounter = 0
	
	local SPEED_ANIMATION = 0.03
	local FACTOR_ANIMATION = 0.4

	local json = spine.SkeletonJson.new()
	json.scale = 0.8
	
	local characterType = cType
	local skinName = skin
	local skeletonPath = skeletonPath
	local skeletonData = json:readSkeletonDataFile(skeletonPath)
	
	spineCharacter = spine.Skeleton.new(skeletonData)

	function spineCharacter.setOrientation(orientation)
		spineCharacter.flipY = false
		if orientation == "right" then
			spineCharacter.flipX = false
		elseif orientation == "left" then
			spineCharacter.flipX = true
		end
	end
	
	spineCharacter.setOrientation("right")

	function spineCharacter:createImage(attachment)
		if string.find(attachment.name, "hat") then
			return display.newImage(imagePath .. "hats/"..attachment.name..".png")
		else
			return display.newImage(imagePath .. self.skin.name.."/"..attachment.name..".png")
		end
	end
	
	spineCharacter:setToSetupPose()
	spineCharacter:setSkin(skin)

	local animationStateData = spine.AnimationStateData.new(skeletonData)
	animationStateData:setMix("WALK", "IDLE", 0.05)
	animationStateData:setMix("WIN", "IDLE", 0.05)
	animationStateData:setMix("LOSE", "IDLE", 0.05)
	local animationState = spine.AnimationState.new(animationStateData)

	function spineCharacter:update()
		animationState:update(SPEED_ANIMATION * FACTOR_ANIMATION)
		animationState:apply(self)
		self:updateWorldTransform()
	end
	
	function spineCharacter.enterFrame()
		spineCharacter:update()
	end
	
	function spineCharacter:setAnimation(animation)
		spineCharacter.currentAnimation = animation
		animationState:setAnimationByName(1, animation, true)
	end
	
	
	function spineCharacter:setAnimationAndIdle(animation)
		spineCharacter.currentAnimation = animation
		animationState:setAnimationByName(1, animation, false)
		local animationIdle = "IDLE"
		animationState:addAnimationByName(1, animationIdle, true, 0)
	end
	
	function spineCharacter:animationWin()
		
		local animationIndex = math.random(1,3)
		if animationIndex == 1 then
			spineCharacter:setAnimationAndIdle("WIN")
		elseif animationIndex == 2 then
			spineCharacter:setAnimationAndIdle("RIGHT")
		elseif animationIndex == 3 then
			spineCharacter:setAnimationAndIdle("APPLAUSE")
		end
	end
	
	function spineCharacter:animationLose(animation)
		local animationIndex = math.random(1,2)
		if animationIndex == 1 then
			spineCharacter:setAnimationAndIdle("LOSE")
		elseif animationIndex == 2 then
			spineCharacter:setAnimationAndIdle("WRONG")
		end
	end
	
	function spineCharacter:setHat(hatName)
		local attachHat = self:getAttachment ("hat", "hat")
		attachHat.name = hatName
		self:setSlotAttachment("hat", nil)
		self:update()
		if hatName then
			self:setSlotAttachment("hat", attachHat)
		end
	end
	
	return spineCharacter
end


function animator.newCharacter(skin, cType, skeletonPath, imagePath)
	return animator.createCharacter(skin, cType, skeletonPath, imagePath)
end


return animator


