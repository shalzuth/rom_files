local BaseCell = autoImport("BaseCell")
TeamGoalCell = class("TeamGoalCell", BaseCell)
TeamGoalCell.ChooseColor = Color(0.10588235294117647, 0.3686274509803922, 0.6941176470588235)
TeamGoalCell.NormalColor = Color(0.13333333333333333, 0.13333333333333333, 0.13333333333333333)
TeamGoalCell.ChooseImgColor = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373)
TeamGoalCell.NormalImgColor = Color(0, 0, 0, 1)
function TeamGoalCell:Init()
  self.label = self:FindComponent("Label", UILabel)
  self.Img = self:FindComponent("Img", UISprite)
  self:AddCellClickEvent()
  self.choose = false
end
function TeamGoalCell:SetData(data)
  self.data = data
  self.label.text = data.NameZh
end
function TeamGoalCell:IsChoose()
  return self.choose
end
function TeamGoalCell:SetChoose(choose)
  self.choose = choose
  self.label.color = self.choose and TeamGoalCell.ChooseColor or TeamGoalCell.NormalColor
  self.Img.color = self.choose and TeamGoalCell.ChooseImgColor or TeamGoalCell.NormalImgColor
end
