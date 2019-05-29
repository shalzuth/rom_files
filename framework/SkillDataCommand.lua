local SkillDataCommand = class("SkillDataCommand", pm.SimpleCommand)
function SkillDataCommand:execute(note)
  if note ~= nil then
    if note.name == ServiceEvent.SkillReqSkillData then
      self:ReqSkillData(note)
    elseif note.name == ServiceEvent.SkillSkillUpdate then
      self:Update(note)
    end
  end
end
function SkillDataCommand:ReqSkillData(note)
  SkillProxy.Instance:ServerReInit(note.body)
  self.facade:sendNotification(SkillEvent.SkillUpdate)
  EventManager.Me():PassEvent(SkillEvent.SkillUpdate)
end
function SkillDataCommand:Update(note)
  SkillProxy.Instance:Update(note.body)
  self.facade:sendNotification(SkillEvent.SkillUpdate)
  EventManager.Me():PassEvent(SkillEvent.SkillUpdate)
end
return SkillDataCommand
