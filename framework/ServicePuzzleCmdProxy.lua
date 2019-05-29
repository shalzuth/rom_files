autoImport("ServicePuzzleCmdAutoProxy")
ServicePuzzleCmdProxy = class("ServicePuzzleCmdProxy", ServicePuzzleCmdAutoProxy)
ServicePuzzleCmdProxy.Instance = nil
ServicePuzzleCmdProxy.NAME = "ServicePuzzleCmdProxy"
function ServicePuzzleCmdProxy:ctor(proxyName)
  if ServicePuzzleCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServicePuzzleCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServicePuzzleCmdProxy.Instance = self
  end
end
function ServicePuzzleCmdProxy:RecvQueryActPuzzleCmd(data)
  ActivityPuzzleProxy.Instance:HandleRecvActivityPuzzleDataCmd(data)
  self:Notify(ServiceEvent.PuzzleCmdQueryActPuzzleCmd, data)
end
function ServicePuzzleCmdProxy:RecvActUpdatePuzzleCmd(data)
  ActivityPuzzleProxy.Instance:HandleRecvActivityIdUpdateCmd(data)
  self:Notify(ServiceEvent.PuzzleCmdActUpdatePuzzleCmd, data)
end
function ServicePuzzleCmdProxy:RecvPuzzleItemNtf(data)
  ActivityPuzzleProxy.Instance:HandleRecvUpdatePuzzleItemCmd(data)
  self:Notify(ServiceEvent.PuzzleCmdPuzzleItemNtf, data)
end
function ServicePuzzleCmdProxy:RecvActivePuzzleCmd(data)
  self:Notify(ServiceEvent.PuzzleCmdActivePuzzleCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.PuzzleCmdActivePuzzleCmd, data)
end
