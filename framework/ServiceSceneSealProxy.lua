autoImport("ServiceSceneSealAutoProxy")
ServiceSceneSealProxy = class("ServiceSceneSealProxy", ServiceSceneSealAutoProxy)
ServiceSceneSealProxy.Instance = nil
ServiceSceneSealProxy.NAME = "ServiceSceneSealProxy"
function ServiceSceneSealProxy:ctor(proxyName)
  if ServiceSceneSealProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneSealProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneSealProxy.Instance = self
  end
end
function ServiceSceneSealProxy:CallSealTimer(data)
  ServiceSceneSealProxy.super.CallSealTimer(self)
end
function ServiceSceneSealProxy:RecvQuerySeal(data)
  SealProxy.Instance:SetSealData(data.datas)
  self:Notify(ServiceEvent.SceneSealQuerySeal, data)
end
function ServiceSceneSealProxy:CallBeginSeal(sealid, etype)
  helplog("Call-->BeginSeal", sealid, etype)
  ServiceSceneSealProxy.super.CallBeginSeal(self, sealid, etype)
end
function ServiceSceneSealProxy:RecvBeginSeal(data)
  FunctionRepairSeal.Me():BeginRepairSeal()
  self:Notify(ServiceEvent.SceneSealBeginSeal, data)
end
function ServiceSceneSealProxy:RecvEndSeal(data)
  FunctionRepairSeal.Me():EndRepairSeal()
  SealProxy.Instance:ResetAcceptSealInfo()
  self:Notify(ServiceEvent.SceneSealEndSeal, data)
end
function ServiceSceneSealProxy:RecvUpdateSeal(data)
  SealProxy.Instance:UpdateSeals(data.newdata, data.deldata)
  self:Notify(ServiceEvent.SceneSealUpdateSeal, data)
end
function ServiceSceneSealProxy:RecvSealTimer(data)
  SealProxy.Instance:SetSealTimer(data)
  FunctionRepairSeal.Me():RefreshSealTimer()
  self:Notify(ServiceEvent.SceneSealSealTimer, data)
end
function ServiceSceneSealProxy:CallSealQueryList()
  ServiceSceneSealProxy.super.CallSealQueryList(self, {})
end
function ServiceSceneSealProxy:RecvSealQueryList(data)
  SealProxy.Instance:SetNowSealTasks(data.configid)
  self:Notify(ServiceEvent.SceneSealSealQueryList, data)
end
function ServiceSceneSealProxy:CallSealAcceptCmd(seal, abandon)
  ServiceSceneSealProxy.super.CallSealAcceptCmd(self, seal, nil, abandon)
end
function ServiceSceneSealProxy:RecvSealAcceptCmd(data)
  if data.abandon then
    SealProxy.Instance:ResetAcceptSealInfo()
  else
    SealProxy.Instance:SetNowAcceptSeal(data.seal, data.pos)
  end
  FunctionRepairSeal.Me():CheckSealTraceInfo()
  self:Notify(ServiceEvent.SceneSealSealAcceptCmd, data)
end
