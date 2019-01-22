autoImport("RefineTypeData")
BlackSmithProxy = class('BlackSmithProxy', pm.Proxy)

BlackSmithProxy.Instance = nil;

BlackSmithProxy.NAME = "BlackSmithProxy"
BlackSmithProxy.RefineLimitQuality = 3
--?????????????????????

function BlackSmithProxy:ctor(proxyName, data)
	self.proxyName = proxyName or BlackSmithProxy.NAME
	if(BlackSmithProxy.Instance == nil) then
		BlackSmithProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end	
	-- self:InitMaster()
	self:ParseRefineConfig()

	self:InitHighRefineCompose();
	self:IntiHighRefine();
end

function BlackSmithProxy:onRegister()
end

function BlackSmithProxy:onRemove()
end

function BlackSmithProxy:ParseRefineConfig()
	self.refineDataMap = {}
	local data
	local t
	local refineTypeData
	for k,v in pairs(Table_EquipRefine) do
		data = v
		for j=1,#data.EuqipType do
			t = data.EuqipType[j]
			refineTypeData = self.refineDataMap[t]
			if(not refineTypeData) then
				refineTypeData = RefineTypeData.new(t)
				self.refineDataMap[t] = refineTypeData
			end
			refineTypeData:AddData(data)
		end
	end
end

function BlackSmithProxy:InitMaster()
	self.strengthMaster = {}
	self.refineMaster = {}
	local data
	local index
	for i=1,#Table_EquipMaster do
		data = Table_EquipMaster[i]
		if(data.type=="StrengthenMaster") then
			index = #self.strengthMaster+1
			self.strengthMaster[index] = data
		elseif(data.type=="RefineMaster")then
			index = #self.refineMaster+1
			self.refineMaster[index] = data
		end
		data.dynamicIndex = index
	end
end

function BlackSmithProxy:SearchMasterByLv(array,lv)
	for i=1,#array do
		if(array[i].Needlv == lv) then
			return array[i]
		end
	end
	return nil
end

function BlackSmithProxy:GetSafeRefineClamp(islottery)
	local cfg = islottery and GameConfig.SafeRefineEquipCostLottery or GameConfig.SafeRefineEquipCost;

	local min, max;
	for k, v in pairs(cfg)do
		local s = v;
		if(type(v) == "table")then
			s = v[1];
		end
		if(s ~= 0)then
			min = min == nil and k or math.min(min, k);
			max = max == nil and k or math.max(max, k);
		end
	end
	return min, max;
end

function BlackSmithProxy:GetNextStrengthMaster(data)
	return self.strengthMaster[(data and data.dynamicIndex or 0) + 1]
end

function BlackSmithProxy:GetNextRefineMaster(data)
	return self.refineMaster[(data and data.dynamicIndex or 0) + 1]
end

function BlackSmithProxy:GetStrengthMaster(lv)
	return self:SearchMasterByLv(self.strengthMaster,lv)
end

function BlackSmithProxy:GetRefineEquips(valid_equiptype_map, includeFashion)
	local result = {};

	if(includeFashion)then
		local fashionEquips = BagProxy.Instance.fashionBag:GetItems();

		local equipInfo;
		for i=1,#fashionEquips do
			equipInfo = fashionEquips[i].equipInfo;

			if(equipInfo)then
				if(valid_equiptype_map)then
					if(valid_equiptype_map[equipInfo.equipData.EquipType])then
						if(equipInfo:CanRefine())then
							table.insert(result, fashionEquips[i]);
						end
					end
				else
					if(equipInfo:CanRefine())then
						table.insert(result, fashionEquips[i]);
					end
				end
			end
		end
	end

	local roleEquips = BagProxy.Instance.roleEquip:GetItems();

	local equipInfo;
	for i=1,#roleEquips do
		equipInfo = roleEquips[i].equipInfo;

		if(equipInfo)then
			if(valid_equiptype_map)then
				if(valid_equiptype_map[equipInfo.equipData.EquipType])then
					if(equipInfo:CanRefine())then
						table.insert(result, roleEquips[i]);
					end
				end
			else
				if(equipInfo:CanRefine())then
					table.insert(result, roleEquips[i]);
				end
			end
		end
	end

	local items = BagProxy.Instance:GetBagEquipTab():GetItems();
	for i=1,#items do
		equipInfo = items[i].equipInfo;

		if(equipInfo)then
			if(valid_equiptype_map)then
				if(valid_equiptype_map[equipInfo.equipData.EquipType])then
					if(equipInfo:CanRefine())then
						table.insert(result, items[i]);
					end
				end
			else
				if(equipInfo:CanRefine())then
					table.insert(result, items[i]);
				end
			end
		end
	end

	table.sort(result, BlackSmithProxy.SortRefineEquips)

	return result;
