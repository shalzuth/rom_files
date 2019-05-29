local baseCell = autoImport("BaseCell")
autoImport("PetDendrogramCell")
PetComposePreviewCell = class("PetComposePreviewCell", baseCell)
local GridCellWidthCfg = {
  [1] = 100,
  [2] = 200
}
function PetComposePreviewCell:ctor(go, rootId, recursive)
  PetComposePreviewCell.super.ctor(self, go)
  self.rootId = rootId
  self.recursive = recursive
  self:Init()
end
function PetComposePreviewCell:Init()
  self:FindObjs()
  self:InitCell()
end
function PetComposePreviewCell:FindObjs()
  self.pos = self:FindGO("Item")
  self.previewGrid = self:FindGO("PreviewGrid"):GetComponent(UIGrid)
  self.line = self:FindComponent("Line", UISprite)
end
function PetComposePreviewCell:InitCell()
  self.dendrogramCellCtl = UIGridListCtrl.new(self.previewGrid, PetDendrogramCell, "PetDendrogramCell")
  self.dendrogramCellCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickItem, self)
  self:ResetCell()
end
function PetComposePreviewCell:OnClickItem(cellCtl)
  local data = cellCtl and cellCtl.data
  if self.clickCall then
    self.clickCall(self.clickCallParam, data)
  end
end
function PetComposePreviewCell:SetClickEvent(clickCall, clickCallParam)
  self.clickCall = clickCall
  self.clickCallParam = clickCallParam
end
function PetComposePreviewCell:ResetCell()
  self.data = PetComposeDendrogram.new(self.rootId, self.recursive)
  if self.data then
    self:Show(self.pos)
    self:SetBaseInfo()
    local uiData = self.data:GetUIData()
    self.dendrogramCellCtl:ResetDatas(uiData)
  else
    self:Hide(self.pos)
  end
end
function PetComposePreviewCell:ResetDatas()
  local uiData = self.data:GetUIData()
  self.dendrogramCellCtl:ResetDatas(uiData)
end
function PetComposePreviewCell:SetBaseInfo()
  local rootId = PetComposeProxy.Instance:GetCurPet()
  local rootCsv = Table_PetCompose[rootId]
  local nextPet = false
  local nodeCount = self.data:GetNodeCount()
  for i = 1, 3 do
    local materialPet = rootCsv["MaterialPet" .. i]
    local childId = materialPet and materialPet.id
    if childId and childId == self.rootId then
      self.previewGrid.cellWidth = nodeCount > 2 and 100 or 150
      self.line.width = (nodeCount - 1) * self.previewGrid.cellWidth
      return
    end
  end
  if self.recursive then
    self.previewGrid.cellWidth = nodeCount > 2 and 370 or 600
  else
    self.previewGrid.cellWidth = nodeCount > 2 and 150 or 200
  end
  self.line.width = (nodeCount - 1) * self.previewGrid.cellWidth
end
function PetComposePreviewCell:PlayComposeEffect()
  local cells = self.dendrogramCellCtl:GetCells()
  if not cells then
    return
  end
  for i = 1, #cells do
    cells[i]:PlayEffect()
  end
end
