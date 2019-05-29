autoImport("SceneCreatureProxy")
NSceneUserProxy = class("NSceneUserProxy", SceneCreatureProxy)
NSceneUserProxy.Instance = nil
NSceneUserProxy.NAME = "NSceneUserProxy"
local GROUP_EFFECT_CFG = GameConfig.GroupEquip
local ArrayFindIndex = TableUtility.ArrayFindIndex
function NSceneUserProxy:ctor(proxyName, data)
  self:CountClear()
  self.userMap = {}
  if NSceneUserProxy.Instance == nil then
    NSceneUserProxy.Instance = self
  end
  self.proxyName = proxyName or NSceneUserProxy.NAME
  if Game and Game.LogicManager_Creature then
    Game.LogicManager_Creature:SetSceneUserProxy(self)
  end
end
function NSceneUserProxy:FindOtherRole(guid)
  if Game.Myself and Game.Myself.data and Game.Myself.data.id == guid then
    return nil
  end
  return self:Find(guid)
end
function NSceneUserProxy:Find(guid)
  if Game.Myself and Game.Myself.data and Game.Myself.data.id == guid then
    return Game.Myself
  end
  return self.userMap[guid]
end
function NSceneUserProxy:SyncMove(data)
  local role = self:FindOtherRole(data.charid)
  if nil ~= role then
    role:Server_MoveToXYZCmd(data.pos.x, data.pos.y, data.pos.z)
    return true
  end
  return false
end
function NSceneUserProxy:SyncServerSkill(data)
  if nil ~= data.petid and 0 ~= data.petid then
    if data.petid > 0 then
      return self:SyncServerPetSkill(data)
    elseif not self:NotifyUseSkill(data) then
      return NSceneUserProxy.super.SyncServerSkill(self, data)
    end
  else
    return NSceneUserProxy.super.SyncServerSkill(self, data)
  end
end
function NSceneUserProxy:Add(data, classRef)
  local role
  if Game.Myself.data.id == data.guid then
    Game.Myself.data:SetAchievementtitle(data.achievetitle)
    role = Game.Myself
    role.data:SetTeamID(data.teamid)
    role:InitBuffs(data, false)
    GameFacade.Instance:sendNotification(MyselfEvent.AddBuffs, data.buffs)
    role:Server_SetUserDatas(data.datas, true)
  else
    role = self:Find(data.guid)
    if nil ~= role then
      return role
    end
    role = NPlayer.CreateAsTable(data)
    self.userMap[data.guid] = role
    self:CountPlus()
    if data.dest ~= nil and not PosUtil.IsZero(data.dest) then
      role:Server_MoveToXYZCmd(data.dest.x, data.dest.y, data.dest.z, 1000)
    end
  end
  self:HandleAddScenicBuffs(data)
  local spEffectDatas = data.speffectdata
  if nil ~= spEffectDatas then
    for i = 1, #spEffectDatas do
      role:Server_AddSpEffect(spEffectDatas[i])
    end
  end
  SceneAINpcProxy.Instance:AddHandNpc(role, data.handnpc, data.pos)
  SceneAINpcProxy.Instance:AddExpressNpc(role, data.givenpcdatas, data.pos)
  return role
