autoImport("ServiceLogCmdAutoProxy")
ServiceLogCmdProxy = class("ServiceLogCmdProxy", ServiceLogCmdAutoProxy)
ServiceLogCmdProxy.Instance = nil
ServiceLogCmdProxy.NAME = "ServiceLogCmdProxy"
function ServiceLogCmdProxy:ctor(proxyName)
  if ServiceLogCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceLogCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceLogCmdProxy.Instance = self
  end
end
