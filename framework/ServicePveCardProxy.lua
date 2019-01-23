autoImport('ServicePveCardAutoProxy')
ServicePveCardProxy = class('ServicePveCardProxy', ServicePveCardAutoProxy)
ServicePveCardProxy.Instance = nil
ServicePveCardProxy.NAME = 'ServicePveCardProxy'

function ServicePveCardProxy:ctor(proxyName)
	if ServicePveCardProxy.Instance == nil then
		self.proxyName = proxyName or ServicePveCardProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServicePveCardProxy.Instance = self
	end
end

function ServicePveCardProxy:CallQueryCardInfoCmd(cards) 
	helplog("Call-->QueryCardInfoCmd");
	ServicePveCardProxy.super.CallQueryCardInfoCmd(self);
end

function ServicePveCardProxy:RecvQueryCardInfoCmd(data) 
	helplog("Recv-->QueryCardInfoCmd");
	DungeonProxy.Instance:ReSetCardDatas(data.cards);
	self:Notify(ServiceEvent.PveCardQueryCardInfoCmd, data)
end

function ServicePveCardProxy:RecvSyncProcessPveCardCmd(data) 
	helplog("Recv-->SyncProcessPveCardCmd");
	DungeonProxy.Instance:SyncProcessPveCard(data.card.index, data.card.cardids, data.process);
	self:Notify(ServiceEvent.PveCardSyncProcessPveCardCmd, data)
end

function ServicePveCardProxy:RecvUpdateProcessPveCardCmd(data) 
	helplog("Recv-->UpdateProcessPveCardCmd");
	DungeonProxy.Instance:UpdateProcessPveCard(data.process);
	self:Notify(ServiceEvent.PveCardUpdateProcessPveCardCmd, data)
	EventManager.Me():PassEvent(ServiceEvent.PveCardUpdateProcessPveCardCmd);
	-- self:Notify(ServiceEvent.PveCardUpdateProcessPveCardCmd)
end

function ServicePveCardProxy:CallSelectPveCardCmd(index) 
	helplog("Call->SelectPveCardCmd", index);
	ServicePveCardProxy.super.CallSelectPveCardCmd(self, index);
end

function ServicePveCardProxy:CallEnterPveCardCmd(configid) 
	helplog("Call->EnterPveCardCmd", configid);
	ServicePveCardProxy.super.CallEnterPveCardCmd(self, configid);
end

function ServicePveCardProxy:RecvFinishPlayCardCmd(data) 
	helplog("Recv-->FinishPlayCardCmd");
	DungeonProxy.Instance:UpdateProcessPveCard(0);
	self:Notify(ServiceEvent.PveCardFinishPlayCardCmd, data)
end