AdventureAppendData = class("AdventureAppendData")

AdventureAppendData.RewardDataType = {
	empty = 1,
	normal = 2,
	special = 3,
	monstUnlock = 4,
	buffer = 5,
}
function AdventureAppendData:ctor(serverData)
	self.staticId = serverData.id
	self:initStaticData()
	self:updateData(serverData)
end

function AdventureAppendData:updateData( serverData )
	-- body
	self.process = serverData.process
	self.finish = serverData.finish
	self.rewardget = serverData.rewardget
end

function AdventureAppendData:initStaticData(  )
	-- body
	self.staticData = Table_AdventureAppend[self.staticId]
	if(self.staticData)then
		self.appendName = self.staticData.NameZh
		local rewards = ItemUtil.GetRewardItemIdsByTeamId(self.staticData.Reward)
		if(not rewards)then
			LogUtility.WarningFormat("can't find reward in Table_Reward reward id:{0} by Table_AdventureAppend id :{1}",self.staticData.Reward,self.staticId)
			return
		end
		table.sort(rewards ,function ( l,r )
			-- body
			return l.id < r.id
		end)
		local specialList = {}
		self.rewardItemDatas = {}
		self.normalItemDatas = {}
		self.specialItemDatas = {}
		for i=1,#rewards do
			local single = rewards[i]
			local itemData = Table_Item[single.id]
			if(itemData)then
				local data = {}
				if(ItemUtil.CheckItemIsSpecialInAdventureAppend(itemData.Type))then
					data.type = AdventureAppendData.RewardDataType.special
					data.text = string.format(ZhString.AdventureAppendRewardPanel_Unlock,itemData.NameZh)
					table.insert(specialList,data)
					table.insert(self.specialItemDatas,single)
				else
					data.type = AdventureAppendData.RewardDataType.normal
					data.text = string.format("%sx%d",itemData.NameZh,single.num)
					data.icon = itemData.Icon
					table.insert(self.rewardItemDatas,data)
					table.insert(self.normalItemDatas,single)
				end
			end
		end		

		if(#self.rewardItemDatas%2 ~= 0)then
			local data = {}
			data.type = AdventureAppendData.RewardDataType.empty
			table.insert(self.rewardItemDatas,data)
		end

		for i=1,#specialList do
			local single = specialList[i]
			table.insert(self.rewardItemDatas,single)
			local data = {}
			data.type = AdventureAppendData.RewardDataType.empty
			table.insert(self.rewardItemDatas,data)
		end

		if(self.staticData.BuffID)then
			local data = {}
			local str = ItemUtil.getBufferDescByIdNotConfigDes(self.staticData.BuffID) or "";
			data.text = string.format(ZhString.AdventureAppendRewardPanel_BufferUnlock,str)
			data.type = AdventureAppendData.RewardDataType.buffer
			table.insert(self.rewardItemDatas,data)
			
			data = {}
			data.type = AdventureAppendData.RewardDataType.empty
			table.insert(self.rewardItemDatas,data)
		end

		local isPhoto = self.staticData.Content == QuestDataStepType.QuestDataStepType_SELFIE
		local isMonster = self.staticData.Type == SceneManual_pb.EMANUALTYPE_MONSTER
		if( isPhoto and isMonster)then
			self.isMonstUnlock = true
			local data = {}
			data.type = AdventureAppendData.RewardDataType.monstUnlock
			data.text = ZhString.AdventureAppendRewardPanel_MonstUnlock
			table.insert(self.rewardItemDatas,data)
		end		
	end
end

function AdventureAppendData:getNormalRewardItems(  )
	-- body
	return self.normalItemDatas
end

function AdventureAppendData:getSpecialRewardItems(  )
	-- body
	return self.specialItemDatas
end

function AdventureAppendData:isMonstUnlock(  )
	-- body
	return self.isMonstUnlock
end

function AdventureAppendData:isCompleted(  )
	-- body
	return self.finish and not self.rewardget
end

function AdventureAppendData:getRewardItems(  )
	-- body
	return self.rewardItemDatas
end

function AdventureAppendData:getAppendName(  )
	-- body
	return self.appendName
end

function AdventureAppendData:getProcessInfo(  )
	-- body
	if(self.staticData)then
		self.traceInfo = self.staticData.Desc
		local tableValue = self:getTranceInfoTable()
		if(tableValue == nil)then
			return "parse table text is nil:"..self.traceInfo
		end
		local result = self.traceInfo and string.gsub(self.traceInfo,'%[(%w+)]',tableValue) or ''
		return result
	end
end

function AdventureAppendData:getTranceInfoTable( )
	-- body
	local table = {}
	local questType = self.staticData.Content
	if( questType == QuestDataStepType.QuestDataStepType_SELFIE)then
		local id = self.staticData.targetID
		local infoTable = Table_Monster[id]
		if(infoTable == nil)then
			infoTable = Table_Npc[id]
		end

		if(infoTable ~= nil)then
			table = {
					param2 = nil,
					monsterName = infoTable.NameZh,
				}
		else
			errorLog("AdventureAppendData can't find mosntData in Table_Monster by targetID:",id)
		end
		
	elseif(questType == QuestDataStepType.QuestDataStepType_KILL)then
		local process = self.process
		local id = self.staticData.targetID
		local totalNum = self.staticData.Params[1]
		local infoTable = Table_Monster[id]
		if(infoTable == nil)then
			infoTable = Table_Npc[id]
		end
		if(infoTable ~= nil)then
			table = {			
					monsterName = infoTable.NameZh,
					num = string.format("[c][0077BBFF]%s[-][/c]",process..'/'..totalNum)
				}
		else
			print("AdventureAppendData can't find mosntData in Table_Monster by targetID:",id)
		end
	elseif(questType == "active")then
		local process = self.process
		local totalNum = self.staticData.Params[1]
		table = {
				num = string.format("[c][0077BBFF]%s[-][/c]",tostring(process)..'/'..tostring(totalNum))
			}
			
	end
	return table
end

-- function AdventureAppendData.getAppendData( type,staticId )
-- 	-- body
-- 	local list
-- 	for k,v in pairs(Table_AdventureAppend) do
-- 		if(v.Type == type and staticId == v.targetID)then
-- 			local data = AdventureAppendData.new(v)
-- 			list = list or {}
-- 			table.insert(list,data)
-- 		end
-- 	end
-- 	return list
-- end
