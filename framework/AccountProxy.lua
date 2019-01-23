local AccountProxy = class('AccountProxy', pm.Proxy)

AccountProxy.Instance = nil;

AccountProxy.NAME = "AccountProxy"

--玩家背包数据管理

function AccountProxy:ctor(proxyName, data)
	self.proxyName = proxyName or AccountProxy.NAME
	if(AccountProxy.Instance == nil) then
		AccountProxy.Instance = self
	end
	
	self.accountName = ""
	self.passWord = ""
end

function AccountProxy:SetInfo( accountname,password )
	self.accountName = accountname
	self.passWord = password
end

return AccountProxy