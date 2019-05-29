FinanceCell = class("FinanceCell", ItemCell)
local _VecPos = LuaVector3.zero
local _redColor = LuaColor.New(0.8156862745098039, 0.18823529411764706, 0.14901960784313725, 1)
local _greenColor = LuaColor.New(0.3137254901960784, 0.7843137254901961, 0.1843137254901961, 1)
function FinanceCell:Init()
  self.itemContainer = self:FindGO("ItemContainer")
  self.itemContainer:AddComponent(UIDragScrollView)
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  _VecPos:Set(0, 0, 0)
  obj.transform.localPosition = _VecPos
  FinanceCell.super.Init(self)
  self:FindObjs()
  self:InitShow()
end
function FinanceCell:FindObjs()
  self.ratio = self:FindGO("Ratio"):GetComponent(UILabel)
  self.ratioArrow = self:FindGO("RatioArrow"):GetComponent(UISprite)
  self.choose = self:FindGO("Choose")
  self.price = self:FindGO("Price"):GetComponent(UILabel)
end
function FinanceCell:InitShow()
  self:ShowChoose(false)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(FinanceEvent.ShowDetail, self)
  end)
  self:AddClickEvent(self.itemContainer, function()
    local data = ReusableTable.CreateTable()
    data.itemdata = self.data:GetItemData()
    data.funcConfig = {}
    TipManager.Instance:ShowItemFloatTip(data, self.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
    ReusableTable.DestroyAndClearTable(data)
  end)
end
function FinanceCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data then
    if data.rankType == FinanceRankTypeEnum.DealCount or data.rankType == FinanceRankTypeEnum.UpRatio then
      self.ratio.color = _redColor
      self.ratioArrow.color = _redColor
      self.ratioArrow.flip = 0
    elseif data.rankType == FinanceRankTypeEnum.DownRatio then
      self.ratio.color = _greenColor
      self.ratioArrow.color = _greenColor
      self.ratioArrow.flip = 2
    end
    self.ratio.text = string.format(ZhString.Finance_Ratio, data.ratio / 10)
    self.price.text = StringUtil.NumThousandFormat(data.price)
    self:ShowChoose(data.isChoose)
    local itemData = data:GetItemData()
    if itemData ~= nil then
      FinanceCell.super.SetData(self, itemData)
    end
  end
  self.data = data
end
function FinanceCell:ShowChoose(isChoose)
  if self.data ~= nil then
    self.data:SetChoose(isChoose)
    self.choose:SetActive(isChoose)
  end
end
