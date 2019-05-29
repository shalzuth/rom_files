autoImport("ServiceScenePetAutoProxy")
ServiceScenePetProxy = class("ServiceScenePetProxy", ServiceScenePetAutoProxy)
ServiceScenePetProxy.Instance = nil
ServiceScenePetProxy.NAME = "ServiceScenePetProxy"
function ServiceScenePetProxy:ctor(proxyName)
  if ServiceScenePetProxy.Instance == nil then
    self.proxyName = proxyName or ServiceScenePetProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceScenePetProxy.Instance = self
  end
end
function ServiceScenePetProxy:CallFireCatPetCmd(catid)
  helplog("Call-->FireCatPetCmd", catid)
  ServiceScenePetProxy.super.CallFireCatPetCmd(self, catid)
end
function ServiceScenePetProxy:CallCatchPetGiftPetCmd(npcguid)
  helplog("Call-->CatchPetGiftPetCmd", npcguid)
  ServiceScenePetProxy.super.CallCatchPetGiftPetCmd(self, npcguid)
end
function ServiceScenePetProxy:CallCatchPetPetCmd(npcguid, isstop)
  helplog("Call-->CatchPetPetCmd", npcguid, isstop)
  ServiceScenePetProxy.super.CallCatchPetPetCmd(self, npcguid, isstop)
end
function ServiceScenePetProxy:CallQueryPetAdventureListPetCmd()
  helplog("Call-->\232\175\183\230\177\130\229\134\146\233\153\169\228\187\187\229\138\161\230\149\176\230\141\174")
  ServiceScenePetProxy.super.CallQueryPetAdventureListPetCmd(self)
end
function ServiceScenePetProxy:CallQueryBattlePetCmd()
  helplog("\232\175\183\230\177\130\229\135\186\230\136\152\229\174\160\231\137\169\230\149\176\230\141\174")
  ServiceScenePetProxy.super.CallQueryBattlePetCmd(self)
end
function ServiceScenePetProxy:CallStartAdventurePetCmd(id, petids, specid)
  helplog("Call-->\232\175\183\230\177\130\229\188\128\229\167\139\229\174\160\231\137\169\229\134\146\233\153\169id ", tostring(id))
  for i = 1, #petids do
    helplog("\232\175\183\230\177\130\229\174\160\231\137\169\229\134\146\233\153\169\231\154\132\229\174\160\231\137\169\229\136\151\232\161\168 guid\239\188\154 ", petids[i])
  end
  ServiceScenePetProxy.super.CallStartAdventurePetCmd(self, id, petids, specid)
end
function ServiceScenePetProxy:CallGetAdventureRewardPetCmd(id)
  helplog("Call-->\232\175\183\230\177\130\233\162\134\229\165\150-\239\188\136\229\174\160\231\137\169\229\134\146\233\153\169\239\188\137")
  ServiceScenePetProxy.super.CallGetAdventureRewardPetCmd(self, id)
end
function ServiceScenePetProxy:RecvPetAdventureResultNtfPetCmd(data)
  PetAdventureProxy.Instance:HandleQuestResultData(data.item)
  self:Notify(ServiceEvent.ScenePetPetAdventureResultNtfPetCmd, data)
end
function ServiceScenePetProxy:RecvQueryPetAdventureListPetCmd(data)
  helplog("Recv-->Recv\230\142\165\230\148\182\229\136\176\229\174\160\231\137\169\229\134\146\233\153\169\228\187\187\229\138\161\230\182\136\230\129\175")
  PetAdventureProxy.Instance:SetQuestData(data.items)
  self:Notify(ServiceEvent.ScenePetQueryPetAdventureListPetCmd, data)
end
function ServiceScenePetProxy:RecvCatchValuePetCmd(data)
  helplog("Recv-->CatchValuePetCmd", data.npcguid, data.value, data.from_npcid)
  FunctionPet.Me():CatchValueChange(data.npcguid, data.value, data.from_npcid)
  self:Notify(ServiceEvent.ScenePetCatchValuePetCmd, data)
end
function ServiceScenePetProxy:RecvCatchResultPetCmd(data)
  helplog("Recv-->CatchResultPetCmd", data.npcguid, data.success)
  FunctionPet.Me():CatchResult(data.npcguid, data.success)
  self:Notify(ServiceEvent.ScenePetCatchResultPetCmd, data)
