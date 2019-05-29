autoImport("ItemCell")
MaterialChooseCell = class("MaterialChooseCell", ItemCell)
MaterialChooseCellEvent = {
  LongPress = "MaterialChooseCellEvent_LongPress"
}
function MaterialChooseCell:Init()
  self.itemObj = self:LoadPreferb("cell/MaterialItemCell", self.gameObject)
  self.itemObj.transform.localPosition = Vector3.zero
  MaterialChooseCell.super.Init(self)
  self:initView()
  self:initData()
  self:AddViewEvents()
end
function MaterialChooseCell:initView()
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.favoriteMask = self:FindGO("FavoriteMask")
end
function MaterialChooseCell:initData()
end
function MaterialChooseCell:AddViewEvents()
  local long = self.gameObject:GetComponent(UILongPress)
  long = long or self.gameObject:AddComponent(UILongPress)
  if long then
    long.pressTime = 1.0
    function long.pressEvent(obj, isPress)
      if isPress then
        self:PassEvent(MaterialChooseCellEvent.LongPress, self)
      end
    end
  end
  self:AddCellClickEvent()
end
function MaterialChooseCell:SetData(data)
  MaterialChooseCell.super.SetData(self, data)
  self:UpdateChoose()
  self:UpdateFavoriteMask()
  self:UpdateBagType()
end
function MaterialChooseCell:SetChooseIds(chooseIds)
  self.chooseIds = chooseIds
  self:UpdateChoose()
end
function MaterialChooseCell:UpdateChoose()
  if self.chooseSymbol and self.data and self.chooseIds and #self.chooseIds > 0 then
    for i = 1, #self.chooseIds do
      local id = self.chooseIds[i]
      if self.data.id == id then
        self.chooseSymbol:SetActive(true)
        return
      end
    end
  end
  self.chooseSymbol:SetActive(false)
end
function MaterialChooseCell:SetItemNameText(text)
end
function MaterialChooseCell:UpdateFavoriteMask()
  if not self.favoriteMask then
    return
  end
  self.favoriteMask:SetActive(false)
  if not self.data then
    return
  end
  if BagProxy.Instance:CheckIfFavoriteCanBeMaterial(self.data) == false then
    self.favoriteMask:SetActive(true)
    self.chooseSymbol:SetActive(false)
  end
end
