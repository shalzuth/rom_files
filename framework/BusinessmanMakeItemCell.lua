autoImport("BaseItemCell")
BusinessmanMakeItemCell = class("BusinessmanMakeItemCell", BaseItemCell)

function BusinessmanMakeItemCell:Init()
	BusinessmanMakeItemCell.super.Init(self)

	self:FindObjs()

	self:AddCellClickEvent()
end

function BusinessmanMakeItemCell:FindObjs()
	self.desc = self:FindGO("Desc"):GetComponent(UILabel)
	self.produceRate = self:FindGO("ProduceRate")
	if self.produceRate then
		self.produceRate = self.produceRate:GetComponent(UILabel)
	end
end

function BusinessmanMakeItemCell:SetData(data)
	if data then
		BusinessmanMakeItemCell.super.SetData(self, data)

		local staticData = data.staticData
		if staticData then
			self.desc.text = staticData.Desc
			UIUtil.WrapLabel(self.desc)
		end
	end
end

function BusinessmanMakeItemCell:SetProduceRate(data)
	if self.produceRate then
		local rate = 100
		if data then
			if data.DynamicRate == 1 then
				rate = CommonFun.calcProduceRate(Game.Myself.data, data.Type, data.Category, data.id) / 100
			end
			self.produceRate.text = string.format(ZhString.Businessman_ProduceRate, rate)
		end
		self.produceRate.gameObject:SetActive(data ~= nil)
	end
end

function BusinessmanMakeItemCell:SetProductNum(data, times)
	times = times or 0

	local canMakeNum = data:GetProductNum() * times
	if canMakeNum > 1 then
		self.numLab.gameObject:SetActive(true)
		self.numLab.text = canMakeNum
	else
		self.numLab.gameObject:SetActive(false)
	end
end