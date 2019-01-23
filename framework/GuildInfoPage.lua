GuildInfoPage = class("GuildInfoPage", SubView)

autoImport("GuildHeadCell")
autoImport("GuildActivityCell")

GuildInfoPage.GuildAassetId = 146;
GuildInfoPage.GuildItemId = 5500;

function GuildInfoPage:Init()	
	self:InitUI();
	self:MapEvent();
end

local tempArgs = {};
function GuildInfoPage:InitUI()
	self.guildName = self:FindComponent("GuildName", UILabel);
	self.guildlv = self:FindComponent("GuildLv", UILabel);
	self.expSlider = self:FindComponent("ExpSlider", UISlider);
	--todo xde 
	self.Foreground = self:FindGO("Foreground", self.expSlider.gameObject);
	self.Foreground.transform.localPosition = Vector3(11,0,0)

	self.chairManName = self:FindComponent("ChairManName", UILabel);
	self.chairManSex = self:FindComponent("Sex", UISprite, self.chairManName.gameObject);
	self.memberNum = self:FindComponent("MemberNum", UILabel);
	self.maintenance = self:FindComponent("Maintenance", UILabel);
	self.dailyCost = self:FindComponent("DailyCost", UILabel);
	-- self.guildArea = self:FindComponent("GuildArea", UILabel);
	self.dismissTime = self:FindComponent("DismissTime", UILabel);
	self.changeZoneTime = self:FindComponent("ChangeZoneTime", UILabel);
	self.guildCurrentline = self:FindComponent("Guild_CurrentLine", UILabel);
	self.enterAreaButton = self:FindGO("EnterAreaButton");
	self.maintenanceFullTip = self:FindGO("MaintenanceFullTip");

	self.superGvg_Parent = self:FindGO("Tip5");
	self.superGvg = self:FindComponent("SuerGvgLv", UILabel, self.superGvg_Parent);
	self:AddClickEvent(self.enterAreaButton, function (go)
		if(Game.Myself:IsDead())then
			MsgManager.ShowMsgByIDTable(2500);
		else
			local currentRaidID = SceneProxy.Instance:GetCurRaidID()
			local raidData = currentRaidID and Table_MapRaid[currentRaidID];
			if(raidData and raidData.Type == 10)then
				MsgManager.ShowMsgByIDTable(2821);
				return;
			end
			ServiceGuildCmdProxy.Instance:CallEnterTerritoryGuildCmd();
			self.container:CloseSelf();
		end
	end);
	local headCellObj = self:FindGO("GuildHeadContainer");
	local itemGO = self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("GuildHeadCell"), headCellObj);
	self.headCell = GuildHeadCell.new(itemGO);
	self.headCell:SetCallIndex(UnionLogo.CallerIndex.UnionList);
	self.headCell:DeleteGO("choose");

	self:AddClickEvent(itemGO, function (go)
		local myMemberData = GuildProxy.Instance:GetMyGuildMemberData();
		local canDo = GuildProxy.Instance:CanJobDoAuthority(myMemberData.job, GuildAuthorityMap.SetIcon);
		if(canDo)then
			self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.GuildHeadChoosePopUp});
		else
			MsgManager.ShowMsgByIDTable(2636);
		end
	end);

	self.centerOnChild = self:FindComponent("Grid", UICenterOnChild);
	self.bordInfoInput = self:FindComponent("BordInfoInput", UIInput);
	self.bordOptButton = self:FindGO("BordInfoOption");
	self:AddClickEvent(self.bordOptButton, function (go)
		self.bordInfoInput.isSelected = not self.bordInfoInput.isSelected;
	end);

	self.upgradeButton = self:FindGO("UpgradeBtn");
	self:AddClickEvent(self.upgradeButton, function (go)
		if(Game.Myself:IsDead())then
			MsgManager.ShowMsgByIDTable(2500);
		else
			local currentRaidID = SceneProxy.Instance:GetCurRaidID()
			local raidData = currentRaidID and Table_MapRaid[currentRaidID];
			if(raidData and raidData.Type == 10)then

				TableUtility.TableClear(tempArgs);
				tempArgs.npcUID = 1;
				local cmd = MissionCommandFactory.CreateCommand(tempArgs, MissionCommandVisitNpc);
				if(cmd)then
					Game.Myself:Client_SetMissionCommand( cmd );
				end
				self:PassEvent(GuildActivityCellEvent.TraceRoad);
			else
				ServiceGuildCmdProxy.Instance:CallEnterTerritoryGuildCmd();
			end
		end
	end);

	self.recruitInfoInput = self:FindComponent("RecruitInfoInput", UIInput);
	self.recruitOptButton = self:FindGO("RecruitInfoOption");
	self:AddClickEvent(self.recruitOptButton, function (go)
		self.recruitInfoInput.isSelected = not self.recruitInfoInput.isSelected;
	end);
	local inputFunc = function(go, state)
		self:UpdateInfoBordAnim(not state);
		if(not state)then
			self:ChangeGuildBordInfo();
		end
	end

	self.filterType = FunctionMaskWord.MaskWordType.GuildSpecialSymbol | FunctionMaskWord.MaskWordType.Chat --todo xde
	UIUtil.LimitInputCharacter(self.recruitInfoInput, GameConfig.System.guildrecruit_max, function (str)
		return FunctionMaskWord.Me():ReplaceMaskWord(str, self.filterType);
	end);
	UIUtil.LimitInputCharacter(self.bordInfoInput, GameConfig.System.guildboard_max, function (str)
		return FunctionMaskWord.Me():ReplaceMaskWord(str, self.filterType);
	end);

	self:AddSelectEvent(self.recruitInfoInput, inputFunc);
	self:AddSelectEvent(self.bordInfoInput, inputFunc);

	self.giScrollBg = self:FindGO("LeftDownBg");
	self:AddPressEvent(self.giScrollBg, function (go, isPress)
		self:UpdateInfoBordAnim(not isPress) 
	end);

	local activityGrid = self:FindComponent("GuildActivityGrid", UIGrid);
	self.activityCtl = UIGridListCtrl.new(activityGrid, GuildActivityCell, "GuildActivityCell");
	self.activityCtl:AddEventListener(GuildActivityCellEvent.TraceRoad, self.TraceRoad, self);
	self.activityCtl:AddEventListener(GuildActivityCellEvent.ClickHelp, self.ClickHelp, self);

	self.noneTip = self:FindGO("NoneTip");

	self:UpdateInfoBordAnim();
