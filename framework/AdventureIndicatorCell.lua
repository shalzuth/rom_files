local baseCell = autoImport("BaseCell")
AdventureIndicatorCell = class("AdventureIndicatorCell", baseCell)
function AdventureIndicatorCell:Init()
  AdventureIndicatorCell.super.Init(self)
  self:initView()
end
local tempColor = LuaColor.white
function AdventureIndicatorCell:initView()
  self.bg = self.gameObject:GetComponent(UISprite)
end
function AdventureIndicatorCell:SetData(data)
  if data.cur then
    tempColor:Set(1, 0.6705882352941176, 0.23921568627450981, 1)
    self.bg.color = tempColor
  else
    tempColor:Set(1, 1, 1, 1)
    self.bg.color = tempColor
  end
end
