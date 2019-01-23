GvgLandInfoPopUp = class("GvgLandInfoPopUp", ContainerView)

GvgLandInfoPopUp.ViewType = UIViewType.PopUpLayer

autoImport("GuildHeadCell");

function GvgLandInfoPopUp:Init()
	self:InitPopUp();
	self:MapEvent();
end

function GvgLandInfoPopUp:InitPopUp()
	self.title = self:FindComponent("TitleLabel", UILabel);
	self.guildName = self:FindComponent("GuildName", UILabel);
	self.guildLevel = self:FindComponent("GuildLevel", UILabel);
	self.guildMemberNum = self:FindComponent("GuildMemberNum", UILabel);

	self.level = self:FindComponent("Level", UILabel);
	self.desc = self:FindComponent("Desc", UILabel);
	self.errorTip = self:FindComponent("ErrorTip", UILabel);

	self.fightButton = self:FindGO("FightButton");
	self.fightButton_sp = self.fightButton:GetComponent(UISprite);
	self.fightButton_collider = self.fightButton:GetComponent(BoxCollider);
	self.fightButton_label = self:FindComponent("Label", UILabel, self.fightButton);
	self:AddClickEvent(self.fightButton, function (go)
		self:DoFight();
	end);

	local headCellGO = self:FindGO("GuildHeadCell");
	self.guildHeadCell = GuildHeadCell.new(headCellGO);

	self.guildIcon = self:FindComponent("GuildIcon", UISprite);

	self.noneTip = self:FindGO("NoneTip");

	self.noOpenTip = self:FindGO("NoOpenTip");
	self.buttons = self:FindGO("Buttons");

	self.downInfo = self:FindGO("DownInfo");
	self.bg = self:FindComponent("Bg", UISprite);
end

function GvgLandInfoPopUp:ActiveFightButton(b)
	if(b)then
		self.fightButton_sp.color = ColorUtil.NGUIWhite;
		self.fightButton_collider.enabled = true;
		self.fightButton_label.effectColor = ColorUtil.ButtonLabelOrange;
	else
		self.fightButton_sp.color = ColorUtil.NGUIShaderGray;
		self.fightButton_collider.enabled = false;
		self.fightButton_label.effectColor = ColorUtil.NGUIGray;
	end
end

function GvgLandInfoPopUp:DoFight()
	-- if GvgProxy.Instance:IsInFightingTime() then
	-- 	helplog("Call-->GoCityGateMapCmd:", self.flagid);
	-- 	ServiceMapProxy.Instance:CallGoCityGateMapCmd(self.flagid) 
	-- end

	local nowZoneid = MyselfProxy.Instance:GetZoneId();
	local myGuildData = GuildProxy.Instance.myGuildData;
	if(myGuildData == nil or myGuildData.zoneid ~= nowZoneid)then
		MsgManager.ConfirmMsgByID(2215, function ()
			ServiceMapProxy.Instance:CallGoCityGateMapCmd(self.flagid) 
			self:CloseSelf();
		end)
		return;
	end

	ServiceMapProxy.Instance:CallGoCityGateMapCmd(self.flagid) 

	self:CloseSelf();
end

