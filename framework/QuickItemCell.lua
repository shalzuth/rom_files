autoImport("BaseItemCell")
QuickItemCell = class("QuickItemCell", BaseItemCell)

function QuickItemCell:Init()
	QuickItemCell.super.Init(self);
	
	self.tipEffect = self:FindGO("TipEffect");
	self:SetDefaultBgSprite(RO.AtlasMap.GetAtlas("NewCom"), "com_icon_bottom2");
end

function QuickItemCell:SetData(data)
	self.data = data;
	if(data and data.staticData)then
		self.gameObject:SetActive(true);
		QuickItemCell.super.SetData(self, data);
		if(data.id == "Shadow")then
			self:SetIconDark(true);
			self:ActiveTip(false);
		else
			self:SetIconDark(false);
		end
	else
		self.gameObject:SetActive(false);
		self:ActiveTip(false);
	end
end

function QuickItemCell:ActiveTip(b)
	if(self.tipEffect.activeSelf~=b)then
		self.tipEffect:SetActive(b);
	end
end