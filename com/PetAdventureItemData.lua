autoImport("PetDropItemData")
PetAdventureItemData = class("PetAdventureItemData")

function PetAdventureItemData:SetData(serviceItemData)
	self.id = serviceItemData.id
	self.specid = serviceItemData.specid
	self.staticData = Table_Pet_Adventure[self.id]
	self.startTime = serviceItemData.starttime
	self.status = serviceItemData.status

	self.rareReward={}
	for i=1,#serviceItemData.raresreward do
		local guid = serviceItemData.raresreward[i].base.guid
		local id = serviceItemData.raresreward[i].base.id
		local count = serviceItemData.raresreward[i].base.count
		local dropItemData = PetDropItemData.new(guid,id)
		dropItemData:SetCount(count)
		self.rareReward[#self.rareReward+1]=dropItemData
	end
	local rewardinfo = serviceItemData.rewardinfo
	local isSpecial = self.staticData.QuestType==1
	self.rewardMap ={}
	self.multiMonsterReward=(self.status==PetAdventureProxy.QuestPhase.MATCH  and not isSpecial)
	if(rewardinfo)then
		if(self.multiMonsterReward)then
			for i=1,#rewardinfo do
				local reward = rewardinfo[i]
				local monsID = reward.monsterid
				local petDropItem = {}
				for j=1,#reward.items do
					local guid = reward.items[j].base.guid
					local id = reward.items[j].base.id
					local count = reward.items[j].base.count
					local dropItemData = PetDropItemData.new(guid,id)
					dropItemData:SetCount(count)
					petDropItem[#petDropItem+1]=dropItemData
				end
				self.rewardMap[monsID]=petDropItem
			end
		else
			local servItem=rewardinfo[1].items
			local petDropItem = {}
			for i=1,#servItem do
				local guid = servItem[i].base.guid
				local id = servItem[i].base.id
				local count = servItem[i].base.count
				local dropItemData = PetDropItemData.new(guid,id)
				dropItemData:SetCount(count)
				petDropItem[#petDropItem+1]=dropItemData
			end
			self.rewardMap=petDropItem
		end
	end

	self.petEggs={}
	local serviceEggs = serviceItemData.eggs
	if(serviceEggs)then
		for i=1,#serviceEggs do
			local itemInfo = serviceEggs[i].base
			if(itemInfo and itemInfo.guid and ''~=itemInfo.guid)then
				local item = ItemData.new(itemInfo.guid,itemInfo.id)
				local PetInfo = PetEggInfo.new(item.staticData)
				PetInfo:Server_SetData(serviceEggs[i].egg)
				PetInfo.guid=itemInfo.guid
				table.insert(self.petEggs, PetInfo)
			else
				table.insert(self.petEggs, 0)
			end
		end
	end
end