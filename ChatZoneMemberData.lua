ChatZoneMemberData = reusableClass("ChatZoneMemberData" , SocialData)

function ChatZoneMemberData:SetData(data)

	ChatZoneMemberData.super.SetData(self,data)

	if data.rolejob then
		self.rolejob = data.rolejob	--???????????????
	end
end

function ChatZoneMemberData:SetOwner(ownerid)
	--????????????????????????
	self.owner = self.id == ownerid
end

function ChatZoneMemberData:DoDeconstruct(asArray)
	ChatZoneMemberData.super.DoDeconstruct(self,asArray)

	self.owner = nil
	self.rolejob = nil
end