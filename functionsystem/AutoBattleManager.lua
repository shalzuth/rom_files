autoImport("AutoQuickItems")
AutoBattleManager = class("AutoBattleManager")
AutoBattleManagerEvent = {
  StateChanged = "E_AutoBattleManager_StateChanged"
}
function AutoBattleManager:ctor(defaultController)
  self.on = false
  self.defaultController = defaultController
  self.controller = defaultController
end
function AutoBattleManager:SetController(newController)
  local oldController = self.controller
  if oldController == newController then
    return
  end
  if nil ~= newController then
    self.controller = newController
  else
    self.controller = self.defaultController
  end
  if nil ~= oldController then
    oldController:AutoBattleLost()
  end
  if self.on then
    self.controller:AutoBattleOn()
  else
    self.controller:AutoBattleOff()
  end
end
function AutoBattleManager:ClearController(controller, off)
  if self.controller ~= controller then
    return
  end
  if off then
    self:AutoBattleOff()
  end
  self:SetController(nil)
end
function AutoBattleManager:AutoBattleOn()
  if self.on then
    return
  end
  self.on = true
  self.controller:AutoBattleOn()
  local eventManager = EventManager.Me()
  eventManager:DispatchEvent(AutoBattleManagerEvent.StateChanged, self)
  self:NotifyState()
end
function AutoBattleManager:AutoBattleOff()
  if not self.on then
    return
  end
  self.on = false
  self.controller:AutoBattleOff()
  local eventManager = EventManager.Me()
  eventManager:DispatchEvent(AutoBattleManagerEvent.StateChanged, self)
  self:NotifyState()
end
function AutoBattleManager:NotifyState()
  ServiceUserEventProxy.Instance:CallSwitchAutoBattleUserEvent(self.on)
end
