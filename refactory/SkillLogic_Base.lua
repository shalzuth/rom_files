SkillLogic_Base = {}
local DefaultActionCast = "reading"
local DefaultActionAttack = "attack"
local DamageType = CommonFun.DamageType
local FindCreature = SceneCreatureProxy.FindCreature
local ArrayPushBack = TableUtility.ArrayPushBack
local ArrayClear = TableUtility.ArrayClear
local ArrayUnique = TableUtility.ArrayUnique
local _RoleDefines_Camp = RoleDefines_Camp
local tempVector3 = LuaVector3.zero
local tempCreatureArray = {}
local tempCalcDamageParams = {
  skillIDAndLevel = 0,
  hitedIndex = 0,
  hitedCount = 0,
  pvpMap = false
}
local tempComboEmitParams = {
  [1] = 0,
  [2] = 0,
  [3] = nil,
  [4] = nil,
  [5] = nil,
  [6] = 0
}
function SkillLogic_Base.error(...)
  errorLog(...)
end
local CreateSearchTargetInfo = ReusableTable.CreateSearchTargetInfo
local DestroySearchTargetInfo = ReusableTable.DestroySearchTargetInfo
local CreateArray = ReusableTable.CreateArray
local DestroyArray = ReusableTable.DestroyArray
local tempSearchTargetArgs = {
  [1] = {},
  [2] = LuaVector3.zero,
  [3] = nil,
  [4] = nil,
  [5] = nil,
  [6] = 0,
  [7] = nil,
  [8] = nil
}
local CheckDistanceInRange = function(targetCreature, args, distance)
  return distance <= args[6]
end
local CheckDistanceInRect = function(targetCreature, args, distance)
  return args[7]:Contains(targetCreature:GetPosition())
end
local AddTarget = function(targetCreature, args)
  if targetCreature.data:NoAccessable() and not args[3]:TargetIncludeHide() then
    return
  end
  local distance = VectorUtility.DistanceXZ(args[2], targetCreature:GetPosition())
  if not args[8](targetCreature, args, distance) then
    return
  end
  if not args[3]:CheckTarget(args[4], targetCreature) then
    return
  end
  if nil ~= args[5] and not args[5](targetCreature, args) then
    return
  end
  local targetInfo = CreateSearchTargetInfo()
  targetInfo[1] = targetCreature
  targetInfo[2] = distance
  ArrayPushBack(args[1], targetInfo)
end
local SearchTarget = function(targets, sortComparator)
  local args = tempSearchTargetArgs
  SceneCreatureProxy.ForEachCreature(AddTarget, args)
  local targetInfos = args[1]
  local targetCount = #targetInfos
  if targetCount > 0 then
    if nil ~= sortComparator then
      table.sort(targetInfos, sortComparator)
    end
    local j = #targets + 1
    for i = targetCount, 1, -1 do
      local targetInfo = targetInfos[i]
      targets[j] = targetInfo[1]
      DestroySearchTargetInfo(targetInfo)
      targetInfos[i] = nil
      j = j + 1
    end
  end
  args[3] = nil
  args[4] = nil
  args[5] = nil
  args[10] = nil
  return targetCount
end
local CheckTarget = function(targetCreature, args)
  return args[1]:CheckTarget(args[2], targetCreature)
end
function SkillLogic_Base.SortComparator_Distance(targetInfo1, targetInfo2)
  return targetInfo1[2] > targetInfo2[2]
end
function SkillLogic_Base.SortComparator_TeamFirstDistance(targetInfo1, targetInfo2)
  local inMyTeam1 = targetInfo1[1]:IsInMyTeam()
  local inMyTeam2 = targetInfo2[1]:IsInMyTeam()
  if inMyTeam1 == inMyTeam2 then
    return targetInfo1[2] > targetInfo2[2]
  end
  return inMyTeam2
end
function SkillLogic_Base.SortComparator_HatredFirstDistance(targetInfo1, targetInfo2)
  local hatred1 = targetInfo1[1]:IsHatred()
  local hatred2 = targetInfo2[1]:IsHatred()
  if hatred1 == hatred2 then
    return targetInfo1[2] > targetInfo2[2]
  end
  return hatred2
