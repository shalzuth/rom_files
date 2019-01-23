PetCatchSuccessView = class("PetCatchSuccessView", BaseView);

PetCatchSuccessView.ViewType = UIViewType.Show3D2DLayer

autoImport("ItemCell");

function PetCatchSuccessView:Init()
	self.effect = self:FindGO("EffectContainer");

	self.bgClick = self:FindGO("BgClick");
	self:AddClickEvent(self.bgClick, function (go)
		self:CloseSelf();
	end);

	local itemCellGO = self:FindGO("ItemCell");
	self.itemCell = ItemCell.new(itemCellGO);

	self.itemName = self:FindComponent("ItemName", UILabel);
end

function PetCatchSuccessView:UpdateInfo()
	self.itemCell:SetData(self.item);
	if(self.itemName)then
		self.itemName.text = self.item:GetName();
	end
end

function PetCatchSuccessView:OnEnter()
	PetCatchSuccessView.super.OnEnter(self);

	self.item = self.viewdata.viewdata;

	self:UpdateInfo();
	self.effect:SetActive(true);
end

function PetCatchSuccessView:OnExit()
	PetCatchSuccessView.super.OnExit(self);
	self.effect:SetActive(false);
end
