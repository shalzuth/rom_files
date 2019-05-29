autoImport("CreatureVisibleHandler")
autoImport("ClientProps")
NCreature = class("NCreature", ReusableObject)
autoImport("NCreature_Effect")
autoImport("NCreature_Client")
autoImport("NCreature_Logic")
local table_ActionAnime = Table_ActionAnime
local config_Action
local DressDelayScale = 1
local fixHeightScale = {0.9, 1.1}
local fixWeightScale = {0.9, 1.1}
HandInActionType = {
  Clear = 0,
  HandIn = 1,
  InHand = 2,
  Hold = 3,
  BeHolded = 4,
  DoubleAction = 5
}
function NCreature:ctor(aiClass)
  NCreature.super.ctor(self)
  config_Action = Game.Config_Action
  self.data = nil
  self.assetRole = nil
  self.logicTransform = Logic_Transform.new()
  aiClass = aiClass or AI_Creature
  self.ai = aiClass.new()
  self.originalScale = nil
  self.isCullingRegisted = false
end
function NCreature:GetDressPriority()
  return LogicManager_RoleDress.Priority.Normal
end
function NCreature:IsMoving()
  return nil ~= self.logicTransform.targetPosition
end
function NCreature:IsExtraMoving()
  return 0 < #self.logicTransform.extraLogics
end
function NCreature:SetDressEnable(v)
  if self.data and v ~= self.data.dressEnable then
    self.data:SetDressEnable(v)
    self:ReDress()
    if self.partner then
      self.partner:SetDressEnable(v)
    end
    if self.handNpc then
      local npc = self:GetHandNpc()
      if npc then
        npc:SetDressEnable(v)
      end
    end
    if self.expressNpcMap then
      for key, value in pairs(self.expressNpcMap) do
        local npc = self:GetExpressNpc(key)
        if npc then
          npc:SetDressEnable(v)
        end
      end
    end
    if self.stageNpc then
      local npc = self:GetStageNpc()
      if npc then
        npc:SetDressEnable(v)
      end
    end
    if self.customSeat then
      self.customSeat:SetVisible(self, v)
    end
    NScenePetProxy.Instance:SetOwnerDressEnable(self, v)
  end
end
function NCreature:IsDressEnable()
  if self.data then
    return self.data:IsDressEnable()
  end
  return true
end
function NCreature:IsDressed()
  return self.dressed
end
function NCreature:IsPhotoStatus()
  return false
end
function NCreature:IsOnSceneSeat()
  return nil ~= Game.SceneSeatManager:GetCreatureSeat(self)
end
function NCreature:GetCreatureType()
  return nil
end
function NCreature:IsHandInHand()
  return false, nil
end
function NCreature:MaskUI(reason, uiType)
  if self.sceneui then
    self.sceneui:MaskUI(reason, uiType)
  end
  if self.handNpc then
    local npc = self:GetHandNpc()
    if npc then
      npc:MaskUI(reason, uiType)
    end
  end
  if self.expressNpcMap then
    for k, v in pairs(self.expressNpcMap) do
      local npc = self:GetExpressNpc(k)
      if npc then
        npc:MaskUI(reason, uiType)
      end
    end
  end
end
function NCreature:UnMaskUI(reason, uiType)
  if self.sceneui then
    self.sceneui:UnMaskUI(reason, uiType)
  end
  if self.handNpc then
    local npc = self:GetHandNpc()
    if npc then
      npc:UnMaskUI(reason, uiType)
    end
  end
  if self.expressNpcMap then
    for k, v in pairs(self.expressNpcMap) do
      local npc = self:GetExpressNpc(k)
      if npc then
        npc:UnMaskUI(reason, uiType)
      end
    end
  end
end
function NCreature:HandleSettingMask()
  if self.sceneui and self.sceneui.roleBottomUI then
    self.sceneui.roleBottomUI:HandleSettingMask(self)
  end
  if self.data.petIDs and #self.data.petIDs > 0 then
    for i = 1, #self.data.petIDs do
      local guid = self.data.petIDs[i]
      local creature = NScenePetProxy.Instance:Find(guid)
      if creature and creature.sceneui and creature.sceneui.roleBottomUI then
        creature.sceneui.roleBottomUI:HandleSettingMask(creature)
      end
    end
  end
  if self.handNpc then
    local npc = self:GetHandNpc()
    if npc then
      npc:HandleSettingMask()
    end
  end
  if self.expressNpcMap then
    for k, v in pairs(self.expressNpcMap) do
      local npc = self:GetExpressNpc(k)
      if npc then
        npc:HandleSettingMask()
      end
    end
  end
