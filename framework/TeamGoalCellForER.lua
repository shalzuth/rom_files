local BaseCell = autoImport("BaseCell")
TeamGoalCellForER = class("TeamGoalCellForER", BaseCell)
TeamGoalCellForER.ChooseColor = Color(0.10588235294117647, 0.3686274509803922, 0.6941176470588235)
TeamGoalCellForER.NormalColor = Color(0.13333333333333333, 0.13333333333333333, 0.13333333333333333)
TeamGoalCellForER.ChooseImgColor = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373)
TeamGoalCellForER.NormalImgColor = Color(0, 0, 0, 1)
function TeamGoalCellForER:Init()
  self.label = self:FindComponent("Label", UILabel)
  self.Img = self:FindComponent("Img", UISprite)
  self:AddCellClickEvent()
  self.choose = false
end
function TeamGoalCellForER:SetData(data)
  self.data = data
  if data.NameZh then
    self.label.text = data.NameZh
  end
end
function TeamGoalCellForER:SetLabelName(str)
  self.label.text = str
end
function TeamGoalCellForER:IsChoose()
  return self.choose
end
function TeamGoalCellForER:SetChoose(choose)
  self.choose = choose
  self.label.color = self.choose and TeamGoalCellForER.ChooseColor or TeamGoalCellForER.NormalColor
  self.Img.color = self.choose and TeamGoalCellForER.ChooseImgColor or TeamGoalCellForER.NormalImgColor
end
function TeamGoalCellForER:GetData()
  return self.data
end
