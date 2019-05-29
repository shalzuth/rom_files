autoImport("InteractNpc")
InteractTrain = class("InteractTrain", InteractNpc)
local MoveState = {
  Open = InteractCmd_pb.ETRAIN_STOP_OPEN,
  Close = InteractCmd_pb.ETRAIN_STOP_CLOSE,
  Move = InteractCmd_pb.ETRAIN_MOVE
}
local pos = LuaVector3.zero
local GameObjectType = Game.GameObjectType.InteractNpc
local VectorDistanceXZ = VectorUtility.DistanceXZ
local Asign_3 = VectorUtility.Asign_3
local ArrayPushBack = TableUtility.ArrayPushBack
local LuaGetPosition = LuaGameObject.GetPosition
local Const_V3_zero = LuaGeometry.Const_V3_zero
local Vector3Equal = LuaVector3.Equal
function InteractTrain:FakeGetOn(cpid, charid)
  local cpTransform = self:GetCP(nil, cpid)
  if cpTransform == nil then
    return
  end
  local assetRole = Game.InteractNpcManager:GetFakeAssetRole(charid)
  if assetRole == nil then
    return
  end
  self.cpMap[cpid] = charid
  assetRole:SetParent(cpTransform, true)
  assetRole:SetPosition(Const_V3_zero)
  assetRole:SetEulerAngles(Const_V3_zero)
  assetRole:SetScale(1)
  assetRole:SetShadowEnable(false)
  assetRole:SetMountDisplay(false)
  assetRole:SetWingDisplay(false)
  assetRole:SetTailDisplay(false)
  local actionID = self.staticData.MountInfo[cpid]
  if actionID ~= nil then
    local actionInfo = Table_ActionAnime[actionID]
    if actionInfo == nil then
      return
    end
    local animParams = Asset_Role.GetPlayActionParams(actionInfo.Name)
    assetRole:PlayAction(animParams)
  end
end
function InteractTrain:FakeGetOff(charid)
  for k, v in pairs(self.cpMap) do
    if v == charid then
      self.cpMap[k] = nil
      break
    end
  end
end
function InteractTrain:UpdateState(state, arrivetime)
  if self.npcState == state then
    return
  end
  if state == MoveState.Open then
    self:PlayAction("wait")
  elseif state == MoveState.Close then
    self:PlayAction("wait")
  elseif state == MoveState.Move then
    local normalizedTime
    if arrivetime ~= nil and arrivetime ~= 0 then
      local leftTime = arrivetime - ServerTime.CurServerTime() / 1000
      if leftTime > 0 then
        local totalTime = self.staticData.Param.MoveTime
        if totalTime ~= nil then
          normalizedTime = (totalTime - leftTime) / totalTime
        end
      end
    end
    self:PlayAction("line", normalizedTime)
  end
  self.npcState = state
end
function InteractTrain:PlayAction(actionName, normalizedTime)
  if actionName == nil or actionName == "" then
    return
  end
  if self.animator == nil then
    return
  end
  normalizedTime = normalizedTime or 0
  self.animator:Play(actionName, -1, normalizedTime)
end
function InteractTrain:CanGetOn()
  if self.npcState == MoveState.Close then
    return false
  end
  return true
end
function InteractTrain:Update(time, deltaTime)
  if time >= self.nextUpdateTime and self.needNotifyMyself then
    local myself = Game.Myself
    local angleY = myself.assetRole.completeTransform.eulerAngles.y
    if self.prevNotifyAngleY == nil or self.prevNotifyAngleY ~= angleY then
      myself:Client_SyncRotationY(angleY)
      self.prevNotifyAngleY = angleY
    end
    local pos = myself:GetPosition()
    if self.prevNotifyPosition == nil or not Vector3Equal(self.prevNotifyPosition, pos) then
      ServiceInteractCmdProxy.Instance:CallPosUpdateInterCmd(pos)
      self.prevNotifyPosition = Asign_3(self.prevNotifyPosition, pos)
    end
  end
  return InteractTrain.super.Update(self, time, deltaTime)
end
function InteractTrain:GetOn(cpid, charid)
  InteractTrain.super.GetOn(self, cpid, charid)
  self.needNotifyMyself = true
end
function InteractTrain:GetOff(charid)
  InteractTrain.super.GetOff(self, charid)
  self.needNotifyMyself = nil
end
function InteractTrain:CheckPosition(npc)
  local myselfPos = Game.Myself:GetPosition()
  for i = 1, #self.triggerTransform do
    pos:Set(LuaGetPosition(self.triggerTransform[i]))
    if VectorDistanceXZ(pos, myselfPos) < self.triggerCheckRange then
      return true
    end
  end
  return false
end
function InteractTrain:GetNpc()
  return Game.GameObjectManagers[GameObjectType]:GetInteractObject(self.npcid)
end
function InteractTrain:GetCP(npc, cpid)
  return self.cpTransform[cpid]
end
function InteractTrain:DoConstruct(asArray, data)
  InteractTrain.super.DoConstruct(self, asArray, data)
  local objData = self:GetNpc()
  local triggerCount = tonumber(objData:GetProperty(0))
  self.triggerTransform = {}
  for i = 1, triggerCount do
    ArrayPushBack(self.triggerTransform, objData:GetComponentProperty(i - 1))
  end
  local cpCount = tonumber(objData:GetProperty(1))
  self.cpTransform = {}
  for i = 1, cpCount do
    self.cpTransform[i] = objData:GetComponentProperty(triggerCount + i - 1)
  end
  self.animator = objData:GetComponentProperty(triggerCount + cpCount)
  self.getOnState = InteractNpc.GetOnState.Ready
end
function InteractTrain:DoDeconstruct(asArray)
  InteractTrain.super.DoDeconstruct(self, asArray)
  self.triggerTransform = nil
  self.cpTransform = nil
  self.animator = nil
  self.needNotifyMyself = nil
  self.prevNotifyAngleY = nil
  if self.prevNotifyPosition ~= nil then
    self.prevNotifyPosition:Destroy()
    self.prevNotifyPosition = nil
  end
end
