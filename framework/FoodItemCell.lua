autoImport("ItemCell");

FoodItemCell = class("FoodItemCell", ItemCell)

FoodItemEvent = {
	LongPress = "FoodItemEvent_LongPress",
	RemoveLongPress = "FoodItemEvent_RemoveLongPress",
	Remove = "FoodItemEvent_Remove",
}

function FoodItemCell:Init()
	FoodItemCell.super.Init(self);

	self:AddCellClickEvent();

	self:AddClickEvent(self.gameObject, function (go)
		if(self.leftNum and self.leftNum > 0)then
			self:PassEvent(MouseEvent.MouseClick, self);
		end
	end);

	self.remove = self:FindGO("Remove");
	self:AddClickEvent(self.remove, function (go)
		self:PassEvent(FoodItemEvent.Remove, self);
	end);
	local removeLongPress = self.remove:GetComponent(UILongPress)
	removeLongPress.pressEvent = function ( obj,state )
		self:PassEvent(FoodItemEvent.RemoveLongPress, {state, self});
	end


	local longPress = self.gameObject:GetComponent(UILongPress)
	longPress.pressEvent = function ( obj,state )
		self:PassEvent(FoodItemEvent.LongPress, {state, self});
	end
end

function FoodItemCell:SetData(data)
	FoodItemCell.super.SetData(self, data);

	self:UpdateRemoveState();
end

function FoodItemCell:UpdateRemoveState(selectIds)
	if(selectIds~=nil and self.selectIds~= selectIds)then
		self.selectIds = selectIds;
	end

	local selectNum = 0;
	if(self.data ~= nil)then
		for i=1,#self.selectIds do
			if(self.data.id == self.selectIds[i].guid)then
				selectNum = selectNum + self.selectIds[i].num;
			end
		end

		self.remove:SetActive(selectNum > 0);

		self.leftNum = self.data.num - selectNum;
		self.numLab.text = self.leftNum;

		if(self.leftNum > 0)then
			self.icon.alpha = 1;
		else
			self.icon.alpha = 0.5;
		end
	else
		self.leftNum = 0;
		self.remove:SetActive(false);
	end
end