autoImport("BaseTip");
autoImport('FoodBuffCell')
EatFoodInfoTip = class("EatFoodInfoTip" ,BaseTip)

EatFoodInfoTip.MaxWidth = 300;

function EatFoodInfoTip:ctor(prefabName, stick, side, offset)
	EatFoodInfoTip.super.ctor(self, prefabName, stick.gameObject);
	self.gameObject.transform:SetParent(stick.transform, false);

	self.stick = stick;
	self.side = side;
	self.offset = offset;

	self:InitTip();
end

function EatFoodInfoTip:InitTip()
	self.desc = self:FindComponent("Desc", UILabel);
	self.descTime = self:FindComponent("DescTime", UILabel);

	local upPanel = GameObjectUtil.Instance:FindCompInParents(self.stick.gameObject, UIPanel);
	self.panel = self.gameObject:GetComponent(UIPanel);
	self.panel.depth = upPanel.depth + 10;

	local pos = NGUIUtil.GetAnchorPoint(nil, self.stick, self.side, self.offset);
	self:SetPos(pos)



	self.foodGrid = self:FindComponent("FoodGrid", UIGrid)
	if self.listControllerOfItems == nil then
		self.listControllerOfItems = UIGridListCtrl.new(self.foodGrid, FoodBuffCell, "FoodBuffCell")
	end

	self.closeComp = self:FindGO("Main"):GetComponent(CloseWhenClickOtherPlace);	
	self.closeComp.callBack = function ()
		TipManager.Instance:CloseEatFoodInfoTip()
	end

	self.bakBoxes = {}
	for i=1,6 do
		self.bakBoxes[#self.bakBoxes + 1] = self:FindGO("backBox" .. i)
	end
end

function EatFoodInfoTip:SetData(data, dataTime)
	self.desc.text = data;
	self.descTime.text = dataTime;
	UIUtil.FitLabelHeight(self.desc, EatFoodInfoTip.MaxWidth)
	local foods = FoodProxy.Instance:GetEatFoods()
	-- table.sort(foods, function (x, y)
	-- 	return x.invalidTime > y.invalidTime
	-- end)
	-- local foodMap = {}
	-- for i=1,#foods do
	-- 	local foodCount = foodMap[foods[i].itemid] or 0
	-- 	foodMap[foods[i].itemid] = foodCount + 1
	-- end

	-- local foodIndexMap = {}
	-- for k,v in pairs(foodMap) do
	-- 	foodIndexMap[#foodIndexMap + 1] = {itemid = k, count = v}
	-- end

	self.listControllerOfItems:ResetDatas(foods)

	local level = Game.Myself.data.userdata:Get(UDEnum.TASTER_LV)
	local tasteLvInfo = Table_TasterLevel[level]
	local boxCount = 3
	if tasteLvInfo then
		boxCount = tasteLvInfo.AddBuffs
	end
	for i=1,6 do
		self.bakBoxes[i]:SetActive(boxCount >= i)
	end
end

function EatFoodInfoTip:AddIgnoreBounds(obj)
	if(self.gameObject and self.closeComp)then
		self.closeComp:AddTarget(obj.transform);
	end
end

function EatFoodInfoTip:RemoveUpdateTick()
	if(self.updateCallTick)then
		TimeTickManager.Me():ClearTick(self, 1)
		self.updateCallTick = nil;
	end

	self.updateCall = nil;
	self.updateCallTick = nil;
end

function EatFoodInfoTip:SetUpdateSetText(interval, updateCall, updateCallParam)
	self.updateCall = updateCall;
	self.updateCallParam = updateCallParam;

	if(self.updateCallTick == nil)then
		self.updateCallTick = TimeTickManager.Me():CreateTick(0, interval, self._TickUpdateCall, self, 1)
	end
end

function EatFoodInfoTip:SetCloseCall(closeCall, closeCallParam)
	self.closeCall = closeCall;
	self.closeCallParam = closeCallParam;
end

function EatFoodInfoTip:_TickUpdateCall()
	if(self.updateCall)then
		local needRemove, text = self.updateCall(self.updateCallParam);
		self:SetData(text);
		
		if(needRemove)then
			self:RemoveUpdateTick();
		end
	end
end

function EatFoodInfoTip:OnEnter()
	EatFoodInfoTip.super.OnEnter(self);
end

function EatFoodInfoTip:DestroySelf()
	if(not self:ObjIsNil(self.gameObject))then
		GameObject.Destroy(self.gameObject)
	end
end

function EatFoodInfoTip:OnExit()
	self:RemoveUpdateTick();

	if(self.closeCall)then
		self.closeCall(self.closeCallParam);
	end
	return true
end
