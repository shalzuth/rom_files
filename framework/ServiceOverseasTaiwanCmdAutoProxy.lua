ServiceOverseasTaiwanCmdAutoProxy = class("ServiceOverseasTaiwanCmdAutoProxy", ServiceProxy)
ServiceOverseasTaiwanCmdAutoProxy.Instance = nil
ServiceOverseasTaiwanCmdAutoProxy.NAME = "ServiceOverseasTaiwanCmdAutoProxy"
function ServiceOverseasTaiwanCmdAutoProxy:ctor(proxyName)
  if ServiceOverseasTaiwanCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceOverseasTaiwanCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceOverseasTaiwanCmdAutoProxy.Instance = self
  end
end
function ServiceOverseasTaiwanCmdAutoProxy:Init()
end
function ServiceOverseasTaiwanCmdAutoProxy:onRegister()
  self:Listen(80, 1, function(data)
    self:RecvTaiwanFbLikeProgressCmd(data)
  end)
  self:Listen(80, 2, function(data)
    self:RecvTaiwanFbLikeUserRedeemCmd(data)
  end)
  self:Listen(81, 1, function(data)
    self:RecvOverseasPhotoUploadCmd(data)
  end)
  self:Listen(81, 2, function(data)
    self:RecvOverseasPhotoPathPrefixCmd(data)
  end)
  self:Listen(80, 10, function(data)
    self:RecvTaiwanFbShareProgressCmd(data)
  end)
  self:Listen(80, 11, function(data)
    self:RecvTaiwanFbShareRedeemCmd(data)
  end)
  self:Listen(81, 11, function(data)
    self:RecvOverseasChargeLimitGetChargeCmd(data)
  end)
  self:Listen(81, 21, function(data)
    self:RecvOverseasGoeItemAddCmd(data)
  end)
  self:Listen(81, 22, function(data)
    self:RecvOverseasGoeItemUseCmd(data)
  end)
end
function ServiceOverseasTaiwanCmdAutoProxy:CallTaiwanFbLikeProgressCmd(totalLikes, prizeList)
  local msg = OverseasTaiwanCmd_pb.TaiwanFbLikeProgressCmd()
  if totalLikes ~= nil then
    msg.totalLikes = totalLikes
  end
  if prizeList ~= nil then
    for i = 1, #prizeList do
      table.insert(msg.prizeList, prizeList[i])
    end
  end
  self:SendProto(msg)
end
function ServiceOverseasTaiwanCmdAutoProxy:CallTaiwanFbLikeUserRedeemCmd(prizeId, err)
  local msg = OverseasTaiwanCmd_pb.TaiwanFbLikeUserRedeemCmd()
  msg.prizeId = prizeId
  if err ~= nil then
    msg.err = err
  end
  self:SendProto(msg)
end
function ServiceOverseasTaiwanCmdAutoProxy:CallOverseasPhotoUploadCmd(type, photoId, fields, path)
  local msg = OverseasTaiwanCmd_pb.OverseasPhotoUploadCmd()
  msg.type = type
  msg.photoId = photoId
  if fields ~= nil then
    for i = 1, #fields do
      table.insert(msg.fields, fields[i])
    end
  end
  if path ~= nil then
    msg.path = path
  end
  self:SendProto(msg)
end
function ServiceOverseasTaiwanCmdAutoProxy:CallOverseasPhotoPathPrefixCmd(type, path)
  local msg = OverseasTaiwanCmd_pb.OverseasPhotoPathPrefixCmd()
  msg.type = type
  if path ~= nil then
    msg.path = path
  end
  self:SendProto(msg)
end
function ServiceOverseasTaiwanCmdAutoProxy:CallTaiwanFbShareProgressCmd(canShare)
  local msg = OverseasTaiwanCmd_pb.TaiwanFbShareProgressCmd()
  if canShare ~= nil then
    msg.canShare = canShare
  end
  self:SendProto(msg)
end
function ServiceOverseasTaiwanCmdAutoProxy:CallTaiwanFbShareRedeemCmd(err)
  local msg = OverseasTaiwanCmd_pb.TaiwanFbShareRedeemCmd()
  if err ~= nil then
    msg.err = err
  end
  self:SendProto(msg)
end
function ServiceOverseasTaiwanCmdAutoProxy:CallOverseasChargeLimitGetChargeCmd(charge)
  local msg = OverseasTaiwanCmd_pb.OverseasChargeLimitGetChargeCmd()
  if charge ~= nil then
    msg.charge = charge
  end
  self:SendProto(msg)
