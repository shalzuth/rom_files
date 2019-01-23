local BaseCell = autoImport("BaseCell");
GuildCell = class("GuildCell", BaseCell);

autoImport("GuildHeadCell");

function GuildCell:Init()
	local guildHeadCellGO = self:FindGO("GuildHeadCell");
	self.headCell = GuildHeadCell.new(guildHeadCellGO);
	self.headCell:SetCallIndex(UnionLogo.CallerIndex.UnionList);

	self.lv = self:FindComponent("Lv", UILabel);
	self.lvname = self:FindComponent("LvName", UILabel);
	self.zoneid = self:FindComponent("ZoneId", UILabel);
	self.chairName = self:FindComponent("ChairName", UILabel);
	self.chairSex = self:FindComponent("Sex", UISprite, self.chairName.gameObject);
	self.memberNum = self:FindComponent("MemberNum", UILabel);
	self.recruitInfo = self:FindComponent("RecruitInfo", UILabel);

	self.applyButton = self:FindGO("ApplyButton");
	self:AddClickEvent(self.applyButton, function (go)
		if(self.data)then
			if(GuildProxy.Instance:IsInJoinCD())then
				MsgManager.ShowMsgByIDTable(4046)
				return;
			end
			ServiceGuildCmdProxy.Instance:CallApplyGuildGuildCmd(self.data.id);
			self:SetApplyState(true);
		end
	end);
	self.applyedInfo = self:FindGO("AppliedSymbol");

	local scrollView = self:FindComponent("GuildScroll", UIScrollView);
end

function GuildCell:GetMyGuildHeadData()
	if(self.myGuildHeadData == nil)then
		self.myGuildHeadData = GuildHeadData.new();
	end

	if(self.data ~= nil)then
		self.myGuildHeadData:SetBy_InfoId(self.data.portrait);
		self.myGuildHeadData:SetGuildId(self.data.id);
	end

	return self.myGuildHeadData;
end

function GuildCell:SetData(data)
	self.data = data;
	if(data)then
		self.gameObject:SetActive(true);

		self.lvname.text = string.format("Lv.%s %s", data.level, data.guildname);
--		self.zoneid.text = ChangeZoneProxy.Instance:ZoneNumToString(data.zoneid); -- ZhString.GuildCell_line
		--todo xde
		local zoneid = data.zoneid %10000
--		helplog(zoneid)
		local info = OverseaHostHelper:GetZoneInfo(zoneid)
		self.zoneid.text = info.name .. info.id
		self.chairName.text = tostring(data.chairmanname);
		self.chairSex.spriteName = data.chairmangender == ProtoCommon_pb.EGENDER_MALE and "friend_icon_man" or "friend_icon_woman";
		self.memberNum.text = string.format("%s/%s", tostring(data.curmember), tostring(data.maxmember));
		self.recruitInfo.text = data.recruitinfo or "";

		self:SetApplyState(false);

		self.headCell:SetData(self:GetMyGuildHeadData());
	else
		self.gameObject:SetActive(false);
	end
end

function GuildCell:SetApplyState(isApplied)
	self.applyButton:SetActive(not isApplied);
	self.applyedInfo:SetActive(isApplied);
end


