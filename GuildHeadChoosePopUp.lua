GuildHeadChoosePopUp = class("GuildHeadChoosePopUp", ContainerView)

GuildHeadChoosePopUp.ViewType = UIViewType.PopUpLayer

autoImport("GuildHeadCell")
autoImport("WrapListCtrl")

function GuildHeadChoosePopUp:Init()
	self:InitView();
	self:MapEvent();
end

function GuildHeadChoosePopUp:InitView()
	local nowHeadObj = self:FindGO("NowHead");
	self.nowHeadCell = GuildHeadCell.new(nowHeadObj);
	self.nowHeadCell:DeleteGO("addSymbol");
	self.nowHeadCell:DeleteGO("choose");

	local container = self:FindGO("HeadWrapContent")
	self.headCtl = WrapListCtrl.new(container, GuildHeadCell, "GuildHeadCell", WrapListCtrl_Dir.Vertical, 4, 104);
	self.headCtl:AddEventListener(MouseEvent.MouseClick, self.ClickGuildHeadCell, self)

	self.buttonGrid = self:FindComponent("ButtonGrid", UIGrid);
	self.confirmButton = self:FindGO("ConfirmButton");
	self.deleteButton = self:FindGO("DeleteButton");
	self.localButton = self:FindGO("LocalButton");
	self:AddClickEvent(self.localButton, function (go)
		self:DoChooseLocalPicture();
	end);

	self:AddClickEvent(self.confirmButton, function (go)
		self:DoConfirmChangeHead();
	end);

	self:AddClickEvent(self.deleteButton, function (go)
		self:DoDeleteGuildIcon();
	end);

	self.guildHead_AddData = GuildHeadData.new(GuildHeadData_Type.Add);
end

function GuildHeadChoosePopUp:DoChooseLocalPicture()
	local myGuildData = GuildProxy.Instance.myGuildData;
	
	local index = myGuildData:GetEmptyCustomIconIndex();
	if(index == nil)then
		MsgManager.ShowMsgByIDTable(2648);
		return;
	end
	self:UpdateGuildHeadList();
	FunctionGuild.Me():SaveAndUploadCustomGuildIcon(index, ApplicationInfo.IsRunOnEditor());
end

function GuildHeadChoosePopUp:DoConfirmChangeHead()
	local myHeadId = GuildProxy.Instance.myGuildData.portrait or 1;
	if(self.nowData:GetInfoId() ~= nil and self.nowData:GetInfoId() ~= myHeadId)then
		ServiceGuildCmdProxy.Instance:CallSetGuildOptionGuildCmd(nil, nil, self.nowData:GetInfoId(), nil);
	end
	self:CloseSelf();
end

function GuildHeadChoosePopUp:DoDeleteGuildIcon()
	local nowData = self.nowData;
	if(nowData and nowData.type == GuildHeadData_Type.Custom)then
		ServiceGuildCmdProxy.Instance:CallGuildIconAddGuildCmd(nowData.index, nil, nil, true);
	end
end

function GuildHeadChoosePopUp:ClickGuildHeadCell(cell)
	local data = cell and cell.data;
	self:UpdateNowChoose(cell.data);
end

function GuildHeadChoosePopUp:UpdateOptButtons()
	if(self.nowData)then

		if(self.nowData.type == GuildHeadData_Type.Add)then
			self.localButton:SetActive(true);
			self.deleteButton:SetActive(false);
			self.confirmButton:SetActive(false);
		elseif(self.nowData.type == GuildHeadData_Type.Custom)then
			self.localButton:SetActive(false);
			self.deleteButton:SetActive(true);
			self.confirmButton:SetActive(self.nowData.state == GuildCmd_pb.EICON_PASS);
		elseif(self.nowData.type == GuildHeadData_Type.Config)then
			self.confirmButton:SetActive(true);
			self.deleteButton:SetActive(false);
			self.localButton:SetActive(false);
		end

		local myGuildHeadData = self:GetMyGuildHeadData();
		if(self.nowData.type == myGuildHeadData.type and self.nowData.id == myGuildHeadData.id)then
			self.confirmButton:SetActive(false);
			self.deleteButton:SetActive(false);
		end
	else
		self.confirmButton:SetActive(false);
		self.deleteButton:SetActive(false);
		self.localButton:SetActive(false);
	end

	self.buttonGrid:Reposition();
end

function GuildHeadChoosePopUp:OnEnter()
	GuildHeadChoosePopUp.super.OnEnter(self);

	-- EREDSYS_GUILD_ICON

	self:UpdateGuildHeadList();
	self:UpdateMyGuildHead();
end

function GuildHeadChoosePopUp:GetMyGuildHeadData()
	if(self.myGuildHeadData == nil)then
		self.myGuildHeadData = GuildHeadData.new();
	end
	local myGuildData = GuildProxy.Instance.myGuildData;
	if(myGuildData ~= nil)then
		local myPortrait = myGuildData.portrait;
		self.myGuildHeadData:SetBy_InfoId(myPortrait);
		self.myGuildHeadData:SetGuildId(myGuildData.id);
	end
	return self.myGuildHeadData;
end

function GuildHeadChoosePopUp:UpdateMyGuildHead()
	self.nowHeadCell:SetData(self:GetMyGuildHeadData());
	self:UpdateOptButtons();
end

function GuildHeadChoosePopUp:UpdateGuildHeadList()
	local myGuildData = GuildProxy.Instance.myGuildData;
	if(myGuildData == nil)then
		return;
	end

	local myHeadData = self:GetMyGuildHeadData();

	local headIcons = myGuildData:GetMyHeadIcons();
	if(self.datas == nil)then
		self.datas = {};
	else
		TableUtility.ArrayClear(self.datas);
	end
	for i=1,#headIcons do
		if(headIcons[i].type == myHeadData.type and headIcons[i].id == myHeadData.id)then
			self:UpdateNowChoose(headIcons[i]);
		end
		table.insert(self.datas, headIcons[i]);
	end

	-- if(myGuildData:GetEmptyCustomIconIndex() ~= nil)then
	--	table.insert(self.datas, 1, self.guildHead_AddData); --todo xde ???????????????????????????????????????
	-- end

	self.headCtl:ResetDatas(self.datas);
end

function GuildHeadChoosePopUp:UpdateNowChoose(chooseData)
	if(self.nowData == nil or (self.nowData.type ~= chooseData.type or self.nowData.id ~= chooseData.id))then
		self.nowData = chooseData;

		local cells = self.headCtl:GetCells();
		for i=1, #cells do
			cells[i]:SetChoose(self.nowData);
		end
		self:UpdateOptButtons();
	end
end

function GuildHeadChoosePopUp:MapEvent()
	self:AddListenEvt(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, self.UpdateMyGuildHead);
	self:AddListenEvt(ServiceEvent.GuildCmdGuildIconSyncGuildCmd, self.UpdateGuildHeadList);
end

function GuildHeadChoosePopUp:OnExit()
	GuildHeadChoosePopUp.super.OnExit(self);

	RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_GUILD_ICON or 43);
	-- local myGuildData = GuildProxy.Instance.myGuildData;
	-- local guildid = myGuildData and myGuildData.id;
	-- GuildHeadCell.ClearCustomPicCache(guildid)
end