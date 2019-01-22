TeamInvitePopUp = class("TeamInvitePopUp", ContainerView)

TeamInvitePopUp.ViewType = UIViewType.PopUpLayer

autoImport("WrapCellHelper");
autoImport("TeamInviteMembCell");

TeamInvitePopUp.TabName = {
	FriendTog = ZhString.TeamInvitePopUp_FriendTog,
	GHTog = ZhString.TeamInvitePopUp_GuideTog,
	OldFriend = ZhString.TeamInvitePopUp_TeammateTog,
	HireTog = ZhString.TeamInvitePopUp_HireTog,
}

TeamInvitePopUp.LongPressEvent = "TeamInvitePopUp_LongPress"

local teamProxy;

function TeamInvitePopUp:Init()
	teamProxy = TeamProxy.Instance;

	self:MapViewListenEvent();
	self:InitView();
end

function TeamInvitePopUp:InitView()
	local wrapContent = self:FindGO("MemberWrap");
	local wrapConfig = {
		wrapObj = wrapContent,
		pfbNum = 5,
		cellName = "TeamInviteMembCell",
		control = TeamInviteMembCell,
	};
	self.wraplist = WrapCellHelper.new(wrapConfig);
	self.wraplist:AddEventListener(MouseEvent.MouseClick, self.ClickMemberEvent, self);

	local friendTog, guildTog, lastfriendTog, hireTog = self:FindGO("FriendTog"), self:FindGO("GHTog"), self:FindGO("OldFriend"), self:FindGO("HireTog");
	self.togMap = {friendTog, guildTog, lastfriendTog, hireTog};

	self:AddTabEvent(friendTog, function (go, value)
		self:UpdateMyFriends();
	end);
	self:AddTabEvent(guildTog, function (go, value)
		self:UpdateMyGuildMembers();
	end);
	self:AddTabEvent(lastfriendTog, function (go, value)
		self:UpdateNearTeamMembers();
	end);
	self:AddTabEvent(hireTog, function (go, value)
		self:QueryMemberCats();
		self:UpdateInfo({});
	end);

	self.noneTip = self:FindGO("NoneTip");
	self.noneTipLabel = self.noneTip:GetComponent(UILabel);
	self.noneTipSp = self:FindGO("NoneTipSp", self.noneTip);

	-- LongPress for TabNameTip
	for i,v in ipairs(self.togMap) do
		local longPress = v:GetComponent(UILongPress)
		longPress.pressEvent = function (obj, state)
			self:PassEvent(TeamInvitePopUp.LongPressEvent, {state, obj.gameObject});
		end
	end
	self:AddEventListener(TeamInvitePopUp.LongPressEvent, self.HandleLongPress, self)

	-- Switch icon or text for TabNameTip
	if not GameConfig.SystemForbid.TabNameTip then -- ?????????????????????
		self.usingIcon = true
	else -- ????????????????????????
		self.usingIcon = false
	end
	self.tabLabelList = {}
	self.tabIconSpList = {}
	for i,v in ipairs(self.togMap) do
		local icon = GameObjectUtil.Instance:DeepFindChild(v, "Icon")
		icon:SetActive(self.usingIcon)
		self.tabIconSpList[#self.tabIconSpList + 1] = icon:GetComponent(UISprite)
		local label = GameObjectUtil.Instance:DeepFindChild(v, "Label")
		label:SetActive(not self.usingIcon)
		self.tabLabelList[#self.tabLabelList + 1] = label:GetComponent(UILabel)
	end

	self.nowTog = 1;
	self:UpdateMyFriends();
end

function TeamInvitePopUp:ClickMemberEvent(cellCtl)
	if(cellCtl)then
		if(cellCtl.eventType == "CloseUI")then
			self:CloseSelf();
		elseif(cellCtl.eventType == "Invite")then
			local data = cellCtl.data;
			local myTeam = TeamProxy.Instance.myTeam;
			if(myTeam and #myTeam:GetMembersList() >= 5)then
				MsgManager.ShowMsgByIDTable(331);
				return;
			end

			if(data.type == TeamInviteMemberType.MemberCat)then
				if(TeamProxy.Instance:IHaveTeam() and not TeamProxy.Instance:CheckIHaveLeaderAuthority())then
					MsgManager.ShowMsgByIDTable(5001);
					return;
				end
				if(not teamProxy:IsInMyTeam(data.id))then
					ServiceSessionTeamProxy.Instance:CallInviteMember(data.data.masterid, data.data.cat)
				end
			else
				if(not teamProxy:IsInMyTeam(data.id))then
					ServiceSessionTeamProxy.Instance:CallInviteMember(data.id)
					cellCtl:ActiveInviteButton(false);
				end
			end
		elseif(cellCtl.eventType == "Hire")then
			local sdata = cellCtl.data.data;
			if(sdata)then
				self:sendNotification(UIEvent.ShowUI, {viewname = "HireCatPopUp", catid = sdata.cat});
				self:CloseSelf();
			end
		end
	end
end

function TeamInvitePopUp:UpdateMyFriends()
	self:SetChooseInviteTogState(1);
	self.nowTog = 1;

	local list = {};
	local friendDatas = FriendProxy.Instance:GetOnlineFriendData();
	for i=1,#friendDatas do
		local isInTeam = false;
		if(friendDatas[i].guid)then
			isInTeam = teamProxy:IsInMyTeam(friendDatas[i].guid);
		end
		if(not isInTeam)then
			local inviteData = {};
			inviteData.id = friendDatas[i].guid;
			inviteData.type = TeamInviteMemberType.Friend;
			inviteData.data = friendDatas[i];
			table.insert(list, inviteData);
		end
	end
	self:UpdateInfo(list);
end

function TeamInvitePopUp:UpdateMyGuildMembers()
	self:SetChooseInviteTogState(2);
	self.nowTog = 2;

	local list = {};
	local myGuildData = GuildProxy.Instance.myGuildData;
	if(myGuildData)then
		local gmembers = GuildProxy.Instance.myGuildData:GetMemberList();
		for i=1,#gmembers do
			local gmemb = gmembers[i];
			if(gmemb.id~=Game.Myself.data.id)then
				local isInTeam = teamProxy:IsInMyTeam(gmemb.id);
				if(not isInTeam)then
					local inviteData = {};
					inviteData.id = gmemb.id;
					inviteData.type = TeamInviteMemberType.GuildMember;
					inviteData.data = gmemb;
					table.insert(list, inviteData);
				end
			end
		end
	end
	self:UpdateInfo(list);
end

function TeamInvitePopUp:UpdateNearTeamMembers()
	self:SetChooseInviteTogState(3);
	self.nowTog = 3;

	local list = {};
	local teamMembers = FriendProxy.Instance:GetRecentTeamMember();
	for i=1,#teamMembers do
		local isInTeam = false;
		isInTeam = teamProxy:IsInMyTeam(teamMembers[i].guid);
		if(not isInTeam)then
			local inviteData = {};
			inviteData.id = teamMembers[i].guid;
			inviteData.type = TeamInviteMemberType.NearlyTeamMember;
			inviteData.data = teamMembers[i];
			table.insert(list, inviteData);
		end
	end
	self:UpdateInfo(list);
end

function TeamInvitePopUp:QueryMemberCats()
	self:SetChooseInviteTogState(4);
	self.nowTog = 4;

	ServiceSessionTeamProxy.Instance:CallQueryMemberCatTeamCmd()
end

function TeamInvitePopUp:UpdateMemberCats()
	local list = {};
	local hireCats = teamProxy:GetMyHireTeamMembers();
	for i=1, #hireCats do
		local catData = hireCats[i];
		if(not teamProxy:IsInMyTeam(catData.id))then
			local inviteData = {};
			inviteData.id = catData.id;
			inviteData.type = TeamInviteMemberType.MemberCat;
			inviteData.data = catData;
			table.insert(list, inviteData);
		end
	end
	self:UpdateInfo(list);
end

function TeamInvitePopUp:SetChooseInviteTogState(tog)
	local chooseColor, unchooseColor = Color(48/255, 65/255, 147/255), Color(157/255, 157/255, 157/255)
	for i=1,#self.togMap do
		if self.usingIcon then
			if(tog == i)then
				self.tabIconSpList[i].color = chooseColor
			else
				self.tabIconSpList[i].color = unchooseColor
			end
		else
			if(tog == i)then
				self.tabLabelList[i].color = chooseColor
			else
				self.tabLabelList[i].color = unchooseColor
			end
		end
	end
end

local tempV3 = LuaVector3();
function TeamInvitePopUp:UpdateInfo(list)
	self.wraplist:UpdateInfo(list);
	self.wraplist:ResetPosition();

	if(self.nowTog == 4)then
		self.noneTipLabel.text = ZhString.TeamInvitePopUp_NoCatTip;
		-- tempV3:Set(75,0,0);
		-- self.noneTipSp.transform.localPosition = tempV3
	else
		self.noneTipLabel.text = ZhString.TeamInvitePopUp_NoMemberTip;
		-- tempV3:Set(125,0,0);
		-- self.noneTipSp.transform.localPosition = tempV3
	end
	self.noneTip:SetActive(#list == 0);
end

function TeamInvitePopUp:MapViewListenEvent()
	self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.HandleGetSocialityClientQuerySocialData);
	self:AddListenEvt(ServiceEvent.SessionSocialityQueryTeamData, self.HandleSocialityQueryTeamData);
	self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.HandleSocialDataUpdate);

	self:AddListenEvt(ServiceEvent.SessionTeamMemberCatUpdateTeam, self.HandleUpdateMemberCat);

	self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.HandleUpdateMemberCat);
end

function TeamInvitePopUp:HandleSocialityQueryTeamData(note)
	helplog("Handle-->SocialityQueryTeamData");
	if(self.nowTog == 3)then
		self:UpdateNearTeamMembers();
	end
end

function TeamInvitePopUp:HandleSocialDataUpdate(note)
	if(self.nowTog == 1)then
		self:UpdateMyFriends();
	end
end

function TeamInvitePopUp:HandleGetSocialityClientQuerySocialData(note)
	helplog("Handle-->GetSocialityClientQuerySocialData");
	if(self.nowTog == 1)then
		self:UpdateMyFriends();
	elseif(self.nowTog == 3)then
		self:UpdateNearTeamMembers();
	end
end

function TeamInvitePopUp:HandleUpdateMemberCat(note)
	if(self.nowTog == 4)then
		self:UpdateMemberCats();
	end
end

function TeamInvitePopUp:OnEnter( )
	TeamInvitePopUp.super.OnEnter(self);
	ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(true)
end

function TeamInvitePopUp:OnExit( )
	TeamInvitePopUp.super.OnExit(self);
	self:UpdateInfo({});
	ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(false)
end

function TeamInvitePopUp:HandleLongPress(param)
	local isPressing, go = param[1], param[2];

	-- Show TabNameTip
	if not GameConfig.SystemForbid.TabNameTip then
		if isPressing then
			local sp = self:FindComponent("Sprite", UISprite, go)
			TipManager.Instance:TryShowVerticalTabNameTip(TeamInvitePopUp.TabName[go.name],
					sp, NGUIUtil.AnchorSide.Down, {140, -58})
		else
			TipManager.Instance:CloseTabNameTipWithFadeOut()
		end
	end
end




