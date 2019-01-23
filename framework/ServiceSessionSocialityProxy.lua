autoImport('ServiceSessionSocialityAutoProxy')
autoImport('UIModelZenyShop')
ServiceSessionSocialityProxy = class('ServiceSessionSocialityProxy', ServiceSessionSocialityAutoProxy)
ServiceSessionSocialityProxy.Instance = nil
ServiceSessionSocialityProxy.NAME = 'ServiceSessionSocialityProxy'

function ServiceSessionSocialityProxy:ctor(proxyName)
	if ServiceSessionSocialityProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSessionSocialityProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceSessionSocialityProxy.Instance = self
	end
end

function ServiceSessionSocialityProxy:CallQuerySocialData()
	if self._canQuerySocialData then
		local now = Time.unscaledTime
		local random = math.random(15, 30)
		if self._callQuerySocialData == nil or (now - self._callQuerySocialData >= random) then
			self._callQuerySocialData = now

			helplog("Call-->QuerySocialData")
			ServiceSessionSocialityProxy.super.CallQuerySocialData(self)
		end
	end
end

function ServiceSessionSocialityProxy:RecvQuerySocialData(data)
	helplog("Recv-->QuerySocialData")
	if self._canQuerySocialData then
		self._canQuerySocialData = false

		local _SocialManager = Game.SocialManager
		for i=1,#data.datas do
			local serviceData = data.datas[i]
			_SocialManager:Update(serviceData)
		end

		_SocialManager:Sort()

		self:Notify(ServiceEvent.SessionSocialityQuerySocialData, data)
	end
end

function ServiceSessionSocialityProxy:RecvFindUser(data)
	print("RecvFindUser ~~~~~~~~~~~")
	FriendProxy.Instance:SetSearchData(data)
	self:Notify(ServiceEvent.SessionSocialityFindUser, data)
end