end
function NCreature:HandIn()
  if self:IsPlayingDoubleAction() then
    return
  end
  self:_SetHandInHandAction(HandInActionType.HandIn)
end
function NCreature:InHand()
  self:_SetHandInHandAction(HandInActionType.InHand)
end
function NCreature:ClearHandInHand()
  self:_SetHandInHandAction(HandInActionType.Clear)
end
function NCreature:IsPlayingHandInIdleAction()
  if 1 ~= self.handInHandAction then
    return false
  end
  return self.assetRole:IsPlayingActionRaw(self:GetIdleAction())
end
function NCreature:IsPlayingHandInMoveAction()
  if 1 ~= self.handInHandAction then
    return false
  end
  return self.assetRole:IsPlayingActionRaw(self:GetMoveAction())
end
function NCreature:IsPlayingHandInAction()
  if 1 ~= self.handInHandAction then
    return false
  end
  return self.assetRole:IsPlayingActionRaw(self:GetIdleAction()) or self.assetRole:IsPlayingActionRaw(self:GetMoveAction())
end
function NCreature:IsPlayingInHandIdleAction()
  if 2 ~= self.handInHandAction then
    return false
  end
  return self.assetRole:IsPlayingActionRaw(self:GetIdleAction())
end
function NCreature:IsPlayingInHandMoveAction()
  if 2 ~= self.handInHandAction then
    return false
  end
  return self.assetRole:IsPlayingActionRaw(self:GetMoveAction())
end
function NCreature:IsPlayingInHandAction()
  if 2 ~= self.handInHandAction then
    return false
  end
  return self.assetRole:IsPlayingActionRaw(self:GetIdleAction()) or self.assetRole:IsPlayingActionRaw(self:GetMoveAction())
end
function NCreature:IsReadyToHandIn(handInCP)
  if self:IsDoubleActionBuild() then
    return
  end
  if self.assetRole:IsPlayingActionRaw(self:GetIdleAction()) or self.assetRole:IsPlayingActionRaw(self:GetMoveAction()) then
    return nil ~= self.assetRole:GetCP(handInCP)
  end
  return false
end
function NCreature:_SetHandInHandAction(action)
  if action == self.handInHandAction then
    return
  end
  local oldIdleActionName = self:GetIdleAction()
  local oldMoveActionName = self:GetMoveAction()
  self.handInHandAction = action
  if self.assetRole:IsPlayingAction(oldIdleActionName) then
    local action = self:GetIdleAction()
    self.assetRole:PlayAction_Simple(action)
  elseif self.assetRole:IsPlayingAction(oldMoveActionName) then
    local action = self:GetMoveAction()
    self.assetRole:PlayAction_Simple(action)
  end
end
function NCreature:Hold()
  if self:IsPlayingDoubleAction() then
    return
  end
  self:_SetHandInHandAction(HandInActionType.Hold)
end
function NCreature:BeHolded()
  self:_SetHandInHandAction(HandInActionType.BeHolded)
end
function NCreature:ClearHold()
  self:_SetHandInHandAction(HandInActionType.Clear)
end
function NCreature:ClearBeHolded()
  self:_SetHandInHandAction(HandInActionType.Clear)
end
function NCreature:IsPlayingHoldIdleAction()
  if HandInActionType.Hold ~= self.handInHandAction then
    return false
  end
  return self.assetRole:IsPlayingActionRaw(self:GetIdleAction())
end
function NCreature:IsPlayingHoldMoveAction()
  if HandInActionType.Hold ~= self.handInHandAction then
    return false
  end
  return self.assetRole:IsPlayingActionRaw(self:GetMoveAction())
end
function NCreature:IsPlayingHoldAction()
  if HandInActionType.Hold ~= self.handInHandAction then
    return false
  end
  return self.assetRole:IsPlayingActionRaw(self:GetIdleAction()) or self.assetRole:IsPlayingActionRaw(self:GetMoveAction())
end
function NCreature:IsPlayingBeHoldedIdleAction()
  if HandInActionType.BeHolded ~= self.handInHandAction then
    return false
  end
  return self.assetRole:IsPlayingActionRaw(self:GetIdleAction())
end
function NCreature:IsPlayingBeHoldedMoveAction()
  if HandInActionType.BeHolded ~= self.handInHandAction then
    return false
  end
  return self.assetRole:IsPlayingActionRaw(self:GetMoveAction())
