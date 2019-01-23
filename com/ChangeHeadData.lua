ChangeHeadData = class("ChangeHeadData")

function ChangeHeadData:ctor(data)
	self:SetData(data)
end

function ChangeHeadData:SetData(data)
	self.id = data
	self.isChoose = false
end

function ChangeHeadData:SetChoose(isChoose)
	self.isChoose = isChoose
end