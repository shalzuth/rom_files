DialogView = class("DialogView", ContainerView)

DialogView.ViewType = UIViewType.DialogLayer;

autoImport("Dialog_MenuData");
autoImport("NpcMenuBtnCell");
autoImport("DialogCell");
autoImport("EndLessTowerCountDownInfo");

local tempV3 = LuaVector3();

function DialogView:GetShowHideMode()
	return PanelShowHideMode.MoveOutAndMoveIn
end

function DialogView:Init()
	self:InitView();
	self:MapEvent();
end

function DialogView:InitView()
	self.menu = self:FindGO("Menu");
	self.menuSprite = self.menu:GetComponent(UISprite);

	local bottom = self:FindGO("Anchor_bottom");
	local activeH = GameObjectUtil.Instance:GetUIActiveHeight(self.gameObject)
	tempV3:Set(0, -activeH/2, 0);
	bottom.transform.localPosition = tempV3;

	self.top = self:FindGO("Anchor_Top");
	tempV3:Set(0, activeH/2, 0);
	self.top.transform.localPosition = tempV3;

	local obj = self:LoadPreferb("cell/DialogCell", bottom);
	obj.transform.localPosition = LuaVector3.zero;
	self.dialogCtl = DialogCell.new(obj);
	self.dialogCtl:AddEventListener(MouseEvent.MouseClick, self.ClickDialogEvent, self);

	-- updateTasks
	local grid = self:FindChild("MenuGrid", self.menu):GetComponent(UIGrid);
	self.menuCtl = UIGridListCtrl.new(grid, NpcMenuBtnCell, "NpcMenuBtnCell");
	self.menuCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMenuEvent, self);
end

function DialogView:ClickDialogEvent()
	local preDialog = self.dialogInfo[self.dialogIndex];
	-- ?????????????????????????????? ????????????????????????????????????????????? ??????????????????
	if(preDialog and (not preDialog.Option or preDialog.Option == "") and self.forceClickMenu ~= true)then
		self:DialogGoUpdate();
	end
end

function DialogView:ResetViewData()
	self.defaultDialogId = nil;
	self.dialoglist = nil;
	self.dialognpcs = nil;
	self.tasks = nil;
	self.callback = nil;
	self.callbackData = nil;
	self.camera = nil;
	self.wait = nil;
	self.questId = nil;
	if(self.questParams)then
		TableUtility.ArrayClear(self.questParams);
	else
		self.questParams = {};
	end
	self.addconfig = nil;
	self.addleft = nil;
	self.addfunc = nil;
	self.custommenudata = nil;
	self.npcguid = nil;
	self.npcdata = nil;
	self.optionid = nil;
	self.dialogInfo = nil;
	self.dialogIndex = nil;
	self.dialogend = false;
	self.subViewId = nil;
	self.optionWait = 0;
	self.midShowFunc = nil;
	self.midShowFuncParam = nil;
	self.midHideFunc = nil;
	self.forceClickMenu = false;
end

function DialogView:OnEnter()
	DialogView.super.OnEnter(self);

	self:ResetViewData();
	self:UpdateViewData();

	self:UpdateShow();

	self.gameObject:SetActive(true);

	local npcinfo = self:GetCurNpc();
	if(npcinfo)then
		local npcRootTrans = npcinfo.assetRole.completeTransform;
		if(npcRootTrans)then
			local viewPort = CameraConfig.NPC_Dialog_ViewPort;
			if(type(self.camera)=="number")then
				viewPort = Vector3(viewPort.x, viewPort.y, self.camera);
			end
			local duration = CameraConfig.NPC_Dialog_DURATION;
			self:CameraFocusOnNpc(npcRootTrans, viewPort, duration);
		end
	end

	local midShowFunc = self.viewdata.midShowFunc;
	if(midShowFunc)then
		self.midHideFunc = midShowFunc(self.gameObject, self.viewdata.midShowFuncParam);
	end

	FunctionVisitNpc.Me():AddVisitRef();
end

