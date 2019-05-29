local baseCell = autoImport("BaseCell")
PhotographSingleFilterText = class("PhotographSingleFilterText", baseCell)
function PhotographSingleFilterText:Init()
  self:initView()
end
function PhotographSingleFilterText:initView()
  self.label = self:FindGO("Label"):GetComponent(UILabel)
  self.toggle = self.gameObject:GetComponent(UIToggle)
  self:SetEvent(self.gameObject, function(obj)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.label.transform.localPosition = Vector3(-96, 0, 0)
  local select = self:FindGO("selected")
  select.transform.localPosition = Vector3(100, 0, 0)
  local selectedBg = self:FindGO("selectedBg")
  selectedBg.transform.localPosition = Vector3(100, 0, 0)
  self.gameObject:GetComponent(BoxCollider).center = Vector3(50, 0, 0)
  helplog("set!!!!")
end
function PhotographSingleFilterText:SetData(data)
  self.data = data
  if data.text then
    self.label.text = data.text
  else
    local config = Table_ScreenFilter[data.id]
    if config then
      self.label.text = config.Name
    end
  end
  self:setIsSelect(true)
end
function PhotographSingleFilterText:setIsSelect(isSelect)
  self.toggle:Set(isSelect)
end
function PhotographSingleFilterText:getIsSelect()
  return self.toggle.value
end
