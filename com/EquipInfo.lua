EquipInfo = class("EquipInfo")

EquipTypeEnum = {
	Weapon = 1,
	Cloth = 2,
	Shield = 3,
	Cloak = 4,
	Shoes = 5,
	Ring = 6,
	Necklace = 7,
	Accessory = 8,
	Back = 9,
}

local forbitFun = {
	Enchant = 1,
	Strength = 2,
	Refine = 4,
}

function EquipInfo:ctor(staticData)
	self.equiped = 0
	self.equipData = nil
	self.upgradeData = nil
	self.upgrade_MaxLv = 0
	self.professCanUse = nil
	self:ResetData(staticData)
end

function EquipInfo:ResetData(staticData)
	self.equipData = staticData
	self.upgradeData = staticData and Table_EquipUpgrade[staticData.id]
	if(self.upgradeData)then
		self.upgrade_MaxLv = 0;
		while self:GetUpgradeMagerialsByEquipLv(self.upgrade_MaxLv + 1) ~= nil do
			self.upgrade_MaxLv = self.upgrade_MaxLv + 1;
		end
		if(self.upgrade_MaxLv ~= 0 and self.upgradeData.Product)then
			self.upgrade_MaxLv = self.upgrade_MaxLv - 1;
		end
	end

	if(self.staticData~=nil) then
		self.staticData.id = staticId
	end
	self:Set()
	self:InitEquipCanUse()

	if(Table_Artifact and Table_Artifact[staticData.id])then
		self.artifact_lv = Table_Artifact[staticData.id].Level;
	end
end

