local BaseCell = autoImport("BaseCell")
ServantHeadCell = class("ServantHeadCell", BaseCell)
function ServantHeadCell:Init()
  self:FingObj()
  self:AddCellClickEvent()
end
function ServantHeadCell:FingObj()
  self.icon = self:FindGO("servantIcon"):GetComponent(UISprite)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
end
function ServantHeadCell:SetData(data)
  self.data = data
  if self.data then
    self.gameObject:SetActive(true)
    IconManager:SetFaceIcon(self.data.icon, self.icon)
    self.chooseSymbol:SetActive(false)
  else
    self.gameObject:SetActive(false)
  end
end
function ServantHeadCell:SetChoose(isSelect)
  self.chooseSymbol:SetActive(isSelect)
end
