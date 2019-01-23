autoImport("ItemCell");
ColliderItemCell = class("ColliderItemCell", ItemCell)

function ColliderItemCell:Init()
	if(self.itemGO == nil)then
		self.itemGO = self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("ItemCell"), self.gameObject);
	end

	self:AddCellClickEvent();

	ColliderItemCell.super.Init(self);
end

function ColliderItemCell:SetMinDepth(minDepth)
	local sps =  GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, UIWidget)
	for i=1,sps do
		sps[i].depth = minDepth + sps[i].depth;
	end
end

function ColliderItemCell:AddCdCtl()
	self.cdCtrl = FunctionCDCommand.Me():GetCDProxy(BagCDRefresher)
end

function ColliderItemCell:SetData(data)
	ColliderItemCell.super.SetData(self, data);
end