local BaseCell = autoImport("BaseCell");
CardCombineCell = class("CardCombineCell", BaseCell)

autoImport("CardCell");
CardCombineCell.CellRid = ResourcePathHelper.UICell("CardCell");

function CardCombineCell:Init()
	if(not self.childCell)then
		self.childCell = {};
		for i=1,6 do
			local tempC = Game.AssetManager_UI:CreateAsset(CardCombineCell.CellRid, self.gameObject);
			self.childCell[i] = CardCell.new(tempC);
			self.childCell[i]:AddEventListener(MouseEvent.MouseClick, self.ClickCard, self);
			self.childCell[i]:AddEventListener(MouseEvent.MousePress, self.PressCard, self);
		end
	end
end

function CardCombineCell:ClickCard(cellctl)
	self:PassEvent(MouseEvent.MouseClick , cellctl);
end

function CardCombineCell:PressCard(press)
	self:PassEvent(MouseEvent.MousePress , press);
end

function CardCombineCell:SetData(data)
	self.data = data
	if(data and type(data) == "table")then
		for i=1,#self.childCell do
			self.childCell[i]:SetData(data[i]);
		end
	end
end

function CardCombineCell:ShowAttri()
	for i=1,#self.childCell do
		self.childCell[i]:ShowAttri();
	end
end

function CardCombineCell:HideAttri()
	for i=1,#self.childCell do
		self.childCell[i]:HideAttri();
	end
end