end
function NCreature:IsPlayingBeHoldedAction()
  if HandInActionType.BeHolded ~= self.handInHandAction then
    return false
  end
  return self.assetRole:IsPlayingActionRaw(self:GetIdleAction()) or self.assetRole:IsPlayingActionRaw(self:GetMoveAction())
end
function NCreature:IsReadyToHold(holdCP)
  if self:IsDoubleActionBuild() then
    return false
  end
  if self.assetRole:IsPlayingActionRaw(self:GetIdleAction()) or self.assetRole:IsPlayingActionRaw(self:GetMoveAction()) then
    return nil ~= self.assetRole:GetCP(holdCP)
  end
  return false
end
function NCreature:IsDoubleActionBuild()
  return self.doubleaction_build == true
end
function NCreature:IsPlayingDoubleAction()
  if self.assetRole == nil then
    return false
  end
  local actionRaw = self.assetRole.actionRaw
  local d_a = config_Action[actionRaw] and config_Action[actionRaw].DoubleAction
  if d_a == nil or d_a <= 0 then
    return false
  end
  return true
end
function NCreature:PlayDoubleAction(isMaster)
  if isMaster then
    self.ai:BreakAll(Time.time, Time.deltaTime, self)
  end
  self:_SetHandInHandAction(HandInActionType.DoubleAction)
  local handNpc = self:GetHandNpc()
  if handNpc then
    handNpc:SetVisible(false, LayerChangeReason.DoubleAction)
  end
end
function NCreature:ClearDoubleAction()
  self:_SetHandInHandAction(HandInActionType.Clear)
  local handNpc = self:GetHandNpc()
  if handNpc then
    handNpc:SetVisible(true, LayerChangeReason.DoubleAction)
  end
end
local HandActionTypeMap = {
  [HandInActionType.HandIn] = Asset_Role.ActionName.IdleHandIn,
  [HandInActionType.InHand] = Asset_Role.ActionName.IdleInHand,
  [HandInActionType.Hold] = Asset_Role.ActionName.IdleHold,
  [HandInActionType.BeHolded] = Asset_Role.ActionName.IdleBeHolded
}
function NCreature:GetIdleAction()
  local handAction = HandActionTypeMap[self.handInHandAction]
  if handAction then
    return handAction
  end
  if HandInActionType.DoubleAction == self.handInHandAction then
    local dactionid = self:GetDoubleActionId(self.new_TwinsActionId)
    if dactionid ~= 0 then
      return table_ActionAnime[dactionid].Name
    else
      local dactionid = self:GetDoubleActionId(self.old_TwinsActionId)
      if dactionid ~= 0 then
        return table_ActionAnime[dactionid].Name
      end
    end
  end
  if self.skillSolo ~= nil then
    local soloAction = self.skillSolo:GetSoloAction()
    if soloAction ~= nil then
      return soloAction
    end
  end
  return self.data and self.data.idleAction or Asset_Role.ActionName.Idle
end
local MoveActionTypeMap = {
  [HandInActionType.HandIn] = Asset_Role.ActionName.MoveHandIn,
  [HandInActionType.InHand] = Asset_Role.ActionName.MoveInHand,
  [HandInActionType.Hold] = Asset_Role.ActionName.MoveHold,
  [HandInActionType.BeHolded] = Asset_Role.ActionName.MoveBeHolded
}
function NCreature:GetMoveAction()
  local handMoveAction = MoveActionTypeMap[self.handInHandAction]
  if handMoveAction then
    return handMoveAction
  end
  return self.data and self.data.moveAction or Asset_Role.ActionName.Move
end
function NCreature:GetPosition()
  return self.logicTransform.currentPosition
end
function NCreature:GetAngleY()
  return self.logicTransform.currentAngleY
end
function NCreature:GetScale()
  return self.data.bodyScale
end
function NCreature:GetOriginalScale()
  return self.originalScale
end
function NCreature:GetDefaultScale()
  return self.data and self.data:GetDefaultScale() or 1
end
function NCreature:GetScaleVector()
  return self.logicTransform.currentScale
end
function NCreature:GetScaleWithFixHW()
  local scaleX, scaleY, scaleZ = self.data.bodyScale, self.data.bodyScale, self.data.bodyScale
  local fixHScale = 1 + self.data.props.SlimHeight:GetValue() / 50
  if fixHScale < fixHeightScale[1] then
    fixHScale = fixHeightScale[1]
  elseif fixHScale > fixHeightScale[2] then
    fixHScale = fixHeightScale[2]
  end
  scaleY = fixHScale * scaleY
  local fixWScale = 1 + self.data.props.SlimWeight:GetValue() / 50
  if fixWScale < fixWeightScale[1] then
    fixWScale = fixWeightScale[1]
  elseif fixWScale > fixWeightScale[2] then
    fixWScale = fixWeightScale[2]
  end
  scaleX = fixWScale * scaleX
  scaleZ = fixWScale * scaleZ
  return scaleX, scaleY, scaleZ
