autoImport("BaseAttributeCell")
BaseAttributeReCell = class("BaseAttributeReCell", BaseAttributeCell)
function BaseAttributeReCell:Init()
  self:initView()
  self:addViewEventListener()
end
function BaseAttributeReCell:addViewEventListener()
  self:AddCellClickEvent()
end
local tempVector3 = LuaVector3.zero
function BaseAttributeReCell:SetData(data)
  BaseAttributeReCell.super.SetData(self, data)
  local id = data.prop.propVO.id
  local staticData = Table_RoleData[id]
  if not staticData then
    return
  end
  local desc = staticData.DataDesc
  tempVector3:Set(LuaGameObject.GetLocalPosition(self.name.transform))
  if StringUtil.IsEmpty(desc) then
    tempVector3:Set(tempVector3.x, 0, tempVector3.z)
    self.name.transform.localPosition = tempVector3
    self:Hide(self.attributeDesc.gameObject)
  else
    tempVector3:Set(tempVector3.x, 6.5, tempVector3.z)
    self.name.transform.localPosition = tempVector3
    self:Show(self.attributeDesc.gameObject)
    self.attributeDesc.text = desc
    self.attributeDesc.fontSize = 14
    self.attributeDesc.transform.localPosition = Vector3(-18, -12, 0)
    self.value.transform.localPosition = Vector3(469.1001, 8, 0)
  end
  self:Show(self.line)
end
function BaseAttributeReCell:initView()
  BaseAttributeReCell.super.initView(self)
  self.attributeDesc = self:FindComponent("attributeDesc", UILabel)
end
