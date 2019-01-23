PVPFactory = class("PVPFactory")

local HandleRolesBase = function (roles)
	local myselfTeamID = Game.Myself.data:GetTeamID()
	local role,teamid
	for i=1,#roles do
		role = roles[i]
		if(myself~=role) then
			teamid = role.data:GetTeamID()
			role.data:Camp_SetIsInPVP(true)
			role.data:Camp_SetIsInMyTeam(myselfTeamID==teamid)
		end
	end
end

local HandleRolesGVG = function (roles,isGVGStart,ignoreTeam)
	local myselfTeamID = Game.Myself.data:GetTeamID()
	local myselfGuildData = Game.Myself.data:GetGuildData()
	local role,teamid,guildData
	for i=1,#roles do
		role = roles[i]
		if(myself~=role) then
			teamid = role.data:GetTeamID()
			guildData = role.data:GetGuildData()
			role.data:Camp_SetIsInGVG(isGVGStart)
			if(ignoreTeam ~= true)then
				role.data:Camp_SetIsInMyTeam(myselfTeamID==teamid)
			end
			if(myselfGuildData~=nil and guildData~=nil) then
				role.data:Camp_SetIsInMyGuild(myselfGuildData.id == guildData.id)
			else
				role.data:Camp_SetIsInMyGuild(false)
			end
		end
	end
end

local HandleNpcsGVG = function (roles,isGVGStart)
	local myselfGuildData = Game.Myself.data:GetGuildData()
	local role,guildData
	for k,role in pairs(roles) do
		if(myself~=role) then
			guildData = role.data:GetGuildData()
			role.data:Camp_SetIsInGVG(isGVGStart)
			if(myselfGuildData~=nil and guildData~=nil) then
				role.data:Camp_SetIsInMyGuild(myselfGuildData.id == guildData.id)
			else
				role.data:Camp_SetIsInMyGuild(false)
			end
		end
	end
end

local SinglePVP = class("SinglePVP")

function SinglePVP:Launch()
	GameFacade.Instance:sendNotification(PVPEvent.PVPDungeonLaunch)
	GameFacade.Instance:sendNotification(PVPEvent.PVP_ChaosFightLaunch)
	EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles,self.HandleAddRoles,self)
end

function SinglePVP:Shutdown()
	GameFacade.Instance:sendNotification(PVPEvent.PVPDungeonShutDown)
	GameFacade.Instance:sendNotification(PVPEvent.PVP_ChaosFightShutDown)
	EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles,self.HandleAddRoles,self)
end

function SinglePVP:HandleAddRoles(roles)
	HandleRolesBase(roles)
end

function SinglePVP:Update()
end

local TwoTeamPVP = class("TwoTeamPVP")

function TwoTeamPVP:Launch()
	GameFacade.Instance:sendNotification(PVPEvent.PVPDungeonLaunch)
	GameFacade.Instance:sendNotification(PVPEvent.PVP_DesertWolfFightLaunch)
	EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles,self.HandleAddRoles,self)
end

function TwoTeamPVP:Shutdown()
	GameFacade.Instance:sendNotification(PVPEvent.PVPDungeonShutDown)
	GameFacade.Instance:sendNotification(PVPEvent.PVP_DesertWolfFightShutDown)
	EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles,self.HandleAddRoles,self)
end

function TwoTeamPVP:HandleAddRoles(roles)
	HandleRolesBase(roles)
end

function TwoTeamPVP:Update()
end

local MvpFight = class("MvpFight")

function MvpFight:ctor()
	self.isMvpFight = true;
end

function MvpFight:Launch()
	self.isMvpFight = true;
	GameFacade.Instance:sendNotification(PVPEvent.PVP_MVPFightLaunch)
	EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles,self.HandleAddRoles,self)
end

function MvpFight:Shutdown()
	self.isMvpFight = false
	GameFacade.Instance:sendNotification(PVPEvent.PVP_MVPFightShutDown)
	EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles,self.HandleAddRoles,self)
end

function MvpFight:HandleAddRoles(roles)
	HandleRolesBase(roles)
end

function MvpFight:Update()
end

local TeamsPVP = class("TeamsPVP")

function TeamsPVP:Launch()
	GameFacade.Instance:sendNotification(PVPEvent.PVPDungeonLaunch)
	GameFacade.Instance:sendNotification(PVPEvent.PVP_GlamMetalFightLaunch)
	EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles,self.HandleAddRoles,self)
