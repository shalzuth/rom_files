EnchantView = class("EnchantView",BaseView)

EnchantView.ViewType = UIViewType.NormalLayer

autoImport("EquipChooseBord");
autoImport("EnchantAttrInfoCell");
autoImport("EnchantEffectCell");

EnchantEffectType = {
	Combine = "EnchantEffectType_combine",
	Enchant = "EnchantEffectType_Enchant",
}


EnchantView.ButtonLabText = {
	[EnchantType.Primary] = ZhString.EnchantView_PrimaryEnchant,
	[EnchantType.Medium] = ZhString.EnchantView_MediumEnchant,
	[EnchantType.Senior] = ZhString.EnchantView_SeniorEnchant,
}

EnchantView.EnchantAction = "use_magic";

local DEFAULT_MATERIAL_SEARCH_BAGTYPES;
local Enchant_MATERIAL_SEARCH_BAGTYPES;

function EnchantView:Init()
	local pacakgeCheck = GameConfig.PackageMaterialCheck;
	DEFAULT_MATERIAL_SEARCH_BAGTYPES = pacakgeCheck and pacakgeCheck.default or {1,9};
	Enchant_MATERIAL_SEARCH_BAGTYPES = pacakgeCheck and pacakgeCheck.enchant or DEFAULT_MATERIAL_SEARCH_BAGTYPES;

	local viewdata = self.viewdata and self.viewdata.viewdata;
	self.npcdata = viewdata and viewdata.npcdata;
	self.enchantType = viewdata and viewdata.enchantType or 1; 

	self:InitUI();
	self:MapEvent();
end

function EnchantView:InitUI()
	self.enchantTipBord = self:FindGO("EnchantTipBrod");
	self.enchantEffectBord = self:FindGO("EnchantEffectBord");
	self.enchantInfoBord = self:FindGO("EnchantInfoBord");

	self.addItemButton = self:FindGO("AddItemButton");
	self:AddClickEvent(self.addItemButton, function (go)
		self:clickTargetItem();
	end);
	self.targetGo = self:FindGO("TargetCell");
	self.targetItemCell = BaseItemCell.new(self.targetGo);
	self.targetItemCell:AddEventListener(MouseEvent.MouseClick, self.clickTargetItem, self);
	self.effectBg = self:FindComponent("EffectBg", ChangeRqByTex);
	
	local enchantEffectGrid = self:FindComponent("EnchantEffectGrid", UIGrid, self.enchantEffectBord);
	self.enchantEffectCtl = UIGridListCtrl.new(enchantEffectGrid, EnchantEffectCell, "EnchantEffectCell");
	self.noEquipEnchantTip = self:FindGO("NoEnchantTip", self.enchantEffectBord);
	
	local coins = self:FindGO("TopCoins");
	self.usermrb = self:FindGO("MRB", coins);
	self.mrbLabel = self:FindComponent("Label", UILabel, self.usergold);
	self.mrbSymbol = self:FindComponent("symbol", UISprite, self.usermrb);
	self.userRob = self:FindGO("Silver", coins);
	self.robLabel = self:FindComponent("Label", UILabel, self.userRob);

	local chooseContaienr = self:FindGO("ChooseContainer");
	local chooseBordDataFunc = function ()
		return self:GetEnchantEquips();
	end
	self.chooseBord = EquipChooseBord.new(chooseContaienr, chooseBordDataFunc);
	self.chooseBord:AddEventListener(EquipChooseBord.ChooseItem, self.ChooseItem, self)
	self.chooseBord:Hide();

	self.enchantButton = self:FindGO("EnchantButton");
	local buttonLab = self:FindComponent("Label", UILabel, self.enchantButton);
	buttonLab.text = EnchantView.ButtonLabText[self.enchantType];
	self:AddClickEvent(self.enchantButton, function (go) self:TryEnchant() end);

	self.enchantTipLab = self:FindComponent("TipLabel", UILabel, self.enchantTipBord);
	self.costGrid = self:FindComponent("CostGrid", UIGrid);
	self.enchantMrbLab = self:FindComponent("MRB", UILabel, self.enchantTipBord);
	self.encahntMrbSymbol = self:FindComponent("Sprite", UISprite, self.enchantMrbLab.gameObject);

	self.enchantSliverLab = self:FindComponent("Sliver", UILabel, self.enchantTipBord);
	self.enchantTipChoose = self:FindGO("ChooseState", self.enchantTipBord);
	self.enchantTipUnChoose = self:FindGO("UnChooseState", self.enchantTipBord);
	local enchantInfoButton = self:FindGO("EnchantInfoButton");
	self:AddClickEvent(enchantInfoButton, function (go)
		self.enchantInfoBord:SetActive(true);
	end);

	self.enchantInfoTitle = self:FindComponent("Title", UILabel, self.enchantInfoBord);
	local enchantInfoTable = self:FindComponent("EnchantInfoTable", UITable);
	self.enchantInfoCtl = UIGridListCtrl.new(enchantInfoTable , EnchantAttrInfoCell, "EnchantAttrInfoCell");
	local infoCloseButton = self:FindGO("InfoCloseButton", self.enchantInfoBord);
	self:AddClickEvent(infoCloseButton, function (go)
		self.enchantInfoBord:SetActive(false);
	end);

	self.compareButton = self:FindGO("CompareButton");
	self.saveAttriButton = self:FindGO("SaveAttriButton");
	self:AddPressEvent(self.compareButton, function(go, isPress)
		if(isPress)then
			self:UpdateEquipEffect(false, true);
		else
			self:UpdateEquipEffect(true);
		end
	end);
	self:AddClickEvent(self.saveAttriButton, function (go)
		if(self.nowItemData and self.hasUnSaveAttri)then
			ServiceItemProxy.Instance:CallProcessEnchantItemCmd(true, self.nowItemData.id);
		end
	end);

	self:UpdateCoins();
	self:UpdateEnchantTip();
