autoImport("NSceneEffect")
ClientSceneEffect = reusableClass("ClientSceneEffect", NSceneEffect)
ClientSceneEffect.PoolSize = 10
function ClientSceneEffect:Start(pos, effect, oneShot, endCallback, context)
  if self.running then
    return
  end
  self.running = true
  self.endCallback = endCallback
  self.context = context
  local assetEffect = ClientSceneEffect.PlayEffect(pos, effect, oneShot)
  self:SetWeakData(NSceneEffect.AssetEffect, assetEffect)
end
function ClientSceneEffect.PlayEffect(pos, effect, oneShot)
  if oneShot then
    return Asset_Effect.PlayOneShotAt(effect, pos)
  else
    return Asset_Effect.PlayAt(effect, pos)
  end
end
function ClientSceneEffect:DoConstruct(asArray, data)
  self._alive = true
  self:CreateWeakData()
end
function ClientSceneEffect:OnObserverDestroyed(k, obj)
end
