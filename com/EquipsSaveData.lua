autoImport("EquipsInfoSaveData")
EquipsSaveData = class("EquipsSaveData")

function EquipsSaveData:ctor(serverequipdata, storageId)
	self.storageId = storageId
	self.pacakgeType = serverequipdata.type
	self.equipsSave = {}
	if serverequipdata.datas then
		local n = #serverequipdata.datas
		for i=1,n do
			local single = EquipsInfoSaveData.new(serverequipdata.datas[i])
			table.insert(self.equipsSave,single)
		end
	end
end

function EquipsSaveData:GetEquipInfos()
	return self.equipsSave;
end
