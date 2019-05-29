local BaseCell = autoImport("BaseCell")
ERCell = class("ERCell", BaseCell)
autoImport("RecommendEquipCellForER")
local reusableTable = {}
function ERCell:Init()
  self.flag = self:FindGO("flag", self.gameObject)
  self.Name = self:FindGO("Name", self.gameObject)
  self.Name_UILabel = self.Name:GetComponent(UILabel)
  self.btn = self:FindGO("btn", self.gameObject)
  self.btn_Name = self:FindGO("Name", self.btn)
  self.btn_Name_UILabel = self.btn_Name:GetComponent(UILabel)
  self:AddClickEvent(self.btn, function()
    self:PassEvent(MouseEvent.MouseClick, {
      type = "selfCustom",
      data = self.data
    })
  end)
  self:AddCellClickEvent()
  self.choose = false
  self.EquipRecommendScrollViewNew = self:FindGO("EquipRecommendScrollViewNew", self.gameObject)
  self.EquipRecommendScrollViewNew_UIPanel = self.EquipRecommendScrollViewNew:GetComponent(UIPanel)
  self.EquipRecommendGrid = self:FindGO("EquipRecommendGrid", self.EquipRecommendScrollViewNew)
  self.EquipRecommendGrid_UIGrid = self.EquipRecommendGrid:GetComponent(UIGrid)
  self.EquipRecommendGrid_UIGridListCtrl = UIGridListCtrl.new(self.EquipRecommendGrid_UIGrid, RecommendEquipCellForER, "RecommendEquipCellForER")
  self.EquipRecommendGrid_UIGridListCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickEquipItem, self)
  self.BG1 = self:FindGO("BG1", self.gameObject)
  self.BG2 = self:FindGO("BG2", self.gameObject)
end
function ERCell:ShowBG1()
  self.BG1.gameObject:SetActive(true)
  self.BG2.gameObject:SetActive(false)
end
function ERCell:ShowBG2()
  self.BG1.gameObject:SetActive(false)
  self.BG2.gameObject:SetActive(true)
end
function ERCell:Get_EquipRecommendGrid_UIGridListCtrl()
  return self.EquipRecommendGrid_UIGridListCtrl
end
function ERCell:ChangeScrollViewDepth(depth)
  self.EquipRecommendScrollViewNew_UIPanel.depth = depth
end
function ERCell:GetTableERid()
  if self.data then
    return self.data.id
  else
    return 1
  end
end
function ERCell:ProcessForTanChu()
  self.btn.gameObject:SetActive(false)
end
function ERCell:UpdateRecomEquipList()
  TableUtility.TableClear(reusableTable)
  local equipList = self.data.equip
  for i = 1, #equipList do
    local tempItem = ItemData.new("", equipList[i])
    table.insert(reusableTable, tempItem)
  end
  self.EquipRecommendGrid_UIGridListCtrl:ResetDatas(reusableTable)
  local cells = self.EquipRecommendGrid_UIGridListCtrl:GetCells()
  for i = 1, #cells do
    cells[i].gameObject:AddComponent(UIDragScrollView)
    cells[i]:AddCellClickEvent()
  end
end
function ERCell:SetData(data)
  self.data = data
  self.Name_UILabel.text = data.genre
  self:UpdateRecomEquipList()
end
function ERCell:ClickEquipItem(cell)
  local data = {
    itemdata = cell.data,
    funcConfig = {},
    noSelfClose = false
  }
  self:ShowItemTip(data, cell.itemCell.icon, NGUIUtil.AnchorSide.Right, {210, -220})
end
function ERCell:SetLabelName(str)
  self.label.text = str
end
function ERCell:IsChoose()
  return self.choose
end
function ERCell:SetChoose(choose)
  self.choose = choose
  self.label.color = self.choose and ERCell.ChooseColor or ERCell.NormalColor
  self.Img.color = self.choose and ERCell.ChooseImgColor or ERCell.NormalImgColor
end
