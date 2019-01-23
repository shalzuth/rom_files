DojoData = class("DojoData")

function DojoData:ctor(data)
	self:SetData(data)
end

function DojoData:SetData(data)
	self.id = data.id
	self.isCompleted = false
	self.isChoose = false
end

function DojoData:SetComplete(isCompleted)
	self.isCompleted = isCompleted	
end

function DojoData:SetChoose(isChoose)
	self.isChoose = isChoose
end

function DojoData:SetLock(isLock)
	self.isLock = isLock
end

function DojoData:GetLock()
	if self.isLock ~= nil then
		return self.isLock
	end
	
	return DojoProxy.Instance:IsLockById(self.id)
end