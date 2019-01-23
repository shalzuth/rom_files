autoImport('ServiceSessionMailAutoProxy')
ServiceSessionMailProxy = class('ServiceSessionMailProxy', ServiceSessionMailAutoProxy)
ServiceSessionMailProxy.Instance = nil
ServiceSessionMailProxy.NAME = 'ServiceSessionMailProxy'

function ServiceSessionMailProxy:ctor(proxyName)
	if ServiceSessionMailProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSessionMailProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceSessionMailProxy.Instance = self
	end
end

function ServiceSessionMailProxy:CallGetMailAttach(id) 
	-- printOrange("Call-->GetMailAttach id:"..id);
	ServiceSessionMailProxy.super.CallGetMailAttach(self, id);
end


function ServiceSessionMailProxy:RecvQueryAllMail(data)
	-- printGreen("Recv-->QueryAllMail");
	PostProxy.Instance:AddUpdatePostDatas(data.datas)
	self:Notify(ServiceEvent.SessionMailQueryAllMail, data);
end

function ServiceSessionMailProxy:RecvMailUpdate(data)
	-- printGreen("Recv-->MailUpdate");
	PostProxy.Instance:AddUpdatePostDatas(data.updates)
	PostProxy.Instance:RemovePostData(data.dels)
	self:Notify(ServiceEvent.SessionMailMailUpdate, data);
end
