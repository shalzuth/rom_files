InteractNpc = class("InteractNpc", ReusableObject)
InteractNpc.PoolSize = 5
InteractNpc.GetOnState = {Wait = 1, Ready = 2}
local InteractType = {Normal = 1, Train = 2}
local tempArgs = {
  [1] = nil,
  [2] = nil
}
local updateInterval = 1
local cameraDuration = 0.3
local cameraViewPort = LuaVector3()
local cameraRotation = LuaVector3()
local VectorDistanceXZ = VectorUtility.DistanceXZ
local TableClear = TableUtility.TableClear
local PartIndexBody = Asset_Role.PartIndex.Body
local LayerChangeReasonInteractNpc = LayerChangeReason.InteractNpc
local PUIVisibleReasonInteractNpc = PUIVisibleReason.InteractNpc
function InteractNpc.GetArgs(staticData, npcGuid)
  tempArgs[1] = staticData
  tempArgs[2] = npcGuid
  return tempArgs
end
function InteractNpc.Create(data)
  local interactType = data[1].Type
  if interactType == InteractType.Normal then
    return ReusableObject.Create(InteractNpc, true, data)
  elseif interactType == InteractType.Train then
    return ReusableObject.Create(InteractTrain, true, data)
  end
end
function InteractNpc:ctor()
  self.cpMap = {}
  self.waitCpMap = {}
end
function InteractNpc:Update(time, deltaTime)
  if self.npcid == nil then
    return false
  end
  local npc
  if self.getOnState == self.GetOnState.Wait then
    npc = self:GetNpc()
    if npc ~= nil and npc.assetRole:GetPartObject(PartIndexBody) ~= nil then
      local hasPlayer = false
      for k, v in pairs(self.waitCpMap) do
        self:GetOn(k, v)
        self.waitCpMap[k] = nil
        hasPlayer = true
      end
      if hasPlayer then
        local actionid = self.staticData.ActionID
        if actionid then
          local actionName = string.format("state%d", actionid)
          npc:Server_PlayActionCmd(actionName, nil, false)
        end
      end
      self.getOnState = self.GetOnState.Ready
    end
  end
  if time < self.nextUpdateTime then
    return self.isInTrigger
  end
  self.nextUpdateTime = time + updateInterval
  if self.needCheckTrigger == false then
    return false
  end
  if self.triggerCheckRange == nil then
    return false
  end
  npc = self:GetNpc()
  if npc == nil then
    return false
  end
  self.isInTrigger = self:CheckPosition(npc)
  return self.isInTrigger
end
function InteractNpc:RequestGetOn(cpid, charid)
  if self.getOnState == self.GetOnState.Wait then
    self.waitCpMap[cpid] = charid
  else
    self:GetOn(cpid, charid)
  end
end
function InteractNpc:RequestGetOff(charid)
  if self.getOnState == self.GetOnState.Wait then
    for k, v in pairs(self.waitCpMap) do
      if v == charid then
        self.waitCpMap[k] = nil
        break
      end
    end
  else
    self:GetOff(charid)
  end
