autoImport("MenuUnLockCell")
autoImport("MenuMsgCell")
autoImport("CoinPopView")
autoImport("ItemPopView")
autoImport("MenuCatCell")
autoImport("CommonUnlockInfo");
SystemUnLockView = class("SystemUnLockView", BaseView);

SystemUnLockView.ViewType =  UIViewType.SystemOpenLayer;

SystemUnLockView.TypeEnum = {
	MenuUnlock = {prefab = ResourcePathHelper.UICell("MenuUnLock") , isMenu = true},
	MenuMsg = {prefab = ResourcePathHelper.UICell("UnLockMsg") , isMenu = true},
	MenuCatCell = {prefab = ResourcePathHelper.UICell("MenuCatCell"), isMenu = true},
	SystemMenuMsg = {prefab = ResourcePathHelper.UICell("UnLockMsg") , isMenu = false,stayTime = 500},
	MenuCoinPop = {prefab = ResourcePathHelper.UICell("CoinPopView") , isMenu = false,stayTime = 500},
	MenuItemPop = {prefab = ResourcePathHelper.UICell("ItemPopView") , isMenu = false,stayTime = 500},
	CommonUnlockInfo = {prefab = ResourcePathHelper.UICell("CommonUnlockInfo") , isMenu = false,stayTime = 500},
}

function SystemUnLockView:Init()
	self.data = self.viewdata.data;
	self:MapViewInterests()
	self:FindObjs();
	self:InitDatas()
	self:InitClickEvent();
end

function SystemUnLockView:MapViewInterests()
	self:AddListenEvt(SystemUnLockEvent.NUserNewMenu, self.HandleNewMenu);
	self:AddListenEvt(SystemUnLockEvent.CommonUnlockInfo, self.HandleCommonUnlockInfo);
end

function SystemUnLockView:FindObjs()
	self.bgClick = self:FindChild("BgClick");
end

function SystemUnLockView:InitClickEvent()
	self:AddClickEvent(self.bgClick, function (go)
		local current = self:GetCurrentCell()
		if(current~=nil and current.PlayHide ~=nil) then
			current:PlayHide()
		end
	end);
end

function SystemUnLockView:InitDatas()
	self.waitQueues = {}
	self.typeMapCell = {}
end

function SystemUnLockView:GetCurrentCell()
	return self.currentCell
end

function SystemUnLockView:HandleNewMenu(note)
	local list = note.body.list;
	self.animplay = note.body.animplay;
	self.unlocklist = self.unlocklist or {};
	local config
	for i=1,#list do
		local v = list[i];
		config = Table_Menu[v]
		if(config)then
			if(config.type == 3) then
				-- self:AddToWait({ Type = SystemUnLockView.TypeEnum.MenuMsg,id = v,class = MenuMsgCell ,data = nil})
			elseif(config.type == 4)then
				self:AddToWait({ Type = SystemUnLockView.TypeEnum.MenuCatCell,id = v,class = MenuCatCell ,data = config})
			else
				self:AddToWait({ Type = SystemUnLockView.TypeEnum.MenuUnlock,id = v,class = MenuUnLockCell ,data = nil})
			end
		end
		
	end
	self:TryShowCell();
end

function SystemUnLockView:HandleCommonUnlockInfo(note)
	local data = note.body;
	if(data)then
		self:AddToWait({ Type = SystemUnLockView.TypeEnum.CommonUnlockInfo, id = "Common",class = CommonUnlockInfo , data = data})
	end
	self:TryShowCell();
end

function SystemUnLockView:HandleMenuMsg(note)
	self:AddToWait({ Type = SystemUnLockView.TypeEnum.SystemMenuMsg,class = MenuMsgCell ,data = note.body})
	self:TryShowCell();
end

function SystemUnLockView:AddToWait(data)
	if(data.Type == nil)then
		helplog("AddToWait Error!!!");
	end
	self.waitQueues[#self.waitQueues + 1] = data
	-- printRed("data.id"..data.id.." data.isMenu"..tostring(data.Type.isMenu))
end

function SystemUnLockView:SetCurrent(data)
	self.currentCell = self:GetOrSpawnCell(data.Type,data.class)
	self.currentCell:SetData(data)
	if(data.stayTime~=nil and data.stayTime>0) then
		-- self:StartTimeTick()
	else
		-- self:EndTimeTick()
	end
end

function SystemUnLockView:TryShowCell()
	if(#self.waitQueues >0) then
		if(self:GetCurrentCell()==nil) then
			local rawData = table.remove(self.waitQueues,1)
			-- 处理默认开启
			if(rawData.Type.isMenu) then
				FunctionUnLockFunc.Me():UnLockMenu(rawData.id);
				local mData = FunctionUnLockFunc.Me():GetMenuData(rawData.id);
				rawData.data = mData and mData.staticData;
				if(rawData.data)then
					if(not self.animplay or rawData.data.Show == nil)then
						self:HandleEndAndGoNext(rawData)
						return;	
					end
				else
					printRed("CanNotFind Data "..rawData.id);
				end
			end
			if(rawData.data)then
				self:SetCurrent(rawData)
			else
				self:TryShowCell()
			end
		end
	else
		self:CloseSelf()
	end
end

function SystemUnLockView:HandleEndAndGoNext(data)
	self:HandleEnd(data)
	local current = self:GetCurrentCell()
	if(current~=nil) then
		current:Hide()
		self.currentCell = nil
	end
	self:TryShowCell()
end

function SystemUnLockView:HandleEnd(data)
	if(data.Type.isMenu) then 
		data = data.data
		FunctionUnLockFunc.Me():UnRegisteEnterBtn(data.id)
		if(data.event and data.event.type and data.event.type == "skillgrid") then
			ShortCutProxy.Instance:SetCacheListToRealList()
			self:sendNotification(SkillEvent.SkillUnlockPos)
		end
	end
end

function SystemUnLockView:GetOrSpawnCell(Type,class)
	local cell = self.typeMapCell[Type]
	if(cell==nil) then
		cell = class.new(Game.AssetManager_UI:CreateAsset(Type.prefab, self.gameObject))
		cell:AddEventListener(SystemUnLockEvent.ShowNextEvent,self.HandleEndAndGoNext,self)
		self.typeMapCell[Type] = cell
	end
	cell:Show()
	return cell
end