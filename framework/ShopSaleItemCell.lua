ShopSaleItemCell = class("ShopSaleItemCell", ItemCell)
function ShopSaleItemCell:Init()
  local cellContainer = self:FindGO("CellContainer")
  if cellContainer then
    local obj = self:LoadPreferb("cell/ItemCell", cellContainer)
    obj.transform.localPosition = Vector3.zero
  end
  ShopSaleItemCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
  self:SetEvent(self.cancelSprite, function()
    self:PassEvent(ShopSaleEvent.canelSale, self)
  end)
  self:SetEvent(cellContainer, function()
    self:PassEvent(ShopSaleEvent.SelectIconSprite, self)
  end)
end
function ShopSaleItemCell:FindObjs()
  self.saleItem = self:FindGO("SaleItem")
  self.itemName = self:FindGO("itemName"):GetComponent(UILabel)
  self.costMoneySprite = self:FindGO("costMoneySprite"):GetComponent(UISprite)
  self.costMoneyNums = self:FindGO("costMoneyNums"):GetComponent(UILabel)
  self.desc = self:FindGO("desc"):GetComponent(UILabel)
  self.cancelSprite = self:FindGO("cancelSprite")
end
function ShopSaleItemCell:SetData(data)
  if data then
    if data.guid ~= nil then
      self.bagData = ShopSaleProxy.Instance:GetItemByGuid(data.guid)
      errorLogTest("ShopSaleItemCell data.guid ~= nil")
    else
      self:ErrorLog("ShopSaleItemCell data.guid = nil")
      return
    end
    if self.bagData == nil then
      self:ErrorLog("ShopSaleItemCell self.bagData = nil")
      return
    end
    if self.bagData.staticData == nil then
      self:ErrorLog("ShopSaleItemCell self.bagData.staticData = nil")
      return
    end
    ShopSaleItemCell.super.SetData(self, self.bagData)
    self:SetActive(self.saleItem, true)
    self.itemName.text = self.bagData.staticData.NameZh
    self:UpdateNumLabel(data.nums)
    self.desc.text = self.bagData.staticData.Desc
    if data.price ~= nil then
      self.costMoneyNums.text = StringUtil.NumThousandFormat(data.price)
    else
      errorLog("ShopSaleItemCell data.price = nil")
    end
  else
    self:SetActive(self.saleItem, false)
  end
  self.data = data
end
function ShopSaleItemCell:ErrorLog(str)
  errorLog(str)
  self.gameObject:SetActive(false)
end
