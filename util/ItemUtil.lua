ItemUtil = {}

ItemUtil.staticRewardDropsItems = {}



-- {
-- 	{id = xx,num = xx},
-- 	{id = xx,num = xx},
-- 	{id = xx,num = xx},
-- }
-- return
function ItemUtil.GetRewardItemIdsByTeamId(teamId)
	return Game.Config_RewardTeam[teamId]
end

function ItemUtil.getAssetPartByItemData( itemId ,parent)
	-- body
	local partIndex = ItemUtil.getItemRolePartIndex(itemId)
	-- LogUtility.Info(itemId)
	if(partIndex)then
		local model = Asset_RolePart.Create( partIndex, itemId);	
		model:ResetParent(parent.transform);
		LogUtility.InfoFormat("getAssetPartByItemData parent.layer:{0}",LogUtility.ToString(parent.layer))
		model:SetLayer( parent.layer )
		return model
	end
end

-- function ItemUtil.checkIsMount( itemData )
-- 	-- body
-- 	if(itemData.Type)
-- end

function ItemUtil.getComposeMaterialsByComposeID(id)
	local compData = Table_Compose[id];
	local all, materials, failStay = {}, {}, {};
	if(compData)then
		if(compData.BeCostItem)then
			for i=1,#compData.BeCostItem do
				local id = compData.BeCostItem[i].id;
				local num = compData.BeCostItem[i].num;
				local tempItem = ItemData.new("Compose", id);
				tempItem.num = num;
				table.insert(all, tempItem);
			end
		end
		if(compData.FailStayItem)then
			local indexMap = {};
			for i=1,#compData.FailStayItem do
				local index = compData.FailStayItem[i];
				if(index)then
					indexMap[index] = 1;
				end
			end
			for i=1,#all do
				if(indexMap[i])then
					table.insert(failStay, all[i]);
				else
					table.insert(materials, all[i]);
				end
			end
		end
	end
	return all, materials, failStay;
end

function ItemUtil.getItemModel( itemData , parent)
	local rid = ItemUtil.getResourceIdByItemData(itemData);
	local result;
	if(rid)then
		if(parent)then
			result = GameObjPool.Instance:RGet(rid,"Pool_Item", parent);
		else
			result = GameObjPool.Instance:RGet(rid,"Pool_Item");
		end
	end
	return result;
end

function ItemUtil.checkEquipIsWeapon (type)
	for i=1,#Table_WeaponType do
		local single = Table_WeaponType[i]
		if(single.NameEn == type)then
			return true
		end		
	end			
end

function ItemUtil.checkIsFashion( itemId )
	-- body
	local itemData = Table_Item[itemId]
	if(itemData)then
		for k,v in pairs(GameConfig.ItemFashion) do
			for i=1,#v.types do
				local single = v.types[i]
				if(single == itemData.Type)then
					return true
				end
			end
		end
	end
end

function ItemUtil.getEquipPos(equipId)
	if(Table_Item[equipId])then
		local type = Table_Item[equipId].Type;
		for k,v in pairs(GameConfig.CardComposeType)do
			for kk,vv in pairs(v.types)do
				if(vv == type)then
					return k;
				end
			end
		end
	end
end

-- 获取时装穿脱的默认功能
function ItemUtil.getFashionDefaultEquipFunc(data)
	if(data.bagtype == BagProxy.BagType.RoleFashionEquip)then
		return FunctionItemFunc.Me():GetFunc("GetoutFashion");
	elseif(data.bagtype == BagProxy.BagType.RoleEquip)then
		return FunctionItemFunc.Me():GetFunc("Discharge");
	elseif(data.bagtype == BagProxy.BagType.MainBag)then
		return FunctionItemFunc.Me():GetFunc("Dress");
	end
end

function ItemUtil.getBufferDescById(bufferid)
	if(Table_Buffer[bufferid])then
		local bufferStr = Table_Buffer[bufferid].Dsc 
		if(not bufferStr or bufferStr == "")then
			bufferStr = Table_Buffer[bufferid].BuffName..ZhString.ItemUtil_NoBufferDes;
		end
		return bufferStr;
	else
		printRed("Can not find buffer"..tostring(bufferid));
		return "";
	end
end

-- buffer描述不读desc 前端自己拼
function ItemUtil.getBufferDescByIdNotConfigDes(bufferid)
	local result = "";
	local config = Table_Buffer[bufferid];
	if(config)then
		if(config.BuffEffect and config.BuffEffect.type == "AttrChange")then
			for key,value in pairs(config.BuffEffect)do
				local kprop = RolePropsContainer.config[key]
				if(kprop and kprop.displayName and value>0)then
					result = result..kprop.displayName.." [c][9fc33dff]+"..value.."[-][/c] ";
				end
			end
		end
	end
	return result;
end

