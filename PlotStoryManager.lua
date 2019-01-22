PlotStoryManager = class("PlotStoryManager")

autoImport("PlotStoryProcess");
autoImport("FakeNPlayer");

PlotStoryManager.PlotStoryUIId = 800;

PlotStoryManager.LimitNpc = 100;

PlotConfig_Prefix = {
	Quest = "Table_PlotQuest_",
	Anim = "Table_PlotAnim_",
}

function PlotStoryManager:ctor()
	self.plotList = {};
	self.npcMap = {};
	self.uiMap = {};
	self.buttonStateMap = {};
	self.roleMoveSpdCache = {};

	self.customNpcList_Map = {
		[PlotConfig_Prefix.Quest] = {};
		[PlotConfig_Prefix.Anim] = {};
	};
end

function PlotStoryManager:Start(plotid, plotEndCall, plotEndCallParam, config_Prefix, customNpclist)
	self:Stop();
	self.cameraDirty = false;

	-- ????????????
	FunctionSystem.WeakInterruptMyself();
	FunctionSystem.InterruptMyselfAI();

	Game.AssetManager_Role:SetForceLoadAll(true);

	-- self.oriLimitNum = Game.LogicManager_RoleDress:GetLimitCount();
	-- Game.LogicManager_RoleDress:SetLimitCount(PlotStoryManager.LimitNpc);

	self.endCall = plotEndCall;
	self.endCallParam = plotEndCallParam;

	self:AddUIView(PlotStoryManager.PlotStoryUIId);

	Game.HandUpManager:MaunalClose();

	config_Prefix = config_Prefix or PlotConfig_Prefix.Quest;

	if(customNpclist)then
		local cacheTable = self.customNpcList_Map[config_Prefix];
		cacheTable[plotid] = customNpclist
	end

	self:Play(plotid, config_Prefix);
end

function PlotStoryManager:StartScenePlot(plotid, starttime, plotEndCall, plotEndCallParam, config_Prefix)
	config_Prefix = config_Prefix or PlotConfig_Prefix.Quest;
	local config = PlotStoryProcess._getStroyConfig(plotid, config_Prefix);

	local step;

	local deltatime = math.floor(ServerTime.CurServerTime()/1000 - starttime);
	if(deltatime > 0)then
		deltatime = deltatime * 1000;

		for i=1,#config do
			if(config[i].Type == "wait_time")then
				deltatime = deltatime - config[i].Params.time;
				if(deltatime <= 0)then
					step = i;
					break;
				end
			end
		end
	end

	if(deltatime > 0)then
		redlog("ERROR: Plot OverTime!!!", 
			"StartTime:" .. os.date("%Y-%m-%d-%H-%M-%S", ServerTime.CurServerTime()/1000),
			"NowTime:" .. os.date("%Y-%m-%d-%H-%M-%S", ServerTime.CurServerTime()/1000));
		return;
	end
	self:Play(plotid, config_Prefix, nil, step);
end

function PlotStoryManager:Play( plotid, config_Prefix, progressEndCall, step )
	local plotStoryProgress = PlotStoryProcess.new(plotid, config_Prefix);
	plotStoryProgress:AddEventListener(PlotStoryEvent.End, self.EndPlotProgress, self);
	plotStoryProgress:AddEventListener(PlotStoryEvent.ShutDown, self.ShutDownProgress, self);

	plotStoryProgress:SetEndCall(progressEndCall);

	table.insert(self.plotList, plotStoryProgress);

	if(self.running)then
		plotStoryProgress:Launch(step);
	end
end

