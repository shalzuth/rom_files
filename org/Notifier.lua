local Facade = import("..facade.Facade")
local Notifier = class("Notifier")
function Notifier:ctor()
end
function Notifier:sendNotification(notificationName, body, type)
  local facade = self:getFacade()
  if facade ~= nil then
    facade:sendNotification(notificationName, body, type)
  end
end
function Notifier:initializeNotifier(key)
  self.multitonKey = key
  self.facade = self:getFacade()
end
function Notifier:getFacade()
  if self.multitonKey == nil then
    error(Notifier.MULTITON_MSG)
  end
  return Facade.getInstance(self.multitonKey)
end
Notifier.MULTITON_MSG = "multitonKey for this Notifier not yet initialized!"
return Notifier
