autoImport("ServiceGZoneCmdAutoProxy")
ServiceGZoneCmdProxy = class("ServiceGZoneCmdProxy", ServiceGZoneCmdAutoProxy)
ServiceGZoneCmdProxy.Instance = nil
ServiceGZoneCmdProxy.NAME = "ServiceGZoneCmdProxy"
function ServiceGZoneCmdProxy:ctor(proxyName)
  if ServiceGZoneCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceGZoneCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceGZoneCmdProxy.Instance = self
  end
end
