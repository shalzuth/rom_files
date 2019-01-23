local BaseCell = autoImport("BaseCell");
FoodMaterilaCell = class("FoodMaterilaCell", BaseCell)

FoodMaterilEvent = {
	LongPress = "FoodMateril_LongPress",
}

function FoodMaterilaCell:Init()
	self.icon = self.gameObject:GetComponent(UISprite);
	self.countLabel = self:FindComponent("Count", UILabel);

	self:AddCellClickEvent();

	local removeLongPress = self.gameObject:GetComponent(UILongPress)
	removeLongPress.pressEvent = function ( obj,state )
		self:PassEvent(FoodMaterilEvent.LongPress, {state, self});
	end
end

function FoodMaterilaCell:SetData(data)
	self.data = data;
	local sData = Table_Item[data.itemId];
	if(sData)then
		if(not IconManager:SetItemIcon(sData.Icon,self.icon))then
			IconManager:SetItemIcon("item_45001",self.icon);
		end
		
		self.icon:MakePixelPerfect();
	end
	self.countLabel.text = data.num
end