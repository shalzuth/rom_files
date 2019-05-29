LogicManager_Creature_Userdata = class("LogicManager_Creature_Userdata")
local ChangeDressData = {
  ProtoCommon_pb.EUSERDATATYPE_FACE,
  ProtoCommon_pb.EUSERDATATYPE_HAIR,
  ProtoCommon_pb.EUSERDATATYPE_BACK,
  ProtoCommon_pb.EUSERDATATYPE_TAIL,
  ProtoCommon_pb.EUSERDATATYPE_LEFTHAND,
  ProtoCommon_pb.EUSERDATATYPE_RIGHTHAND,
  ProtoCommon_pb.EUSERDATATYPE_BODY,
  ProtoCommon_pb.EUSERDATATYPE_HEAD,
  ProtoCommon_pb.EUSERDATATYPE_EYE,
  ProtoCommon_pb.EUSERDATATYPE_MOUNT,
  ProtoCommon_pb.EUSERDATATYPE_MOUTH,
  ProtoCommon_pb.EUSERDATATYPE_HAIRCOLOR,
  ProtoCommon_pb.EUSERDATATYPE_CLOTHCOLOR,
  ProtoCommon_pb.EUSERDATATYPE_TAIL
}
function LogicManager_Creature_Userdata:ctor()
  self.dirtyCalls = {}
  self.updateCalls = {}
  self.setCalls = {}
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_DIR, self.SetDir)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_BODYSCALE, self.SetScale)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_STATUS, self.SetStatus)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_NORMAL_SKILL, self.SetNormalSkill)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_ROLELEVEL, self.SetRoleLevel)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PET_PARTNER, self.SetPartner)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_SHADERCOLOR, self.SetShaderColorChange)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_DIR, self.UpdateDir)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_NAME, self.UpdateName)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_BODYSCALE, self.UpdateScale)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_STATUS, self.UpdateStatus)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_NORMAL_SKILL, self.SetNormalSkill)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_ROLELEVEL, self.UpdateRoleLevel)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PET_PARTNER, self.UpdatePartner)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_SHADERCOLOR, self.UpdateShaderColorChange)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_HANDID, self.UpdateHandId)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_TWINS_ACTIONID or 124, self.UpdateTwinsActionId)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_COOKER_LV, self.UpdateCooklv)
  for i = 1, #ChangeDressData do
    self:AddDirtyCall(ChangeDressData[i], self.SetChangeDressDirty)
  end
end
function LogicManager_Creature_Userdata:IsDirty(id)
  return self.dirtyCalls[id] ~= nil
end
function LogicManager_Creature_Userdata:AddDirtyCall(id, func)
  self.dirtyCalls[id] = func
end
function LogicManager_Creature_Userdata:AddUpdateCall(id, func)
  self.updateCalls[id] = func
end
function LogicManager_Creature_Userdata:AddSetCall(id, func)
  self.setCalls[id] = func
end
function LogicManager_Creature_Userdata:RemoveDirtyCall(id)
  self.dirtyCalls[id] = nil
end
function LogicManager_Creature_Userdata:RemoveUpdateCall(id)
  self.updateCalls[id] = nil
end
function LogicManager_Creature_Userdata:RemoveSetCall(id)
  self.setCalls[id] = nil
end
function LogicManager_Creature_Userdata:CheckDirtyDatas(ncreature)
  local userDatas = ncreature.data.userdata
  local call
  if userDatas and userDatas.hasDirtyDatas then
    for k, v in pairs(userDatas.dirtyIDs) do
      call = self.dirtyCalls[k]
      if call ~= nil then
        call(self, ncreature, k, v, userDatas:GetById(k))
      end
      userDatas.dirtyIDs[k] = nil
    end
    userDatas.hasDirtyDatas = false
  end
  self:CheckDressDirty(ncreature)
end
function LogicManager_Creature_Userdata:CheckDressDirty(ncreature)
  if self.changeDressDirty then
    self.changeDressDirty = false
    ncreature:ReDress()
  end
end
function LogicManager_Creature_Userdata:CheckHasAnyDressData(ncreature)
  if ncreature ~= nil and ncreature.data ~= nil then
    local userDatas = ncreature.data.userdata
    if userDatas then
      local v
      for i = 1, #ChangeDressData do
        v = userDatas:GetById(ChangeDressData[i])
        if v ~= nil and v ~= 0 then
          return true
        end
      end
    end
  end
  return false
end
function LogicManager_Creature_Userdata:SetChangeDressDirty(ncreature, userDataID, oldValue, newValue)
  self.changeDressDirty = true
end
function LogicManager_Creature_Userdata:CheckUpdateDataCall(ncreature, userDataID, oldValue, newValue)
  local call = self.updateCalls[userDataID]
  if call then
    call(self, ncreature, userDataID, oldValue, newValue)
  end
end
function LogicManager_Creature_Userdata:CheckSetDataCall(ncreature, userDataID, oldValue, newValue)
  local call = self.setCalls[userDataID]
  if call then
    call(self, ncreature, userDataID, oldValue, newValue)
  end
end
function LogicManager_Creature_Userdata:SetDir(ncreature, userDataID, oldValue, newValue)
  ncreature:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, newValue / 1000, true)
end
function LogicManager_Creature_Userdata:UpdateDir(ncreature, userDataID, oldValue, newValue)
  ncreature:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, newValue / 1000)
