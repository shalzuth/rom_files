autoImport("Trap")
SceneTrapProxy = class("SceneTrapProxy", SceneObjectProxy)
SceneTrapProxy.Instance = nil
SceneTrapProxy.NAME = "SceneTrapProxy"
function SceneTrapProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SceneTrapProxy.NAME
  self:Reset()
  self.addMode = SceneObjectProxy.AddMode.Normal
  if SceneTrapProxy.Instance == nil then
    SceneTrapProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
end
function SceneTrapProxy:Reset()
  self.trapMap = {}
end
function SceneTrapProxy:Find(guid)
  return self.trapMap[guid]
end
function SceneTrapProxy:CullingStateChange(guid, visible, distanceLevel)
  local trap = self.trapMap[guid]
  if trap then
    trap:CullingStateChange(visible, distanceLevel)
  end
end
function SceneTrapProxy:Add(data)
  if self.trapMap[data.id] == nil then
    local trap = Trap.CreateAsTable()
    trap:Init(data.id, data.skillID, data.masterid, data.pos)
    self.trapMap[data.id] = trap
    trap:SetRotation(data.dir)
    return trap
  end
  return nil
end
function SceneTrapProxy:PureAddSome(datas)
  for i = 1, #datas do
    self:Add(datas[i])
  end
  return nil
end
function SceneTrapProxy:RefreshAdd(datas)
  return nil
end
function SceneTrapProxy:AddSome(datas)
  if self.addMode == SceneObjectProxy.AddMode.Normal then
    return self:PureAddSome(datas)
  elseif self.addMode == SceneObjectProxy.AddMode.Refresh then
    return self:RefreshAdd(datas)
  end
end
function SceneTrapProxy:Remove(guid)
  local trap = self.trapMap[guid]
  if trap then
    trap:Destroy()
    self.trapMap[guid] = nil
  end
  return trap
end
function SceneTrapProxy:RemoveSome(guids)
  if guids ~= nil and #guids > 0 then
    for i = 1, #guids do
      self:Remove(guids[i])
    end
  end
end
function SceneTrapProxy:Clear()
  self:ChangeAddMode(SceneObjectProxy.AddMode.Normal)
  for id, trap in pairs(self.trapMap) do
    trap:Destroy()
  end
  self:Reset()
end
function SceneTrapProxy:GetAll()
  return self.trapMap
end
