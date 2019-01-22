autoImport("BaseCDCell");
autoImport("ItemCardCell");
autoImport("PortraitFrameCell");
ItemCell = class("ItemCell", BaseCDCell)

ItemCell.Config = {
	PicId = 50,
	ChipId = 110,
}

local EquipLv_SpriteMap = 
{
	[1] = "equip_icon_1",
	[2] = "equip_icon_2",
	[3] = "equip_icon_3",
}

function ItemCell:Init()
	ItemCell.super.Init(self);
	
	self:InitItemCell();
end

function ItemCell:SetDefaultBgSprite(atlas, spriteName)
	self.DefaultBg_atlas = atlas;
	self.DefaultBg_spriteName = spriteName;
end

function ItemCell:InitItemCell()
	self.item = self:FindGO("Item");
	self.empty = self:FindGO("Empty");
	self.empty_hideIcon = self:FindGO("HideIconSymbol", self.empty);
	self.normalItem = self:FindGO("NormalItem");

	self.icon = self:FindComponent("Icon_Sprite", UISprite);
	self.questFlagIcon = self:FindComponent("QuestFlagIcon",UISprite);
	self.numLab = self:FindComponent("NumLabel", UILabel);
	self.bg = self:FindComponent("Background", UISprite);
	self.pic = self:FindGO("Pic");
	self.newTag = self:FindGO("NewTag");
	self.invalid = self:FindGO("Invalid");
	self.strenglv = self:FindComponent("StrengLv", UILabel);
	self.refinelv = self:FindComponent("RefineLv", UILabel);
	-- self.equiplv = self:FindComponent("EquipLv", UISprite);
	self.equiplv = self:FindComponent("EquipLv", UILabel);
	self.damageSymbol = self:FindGO("Break");
	self.activeSymbol = self:FindGO("ActiveSymbol");
	self.nameLab = self:FindComponent("ItemName", UILabel);
	self.cardSlotGO = self:FindGO("CardSlot");
	self.functionTip = self:FindGO("FunctionTip");
	self.shopCorner = self:FindGO("ShopCorner");
	self.foodStars = {};
	self.foodStars[0] = self:FindGO("FoodStars");
	if(self.foodStars[0])then
		for i=1,5 do
			self.foodStars[i] = self:FindComponent(tostring(i), UISprite, self.foodStars[0]);
		end
	end
	
	self.coldDown = self:FindComponent("ColdDown", UISprite, self.item);
	self.goMask = self:FindGO("Mask")
	if self.goMask then
		self.spMask = self.goMask:GetComponent(UISprite)
	end
	self.bebreaked = self:FindComponent("BeBreaked", UISprite);;

	self.numHide = false;
end

function ItemCell:InitCardSlot()
	if(not self.initCardSlot)then
		self.initCardSlot = true;
		if(self.cardSlotGO)then
			local slotCpy = self:FindGO("CardEquip1", self.cardSlotGO);
			if(slotCpy)then
				self.cardSlotSymbols = {};
				for i=1,5 do
					local cardGO;
					if(i==1)then
						cardGO = slotCpy;
					else
						cardGO = self:FindGO("CardEquip"..i, self.cardSlotGO)
						if(not cardGO)then
							cardGO = self:CopyGameObject(slotCpy, self.cardSlotGO);
							cardGO.name = "CardEquip"..i;
						end
					end
					local cardSp = cardGO:GetComponent(UISprite);
					table.insert(self.cardSlotSymbols, cardSp);
				end
			end
		end
	end
end

function ItemCell:RemoveUnuseObj(key)
	if(not self:ObjIsNil(self[key]))then
		GameObject.DestroyImmediate(self[key]);
		self[key] = nil;
	end
end

