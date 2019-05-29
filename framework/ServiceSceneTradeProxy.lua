autoImport("ServiceSceneTradeAutoProxy")
ServiceSceneTradeProxy = class("ServiceSceneTradeProxy", ServiceSceneTradeAutoProxy)
ServiceSceneTradeProxy.Instance = nil
ServiceSceneTradeProxy.NAME = "ServiceSceneTradeProxy"
function ServiceSceneTradeProxy:ctor(proxyName)
  if ServiceSceneTradeProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneTradeProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneTradeProxy.Instance = self
  end
end
