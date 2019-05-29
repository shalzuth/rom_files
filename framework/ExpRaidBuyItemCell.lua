autoImport("HappyShopBuyItemCell")
ExpRaidBuyItemCell = class("ExpRaidBuyItemCell", HappyShopBuyItemCell)
local hideType = {hideClickSound = true, hideClickEffect = false}
function ExpRaidBuyItemCell:AddConfirmClickEvent()
  self:AddClickEvent(self.confirmButton.gameObject, function()
    if self.confirmSprite.CurrentState == 1 then
      return
    end
    MsgManager.ConfirmMsgByID(4047, function()
      self:Confirm()
    end, nil, nil, self.itemData.staticData.NameZh)
  end, hideType)
end
function ExpRaidBuyItemCell:SetData(data)
  if data then
    self.data = data
    self.moneycount = ExpRaidProxy.Instance:GetPriceOfItem(data.staticData.id)
    self.maxcount = nil
    self:UpdateOwnInfo()
    if ExpRaidProxy.Instance:GetRemainingCountOfShopItem(data.staticData.id) <= 0 then
      self.confirmSprite.CurrentState = 1
      self.confirmLabel.text = ZhString.HappyShop_SoldOut
      self.confirmLabel.effectStyle = UILabel.Effect.None
    else
      self.confirmSprite.CurrentState = 0
      self.confirmLabel.text = ZhString.HappyShop_Buy
      self.confirmLabel.effectStyle = UILabel.Effect.Outline
    end
    self:SetLimitCountText()
    IconManager:SetUIIcon("exp_integral", self.priceIcon)
    IconManager:SetUIIcon("exp_integral", self.totalPriceIcon)
    self.todayCanBuy.gameObject:SetActive(false)
    self.salePrice:SetActive(false)
    self.multiplePriceRoot:SetActive(false)
  end
  ExpRaidBuyItemCell.super.super.SetData(self, data)
end
function ExpRaidBuyItemCell:UpdateOwnInfo()
  if self.data then
    local own = HappyShopProxy.Instance:GetItemNumByStaticID(self.data.id)
    if own then
      self.ownInfo.text = string.format(ZhString.HappyShop_OwnInfo, own)
    else
      self.ownInfo.text = ""
    end
  end
end
function ExpRaidBuyItemCell:Confirm()
  local count = tonumber(self.countInput.value)
  if count == nil then
    self.countInput.value = self.count
    count = self.count
  end
  if self.itemData then
    if count * self.moneycount > ExpRaidProxy.Instance:GetAllExpRaidScore() then
      MsgManager.ShowMsgByID(9620, ZhString.ExpRaid_ExpRaidScore)
    else
      ExpRaidProxy.Instance:CallBuyItem(self.itemData.staticData.id, count)
    end
    self:PlayUISound(AudioMap.UI.Click)
  else
    LogUtility.Error("itemData of ExpRaidBuyItemCell is nil")
  end
  ExpRaidBuyItemCell.super.super.Confirm(self)
end
function ExpRaidBuyItemCell:UpdateTotalPrice(count)
  self.count = count
  self.totalPrice.text = StringUtil.NumThousandFormat(self:CalcTotalPrice(count))
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
end
function ExpRaidBuyItemCell:UpdatePrice(count)
  ExpRaidBuyItemCell.super.super.UpdatePrice(self, count)
end
function ExpRaidBuyItemCell:UpdateCount(change)
  ExpRaidBuyItemCell.super.super.UpdateCount(self, change)
end
function ExpRaidBuyItemCell:SetLimitCountText(text)
  if text and text ~= "" then
    self.limitCount.gameObject:SetActive(true)
    self.limitCount.text = text
  else
    self.limitCount.gameObject:SetActive(false)
  end
end
