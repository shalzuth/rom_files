local baseCell = autoImport("BaseCell")
ExchangeBuyNormalInfoCell = class("ExchangeBuyNormalInfoCell", baseCell)

function ExchangeBuyNormalInfoCell:Init()
	self:FindObjs()
	self:InitShow()
end

function ExchangeBuyNormalInfoCell:FindObjs()
	self.info = self:FindGO("Info"):GetComponent(UILabel)
	self.time = self:FindGO("Time"):GetComponent(UILabel)
end

function ExchangeBuyNormalInfoCell:InitShow()

end

function ExchangeBuyNormalInfoCell:SetData(data)
	self.data = data
	if data then
		self.info.text = string.format(ZhString.ShopMall_ExchangeBuyInfo , data.name)
		self.time.text = ClientTimeUtil.GetFormatOfflineTimeStr(data.time)
	end
end