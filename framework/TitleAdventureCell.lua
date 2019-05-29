autoImport("TitleCell")
TitleAdventureCell = class("TitleAdventureCell", TitleCell)
local grayLabel = Color(0.5019607843137255, 0.5019607843137255, 0.5019607843137255, 1)
local blackLabel = Color(0.17647058823529413, 0.17647058823529413, 0.17647058823529413, 1)
local usingLabel = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
function TitleAdventureCell:FindObjs()
  TitleAdventureCell.super.FindObjs(self)
  self.attr = self:FindComponent("attr", UILabel)
end
function TitleAdventureCell:SetData(data)
  TitleAdventureCell.super.SetData(self, data)
  local staticData = Table_Appellation[self.id]
  if not staticData then
    return
  end
  local prop = staticData.BaseProp
  local propDesc
  for k, v in pairs(prop) do
    if propDesc then
      propDesc = propDesc .. " , " .. tostring(k) .. "+" .. tostring(v)
    else
      propDesc = tostring(k) .. "+" .. tostring(v)
    end
  end
  local curID = Game.Myself.data:GetAchievementtitle()
  if curID == self.id and self.unlocked then
    self.attr.color = usingLabel
  elseif self.unlocked then
    self.attr.color = blackLabel
  else
    self.attr.color = grayLabel
  end
  self.attr.text = propDesc
end