end

function BlackSmithProxy.SortRefineEquips(l, r)
	local leuqipInfo = l.equipInfo;
	local reuqipInfo = r.equipInfo;

	if(l.equiped ~= r.equiped)then
		return l.equiped > r.equiped;
	end

	if(l.staticData.id ~= r.staticData.id)then
		return l.staticData.id > r.staticData.id;
	end

	return leuqipInfo.refinelv > reuqipInfo.refinelv;
end

function BlackSmithProxy:GetRefineMaster(lv)
	return self:SearchMasterByLv(self.refineMaster,lv)
end

function BlackSmithProxy:MaxStrengthLevel(item)
	local retValue = 0
	-- local equip = item.equipInfo;
	-- retValue = equip.equipData.EnhanceMaxlv
	retValue = MyselfProxy.Instance:RoleLevel()
	return retValue
end

function BlackSmithProxy:SetEquipOptDiscounts(etype, params)
	if(self.equipOptDiscount_Map == nil)then
		self.equipOptDiscount_Map = {};
	end
	
	local discounts = self.equipOptDiscount_Map[etype];
	if(discounts == nil)then
		discounts = {};
		self.equipOptDiscount_Map[etype] = discounts;
	else
		TableUtility.ArrayClear(discounts);
	end

	if(params ~= nil and params[2])then
		TableUtility.ArrayShallowCopy(discounts, params);
	end
end

function BlackSmithProxy:GetEquipOptDiscounts(etype)
	if(self.equipOptDiscount_Map == nil)then
		return _EmptyTable;
	end
	return self.equipOptDiscount_Map[etype];
end

function BlackSmithProxy:GetSafeRefineCostEquipNum(refinelv, islottery)
	if(refinelv == nil)then
		return;
	end

	local cfg = islottery and GameConfig.SafeRefineEquipCostLottery or GameConfig.SafeRefineEquipCost;

	local scfg = cfg[refinelv];
	if(scfg == nil)then
		return;
	end

	local indiscount = self:GetEquipOptDiscounts(ActivityCmd_pb.GACTIVITY_SAFE_REFINE_DISCOUNT);
	indiscount = indiscount and indiscount[2] or false;
	local result;
	if(type(scfg) == "table")then
		result = indiscount and scfg[2] or scfg[1];
	else
		result = scfg;
	end

	return result;
end



-- materials begin
function BlackSmithProxy.SortMaterialEquips(equipA, equipB)
	local slotA, slotB = equipA.cardSlotNum, equipB.cardSlotNum;
	if(slotA ~= slotB)then
		return slotA < slotB;
	end

	local equipInfoA, equipInfoB = equipA.equipInfo, equipB.equipInfo;

	if(equipInfoA.equiplv ~= equipInfoB.equiplv)then
		return equipInfoA.equiplv < equipInfoB.equiplv;
	end

	if(equipInfoA.refinelv ~= equipInfoB.refinelv)then
		return equipInfoA.refinelv < equipInfoB.refinelv;
	end

	local equipA_hasEnchant = equipA.enchantInfo and equipA.enchantInfo:HasAttri() or false;
	local equipB_hasEnchant = equipB.enchantInfo and equipB.enchantInfo:HasAttri() or false;
	if(equipA_hasEnchant ~= equipB_hasEnchant)then
		return not equipA_hasEnchant;
	end

	local equipA_CardNum = equipA:GetEquipedCardNum();
	local equipB_CardNum = equipB:GetEquipedCardNum();
	if(equipA_CardNum ~= equipB_CardNum)then
		return equipA_CardNum < equipB_CardNum;
	end

	if(equipInfoA.strengthlv2 ~= equipInfoB.strengthlv2)then
		return equipInfoA.strengthlv2 < equipInfoB.strengthlv2;
	end

	if(equipInfoA.strengthlv ~= equipInfoB.strengthlv)then
		return equipInfoA.strengthlv < equipInfoB.strengthlv;
	end

	return equipA.staticData.id < equipB.staticData.id;
