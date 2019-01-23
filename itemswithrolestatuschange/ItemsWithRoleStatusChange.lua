ItemsWithRoleStatusChange = class("ItemsWithRoleStatusChange")

function ItemsWithRoleStatusChange:Instance()
	if ItemsWithRoleStatusChange.instance == nil then
		ItemsWithRoleStatusChange.instance = ItemsWithRoleStatusChange.new()
	end
	return ItemsWithRoleStatusChange.instance
end

function ItemsWithRoleStatusChange:OnReceiveStatusChange(message)
	if message.propVO.name == "StateEffect" then
		local propertyValue = message:GetValue()
		local status = {}
		local bitCount = 32
		for i = 0, bitCount - 1 do
			local bitValue = BitUtil.band(propertyValue, i)
			if bitValue > 0 then
				table.insert(status, i + 1);
			end
		end
		local allItemTypes = {}
		self.itemTypesForbidden = {}
		for k, v in pairs(GameConfig.ItemsNoUseWhenRoleStates) do
			local statusBitIndex = k
			local itemTypes = v
			for _, v in pairs(itemTypes) do
				local itemType = v
				if not table.ContainsValue(allItemTypes, itemType) then
					table.insert(allItemTypes, itemType)
				end
				if table.ContainsValue(status, statusBitIndex) then
					if not table.ContainsValue(self.itemTypesForbidden, itemType) then
						table.insert(self.itemTypesForbidden, itemType)
					end
				end
			end
		end
		local itemTypesCouldUse = {}
		for _, v in pairs(allItemTypes) do
			local itemType = v
			if not table.ContainsValue(self.itemTypesForbidden, itemType) then
				table.insert(itemTypesCouldUse, itemType)
			end
		end
		for i, v in pairs(itemTypesCouldUse) do
			local itemType = v
			local itemsData = BagProxy.Instance:GetBagItemsByType(itemType)
			for _, v in pairs(itemsData) do
				local itemData = v
				itemData.couldUseWithRoleStatus = true
			end
		end
		for i, v in pairs(self.itemTypesForbidden) do
			local itemType = v
			local itemsData = BagProxy.Instance:GetBagItemsByType(itemType)
			for _, v in pairs(itemsData) do
				local itemData = v
				itemData.couldUseWithRoleStatus = false
			end
		end
		GameFacade.Instance:sendNotification(ItemEvent.ItemUpdate)
	end
end

function ItemsWithRoleStatusChange:AddBuffLimitUseItem(canUseTypes, forbidAll)
	local dirty = false
	if canUseTypes ~= nil then
		if self.buffLimitItemTypes == nil then
			self.buffLimitItemTypes = {}
			self.buffLimitItemTypes.count = 0
		end
		for i=1,#canUseTypes do
			self:_AddData(self.buffLimitItemTypes, canUseTypes[i])
		end

		dirty = true
	end

	if forbidAll == 1 then
		if self.isForbidAll == nil then
			self.isForbidAll = 0
		end
		self.isForbidAll = self.isForbidAll + 1

		dirty = true
	end

	if dirty then
		GameFacade.Instance:sendNotification(ItemEvent.ItemUpdate)
	end
end

function ItemsWithRoleStatusChange:RemoveBuffLimitUseItem(canUseTypes, forbidAll)
	local dirty = false
	if canUseTypes ~= nil and self.buffLimitItemTypes ~= nil then
		for i=1,#canUseTypes do
			self:_RemoveData(self.buffLimitItemTypes, canUseTypes[i])
		end

		dirty = true
	end

	if forbidAll == 1 and self.isForbidAll ~= nil then
		self.isForbidAll = self.isForbidAll - 1

		dirty = true
	end

	if dirty then
		GameFacade.Instance:sendNotification(ItemEvent.ItemUpdate)
	end
end

