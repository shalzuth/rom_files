ProfessionInfoViewProxy = class('ProfessionInfoViewProxy', pm.Proxy)
ProfessionInfoViewProxy.Instance = nil;
ProfessionInfoViewProxy.NAME = "ProfessionInfoViewProxy"

function ProfessionInfoViewProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ProfessionInfoViewProxy.NAME
	if(ProfessionInfoViewProxy.Instance == nil) then
		ProfessionInfoViewProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
	self:AddEvts()
end

function ProfessionInfoViewProxy:Init()

end

function ProfessionInfoViewProxy:AddEvts()

end

return PushProxy

