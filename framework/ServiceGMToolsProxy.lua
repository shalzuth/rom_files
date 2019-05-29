autoImport("ServiceGMToolsAutoProxy")
ServiceGMToolsProxy = class("ServiceGMToolsProxy", ServiceGMToolsAutoProxy)
ServiceGMToolsProxy.Instance = nil
ServiceGMToolsProxy.NAME = "ServiceGMToolsProxy"
function ServiceGMToolsProxy:ctor(proxyName)
  if ServiceGMToolsProxy.Instance == nil then
    self.proxyName = proxyName or ServiceGMToolsProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceGMToolsProxy.Instance = self
  end
end
