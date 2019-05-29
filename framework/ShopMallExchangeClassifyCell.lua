ShopMallExchangeClassifyCell = class("ShopMallExchangeClassifyCell", ItemCell)
function ShopMallExchangeClassifyCell:Init()
  self.cellContainer = self:FindGO("CellContainer")
  if self.cellContainer then
    local obj = self:LoadPreferb("cell/ItemCell", self.cellContainer)
    obj.transform.localPosition = Vector3.zero
    self.cellContainer:AddComponent(UIDragScrollView)
  end
  ShopMallExchangeClassifyCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
  self:AddEvts()
end
function ShopMallExchangeClassifyCell:FindObjs()
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.level = self:FindGO("Level"):GetComponent(UILabel)
  self.publicity = self:FindGO("Publicity")
end
function ShopMallExchangeClassifyCell:AddEvts()
  self:AddClickEvent(self.cellContainer, function()
    local data = ReusableTable.CreateTable()
    data.itemdata = self.itemData
    data.funcConfig = {}
    TipManager.Instance:ShowItemFloatTip(data, self.icon, NGUIUtil.AnchorSide.Right, {210, 0})
    ReusableTable.DestroyAndClearTable(data)
  end)
end
function ShopMallExchangeClassifyCell:SetData(data)
  if data then
    local itemData = Table_Item[data.id]
    if itemData ~= nil then
      self.name.text = itemData.NameZh
      local exchangeData = Table_Exchange[data.id]
      if exchangeData and exchangeData.FashionType then
        local fashion = GameConfig.Exchange.ExchangeFashion[exchangeData.FashionType]
        if fashion then
          self.level.gameObject:SetActive(true)
          self.level.text = fashion
        else
          errorLog(string.format("ShopMallExchangeClassifyCell SetData : GameConfig.Exchange.ExchangeFashion[%s] = nil", tostring(exchangeData.FashionType)))
        end
      elseif itemData.Level then
        self.level.gameObject:SetActive(true)
        self.level.text = "Lv." .. itemData.Level
      else
        self.level.gameObject:SetActive(false)
      end
    end
    self.itemData = ItemData.new(nil, data.id)
    if self.itemData then
      ShopMallExchangeClassifyCell.super.SetData(self, self.itemData)
    end
    self.publicity:SetActive(data.isPublicity)
  end
  self.data = data
end