end
function ServiceScenePetProxy:RecvPetInfoPetCmd(data)
  helplog("Recv-->PetInfoPetCmd", #data.petinfo)
  PetProxy.Instance:Server_UpdateMyPetInfos(data.petinfo)
  self:Notify(ServiceEvent.ScenePetPetInfoPetCmd, data)
end
function ServiceScenePetProxy:RecvPetInfoUpdatePetCmd(data)
  PetProxy.Instance:Server_PetInfoUpdate(data.petid, data.datas)
  self:Notify(ServiceEvent.ScenePetPetInfoUpdatePetCmd, data)
end
function ServiceScenePetProxy:CallEggHatchPetCmd(name, guid)
  helplog("Call-->EggHatchPetCmd", tostring(name), tostring(guid))
  ServiceScenePetProxy.super.CallEggHatchPetCmd(self, name, guid)
end
function ServiceScenePetProxy:RecvPetOffPetCmd(data)
  helplog("Recv-->PetOffPetCmd", tostring(data.petid))
  PetProxy.Instance:Server_RemovePetInfoData(data.petid)
  self:Notify(ServiceEvent.ScenePetPetOffPetCmd, data)
end
function ServiceScenePetProxy:RecvEquipUpdatePetCmd(data)
  helplog("Recv-->EquipUpdatePetCmd", tostring(data.petid), tostring(data.update), data.del)
  PetProxy.Instance:Server_UpdatePetEquip(data.petid, data.update, data.del)
  self:Notify(ServiceEvent.ScenePetEquipUpdatePetCmd, data)
end
function ServiceScenePetProxy:CallGiveGiftPetCmd(petid, itemguid)
  helplog("Call-->GiveGiftPetCmd", petid, itemguid)
  ServiceScenePetProxy.super.CallGiveGiftPetCmd(self, petid, itemguid)
end
function ServiceScenePetProxy:RecvGiveGiftPetCmd(data)
  helplog("Recv-->GiveGiftPetCmd")
  self:Notify(ServiceEvent.ScenePetGiveGiftPetCmd, data)
end
function ServiceScenePetProxy:CallEquipOperPetCmd(oper, petid, guid)
  helplog("Call-->EquipOperPetCmd", oper, petid, guid)
  ServiceScenePetProxy.super.CallEquipOperPetCmd(self, oper, petid, guid)
end
function ServiceScenePetProxy:RecvUnlockNtfPetCmd(data)
  helplog("Recv-->UnlockNtfPetCmd", tostring(data.petid), tostring(data.equipids[1]), data.bodys[1])
  PetProxy.Instance:Server_UpdateUnlockInfo(data.petid, data.equipids, data.bodys)
  self:Notify(ServiceEvent.ScenePetUnlockNtfPetCmd, data)
end
function ServiceScenePetProxy:CallEggRestorePetCmd(petid)
  helplog("Call-->EggRestorePetCmd", petid)
  ServiceScenePetProxy.super.CallEggRestorePetCmd(self, petid)
end
function ServiceScenePetProxy:CallGetGiftPetCmd(petid)
  helplog("Call-->GetGiftPetCmd", petid)
  ServiceScenePetProxy.super.CallGetGiftPetCmd(self, petid)
end
function ServiceScenePetProxy:CallResetSkillPetCmd(id)
  helplog("Call-->ResetSkillPetCmd", id)
  ServiceScenePetProxy.super.CallResetSkillPetCmd(self, id)
end
function ServiceScenePetProxy:CallQueryGotItemPetCmd(items)
  helplog("Call-->QueryGotItemPetCmd")
  ServiceScenePetProxy.super.CallGetGiftPetCmd(self, petid)
end
function ServiceScenePetProxy:RecvQueryGotItemPetCmd(data)
  self:Notify(ServiceEvent.ScenePetQueryGotItemPetCmd, data)
end
function ServiceScenePetProxy:RecvQueryPetWorkManualPetCmd(data)
  PetWorkSpaceProxy.Instance:SetPetSpaceFuncUnlock(data.manual)
  self:Notify(ServiceEvent.ScenePetQueryPetWorkManualPetCmd, data)
end
function ServiceScenePetProxy:RecvQueryPetWorkDataPetCmd(data)
  helplog("Recv-->RecvQueryPetWorkDataPetCmd")
  PetWorkSpaceProxy.Instance:SetPetWorkData(data.datas)
  PetWorkSpaceProxy.Instance:SetExtra(data)
  self:Notify(ServiceEvent.ScenePetQueryPetWorkDataPetCmd, data)
end
function ServiceScenePetProxy:RecvWorkSpaceUpdate(data)
  helplog("Recv-->RecvWorkSpaceUpdate")
  PetWorkSpaceProxy.Instance:SetPetWorkData(data.updates)
  self:Notify(ServiceEvent.ScenePetWorkSpaceUpdate, data)
end
function ServiceScenePetProxy:RecvPetExtraUpdatePetCmd(data)
  PetWorkSpaceProxy.Instance:SetExchangeMap(data.updates)
  self:Notify(ServiceEvent.ScenePetPetExtraUpdatePetCmd, data)
end
function ServiceScenePetProxy:RecvPetEquipListCmd(data)
  PetComposeProxy.Instance:InitPetEquipList(data.unlockinfo)
  self:Notify(ServiceEvent.ScenePetPetEquipListCmd, data)
end
function ServiceScenePetProxy:RecvUpdatePetEquipListCmd(data)
  PetComposeProxy.Instance:UpdatePetEquipList(data)
  self:Notify(ServiceEvent.ScenePetUpdatePetEquipListCmd, data)
end
function ServiceScenePetProxy:RecvUpdateWearPetCmd(data)
  self:Notify(ServiceEvent.ScenePetUpdateWearPetCmd, data)
end
