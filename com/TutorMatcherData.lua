autoImport("UserData")
TutorMatcherData = class("TutorMatcherData")

function TutorMatcherData:ctor(serverdata)
	self.userdata = UserData.CreateAsTable()
	self:ResetData(serverdata)
end

function TutorMatcherData:SetUserData(serverdata)
	local sdata
	for i = 1, #serverdata do
		sdata = serverdata[i]
		if sdata ~= nil then
			self.userdata:SetByID(sdata.type,sdata.value,sdata.data)
			redlog("userdata type value",sdata.type,sdata.value)
		end
	end
end

function TutorMatcherData:ResetData(serverdata)
	if serverdata then
		self.charid = serverdata.charid
		self:SetUserData(serverdata.datas)
		self.findtutor = serverdata.findtutor	
		self.profession = self.userdata:Get(UDEnum.PROFESSION)
		self.level = self.userdata:Get(UDEnum.ROLELEVEL)
		self.portrait = self.userdata:Get(UDEnum.PORTRAIT)
		self.gender = self.userdata:Get(UDEnum.SEX)
		self.name = self.userdata:GetBytes(UDEnum.NAME)
		self.hairID = self.userdata:Get(UDEnum.HAIR)
		self.headID = self.userdata:Get(UDEnum.HEAD)
		self.faceID = self.userdata:Get(UDEnum.FACE)
		self.mouthID = self.userdata:Get(UDEnum.MOUTH)
		self.bodyID = self.userdata:Get(UDEnum.BODY)
		self.eyeID = self.userdata:Get(UDEnum.EYE)
		redlog("hairID eyeID",self.hairID,self.eyeID)
	end

end

function TutorMatcherData:GetUserData()
	return self.userdata
end

function TutorMatcherData:GetCharID()
	return self.charid
end

function TutorMatcherData:FindTutor()
	return self.findtutor
end

function TutorMatcherData:OnDestroy()
	if self.userdata then
		self.userdata:DestroySelf()
	end
end