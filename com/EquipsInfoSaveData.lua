EquipsInfoSaveData = class("EquipsInfoSaveData")

function EquipsInfoSaveData:ctor(serverequipinfo)
	if serverequipinfo then
		self.pos = serverequipinfo.pos
		self.type_id = serverequipinfo.type_id
		self.guid = serverequipinfo.guid
	end
end


function EquipsInfoSaveData:CheckValid()
	local bagData = BagProxy.Instance:GetBagByType(BagProxy.BagType.MainBag)
	local data1 = bagData:GetItemByGuid(self.guid)
	if data1 then return true end
	
	bagData = BagProxy.Instance:GetBagByType(BagProxy.BagType.Storage)
	data = storageBagdata:GetItemByGuid(self.guid)
	if data then return true end

	bagData = BagProxy.Instance:GetBagByType(BagProxy.BagType.RoleEquip)
	data = storageBagdata:GetItemByGuid(self.guid)
	if data then return true end

	bagData = BagProxy.Instance:GetBagByType(BagProxy.BagType.RoleFashionEquip)
	data = storageBagdata:GetItemByGuid(self.guid)
	if data then return true end

	return false
end