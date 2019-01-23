autoImport('ServiceScenePetAutoProxy')
ServiceScenePetProxy = class('ServiceScenePetProxy', ServiceScenePetAutoProxy)
ServiceScenePetProxy.Instance = nil
ServiceScenePetProxy.NAME = 'ServiceScenePetProxy'

function ServiceScenePetProxy:ctor(proxyName)
	if ServiceScenePetProxy.Instance == nil then
		self.proxyName = proxyName or ServiceScenePetProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceScenePetProxy.Instance = self
	end
end

function ServiceScenePetProxy:CallFireCatPetCmd(catid)
	helplog("Call-->FireCatPetCmd", catid);
	ServiceScenePetProxy.super.CallFireCatPetCmd(self, catid);
end


function ServiceScenePetProxy:CallCatchPetGiftPetCmd(npcguid) 
	helplog("Call-->CatchPetGiftPetCmd", npcguid);
	ServiceScenePetProxy.super.CallCatchPetGiftPetCmd(self, npcguid);
end

function ServiceScenePetProxy:CallCatchPetPetCmd(npcguid, isstop) 
	helplog("Call-->CatchPetPetCmd", npcguid, isstop);
	ServiceScenePetProxy.super.CallCatchPetPetCmd(self, npcguid, isstop);
end

function ServiceScenePetProxy:CallQueryPetAdventureListPetCmd()
	helplog("Call-->请求冒险任务数据");
	ServiceScenePetProxy.super.CallQueryPetAdventureListPetCmd(self)
end

function ServiceScenePetProxy:CallQueryBattlePetCmd()
	helplog("请求出战宠物数据")
	ServiceScenePetProxy.super.CallQueryBattlePetCmd(self)
end

function ServiceScenePetProxy:CallStartAdventurePetCmd(id, petids,specid)
	helplog("Call-->请求开始宠物冒险id ",tostring(id))
	for i=1,#petids do
		helplog("请求宠物冒险的宠物列表 guid： ",petids[i])
	end
	ServiceScenePetProxy.super.CallStartAdventurePetCmd(self,id,petids,specid)
end

function ServiceScenePetProxy:CallGetAdventureRewardPetCmd(id)
	helplog("Call-->请求领奖-（宠物冒险）");
	ServiceScenePetProxy.super.CallGetAdventureRewardPetCmd(self,id)
end

function ServiceScenePetProxy:RecvPetAdventureResultNtfPetCmd(data)
	PetAdventureProxy.Instance:HandleQuestResultData(data.item)
	self:Notify(ServiceEvent.ScenePetPetAdventureResultNtfPetCmd, data)
end

function ServiceScenePetProxy:RecvQueryPetAdventureListPetCmd(data)
	helplog("Recv-->Recv接收到宠物冒险任务消息");
	PetAdventureProxy.Instance:SetQuestData(data.items)
	self:Notify(ServiceEvent.ScenePetQueryPetAdventureListPetCmd, data)
end

function ServiceScenePetProxy:RecvCatchValuePetCmd( data )
	helplog("Recv-->CatchValuePetCmd", data.npcguid, data.value, data.from_npcid);
	FunctionPet.Me():CatchValueChange(data.npcguid, data.value, data.from_npcid);
	self:Notify(ServiceEvent.ScenePetCatchValuePetCmd, data)
end

function ServiceScenePetProxy:RecvCatchResultPetCmd(data) 
	helplog("Recv-->CatchResultPetCmd", data.npcguid, data.success);
	FunctionPet.Me():CatchResult(data.npcguid, data.success)
	self:Notify(ServiceEvent.ScenePetCatchResultPetCmd, data)
end

