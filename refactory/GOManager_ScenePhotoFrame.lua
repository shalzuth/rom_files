GOManager_ScenePhotoFrame = class("GOManager_ScenePhotoFrame")

local FramePhotoWidth = 822
local FramePhotoHeight = 462
local FramePhotoAspect = FramePhotoWidth / FramePhotoHeight
local FramePhotoAspectReverse = FramePhotoHeight / FramePhotoWidth

local tempVector3 = LuaVector3.zero

function GOManager_ScenePhotoFrame:ctor()
	self.objects = {}
	self.renderers = {}
end

function GOManager_ScenePhotoFrame:Clear()
	TableUtility.TableClear(self.objects)
	TableUtility.TableClear(self.renderers)
end

function GOManager_ScenePhotoFrame:SetPhoto(frameID, photo, photoWidth, photoHeight, angleZ)
	local obj = self.objects[frameID]
	if nil == obj then
		return
	end
	local renderer = self.renderers[frameID]
	if nil == renderer then
		if nil == photo then
			return 
		end
		renderer = obj:GetComponentProperty(0)
		self.renderers[frameID] = renderer
	else
		if nil == photo then
			renderer.material = nil
			renderer.materials = _EmptyTable
			self.renderers[frameID] = nil
			return
		end
	end
	renderer.material = Game.Prefab_ScenePhoto.sharedMaterial
	renderer.material.mainTexture = photo

	-- fit scale mode

	-- local frameAspect = nil
	-- if photoWidth > photoHeight then
	-- 	-- horizontal
	-- 	frameAspect = FramePhotoAspect
	-- else
	-- 	-- vertical
	-- 	frameAspect = FramePhotoAspectReverse
	-- end
	-- local aspect = photoWidth / photoHeight
	-- if aspect < frameAspect then
	-- 	-- change width
	-- 	tempVector3:Set(aspect/frameAspect, 1, 1)
	-- else
	-- 	-- change height
	-- 	tempVector3:Set(1, frameAspect/aspect, 1)
	-- end

	-- renderer.transform.localEulerAngles = tempVector3

	-- fill scale mode
	-- tempVector3:Set(0,0,0)
	tempVector3:Set(LuaGameObject.GetLocalEulerAngles(renderer.transform));

	local frameDir = Table_ScenePhotoFrame[frameID].Dir
	local frameAspect = nil
	local scaleX = 1
	local scaleY = 1
	if 0 == frameDir then
		-- horizontal
		frameAspect = FramePhotoAspect
	else
		-- vertical
		if 45 <= angleZ and 135 >= angleZ then
			-- tempVector3:Set(0,0,270)
			tempVector3[3] = 270
			frameAspect = FramePhotoAspect
			scaleX = FramePhotoAspect
			scaleY = FramePhotoAspectReverse
		elseif 225 <= angleZ and 315 >= angleZ then
			-- tempVector3:Set(0,0,90)
			tempVector3[3] = 90
			frameAspect = FramePhotoAspect
			scaleX = FramePhotoAspect
			scaleY = FramePhotoAspectReverse
		else
			frameAspect = FramePhotoAspectReverse
		end
	end

	renderer.transform.localEulerAngles = tempVector3

	tempVector3:Set(LuaGameObject.GetLocalScale(renderer.transform));

	local aspect = photoWidth / photoHeight
	if aspect < frameAspect then
		-- change height
		-- tempVector3:Set(scaleX, scaleY*(frameAspect/aspect), 1)
		tempVector3[1] = scaleX
		tempVector3[2] = scaleY*(frameAspect/aspect)

		renderer.material:SetFloat("_CutX", 0)
		renderer.material:SetFloat("_CutY", (1-aspect/frameAspect)*0.5)
	else
		-- change width
		-- tempVector3:Set(scaleX*(aspect/frameAspect), scaleY, 1)
		tempVector3[1] = scaleX*(aspect/frameAspect)
		tempVector3[2] = scaleY

		renderer.material:SetFloat("_CutX", (1-frameAspect/aspect)*0.5)
		renderer.material:SetFloat("_CutY", 0)
	end
	renderer.transform.localScale = tempVector3
end

function GOManager_ScenePhotoFrame:SetPhotoFrame(obj, ID)
	self.objects[ID] = obj
	if nil ~= obj then
		local renderer = obj:GetComponentProperty(0)
		renderer.material = nil
		renderer.materials = _EmptyTable
	else
		self.renderers[ID] = nil
	end
end

function GOManager_ScenePhotoFrame:OnClick(obj)
	local renderer = self.renderers[obj.ID]
	if nil ~= renderer then
		Game.PictureWallManager:ClickFrame(obj.ID,renderer)
	else
		Game.PictureWallManager:ClickFrame(obj.ID,obj)
	end
end

function GOManager_ScenePhotoFrame:ClearPhotoFrame(obj)
	local objID = obj.ID
	local testObj = self.objects[objID]
	if nil ~= testObj and testObj == obj then
		self:SetPhotoFrame(nil, objID)
		return true
	end
	return false
end

function GOManager_ScenePhotoFrame:RegisterGameObject(obj)
	local objID = obj.ID
	Debug_AssertFormat(0 < objID, "RegisterScenePhotoFrame({0}) invalid id: {1}", obj, objID)

	self:SetPhotoFrame(obj, objID)
	return true
end

function GOManager_ScenePhotoFrame:UnregisterGameObject(obj)
	if not self:ClearPhotoFrame(obj) then
		Debug_AssertFormat(false, "UnregisterScenePhotoFrame({0}) failed: {1}", obj, obj.ID)
		return false
	end

	return true
end
