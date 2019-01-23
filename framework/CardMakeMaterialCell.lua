CardMakeMaterialCell = class("CardMakeMaterialCell", ItemCell)

local TextColorRed = "[c][FF3B35]"

function CardMakeMaterialCell:Init()

	local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
	obj.transform.localPosition = Vector3.zero

	CardMakeMaterialCell.super.Init(self)

	self:FindObjs()
	self:AddEvts()
end

function CardMakeMaterialCell:FindObjs()
	self.choose = self:FindGO("Choose")
end

function CardMakeMaterialCell:AddEvts()
	self:AddCellClickEvent()
end

function CardMakeMaterialCell:SetData(data)
	if data then
		CardMakeMaterialCell.super.SetData(self, data.itemData)

		local num = data.itemData.num
		if num > 1 then
			local bagNum = CardMakeProxy.Instance:GetItemNumByStaticID(data.id)
			local colorStr = bagNum >= num and "" or TextColorRed
			self.numLab.text = colorStr..bagNum.."[-][/c]/"..num
		end

		self:SetIconGrey(not CardMakeProxy.Instance:CheckCanMake(data))
	end

	self.data = data
end