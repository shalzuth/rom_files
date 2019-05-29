local BaseCell = autoImport("BaseCell")
PetComposeItemCell = class("PetComposeItemCell", BaseCell)
function PetComposeItemCell:Init()
  self:InitView()
  self:AddCellClickEvent()
end
function PetComposeItemCell:InitView()
  self.pos = self:FindGO("Item")
  self.chooseFlag = self:FindGO("Choose")
  self.icon = self:FindComponent("Icon", UISprite)
  self.starGrid = self:FindComponent("StarGrid", UIGrid)
  self.starPrefab = self:FindGO("StarPrefab")
end
function PetComposeItemCell:SetData(data)
  self.data = data
  self.starObj = {}
  if data then
    self:Show(self.pos)
    IconManager:SetNpcMonsterIconByID(data, self.icon)
  else
    self:Hide(self.pos)
  end
end
function PetComposeItemCell:SetStar()
  if not self.data then
    return
  end
  local star = self.data
  local childCount = self.starGrid.gameObject.transform.childCount
  for i = 1, childCount - 1 do
    local trans = self.starGrid.gameObject.transform:GetChild(i)
    self:Hide(trans.gameObject)
  end
  for i = 1, star do
    local obj = self.starObj[i]
    if not obj then
      local starObj = self:CopyGameObject(self.starPrefab)
      starObj:SetActive(true)
      starObj.transform:SetParent(self.starGrid.gameObject.transform)
      starObj.name = string.format("starSymbol%02d", star)
      self.starObj[i] = starObj
    else
      obj:SetActive(true)
    end
  end
  self.starGrid:Reposition()
end
function PetComposeItemCell:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end
function PetComposeItemCell:UpdateChoose()
  if self.data and self.chooseId and self.data == self.chooseId then
    self.chooseFlag:SetActive(true)
  else
    self.chooseFlag:SetActive(false)
  end
end
