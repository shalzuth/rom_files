GuildOpenRaidDialog = class("GuildOpenRaidDialog", ContainerView)

GuildOpenRaidDialog.ViewType = UIViewType.DialogLayer;

autoImport("NpcMenuBtnCell");
autoImport("DialogCell");
autoImport("Dialog_MenuData");

GuildOpenRaidFuncTag = {
	OpenRaid = 1,
	GoReady = 2,	
};

local curSerTime = ServerTime.CurServerTime;

function GuildOpenRaidDialog:Init()
	self:InitView();
	self:MapEvent();
end

function GuildOpenRaidDialog:InitView()
	self.menu = self:FindGO("Menu");
	self.menuSprite = self.menu:GetComponent(UISprite);
	self.menuSprite.enabled = true;

	local bottom = self:FindGO("Anchor_bottom");
	local obj = self:LoadPreferb("cell/DialogCell", bottom);
	obj.transform.localPosition = LuaVector3.zero;
	self.dialogCtl = DialogCell.new(obj);
	self.dialogCtl:AddEventListener(MouseEvent.MouseClick, self.ClickDialogEvent, self);

	-- updateTasks
	local grid = self:FindChild("MenuGrid", self.menu):GetComponent(UIGrid);
	self.menuCtl = UIGridListCtrl.new(grid, NpcMenuBtnCell, "NpcMenuBtnCell");
	self.menuCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMenuEvent, self);
end

function GuildOpenRaidDialog:ClickDialogEvent(cellCtl)
	self:CloseSelf();
end

function GuildOpenRaidDialog:ClickMenuEvent(cellCtl)
	local cellData = cellCtl.data;
	if(not cellData)then
		return;
	end

	local menuType = cellData.menuType;
	local npcinfo = self:GetCurNpc();
	if(menuType == Dialog_MenuData_Type.NpcFunc)then
		local stay = FunctionNpcFunc.Me():DoNpcFunc( cellData.npcFuncData, npcinfo, cellData.param )
		if(not stay)then
			self:CloseSelf(self);
		end
	end
end

function GuildOpenRaidDialog:UpdateDialog()
	if(not self.dialogData)then
		self.dialogData = {};
	else
		TableUtility.TableClear(self.dialogData);
	end

	local npc = self:GetCurNpc();
	local npcid = npc.data.staticData.id;
	self.dialogData.Speaker = npcid;
	self.dialogData.NoSpeak = true;

	local guildGateInfo = GuildProxy.Instance:GetGuildGateInfoByNpcId(npc.data.id);
	if(guildGateInfo)then
		self.nextraidTime = guildGateInfo and guildGateInfo.closetime;
		self.gateState = guildGateInfo.state or 1;
		self.gate_isSpecial = guildGateInfo.gate_isSpecial;
		if(not guildGateInfo.gate_isSpecial)then
			local config = GameConfig.GuildRaid[npcid];
			if(config)then
				self.limit_userlevel = config.UserLevel;
				self.open_costItem = config.OpenItem;
				self.unlock_level = config.GuildLevel;
			end
		end

		TimeTickManager.Me():ClearTick(self, 1)
		local leftRaidTime = self.nextraidTime - curSerTime()/1000;
		self.dialogData.Text = self:GetGuildOpenDialogText(leftRaidTime);

		if(leftRaidTime > 0 and self.gateState ~= Guild_GateState.Lock)then
			TimeTickManager.Me():CreateTick(0, 1000, self.UpdateLeftRaidTime, self, 1);
		end
	else
		self.dialogData.Text = "";
	end

	self.dialogCtl:SetData(self.dialogData);
end