end

function TeamsPVP:Shutdown()
	GameFacade.Instance:sendNotification(PVPEvent.PVPDungeonShutDown)
	GameFacade.Instance:sendNotification(PVPEvent.PVP_GlamMetalFightShutDown)
	EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles,self.HandleAddRoles,self)
	if(Game.Myself~=nil) then
		Game.Myself:PlayTeamCircle(0)
	end
end

function TeamsPVP:HandleAddRoles(roles)
	HandleRolesBase(roles)
end

function TeamsPVP:Update()
end

local GuildMetalGVG = class("GuildMetalGVG")

function GuildMetalGVG:ctor()
	self.noSelectTarget = true
	self.isGVG = true
	self.calmDown = true
end

function GuildMetalGVG:Launch()
	GameFacade.Instance:sendNotification(GVGEvent.GVGDungeonLaunch)
	EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles,self.HandleAddRoles,self)
	EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs,self.HandleAddNpcs,self)
	EventManager.Me():AddEventListener(ServiceEvent.GuildCmdEnterGuildGuildCmd,self.HandleSomeGuildChange,self)
	EventManager.Me():AddEventListener(ServiceEvent.GuildCmdExitGuildGuildCmd,self.HandleSomeGuildChange,self)
end

function GuildMetalGVG:Shutdown()
	GameFacade.Instance:sendNotification(GVGEvent.GVGDungeonShutDown)
	EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles,self.HandleAddRoles,self)
	EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs,self.HandleAddNpcs,self)
	EventManager.Me():RemoveEventListener(ServiceEvent.GuildCmdEnterGuildGuildCmd,self.HandleSomeGuildChange,self)
	EventManager.Me():RemoveEventListener(ServiceEvent.GuildCmdExitGuildGuildCmd,self.HandleSomeGuildChange,self)
end

function GuildMetalGVG:HandleSomeGuildChange(note)
	local roles = NSceneNpcProxy.Instance.userMap
	HandleNpcsGVG(roles,not self.calmDown)
end

function GuildMetalGVG:HandleAddRoles(roles)
	HandleRolesGVG(roles,not self.calmDown)
end

function GuildMetalGVG:HandleAddNpcs(roles)
	HandleNpcsGVG(roles,not self.calmDown)
end

function GuildMetalGVG:SetCalmDown(val)
	if(self.calmDown~=val) then
		self.calmDown = val
		self:SetRolesInGVG(not val)
		self:SetNpcsInGVG(not val)
	end
end

function GuildMetalGVG:SetRolesInGVG(val)
	local roles = NSceneUserProxy.Instance:GetAll()
	for k,v in pairs(roles) do
		v.data:Camp_SetIsInGVG(val)
	end
end

function GuildMetalGVG:SetNpcsInGVG(val)
	local roles = NSceneNpcProxy.Instance:GetAll()
	for k,v in pairs(roles) do
		v.data:Camp_SetIsInGVG(val)
	end
end

function GuildMetalGVG:Update()
end



autoImport("PoringFightTipView");
local PoringFight = class("PoringFight");

function PoringFight:ctor()	
	self.noSelectTarget = true
	self.isPoringFight = true;
end

function PoringFight:Launch()
	GameFacade.Instance:sendNotification(PVPEvent.PVPDungeonLaunch)
	GameFacade.Instance:sendNotification(PVPEvent.PVP_PoringFightLaunch)

	if(self.cache_MyPos == nil)then
		self.cache_MyPos = LuaVector3();

		local myPos = Game.Myself:GetPosition();
		self.cache_MyPos:Set(myPos[1], myPos[2], myPos[3]);
	end

	self.initfight = false;
	self:HandleMatchCCmdGodEndTimeCCmd();

	Game.AutoBattleManager:AutoBattleOff()

	EventManager.Me():AddEventListener(MyselfEvent.TransformChange, self.OnTransformChangeHandler, self)
	EventManager.Me():AddEventListener(ServiceEvent.MatchCCmdPvpResultCCmd, self.PoringFightResult, self)
end

function PoringFight:PoringFightResult(data)
	local dataType = data and data.type
	if(dataType == PvpProxy.Type.PoringFight)then
		GameFacade.Instance:sendNotification(UIEvent.CloseUI, PoringFightTipView.ViewType );
	end
