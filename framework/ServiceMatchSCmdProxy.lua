autoImport("ServiceMatchSCmdAutoProxy")
ServiceMatchSCmdProxy = class("ServiceMatchSCmdProxy", ServiceMatchSCmdAutoProxy)
ServiceMatchSCmdProxy.Instance = nil
ServiceMatchSCmdProxy.NAME = "ServiceMatchSCmdProxy"
function ServiceMatchSCmdProxy:ctor(proxyName)
  if ServiceMatchSCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceMatchSCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceMatchSCmdProxy.Instance = self
  end
end
