autoImport("BaseTip");
FoodRecipeTip = class("FoodRecipeTip",BaseTip);

autoImport("ItemTipComCell");

function FoodRecipeTip:Init()
	FoodRecipeTip.super.Init(self);

	self.itemTipComCell = ItemTipComCell.new(self.gameObject);
	self.itemTipComCell:AddEventListener(ItemTipEvent.ClickTipFuncEvent, self.ClickTipFuncEvent, self);
end

function FoodRecipeTip:ClickTipFuncEvent(cell)
	TipManager.Instance:CloseRecipeTip()
end

function FoodRecipeTip:SetData(data)
	if(data == nil)then
		return;
	end
	local matchNum = FunctionFood.Me():Match_MakeNum(data.staticData.id);

	local productData = data:GetProductItem();
	productData:SetItemNum(matchNum)
	self.itemTipComCell:SetData(productData);
	self.itemTipComCell:HideGetPath();

	local materialInfo = {};
	local foodProxy = FoodProxy.Instance;
	materialInfo[1] = ZhString.FoodRecipeTip_RecipeTip;
	local bagProxy = BagProxy.Instance;
	local material = data.staticData.Material;
	materialInfo[2] = "";
	for i=1,#material do
		local m = material[i]
		if(m[1] == 1)then
			local sData = Table_Item[m[2]]
			local bagNum = bagProxy:GetItemNumByStaticID(m[2], BagProxy.BagType.Food);
			materialInfo[2] = materialInfo[2] .. string.format(ZhString.FoodRecipeTip_RecipeMaterial_FamilyTip, sData.NameZh, bagNum, m[3]);
			if(i < #material)then
				materialInfo[2] = materialInfo[2] .. "\n"
			end
		elseif(m[1] == 2)then
			local itype = m[2];
			local itypeName = Table_ItemType[m[2]] and Table_ItemType[m[2]].Name;

			local bagNum = 0;
			local items = bagProxy:GetBagItemsByType(itype, BagProxy.BagType.Food)
			for j=1,#items do
				bagNum = bagNum + items[j].num;
			end
			materialInfo[2] = materialInfo[2] .. string.format(ZhString.FoodRecipeTip_RecipeMaterial_FamilyTip, itypeName, bagNum, m[3]);
			if(i < #material)then
				materialInfo[2] = materialInfo[2] .. "\n"
			end
		end
	end

	self.itemTipComCell:AddOtherTip(ItemTipAttriType.FoodInfo+1, materialInfo, false, false);

	local recipeInfo = {};
	local userdata = Game.Myself.data.userdata;
	if(userdata)then
		local cookerlv = userdata:Get(UDEnum.COOKER_LV) or 1;
		cookerlv = math.max(cookerlv, 1);
		local cookHard = data:GetDiffLevel();
		if(cookHard > cookerlv+1)then
			table.insert(recipeInfo, ZhString.FoodRecipeTip_MinusSuccrateTip);
		end
	end

	if(productData.staticData.Type == 610)then
		local cookInfo = foodProxy:Get_FoodCookExpInfo(productData.staticData.id);
		local cooklv, expPct;
		if(cookInfo)then
			cooklv = cookInfo.level;
			local maxExp = GameConfig.Food.CookFoodExpPerLv or 10;
			expPct = math.floor(cookInfo.exp*1000/maxExp)/10
		else
			cooklv = 1;
			expPct = 0.0
		end
		table.insert(recipeInfo, string.format( ZhString.FoodRecipeTip_Cook_Proficiency, data.staticData.Name, cooklv, expPct) );
	end

	self.itemTipComCell:AddOtherTip(ItemTipAttriType.FoodInfo+2, recipeInfo, false, true);

	self:UpdateRecipeFunc(data, matchNum);
end

function FoodRecipeTip:UpdateRecipeFunc(recipeData, matchNum)
	local param = {}
	param.recipeData = recipeData
	param.matchNum = matchNum
	local buttonData = {
		name = ZhString.FoodRecipeTip_PutMaterials,

		callback = FoodRecipeTip.PutFood,
		callbackParam = param,

		inactive = matchNum <= 0,
	};

	self.itemTipComCell:UpdateTipButtons({buttonData});
	self.itemTipComCell:UpdateNoneItemTipCountChooseBord(math.min(matchNum, 999));
end

function FoodRecipeTip.PutFood(param, count)
	param.matchNum = count
	GameFacade.Instance:sendNotification(FoodEvent.PutMaterials, param);
end

function FoodRecipeTip:DestroySelf()
	GameObject.Destroy(self.gameObject)
end

function FoodRecipeTip:OnExit()
	self.itemTipComCell:Exit();
	
	return true;
end