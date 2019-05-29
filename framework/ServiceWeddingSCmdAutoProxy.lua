ServiceWeddingSCmdAutoProxy = class("ServiceWeddingSCmdAutoProxy", ServiceProxy)
ServiceWeddingSCmdAutoProxy.Instance = nil
ServiceWeddingSCmdAutoProxy.NAME = "ServiceWeddingSCmdAutoProxy"
function ServiceWeddingSCmdAutoProxy:ctor(proxyName)
  if ServiceWeddingSCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceWeddingSCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceWeddingSCmdAutoProxy.Instance = self
  end
end
function ServiceWeddingSCmdAutoProxy:Init()
end
function ServiceWeddingSCmdAutoProxy:onRegister()
  self:Listen(214, 1, function(data)
    self:RecvForwardC2WeddingSCmd(data)
  end)
  self:Listen(214, 2, function(data)
    self:RecvForwardS2WeddingSCmd(data)
  end)
  self:Listen(214, 3, function(data)
    self:RecvForwardWedding2SSCmd(data)
  end)
  self:Listen(214, 8, function(data)
    self:RecvForwardWedding2CSCmd(data)
  end)
  self:Listen(214, 4, function(data)
    self:RecvSyncWeddingInfoSCmd(data)
  end)
  self:Listen(214, 14, function(data)
    self:RecvUpdateWeddingManualSCmd(data)
  end)
  self:Listen(214, 5, function(data)
    self:RecvStartWeddingSCmd(data)
  end)
  self:Listen(214, 6, function(data)
    self:RecvStopWeddingSCmd(data)
  end)
  self:Listen(214, 7, function(data)
    self:RecvReserveWeddingResultSCmd(data)
  end)
  self:Listen(214, 9, function(data)
    self:RecvBuyServiceWeddingSCmd(data)
  end)
  self:Listen(214, 11, function(data)
    self:RecvMarrySCmd(data)
  end)
  self:Listen(214, 12, function(data)
    self:RecvCheckWeddingReserverSCmd(data)
  end)
  self:Listen(214, 13, function(data)
    self:RecvMissyouInviteWedSCmd(data)
  end)
  self:Listen(214, 15, function(data)
    self:RecvMarrySuccessSCmd(data)
  end)
  self:Listen(214, 16, function(data)
    self:RecvUserRenameWedSCmd(data)
  end)
end
function ServiceWeddingSCmdAutoProxy:CallForwardC2WeddingSCmd(charid, zoneid, name, data, len)
  local msg = WeddingSCmd_pb.ForwardC2WeddingSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if name ~= nil then
    msg.name = name
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceWeddingSCmdAutoProxy:CallForwardS2WeddingSCmd(charid, zoneid, name, data, len)
  local msg = WeddingSCmd_pb.ForwardS2WeddingSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if name ~= nil then
    msg.name = name
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceWeddingSCmdAutoProxy:CallForwardWedding2SSCmd(charid, data, len)
  local msg = WeddingSCmd_pb.ForwardWedding2SSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceWeddingSCmdAutoProxy:CallForwardWedding2CSCmd(charid, data, len)
  local msg = WeddingSCmd_pb.ForwardWedding2CSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if data ~= nil then
    msg.data = data
  end
  if len ~= nil then
    msg.len = len
  end
  self:SendProto(msg)