-- ViewData??????
-- 1. dialoglist(Dialog?????????ids or string(s){Text=string,ViceText=string}(s)??????????????????????????????????????????????????????)
-- 2. dialognpcs(?????????????????????NPCIDS)
-- 3. tasks ?????????????????????(??????????????????????????????)
-- 4. callback(?????????????????????) function(callbackData, optionid, isSuccess)
-- 5. camera(????????????Z?????????)
-- 6. wait(???????????? ??????????????????????????????)
-- 7. questdata(???????????????????????????)
-- 8. addconfig( ???????????????????????????(npcfunc?????????????????????) )
-- 9. addleft( ???????????????????????? )
-- 10. addfunc( ?????????????????????(NameZh = string, event, eventParam, closeDialog, waitClose) )
-- 11. npcinfo( ?????????NPC )
-- 12. subViewId( ????????????id );
-- 13. midShowFunc(gameObject, showEventParam)( ??????????????????????????????????????????????????? );
-- 14. midShowFuncParam( ??????????????????????????? );
-- 15. forceClickMenu (??????????????????????????????)
function DialogView:UpdateViewData()
	self.defaultDialogId = self.viewdata.defaultDialogId;
	self.dialoglist = self.viewdata.dialoglist;
	self.dialognpcs = self.viewdata.dialognpcs;
	self.tasks = self.viewdata.tasks;
	self.callback = self.viewdata.callback;
	self.callbackData = self.viewdata.callbackData;
	self.camera = self.viewdata.camera;
	self.wait = self.viewdata.wait;
	self.questId = self.viewdata.questId;
	self.addconfig = self.viewdata.addconfig;
	self.addleft = self.viewdata.addleft;
	self.addfunc = self.viewdata.addfunc;
	self.subViewId = self.viewdata.subViewId;
	self.forceClickMenu = self.viewdata.forceClickMenu;
	self.custommenudata = self.viewdata.custommenudata;

	local npcinfo = self.viewdata.npcinfo;
	if(npcinfo~=nil)then
		self.npcguid = npcinfo.data.id;
		self.npcdata = npcinfo.data.staticData;
	end
	
	self.dialogInfo = {};
	self.dialogIndex = 1;
	self:UpdateQuestParams();
end

function DialogView:GetCurNpc()
	if(self.npcguid)then
		return SceneCreatureProxy.FindCreature(self.npcguid);
	end
	return nil;
end

function DialogView:UpdateQuestParams()
	if(self.questId)then
		local questdata = QuestProxy.Instance:getQuestDataByIdAndType( self.questId );
		if(questdata and questdata.names)then
			TableUtility.ArrayShallowCopy(self.questParams, questdata.names);
		end
	end
end

function DialogView:UpdateShow()
	if(self.dialognpcs~=nil and type(self.dialognpcs) == "table")then
		for _,id in pairs(self.dialognpcs) do
			local npc = NSceneNpcProxy.Instance:FindNearestNpc(Game.Myself:GetPosition(), id);
			if(npc~=nil)then
				FunctionVisitNpc.Me():NpcTurnToMe(npc)
			end
		end
	end

	if(self.dialoglist)then
		self:UpdateDialoglst(self.dialoglist);
	else
		self:UpdateDefaultDialog();
	end
end