end
function ServiceOverseasTaiwanCmdAutoProxy:CallOverseasGoeItemAddCmd(uid, content, platform, pid, num, amt, ptype, note, date)
  local msg = OverseasTaiwanCmd_pb.OverseasGoeItemAddCmd()
  if uid ~= nil then
    msg.uid = uid
  end
  if content ~= nil then
    msg.content = content
  end
  if platform ~= nil then
    msg.platform = platform
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if num ~= nil then
    msg.num = num
  end
  if amt ~= nil then
    msg.amt = amt
  end
  if ptype ~= nil then
    msg.ptype = ptype
  end
  if note ~= nil then
    msg.note = note
  end
  if date ~= nil then
    msg.date = date
  end
  self:SendProto(msg)
end
function ServiceOverseasTaiwanCmdAutoProxy:CallOverseasGoeItemUseCmd(uid, content, platform, pid, num, numf, utype, acquiree, note, date)
  local msg = OverseasTaiwanCmd_pb.OverseasGoeItemUseCmd()
  if uid ~= nil then
    msg.uid = uid
  end
  if content ~= nil then
    msg.content = content
  end
  if platform ~= nil then
    msg.platform = platform
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if num ~= nil then
    msg.num = num
  end
  if numf ~= nil then
    msg.numf = numf
  end
  if utype ~= nil then
    msg.utype = utype
  end
  if acquiree ~= nil then
    msg.acquiree = acquiree
  end
  if note ~= nil then
    msg.note = note
  end
  if date ~= nil then
    msg.date = date
  end
  self:SendProto(msg)
end
function ServiceOverseasTaiwanCmdAutoProxy:RecvTaiwanFbLikeProgressCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdTaiwanFbLikeProgressCmd, data)
end
function ServiceOverseasTaiwanCmdAutoProxy:RecvTaiwanFbLikeUserRedeemCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdTaiwanFbLikeUserRedeemCmd, data)
end
function ServiceOverseasTaiwanCmdAutoProxy:RecvOverseasPhotoUploadCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdOverseasPhotoUploadCmd, data)
end
function ServiceOverseasTaiwanCmdAutoProxy:RecvOverseasPhotoPathPrefixCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdOverseasPhotoPathPrefixCmd, data)
end
function ServiceOverseasTaiwanCmdAutoProxy:RecvTaiwanFbShareProgressCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdTaiwanFbShareProgressCmd, data)
end
function ServiceOverseasTaiwanCmdAutoProxy:RecvTaiwanFbShareRedeemCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdTaiwanFbShareRedeemCmd, data)
end
function ServiceOverseasTaiwanCmdAutoProxy:RecvOverseasChargeLimitGetChargeCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdOverseasChargeLimitGetChargeCmd, data)
end
function ServiceOverseasTaiwanCmdAutoProxy:RecvOverseasGoeItemAddCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdOverseasGoeItemAddCmd, data)
end
function ServiceOverseasTaiwanCmdAutoProxy:RecvOverseasGoeItemUseCmd(data)
  self:Notify(ServiceEvent.OverseasTaiwanCmdOverseasGoeItemUseCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.OverseasTaiwanCmdTaiwanFbLikeProgressCmd = "ServiceEvent_OverseasTaiwanCmdTaiwanFbLikeProgressCmd"
ServiceEvent.OverseasTaiwanCmdTaiwanFbLikeUserRedeemCmd = "ServiceEvent_OverseasTaiwanCmdTaiwanFbLikeUserRedeemCmd"
ServiceEvent.OverseasTaiwanCmdOverseasPhotoUploadCmd = "ServiceEvent_OverseasTaiwanCmdOverseasPhotoUploadCmd"
ServiceEvent.OverseasTaiwanCmdOverseasPhotoPathPrefixCmd = "ServiceEvent_OverseasTaiwanCmdOverseasPhotoPathPrefixCmd"
ServiceEvent.OverseasTaiwanCmdTaiwanFbShareProgressCmd = "ServiceEvent_OverseasTaiwanCmdTaiwanFbShareProgressCmd"
ServiceEvent.OverseasTaiwanCmdTaiwanFbShareRedeemCmd = "ServiceEvent_OverseasTaiwanCmdTaiwanFbShareRedeemCmd"
ServiceEvent.OverseasTaiwanCmdOverseasChargeLimitGetChargeCmd = "ServiceEvent_OverseasTaiwanCmdOverseasChargeLimitGetChargeCmd"
ServiceEvent.OverseasTaiwanCmdOverseasGoeItemAddCmd = "ServiceEvent_OverseasTaiwanCmdOverseasGoeItemAddCmd"
ServiceEvent.OverseasTaiwanCmdOverseasGoeItemUseCmd = "ServiceEvent_OverseasTaiwanCmdOverseasGoeItemUseCmd"
