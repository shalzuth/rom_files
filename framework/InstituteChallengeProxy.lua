InstituteChallengeProxy = class('InstituteChallengeProxy', pm.Proxy)
InstituteChallengeProxy.Instance = nil;
InstituteChallengeProxy.NAME = "InstituteChallengeProxy"

function InstituteChallengeProxy:ctor(proxyName, data)
	self.proxyName = proxyName or InstituteChallengeProxy.NAME
	if(InstituteChallengeProxy.Instance == nil) then
		InstituteChallengeProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
end

function InstituteChallengeProxy:Init()
	self.curWave=0
	self.curscore=0
	self.maxscore=0
end

function InstituteChallengeProxy:RecvLaboratory(data)
	self.catchmax = self.maxscore;

	self.addScore=data.curscore-self.catchmax
	self.curWave=data.round
	self.curscore=data.curscore
	self.maxscore=data.maxscore
end





