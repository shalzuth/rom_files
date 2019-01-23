GOManager_CullingObject = class("GOManager_CullingObject")

local CullingType = Game.GameObjectType.CullingObject

function GOManager_CullingObject:ctor()
	self.objects = {}
	self.idPool = {}
	self.maxID = 0
end

function GOManager_CullingObject:Clear()
	TableUtility.TableClear(self.objects)
end

function GOManager_CullingObject:GetCullingObject(ID)
	return self.objects[ID]
end

function GOManager_CullingObject:SetCullingObject(obj, ID)
	if nil ~= obj then
		Debug_AssertFormat(nil == self.objects[ID], "SetCullingObject({0}) duplicate id: {1}", obj, ID)
	end
	self.objects[ID] = obj
end

function GOManager_CullingObject:ClearCullingObject(obj, ID)
	if obj == self.objects[ID] then
		self:SetCullingObject(nil, ID)
		return true
	end
	return false
end

function GOManager_CullingObject:RegisterGameObject(obj)
	local objID = 1
	if 0 < #self.idPool then
		objID = TableUtility.ArrayPopBack(self.idPool)
	else
		objID = self.maxID+1
		self.maxID = objID
	end
	obj.ID = objID
	self:SetCullingObject(obj, objID)

	-- register
	Game.CullingObjectManager:Register_CullingObject(obj)
	return true
end

function GOManager_CullingObject:UnregisterGameObject(obj)
	local objID = obj.ID
	if not self:ClearCullingObject(obj, objID) then
		Debug_AssertFormat(false, "UnregisterCullingObject({0}) failed: {1}", obj, obj.ID)
		return false
	else
		TableUtility.ArrayPushBack(self.idPool, objID)
	end
	Game.CullingObjectManager:Unregister_CullingObject(obj)
	return true
end
