autoImport("SceneObjectProxy")
autoImport("SceneDropItem")
SceneItemProxy = class("SceneItemProxy", SceneObjectProxy)
SceneItemProxy.Instance = nil
SceneItemProxy.NAME = "SceneItemProxy"
function SceneItemProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SceneItemProxy.NAME
  self.userMap = {}
  self.addMode = SceneObjectProxy.AddMode.Normal
  if SceneItemProxy.Instance == nil then
    SceneItemProxy.Instance = self
  end
  self:InitConfig()
  self.tmp = {}
  self.tmpItemData = {}
  self.maxTime = GameConfig.SceneDropItem.disappeartime * 1000 * 1.5
  self.poringFightMaxTime = 300000
  TimeTickManager.Me():CreateTick(0, 2000, self.Tick, self)
end
function SceneItemProxy:Tick(deltaTime)
  local isPoringFight = Game.MapManager and Game.MapManager:IsPVPMode_PoringFight() or false
  for k, v in pairs(self.tmp) do
    v = v + deltaTime
    self.tmp[k] = v
    if v >= self.maxTime and (not isPoringFight or v >= self.poringFightMaxTime) then
      local item = self.userMap[k]
      if item ~= nil then
        self:SetRemoveFlag(k)
        self.tmpItemData.itemguid = item.id
        GameFacade.Instance:sendNotification(ServiceEvent.MapPickupItem, self.tmpItemData)
      else
        self.tmp[k] = nil
      end
    end
  end
end
function SceneItemProxy:InitConfig()
  self.typeConfig = {}
  for k, v in pairs(GameConfig.SceneDropItem) do
    if type(v) == "table" then
      local types = v.Types
      if types ~= nil then
        for i = 1, #types do
          self.typeConfig[types[i]] = v
        end
      end
    end
  end
end
function SceneItemProxy:Add(data)
  local item = self.userMap[data.guid]
  if item == nil then
    local staticData = Table_Item[data.id]
    if not staticData then
      error(string.format("\230\156\141\229\138\161\229\153\168\232\166\129\230\177\130\230\183\187\229\138\160\233\129\147\229\133\183%s,\233\133\141\231\189\174\230\156\170\230\137\190\229\136\176", data.id))
    end
    item = SceneDropItem.CreateAsTable()
    self.tmp[data.guid] = 0
    item:ResetData(data.guid, staticData, Table_Equip[data.id], data.time, data.pos, data.owners, self.typeConfig[staticData.Type], data.sourceid, data.refinelv)
    if #data.owners == 0 or Game.Myself ~= nil and 0 < TableUtil.ArrayIndexOf(data.owners, Game.Myself.data.id) then
      item.iCanPickUp = true
    end
    self.userMap[data.guid] = item
  else
    item = nil
  end
  if item and FunctionPurify.Me():MonsterNeedPurify(item.sourceID) then
    FunctionPurify.Me():AddDrops(item)
    item = nil
  end
  return item
end
function SceneItemProxy:PureAddSome(datas)
  local items = {}
  local item
  for i = 1, #datas do
    item = self:Add(datas[i])
    if item ~= nil then
      items[#items + 1] = item
    end
  end
  return items
end
function SceneItemProxy:DropItems(datas)
  local items = self:AddSome(datas)
  FunctionSceneItemCommand.Me():DropItems(items)
end
function SceneItemProxy:RefreshAdd(datas)
end
function SceneItemProxy:Remove(guid)
  local item = self.userMap[guid]
  if item ~= nil then
    item:DestroyUI()
    self.userMap[guid] = nil
  end
  self.tmp[guid] = nil
  return item
end
function SceneItemProxy:SetRemoveFlags(guids)
  for i = 1, #guids do
    self:SetRemoveFlag(guids[i])
  end
end
function SceneItemProxy:SetRemoveFlag(guid)
  if self:Remove(guid) ~= nil then
    FunctionSceneItemCommand.Me():SetRemoveFlag(guid)
  end
end
function SceneItemProxy:RemoveSome(guids)
end
function SceneItemProxy:Clear()
  self.tmp = {}
  self.userMap = {}
  FunctionSceneItemCommand.Me():Clear()
end