function ItemsWithRoleStatusChange:ItemIsCouldUseWithCurrentStatus(item_type)
	if self.isForbidAll ~= nil and self.isForbidAll > 0 then
		return false
	end

	local canUse = not table.ContainsValue(self.itemTypesForbidden, item_type)
	if canUse then
		if self.buffLimitItemTypes ~= nil and self.buffLimitItemTypes.count > 0 then
			local count = self.buffLimitItemTypes[item_type]
			return count ~= nil and count > 0
		end
	end

	return canUse
end

function ItemsWithRoleStatusChange:AddBuffForbidEquip(buffEffect)
	local dirty = false
	if buffEffect ~= nil then
		for k,v in pairs(buffEffect) do
			if type(k) == "number" then
				local forbid_on_pos = v.forbid_on_pos
				if forbid_on_pos ~= nil then
					if self.buffForbidOnSites == nil then
						self.buffForbidOnSites = {}
					end
					local data = self.buffForbidOnSites[k]
					if data == nil then
						data = {}
						data.count = 0
						self.buffForbidOnSites[k] = data
					end
					for i=1,#forbid_on_pos do
						self:_AddData(self.buffForbidOnSites[k], forbid_on_pos[i])

						dirty = true
					end
				end

				local forbid_off_pos = v.forbid_off_pos
				if forbid_off_pos ~= nil then
					if self.buffForbidOffSites == nil then
						self.buffForbidOffSites = {}
					end
					local data = self.buffForbidOffSites[k]
					if data == nil then
						data = {}
						data.count = 0
						self.buffForbidOffSites[k] = data
					end
					for i=1,#forbid_off_pos do
						self:_AddData(self.buffForbidOffSites[k], forbid_off_pos[i])

						dirty = true
					end
				end
			end
		end
	end

	if dirty then
		GameFacade.Instance:sendNotification(ItemEvent.ItemUpdate)
	end
end

function ItemsWithRoleStatusChange:RemoveBuffForbidEquip(buffEffect)
	local dirty = false
	if buffEffect ~= nil then
		for k,v in pairs(buffEffect) do
			if type(k) == "number" then
				local forbid_on_pos = v.forbid_on_pos
				if forbid_on_pos ~= nil and self.buffForbidOnSites ~= nil and self.buffForbidOnSites[k] ~= nil then
					for i=1,#forbid_on_pos do
						self:_RemoveData(self.buffForbidOnSites[k], forbid_on_pos[i])

						dirty = true
					end
				end

				local forbid_off_pos = v.forbid_off_pos
				if forbid_off_pos ~= nil and self.buffForbidOffSites ~= nil and self.buffForbidOffSites[k] ~= nil then
					for i=1,#forbid_off_pos do
						self:_RemoveData(self.buffForbidOffSites[k], forbid_off_pos[i])

						dirty = true
					end
				end
			end
		end
	end

	if dirty then
		GameFacade.Instance:sendNotification(ItemEvent.ItemUpdate)
	end
end

function ItemsWithRoleStatusChange:CanEquipWithCurrentStatus(bagtype, sites)
	if self.buffForbidOnSites ~= nil then
		local data = self.buffForbidOnSites[bagtype]
		if data ~= nil and data.count > 0 then
			for i=1,#sites do
				local count = data[sites[i]]
				if count ~= nil and count > 0 then
					return false
				end
			end
		end
	end

	return true
end

function ItemsWithRoleStatusChange:CanOffEquipWithCurrentStatus(bagtype, sites)
	if self.buffForbidOffSites ~= nil then
		local data = self.buffForbidOffSites[bagtype]
		if data ~= nil and data.count > 0 then
			for i=1,#sites do
				local count = data[sites[i]]
				if count ~= nil and count > 0 then
					return false
				end
			end
		end
	end

	return true
end

function ItemsWithRoleStatusChange:_AddData(map, data)
	local count = map[data]
	if count == nil then
		count = 0
		map[data] = count
		map.count = map.count + 1
	end
	map[data] = count + 1
end

function ItemsWithRoleStatusChange:_RemoveData(map, data)
	local count = map[data]
	if count ~= nil then
		local result = count - 1
		if result == 0 then
			result = nil
			map.count = map.count - 1
		end
		map[data] = result
	end
end