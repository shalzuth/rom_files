autoImport("ServiceAuctionSCmdAutoProxy")
ServiceAuctionSCmdProxy = class("ServiceAuctionSCmdProxy", ServiceAuctionSCmdAutoProxy)
ServiceAuctionSCmdProxy.Instance = nil
ServiceAuctionSCmdProxy.NAME = "ServiceAuctionSCmdProxy"
function ServiceAuctionSCmdProxy:ctor(proxyName)
  if ServiceAuctionSCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceAuctionSCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceAuctionSCmdProxy.Instance = self
  end
end