function ServiceSessionSocialityProxy:RecvSocialUpdate(data) 
	helplog("RecvSocialUpdate", #data.updates, #data.dels)

	local _SocialManager = Game.SocialManager
	for i=1,#data.updates do
		local serviceData = data.updates[i]
		_SocialManager:PreProcess(serviceData)
		_SocialManager:Update(serviceData)
					
	end

	for i=1,#data.dels do
		local serviceData = data.dels[i]
		_SocialManager:Remove(serviceData)
	end

	_SocialManager:Sort()
	self:Notify(ServiceEvent.SessionSocialitySocialUpdate, data)
end

function ServiceSessionSocialityProxy:RecvSocialDataUpdate(data) 
	helplog("RecvSocialDataUpdate ~~~~~~~~~~~")
	local _SocialManager = Game.SocialManager

	_SocialManager:UpdateData(data)
	_SocialManager:Sort()

	self:Notify(ServiceEvent.SessionSocialitySocialDataUpdate, data)
end

function ServiceSessionSocialityProxy:CallOperateTakeSocialCmd(type, state, subkey) 
	helplog("Call-->OperateTakeSocialCmd", type, subkey);
	ServiceSessionSocialityProxy.super.CallOperateTakeSocialCmd(self, type, state, subkey);
end


local OperateTakeDialogConfig = {
	[SessionSociality_pb.EOperateType_Summer] = GameConfig.Activity.GetIceCreamtable,
	[SessionSociality_pb.EOperateType_Autumn] = GameConfig.Activity.GetAutumnLeaftable,
	[SessionSociality_pb.EOperateType_CodeMX] = GameConfig.Activity.AppointmentThanks,
	[SessionSociality_pb.EOperateType_CodeBW] = GameConfig.Activity.MillionHitThanks,
	[SessionSociality_pb.EOperateType_RedBag] = GameConfig.Activity.ChinaNewYear,
	[SessionSociality_pb.EOperateType_Phone] = GameConfig.Activity.Safetyrewards,
	[SessionSociality_pb.EOperateType_MonthCard or 8] = GameConfig.Activity.MonthCard,
};
function ServiceSessionSocialityProxy:RecvOperateTakeSocialCmd(data ) 
	helplog("Recv-->OperateTakeSocialCmd", data.type, data.state);
	if(not data.type or not data.state)then
		return;
	end

	local config = OperateTakeDialogConfig[data.type];
	if(not config)then
		return;
	end

	local target = FunctionVisitNpc.Me():GetTarget();
	if(not target)then
		return;
	end

	local viewdata = {
		viewname = "DialogView",
		npcinfo = target
	}

	if(data.state == SessionSociality_pb.EOperateState_None)then
		local text = config[2] or config[1];
		viewdata.dialoglist = {text};
	elseif(data.state == SessionSociality_pb.EOperateState_Toke)then
		local text = config[3] or config[1];
		viewdata.dialoglist = {text};
	elseif(data.state == SessionSociality_pb.EOperateState_CanTake)then
		local text = config[1];
		viewdata.dialoglist = {text};
	end
	FunctionNpcFunc.ShowUI(viewdata);

	-- self:Notify(ServiceEvent.SessionSocialityOperateTakeSocialCmd, data)
end

function ServiceSessionSocialityProxy:CallOperateQuerySocialCmd(type, state, param1, param2, param3, param4) 
	helplog("Call-->OperateQuerySocialCmd", type, state);
	ServiceSessionSocialityProxy.super.CallOperateQuerySocialCmd(self, type, state);
end

local OperateQueryConfig = {
	[SessionSociality_pb.EOperateType_Charge] = 4032,
	[SessionSociality_pb.EOperateType_Summer] = 4027,
	[SessionSociality_pb.EOperateType_Autumn] = 4033,
	[SessionSociality_pb.EOperateType_CodeBW] = 4034,
	[SessionSociality_pb.EOperateType_CodeMX] = 4035,
	-- [SessionSociality_pb.EOperateType_RedBag] = 4036,
	[SessionSociality_pb.EOperateType_Phone] = 4037,
}
local Split_OperateQueryConfig = {
	[SessionSociality_pb.EOperateType_MonthCard or 8] = {4041, 4042, 4043},
}
function ServiceSessionSocialityProxy:RecvOperateQuerySocialCmd(data) 
	helplog("Recv-->OperateQuerySocialCmd", data.type, data.state, data.param1, data.param2, data.param3, data.param4);
	if(not data.type)then
		return;
	end

	local typeid = OperateQueryConfig[data.type];
	if(typeid)then
		if(data.state == SessionSociality_pb.EOperateState_CanTake)then
			local testData = {};
			testData.param = { data.param1, data.param2, data.param3 };
			testData.type = typeid;
			self:Notify(DialogEvent.AddMenuEvent, testData);
		end
	else
		local splitConfig = Split_OperateQueryConfig[data.type];
		if(splitConfig)then
			local param4 = data.param4;
			if(param4)then
				for i=1,#param4 do
					local index = param4[i];
					if(splitConfig[index])then
						local testData = {};
						testData.param = index;
						testData.type = splitConfig[index];
						self:Notify(DialogEvent.AddMenuEvent, testData);
					end
				end
			end
		end
	end
	-- self:Notify(ServiceEvent.SessionSocialityOperateQuerySocialCmd, data)
end

function ServiceSessionSocialityProxy:RecvQueryDataNtfSocialCmd(data) 
	self._canQuerySocialData = true

	local _SocialManager = Game.SocialManager
	_SocialManager:Clear()
	for i=1,#data.relations do
		_SocialManager:Update(data.relations[i])
	end

	self:Notify(ServiceEvent.SessionSocialityQueryDataNtfSocialCmd, data)
end

function ServiceSessionSocialityProxy:IsQuerySocialData()
	return not self._canQuerySocialData
end

function ServiceSessionSocialityProxy:RecvOperActivityNtfSocialCmd(data)
	ActivityDataProxy.Instance:InitActivityDatas( data )
	self:Notify(ServiceEvent.SessionSocialityOperActivityNtfSocialCmd, data)
end

function ServiceSessionSocialityProxy:RecvQueryRecallListSocialCmd(data)
	FriendProxy.Instance:RecvQueryRecallListSocialCmd(data)
	self:Notify(ServiceEvent.SessionSocialityQueryRecallListSocialCmd, data)
end

function ServiceSessionSocialityProxy:RecvAddRelationResultSocialCmd(data)
	Game.SocialManager:RelationResult(data)
	self:Notify(ServiceEvent.SessionSocialityAddRelationResultSocialCmd, data)
end

function ServiceSessionSocialityProxy:RecvQueryChargeVirginCmd(data)
	if data.del > 0 then
		UIModelZenyShop.Ins():RemoveFPRFlag(data.del)
	else
		UIModelZenyShop.Ins():SetFPRFlag(data.datas)
	end
	self:Notify(ServiceEvent.SessionSocialityQueryChargeVirginCmd, data)
	EventManager.Me():PassEvent(ServiceEvent.SessionSocialityQueryChargeVirginCmd, data)
end