TreasureItemData = class("TreasureItemData")

local function getMemberData(id)
	local myGuildData = GuildProxy.Instance.myGuildData
	if(myGuildData)then
		local memberData = myGuildData:GetMemberByGuid(id)
		return  memberData
	end
	return nil
end

function TreasureItemData:ctor(serverdata)
	self.charid = serverdata.charid
	self.name = serverdata.name
	local items = serverdata.datas
	self.ItemData = {}
	for i=1,#items do
		if(items[i].base)then
			local item = {}
			item.id = items[i].base.id
			item.num = items[i].base.count
			TableUtility.ArrayPushBack(self.ItemData,item)
		end
	end
end

function TreasureItemData:GetCharName()
	local memberData = getMemberData(self.charid)
	if(memberData)then
		return memberData.name
	end
	return ""
end


TreasureResultData = class("TreasureResultData")

function TreasureResultData:ctor()
	self.treasureItems = {}
end

function TreasureResultData:Server_SetData(serverdata)
	self.guid = serverdata.guid
	self.treasureID = serverdata.treasureid
	self.onwerID = serverdata.ownerid
	self.totalMember = serverdata.totalmember
	self.state = serverdata.state
	TableUtility.ArrayClear(self.treasureItems)
	local items = serverdata.items
	for i=1,#items do
		local cell = items[i]
		cell = TreasureItemData.new(cell)
		TableUtility.ArrayPushBack(self.treasureItems,cell)
	end
end

function TreasureResultData:GetMemberData()
	if(self.onwerID)then
		return getMemberData(self.onwerID)
	end
	return nil
end

function TreasureResultData:GetOwnerName()
	local memberData = getMemberData(self.onwerID)
	if(memberData)then
		return  memberData.name
	end
	return ""
end

function TreasureResultData:IsEmpty()
	return #self.treasureItems<=0
end

function TreasureResultData:GetResultItems()
	return self.treasureItems
end

function TreasureResultData:GetPrecent()
	local myGuildData = GuildProxy.Instance.myGuildData
	local all = self.totalMember
	local per = string.format(ZhString.GuildTreasure_RewardPer,#self.treasureItems,all)
	return per
end


