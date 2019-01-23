
AdventureAppendRewardItemData = class("AdventureAppendRewardItemData")

function AdventureAppendRewardItemData:ctor(id)
	
	self:initStaticData()
	self:updateData(serverData)
end

function AdventureAppendRewardItemData:updateData( serverData )
	-- body
	self.process = serverData.process
	self.finish = serverData.finish
	self.rewardget = serverData.rewardget
end