end
function ServiceWeddingSCmdAutoProxy:CallSyncWeddingInfoSCmd(charid, weddinginfo)
  local msg = WeddingSCmd_pb.SyncWeddingInfoSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if weddinginfo ~= nil and weddinginfo.id ~= nil then
    msg.weddinginfo.id = weddinginfo.id
  end
  if weddinginfo ~= nil and weddinginfo.status ~= nil then
    msg.weddinginfo.status = weddinginfo.status
  end
  if weddinginfo ~= nil and weddinginfo.charid1 ~= nil then
    msg.weddinginfo.charid1 = weddinginfo.charid1
  end
  if weddinginfo ~= nil and weddinginfo.charid2 ~= nil then
    msg.weddinginfo.charid2 = weddinginfo.charid2
  end
  if weddinginfo ~= nil and weddinginfo.zoneid ~= nil then
    msg.weddinginfo.zoneid = weddinginfo.zoneid
  end
  if weddinginfo ~= nil and weddinginfo.date ~= nil then
    msg.weddinginfo.date = weddinginfo.date
  end
  if weddinginfo ~= nil and weddinginfo.configid ~= nil then
    msg.weddinginfo.configid = weddinginfo.configid
  end
  if weddinginfo ~= nil and weddinginfo.starttime ~= nil then
    msg.weddinginfo.starttime = weddinginfo.starttime
  end
  if weddinginfo ~= nil and weddinginfo.endtime ~= nil then
    msg.weddinginfo.endtime = weddinginfo.endtime
  end
  if weddinginfo ~= nil and weddinginfo.manual.serviceids ~= nil then
    for i = 1, #weddinginfo.manual.serviceids do
      table.insert(msg.weddinginfo.manual.serviceids, weddinginfo.manual.serviceids[i])
    end
  end
  if weddinginfo.manual ~= nil and weddinginfo.manual.ringid ~= nil then
    msg.weddinginfo.manual.ringid = weddinginfo.manual.ringid
  end
  if weddinginfo.manual ~= nil and weddinginfo.manual.photoindex1 ~= nil then
    msg.weddinginfo.manual.photoindex1 = weddinginfo.manual.photoindex1
  end
  if weddinginfo.manual ~= nil and weddinginfo.manual.photoindex2 ~= nil then
    msg.weddinginfo.manual.photoindex2 = weddinginfo.manual.photoindex2
  end
  if weddinginfo.manual ~= nil and weddinginfo.manual.phototime1 ~= nil then
    msg.weddinginfo.manual.phototime1 = weddinginfo.manual.phototime1
  end
  if weddinginfo.manual ~= nil and weddinginfo.manual.phototime2 ~= nil then
    msg.weddinginfo.manual.phototime2 = weddinginfo.manual.phototime2
  end
  if weddinginfo ~= nil and weddinginfo.manual.invitees ~= nil then
    for i = 1, #weddinginfo.manual.invitees do
      table.insert(msg.weddinginfo.manual.invitees, weddinginfo.manual.invitees[i])
    end
  end
  if weddinginfo.manual ~= nil and weddinginfo.manual.name1 ~= nil then
    msg.weddinginfo.manual.name1 = weddinginfo.manual.name1
  end
  if weddinginfo.manual ~= nil and weddinginfo.manual.name2 ~= nil then
    msg.weddinginfo.manual.name2 = weddinginfo.manual.name2
  end
  if weddinginfo ~= nil and weddinginfo.manual.itemrecords ~= nil then
    for i = 1, #weddinginfo.manual.itemrecords do
      table.insert(msg.weddinginfo.manual.itemrecords, weddinginfo.manual.itemrecords[i])
    end
  end
  self:SendProto(msg)
end
function ServiceWeddingSCmdAutoProxy:CallUpdateWeddingManualSCmd(weddingid, manual)
  local msg = WeddingSCmd_pb.UpdateWeddingManualSCmd()
  msg.weddingid = weddingid
  if manual ~= nil and manual.serviceids ~= nil then
    for i = 1, #manual.serviceids do
      table.insert(msg.manual.serviceids, manual.serviceids[i])
    end
  end
  if manual ~= nil and manual.ringid ~= nil then
    msg.manual.ringid = manual.ringid
  end
  if manual ~= nil and manual.photoindex1 ~= nil then
    msg.manual.photoindex1 = manual.photoindex1
  end
  if manual ~= nil and manual.photoindex2 ~= nil then
    msg.manual.photoindex2 = manual.photoindex2
  end
  if manual ~= nil and manual.phototime1 ~= nil then
    msg.manual.phototime1 = manual.phototime1
  end
  if manual ~= nil and manual.phototime2 ~= nil then
    msg.manual.phototime2 = manual.phototime2
  end
  if manual ~= nil and manual.invitees ~= nil then
    for i = 1, #manual.invitees do
      table.insert(msg.manual.invitees, manual.invitees[i])
    end
  end
  if manual ~= nil and manual.name1 ~= nil then
    msg.manual.name1 = manual.name1
  end
  if manual ~= nil and manual.name2 ~= nil then
    msg.manual.name2 = manual.name2
  end
  if manual ~= nil and manual.itemrecords ~= nil then
    for i = 1, #manual.itemrecords do
      table.insert(msg.manual.itemrecords, manual.itemrecords[i])
    end
  end
  self:SendProto(msg)
