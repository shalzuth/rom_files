autoImport("WeddingBuyDescCell")
local baseCell = autoImport("BaseCell")
WeddingBuyCell = class("WeddingBuyCell", baseCell)
local _weddingActivity = GameConfig.Activity.WeddingService
function WeddingBuyCell:Init()
  self:FindObjs()
  self:InitCell()
end
function WeddingBuyCell:FindObjs()
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.buyBtn = self:FindGO("BuyBtn"):GetComponent(UIMultiSprite)
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.price = self:FindGO("Price"):GetComponent(UILabel)
  self.purchased = self:FindGO("Purchased")
  self.table = self:FindGO("Table"):GetComponent(UITable)
  self.background = self:FindGO("Background"):GetComponent(UITexture)
  self.discountTip = self:FindGO("DiscountTip")
  self.discountTip_Sp = self.discountTip:GetComponent(UISprite)
  self.discountTip_Label = self:FindComponent("Label", UILabel, self.discountTip)
  self.primeCost = self:FindGO("primeCost"):GetComponent(UILabel)
end
function WeddingBuyCell:InitCell()
  self.ctrl = UIGridListCtrl.new(self.table, WeddingBuyDescCell, "WeddingBuyDescCell")
  self:AddClickEvent(self.buyBtn.gameObject, function()
    self:PassEvent(WeddingEvent.Buy, self)
  end)
end
function WeddingBuyCell:SetData(data)
  self:UnLoadPic()
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data then
    local staticData = Table_Item[data.id]
    if staticData ~= nil then
      self.title.text = staticData.NameZh
    end
    self.ctrl:ResetDatas(data:GetDescList())
    self.table:Reposition()
    if data.isPurchased then
      self.purchased:SetActive(true)
      self.buyBtn.CurrentState = 1
      self.icon.gameObject:SetActive(false)
    else
      self.purchased:SetActive(false)
      self.buyBtn.CurrentState = 0
      self.icon.gameObject:SetActive(true)
      local price = data:GetPrice()
      if price ~= nil then
        local money = Table_Item[price.id]
        if money ~= nil then
          IconManager:SetItemIcon(money.Icon, self.icon)
        end
        local discount = WeddingProxy.Instance:GetDiscountByID(data.id)
        redlog("dataid discount", data.id, discount)
        if discount then
          self:SetDisCountTip(true, discount / 100)
          self.price.text = StringUtil.NumThousandFormat(price.num * discount / 10000)
          self.primeCost.text = StringUtil.NumThousandFormat(price.num)
          self:Show(self.primeCost.gameObject)
        else
          self.price.text = StringUtil.NumThousandFormat(price.num)
          self:Hide(self.primeCost.gameObject)
          self:SetDisCountTip(false)
        end
      end
    end
    local serviceData = Table_WeddingService[data.id]
    if serviceData ~= nil then
      PictureManager.Instance:SetWedding(serviceData.Background, self.background)
    end
  end
end
function WeddingBuyCell:UnLoadPic()
  if self.data then
    local serviceData = Table_WeddingService[self.data.id]
    if serviceData ~= nil then
      PictureManager.Instance:UnLoadWedding(serviceData.Background, self.background)
    end
  end
end
function WeddingBuyCell:SetDisCountTip(b, pct)
  if self.discountTip then
    if b then
      self.discountTip:SetActive(true)
      self.discountTip_Label.text = pct .. "%"
      local spname, labelColor = self:GetDiscountUIConfig(pct)
      self.discountTip_Sp.spriteName = spname
      self.discountTip_Label.effectColor = labelColor or ColorUtil.NGUIBlack
    else
      self.discountTip:SetActive(false)
    end
  end
end
function WeddingBuyCell:GetDiscountUIConfig(pct)
  if pct > 0 and pct <= 20 then
    return "shop_icon_sale20%", ColorUtil.DiscountLabel_Green
  elseif pct > 20 and pct <= 30 then
    return "shop_icon_sale30%", ColorUtil.DiscountLabel_Blue
  elseif pct > 30 and pct <= 50 then
    return "shop_icon_sale50%", ColorUtil.DiscountLabel_Purple
  elseif pct > 50 and pct <= 100 then
    return "shop_icon_sale70%", ColorUtil.DiscountLabel_Yellow
  end
end