function DialogView:UpdateDialoglst(dialoglist)
	if(#dialoglist>0)then
		local dlst = {};
		-- ?????????????????????????????? ????????????????????????
		for i = 1,#dialoglist do
			local dilg, data = dialoglist[i];
			if(type(dilg)=="number")then
				-- data = Table_Dialog[dilg];
				data = DialogUtil.GetDialogData(dilg);
			elseif(type(dilg)=="string")then
				data = {id = 0, Text = dilg, SubViewId = self.subViewId};
				if(self.npcdata)then
					data.Speaker = self.npcdata.id;
				end
			elseif(type(dilg) == "table")then
				data = {id = 0, Text = dilg.Text, ViceText = dilg.ViceText};
				if(self.npcdata)then
					data.Speaker = self.npcdata.id;
				end
			end
			if(data)then
				table.insert(dlst, data);
			else
				errorLog( string.format("%s not config", dialoglist[i]) );
			end
		end
		self.dialogInfo = dlst;
		self:UpdateDialog();
	else
		self:CloseSelf();
	end
end

function DialogView:UpdateDefaultDialog()
	if(self.npcdata)then
		local defaultDialogId = self.defaultDialogId;
		if(defaultDialogId == nil)then
			defaultDialogId = self.npcdata.DefaultDialog
		end
		if(defaultDialogId)then
			local configs = {};
			if(self.npcdata)then
				configs = self.npcdata.NpcFunction;
			end
			-- self.dialogInfo ={ Table_Dialog[defaultDialogId] };
			self.dialogInfo ={ DialogUtil.GetDialogData(defaultDialogId) };
			self:UpdateDialog(configs, self.tasks);
		else
			-- ??????npc???????????????????????? ????????????????????? ?????????????????????
			local configs = self.npcdata.NpcFunction;
			local tempData = {
				id = 1, 
				Speaker = self.npcdata.id, 
				Text = '??????', 
			}; 
			self.dialogInfo ={ tempData };
			self:UpdateDialog(configs, self.tasks);
		end
	else
		self:CloseSelf();
	end
end

-- config ??? tasks ????????????
function DialogView:UpdateDialog(config, tasks)
	if(#self.dialogInfo>0)then
		self.nowDialogData = self.dialogInfo[self.dialogIndex];

		if(self.nowDialogData)then
			self.dialogCtl:SetData(self.nowDialogData, self.questParams);
			if(self.nowDialogData.Option and self.nowDialogData.Option~="")then
				local optionConfig = StringUtil.AnalyzeDialogOptionConfig(self.nowDialogData.Option);
                -- todo xde start ?????????????????????
                local optionConfig = StringUtil.AnalyzeDialogOptionConfig(OverSea.LangManager.Instance():GetLangByKey(self.nowDialogData.Option));
                -- todo xde end
				if(#optionConfig>0)then
					self:UpdateMenu(config,tasks,optionConfig);
				end
			else
				self:UpdateMenu(config,tasks, nil);
			end
			self:UpdateDialogSubView(self.nowDialogData.SubViewId);
			self.menuSprite.enabled = self.nowDialogData.Text ~= "";
		else
			errorLog("Not Find Dialog");
			self:CloseSelf();
		end
	else
		self.nowDialogData = nil;
	end
end

function DialogView:UpdateDialogSubView(subId)
	if(self.nowSubId)then
		self:RemoveSubView(self.nowSubId);
		self.nowSubId = nil;
	end
	if(subId)then
		self.nowSubId = subId;
		local subPage = SubViewMap.Instance:GetSubView(subId);
		local nowSubPage = self:AddSubView(subId, subPage);
		nowSubPage:OnEnter(subId, self);
	end
end

function DialogView:DialogGoUpdate()
	self.dialogend = self.dialogIndex == #self.dialogInfo;

	self.dialogIndex = self.dialogIndex+1;
	if(self.dialogIndex<=#self.dialogInfo)then
		self:UpdateDialog();
	else
		-- ???????????????????????????
		if(not self.addleft)then
			self:CloseSelf();
		end
	end
end

local tempArray = {};
function DialogView:UpdateMenu(configs, tasks, option)
	if(not self.menuData)then
		self.menuData = {};
	else
		TableUtility.ArrayClear(self.menuData);
	end
	-- Tasks
	if(tasks)then
		for i=1,#tasks do
			if(tasks[i])then
				if(tasks[i].staticData)then
					local taskMenuData = Dialog_MenuData.new();
					taskMenuData:Set_ByTask(tasks[i]);
					table.insert(self.menuData, taskMenuData);
				else
					errorLog(string.format("Task:%s Not Have StaticData", tasks[i].id));
				end
			end
		end
	end
	-- Configs
	if(configs or self.addconfig)then
		TableUtility.ArrayClear(tempArray);
		if(configs)then
			TableUtility.ArrayShallowCopy(tempArray, configs);
		end
		if(self.addconfig)then
			for i=1,#self.addconfig do
				table.insert(tempArray, self.addconfig[i]);
			end
		end

		for i=1,#tempArray do
			local typeid, param, name = tempArray[i].type, tempArray[i].param, tempArray[i].name;
			local npcfunc_menuData = Dialog_MenuData.new();
			npcfunc_menuData:Set_ByNpcFunctionConfig(typeid, param, name, self:GetCurNpc());
			table.insert(self.menuData, npcfunc_menuData);
		end
	end
	-- option
	if(option)then
		for i=1,#option do
			local option_menuData = Dialog_MenuData.new();
			option_menuData:Set_ByOption(option[i]);
			table.insert(self.menuData, option_menuData);
		end
	end
	-- ???????????????????????????(func(event, name))
	if(self.addfunc)then
		for i=1,#self.addfunc do
			local addFunc = self.addfunc[i];
			if(addFunc.event and addFunc.NameZh)then
				local addfunc_menuData = Dialog_MenuData.new();
				addfunc_menuData:Set_Name(addFunc.NameZh);
				addfunc_menuData:Set_CloseDialogWhenClick(addFunc.closeDialog);
				addfunc_menuData:Set_WaitCloseDialogWhenClick(addFunc.waitClose);
				addfunc_menuData:Set_CusetomClickCall(addFunc.event, addFunc.eventParam);
				table.insert(self.menuData, addfunc_menuData);
			end
		end
	end
	if(self.custommenudata)then
		for i=1,#self.custommenudata do
			table.insert(self.menuData, self.custommenudata[i]);
		end
	end
	if(self.addleft)then
		local addleft_menuData = Dialog_MenuData.new();
		addleft_menuData:Set_CusetomClickCall();
		addleft_menuData:Set_CloseDialogWhenClick(true);
		addleft_menuData:Set_Name(ZhString.DialogView_Left);
		table.insert(self.menuData, addleft_menuData);
	end

	self:UpdateMenuCtl();
end

function DialogView:RegisterMenuEvent(btnGO, optionid, needReplace)
	if(btnGO == nil or optionid == nil)then
		redlog("btnGO or optionid is nil");
		return;
	end

	local menuDataDirty = false;

	local optionData;
	local m;
	for i=#self.menuData,1,-1 do
		m = self.menuData[i];
		if(m.optionid == optionid)then
			optionData = m;

			if(needReplace)then
				menuDataDirty = true;
				table.remove(self.menuData, i)
			end

			break;
		end
	end
	local func = function ()
		if(optionData == nil)then
			self:CloseSelf();
		else
			self:DoMenuEvent(optionData);
		end
	end
	self:AddClickEvent( btnGO, func);

	if(menuDataDirty)then
		self:UpdateMenuCtl();
	end
end

function DialogView:UpdateMenuCtl(menuData)
	menuData = menuData or self.menuData;

	if(#menuData>0)then
		local realCount = #menuData;
		for i=#menuData,1,-1 do
			local mData = menuData[i];
			if(mData and mData.state == NpcFuncState.InActive)then
				realCount = realCount - 1;
			end
		end
		realCount = math.max(0, realCount);

		if(realCount > 0)then
			self.menu:SetActive(true);
			self.menuSprite.height = 60 + realCount * 70;
		else
			self.menu:SetActive(false);
		end

		self.menuCtl:ResetDatas(menuData);
		self.menuCtl.layoutCtrl.repositionNow = true;
	else
		self.menu:SetActive(false);
	end
end

function DialogView:ClickMenuEvent(cellCtl)
	local cellData = cellCtl.data;
	if(not cellData)then
		return;
	end

	self:DoMenuEvent(cellData);
end

function DialogView:DoMenuEvent(cellData)
	local menuType = cellData.menuType;
	local npcinfo = self:GetCurNpc();
	if(menuType == Dialog_MenuData_Type.NpcFunc)then
		self.dialogend = true;

		local stay = FunctionNpcFunc.Me():DoNpcFunc( cellData.npcFuncData, npcinfo, cellData.param )
		if(not stay)then
			DialogView.super.CloseSelf(self);
		end
	elseif(menuType == Dialog_MenuData_Type.Option)then
		self.optionid = cellData.optionid;
		if(self.optionid == 0)then
			self:DialogGoUpdate();
		else
			self.dialogend = true;
			-- self.optionWait = 0.2;
			self:CloseSelf();	
		end
	elseif(menuType == Dialog_MenuData_Type.Task)then
		if(cellData.task)then
			if(self.callback)then
				self.callback(cellData.task.id, self.optionid);
			end
			FunctionVisitNpc.Me():ExcuteQuestEvent(npcinfo, cellData.task);
		end
	elseif(menuType == Dialog_MenuData_Type.CustomFunc)then
		if(cellData.closeDialog == true)then
			if(cellData.waitClose ~= nil)then
				self.optionWait = cellData.waitClose;
			end
			self:CloseSelf();
		end
		-- custom event excute after close(if need)
		if(cellData.clickCall)then
			local stay = cellData.clickCall(self:GetCurNpc(), cellData.clickCallParam);
			if(cellData.closeDialog ~= true and stay == false)then
				self:CloseSelf();
			end
		end
	end
end

function DialogView:MapEvent()
	self:AddListenEvt(SceneGlobalEvent.Map2DChanged, self.HandleUpdateMap2d)
	self:AddListenEvt(DialogEvent.AddMenuEvent, self.HandleAddMenuEvent);
	self:AddListenEvt(ServiceEvent.NUserRequireNpcFuncUserCmd, self.HandleRequireNpcFuncUserCmd);
	self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpcs);
	self:AddListenEvt(DialogEvent.NpcFuncStateChange, self.HandleNpcFuncStateChange);
	self:AddListenEvt(DialogEvent.AddUpdateSetTextCall, self.HandleAddUpdateSetTextCall);

	self:AddListenEvt(ServiceUserProxy.RecvLogin, self.HandleRecvLogin);

	self:AddListenEvt(CarrierEvent.MyCarrierStart, self.CloseSelf);
end

function DialogView:HandleRecvLogin(note)
	self:CloseSelf();
end

function DialogView:HandleAddUpdateSetTextCall(note)
	self.dialogCtl:Set_UpdateSetTextCall(note.body[1], note.body[2]);
end

function DialogView:HandleNpcFuncStateChange(note)
	local changeFuncs = note.body;
	-- self.menuData
	for i=1,#changeFuncs do
		local cache = changeFuncs[i];

		local menuData,index;
		for j=#self.menuData,1,-1 do
			if(self.menuData[j].key == cache.key)then
				menuData = self.menuData[j];
				index = j;
				break;
			end
		end
		menuData:Set_State(cache.state);
	end

	self:UpdateMenuCtl();
end

function DialogView:HandleRemoveNpcs(note)
	local npcs = note.body
	if(npcs and #npcs>0)then
		for i=1,#npcs do
			if(self.npcguid == npcs[i])then
				self:CloseSelf();
			end
		end
	end
end

function DialogView:HandleUpdateMap2d(note)
	local npcinfo = self:GetCurNpc();
	if(npcinfo)then
		local npc = FunctionVisitNpc.Me():GetTarget()
		if(npc ~= npcinfo)then
			DialogView.super.CloseSelf(self);
		end
	end
end

function DialogView:HandleAddMenuEvent(note)
	local config = note.body;
	if(config == nil)then
		return;
	end

	local npcinfo = self:GetCurNpc();

	local dialog_menuData = Dialog_MenuData.new();
	dialog_menuData:Set_ByNpcFunctionConfig(config.type, config.param, config.name, npcinfo);
	table.insert(self.menuData, 1, dialog_menuData);

	
	self:UpdateMenuCtl();
end

function DialogView:HandleRequireNpcFuncUserCmd(note)
	local data = note.body;
	local npcinfo = self:GetCurNpc();

	if(data == nil or npcinfo == nil )then
		return;
	end

	local requireFunctions = npcinfo.data.staticData.RequireNpcFunction;
	local functions = data.functions;
	if(functions)then
		for i=1,#functions do
			local config = StringUtil.Json2Lua(functions[i]);
			if(type(config) == "table")then
				local dialog_menuData = Dialog_MenuData.new();
				dialog_menuData:Set_ByNpcFunctionConfig(config.type, config.param, config.name, npcinfo);
				table.insert(self.menuData, 1, dialog_menuData);
			end
		end
		self:UpdateMenuCtl();
	end
end

function DialogView:RemoveLeanTween()
	if(self.lt)then
		self.lt:cancel();
	end
	self.lt = nil;
end

-- ????????????????????????
function DialogView:CloseSelf()
	if(self.dialogend and self.callback~=nil)then
		self.callback(self.callbackData, self.optionid, true);
		self.callback = nil;
		self.callbackData = nil;
	end

	self.gameObject:SetActive(false);

	local wait = self.wait or self.optionWait or 0;
	if(wait > 0)then
		self:RemoveLeanTween();
		self.lt = LeanTween.delayedCall(wait, function ()
			DialogView.super.CloseSelf(self);
		end);
	else
		DialogView.super.CloseSelf(self);
	end
end

function DialogView:OnExit()
	-- ????????????
	self.super.OnExit(self);

	FunctionVisitNpc.Me():RemoveVisitRef();
	FunctionNpcFunc.Me():ClearUpdateCheck();

	if(self.callback~=nil)then
		self.callback(self.callbackData, nil, false);
		self.callback = nil;
		self.callbackData = nil;
	end
	if(type(self.midHideFunc) == "function")then
		self.midHideFunc();
		self.midHideFunc = nil;
	end

	self.dialogCtl:OnExit();

	self:CameraReset();
	self:RemoveLeanTween();
	
	if(self.dialognpcs~=nil and type(self.dialognpcs) == "table")then
		for _,id in pairs(self.dialognpcs) do
			local npc = NSceneNpcProxy.Instance:FindNearestNpc(Game.Myself:GetPosition(), id);
			if(npc~=nil)then
				FunctionVisitNpc.Me():NpcTurnBack(npc)
			end
		end
	end
end
