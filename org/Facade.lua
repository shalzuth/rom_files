local Controller = import("...core.Controller")
local Model = import("...core.Model")
local View = import("...core.View")
local Notification = import("..observer.Notification")
local Facade = class("Facade")
function Facade:ctor(key)
  if Facade.instanceMap[key] ~= nil then
    error(Facade.MULTITON_MSG)
  end
  self:initializeNotifier(key)
  Facade.instanceMap[key] = self
  self:initializeFacade()
end
function Facade:initializeFacade()
  self:initializeModel()
  self:initializeController()
  self:initializeView()
end
function Facade.getInstance(key)
  if nil == key then
    return nil
  end
  if Facade.instanceMap[key] == nil then
    Facade.instanceMap[key] = Facade.new(key)
  end
  return Facade.instanceMap[key]
end
function Facade:initializeController()
  if self.controller ~= nil then
    return
  end
  self.controller = Controller.getInstance(self.multitonKey)
end
function Facade:initializeModel()
  if self.model ~= nil then
    return
  end
  self.model = Model.getInstance(self.multitonKey)
end
function Facade:initializeView()
  if self.view ~= nil then
    return
  end
  self.view = View.getInstance(self.multitonKey)
end
function Facade:registerCommand(notificationName, commandClassRef)
  self.controller:registerCommand(notificationName, commandClassRef)
end
function Facade:removeCommand(notificationName)
  self.controller:removeCommand(notificationName)
end
function Facade:hasCommand(notificationName)
  return self.controller:hasCommand(notificationName)
end
function Facade:registerProxy(proxy)
  self.model:registerProxy(proxy)
end
function Facade:retrieveProxy(proxyName)
  return self.model:retrieveProxy(proxyName)
end
function Facade:removeProxy(proxyName)
  local proxy
  if self.model ~= nil then
    proxy = self.model:removeProxy(proxyName)
  end
  return proxy
end
function Facade:hasProxy(proxyName)
  return self.model:hasProxy(proxyName)
end
function Facade:registerMediator(mediator)
  if self.view ~= nil then
    self.view:registerMediator(mediator)
  end
end
function Facade:retrieveMediator(mediatorName)
  return self.view:retrieveMediator(mediatorName)
end
function Facade:removeMediator(mediatorName)
  local mediator
  if self.view ~= nil then
    mediator = self.view:removeMediator(mediatorName)
  end
  return mediator
end
function Facade:hasMediator(mediatorName)
  return self.view:hasMediator(mediatorName)
end
function Facade:sendNotification(notificationName, body, type)
  local notification = Notification.CreateAsTable()
  notification.name, notification.body, notification.type = notificationName, body, type
  self:notifyObservers(notification)
  notification:Destroy()
end
function Facade:notifyObservers(notification)
  if self.view ~= nil then
    self.view:notifyObservers(notification)
  end
end
function Facade:initializeNotifier(key)
  self.multitonKey = key
end
function Facade.hasCore(key)
  return Facade.instanceMap[key] ~= nil
end
function Facade.removeCore(key)
  if Facade.instanceMap[key] == nil then
    return
  end
  Model.removeModel(key)
  View.removeView(key)
  Controller.removeController(key)
  Facade.instanceMap[key] = nil
end
Facade.instanceMap = {}
Facade.MULTITON_MSG = "Facade instance for this Multiton key already constructed!"
return Facade
