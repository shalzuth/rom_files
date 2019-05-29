local baseCell = autoImport("BaseCell")
DotCell = class("DotCell", baseCell)
local DotNormal = Color(0.6862745098039216, 0.6862745098039216, 0.6862745098039216, 1)
local DotChoose = Color(1, 0.6862745098039216, 0.11764705882352941, 1)
function DotCell:Init()
  self:FindObjs()
end
function DotCell:FindObjs()
  self.dotSp = self.gameObject:GetComponent(UISprite)
end
function DotCell:SetChoose(isChoose)
  if self.isChoose ~= isChoose then
    self.isChoose = isChoose
    self.dotSp.color = isChoose and DotChoose or DotNormal
  end
end
function DotCell:GetChoose()
  return self.isChoose
end
