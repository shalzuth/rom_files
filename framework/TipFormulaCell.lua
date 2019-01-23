local BaseCell = autoImport("BaseCell");
TipFormulaCell = class("TipFormulaCell", BaseCell);

function TipFormulaCell:Init()
	self.TipLabel = self:FindComponent("TipLabel", UILabel);
	self.Line = self:FindGO("Line");
	self.table = self.gameObject:GetComponent(UITable);
	self.lineTitle = self:FindComponent("lineTitle", UILabel);
end

function TipFormulaCell:SetData(data)
	self.data = data;
	if(data)then
		self:Show(self.Line);
		self.TipLabel.text=data.mtText;
		self.lineTitle.text=data.title;
		self.table:Reposition();
		self.table.repositionNow = true;
	end
end
