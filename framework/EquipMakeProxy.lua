autoImport("EquipMakeData")

EquipMakeProxy = class('EquipMakeProxy', pm.Proxy)
EquipMakeProxy.Instance = nil;
EquipMakeProxy.NAME = "EquipMakeProxy"

local packageCheck = GameConfig.PackageMaterialCheck and GameConfig.PackageMaterialCheck.produce

function EquipMakeProxy:ctor(proxyName, data)
	self.proxyName = proxyName or EquipMakeProxy.NAME
	if(EquipMakeProxy.Instance == nil) then
		EquipMakeProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
end

function EquipMakeProxy:Init()
	self.makeList = {}
	self.makeTable = {}
	self.selfProfessionMakeList = {}
	self.lastNpcId = 0
end

function EquipMakeProxy:InitMakeList()
	TableUtility.ArrayClear(self.makeList)

	for k,v in pairs(Table_Compose) do
		if v.Category == 1 and v.NpcId == self.npcId then
			self.makeList[#self.makeList + 1] = k

			if self.makeTable[k] == nil then
				self.makeTable[k] = EquipMakeData.new(k)
			end
		end
	end

	table.sort(self.makeList ,function(l,r)
		local lData = self.makeTable[l]
		local rData = self.makeTable[r]

		if lData:IsLock() == rData:IsLock() then
			if lData.itemData:CanEquip() ~= rData.itemData:CanEquip() then
				return lData.itemData:CanEquip()
			end
		else
			return not lData:IsLock()
		end
	end)

	self.lastNpcId = self.npcId
end

function EquipMakeProxy:SetNpcId(npcId)
	self.npcId = npcId
end

function EquipMakeProxy:GetMakeList()
	if self.lastNpcId ~= self.npcId then
		self:InitMakeList()
	end

	return self.makeList
end

function EquipMakeProxy:GetSelfProfessionMakeList()

	TableUtility.ArrayClear(self.selfProfessionMakeList)

	for i=1,#self.makeList do
		local composeId = self.makeList[i]
		local makeData = self.makeTable[composeId]
		if makeData and makeData.itemData:CanEquip() then
			self.selfProfessionMakeList[#self.selfProfessionMakeList + 1] = composeId
		end
	end

	return self.selfProfessionMakeList
end

function EquipMakeProxy:GetMakeData(composeId)
	return self.makeTable[composeId]
end

function EquipMakeProxy:GetItemNumByStaticID(itemid)
	local _BagProxy = BagProxy.Instance
	local count = 0
	for i=1,#packageCheck do
		count = count + _BagProxy:GetItemNumByStaticID(itemid, packageCheck[i])
	end
	return count
end