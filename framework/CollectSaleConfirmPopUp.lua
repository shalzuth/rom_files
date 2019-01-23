CollectSaleConfirmPopUp = class("CollectSaleConfirmPopUp", BaseView);

CollectSaleConfirmPopUp.ViewType = UIViewType.PopUpLayer

local tempV3 = LuaVector3();
function CollectSaleConfirmPopUp:Init()
	self.content = self:FindComponent("Content", UILabel);
	self.confirmButton = self:FindGO("ConfirmButton");
	self.zenyCost = self:FindComponent("ZenyCostLabel", UILabel);
	self.noSaleTip = self:FindGO("NoSaleTip");
	self.sellDiscount = self:FindGO("SellDiscount");
	self.sellDiscountDesc = self:FindComponent("DiscountDesc", UILabel, self.sellDiscount);

	self:AddClickEvent(self.confirmButton, function (go)
		self:DoConfirm();
	end);
end

local server_items = {};
function CollectSaleConfirmPopUp:DoConfirm()
	if(#self.mt == 0)then
		MsgManager.ShowMsgByIDTable(25428);
		return;
	end

	for i=1,#self.mt do
		local item = self.mt[i];

		local sitem = SceneItem_pb.SItem()
		sitem.guid, sitem.count = item.id, item.num or 0;
		table.insert(server_items, sitem);
	end
	ServiceItemProxy.Instance:CallQuickSellItemCmd(server_items) 

	TableUtility.ArrayClear(server_items)

	self:CloseSelf();
end

function CollectSaleConfirmPopUp:UpdateInfo()
	self.mt = ReusableTable.CreateArray();
	BagProxy.Instance:CollectQuickSaleItems(self.mt);

	local length = #self.mt;
	if(length > 0)then

		local zenyCost = 0;
		local noDiscountCost = 0;
		local addZenyCost = 0;

		local itemMap = self.itemMap;
		if(itemMap == nil)then
			itemMap = {};
			self.itemMap = {};
		end
		local disCount = Game.Myself.data.props.SellDiscount;
		if(disCount)then
			disCount = disCount:GetValue();
		else
			disCount = 0;
		end
		local shopProxy = ShopSaleProxy.Instance;
		for i=1,length do
			local item = self.mt[i];

			local sname = item.staticData.NameZh;
			if itemMap[sname] == nil then
				itemMap[sname] = 1; 
			else
				itemMap[sname] = 1 + itemMap[sname]; 
			end

			local price = shopProxy:GetPrice(item) or 0;
			local purePrice = shopProxy:GetPurePrice(item) or 0;

			zenyCost = zenyCost + purePrice;
			noDiscountCost = noDiscountCost + (price - purePrice);
		end

		if(disCount ~= 0)then
			addZenyCost = math.floor(disCount*zenyCost/1000);
		end

		local namesList = self.namesList;
		if(namesList == nil)then
			namesList = {};
			self.namesList = namesList;
		end

		for sname,count in pairs(itemMap)do
			table.insert(namesList, sname .. "x" .. count);
		end
		TableUtility.TableClear(itemMap);

		table.sort(namesList, function (a, b)
			return a < b;
		end)

		local name = "";
		for i=1, #namesList do
			if(i%3 == 0)then
				name = name .. namesList[i] .. "\n";
			else
				name = name .. namesList[i] .. "      ";
			end
		end
		TableUtility.ArrayClear(namesList);

		self.content.text = string.format(ZhString.CollectSaleConfirmPopUp_SaleTip, name);
		self.zenyCost.text = zenyCost + noDiscountCost + addZenyCost;

		if(addZenyCost > 0)then
			self.sellDiscount:SetActive(true);
			self.sellDiscountDesc.text = string.format(ZhString.CollectSaleConfirmPopUp_SellDiscountDesc, math.floor(disCount/10), addZenyCost);

			tempV3:Set(-3, -170);
			self.confirmButton.transform.localPosition = tempV3;
		else
			self.sellDiscount:SetActive(false);

			tempV3:Set(-3, -160);
			self.confirmButton.transform.localPosition = tempV3;
		end

		self.noSaleTip.gameObject:SetActive(false);
	else
		self.content.text = "";
		self.zenyCost.text = 0;

		self.noSaleTip.gameObject:SetActive(true);
	end
end

function CollectSaleConfirmPopUp:OnEnter()
	CollectSaleConfirmPopUp.super.OnEnter(self);
	
	self:UpdateInfo();
end


function CollectSaleConfirmPopUp:OnExit()
	CollectSaleConfirmPopUp.super.OnExit(self);

	if(self.mt ~= nil)then
		ReusableTable.DestroyAndClearArray(self.mt);
		self.mt = nil;
	end
end