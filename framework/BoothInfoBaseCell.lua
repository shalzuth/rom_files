BoothInfoBaseCell = class("BoothInfoBaseCell", ItemTipBaseCell)

function BoothInfoBaseCell:Init()
	BoothInfoBaseCell.super.Init(self)
	self:FindObjs()
	self:AddEvts()
end

function BoothInfoBaseCell:FindObjs()
	self.confirmBtn = self:FindGO("ConfirmButton"):GetComponent(UISprite)
	self.confirmLabel = self:FindGO("Label", self.confirmBtn.gameObject):GetComponent(UILabel)
	self.priceLabel = self:FindGO("Price"):GetComponent(UILabel)
	self.countSubtract = self:FindGO("CountSubtractBg")
	if self.countSubtract ~= nil then
		self.countSubtract = self.countSubtract:GetComponent(UISprite)
	end
	self.countPlus = self:FindGO("CountPlusBg")
	if self.countPlus ~= nil then
		self.countPlus = self.countPlus:GetComponent(UISprite)
	end
	self.countInput = self:FindGO("CountInput")
	if self.countInput ~= nil then
		self.countInput = self.countInput:GetComponent(UIInput)
		UIUtil.LimitInputCharacter(self.countInput, 6)
	end
end

function BoothInfoBaseCell:AddEvts()
	if self.confirmBtn ~= nil then
		self:AddClickEvent(self.confirmBtn.gameObject, function ()
			self:Confirm()
		end)
	end
	local cancelBtn = self:FindGO("CancelButton")
	if cancelBtn ~= nil then
		self:AddClickEvent(cancelBtn, function ()
			self:Cancel()
		end)
	end
	if self.countInput ~= nil then
		EventDelegate.Set(self.countInput.onChange, function ()
			self:InputOnChange()
		end)
	end
	if self.countSubtract ~= nil then
		self:AddPressEvent(self.countSubtract.gameObject, function (g, b)
			self:PressCount(b, -1)
		end)
	end
	if self.countPlus ~= nil then
		self:AddPressEvent(self.countPlus.gameObject, function (g, b)
			self:PressCount(b, 1)
		end)
	end
end

function BoothInfoBaseCell:SetData(data)
	self.data = data
	
	if data then
		self:UpdateAttriContext()
		self:UpdateTopInfo()
	end
end

function BoothInfoBaseCell:Confirm()

end

function BoothInfoBaseCell:Cancel()
	self:PassEvent(BoothEvent.CloseInfo, self)
end

function BoothInfoBaseCell:InputOnChange(count)
	count = count or tonumber(self.countInput.value)
	if count == nil then
		return
	end

	if count <= 1 then
		count = 1
	elseif count >= self.maxCount then
		count = self.maxCount
	end
	local alpha = count <= 1 and 0.5 or 1
	self:SetAlpha(self.countSubtract, alpha)
	alpha = count >= self.maxCount and 0.5 or 1
	self:SetAlpha(self.countPlus, alpha)

	self.count = count

	self:UpdateCount()
	self:UpdatePrice()
end

function BoothInfoBaseCell:PressCount(isPressed, change)
	if isPressed then
		self.countChangeRate = 1
		TimeTickManager.Me():CreateTick(0, 150, function (self, deltatime)
			self:ClickCount(change) end, 
				self, 3)
	else
		TimeTickManager.Me():ClearTick(self, 3)	
	end	
end

function BoothInfoBaseCell:ClickCount(change)
	local count = tonumber(self.countInput.value) + self.countChangeRate * change

	if count < 1 or count > self.maxCount then
		self.countChangeRate = 1
		return
	end

	if self.countChangeRate <= 3 then
		self.countChangeRate = self.countChangeRate + 1
	end

	self:InputOnChange(count)
end

function BoothInfoBaseCell:UpdateCount()
	if self.countInput ~= nil then
		self.countInput.value = self.count
	end
end

function BoothInfoBaseCell:UpdatePrice()
	
end

function BoothInfoBaseCell:SetOrderId(orderId)
	
end

function BoothInfoBaseCell:SetPriceRate()
	
end

function BoothInfoBaseCell:SetPrice(price)
	
end

function BoothInfoBaseCell:SetOriginalQuota(quota)
	
end

function BoothInfoBaseCell:SetStateType(type)
	self.stateType = type
end

function BoothInfoBaseCell:SetInvalidBtn(isInvalid)
	if isInvalid then
		self.confirmBtn.color = ColorUtil.NGUIShaderGray
		self.confirmLabel.effectColor = ColorUtil.NGUIGray
	else
		self.confirmBtn.color = ColorUtil.NGUIWhite
		self.confirmLabel.effectColor = ColorUtil.ButtonLabelOrange
	end

	self.isInvalid = isInvalid
end

function BoothInfoBaseCell:SetAlpha(sprite, alpha)
	if sprite.color.a ~= alpha then
		sprite.alpha = alpha
	end
end