function EquipInfo:Set(serverData)
	self.strengthlv = serverData and serverData.strengthlv or 0
	self.strengthlv2 = serverData and serverData.strengthlv2 or 0
	self.refinelv = serverData and serverData.refinelv or 0
	--当前等级段的经验值
	self.refineexp = serverData and serverData.refineexp or 0
	self.damage = serverData and serverData.damage or false;
	self.equiplv = serverData and serverData.lv or 0;
	self.color = serverData and serverData.color;

	self.breakstarttime = serverData and serverData.breakstarttime;
	self.breakendtime = serverData and serverData.breakendtime;
	if(self.breakstarttime and self.breakendtime)then
		self.breakduration = self.breakendtime - self.breakstarttime;
	else
		self.breakduration = nil;
	end

	-- 装备的 buffid(特色属性)
	if(not self.uniqueEffect)then
		local eudata = self.equipData.UniqueEffect;
		self.uniqueEffect = {};
		if(eudata) then
			for k,v in pairs(eudata) do
				for vk,vv in pairs(v)do
					if(vk~="type")then
						self.uniqueEffect = TableUtil.InsertArray(self.uniqueEffect, vv);
					end
				end
			end
		end
		if(#self.uniqueEffect>0)then
			self.activeUniqueEffect = {};
		end
	end
	if(not self.pvp_uniqueEffect)then
		self.pvp_uniqueEffect = {};
		local epvpudata = self.equipData.PVPUniqueEffect;
		if(epvpudata and epvpudata~=_EmptyTable)then
			for k,v in pairs(epvpudata)do
				for vk,vv in pairs(v)do
					if(vk~="type")then
						self.pvp_uniqueEffect = TableUtil.InsertArray(self.pvp_uniqueEffect, vv);
					end
				end
			end
		end
	end
	if(self.activeUniqueEffect and serverData and serverData.buffid)then
		for i=1,#serverData.buffid do
			self.activeUniqueEffect[serverData.buffid[i]] = true;
		end
	end
end

function EquipInfo:GetReplaceValues()
	if(self.equipData) then
		return self.equipData.ReplaceValues or 0
	end
	return 0
end

function EquipInfo:GetEffect()
	if(self.equipData) then
		return next(self.equipData.Effect)
	end
	return nil,nil
end

function EquipInfo:InitEquipCanUse()
	local equpType = GameConfig.EquipType;
	if(self.equipData~=nil and self.equipData.EquipType) then
		self.site = equpType[self.equipData.EquipType] and equpType[self.equipData.EquipType].site
		if(self.equipData.EquipCanUseProfess ==nil) then
			self.equipData.EquipCanUseProfess = {}
			for i=1,#self.equipData.CanEquip do
				self.equipData.EquipCanUseProfess[self.equipData.CanEquip[i]] = self.equipData.CanEquip[i]
			end
		end
		self.professCanUse = self.equipData.EquipCanUseProfess
	else
		self.site = {};
	end
end

function EquipInfo:CanUseByProfess( pro )
	return (self.professCanUse~=nil and (self.professCanUse[0]~=nil or self.professCanUse[pro]~=nil))
end

function EquipInfo:GetEquipType()
	if(self.equipData~=nil) then return self.equipData.EquipType
	else return nil end
end

function EquipInfo:GetEquipSite()
	return self.site
end

function EquipInfo:GetUniqueEffect()
	if(self.activeUniqueEffect)then
		local result = {};
		for i=1,#self.uniqueEffect do
			local temp = {};
			temp.id = self.uniqueEffect[i];
			temp.active = self.activeUniqueEffect[temp.id];
			table.insert(result, temp);
		end
		return result;
	end
end

function EquipInfo:GetPvpUniqueEffect()
	if(self.activeUniqueEffect)then
		local result = {};
		for i=1,#self.pvp_uniqueEffect do
			local temp = {};
			temp.id = self.pvp_uniqueEffect[i];
			temp.active = self.activeUniqueEffect[temp.id];
			table.insert(result, temp);
		end
		return result;
	end
end

function EquipInfo:IsWeapon()
	return self.equipData.EquipType ==EquipTypeEnum.Weapon
end

function EquipInfo:BasePropStr()
	local effects ={{effect = self.equipData.Effect,name = "normal",lv = 1}}
	return PropUtil.FormatEffectsByProp(effects,false," +")
end

function EquipInfo:RefineAndStrInfo(refinelv,strengthlv)
	refinelv = refinelv or self.refinelv
	strengthlv = strengthlv or self.strengthlv
	if(whole == nil) then whole = true end
	if(same == nil) then same = true end
	local effects = {{effect = self.equipData.Effect,name = "normal",lv = 1}
					,{effect = self.equipData.EffectAdd,name = "str",lv = strengthlv}
					,{effect = self.equipData.RefineEffect,name = "refine",lv = refinelv}}
	return PropUtil.FormatEffectsByProp(effects,false," +")
end

function EquipInfo:StrengthInfo(level,whole,same)
	level = level or self.strengthlv
	if(whole == nil) then whole = true end
	if(same == nil) then same = true end

	if(whole) then
		local effects = {{effect = self.equipData.Effect,name = "normal",lv = 1}
					,{effect = self.equipData.EffectAdd,name = "str",lv = level}}
		return PropUtil.FormatEffectsByProp(effects,same," +")
	else
		local effectAdd = self.equipData.EffectAdd
		local effects = {}
		for k,v in pairs(effectAdd) do
			local data ={}
			data.name = k
			data.value = v
			table.insert(effects,data)
		end
		return PropUtil.FormatEffects(effects,level," +")
	end
end

function EquipInfo:RefineInfo(level,whole,same,sperator)
	level = level or self.refinelv
	sperator = sperator or " +"
	if(whole == nil) then whole = false end
	if(same == nil) then same = true end
	if(whole) then
		local effects = {{effect = self.equipData.Effect,name = "normal",lv = 1}
					,{effect = self.equipData.RefineEffect,name = "refine",lv = level}}
		return PropUtil.FormatEffectsByProp(effects,same, sperator)
	else
		local effectAdd = self.equipData.RefineEffect
		local effects = {}
		for k,v in pairs(effectAdd) do
			local data ={}
			data.name = k
			data.value = v
			table.insert(effects,data)
		end	
		return PropUtil.FormatEffects(effects,level, sperator)
	end
end

function EquipInfo:SetStrengthRefine(strengthlv, refinelv)
	self.strengthlv = strengthlv;
	self.refinelv = refinelv;
end

function EquipInfo:GetUpgradeMagerialsByEquipLv(equiplv)
	if(nil == self.upgradeData)then
		return nil;
	end

	equiplv = equiplv or self.equiplv;
	local materialsKey = "Material_" .. tostring(equiplv);
	local materials = self.upgradeData[materialsKey];
	if(materials and #materials > 0)then
		return materials;
	end

	return nil;
end

function EquipInfo:CanUpgrade()
	if(self.upgradeData ~= nil)then
		return self:GetUpgradeMagerialsByEquipLv(self.equiplv + 1) ~= nil;
	end
	return false;
end

function EquipInfo:CanUpgrade_ByClassDepth(classdepth, equiplv)
	if(not self.upgradeData)then
		return false;
	end

	local classDepthLimit_2 = self.upgradeData.ClassDepthLimit_2;
	if(classDepthLimit_2 and classdepth < 2)then
		if(equiplv >= classDepthLimit_2)then
			return false, 2;
		end
	end

	return true;
end

function EquipInfo:CanUpgradeInfoBeEffect_ByClassDepth(classdepth, equiplv)
	if(not self.upgradeData)then
		return false;
	end

	local classDepthLimit_2 = self.upgradeData.ClassDepthLimit_2;
	if(classDepthLimit_2 and classdepth < 2)then
		if(equiplv and equiplv >= classDepthLimit_2)then
			return false, 2;
		end
	end

	return true;
end

function EquipInfo:GetUpgradeBuffIdByEquipLv(equiplv)
	if(nil == self.upgradeData)then
		return nil;
	end

	equiplv = equiplv or self.equiplv;
	local buffKey = "BuffID_" .. tostring(equiplv);
	return self.upgradeData[buffKey];
end

function EquipInfo:CanStrength()
	if(not self:CanStrength_ByStaticData())then
		return false;
	end

	return self:CanStrength_ByServerData();
end

function EquipInfo:CanStrength_ByStaticData()
	--step1.静态配置
	if(self.equipData.ForbidFuncBit~=nil) then
		if(self.equipData.ForbidFuncBit & forbitFun.Strength > 0) then
			return false
		end
	end

	--step2.规则
	if(self.equipData and self.equipData.EquipType)then
		local config = GameConfig.EquipType[self.equipData.EquipType];
		local sites = config and config.site 
		sites = type(sites)=="table" and sites or {};
		return type(sites[1])=="number" and sites[1]~=0;
	end
	return false
end

function EquipInfo:CanStrength_ByServerData()
	return true;
end

function EquipInfo:CanRefine()
	if(not self:CanRefine_ByStaticData())then
		return false;
	end

	return self:CanRefine_ByServerData();
end

function EquipInfo:CanRefine_ByStaticData()
	if(self.equipData.EquipType==12)then
		return false
	end
	if(self.equipData.ForbidFuncBit==nil) then
		return true
	end
	return self.equipData.ForbidFuncBit & forbitFun.Refine <= 0
end

function EquipInfo:CanRefine_ByServerData()
	return true;
end

function EquipInfo:CanEnchant()
	local equipID = self.equipData.id;
	local itemType = equipID and Table_Item[equipID] and Table_Item[equipID].Type;
	local isfashion = itemType and BagProxy.fashionType[itemType] or false
	if(isfashion and GameConfig.SystemForbid.FashionEquipEnchant)then
		return false;
	end
	if(not self:CanEnchant_ByStaticData())then
		return false;
	end
	return self:CanRefine_ByServerData();
end

function EquipInfo:CanEnchant_ByStaticData()
	if(self.equipData.ForbidFuncBit==nil) then
		return true
	end
	return self.equipData.ForbidFuncBit & forbitFun.Enchant <= 0
end

function EquipInfo:CanEnchant_ByServerData()
	return true;
end

function EquipInfo:Clone(other)
	self:Set(other)
	self.equiplv = other.equiplv
	self.site = other.site
end
-- return Prop

function EquipInfo:SetUpgradeCheckDirty()
	self.upgrade_checkdirty = true;
end

function EquipInfo.GetEquipCheckTypes()
	local pacakgeCheck = GameConfig.PackageMaterialCheck;
	local upgradeCheckTypes;
	if(pacakgeCheck)then
		upgradeCheckTypes = pacakgeCheck.upgrade or pacakgeCheck.default;
	else
		upgradeCheckTypes = {1,9};
	end
	return upgradeCheckTypes;
end

function EquipInfo:CheckCanUpgradeSuccess(isMyEquip, item_guid)
	if(self.upgradeData == nil)then
		return false;
	end

	if(not self:CanUpgrade())then
		return false;
	end

	if(self.upgrade_checkdirty == false)then
		return self.canUpgrade_success;
	end

	self.upgrade_checkdirty = false;

	self.canUpgrade_success = false;

	local equiplv = self.equiplv;
	if(isMyEquip)then
		local myClass = Game.Myself.data.userdata:Get(UDEnum.PROFESSION);
		local classDepth = ProfessionProxy.Instance:GetDepthByClassId(myClass);
		if(not self:CanUpgrade_ByClassDepth(classDepth, equiplv + 1))then
			return false;
		end
	end
	
	local materialsKey = "Material_" .. (equiplv+1);
	local cost = self.upgradeData[materialsKey];

	local _BlackSmithProxy, _BagProxy, searchItems = BlackSmithProxy.Instance, BagProxy.Instance;
	for i=1,#cost do
		local sc = cost[i];

		local searchNum = 0;
		if(sc.id ~= 100)then
			if(ItemData.CheckIsEquip(sc.id))then
				searchItems = _BlackSmithProxy:GetMaterialEquips_ByEquipId(sc.id, nil, true, nil, self:GetEquipCheckTypes(), function (param, itemData)
					if(itemData.equipInfo ~= self)then
						searchNum = searchNum + itemData.num;
					end
				end);
			else
				searchItems = _BagProxy:GetMaterialItems_ByItemId(sc.id, self.GetEquipCheckTypes());
				for j=1,#searchItems do
					searchNum = searchNum + searchItems[j].num;
				end
			end
		else
			searchNum = Game.Myself.data.userdata:Get(UDEnum.SILVER);
		end
		if(searchNum < sc.num)then
			self.canUpgrade_success = false;
			return false;
		end
	end

	self.canUpgrade_success = true;

	return true;
end