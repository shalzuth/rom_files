TeamMemberListPopUp = class("TeamMemberListPopUp", ContainerView)

TeamMemberListPopUp.ViewType = UIViewType.NormalLayer

autoImport("TeamMemberCell");

function TeamMemberListPopUp:Init()
	self:InitView();
	self:MapEvent();
end

function TeamMemberListPopUp:InitView()
	self.teamName = self:FindComponent("TeamName", UILabel);
	self.pickUpMode = self:FindComponent("PickUpMode", UILabel);
	self.teamLevel = self:FindComponent("TeamLevel", UILabel);
	
	local listGrid = self:FindComponent("MemberGrid", UIGrid);
	self.memberlist = UIGridListCtrl.new(listGrid, TeamMemberCell, "TeamMemberCell");
	self.memberlist:AddEventListener(MouseEvent.MouseClick, self.ClickTeamMember, self);

	local applyPageButton = self:FindGO("ApplyListButton");
	self.applyPageButton = applyPageButton:GetComponent(UIButton);
	----[[ todo xde 调整字体大小
	local btnLabel = self:FindGO("Label", applyPageButton):GetComponent(UILabel)
	btnLabel.overflowMethod = 2
	btnLabel.width = 164
	btnLabel.transform.localPosition = Vector3(0,4,0)
	--]]

	self:AddClickEvent(applyPageButton, function (go)
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TeamApplyListPopUp}) 
	end);
	local applyPageButtonBg = applyPageButton:GetComponent(UISprite);
	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TEAMAPPLY, applyPageButtonBg, 25)

	local leaveButton = self:FindGO("LeaveTeamButton");
	self:AddClickEvent(leaveButton, function (go)
		FunctionPlayerTip.LeaverTeam()
	end);

	local inviteMemberButton = self:FindGO("InviteMemberButton");
	self.inviteMemberButton = inviteMemberButton:GetComponent(UIButton);
	self:AddClickEvent(inviteMemberButton, function (go)
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TeamInvitePopUp}) 
	end);

	self.optionButton = self:FindGO("OptionButton");
	self:AddClickEvent(self.optionButton, function (go)
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TeamOptionPopUp}) 
	end);

	self.inviteAllButton = self:FindGO("InviteAllFollowButton");
	self:AddClickEvent(self.inviteAllButton, function ()
		FunctionTeam.Me():InviteMemberFollow();
	end);

	self.autoFollowTog = self:FindComponent("AutoFollowTog", UIToggle);
	self:AddClickEvent(self.autoFollowTog.gameObject, function ()
		local togValue = self.autoFollowTog.value;
		local myMemberData = TeamProxy.Instance:GetMyTeamMemberData();
		local isautoFollow = myMemberData.autofollow == 1;
		if(togValue ~= isautoFollow)then
			helplog("CallSetMemberOptionTeamCmd", togValue);
			ServiceSessionTeamProxy.Instance:CallSetMemberOptionTeamCmd(togValue);
		end
	end);	
	
--todo xde
	local autoLabel = self:FindGO("Label",self.autoFollowTog.gameObject):GetComponent(UILabel)
	autoLabel.pivot = UIWidget.Pivot.Right
	autoLabel.transform.localPosition = Vector3(-20,0,0)
end

