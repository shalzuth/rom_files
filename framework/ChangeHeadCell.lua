autoImport("HeadIconCell")

local baseCell = autoImport("BaseCell")
ChangeHeadCell = class("ChangeHeadCell",baseCell)

function ChangeHeadCell:Init()
	self:InitCell()
	self:AddEvts()
end

function ChangeHeadCell:InitCell()
	self.headIcon = self:FindGO("HeadIcon"):GetComponent(UISprite)
	self.choose = self:FindGO("Choose")
end

function ChangeHeadCell:AddEvts()
	self:SetEvent(self.gameObject, function ()
		self:PassEvent(ChangeHeadEvent.Select, self)
	end)
end

function ChangeHeadCell:SetData(data)
	self.data = data

	if data then
		local staticData = Table_HeadImage[data.id]
		if staticData and staticData.Picture then
			IconManager:SetFaceIcon(staticData.Picture, self.headIcon)

			self.choose:SetActive(data.isChoose)
		else
			self.gameObject:SetActive(false)
		end
	end
end

function ChangeHeadCell:SetChoose(isChoose)
	self.choose:SetActive(isChoose)
end