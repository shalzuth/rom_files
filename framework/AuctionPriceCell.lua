local baseCell = autoImport("BaseCell")
AuctionPriceCell = class("AuctionPriceCell", baseCell)

function AuctionPriceCell:Init()
	self:FindObjs()
	self:AddEvts()
end

function AuctionPriceCell:FindObjs()
	self.bg = self:FindGO("Bg"):GetComponent(UISprite)
	self.price = self:FindGO("Price"):GetComponent(UILabel)
	self.collider = self.gameObject:GetComponent(BoxCollider)
	self.bgTween = self.bg.gameObject:GetComponent(TweenHeight)
	self.priceTween = self.price.gameObject:GetComponent(TweenPosition)
	self.effect = self:FindGO("AuctionPrice")
	self.icon = self:FindGO("Icon"):GetComponent(UISprite)
end

function AuctionPriceCell:AddEvts()
	self:AddCellClickEvent()

	self.bgTween:SetOnFinished(function ()
		self.collider.enabled = true
		if self.bgTween.value == self.bgTween.to then
			if self.finishCallback then
				self.finishCallback()
			end
		end
	end)	
end

function AuctionPriceCell:SetData(data)
	self.data = data

	if data then
		self.price.text = ZhString.Auction_Price..StringUtil.NumThousandFormat(data.price)
		local disable = data.disable or data.mask
		if disable then
			local _GrayUIWidget = ColorUtil.GrayUIWidget
			_GrayUIWidget(self.bg)
			_GrayUIWidget(self.price)
			_GrayUIWidget(self.icon)
			self.price.effectStyle = UILabel.Effect.None
		else
			local _WhiteUIWidget = ColorUtil.WhiteUIWidget
			_WhiteUIWidget(self.bg)
			_WhiteUIWidget(self.price)
			_WhiteUIWidget(self.icon)
			self.price.effectStyle = UILabel.Effect.Outline
		end
		self.effect:SetActive(not disable)
	end
end

function AuctionPriceCell:Reset()
	self.collider.enabled = true

	self.bgTween.value = self.bgTween.from
	self.priceTween.value = self.priceTween.from

	self.effect:SetActive(not self.data.disable)
end

function AuctionPriceCell:PlayForward(finishCallback)
	self.bgTween:ResetToBeginning()
	self.priceTween:ResetToBeginning()

	self.bgTween:PlayForward()
	self.priceTween:PlayForward()

	self.collider.enabled = false

	self.finishCallback = finishCallback

	self.effect:SetActive(false)
end