function GuildOpenRaidDialog:UpdateMenuData()
	if(not self.menuData)then
		self.menuData = {};
	else
		TableUtility.TableClear(self.menuData);
	end

	local npc = self:GetCurNpc();
	local npcfunc = npc.data.staticData.NpcFunction;
	for i=1,#npcfunc do
		local typeid, param, name = npcfunc[i].type, npcfunc[i].param, npcfunc[i].name;
		local npcFuncData = typeid and Table_NpcFunction[typeid];
		if(npcFuncData)then
			-- 判断npc功能是否在menu中解锁 
			local isImplemented = FunctionNpcFunc.Me():getFunc(typeid);
			if(isImplemented and FunctionUnLockFunc.Me():CheckCanOpenByPanelId(typeid))then
				local npcinfo = self:GetCurNpc();
				local state, othername = FunctionNpcFunc.Me():CheckFuncState(npcFuncData.NameEn, npcinfo, param)
				local canShow = self:CheckOpenNpcFuncState(npcFuncData);
				if(canShow and state == NpcFuncState.Active or state == NpcFuncState.Grey)then
					local temp = {};
					temp.state = state;
					temp.menuType = Dialog_MenuData_Type.NpcFunc;
					temp.name = othername or name or npcFuncData.NameZh;
					temp.npcFuncData = npcFuncData;
					temp.param = param;
					table.insert(self.menuData, temp);
				end
			end
		end
	end
	if(#self.menuData > 0)then
		self.menu:SetActive(true);
		self.menuCtl:ResetDatas(self.menuData);
		self.menuSprite.height = 60 + #self.menuData * 70;
	else
		self.menu:SetActive(false);
	end
end

function GuildOpenRaidDialog:CheckOpenNpcFuncState(npcFuncData)
	if(npcFuncData.Type == "Common_GuildRaid")then
		if(self.gateState == nil or self.gateState == Guild_GateState.Lock)then
			return npcFuncData.NameEn == "Unlock";
		elseif(self.gateState == Guild_GateState.Close)then
			return npcFuncData.NameEn == "Open";
		elseif(self.gateState == Guild_GateState.Open)then
			return npcFuncData.NameEn == "Enter";
		end
	end
	return true;
end

function GuildOpenRaidDialog:UpdateLeftRaidTime()
	local leftRaidTime = self.nextraidTime - curSerTime()/1000;
	if(leftRaidTime > 0)then
		self.dialogData.Text = self:GetGuildOpenDialogText(leftRaidTime);
		self.dialogCtl:SetData(self.dialogData);
	else
		self:UpdateDialog();
	end
end

function GuildOpenRaidDialog:GetGuildOpenDialogText(leftRaidTime)
	if(self.gateState == Guild_GateState.Lock)then
		if(self.unlock_level)then
			return string.format(ZhString.GuildOpenRaidDialog_EnterFuben_LockTip, self.unlock_level);
		else
			return ZhString.GuildOpenRaidDialog_EnterFuben_LockTip;
		end
	elseif(self.gateState == Guild_GateState.Open)then
		if(leftRaidTime > 0)then
			local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.FormatTimeBySec( leftRaidTime )
			if(leftDay > 0 or leftHour > 0)then
				local tipStr = ZhString.GuildOpenRaidDialog_EnterFuben_Dialog .. "\n" .. ZhString.GuildOpenRaidDialog_OpenFuben_Dialog_1;
				return string.format(tipStr, leftDay, leftHour, leftMin, leftSec);
			else
				local tipStr = ZhString.GuildOpenRaidDialog_EnterFuben_Dialog ..  "\n" .. ZhString.GuildOpenRaidDialog_OpenFuben_Dialog_2;
				return string.format(tipStr, leftDay, leftHour, leftMin, leftSec);
			end
		else
			return ZhString.GuildOpenRaidDialog_EnterFuben_Dialog;
		end
	elseif(self.gateState == Guild_GateState.Close)then
		local limitStr = "";
		if(self.limit_userlevel)then
			limitStr = string.format(ZhString.GuildOpenRaidDialog_OpenFuben_LevelLimit, self.limit_userlevel);
		end
		local openTip = ZhString.GuildOpenRaidDialog_OpenFuben_Dialog;
		if(self.open_costItem)then
			local costTip = "";
			for i=1,#self.open_costItem do
				local cost = self.open_costItem[i];
				local item = Table_Item[cost[1]];
				if(item)then
					costTip = tostring(cost[2]) .. ZhString.GuildOpenRaidDialog_Ge .. item.NameZh;
				end
				if(i < #self.open_costItem)then
					costTip = costTip .. "、";
				end
			end
			openTip = string.format(openTip, costTip);
		end

		if(leftRaidTime > 0)then
			local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.FormatTimeBySec( leftRaidTime )
			if(leftDay > 0 or leftHour > 0)then
				local tipStr = openTip .. "\n" .. limitStr .. "\n" .. ZhString.GuildOpenRaidDialog_OpenFuben_Dialog_1;
				return string.format(tipStr, leftDay, leftHour, leftMin, leftSec);
			else
				local tipStr = openTip ..  "\n" .. limitStr ..  "\n" .. ZhString.GuildOpenRaidDialog_OpenFuben_Dialog_2;
				return string.format(tipStr, leftDay, leftHour, leftMin, leftSec);
			end
		else
			return openTip ..  "\n" .. limitStr;
		end
	end
end

function GuildOpenRaidDialog:MapEvent()
end

function GuildOpenRaidDialog:OnEnter()
	GuildOpenRaidDialog.super.OnEnter(self);
	local npcinfo = self.viewdata.viewdata.npcInfo;
	if(npcinfo~=nil)then
		self.npcguid = npcinfo.data.id;

		local viewPort = CameraConfig.NPC_Dialog_ViewPort;
		local duration = CameraConfig.NPC_Dialog_DURATION;
		local npcTrans = npcinfo.assetRole.completeTransform;
		self:CameraFocusOnNpc(npcTrans, viewPort, duration);
	end

	self:UpdateDialog();
	self:UpdateMenuData();
end

function GuildOpenRaidDialog:GetCurNpc()
	if(self.npcguid)then
		return NSceneNpcProxy.Instance:Find(self.npcguid);
	end
	return nil;
end

function GuildOpenRaidDialog:OnExit()
	GuildOpenRaidDialog.super.OnExit(self);
	TimeTickManager.Me():ClearTick(self, 1)

	self:CameraReset();
end