end
function InteractNpc:GetOn(cpid, charid)
  local npc = self:GetNpc()
  if npc == nil then
    return
  end
  local cpTransform = self:GetCP(npc, cpid)
  if cpTransform == nil then
    return
  end
  local creature = NSceneUserProxy.Instance:Find(charid)
  if creature == nil then
    return
  end
  if self.cpMap[cpid] == nil then
    self.cpCount = self.cpCount + 1
  end
  self.cpMap[cpid] = charid
  creature:SetParent(cpTransform)
  creature:Logic_SetAngleY(0)
  local assetRole = creature.assetRole
  assetRole:SetShadowEnable(false)
  assetRole:SetMountDisplay(false)
  assetRole:SetWingDisplay(false)
  assetRole:SetTailDisplay(false)
  creature:SetPeakEffectVisible(false, LayerChangeReasonInteractNpc)
  local FunctionPlayerUI = FunctionPlayerUI.Me()
  FunctionPlayerUI:MaskBloodBar(creature, PUIVisibleReasonInteractNpc)
  FunctionPlayerUI:MaskNameHonorFactionType(creature, PUIVisibleReasonInteractNpc)
  local partner = creature.partner
  if partner ~= nil then
    partner:SetVisible(false, LayerChangeReasonInteractNpc)
  end
  local myself = Game.Myself
  local actionID = self.staticData.MountInfo[cpid]
  if actionID ~= nil then
    local actionInfo = Table_ActionAnime[actionID]
    if actionInfo == nil then
      return
    end
    creature:Client_PlayAction(actionInfo.Name, nil, true)
  end
  if creature == myself then
    local configViewPort = self.staticData.CameraViewPort
    local configRotation = self.staticData.CameraRotation
    if #configViewPort > 0 and #configRotation > 0 then
      cameraViewPort:Set(configViewPort[1], configViewPort[2], configViewPort[3])
      cameraRotation:Set(configRotation[1], configRotation[2], configRotation[3])
      self.cft = CameraEffectFocusAndRotateTo.new(myself.assetRole.completeTransform, nil, cameraViewPort, cameraRotation, cameraDuration)
      FunctionCameraEffect.Me():Start(self.cft)
    end
  end
end
function InteractNpc:GetOff(charid)
  local creature = NSceneUserProxy.Instance:Find(charid)
  if creature == nil then
    return
  end
  for k, v in pairs(self.cpMap) do
    if v == charid then
      self.cpMap[k] = nil
      self.cpCount = self.cpCount - 1
      break
    end
  end
  creature:SetParent(nil, true)
  creature:Logic_NavMeshPlaceTo(creature:GetPosition())
  local assetRole = creature.assetRole
  assetRole:SetShadowEnable(true)
  assetRole:SetMountDisplay(true)
  assetRole:SetWingDisplay(true)
  assetRole:SetTailDisplay(true)
  creature:SetPeakEffectVisible(true, LayerChangeReasonInteractNpc)
  local FunctionPlayerUI = FunctionPlayerUI.Me()
  FunctionPlayerUI:UnMaskBloodBar(creature, PUIVisibleReasonInteractNpc)
  FunctionPlayerUI:UnMaskNameHonorFactionType(creature, PUIVisibleReasonInteractNpc)
  local partner = creature.partner
  if partner ~= nil then
    partner:SetVisible(true, LayerChangeReasonInteractNpc)
  end
  creature:Logic_PlayAction_Idle()
  if creature == Game.Myself and self.cft ~= nil then
    FunctionCameraEffect.Me():End(self.cft)
    self.cft = nil
  end
end
function InteractNpc:CheckPosition(npc)
  return VectorDistanceXZ(npc:GetPosition(), Game.Myself:GetPosition()) < self.triggerCheckRange
end
function InteractNpc:GetNpc()
  return NSceneNpcProxy.Instance:Find(self.npcid)
end
function InteractNpc:GetCP(npc, cpid)
  return npc.assetRole:GetCP(cpid)
end
function InteractNpc:IsTrainType()
  return self.staticData.Type == InteractType.Train
end
function InteractNpc:IsAuto()
  return self.staticData.Auto == 1
end
function InteractNpc:IsFull()
  if self.cpCount >= self.cpMaxCount then
    return true
  end
  return false
end
function InteractNpc:DoConstruct(asArray, data)
  self.staticData = data[1]
  self.npcid = data[2]
  self.needCheckTrigger = not self:IsAuto()
  if self.needCheckTrigger then
    self.triggerCheckRange = self.staticData.Range
  end
  self.cpMaxCount = #self.staticData.MountInfo
  self.nextUpdateTime = 0
  self.cpCount = 0
  self.getOnState = self.GetOnState.Wait
end
function InteractNpc:DoDeconstruct(asArray)
  self.staticData = nil
  self.npcid = nil
  self.nextUpdateTime = nil
  self.isInTrigger = nil
  self.needCheckTrigger = nil
  self.triggerCheckRange = nil
  self.cpCount = nil
  self.cpMaxCount = nil
  self.npcState = nil
  self.getOnState = nil
  TableClear(self.cpMap)
  TableClear(self.waitCpMap)
end
