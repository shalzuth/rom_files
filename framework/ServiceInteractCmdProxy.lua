autoImport("ServiceInteractCmdAutoProxy")
ServiceInteractCmdProxy = class("ServiceInteractCmdProxy", ServiceInteractCmdAutoProxy)
ServiceInteractCmdProxy.Instance = nil
ServiceInteractCmdProxy.NAME = "ServiceInteractCmdProxy"
local tempPos = {}
local C2S_Vector3 = ProtolUtility.C2S_Vector3
function ServiceInteractCmdProxy:ctor(proxyName)
  if ServiceInteractCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceInteractCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceInteractCmdProxy.Instance = self
  end
end
function ServiceInteractCmdProxy:CallPosUpdateInterCmd(pos)
  C2S_Vector3(pos, tempPos)
  ServiceInteractCmdProxy.super.CallPosUpdateInterCmd(self, tempPos)
end
function ServiceInteractCmdProxy:RecvAddMountInterCmd(data)
  Game.InteractNpcManager:AddMountInter(data.npcguid, data.mountid, data.charid)
end
function ServiceInteractCmdProxy:RecvDelMountInterCmd(data)
  Game.InteractNpcManager:DelMountInter(data)
end
function ServiceInteractCmdProxy:RecvAddMoveMountInterCmd(data)
  Game.InteractNpcManager:AddMoveMountInter(data)
end
function ServiceInteractCmdProxy:RecvDelMoveMountInterCmd(data)
  Game.InteractNpcManager:DelMoveMountInter(data)
end
function ServiceInteractCmdProxy:RecvUpdateTrainStateInterCmd(data)
  Game.InteractNpcManager:UpdateTrainStateInter(data)
end
function ServiceInteractCmdProxy:RecvTrainUserSyncInterCmd(data)
  Game.InteractNpcManager:TrainUserSyncInter(data)
end
