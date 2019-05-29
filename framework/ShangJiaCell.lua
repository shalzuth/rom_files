local baseCell = autoImport("BaseCell")
ShangJiaCell = class("ShangJiaCell", baseCell)
function ShangJiaCell:Init()
  self:initView()
  self:initData()
  self:AddCellClickEvent()
end
function ShangJiaCell:initData()
end
function ShangJiaCell:initView()
  self.Title = self:FindGO("Title")
  self.WeiZhi = self:FindGO("WeiZhi")
  self.Select = self:FindGO("Select")
  self.Title_UILabel = self.Title:GetComponent(UILabel)
  self.Select.gameObject:SetActive(false)
end
function ShangJiaCell:childCellClick(cellCtl)
end
function ShangJiaCell:getSubChildCells()
end
function ShangJiaCell:SetData(data)
  self.data = data
  self.Title_UILabel.text = self.data.name
end
function ShangJiaCell:clickEvent()
end
function ShangJiaCell:setSelected(isSelected)
end