function GvgLandInfoPopUp:UpdatePopUp()
	self.ruleGuild, self.ruleGuild_type = GvgProxy.Instance:GetRuleGuildInfo(self.flagid);
	
	if(self.ruleGuild ~= nil and self.ruleGuild_type == 2)then
		if(self.ruleGuild.guildid == nil or self.ruleGuild.guildid == 0)then
			self.ruleGuild = nil;
		end
	end

	if(self.ruleGuild)then
		self.noneTip:SetActive(false);

		local ruleGuild_lv = self.ruleGuild.lv or 0;
		self.level.text = "Lv." .. ruleGuild_lv;

		self.guildName.text = self.ruleGuild.name;
		self.guildMemberNum.text = self.ruleGuild.membercount or 0;
		self.guildLevel.text = ruleGuild_lv;

		local headData = GuildHeadData.new();
		headData:SetBy_InfoId(self.ruleGuild.portrait);

		local ruleid = self.ruleGuild_type == 1 and self.ruleGuild.id or self.ruleGuild.guildid;
		headData:SetGuildId(ruleid);
		self.guildHeadCell:SetData(headData);

		local guildIconData = Table_Guild_Icon[self.ruleGuild.portrait]
		local guildIcon = guildIconData and guildIconData.Icon or nil;
		if(guildIcon ~= nil)then
			IconManager:SetGuildIcon(guildIcon, self.guildIcon);
		end
	else
		self.level.text = "";

		self.noneTip:SetActive(true);

		self.guildName.text = ZhString.GvgLandInfoPopUp_NoRuleTip;
		self.guildMemberNum.text = ZhString.GvgLandInfoPopUp_None;
		self.guildLevel.text = ZhString.GvgLandInfoPopUp_None;

		self.guildHeadCell:SetData();
	end

	if(GvgProxy.Instance:IsInFightingTime())then
		self.fightButton_label.text = ZhString.GvgLandInfoPopUp_JoinFight;
	else
		self.fightButton_label.text = ZhString.GvgLandInfoPopUp_EnterArea;
	end

	local config = Table_Guild_StrongHold and Table_Guild_StrongHold[self.flagid];
	if(config)then
		self.title.text = config.Name;
		self.desc.text = config.Text;
	else
		self.title.text = "Not Find Config";
		self.desc.text = string.format("Not Find FlagConfig:%s In Table_Guild_StrongHold", self.flagid);
	end

	self:UpdateFightState();
end

function GvgLandInfoPopUp:UpdateFightState(note)
	local open = true;
	if(note)then
		open = 	note.body.cityopen == true;
	end
	self.buttons:SetActive(open);
	self.noOpenTip:SetActive(not open);
	
	if(GvgProxy.Instance:IsInFightingTime())then
		self:ActiveFightButton(true);
	else
		self:ActiveFightButton(false);
	end

	local config = Table_Guild_StrongHold and Table_Guild_StrongHold[self.flagid];
	if(config)then
		self.desc.text = config.Text;
	else
		self.desc.text = string.format("Not Find FlagConfig:%s In Table_Guild_StrongHold", self.flagid);
	end

	local myGuildData = GuildProxy.Instance.myGuildData;
	local myGuildId = myGuildData and myGuildData.id or 0;
	if(self.ruleGuild == nil)then
		self.errorTip.text = "";
		return;
	end
	local ruleid = self.ruleGuild_type == 1 and self.ruleGuild.id or self.ruleGuild.guildid;
	if(ruleid == myGuildId)then
		-- 自己的公会
		self.errorTip.text = ZhString.GvgLandInfoPopUp_MyLandTip;
		return;
	end

	if(not GvgProxy.Instance:IsInFightingTime())then
		-- 不在公会战时间
		local openTime = GvgProxy.Instance:GetGvgOpenTime();
		local timeDateInfo = os.date("*t", openTime);

		self.errorTip.text = string.format(ZhString.GvgLandInfoPopUp_OpenTip, timeDateInfo.month, timeDateInfo.day, timeDateInfo.hour);
		return;
	end

	self.errorTip.text = "";
end

function GvgLandInfoPopUp:ActiveDownInfo(b)
	self.downInfo:SetActive(b);
	if(b)then
		self.bg.height = 524;
	else
		self.bg.height = 434;
	end
end

function GvgLandInfoPopUp:MapEvent()
	self:AddListenEvt(ServiceEvent.FuBenCmdGuildFireStatusFubenCmd, self.UpdateFightState);	
	self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandlePlayerMapChange);	
end

function GvgLandInfoPopUp:HandlePlayerMapChange(note)
	self:CloseSelf();
end

function GvgLandInfoPopUp:OnEnter()
	GvgLandInfoPopUp.super.OnEnter(self);

	self.flagid = self.viewdata.viewdata.flagid;

	self:UpdatePopUp();

	self.hideDownInfo = self.viewdata.viewdata.hide_downinfo;
	self:ActiveDownInfo(self.hideDownInfo ~= true);

	ServiceFuBenCmdProxy.Instance:CallGuildFireStatusFubenCmd(nil, nil, self.flagid);
end

function GvgLandInfoPopUp:OnExit()
	GvgLandInfoPopUp.super.OnExit(self);

end