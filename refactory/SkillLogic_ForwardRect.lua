local SelfClass = {}
setmetatable(SelfClass, {
  __index = SkillLogic_TargetNone
})
local SuperClass = SkillLogic_TargetNone
local tempVector2 = LuaVector2.zero
local tempVector2_1 = LuaVector2.zero
function SelfClass:Client_DoDeterminTargets(creature, creatureArray, maxCount)
  SuperClass.Client_DoDeterminTargets(self, creature, creatureArray)
  local skillInfo = self.info
  skillInfo:GetTargetForwardRect(creature, tempVector2, tempVector2_1)
  local p = creature:GetPosition()
  local angleY = creature:GetAngleY()
  SkillLogic_Base.SearchTargetInRect(creatureArray, p, tempVector2, tempVector2_1, angleY, skillInfo, creature)
end
return SelfClass
