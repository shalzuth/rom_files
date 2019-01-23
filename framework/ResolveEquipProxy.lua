ResolveEquipProxy = class('ResolveEquipProxy', pm.Proxy)
ResolveEquipProxy.Instance = nil;
ResolveEquipProxy.NAME = "ResolveEquipProxy"

function ResolveEquipProxy:ctor(proxyName, data)
	self.proxyName = proxyName or ResolveEquipProxy.NAME
	if(ResolveEquipProxy.Instance == nil) then
		ResolveEquipProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end
	self:Init()
end

function ResolveEquipProxy:Init()
	--self.ResolveResultNums=1
	--self.ResolveResultObtainEquips={}
	--self.ResolveResultObtainMaterials={}
	--self.ResolveResultObtainROB=0
end

function ResolveEquipProxy:UpdateQueryEquipData(data)
	if(data)then
		self.QueryEquipData=data
	else
		print("Update Query Equip Data is nil")
	end
end

function ResolveEquipProxy:CalculateResolveEquip()
	
end