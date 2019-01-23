local baseCell = autoImport("BaseCell")
GvgQuestTableCell = class("GvgQuestTableCell", baseCell)

function GvgQuestTableCell:Init()
	GvgQuestTableCell.super.Init(self);	
	self.questName = self:FindComponent("questName",UILabel)
	self.icon = self:FindComponent("icon",UISprite)
	self.rewardName = self:FindComponent("rewardName",UILabel)
	self.rewardCount = self:FindComponent("rewardCount",UILabel)
end

function GvgQuestTableCell:SetData(data)
	local key = data.key
	local value = data.value
	local configData = GameConfig.GVGConfig.reward[GvgProxy.GvgQuestMap[key]]

	if(configData)then
		local index = 1
		local dataInfo
		local maxRound = #configData > index and #configData or index
		if(key == FuBenCmd_pb.EGVGDATA_KILLUSER)then
			self.rewardName.text = ZhString.MainViewGvgPage_GvgQuestTip_KillUser
			self.rewardCount.text = "x"..configData.count
			local itemData = Table_Item[configData.itemid]
			if(itemData)then
				IconManager:SetItemIcon(itemData.Icon,self.icon)
			end
			self.questName.text = string.format(ZhString.MainViewGvgPage_GvgQuestTip_KillUserDes,value)
			return
		end
		while true do
			if((configData[index] and configData[index].times > value) or index > maxRound)then
				if(index > maxRound)then
					dataInfo = configData[maxRound]
				else
					dataInfo = configData[index]
				end
				self.rewardName.text = string.format(dataInfo.desc,value <= dataInfo.times and value or dataInfo.times)
				self.rewardCount.text = "x"..dataInfo.count
				local itemData = Table_Item[dataInfo.itemid]
				if(itemData)then
					IconManager:SetItemIcon(itemData.Icon,self.icon)
				end
				if(key == FuBenCmd_pb.EGVGDATA_KILLMETAL)then
					self.questName.text = configData.desc
				elseif(configData[maxRound].times <= value)then
					self.questName.text = string.format(configData.desc,ZhString.AnnounceQuestPanel_Complete)
				elseif(key == FuBenCmd_pb.EGVGDATA_HONOR)then
					local str = string.format("%s/%s",(value <= 1200 and value or GameConfig.GVGConfig.reward.max_honor),(GameConfig.GVGConfig.reward.max_honor or 1200))
					self.questName.text = string.format(configData.desc,str)
				else
					local str = string.format("%s/%s",index-1,maxRound)
					self.questName.text = string.format(configData.desc,str)
				end
				break
			end
			index = index+1
		end
	end
	-- self.data = data
	-- local level = data.staticData.Name.Level
	-- level = level and "Lv."..level or ""
	-- self.questName.text = data.staticData.Name..level
	-- self.checkBox.value = data.trace
	-- local rewards = QuestProxy.Instance:getValidReward(data)
	-- rewards = rewards or {}
	-- self.rewardList:ResetDatas(rewards)
end
