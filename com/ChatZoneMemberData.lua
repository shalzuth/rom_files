ChatZoneMemberData = reusableClass("ChatZoneMemberData" , SocialData)

function ChatZoneMemberData:SetData(data)

	ChatZoneMemberData.super.SetData(self,data)

	if data.rolejob then
		self.rolejob = data.rolejob	--用于聊天室
	end
end

function ChatZoneMemberData:SetOwner(ownerid)
	--是否为聊天室房主
	self.owner = self.id == ownerid
end

function ChatZoneMemberData:DoDeconstruct(asArray)
	ChatZoneMemberData.super.DoDeconstruct(self,asArray)

	self.owner = nil
	self.rolejob = nil
end