end
function SkillLogic_Base.SearchTargetInRange(targets, p, range, skillInfo, creature, filter, sortComparator)
  local args = tempSearchTargetArgs
  args[2]:Set(p[1], p[2], p[3])
  args[3] = skillInfo
  args[4] = creature
  args[5] = filter
  args[6] = range
  args[8] = CheckDistanceInRange
  return SearchTarget(targets, sortComparator)
end
function SkillLogic_Base.SearchTargetInRect(targets, p, offset, size, angleY, skillInfo, creature, filter, sortComparator)
  local args = tempSearchTargetArgs
  args[2]:Set(p[1], p[2], p[3])
  args[3] = skillInfo
  args[4] = creature
  args[5] = filter
  local rectObject = Game.Object_Rect
  rectObject:PlaceTo(p, angleY or 0)
  if nil ~= offset then
    rectObject.offset = offset
  else
    rectObject.offset = LuaGeometry.Const_V2_zero
  end
  rectObject.size = size
  rectObject:PlaceTo(p, angleY or 0)
  if nil ~= offset then
    rectObject.offset = offset
  else
    rectObject.offset = LuaGeometry.Const_V2_zero
  end
  rectObject.size = size
  args[7] = rectObject
  args[8] = CheckDistanceInRect
  return SearchTarget(targets, sortComparator)
end
function SkillLogic_Base.CalcDamageLabelParams(sourcePosition, targetPosition, damageType, targetCreature)
  local labelType
  if DamageType.Miss == damageType or DamageType.Barrier == damageType then
    labelType = HurtNumType.Miss
  else
    labelType = HurtNumType.DamageNum_L
    local atRight = ROUtils.IsAtRightOnScreen(sourcePosition, targetPosition)
    if atRight then
      labelType = HurtNumType.DamageNum_R
    end
  end
  local labelColorType
  if DamageType.Normal_Sp == damageType then
    labelColorType = HurtNumColorType.Normal_Sp
  else
    labelColorType = HurtNumColorType.Normal
    if nil ~= targetCreature then
      if Game.Myself == targetCreature then
        labelColorType = HurtNumColorType.Player
      else
        local myTeam = TeamProxy.Instance.myTeam
        if nil ~= myTeam then
          local teamMember = myTeam:GetMemberByGuid(targetCreature.data.id)
          if nil ~= teamMember then
            labelColorType = HurtNumColorType.Player
          end
        end
      end
    end
  end
  return labelType, labelColorType
end
function SkillLogic_Base.AllowSelfEffect(creature)
  if nil == creature then
    return false
  end
  if not creature:IsDressed() then
    return false
  end
  if not creature:IsCullingVisible() or 0 < creature:GetCullingDistanceLevel() then
    return false
  end
  return true
end
function SkillLogic_Base.AllowTargetEffect(creature, targetCreature)
  if nil == targetCreature then
    return false
  end
  if targetCreature == Game.Myself then
    return true
  end
  if not targetCreature:IsDressed() then
    return false
  end
  if not targetCreature:IsCullingVisible() or 0 < targetCreature:GetCullingDistanceLevel() then
    return false
  end
  if nil ~= targetCreature.data and FunctionPlayerUI.Me():IsMaskHurtNum(targetCreature.data.id) then
    return false
  end
  return true
