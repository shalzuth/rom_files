EffectManager = class("EffectManager")
EffectManager.AutoDestroyMaxCount = 500
EffectManager.FilterType = {All = 1}
EffectManager.EffectType = {Loop = 1, OneShot = 2}
function EffectManager:ctor()
  self.effect_list = {}
  self.effects = {}
  self.autoDestroyEffects = {}
  self.isFilter = false
end
function EffectManager:Filter(filterType)
  self.isFilter = true
  for k, autoDestroyEffect in pairs(self.autoDestroyEffects) do
    self.autoDestroyEffects[k] = nil
    autoDestroyEffect:Stop()
  end
  for k, effect in pairs(self.effects) do
    effect:SetActive(false, Asset_Effect.DeActiveOpt.Filter)
  end
end
function EffectManager:UnFilter(filterType)
  self.isFilter = false
  for k, effect in pairs(self.effects) do
    effect:SetActive(true, Asset_Effect.DeActiveOpt.Filter)
  end
end
function EffectManager:IsFiltered()
  return self.isFilter
end
function EffectManager:RegisterEffect(effect, autoDestroy)
  if effect == nil then
    return
  end
  if autoDestroy then
    self.effects[effect.id] = nil
    self.autoDestroyEffects[effect.id] = effect
    if #self.effect_list > EffectManager.AutoDestroyMaxCount then
      local id = self.effect_list[1]
      local effect = self.autoDestroyEffects[id]
      if effect ~= nil then
        effect:Destroy()
      end
    end
    self:AddOrUpdateEffectIdToList(effect.id)
  else
    self.effects[effect.id] = effect
  end
end
function EffectManager:AddOrUpdateEffectIdToList(id)
  for i = #self.effect_list, 1, -1 do
    if id == self.effect_list[i] then
      table.remove(self.effect_list, i)
      break
    end
  end
  table.insert(self.effect_list, id)
end
function EffectManager:RemoveEffectIdInList(id)
  for i = #self.effect_list, 1, -1 do
    if id == self.effect_list[i] then
      return table.remove(self.effect_list, i), i
    end
  end
  return nil
end
function EffectManager:UnRegisterEffect(effect)
  if effect ~= nil then
    self.effects[effect.id] = nil
    if self.autoDestroyEffects[effect.id] then
      self:RemoveEffectIdInList(effect.id)
    end
    self.autoDestroyEffects[effect.id] = nil
  end
end
