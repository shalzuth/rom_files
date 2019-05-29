local baseCell = autoImport("BaseCell")
RecipeCell = class("RecipeCell", baseCell)
autoImport("ItemCell")
autoImport("ItemData")
function RecipeCell:Init()
  self:InitCell()
  self:AddCellClickEvent()
end
function RecipeCell:InitCell()
  local itemGO = self:FindGO("ItemCell")
  self.itemCell = ItemCell.new(itemGO)
  self.itemCell:HideNum()
  self.name = self:FindComponent("Name", UILabel)
  self.effect = self:FindComponent("Effect", UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
end
function RecipeCell:SetData(data)
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    local sData = data.staticData
    if data.unlock then
      local product = sData.Product
      local productItem = data:GetProductItem()
      if productItem then
        self.itemCell:SetData(productItem)
        local matchNum = FunctionFood.Me():Match_MakeNum(data.staticData.id)
        if matchNum then
          if matchNum > 0 then
            self.name.text = sData.Name .. string.format("(%s)", matchNum)
          else
            self.name.text = sData.Name
          end
        end
        self.effect.text = productItem:GetFoodEffectDesc()
        UIUtil.WrapLabel(self.effect)
      end
    else
      self.itemCell:SetData(nil)
      self.name.text = "??????"
      self.effect.text = "????????"
    end
    self.chooseSymbol:SetActive(sData.id == self.chooseid)
  else
    self.gameObject:SetActive(false)
  end
end
function RecipeCell:Refresh()
  self:SetData(self.data)
end
function RecipeCell:SetChoose(chooseid)
  self.chooseid = chooseid
  if self.data and self.data.staticData.id == self.chooseid then
    self.chooseSymbol:SetActive(true)
  else
    self.chooseSymbol:SetActive(false)
  end
end
