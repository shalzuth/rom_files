autoImport("ItemCell")
EquipChooseCell = class("EquipChooseCell",ItemCell)

EquipChooseCellEvent = {
	ClickItemIcon = "EquipChooseCellEvent_ClickItemIcon",
}

function EquipChooseCell:Init()
	EquipChooseCell.super.Init(self);
	self.equipEd = self:FindGO("EquipEd");
	self.chooseSymbol = self:FindGO("ChooseSymbol");

	self.chooseButton = self:FindGO("ChooseButton");
	if(self.chooseButton)then
		self:AddClickEvent(self.chooseButton, function ()
			self:PassEvent(MouseEvent.MouseClick, self);
		end);
	else
		self:AddClickEvent(self.gameObject, function ()
			if(self.isValid)then
				self:PassEvent(MouseEvent.MouseClick, self);
			end
		end);
	end
	

	self.invalidTip = self:FindComponent("InvalidTip", UILabel);

	self.itemIcon = self:FindGO("Item");
	self:AddClickEvent(self.itemIcon, function ()
		self:PassEvent(EquipChooseCellEvent.ClickItemIcon, self);
	end);
end

function EquipChooseCell:SetData(data)
	EquipChooseCell.super.SetData(self, data)
	self:UpdateMyselfInfo();

	if(data)then
		self:Show(self.nameLab);
		if(self.chooseButton)then
			self.chooseButton:SetActive(true);
		end
	 	if(self.equipEd)then
	 		self.equipEd:SetActive(data.equiped == 1);
	 	end

	 	self:SetIconGrey(data.id == "NoGet")
	else
		self.equipEd:SetActive(false);
		if(self.chooseButton)then
			self.chooseButton:SetActive(false);
		end
	 	if(self.nameLab)then
			self:Hide(self.nameLab);
		end
	end
	self:UpdateChoose();
	self:CheckValid();
end

function EquipChooseCell:SetChooseId(chooseId)
	self.chooseId = chooseId;
	self:UpdateChoose();
end

function EquipChooseCell:UpdateChoose()
	if(self.chooseSymbol)then
		if(self.chooseId and self.data and self.data.id == self.chooseId)then
			self.chooseSymbol:SetActive(true);
		else
			self.chooseSymbol:SetActive(false);
		end
	end
end

function EquipChooseCell:SetItemNameText(text)
	self.nameLab.text = text;
end

function EquipChooseCell:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip)
	self.checkFunc = checkFunc;
	self.checkFuncParam = checkFuncParam;
	self.checkTip = checkTip;

	self:CheckValid();
end

function EquipChooseCell:CheckValid()
	if(self.data == nil )then
		return;
	end
	if(self.checkFunc)then
		self.isValid, otherTip = self.checkFunc(self.checkFuncParam, self.data);
		if(self.isValid)then
			if(self.chooseButton)then
				self.chooseButton:SetActive(true);
			end

			if(otherTip)then
				self.invalidTip.gameObject:SetActive(true);
				self.invalidTip.text = tostring(otherTip)
			else
				self.invalidTip.gameObject:SetActive(false);
			end
		else
			if(self.chooseButton)then
				self.chooseButton:SetActive(false);
			end
			self.invalidTip.gameObject:SetActive(true);

			local checkTip = otherTip or self.checkTip;
			self.invalidTip.text = tostring(checkTip)
		end
	else
		if(self.chooseButton)then
			self.chooseButton:SetActive(true);
		end
		self.invalidTip.gameObject:SetActive(false);
	end
end
