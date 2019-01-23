autoImport("ItemCell")
GuildTreasureItemCell = class("GuildTreasureItemCell", ItemCell)

function GuildTreasureItemCell:Init()
	self:FindObjs()
	local itemRoot = self:FindGO("itemPos")
	local obj = self:LoadPreferb("cell/ItemCell", itemRoot)
	obj.transform.localPosition = Vector3.zero
	GuildTreasureItemCell.super.Init(self)
	self.itemPos = self:FindGO("itemPos")
	self:SetEvent(self.itemPos, function ()
		self:PassEvent(MouseEvent.MouseClick, self);
	end);
end

function GuildTreasureItemCell:FindObjs()
	self.name = self:FindGO("name"):GetComponent(UILabel)
	self.typeLab = self:FindComponent("type",UILabel)
end

function GuildTreasureItemCell:SetData(data)
	if(data)then
		GuildTreasureItemCell.super.SetData(self, data)
		self.data = data
		self.typeLab.text=data:GetTypeName()
		if(data.num>0)then
			self:Show(self.numLab)
			self.numLab.text=data.num
		else
			self:Hide(self.numLab)
		end
		self.name.text = data:GetName()
	else
		self.gameObject:SetActive(false)
	end
end