function ItemCell:SetData(data)
	self.data = data;
	local cellGO = self.item or self.gameObject;
	if(data == nil or data.staticData == nil)then
		if(self.empty)then
			self.empty:SetActive(true);
			if(self.empty_hideIcon and self.empty_hideIcon.activeSelf)then
				self.empty_hideIcon:SetActive(false);
			end
		end
		if(cellGO)then
			cellGO:SetActive(false);
		end
		return;
	end
	if(cellGO)then
		cellGO:SetActive(true);
	end
	if(self.empty)then
		self.empty:SetActive(false);
	end
	-- ??????
	if(self.numLab)then
		if(not self.numHide and data.num>1)then
			self.numLab.gameObject:SetActive(true);
			self.numLab.text = data.num;
			self.numLab.transform.localPosition = Vector3(35, -37, 0);
		else
			self.numLab.gameObject:SetActive(false);
		end
	end
	-- ?????????new
	if(self.newTag)then
		local isnew = data:IsNew() and true or false;
		self.newTag:SetActive(isnew);
	end

	local dType = data.staticData.Type;
	local isCard = AdventureDataProxy.Instance:isCard(dType);
	if(isCard)then
		if(not self.cardItem)then
			local cardobj = self:LoadPreferb("cell/ItemCardCell", cellGO);
			self.cardItem = ItemCardCell.new(cardobj);
		end
		self.cardItem:SetData(data);
		if(self.numLab)then
			self.numLab.transform.localPosition = Vector3(28, -37, 0);
		end
	else
		if(self.cardItem)then
			self.cardItem:SetData(nil);
		end
	end
	if(self.normalItem)then
		self.normalItem:SetActive(not isCard);
	end

	self:SetQuestIcon(dType);
	-- ???????????????
	if(dType == self.Config.PicId)then
		if(self.bg)then
			IconManager:SetUIIcon("icon_34", self.bg)
		end
	else
		if(self.bg)then
			self.bg.atlas = self.DefaultBg_atlas or RO.AtlasMap.GetAtlas("NewCom");
			self.bg.spriteName = self.DefaultBg_spriteName or "com_icon_bottom3";
		end
	end
	-- ??????
	if(self.icon)then
		local setSuc, scale = false, Vector3.one;
		if(dType == 1200)then
			setSuc = IconManager:SetFaceIcon(data.staticData.Icon, self.icon)
			-- ?????????????????? ??????????????????
			if(not setSuc)then
				setSuc = IconManager:SetFaceIcon("boli", self.icon)
			end
			scale = Vector3.one*0.71;
		else
			setSuc = IconManager:SetItemIcon(data.staticData.Icon, self.icon)
			-- ?????????????????? ?????????????????????
			if(not setSuc)then
				setSuc = IconManager:SetItemIcon("item_45001", self.icon)
			end
			self.icon.transform.localScale = Vector3.one;
		end
		if(setSuc)then
			self.icon.gameObject:SetActive(true);
			self.icon:MakePixelPerfect()
			self.icon.transform.localScale = scale
		else
			self.icon.gameObject:SetActive(false);
		end
	end
	-- ??????????????????
	if(self.bebreaked)then
		if(data.equipInfo)then
			local st = data.equipInfo.site;
			local st = st and st[1];
			if(st)then
				st = st == 5 and 6 or st; 
				self.bebreaked.spriteName = "bag_equip_break" .. tostring(st);
			else
				self.bebreaked.spriteName = "";
			end
		end
	end
	-- ????????????
	if(self.strenglv)then
		if(data.equipInfo and data.equipInfo.strengthlv>0)then
			self.strenglv.gameObject:SetActive(true);
			self.strenglv.text = data.equipInfo.strengthlv;
		else
			self.strenglv.gameObject:SetActive(false);
		end
	end
	-- ????????????
	if(self.refinelv)then
		if(data.equipInfo and data.equipInfo.refinelv>0)then
			self.refinelv.gameObject:SetActive(true);
			self.refinelv.text = string.format("+%d", data.equipInfo.refinelv);
		else
			self.refinelv.gameObject:SetActive(false);
		end
	end
	-- ???????????????????????????
	if(self.damageSymbol)then
		if(data.equipInfo)then
			self:SetActive(self.damageSymbol, data.equipInfo.damage);
		else
			self:SetActive(self.damageSymbol, false);
		end
	end
	-- ??????????????????
	if(self.equiplv)then
		if(data.equipInfo)then
			local equiplv = data.equipInfo.equiplv;
			if(equiplv > 0)then
				self:SetActive(self.equiplv, true);
				self.equiplv.text = StringUtil.IntToRoman(equiplv);
			else
				local artifact_lv = data.equipInfo.artifact_lv;
				if(artifact_lv and artifact_lv > 0)then
					self:SetActive(self.equiplv, true);
					self.equiplv.text = StringUtil.IntToRoman(artifact_lv);
				else
					self:SetActive(self.equiplv, false);
				end
			end
		else
			self:SetActive(self.equiplv, false);
		end
	end
	-- ????????????
	local slotNum = data.cardSlotNum or 0;
	local replaceCount = data.replaceCount or 0;
	if(self.cardSlotGO)then
		if(data.equipInfo and (slotNum>0 or replaceCount>0))then
			self:InitCardSlot();
			self.cardSlotGO:SetActive(true);

			local cardDatas = data.equipedCardInfo or {};
			local symbols = self.cardSlotSymbols;
			
			local count = 1;
			for i=1,#symbols do
				if(i<=slotNum)then
					symbols[i].gameObject:SetActive(true);
					local spriteName = cardDatas[i] and string.format("card_icon_%02d", cardDatas[i].staticData.Quality) or "card_icon_0";
					symbols[i].spriteName = spriteName;
					count = count + 1;
				elseif(i <= slotNum+replaceCount)then
					symbols[i].gameObject:SetActive(true);
					symbols[i].spriteName = "card_icon_lock";
					count = count + 1;
				else
					symbols[i].gameObject:SetActive(false);
				end
			end
			-- UIGrid ?????????bug
			for i=1,count do
				symbols[i].transform.localPosition = Vector3(-10*(count-1-i),0,0);
			end
		else
			self.cardSlotGO:SetActive(false);
		end
	end

	if(self.nameLab)then
		self.nameLab.text = self.data:GetName();
	end
	
	if(self.activeSymbol)then
		self.activeSymbol:SetActive(data.isactive == true);
	end

	local itemType = self.data and self.data.staticData and self.data.staticData.Type;
	-- ??????????????????????????????
	if(self.invalid)then
		if(data.IsUseItem and data:IsUseItem())then
			if(itemType)then
				local couldUse = ItemsWithRoleStatusChange.Instance():ItemIsCouldUseWithCurrentStatus(itemType);
				if(couldUse == true)then
					self.invalid.gameObject:SetActive(self.data:IsLimitUse());
				else
					self.invalid.gameObject:SetActive(true);
				end
			end
		else
			self.invalid.gameObject:SetActive(false);
		end
	end

	-- ???????????????Tip
	if(self.functionTip)then
		self.functionTip:SetActive(itemType == 65);
	end

	-- ?????????????????????
	if(self.shopCorner)then
		self.shopCorner:SetActive(itemType == 61);
	end

	if(self.foodStars[0])then
		local foodSData = data:GetFoodSData();
		if(foodSData~=nil)then
			local cookHard = foodSData.CookHard;
			if(cookHard and cookHard > 0)then
				self.foodStars[0]:SetActive(true);
				local num = math.floor(cookHard/2)
				for i=1,5 do
					if(i<=num)then
						self.foodStars[i].gameObject:SetActive(true);
						self.foodStars[i].spriteName = "food_icon_08";
					elseif(i==num+1 and cookHard%2==1)then
						self.foodStars[i].gameObject:SetActive(true);
						self.foodStars[i].spriteName = "food_icon_09";
					else
						self.foodStars[i].gameObject:SetActive(false);
					end
				end
			else
				self.foodStars[0]:SetActive(false);
			end
		else
			self.foodStars[0]:SetActive(false);
		end
	end
