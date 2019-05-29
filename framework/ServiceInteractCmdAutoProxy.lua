ServiceInteractCmdAutoProxy = class("ServiceInteractCmdAutoProxy", ServiceProxy)
ServiceInteractCmdAutoProxy.Instance = nil
ServiceInteractCmdAutoProxy.NAME = "ServiceInteractCmdAutoProxy"
function ServiceInteractCmdAutoProxy:ctor(proxyName)
  if ServiceInteractCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceInteractCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceInteractCmdAutoProxy.Instance = self
  end
end
function ServiceInteractCmdAutoProxy:Init()
end
function ServiceInteractCmdAutoProxy:onRegister()
  self:Listen(217, 1, function(data)
    self:RecvAddMountInterCmd(data)
  end)
  self:Listen(217, 2, function(data)
    self:RecvDelMountInterCmd(data)
  end)
  self:Listen(217, 3, function(data)
    self:RecvConfirmMountInterCmd(data)
  end)
  self:Listen(217, 4, function(data)
    self:RecvCancelMountInterCmd(data)
  end)
  self:Listen(217, 5, function(data)
    self:RecvAddMoveMountInterCmd(data)
  end)
  self:Listen(217, 6, function(data)
    self:RecvDelMoveMountInterCmd(data)
  end)
  self:Listen(217, 7, function(data)
    self:RecvConfirmMoveMountInterCmd(data)
  end)
  self:Listen(217, 8, function(data)
    self:RecvCancelMoveMountInterCmd(data)
  end)
  self:Listen(217, 10, function(data)
    self:RecvUpdateTrainStateInterCmd(data)
  end)
  self:Listen(217, 9, function(data)
    self:RecvTrainUserSyncInterCmd(data)
  end)
  self:Listen(217, 11, function(data)
    self:RecvPosUpdateInterCmd(data)
  end)
end
function ServiceInteractCmdAutoProxy:CallAddMountInterCmd(npcguid, mountid, charid)
  local msg = InteractCmd_pb.AddMountInterCmd()
  if npcguid ~= nil then
    msg.npcguid = npcguid
  end
  if mountid ~= nil then
    msg.mountid = mountid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceInteractCmdAutoProxy:CallDelMountInterCmd(npcguid, charid)
  local msg = InteractCmd_pb.DelMountInterCmd()
  if npcguid ~= nil then
    msg.npcguid = npcguid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceInteractCmdAutoProxy:CallConfirmMountInterCmd(npcguid)
  local msg = InteractCmd_pb.ConfirmMountInterCmd()
  if npcguid ~= nil then
    msg.npcguid = npcguid
  end
  self:SendProto(msg)
end
function ServiceInteractCmdAutoProxy:CallCancelMountInterCmd(npcguid)
  local msg = InteractCmd_pb.CancelMountInterCmd()
  if npcguid ~= nil then
    msg.npcguid = npcguid
  end
  self:SendProto(msg)
end
function ServiceInteractCmdAutoProxy:CallAddMoveMountInterCmd(npcid, user)
  local msg = InteractCmd_pb.AddMoveMountInterCmd()
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if user.user ~= nil and user.user.charid ~= nil then
    msg.user.user.charid = user.user.charid
  end
  if user.user ~= nil and user.user.guildid ~= nil then
    msg.user.user.guildid = user.user.guildid
  end
  if user.user ~= nil and user.user.name ~= nil then
    msg.user.user.name = user.user.name
  end
  if user.user ~= nil and user.user.guildname ~= nil then
    msg.user.user.guildname = user.user.guildname
  end
  if user.user ~= nil and user.user.guildportrait ~= nil then
    msg.user.user.guildportrait = user.user.guildportrait
  end
  if user.user ~= nil and user.user.guildjob ~= nil then
    msg.user.user.guildjob = user.user.guildjob
  end
  if user ~= nil and user.user.datas ~= nil then
    for i = 1, #user.user.datas do
      table.insert(msg.user.user.datas, user.user.datas[i])
    end
  end
  if user ~= nil and user.user.attrs ~= nil then
    for i = 1, #user.user.attrs do
      table.insert(msg.user.user.attrs, user.user.attrs[i])
    end
  end
  if user ~= nil and user.user.equip ~= nil then
    for i = 1, #user.user.equip do
      table.insert(msg.user.user.equip, user.user.equip[i])
    end
  end
  if user ~= nil and user.user.fashion ~= nil then
    for i = 1, #user.user.fashion do
      table.insert(msg.user.user.fashion, user.user.fashion[i])
    end
  end
  if user ~= nil and user.user.highrefine ~= nil then
    for i = 1, #user.user.highrefine do
      table.insert(msg.user.user.highrefine, user.user.highrefine[i])
    end
  end
  if user.user ~= nil and user.user.partner ~= nil then
    msg.user.user.partner = user.user.partner
  end
  if user ~= nil and user.mountid ~= nil then
    msg.user.mountid = user.mountid
  end
  self:SendProto(msg)