end
function BlackSmithProxy:GetMaterialEquips_ByEquipId(equipid, count, filterDamage, filterFunc, bagTypes, matchCall, matchCallParam)
	local equips;
	if(bagTypes == nil)then
		equips = BagProxy.Instance:GetItemsByStaticID(equipid, BagProxy.BagType.MainBag);
	else
		equips = {};

		local bagData, items;
		for i=1,#bagTypes do
			bagData = BagProxy.Instance:GetBagByType(bagTypes[i]);
			items = bagData:GetItems();
			for j=1,#items do
				if(items[j].staticData.id == equipid)then
					table.insert(equips, items[j]);
				end
			end
		end
	end

	if(equips == nil or #equips == 0)then
		return _EmptyTable;
	end

	table.sort(equips, BlackSmithProxy.SortMaterialEquips)

	local result = {};
	for i=1, #equips do
		if(equips[i].equipInfo.refinelv <= GameConfig.Item.material_max_refine)then
			local valid = true;
			if(filterFunc)then
				valid = filterFunc(equips[i]);
			end
			if(valid)then
				if(filterDamage)then
					if(not equips[i].equipInfo.damage)then
						if(matchCall)then
							matchCall(matchCallParam, equips[i]);
						end
						table.insert(result, equips[i]);
					end
				else
					if(matchCall)then
						matchCall(matchCallParam, equips[i]);
					end
					table.insert(result, equips[i]);
				end
			end
		end
		if(count and #result == count)then
			break;
		end
	end
	return result;
end

local Func_CheckEquip_SameVID = function (itemA, itemB, includeSelf)
	if(itemA == nil or itemB == nil)then
		return false;
	end

	if(itemA.id == itemB.id)then
		return includeSelf == true;
	end

	if(itemA.equipInfo == nil or itemB.equipInfo == nil)then
		return false;
	end

	local vid_a = itemA.equipInfo.equipData.VID;
	local vid_b = itemB.equipInfo.equipData.VID;

	if(vid_a and vid_b)then
		return math.floor(vid_a/10000) == math.floor(vid_b/10000) and vid_a%1000 == vid_b%1000;
	end
	
	return false;
end
function BlackSmithProxy:GetMaterialEquips_ByVID(itemData, bagTypes, matchCall, matchCallParam)
	if(itemData == nil or itemData.equipInfo == nil)then
		return _EmptyTable;
	end

	local result = {};

	local bagProxy = BagProxy.Instance;
	local material_max_refine = GameConfig.Item.material_max_refine;

	if(bagTypes == nil)then
		local bagItems = bagProxy.bagData:GetItems();
		for i=1,#bagItems do
			local item = bagItems[i];
			if(Func_CheckEquip_SameVID(itemData, item) and
				item.equipInfo.refinelv <= material_max_refine)then
				if(matchCall)then
					matchCall(matchCallParam, item);
				end
				table.insert(result, item);
			end
		end
	else
		local bagData, bagItems;
		for i=1,#bagTypes do
			bagData = bagProxy:GetBagByType(bagTypes[i]);
			bagItems = bagData:GetItems();
			for j=1,#bagItems do
				local item = bagItems[j];
				if(Func_CheckEquip_SameVID(itemData, item) 
					and item.equipInfo.refinelv <= material_max_refine)then
					if(matchCall)then
						matchCall(matchCallParam, item);
					end
					table.insert(result, item);
				end
			end
		end
	end

	table.sort(result, BlackSmithProxy.SortMaterialEquips)
	
	return result;
end
-- materials end




function BlackSmithProxy:MaxRefineLevelByData(staticData)
	if(staticData == nil)then
		return 0;
	end

	local refineMaxLevel1 = nil;
	local refineType = self.refineDataMap[staticData.Type]
	if(refineType) then
		refineMaxLevel1 = refineType:GetRefineMaxLevel(staticData.Quality)
	end

	local refineMaxLevel2 = nil;
	local equipData = Table_Equip[staticData.id];
	if(equipData)then
		refineMaxLevel2 = equipData.RefineMaxlv;
	end

	if(refineMaxLevel1)then
		if(refineMaxLevel2)then
			return math.min(refineMaxLevel1, refineMaxLevel2);
		end
		return refineMaxLevel1;
	end
	return 0
end

function BlackSmithProxy:GetRefineData(itemType,quality,refineLevel)
	local refineType = self.refineDataMap[itemType]
	if(refineType) then
		if(refineLevel==0) then refineLevel = 1 end
		return refineType:GetData(quality,refineLevel)
	end
	return nil
end

function BlackSmithProxy:GetComposeIDsByItemData(itemData,isSafe)
	local refineType = self.refineDataMap[itemData.staticData.Type]
	if(refineType) then
		local refinelv = itemData.equipInfo.refinelv
		refinelv =refinelv+1
		local maxRefineLv = self:MaxRefineLevelByData(itemData.staticData)
		if(refinelv>maxRefineLv)then
			refinelv=maxRefineLv
		end
		local data=refineType:GetData(itemData.staticData.Quality,refinelv)
		if(data)then
			if(isSafe)then
				for i=1,#data.SafeRefineCost do
					if(data.SafeRefineCost[i].color==itemData.staticData.Quality)then
						return data.SafeRefineCost[i].id
					end
				end
			else
				for i=1,#data.RefineCost do
					if(data.RefineCost[i].color==itemData.staticData.Quality)then
						return data.RefineCost[i].id
					end
				end
			end
		end
	end
	return nil
end

function BlackSmithProxy:GetExtraSuccesssByStaicID(staticID)
	for i=1,#GameConfig.EquipRefineRate do
		if(staticID==GameConfig.EquipRefineRate[i].itemid)then
			return GameConfig.EquipRefineRate[i].rate
		end
	end
	return 0
end

function BlackSmithProxy:InitHighRefineCompose()
	if(Table_HighRefineMatCompose == nil)then
		return;
	end

	self.highRefineCompose_GroupMap = {};
	for id, data in pairs(Table_HighRefineMatCompose)do
		local groupId = data.GroupId;

		local cache = self.highRefineCompose_GroupMap[groupId];
		if(cache == nil)then
			cache = {};
			self.highRefineCompose_GroupMap[groupId] = cache;
		end

		table.insert(cache, data);
	end
end

function BlackSmithProxy:GetHighRefineComposeData(groupId)
	if(self.highRefineCompose_GroupMap)then
		return self.highRefineCompose_GroupMap[groupId];
	end
	return _EmptyTable;
end


function BlackSmithProxy:IntiHighRefine()
	if(Table_HighRefine == nil)then
		return;
	end

	self.highRefineData_Map = {};
	for id, data in pairs(Table_HighRefine)do
		local t = self.highRefineData_Map[ data.PosType ];
		if(t == nil)then
			t = {};
			self.highRefineData_Map[ data.PosType ] = t;	
		end

		local level = data.Level;
		local levelType = math.floor(level/1000);
		local tt = t[levelType];
		if(tt == nil)then
			tt = {};
			t[levelType] = tt;
		end
		local singlelevel = level % 1000;
		tt[singlelevel] = data;

		-- equalPos begin
		local equalPos = data.EqualPos;
		for i=1,#equalPos do
			local t = self.highRefineData_Map[ equalPos[i] ];
			if(t == nil)then
				t = {};
				self.highRefineData_Map[ equalPos[i] ] = t;	
			end

			local level = data.Level;
			local levelType = math.floor(level/1000);
			local tt = t[levelType];
			if(tt == nil)then
				tt = {};
				t[levelType] = tt;
			end
			local singlelevel = level % 1000;
			tt[singlelevel] = data;

		end
		-- equalPos end
	end

end

function BlackSmithProxy:GetHighRefineData(posType, levelType, level)
	if(self.highRefineData_Map == nil)then
		return;
	end

	if(posType == nil)then
		return;
	end

	local t = self.highRefineData_Map[posType];
	if(levelType == nil)then
		return t;
	end

	if(t == nil)then
		return nil;
	end

	t = t[levelType];

	if(level == nil)then
		return t;
	end

	if(t == nil)then
		return nil;
	end

	return t[level];
end

function BlackSmithProxy:GetMaxHRefineTypeOrLevel(pos, ttype)
	if(ttype == nil)then
		local _,unlockTypes = self:GetHighRefinePoses();
		local types = unlockTypes and unlockTypes[pos];
		if(types)then
			local maxType = 0;
			for i=1,#types do
				maxType = math.max(types[i], maxType);
			end
			return maxType;
		end
	end

	local ds = self:GetHighRefineData(pos, ttype);
	if(ds)then
		return #ds;
	end
	return 0;
end

function BlackSmithProxy:GetShowHRefineDatas(pos)
	local maxType = self:GetMaxHRefineTypeOrLevel(pos);
	local showlvType = maxType;
	for i=1,maxType do

		local nowlv = self:GetPlayerHRefineLevel(pos, i);
		if(nowlv < 10)then
			showlvType = i;
			break;
		end
	end
	return self:GetHighRefineData(pos, showlvType), showlvType;
end

function BlackSmithProxy:SetPlayerHRefineLevels(server_highRefineDatas)
	if(server_highRefineDatas == nil)then
		return;
	end

	self.playerHRefineLevelMap = {};

	for i=1,#server_highRefineDatas do
		self:SetPlayerHRefineLevel(server_highRefineDatas[i]);
	end
end

function BlackSmithProxy:SetPlayerHRefineLevel(server_highRefineData)
	if(server_highRefineData == nil)then
		return;
	end

	local t = self.playerHRefineLevelMap[server_highRefineData.pos];
	if(t == nil)then
		t = {};
		self.playerHRefineLevelMap[server_highRefineData.pos] = t;
	end

	for j=1,#server_highRefineData.level do
		local lv = server_highRefineData.level[j];

		local levelType = math.floor(lv/1000)
		local reallevel = lv % 1000;
		t[levelType] = reallevel;
	end
end

function BlackSmithProxy:GetPlayerHRefineLevel(pos, levelType)
	if(self.playerHRefineLevelMap == nil)then
		return 0;
	end
	local poslvs = self.playerHRefineLevelMap[pos];
	return poslvs and poslvs[levelType] or 0;
end

function BlackSmithProxy:HelpGetMyHRefineEffects(config_data, refinelv)
	local myclass = MyselfProxy.Instance:GetMyProfession()
	return self:HelpGet_SingleHRefineEffects(config_data, myclass, refinelv);
end

function BlackSmithProxy:Get_TotalHRefineEffect_Map(equipPos, typelevel, hrlevel, class, limitRefinelv)
	local datas = self:GetHighRefineData(equipPos, typelevel);

	local resuleEffectMap = {};
	for i=1,hrlevel do
		local s_effectmap = self:get_SingleHRefineEffects_Map(datas[i], class, limitRefinelv)
		if(s_effectmap)then
			for ek, ev in pairs(s_effectmap)do
				if(ek ~= "Job")then
					local ov = resuleEffectMap[ ek ] or 0;
					resuleEffectMap[ ek ] = ov + ev;
				end
			end
		end
	end

	return resuleEffectMap;
end
function BlackSmithProxy:get_SingleHRefineEffects_Map(config_data, class, refinelv)
	if(refinelv)then
		if(config_data.RefineLv > refinelv)then
			return;
		end
	end

	local effect = config_data.Effect;
	for i=1,#effect do
		local jobs = effect[i].Job
		for j=1,#jobs do
			if(jobs[j] == class)then
				return effect[i];
			end
		end
	end

	return nil;
end

function BlackSmithProxy:GetMyHRefineEffects(pos, typelevel, refinelv)
	if(pos == nil)then
		return _EmptyTable;
	end

	local resuleEffectMap;

	local myclass = MyselfProxy.Instance:GetMyProfession()
	if(typelevel ~= nil)then
		local level = self:GetPlayerHRefineLevel(pos, typelevel);
		resuleEffectMap = self:Get_TotalHRefineEffect_Map(pos,
							typelevel,
							level,
							myclass,
							refinelv);
	else
		resuleEffectMap = {};

		local maxType = self:GetMaxHRefineTypeOrLevel(pos);
		for k=1,maxType do
			local level = self:GetPlayerHRefineLevel(pos, k);
			local effectmap = self:Get_TotalHRefineEffect_Map(pos,
								k,
								level,
								myclass,
								refinelv);

			for ek, ev in pairs(effectmap)do
				local v = resuleEffectMap[ ek ] or 0;
				resuleEffectMap[ ek ] = v + ev;
			end
		end
	end

	local effects = {};
	for k,v in pairs(resuleEffectMap)do
		table.insert(effects, {k, v});
	end

	return effects;
end

function BlackSmithProxy:IsHighRefineUnlock()
	-- GameConfig.BranchForbid
	if(EnvChannel.Channel.Name == EnvChannel.ChannelConfig.Alpha.Name or 
		EnvChannel.Channel.Name == EnvChannel.ChannelConfig.Release.Name)then
		return false;
	end
	return true;
end

function BlackSmithProxy:GetHighRefinePoses()
	local gbData = GuildBuildingProxy.Instance:GetBuildingDataByType(GuildBuildingProxy.Type.EGUILDBUILDING_HIGH_REFINE); 
	if(gbData == nil)then
		return;
	end

	local unlockParam = gbData.staticData.UnlockParam;
	local result = {};
	if(unlockParam and unlockParam.hrefine_part)then
		for site,_ in pairs(unlockParam.hrefine_part)do
			table.insert(result, site);
		end
		table.sort(result, function (a,b)
			return a < b;
		end);
	end
	return result, unlockParam.hrefine_part;
end

local _EnchantCost = {};
function BlackSmithProxy:GetEnchantCost(enchantType, itemType)
	TableUtility.ArrayClear(_EnchantCost);

	local costConfig = GameConfig.EquipEnchant and GameConfig.EquipEnchant.SpecialCost;
	if(costConfig)then
		local config = costConfig[enchantType][itemType];
		if(config ~= nil)then
			local zenyCost;
			for i=#config,1,-1 do
				if(config[i].itemid == 100)then
					zenyCost = config[i].num;
				else
					table.insert(_EnchantCost, config[i])
				end
			end
			return _EnchantCost, zenyCost or 0;
		end
	end

	local cost = EnchantEquipUtil.Instance:GetEnchantCost(enchantType)
	if(cost)then
		table.insert(_EnchantCost, cost.ItemCost)
		return _EnchantCost, cost.ZenyCost or 0;
	end
end

local Enchant_UnlockMenuId = 
{
	[SceneItem_pb.EENCHANTTYPE_PRIMARY] = 71,
	[SceneItem_pb.EENCHANTTYPE_MEDIUM] = 72,
	[SceneItem_pb.EENCHANTTYPE_SENIOR] = 73,
}
-- ??????????????????????????????????????????????????????
function BlackSmithProxy:CanBetter_EquipEnchantInfo()
	
	local unlockFunc = FunctionUnLockFunc.Me();
	local maxEnchantType;
	for enchantType, menuId in pairs(Enchant_UnlockMenuId)do
		if(unlockFunc:CheckCanOpen(menuId))then
			if(maxEnchantType == nil or enchantType > maxEnchantType)then
				maxEnchantType = enchantType;
			end
		end
	end

	local roleEquipBag = BagProxy.Instance:GetRoleEquipBag();
	local items = roleEquipBag:GetItems();
	if(#items == 0)then
		return false;
	end

	if(maxEnchantType == nil)then
		return false;
	end

	local item
	for i=1,#items do
		item = items[i];
		if(self:CheckItemEnchant_CanBetter(item, maxEnchantType))then
			return true;
		end
	end

	return false;
end

function BlackSmithProxy:CheckItemEnchant_CanBetter(item, maxEnchantType)
	local equipInfo = item and item.equipInfo;
	if(equipInfo == nil or not equipInfo:CanEnchant())then
		return false;
	end

	local lcondition_enchantType = nil;

	local enchantInfo = item.enchantInfo;
	if(enchantInfo == nil)then
		lcondition_enchantType = SceneItem_pb.EENCHANTTYPE_PRIMARY;
	else
		lcondition_enchantType = enchantInfo.enchantType + 1;
	end

	if(maxEnchantType and lcondition_enchantType > maxEnchantType)then
		return false;
	end

	local itemType = item.staticData.Type;
	local enchantCost, zenyCost = self:GetEnchantCost(lcondition_enchantType, itemType);

	local rob = MyselfProxy.Instance:GetROB();
	if(rob < zenyCost)then
		return false;
	end

	if(enchantCost ~= nil)then
		local bagProxy = BagProxy.Instance;
		local search_bagtypes = bagProxy:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Enchant);
		for _,cost in pairs(enchantCost)do
			for itemid, needNum in pairs(cost)do
				local items = bagProxy:GetMaterialItems_ByItemId(itemid, search_bagtypes);
				local haveNum = 0;
				for i=1,#items do
					haveNum = haveNum + items[i].num;
				end
				if(haveNum < needNum)then
					return false;
				end
			end
		end
	end

	return true;
end