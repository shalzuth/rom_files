Dialog_MenuData = class("Dialog_MenuData");

Dialog_MenuData_Type = {
	NpcFunc = 1,
	Task = 2,
	CustomFunc = 3,
	Option = 4,
}

function Dialog_MenuData:ctor()
	self:Reset();
end

function Dialog_MenuData:Reset()
	self:Set_Name("");	
	self:Set_CloseDialogWhenClick(true);

end

function Dialog_MenuData:Set_Name(name)
	self.name = name;
end

function Dialog_MenuData:Set_State(state)
	self.state = state;
end

function Dialog_MenuData:Set_CloseDialogWhenClick(closeDialog)
	self.closeDialog = closeDialog;
end

function Dialog_MenuData:Set_WaitCloseDialogWhenClick(waitClose)
	self.waitClose = waitClose;
end

function Dialog_MenuData:Set_CusetomClickCall(clickCall, clickCallParam)
	self.menuType = Dialog_MenuData_Type.CustomFunc;
	self.clickCall = clickCall;
	self.clickCallParam = clickCallParam;
end

function Dialog_MenuData:Set_ByNpcFunctionConfig(typeid, param, paramname, npcinfo)
	self.menuType = Dialog_MenuData_Type.NpcFunc;

	local isImplemented = FunctionNpcFunc.Me():getFunc(typeid);
	if(not isImplemented)then
		self:Set_State(NpcFuncState.InActive);
		return;
	end

	local isOpen = FunctionUnLockFunc.Me():CheckCanOpenByPanelId(typeid, false, MenuUnlockType.NpcFunction)
	if(not isOpen)then
		self:Set_State(NpcFuncState.InActive);
		return;
	end

	self.npcFuncData = Table_NpcFunction[typeid];
	if(self.npcFuncData == nil)then
		self:Set_State(NpcFuncState.InActive);
		return;
	end

	local state, othername = FunctionNpcFunc.Me():CheckFuncState(self.npcFuncData.NameEn, npcinfo, param)
	self:Set_State(state);

	if(othername)then
		self:Set_Name(othername);
	elseif(paramname)then
		self:Set_Name(paramname);
	else
		self:Set_Name(self.npcFuncData.NameZh);
	end

	self.param = param;
	self.key = self.npcFuncData.NameEn;
end

function Dialog_MenuData:Set_ByTask(task)
	self.menuType = Dialog_MenuData_Type.Task;
	self:Set_Name(task.staticData.Name);
	self.task = task;
end

function Dialog_MenuData:Set_ByOption(option)
	self.menuType = Dialog_MenuData_Type.Option;
	self.name = option.text;
	self.optionid = option.id;
end