autoImport("ServiceBossSCmdAutoProxy")
ServiceBossSCmdProxy = class("ServiceBossSCmdProxy", ServiceBossSCmdAutoProxy)
ServiceBossSCmdProxy.Instance = nil
ServiceBossSCmdProxy.NAME = "ServiceBossSCmdProxy"
function ServiceBossSCmdProxy:ctor(proxyName)
  if ServiceBossSCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceBossSCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceBossSCmdProxy.Instance = self
  end
end
