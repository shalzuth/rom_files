local AskUseSkillCommand = class("AskUseSkillCommand", pm.SimpleCommand)
function AskUseSkillCommand:execute(note)
  local skillID = note.body
  local target
  if type(skillID) == "table" then
    target = skillID.target
    skillID = skillID.skill
  end
  helplog("AskUseSkillCommand ", skillID, target)
  FunctionSkill.Me():TryUseSkill(skillID, target)
end
return AskUseSkillCommand
