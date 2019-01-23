EnchantEquipTypeRateMap = {
	[170] = "SpearRate", 
	[180] = "SwordRate", 
	[190] = "StaffRate", 
	[200] = "KatarRate", 
	[210] = "BowRate",
	[220] = "MaceRate", 
	[230] = "AxeRate", 
	[240] = "BookRate",
	[250] = "KnifeRate", 
	[260] = "InstrumentRate", 
	[270] = "LashRate", 
	[280] = "PotionRate",
	[290] = "GloveRate",
	[500] = "ArmorRate",
	[510] = "ShieldRate", 
	[520] = "RobeRate",
	[530] = "ShoeRate", 
	[540] = "AccessoryRate",
	[511] = "OrbRate",
	[512] = "EikonRate",
	[513] = "BracerRate", 
	[514] = "BraceletRate",
	[515] = "TrolleyRate", 
	[800] = "HeadRate", 
	[810] = "WingRate",
	[830] = "FaceRate", 
	[840] = "TailRate", 
	[850] = "MouthRate", 
}

EnchantMenuType = {
	Default = 0,
	SixBaseAttri = 1,
	BaseAttri = 2,
	DefAttri = 3,
	CombineAttri = 4,
}

Enchant1rdAttri = {
	"Str","Agi","Vit","Int","Dex","Luk",
}

Enchant2rdAttri = {
	"Hp","Sp",
	"MaxHp","MaxHpPer",
	"MaxSp","MaxSpPer",
	"Atk","AtkPer",
	"MAtk","MAtkPer",
	"Def","DefPer",
	"MDef","MDefPer",
	"Hit","Cri","Flee","AtkSpd",
	"CriRes", "CriDamPer",
	"CriDefPer", "HealEncPer",
	"BeHealEncPer", "DamIncrease",
	"DamReduc", "DamRebound",
	"MDamRebound", "Vampiric",
	"EquipASPD",
}

Enchant3rdAttri = {
	"SilenceDef",
	"FreezeDef",
	"StoneDef",
	"StunDef",
	"BlindDef",
	"PoisonDef",
	"SlowDef",
	"ChaosDef",
	"CurseDef",
}


-------------------------------------------------------------------------


EnchantData = class("EnchantData");

function EnchantData:ctor()
	self.datas = {};
end

-- return with canGet
function EnchantData:Get(itemType)
	local rateKey = itemType and EnchantEquipTypeRateMap[itemType]
	if(not rateKey)then
		return self.datas[1], false;
	end

	for i=#self.datas,1,-1 do
		if(EnchantData.CanGet(self.datas[i], itemType))then
			return self.datas[i], true;
		end
	end

	-- 默认返回第一条
	return self.datas[1], false;
end

function EnchantData:Add( equipEnchant_config )
	table.insert(self.datas, equipEnchant_config);
end

function EnchantData.CanGet( data, itemType )
	local rateKey = itemType and EnchantEquipTypeRateMap[itemType]
	if(not rateKey)then
		return false;
	end

	local cantEnchantMap = data.CantEnchant;
	if(cantEnchantMap[rateKey] ~= 1)then
		return true;
	end

	return false;
end


-------------------------------------------------------------------------


EnchantEquipUtil = class("EnchantEquipUtil");

EnchantEquipUtil.Instance = nil

function EnchantEquipUtil:ctor()
	self:Init();
	EnchantEquipUtil.Instance = self;
end

function EnchantEquipUtil:Init()
	self.dataMap = {};
	self.combineEffectMap = {};
	for typeKey, enchantType in pairs(EnchantType)do
		self.dataMap[enchantType] = {};
		self.combineEffectMap[enchantType] = {};
	end

	self.costMap = {};
	for key,data in pairs(Table_EquipEnchant)do
		local enchantData = self.dataMap[data.EnchantType][data.AttrType];
		if(enchantData == nil)then
			enchantData = EnchantData.new();
			self.dataMap[data.EnchantType][data.AttrType] = enchantData;
		end
		enchantData:Add(data);

		local key,value = next(data.AttrType2);
		if(key and value and data.ComBineAttr~="")then
			table.insert(self.combineEffectMap[data.EnchantType], data);
		end

		if(not self.costMap[data.EnchantType])then
			self.costMap[data.EnchantType] = {};
			self.costMap[data.EnchantType].ItemCost = data.ItemCost;
			self.costMap[data.EnchantType].ZenyCost = data.ZenyCost;
		end
	end

	self.priceRateMap = {};
	local priceConfig = Table_EquipEnchantPrice or {};
	for _,data in pairs(priceConfig)do
		if(data.AttrType)then
			self.priceRateMap[data.AttrType] = data;
		end
	end
end

function EnchantEquipUtil:GetEnchantDatasByEnchantType(enchantType)
	return self.dataMap[enchantType];
end

function EnchantEquipUtil:GetEnchantData(enchantType, attri, itemType)
	if(not attri or not enchantType)then
		errorLog(string.format("GetEnchantData Parama Error (%s %s)", tostring(enchantType), tostring(attri)));
		return;
	end
	local edatas = self.dataMap[enchantType];
	if(edatas == nil)then
		return;
	end
	local enchantData = edatas[ attri ];
	if(enchantData == nil)then
		return;
	end
	return enchantData:Get(itemType);
end

function EnchantEquipUtil:GetAttriPropVO(attriType)
	local pro = RolePropsContainer.config[attriType];
	if(nil == pro)then
		errorLog(string.format("NO This Attri %s", tostring(attriType)));
	end
	return pro;
end

function EnchantEquipUtil:GetMenuType(attriType)
	for pos,type in pairs(Enchant1rdAttri)do
		if(attriType == type)then
			return EnchantMenuType.SixBaseAttri, pos;
		end
	end
	for pos,type in pairs(Enchant2rdAttri)do
		if(attriType == type)then
			return EnchantMenuType.BaseAttri, pos;
		end
	end
	for pos,type in pairs(Enchant3rdAttri)do
		if(attriType == type)then
			return EnchantMenuType.DefAttri, pos;
		end
	end
	errorLog(string.format("(%s) Not Config In EnchantEquipUtil'TopConfig", attriType));
	return EnchantMenuType.Default, 1;
end

function EnchantEquipUtil:GetEnchantCost(enchantType)
	return self.costMap[enchantType];
end

function EnchantEquipUtil:GetCombineEffects(enchantType)
	return self.combineEffectMap[enchantType];
end

function EnchantEquipUtil:GetCombineEffect(uniqueId)
	for _,data in pairs(Table_EquipEnchant) do
		if(data.UniqID == uniqueId)then
			return data;
		end
	end
	return nil;
end

function EnchantEquipUtil:GetPriceRate(attriType, itemType)
	if(attriType)then
		local data = self.priceRateMap[attriType];
		if(data)then
			local key = EnchantEquipTypeRateMap[itemType];
			if(data[key])then
				return data[key]
			end
		end
	end
	return 0;
end

function EnchantEquipUtil:CanGetCombineEffect(data, itemType)
	local canGet1 = EnchantData.CanGet( data, itemType )
	if(not canGet1)then
		return;
	end
	local attri2 = data.AttrType2[1];
	if(attri2 == nil)then
		return canGet1;
	end

	local rateKey = itemType and EnchantEquipTypeRateMap[itemType]
	if(not rateKey or data.NoShowEquip[rateKey] == 1)then
		return false;
	end

	local enchantType = data.EnchantType;
	local data2, canGet2 = self:GetEnchantData(enchantType, attri2, itemType)
	if(data2 == nil)then
		return false;
	end
	return canGet2;
end