end

function PoringFight:HandleMatchCCmdGodEndTimeCCmd(data)
	if(self.initfight)then
		return false;
	end
	self.initfight = true;
	self:RemoveLt();
	local endtime = PvpProxy.Instance:GetGodEndTime() or 0;
	local leftSec = math.ceil(endtime - ServerTime.CurServerTime()/1000);

	helplog("ServerTime.CurServerTime()", os.date("%Y-%m-%d-%H-%M-%S", endtime), 
		os.date("%Y-%m-%d-%H-%M-%S", ServerTime.CurServerTime()/1000), leftSec);

	if(leftSec and leftSec > 0)then
		GameFacade.Instance:sendNotification(MainViewEvent.ShowOrHide,false)
		self:DoCameraEffect();	
		MsgManager.ShowMsgByIDTable(3608,{leftSec});
		self.effectlt = LeanTween.delayedCall(leftSec, function ()
			GameFacade.Instance:sendNotification(MainViewEvent.ShowOrHide,true)
			self:CameraReset();
			self:RemoveLt();
		end);
	end
end
function PoringFight:OnTransformChangeHandler()
	local props = Game.Myself.data.props;
	local monsterId = props.TransformID:GetValue()

	helplog("OnTransformChangeHandler : ", monsterId);
	if(monsterId == 20004)then
		GameFacade.Instance:sendNotification(UIEvent.JumpPanel, { view = PanelConfig.PoringFightTipView });
	else
		GameFacade.Instance:sendNotification(UIEvent.CloseUI, PoringFightTipView.ViewType );
	end
end
function PoringFight:GetRestrictViewPort(oriViewPort)
	local vp_x, vp_y, vp_z = oriViewPort[1], oriViewPort[2], oriViewPort[3];

	local viewWidth = UIManagerProxy.Instance:GetUIRootSize()[1];
	vp_x = 0.5 - (0.5 - vp_x) * 1280 / viewWidth;

	if(self.temp_ViewPort == nil)then
		self.temp_ViewPort = LuaVector3();
	end
	self.temp_ViewPort:Set(vp_x, vp_y, vp_z);
	
	return self.temp_ViewPort;
end
function PoringFight:DoCameraEffect()
	local rot_V3 = LuaVector3();
	local myTrans = Game.Myself.assetRole.completeTransform;
	if(myTrans)then
		rot_V3:Set(CameraConfig.FoodMake_Rotation_OffsetX,CameraConfig.FoodMake_Rotation_OffsetY,0);
		self:CameraFaceTo(myTrans, CameraConfig.FoodMake_ViewPort, nil, nil, rot_V3);
	end

	FunctionSystem.InterruptMyself();
end
function PoringFight:CameraFaceTo( transform,viewPort,rotation,duration,rotateOffset,listener )
	if nil == CameraController.singletonInstance then
		return
	end
	viewPort = viewPort or CameraConfig.UI_ViewPort

	rotation = rotation or CameraController.singletonInstance.targetRotationEuler;
	duration = duration or CameraConfig.UI_Duration
	self.cft = CameraEffectFaceTo.new(transform, nil, self:GetRestrictViewPort(viewPort), rotation, duration, listener);
	if(rotateOffset)then
		self.cft:SetRotationOffset(rotateOffset);
	end
	FunctionCameraEffect.Me():Start(self.cft);
end
function PoringFight:CameraReset()
	if(self.cft~=nil)then
		FunctionCameraEffect.Me():End(self.cft);
		self.cft = nil;
	end
end
function PoringFight:RemoveLt()
	if(self.effectlt)then
		self.effectlt:cancel();
		self.effectlt = nil;
	end
end

function PoringFight:Update()

	-- check camera effect
	if(self.cft)then
		if(self:I_IsMove())then
			self:CameraReset();
		end
	end
	-- check camera effect

end

function PoringFight:I_IsMove()
	local role = Game.Myself;
	if(role)then
		local nowMyPos = role:GetPosition();
		if(not nowMyPos)then
			return false;
		end
		if( VectorUtility.DistanceXZ(self.cache_MyPos, nowMyPos) > 0.01)then
			self.cache_MyPos:Set(nowMyPos[1], nowMyPos[2], nowMyPos[3]);
			return true;
		end
	end
	return false;
