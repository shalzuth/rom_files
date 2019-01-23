autoImport('ServiceSceneBeingAutoProxy')
ServiceSceneBeingProxy = class('ServiceSceneBeingProxy', ServiceSceneBeingAutoProxy)
ServiceSceneBeingProxy.Instance = nil
ServiceSceneBeingProxy.NAME = 'ServiceSceneBeingProxy'

function ServiceSceneBeingProxy:ctor(proxyName)
	if ServiceSceneBeingProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSceneBeingProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceSceneBeingProxy.Instance = self
	end
end

function ServiceSceneBeingProxy:RecvBeingSkillQuery(data) 
	CreatureSkillProxy.Instance:RecieveServerDatas(data.data)
	-- self:Notify(ServiceEvent.SceneBeingBeingSkillQuery, data)
end

function ServiceSceneBeingProxy:RecvBeingSkillUpdate(data) 
	CreatureSkillProxy.Instance:RecieveServerDelDatas(data.del)
	CreatureSkillProxy.Instance:RecieveServerUpdateDatas(data.update)
	self:Notify(ServiceEvent.SceneBeingBeingSkillUpdate, data)
end

function ServiceSceneBeingProxy:RecvBeingInfoQuery(data) 
	helplog("Recv-->BeingInfoQuery");
	PetProxy.Instance:Server_SetMyBeingNpcInfos(data.beinginfo);
	self:Notify(ServiceEvent.SceneBeingBeingInfoQuery, data)
end

function ServiceSceneBeingProxy:RecvBeingInfoUpdate(data) 
	helplog("Recv-->BeingInfoUpdate");
	PetProxy.Instance:Server_UpdateMyBeingInfo(data.beingid, data.datas );
	self:Notify(ServiceEvent.SceneBeingBeingInfoUpdate, data)
end

function ServiceSceneBeingProxy:CallBeingSwitchState(beingid, battle)
	helplog("Call-->BeingSwitchState", beingid, battle);
	ServiceSceneBeingProxy.super.CallBeingSwitchState(self, beingid, battle);
end

function ServiceSceneBeingProxy:RecvBeingSwitchState(data) 
	helplog("Recv-->BeingSwitchState");
	self:Notify(ServiceEvent.SceneBeingBeingSwitchState, data)
end

function ServiceSceneBeingProxy:CallBeingOffCmd(beingid) 
	helplog("Call-->BeingOffCmd", beingid);
	ServiceSceneBeingProxy.super.CallBeingOffCmd(self, beingid);
end

function ServiceSceneBeingProxy:RecvBeingOffCmd(data) 
	helplog("Recv-->BeingOffCmd", data.beingid);
	PetProxy.Instance:Server_RemoveBeingInfoData(data.beingid);
	self:Notify(ServiceEvent.SceneBeingBeingOffCmd, data)
end

function ServiceSceneBeingProxy:CallChangeBodyBeingCmd(beingid, body) 
	helplog("Call-->ChangeBodyBeingCmd", beingid, body);
	ServiceSceneBeingProxy.super.CallChangeBodyBeingCmd(self, beingid, body);
end
