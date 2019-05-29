autoImport("SceneObjectProxy")
NSceneEffectProxy = class("NSceneEffectProxy", SceneObjectProxy)
NSceneEffectProxy.Instance = nil
NSceneEffectProxy.NAME = "NSceneEffectProxy"
NSceneEffectProxy.MaxCount = 300
autoImport("NSceneEffect")
autoImport("ClientSceneEffect")
function NSceneEffectProxy:ctor(proxyName, data)
  self.userMap = {}
  self.sceneEffectMap = {}
  if NSceneEffectProxy.Instance == nil then
    NSceneEffectProxy.Instance = self
  end
  self.proxyName = proxyName or NSceneEffectProxy.NAME
  self.effectCount = 0
end
function NSceneEffectProxy:GetEffectPath(effect)
  if FunctionPerformanceSetting.Me():GetSetting().effectLow then
    local low = Table_MapEffectLow[effect]
    if low then
      return low
    end
  end
  return effect
end
function NSceneEffectProxy:Add(data)
  if 0 == data.charid then
    return
  end
  if Asset_Effect.AliveCount >= Asset_Effect.MaxCount then
    redlog("Effect Overflow!!!", Asset_Effect.AliveCount, data.effect, data.charid)
    return
  end
  data.effect = self:GetEffectPath(data.effect)
  local effect = NSceneEffect.CreateAsTable(data)
  local guid = effect.guid
  local effects = self:Find(guid)
  if effects == nil then
    effects = ReusableTable.CreateArray()
    self.userMap[guid] = effects
  end
  effects[#effects + 1] = effect
  effect:Start(self.EffectEnd, self)
end
function NSceneEffectProxy:Client_AddSceneEffect(id, pos, effectPath, oneShot)
  if not oneShot then
    local effect = self.sceneEffectMap[id]
    if effect == nil then
      effect = ReusableObject.Create(ClientSceneEffect, false, nil)
      self.sceneEffectMap[id] = effect
      effect:Start(pos, effectPath, oneShot)
    end
  else
    ClientSceneEffect.PlayEffect(pos, effectPath, oneShot)
  end
end
function NSceneEffectProxy:Client_RemoveSceneEffect(id)
  local effect = self.sceneEffectMap[id]
  if effect then
    self.sceneEffectMap[id] = nil
    effect:Destroy()
  end
end
function NSceneEffectProxy:Server_AddSceneEffect(data)
  if data.id == nil or data.id == 0 then
    return
  end
  if Asset_Effect.AliveCount >= Asset_Effect.MaxCount then
    redlog("Effect Overflow!!!", Asset_Effect.AliveCount, data.effect, data.id)
    return
  end
  local guid = data.id
  local effect = self.sceneEffectMap[guid]
  if effect == nil then
    data.effect = self:GetEffectPath(data.effect)
    effect = NSceneEffect.CreateAsTable(data)
    self.sceneEffectMap[guid] = effect
    effect:Start(self.EffectEnd, self)
  end
end
function NSceneEffectProxy:Server_RemoveSceneEffect(id)
  self:Client_RemoveSceneEffect(id)
end
function NSceneEffectProxy:EffectEnd(effect)
  self:Remove(effect.args, effect)
end
function NSceneEffectProxy:Destroy(effect)
  if nil == effect or type(effect) ~= "table" then
    return
  end
  if effect.__cname and effect.__cname ~= "NSceneEffect" and effect.__cname ~= "ClientSceneEffect" then
    return
  end
  if effect:Alive() then
    effect:Destroy()
  end
end
function NSceneEffectProxy:Remove(data, effect)
  if data.id and data.id > 0 then
    self:Server_RemoveSceneEffect(data.id)
  else
    local guid = NSceneEffect.GetEffectGuid(data)
    local effects = self:Find(guid)
    if nil ~= effects then
      if nil ~= effect then
        local index = TableUtil.Remove(effects, effect)
        self:Destroy(effect)
      else
        for k, v in pairs(effects) do
          self:Destroy(v)
        end
        ReusableTable.DestroyAndClearArray(effects)
        self.userMap[guid] = nil
      end
    end
  end
  return effect
end
function NSceneEffectProxy:Clear()
  for _, effects in pairs(self.userMap) do
    for k, v in pairs(effects) do
      self:Destroy(v)
    end
    ReusableTable.DestroyAndClearArray(effects)
    self.userMap[_] = nil
  end
  for k, effect in pairs(self.sceneEffectMap) do
    self.sceneEffectMap[k] = nil
    self:Destroy(effect)
  end
end
