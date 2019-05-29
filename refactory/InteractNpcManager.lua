autoImport("InteractNpc")
autoImport("InteractTrain")
InteractNpcManager = class("InteractNpcManager")
local GameFacade = GameFacade.Instance
local ArrayPushBack = TableUtility.ArrayPushBack
local ArrayRemove = TableUtility.ArrayRemove
local ArrayClear = TableUtility.ArrayClear
local PartIndex = Asset_Role.PartIndex
local PartIndexEx = Asset_Role.PartIndexEx
function InteractNpcManager:ctor()
  self.interactNpcMap = {}
  self.assetRoleMap = {}
  self.interactNpcCount = 0
end
function InteractNpcManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  if self.interactNpcCount == 0 then
    return
  end
  local isInTrigger = false
  self.lockNpcGuid = nil
  for k, v in pairs(self.interactNpcMap) do
    if v:Update(time, deltaTime) then
      isInTrigger = true
      self.lockNpcGuid = k
      break
    end
  end
  if self.isInTrigger ~= isInTrigger then
    self:_TrySendMyselfTriggerChange(isInTrigger)
    self.isInTrigger = isInTrigger
  end
end
function InteractNpcManager:Launch()
  if self.running then
    return
  end
  self.running = true
end
function InteractNpcManager:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  self:Clear()
end
function InteractNpcManager:Clear()
  for k, v in pairs(self.interactNpcMap) do
    v:Destroy()
    self.interactNpcMap[k] = nil
  end
  for k, v in pairs(self.assetRoleMap) do
    v:Destroy()
    self.assetRoleMap[k] = nil
  end
  self.interactNpcCount = 0
  if self.fakeUserdata ~= nil then
    self.fakeUserdata:Destroy()
    self.fakeUserdata = nil
  end
  if self.fakeParts ~= nil then
    Asset_Role.DestroyPartArray(self.fakeParts)
    self.fakeParts = nil
  end
  self:ClearTrigger()
end
function InteractNpcManager:ClearTrigger()
  self.isInTrigger = nil
  GameFacade:sendNotification(InteractNpcEvent.MyselfTriggerChange, false)
end
function InteractNpcManager:RegisterInteractNpc(staticid, id)
  local data = Table_InteractNpc[staticid]
  if data == nil then
    return
  end
  local interactNpcMap = self.interactNpcMap
  if interactNpcMap[id] ~= nil then
    return
  end
  local args = InteractNpc.GetArgs(data, id)
  interactNpcMap[id] = InteractNpc.Create(args)
  self.interactNpcCount = self.interactNpcCount + 1
end
function InteractNpcManager:UnregisterInteractNpc(id)
  local interactNpcMap = self.interactNpcMap
  if interactNpcMap[id] ~= nil then
    if id == self.myselfOnNpcGuid then
      interactNpcMap[id]:RequestGetOff(Game.Myself.data.id)
      self:_ChangeMyselfOnOff(nil, interactNpcMap[id])
    end
    interactNpcMap[id]:Destroy()
    interactNpcMap[id] = nil
    self.interactNpcCount = self.interactNpcCount - 1
    if self.interactNpcCount == 0 then
      self:ClearTrigger()
    end
  end
end
function InteractNpcManager:MyselfManualGetOff()
  self:_TryNotifyGetOff()
end
function InteractNpcManager:MyselfManualClick()
  if not self:_TryNotifyGetOff() then
    self:_TryNotifyGetOn()
  end
end
function InteractNpcManager:AddInteractObject(id)
  self:RegisterInteractNpc(id, id)
end
function InteractNpcManager:RemoveInteractObject(id)
  self:UnregisterInteractNpc(id)
end
function InteractNpcManager:AddMountInter(npcguid, mountid, charid)
  local interactNpc = self.interactNpcMap[npcguid]
  if interactNpc ~= nil then
    interactNpc:RequestGetOn(mountid, charid)
    if charid == Game.Myself.data.id then
      self:_ChangeMyselfOnOff(npcguid, interactNpc)
    end
  end
end
function InteractNpcManager:DelMountInter(data)
  local npcguid = data.npcguid
  local interactNpc = self.interactNpcMap[npcguid]
  if interactNpc ~= nil then
    local charid = data.charid
    interactNpc:RequestGetOff(charid)
    if charid == Game.Myself.data.id then
      self:_ChangeMyselfOnOff(nil, interactNpc)
    end
  end
end
function InteractNpcManager:AddMoveMountInter(data)
  local interactNpc = self.interactNpcMap[data.npcid]
  if interactNpc ~= nil then
    self:_GetOnMoveMount(interactNpc, data.user)
  end
end
function InteractNpcManager:DelMoveMountInter(data)
  local interactNpc = self.interactNpcMap[data.npcid]
  if interactNpc ~= nil then
    local charid
    for i = 1, #data.charids do
      charid = data.charids[i]
      if charid == Game.Myself.data.id then
        interactNpc:RequestGetOff(charid)
        self:_ChangeMyselfOnOff(nil, interactNpc)
      else
        local assetRole = self.assetRoleMap[charid]
        if assetRole ~= nil then
          assetRole:Destroy()
          self.assetRoleMap[charid] = nil
        end
        interactNpc:FakeGetOff(charid)
      end
    end
  end
end
function InteractNpcManager:UpdateTrainStateInter(data)
  local interactNpc = self.interactNpcMap[data.npcid]
  if interactNpc ~= nil then
    interactNpc:UpdateState(data.state)
  end
