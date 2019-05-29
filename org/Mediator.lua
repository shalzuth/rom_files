local Notifier = import("..observer.Notifier")
local Mediator = class("Mediator", Notifier)
function Mediator:ctor(mediatorName, viewComponent)
  self.mediatorName = mediatorName or Mediator.NAME
  self.viewComponent = viewComponent
end
Mediator.NAME = "Mediator"
function Mediator:getMediatorName()
  return self.mediatorName
end
function Mediator:setViewComponent(viewComponent)
  self.viewComponent = viewComponent
end
function Mediator:getViewComponent()
  return self.viewComponent
end
function Mediator:listNotificationInterests()
  return {}
end
function Mediator:handleNotification(notification)
end
function Mediator:onRegister()
end
function Mediator:onRemove()
end
return Mediator