end
function ServiceInteractCmdAutoProxy:CallDelMoveMountInterCmd(npcid, charids)
  local msg = InteractCmd_pb.DelMoveMountInterCmd()
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if charids ~= nil then
    for i = 1, #charids do
      table.insert(msg.charids, charids[i])
    end
  end
  self:SendProto(msg)
end
function ServiceInteractCmdAutoProxy:CallConfirmMoveMountInterCmd(npcid)
  local msg = InteractCmd_pb.ConfirmMoveMountInterCmd()
  if npcid ~= nil then
    msg.npcid = npcid
  end
  self:SendProto(msg)
end
function ServiceInteractCmdAutoProxy:CallCancelMoveMountInterCmd(npcid)
  local msg = InteractCmd_pb.CancelMoveMountInterCmd()
  if npcid ~= nil then
    msg.npcid = npcid
  end
  self:SendProto(msg)
end
function ServiceInteractCmdAutoProxy:CallUpdateTrainStateInterCmd(npcid, state)
  local msg = InteractCmd_pb.UpdateTrainStateInterCmd()
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if state ~= nil then
    msg.state = state
  end
  self:SendProto(msg)
end
function ServiceInteractCmdAutoProxy:CallTrainUserSyncInterCmd(state, arrivetime, users, npcid)
  local msg = InteractCmd_pb.TrainUserSyncInterCmd()
  if state ~= nil then
    msg.state = state
  end
  if arrivetime ~= nil then
    msg.arrivetime = arrivetime
  end
  if users ~= nil then
    for i = 1, #users do
      table.insert(msg.users, users[i])
    end
  end
  if npcid ~= nil then
    msg.npcid = npcid
  end
  self:SendProto(msg)
end
function ServiceInteractCmdAutoProxy:CallPosUpdateInterCmd(pos)
  local msg = InteractCmd_pb.PosUpdateInterCmd()
  if pos ~= nil and pos.x ~= nil then
    msg.pos.x = pos.x
  end
  if pos ~= nil and pos.y ~= nil then
    msg.pos.y = pos.y
  end
  if pos ~= nil and pos.z ~= nil then
    msg.pos.z = pos.z
  end
  self:SendProto(msg)
end
function ServiceInteractCmdAutoProxy:RecvAddMountInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdAddMountInterCmd, data)
end
function ServiceInteractCmdAutoProxy:RecvDelMountInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdDelMountInterCmd, data)
end
function ServiceInteractCmdAutoProxy:RecvConfirmMountInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdConfirmMountInterCmd, data)
end
function ServiceInteractCmdAutoProxy:RecvCancelMountInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdCancelMountInterCmd, data)
end
function ServiceInteractCmdAutoProxy:RecvAddMoveMountInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdAddMoveMountInterCmd, data)
end
function ServiceInteractCmdAutoProxy:RecvDelMoveMountInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdDelMoveMountInterCmd, data)
end
function ServiceInteractCmdAutoProxy:RecvConfirmMoveMountInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdConfirmMoveMountInterCmd, data)
end
function ServiceInteractCmdAutoProxy:RecvCancelMoveMountInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdCancelMoveMountInterCmd, data)
end
function ServiceInteractCmdAutoProxy:RecvUpdateTrainStateInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdUpdateTrainStateInterCmd, data)
end
function ServiceInteractCmdAutoProxy:RecvTrainUserSyncInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdTrainUserSyncInterCmd, data)
end
function ServiceInteractCmdAutoProxy:RecvPosUpdateInterCmd(data)
  self:Notify(ServiceEvent.InteractCmdPosUpdateInterCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.InteractCmdAddMountInterCmd = "ServiceEvent_InteractCmdAddMountInterCmd"
ServiceEvent.InteractCmdDelMountInterCmd = "ServiceEvent_InteractCmdDelMountInterCmd"
ServiceEvent.InteractCmdConfirmMountInterCmd = "ServiceEvent_InteractCmdConfirmMountInterCmd"
ServiceEvent.InteractCmdCancelMountInterCmd = "ServiceEvent_InteractCmdCancelMountInterCmd"
ServiceEvent.InteractCmdAddMoveMountInterCmd = "ServiceEvent_InteractCmdAddMoveMountInterCmd"
ServiceEvent.InteractCmdDelMoveMountInterCmd = "ServiceEvent_InteractCmdDelMoveMountInterCmd"
ServiceEvent.InteractCmdConfirmMoveMountInterCmd = "ServiceEvent_InteractCmdConfirmMoveMountInterCmd"
ServiceEvent.InteractCmdCancelMoveMountInterCmd = "ServiceEvent_InteractCmdCancelMoveMountInterCmd"
ServiceEvent.InteractCmdUpdateTrainStateInterCmd = "ServiceEvent_InteractCmdUpdateTrainStateInterCmd"
ServiceEvent.InteractCmdTrainUserSyncInterCmd = "ServiceEvent_InteractCmdTrainUserSyncInterCmd"
ServiceEvent.InteractCmdPosUpdateInterCmd = "ServiceEvent_InteractCmdPosUpdateInterCmd"
