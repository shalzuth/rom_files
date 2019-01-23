TutorItemCell = class("TutorItemCell", ItemCell)

function TutorItemCell:Init()

	local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
	obj.transform.localPosition = Vector3.zero

	TutorItemCell.super.Init(self)

	self:AddCellClickEvent()
end

function TutorItemCell:SetData(data)
	if data then
		local itemData = ItemData.new("Tutor", data.id)
		itemData.num = data.num

		TutorItemCell.super.SetData(self, itemData)
	end
end