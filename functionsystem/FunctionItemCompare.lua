FunctionItemCompare = class("FunctionItemCompare")

function FunctionItemCompare.Me()
	if nil == FunctionItemCompare.me then
		FunctionItemCompare.me = FunctionItemCompare.new()
	end
	return FunctionItemCompare.me
end

function FunctionItemCompare:ctor()
end

function FunctionItemCompare:TryRemove(item)
	if(item) then
		if(item:IsFashion()) then
			if(QuickUseProxy.Instance:RemoveNeverEquipedFashion(item.staticData.id,item:IsNew()==false)) then
				return true
			end
		elseif(item:IsEquip()) then
			self.profess = MyselfProxy.Instance:GetMyProfession()
			if(item.equipInfo:CanUseByProfess(self.profess)) then
				if(QuickUseProxy.Instance:RemoveBetterEquip(item)) then
					return true
				end
			end
		else
			local useConfig = Table_UseItem[item.staticData.id]
			if(useConfig and useConfig.AlertMode) then
				--根据使用表中alertmode字段判断是否需要右下角提示
				if(useConfig.AlertMode == 1) then
					if(QuickUseProxy.Instance:RemoveItemUse(item)) then
						return true
					end
				end
			end
		end
	end
end

function FunctionItemCompare:CompareItem(item,myselfLV)
	if(item and item.staticData) then
		--未被展示过
		self.equipItems = BagProxy.Instance:GetRoleEquipBag().siteMap
		self.profess = MyselfProxy.Instance:GetMyProfession()
		local useConfig = Table_UseItem[item.staticData.id]
		if(useConfig and useConfig.AlertMode) then
			--根据使用表中alertmode字段判断是否需要右下角提示
			if(useConfig.AlertMode == 1) then
				myselfLV = myselfLV or MyselfProxy.Instance:RoleLevel()
				local level = item.staticData.Level or 0
				if(useConfig.Alert_LimitLevel == nil or myselfLV <= useConfig.Alert_LimitLevel)then
					if(item.tempHint and myselfLV>=level and QuickUseProxy.Instance:AddItemUse(item)) then
						return true
					end
				end
			end
		else
			if(item:IsHint()) then
				myselfLV = myselfLV or MyselfProxy.Instance:RoleLevel()
				local level = item.staticData.Level or 0
				if(myselfLV>=level) then
					if(item:IsFashion()) then
						if(item:CanEquip())then
							if(not item:IsNew()) then
								if(QuickUseProxy.Instance:RemoveNeverEquipedFashion(item.staticData.id,true)) then
									return true
								end
							elseif(QuickUseProxy.Instance:AddNeverEquipedFashion(item)) then
								return true
							end
						end
					elseif(item:IsEquip()) then
						if(self:CompareEquip(item,self.profess,self.equipItems)) then
							return true
						end
					elseif(item.staticData.UseMode~=nil) then
						--普通道具也遵循Hint 展示规则
						-- helplog(item.staticData.id,"hint is true")
						return QuickUseProxy.Instance:AddItemUse(item)
					end
				end
			end
		end
		return false
	else
		errorLog("try to compare a nil item")
		return false
	end
end

function FunctionItemCompare:CompareEquip(item,profess,equipItems)
	equipItems = equipItems or BagProxy.Instance:GetRoleEquipBag().siteMap
	profess = profess or MyselfProxy.Instance:GetMyProfession()
	if(item.equipInfo:CanUseByProfess(profess)) then
		local sites = item.equipInfo:GetEquipSite()
		local better = false
		local site
		for i=1,#sites do
			local equipedPart = equipItems[sites[i]]
			if(item:CompareTo(equipedPart)) then
				better = true
				site = sites[i]
				break
			elseif(equipedPart~=nil and equipedPart.equipInfo:CanUseByProfess(profess)==false) then
				better = true
				site = sites[i]
				break
			end
		end

		if(better and QuickUseProxy.Instance:AddBetterEquip(item,site)) then
			return true
		end
	end
	return false
end

function FunctionItemCompare:CompareItems(items)
	self.myselfLV = MyselfProxy.Instance:RoleLevel()
	local dirty = false
	if(items and type(items) =="table") then
		for i=1,#items do
			if(self:CompareItem(items[i],self.myselfLV)) then
				dirty = true
			end
		end
	else
		errorLog("try to compare nil items")
		return
	end
	if(dirty) then
		GameFacade.Instance:sendNotification(ItemEvent.BetterEquipAdd)
	end
end

function FunctionItemCompare:SetHint(item)
	if(item and item.staticData) then
		local staticID = item.staticData.id
		-- send to server hint
		ServiceItemProxy.Instance:CallHintNtf(staticID)
		local items = BagProxy.Instance:GetItemsByStaticID(staticID)
		if(items) then
			for i=1,#items do
				items[i].isHint = false
			end
		end
	end
end

function FunctionItemCompare:TryCompare()
	local bag = BagProxy.Instance:GetMainBag()
	self:CompareItems(bag:GetItems())
end