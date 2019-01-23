autoImport("BaseItemCell");
EquipAlchemyMaterialCell = class("EquipAlchemyMaterialCell", BaseItemCell)

EquipAlchemyMaterialEvent = {
	Remove = "EquipAlchemyMaterialEvent_Remove",
	LongPress = "EquipAlchemyMaterialEvent_LongPress",
}

function EquipAlchemyMaterialCell:Init()
	self.itemCell = self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("ItemCell"), self.gameObject);

	EquipAlchemyMaterialCell.super.Init(self);

	self.remove = self:FindGO("Remove");
	self:AddClickEvent(self.remove, function (go)
		self:PassEvent(EquipAlchemyMaterialEvent.Remove, self);
	end);

	self:AddClickEvent(self.gameObject, function (go)
		self:PassEvent(MouseEvent.MouseClick, self);
	end);

	local longPress = self.gameObject:GetComponent(UILongPress)
	longPress.pressEvent = function ( obj,state )
		self:PassEvent(EquipAlchemyMaterialEvent.LongPress, {self, state});
	end
end

function EquipAlchemyMaterialCell:SetData(data)
	if(data)then
		self.gameObject:SetActive(true);

		EquipAlchemyMaterialCell.super.SetData(self, data);

		self.data = data;
	else
		self.gameObject:SetActive(false);
	end

	self:UpdateNum();
end

function EquipAlchemyMaterialCell:SetChoosedInfo(choosedInfo)
	self.choosedInfo = choosedInfo;
	self:UpdateNum();
end

function EquipAlchemyMaterialCell:UpdateNum()
	if(self.data == nil)then
		return;
	end

	local sid = self.data.staticData.id;
	self.leftNum = BagProxy.Instance:GetItemNumByStaticID(sid);

	local choosedNum = self.choosedInfo and self.choosedInfo[sid];
	if(choosedNum)then
		self.remove:SetActive(true);
		self.leftNum = self.leftNum - choosedNum;
	else
		self.remove:SetActive(false);
	end

	if(self.leftNum <= 0)then
		self:SetIconGrey(true);
		self.numLab.gameObject:SetActive(false);
	else
		self:SetIconGrey(false);

		self.numLab.gameObject:SetActive(true);
		self.numLab.text = self.leftNum;
	end
end