end
function NCreature:GetSceneUI()
  return nil
end
function NCreature:SetVisible(v, reason)
  if self.visibleHandler == nil then
    self.visibleHandler = CreatureVisibleHandler.CreateAsTable()
  end
  self.visibleHandler:Visible(self, v, reason)
  self:SetPartnerVisible(v, reason)
  self:SetHandNpcVisible(v, reason)
  self:SetExpressNpcVisible(v, reason)
end
function NCreature:SetPartnerVisible(v, reason)
  if self.partner then
    self.partner:SetVisible(v, reason)
  end
end
function NCreature:SetHandNpcVisible(v, reason)
  if self.handNpc then
    local npc = self:GetHandNpc()
    if npc then
      npc:SetVisible(v, reason)
    end
  end
end
function NCreature:SetExpressNpcVisible(v, reason)
  if self.expressNpcMap then
    for key, value in pairs(self.expressNpcMap) do
      local npc = self:GetExpressNpc(key)
      if npc then
        npc:SetVisible(v, reason)
      end
    end
  end
end
function NCreature:SetOnCarrier(val)
  self.onCarrier = val
  if val then
    if self.partner ~= nil and not self.partner.data:CanGetOnCarrier() then
      local partnerID = self.partnerID
      self:RemovePartner()
      self.partnerID = partnerID
    end
  elseif self.partner == nil and self.partnerID ~= nil and self.partnerID ~= 0 then
    self:SetPartner(self.partnerID)
  end
end
function NCreature:SetPartner(id)
  self.partnerID = id
  if id == 0 then
    self:RemovePartner()
  else
    if self.partner then
      self.partner:ResetID(id)
    else
      self.partner = NPartner.CreateAsTable(id)
    end
    self.partner:SetMaster(self)
  end
end
function NCreature:RemovePartner()
  if self.partner then
    self.partner:Destroy()
    self.partner = nil
  end
  self.partnerID = 0
end
function NCreature:GetPartnerID()
  return self.partnerID
end
function NCreature:AddHandNpc(guid)
  self.handNpc = guid
end
function NCreature:RemoveHandNpc()
  self.handNpc = nil
end
function NCreature:GetHandNpc()
  if self.handNpc == nil then
    return
  end
  local npc = SceneAINpcProxy.Instance:Find(self.handNpc)
  if npc == nil then
    self:RemoveHandNpc()
  end
  return npc
end
function NCreature:AddExpressNpc(guid)
  if self.expressNpcMap == nil then
    self.expressNpcMap = {}
  end
  if self.expressNpcMap[guid] == nil then
    self.expressNpcMap[guid] = guid
  end
end
function NCreature:ClearExpressNpc()
  if self.expressNpcMap then
    for k, v in pairs(self.expressNpcMap) do
      SceneAINpcProxy.Instance:Remove(k)
    end
    TableUtility.TableClear(self.expressNpcMap)
  end
end
function NCreature:IsExpressNpc(guid)
  if self.expressNpcMap then
    return self.expressNpcMap[guid]
  else
    return nil
  end
end
function NCreature:GetExpressNpc(guid)
  local npc = SceneAINpcProxy.Instance:Find(guid)
  if npc == nil then
    self.expressNpcMap[guid] = nil
  end
  return npc
end
function NCreature:SetStealth(v)
  if self.assetRole then
    if v then
      self.assetRole:AlphaTo(0.5, 1)
    else
      self.assetRole:AlphaTo(1, 1)
    end
  end
end
function NCreature:AddStageNpc(guid)
  self.stageNpc = guid
end
function NCreature:RemoveStageNpc()
  self.stageNpc = nil
end
function NCreature:GetStageNpc()
  local npc = SceneAINpcProxy.Instance:Find(self.stageNpc)
  if npc == nil then
    self:RemoveStageNpc()
  end
  return npc
end
function NCreature:SetParent(parentTransform, noResetLocal)
  self.ai:SetParent(parentTransform, self, noResetLocal)
end
function NCreature:Show()
  FunctionVisibleSkill.Me():CoStart(nil, SkillInVisiblePlayerCmd):ShowPlayer(self)
end
function NCreature:Hide()
  FunctionVisibleSkill.Me():CoStart(nil, SkillInVisiblePlayerCmd):HidePlayer(self)
