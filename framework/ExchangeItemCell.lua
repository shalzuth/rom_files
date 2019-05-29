ExchangeItemCell = class("ExchangeItemCell", ItemCell)
local str_format = "%s/%s"
local tempColor = LuaColor.white
ExchangeItemCellEvent = {
  Minus = "ExchangeItemCellEvent_Minus",
  LongPress = "ExchangeItemCellEvent_LongPress",
  LongPressSubtract = "ExchangeItemCellEvent_LongPressSubtract"
}
function ExchangeItemCell:Init()
  self:FindObj()
  self:AddEvts()
end
function ExchangeItemCell:FindObj()
  local itemCell = self:FindGO("Common_ItemCell")
  if not itemCell then
    self.itemgo = self:LoadPreferb("cell/ItemCell", self.gameObject)
    self.itemgo.name = "Common_ItemCell"
  end
  ExchangeItemCell.super.Init(self)
  self.pos = self:FindGO("pos")
  self.package = self:FindGO("PackageImg")
  self.minus = self:FindGO("MinusImg")
  self.numLab = self:FindComponent("NumLab", UILabel)
  self.chooseSymbol = self:FindGO("ChooseImg")
  self:AddCellClickEvent()
end
function ExchangeItemCell:AddEvts()
  self:AddPressEvent(self.gameObject, function(g, b)
    self:PlusPressCount(b)
  end)
  self:AddPressEvent(self.minus, function(g, b)
    self:SubtractPressCount(b)
  end)
end
function ExchangeItemCell:PlusPressCount(isPressed)
  if isPressed then
    if self.plusTick == nil then
      self.plusTick = TimeTickManager.Me():CreateTick(1, 150, function(self, deltatime)
        self:PassEvent(ExchangeItemCellEvent.LongPress, self)
      end, self, 1)
    end
  elseif self.plusTick then
    self.plusTick:Destroy()
    self.plusTick = nil
  end
end
function ExchangeItemCell:SubtractPressCount(isPressed)
  if isPressed then
    if self.subtractTick == nil then
      self.subtractTick = TimeTickManager.Me():CreateTick(1, 150, function(self, deltatime)
        self:PassEvent(ExchangeItemCellEvent.LongPressSubtract, self)
      end, self, 2)
    end
  elseif self.subtractTick then
    self.subtractTick:Destroy()
    self.subtractTick = nil
  end
end
function ExchangeItemCell:SetData(data)
  if not data then
    self:Hide(self.itemgo)
    self:Hide(self.pos)
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self:Show(self.itemgo)
  self:Show(self.pos)
  ExchangeItemCell.super.SetData(self, data)
  if data.id == "FeedPet" then
    self:SetFeedData()
    self:UpdateChoose()
    return
  end
  self:UpdateOwn()
end
function ExchangeItemCell:SetChoosen(id)
  self.chooseId = id
  self:UpdateChoose()
end
function ExchangeItemCell:UpdateChoose()
  if self.data and self.chooseId and self.data.staticData.id == self.chooseId then
    self.chooseSymbol:SetActive(true)
  else
    self.chooseSymbol:SetActive(false)
  end
end
local GetOwnCount = function(itemid)
  local package = GameConfig.PackageMaterialCheck.exchange_shop
  local _BagProxy = BagProxy.Instance
  local count = 0
  for i = 1, #package do
    count = count + _BagProxy:GetItemNumByStaticID(itemid, package[i])
  end
  return count
end
function ExchangeItemCell:SetFeedData()
  if not self.data then
    self:Hide(self.pos)
    return
  end
  self:Hide(self.package)
  self:Hide(self.minus)
  local staticId = self.data.staticData.id
  self.numLab.text = GetOwnCount(staticId)
  if 0 == GetOwnCount(staticId) then
    tempColor:Set(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 0.6274509803921569)
    self.icon.color = tempColor
    self:Hide(self.numLab)
  else
    ColorUtil.WhiteUIWidget(self.icon)
    self:Show(self.numLab)
  end
end
function ExchangeItemCell:UpdateOwn()
  if not self.data then
    self:Hide(self.pos)
    return
  end
  local staticId = self.data.staticData.id
  local own = BagProxy.Instance:GetItemNumByStaticID(staticId, BagProxy.BagType.MainBag)
  local previewNum = ExchangeShopProxy.Instance.chooseMap[staticId] or 0
  self.numLab.text = string.format(str_format, previewNum, own)
  self.minus:SetActive(previewNum > 0)
  if previewNum <= 0 and self.subtractTick then
    self.subtractTick:Destroy()
    self.subtractTick = nil
  end
  self.pos:SetActive(own > 0)
  if 0 == own then
    tempColor:Set(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 0.6274509803921569)
    self.icon.color = tempColor
    self:Hide(self.numLab)
  else
    ColorUtil.WhiteUIWidget(self.icon)
    self:Show(self.numLab)
  end
end
