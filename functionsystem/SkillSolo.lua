SkillSolo = class("SkillSolo", ReusableObject)
SkillSolo.PoolSize = 5
local VectorZero = LuaVector3.zero
function SkillSolo.Create()
  return ReusableObject.Create(SkillSolo, true)
end
function SkillSolo:StartSolo(creature, skillid)
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillid)
  if skillInfo then
    self.soloAction = skillInfo:GetAttackAction(creature)
  else
    self.soloAction = nil
  end
  creature:Logic_PlayAction_Idle()
  self:PlaySEOn(creature, skillid)
end
function SkillSolo:EndSolo(creature)
  local action = self.soloAction
  self.soloAction = nil
  if creature.assetRole:IsPlayingAction(action) then
    creature:Logic_PlayAction_Idle()
  end
  self:StopSEOn()
end
function SkillSolo:PlaySEOn(creature, skillid)
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillid)
  if skillInfo == nil then
    return
  end
  local sePath = skillInfo:GetBgSEPath()
  if sePath == nil then
    return
  end
  if self.audioSource == nil then
    self.audioSource = AudioUtility.GetOneShotAudioSource()
    if self.audioSource == nil then
      return
    end
    local audioTransform = self.audioSource.transform
    audioTransform.parent = creature.assetRole.completeTransform
    audioTransform.localPosition = VectorZero
  end
  local resPath = ResourcePathHelper.AudioSE(sePath)
  AudioUtility.PlayOn_Path(resPath, self.audioSource)
  self.audioSource.loop = true
  FunctionBGMCmd.Me():StartSolo()
end
function SkillSolo:StopSEOn()
  if self.audioSource ~= nil then
    FunctionBGMCmd.Me():EndSolo()
  end
  self:ClearAudioSource()
end
function SkillSolo:ClearAudioSource()
  if self.audioSource ~= nil then
    self.audioSource:Stop()
    self.audioSource = nil
  end
end
function SkillSolo:GetSoloAction()
  return self.soloAction
end
function SkillSolo:DoConstruct(asArray, args)
end
function SkillSolo:DoDeconstruct(asArray)
  self.soloAction = nil
  self:ClearAudioSource()
end
