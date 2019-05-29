autoImport("ServiceRecordCmdAutoProxy")
ServiceRecordCmdProxy = class("ServiceRecordCmdProxy", ServiceRecordCmdAutoProxy)
ServiceRecordCmdProxy.Instance = nil
ServiceRecordCmdProxy.NAME = "ServiceRecordCmdProxy"
function ServiceRecordCmdProxy:ctor(proxyName)
  if ServiceRecordCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceRecordCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceRecordCmdProxy.Instance = self
  end
end
