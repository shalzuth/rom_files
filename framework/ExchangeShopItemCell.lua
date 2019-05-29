local baseCell = autoImport("BaseCell")
ExchangeShopItemCell = class("ExchangeShopItemCell", baseCell)
local ICON_BG_TEX = "guild_bg_05"
local EMPTY = ExchangeShopProxy.GoodsTYPE.EMPTY
function ExchangeShopItemCell:Init()
  self:FindObjs()
  self:AddEvts()
end
local BTN_CONTENT_CFG = {
  [ExchangeShopProxy.EnchangeType.FRESS] = ZhString.ExchangeShop_Free,
  [ExchangeShopProxy.EnchangeType.PROGRESS] = ZhString.ExchangeShop_Exchange,
  [ExchangeShopProxy.EnchangeType.NO_PROGRESS] = ZhString.ExchangeShop_Exchange,
  [ExchangeShopProxy.EnchangeType.Limited_PROGRESS] = ZhString.ExchangeShop_Exchange,
  [ExchangeShopProxy.EnchangeType.MEDAL_PROGRESS] = ZhString.ExchangeShop_Exchange
}
function ExchangeShopItemCell:FindObjs()
  self.btn = self:FindGO("Btn")
  self.costPos = self:FindGO("CostPos")
  self.name = self:FindComponent("Name", UILabel)
  self.icon = self:FindComponent("Icon", UISprite)
  self.iconBg = self:FindComponent("IconBg", UITexture)
  self.btnContent = self:FindComponent("BtnContent", UILabel)
  self.costItemIcon = self:FindComponent("CostItemIcon", UISprite)
  self.costItemNum = self:FindComponent("CostItemNum", UILabel)
  self.empty = self:FindGO("Empty")
  self.desContent = self:FindComponent("Desc", UILabel)
  self.leftTime = self:FindComponent("LeftTime", UILabel)
  self.extraGift = self:FindGO("Extra")
  self.extraNum = self:FindComponent("ExtraNum", UILabel)
  self.extraDesc = self:FindGO("ExtraDesc")
  self.extraDescLab = self:FindComponent("ExtraDescLab", UILabel)
end
function ExchangeShopItemCell:AddEvts()
  self:AddClickEvent(self.btn.gameObject, function()
    if self.data and self.data.status ~= ExchangeShopProxy.GoodsTYPE.EMPTY then
      self:PassEvent(MouseEvent.MouseClick, self)
    end
  end)
  self:AddCellClickEvent()
end
function ExchangeShopItemCell:SetData(data)
  self.data = data
  if data then
    self:Show(self.gameObject)
    PictureManager.Instance:SetGuildBuilding(ICON_BG_TEX, self.iconBg)
    if data.staticData then
      local hasGift = #data.staticData.Item > 1
      self.empty:SetActive(EMPTY == data.status)
      self.btn:SetActive(EMPTY ~= data.status)
      self.extraGift:SetActive(hasGift)
      self.leftTime.gameObject:SetActive(EMPTY ~= data.status)
      if EMPTY ~= data.status then
        self:ResetLeftTime()
      end
      self:SetBtnState()
      local limit = data.staticData.ExchangeLimit
      local userMedalCount = Game.Myself.data.userdata:Get(UDEnum.TOTAL_MEDALCOUNT) or 0
      local isFixed = data.staticData.ExchangeType == ExchangeShopProxy.EnchangeType.Limited_PROGRESS
      if "table" == type(limit) and #limit > 0 then
        self:Show(self.extraDesc)
        local serverExchangeLimit = data.staticData.ExchangeLimit[data.progress]
        local medalCount = 0
        if isFixed then
          medalCount = serverExchangeLimit
        elseif data.status == EMPTY then
          medalCount = serverExchangeLimit
        else
          local isMedal = data.staticData.ExchangeType == ExchangeShopProxy.EnchangeType.MEDAL_PROGRESS or data.isKapulaExchangeType == true
          medalCount = isMedal and serverExchangeLimit - userMedalCount or serverExchangeLimit - data.exchangeCount
        end
        self.extraDescLab.text = string.format(ZhString.ExchangeShop_MedalDesc, medalCount, medalCount * 200)
      else
        self:Hide(self.extraDesc)
      end
      self.desContent.text = data.staticData.Desc
      self.name.text = data.staticData.Name
      if false == IconManager:SetItemIcon(data.staticData.Icon, self.icon) then
        IconManager:SetUIIcon(data.staticData.Icon, self.icon)
      end
    end
  else
    self:Hide(self.gameObject)
  end
end
function ExchangeShopItemCell:ResetLeftTime()
  if nil ~= self.data.leftTime and 0 < self.data:GetLeftTime() then
    if nil ~= self.timeTick then
      self:ClearTick()
    end
    self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateLeftTime, self)
    self:Show(self.leftTime)
  else
    self:Hide(self.leftTime)
    self:ClearTick()
  end
end
function ExchangeShopItemCell:UpdateLeftTime()
  if not self.data then
    self:Hide(self.leftTime)
    self:ClearTick()
    return
  end
  local totalSec = self.data:GetLeftTime()
  if totalSec > 0 then
    local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(totalSec)
    if not (day > 0) or not string.format(ZhString.QuotaCard_Surplus, day) then
    end
    self.leftTime.text = string.format(ZhString.MVPFightInfoBord_LeftTime, hour, min, sec)
  end
end
function ExchangeShopItemCell:SetBtnState()
  local staticData = self.data.staticData
  if staticData.ExchangeType == ExchangeShopProxy.EnchangeType.COINS then
    self:Show(self.costPos)
    self:Show(self.costItemIcon)
    self:Hide(self.btnContent)
    local costCFG = staticData.Cost
    if #costCFG < 2 then
      return
    end
    local _icon = Table_Item[costCFG[1]] and Table_Item[costCFG[1]].Icon or ""
    self.costItemNum.text = costCFG[2]
    if false == IconManager:SetItemIcon(_icon, self.costItemIcon) then
      IconManager:SetUIIcon(_icon, self.costItemIcon)
    end
    if 1 < #staticData.Item then
      self.extraNum.text = string.format(ZhString.ExchangeShop_MedalDesc, staticData.Item[1][2], staticData.Item[2][2])
    end
  else
    self:Hide(self.costPos)
    self:Hide(self.costItemIcon)
    self:Show(self.btnContent)
    self.btnContent.text = BTN_CONTENT_CFG[staticData.ExchangeType]
  end
end
function ExchangeShopItemCell:ClearTick()
  if nil ~= self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end
function ExchangeShopItemCell:OnDestroy()
  self:ClearTick()
  PictureManager.Instance:UnloadGuildBuilding()
end
