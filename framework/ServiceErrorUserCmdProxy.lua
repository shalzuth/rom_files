autoImport('ServiceErrorUserCmdAutoProxy')
ServiceErrorUserCmdProxy = class('ServiceErrorUserCmdProxy', ServiceErrorUserCmdAutoProxy)
ServiceErrorUserCmdProxy.Instance = nil
ServiceErrorUserCmdProxy.NAME = 'ServiceErrorUserCmdProxy'

function ServiceErrorUserCmdProxy:ctor(proxyName)
	if ServiceErrorUserCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceErrorUserCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceErrorUserCmdProxy.Instance = self
	end
end

function ServiceErrorUserCmdProxy:RecvRegErrUserCmd(data)
	LogUtility.InfoFormat("<color=red>RecvRegErrUserCmd id:{0}</color>",data.ret)
	FunctionNetError.Me():ShowErrorById(data.ret, data.args)
	self:Notify(ServiceEvent.Error,data.ret)
end

function ServiceErrorUserCmdProxy:RecvMaintainUserCmd(data)
	LogUtility.InfoFormat("<color=red>RecvMaintainUserCmd id:{0}</color>",data.content)
	FloatingPanel.Instance:ShowMaintenanceMsg(
		ZhString.ServiceErrorUserCmdProxy_Maintain, 
		data.content, 
		data.tip, 
		ZhString.ServiceErrorUserCmdProxy_Confirm,
		data.picture);
	self:Notify(ServiceEvent.ErrorUserCmdMaintainUserCmd, data)
end
