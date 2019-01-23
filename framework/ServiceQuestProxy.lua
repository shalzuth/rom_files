autoImport('ServiceQuestAutoProxy')
ServiceQuestProxy = class('ServiceQuestProxy', ServiceQuestAutoProxy)
ServiceQuestProxy.Instance = nil
ServiceQuestProxy.NAME = 'ServiceQuestProxy'

function ServiceQuestProxy:ctor(proxyName)
	if ServiceQuestProxy.Instance == nil then
		self.proxyName = proxyName or ServiceQuestProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceQuestProxy.Instance = self
	end
	NetProtocol.NeedCacheReceive(8,1)
end

function ServiceQuestProxy:RecvQuestDetailList(data)	
	-- QuestProxy.Instance:QuestQuestDetailList(data)
	self:Notify(ServiceEvent.QuestQuestDetailList, data)
end

function ServiceQuestProxy:RecvQuestDetailUpdate(data) 	
	-- QuestProxy.Instance:QuestQuestDetailUpdate(data)
	self:Notify(ServiceEvent.QuestQuestDetailUpdate, data)
end

function ServiceQuestProxy:RecvQuestList(data)
	QuestProxy.Instance:QuestQuestList(data)
	self:Notify(ServiceEvent.QuestQuestList, data)
end

function ServiceQuestProxy:RecvQuestUpdate(data)
	QuestProxy.Instance:QuestQuestUpdate(data)
	self:Notify(ServiceEvent.QuestQuestUpdate,data)
end
function ServiceQuestProxy:RecvQuestStepUpdate(data)
	QuestProxy.Instance:QuestQuestStepUpdate(data)	
end

function ServiceQuestProxy:CallQueryOtherData(type, data)
	ServiceQuestProxy.super.CallQueryOtherData(self, type, data);
end

-- expiretype: 1.1日租 2.7日租
function ServiceQuestProxy:CallQueryCatPrice(catid, expiretype)
	local otherData = SceneQuest_pb.OtherData();
	otherData.param1 = catid;
	otherData.param2 = expiretype;
	ServiceQuestProxy.super.CallQueryOtherData(self, SceneQuest_pb.EOTHERDATA_CAT, otherData);
end

function ServiceQuestProxy:RecvQueryOtherData(data)
	if(data.type == SceneQuest_pb.EOTHERDATA_CAT)then
		EventManager.Me():DispatchEvent(ServiceEvent.QuestQueryOtherData, data.data);
	elseif(data.type == SceneQuest_pb.EOTHERDATA_DAILY)then
		QuestProxy.Instance:setDailyQuestData(data)
	end

	self:Notify(ServiceEvent.QuestQueryOtherData, data)
end

function ServiceQuestProxy:RecvQueryWantedInfoQuestCmd(data)
	QuestProxy.Instance:setMaxWanted(data)
	self:Notify(ServiceEvent.QuestQueryWantedInfoQuestCmd, data)
end

function ServiceQuestProxy:CallQueryWorldQuestCmd() 
	-- helplog("CallQueryWorldQuestCmd");
	ServiceQuestProxy.super.CallQueryWorldQuestCmd(self);
end

function ServiceQuestProxy:RecvQueryWorldQuestCmd(data) 
	-- helplog("RecvQueryWorldQuestCmd", #data.quests);
	WorldMapProxy.Instance:SetWorldQuestInfo(data.quests);
	self:Notify(ServiceEvent.QuestQueryWorldQuestCmd, data)
end

function ServiceQuestProxy:RecvQueryManualQuestCmd(data)
	-- helplog("RecvQueryManualQuestCmd")
	QuestManualProxy.Instance:HandleRecvQueryManualQuestCmd(data)
	self:Notify(ServiceEvent.QuestQueryManualQuestCmd, data)
end

function ServiceQuestProxy:CallQueryManualQuestCmd(version, manual)
	local msg = SceneQuest_pb.QueryManualQuestCmd()
	if(version ~= nil )then
		msg.version = version
	end

	self:SendProto(msg)
end

