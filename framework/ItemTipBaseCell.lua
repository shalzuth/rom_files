local BaseCell = autoImport("BaseCell");
ItemTipBaseCell = class("ItemTipBaseCell", BaseCell);

autoImport("TipLabelCell");

-- order depend on type-value
ItemTipAttriType = {
	Level = 1,
	EquipDecomposeTip = 2,
	ItemType = 3,
	EquipCollectionLv = 4,
	UseLimit = 5,
	GetLimit = 6,

	EquipBaseAttri = 7,
	NextEquipLotteryAttri = 8,
	EquipStrengthRefine = 9,
	EquipSpecial = 10,

	Pvp_EquipBaseAttri = 11,
	Pvp_EquipSpecial = 12,

	EquipEnchant = 13,
	EquipUpInfo = 14,
	EquipUpMaterial = 15,
	EquipCards = 16,
	EquipSuit = 17,
	EquipColor = 18,

	ComposeProductAttri = 19,
	ComposeInfo = 20,

	CardInfo = 21,

	SpecialTip = 22,

	UnLockInfo = 23,

	NoStorage = 24,
	NoMakeCard = 25,

	EquipCanInfo = 26,

	FoodInfo = 27,
	FoodAdvInfo = 28,
	
	PetEggInfo_Brief = 29,
	PetEggInfo_Skill = 30,
	PetEggInfo_Equip = 31,

	EquipJobs = 32,
	NoEffectTip = 33,

	Code = 34,
	Desc = 35,

	TradePrice = 36,
	SellPrice = 37,

	MAX_INDEX = 38,
}

local tempV3 = LuaVector3();
function ItemTipBaseCell:Init()
	self.main = self:FindComponent("Main", UIWidget);
	local cellContainer = self:FindGO("CellContainer");
	if(cellContainer)then
		local cellObj = self:LoadPreferb("cell/ItemCell", cellContainer);
		cellObj.transform:SetParent(cellContainer.transform, true);
		cellObj.transform.localPosition = LuaGeometry.Const_V3_zero;
		self.itemcell = ItemCell.new(cellContainer);
		self.itemcell:HideNum();
	end

	self.typesprite = self:FindComponent("TypeSprite", UISprite);
	self.equipTip = self:FindGO("EquipEd");
	self.scrollview = self:FindComponent("ScrollView", UIScrollView);

	self.replaceInfo = self:FindGO("ReplaceInfo");
	self.replaceLab = self:FindComponent("Label", UILabel, self.replaceInfo);
	self.centerTop = self:FindGO("CenterTop");
	self.centerBottom = self:FindGO("CenterBottom");

	self.getPathBtn = self:FindGO("GetPathBtn");
	if(self.getPathBtn)then
		self:AddClickEvent(self.getPathBtn, function (go)
			self:PassEvent(ItemTipEvent.ShowGetPath, self);
		end);
	end

	self:InitAttriContext();
	
	self:InitEvent();

	self:InitCountChooseBord();
	
	--todo xde 
	if self.getPathBtn then
		local label = self:FindGO("Sprite",self.getPathBtn):GetComponent(UILabel)
		OverseaHostHelper:FixLabelOverV1(label,0,58)
	end
end

function ItemTipBaseCell:InitAttriContext()
	self.table = self:FindComponent("AttriTable", UITable);
	local upPanel = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIPanel);
	local panels = self:FindComponents(UIPanel);
	for i=1,#panels do
		panels[i].depth = upPanel.depth+panels[i].depth;
	end
	self.attriCtl = UIGridListCtrl.new(self.table, TipLabelCell, "TipLabelCell");

	self.contextDatas = {};
end

function ItemTipBaseCell:HideItemIcon()
	if(self.itemcell)then
		self.itemcell:HideIcon();

		local sData = self.data and self.data.staticData;
		if(sData == nil)then
			return;
		end

		local lockDesc = Table_ItemAdvManual[sData.id] and Table_ItemAdvManual[sData.id].LockDesc;
		if(lockDesc)then
			local desc = self.contextDatas[ ItemTipAttriType.Desc ] or {};
			local descStr = lockDesc
			desc.label = ZhString.ItemTip_Desc..descStr;
			desc.hideline = true;
			self.contextDatas[ ItemTipAttriType.Desc ] = desc;
		end

		self:ResetAttriDatas();
	end
end

function ItemTipBaseCell:Active_Collider_Call()
	self:UpdateCountChooseBordButton();
end

function ItemTipBaseCell:InitCountChooseBord()
	self.chooseCount = 1;
	
	self.countChooseBord = self:FindGO("CountChooseBord");

	if(self.countChooseBord == nil)then
		return;
	end
	
	local countChoose_AddButton = self:FindGO("AddButton", self.countChooseBord);
	self.countChoose_AddButton_Sp1 = countChoose_AddButton:GetComponent(UISprite);
	self.countChoose_AddButton_Sp2 = self:FindComponent("Sprite", UISprite, countChoose_AddButton);
	self.countChoose_AddButton_Collider = countChoose_AddButton:GetComponent(BoxCollider);
	self:AddClickEvent(countChoose_AddButton, function ( go )
		self:DoAddUseCount();
	end);
	local longPress = countChoose_AddButton:GetComponent(UILongPress)
	longPress.pressEvent = function ( obj,state )
		self:QuickDoAddUseCount(state);
	end

	local countChoose_MinusButton = self:FindGO("MinusButton", self.countChooseBord);
	self.countChoose_MinusButton_Sp1 = countChoose_MinusButton:GetComponent(UISprite);
	self.countChoose_MinusButton_Sp2 = self:FindComponent("Sprite", UISprite, countChoose_MinusButton);
	self.countChoose_MinusButton_Collider = countChoose_MinusButton:GetComponent(BoxCollider);
	self:AddClickEvent(countChoose_MinusButton, function ( go )
		self:DoMinusUseCount();
	end);

	local longPress = countChoose_MinusButton:GetComponent(UILongPress)
	longPress.pressEvent = function ( obj,state )
		self:QuickMinusAddUseCount(state);
	end

	self.countChoose_CountInput = self:FindComponent("CountInput", UIInput, self.countChooseBord);

	EventDelegate.Set(self.countChoose_CountInput.onChange,function ()
		self.chooseCount = tonumber(self.countChoose_CountInput.value) or 0;
		self:UpdateCountChooseBordButton();
	end)

	self.countChoose_Count = self:FindComponent("Count", UILabel, self.countChooseBord);

	self.chooseCount = 1;
end

function ItemTipBaseCell:DoAddUseCount()
	if(self.data == nil)then
		return;
	end

	self.chooseCount = self.chooseCount + 1;
	self.countChoose_CountInput.value = self.chooseCount;
	self:UpdateCountChooseBordButton(true);
end


function ItemTipBaseCell:QuickDoAddUseCount(open)
	if(open)then
		TimeTickManager.Me():CreateTick(0, 100, function ()
			self:DoAddUseCount();
		end, self, 11);
	else
		TimeTickManager.Me():ClearTick(self, 11)
	end
end

function ItemTipBaseCell:DoMinusUseCount()
	if(self.data == nil)then
		return;
	end

	self.chooseCount = self.chooseCount - 1;
	self.countChoose_CountInput.value = self.chooseCount;
	self:UpdateCountChooseBordButton();
end

function ItemTipBaseCell:ResetUseCount()
	self.chooseCount = 1;

	if(self.countChooseBord == nil)then
		return;
	end

	self.countChoose_CountInput.value = self.chooseCount;
	self:UpdateCountChooseBordButton();
end

function ItemTipBaseCell:SetChooseCount(count)
	self.chooseCount = count;

	if(self.countChooseBord == nil)then
		return;
	end

	self.countChoose_CountInput.value = self.chooseCount;
	self:UpdateCountChooseBordButton();
end

function ItemTipBaseCell:UpdateCountChooseBordButton(showMultipleMsg)
	if(self.countChooseBord == nil)then
		return;
	end

	if(self.data == nil)then
		return;
	end

	local sid = self.data.staticData.id;
	if(sid == nil)then
		return;
	end

	local useMax = nil;

	if(self.countChoose_maxCount == nil)then
		local typeData = Table_ItemType[ self.data.staticData.Type ];
		if(typeData and typeData.UseNumber)then
			useMax = typeData.UseNumber;
		else
			useMax = self.data.staticData.MaxNum;
		end
	else
		useMax = self.countChoose_maxCount;
	end
	
	if(useMax ~= nil)then
		useMax = math.min(self.data.num, useMax);
	else
		useMax = self.data.num;
	end
	if(showMultipleMsg)then
		if(self.countChoose_maxCount and self.chooseCount == self.countChoose_maxCount)then
			MsgManager.ShowMsgByIDTable(1281);
		end
	end

	if(self.chooseCount > useMax or self.chooseCount < 1)then
		self.chooseCount = math.clamp(self.chooseCount, 1, useMax);
		self.countChoose_CountInput.value = self.chooseCount;
	end

	if self.itemcell and not self.dontUpdateCellCount then
		self.itemcell:UpdateNumLabel(self.chooseCount)
	end

	self:_helpActiveButton(self.chooseCount < useMax, 
		self.countChoose_AddButton_Sp1, 
		self.countChoose_AddButton_Sp2,
		self.countChoose_AddButton_Collider);
	self:_helpActiveButton(self.chooseCount > 1, 
		self.countChoose_MinusButton_Sp1, 
		self.countChoose_MinusButton_Sp2,
		self.countChoose_MinusButton_Collider);