end

function ItemCell:UpdateMyselfInfo(data)
	-- ???????????????
	if(self.invalid == nil)then
		return;
	end
	data = data or self.data;
	if(data == nil)then
		self.invalid:SetActive(false);
		return;
	end

	if(data and data.IsJobLimit and data:IsJobLimit())then
		self.invalid:SetActive(true);
		return;
	end
	
	if(data.IsUseItem and data:IsUseItem())then
		return;
	end
	if(data.equipInfo)then
		local isValid = true;
		if(BagProxy.BagType.RoleEquip == data.bagType or 
			BagProxy.BagType.RoleFashionEquip == data.bagType)then
			isValid = data:CanIOffEquip();
		else
			isValid = data:CanEquip();
		end
		self:SetActive(self.invalid, not isValid);
	else
		self:SetActive(self.invalid, false);
	end
end

-- ????????????icon
function ItemCell:SetQuestIcon(itemType)
	if(nil==self.questFlagIcon)then return end;
	local iconName = nil;
	if(nil==GameConfig.QuestItemIcon) then 
		self:Hide(self.questFlagIcon.gameObject); 
		return 
	end
	for k,v in pairs(GameConfig.QuestItemIcon) do
		if(k==itemType)then
			iconName=v;
		end
	end
	if(nil==iconName)then
		self:Hide(self.questFlagIcon.gameObject);
		return 
	end
	self:Show(self.questFlagIcon.gameObject);
	IconManager:SetUIIcon(iconName, self.questFlagIcon);