end
function NCreature:OnStageHide()
  self:SetVisible(false, LayerChangeReason.OnStageWaitting)
  FunctionPlayerUI.Me():MaskAllUI(self, LayerChangeReason.OnStageWaitting)
end
function NCreature:OnStageShow()
  self:SetVisible(true, LayerChangeReason.OnStageWaitting)
  FunctionPlayerUI.Me():UnMaskAllUI(self, LayerChangeReason.OnStageWaitting)
end
function NCreature:SetClickable(v)
  if self.data then
    self.data.noAccessable = v and 0 or 1
  end
  if self.assetRole then
    local creatureType = self:GetCreatureType()
    if creatureType == Creature_Type.Npc or creatureType == Creature_Type.Player then
      local noAccessable = self.data:NoAccessable()
      self.assetRole:SetColliderEnable(not noAccessable)
      if not v and Game.Myself:GetLockTarget() == self then
        Game.Myself:Client_LockTarget(nil)
      end
    end
  end
end
function NCreature:GetClickable()
  return not self.data:NoAccessable()
end
function NCreature:ShowWarnRingEffect()
  self.assetRole:SetShowWarnRingEffect()
end
function NCreature:InitAssetRole()
  self:ReDress()
end
function NCreature:ResetClickPriority()
  if self.assetRole and self.data then
    self.assetRole:SetClickPriority(self.data:GetClickPriority())
  end
end
function NCreature:Server_SyncSkill(phaseData)
  self.ai:PushCommand(FactoryAICMD.GetSkillCmd(phaseData), self)
  if SkillPhase.None == phaseData:GetSkillPhase() then
    self:Server_BreakSkill(phaseData:GetSkillID())
  end
end
function NCreature:Server_BreakSkill(skillID)
  if self.skillFreeCast ~= nil and self.skillFreeCast:GetSkillID() == skillID then
    self.disableSkillBroadcast = true
    self.skillFreeCast:InterruptCast(self)
    self.disableSkillBroadcast = false
  end
end
function NCreature:Server_GetOnSeat(seatID, fromCreature)
  self.ai:PushCommand(FactoryAICMD.GetGetOnSeatCmd(seatID, fromCreature), self)
end
function NCreature:Server_GetOffSeat(seatID, fromCreature)
  self.ai:PushCommand(FactoryAICMD.GetGetOffSeatCmd(seatID, fromCreature), self)
end
function NCreature:InitLogicTransform(serverX, serverY, serverZ, dir, scale, moveSpeed, rotateSpeed, scaleSpeed)
  self.logicTransform:SetMoveSpeed(self.data:ReturnMoveSpeedWithFactor(moveSpeed))
  self.logicTransform:SetRotateSpeed(self.data:ReturnRotateSpeedWithFactor(rotateSpeed))
  self.logicTransform:SetScaleSpeed(self.data:ReturnScaleSpeedWithFactor(scaleSpeed))
  if scale then
    self:Server_SetScaleCmd(scale, true)
  end
  if dir then
    self:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir)
  end
  self:Server_SetPosXYZCmd(serverX, serverY, serverZ, 1000)
end
function NCreature:GetDressParts()
  if not self:IsDressEnable() then
    return Asset_Role.CreatePartArray()
  end
  return self.data:GetDressParts()
end
function NCreature:DestroyDressParts(parts, partsNoDestroy)
  if partsNoDestroy then
    return
  end
  Asset_Role.DestroyPartArray(parts)
end
function NCreature:AllowDress()
  return not self:IsDressEnable() or not not self.dressed
end
function NCreature:ReDress()
  if nil ~= self.assetRole then
    if not self:AllowDress() then
      return
    end
    self:_ReDress()
  else
    local parts
    local partsNoDestroy = false
    local dressEnable = false
    if self:AllowDress() then
      parts, partsNoDestroy = self:GetDressParts()
      dressEnable = self:IsDressEnable()
    else
      parts = Asset_Role.CreatePartArray()
      dressEnable = false
    end
    parts[Asset_Role.PartIndexEx.SmoothDisplay] = 0.3
    self.dressed = dressEnable
    self.assetRole = Asset_Role.Create(parts, self.assetManager)
    self:DestroyDressParts(parts, partsNoDestroy)
  end
end
function NCreature:_ReDress()
  local parts, partsNoDestroy = self:GetDressParts()
  self.dressed = self:IsDressEnable()
  self.assetRole:Redress(parts)
  self:DestroyDressParts(parts, partsNoDestroy)
