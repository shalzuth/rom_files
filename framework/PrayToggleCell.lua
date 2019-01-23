local BaseCell = autoImport("BaseCell");
PrayToggleCell = class("PrayToggleCell", BaseCell);

function PrayToggleCell:Init()
	PrayToggleCell.super.Init(self)
	self:FindObjs()
	self:AddCellClickEvent()
end

function PrayToggleCell:FindObjs()
	self.chooseImg = self:FindComponent("choosenImg",UISprite);
	self.typeLab = self:FindComponent("typeLab",UILabel);
	self.icon = self:FindComponent("icon",UISprite);
end

function PrayToggleCell:ShowChooseImg(t)
	self.chooseImg.enabled=(t==self.data.type);
	self.typeLab.effectStyle =(t==self.data.type) and  UILabel.Effect.Outline or UILabel.Effect.None;
end

function PrayToggleCell:SetData(data)
	self.data=data
	if(data and 3==#data)then
		self.typeLab.text=data[1];
		self.name=data[1];
		local itemId = data[3]
		IconManager:SetItemIcon(Table_Item[itemId].Icon,self.icon)
		-- self.icon:MakePixelPerfect();
	end
end