end
function LogicManager_Creature_Userdata:SetScale(ncreature, userDataID, oldValue, newValue)
  ncreature:Server_SetScaleCmd(newValue / 100, true)
end
function LogicManager_Creature_Userdata:UpdateScale(ncreature, userDataID, oldValue, newValue)
  ncreature:Server_SetScaleCmd(newValue / 100)
end
function LogicManager_Creature_Userdata:SetStatus(ncreature, userDataID, oldValue, newValue)
  self:_RefreshStatus(ncreature, newValue, true)
end
function LogicManager_Creature_Userdata:UpdateStatus(ncreature, userDataID, oldValue, newValue)
  self:_RefreshStatus(ncreature, newValue, false, oldValue)
end
function LogicManager_Creature_Userdata:SetRoleLevel(ncreature, userDataID, oldValue, newValue)
  ncreature.data:SetBaseLv(newValue)
end
function LogicManager_Creature_Userdata:UpdateRoleLevel(ncreature, userDataID, oldValue, newValue)
  ncreature.data:SetBaseLv(newValue)
end
function LogicManager_Creature_Userdata:SetPartner(ncreature, userDataID, oldValue, newValue)
  ncreature:SetPartner(newValue)
  GameFacade.Instance:sendNotification(ServiceEvent.UpdatePetPartner, ncreature)
end
function LogicManager_Creature_Userdata:UpdatePartner(ncreature, userDataID, oldValue, newValue)
  ncreature:SetPartner(newValue)
  GameFacade.Instance:sendNotification(ServiceEvent.UpdatePetPartner, ncreature)
end
function LogicManager_Creature_Userdata:UpdateName(ncreature, userDataID, oldValue, newValue)
  ncreature.data.name = ncreature.data.userdata:GetBytes(UDEnum.NAME)
  GameFacade.Instance:sendNotification(CreatureEvent.Name_Change, ncreature)
end
function LogicManager_Creature_Userdata:_RefreshStatus(ncreature, value, isSet, oldValue)
  if value == ProtoCommon_pb.ECREATURESTATUS_DEAD then
    self:_Die(ncreature, isSet)
    if ncreature:GetCreatureType() == Creature_Type.Me then
      GameFacade.Instance:sendNotification(MainViewEvent.ShowOrHide, false)
      GameFacade.Instance:sendNotification(MyselfEvent.DeathStatus)
    elseif ncreature:GetCreatureType() == Creature_Type.Player then
      GameFacade.Instance:sendNotification(PlayerEvent.DeathStatusChange, ncreature)
    end
  elseif value == ProtoCommon_pb.ECREATURESTATUS_LIVE then
    if ncreature:GetCreatureType() == Creature_Type.Me then
      GameFacade.Instance:sendNotification(MainViewEvent.ShowOrHide, true)
      GameFacade.Instance:sendNotification(MyselfEvent.ReliveStatus)
    elseif ncreature:GetCreatureType() == Creature_Type.Player then
      GameFacade.Instance:sendNotification(PlayerEvent.DeathStatusChange, ncreature)
    end
    self:_Revive(ncreature, oldValue)
  elseif value == ProtoCommon_pb.ECREATURESTATUS_PHOTO and ncreature:GetCreatureType() ~= Creature_Type.Me then
  elseif value == ProtoCommon_pb.ECREATURESTATUS_FAKEDEAD then
    self:_FakeDie(ncreature)
  elseif value == ProtoCommon_pb.ECREATURESTATUS_INRELIVE and ncreature:GetCreatureType() == Creature_Type.Player then
    GameFacade.Instance:sendNotification(PlayerEvent.DeathStatusChange, ncreature)
  end
end
function LogicManager_Creature_Userdata:_FakeDie(ncreature)
  FunctionSystem.InterruptCreature(ncreature)
  ncreature:Server_PlayActionCmd(Asset_Role.ActionName.Die, 1, false, true)
end
function LogicManager_Creature_Userdata:_Die(ncreature, isSet)
  ncreature:Server_DieCmd(isSet)
end
function LogicManager_Creature_Userdata:_Revive(ncreature, oldValue)
  ncreature:Server_ReviveCmd()
end
function LogicManager_Creature_Userdata:SetNormalSkill(ncreature, userDataID, oldValue, newValue)
  ncreature.data.normalAtkID = newValue
end
function LogicManager_Creature_Userdata:SetShaderColorChange(ncreature, userDataID, oldValue, newValue)
end
function LogicManager_Creature_Userdata:UpdateShaderColorChange(ncreature, userDataID, oldValue, newValue)
end
function LogicManager_Creature_Userdata:UpdateHandId(ncreature, userDataID, oldValue, newValue)
  if newValue then
    ncreature:Server_SetHandInHand(newValue, newValue ~= 0)
  end
end
function LogicManager_Creature_Userdata:UpdateTwinsActionId(ncreature, userDataID, oldValue, newValue)
  if newValue then
    ncreature:Server_SetTwinsActionId(newValue, oldValue)
    if oldValue ~= 0 and newValue == 0 then
      ncreature:Server_SetDoubleAction(0, false)
    end
  end
end
function LogicManager_Creature_Userdata:UpdateCooklv(ncreature, userDataID, oldValue, newValue)
  if oldValue < newValue then
  end
end
