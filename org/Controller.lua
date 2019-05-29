local View = import(".View")
local Observer = import("..patterns.observer.Observer")
local Controller = class("Controller")
function Controller:ctor(key)
  if Controller.instanceMap[key] ~= nil then
    error(Controller.MULTITON_MSG)
  end
  self.multitonKey = key
  Controller.instanceMap[self.multitonKey] = self
  self.commandMap = {}
  self:initializeController()
end
function Controller:initializeController()
  self.view = View.getInstance(self.multitonKey)
end
function Controller.getInstance(key)
  if nil == key then
    return nil
  end
  if nil == Controller.instanceMap[key] then
    return Controller.new(key)
  else
    return Controller.instanceMap[key]
  end
end
function Controller:executeCommand(note)
  local commandClassRef = self.commandMap[note:getName()]
  if commandClassRef == nil then
    return
  end
  local commandInstance = commandClassRef.new()
  commandInstance:initializeNotifier(self.multitonKey)
  commandInstance:execute(note)
end
function Controller:registerCommand(notificationName, commandClassRef)
  if self.commandMap[notificationName] == nil then
    self.view:registerObserver(notificationName, Observer.new(self.executeCommand, self))
  end
  self.commandMap[notificationName] = commandClassRef
end
function Controller:hasCommand(notificationName)
  return self.commandMap[notificationName] ~= nil
end
function Controller:removeCommand(notificationName)
  if self:hasCommand(notificationName) then
    self.view:removeObserver(notificationName, self)
    self.commandMap[notificationName] = nil
  end
end
function Controller.removeController(key)
  Controller.instanceMap[key] = nil
end
Controller.instanceMap = {}
Controller.MULTITON_MSG = "controller key for this Multiton key already constructed"
return Controller