end
local tmpVector3 = LuaVector3.zero
function NCreature:Server_SetPosXYZCmd(x, y, z, div, ignoreNavMesh)
  tmpVector3:Set(x, y, z)
  if div ~= nil then
    tmpVector3:Div(div)
  end
  self:Server_SetPosCmd(tmpVector3, ignoreNavMesh)
  self.serverPos_x = x / 1000
  self.serverPos_y = y / 1000
  self.serverPos_z = z / 1000
end
function NCreature:GetServerPos()
  return self.serverPos_x or 0, self.serverPos_y or 0, self.serverPos_z or 0
end
function NCreature:Server_SetPosCmd(p, ignoreNavMesh)
  self.ai:PushCommand(FactoryAICMD.GetPlaceToCmd(p, ignoreNavMesh), self)
end
function NCreature:Server_SetDirCmd(mode, dir, noSmooth)
  self.ai:PushCommand(FactoryAICMD.GetSetAngleYCmd(mode, dir, noSmooth), self)
end
function NCreature:Server_MoveToXYZCmd(x, y, z, div, ignoreNavMesh)
  tmpVector3:Set(x, y, z)
  if div ~= nil then
    tmpVector3:Div(div)
  end
  self:Server_MoveToCmd(tmpVector3, ignoreNavMesh)
end
function NCreature:Server_MoveToCmd(p, ignoreNavMesh)
  self.ai:PushCommand(FactoryAICMD.GetMoveToCmd(p, ignoreNavMesh), self)
end
function NCreature:Server_SetScaleCmd(scale, noSmooth)
  self.originalScale = scale
  self.data.bodyScale = scale
  local scaleX, scaleY, scaleZ = self:GetScaleWithFixHW()
  self.ai:PushCommand(FactoryAICMD.GetSetScaleCmd(scaleX, scaleY, scaleZ, noSmooth), self)
end
function NCreature:Server_SetFixHeightCmd(height, noSmooth)
  local scaleX, scaleY, scaleZ = self:GetScaleWithFixHW()
  self.ai:PushCommand(FactoryAICMD.GetSetScaleCmd(scaleX, scaleY, scaleZ, noSmooth), self)
end
function NCreature:Server_SetFixWeightCmd(weight, noSmooth)
  local scaleX, scaleY, scaleZ = self:GetScaleWithFixHW()
  self.ai:PushCommand(FactoryAICMD.GetSetScaleCmd(scaleX, scaleY, scaleZ, noSmooth), self)
end
function NCreature:Server_PlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration)
  self.ai:PushCommand(FactoryAICMD.GetPlayActionCmd(name, normalizedTime, loop, fakeDead, forceDuration), self)
end
function NCreature:Server_DieCmd(noaction)
  self.ai:PushCommand(FactoryAICMD.GetDieCmd(noaction), self)
end
function NCreature:Server_ReviveCmd()
  self.ai:PushCommand(FactoryAICMD.GetReviveCmd(), self)
end
function NCreature:Server_SetMoveSpeed(moveSpeed)
  self.logicTransform:SetMoveSpeed(self.data:ReturnMoveSpeedWithFactor(moveSpeed))
end
function NCreature:Server_SetAtkSpeed(atkSpeed)
  self.data:SetAttackSpeed(atkSpeed)
end
function NCreature:Server_CameraFlash()
  self.ai:CameraFlash(0, 0, self)
end
function NCreature:Server_SetHandInHand(masterID, running)
  if running then
    self.ai:HandInHand(masterID, self)
  else
    self.ai:HandInHand(0, self, nil)
  end
end
function NCreature:Server_SetTwinsActionId(newValue, oldValue)
  self.new_TwinsActionId = newValue
  self.old_TwinsActionId = oldValue
end
function NCreature:Server_SetDoubleAction(masterID, running)
  self.doubleaction_build = running
  if running then
    self.ai:DoDoubleAction(masterID, self)
  else
    self.ai:DoDoubleAction(0, self)
  end
end
local DoubleAction_F_Prefix = "be_"
function NCreature:GetDoubleActionId(handInActionID)
  if handInActionID == nil or handInActionID == 0 then
    return 0
  end
  local action_name = table_ActionAnime[handInActionID] and table_ActionAnime[handInActionID].Name
  local prefix = string.sub(action_name, 1, 3)
  local sex = self.data.userdata:Get(UDEnum.SEX)
  if sex == 1 then
    if prefix == DoubleAction_F_Prefix then
      local reflect_name = string.sub(action_name, 4, -1)
      local reflect_data = config_Action[reflect_name]
      if reflect_data then
        return reflect_data.id
      end
    end
  elseif sex == 2 and prefix ~= DoubleAction_F_Prefix then
    local reflect_name = DoubleAction_F_Prefix .. action_name
    local reflect_data = config_Action[reflect_name]
    if reflect_data then
      return reflect_data.id
    end
  end
  return handInActionID
