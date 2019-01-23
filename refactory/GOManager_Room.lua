GOManager_Room = class("GOManager_Room")

function GOManager_Room:ctor()
	self.hideObjects = {}
end

function GOManager_Room:Clear()
	TableUtility.TableClear(self.hideObjects)
end

function GOManager_Room:GetHideObject(ID)
	return self.hideObjects[ID]
end

function GOManager_Room:SetHideObject(go, ID)
	self.hideObjects[ID] = go
end

function GOManager_Room:ClearHideObject(obj)
	local objID = obj.ID
	local go = self.hideObjects[objID]
	if nil ~= go and go == obj.gameObject then
		self:SetHideObject(nil, objID)
		return true
	end
	return false
end

function GOManager_Room:RegisterGameObject(obj)
	local objID = obj.ID
	Debug_AssertFormat(0 < objID, "RegisterRoomHideObject({0}) invalid id: {1}", obj, objID)

	self:SetHideObject(obj.gameObject, objID)
	return true
end

function GOManager_Room:UnregisterGameObject(obj)
	if not self:ClearHideObject(obj) then
		Debug_AssertFormat(false, "UnregisterRoomHideObject({0}) failed: {1}", obj, obj.ID)
		return false
	end

	return true
end