end

function PoringFight:Shutdown()

	if(self.cache_MyPos)then
		self.cache_MyPos:Destroy();
		self.cache_MyPos = nil;
	end

	GameFacade.Instance:sendNotification(MainViewEvent.ShowOrHide,true)
	self:CameraReset();
	self:RemoveLt();

	GameFacade.Instance:sendNotification(PVPEvent.PVPDungeonShutDown)
	GameFacade.Instance:sendNotification(PVPEvent.PVP_PoringFightShutdown)

	EventManager.Me():RemoveEventListener(MyselfEvent.TransformChange, self.OnTransformChangeHandler, self)
end


--溜溜猴
function PVPFactory.GetSinglePVP()
	return SinglePVP.new()
end

--沙漠之狼
function PVPFactory.GetTwoTeamPVP()
	return TwoTeamPVP.new()
end

--华丽金属
function PVPFactory.GetTeamsPVP()
	return TeamsPVP.new()
end

--华丽金属
function PVPFactory.GetGuildMetalGVG()
	return GuildMetalGVG.new()
end

function PVPFactory.GetPoringFight()
	return PoringFight.new();
end
function PVPFactory.GetMvpFight()
	return MvpFight.new();
end


local GvgDroiyan = class("GvgDroiyan");
function GvgDroiyan:ctor()
	self.isGvgDroiyan = true;
	self.triggerDatas = {};
end

function GvgDroiyan:Launch()
	helplog("<<<<=======GVG_FinalFightLaunch========>>>>>")
	GameFacade.Instance:sendNotification(GVGEvent.GVG_FinalFightLaunch);

	self:InitFightForeAreaTriggers();

	EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles,self.HandleAddRoles,self)
	EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs,self.HandleAddNpcs,self)
end

function GvgDroiyan:InitFightForeAreaTriggers()
	local config = GameConfig.GvgDroiyan and GameConfig.GvgDroiyan.RobPlatform;
	if(config == nil)then
		config = {
		  [1] = { pos = {0,0,0}, },
		  [2] = { pos = {0,0,0}, },
		  [3] = { pos = {0,0,0}, },
		};
	end

	for guid, v in pairs(config)do
		self:AddGvgDroiyan_FightForeArea_Trigger(guid, v.pos, v.RobPlatform_Area);
	end
end

function GvgDroiyan:AddGvgDroiyan_FightForeArea_Trigger(guid, pos, triggerArea)
	self:RemoveFightForAreaTrigger(guid);

	local triggerData = ReusableTable.CreateTable()
	triggerData.id = guid;
	triggerData.type = AreaTrigger_Common_ClientType.GvgDroiyan_FightForArea;

	local triggerPos = LuaVector3(pos[1], pos[2], pos[3]);
	triggerData.pos = triggerPos;
	triggerData.range = triggerArea or 5;

	self.triggerDatas[guid] = triggerData;

	SceneTriggerProxy.Instance:Add(triggerData);
end

function GvgDroiyan:RemoveFightForAreaTrigger(guid)
	local triggerData = self.triggerDatas[guid];
	if(triggerData == nil)then
		return;
	end

	SceneTriggerProxy.Instance:Remove(guid);

	if(triggerData.pos)then
		triggerData.pos:Destroy();
		triggerData.pos = nil;
	end

	ReusableTable.DestroyTable(triggerData);
	
	self.triggerDatas[guid] = nil;
end

function GvgDroiyan:ClearTirggerDatas()
	for guid, data in pairs(self.triggerDatas)do
		self:RemoveFightForAreaTrigger(guid);
	end
end

function GvgDroiyan:HandleAddRoles(roles)
	HandleRolesGVG(roles, true, true)
end

function GvgDroiyan:HandleAddNpcs(roles)
	HandleNpcsGVG(roles, true)
end


function GvgDroiyan:Update()
end

function GvgDroiyan:Shutdown()
	helplog("<<<<========GVG_FinalFightShutDown========>>>>")
	GameFacade.Instance:sendNotification(GVGEvent.GVG_FinalFightShutDown);
	
	self:ClearTirggerDatas();

	EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles,self.HandleAddRoles,self);
	EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs,self.HandleAddNpcs,self)
end

function PVPFactory.GetGvgDroiyan()
	return GvgDroiyan.new();
end

