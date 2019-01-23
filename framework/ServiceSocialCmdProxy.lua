autoImport('ServiceSocialCmdAutoProxy')
ServiceSocialCmdProxy = class('ServiceSocialCmdProxy', ServiceSocialCmdAutoProxy)
ServiceSocialCmdProxy.Instance = nil
ServiceSocialCmdProxy.NAME = 'ServiceSocialCmdProxy'

function ServiceSocialCmdProxy:ctor(proxyName)
	if ServiceSocialCmdProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSocialCmdProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceSocialCmdProxy.Instance = self
	end
end