end
function ServiceWeddingSCmdAutoProxy:CallStartWeddingSCmd(weddinginfo)
  local msg = WeddingSCmd_pb.StartWeddingSCmd()
  if weddinginfo ~= nil and weddinginfo.id ~= nil then
    msg.weddinginfo.id = weddinginfo.id
  end
  if weddinginfo ~= nil and weddinginfo.status ~= nil then
    msg.weddinginfo.status = weddinginfo.status
  end
  if weddinginfo ~= nil and weddinginfo.charid1 ~= nil then
    msg.weddinginfo.charid1 = weddinginfo.charid1
  end
  if weddinginfo ~= nil and weddinginfo.charid2 ~= nil then
    msg.weddinginfo.charid2 = weddinginfo.charid2
  end
  if weddinginfo ~= nil and weddinginfo.zoneid ~= nil then
    msg.weddinginfo.zoneid = weddinginfo.zoneid
  end
  if weddinginfo ~= nil and weddinginfo.date ~= nil then
    msg.weddinginfo.date = weddinginfo.date
  end
  if weddinginfo ~= nil and weddinginfo.configid ~= nil then
    msg.weddinginfo.configid = weddinginfo.configid
  end
  if weddinginfo ~= nil and weddinginfo.starttime ~= nil then
    msg.weddinginfo.starttime = weddinginfo.starttime
  end
  if weddinginfo ~= nil and weddinginfo.endtime ~= nil then
    msg.weddinginfo.endtime = weddinginfo.endtime
  end
  if weddinginfo ~= nil and weddinginfo.manual.serviceids ~= nil then
    for i = 1, #weddinginfo.manual.serviceids do
      table.insert(msg.weddinginfo.manual.serviceids, weddinginfo.manual.serviceids[i])
    end
  end
  if weddinginfo.manual ~= nil and weddinginfo.manual.ringid ~= nil then
    msg.weddinginfo.manual.ringid = weddinginfo.manual.ringid
  end
  if weddinginfo.manual ~= nil and weddinginfo.manual.photoindex1 ~= nil then
    msg.weddinginfo.manual.photoindex1 = weddinginfo.manual.photoindex1
  end
  if weddinginfo.manual ~= nil and weddinginfo.manual.photoindex2 ~= nil then
    msg.weddinginfo.manual.photoindex2 = weddinginfo.manual.photoindex2
  end
  if weddinginfo.manual ~= nil and weddinginfo.manual.phototime1 ~= nil then
    msg.weddinginfo.manual.phototime1 = weddinginfo.manual.phototime1
  end
  if weddinginfo.manual ~= nil and weddinginfo.manual.phototime2 ~= nil then
    msg.weddinginfo.manual.phototime2 = weddinginfo.manual.phototime2
  end
  if weddinginfo ~= nil and weddinginfo.manual.invitees ~= nil then
    for i = 1, #weddinginfo.manual.invitees do
      table.insert(msg.weddinginfo.manual.invitees, weddinginfo.manual.invitees[i])
    end
  end
  if weddinginfo.manual ~= nil and weddinginfo.manual.name1 ~= nil then
    msg.weddinginfo.manual.name1 = weddinginfo.manual.name1
  end
  if weddinginfo.manual ~= nil and weddinginfo.manual.name2 ~= nil then
    msg.weddinginfo.manual.name2 = weddinginfo.manual.name2
  end
  if weddinginfo ~= nil and weddinginfo.manual.itemrecords ~= nil then
    for i = 1, #weddinginfo.manual.itemrecords do
      table.insert(msg.weddinginfo.manual.itemrecords, weddinginfo.manual.itemrecords[i])
    end
  end
  self:SendProto(msg)
