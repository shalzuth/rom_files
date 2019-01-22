GOManager_Light = class("GOManager_Light")

function GOManager_Light:ctor()
	
end

function GOManager_Camera:Clear()
	self:SetSun(nil)
end

function GOManager_Light:GetSun()
	return self.sun
end

function GOManager_Light:SetSun(sun)
	self.sun = sun
	Game.EnviromentManager:SetSkyboxSun(sun)
end

function GOManager_Light:ClearSun(obj)
	if nil ~= self.sun and self.sun.gameObject == obj.gameObject then
		self:SetSun(nil)
		return true
	end
	return false
end

function GOManager_Light:RegisterGameObject(obj)
	local objID = obj.ID
	Debug_AssertFormat(1 == objID, "RegisterLight({0}) invalid id: {1}", obj, objID)
	
	local light = obj.gameObject:GetComponent(Light)
	Debug_AssertFormat(nil ~= light, "RegisterLight({0}) no light: {1}", obj, objID)
	
	self:SetSun(light)
	return true
end

function GOManager_Light:UnregisterGameObject(obj)
	if not self:ClearSun(obj) then
		Debug_AssertFormat(false, "UnregisterLight({0}) failed: {1}", obj, obj.ID)
		return false
	end

	return true
end

