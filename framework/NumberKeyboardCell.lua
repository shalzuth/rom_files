local baseCell = autoImport("BaseCell")
NumberKeyboardCell = class("NumberKeyboardCell", baseCell)

function NumberKeyboardCell:ctor(obj,number)
	NumberKeyboardCell.super.ctor(self,obj);
	self:setNumber(number)
end

function NumberKeyboardCell:Init()
	NumberKeyboardCell.super.Init(self);
	self:FindObjs()
	--self:AddCellClickEvent();
end

function NumberKeyboardCell:FindObjs()

end

function NumberKeyboardCell:SetData(data)
	self.data = data;
end

function NumberKeyboardCell:setNumber(integer)
	self.number=integer
end