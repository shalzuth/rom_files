local baseCell = autoImport("BaseCell")
RecallContractCell = class("RecallContractCell", baseCell)

function RecallContractCell:Init()
	self:FindObjs()
end

function RecallContractCell:FindObjs()
	self.content = self.gameObject:GetComponent(UILabel)
end

function RecallContractCell:SetData(data)
	self.data = data

	if data then
		local id = data.id
		local useItem = Table_UseItem[id]
		if useItem ~= nil and useItem.UseEffect.type == "addbuff" then
			local buff = Table_Buffer[useItem.UseEffect.id]
			if buff ~= nil then
				self.content.text = string.format(ZhString.Friend_RecallRewardBuff, GameConfig.Recall.RewardBuffDuringTime, buff.BuffName)
			end
		else
			local item = Table_Item[id]
			if item then
				self.content.text = string.format(ZhString.Friend_RecallRewardItem, data.num, item.NameZh)
			end
		end
	end
end