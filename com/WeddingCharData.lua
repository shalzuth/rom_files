WeddingCharData = class("WeddingCharData")

function WeddingCharData:ctor(data)
	self:SetData(data)
end

function WeddingCharData:SetData(data)
	if data then
		self.charid = data.charid
		self.name = data.name
		self.profession = data.profession
		self.level = data.level
		self.guildname = data.guildname
		self:SetHeadData(data)
	end
end

function WeddingCharData:SetHeadData(data)
	self.gender = data.gender
	self.portrait = data.portrait
	self.hairID = data.hair
	self.haircolor = data.haircolor
	self.bodyID = data.body
	self.headID = data.head
	self.faceID = data.face
	self.mouthID = data.mouth
	self.eyeID = data.eye	
end