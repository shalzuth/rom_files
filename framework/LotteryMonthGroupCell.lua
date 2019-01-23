local baseCell = autoImport("BaseCell")
LotteryMonthGroupCell = class("LotteryMonthGroupCell", baseCell)

function LotteryMonthGroupCell:Init()
	self:FindObjs()

	self:AddCellClickEvent()
end

function LotteryMonthGroupCell:FindObjs()
	self.content = self:FindGO("Content"):GetComponent(UILabel)
	self.choose = self:FindGO("Choose")
end

function LotteryMonthGroupCell:SetData(data)
	self.data = data
	if data then
		self.content.text = data:GetName()

		self:SetChoose(false)
	end
end

function LotteryMonthGroupCell:SetChoose(isChoose)
	self.choose:SetActive(isChoose)

	if isChoose then
		self.content.color = ColorUtil.TitleBlue
	else
		ColorUtil.WhiteUIWidget(self.content)
	end
end