end

function EnchantView:GetEnchantEquips()
	local equipEquips = BagProxy.Instance.roleEquip:GetItems() or {};
	local bagEquips = BagProxy.Instance:GetBagEquipItems()
	local result = {};
	for i=1,#equipEquips do
		local equipInfo = equipEquips[i] and equipEquips[i].equipInfo;
		if(equipInfo and equipInfo:CanEnchant())then
			table.insert(result, equipEquips[i]);
		end
	end
	for i=1,#bagEquips do
		local equipInfo = bagEquips[i] and bagEquips[i].equipInfo;
		if(equipInfo and equipInfo:CanEnchant())then
			table.insert(result, bagEquips[i]);
		end
	end
	return result;
end

function EnchantView:clickTargetItem(cellCtl)
	self.chooseBord:Show(true);
	self.enchantInfoBord:SetActive(false);
	self.chooseBord:SetChoose(self.nowItemData);
end

function EnchantView:ChooseItem(itemData)
	self.nowItemData = itemData;
	if(self.nowItemData)then
		self.addItemButton:SetActive(false);
		self.targetGo:SetActive(true);
	else
		self.addItemButton:SetActive(true);
		self.targetGo:SetActive(false);
	end
	
	self.targetItemCell:SetData(self.nowItemData);
	self.targetItemCell:UpdateMyselfInfo(self.nowItemData);
	
	self:UpdateEquipEffect();
	self:UpdateEnchantTip();
	self.chooseBord:Hide();
end

function EnchantView:GetCost()
	local itemType;
	if(self.nowItemData)then
		itemType = self.nowItemData.staticData.Type;
	end
	return BlackSmithProxy.Instance:GetEnchantCost(self.enchantType, itemType)
end

function EnchantView:GetMrb()
	local itemCost,zenyCost = self:GetCost();
	itemCost = itemCost and itemCost[1];
	local itemid = itemCost and itemCost.itemid or 135;
	local items = BagProxy.Instance:GetMaterialItems_ByItemId(itemid, Enchant_MATERIAL_SEARCH_BAGTYPES);
	local searchNum = 0;
	for i=1,#items do
		searchNum = searchNum + items[i].num;
	end
	return searchNum;
end

