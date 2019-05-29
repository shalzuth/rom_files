local SceneUserNewCommand = class("SceneUserNewCommand", pm.SimpleCommand)
function SceneUserNewCommand:execute(note)
  if note ~= nil and note.name == ServiceEvent.NUserVarUpdate then
    self:NUserVarUpdate(note)
  end
end
function SceneUserNewCommand:NUserVarUpdate(note)
  SceneUserNewProxy.Instance:NUserVarUpdate(note.body)
end
return SceneUserNewCommand