function PlotStoryManager:EndPlotProgress(plotProgress)
	if(plotProgress)then
		plotProgress:ShutDown();
	end
	
	if(self.endCall and #self.plotList == 0)then
		self.endCall(self.endCallParam);
	end
	self.endCall = nil;
	self.endCallParam = nil;
end

function PlotStoryManager:ShutDownProgress(plotProgress)
	for i=#self.plotList, 1, -1 do
		local plot = self.plotList[i];
		if(plot == plotProgress)then
			table.remove(self.plotList, i);
		end
	end

	if(#self.plotList == 0)then
		self:Clear();
		Game.AssetManager_Role:SetForceLoadAll(false);
		-- Game.LogicManager_RoleDress:SetLimitCount(self.oriLimitNum);
	end
end

function PlotStoryManager:GetNowProgressList()
	return self.plotList;
end

function PlotStoryManager:GetProgressById(plotid)
	for i=1,#self.plotList do
		if(self.plotList[i].plotid == plotid)then
			return self.plotList[i];
		end
	end
end


-- npc begin
function PlotStoryManager:CombineNpcKey(plotid, npcuid)
	if(plotid and npcuid)then
		return plotid..npcuid;
	end 
	errorLog(string.format("Error When Combine NPCKEY %s %s", tostring(plotid), tostring(npcuid)));
	return "NULL";
end

function PlotStoryManager:GetPlotCustomNpcInfo(config_Prefix, plotid, npcindex)
	local cache = self.customNpcList_Map[config_Prefix];
	local customNpclist = cache[plotid];
	if(customNpclist)then
		return customNpclist[npcindex];
	end
end

function PlotStoryManager:CreateNpcRole(plotid, npcuid, npcid, pos, groupid, npcname)
	local combineKey = self:CombineNpcKey(plotid, npcuid);
	local fakeNpc = self.npcMap[combineKey];
	if(not fakeNpc)then
		local fakeServerData;
		if(Table_Npc[npcid])then
			fakeServerData = {};
			fakeServerData.guid = npcuid;
			fakeServerData.name = Table_Npc[npcid].NameZh;
			fakeServerData.npcid = npcid;
		elseif(Table_Monster[npcid])then
			fakeServerData = {};
			fakeServerData.guid = npcuid;
			fakeServerData.name = Table_Monster[npcid].NameZh;

			fakeServerData.monsterid = npcid;
		end
		if(npcname)then
			fakeServerData.name = npcname;
		end
		if(fakeServerData)then
			fakeServerData.pos = pos;
			
			fakeServerData.attrs = {};
			fakeServerData.datas = {};

			fakeServerData.groupid = groupid;

			fakeNpc = FakeNPlayer.CreateAsTable(fakeServerData);

			self.npcMap[combineKey] = fakeNpc;
		end
	end

	return fakeNpc;
end

function PlotStoryManager:GetNpcRole(plotid, npcuid)
	local combineKey = self:CombineNpcKey(plotid, npcuid);
	return self.npcMap[combineKey];
end

function PlotStoryManager:GetNpcRoles_ByGroupId(groupid)
	if(not groupid)then
		return;
	end

	local npcs = {};
	for _, npcRole in pairs(self.npcMap)do
		if(npcRole and npcRole.data:GetGroupID() == groupid)then
			table.insert(npcs, npcRole)
		end
	end
	return npcs;
end

function PlotStoryManager:DestroyNpcRole(plotid, npcuid)
	local combineKey = self:CombineNpcKey(plotid, npcuid);
	local npcRole = self.npcMap[combineKey];
	if(npcRole)then
		npcRole:Destroy();
	end
	self.npcMap[combineKey] = nil;
end

local npcDeleter = function (npcRole)	npcRole:Destroy()	end
function PlotStoryManager:ClearNpcMap()
	TableUtility.TableClearByDeleter(self.npcMap, npcDeleter);
end
-- npc end


-- button begin
function PlotStoryManager:CombineButtonKey(plotid, buttonid)
	if(plotid and buttonid)then
		return plotid..buttonid;
	end
	errorLog(string.format("Error When Combine BUTTONKEY %s %s", tostring(plotid), tostring(buttonid)));
	return "NULL";
end

function PlotStoryManager:AddButton(plotid, buttonid, buttonData)
	local combineKey = self:CombineButtonKey(plotid, buttonid);
	GameFacade.Instance:sendNotification( PlotStoryViewEvent.AddButton, buttonData );

	self.buttonStateMap[combineKey] = 1;
end

function PlotStoryManager:SetButtonState(plotid, buttonid, state)
	local combineKey = self:CombineButtonKey(plotid, buttonid);
	self.buttonStateMap[combineKey] = state;
end

function PlotStoryManager:GetButtonState(plotid, buttonid)
	local combineKey = self:CombineButtonKey(plotid, buttonid);
	return self.buttonStateMap[combineKey];
end

function PlotStoryManager:ClearButtonStates()
	TableUtility.TableClear(self.buttonStateMap);
end
-- button end


-- ui begin
function PlotStoryManager:AddUIView(panelid)
	if(not self.uiMap[panelid])then
		local panelConfig = FunctionUnLockFunc.Me():GetPanelConfigById(panelid);
		if(panelConfig)then
			GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = panelConfig});
			self.uiMap[panelid] = panelConfig;
		end
	end
end

function PlotStoryManager:CloseUIView(panelid)
	local panelConfig = self.uiMap[panelid];
	if(panelConfig)then
		local viewClass = _G[panelConfig.class];
		if(viewClass)then
			GameFacade.Instance:sendNotification(UIEvent.CloseUI, viewClass.ViewType);
		end
	end
