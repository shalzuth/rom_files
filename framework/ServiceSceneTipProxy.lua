autoImport("ServiceSceneTipAutoProxy")
ServiceSceneTipProxy = class("ServiceSceneTipProxy", ServiceSceneTipAutoProxy)
ServiceSceneTipProxy.Instance = nil
ServiceSceneTipProxy.NAME = "ServiceSceneTipProxy"
function ServiceSceneTipProxy:ctor(proxyName)
  if ServiceSceneTipProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneTipProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneTipProxy.Instance = self
  end
end
function ServiceSceneTipProxy:RecvGameTipCmd(data)
  RedTipProxy.Instance:UpdateRedTipsbyServer(data)
end
function ServiceSceneTipProxy:RecvBrowseRedTipCmd(data)
end
function ServiceSceneTipProxy:CallAddRedTip(red)
  if RedTipProxy.Instance:InRedTip(red) then
    return
  end
end
