FunctionUnLockFunc = class("FunctionUnLockFunc")

autoImport("ConditionCheck")

LockFuncReason = {
	MenuLock = "MenuLock",
	Interface = "Interface",
}

MenuUnlockType = 
{
	View = 1,
	NpcFunction = 2,
}

function FunctionUnLockFunc.Me()
	if nil == FunctionUnLockFunc.me then
		FunctionUnLockFunc.me = FunctionUnLockFunc.new()
	end
	return FunctionUnLockFunc.me
end

function FunctionUnLockFunc:ctor()
	self.menuData = {};
	self:InitMenuUnLock();
	self:InitInterfaceData();
	
	self.enterBtnsMap = {};
end

function FunctionUnLockFunc:InitMenuUnLock()
	for key,data in pairs(Table_Menu)do
		local mData = self.menuData[key];
		if(not mData)then
			mData = {};
			mData.checker = ConditionCheck.new();
			self.menuData[key] = mData;
		end
		mData.staticData = data;
		mData.checker:SetReason(LockFuncReason.MenuLock);
	end
end

function FunctionUnLockFunc:GetMenuId(menuData)
	if(menuData)then
		if(menuData.staticData)then
			return menuData.staticData.id;
		elseif(menuData.interfaceData)then
			return menuData.interfaceData.id;
		end
	end
end

function FunctionUnLockFunc:GetMenuData(menuid)
	return self.menuData[menuid];
end

function FunctionUnLockFunc:GetMenuDataByPanelID(panelId, unlockType)
	for _,mData in pairs(self.menuData)do
		if(mData.staticData)then
			if(mData.staticData.PanelID == panelId and mData.staticData.type == unlockType)then
				return mData;
			end
		end
		if(mData.interfaceData)then
			if(mData.interfaceData.PanelID == panelId)then
				return mData;
			end
		end
	end
end

function FunctionUnLockFunc:InitInterfaceData()
	self.propMap = {};
	for _,iData in pairs(Table_InterfaceOpen)do
		if(iData.Condition and iData.Condition.Prop)then
			if(iData.Condition.Prop.VarName)then
				self.propMap[iData.Condition.Prop.VarName] = 1;
			end
			if(iData.PanelID)then
				local mData = self:GetMenuDataByPanelID(iData.PanelID, MenuUnlockType.View);
				if(not mData)then
					-- interface表 和 menu表 两张表没有统一的唯一Key 但是两者的reason却要统一
					-- （待优化）这样写应该是不被允许的 可临时解决问题
					local key = "Interface"..iData.PanelID;
					mData = {};
					mData.checker = ConditionCheck.new();
					self.menuData[key] = mData;
					iData.id = key;
				end
				mData.interfaceData = iData;
				self:SetReason(self:GetMenuId(mData), LockFuncReason.Interface);
			end
		end
	end
end

function FunctionUnLockFunc:SetReason(menuid, reason)
	local menuData = self.menuData[menuid];
	if(menuData)then
		menuData.checker:SetReason(reason);
	end
end

function FunctionUnLockFunc:RemoveReason(menuid, reason)
	local mData = self.menuData[menuid];
	if(mData)then
		mData.checker:RemoveReason(reason);
	end
end

function FunctionUnLockFunc:ClearUselessButton()
	for key,buttons in pairs(self.enterBtnsMap)do
		for i=#buttons, 1, -1 do
			if(GameObjectUtil.Instance:ObjectIsNULL(buttons[i]))then
				table.remove(buttons, i);
			end
		end
		if(#buttons == 0)then
			self.enterBtnsMap[key] = nil;
		end
	end
end

function FunctionUnLockFunc:RegisteEnterBtn(menuid, button)
	local mData = self.menuData[menuid];
	if(mData and mData.staticData.Enterhide == 1)then
		if(not self:CheckCanOpen(menuid))then
			local buttonMap = self.enterBtnsMap[menuid];
			if(not buttonMap)then
				self.enterBtnsMap[menuid] = {};
				buttonMap = self.enterBtnsMap[menuid];
			end
			table.insert(buttonMap, button);
			button.gameObject:SetActive(false);
		end
	end
	self:ClearUselessButton();
end

function FunctionUnLockFunc:RegisteEnterBtnByPanelID(panelid, button)
	local data = self:GetMenuDataByPanelID(panelid, MenuUnlockType.View);
	if(data)then
		self:RegisteEnterBtn(self:GetMenuId(data), button)
	end
end

function FunctionUnLockFunc:UnRegisteEnterBtn(menuid)
	local buttons = self.enterBtnsMap[menuid];
	if(buttons)then
		for _,button in pairs(buttons)do
			if(not GameObjectUtil.Instance:ObjectIsNULL(button))then
				button.gameObject:SetActive(true);
			end
		end
		self.enterBtnsMap[menuid] = nil;
		GameFacade.Instance:sendNotification(UIMenuEvent.UnRegisitButton);
	end
end

function FunctionUnLockFunc:CheckCanOpen(menuid, withTip)
	if(menuid == nil)then
		return true;
	end

	local menuData = self.menuData[menuid];
	if(menuData)then
		local open = not menuData.checker:HasReason();
		if(withTip and not open)then
			self:ErrorMsg(menuid);
		end
		return open;
	end
	return false;
end

function FunctionUnLockFunc:CheckCanOpenByPanelId(panelId, withTip, unlockType)
	unlockType = unlockType or MenuUnlockType.View;

	local menuData = self:GetMenuDataByPanelID(panelId, unlockType);
	if(menuData)then
		return self:CheckCanOpen(self:GetMenuId(menuData), withTip);
	end
	return true;
end

function FunctionUnLockFunc:ErrorMsg(menuid)
	local mData = self:GetMenuData(menuid);
	if(mData) then
		local msgid, params;
		local reasons = mData.checker.reasons;
		if(type(reasons)=="table")then
			local _,reason = next(reasons);
			if(reason == LockFuncReason.MenuLock)then
				msgid = mData.staticData.sysMsg.id;
				params = mData.staticData.sysMsg.params;
			elseif(reason == LockFuncReason.Interface and mData.interfaceData)then
				msgid = mData.interfaceData.SysMsgID.id;
				params = mData.interfaceData.SysMsgID.params;
			end
		end
		if(msgid)then
			MsgManager.ShowMsgByIDTable(msgid, params);
		end
	end
end

function FunctionUnLockFunc:UnLockMenu(menuid)
	self:RemoveReason(menuid, LockFuncReason.MenuLock);
end

function FunctionUnLockFunc:LockMenu(menuid)
	self:SetReason(menuid, LockFuncReason.MenuLock);
end

function FunctionUnLockFunc:CheckProp(prop)
	if(not prop or not self.propMap[prop.propVO.name])then
		return;
	end
	for _,mData in pairs(self.menuData)do
		if(mData.interfaceData)then
			local condition = mData.interfaceData.Condition;
			if(condition.Prop and condition.Prop.VarName == prop.propVO.name)then
				if(prop:GetValue() == condition.Prop.value)then
					self:RemoveReason(self:GetMenuId(mData), LockFuncReason.Interface);
				else
					self:SetReason(self:GetMenuId(mData), LockFuncReason.Interface);
				end
			end
		end
	end
end

function FunctionUnLockFunc:GetPanelConfigById(panelid)
	if(not self.panelConfigMap)then
		self.panelConfigMap = {};
		for _, config in pairs(PanelConfig) do
			self.panelConfigMap[config.id] = config;
		end
	end
	return self.panelConfigMap[panelid];
end









