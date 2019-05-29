local Model = class("Model")
function Model:ctor(key)
  if Model.instanceMap[key] then
    error(Model.MULTITON_MSG)
  end
  self.multitonKey = key
  Model.instanceMap[key] = self
  self.proxyMap = {}
  self:initializeModel()
end
function Model:initializeModel()
end
function Model.getInstance(key)
  if nil == key then
    return nil
  end
  if Model.instanceMap[key] == nil then
    return Model.new(key)
  else
    return Model.instanceMap[key]
  end
end
function Model:registerProxy(proxy)
  proxy:initializeNotifier(self.multitonKey)
  self.proxyMap[proxy:getProxyName()] = proxy
  proxy:onRegister()
end
function Model:retrieveProxy(proxyName)
  return self.proxyMap[proxyName]
end
function Model:hasProxy(proxyName)
  return self.proxyMap[proxyName] ~= nil
end
function Model:removeProxy(proxyName)
  local proxy = self.proxyMap[proxyName]
  if proxy ~= nil then
    self.proxyMap[proxyName] = nil
    proxy:onRemove()
  end
  return proxy
end
function Model.removeModel(key)
  Model.instanceMap[key] = nil
end
Model.instanceMap = {}
Model.MULTITON_MSG = "Model instance for this Multiton key already constructed!"
return Model
