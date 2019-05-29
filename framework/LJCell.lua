local BaseCell = autoImport("BaseCell")
LJCell = class("LJCell", BaseCell)
function LJCell:Init()
  LJCell.super.Init(self)
  self:FindObjs()
  self.BG1 = self:FindGO("BG1")
  self.BG2 = self:FindGO("BG2")
  self.Gou = self:FindGO("Gou")
  self.Name = self:FindGO("Name")
  self.BG2_UITexture = self.BG2:GetComponent(UITexture)
  self.Name_UILabel = self.Name:GetComponent(UILabel)
  self:AddClickEvent(self.gameObject, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end
function LJCell:FindObjs()
end
function LJCell:OnClickGiftBtn()
end
function LJCell:SetData(data)
  self.data = data
  if self.data then
    self.Name_UILabel.text = self.data.Name
    if self.data.TextureName and self.data.TextureName ~= "test1" then
      self.BG1.gameObject:SetActive(false)
      PictureManager.Instance:SetCameraBG(self.data.TextureName, self.BG2_UITexture)
    else
      self.BG1.gameObject:SetActive(false)
      PictureManager.Instance:SetCameraBG("Boom", self.BG2_UITexture)
    end
  end
  self:SetSelect(false)
end
function LJCell:SetSelect(b)
  self.select = b
  if b then
    self.Gou.gameObject:SetActive(true)
    if self.data and self.data.IsRealtime == 0 then
      MsgManager.ShowMsgByIDTable(34008)
    end
  else
    self.Gou.gameObject:SetActive(false)
  end
end
function LJCell:GetSelectState()
  return self.select or false
end
function LJCell:UpdateGiftState(groupData)
end
