autoImport('FoodBuffCell')
FoodOverridePopView = class("FoodOverridePopView", BaseView);

FoodOverridePopView.ViewType = UIViewType.PopUpLayer

function FoodOverridePopView:Init()
	self:GetComponents();
	self:InitView();
end

function FoodOverridePopView:GetComponents()
	self.eatingTip = self:FindComponent("EatingTip", UILabel)
	self:AddButtonEvent("CancelButton",function (  )
		self:CloseSelf()
	end)
	self:AddButtonEvent("ConfirmButton",function (  )
		if self.foodNpcId then
			ServiceSceneFoodProxy.Instance:CallStartEat(self.foodNpcId, false, self.foodCount);
		elseif self.foodGuid then
			ServiceSceneFoodProxy.Instance:CallPutFood(self.foodGuid, SceneFood_pb.EEATPOWR_SELF, self.foodCount, false);
		end
		self:CloseSelf()
	end)
	self.noticeToggle = self:FindComponent("NoticeToggle", UIToggle)
	EventDelegate.Add(self.noticeToggle.onChange, function ()
		LocalSaveProxy.Instance:SetFoodBuffOverrideNoticeShow(not self.noticeToggle.value)
	end)
	self.foodGrid = self:FindComponent("FoodBuffGrid", UIGrid)
	if self.listControllerOfItems == nil then
		self.listControllerOfItems = UIGridListCtrl.new(self.foodGrid, FoodBuffCell, "FoodBuffCellBig")
	end
end

function FoodOverridePopView:InitView()
	self.foodNpcId = self.viewdata.foodNpcId
	self.foodItemId = self.viewdata.foodItemId
	self.foodCount = self.viewdata.foodCount
	self.foodGuid = self.viewdata.foodGuid
	local eatedfoodList = FoodProxy.Instance:GetEatFoods()
	local level = Game.Myself.data.userdata:Get(UDEnum.TASTER_LV)
	local tasteLvInfo = Table_TasterLevel[level]
	local foodMaxCount = 3
	if tasteLvInfo then
		foodMaxCount = tasteLvInfo.AddBuffs
	end

	local resultItemIdList = {}
	if eatedfoodList then
		local eatedStartIndex = self.foodCount + #eatedfoodList - foodMaxCount + 1
		if #eatedfoodList >= eatedStartIndex then
			for i=eatedStartIndex,#eatedfoodList do
				resultItemIdList[#resultItemIdList + 1] = {itemid = eatedfoodList[i].itemid}
			end
			for i=1, self.foodCount do
				resultItemIdList[#resultItemIdList + 1] = {itemid = self.foodItemId}
			end
		else
			for i=1, foodMaxCount do
				resultItemIdList[#resultItemIdList + 1] = {itemid = self.foodItemId}
			end
		end
	end

	self.listControllerOfItems:ResetDatas(resultItemIdList)
end