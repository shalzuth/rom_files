GOManager_SceneGuildFlag = class("GOManager_SceneGuildFlag")

local tempVector2 = LuaVector2.zero

function GOManager_SceneGuildFlag:ctor()
	self.objects = {}
	self.renderers = {}
end

function GOManager_SceneGuildFlag:Clear()
	TableUtility.TableClear(self.objects)
	TableUtility.TableClear(self.renderers)
end

local function GetStrongHoldId_(obj, flagid)
	local strongHoldId = tonumber(obj:GetProperty(0))
	if nil ~= strongHoldId then
		return strongHoldId
	end
	return flagId
end

function GOManager_SceneGuildFlag:SetIcon(strongHoldId, icon, offsetX, offsetY, scaleX, scaleY)
	local flagObjects = self.objects
	for flagId, obj in pairs(flagObjects) do
		local shID = GetStrongHoldId_(obj, flagId)
		if shID == strongHoldId then
			self:SetFlagIcon(flagId, icon, offsetX, offsetY, scaleX, scaleY);
		end
	end
end

function GOManager_SceneGuildFlag:SetFlagIcon(flagID, icon, offsetX, offsetY, scaleX, scaleY)
	local obj = self.objects[flagID]
	if nil == obj then
		return
	end
	local renderer = self.renderers[flagID]
	if nil == renderer then
		if nil == icon then
			return 
		end
		renderer = obj:GetComponentProperty(0)
		self.renderers[flagID] = renderer
	else
		if nil == icon then
			renderer.material = nil
			renderer.materials = _EmptyTable
			self.renderers[flagID] = nil
			return
		end
	end
	renderer.material = Game.Prefab_SceneGuildIcon.sharedMaterial
	renderer.material.mainTexture = icon

	if nil ~= offsetX and nil ~= offsetY then
		tempVector2:Set(offsetX, offsetY)
		renderer.material.mainTextureOffset = tempVector2
	end
	if nil ~= scaleX and nil ~= scaleY then
		tempVector2:Set(scaleX, scaleY)
		renderer.material.mainTextureScale = tempVector2
	end
end

function GOManager_SceneGuildFlag:SetFlag(obj, ID)
	self.objects[ID] = obj
	if nil ~= obj then
		local renderer = obj:GetComponentProperty(0)
		renderer.material = nil
		renderer.materials = _EmptyTable
	else
		self.renderers[ID] = nil
	end
end

function GOManager_SceneGuildFlag:OnClick(obj)
	-- helplog("Guild Flag Clicked", obj.ID)
	local strongHoldId = GetStrongHoldId_(obj, obj.ID)
	FunctionVisitNpc.AccessGuildFlag(strongHoldId, obj.transform)
end

function GOManager_SceneGuildFlag:ClearFlag(obj)
	local objID = obj.ID
	local testObj = self.objects[objID]
	if nil ~= testObj and testObj == obj then
		self:SetFlag(nil, objID)
		return true
	end
	return false
end

function GOManager_SceneGuildFlag:RegisterGameObject(obj)
	if GameConfig.SystemForbid.GVG then 
    	GameObject.Destroy(obj.gameObject)
		return true
	end
	local objID = obj.ID
	Debug_AssertFormat(0 < objID, "RegisterSceneGuildFlag({0}) invalid id: {1}", obj, objID)

	self:SetFlag(obj, objID)
	return true
end

function GOManager_SceneGuildFlag:UnregisterGameObject(obj)
	if not self:ClearFlag(obj) then
		Debug_AssertFormat(false, "UnregisterSceneGuildFlag({0}) failed: {1}", obj, obj.ID)
		return false
	end

	return true
end