end

function GuildInfoPage:TraceRoad()
	self.container:CloseSelf();
end

function GuildInfoPage:ClickHelp(data)
	if(data == nil)then
		return;
	end

	if(data.HelpID == nil)then
		return;
	end

	local helpData = Table_Help[ data.HelpID ];
	self:OpenHelpView(helpData);
end

function GuildInfoPage:UpdateGuildInfo()
	local gdata = GuildProxy.Instance.myGuildData;
	if(gdata)then
		self.guildName.text = gdata.name;
		----[[ todo xde 不翻译玩家名字
		self.guildName.text = AppendSpace2Str(gdata.name)
		--]]
		self.guildlv.text = string.format("Lv.%s", tostring(gdata.level));
		local gasset = gdata.asset
		local expValue = gasset/gdata:GetUpgradeConfig().LevelupFund;
		self.expSlider.value = expValue;
		local chairMan = gdata:GetChairMan();
		local myid = Game.Myself.data.id;
		self.upgradeButton:SetActive(chairMan.id == myid and gasset >= gdata:GetUpgradeConfig().ReviewFund);
		self.chairManName.text = chairMan.name;
		----[[ todo xde 不翻译玩家名字
		self.chairManName.text = AppendSpace2Str(chairMan.name)
		--]]
		self.chairManSex.spriteName = chairMan:IsBoy() and "friend_icon_man" or "friend_icon_woman";
		self.memberNum.text = string.format("%s/%s", tostring(gdata.memberNum), tostring(gdata.maxMemberNum));

		self.maintenance.text = gasset;

		local guildSData = Table_Guild[gdata.level];
		if(guildSData)then
			local limit = guildSData.UpperLimit or 0;
			local dayGet = gdata.assettoday or 0;
			if(limit~=0 and guildSData~=0 and dayGet>=limit)then
				self.maintenanceFullTip:SetActive(true);
			else
				self.maintenanceFullTip:SetActive(false);
			end
		end

		if(gdata.staticData)then
			self.dailyCost.text = string.format(ZhString.GuildInfoView_DailyCostTip, gdata.staticData.maintenanceCharge);
			local headId = GuildProxy.Instance.myGuildData.portrait or 1;
			local headData = GuildHeadData.new();
			headData:SetBy_InfoId(headId);
			headData:SetGuildId(gdata.id);
			self.headCell:SetData(headData);
		end
		
		-- self.guildArea.text = ZhString.GuildInfoPage_Nothing;
		self.guildCurrentline.text = ChangeZoneProxy.Instance:ZoneNumToString(gdata.zoneid); -- ZhString.GuildInfoPage_line

		self.recruitInfoInput.value = gdata.recruitinfo;
		self.bordInfoInput.value =  OverSea.LangManager.Instance():GetLangByKey(gdata.boardinfo);

		self:UpdateDismissTime();
		self:UpdateChangeZoneTime();
		self:UpdateAcitvityList();

		local myMemberData = GuildProxy.Instance:GetMyGuildMemberData();
		if(myMemberData)then
			local canEditBord = GuildProxy.Instance:CanJobDoAuthority(myMemberData.job, GuildAuthorityMap.SetBordInfo)
			self.bordOptButton:SetActive(canEditBord);
		end
		local myMemberData = GuildProxy.Instance:GetMyGuildMemberData();
		if(myMemberData)then
			local canEditRecruit = GuildProxy.Instance:CanJobDoAuthority(myMemberData.job, GuildAuthorityMap.SetRecruitInfo)
			self.recruitOptButton:SetActive(canEditRecruit);
		end

		self:UpdateGvgDroiyaLv();
	end