function EnchantView:GetEnchantItemNum(itemid)
	local items = BagProxy.Instance:GetMaterialItems_ByItemId(itemid, Enchant_MATERIAL_SEARCH_BAGTYPES);

	local searchNum = 0;
	for i=1,#items do
		searchNum = searchNum + items[i].num;
	end
	return searchNum;
end

function EnchantView:UpdateCoins()
	self.robLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetROB())
	self.mrbLabel.text = StringUtil.NumThousandFormat(self:GetMrb())
end

function EnchantView:UpdateEquipEffect(withGoodTip, showOriginal)
	local nowData = self.nowItemData;
	if(nowData)then
		self.enchantEffectBord:SetActive(true);
		local resultEffect = {};
		self.hasUnSaveAttri, enchantAttrs = nowData.enchantInfo:HasUnSaveAttri();
		if(not showOriginal and self.hasUnSaveAttri)then
			enchantAttrs = nowData.enchantInfo:GetCacheEnchantAttrs();
		else
			enchantAttrs = nowData.enchantInfo:GetEnchantAttrs();
		end
		self.hasNewGoodAttri = nowData.enchantInfo:HasNewGoodAttri();
		for i=1,#enchantAttrs do
			local temp = {};
			temp.type = EnchantEffectType.Enchant;
			temp.showline = true;
			temp.withGoodTip = true;
			temp.enchantAttri = enchantAttrs[i];
			table.insert(resultEffect, temp)
		end
		local combineEffects;
		if(not showOriginal and self.hasUnSaveAttri)then
			combineEffects = nowData.enchantInfo:GetCacheCombineEffects();
		else
			combineEffects = nowData.enchantInfo:GetCombineEffects();
		end
		if(combineEffects)then
			for i=1,#combineEffects do
				local combineEffect = combineEffects[i];
				if(combineEffect)then
					local temp = {};
					temp.type = EnchantEffectType.Combine;
					temp.isWork = combineEffect.isWork;
					if(temp.isWork)then
						temp.combineTip = string.format("%s:%s", combineEffect.buffData.BuffName ,combineEffect.buffData.BuffDesc);
					else
						temp.combineTip = string.format("%s:%s(%s)", tostring(combineEffect.buffData.BuffName),
											tostring(combineEffect.buffData.BuffDesc), tostring(combineEffect.WorkTip));
					end
					table.insert(resultEffect, temp);
				end
			end
		end
		
		self.enchantEffectCtl:ResetDatas(resultEffect);
		self.noEquipEnchantTip:SetActive(#resultEffect==0);
		self.saveAttriButton:SetActive(self.hasUnSaveAttri);
		self.compareButton:SetActive(self.hasUnSaveAttri);
	else
		self.enchantEffectBord:SetActive(false);
		self.hasUnSaveAttri = false;
		self.hasNewGoodAttri = false;
	end
end

function EnchantView:UpdateEnchantTip()

	self.material_enough = false;

	if(self.nowItemData)then
		self.enchantTipChoose:SetActive(true);
		self.enchantTipUnChoose:SetActive(false);

		self.material_enough = true;

		local itemCost,zenyCost = self:GetCost();
		itemCost = itemCost and itemCost[1];

		-- temp
		if(itemCost and itemCost.num and itemCost.num > 0)then
			local havNum = self:GetEnchantItemNum( itemCost.itemid );
			self.enchantMrbLab.gameObject:SetActive(true);

			if(havNum < itemCost.num)then
				self.material_enough = false
				self.enchantMrbLab.text = string.format("[c][FF3B0D]%s[-][/c]", "x"..tostring(itemCost.num));
			else
				self.enchantMrbLab.text = "x"..tostring(itemCost.num);
			end
			IconManager:SetItemIcon(Table_Item[itemCost.itemid].Icon, self.mrbSymbol)
			IconManager:SetItemIcon(Table_Item[itemCost.itemid].Icon, self.encahntMrbSymbol)
		else
			IconManager:SetItemIcon(Table_Item[135].Icon, self.mrbSymbol)
			self.enchantMrbLab.gameObject:SetActive(false);
		end
		if(zenyCost and zenyCost>0)then
			self.enchantSliverLab.gameObject:SetActive(true);

			if(MyselfProxy.Instance:GetROB() < zenyCost)then
				self.material_enough = false
				self.enchantSliverLab.text = string.format("[c][FF3B0D]%s[-][/c]", "x"..tostring(zenyCost));
			else
				self.enchantSliverLab.text = "x"..tostring(zenyCost);
			end
		else
			self.enchantSliverLab.gameObject:SetActive(false);
		end
		self.costGrid.gameObject:SetActive(true);
		self.costGrid:Reposition();

		self.enchantTipLab.text = string.format(ZhString.EnchantView_EnchantTip, 
				self.nowItemData.staticData.NameZh, EnchantView.ButtonLabText[self.enchantType]);

		self:UpdateEnchantInfo();

		self:UpdateCoins();
	else
		self.costGrid.gameObject:SetActive(false);

		self.enchantTipChoose:SetActive(false);
		self.enchantTipUnChoose:SetActive(true);
	end
end

function EnchantView:UpdateEnchantInfo()
	if(self.nowItemData)then
		local enchantDatas = self:CombineEnchantInfoDatas();
		self.enchantInfoTitle.text = EnchantView.ButtonLabText[self.enchantType]..ZhString.EnchantView_Attri;
		self.enchantInfoCtl:ResetDatas(enchantDatas);
	else
		errorLog("Not Select Item");
	end
end

function EnchantView:CombineEnchantInfoDatas()
	local enchantType = self.enchantType;
	local enchantDatas = EnchantEquipUtil.Instance:GetEnchantDatasByEnchantType(enchantType);

	local result = {};
	local equipType = self.nowItemData.staticData.Type;
	for attriType, data in pairs(enchantDatas)do
		local attriMenuType, pos = EnchantEquipUtil.Instance:GetMenuType(attriType);
		local infoData = result[attriMenuType]
		if(not infoData)then
			infoData = {};
			infoData.attriMenuType = attriMenuType;
			infoData.attris = {};
			result[attriMenuType] = infoData;
		end

		local cbdata = {};
		cbdata.attriMenuType = attriMenuType;
		cbdata.equipType = equipType;
		cbdata.enchantType = enchantType;
		cbdata.enchantData, cbdata.canGet = data:Get(equipType);
		cbdata.pos = pos;
		table.insert(infoData.attris, cbdata);
	end
	local combineEffects = EnchantEquipUtil.Instance:GetCombineEffects(enchantType);
	local hasValue = next(combineEffects);
	if(hasValue)then
		local infoData = {};
		infoData.attriMenuType = EnchantMenuType.CombineAttri;
		infoData.attris = {};
		table.insert(result, infoData);

		local enchantEquipUtil = EnchantEquipUtil.Instance;

		local nameKeysMap,attris = {}, infoData.attris;
		for _,data in pairs(combineEffects)do
			if(nameKeysMap[ data.Name ] == nil)then
				local cbdata = {};
				cbdata.attriMenuType = EnchantMenuType.CombineAttri;
				cbdata.equipType = equipType;
				cbdata.enchantType = enchantType;
				cbdata.enchantData = data;
				cbdata.pos = data.id;
				cbdata.canGet = enchantEquipUtil:CanGetCombineEffect(data, equipType)
				table.insert(attris, cbdata);
				nameKeysMap[ data.Name ] = #attris;
			else
				local canGet = enchantEquipUtil:CanGetCombineEffect(data, equipType)
				if(canGet)then
					local cbdata = attris[ nameKeysMap[data.Name] ];
					cbdata.enchantData = data;
					cbdata.pos = data.id;
					cbdata.canGet = true;
				end
			end
		end
	end
	return result;
end

function EnchantView:TryEnchant()
	if(self.waitRecv)then
		return;
	end

	if(self.nowItemData)then
		local hasNewGoodAttri = self.nowItemData.enchantInfo:HasNewGoodAttri();
		if(hasNewGoodAttri)then
			MsgManager.ConfirmMsgByID(3060,function ()
				-- ServiceItemProxy.Instance:CallProcessEnchantItemCmd(false, self.nowItemData.id);
				self:DoEnchant();
			end , nil , nil)
			return;
		end
		self:DoEnchant();
	else
		printRed("No Choosem Item");
	end
end

function EnchantView:DoEnchant()
	FunctionSecurity.Me():EnchantingEquip(self.ExcuteEnchant, self);
end

function EnchantView:ExcuteEnchant()
	if(self.nowItemData)then
		if(not self:HasErrorEnchantInfo(self.nowItemData))then
			if(not self.material_enough)then
				MsgManager.ShowMsgByIDTable(8);
				return;
			end
		end

		if(not self.material_enough)then
			MsgManager.ShowMsgByIDTable(8);
			return;
		end

		if(self.npcdata)then
			self.npcdata:Client_PlayAction(EnchantView.EnchantAction, nil, false);
		end

		self.waitRecv = true;
		ServiceItemProxy.Instance:CallEnchantEquip(self.enchantType, self.nowItemData.id) 
	end
end

function EnchantView:HasErrorEnchantInfo(itemData)
	local enchantInfo = itemData.enchantInfo;
	if(enchantInfo)then
		local attris = enchantInfo:GetEnchantAttrs();
		local combineEffect = enchantInfo:GetCombineEffects();
		if(#combineEffect == 0)then

			local temp = {
				["MaxSpPer"] = 0,
				["MAtk"] = 0,
				["EquipASPD"] = 0,
				["DamIncrease"] = 0,
			};

			for i=1,#attris do
				if(temp[ attris[i].type ] == 0)then
					temp[ attris[i].type ] = 1;
				end
			end

			if(temp["MaxSpPer"] == 1 and temp["MAtk"] == 1)then
				return true;
			elseif(temp["DamIncrease"] or temp["EquipASPD"] == 1)then
				return true;
			end
		end
	end
	return false;
end

function EnchantView:MapEvent()
	self:AddListenEvt(ServiceEvent.ItemEnchantEquip, self.HandleEnchantEnd);
	self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleEnchantItemUpdate);
	self:AddListenEvt(ItemEvent.EquipUpdate, self.HandleEnchantItemUpdate);
	self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleMyDataChange)
