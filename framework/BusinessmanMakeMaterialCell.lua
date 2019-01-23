BusinessmanMakeMaterialCell = class("BusinessmanMakeMaterialCell", ItemCell)

local redString = "[c][FF622CFF]%s[-][/c]"
function BusinessmanMakeMaterialCell:Init()

	local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
	obj.transform.localPosition = Vector3.zero

	BusinessmanMakeMaterialCell.super.Init(self)

	self:FindObjs()

	self:AddCellClickEvent()
end

function BusinessmanMakeMaterialCell:FindObjs()
	self.count = self:FindGO("Count"):GetComponent(UILabel)
end

function BusinessmanMakeMaterialCell:SetData(data)
	if data then
		self.itemData = ItemData.new(nil,data.id)
		BusinessmanMakeMaterialCell.super.SetData(self, self.itemData)

		self:SetNum(data, 1)
	end

	self.data = data
end

function BusinessmanMakeMaterialCell:IsEnough()
	return self.isEnough
end

function BusinessmanMakeMaterialCell:SetNum(data, times)
	data = data or self.data
	times = times or 0

	local count = BagProxy.Instance:GetItemNumByStaticID(data.id)
	local needCount = data.num * times
	local str = string.format("%s/%s", count, needCount)

	self.isEnough = false
	if count >= needCount then
		self.isEnough = true
		self.count.text = str
	else
		self.count.text = string.format(redString, str)
	end
end