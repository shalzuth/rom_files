MakeMaterialCell = class("MakeMaterialCell", ItemCell)

local redString = "[c][FF622CFF]%s[-][/c]"
function MakeMaterialCell:Init()

	local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
	obj.transform.localPosition = Vector3.zero

	MakeMaterialCell.super.Init(self)

	self:FindObjs()

	self:AddCellClickEvent()
end

function MakeMaterialCell:FindObjs()
	self.count = self:FindGO("Count"):GetComponent(UILabel)
end

function MakeMaterialCell:SetData(data)

	if data then
		self.itemData = ItemData.new(nil,data.id)
		MakeMaterialCell.super.SetData(self,self.itemData)

		local count = EquipMakeProxy.Instance:GetItemNumByStaticID(data.id)
		local str = string.format("%s/%s",tostring(count),tostring(data.num))

		self.isEnough = false
		if count >= data.num then
			self.isEnough = true
			-- ColorUtil.BlackLabel(self.count)
			self.count.text = str
		else
			-- self.count.color = ColorUtil.Red
			self.count.text = string.format(redString, str)
		end
	end

	self.data = data
end

function MakeMaterialCell:IsEnough()
	return self.isEnough
end

function MakeMaterialCell:NeedCount()
	if self.isEnough then
		return 0
	else
		return self.data.num - EquipMakeProxy.Instance:GetItemNumByStaticID(self.data.id)
	end
end