end
function SkillLogic_Base.ShowDamage_Single(damageType, damage, position, labelType, labelColorType, creature, skillInfo)
  if not SkillLogic_Base.AllowTargetEffect(nil, creature) then
    return
  end
  if DamageType.None == damageType or DamageType.Block == damageType or DamageType.AutoBlock == damageType or DamageType.WeaponBlock == damageType then
    return
  end
  local damageStr
  local crit = HurtNum_CritType.None
  if DamageType.Miss == damageType or CommonFun.DamageType.Barrier == damageType then
    damageStr = "Miss"
  elseif DamageType.Treatment == damageType then
    if damage <= 0 then
      return
    end
    labelType = HurtNumType.HealNum
    labelColorType = HurtNumColorType.Treatment
    damageStr = tostring(damage)
  elseif DamageType.Treatment_Sp == damageType then
    if damage <= 0 then
      return
    end
    labelType = HurtNumType.HealNum
    labelColorType = HurtNumColorType.Treatment_Sp
    damageStr = tostring(damage)
  elseif DamageType.Crit == damageType then
    if damage <= 0 then
      return
    end
    labelColorType = HurtNumColorType.Combo
    damageStr = tostring(damage)
    if nil ~= skillInfo and skillInfo:ShowMagicCrit(creature) then
      crit = HurtNum_CritType.MAtk
    else
      crit = HurtNum_CritType.PAtk
    end
  else
    if damage <= 0 then
      return
    end
    damageStr = tostring(damage)
  end
  SceneUIManager.Instance:ShowDynamicHurtNum(position, damageStr, labelType, labelColorType, crit)
end
function SkillLogic_Base.CalcDamage(skillID, creature, targetCreature, targetIndex, targetCount)
  tempCalcDamageParams.skillIDAndLevel = skillID
  tempCalcDamageParams.hitedIndex = targetIndex
  tempCalcDamageParams.hitedCount = targetCount
  tempCalcDamageParams.pvpMap = Game.MapManager:IsPVPMode()
  local damage, damageType, shareDamageInfos = CommonFun.CalcDamage(creature.data, targetCreature.data, tempCalcDamageParams, SkillLogic_Base)
  damage = math.abs(damage)
  return damageType, damage, shareDamageInfos
end
local tempDamageArray = {}
function SkillLogic_Base.SplitDamage(damage, damageCount, damageArray)
  if damage > 1 and damageCount > 1 then
    local partDamage = math.max(math.floor(damage / damageCount), 1)
    for i = 1, damageCount - 1 do
      damageArray[i] = partDamage
    end
    damageArray[damageCount] = math.max(damage - partDamage * (damageCount - 1), 1)
    return damageCount
  else
    damageArray[1] = damage
    return 1
  end
end
function SkillLogic_Base.GetSplitDamage(damage, damageIndex, damageCount)
  damageCount = SkillLogic_Base.SplitDamage(damage, damageCount, tempDamageArray)
  if damageIndex > damageCount then
    damageIndex = damageCount
  end
  return tempDamageArray[damageIndex]
end
function SkillLogic_Base.GetComboEmitParams()
  return tempComboEmitParams
end
function SkillLogic_Base.HitTargetByPhaseData(phaseData, sourceCreatureGUID)
  local targetCount = phaseData:GetTargetCount()
  if targetCount <= 0 then
    return
  end
  if nil ~= sourceCreatureGUID and 0 ~= sourceCreatureGUID then
    local sourceCreature = FindCreature(sourceCreatureGUID)
    if nil ~= sourceCreature then
      sourceCreature.skill:OnDelayHit(sourceCreature, phaseData)
    end
  end
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(phaseData:GetSkillID())
  local hitWorker = SkillHitWorker.Create()
  hitWorker:Init(skillInfo, phaseData:GetPosition(), sourceCreatureGUID, 0)
  for i = 1, targetCount do
    hitWorker:AddTarget(phaseData:GetTarget(i))
  end
  hitWorker:Work(1, 1)
  hitWorker:Destroy()
end
function SkillLogic_Base.EmitFire(creature, targetCreature, targetPosition, fireEP, emitParams, hitWorker, forceSingleDamage, emitIndex, emitCount)
  local fireEPTransform = creature.assetRole:GetEPOrRoot(fireEP)
  tempVector3:Set(LuaGameObject.GetPosition(fireEPTransform))
  local args = SubSkillProjectile.GetArgs(emitParams, hitWorker, forceSingleDamage, tempVector3, targetPosition, emitIndex, emitCount)
  Game.SkillWorkerManager:CreateWorker_SubSkillProjectile(args)
  SubSkillProjectile.ClearArgs(args)
