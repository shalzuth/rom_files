local baseCell = autoImport("BaseCell")
BlankItemCell = class("BlankItemCell", baseCell)
function BlankItemCell:Init()
  self:initView()
end
function BlankItemCell:initView()
end
function BlankItemCell:SetData(data)
  self.data = data
end