end

function ItemTipBaseCell:QuickMinusAddUseCount(open)
	if(open)then
		TimeTickManager.Me():CreateTick(0, 100, function ()
			self:DoMinusUseCount();
		end, self, 12);
	else
		TimeTickManager.Me():ClearTick(self, 12)
	end
end

function ItemTipBaseCell:_helpActiveButton(b, sp1, sp2, collider)
	if(b)then
		sp1.color = ColorUtil.NGUIWhite;
		sp2.color = ColorUtil.NGUIWhite;
		collider.enabled = true;
	else
		sp1.color = ColorUtil.NGUIShaderGray;
		sp2.color = ColorUtil.NGUIShaderGray;
		collider.enabled = false;
	end
end

function ItemTipBaseCell:SetData(data)
	self.hasMonthVIP = ServiceUserEventProxy.Instance:AmIMonthlyVIP();

	self.data = data;
	self:UpdateTopInfo();
	self:UpdateAttriContext();
end

function ItemTipBaseCell:UpdateTopInfo(data)
	local data = data or self.data;
	if(data)then
		local qInt = data.staticData.Quality;
		if(self.typesprite)then
			local typeConfig = Table_ItemType[data.staticData.Type];
			if(typeConfig and typeConfig.icon and typeConfig.icon~="")then
				self.typesprite.gameObject:SetActive(true);
				self.typesprite.spriteName = Table_ItemType[data.staticData.Type].icon;
				self.typesprite:MakePixelPerfect();
			else
				self.typesprite.gameObject:SetActive(false);
			end
		end
		
		if(self.equipTip)then
			self.equipTip:SetActive(data.equiped == 1);
		end
		if(self.itemcell)then
			--选中菜品显示Cell的数量
			if data.staticData.Type == 610 and not self.dontUpdateCellCount then
				self.itemcell:ShowNum()
			end
			self.itemcell:SetData(data);
		end
		
		if(data.equipInfo)then
			local replaceValue = data.equipInfo:GetReplaceValues();
			if(replaceValue > 0)then
				self:SetReplaceInfo(ZhString.Itemtip_EquipScore .. replaceValue);
			else
				self:SetReplaceInfo();
			end
		else
			self:SetReplaceInfo();
		end

		if(self.getPathBtn and data.staticData)then
			local gainData = GainWayTipProxy.Instance:GetDataByStaticID(data.staticData.id)
			self.getPathBtn:SetActive(gainData~=nil);
		end
	end
end


function ItemTipBaseCell:SetReplaceInfo(text)
	if(self.replaceInfo == nil)then
		tempV3:Set(0,100,0);
	else
		if(text == nil or text == "")then
			self.replaceInfo:SetActive(false);
			tempV3:Set(0,100,0);
		else
			self.replaceInfo:SetActive(true);
			tempV3:Set(0,88,0);

			self.replaceLab.text = text;
		end
	end

	if(self.centerTop)then
		self.centerTop.transform.localPosition = tempV3

		if(self.main)then
			self.main:UpdateAnchors();
		end
	end
end

function ItemTipBaseCell:FormatBufferStr(bufferId)
	local str = ItemUtil.getBufferDescById(bufferId);
	local result = "";
	local bufferStrs = string.split(str, "\n")
	for m=1,#bufferStrs do
		result = result.."{uiicon=tips_icon_01} "..bufferStrs[m].."\n";
	end
	if(result~="")then
		result = string.sub(result, 1, -2);
	end
	return result;
end

function ItemTipBaseCell:ActiveText(text, active)
	return active and text or '[c][9c9c9c]' .. text .. "[/c]";
end


-- attri begin
function ItemTipBaseCell:UpdateAttriContext()
	TableUtility.TableClear(self.contextDatas);
	
	if(self.data)then
		self:UpdateNormalItemInfo(self.data);
		self:UpdateEquipAttriInfo(self.data);
		self:UpdateComposeInfo(self.data);
		self:UpdateCardAttriInfo(self.data);
		self:UpdateFoodInfo(self.data);
		self:UpdatePetEggInfo(self.data);
		self:UpdateCodeInfo(self.data);
	end

	self:ResetAttriDatas();
end

function ItemTipBaseCell:_bHairType(type)
	local hairConfig = GameConfig.HairType;
	if(nil==hairConfig) then return false end
	for _,v in pairs(hairConfig) do
		if(type==v)then
			return true;
		end
	end
	return false;
end