end
function SkillLogic_Base:Cast(creature)
  local assetRole = creature.assetRole
  local skillInfo = self.info
  SkillLogic_Base.CastPlayAction(self, creature)
  local effectPath = skillInfo:GetCastEffectPath(creature)
  if nil ~= effectPath then
    local effect = assetRole:PlayEffectOn(effectPath, 0)
    self:AddEffect(effect)
  end
  local sePath = skillInfo:GetCastSEPath(creature)
  if nil ~= sePath then
    local se = assetRole:PlaySEOn(sePath)
    self:AddSE(se)
  end
  return true
end
function SkillLogic_Base:CastPlayAction(creature)
  local actionName = self.info:GetCastAction(creature)
  if not creature.assetRole:HasActionRaw(actionName) then
    actionName = DefaultActionCast
  end
  creature:Logic_PlayAction_Simple(actionName)
end
function SkillLogic_Base:FreeCast(creature)
  return SkillLogic_Base.Cast(self, creature)
end
function SkillLogic_Base:Attack(creature)
  local logicTransform = creature.logicTransform
  local assetRole = creature.assetRole
  local skillInfo = self.info
  local attackSpeed = 1
  local actionPlayed = false
  if not skillInfo:NoAction(creature) then
    local hasOriginAction = true
    local actionName = skillInfo:GetAttackAction(creature)
    if not assetRole:HasAction(actionName) and not assetRole:HasActionIgnoreMount(actionName) and not assetRole:HasActionRaw(actionName) then
      actionName = DefaultActionAttack
      hasOriginAction = false
    end
    if hasOriginAction or assetRole:HasActionRaw(actionName) then
      if creature.data:GetAttackSkillIDAndLevel() == skillInfo:GetSkillID() then
        attackSpeed = creature.data:GetAttackSpeed_Adjusted() * logicTransform:GetFastForwardSpeed()
        local attackDuration = 1 / attackSpeed
        attackSpeed = attackSpeed * ((attackDuration + 0.11) / attackDuration)
      else
        attackSpeed = logicTransform:GetFastForwardSpeed()
      end
      local playActionParams = Asset_Role.GetPlayActionParams(actionName, nil, attackSpeed)
      playActionParams[6] = true
      playActionParams[7] = SkillLogic_Base.OnAttackFinished
      playActionParams[8] = self.instanceID
      actionPlayed = creature:Logic_PlayAction(playActionParams)
      Asset_Role.ClearPlayActionParams(playActionParams)
      local attackEP = skillInfo:GetAttackEP(creature)
      local effectPath = skillInfo:GetAttackEffectPath(creature)
      if nil ~= effectPath then
        local effect
        if skillInfo:AttackEffectOnRole(creature) then
          effect = assetRole:PlayEffectOneShotOn(effectPath, attackEP)
        else
          effect = assetRole:PlayEffectOneShotAt(effectPath, attackEP)
          effect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
        end
        effect:SetPlaybackSpeed(attackSpeed)
      end
      local sePath = skillInfo:GetAttackSEPath(creature)
      if nil ~= sePath then
        assetRole:PlaySEOneShotAt(sePath, attackEP)
      end
    end
  end
  if not skillInfo:NoAttackEffectMove(creature) then
    local specialEffects = skillInfo:GetSpecialAttackEffects(creature)
    if nil ~= specialEffects then
      for i = 1, #specialEffects do
        local specialEffect = specialEffects[i]
        if 1 == specialEffect.type then
          local dirMoveAngleY
          local dirMoveDistance = specialEffect.distance
          local dirMoveSpeed = specialEffect.speed * attackSpeed
          local skillAngleY = self.phaseData:GetAngleY()
          if nil == skillAngleY then
            skillAngleY = logicTransform.currentAngleY
          end
          if "back" == specialEffect.direction then
            LogUtility.Info("back")
            dirMoveAngleY = NumberUtility.Repeat(skillAngleY + 180, 360)
          elseif "forward" == specialEffect.direction then
            dirMoveAngleY = skillAngleY
          end
          logicTransform:ExtraDirMove(dirMoveAngleY, dirMoveDistance, dirMoveSpeed, SkillLogic_Base.CheckExtraDirMove, skillInfo:GetSkillID())
        elseif 2 == specialEffect.type then
          CameraAdditiveEffectManager.Me():StartShake(specialEffect.range, specialEffect.time, specialEffect.curve)
        end
      end
    end
  end
  if actionPlayed then
    self.fireCount = skillInfo:GetFireCount(creature)
  else
    self.fireCount = 1
  end
  return true, actionPlayed, attackSpeed
