autoImport("ServiceSessionMailAutoProxy")
ServiceSessionMailProxy = class("ServiceSessionMailProxy", ServiceSessionMailAutoProxy)
ServiceSessionMailProxy.Instance = nil
ServiceSessionMailProxy.NAME = "ServiceSessionMailProxy"
function ServiceSessionMailProxy:ctor(proxyName)
  if ServiceSessionMailProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSessionMailProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSessionMailProxy.Instance = self
  end
end
function ServiceSessionMailProxy:CallGetMailAttach(id)
  ServiceSessionMailProxy.super.CallGetMailAttach(self, id)
end
function ServiceSessionMailProxy:RecvQueryAllMail(data)
  PostProxy.Instance:AddUpdatePostDatas(data.datas)
  self:Notify(ServiceEvent.SessionMailQueryAllMail, data)
end
function ServiceSessionMailProxy:RecvMailUpdate(data)
  PostProxy.Instance:AddUpdatePostDatas(data.updates)
  PostProxy.Instance:RemovePostData(data.dels)
  self:Notify(ServiceEvent.SessionMailMailUpdate, data)
  if #data.dels > 0 then
    GameFacade.Instance:sendNotification(PostEvent.PostDelete)
  end
end
