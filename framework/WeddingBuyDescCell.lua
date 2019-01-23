local baseCell = autoImport("BaseCell")
WeddingBuyDescCell = class("WeddingBuyDescCell", baseCell)

function WeddingBuyDescCell:Init()
	self:FindObjs()
end

function WeddingBuyDescCell:FindObjs()
	self.content = self.gameObject:GetComponent(UILabel)
end

function WeddingBuyDescCell:SetData(data)
	self.data = data

	if data then
		self.content.text = data
	end
end