end

function EnchantView:HandleMyDataChange(note)
	self:UpdateCoins();
	self:UpdateEnchantTip();
end

function EnchantView:HandleEnchantEnd(note)
	self.waitRecv = false;

	self:UpdateEquipEffect(true);
	self:UpdateEnchantTip();

	self:PlayCommonSound(AudioMap.Maps.Refinesuccess);
	self:PlayUIEffect(EffectMap.UI.upgrade_surprised, 
						self.effectBg.gameObject, 
						true, 
						EnchantView.UpgradeEffectHandle, 
						self);
end

function EnchantView.UpgradeEffectHandle(effectHandle, owner)
	if(owner)then
		owner.effectBg:AddChild(effectHandle.gameObject);
	end
end

function EnchantView:HandleEnchantItemUpdate()
	self:UpdateEquipEffect(true);
	self:UpdateEnchantTip();
end

function EnchantView:OnEnter()
	EnchantView.super.OnEnter(self);

	if(self.npcdata)then
		local npcTrans = self.npcdata.assetRole.completeTransform;
		if(npcTrans)then
			local viewPort = CameraConfig.HappyShop_ViewPort
			local rotation = CameraConfig.HappyShop_Rotation
			self:CameraFaceTo(npcTrans,viewPort,rotation)
		end
	end

	self.waitRecv = false;
end

function EnchantView:OnExit()
	self:CameraReset();
	EnchantView.super.OnExit(self);
end

function EnchantView:CloseSelf()
	if( self.nowItemData)then
		if(self.hasNewGoodAttri)then
			MsgManager.ConfirmMsgByID(3060,function ()
				ServiceItemProxy.Instance:CallProcessEnchantItemCmd(false, self.nowItemData.id);
				EnchantView.super.CloseSelf(self);
			end , nil, nil)
			return;
		elseif(self.hasUnSaveAttri)then
			ServiceItemProxy.Instance:CallProcessEnchantItemCmd(false, self.nowItemData.id);
		end
	end
	EnchantView.super.CloseSelf(self);
end





