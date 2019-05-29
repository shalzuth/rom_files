local BaseCell = autoImport("BaseCell")
jihuacellfather = class("jihuacellfather", BaseCell)
jihuacellfather.ChooseColor = Color(0.10588235294117647, 0.3686274509803922, 0.6941176470588235)
jihuacellfather.NormalColor = Color(0.13333333333333333, 0.13333333333333333, 0.13333333333333333)
jihuacellfather.ChooseImgColor = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373)
jihuacellfather.NormalImgColor = Color(0, 0, 0, 1)
function jihuacellfather:Init()
  self.label = self:FindComponent("Label", UILabel)
  self.Img = self:FindComponent("Img", UISprite)
  self:AddCellClickEvent()
  self.choose = false
end
function jihuacellfather:SetData(data)
  self.data = data
  if data.NameZh then
    self.label.text = data.NameZh
  end
end
function jihuacellfather:GetFatherName()
  if self.data and self.data.NameZh then
    return self.data.NameZh
  else
    return "unknown"
  end
end
function jihuacellfather:IsChoose()
  return self.choose
end
function jihuacellfather:SetChoose(choose)
  self.choose = choose
end
function jihuacellfather:GetData()
  return self.data
end
