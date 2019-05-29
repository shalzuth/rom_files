MyselfDeathCommand = class("MyselfDeathCommand", pm.SimpleCommand)
function MyselfDeathCommand:execute(note)
  helplog("MyselfDeathCommand execute")
  local roleAgent = note.body
  if note.name == MyselfEvent.DeathEnd and Game.Myself:IsDead() then
    GameFacade.Instance:sendNotification(MainViewEvent.ShowOrHide, true)
    local deathCount = 0
    local isPvpMap = SceneProxy.Instance:IsPvPScene()
    if isPvpMap then
      deathCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_PVP_DEAD_COUNT)
    else
      deathCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_RELIVE)
    end
    if deathCount == 1 and isPvpMap then
      ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RETURN)
      return
    end
    self:sendNotification(UIEvent.ShowUI, {
      viewname = "DeathPopView"
    })
    Game.HandUpManager:EndHandUp()
  end
end
