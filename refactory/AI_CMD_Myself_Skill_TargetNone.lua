local SkillCMD = {}
setmetatable(SkillCMD, {__index = AI_CMD_Myself_Skill_Run})

function SkillCMD.Start(self, time, deltaTime, creature)
	return AI_CMD_Myself_Skill_Run.Start(self, time, deltaTime, creature, nil, nil, self.args[7])
end

function SkillCMD.ToString()
	return "AI_CMD_Myself_Skill_TargetNone",SkillCMD
end

return SkillCMD