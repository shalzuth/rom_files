autoImport("ServiceGateSuperAutoProxy")
ServiceGateSuperProxy = class("ServiceGateSuperProxy", ServiceGateSuperAutoProxy)
ServiceGateSuperProxy.Instance = nil
ServiceGateSuperProxy.NAME = "ServiceGateSuperProxy"
function ServiceGateSuperProxy:ctor(proxyName)
  if ServiceGateSuperProxy.Instance == nil then
    self.proxyName = proxyName or ServiceGateSuperProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceGateSuperProxy.Instance = self
  end
end
