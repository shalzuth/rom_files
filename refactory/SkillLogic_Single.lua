local SelfClass = {}
setmetatable(SelfClass, {
  __index = SkillLogic_TargetCreature
})
local SuperClass = SkillLogic_TargetCreature
return SelfClass