end
function SkillLogic_Base.CheckExtraDirMove(logicTransform, arg)
  if logicTransform ~= nil then
    ServiceSkillProxy.Instance:CallSyncDestPosSkillCmd(arg, logicTransform.currentPosition)
  end
end
function SkillLogic_Base:CreateHitMultiTargetWorker(creature, phaseData, assetRole, skillInfo)
  local hitWorker = SkillHitWorker.Create()
  hitWorker:Init(skillInfo, creature:GetPosition(), creature.data and creature.data.id or 0, assetRole:GetWeaponID())
  hitWorker:SetForceEffectPath(skillInfo:GetMainHitEffectPath(creature))
  local targetCount = phaseData:GetTargetCount()
  if targetCount > 0 then
    for i = 1, targetCount do
      local targetGUID, damageType, damage, shareDamageInfos = phaseData:GetTarget(i)
      hitWorker:AddTarget(targetGUID, damageType, damage, shareDamageInfos, self:GetComboDamageLabel(i))
    end
  end
  return hitWorker
end
local DoEmit = function(self, creature, targetCreature, damageType, damage, fireEP, emitParams, hitWorker)
  if emitParams.single_fire then
    SkillLogic_Base.EmitFire(creature, targetCreature, nil, fireEP, emitParams, hitWorker, false, 1, 1)
  else
    local skillInfo = hitWorker:GetSkillInfo()
    local emitCount = skillInfo:GetDamageCount(creature, targetCreature, damageType, damage)
    if emitCount > 1 then
      local targetCount = hitWorker:GetTargetCount()
      for i = 1, targetCount do
        hitWorker:SetTargetComboDamageLabel(i, self:CreateComboDamageLabel(i))
      end
      local comboEmitArgs = SkillComboEmitWorker.GetArgs()
      comboEmitArgs[1] = creature.data.id
      comboEmitArgs[2] = fireEP
      comboEmitArgs[3] = targetCreature
      comboEmitArgs[4] = emitParams
      comboEmitArgs[5] = hitWorker
      comboEmitArgs[6] = emitCount
      Game.SkillWorkerManager:CreateWorker_ComboEmit(comboEmitArgs)
      SkillComboEmitWorker.ClearArgs(comboEmitArgs)
    else
      SkillLogic_Base.EmitFire(creature, targetCreature, nil, fireEP, emitParams, hitWorker, true, 1, 1)
    end
  end
end
local Emit = function(self, creature, phaseData, assetRole, skillInfo, fireEP, emitParams)
  local targetCount = phaseData:GetTargetCount()
  if targetCount <= 0 then
    return
  end
  local targetGUID, damageType, damage = phaseData:GetTarget(1)
  local targetCreature = FindCreature(targetGUID)
  if nil == targetCreature then
    return
  end
  if emitParams.multi_target then
  else
    local hitWorker = SkillLogic_Base.CreateHitMultiTargetWorker(self, creature, phaseData, assetRole, skillInfo)
    hitWorker:AddRef()
    DoEmit(self, creature, targetCreature, damageType, damage, fireEP, emitParams, hitWorker)
    hitWorker:SubRef()
  end
