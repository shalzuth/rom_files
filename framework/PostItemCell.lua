PostItemCell = class("PostItemCell", ItemCell)
function PostItemCell:Init()
  self.itemobj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  self.itemobj.transform.localPosition = Vector3.zero
  PostItemCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end
function PostItemCell:FindObjs()
  self.emptyPos = self:FindGO("EmptyPos")
end
function PostItemCell:SetData(data)
  self.emptyPos:SetActive(nil == data)
  self.itemobj:SetActive(nil ~= data)
  if data then
    PostItemCell.super.SetData(self, data)
    self:SetPostGray(data.attach)
  end
  self.data = data
end
function PostItemCell:SetPostGray(var)
  local func = var and ColorUtil.GrayUIWidget or ColorUtil.WhiteUIWidget
  func(self.icon)
  func(self:GetBgSprite())
end
