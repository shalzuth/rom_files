SceneObjectProxy = class("SceneObjectProxy", pm.Proxy)
SceneObjectProxy.Instance = nil
SceneObjectProxy.NAME = "SceneObjectProxy"
SceneObjectProxy.AddMode = {Normal = 1, Refresh = 2}
function SceneObjectProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SceneObjectProxy.NAME
  self.userMap = {}
  self.addMode = SceneObjectProxy.AddMode.Normal
  if SceneObjectProxy.Instance == nil then
    SceneObjectProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
end
function SceneObjectProxy.RemoveObjs(list, delay, fadeout)
  SceneTrapProxy.Instance:RemoveSome(list)
  SceneTriggerProxy.Instance:RemoveSome(list)
  SceneItemProxy.Instance:SetRemoveFlags(list)
  NSceneNpcProxy.Instance:RemoveSome(list, delay, fadeout)
  NScenePetProxy.Instance:RemoveSome(list, delay, fadeout)
  NSceneUserProxy.Instance:RemoveSome(list)
end
function SceneObjectProxy.ClearAll()
  SceneItemProxy.Instance:Clear()
  SceneTrapProxy.Instance:Clear()
  SceneTriggerProxy.Instance:Clear()
  SceneCarrierProxy.Instance:Clear()
  SceneAINpcProxy.Instance:Clear()
  NSceneEffectProxy.Instance:Clear()
  NSceneNpcProxy.Instance:Clear()
  NScenePetProxy.Instance:Clear()
  NSceneUserProxy.Instance:Clear()
end
function SceneObjectProxy:GetAll()
  return self.userMap
end
function SceneObjectProxy:ChangeAddMode(mode)
  self.addMode = mode
end
function SceneObjectProxy:Find(guid)
  return self.userMap[guid]
end
function SceneObjectProxy:Add(data)
  return nil
end
function SceneObjectProxy:PureAddSome(datas)
  return nil
end
function SceneObjectProxy:RefreshAdd(datas, idPropName)
  idPropName = idPropName or "id"
  local newAdds = {}
  local newAddDatas = {}
  local removes = {}
  local find, data
  for i = 1, #datas do
    data = datas[i]
    find = self.userMap[data[idPropName]]
    if find == nil then
      newAddDatas[#newAddDatas + 1] = data
    else
      find.refresh = true
    end
  end
  for k, v in pairs(self.userMap) do
    if not v.refresh then
    end
  end
  for i = 1, #newAddDatas do
    newAdds[#newAdds + 1] = self:Add(newAddDatas[i])
  end
  return newAdds, removes
end
function SceneObjectProxy:AddSome(datas)
  if self.addMode == SceneObjectProxy.AddMode.Normal then
    return self:PureAddSome(datas)
  elseif self.addMode == SceneObjectProxy.AddMode.Refresh then
    return self:RefreshAdd(datas)
  end
end
function SceneObjectProxy:Remove(guid)
  return nil
end
function SceneObjectProxy:RemoveSome(guids, delay, fadeout)
  self.removeSomes = self.removeSomes and self.removeSomes or {}
  TableUtility.ArrayClear(self.removeSomes)
  if guids ~= nil and #guids > 0 then
    for i = 1, #guids do
      if self:Remove(guids[i], delay, fadeout) then
        self.removeSomes[#self.removeSomes + 1] = guids[i]
      end
    end
  end
  return self.removeSomes
end
function SceneObjectProxy:Clear()
  self:ChangeAddMode(SceneObjectProxy.AddMode.Normal)
end