end
local tmpRoles = {}
function NSceneUserProxy:PureAddSome(datas)
  for i = 1, #datas do
    if datas[i] ~= nil then
      local role = self:Add(datas[i])
      if role ~= nil then
        tmpRoles[#tmpRoles + 1] = role
      end
    end
  end
  GameFacade.Instance:sendNotification(SceneUserEvent.SceneAddRoles, tmpRoles)
  EventManager.Me():PassEvent(SceneUserEvent.SceneAddRoles, tmpRoles)
  SceneCarrierProxy.Instance:PureAddSome(datas)
  TableUtility.TableClear(tmpRoles)
  self:FindGroupUserByPath()
end
function NSceneUserProxy:FindCreateByGuild(guild, array)
  TableUtility.TableClear(array)
  for k, user in pairs(self.userMap) do
    local guildData = user.data:GetGuildData()
    if guildData and guildData.id == guild then
      array[#array + 1] = user
    end
  end
  if Game.Myself.data and Game.Myself.data:GetGuildData() then
    local selfData = Game.Myself.data:GetGuildData()
    if selfData and selfData.id == guild then
      array[#array + 1] = Game.Myself
    end
  end
end
function NSceneUserProxy:CheckUpdataUserData(oldValue, newValue)
  for eff, cfg in pairs(GameConfig.GroupEquip) do
    for i = 1, #cfg do
      for j = 1, #cfg[i] do
        if oldValue == cfg[i][j] or newValue == cfg[i][j] then
          self:FindGroupUserByPath()
          return
        end
      end
    end
  end
end
function NSceneUserProxy:RemoveSome(guids)
  local roles = NSceneUserProxy.super.RemoveSome(self, guids)
  if roles and #roles > 0 then
    GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveRoles, roles)
    EventManager.Me():PassEvent(SceneUserEvent.SceneRemoveRoles, roles)
    self:HandleRemoveScenicBuffs(roles)
  end
  self:FindGroupUserByPath()
end
local tempPos = LuaVector3.zero
function NSceneUserProxy:FindNearUsers(position, distance, filter)
  tempPos:Set(position[1], position[2], position[3])
  local list = {}
  for k, user in pairs(self.userMap) do
    if nil == filter or filter(user) then
      local dist = LuaVector3.Distance(user:GetPosition(), tempPos)
      if distance >= dist then
        table.insert(list, user)
      end
    end
  end
  return list
end
function NSceneUserProxy:FindGroupUserByPath()
  if nil == GROUP_EFFECT_CFG then
    return
  end
  self:ClearGroupEff()
  for path, groupIDs in pairs(GROUP_EFFECT_CFG) do
    for p = 1, #groupIDs do
      self:CheckGroupUser(groupIDs[p], path)
    end
  end
end
function NSceneUserProxy:ClearGroupEff()
  for k, v in pairs(self.userMap) do
    v:RemoveGroupEffect()
  end
  Game.Myself:RemoveGroupEffect()
end
local CHECK_UDEnum = {
  "BODY",
  "HAIR",
  "LEFTHAND",
  "RIGHTHAND",
  "HEAD",
  "BACK",
  "FACE",
  "TAIL",
  "EYE",
  "MOUNT",
  "MOUTH"
}
local uData = {}
local _GetUserData = function(userdata)
  TableUtility.ArrayClear(uData)
  for i = 1, #CHECK_UDEnum do
    uData[#uData + 1] = userdata:Get(CHECK_UDEnum[i]) or 0
  end
  return uData
end
local Limited_GroupCount = 2
function NSceneUserProxy:CheckGroupUser(group, path)
  local list = {}
  local myself = Game.Myself
  local myguid = myself.data.id
  local allEquip = {}
  for guid, user in pairs(self.userMap) do
    local userdata = _GetUserData(user.data.userdata)
    for i = 1, #userdata do
      local equip = userdata[i]
      if 0 ~= ArrayFindIndex(group, equip) then
        if nil == list[guid] then
          list[guid] = {}
        end
        if 0 == ArrayFindIndex(list[guid], equip) then
          table.insert(list[guid], equip)
        end
        if 0 == ArrayFindIndex(allEquip, equip) then
          allEquip[#allEquip + 1] = equip
        end
      end
    end
  end
  local myUserdata = _GetUserData(myself.data.userdata)
  for i = 1, #myUserdata do
    local equip = myUserdata[i]
    if 0 ~= ArrayFindIndex(group, equip) then
      if nil == list[myguid] then
        list[myguid] = {}
      end
      if 0 == ArrayFindIndex(list[myguid], equip) then
        table.insert(list[myguid], equip)
      end
      if 0 == ArrayFindIndex(allEquip, equip) then
        allEquip[#allEquip + 1] = equip
      end
    end
  end
  if #allEquip >= Limited_GroupCount then
    for roleID, _ in pairs(list) do
      self:Find(roleID):PlayGropEquipEffect(path)
    end
  end
end
function NSceneUserProxy:Clear()
  local clears = NSceneUserProxy.super.Clear(self)
  if clears and #clears > 0 then
    GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveRoles, clears)
    EventManager.Me():PassEvent(SceneUserEvent.SceneRemoveRoles, clears)
  end
end
function NSceneUserProxy:AddScenicBuff(guid, buffId)
  local buffData = Table_Buffer[buffId]
  if buffData and buffData.BuffEffect.type == "Scenery" then
    local data = FunctionScenicSpot.Me():AddCreatureScenicSpot(guid, buffData.BuffEffect.scenic)
    if data then
      GameFacade.Instance:sendNotification(MiniMapEvent.CreatureScenicAdd, {data})
    end
  end
end
local tempArray = {}
function NSceneUserProxy:HandleAddScenicBuffs(serverData)
  TableUtility.ArrayClear(tempArray)
  local buffDatas = serverData.buffs
  if buffDatas and #buffDatas > 0 then
    for i = 1, #buffDatas do
      local scenic = self:AddScenicBuff(serverData.guid, buffDatas[i].id)
      if scenic then
        tempArray[#tempArray + 1] = scenic
      end
    end
  end
end
function NSceneUserProxy:RemoveScenicBuff(guid, buffId)
  local ssId
  if buffId then
    local buffData = Table_Buffer[buffId]
    if buffData and buffData.BuffEffect.type == "Scenery" then
      ssId = buffData.BuffEffect.scenic
      FunctionScenicSpot.Me():RemoveCreatureScenicSpot(guid, ssId)
    end
  end
end
function NSceneUserProxy:HandleRemoveScenicBuffs(guids)
  for i = 1, #guids do
    FunctionScenicSpot.Me():RemoveCreatureScenicSpot(guids[i])
  end
end