end

function PlotStoryManager:ClearUIView()
	for panelid, panelConfig in pairs(self.uiMap)do
		self:CloseUIView(panelid);
		self.uiMap[panelid] = nil;
	end
end
-- ui end


-- camera begin
function PlotStoryManager:SetCameraEndStay(b)
	self.camera_endstay = b;
end

function PlotStoryManager:ActiveCameraControl(active)
	self.cameraDirty = true;
	if(active)then
		GameObjectUtil.SetBehaviourEnabled(CameraController.singletonInstance , true);
		CameraController.singletonInstance:ForceApplyCurrentInfo();
	else
		GameObjectUtil.SetBehaviourEnabled(CameraController.singletonInstance , false);
	end
end

function PlotStoryManager:SetCamera(pos, rotation, fieldOfView)
	if(not pos and not fieldOfView)then
		return;
	end

	local cameraTrans = Camera.main.transform;
	if(pos)then
		cameraTrans.position = pos;
	end
	if(rotation)then
		cameraTrans.rotation = rotation;
	end
	if(fieldOfView)then
		Camera.main.fieldOfView = fieldOfView;
	end
	CameraController.singletonInstance:UpdateCameras();

	self:ActiveCameraControl(false);
end

function PlotStoryManager:MoveCamera(pos, targetPos, time)

end
-- camera end


-- Set PlayerSpd begin
function PlotStoryManager:SetRoleMoveSpd(role, moveSpd)
	local roleData = role and role.data;
	if(roleData)then
		local id = roleData.id;
		local moveSpdProp = roleData.props.MoveSpd;
		if(self.roleMoveSpdCache[id] == nil)then
			self.roleMoveSpdCache[id] = moveSpdProp:GetValue();
		end
		moveSpdProp:SetValue(moveSpd*1000);
		role:Client_SetMoveSpeed(moveSpdProp:GetValue());
	end
end

function PlotStoryManager:ResetMoveSpd(role)
	if(role)then
		local oriSpd = self.roleMoveSpdCache[role.data.id];
		if(oriSpd)then
			local moveSpdProp = role.data.props.MoveSpd;
			moveSpdProp:SetValue(oriSpd * 1000);
			role:Client_SetMoveSpeed(moveSpdProp:GetValue());
		end
	else
		for roleid, oriSpd in pairs(self.roleMoveSpdCache)do
			local role = SceneCreatureProxy.FindCreature(roleid);
			if(role)then
				local moveSpdProp = role.data.props.MoveSpd;
				moveSpdProp:SetValue(oriSpd * 1000);
				role:Client_SetMoveSpeed(moveSpdProp:GetValue());
			end
		end
	end
end
-- Set PlayerSpd end


function PlotStoryManager:Clear()
	self:ClearNpcMap();
	self:ClearButtonStates();
	self:ClearUIView();

	local customNpclist_quest = self.customNpcList_Map[PlotConfig_Prefix.Quest];
	TableUtility.TableClear(customNpclist_quest);
	local customNpclist_anim = self.customNpcList_Map[PlotConfig_Prefix.Anim];
	TableUtility.TableClear(customNpclist_anim);

	if(self.cameraDirty)then
		self.cameraDirty = false;

		if(not self.camera_endstay)then
			self:ActiveCameraControl(true);
		end
	end
	self:ResetMoveSpd();

	Game.HandUpManager:MaunalOpen();
end

function PlotStoryManager:StopProgressById( plotid )
	for i=#self.plotList,1,-1 do
		if(self.plotList[i].plotid == plotid)then
			self.plotList[i]:ShutDown();
			break;
		end
	end
end

function PlotStoryManager:Stop()
	for i=1,#self.plotList do
		self.plotList[i]:ShutDown();
	end
end


-- plotstory manager selfFunc
function PlotStoryManager:Launch()
	if(self.running)then
		return;
	end
	self.running = true;
	self.camera_endstay = false;

	for i=1, #self.plotList do
		self.plotList[i]:Launch();
	end
end

function PlotStoryManager:Update(time, deltaTime)
	if(not self.running)then
		return;
	end

	for i=1,#self.plotList do
		self.plotList[i]:Update(time, deltaTime);
	end

	for _, npc in pairs(self.npcMap) do
		npc:Update(time, deltaTime);
	end
end

function PlotStoryManager:Shutdown()
	if(not self.running)then
		return;
	end
	self.running = false;

	self:Stop();
end



