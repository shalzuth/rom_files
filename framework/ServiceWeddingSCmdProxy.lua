autoImport("ServiceWeddingSCmdAutoProxy")
ServiceWeddingSCmdProxy = class("ServiceWeddingSCmdProxy", ServiceWeddingSCmdAutoProxy)
ServiceWeddingSCmdProxy.Instance = nil
ServiceWeddingSCmdProxy.NAME = "ServiceWeddingSCmdProxy"
function ServiceWeddingSCmdProxy:ctor(proxyName)
  if ServiceWeddingSCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceWeddingSCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceWeddingSCmdProxy.Instance = self
  end
end
