GOManager_DynamicObject = class("GOManager_DynamicObject")

function GOManager_DynamicObject:ctor()
	self.objects = {}
end

function GOManager_DynamicObject:Clear()
	TableUtility.TableClear(self.objects)
	Game.DynamicObjectManager:Clear()
end

function GOManager_DynamicObject:GetDynamicObject(ID)
	return self.objects[ID]
end

function GOManager_DynamicObject:SetDynamicObject(obj, ID)
	self.objects[ID] = obj
	Game.DynamicObjectManager:SetDynamicData(ID, obj)
end

function GOManager_DynamicObject:ClearDynamicObject(obj)
	local objID = obj.ID
	local testObj = self.objects[objID]
	if nil ~= testObj and testObj == obj then
		self:SetDynamicObject(nil, objID)
		return true
	end
	return false
end

function GOManager_DynamicObject:RegisterGameObject(obj)
	local objID = obj.ID
	Debug_AssertFormat(0 < objID, "RegisterDynamicObject({0}) invalid id: {1}", obj, objID)

	self:SetDynamicObject(obj, objID)
	return true
end

function GOManager_DynamicObject:UnregisterGameObject(obj)
	if not self:ClearDynamicObject(obj) then
		Debug_AssertFormat(false, "UnregisterDynamicObject({0}) failed: {1}", obj, obj.ID)
		return false
	end

	return true
end
