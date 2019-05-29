autoImport("ServiceCarrierCmdAutoProxy")
ServiceCarrierCmdProxy = class("ServiceCarrierCmdProxy", ServiceCarrierCmdAutoProxy)
ServiceCarrierCmdProxy.Instance = nil
ServiceCarrierCmdProxy.NAME = "ServiceCarrierCmdProxy"
function ServiceCarrierCmdProxy:ctor(proxyName)
  if ServiceCarrierCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceCarrierCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceCarrierCmdProxy.Instance = self
  end
  NetProtocol.NeedCacheReceive(16, 2)
  NetProtocol.NeedCacheReceive(16, 13)
end
function ServiceCarrierCmdProxy:RecvCarrierInfoUserCmd(data)
  SceneCarrierProxy.Instance:InfoAdd(data)
end
function ServiceCarrierCmdProxy:RecvCreateCarrierUserCmd(data)
  SceneCarrierProxy.Instance:CreateMyCarrier(data)
end
function ServiceCarrierCmdProxy:RecvJoinCarrierUserCmd(data)
  if SceneCarrierProxy.Instance:GetMyCarrier() == nil then
    local data = {
      type = InviteType.Carrier,
      playerid = data.masterid,
      msgId = 405,
      msgParama = {
        data.mastername,
        Table_Bus[data.carrierid].NameZh
      }
    }
    function data.yesevt(id)
      ServiceCarrierCmdProxy.Instance:CallJoinCarrierUserCmd(id, nil, nil, true)
    end
    function data.noevt(id)
      ServiceCarrierCmdProxy.Instance:CallJoinCarrierUserCmd(id, nil, nil, false)
    end
    self:Notify(InviteConfirmEvent.AddInvite, data)
  else
    self:CallJoinCarrierUserCmd(data.masterid, nil, nil, false)
  end
end
function ServiceCarrierCmdProxy:RecvFerrisWheelInviteCarrierCmd(data)
  local myself = Game.Myself
  local handed, imhander = myself:IsHandInHand()
  if handed and data.targetid == myself:GetHandInHandPartnerID() then
    ServiceCarrierCmdProxy.Instance:CallFerrisWheelProcessInviteCarrierCmd(data.targetid, CarrierCmd_pb.EFERRISACTION_AGREE, data.id)
    return
  end
  local inviteData = {
    type = InviteType.FerrisWheel,
    playerid = data.targetid,
    time = Table_DateLand[data.id].invite_overtime,
    msgId = 871,
    msgParama = {
      data.targetname
    }
  }
  function inviteData.yesevt(id)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SkyWheelAcceptView,
      viewdata = data
    })
  end
  function inviteData.noevt(id)
    ServiceCarrierCmdProxy.Instance:CallFerrisWheelProcessInviteCarrierCmd(id, CarrierCmd_pb.EFERRISACTION_DISAGREE, data.id)
    GameFacade.Instance:sendNotification(SkyWheel.CloseAccept)
  end
  function inviteData.endevt()
    ServiceCarrierCmdProxy.Instance:CallFerrisWheelProcessInviteCarrierCmd(data.targetid, CarrierCmd_pb.EFERRISACTION_DISAGREE, data.id)
  end
  self:Notify(InviteConfirmEvent.AddInvite, inviteData)
end
function ServiceCarrierCmdProxy:RecvRetJoinCarrierUserCmd(data)
  SceneCarrierProxy.Instance:MemberAgree(data)
  self:Notify(ServiceEvent.CarrierCmdRetJoinCarrierUserCmd, data)
end
function ServiceCarrierCmdProxy:RecvLeaveCarrierUserCmd(data)
  SceneCarrierProxy.Instance:LeaveCarrier(data)
end
function ServiceCarrierCmdProxy:RecvReachCarrierUserCmd(data)
  SceneCarrierProxy.Instance:ReachCarrier(data)
end
function ServiceCarrierCmdProxy:RecvCarrierMoveUserCmd(data)
  SceneCarrierProxy.Instance:SyncCarrierMove(data)
end
function ServiceCarrierCmdProxy:RecvCarrierStartUserCmd(data)
  SceneCarrierProxy.Instance:CarrierStart(data)
end
function ServiceCarrierCmdProxy:RecvCarrierWaitListUserCmd(data)
  SceneCarrierProxy.Instance:CarrierWaitMembers(data.masterid, data.members)
  self:Notify(ServiceEvent.CarrierCmdCarrierWaitListUserCmd, data)
end
function ServiceCarrierCmdProxy:CallLeaveCarrierUserCmd(pos)
  local msg = CarrierCmd_pb.LeaveCarrierUserCmd()
  if pos then
    pos = pos * 1000
    msg.pos.x = pos.x
    msg.pos.y = pos.y
    msg.pos.z = pos.z
  end
  self:SendProto(msg)
end
function ServiceCarrierCmdProxy:CallCarrierMoveUserCmd(pos, progress)
  local msg = CarrierCmd_pb.CarrierMoveUserCmd()
  if pos then
    pos = pos * 1000
    msg.pos.x = pos.x
    msg.pos.y = pos.y
    msg.pos.z = pos.z
  end
  if progress ~= nil then
    msg.progress = progress
  end
  self:SendProto(msg)
end
function ServiceCarrierCmdProxy:CallReachCarrierUserCmd(pos, masterid)
  local msg = CarrierCmd_pb.ReachCarrierUserCmd()
  if pos then
    pos = pos * 1000
    msg.pos.x = pos.x
    msg.pos.y = pos.y
    msg.pos.z = pos.z
  end
  if masterid ~= nil then
    msg.masterid = masterid
  end
  self:SendProto(msg)
end
function ServiceCarrierCmdProxy:RecvChangeCarrierUserCmd(data)
  SceneCarrierProxy.Instance:ChangeCarrier(data.masterid, data.carrierid)
end
