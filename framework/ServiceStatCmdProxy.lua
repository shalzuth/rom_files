autoImport("ServiceStatCmdAutoProxy")
ServiceStatCmdProxy = class("ServiceStatCmdProxy", ServiceStatCmdAutoProxy)
ServiceStatCmdProxy.Instance = nil
ServiceStatCmdProxy.NAME = "ServiceStatCmdProxy"
function ServiceStatCmdProxy:ctor(proxyName)
  if ServiceStatCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceStatCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceStatCmdProxy.Instance = self
  end
end
