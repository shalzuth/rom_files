FunctionSkill = class("FunctionSkill")
function FunctionSkill.Me()
  if nil == FunctionSkill.me then
    FunctionSkill.me = FunctionSkill.new()
  end
  return FunctionSkill.me
end
function FunctionSkill:ctor()
  EventManager.Me():AddEventListener(SkillEvent.SkillCastBegin, self.HandleStartProcess, self)
  EventManager.Me():AddEventListener(SkillEvent.SkillCastEnd, self.HandleStopProcess, self)
end
function FunctionSkill:HandleStartProcess(data)
  local creature = data.data
  if Game.Myself and Game.Myself == creature then
    self.isCasting = true
  end
end
function FunctionSkill:HandleStopProcess(data)
  local creature = data.data
  if Game.Myself and Game.Myself == creature then
    self.isCasting = false
  end
end
function FunctionSkill:TryUseSkill(skillIDAndLevel, target, noSearch)
  if self.isCasting then
    return
  end
  local myself = Game.Myself
  local isHanding, handOther = myself:IsHandInHand()
  if isHanding and not handOther then
    return
  end
  local fit, requiredSkill = FunctionSkillEnableCheck.Me():LearnedSkillCheck(skillIDAndLevel)
  if fit == false and requiredSkill ~= nil then
    requiredSkill = requiredSkill * 1000 + 1
    MsgManager.ShowMsgByIDTable(355, {
      Table_Skill[requiredSkill].NameZh
    })
    return
  end
  local fitSpecial, specialItem, count, needMsg = SkillProxy.Instance:HasFitSpecialCost(skillIDAndLevel)
  if not SkillProxy.Instance:HasEnoughSp(skillIDAndLevel) then
    MsgManager.ShowMsgByIDTable(1101)
  elseif not SkillProxy.Instance:HasEnoughHp(skillIDAndLevel) then
    MsgManager.ShowMsgByIDTable(609)
  elseif not fitSpecial then
    if needMsg then
      MsgManager.ShowMsgByIDTable(3052, {
        specialItem.NameZh,
        count
      })
    end
  else
    local lockedTarget = myself:GetLockTarget()
    local isUseSkill = true
    if myself.data.userdata:Get(UDEnum.NORMAL_SKILL) == skillIDAndLevel then
      myself:Client_UseSkill(skillIDAndLevel, lockedTarget, nil, nil, noSearch)
    else
      local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
      local skillType = skillInfo:GetSkillType()
      if skillType == SkillType.Function then
        self:HandleFunctionSkill(skillInfo)
      else
        local skillTargetType = skillInfo:GetTargetType(myself)
        if skillTargetType ~= nil then
          if skillTargetType == SkillTargetType.None then
            isUseSkill = myself:Client_UseSkill(skillIDAndLevel, nil, nil, nil, noSearch)
          elseif skillTargetType == SkillTargetType.Creature then
            if target then
              myself:Client_UseSkill(skillIDAndLevel, target, nil, nil, noSearch)
            else
              myself:Client_UseSkill(skillIDAndLevel, lockedTarget, nil, nil, noSearch)
            end
          elseif skillTargetType == SkillTargetType.Point then
            FunctionSkillTargetPointLauncher.Me():Shutdown()
            FunctionSkillTargetPointLauncher.Me():Launch(skillIDAndLevel)
          end
        else
        end
      end
    end
    if not isUseSkill then
      MsgManager.ShowMsgByID(609)
    end
  end
end
function FunctionSkill:CancelSkill(skillIDAndLevel)
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)
  local skillTargetType = skillInfo:GetTargetType(Game.Myself)
  if skillTargetType == nil or skillTargetType == SkillTargetType.None then
  elseif skillTargetType == SkillTargetType.Creature then
  else
    if skillTargetType == SkillTargetType.Point then
      FunctionSkillTargetPointLauncher.Me():Shutdown()
    else
    end
  end
end
function FunctionSkill:HandleFunctionSkill(skillInfo)
  local logicParam = skillInfo.logicParam
  if logicParam ~= nil then
    if logicParam.shortcutID then
      FuncShortCutFunc.Me():CallByID(logicParam.shortcutID)
    elseif logicParam.msgid then
      MsgManager.ShowMsgByIDTable(logicParam.msgid)
    end
  else
    helplog(skillInfo.staticData.id, "\230\178\161\230\156\137\233\133\141Logicparam")
  end
end
