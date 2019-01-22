autoImport('ServiceOverseasTaiwanCmdAutoProxy')
ServiceOverseasTaiwanCmdProxy = class('ServiceOverseasTaiwanCmdProxy', ServiceOverseasTaiwanCmdAutoProxy)
ServiceOverseasTaiwanCmdProxy.Instance = nil
ServiceOverseasTaiwanCmdProxy.NAME = 'ServiceOverseasTaiwanCmdProxy'

function ServiceOverseasTaiwanCmdProxy:ctor(proxyName)
	if ServiceOverseasTaiwanCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceOverseasTaiwanCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceOverseasTaiwanCmdProxy.Instance = self
	end
end

function ServiceOverseasTaiwanCmdProxy:GetUpLoadSign(type,photoId)
	LogUtility.InfoFormat("type:{0} photoId:{1}",type,photoId)
	self:CallOverseasPhotoUploadCmd(type,photoId)
end

function ServiceOverseasTaiwanCmdProxy:RecvOverseasPhotoUploadCmd(data)
	self:Notify(ServiceEvent.OverseasTaiwanCmdOverseasPhotoUploadCmd, data)
	EventManager.Me():PassEvent(ServiceEvent.OverseasTaiwanCmdOverseasPhotoUploadCmd, data)
end


downloadCallbacks = {}

function ServiceOverseasTaiwanCmdProxy:GetDownLoadPath(type,callback)
	local callbackKey = 'cb_' ..type
	downloadCallbacks[callbackKey] = callback
	self:CallOverseasPhotoPathPrefixCmd(type)
end

function ServiceOverseasTaiwanCmdProxy:RecvOverseasPhotoPathPrefixCmd(data)
	local callbackKey = 'cb_' .. data.type
	local callback = downloadCallbacks[callbackKey]
	if(callback ~= nil)then
		callback(data)
		downloadCallbacks[callbackKey] = nil
	end
end