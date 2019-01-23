local baseCell = autoImport("BaseCell")
WeddingProcessCell = class("WeddingProcessCell", baseCell)

function WeddingProcessCell:Init()
	self:FindObjs()
end

function WeddingProcessCell:FindObjs()
	self.title = self:FindGO("Title"):GetComponent(UILabel)
	self.content = self:FindGO("Content"):GetComponent(UILabel)
end

function WeddingProcessCell:SetData(data)
	self.data = data

	if data then
		self.title.text = data.title
		self.content.text = data.content
	end
end