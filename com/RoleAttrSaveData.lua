autoImport("UserData")
autoImport("RolePropsContainer")
RoleAttrSaveData = class("RoleAttrSaveData")

function RoleAttrSaveData:ctor(serverdata)
	self.userdata = UserData.CreateAsTable()
	self.userAttr = RolePropsContainer.CreateAsTable()
	self:SetUserData(serverdata.datas)
	self:SetUserAttr(serverdata.attrs)
end

function RoleAttrSaveData:SetUserData(serverdata)
	local sdata
	for i = 1, #serverdata do
		sdata = serverdata[i]
		if sdata ~= nil then
			self.userdata:SetByID(sdata.type,sdata.value,sdata.data)
		end
	end
end

function RoleAttrSaveData:SetUserAttr(serverAttrs)
	local sdata
	for i = 1, #serverAttrs do
		sdata = serverAttrs[i]
		if sdata ~= nil then
			self.userAttr:SetValueById(sdata.type,sdata.value)
		end
	end
end

function RoleAttrSaveData:GetUserData()
	return self.userdata
end

function RoleAttrSaveData:GetUserAttr()
	return self.userAttr
end

function RoleAttrSaveData:OnDestroy()
	if(self.userdata)then
		self.userdata:DestroySelf();
	end
	if(self.userAttr)then
		self.userAttr:DestroySelf();
	end
end