function TeamMemberListPopUp:ClickTeamMember(cellCtl)
	if(cellCtl ~= self.nowCell)then
		local clickMy = cellCtl.data.id == Game.Myself.data.id;
		if(not clickMy)then
			self.nowCell = cellCtl;
			local memberData = cellCtl.data;
			local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cellCtl.bg, NGUIUtil.AnchorSide.TopRight, {-70,14});
			local playerData = PlayerTipData.new();
			playerData:SetByTeamMemberData(memberData);
			local funckeys;
			if(memberData.cat~=nil and memberData.cat ~= 0)then
				funckeys = {"ShowDetail", "KickMember", "FireHireman", "ReHireCat"};
				if(memberData.masterid ~= nil and memberData.masterid == Game.Myself.id)then
					local attriFunction = Game.Myself.data:GetProperty("AttrFunction")
					local serverCanJoinHand = (attriFunction >> (pos-1)) & 1 == 1;
					if(serverCanJoinHand)then
						local followId = Game.Myself:Client_GetFollowLeaderID();
						local isHandFollow = Game.Myself:Client_IsFollowHandInHand();
						if(isHandFollow and followId == Game.Myself.data.id)then
							table.insert(funckeys, "CancelJoinHand", 3);
						else
							table.insert(funckeys, "InviteJoinHand", 3);
						end
					end
				end
			else
				FunctionPlayerTip.Me():GetPlayerFunckey(memberData.id);
			end
			local tipData = {
				playerData = playerData,
				funckeys = funckeys,
			};
			playerTip:SetData(tipData);
			playerTip:AddIgnoreBound(cellCtl.portraitCell.gameObject);
			playerTip.closecallback = function ()
				self.nowCell = nil;
			end
			playerTip.clickcallback = function (funcConfig)
				if(funcConfig.key == "LeaverTeam")then
					self:CloseSelf();
				end
			end
		else
			FunctionPlayerTip.Me():CloseTip();
			self.nowCell = nil;
		end
	else
		FunctionPlayerTip.Me():CloseTip();
		self.nowCell = nil;
	end
end

function TeamMemberListPopUp:OnEnter()
	TeamMemberListPopUp.super.OnEnter(self);
	self:UpdateTeamInfo();
	self:UpdateMemberList();
end

function TeamMemberListPopUp:UpdateTeamInfo()
	if(TeamProxy.Instance:IHaveTeam())then
		local myTeam = TeamProxy.Instance.myTeam;
		self.teamName.text = myTeam.name;
		local type, goalStr = myTeam.type;
		if(type and Table_TeamGoals[type])then
			goalStr = Table_TeamGoals[type].NameZh;
		end
		self.teamLevel.text = string.format("%s[%s~%s]",tostring(goalStr) ,tostring(myTeam.minlv) ,tostring(myTeam.maxlv));
		local pickUpMode = myTeam.pickupmode or 0;
		if(pickUpMode == 0)then
			self.pickUpMode.text = ZhString.TeamMemberListPopUp_FreePick
		elseif(pickUpMode == 1)then
			self.pickUpMode.text = ZhString.TeamMemberListPopUp_RandomPick
		end

		local leaderAuthority = TeamProxy.Instance:CheckIHaveLeaderAuthority();
		self.applyPageButton.gameObject:SetActive(leaderAuthority);
		self.inviteMemberButton.gameObject:SetActive(leaderAuthority);
		self.optionButton.gameObject:SetActive(leaderAuthority);
		self.inviteAllButton.gameObject:SetActive(leaderAuthority);

		self.autoFollowTog.gameObject:SetActive(not leaderAuthority);
		local myMemberData = TeamProxy.Instance:GetMyTeamMemberData();
		if(myMemberData)then
			self.autoFollowTog.value = myMemberData.autofollow == 1;
		else
			self.autoFollowTog.value = false;
		end
	end
end

local memberDatas = {}
function TeamMemberListPopUp:UpdateMemberList()
	if(TeamProxy.Instance:IHaveTeam())then
		local myTeam = TeamProxy.Instance.myTeam;
		local memberList = myTeam:GetMembersList();
		TableUtility.ArrayClear(memberDatas);
		for i=1,#memberList do
			table.insert(memberDatas, memberList[i]);
		end
		if(#memberDatas < 5)then
			table.insert(memberDatas, MyselfTeamData.EMPTY_STATE);
		end
		self.memberlist:ResetDatas(memberDatas);
	else
		self.memberlist:ResetDatas({});
	end
end

function TeamMemberListPopUp:MapEvent()
	self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.HandleEnterTeam);
  	self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.UpdateTeamInfo);
  	self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.UpdateMemberList);
	self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateMemberList);
	self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.HandleExitTeam);
	self:AddListenEvt(ServiceEvent.NUserBeFollowUserCmd, self.UpdateMemberList);
end

function TeamMemberListPopUp:HandleEnterTeam(note)
	self:UpdateTeamInfo();
	self:UpdateMemberList();
end

function TeamMemberListPopUp:HandleExitTeam(note)
	self:CloseSelf();
end

function TeamMemberListPopUp:OnExit()
	self.memberlist:ResetDatas({});
	TeamMemberListPopUp.super.OnExit(self);
	
	FunctionPlayerTip.Me():CloseTip();
end