end
function NCreature:Server_SetAlpha(alpha)
  if self.assetRole then
    self.assetRole:AlphaTo(alpha, 0)
  end
end
function NCreature:Server_SetSolo(value)
  if self.skillSolo == nil then
    self.skillSolo = SkillSolo.Create()
  end
  if value > 0 then
    self.skillSolo:StartSolo(self, value)
  else
    self.skillSolo:EndSolo(self)
    self:ClearSkillSolo()
  end
end
function NCreature:ClearSkillSolo()
  if self.skillSolo ~= nil then
    self.skillSolo:Destroy()
    self.skillSolo = nil
  end
end
function NCreature:Update(time, deltaTime)
  if not self:CanForbidLogic() then
    self.logicTransform:Update(time, deltaTime)
  end
  self.ai:Update(time, deltaTime, self)
  if self.partner then
    self.partner:Update(time, deltaTime)
  end
  if not self:CanForbidLogic() then
    if self.handNpc then
      local npc = self:GetHandNpc()
      if npc then
        npc:Update(time, deltaTime)
      end
    end
    if self.expressNpcMap then
      for k, v in pairs(self.expressNpcMap) do
        local npc = self:GetExpressNpc(k)
        if npc then
          npc:Update(time, deltaTime)
        end
      end
    end
    self:_UpdateArroundMyself(time, deltaTime)
    self:_UpdateSpEffect(time, deltaTime)
  end
end
function NCreature:GetDressDisableDistanceLevel()
  return 999
end
function NCreature:_UpdateArroundMyself(time, deltaTime)
  if not self.dressed then
    local distanceLevelChanged = false
    if self.arroundMyselfLevel ~= self.culling_distanceLevel then
      self.arroundMyselfLevel = self.culling_distanceLevel
      distanceLevelChanged = true
    else
      self.arroundMyselfTime = self.arroundMyselfTime + deltaTime
    end
    local dressDisableDistanceLevel = self:GetDressDisableDistanceLevel()
    if not self.culling_visible or not (dressDisableDistanceLevel > self.culling_distanceLevel) or not self:IsDressEnable() then
      return
    end
    local myself = Game.Myself
    local lockTarget = myself:GetLockTarget()
    if self == lockTarget then
      self:_ReDress()
      return
    end
    if distanceLevelChanged and self.culling_distanceLevel <= 0 then
      local parts, partsNoDestroy = self:GetDressParts()
      self.dressed = self.assetRole:RedressWithCache(parts)
      self:DestroyDressParts(parts, partsNoDestroy)
      if self.dressed then
        return
      end
    end
    local dressDelayTime = self.arroundMyselfLevel * 2 + 1
    if dressDelayTime < self.arroundMyselfTime then
      self:_ReDress()
    end
  end
end
autoImport("EffectWorker_Connect")
autoImport("EffectWorker_OnFloor")
SpEffectWorkerClass = {
  [1] = EffectWorker_Connect,
  [2] = EffectWorker_OnFloor
}
function NCreature:AllowSpEffect_OnFloor()
  return false
end
function NCreature:Server_AddSpEffect(spEffectData)
  local effectID = spEffectData.id
  if nil == Table_SpEffect[effectID] then
    return
  end
  local effectType = Table_SpEffect[effectID].Type
  local EffectClass = SpEffectWorkerClass[effectType]
  if nil == EffectClass then
    return
  end
  if nil == self.spEffects then
    self.spEffects = {}
  end
  local key = spEffectData.guid
  local effect = self.spEffects[key]
  if nil ~= effect then
    effect:Destroy()
    self.spEffects[key] = nil
  end
  effect = EffectClass.Create(effectID)
  effect:SetArgs(spEffectData.entity, self)
  self.spEffects[key] = effect
end
function NCreature:Server_RemoveSpEffect(spEffectData)
  if nil == self.spEffects then
    return
  end
  local key = spEffectData.guid
  local effect = self.spEffects[key]
  if nil ~= effect then
    effect:Destroy()
    self.spEffects[key] = nil
  end
end
function NCreature:ClearSpEffect()
  if nil == self.spEffects then
    return
  end
  for k, v in pairs(self.spEffects) do
    v:Destroy()
    self.spEffects[k] = nil
  end
