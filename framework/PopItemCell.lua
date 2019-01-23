autoImport("BaseItemCell");
PopItemCell = class("PopItemCell",BaseItemCell )

function PopItemCell:Init()
	PopItemCell.super.Init(self);
	self.cdCtrl = FunctionCDCommand.Me():GetCDProxy(BagCDRefresher)
	self:AddCellClickEvent();
end

function PopItemCell:SetData(data)
	self:Show()
	PopItemCell.super.SetData(self, data);
	if(not data)then
		self:Hide()
	end
end
