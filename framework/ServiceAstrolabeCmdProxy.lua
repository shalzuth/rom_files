autoImport("ServiceAstrolabeCmdAutoProxy")
ServiceAstrolabeCmdProxy = class("ServiceAstrolabeCmdProxy", ServiceAstrolabeCmdAutoProxy)
ServiceAstrolabeCmdProxy.Instance = nil
ServiceAstrolabeCmdProxy.NAME = "ServiceAstrolabeCmdProxy"
function ServiceAstrolabeCmdProxy:ctor(proxyName)
  if ServiceAstrolabeCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceAstrolabeCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceAstrolabeCmdProxy.Instance = self
  end
end
function ServiceAstrolabeCmdProxy:CallAstrolabeQueryCmd(stars, astrolabetype)
  ServiceAstrolabeCmdProxy.super.CallAstrolabeQueryCmd(self, stars, astrolabetype)
end
function ServiceAstrolabeCmdProxy:RecvAstrolabeQueryCmd(data)
  AstrolabeProxy.Instance:Server_SetActivePoints(data.stars, data.astrolabetype)
  self:Notify(ServiceEvent.AstrolabeCmdAstrolabeQueryCmd, data)
end
function ServiceAstrolabeCmdProxy:CallAstrolabeActivateStarCmd(stars, success)
  ServiceAstrolabeCmdProxy.super.CallAstrolabeActivateStarCmd(self, stars, success)
end
function ServiceAstrolabeCmdProxy:RecvAstrolabeActivateStarCmd(data)
  if data.success then
    AstrolabeProxy.Instance:Server_SetActivePoints(data.stars)
  end
  self:Notify(ServiceEvent.AstrolabeCmdAstrolabeActivateStarCmd, data)
end
function ServiceAstrolabeCmdProxy:CallAstrolabeQueryResetCmd(items)
  ServiceAstrolabeCmdProxy.super.CallAstrolabeQueryResetCmd(self, items)
end
function ServiceAstrolabeCmdProxy:RecvAstrolabeQueryResetCmd(data)
  self:Notify(ServiceEvent.AstrolabeCmdAstrolabeQueryResetCmd, data)
end
function ServiceAstrolabeCmdProxy:CallAstrolabeResetCmd(stars, success)
  ServiceAstrolabeCmdProxy.super.CallAstrolabeResetCmd(self, stars, success)
end
function ServiceAstrolabeCmdProxy:RecvAstrolabeResetCmd(data)
  if data.success then
    AstrolabeProxy.Instance:Server_ResetPoints(data.stars)
  end
  self:Notify(ServiceEvent.AstrolabeCmdAstrolabeResetCmd, data)
end
function ServiceAstrolabeCmdProxy:RecvAstrolabePlanSaveCmd(data)
  helplog("Recv-->AstrolabePlanSaveCmd", data.stars)
  AstrolabeProxy.Instance:Server_SetActivePoints(data.stars, AstrolabeCmd_pb.EASTROLABETYPE_PLAN)
  self:Notify(ServiceEvent.AstrolabeCmdAstrolabePlanSaveCmd, data)
end
