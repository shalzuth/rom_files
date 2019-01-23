local baseCell = autoImport("BaseCell")
QuestTableRewardCell = class("QuestTableRewardCell", baseCell)

function QuestTableRewardCell:Init()
	
	self.rewardName = self:FindComponent("rewardName",UILabel)
end

function QuestTableRewardCell:SetData(config)
	local msg = config.text
	if(config.event)then
		if(config.event.type == "scenery")then
			local _,viewindex = next(config.event.param);
			if(viewindex and Table_Viewspot[viewindex])then
				local pointName = Table_Viewspot[viewindex].SpotName;
				msg = string.format(msg, pointName);
			end
		elseif(config.event.type == "unlockmanual")then
			local viewindex = config.event.param[2];
			if(viewindex)then
				local mapName = Table_Map[viewindex].CallZh;
				msg = string.format(msg, mapName);
			end
		end
	end
	self.rewardName.text = msg
end