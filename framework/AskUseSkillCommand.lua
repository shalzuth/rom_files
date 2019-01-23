local AskUseSkillCommand = class("AskUseSkillCommand",pm.SimpleCommand)

function AskUseSkillCommand:execute(note)
	local skillID = note.body
	local target = nil
	if(type(skillID)=="table") then
		target = skillID.target
		skillID = skillID.skill
	end
	FunctionSkill.Me():TryUseSkill(skillID,target)
end


return AskUseSkillCommand