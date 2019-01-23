WeddingInviteData = class("WeddingInviteData")

function WeddingInviteData:ctor(data)
	
end

function WeddingInviteData:SetFriendData(data)
	if data ~= nil then
		self.guid = data.guid
		self.level = data.level
		self.portrait = data.portrait
		self.hairID = data.hairID
		self.haircolor = data.haircolor
		self.bodyID = data.bodyID
		self.headID = data.headID
		self.faceID = data.faceID
		self.mouthID = data.mouthID
		self.eyeID = data.eyeID
		self.profession = data.profession
		self.gender = data.gender
		self.name = data.name
		self.offlinetime = data.offlinetime
	end
end

function WeddingInviteData:SetGuildData(data)
	if data ~= nil then
		self.guid = data.id
		self.level = data.baselevel
		self.portrait = data.portrait
		self.hairID = data.hair
		self.haircolor = data.haircolor
		self.bodyID = data.body
		self.headID = data.head
		self.faceID = data.face
		self.mouthID = data.mouth
		self.eyeID = data.eye
		self.profession = data.profession
		self.gender = data.gender
		self.name = data.name
		self.offlinetime = data.offlinetime
	end
end

function WeddingInviteData:SetCreatureData(data)
	if data ~= nil then
		self.guid = data.id
		self.name = data.name

		local userdata = data.userdata
		self.level = userdata:Get(UDEnum.ROLELEVEL)
		self.portrait = userdata:Get(UDEnum.PORTRAIT)
		self.hairID = userdata:Get(UDEnum.HAIR)
		self.haircolor = userdata:Get(UDEnum.HAIRCOLOR)
		self.bodyID = userdata:Get(UDEnum.BODY)
		self.headID = userdata:Get(UDEnum.HEAD)
		self.faceID = userdata:Get(UDEnum.FACE)
		self.mouthID = userdata:Get(UDEnum.MOUTH)
		self.eyeID = userdata:Get(UDEnum.EYE)
		self.profession = userdata:Get(UDEnum.PROFESSION)
		self.gender = userdata:Get(UDEnum.SEX)
	end
end

function WeddingInviteData:SetInvited(isInvited)
	self.isInvited = isInvited
end