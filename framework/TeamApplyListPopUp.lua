TeamApplyListPopUp = class("TeamApplyListPopUp", ContainerView)

TeamApplyListPopUp.ViewType = UIViewType.PopUpLayer
autoImport("TeamApplyCell");

local teamProxy;

function TeamApplyListPopUp:Init()
	teamProxy = TeamProxy.Instance;
	
	self:InitUI();
	self:AddViewEvts();
end

function TeamApplyListPopUp.ServerProxy()
	return ServiceSessionTeamProxy.Instance;
end

function TeamApplyListPopUp:OnEnter()
	TeamApplyListPopUp.super.OnEnter(self);
	RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_TEAMAPPLY)
	RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_TEAMAPPLY);
end

-- 先临时处理返回
function TeamApplyListPopUp:OnExit()
	TeamApplyListPopUp.super.OnExit(self);
end

function TeamApplyListPopUp:InitUI()
	local page = self:FindGO("TeamApply");
	local grid = self:FindComponent("ApplyGrid", UIGrid, page);
	self.applyInfoCtl = UIGridListCtrl.new(grid, TeamApplyCell, "TeamApplyCell");
	self.applyInfoCtl:SetDisableDragIfFit();
	-- 清除申请列表
	local clearButton = self:FindGO("ClearApplyButton", page);
	self:AddClickEvent(clearButton, function (go)
		self.ServerProxy():CallClearApplyList();
	end)
	self:AddButtonEvent("CloseApplyButton", function (go)
		page:SetActive(false);
	end);
	self.noneTip = self:FindGO("NoneTip");

	self:UpdateApplyList();
end

function TeamApplyListPopUp:UpdateApplyList( )
	local applylst;
	if(teamProxy:IHaveTeam())then
		applylst = teamProxy.myTeam:GetApplyList();
	else
		applylst = {};
	end
	self.applyInfoCtl:ResetDatas(applylst);	
	self.noneTip:SetActive(#applylst == 0);
end

function TeamApplyListPopUp:AddViewEvts()
	self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.UpdateApplyList);
  	self:AddListenEvt(ServiceEvent.SessionTeamClearApplyList, self.UpdateApplyList);
	self:AddListenEvt(ServiceEvent.SessionTeamTeamApplyUpdate, self.UpdateApplyList);
	self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberApply, self.UpdateApplyList);
end