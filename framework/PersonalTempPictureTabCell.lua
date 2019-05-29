local baseCell = autoImport("BaseCell")
PersonalTempPictureTabCell = class("PersonalTempPictureTabCell", baseCell)
function PersonalTempPictureTabCell:Init()
  self:initView()
  self:initData()
end
function PersonalTempPictureTabCell:initView()
  self.label = self:FindComponent("PersonalTabLabel", UILabel)
end
function PersonalTempPictureTabCell:initData()
end
local tempColor = LuaColor(0.14901960784313725, 0.2823529411764706, 0.5803921568627451)
function PersonalTempPictureTabCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self.label.effectStyle = UILabel.Effect.Outline8
      self.label.effectColor = tempColor
    else
      self.label.effectStyle = UILabel.Effect.None
    end
  end
end
function PersonalTempPictureTabCell:SetData(data)
  self.data = data
  self.label.text = data.name
end
