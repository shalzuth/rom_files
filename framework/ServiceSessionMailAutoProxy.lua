ServiceSessionMailAutoProxy = class("ServiceSessionMailAutoProxy", ServiceProxy)
ServiceSessionMailAutoProxy.Instance = nil
ServiceSessionMailAutoProxy.NAME = "ServiceSessionMailAutoProxy"
function ServiceSessionMailAutoProxy:ctor(proxyName)
  if ServiceSessionMailAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSessionMailAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSessionMailAutoProxy.Instance = self
  end
end
function ServiceSessionMailAutoProxy:Init()
end
function ServiceSessionMailAutoProxy:onRegister()
  self:Listen(55, 1, function(data)
    self:RecvQueryAllMail(data)
  end)
  self:Listen(55, 2, function(data)
    self:RecvMailUpdate(data)
  end)
  self:Listen(55, 3, function(data)
    self:RecvGetMailAttach(data)
  end)
  self:Listen(55, 4, function(data)
    self:RecvMailRead(data)
  end)
  self:Listen(55, 5, function(data)
    self:RecvMailRemove(data)
  end)
end
function ServiceSessionMailAutoProxy:CallQueryAllMail(datas)
  local msg = SessionMail_pb.QueryAllMail()
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionMailAutoProxy:CallMailUpdate(updates, dels)
  local msg = SessionMail_pb.MailUpdate()
  if updates ~= nil then
    for i = 1, #updates do
      table.insert(msg.updates, updates[i])
    end
  end
  if dels ~= nil then
    for i = 1, #dels do
      table.insert(msg.dels, dels[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionMailAutoProxy:CallGetMailAttach(ids)
  local msg = SessionMail_pb.GetMailAttach()
  if ids ~= nil then
    for i = 1, #ids do
      table.insert(msg.ids, ids[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionMailAutoProxy:CallMailRead(id)
  local msg = SessionMail_pb.MailRead()
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
function ServiceSessionMailAutoProxy:CallMailRemove(ids)
  local msg = SessionMail_pb.MailRemove()
  if ids ~= nil then
    for i = 1, #ids do
      table.insert(msg.ids, ids[i])
    end
  end
  self:SendProto(msg)
end
function ServiceSessionMailAutoProxy:RecvQueryAllMail(data)
  self:Notify(ServiceEvent.SessionMailQueryAllMail, data)
end
function ServiceSessionMailAutoProxy:RecvMailUpdate(data)
  self:Notify(ServiceEvent.SessionMailMailUpdate, data)
end
function ServiceSessionMailAutoProxy:RecvGetMailAttach(data)
  self:Notify(ServiceEvent.SessionMailGetMailAttach, data)
end
function ServiceSessionMailAutoProxy:RecvMailRead(data)
  self:Notify(ServiceEvent.SessionMailMailRead, data)
end
function ServiceSessionMailAutoProxy:RecvMailRemove(data)
  self:Notify(ServiceEvent.SessionMailMailRemove, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SessionMailQueryAllMail = "ServiceEvent_SessionMailQueryAllMail"
ServiceEvent.SessionMailMailUpdate = "ServiceEvent_SessionMailMailUpdate"
ServiceEvent.SessionMailGetMailAttach = "ServiceEvent_SessionMailGetMailAttach"
ServiceEvent.SessionMailMailRead = "ServiceEvent_SessionMailMailRead"
ServiceEvent.SessionMailMailRemove = "ServiceEvent_SessionMailMailRemove"