end
function SkillLogic_Base:Fire(creature)
  local phaseData = self.phaseData
  local targetCount = phaseData:GetTargetCount()
  if targetCount > 0 then
    local assetRole = creature.assetRole
    local fireIndex = self.fireIndex
    local fireCount = self.fireCount
    local skillInfo = self.info
    local fireEP = skillInfo:GetFireEP(creature)
    local effectPath = skillInfo:GetFireEffectPath(creature)
    if nil ~= effectPath then
      local effect = assetRole:PlayEffectOneShotAt(effectPath, fireEP)
      effect:ResetLocalEulerAnglesXYZ(0, creature:GetAngleY(), 0)
    end
    local sePath = skillInfo:GetFireSEPath(creature)
    if nil ~= sePath then
      assetRole:PlaySEOneShotAt(sePath, fireEP)
    end
    local emitParams = skillInfo:GetEmitParams(creature)
    if nil ~= emitParams then
      Emit(self, creature, phaseData, assetRole, skillInfo, fireEP, emitParams)
    else
      local hitWorker = SkillLogic_Base.CreateHitMultiTargetWorker(self, creature, phaseData, assetRole, skillInfo)
      hitWorker:Work(fireIndex, fireCount)
      hitWorker:Destroy()
    end
  end
end
function SkillLogic_Base:Update_Cast(time, deltaTime, creature)
  return true
end
function SkillLogic_Base:Update_Attack(time, deltaTime, creature)
  return true
end
function SkillLogic_Base.OnAttackFinished(creatureGUID, skillInstanceID)
  local creature = FindCreature(creatureGUID)
  if nil == creature then
    return
  end
  if creature.skill.instanceID ~= skillInstanceID then
    return
  end
  creature.skill:End(creature)
end
function SkillLogic_Base:Client_PreUpdate_Cast(time, deltaTime, creature)
  return true
end
function SkillLogic_Base:Client_PreUpdate_FreeCast(time, deltaTime, creature)
  return true
end
function SkillLogic_Base:Client_PreUpdate_Attack(time, deltaTime, creature)
  return true
end
function SkillLogic_Base:Client_DeterminTargets(creature)
  self.phaseData:ClearTargets()
  if self.info:NoSelect(creature) then
    return
  end
  local maxCount = self.info:GetTargetsMaxCount(creature)
  if maxCount <= 0 then
    return
  end
  local skillInfo = self.info
  if skillInfo:TargetIncludeSelf(creature) then
    ArrayPushBack(tempCreatureArray, creature)
  end
  skillInfo.LogicClass.Client_DoDeterminTargets(self, creature, tempCreatureArray, maxCount)
  local teamRange = skillInfo:TargetIncludeTeamRange(creature)
  if teamRange > 0 then
    local myTeam = TeamProxy.Instance.myTeam
    if nil ~= myTeam then
      local args = CreateArray()
      ArrayPushBack(args, skillInfo)
      ArrayPushBack(args, creature)
      myTeam:GetMemberCreatureArrayInRange(teamRange, tempCreatureArray, CheckTarget, args)
      DestroyArray(args)
    end
  end
  local targetCount = #tempCreatureArray
  if targetCount > 0 then
    ArrayUnique(tempCreatureArray)
    targetCount = #tempCreatureArray
    if maxCount < targetCount then
      targetCount = maxCount
    end
    local removedCount = 0
    for i = targetCount, 1, -1 do
      local targetCreature = tempCreatureArray[i]
      if targetCreature.data:NoPicked() or targetCreature.data:NoAttacked() then
        table.remove(tempCreatureArray, i)
        removedCount = removedCount + 1
      elseif targetCreature.data:CanNotBeSkillTargetByEnemy() and targetCreature.data:GetCamp() == _RoleDefines_Camp.ENEMY then
        table.remove(tempCreatureArray, i)
        removedCount = removedCount + 1
      end
    end
    targetCount = targetCount - removedCount
    if targetCount > 0 then
      local skillID = skillInfo:GetSkillID()
      local phaseData = self.phaseData
      for i = 1, targetCount do
        local targetCreature = tempCreatureArray[i]
        local damageType, damage, shareDamageInfos = SkillLogic_Base.CalcDamage(skillID, creature, targetCreature, i, targetCount)
        phaseData:AddTarget(targetCreature.data.id, damageType, damage, shareDamageInfos)
      end
    end
    ArrayClear(tempCreatureArray)
  end
end
function SkillLogic_Base:Client_DoDeterminTargets(creature, creatureArray, maxCount)
  return 0
end
