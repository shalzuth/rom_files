local baseCell = autoImport("BaseCell")
GuildRewardCell = class("GuildRewardCell", baseCell)

autoImport("ItemCell");

GuildRewardCellEvent = {
	GetReward = 1,
}

function GuildRewardCell:Init()
	local grid = self:FindComponent("Grid", UIGrid);
   	self.ctl = UIGridListCtrl.new(grid , ItemCell, "ItemCell");

   	local getButton = self:FindGO("GetButton");
   	self:AddClickEvent(getButton, function ()
   		self:PassEvent(GuildRewardCellEvent.GetReward, self);
   	end);

   	self.scoreLabel = self:FindComponent("Score", UILabel);
end

function GuildRewardCell:SetData(data)
	-- self.scoreLabel.text = 0;

	-- self.ctl:ResetDatas();
end
