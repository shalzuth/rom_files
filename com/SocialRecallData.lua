SocialRecallData = class("SocialRecallData")

function SocialRecallData:ctor(data)
	self:SetData(data)
end

function SocialRecallData:SetData(data)
	self.guid = data.charid
end

function SocialRecallData:GetName()
	return Game.SocialManager:GetName(self.guid)
end