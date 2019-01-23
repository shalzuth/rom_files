autoImport("ItemData")
GuildTreasureRewardData = class("GuildTreasureRewardData",ItemData)

function GuildTreasureRewardData:SetType(t)
	self.typeName = t
end

function GuildTreasureRewardData:GetName()
	return self.staticData.NameZh
end

function GuildTreasureRewardData:GetTypeName()
	return self.typeName
end




