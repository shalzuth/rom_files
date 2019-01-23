autoImport("BaseView");
PoringFightTipView = class("PoringFightTipView", BaseView)

autoImport("GoldAppleTipCell");

local LIMIT_SCORE = 2;

PoringFightTipView.ViewType = UIViewType.Lv4PopUpLayer

function PoringFightTipView:Init()
	self:InitView();
	self:MapEvent();
end

function PoringFightTipView:InitView()
	local grid = self:FindComponent("Grid", UIGrid);
	self.materialCtl = UIGridListCtrl.new(grid, GoldAppleTipCell, "GoldAppleTipCell");

	local testData = { true, true },
	self.materialCtl:ResetDatas(testData);

	self.label = self:FindComponent("Label", UILabel);
	self.label.text = string.format(ZhString.PoringFightTipView_MonsterTip, LIMIT_SCORE);
end

function PoringFightTipView:Update()

	local fightInfo = PvpProxy.Instance:GetFightStatInfo();
	local score = fightInfo.score;

	local datas = {};
	for i=1,LIMIT_SCORE do
		table.insert(datas, i <= score);
	end

	self.materialCtl:ResetDatas(datas);

	self.label.text = string.format(ZhString.PoringFightTipView_MonsterTip, LIMIT_SCORE - score);
end

function PoringFightTipView:MapEvent()
	self:AddListenEvt(ServiceEvent.MatchCCmdNtfFightStatCCmd, self.Update);	
end

function PoringFightTipView:OnEnter()
	PoringFightTipView.super.OnEnter(self);

	self:Update();
end