autoImport("ServiceRegionCmdAutoProxy")
ServiceRegionCmdProxy = class("ServiceRegionCmdProxy", ServiceRegionCmdAutoProxy)
ServiceRegionCmdProxy.Instance = nil
ServiceRegionCmdProxy.NAME = "ServiceRegionCmdProxy"
function ServiceRegionCmdProxy:ctor(proxyName)
  if ServiceRegionCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceRegionCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceRegionCmdProxy.Instance = self
  end
end
