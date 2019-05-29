autoImport("ObserverList")
local Observer = import("..patterns.observer.Observer")
local View = class("View")
function View:ctor(key)
  if View.instanceMap[key] ~= nil then
    error(View.MULTITON_MSG)
  end
  self.multitonKey = key
  View.instanceMap[self.multitonKey] = self
  self.mediatorMap = {}
  self.observerMap = {}
  self:initializeView()
end
function View:initializeView()
end
function View.getInstance(key)
  if nil == key then
    return nil
  end
  if View.instanceMap[key] == nil then
    return View.new(key)
  else
    return View.instanceMap[key]
  end
end
function View:registerObserver(notificationName, observer)
  if self.observerMap[notificationName] ~= nil then
    self.observerMap[notificationName]:AddObserver(observer)
  else
    self.observerMap[notificationName] = ObserverList.new(notificationName)
    self.observerMap[notificationName]:AddObserver(observer)
  end
end
function View:notifyObservers(notification)
  local list = self.observerMap[notification:getName()]
  if list then
    list:Notify(notification)
  end
end
function View:removeObserver(notificationName, notifyContext)
  local observers = self.observerMap[notificationName]
  if observers then
    observers:RemoveObserver(notifyContext)
  end
end
function View:registerMediator(mediator)
  if self.mediatorMap[mediator:getMediatorName()] ~= nil then
    return
  end
  mediator:initializeNotifier(self.multitonKey)
  self.mediatorMap[mediator:getMediatorName()] = mediator
  local interests = mediator:listNotificationInterests()
  if #interests > 0 then
    local observer = Observer.new(mediator.handleNotification, mediator)
    for _, i in pairs(interests) do
      self:registerObserver(i, observer)
    end
  end
  mediator:onRegister()
end
function View:retrieveMediator(mediatorName)
  return self.mediatorMap[mediatorName]
end
function View:removeMediator(mediatorName)
  local mediator = self.mediatorMap[mediatorName]
  if mediator ~= nil then
    local interests = mediator:listNotificationInterests()
    for _, i in pairs(interests) do
      self:removeObserver(i, mediator)
    end
    self.mediatorMap[mediatorName] = nil
    mediator:onRemove()
  end
  return mediator
end
function View:hasMediator(mediatorName)
  return self.mediatorMap[mediatorName] ~= nil
end
function View.removeView(key)
  View.instanceMap[key] = nil
end
View.instanceMap = {}
View.MULTITON_MSG = "View instance for this Multiton key already constructed!"
return View
