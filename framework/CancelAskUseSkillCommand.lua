CancelAskUseSkillCommand = class("CancelAskUseSkillCommand",pm.SimpleCommand)

function CancelAskUseSkillCommand:execute(note)
	local skillID = note.body
	FunctionSkill.Me():CancelSkill(skillID)
end