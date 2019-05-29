LogicManager_Npc_Userdata = class("LogicManager_Creature_Userdata", LogicManager_Creature_Userdata)
function LogicManager_Npc_Userdata:ctor()
  LogicManager_Npc_Userdata.super.ctor(self)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_ALPHA, self.SetAlpha)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_CHAIR, self.UpdateChair)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_ALPHA, self.UpdateAlpha)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_HAIR, self.SetChangeDressDirty)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_LEFTHAND, self.SetChangeDressDirty)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_RIGHTHAND, self.SetChangeDressDirty)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_HEAD, self.SetChangeDressDirty)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BACK, self.SetChangeDressDirty)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_CHAIR, self.UpdateChair)
end
function LogicManager_Npc_Userdata:SetAlpha(ncreature, userDataID, oldValue, newValue)
  local value = newValue / 1000
  ncreature:Server_SetAlpha(value)
end
function LogicManager_Npc_Userdata:UpdateAlpha(ncreature, userDataID, oldValue, newValue)
  local value = newValue / 1000
  ncreature:Server_SetAlpha(value)
end
function LogicManager_Npc_Userdata:SetChangeDressDirty(ncreature, userDataID, oldValue, newValue)
  self.changeDressDirty = true
  if newValue ~= 0 and ncreature ~= nil and ncreature.data ~= nil then
    ncreature.data:SetUseServerDressData(true)
  end
  if ncreature and ncreature.data and ncreature.data:IsPet() then
    GameFacade.Instance:sendNotification(PetCreatureEvent.PetChangeDress, ncreature)
  end
end
local superCheckDressDirty = LogicManager_Npc_Userdata.super.CheckDressDirty
function LogicManager_Npc_Userdata:CheckDressDirty(ncreature)
  if self.changeDressDirty and not self:CheckHasAnyDressData(ncreature) then
    ncreature.data:SetUseServerDressData(false)
  end
  superCheckDressDirty(self, ncreature)
end
function LogicManager_Npc_Userdata:UpdateChair(ncreature, userDataID, oldValue, newValue)
  if newValue == 0 then
    ncreature:Client_PlayAction(Asset_Role.ActionName.Idle, nil, true)
  else
    ncreature:Client_PlayAction(Asset_Role.ActionName.Sitdown, nil, true)
  end
end
