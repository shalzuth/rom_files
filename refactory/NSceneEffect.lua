NSceneEffect = reusableClass("NSceneEffect")
NSceneEffect.PoolSize = 20
NSceneEffect.AssetEffect = "AssetEffect"
NSceneEffect.WarnRingEffect = "WarnRingEffect"
local EffectLT_NowCount = 0
local EffectLT_MaxCount = 200
function NSceneEffect.GetEffectGuid(data)
  if data.id ~= nil and data.id ~= 0 then
    return data.id
  end
  return tostring(data.charid) .. "_" .. tostring(data.index)
end
function NSceneEffect.IsEffectOneShot(args)
  return 0 ~= args.times
end
function NSceneEffect:ctor(data)
  NSceneEffect.super.ctor(self)
  self:CreateWeakData()
end
function NSceneEffect:Start(endCallback, context)
  if self.running then
    return
  end
  self.running = true
  self.endCallback = endCallback
  self.context = context
  local args = self.args
  if nil ~= args.delay and args.delay > 0 then
    if EffectLT_NowCount >= EffectLT_MaxCount then
      self:DoStart()
      redlog("TOO MUCH DELAY EFFECT!!!!!!")
      return
    end
    EffectLT_NowCount = EffectLT_NowCount + 1
    self.delayLT = LeanTween.delayedCall(args.delay / 1000, function()
      self:DoStart()
    end)
  else
    self:DoStart()
  end
end
function NSceneEffect.PlayEffect(args, creature)
  if NSceneEffect.IsEffectOneShot(args) then
    local go
    if args.posbind then
      if creature then
        return creature.assetRole:PlayEffectOneShotAt(args.effect, args.effectpos)
      else
        if not args.ignorenavmesh then
          NavMeshUtility.SelfSample(args.pos)
        end
        return Asset_Effect.PlayOneShotAt(args.effect, args.pos)
      end
    else
      return creature.assetRole:PlayEffectOneShotOn(args.effect, args.effectpos)
    end
  elseif args.posbind then
    if creature then
      return creature.assetRole:PlayEffectAt(args.effect, args.effectpos)
    else
      if not args.ignorenavmesh then
        NavMeshUtility.SelfSample(args.pos)
      end
      return Asset_Effect.PlayAt(args.effect, args.pos)
    end
  else
    return creature.assetRole:PlayEffectOn(args.effect, args.effectpos)
  end
end
function NSceneEffect:DoStart()
  if not self.running then
    return
  end
  local args = self.args
  self:CancelDelay()
  local assetEffect, warnRingEffect
  local creature = SceneCreatureProxy.FindCreature(args.charid)
  if args.epbind then
    if nil ~= creature then
      assetEffect = NSceneEffect.PlayEffect(args, creature)
    end
  else
    assetEffect = NSceneEffect.PlayEffect(args)
    assetEffect:ResetLocalEulerAnglesXYZ(0, args.dir, 0)
  end
  if assetEffect and not NSceneEffect.IsEffectOneShot(args) then
    self:CreateWeakData()
    self:SetWeakData(NSceneEffect.AssetEffect, assetEffect)
    if creature and creature.data:GetCamp() == RoleDefines_Camp.ENEMY and self.skillid then
      local skillinfo = Game.LogicManager_Skill:GetSkillInfo(skillid)
      if skillinfo and skillinfo:IsTrap() then
        local size = ReusableTable.CreateTable()
        warnRingEffect = Asset_Effect.CreateWarnRingAt(args.pos, skillinfo:GetWarnRingSize(creature, size), args.dir)
        ReusableTable.DestroyAndClearTable(size)
        self:SetWeakData(NSceneEffect.WarnRingEffect, warnRingEffect)
      end
    end
  elseif not self:FireCallBack() then
    self:Destroy()
  end
end
function NSceneEffect:CancelDelay()
  if nil ~= self.delayLT then
    self.delayLT:cancel()
    self.delayLT = nil
    EffectLT_NowCount = EffectLT_NowCount - 1
  end
end
function NSceneEffect:FireCallBack()
  if nil ~= self.endCallback then
    local call, context = self.endCallback, self.context
    self.endCallback = nil
    self.context = nil
    call(context, self)
    return true
  end
  return false
end
function NSceneEffect:DoConstruct(asArray, data)
  NSceneEffect.super.DoConstruct(self)
  local args = ReusableTable.CreateTable()
  self.args = args
  args.charid = data.charid
  args.index = data.index
  args.epbind = data.epbind
  args.effectpos = data.effectpos
  args.times = data.times
  args.posbind = data.posbind
  args.effect = data.effect
  args.pos = ProtolUtility.S2C_Vector3(data.pos)
  args.delay = data.delay
  args.id = data.id
  args.dir = ServiceProxy.ServerToNumber(data.dir)
  args.skillid = data.skillid
  args.ignorenavmesh = data.ignorenavmesh
  self.guid = NSceneEffect.GetEffectGuid(data)
end
function NSceneEffect:Destroy()
  NSceneEffect.super.Destroy(self)
end
function NSceneEffect:DoDeconstruct(asArray)
  if not self.running then
    return
  end
  self.running = false
  self.endCallback = nil
  self.context = nil
  self:CancelDelay()
  local effect, warnRingEffect
  if self._weakData then
    effect = self:GetWeakData(NSceneEffect.AssetEffect)
    warnRingEffect = self:GetWeakData(NSceneEffect.WarnRingEffect)
  end
  NSceneEffect.super.DoDeconstruct(self)
  if effect then
    effect:Destroy()
  end
  if warnRingEffect then
    warnRingEffect:Destroy()
  end
  if self.args then
    if self.args.pos then
      self.args.pos:Destroy()
      self.args.pos = nil
    end
    ReusableTable.DestroyAndClearTable(self.args)
    self.args = nil
  end
end
