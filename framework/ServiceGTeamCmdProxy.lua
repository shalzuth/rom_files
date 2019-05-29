autoImport("ServiceGTeamCmdAutoProxy")
ServiceGTeamCmdProxy = class("ServiceGTeamCmdProxy", ServiceGTeamCmdAutoProxy)
ServiceGTeamCmdProxy.Instance = nil
ServiceGTeamCmdProxy.NAME = "ServiceGTeamCmdProxy"
function ServiceGTeamCmdProxy:ctor(proxyName)
  if ServiceGTeamCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceGTeamCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceGTeamCmdProxy.Instance = self
  end
end
