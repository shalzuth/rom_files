local BaseCell = autoImport("BaseCell");
QuotaLogCell = class("QuotaLogCell", BaseCell)

function QuotaLogCell:Init()
	self.date = self:FindComponent("Date", UILabel)
	self.desc = self:FindComponent("Desc", UILabel)
	self.count = self:FindComponent("Count", UILabel)
	self.lockTip = self:FindGO("LockTip"):GetComponent(UILabel)
end

function QuotaLogCell:SetData(data)
	self.data = data
	if data then
		self:Show(self.gameObject)
		self.date.text = ClientTimeUtil.FormatTimeTick(data.time, "yyyy-MM-dd")
		self.desc.text = data.logTitle
		self.count.text = StringUtil.NumThousandFormat(data.value)
		self:UpdateLockTip()
	else
		self:Hide(self.gameObject)
	end
end

function QuotaLogCell:UpdateLockTip()
	if self.data.quotaType == QuotaCardProxy.Type.ChargeLock then
		local delayTime = GameConfig.System.charge_delay
		if delayTime ~= nil then
			local leftTime = ServerTime.CurServerTime() / 1000 - self.data.time
			if leftTime <= delayTime then
				self.lockTip.text = string.format(ZhString.QuotaCard_ChargeLockTip, math.ceil((delayTime - leftTime) / 3600))
				return
			end
		end
	end

	self.lockTip.text = ""
end