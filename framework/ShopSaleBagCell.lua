autoImport("BaseItemCell");

ShopSaleBagCell = class("ShopSaleBagCell", BaseItemCell);

function ShopSaleBagCell:Init()

	local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
    obj.transform.localPosition = Vector3.zero

	ShopSaleBagCell.super.Init(self);
	self.cantSale=self:FindGO("cantSale");
end

function ShopSaleBagCell:SetData(data)
	ShopSaleBagCell.super.SetData(self, data);
	if(data)then
		self.cantSale:SetActive(not ShopSaleProxy.Instance:IsThisItemCanSale(data.id))
	else
		self.cantSale:SetActive(false)
	end
end