end
function NCreature:_UpdateSpEffect(time, deltaTime)
  if nil == self.spEffects then
    return
  end
  for k, v in pairs(self.spEffects) do
    if v:Update(time, deltaTime, self) == false then
      v:Destroy()
      self.spEffects[k] = nil
    end
  end
end
function NCreature:IsInMyTeam()
  return nil ~= self.data and TeamProxy.Instance:IsInMyTeam(self.data.id)
end
function NCreature:IsHatred()
  return self.beHatred
end
function NCreature:BeHatred(on, time)
  local oldBeHatred = self.beHatred
  self.beHatred = on
  if self.beHatred then
    Game.LogicManager_Hatred:Refresh(self, time)
  elseif oldBeHatred then
    Game.LogicManager_Hatred:Remove(self)
  end
end
function NCreature:HatredTimeout()
  self.beHatred = false
end
function NCreature:IsCullingRegisted()
  return self.isCullingRegisted
end
function NCreature:RegistCulling()
  Game.CullingObjectManager:Register_Creature(self)
  self.isCullingRegisted = true
end
function NCreature:UnRegistCulling()
  Game.CullingObjectManager:Unregister_Creature(self)
  self.isCullingRegisted = false
end
function NCreature:IsCullingVisible()
  return self.culling_visible
end
function NCreature:GetCullingDistanceLevel()
  return self.culling_distanceLevel
end
function NCreature:CullingStateChange(visible, distanceLevel)
  if visible ~= nil then
    self.culling_visible = visible ~= 0 and true or false
  end
  if distanceLevel ~= nil then
    self.culling_distanceLevel = distanceLevel
  end
  local maskRange = Game.MapManager:GetCreatureMaskRange()
  if not self.culling_visible or maskRange < self.culling_distanceLevel then
    self:MaskOutOfMyRangeUI()
  else
    self:UnMaskOutOfMyRangeUI()
  end
end
function NCreature:MaskOutOfMyRangeUI()
  local reason = PUIVisibleReason.OutOfMyRange
  FunctionPlayerUI.Me():MaskHurtNum(self, reason, false)
  FunctionPlayerUI.Me():MaskChatSkill(self, reason, false)
  FunctionPlayerUI.Me():MaskEmoji(self, reason, false)
end
function NCreature:UnMaskOutOfMyRangeUI()
  local reason = PUIVisibleReason.OutOfMyRange
  FunctionPlayerUI.Me():UnMaskHurtNum(self, reason, false)
  FunctionPlayerUI.Me():UnMaskChatSkill(self, reason, false)
  FunctionPlayerUI.Me():UnMaskEmoji(self, reason, false)
end
function NCreature:IsInBooth()
  return false
end
function NCreature:CanForbidLogic()
  if not self:IsInBooth() then
    return false
  end
  return not self:IsDressEnable() or self.dressed
end
function NCreature:DoConstruct(asArray, data)
  self.culling_visible = true
  self.culling_distanceLevel = 0
  self.dressed = false
  self.arroundMyselfTime = 0
  self.arroundMyselfLevel = -1
  self.data = data
  self.handInHandAction = HandInActionType.Clear
  self.originalScale = 1
  self.ai:Construct(self)
  self.logicTransform:Construct()
end
function NCreature:DoDeconstruct(asArray)
  self.onCarrier = false
  self:BeHatred(false)
  self:ClearSpEffect()
  self:Client_GetOffSeat()
  self.ai:Deconstruct(self)
  if self.data then
    self.data:Destroy()
    self.data = nil
  end
  if self.visibleHandler ~= nil then
    self.visibleHandler:Destroy()
    self.visibleHandler = nil
  end
  self.logicTransform:Deconstruct()
  self:RemovePartner()
  self:RemoveHandNpc()
  self:ClearExpressNpc()
  self:ClearSkillSolo()
end
function NCreature:OnObserverDestroyed(k, obj)
  self:OnObserverEffectDestroyed(k, obj)
end
function NCreature:HasPetPartner()
  return self.partner ~= nil
end
function NCreature:GetPetPartner()
  return self.partner
end
function NCreature:GetBossType()
  return nil
end
function NCreature:GetPlayShowAction()
  if self.data == nil or self.data.staticData == nil then
    return Asset_Role.ActionName.PlayShow
  end
  local playShowActions = self.data.staticData.PlayShowActions
  if playShowActions == nil or #playShowActions == 0 then
    return Asset_Role.ActionName.PlayShow
  end
  local count = #playShowActions
  if count == 1 then
    actionId = playShowActions[1]
  else
    actionId = playShowActions[math.random(count)]
  end
  return Table_ActionAnime[actionId].Name
end
