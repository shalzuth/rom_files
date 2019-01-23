FoodMakeLvUpPopUp = class("FoodMakeLvUpPopUp", BaseView);

FoodMakeLvUpPopUp.ViewType = UIViewType.PopUpLayer

autoImport("BaseItemCell");
autoImport("HeadIconCell");

function FoodMakeLvUpPopUp:Init()
	self:InitView();

	self:MapEvent();
end

function FoodMakeLvUpPopUp:InitView()
	self.titleText = self:FindComponent("TitleText", UILabel);
	self.confirmButton = self:FindGO("ConfirmButton");
	self.desc1 = self:FindComponent("Desc1", UILabel);
	self.desc2 = self:FindComponent("Desc2", UILabel);

	self.recipeGrid = self:FindComponent("RecipeGrid", UIGrid);
	self.recipeCtl = UIGridListCtrl.new(self.recipeGrid , BaseItemCell, "FoodWhiteItemCell");
	self.recipeCtl:AddEventListener(MouseEvent.MouseClick, self.ClickRecipe, self);

	self.headIconCell = HeadIconCell.new(self.headHolder);

	local headHolder = self:FindGO("HeadHolder");
	self.headIconCell = HeadIconCell.new();
	self.headIconCell:CreateSelf(headHolder);
	self.headIconCell:SetMinDepth(3);
	self.headIconCell:HideFrame();
	
	self.normalStick = self:FindComponent("NormalStick", UIWidget);
end

function FoodMakeLvUpPopUp:ClickRecipe(cell)
	local sdata = {
		itemdata = cell.data, 
		funcConfig = {},
		ignoreBounds = cell.gameObject,
		callback = callback,
	};
	self:ShowItemTip(sdata, self.normalStick, nil, {-160,-100});
end

function FoodMakeLvUpPopUp:UpdateInfo()
	local userdata = Game.Myself.data.userdata;
	local iconData = {};
	iconData.type = HeadImageIconType.Avatar;
	iconData.id = Game.Myself.data.id;
	iconData.hairID = userdata:Get(UDEnum.HAIR);
	iconData.haircolor = userdata:Get(UDEnum.HAIRCOLOR);
	iconData.gender = userdata:Get(UDEnum.SEX);
	local classid = userdata:Get(UDEnum.PROFESSION);
	local classData = Table_Class[classid];
	iconData.bodyID = iconData.gender == 1 and classData.MaleBody or classData.FemaleBody;
	iconData.headID = 400146;
	iconData.eyeID = userdata:Get(UDEnum.EYE);
	self.headIconCell:SetData(iconData);

	local cooklvData = Table_CookerLevel[ self.cooklv ];
	local titleName = Table_Appellation[ cooklvData.Title ].Name;
	self.titleText.text = titleName;
	self.desc1.text = string.format(ZhString.FoodMakeLvUpPopUp_TitleTip, titleName);

	local addBagSlot = cooklvData.RewardBagSlot;
	local preCookData = Table_CookerLevel[ self.cooklv - 1 ];
	if(preCookData)then
		addBagSlot = addBagSlot - preCookData.RewardBagSlot;
	end
	local itemName = Table_Item[cooklvData.Book].NameZh;
	self.desc2.text = string.format(ZhString.FoodMakeLvUpPopUp_TitleTip2, addBagSlot, itemName, cooklvData.SuccessRate .. "%")

	local recipeDatas = {}; 
	local recipes = cooklvData.Recipe;
	if(recipes)then
		for i=1,#recipes do
			local recipeData = Table_Recipe[recipes[i]];
		 	local itemData = ItemData.new("Recipe", recipeData.Product);
		 	table.insert(recipeDatas, itemData);
		end
	end
	self.recipeCtl:ResetDatas(recipeDatas);
end

function FoodMakeLvUpPopUp:MapEvent()
end

function FoodMakeLvUpPopUp:OnEnter()
	FoodMakeLvUpPopUp.super.OnEnter(self);

	self.cooklv = self.viewdata.cooklv;
	self:UpdateInfo();
end

function FoodMakeLvUpPopUp:OnExit()
	FoodMakeLvUpPopUp.super.OnExit(self);
end