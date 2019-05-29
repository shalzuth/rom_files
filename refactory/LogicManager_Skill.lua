autoImport("SkillHitWorker")
autoImport("SkillComboHitWorker")
autoImport("SkillComboEmitWorker")
autoImport("SubSkillProjectile")
autoImport("SkillLogic_Base")
autoImport("SkillLogic_TargetNone")
autoImport("SkillLogic_TargetCreature")
autoImport("SkillLogic_TargetPoint")
autoImport("SkillInfo")
autoImport("SkillPhaseData")
autoImport("SkillBase")
autoImport("ServerSkill")
autoImport("ClientSkill")
autoImport("SkillFreeCast")
autoImport("SkillFreeCast_Client")
autoImport("SkillSolo")
LogicManager_Skill = class("LogicManager_Skill")
function LogicManager_Skill:ctor()
  self.logicClassMap = {}
  self.logicClassMap.SkillNone = autoImport("SkillLogic_None")
  self.logicClassMap.SkillSelfRange = autoImport("SkillLogic_SelfRange")
  self.logicClassMap.SkillForwardRect = autoImport("SkillLogic_ForwardRect")
  self.logicClassMap.SkillPointRange = autoImport("SkillLogic_PointRange")
  self.logicClassMap.SkillPointRect = autoImport("SkillLogic_PointRect")
  self.logicClassMap.SkillRandomRange = autoImport("SkillLogic_RandomRange")
  self.logicClassMap.SkillLockedTarget = autoImport("SkillLogic_Single")
  self.skillInfoMap = {}
end
function LogicManager_Skill:GetLogic(name)
  return self.logicClassMap[name]
end
function LogicManager_Skill:GetSkillInfo(skillID)
  if skillID == 0 then
    return nil
  end
  local skill = self.skillInfoMap[skillID]
  if skill == nil then
    local data = Table_Skill[skillID]
    if data ~= nil then
      skill = SkillInfo.new(data, self:GetLogic(data.Logic))
      self.skillInfoMap[skillID] = skill
    end
  end
  return skill
end
function LogicManager_Skill:Update(time, deltaTime)
end
