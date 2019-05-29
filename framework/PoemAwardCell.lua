local baseCell = autoImport("BaseCell")
PoemAwardCell = class("PoemAwardCell", baseCell)
function PoemAwardCell:Init()
  self:initView()
end
function PoemAwardCell:initView()
  self.awardIcon = self:FindComponent("awardIcon", UISprite)
  self.awardName = self:FindComponent("awardName", UILabel)
  OverseaHostHelper:FixLabelOverV1(self.awardName, 3, 160)
  self.awardName.fontSize = 18
end
local tempVector3 = LuaVector3.zero
function PoemAwardCell:SetData(data)
  self.data = data
  local itemStaticData = Table_Item[data.id]
  IconManager:SetItemIcon(itemStaticData.Icon, self.awardIcon)
  self.awardName.text = itemStaticData.NameZh .. " x " .. data.num
end