end

function ItemCell:SetIconGrey(b)
	local data = self.data;
	if(data and data.staticData)then
		local isCard = AdventureDataProxy.Instance:isCard(data.staticData.Type);
		if(isCard)then
			self:SetCardGrey(b);
		else
			if(self.icon)then
				self.icon.color = b and Color(1/255,2/255,3/255) or Color(1,1,1);
			end
		end
	end
end

function ItemCell:SetIconDark(b)
	if(self.icon)then
		self.icon.color = b and Color(100/255,100/255,100/255) or Color(1,1,1);
	end
end

function ItemCell:isCard( type )
	-- body

end

function ItemCell:ShowMask()
	if self.spMask then
		self.spMask.enabled = true
	end
end

function ItemCell:HideMask()
	if self.spMask then
		self.spMask.enabled = false
	end
end

function ItemCell:ActiveNewTag(b)
	if(self.newTag)then
		self.newTag:SetActive(b);
	end
end

function ItemCell:SetMinDepth(minDepth)
	self.minDepth = minDepth;
end

function ItemCell:SetCardGrey(b)
	if(self.cardItem)then
		self.cardItem:SetCardGrey(b);
	end
end

function ItemCell:ShowNum()
	self.numHide = false;
end

function ItemCell:HideNum()
	self.numHide = true;
end

function ItemCell:HideIcon()
	if(self.item)then
		self.item:SetActive(false);
	end

	if(self.empty)then
		self.empty:SetActive(true);
	end

	if(self.empty_hideIcon)then
		self.empty_hideIcon:SetActive(true);
	end
end


-- ????????????
local BagType_SymbolMap = {
	[BagProxy.BagType.PersonalStorage] = "com_icon_Corner_warehouse",
	[BagProxy.BagType.Barrow] = "com_icon_Corner_wheelbarrow",
	[BagProxy.BagType.Temp] = "com_icon_Corner_temporarybag",
}
function ItemCell:UpdateBagType()
	if(not self.init_bagtype)then
		self.init_bagtype = true;

		self.bagTypes = self:FindGO("BagTypes");
		self.bagTypes_Sp = self.bagTypes and self.bagTypes:GetComponent(UISprite);
	end

	if(self.bagTypes == nil)then
		return;
	end

	local data = self.data;
	if(data and data.bagtype)then
		if(BagType_SymbolMap[data.bagtype])then
			self.bagTypes:SetActive(true);
			self.bagTypes_Sp.spriteName = BagType_SymbolMap[data.bagtype];
		else
			self.bagTypes:SetActive(false);
		end
	else
		self.bagTypes:SetActive(false);
	end
end

local equipUpgrade_RefreshBagType;
function ItemCell:UpdateEquipUpgradeTip()
	if(self.upgradeTip == nil)then
		self.upgradeTip = self:FindGO("UpgradeTip");
	end

	if(self.upgradeTip == nil)then
		return;
	end

	self.upgradeTip:SetActive(false);

	local bagtype, equipInfo;
	if(type(self.data) == "table")then
		bagtype = self.data.bagtype;
		equipInfo = self.data.equipInfo;
	end

	if(equipUpgrade_RefreshBagType == nil)then
		equipUpgrade_RefreshBagType = BagProxy.EquipUpgrade_RefreshBagType;
	end
	if(bagtype == nil or equipUpgrade_RefreshBagType[bagtype] == nil)then
		return;
	end

	if(equipInfo == nil)then
		return;
	end

	if(not equipInfo:CheckCanUpgradeSuccess(true))then
		return;
	end
	
	self.upgradeTip:SetActive(true);
end

function ItemCell:UpdateNumLabel( count )
	if(self.numLab)then
		if(not self.numHide and count > 0)then
			self.numLab.gameObject:SetActive(true);
			self.numLab.text = count;
			self.numLab.transform.localPosition = Vector3(35, -37, 0);
		else
			self.numLab.gameObject:SetActive(false);
		end
	end
end