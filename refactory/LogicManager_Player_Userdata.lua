autoImport("LogicManager_Creature_Userdata")
LogicManager_Player_Userdata = class("LogicManager_Player_Userdata", LogicManager_Creature_Userdata)
local PVPTeam = RoleDefines.PVPTeam
local bodyUserdataID = 0
function LogicManager_Player_Userdata:ctor()
  LogicManager_Player_Userdata.super.ctor(self)
  bodyUserdataID = ProtoCommon_pb.EUSERDATATYPE_BODY
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_DEMAND, self.UpdateMusicDJ)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PVP_COLOR, self.SetPvpColor)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PEAK_EFFECT, self.UpdatePeakEffect)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_DRESSUP, self.UpdateOnStageHiding)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_PROFESSION, self.SetProfession)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_CHAIR, self.UpdateChair)
  self:AddSetCall(ProtoCommon_pb.EUSERDATATYPE_TRAIN, self.UpdateTrain)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_JOBLEVEL, self.UpdateJobLevel)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_JOBEXP, self.UpdateJobExpLevel)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PROFESSION, self.UpdateProfession)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_MUSIC_DEMAND, self.UpdateMusicDJ)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PVP_COLOR, self.UpdatePvpColor)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_PEAK_EFFECT, self.UpdatePeakEffect)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_DRESSUP, self.UpdateOnStageHiding)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_CHAIR, self.UpdateChair)
  self:AddUpdateCall(ProtoCommon_pb.EUSERDATATYPE_TRAIN, self.UpdateTrain)
end
function LogicManager_Player_Userdata:SetProfession(ncreature, userDataID, oldValue, newValue)
  ncreature:Logic_RideAction()
end
function LogicManager_Player_Userdata:UpdateRoleLevel(ncreature, userDataID, oldValue, newValue)
  LogicManager_Player_Userdata.super.UpdateRoleLevel(self, ncreature, userDataID, oldValue, newValue)
  GameFacade.Instance:sendNotification(SceneUserEvent.LevelUp, ncreature, SceneUserEvent.BaseLevelUp)
end
function LogicManager_Player_Userdata:UpdateJobLevel(ncreature, userDataID, oldValue, newValue)
  local occ = ncreature.data:GetCurOcc()
  if occ then
    occ:SetLevel(newValue)
  end
  GameFacade.Instance:sendNotification(SceneUserEvent.LevelUp, ncreature, SceneUserEvent.JobLevelUp)
end
function LogicManager_Player_Userdata:UpdateJobExpLevel(ncreature, userDataID, oldValue, newValue)
  local occ = ncreature.data:GetCurOcc()
  if occ then
    occ:SetExp(newValue)
  end
end
function LogicManager_Player_Userdata:SetChangeDressDirty(ncreature, userDataID, oldValue, newValue)
  self.changeDressDirty = true
  if userDataID == bodyUserdataID then
    ncreature:HandlerAssetRoleSuffixMap()
  end
  NSceneUserProxy.Instance:CheckUpdataUserData(oldValue, newValue)
end
function LogicManager_Player_Userdata:UpdateProfession(ncreature, userDataID, oldValue, newValue)
  ncreature.data:UpdateProfession()
  ncreature:HandlerAssetRoleSuffixMap()
  ncreature:Logic_RideAction()
  EventManager.Me():PassEvent(SceneUserEvent.ChangeProfession, ncreature)
  if ncreature == Game.Myself:GetLockTarget() then
    EventManager.Me():PassEvent(MyselfEvent.SelectTargetClassChange, ncreature)
  end
end
function LogicManager_Player_Userdata:UpdateMusicDJ(ncreature, userDataID, oldValue, newValue)
  if newValue == 1 then
    FunctionMusicBox.Me():AddDJPlayer(ncreature)
  elseif newValue == 0 then
    FunctionMusicBox.Me():RemoveDJPlayer(ncreature)
  end
end
function LogicManager_Player_Userdata:SetPvpColor(ncreature, userDataID, oldValue, newValue)
  ncreature:PlayTeamCircle(newValue)
end
function LogicManager_Player_Userdata:UpdatePvpColor(ncreature, userDataID, oldValue, newValue)
  ncreature:PlayTeamCircle(newValue)
end
function LogicManager_Player_Userdata:UpdatePeakEffect(ncreature, userDataID, oldValue, newValue)
  if newValue == 1 then
    ncreature:PlayPeakEffect()
  elseif newValue == 0 then
    ncreature:RemovePeakEffect()
  end
end
function LogicManager_Player_Userdata:UpdateOnStageHiding(ncreature, userDataID, oldValue, newValue)
  if newValue ~= 0 then
    FunctionStage.Me():AddPlayerOnStage(ncreature.data.id, ncreature, newValue)
  else
    FunctionStage.Me():RemovePlayerOnStage(ncreature.data.id)
  end
  EventManager.Me():PassEvent(CreatureEvent.Hiding_Change, ncreature.data.id)
end
function LogicManager_Player_Userdata:UpdateChair(ncreature, userDataID, oldValue, newValue)
  if newValue == 0 then
    ncreature:Server_GetOffSeat(newValue, true)
  else
    ncreature:Server_GetOnSeat(newValue, true)
  end
end
function LogicManager_Player_Userdata:UpdateTrain(ncreature, userDataID, oldValue, newValue)
  if newValue == 0 then
    ncreature:SetVisible(true, LayerChangeReason.InteractNpc)
    FunctionPlayerUI.Me():UnMaskAllUI(ncreature, PUIVisibleReason.InteractNpc)
  else
    ncreature:SetVisible(false, LayerChangeReason.InteractNpc)
    FunctionPlayerUI.Me():MaskAllUI(ncreature, PUIVisibleReason.InteractNpc)
  end
end
