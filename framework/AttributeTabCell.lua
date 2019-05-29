autoImport("BaseCell")
autoImport("BaseAttributeReCell")
AttributeTabCell = class("AttributeTabCell", BaseCell)
function AttributeTabCell:Init()
  self:initView()
  self:addViewEventListener()
end
function AttributeTabCell:addViewEventListener()
  self:AddCellClickEvent()
end
local tempVector3 = LuaVector3.zero
function AttributeTabCell:SetData(data)
  self.data = data
  self:initData()
  local desc = data.desc
  tempVector3:Set(LuaGameObject.GetLocalPosition(self.grid.transform))
  if StringUtil.IsEmpty(desc) then
    tempVector3:Set(tempVector3.x, -28.61, tempVector3.z)
    self.grid.transform.localPosition = tempVector3
    self:Hide(self.descCt)
  else
    tempVector3:Set(tempVector3.x, -49.4, tempVector3.z)
    self.grid.transform.localPosition = tempVector3
    self:Show(self.descCt)
    self.titleDesc.text = desc
  end
  self.titleLabel.text = data.name
  self.baseGridList:ResetDatas(data.props)
  self:setPreferenceShow()
end
function AttributeTabCell:setPreferenceShow()
  local pfKey = string.format("RO_PropTabShowPre_%s", self.data.id)
  local value = FunctionPlayerPrefs.Me():GetInt(pfKey, 1)
  if value == 0 then
    self:Hide(self.grid.gameObject)
    self.icon.transform.localRotation = Quaternion.Euler(0, 0, -90)
  else
    self:Show(self.grid.gameObject)
    self.icon.transform.localRotation = Quaternion.Euler(0, 0, 90)
  end
end
function AttributeTabCell:initData()
  if self.baseGridList then
    return
  end
  if self.data.id > 2 then
    self.baseGridList = UIGridListCtrl.new(self.grid, BaseAttributeReCell, "BaseAttributeCell")
    self.grid.columns = 1
  else
    self.grid.columns = 2
    self.baseGridList = UIGridListCtrl.new(self.grid, BaseAttributeReCell, "BaseAttrCell")
  end
end
function AttributeTabCell:toggleGridUIVisible()
  local activeSelf = self.grid.gameObject.activeSelf
  local value = 1
  if activeSelf then
    self:Hide(self.grid.gameObject)
    value = 0
    self.icon.transform.localRotation = Quaternion.Euler(0, 0, -90)
  else
    self.icon.transform.localRotation = Quaternion.Euler(0, 0, 90)
    self:Show(self.grid.gameObject)
  end
  local pfKey = string.format("RO_PropTabShowPre_%s", self.data.id)
  FunctionPlayerPrefs.Me():SetInt(pfKey, value)
end
function AttributeTabCell:initView()
  self.titleLabel = self:FindComponent("titleLabel", UILabel)
  self.titleDesc = self:FindComponent("titleDesc", UILabel)
  self.descCt = self:FindGO("descCt")
  self.grid = self:FindComponent("Grid", UITable)
  self.icon = self:FindComponent("Sprite", UISprite)
end
