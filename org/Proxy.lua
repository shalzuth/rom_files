local Notifier = import("..observer.Notifier")
local Proxy = class("Proxy", Notifier)
function Proxy:ctor(proxyName, data)
  self.proxyName = proxyName or Proxy.NAME
  if data ~= nil then
    self:setData(data)
  end
end
Proxy.NAME = "Proxy"
function Proxy:getProxyName()
  return self.proxyName
end
function Proxy:setData(data)
  self.data = data
end
function Proxy:getData()
  return self.data
end
function Proxy:onRegister()
end
function Proxy:onRemove()
end
return Proxy
