UIModelMiyinStrengthen = class('UIModelMiyinStrengthen')

function UIModelMiyinStrengthen:Ins()
	if UIModelMiyinStrengthen.ins == nil then
		UIModelMiyinStrengthen.ins = UIModelMiyinStrengthen.new()
	end
	return UIModelMiyinStrengthen.ins
end

function UIModelMiyinStrengthen:GetEquipedItems()
	local equipedItems = BagProxy.Instance.roleEquip:GetItems()
	local validEquipItems = nil
	if equipedItems ~= nil and #equipedItems > 0 then
		for i=1, #equipedItems do
			local equipedItem = equipedItems[i]
			if equipedItem ~= nil then
				local equipInfo = equipedItem.equipInfo
				if equipInfo ~= nil and equipInfo:CanStrength() then
					if validEquipItems == nil then
						validEquipItems = {}
					end
					table.insert(validEquipItems, equipedItem);
				end
			end
		end
	end
	equipedItems = BagProxy.Instance.bagData:GetItems()
	if equipedItems ~= nil and #equipedItems > 0 then
		for i=1, #equipedItems do
			local equipedItem = equipedItems[i]
			if equipedItem ~= nil then
				local equipInfo = equipedItem.equipInfo
				if equipInfo ~= nil and equipInfo:CanStrength() then
					if validEquipItems == nil then
						validEquipItems = {}
					end
					table.insert(validEquipItems, equipedItem);
				end
			end
		end
	end
	return validEquipItems
end

function UIModelMiyinStrengthen:GetEquipedItems_ValidPart()
	local equipedItems = self:GetEquipedItems()
	if equipedItems ~= nil then
		local validEquipedItems = nil
		for i = 1, #equipedItems do
			local equipedItem = equipedItems[i]
			local equipType = equipedItem.equipInfo.equipData.EquipType
			if self:IsCouldStrengthen(equipType) then
				if validEquipedItems == nil then
					validEquipedItems = {}
				end
				table.insert(validEquipedItems, equipedItem)
			end
		end
		return validEquipedItems
	end
	return nil
end

function UIModelMiyinStrengthen:IsCouldStrengthen(equip_type)
	local couldStrengthenTypes = nil
	local buildingLevel = GuildBuildingProxy.Instance:GetBuildingLevelByType(GuildBuildingProxy.Type.EGUILDBUILDING_MAGIC_SEWING)
	for k, v in pairs(Table_GuildBuilding) do
		local guildBuildingConf = v
		if guildBuildingConf.Type == 4 and guildBuildingConf.Level == buildingLevel then
			couldStrengthenTypes = guildBuildingConf.UnlockParam.equip.strength_type
			break
		end
	end
	return table.ContainsValue(couldStrengthenTypes, equip_type)
end

local miyinConfID = 5030
function UIModelMiyinStrengthen:GetOwnMiyinCount()
	return BagProxy.Instance:GetItemNumByStaticID(miyinConfID)
end