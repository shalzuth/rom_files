local InnerTreasure = class("InnerTreasure")

function InnerTreasure:SetData(id,count)
	self.id=id
	self.count=count
end


GuildTreasureData = class("GuildTreasureData")
autoImport("GuildTreasureRewardData")

function GuildTreasureData:ctor(id,count)
	local treasure = InnerTreasure.new();
	treasure:SetData(id,count)
	self.treasureID = treasure.id
	self.staticData=Table_Guild_Treasure[id]
	self.gvgCount = treasure.count
	self.rewardItems={}
	if(self.staticData)then
		self:SetTreasure()
	end
end


function GuildTreasureData:SetTreasure()
	local data = self.staticData
	if(data.GuildReward)then	
		for i=1,#data.GuildReward do
			local rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(data.GuildReward[i]);
			if(rewardTeamids)then
				for _,data in pairs(rewardTeamids)do
					local item = GuildTreasureRewardData.new("Reward", data.id);
					item.num = data.num;
					item:SetType(ZhString.GuildTreasure_GuildAssetType);
					self.rewardItems[#self.rewardItems+1]=item;
				end
			end
		end
	end
	local myGuildData = GuildProxy.Instance.myGuildData;
	local openCount = myGuildData.bcoin_treasure_count+1;
	-- local memberNum = myGuildData.memberNum
	if(data.GuildMemberReward)then
		local staticCount = #data.GuildMemberReward
		openCount = math.min(openCount,staticCount)
		local rewardData = data.GuildMemberReward[openCount]
		if(not rewardData)then return end 
		for i=1,#rewardData do
			local rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(rewardData[i]);
			if(rewardTeamids)then
				for _,data in pairs(rewardTeamids)do
					local item = GuildTreasureRewardData.new("Reward", data.id);
					item.num = data.num
					item:SetType(ZhString.GuildTreasure_GuildMemberType);
					self.rewardItems[#self.rewardItems+1]=item;
				end
			end
		end
	end
end

function GuildTreasureData:isLotteryType()
	if(self.staticData)then
		return self.staticData.Type==2
	end
	return false
end

function GuildTreasureData:GetReward()
	return self.rewardItems
end

function GuildTreasureData:GetName()
	if(self.staticData)then
		return self.staticData.Name
	end
	return ""
end

function GuildTreasureData:SetTreasureCount(gc,bc)
	self.guild_treasure_count=gc
	self.bcoin_treasure_count=bc
end