function ServiceScenePetProxy:RecvPetInfoPetCmd(data) 
	helplog("Recv-->PetInfoPetCmd", #data.petinfo);
	PetProxy.Instance:Server_UpdateMyPetInfos(data.petinfo);
	self:Notify(ServiceEvent.ScenePetPetInfoPetCmd, data)
end

function ServiceScenePetProxy:RecvPetInfoUpdatePetCmd(data) 
	-- helplog("Recv-->PetInfoUpdatePetCmd", data.petid);
	PetProxy.Instance:Server_PetInfoUpdate(data.petid, data.datas);
	self:Notify(ServiceEvent.ScenePetPetInfoUpdatePetCmd, data)
end

function ServiceScenePetProxy:CallEggHatchPetCmd(name, guid) 
	helplog("Call-->EggHatchPetCmd", tostring(name), tostring(guid));
	ServiceScenePetProxy.super.CallEggHatchPetCmd(self, name, guid) 
end

function ServiceScenePetProxy:RecvPetOffPetCmd(data) 
	helplog("Recv-->PetOffPetCmd", tostring(data.petid));
	PetProxy.Instance:Server_RemovePetInfoData(data.petid)
	self:Notify(ServiceEvent.ScenePetPetOffPetCmd, data)
end

function ServiceScenePetProxy:RecvEquipUpdatePetCmd(data) 
	helplog("Recv-->EquipUpdatePetCmd", tostring(data.petid), tostring(data.update), data.del);
	PetProxy.Instance:Server_UpdatePetEquip(data.petid, data.update, data.del)
	self:Notify(ServiceEvent.ScenePetEquipUpdatePetCmd, data)
end

function ServiceScenePetProxy:CallGiveGiftPetCmd(petid, itemguid) 
	helplog("Call-->GiveGiftPetCmd", petid, itemguid);
	ServiceScenePetProxy.super.CallGiveGiftPetCmd(self, petid, itemguid);
end

function ServiceScenePetProxy:RecvGiveGiftPetCmd(data) 
	helplog("Recv-->GiveGiftPetCmd");
	self:Notify(ServiceEvent.ScenePetGiveGiftPetCmd, data)
end

function ServiceScenePetProxy:CallEquipOperPetCmd(oper, petid, guid) 
	helplog("Call-->EquipOperPetCmd", oper, petid, guid);
	ServiceScenePetProxy.super.CallEquipOperPetCmd(self, oper, petid, guid);
end

function ServiceScenePetProxy:RecvUnlockNtfPetCmd(data) 
	helplog("Recv-->UnlockNtfPetCmd", tostring(data.petid), tostring(data.equipids[1]), data.bodys[1]);
 	PetProxy.Instance:Server_UpdateUnlockInfo(data.petid, data.equipids ,data.bodys);
	self:Notify(ServiceEvent.ScenePetUnlockNtfPetCmd, data)
end

function ServiceScenePetProxy:CallEggRestorePetCmd(petid) 
	helplog("Call-->EggRestorePetCmd", petid);
	ServiceScenePetProxy.super.CallEggRestorePetCmd(self, petid);
end

function ServiceScenePetProxy:CallGetGiftPetCmd(petid) 
	helplog("Call-->GetGiftPetCmd", petid);
	ServiceScenePetProxy.super.CallGetGiftPetCmd(self, petid);
end

function ServiceScenePetProxy:CallResetSkillPetCmd(id) 
	helplog("Call-->ResetSkillPetCmd", id);
	ServiceScenePetProxy.super.CallResetSkillPetCmd(self, id);
end

function ServiceScenePetProxy:CallQueryGotItemPetCmd(items) 
	helplog("Call-->QueryGotItemPetCmd");
	ServiceScenePetProxy.super.CallGetGiftPetCmd(self, petid);
end

function ServiceScenePetProxy:RecvQueryGotItemPetCmd(data) 
	self:Notify(ServiceEvent.ScenePetQueryGotItemPetCmd, data)
end

function ServiceScenePetProxy:RecvQueryPetWorkManualPetCmd(data)
	PetWorkSpaceProxy.Instance:SetPetSpaceFuncUnlock(data.manual)
	self:Notify(ServiceEvent.ScenePetQueryPetWorkManualPetCmd, data)
end

function ServiceScenePetProxy:RecvQueryPetWorkDataPetCmd(data)
	helplog("Recv-->RecvQueryPetWorkDataPetCmd");
	PetWorkSpaceProxy.Instance:SetPetWorkData(data.datas)
	PetWorkSpaceProxy.Instance:SetExtra(data)
	self:Notify(ServiceEvent.ScenePetQueryPetWorkDataPetCmd, data)
end

function ServiceScenePetProxy:RecvWorkSpaceUpdate(data)
	helplog("Recv-->RecvWorkSpaceUpdate");
	PetWorkSpaceProxy.Instance:SetPetWorkData(data.updates)
	self:Notify(ServiceEvent.ScenePetWorkSpaceUpdate, data)
end

function ServiceScenePetProxy:RecvPetExtraUpdatePetCmd(data)
	PetWorkSpaceProxy.Instance:SetExchangeMap(data.updates)
	self:Notify(ServiceEvent.ScenePetPetExtraUpdatePetCmd, data)
end

