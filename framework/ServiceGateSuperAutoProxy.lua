ServiceGateSuperAutoProxy = class("ServiceGateSuperAutoProxy", ServiceProxy)
ServiceGateSuperAutoProxy.Instance = nil
ServiceGateSuperAutoProxy.NAME = "ServiceGateSuperAutoProxy"
function ServiceGateSuperAutoProxy:ctor(proxyName)
  if ServiceGateSuperAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceGateSuperAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceGateSuperAutoProxy.Instance = self
  end
end
function ServiceGateSuperAutoProxy:Init()
end
function ServiceGateSuperAutoProxy:onRegister()
  self:Listen(205, 1, function(data)
    self:RecvGateToSuperUserNum(data)
  end)
  self:Listen(205, 2, function(data)
    self:RecvPushMsgGateSuperCmd(data)
  end)
  self:Listen(205, 3, function(data)
    self:RecvAlterMsgGateSuperCmd(data)
  end)
  self:Listen(205, 4, function(data)
    self:RecvPushTyrantDbGateSuperCmd(data)
  end)
  self:Listen(205, 5, function(data)
    self:RecvForwardToGateUserCmd(data)
  end)
  self:Listen(205, 6, function(data)
    self:RecvPushClientMsgGateSuperCmd(data)
  end)
  self:Listen(205, 7, function(data)
    self:RecvSendMessageGateSuperCmd(data)
  end)
end
function ServiceGateSuperAutoProxy:CallGateToSuperUserNum(num)
  local msg = GateSuper_pb.GateToSuperUserNum()
  if num ~= nil then
    msg.num = num
  end
  self:SendProto(msg)
end
function ServiceGateSuperAutoProxy:CallPushMsgGateSuperCmd(type, title, msg)
  local msg = GateSuper_pb.PushMsgGateSuperCmd()
  if type ~= nil then
    msg.type = type
  end
  if title ~= nil then
    msg.title = title
  end
  if msg ~= nil then
    msg.msg = msg
  end
  self:SendProto(msg)
end
function ServiceGateSuperAutoProxy:CallAlterMsgGateSuperCmd(event, title, msg)
  local msg = GateSuper_pb.AlterMsgGateSuperCmd()
  if event ~= nil then
    msg.event = event
  end
  if title ~= nil then
    msg.title = title
  end
  if msg ~= nil then
    msg.msg = msg
  end
  self:SendProto(msg)
end
function ServiceGateSuperAutoProxy:CallPushTyrantDbGateSuperCmd(accid, charid, orderid, amount, itemcount, productid, chargetype, currency_type)
  local msg = GateSuper_pb.PushTyrantDbGateSuperCmd()
  if accid ~= nil then
    msg.accid = accid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if orderid ~= nil then
    msg.orderid = orderid
  end
  if amount ~= nil then
    msg.amount = amount
  end
  if itemcount ~= nil then
    msg.itemcount = itemcount
  end
  if productid ~= nil then
    msg.productid = productid
  end
  if chargetype ~= nil then
    msg.chargetype = chargetype
  end
  if currency_type ~= nil then
    msg.currency_type = currency_type
  end
  self:SendProto(msg)
end
function ServiceGateSuperAutoProxy:CallForwardToGateUserCmd(accids, data)
  local msg = GateSuper_pb.ForwardToGateUserCmd()
  if accids ~= nil then
    for i = 1, #accids do
      table.insert(msg.accids, accids[i])
    end
  end
  if data ~= nil then
    msg.data = data
  end
  self:SendProto(msg)
end
function ServiceGateSuperAutoProxy:CallPushClientMsgGateSuperCmd(pushkey, msg)
  local msg = GateSuper_pb.PushClientMsgGateSuperCmd()
  if pushkey ~= nil then
    msg.pushkey = pushkey
  end
  if msg ~= nil then
    msg.msg = msg
  end
  self:SendProto(msg)
end
function ServiceGateSuperAutoProxy:CallSendMessageGateSuperCmd(phone, content)
  local msg = GateSuper_pb.SendMessageGateSuperCmd()
  if phone ~= nil then
    msg.phone = phone
  end
  if content ~= nil then
    msg.content = content
  end
  self:SendProto(msg)
end
function ServiceGateSuperAutoProxy:RecvGateToSuperUserNum(data)
  self:Notify(ServiceEvent.GateSuperGateToSuperUserNum, data)
end
function ServiceGateSuperAutoProxy:RecvPushMsgGateSuperCmd(data)
  self:Notify(ServiceEvent.GateSuperPushMsgGateSuperCmd, data)
end
function ServiceGateSuperAutoProxy:RecvAlterMsgGateSuperCmd(data)
  self:Notify(ServiceEvent.GateSuperAlterMsgGateSuperCmd, data)
end
function ServiceGateSuperAutoProxy:RecvPushTyrantDbGateSuperCmd(data)
  self:Notify(ServiceEvent.GateSuperPushTyrantDbGateSuperCmd, data)
end
function ServiceGateSuperAutoProxy:RecvForwardToGateUserCmd(data)
  self:Notify(ServiceEvent.GateSuperForwardToGateUserCmd, data)
end
function ServiceGateSuperAutoProxy:RecvPushClientMsgGateSuperCmd(data)
  self:Notify(ServiceEvent.GateSuperPushClientMsgGateSuperCmd, data)
end
function ServiceGateSuperAutoProxy:RecvSendMessageGateSuperCmd(data)
  self:Notify(ServiceEvent.GateSuperSendMessageGateSuperCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.GateSuperGateToSuperUserNum = "ServiceEvent_GateSuperGateToSuperUserNum"
ServiceEvent.GateSuperPushMsgGateSuperCmd = "ServiceEvent_GateSuperPushMsgGateSuperCmd"
ServiceEvent.GateSuperAlterMsgGateSuperCmd = "ServiceEvent_GateSuperAlterMsgGateSuperCmd"
ServiceEvent.GateSuperPushTyrantDbGateSuperCmd = "ServiceEvent_GateSuperPushTyrantDbGateSuperCmd"
ServiceEvent.GateSuperForwardToGateUserCmd = "ServiceEvent_GateSuperForwardToGateUserCmd"
ServiceEvent.GateSuperPushClientMsgGateSuperCmd = "ServiceEvent_GateSuperPushClientMsgGateSuperCmd"
ServiceEvent.GateSuperSendMessageGateSuperCmd = "ServiceEvent_GateSuperSendMessageGateSuperCmd"
