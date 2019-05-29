autoImport("BaseAttributeReCell")
PlayerAttriButeCell = class("PlayerAttriButeCell", BaseAttributeReCell)
local tempVector3 = LuaVector3.zero
function PlayerAttriButeCell:Init()
  self:initView()
end
function PlayerAttriButeCell:initView()
  self.name = self:FindChild("name"):GetComponent(UILabel)
  self.value = self:FindChild("value"):GetComponent(UILabel)
  self.line = self:FindGO("line")
  self.attributeDesc = self:FindComponent("attributeDesc", UILabel)
  self.checkBoxCt = self:FindGO("checkBox")
end
function PlayerAttriButeCell:SetData(data)
  self.data = data
  if data then
    local playerData = data.playerData
    local propVO = data.prop.propVO
    local name, value, total
    if CommonFun.checkIsNoNeedPercent(data.prop.propVO.name) then
      total = data.prop:GetValue()
    else
      local perProKey = string.format("%sPer", propVO.name)
      local perPropVO, perPropValue = playerData.props[perProKey], 0
      perPropValue = perPropVO and (perPropVO:GetValue() or 0)
      total = data.prop:GetValue() * (1 + perPropValue)
    end
    if propVO.IsClientPercent then
      local tmp = math.floor(total * 1000) / 10
      total = tmp .. "%"
    else
      total = math.floor(total)
    end
    if propVO.name == "Sp" or propVO.name == "Hp" then
      local maxProKey = string.format("Max%s", propVO.name)
      local maxPropVO, maxPropValue = playerData.props[maxProKey], 0
      maxPropValue = maxPropVO and (maxPropVO:GetValue() or 0)
      maxPropValue = math.floor(maxPropValue)
      value = string.format("%s/%s", total, maxPropValue)
      name = propVO.name
    else
      value = total
      name = propVO.displayName
    end
    self.value.text = value
    self.name.text = name
  end
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
  end
  self:Show(self.line)
  if self.checkBoxCt then
    self:Hide(self.checkBoxCt)
  end
end
function PlayerAttriButeCell:HideLine()
  self.line.gameObject:SetActive(false)
end
local tempVector3 = LuaVector3.zero
function PlayerAttriButeCell:HideDesc()
  self.attributeDesc.gameObject:SetActive(false)
  tempVector3:Set(LuaGameObject.GetLocalPosition(self.name.transform))
  tempVector3:Set(tempVector3.x, 0, tempVector3.z)
  self.name.transform.localPosition = tempVector3
end
