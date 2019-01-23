MainViewTeamPage = class("MainViewTeamPage", SubView);

autoImport("TMInfoCell");

local teamProxy;

function MainViewTeamPage:Init()
	teamProxy = TeamProxy.Instance;
	
	self:InitUI();
	self:MapViewListener();
end

function MainViewTeamPage:InitUI()
	local teamButton = self:FindGO("TeamButton");
	local rClickBg = teamButton:GetComponent(UISprite);
	FunctionUnLockFunc.Me():RegisteEnterBtnByPanelID(PanelConfig.TeamMemberListPopUp.id, teamButton);
	
	self:AddClickEvent(teamButton, function (go)
		if(not teamProxy:IHaveTeam())then
			self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TeamFindPopUp});
		else
			self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TeamMemberListPopUp}) 
		end
	end);
	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TEAMAPPLY, teamButton, 42)

	local teamGrid = self:FindComponent("TeamGrid", UIGrid);
	self.teamCtl = UIGridListCtrl.new(teamGrid, TMInfoCell, "TMInfoCell");
	self.teamCtl:AddEventListener(MouseEvent.MouseClick, self.ClickTeamPlayer, self);

	self.playerTipStick = self:FindComponent("PlayerTipStick", UIWidget);
end

function MainViewTeamPage:ClickTeamPlayer(cellCtl)
	local data = cellCtl.data;
	if(data == MyselfTeamData.EMPTY_STATE)then
		FunctionPlayerTip.Me():CloseTip();
		self.nowClickMember = nil;

		if(not teamProxy:IHaveTeam())then
			self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TeamFindPopUp});
		else
			self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TeamInvitePopUp}) 
		end
	elseif(data ~= nil)then
		if(self.nowClickMember ~= cellCtl)then
			local playerTip = FunctionPlayerTip.Me():GetPlayerTip(self.playerTipStick, NGUIUtil.AnchorSide.Right);
			local funckeys;
			if(data.cat~=nil and data.cat ~= 0)then
				funckeys = {"ShowDetail", "KickMember", "FireHireman", "ReHireCat"};
				if(data.masterid ~= nil and data.masterid == Game.Myself.data.id)then
					local attriFunction = Game.Myself.data:GetProperty("AttrFunction")
					local pos = CommonFun.AttrFunction.HandEnable or 1;
					local serverCanJoinHand = (attriFunction >> (pos-1)) & 1 == 1;
					if(serverCanJoinHand)then
						local handFollowerId = Game.Myself:Client_GetHandInHandFollower();
						if(handFollowerId == data.id)then
							table.insert(funckeys, 3, "CancelJoinHand");
						else
							table.insert(funckeys, 3, "InviteJoinHand");
						end
					end
				end
				table.insert(funckeys, "Double_Action")
			else
				funckeys = FunctionPlayerTip.Me():GetPlayerFunckey(data.id);
				table.insert(funckeys, "Double_Action")
			end
			local playerData = PlayerTipData.new();
			playerData:SetByTeamMemberData(data);

			local tipData = {
				playerData = playerData,
				funckeys = funckeys,
				callback = nil,
			};
			playerTip:SetData(tipData);
			playerTip.closecallback = function ()
				self.nowClickMember = nil;
			end
			playerTip:AddIgnoreBound(cellCtl.gameObject);
			self.nowClickMember = cellCtl;

			local role = NSceneUserProxy.Instance:Find(data.id);
			if(role == nil)then
				role = NSceneNpcProxy.Instance:Find(data.id);
			end
			if(role~=nil)then
				Game.Myself:Client_LockTarget(role);
			end
		else
			FunctionPlayerTip.Me():CloseTip();
			self.nowClickMember = nil;
		end
	end
end

function MainViewTeamPage:UpdateTeamMember()
	if(teamProxy.myTeam)then
		local memberlst = teamProxy.myTeam:GetMemberListWithAdd();
		if(memberlst)then
			self.teamCtl:ResetDatas(memberlst);
		end
	else
		self.teamCtl:ResetDatas({MyselfTeamData.EMPTY_STATE});
	end
end

function MainViewTeamPage:UpdateMemberPos()
	local cells = self.teamCtl:GetCells();
	for i=1,#cells do
		cells[i]:UpdateMemberPos();
	end
end

function MainViewTeamPage:MapViewListener()
	self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.UpdateTeamMember);
	self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.UpdateTeamMember);
	self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.UpdateTeamMember);
	self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateTeamMember);
	self:AddListenEvt(ServiceEvent.SessionTeamExchangeLeader, self.UpdateTeamMember);
	self:AddListenEvt(TeamEvent.MemberOffline, self.UpdateTeamMember);

	self:AddListenEvt(ServiceEvent.SessionTeamQuickEnter, self.HandleQuickEnter);
	-- self:AddListenEvt(ServiceEvent.SessionTeamMemberPosUpdate, self.UpdateMemberPos);
	self:AddListenEvt(LoadSceneEvent.FinishLoad,self.HandleMapChange);

	-- 牵手跟谁
	self:AddListenEvt(ServiceEvent.NUserBeFollowUserCmd,self.HandleFollowStateChange);
	-- self:AddListenEvt(ServiceEvent.NUserFollowerUser, self.HandleFollowStateChange);
	self:AddDispatcherEvt(FunctionFollowCaptainEvent.StateChanged, self.HandleFollowStateChange);
end

function MainViewTeamPage:HandleMapChange(note)
	FunctionTeam.Me():CheckChangeTeamGoal();
end

function MainViewTeamPage:HandleQuickEnter( note )
	local members = self.teamCtl:GetCells();
	for _,member in pairs(members)do
		member:UpdateEmptyState();
	end
end

function MainViewTeamPage:HandleFollowStateChange(note)
	local members = self.teamCtl:GetCells();
	for _,member in pairs(members)do
		member:UpdateFollow();
	end

	self:BreakOrJoinHandTip();
end

function MainViewTeamPage:BreakOrJoinHandTip()
	local followId = Game.Myself:Client_GetFollowLeaderID();
	local isHandFollow = Game.Myself:Client_IsFollowHandInHand();
	local handFollowerId = Game.Myself:Client_GetHandInHandFollower();

	local handTargetId = isHandFollow and followId or handFollowerId
	if self.cacheHandTargetId == handTargetId then
		return
	end
	if 0 ~= handTargetId then
		if nil ~= self.cacheHandTargetName then
			-- show break old
			MsgManager.ShowMsgByIDTable(886, self.cacheHandTargetName);
		end
		
		self.cacheHandTargetId = handTargetId
		local memberData = teamProxy.myTeam and teamProxy.myTeam:GetMemberByGuid(handTargetId);
		if(memberData)then
			self.cacheHandTargetName = memberData.name;
			if nil ~= self.cacheHandTargetName then
				-- show hand new
				MsgManager.ShowMsgByIDTable(885, self.cacheHandTargetName);
			end
		else
			self.cacheHandTargetName = nil
		end
	else
		if nil ~= self.cacheHandTargetId then
			if nil ~= self.cacheHandTargetName then
				-- show break old
				MsgManager.ShowMsgByIDTable(886, self.cacheHandTargetName);
			end
			self.cacheHandTargetId = nil
			self.cacheHandTargetName = nil
		end
	end
end

function MainViewTeamPage:OnEnter()
	MainViewTeamPage.super.OnEnter(self);
	self:UpdateTeamMember();
end







