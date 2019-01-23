autoImport("BaseCell")
GuildAssetItemCell = class("GuildAssetItemCell", ItemCell)

function GuildAssetItemCell:Init()
	self.itemObj = self:LoadPreferb("cell/ItemCell", self.gameObject);
	self.itemObj.name = "Common_ItemCell";
	self.itemObj.transform.localPosition = Vector3.zero
	GuildAssetItemCell.super.Init(self);	
	self:AddCellClickEvent();
end

function GuildAssetItemCell:SetData(data)
	GuildAssetItemCell.super.SetData(self, data);
end