end
function ServiceWeddingSCmdAutoProxy:CallStopWeddingSCmd(id)
  local msg = WeddingSCmd_pb.StopWeddingSCmd()
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
function ServiceWeddingSCmdAutoProxy:CallReserveWeddingResultSCmd(date, configid, charid1, charid2, success, ticket, money, zoneid)
  local msg = WeddingSCmd_pb.ReserveWeddingResultSCmd()
  if date ~= nil then
    msg.date = date
  end
  if configid ~= nil then
    msg.configid = configid
  end
  if charid1 ~= nil then
    msg.charid1 = charid1
  end
  if charid2 ~= nil then
    msg.charid2 = charid2
  end
  if success ~= nil then
    msg.success = success
  end
  if ticket ~= nil then
    msg.ticket = ticket
  end
  if money ~= nil then
    msg.money = money
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  self:SendProto(msg)
end
function ServiceWeddingSCmdAutoProxy:CallBuyServiceWeddingSCmd(charid, source, items, serviceid, weddingid, success)
  local msg = WeddingSCmd_pb.BuyServiceWeddingSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if source ~= nil then
    msg.source = source
  end
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  if serviceid ~= nil then
    msg.serviceid = serviceid
  end
  if weddingid ~= nil then
    msg.weddingid = weddingid
  end
  if success ~= nil then
    msg.success = success
  end
  self:SendProto(msg)
end
function ServiceWeddingSCmdAutoProxy:CallMarrySCmd(charid1, charid2, weddingid, items)
  local msg = WeddingSCmd_pb.MarrySCmd()
  if charid1 ~= nil then
    msg.charid1 = charid1
  end
  if charid2 ~= nil then
    msg.charid2 = charid2
  end
  if weddingid ~= nil then
    msg.weddingid = weddingid
  end
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceWeddingSCmdAutoProxy:CallCheckWeddingReserverSCmd(weddingid, mailid, charid, result)
  local msg = WeddingSCmd_pb.CheckWeddingReserverSCmd()
  if weddingid ~= nil then
    msg.weddingid = weddingid
  end
  if mailid ~= nil then
    msg.mailid = mailid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if result ~= nil then
    msg.result = result
  end
  self:SendProto(msg)
end
function ServiceWeddingSCmdAutoProxy:CallMissyouInviteWedSCmd(charid, trans, info)
  local msg = WeddingSCmd_pb.MissyouInviteWedSCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if trans ~= nil then
    msg.trans = trans
  end
  if info ~= nil and info.mapid ~= nil then
    msg.info.mapid = info.mapid
  end
  if info ~= nil and info.zoneid ~= nil then
    msg.info.zoneid = info.zoneid
  end
  if info ~= nil and info.x ~= nil then
    msg.info.x = info.x
  end
  if info ~= nil and info.y ~= nil then
    msg.info.y = info.y
  end
  if info ~= nil and info.z ~= nil then
    msg.info.z = info.z
  end
  self:SendProto(msg)
end
function ServiceWeddingSCmdAutoProxy:CallMarrySuccessSCmd(weddingid)
  local msg = WeddingSCmd_pb.MarrySuccessSCmd()
  if weddingid ~= nil then
    msg.weddingid = weddingid
  end
  self:SendProto(msg)
end
function ServiceWeddingSCmdAutoProxy:CallUserRenameWedSCmd(weddingid, charid)
  local msg = WeddingSCmd_pb.UserRenameWedSCmd()
  if weddingid ~= nil then
    msg.weddingid = weddingid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceWeddingSCmdAutoProxy:RecvForwardC2WeddingSCmd(data)
  self:Notify(ServiceEvent.WeddingSCmdForwardC2WeddingSCmd, data)
end
function ServiceWeddingSCmdAutoProxy:RecvForwardS2WeddingSCmd(data)
  self:Notify(ServiceEvent.WeddingSCmdForwardS2WeddingSCmd, data)
end
function ServiceWeddingSCmdAutoProxy:RecvForwardWedding2SSCmd(data)
  self:Notify(ServiceEvent.WeddingSCmdForwardWedding2SSCmd, data)
end
function ServiceWeddingSCmdAutoProxy:RecvForwardWedding2CSCmd(data)
  self:Notify(ServiceEvent.WeddingSCmdForwardWedding2CSCmd, data)
end
function ServiceWeddingSCmdAutoProxy:RecvSyncWeddingInfoSCmd(data)
  self:Notify(ServiceEvent.WeddingSCmdSyncWeddingInfoSCmd, data)
