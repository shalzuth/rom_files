local baseCell = autoImport("BaseCell")
QuestTableCell = class("QuestTableCell", baseCell)

function QuestTableCell:Init()
	QuestTableCell.super.Init(self);	
	self:AddCellClickEvent();
	self.selectedBg = self:FindGO("selectedBg")
	self.questName = self:FindComponent("questName",UILabel)
	local grid = self:FindComponent("RewardGrid",UIGrid)
	self.rewardList = UIGridListCtrl.new(grid,QuestTableRewardCell,"QuestTableRewardCell")
	self.checkBox = self:FindComponent("checkBoxBg",UIToggle)
	self:AddButtonEvent("checkBox",function (  )
		-- body
		-- self:PassEvent(PicutureWallSyncPanel.CellSelectedChange, self)
		ServiceQuestProxy.Instance:CallQuestGroupTraceQuestCmd(self.data.id,not self.data.trace)
		self.checkBox.value = not self.data.trace
	end)
	self:setIsSelected(false)
end

function QuestTableCell:setIsSelected( isSelected )
	-- body
	if(self.isSelected ~= isSelected)then
		self.isSelected = isSelected
		if(isSelected)then			
			self:Show(self.selectedBg)
		else
			self:Hide(self.selectedBg)
		end
	end
end

function QuestTableCell:SetData(data)
	self.data = data
	local level = data.staticData.Name.Level
	level = level and "Lv."..level or ""
	self.questName.text = data.staticData.Name..level
	self.checkBox.value = data.trace
	local rewards = QuestProxy.Instance:getValidReward(data)
	rewards = rewards or {}
	self.rewardList:ResetDatas(rewards)
end
