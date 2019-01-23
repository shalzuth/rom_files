local baseCell = autoImport("BaseCell")
LineChartTipCell = class("LineChartTipCell", baseCell)

function LineChartTipCell:Init()
	self:FindObjs()
end

function LineChartTipCell:FindObjs()
	self.label = self.gameObject:GetComponent(UILabel)
end

function LineChartTipCell:SetData(data)
	self.data = data

	if data then
		self.label.text = data
	end
end