MissionCommand = class("MissionCommand", ReusableObject)
MissionCommand.CallbackEvent = {
  Launch = 1,
  Shutdown = 2,
  Custom = 3
}
function MissionCommand:ctor()
  self.args = {}
end
function MissionCommand:Log()
  LogUtility.Info("MissionCommand")
end
function MissionCommand:_MyselfNoMove()
  return Game.Myself.data:NoMove() or not Game.MapManager.running
end
function MissionCommand:Launch()
  if self.running then
    return
  end
  self.running = true
  self:DoLaunch()
  local args = self.args
  if nil ~= args.callback then
    args.callback(self, MissionCommand.CallbackEvent.Launch)
  end
end
function MissionCommand:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  local args = self.args
  if nil ~= args.callback then
    args.callback(self, MissionCommand.CallbackEvent.Shutdown)
  end
  self:DoShutdown()
  LogUtility.InfoFormat("<color=green>MissionCommand Shutdown: </color>{0}", self.class.__cname)
end
function MissionCommand:Update(time, deltaTime)
  if not self.running then
    return
  end
  if not self:DoUpdate(time, deltaTime) then
    self:Shutdown()
  end
end
function MissionCommand:DoLaunch()
end
function MissionCommand:DoShutdown()
end
function MissionCommand:DoUpdate(time, deltaTime)
end
function MissionCommand:DoConstruct(asArray, args)
  TableUtility.TableShallowCopy(self.args, args)
end
function MissionCommand:DoDeconstruct(asArray)
  TableUtility.TableClear(self.args)
  local args = self.args
  args.callback = nil
end
