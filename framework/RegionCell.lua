local baseCell = autoImport("BaseCell")
RegionCell = class("RegionCell", baseCell)
function RegionCell:Init()
  self:initView()
  self:initData()
end
function RegionCell:initView()
  self.name = self:FindGO("name"):GetComponent(UILabel)
  self.bg = self:FindGO("bg"):GetComponent(UIMultiSprite)
  self:SetEvent(self.gameObject, function(obj)
    if not self.isSelected then
      self:PassEvent(MouseEvent.MouseClick, self)
    end
  end)
end
function RegionCell:initData()
  self.isSelected = true
  self:setIsSelected(false)
end
function RegionCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self.bg.CurrentState = 0
      self.name.effectColor = Color(0.01568627450980392, 0.49411764705882355, 0.6901960784313725, 1)
      self.name.effectStyle = UILabel.Effect.Outline8
      self.bg.gameObject.transform.localScale = Vector3(1.04, 1.04, 1.04)
    else
      self.bg.CurrentState = 1
      self.name.effectStyle = UILabel.Effect.None
      self.bg.gameObject.transform.localScale = Vector3.one
    end
  end
end
function RegionCell:SetData(data)
  self.data = data
  self.name.text = data.name
end