local NOSHOW_GETLIMIT_IDMAP = 
{
	[5503] = 1,
}
function ItemTipBaseCell:UpdateNormalItemInfo(data)
	local sData = data and data.staticData;
	if(not sData)then
		return;
	end
	local itemid = sData.id;

	local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)

	if(sData.Level and sData.Level>0)then
		local limitlevel = {};
		local colorStr = mylv>=sData.Level and "[222222]" or CustomStrColor.BanRed;
		limitlevel.label = string.format("[c]%s%s%s[-][/c]", colorStr, ZhString.ItemTip_LimitLv, sData.Level);
		limitlevel.hideline = true;
		self.contextDatas[ ItemTipAttriType.Level ] = limitlevel;
	end

	local iscollection = AdventureDataProxy.Instance:CheckItemIsCollection(data);
	if(iscollection)then
		local tipMap = GameConfig.ItemQualityDesc;
		if(tipMap and tipMap[sData.Quality])then
			local collectionTip = {};
			collectionTip.label = string.format(ZhString.ItemTip_EquipCollectionLv, tipMap[sData.Quality]);
			collectionTip.hideline = true;
			self.contextDatas[ ItemTipAttriType.EquipCollectionLv ] = collectionTip;
		end
	end

	if(nil==data.equipInfo)then
		local pros = Table_UseItem[sData.id] and Table_UseItem[sData.id].Class;
		if(pros ~= nil and next(pros))then
			local proInfo = {};
			local prostr = "";
			local proban = true;
			local myPro = MyselfProxy.Instance:GetMyProfession()
			if(nil==pros or #pros<=0)then
				proban = false;
				prostr = ZhString.ItemTip_AllPro;
			else
				for i =1,#pros do
		 			if(myPro == pros[i])then
			 			proban = false;
					end
					if(Table_Class[pros[i]])then
						prostr = prostr..Table_Class[pros[i]].NameZh;
					end
					if(i~=#pros)then
						prostr = prostr.."/";
					end
				end
			end
			if(proban)then
				proInfo.label = "[c]"..CustomStrColor.BanRed..ZhString.ItemTip_Profession..prostr.."[-][/c]";
			else
				proInfo.label = ZhString.ItemTip_Profession..prostr;
			end
			proInfo.hideline = true;
			self.contextDatas[ ItemTipAttriType.EquipJobs ] = proInfo;
		end
	end

	local typedata = Table_ItemType[sData.Type];
	if(typedata)then
		if(typedata.Name)then
			local typeStr = {};
            -- todo xde 翻译道具类型
			typeStr.label = ZhString.ItemTip_ItemType..OverSea.LangManager.Instance():GetLangByKey(typedata.Name);
			self.contextDatas[ ItemTipAttriType.ItemType ] = typeStr;
		end
	end
	local bHairType = self._bHairType(sData.Type);
	if(not bHairType)then
		local tradeSell = {};
		if(data:CanTrade())then
			local refinelv = self.data.equipInfo and self.data.equipInfo.refinelv
			if(refinelv and refinelv <= 0)then
				refinelv = nil;
			end
			local isOverTime = FunctionItemTrade.Me():IsRequireOverTime(self.data);
			if(isOverTime)then
				tradeSell.label = ZhString.ItemTip_TradePrice..ZhString.ItemTip_TradePriceWait;

				self:RemoveTradeLT();
				self.itemTradeLt = LeanTween.delayedCall(1, function ()
					FunctionItemTrade.Me():GetTradePrice(self.data);
					self:RemoveTradeLT();
				end)
			else
				local price = FunctionItemTrade.Me():GetTradePrice(self.data)
				if(price == 0)then
					tradeSell.label = ZhString.ItemTip_TradePrice..ZhString.ItemTip_TradePriceWait;
				else
					tradeSell.label = ZhString.ItemTip_TradePrice.."{itemicon=100} "..StringUtil.NumThousandFormat(price);
				end
			end
		else
			tradeSell.label = ZhString.ItemTip_TradePrice..ZhString.ItemTip_NoTradeTip;
		end

		tradeSell.hideline = true;
		self.contextDatas[ ItemTipAttriType.TradePrice ] = tradeSell;
	end
	if(not bHairType)then
		local price = sData.SellPrice or 0;
		if(price>0 and sData.NoSale~=1)then
			local sell = {};
			sell.label = ZhString.ItemTip_SellPrice.."{itemicon=100} "..StringUtil.NumThousandFormat(price);
			sell.hideline = true;
			self.contextDatas[ ItemTipAttriType.SellPrice ] = sell;
		end
	end

	if(sData.Desc and sData.Desc~="")then
		local desc = {};
		local descStr = sData.Desc
		if data:IsLoveLetter() then
			local time = os.date("*t", data.createtime)
			descStr = string.format(descStr, data.loveLetter.name, time.year, time.month, time.day)
		elseif(data:IsMarryInviteLetter())then
			local weddingData = data.weddingData;
			local timeStr = os.date(ZhString.ItemTip_WeddingCememony_TimeFormat, weddingData.starttime)
			local lintstr = ChangeZoneProxy.Instance:ZoneNumToString(weddingData.zoneid);
			lintstr = string.format(ZhString.ItemTip_Line, lintstr);
			descStr = string.format(descStr, weddingData.myname, weddingData.partnername, lintstr, timeStr);
		end
		desc.label = ZhString.ItemTip_Desc..descStr;
		desc.hideline = true;
		self.contextDatas[ ItemTipAttriType.Desc ] = desc;
	end

	-- 获取上限
	local limitCfg = sData.GetLimit;
	if(NOSHOW_GETLIMIT_IDMAP[sData.id] == nil and limitCfg and limitCfg.type ~= nil)then
		local getLimitData = {};
		local tipStr = "";

		local str;
		if(limitCfg.type == 1)then
			str = ZhString.ItemTip_GetLimit_Day;
		elseif(limitCfg.type == 7)then
			str = ZhString.ItemTip_GetLimit_Weak;
		end
		local limitCount = ItemData.Get_GetLimitCount(sData.id);

		if(tipStr ~= "")then
			tipStr = tipStr .. "  "
		end
		tipStr = str .. " " .. 0 .. "/" .. limitCount

		getLimitData.label = ZhString.ItemTip_GetLimit .. tipStr;

		self.contextDatas[ ItemTipAttriType.UseLimit ] = getLimitData;

		local sourceId = limitCfg.source and limitCfg.source[1] or nil;
		ServiceItemProxy.Instance:CallGetCountItemCmd(itemid, nil, sourceId);
	end

	-- 解锁 存入属性提示
	local needManualShow, inManualStr, unlockManualStr = false;
	local inManual, unlockManual = false, false;
	if(data:IsFashion())then
		local groupId = Table_Equip[sData.id] and Table_Equip[sData.id].GroupID;
		if(groupId)then
			local fakeItemData = Table_Item[groupId];
			needManualShow = type(fakeItemData.AdventureValue) == "number" and fakeItemData.AdventureValue ~= 0 or false;

			inManualStr = AdventureDataProxy.Instance:getIntoPackageRewardStr(fakeItemData, ZhString.ItemTip_ChAnd);
			unlockManualStr = AdventureDataProxy.Instance:getUnlockRewardStr(fakeItemData, ZhString.ItemTip_ChAnd); 

			inManual = AdventureDataProxy.Instance:IsFashionStored( groupId )
			unlockManual = AdventureDataProxy.Instance:IsFashionUnlock( groupId )
		else
			needManualShow = type(sData.AdventureValue) == "number" and sData.AdventureValue ~= 0 or false;

			inManualStr = AdventureDataProxy.Instance:getIntoPackageRewardStr(sData, ZhString.ItemTip_ChAnd);
			unlockManualStr = AdventureDataProxy.Instance:getUnlockRewardStr(sData, ZhString.ItemTip_ChAnd); 

			inManual = AdventureDataProxy.Instance:IsFashionStored( sData.id )
			unlockManual = AdventureDataProxy.Instance:IsFashionUnlock( sData.id )
		end

	elseif(data:IsPic())then
		local pCData = sData.ComposeID and Table_Compose[sData.ComposeID];
		if(pCData)then
			picToId = pCData.Product.id;
			local psData = Table_Item[picToId];
			local groupId = Table_Equip[psData.id] and Table_Equip[psData.id].GroupID;

			if(groupId)then
				local fakeItemData = Table_Item[groupId];
				needManualShow = type(fakeItemData.AdventureValue) == "number" and fakeItemData.AdventureValue ~= 0 or false;

				inManualStr = AdventureDataProxy.Instance:getIntoPackageRewardStr(fakeItemData, ZhString.ItemTip_ChAnd);
				unlockManualStr = AdventureDataProxy.Instance:getUnlockRewardStr(fakeItemData, ZhString.ItemTip_ChAnd); 

				inManual = AdventureDataProxy.Instance:IsFashionStored( groupId )
				unlockManual = AdventureDataProxy.Instance:IsFashionUnlock( groupId )
			else
				needManualShow = type(psData.AdventureValue) == "number" and psData.AdventureValue ~= 0 or false;

				inManualStr = AdventureDataProxy.Instance:getIntoPackageRewardStr(Table_Item[picToId], ZhString.ItemTip_ChAnd);
				unlockManualStr = AdventureDataProxy.Instance:getUnlockRewardStr(Table_Item[picToId], ZhString.ItemTip_ChAnd); 

				inManual = AdventureDataProxy.Instance:IsFashionStored( picToId )
				unlockManual = AdventureDataProxy.Instance:IsFashionUnlock( picToId )
			end
		end
	elseif(data:IsCard())then
		needManualShow = true;
		inManualStr = AdventureDataProxy.Instance:getIntoPackageRewardStr(sData, ZhString.ItemTip_ChAnd);
		unlockManualStr = AdventureDataProxy.Instance:getUnlockRewardStr(sData, ZhString.ItemTip_ChAnd); 

		inManual = AdventureDataProxy.Instance:IsCardStored( sData.id )
		unlockManual = AdventureDataProxy.Instance:IsCardUnlock( sData.id )
	end
	if(needManualShow)then
		local manual = {label = {}};

		if(inManualStr == nil or inManualStr == "")then
			inManualStr = ZhString.ItemTip_None;
		end
		table.insert(manual.label, self:ActiveText(ZhString.ItemTip_ManualInTip .. inManualStr, inManual));

		if(unlockManualStr == nil or unlockManualStr == "")then
			unlockManualStr = ZhString.ItemTip_None;
		end

		table.insert(manual.label, self:ActiveText(ZhString.ItemTip_ManualUnlockTip .. unlockManualStr, unlockManual));

		self.contextDatas[ ItemTipAttriType.UnLockInfo ] = manual;
	end
	-- 解锁 存入属性提示

	-- 结婚信息 begin
	local weddingData = self.data.weddingData;
	if((data:IsMarriageCertificate() or data:IsMarriageRing()) and weddingData)then
		local weddingDesc = {};
		weddingDesc.label = {};

		weddingDesc.label[1] = sData.Desc;

		local partnername = weddingData.partnername or ""
		local formattime = os.date("%Y/%m/%d", weddingData.weddingtime or 0);
		local lintstr = ChangeZoneProxy.Instance:ZoneNumToString(weddingData.zoneid);
		weddingDesc.label[2] = string.format(ZhString.ItemTip_WeddingTip, 
			weddingData.myname, 
			partnername,
			formattime, 
			lintstr);

		self.contextDatas[ ItemTipAttriType.Desc ] = weddingDesc;
	end
	-- 结婚信息 end

	if(sData.NoStorage and sData.NoStorage > 0)then
		local noStroage = {};
		local storgeDesc = "";
		local index = 0;
		if(not data:CanStorage(BagProxy.BagType.Storage))then
			storgeDesc = storgeDesc .. ZhString.ItemTip_CommonStorage;
			index = index + 1;
		end
		if(not data:CanStorage(BagProxy.BagType.PersonalStorage))then
			if(index > 0)then
				storgeDesc = storgeDesc .. "/";
			end
			storgeDesc = storgeDesc .. ZhString.ItemTip_PersonStorage;
			index =  index + 1;
		end
		if(not data:CanStorage(BagProxy.BagType.Barrow))then
			if(index > 0)then
				storgeDesc = storgeDesc .. "/";
			end
			storgeDesc = storgeDesc .. ZhString.ItemTip_BarrowStorage;
			index =  index + 1;
		end
		noStroage.label = string.format(ZhString.ItemTip_NoStorage, storgeDesc);
		self.contextDatas[ ItemTipAttriType.NoStorage ] = noStroage;
	end

	local useItemData = Table_UseItem[itemid];
	if(useItemData)then
		-- 使用次数限制
		if(useItemData.WeekLimit)then
			local limitData = {};
			limitData.label = string.format(ZhString.ItemTip_UseTimeLimit, 0, useItemData.WeekLimit);
			self.contextDatas[ ItemTipAttriType.UseLimit ] = limitData;

			local itemid = self.data.staticData.id;
			ServiceItemProxy.Instance:CallUseCountItemCmd(itemid);
		end

		local tipInfo = useItemData.TipsInfo;
		if(tipInfo) then
			for i=1,#tipInfo do
				if(tipInfo[i] == 1)then
					local catchMap = Game.Myself.data.userdata:Get(UDEnum.SAVEMAP);
					local catchData = Table_Map[catchMap];
					if(catchMap and catchData)then
						local recordPos = {};
						recordPos.label = {};
						local posStr = ZhString.ItemTip_Position..catchData.NameZh;
						table.insert(recordPos.label, posStr);
						self.contextDatas[ ItemTipAttriType.SpecialTip ] = recordPos;
					end
				end
			end
		end
	end
end

function ItemTipBaseCell:RemoveTradeLT()
	if(self.itemTradeLt)then
		self.itemTradeLt:cancel();
		self.itemTradeLt = nil;
	end
end

local EquipUpgrade_EquipLevel_SpriteMap = {
	[1] = {Active = "tips_icon_1", InActive = "tips_icon_1b"},
	[2] = {Active = "tips_icon_2", InActive = "tips_icon_2b"},
	[3] = {Active = "tips_icon_3", InActive = "tips_icon_3b"},
}
local EquipUpgrade_EquipLevel_Product_Sprite = {
	Active = "tips_icon_end",
	InActive = "tips_icon_end2",
}
function ItemTipBaseCell.EffectSort(a,b)
	return a[1] < b[1]
end
function ItemTipBaseCell:UpdateEquipAttriInfo(data)
	local equipInfo = data.equipInfo;
	local isfashion = data:IsFashion();
	local ismount = data:IsMount();
	local propMap = Game.Config_PropName;
	local isMyItem = BagProxy.Instance:GetItemByGuid(data.id) ~= nil;
	if(equipInfo)then
		local decomposeId = equipInfo.equipData.DecomposeID;
		if(decomposeId)then
			local decompseData = Table_EquipDecompose[decomposeId];
			local decompseTip = {};
			decompseTip.label = string.format(ZhString.ItemTip_DecomposeLv, decompseData.NameZh);
			self.contextDatas[ ItemTipAttriType.EquipDecomposeTip ] = decompseTip
		end

		if(not ismount and not isfashion)then
			local effect = equipInfo.equipData.Effect
			local baseEffect = {};
			for k,v in pairs(effect)do
				if(propMap[k])then
					local vstr = propMap[k].IsPercent==1 and v * 100 .. "%" or v;
					local iconname = GameConfig.PropIcon[propMap[k].VarName] and string.format('{uiicon=%s}', GameConfig.PropIcon[propMap[k].VarName]) or '{uiicon=tips_icon_01}';
					-- todo xde 翻译 物理攻击+xxxx
					-- local templab = iconname..propMap[k].PropName.."+"..vstr;
					local templab = iconname..OverSea.LangManager.Instance():GetLangByKey(propMap[k].PropName).."+"..vstr;
					table.insert(baseEffect, { propMap[k].id, templab });
				end
			end
			local lotterData, nextlotteryData = LotteryProxy.Instance:GetEquipLotteryShowDatas(data.staticData.id);
			if(lotterData)then
				for k,v in pairs(lotterData.Attr)do
					if(propMap[k])then
						local vstr = propMap[k].IsPercent==1 and v * 100 .. "%" or v;
						local iconname = '{uiicon=tips_icon_01}';
						local templab = iconname..propMap[k].PropName.."+"..vstr;
						table.insert(baseEffect, { propMap[k].id, templab });
					end
				end
			end
			if(#baseEffect > 0)then
				table.sort(baseEffect, ItemTipBaseCell.EffectSort);
				local base = { label = '' };
				for i=1,#baseEffect do
					if(base.label ~= '')then
						base.label = base.label .. "\n"
					end
					base.label = base.label .. baseEffect[i][2];
				end

				if(base.label ~= '')then
					self.contextDatas[ ItemTipAttriType.EquipBaseAttri ] = base;
				end
			end

			local pvpeffect = equipInfo.equipData.PVPEffect
			if(pvpeffect)then
				local pvpBaseEffect = {};
				for k,v in pairs(pvpeffect)do
					if(propMap[k])then
						local vstr = propMap[k].IsPercent==1 and v * 100 .. "%" or v;
						local iconname = GameConfig.PropIcon[propMap[k].VarName] and string.format('{uiicon=%s}', GameConfig.PropIcon[propMap[k].VarName]) or '{uiicon=tips_icon_01}';
						local templab = iconname..propMap[k].PropName.."+"..vstr;
						table.insert(pvpBaseEffect, { propMap[k].id, templab });
					end
				end
				local pvp_uniqueEffect = equipInfo:GetPvpUniqueEffect();
				if(#pvpBaseEffect > 0 or (pvp_uniqueEffect and #pvp_uniqueEffect > 0))then
					local isActive = Game.MapManager:IsPVPMode() or Game.MapManager:IsPVPMode_GVGDetailed();

					table.sort(pvpBaseEffect, ItemTipBaseCell.EffectSort);
					local pvpBase = {};
					pvpBase.label = { ZhString.ItemTip_PvpEquipTip };
					local baseStr = "";
					for i=1,#pvpBaseEffect do
						if(isActive)then
							baseStr = baseStr .. pvpBaseEffect[i][2];
						else
							baseStr = baseStr ..'[c][9c9c9c]' .. pvpBaseEffect[i][2] .. "[/c]";
						end
						if(i<#pvpBaseEffect)then
							baseStr = baseStr .. "\n";
						end
					end
					table.insert(pvpBase.label, baseStr)

					if(pvp_uniqueEffect and #pvp_uniqueEffect > 0)then
						local pvpspecial = {};
						pvpspecial.label = {};
						local label = "";
						for i=1,#pvp_uniqueEffect do
							local id = pvp_uniqueEffect[i].id;
							if(isActive)then
								label = label..self:FormatBufferStr(id).."\n";
							else
								label = label..'[c][9c9c9c]' .. self:FormatBufferStr(id).."[/c]\n";
							end
						end
						if(label~="")then
							label = string.sub(label, 1, -2);
							table.insert(pvpBase.label, label);
						end
					end

					self.contextDatas[ ItemTipAttriType.Pvp_EquipBaseAttri ] = pvpBase;
				end
			end
					
			if(nextlotteryData)then
				local nlotteryEffect = {};
				for k,v in pairs(nextlotteryData.Attr)do
					if(propMap[k])then
						local vstr = propMap[k].IsPercent==1 and v * 100 .. "%" or v;
						local iconname = '{uiicon=tips_icon_01}';
						local templab = iconname..propMap[k].PropName.."+"..vstr;
						table.insert(nlotteryEffect, { propMap[k].id, templab });
					end
				end
				if(#nlotteryEffect > 0)then
					table.sort(nlotteryEffect, ItemTipBaseCell.EffectSort);
					local nextlottery = {};
					nextlottery.label = { string.format(ZhString.ItemTip_EquipLotteryTip, nextlotteryData.Level[1]) };
					local nextStr = "";
					for i=1,#nlotteryEffect do
						if(nextStr ~= '')then
							nextStr = nextStr .. "\n"
						end
						nextStr = nextStr .. nlotteryEffect[i][2];
					end
					nextlottery.label[2] = nextStr;
					self.contextDatas[ ItemTipAttriType.NextEquipLotteryAttri ] = nextlottery;
				end
			elseif(lotterData)then
				local nextlottery = {};
				nextlottery.label = ZhString.ItemTip_LotteryMaxTip;
				self.contextDatas[ ItemTipAttriType.NextEquipLotteryAttri ] = nextlottery;
			end
		end

		local strengRefine = {label=""};
		local strenglab, strengthlab2, refinelab, hrefinelab = "","","","";
		if(equipInfo.strengthlv>0)then
			local tiplabel;
			if(isMyItem)then
				local maxlv = BlackSmithProxy.Instance:MaxStrengthLevel(self.data);
				tiplabel = string.format(ZhString.ItemTip_StrengthLv, equipInfo.strengthlv, maxlv)
			else
				tiplabel = string.format(ZhString.ItemTip_StrengthLv_NoMax, equipInfo.strengthlv)
			end
			strenglab = tiplabel..equipInfo:StrengthInfo(nil, false);
		end
		if(equipInfo.strengthlv2>0)then
			local additionalAttrs = ItemFun.calcStrengthAttr(data.staticData.Quality, 
				equipInfo.equipData.EquipType, 
				equipInfo.strengthlv2);
			local effects = {}
			for k,v in pairs(additionalAttrs) do
				local data ={}
				data.name = Table_RoleData[k].VarName
				data.value = v
				table.insert(effects,data)
			end
			strengthlab2 = string.format(ZhString.ItemTip_StrengthLv2, 
				equipInfo.strengthlv2, 
				PropUtil.FormatEffects(effects, 1, " +"));
		end
		if(equipInfo.refinelv>0)then
			local maxlv = self.data.equipInfo.equipData.RefineMaxlv or 0;
			local tiplabel, refineTxt = string.format(ZhString.ItemTip_RefineLv, equipInfo.refinelv, maxlv), "";

			local refineEffect = equipInfo.equipData.RefineEffect;
			local effectName, effectAddValue = next(refineEffect);
			if(effectName and effectAddValue)then
				local proName = GameConfig.EquipEffect[effectName], effectAddValue * equipInfo.refinelv;
				local pro, isPercent = RolePropsContainer.config[effectName], false
				if(pro)then
					isPercent = pro.isPercent
				end
				if(isPercent)then
					refineTxt = string.format("%s+%s%%", proName, effectAddValue * equipInfo.refinelv * 100);
				else
					refineTxt = string.format("%s+%s", proName, effectAddValue * equipInfo.refinelv);
				end
			end
			refinelab = tiplabel..refineTxt;
		end

		if(data.equiped == 1)then
			local siteConfig = GameConfig.EquipType[ equipInfo.equipData.EquipType ];
			local site = siteConfig and siteConfig.site[1];
			local hrEffects = BlackSmithProxy.Instance:GetMyHRefineEffects(site, nil, equipInfo.refinelv);
			if(hrEffects and hrEffects[1])then
				local proKey, proValue = hrEffects[1][1], hrEffects[1][2];

				local nowEN_Str = GameConfig.EquipEffect[proKey] or proKey .. " No Find";
				local nowEV_Str = "";
				local PropNameConfig = Game.Config_PropName
				local config = PropNameConfig[ proKey ];
				if(config.IsPercent == 1)then
					nowEV_Str = proValue * 100 .. "%";
				else
					nowEV_Str = proValue
				end
				if(proValue > 0)then
					nowEV_Str = "+" .. nowEV_Str;
				end

				hrefinelab = ZhString.ItemTip_HRefineAddEffect..nowEN_Str..nowEV_Str;
			end
		end

		strengRefine.label = "";
		if(strenglab ~= "")then
			strengRefine.label = strenglab;
		end
		if(strengthlab2 ~= "")then
			if(strengRefine.label ~= "")then
				strengRefine.label = strengRefine.label .. "\n" .. strengthlab2
			else
				strengRefine.label = strengthlab2
			end
		end
		if(refinelab ~= "")then
			if(strengRefine.label ~= "")then
				strengRefine.label = strengRefine.label .. "\n" .. refinelab
			else
				strengRefine.label = refinelab
			end
		end
		if(hrefinelab ~= "")then
			if(strengRefine.label ~= "")then
				strengRefine.label = strengRefine.label .. "\n" .. hrefinelab
			else
				strengRefine.label = hrefinelab
			end
		end
		if(strengRefine.label ~= "")then
			self.contextDatas[ ItemTipAttriType.EquipStrengthRefine ] = strengRefine;
		end

		local uniqueEffect = equipInfo:GetUniqueEffect();
		if(uniqueEffect and #uniqueEffect>0)then
			local special = {};
			special.label = {};
			local label = "";
			for i=1,#uniqueEffect do
				local id = uniqueEffect[i].id;
				label = label..self:FormatBufferStr(id).."\n";
			end
			if(label~="")then
				label = string.sub(label, 1, -2);
				table.insert(special.label, label);
				self.contextDatas[ ItemTipAttriType.EquipSpecial ] = special;
			end
		end

		if(data.enchantInfo)then
			local attri = data.enchantInfo:GetEnchantAttrs();
			if(#attri>0)then
				local enchant = {};
				enchant.label = ZhString.ItemTip_Enchant.."\n";
				for i=1,#attri do
					local enchantStr = "";
					if(attri[i].propVO.isPercent)then
						enchantStr = string.format("%s    [c][1B5EB1]+%s%%[-][/c]", tostring(attri[i].name), tostring(attri[i].value))
					else
						enchantStr = string.format("%s    [c][1B5EB1]+%s[-][/c]", tostring(attri[i].name), tostring(attri[i].value))
					end
					enchant.label = enchant.label..enchantStr;
					if(i<#attri)then
						enchant.label = enchant.label.."\n";
					end
				end
				local combineEffects = data.enchantInfo:GetCombineEffects()
				for i=1,#combineEffects do
					local combineEffect = combineEffects[i];
					local buffData = combineEffect and combineEffect.buffData;
					if(buffData)then
						enchant.label = enchant.label.."\n";
						if(combineEffect.isWork)then
							enchant.label = enchant.label..string.format("[c][222222]%s:%s[-][/c]", 
								tostring(buffData.BuffName), tostring(buffData.BuffDesc));
						else
							enchant.label = enchant.label..string.format("[c][9c9c9c]%s:%s(%s)[-][/c]", 
								tostring(buffData.BuffName), tostring(buffData.BuffDesc), tostring(combineEffect.WorkTip));
						end
						
					end
				end
				self.contextDatas[ ItemTipAttriType.EquipEnchant ] = enchant;
			end
		end

		local cardSlotNum, replaceCount = data.cardSlotNum, data.replaceCount or 0;
		if((cardSlotNum and cardSlotNum>0) or replaceCount and replaceCount>0)then
			local card = {};
			local equipCards = data.equipedCardInfo or {};
			card.label = {};
			for i=1,cardSlotNum do
				local cardTip = "";
				if(equipCards[i])then
					local iconStr = string.format("{uiicon=card_icon_%02d} ", equipCards[i].staticData.Quality);
					cardTip = iconStr..ColorUtil.TipLightColor..equipCards[i].staticData.NameZh.."[-]".."\n";
					local bufferIds = equipCards[i].cardInfo.BuffEffect.buff;
					for j=1,#bufferIds do
						cardTip = cardTip..self:FormatBufferStr(bufferIds[j]).."\n";
					end
					cardTip = string.sub(cardTip, 1, -2);
				else
					cardTip = string.format("{uiicon=card_icon_0} %s%s[-]", ColorUtil.TipDarkColor, ZhString.ItemTip_EmptyCardSlot);
				end
				table.insert(card.label, cardTip)
			end
			for i=1,replaceCount do
				local replaceTip = string.format("{uiicon=card_icon_lock} %s%s[-]", ColorUtil.TipDarkColor, ZhString.ItemTip_LockCardSlot);
				table.insert(card.label, replaceTip)
			end
			self.contextDatas[ ItemTipAttriType.EquipCards ] = card;
		end

		-- if(not isfashion)then
			local proinfo = {};
			local proban = true; --CustomStrColor.BanRed;
			local prostr = "";
			local pros = self.data.equipInfo.equipData.CanEquip;
			local myPro = MyselfProxy.Instance:GetMyProfession()
			for i =1,#pros do
				if(pros[i] == 0)then
					proban = false;
					prostr = ZhString.ItemTip_AllPro;
					break;
				else
					if(myPro == pros[i])then
						proban = false;
					end
					if(Table_Class[pros[i]])then
						prostr = prostr..Table_Class[pros[i]].NameZh;
					end
					if(i~=#pros)then
						prostr = prostr.."/";
					end
				end
			end
			if(proban)then
				proinfo.label = "[c]"..CustomStrColor.BanRed..ZhString.ItemTip_Profession..prostr.."[-][/c]";
			else
				proinfo.label = ZhString.ItemTip_Profession..prostr;
			end
			proinfo.hideline = true;
			self.contextDatas[ ItemTipAttriType.EquipJobs ] = proinfo;
		-- end

		-- 装备升级信息
		local upgradeData = data.equipInfo.upgradeData;
		if(upgradeData)then
			local equiplv = data.equipInfo.equiplv;
			local maxUplv = data.equipInfo.upgrade_MaxLv;
			if(maxUplv>0)then
				local myClass = Game.Myself.data.userdata:Get(UDEnum.PROFESSION);
				local classDepth = ProfessionProxy.Instance:GetDepthByClassId(myClass);

				local upgradeInfo = {};
				upgradeInfo.label = { ZhString.ItemTip_UpgradeTip };

				local hasUnlocklv;
				for i=1,maxUplv do
					local buffid = equipInfo:GetUpgradeBuffIdByEquipLv(i);
					if(buffid)then
						local text = Table_Buffer[buffid] and Table_Buffer[buffid].Dsc or buffid .. " No Buff Dsc"; --ItemUtil.getBufferDescById(buffid)
						local spriteText;
						if(i > equiplv)then
							local sprite_InActive = "tips_icon_" .. i .. "b";
							spriteText = string.format("{uiicon=%s} ", sprite_InActive);
							-- spriteText = string.format("{uiicon=%s} ", EquipUpgrade_EquipLevel_SpriteMap[i].InActive);
							text = "[c][9d9d9d]" .. text .. "[-][/c]";

							local canUpgrade, lv = equipInfo:CanUpgrade_ByClassDepth(classDepth, i);
							if(not canUpgrade)then
								hasUnlocklv = true;
								table.insert( upgradeInfo.label, string.format(ZhString.ItemTip_NoUpgradeTip, ZhString.ChinaNumber[lv]) );
								break;
							end
						else
							local sprite_Active = "tips_icon_" .. i;
							spriteText = string.format("{uiicon=%s} ", sprite_Active);

							local isEffect, lv = equipInfo:CanUpgrade_ByClassDepth(classDepth, i);
							if(not isEffect)then
								text = text .. string.format(ZhString.ItemTip_NoUpgradeInfoEffectTip, ZhString.ChinaNumber[lv]);
							end
							 -- = "[c][9d9d9d](%s转之后有效)[-][/c]",
							-- spriteText = string.format("{uiicon=%s} ", EquipUpgrade_EquipLevel_SpriteMap[i].Active);
						end
						table.insert(upgradeInfo.label, spriteText .. text);
					end
				end
				if(not hasUnlocklv)then
					local canUpgrade, lv = equipInfo:CanUpgrade_ByClassDepth(classDepth, maxUplv + 1);
					if(not canUpgrade)then
						hasUnlocklv = true;
						table.insert( upgradeInfo.label, string.format(ZhString.ItemTip_NoUpgradeTip, ZhString.ChinaNumber[lv]) );
					end
				end
				if(not hasUnlocklv and upgradeData.Product)then
					local productData = Table_Item[upgradeData.Product];
					local productText = "[c][9d9d9d]" .. string.format(ZhString.ItemTip_UpgradeFinalTip, productData.NameZh) .. "[-][/c]";
					local spriteText = string.format("{uiicon=%s} ", EquipUpgrade_EquipLevel_Product_Sprite.InActive);
					table.insert(upgradeInfo.label, spriteText .. productText);
					local endBuff = equipInfo:GetUpgradeBuffIdByEquipLv(maxUplv + 1);
					if(endBuff)then
						local endBuffDsc = Table_Buffer[endBuff] and Table_Buffer[endBuff].Dsc or endBuff .. ": No Buff Data";
						local text = string.format(ZhString.ItemTip_UpEndBuffTip, productData.NameZh, tostring(endBuffDsc));
						table.insert(upgradeInfo.label, "[c][9d9d9d]"..text.."[-][/c]");
					end
				end
				self.contextDatas[ ItemTipAttriType.EquipUpInfo ] = upgradeInfo;

				-- 装备升级下一级材料信息
				if(equiplv < maxUplv or (equiplv == maxUplv and upgradeData.Product))then
					local upgradeMaterial = {};
					local shortcutID = upgradeData.ShortcutID;
					local umtext = {};
					if(shortcutID)then
						if(shortcutID)then
							local shortData = Table_ShortcutPower[shortcutID];
							local mapid, npcid = shortData.Event.mapid, shortData.Event.npcid;
							local mapName = mapid and Table_Map[mapid].CallZh
							local npcName = npcid and Table_Npc[npcid].NameZh;
							table.insert(umtext, string.format(ZhString.ItemTip_UpgradeNpcTip, mapName, npcName));
						end
					end
					
					table.insert(umtext, string.format(ZhString.ItemTip_UpMaterialTip));

					local bagtype = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Upgrade);
					local materials = equipInfo:GetUpgradeMagerialsByEquipLv(equiplv + 1);
					for i=1,#materials do
						local material = materials[i];
						local msdata = Table_Item[material.id];
						if(material.id~=100 and msdata)then
							local nownum = BagProxy.Instance:GetItemNumByStaticID(material.id,bagtype);
							local neednum = material.num;
							local celllab =  msdata.NameZh .. ZhString.ItemTip_CHSpace .. nownum .. "/" .. neednum;
							table.insert(umtext, celllab);
						end
					end
					upgradeMaterial.label = umtext;
					self.contextDatas[ ItemTipAttriType.EquipUpMaterial ] = upgradeMaterial;
				end
			end
		end

		-- 装备是否可以强化，精炼，附魔
		local canStrength, canRefine, canEnchant = equipInfo:CanStrength(), equipInfo:CanRefine(), equipInfo:CanEnchant();
		local str = "";
		if(not canStrength)then
			if(str ~= "")then
				str = str .. "/"
			end
			str = str .. ZhString.ItemTip_NoStrength;
		end
		if(not canRefine)then
			if(str ~= "")then
				str = str .. "/"
			end
			str = str .. ZhString.ItemTip_NoRefine;
		end
		if(not canEnchant)then
			if(str ~= "")then
				str = str .. "/"
			end
			str = str .. ZhString.ItemTip_NoEnchant;
		end
		if(str ~= "")then
			str = "[c]" .. CustomStrColor.BanRed .. ZhString.ItemTip_EquipCanTip .. str .. "[-][/c]";
			local canInfo = {};
			canInfo.label = str;
			canInfo.hideline = true;
			self.contextDatas[ ItemTipAttriType.EquipCanInfo ] = canInfo;
		end
	end

	-- 装备套装属性
	local suitInfo = data.suitInfo;
	if(suitInfo)then
		local equipSuitDatas = suitInfo:GetEquipSuitDatas();
		if(#equipSuitDatas>0)then
			local suit = {label = {}};
			for k=1,#equipSuitDatas do
				local equipSuitData = equipSuitDatas[k];
				table.insert(suit.label, string.format(ZhString.ItemTip_SuitInfo, k));
				table.insert(suit.label, equipSuitData:GetSuitName());

				local effectStr;
				if(data.equiped == 1 and equipSuitData:CheckIsActive())then
					effectStr = string.format(ZhString.ItemTip_SuitInfoTip, equipSuitData:GetSuitNum())..tostring(equipSuitData:GetEffectDesc());
				else
					effectStr = '[c][9d9d9d]' .. string.format(ZhString.ItemTip_SuitInfoTip, equipSuitData:GetSuitNum())..tostring(equipSuitData:GetEffectDesc()).."[-][/c]"
				end
				table.insert(suit.label, effectStr);
			end
			self.contextDatas[ ItemTipAttriType.EquipSuit ] = suit;
		end
	end
end

function ItemTipBaseCell:UpdateComposeInfo(data)
	local sData = data.staticData;
	if(not sData)then
		return;
	end
	local composeData = Table_Compose[sData.ComposeID];
	local productId = composeData and composeData.Product.id;
	if(productId)then
		local isPic = data:IsPic();
		-- 图纸显示合成道具的特色属性
		if(isPic)then
			local itemData = ItemData.new("Fashion", productId);
			local uniqueEffect = itemData.equipInfo:GetUniqueEffect();
			if(uniqueEffect and #uniqueEffect>0)then
				local picSpecial = {};
				picSpecial.label = {};
				local label = "";
				for i=1,#uniqueEffect do
					local id = uniqueEffect[i].id;
					label = label..self:FormatBufferStr(id).."\n";
				end
				if(label~="")then
					label = string.sub(label, 1, -2);
					-- table.insert(picSpecial.label, ZhString.ItemTip_PicSpecialAttri);
					table.insert(picSpecial.label, label);
					self.contextDatas[ ItemTipAttriType.ComposeProductAttri ] = picSpecial;
				end
			end
		end
		-- 合成信息（如果是图纸 显示为：所需材料； 如果是卡片碎片 显示为合成卡片+碎片） 成品不显示合成信息
		if(productId ~= sData.id)then
			local compose = {};
			compose.label = {};
			local tiplabel = "";
			-- 图纸
			if(isPic)then
				tiplabel = ZhString.ItemTip_PicMake;
			else
				local product = Table_Item[composeData.Product.id]; 
				tiplabel = string.format(ZhString.ItemTip_Compose, product.NameZh);
			end
			if(tiplabel~="")then
				table.insert(compose.label, tiplabel);

				local failIndexMap = {}
				if(composeData.FailStayItem)then
					for i=1,#composeData.FailStayItem do
						local index = composeData.FailStayItem[i];
						if(index)then
							failIndexMap[index] = 1;
						end
					end
				end

				local bagtype = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(BagProxy.MaterialCheckBag_Type.Produce);
				for i = 1,#composeData.BeCostItem do
					if(not failIndexMap[i])then
						local material = composeData.BeCostItem[i];
						local msdata = Table_Item[material.id];
						if(msdata)then
							local nownum =  BagProxy.Instance:GetItemNumByStaticID(material.id,bagtype);
							local neednum = material.num;
							local colorStr = nownum>=neednum and ColorUtil.TipLightColor or ColorUtil.TipDarkColor;
							local celllab = string.format("%s%s    %d/%d[-]", colorStr, msdata.NameZh, nownum, neednum);
							table.insert(compose.label, celllab);
						end
					end
				end
			end
			self.contextDatas[ ItemTipAttriType.ComposeInfo ] = compose;
		end
	end
end

function ItemTipBaseCell:UpdateCardAttriInfo(data)
	-- 卡片道具信息
	if(data.cardInfo)then
		-- 卡片特色属性
		local special = {};
		special.label = {};
		local bufferIds = data.cardInfo.BuffEffect.buff;
		if(bufferIds)then
			for i=1,#bufferIds do
				local str = ItemUtil.getBufferDescById(bufferIds[i]);
				local bufferStrs = string.split(str, "\n")
				-- 每条buffer的描述根据"\n" 分为多条buffer
				for j=1,#bufferStrs do
					local cardTip = "{uiicon=tips_icon_01} "..bufferStrs[j];
					table.insert(special.label, cardTip);
				end
			end
		end
		self.contextDatas[ ItemTipAttriType.CardInfo ] = special;

		-- 卡片不可制作
		if(data:CheckItemCardType(Item_CardType.Raffle))then
			local noMakeCard = {};
			noMakeCard.label = ZhString.ItemTip_NoMakeCard;
			noMakeCard.hideline = true;
			self.contextDatas[ ItemTipAttriType.NoMakeCard ] = noMakeCard;
		end
	end
end

function ItemTipBaseCell:UpdateFoodInfo(data)	
	if(data:IsFood())then
		-- update FoodInfo
		local tipFoodInfo = {};
		tipFoodInfo.label = {};

		local food_Sdata = data:GetFoodSData();
		local desc;
		-- 营养价值
		desc = data:GetFoodEffectDesc();
		if(desc ~= nil)then
			table.insert(tipFoodInfo.label, ZhString.ItemTip_Food_EffectTip .. desc);
		end
		-- 持续时间
		if(food_Sdata.Duration)then
			desc = string.format(ZhString.ItemTip_Food_FullProgressTip, math.floor(food_Sdata.Duration/60))
			table.insert(tipFoodInfo.label, desc);
		end
		-- 存储热量
		desc = nil;
		local hpStr, spStr;
		if(food_Sdata.SaveHP)then
			hpStr = string.format(ZhString.ItemTip_SavePower_Desc, "Hp", food_Sdata.SaveHP);
		end
		if(food_Sdata.SaveSP)then
			spStr = string.format(ZhString.ItemTip_SavePower_Desc, "Sp", food_Sdata.SaveSP);
		end
		if(hpStr and spStr)then
			desc = hpStr .. ZhString.ItemTip_SavePower_And .. spStr;
		else
			desc = hpStr and hpStr or spStr;
		end
		if(desc ~= nil)then
			table.insert(tipFoodInfo.label, ZhString.Itemtip_SavePower .. ZhString.ItemTip_SavePower_Add .. desc);
		end
		-- 饱腹感
		-- if(food_Sdata.FullProgress)then
		-- 	desc = ZhString.ItemTip_Food_FullProgressTip .. "+" .. food_Sdata.FullProgress
		-- 	table.insert(tipFoodInfo.label, desc);
		-- end
		-- 料理难度
		local cookHard = food_Sdata.CookHard;
		if(cookHard)then
			desc = "";
			local starNum = math.floor(cookHard/2);
			for i=1,starNum do
				desc = desc .. "{uiicon=food_icon_08}";
			end
			if(cookHard%2==1)then
				desc = desc .. "{uiicon=food_icon_09}";
			end
			if(desc ~= "")then
				table.insert(tipFoodInfo.label, ZhString.ItemTip_Food_CookHardTip .. desc);
			end
		end
		-- 增高变矮
		local height = food_Sdata.Height;
		if(height)then
			desc = nil;
			if(height > 0)then
				desc = ZhString.ItemTip_Food_HeightTip_Add;
			elseif(height < 0)then
				desc = ZhString.ItemTip_Food_HeightTip_Minus
			end
			if(desc)then
				for i=1,math.abs(height) do
					desc = desc .. "{uiicon=food_icon_10}"
				end	
			end
			table.insert(tipFoodInfo.label, desc);
		end
		-- 变胖变瘦
		local weight = food_Sdata.Weight;
		if(weight)then
			desc = nil;
			if(weight > 0)then
				desc = ZhString.ItemTip_Food_WeightTip_Add;
			elseif(weight < 0)then
				desc = ZhString.ItemTip_Food_WeightTip_Minus;
			end
			if(desc)then
				for i=1,math.abs(weight) do
					desc = desc .. "{uiicon=food_icon_10}"
				end	
			end
			table.insert(tipFoodInfo.label, desc);
		end

		self.contextDatas[ ItemTipAttriType.FoodInfo ] = tipFoodInfo;
		-- local prop = Game.Config_PropName[ k]

		-- food_Sdata
		local userdata = Game.Myself.data.userdata;
		
		local foodAdvInfo = { label = {} }
		local maxCooklv = GameConfig.Food.MaxCookFoodLv;
		local cookInfo = FoodProxy.Instance:Get_FoodCookExpInfo(data.staticData.id)
		local cookerlv = cookInfo and cookInfo.level or 0;
		local cooklvAttr = food_Sdata.CookLvAttr;
		for k,v in pairs(cooklvAttr)do
			local prop = Game.Config_PropName[ k]
			local str = string.format(ZhString.ItemTip_FoodCookTip, maxCooklv, prop.PropName, v);
			str = self:ActiveText(str, cookerlv >= maxCooklv);
			table.insert(foodAdvInfo.label, str);
		end

		local tasterlvAttr = food_Sdata.TasteLvAttr;
		local maxTasterlv = GameConfig.Food.MaxTasterFoodLv;
		local tasteInfo = FoodProxy.Instance:Get_FoodEatExpInfo(data.staticData.id)
		local tasterlv = tasteInfo and tasteInfo.level or 0;
		for k,v in pairs(tasterlvAttr)do
			local prop = Game.Config_PropName[ k]
			local str = string.format(ZhString.ItemTip_FoodTasteTip, maxTasterlv, prop.PropName, v);
			str = self:ActiveText(str, tasterlv >= maxTasterlv);
			table.insert(foodAdvInfo.label, str);
		end
		self.contextDatas[ ItemTipAttriType.FoodAdvInfo ] = foodAdvInfo;
	end
end

function ItemTipBaseCell:UpdatePetEggInfo(data)
	local petEggInfo = data.petEggInfo;
	if(petEggInfo)then
		local briefInfo = {};
		briefInfo.label = {};
		if(petEggInfo.petid)then
			local monsterName = Table_Monster[petEggInfo.petid] and Table_Monster[petEggInfo.petid].NameZh or "UnKnown";
			table.insert(briefInfo.label, string.format(ZhString.ItemTip_PetEgg_MonsterName, monsterName));
		end
		if(petEggInfo.lv)then
			table.insert(briefInfo.label, string.format(ZhString.ItemTip_PetEgg_Level, petEggInfo.lv));
		end
		if(petEggInfo.friendlv)then
			table.insert(briefInfo.label, string.format(ZhString.ItemTip_PetEgg_Friendly, petEggInfo.friendlv));
		end

		local skillInfo;
		local skillids = petEggInfo.skillids;
		if(skillids and #skillids>0)then
			skillInfo = {};
			skillInfo.label = { ZhString.ItemTip_PetEgg_Skill };

			for i=1,#skillids do
				local skillConfig = Table_Skill[skillids[i]];
				if(skillConfig)then
					table.insert(skillInfo.label, skillConfig.NameZh .. "    Lv." .. skillConfig.Level);
				end
			end
		end

		local equipInfo;
		local equips = petEggInfo.equips;
		if(equips and #equips>0)then
			equipInfo = {};
			equipInfo.label = { ZhString.ItemTip_PetEgg_Equip };

			for i=1,#equips do
				table.insert(equipInfo.label, equips[i].staticData.NameZh);
			end
		end

		local lastInfo = briefInfo;

		self.contextDatas[ ItemTipAttriType.PetEggInfo_Brief ] = briefInfo;
		if(skillInfo ~= nil)then
			briefInfo.hideline = true;
			lastInfo = skillInfo;
			self.contextDatas[ ItemTipAttriType.PetEggInfo_Skill ] = skillInfo;
		end
		if(equipInfo ~= nil)then
			if(skillInfo~=nil)then
				skillInfo.hideline = true;
			elseif(briefInfo~=nil)then
				briefInfo.hideline = true;
			end
			lastInfo = equipInfo;
			self.contextDatas[ ItemTipAttriType.PetEggInfo_Equip ] = equipInfo;
		end

		-- if(not data:CanTrade())then
		-- 	table.insert(lastInfo.label, ZhString.ItemTip_PetEgg_Exchange_NotCan);
		-- end
	end
end

function ItemTipBaseCell:UpdateCodeInfo(data)
	if(data == nil)then
		return;
	end

	local codeData = data.CodeData;
	if(codeData and codeData.code and codeData.code ~= "")then
		local code = data.code;
		local codeDesc = {};
		codeDesc.label = string.format(ZhString.ItemTip_Code_Desc, codeData.code);
		self.contextDatas[ ItemTipAttriType.Code ] = codeDesc;
	else
		-- KFC活动
		if(self.data.staticData.id == 6081)then
			ServiceItemProxy.Instance:CallUseCodItemCmd(data.id);
		end
	end
end

function ItemTipBaseCell:ResetAttriDatas(resetPos)
	local maxIndex = ItemTipAttriType.MAX_INDEX;
	if(not self.listDatas)then
		self.listDatas = {};
	else
		TableUtility.ArrayClear(self.listDatas);
	end
	for i=1,ItemTipAttriType.MAX_INDEX do
		if(self.contextDatas[i])then
			table.insert(self.listDatas, self.contextDatas[i]);
		end
	end
	if(resetPos == nil)then
		resetPos = true;
	end

	self.attriCtl:ResetDatas(self.listDatas, true, resetPos);

	if(self.main and resetPos)then
		self.main:UpdateAnchors();
	end
end
-- attri end



function ItemTipBaseCell:UpdateTradePrice(evt)
	if(Slua.IsNull(self.gameObject))then
		self:Exit();
		return;
	end

	local data = evt.data;

	if(self.data)then
		local key = FunctionItemTrade.Me():CombineItemKey(self.data)
		local id, price = data.id, data.price;
		if(id == key)then
			local tradeData = self.contextDatas[ ItemTipAttriType.TradePrice ];
			if(tradeData)then
				if(price == 0)then
					tradeData.label = ZhString.ItemTip_TradePrice..ZhString.ItemTip_TradePriceWait;
				else
					tradeData.label = ZhString.ItemTip_TradePrice.."{itemicon=100} "..StringUtil.NumThousandFormat(price);
				end
			end

			self:ResetAttriDatas(false);
		end
	end
end

function ItemTipBaseCell:HideEquipedSymbol()
	self.equipTip:SetActive(false);
end

function ItemTipBaseCell:SetNoEffectTip(active)
	local noEffectTip = self.contextDatas[ItemTipAttriType.NoEffectTip];
	if(active)then
		if(noEffectTip == nil)then
			local noEffectTip = {};
			noEffectTip.label = "[c]" .. CustomStrColor.BanRed .. ZhString.ItemTip_NoEffectTip .. "[-][/c]";
			self.contextDatas[ItemTipAttriType.NoEffectTip] = noEffectTip
			self:ResetAttriDatas();
		end
	else
		self.contextDatas[ItemTipAttriType.NoEffectTip] = nil;
		self:ResetAttriDatas();
	end
end

function ItemTipBaseCell:AddOtherTip(index, labels, hideline, refresh)
	local otherTip = {};
	otherTip.label = labels;
	otherTip.hideline = hideline;	
	self.contextDatas[ index ] = otherTip;
	
	if(refresh)then
		self:ResetAttriDatas();
	end
end

function ItemTipBaseCell:ActiveCountChooseBord(b, countChoose_maxCount)
	if(self.countChooseBord == nil)then
		return;
	end

	if(b)then
		self.countChoose_maxCount = countChoose_maxCount;
		self.countChooseBord:SetActive(true);

		tempV3:Set(0, -90, 0);
		self.centerBottom.transform.localPosition = tempV3;

		self.countChoose_CountInput.value = self.chooseCount;
		-- self.countChoose_Count.text = self.chooseCount;
	else
		self.countChooseBord:SetActive(false);

		tempV3:Set(0, -145, 0);
		self.centerBottom.transform.localPosition = tempV3;
	end
	-- CountChooseBord
end

function ItemTipBaseCell:Exit()
	TimeTickManager.Me():ClearTick(self, 11)
	TimeTickManager.Me():ClearTick(self, 12)
end

function ItemTipBaseCell:InitEvent()
	self:AddGameObjectComp();

	if(self.isEvent_Add == true)then
		return;
	end

	self.isEvent_Add = true;

	EventManager.Me():AddEventListener(ItemTradeEvent.TradePriceChange, self.UpdateTradePrice, self);
	EventManager.Me():AddEventListener(ServiceEvent.ItemUseCountItemCmd, self.UpdateUseLimit, self);
	EventManager.Me():AddEventListener(ServiceEvent.ItemGetCountItemCmd, self.UpdateGetLimit, self);
	EventManager.Me():AddEventListener(ServiceEvent.ItemUseCodItemCmd, self.UpdateGetCodItem, self);
end

function ItemTipBaseCell:UpdateTradePrice(evt)
	if(Slua.IsNull(self.gameObject))then
		self:Exit();
		return;
	end

	local data = evt.data;

	if(self.data)then
		local key = FunctionItemTrade.Me():CombineItemKey(self.data)
		local id, price = data.id, data.price;
		if(id == key)then
			local tradeData = self.contextDatas[ ItemTipAttriType.TradePrice ];
			if(tradeData)then
				if(price == 0)then
					tradeData.label = ZhString.ItemTip_TradePrice..ZhString.ItemTip_TradePriceWait;
				else
					tradeData.label = ZhString.ItemTip_TradePrice.."{itemicon=100} "..StringUtil.NumThousandFormat(price);
				end
			end

			self:ResetAttriDatas(false);
		end
	end
end

function ItemTipBaseCell:UpdateUseLimit(evt)
	local data = evt.data;
	local itemid,count = data.itemid, data.count;
	if(self.data and self.data.staticData.id ~= itemid)then
		return;
	end
	local useData = Table_UseItem[itemid];
	local useLimitData = self.contextDatas[ ItemTipAttriType.UseLimit ];
	if(useLimitData and useData and useData.WeekLimit)then
		local maxTime = useData.WeekLimit
		if(self.hasMonthVIP)then
			useLimitData.label =  ZhString.ItemTip_MonthNoLimit;
		else
			useLimitData.label = string.format(ZhString.ItemTip_UseTimeLimit, count, maxTime);
		end
		self:ResetAttriDatas();
	end
end

function ItemTipBaseCell:UpdateGetLimit(evt)
	local data = evt.data;
	local itemid,count = data.itemid, data.count;

	if(self.data == nil or self.data.staticData.id ~= itemid)then
		return;
	end

	local sData = self.data.staticData;

	local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
	local getLimitData = self.contextDatas[ ItemTipAttriType.UseLimit ];
	if(getLimitData)then
		local tipStr = "";

		local limitCfg = sData.GetLimit;
		local str;
		if(limitCfg.type == 1)then
			str = ZhString.ItemTip_GetLimit_Day;
		elseif(limitCfg.type == 7)then
			str = ZhString.ItemTip_GetLimit_Weak;
		end
		local limitCount = ItemData.Get_GetLimitCount(sData.id);

		if(tipStr ~= "")then
			tipStr = tipStr .. "  "
		end
		tipStr = str .. " " .. count .. "/" .. limitCount

		getLimitData.label = ZhString.ItemTip_GetLimit .. tipStr;

		self:ResetAttriDatas();
	end
end

function ItemTipBaseCell:UpdateGetCodItem(data)
	if(self.data == nil)then
		return;
	end
	if(self.data.id == data.guid)then
		return;
	end

	local code = data.code;
	local codeDesc = {};
	codeDesc.label = string.format(ZhString.ItemTip_Code_Desc, code);

	self.contextDatas[ ItemTipAttriType.Code ] = codeDesc;

	self:ResetAttriDatas();
end

function ItemTipBaseCell:OnDestroy()
	self:RemoveEvent();
end

function ItemTipBaseCell:RemoveEvent()
	self:RemoveTradeLT();

	if(self.isEvent_Add ~= true)then
		return;
	end

	self.isEvent_Add = false;

	EventManager.Me():RemoveEventListener(ItemTradeEvent.TradePriceChange, self.UpdateTradePrice, self)
	EventManager.Me():RemoveEventListener(ServiceEvent.ItemUseCountItemCmd, self.UpdateUseLimit, self);
	EventManager.Me():RemoveEventListener(ServiceEvent.ItemGetCountItemCmd, self.UpdateGetLimit, self);
	EventManager.Me():RemoveEventListener(ServiceEvent.ItemUseCodItemCmd, self.UpdateGetCodItem, self);
end

function ItemTipBaseCell:OnDisable()
end

