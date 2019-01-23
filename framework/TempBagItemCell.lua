autoImport("BagItemCell");
TempBagItemCell = class("TempBagItemCell", BagItemCell);

function TempBagItemCell:Init()
	TempBagItemCell.super.Init(self);
	self.delWarning = self:FindGO("DelWarning");
end

function TempBagItemCell:SetData(data)
	TempBagItemCell.super.SetData(self, data);

	self:RefreshDelWarning();
end

function TempBagItemCell:RefreshDelWarning()
	if(not self.delWarning)then
		return;
	end

	local data = self.data;
	if(data and data:GetDelWarningState())then
		self.delWarning:SetActive(true);
	else
		self.delWarning:SetActive(false);
	end

	self:ActiveNewTag(false);
end