function ItemUtil.getFashionItemRoleBodyPart(itemid,isMale)
	local equipData = Table_Equip[itemid]
	if(not equipData or not equipData.GroupID)then
		return equipData
	end
	local GroupID = equipData.GroupID
	local equipDatas = AdventureDataProxy.Instance.fashionGroupData[GroupID]
	if(not equipDatas or #equipDatas==0)then
		return 
	end

	for i=1,#equipDatas do
		local single = equipDatas[i]
		if(isMale and single.RealShowModel == 1)then
			return single
		elseif(not isMale and single.RealShowModel == 2)then
			return single
		end
	end
	return equipDatas[1]
end

function ItemUtil.getItemRolePartIndex(itemid)
	if(Table_Mount[itemid])then
		return Asset_Role.PartIndex.Mount;
	elseif(Table_Equip[itemid])then
		local typeId = Table_Equip[itemid].EquipType;
		if(typeId == 1 or typeId == 21 )then
			return Asset_Role.PartIndex.RightWeapon;
		elseif(typeId == 8)then
			return Asset_Role.PartIndex.Head;
		elseif(typeId == 9)then
			return Asset_Role.PartIndex.Wing;
		elseif(typeId == 10)then
			return Asset_Role.PartIndex.Face;
		elseif(typeId == 11)then
			return Asset_Role.PartIndex.Tail;
		elseif(typeId == 13)then
			return Asset_Role.PartIndex.Mouth;
		elseif(Table_Equip[itemid].Body)then
			return Asset_Role.PartIndex.Body;
		else
			local mtype = Table_Equip[itemid].Type;
			if(mtype == "Head")then
				return Asset_Role.PartIndex.Head;
			elseif(mtype == "Wing")then
				return Asset_Role.PartIndex.Wing;
			end
		end
	else
		local itemType = Table_Item[itemid].Type;
		if(itemType == 823 or itemType == 824)then
			return Asset_Role.PartIndex.Eye;
		elseif(itemType == 820 or itemType == 821 or itemType == 822)then
			return Asset_Role.PartIndex.Hair;
		end
	end
	return 0;
end

function ItemUtil.AddItemsTrace(datas)
	local traceDatas = {};
	for i=1,#datas do
		local data = datas[i];
		local staticId = data.staticData.id;
		local cell = QuestProxy:GetTraceCell(QuestDataType.QuestDataType_ITEMTR, data.staticData.id);
		if(not cell)then
			local odata = GainWayTipProxy.Instance:GetItemOriginMonster(staticId)
			local itemName = odata.name;
			local haveNum = BagProxy.Instance:GetAllItemNumByStaticID(staticId);
			local origin = odata.origins and odata.origins[1]
			if(origin)then
				local traceData = {
					type = QuestDataType.QuestDataType_ITEMTR, 
					questDataStepType = QuestDataStepType.QuestDataStepType_MOVE,
					id = staticId,
					map = origin.mapID,
					pos = origin.pos,
					traceTitle = ZhString.MainViewSealInfo_TraceTitle,
					traceInfo = string.format(ZhString.ItemUtil_ItemTraceInfo, itemName, haveNum),   
				};
				table.insert(traceDatas, traceData);
			else
				errorLog(string.format(ZhString.ItemUtil_NoMonsterDrop, staticId));
			end
			
		end
	end
	if(#traceDatas>0)then
		QuestProxy.Instance:AddTraceCells(traceDatas);
	end
end

function ItemUtil.CancelItemTrace(data)
	QuestProxy.Instance:RemoveTraceCell(QuestDataType.QuestDataType_ITEMTR, data.staticData.id);
end

function ItemUtil.CheckItemIsSpecialInAdventureAppend( itemType )
	-- body
	for i=1,#GameConfig.AdventureAppendSpecialItemType do
		local single = GameConfig.AdventureAppendSpecialItemType[i]
		if(single == itemType)then
			return true
		end
	end
end


function ItemUtil.GetComposeItemByBlueItem( itemData )
	if(itemData and 50 == itemData.Type)then
		local compose = Table_Compose[itemData.id]
		if(compose)then
			return compose.Product.id
		end
	end
end

function ItemUtil.GetDeath_Drops( monsterId )
	-- body
	if(ItemUtil.staticRewardDropsItems[monsterId])then
		return ItemUtil.staticRewardDropsItems[monsterId]
	end	

	local tempArray = {}
	local staticData = Table_Monster[monsterId]
	if(staticData and staticData.Dead_Reward and #staticData.Dead_Reward >0)then
		for i=1,#staticData.Dead_Reward do
			local rewardTeamID=staticData.Dead_Reward[i]
			local list = ItemUtil.GetRewardItemIdsByTeamId(rewardTeamID)
			if(list)then
				for j=1,#list do
					local single = list[j]
					local hasAdd = false
					for j=1,#tempArray do
						local tmp = tempArray[j]
						if(tmp.itemData.id == single.id)then
							tmp.num = tmp.num+single.num
							hasAdd = true
							break
						end
					end
					if(not hasAdd)then
						local data = {};
						data.itemData = Table_Item[single.id]
						if(data.itemData)then
							data.num = single.num
							table.insert(tempArray, data);
						end
					end
				end
			end
		end
		ItemUtil.staticRewardDropsItems[monsterId] = tempArray
		return ItemUtil.staticRewardDropsItems[monsterId]
	end
end
-- 获取装备附魔成功概率
function ItemUtil.GetEquipEnchantEffectSucRate(attriType)
	
end

-- 获取装备附魔成功概率
local useCodeItemId
function ItemUtil.SetUseCodeCmd(data)
	useCodeItemId = data.id
end

function ItemUtil.HandleUseCodeCmd(data)
	if(useCodeItemId and data.guid == useCodeItemId)then
		useCodeItemId = nil
		local url = string.format(ZhString.KFCShareURL,Game.Myself.data.id,data.code)
		Application.OpenURL(url)
	end
end