end
function InteractNpcManager:TrainUserSyncInter(data)
  local interactNpc = self.interactNpcMap[data.npcid]
  if interactNpc ~= nil then
    interactNpc:UpdateState(data.state, data.arrivetime)
    for i = 1, #data.users do
      self:_GetOnMoveMount(interactNpc, data.users[i])
    end
  end
end
function InteractNpcManager:_TryNotifyGetOn()
  local lockNpcGuid = self.lockNpcGuid
  if lockNpcGuid ~= nil then
    local interactNpc = self.interactNpcMap[lockNpcGuid]
    if interactNpc:IsFull() then
      MsgManager.ShowMsgByID(28000)
      return false
    end
    if interactNpc:IsTrainType() then
      if interactNpc:CanGetOn() then
        ServiceInteractCmdProxy.Instance:CallConfirmMoveMountInterCmd(lockNpcGuid)
      else
        MsgManager.ShowMsgByID(28002)
      end
    else
      ServiceInteractCmdProxy.Instance:CallConfirmMountInterCmd(lockNpcGuid)
    end
    return true
  end
  return false
end
function InteractNpcManager:_TryNotifyGetOff()
  local myselfOnNpcGuid = self.myselfOnNpcGuid
  if myselfOnNpcGuid ~= nil then
    local interactNpc = self.interactNpcMap[myselfOnNpcGuid]
    if interactNpc:IsTrainType() then
      ServiceInteractCmdProxy.Instance:CallCancelMoveMountInterCmd(myselfOnNpcGuid)
    else
      ServiceInteractCmdProxy.Instance:CallCancelMountInterCmd(myselfOnNpcGuid)
    end
    return true
  end
  return false
end
function InteractNpcManager:_ChangeMyselfOnOff(npcguid, interactNpc)
  self.myselfOnNpcGuid = npcguid
  GameFacade:sendNotification(InteractNpcEvent.MyselfOnOffChange, npcguid ~= nil)
  if interactNpc:IsAuto() then
    self:_TrySendMyselfTriggerChange(npcguid ~= nil)
  end
  if npcguid == nil then
    MsgManager.ShowMsgByID(28001)
  end
end
function InteractNpcManager:_GetOnMoveMount(interactNpc, user)
  local charid = user.user.charid
  if charid == Game.Myself.data.id then
    interactNpc:RequestGetOn(user.mountid, charid)
    self:_ChangeMyselfOnOff(interactNpc.npcid, interactNpc)
  else
    local parts = self:_GetDressParts(user.user.datas)
    local assetRole = self.assetRoleMap[charid]
    if assetRole == nil then
      assetRole = Asset_Role.Create(parts)
      self.assetRoleMap[charid] = assetRole
    end
    assetRole:Redress(parts)
    interactNpc:FakeGetOn(user.mountid, charid)
  end
end
function InteractNpcManager:_ResetUserData(serverdata)
  if self.fakeUserdata == nil then
    self.fakeUserdata = UserData.CreateAsTable()
  end
  self.fakeUserdata:Reset()
  local sdata
  for i = 1, #serverdata do
    sdata = serverdata[i]
    if sdata ~= nil then
      self.fakeUserdata:SetByID(sdata.type, sdata.value, sdata.data)
    end
  end
  return self.fakeUserdata
end
function InteractNpcManager:_GetDressParts(serverdata)
  local userdata = self:_ResetUserData(serverdata)
  if self.fakeParts == nil then
    self.fakeParts = Asset_Role.CreatePartArray()
  end
  local parts = self.fakeParts
  if userdata then
    parts[PartIndex.Body] = userdata:Get(UDEnum.BODY) or 0
    parts[PartIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0
    parts[PartIndex.LeftWeapon] = userdata:Get(UDEnum.LEFTHAND) or 0
    parts[PartIndex.RightWeapon] = userdata:Get(UDEnum.RIGHTHAND) or 0
    parts[PartIndex.Head] = userdata:Get(UDEnum.HEAD) or 0
    parts[PartIndex.Wing] = userdata:Get(UDEnum.BACK) or 0
    parts[PartIndex.Face] = userdata:Get(UDEnum.FACE) or 0
    parts[PartIndex.Tail] = userdata:Get(UDEnum.TAIL) or 0
    parts[PartIndex.Eye] = userdata:Get(UDEnum.EYE) or 0
    parts[PartIndex.Mouth] = userdata:Get(UDEnum.MOUTH) or 0
    parts[PartIndexEx.Gender] = userdata:Get(UDEnum.SEX) or 0
    parts[PartIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0
    parts[PartIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0
    parts[PartIndexEx.BodyColorIndex] = userdata:Get(UDEnum.CLOTHCOLOR) or 0
    parts[PartIndexEx.SmoothDisplay] = 0.3
  else
    for i = 1, 16 do
      parts[i] = 0
    end
  end
  return parts
end
function InteractNpcManager:_TrySendMyselfTriggerChange(isInTrigger)
  if self.myselfOnNpcGuid ~= nil then
    isInTrigger = true
  end
  GameFacade:sendNotification(InteractNpcEvent.MyselfTriggerChange, isInTrigger)
end
function InteractNpcManager:IsMyselfOnNpc()
  return self.myselfOnNpcGuid ~= nil
end
function InteractNpcManager:GetFakeAssetRole(charid)
  return self.assetRoleMap[charid]
end
