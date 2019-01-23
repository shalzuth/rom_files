autoImport("ChangeHeadData")

ChangeHeadProxy = class('ChangeHeadProxy', pm.Proxy)
ChangeHeadProxy.Instance = nil;
ChangeHeadProxy.NAME = "ChangeHeadProxy"

function ChangeHeadProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ChangeHeadProxy.NAME
	if(ChangeHeadProxy.Instance == nil) then
		ChangeHeadProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
end

function ChangeHeadProxy:Init()
	self.portraitList = {}
end

function ChangeHeadProxy:RecvQueryPortraitList(data)
	if data.portrait then
		TableUtility.ArrayClear(self.portraitList)

		for i=1,#data.portrait do
			local changeHeadData = ChangeHeadData.new(data.portrait[i])
			TableUtility.ArrayPushBack(self.portraitList , changeHeadData)
		end
	end
end

function ChangeHeadProxy:RecvNewPortraitFrame(data)
	if data.portrait then		
		for i=1,#data.portrait do
			local changeHeadData = ChangeHeadData.new(data.portrait[i])
			TableUtility.ArrayPushBack(self.portraitList , changeHeadData)
		end
	end
end

function ChangeHeadProxy:GetPortraitList()
	return self.portraitList
end