end
function ServiceWeddingSCmdAutoProxy:RecvUpdateWeddingManualSCmd(data)
  self:Notify(ServiceEvent.WeddingSCmdUpdateWeddingManualSCmd, data)
end
function ServiceWeddingSCmdAutoProxy:RecvStartWeddingSCmd(data)
  self:Notify(ServiceEvent.WeddingSCmdStartWeddingSCmd, data)
end
function ServiceWeddingSCmdAutoProxy:RecvStopWeddingSCmd(data)
  self:Notify(ServiceEvent.WeddingSCmdStopWeddingSCmd, data)
end
function ServiceWeddingSCmdAutoProxy:RecvReserveWeddingResultSCmd(data)
  self:Notify(ServiceEvent.WeddingSCmdReserveWeddingResultSCmd, data)
end
function ServiceWeddingSCmdAutoProxy:RecvBuyServiceWeddingSCmd(data)
  self:Notify(ServiceEvent.WeddingSCmdBuyServiceWeddingSCmd, data)
end
function ServiceWeddingSCmdAutoProxy:RecvMarrySCmd(data)
  self:Notify(ServiceEvent.WeddingSCmdMarrySCmd, data)
end
function ServiceWeddingSCmdAutoProxy:RecvCheckWeddingReserverSCmd(data)
  self:Notify(ServiceEvent.WeddingSCmdCheckWeddingReserverSCmd, data)
end
function ServiceWeddingSCmdAutoProxy:RecvMissyouInviteWedSCmd(data)
  self:Notify(ServiceEvent.WeddingSCmdMissyouInviteWedSCmd, data)
end
function ServiceWeddingSCmdAutoProxy:RecvMarrySuccessSCmd(data)
  self:Notify(ServiceEvent.WeddingSCmdMarrySuccessSCmd, data)
end
function ServiceWeddingSCmdAutoProxy:RecvUserRenameWedSCmd(data)
  self:Notify(ServiceEvent.WeddingSCmdUserRenameWedSCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.WeddingSCmdForwardC2WeddingSCmd = "ServiceEvent_WeddingSCmdForwardC2WeddingSCmd"
ServiceEvent.WeddingSCmdForwardS2WeddingSCmd = "ServiceEvent_WeddingSCmdForwardS2WeddingSCmd"
ServiceEvent.WeddingSCmdForwardWedding2SSCmd = "ServiceEvent_WeddingSCmdForwardWedding2SSCmd"
ServiceEvent.WeddingSCmdForwardWedding2CSCmd = "ServiceEvent_WeddingSCmdForwardWedding2CSCmd"
ServiceEvent.WeddingSCmdSyncWeddingInfoSCmd = "ServiceEvent_WeddingSCmdSyncWeddingInfoSCmd"
ServiceEvent.WeddingSCmdUpdateWeddingManualSCmd = "ServiceEvent_WeddingSCmdUpdateWeddingManualSCmd"
ServiceEvent.WeddingSCmdStartWeddingSCmd = "ServiceEvent_WeddingSCmdStartWeddingSCmd"
ServiceEvent.WeddingSCmdStopWeddingSCmd = "ServiceEvent_WeddingSCmdStopWeddingSCmd"
ServiceEvent.WeddingSCmdReserveWeddingResultSCmd = "ServiceEvent_WeddingSCmdReserveWeddingResultSCmd"
ServiceEvent.WeddingSCmdBuyServiceWeddingSCmd = "ServiceEvent_WeddingSCmdBuyServiceWeddingSCmd"
ServiceEvent.WeddingSCmdMarrySCmd = "ServiceEvent_WeddingSCmdMarrySCmd"
ServiceEvent.WeddingSCmdCheckWeddingReserverSCmd = "ServiceEvent_WeddingSCmdCheckWeddingReserverSCmd"
ServiceEvent.WeddingSCmdMissyouInviteWedSCmd = "ServiceEvent_WeddingSCmdMissyouInviteWedSCmd"
ServiceEvent.WeddingSCmdMarrySuccessSCmd = "ServiceEvent_WeddingSCmdMarrySuccessSCmd"
ServiceEvent.WeddingSCmdUserRenameWedSCmd = "ServiceEvent_WeddingSCmdUserRenameWedSCmd"
