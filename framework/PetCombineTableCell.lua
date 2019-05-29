autoImport("PetComposeItemCell")
PetCombineTableCell = class("PetCombineTableCell", BaseCell)
function PetCombineTableCell:Init()
  self:FindObj()
  self:InitCell()
  self:AddCellClickEvent()
end
function PetCombineTableCell:FindObj()
  self.starGrid = self:FindComponent("StarGrid", UIGrid)
  self.petGrid = self:FindComponent("PetGrid", UIGrid)
  self.starPrefab = self:FindGO("StarPrefab")
end
function PetCombineTableCell:InitCell()
  self.starObj = {}
  self.petCtl = UIGridListCtrl.new(self.petGrid, PetComposeItemCell, "PetComposeItemCell")
  self.petCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChoosenPetCell, self)
end
function PetCombineTableCell:ClickChoosenPetCell(cellctl)
  if cellctl and cellctl.data then
    self:PassEvent(MouseEvent.MouseClick, cellctl)
  end
end
function PetCombineTableCell:SetStar()
  local childCount = self.starGrid.gameObject.transform.childCount
  for i = 1, childCount - 1 do
    local trans = self.starGrid.gameObject.transform:GetChild(i)
    self:Hide(trans.gameObject)
  end
  for i = 1, self.data.star do
    local obj = self.starObj[i]
    if not obj then
      local starObj = self:CopyGameObject(self.starPrefab)
      starObj:SetActive(true)
      starObj.transform:SetParent(self.starGrid.gameObject.transform)
      starObj.name = string.format("starSymbol%02d", self.data.star)
      self.starObj[i] = starObj
    else
      obj:SetActive(true)
    end
  end
  self.starGrid:Reposition()
end
function PetCombineTableCell:SetData(data)
  self.data = data
  if data then
    self.petCtl:ResetDatas(data.value)
    if "number" == type(data.star) then
      self:SetStar()
    end
  end
end
function PetCombineTableCell:GetCells()
  return self.petCtl:GetCells()
end
