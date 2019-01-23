GuildRewardPopUp = class("GuildRewardPopUp", SubView)

GuildRewardPopUp.ViewType = UIViewType.PopUpLayer

autoImport("GuildRewardCell");

function GuildRewardPopUp:Init()	
	self:InitView();
	self:MapEvents();
end

function GuildRewardPopUp:InitView( )
	self.score = self:FindComponent("Score", UILabel);
	
	local rewardGrid = self:FindComponent("Grid", UIGrid);
	self.rewardCtl = UIGridListCtrl.new(rewardGrid , GuildRewardCell, "GuildRewardCell");
	self.rewardCtl:AddEventListener(GuildRewardCellEvent.GetReward, self.GetReward, self)	
end

function GuildRewardPopUp:GetReward(cell)
	local data = cell.data;
	if(data)then
		-- GetReward
	end
end

function GuildRewardPopUp:UpdateRewardList()
	local list = {};
	self.rewardCtl:ResetDatas(list);

	-- self.score.text = 1000;
end

function GuildRewardPopUp:MapEvents()
	-- self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.UpdateRewardList);
end

function GuildRewardPopUp:OnEnter()
	GuildRewardPopUp.super.OnEnter(self);
end