end

function GuildInfoPage:UpdateGvgDroiyaLv()
	local GvgDroiyanReward_Config = GameConfig.GvgDroiyan.GvgDroiyanReward;
	if(GvgDroiyanReward_Config == nil)then
		self.superGvg_Parent.gameObject:SetActive(false);
		return;
	end

	local gdata = GuildProxy.Instance.myGuildData;
	if(gdata.supergvg_lv == nil or gdata.supergvg_lv == 0)then
		self.superGvg_Parent.gameObject:SetActive(false);
		return;
	end

	self.superGvg_Parent.gameObject:SetActive(true);

	self.superGvg.text = GvgDroiyanReward_Config[gdata.supergvg_lv].LvDesc;
end

function GuildInfoPage:UpdateAcitvityList()
	local activitylst = GuildProxy.Instance:GetGuildActivityList();
	self.activityCtl:ResetDatas(activitylst);
	self.noneTip:SetActive(#activitylst == 0);
end

function GuildInfoPage:UpdateDismissTime(time)
	local gdata = GuildProxy.Instance.myGuildData;
	self:UpdateCountDownTime(gdata.dismisstime, self.dismissTime, ZhString.GuildInfoPage_DismissGuildTip);
end

function GuildInfoPage:UpdateChangeZoneTime(time)
	local gdata = GuildProxy.Instance.myGuildData;
	local tip = "";
	if(gdata.nextzone and gdata.nextzone ~= 0)then
		tip = ChangeZoneProxy.Instance:ZoneNumToString(gdata.nextzone, ZhString.GuildInfoPage_GuildChangeline);
	end
	self:UpdateCountDownTime(gdata.zonetime, self.changeZoneTime, tip);
end

function GuildInfoPage:UpdateCountDownTime(time, label, tip)
	local nowServerTime = ServerTime.CurServerTime()/1000;

	TimeTickManager.Me():ClearTick(self, 1)
	if(time > nowServerTime)then
		TimeTickManager.Me():CreateTick(0,1000,function (deltatime)
			if(time > ServerTime.CurServerTime()/1000)then
				local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr( time )
				if(leftDay > 0)then
					label.text = string.format("%s%02d:%02d:%02d", tip, leftDay, leftHour, leftMin);
				else
					label.text = string.format("%s%02d:%02d:%02d", tip, leftHour, leftMin, leftSec);
				end
			else
				label.text = "";
				TimeTickManager.Me():ClearTick(self, 1)
			end
		end, self, 1)	
	else
		label.text = "";
	end
end

function GuildInfoPage:ChangeGuildBordInfo()
	local myGuildData = GuildProxy.Instance.myGuildData;
	if(myGuildData)then
		local board, recruit;
		if(self.bordInfoInput.value~=myGuildData.boardinfo)then
			board = self.bordInfoInput.value;
		end
		if(self.recruitInfoInput.value~=myGuildData.recruitinfo)then
			recruit = self.recruitInfoInput.value;
		end
		if(board or recruit)then
			board = board=="" and "null" or board;
			recruit = recruit=="" and "null" or recruit;
			ServiceGuildCmdProxy.Instance:CallSetGuildOptionGuildCmd(board, recruit) 
		end
	end
end

function GuildInfoPage:UpdateInfoBordAnim(isTween)
	TimeTickManager.Me():ClearTick(self, 2)
	if(nil == isTween)then
		isTween = not self.bordInfoInput.isSelected and not self.recruitInfoInput.isSelected;
	end
	if(not isTween)then
		return;
	end
	
	TimeTickManager.Me():CreateTick(6000, 6000,function ()
		local childlist, cTrans = {}, self.centerOnChild.transform;
		local centerIndex = 0;
		for i=0, cTrans.childCount-1 do
			childlist[i] = cTrans:GetChild(i);
			if(childlist[i].gameObject == self.centerOnChild.centeredObject)then
				centerIndex = i;
			end
		end
		if(#childlist>0)then
			local index = (centerIndex + 1) % (#childlist + 1);
			local centerTrans = childlist[index];
			self.centerOnChild:CenterOn(centerTrans);
		end	
	end, self, 2);
end

function GuildInfoPage:MapEvent()
	self:AddListenEvt(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, self.HandleGuildDataUpdate);
	self:AddListenEvt(ServiceEvent.GuildCmdQueryPackGuildCmd, self.HandleGuildDataUpdate);

	self:AddListenEvt(ServiceEvent.GuildCmdQueryPackGuildCmd, self.UpdateGuildInfo);
	self:AddListenEvt(ServiceEvent.GuildCmdPackUpdateGuildCmd, self.UpdateGuildInfo);
end

function GuildInfoPage:HandleGuildDataUpdate(note)
	self:UpdateGuildInfo();
end

function GuildInfoPage:OnEnter()
	GuildInfoPage.super.OnEnter(self);

	local myGuildData = GuildProxy.Instance.myGuildData;
	self.myGuildId = myGuildData.id;

	self:UpdateGuildInfo();

	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_GUILD_ICON, self.headCell.bg.gameObject, 42)
end

function GuildInfoPage:OnExit()
	GuildInfoPage.super.OnExit(self);
	
	TimeTickManager.Me():ClearTick(self)

	FunctionGuild.Me():ClearCustomPicCache(self.myGuildId)

	local cells = self.activityCtl:GetCells();
	for i=1, #cells do
		cells[i]:OnRemove();
	end
end
