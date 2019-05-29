Astrolabe_PointCell = class("Astrolabe_PointCell", BaseCell)
Astrolabe_PointCell.Rid = ResourcePathHelper.UICell("Astrolabe_PointCell")
Astrolabe_PointCell.Point_Mask_Path = ResourcePathHelper.UICell("Astrolabe_PointCell_mask")
Astrolabe_PlateData_Event = {
  ClickPoint = "Astrolabe_PlateData_Event_ClickPoint"
}
Astrolabe_Point_IconMap = {
  [0] = {
    "Rune_Locked_St",
    "Rune_Off_St",
    "Rune_On_St"
  },
  [1] = {
    "Rune_Locked_1",
    "Rune_Off_1",
    "Rune_On_1"
  },
  [2] = {
    "Rune_Locked_2",
    "Rune_Off_2",
    "Rune_On_2"
  },
  [3] = {
    "Rune_Locked_3",
    "Rune_Off_3",
    "Rune_On_3"
  },
  [4] = {
    "Rune_Locked_4",
    "Rune_Off_4",
    "Rune_On_4"
  },
  [5] = {
    "Rune_Locked_5",
    "Rune_Off_5",
    "Rune_On_5"
  },
  [6] = {
    "Rune_Locked_6",
    "Rune_Off_6",
    "Rune_On_6"
  }
}
local isRunOnEditor = ApplicationInfo.IsRunOnEditor()
local PropNameConfig = Game.Config_PropName
local tempV3 = LuaVector3()
function Astrolabe_PointCell:ctor()
  self.gameObject = Game.AssetManager_UI:CreateAstrolabeAsset(Astrolabe_PointCell.Rid)
  self.trans = self.gameObject.transform
  self.bg = self.gameObject:GetComponent(UISprite)
  self.attriGO = self:FindGO("AttriTip")
  self.attrilabel = self.attriGO:GetComponent(UILabel)
  self.attriGO_Active = false
  self:AddClickEvent(self.gameObject, function()
    if self.data == nil then
      return
    end
    self:PassEvent(Astrolabe_PlateData_Event.ClickPoint, self)
  end, {hideClickSound = true})
end
local _CheckValid = function(data, priStateMap, bordData)
  local innerConnect = data:GetInnerConnect()
  local connectId, guid, pointData, nearState
  for i = 1, #innerConnect do
    connectId = innerConnect[i]
    guid = data.plateid * 10000 + connectId
    nearState = priStateMap[guid]
    if nearState == nil then
      pointData = bordData:GetPointByGuid(guid)
      nearState = pointData:GetState()
    end
    if nearState == Astrolabe_PointData_State.On then
      return true
    end
  end
  return false
end
local _GetPointState = function(data, priStateMap, bordData)
  local guid = data.guid
  local state = priStateMap and priStateMap[guid]
  if state then
    return state
  end
  state = data:GetState()
  if state == Astrolabe_PointData_State.Off and priStateMap and next(priStateMap) and _CheckValid(data, priStateMap, bordData) then
    state = Astrolabe_PointData_State.Lock
  end
  return state
end
function Astrolabe_PointCell:SetData(data, priStateMap, bordData)
  self.data = data
  if self.data == nil then
    return
  end
  tempV3:Set(data:GetLocalPos_XYZ())
  self.trans.localPosition = tempV3
  if isRunOnEditor then
    self.gameObject.name = "Point_" .. data.id
  end
  local index = data:GetIconIndex()
  local state = _GetPointState(data, priStateMap, bordData)
  local spName = Astrolabe_Point_IconMap[index][state]
  if spName ~= self.bg.spriteName then
    self.bg.spriteName = spName
  end
  self.bg:MakePixelPerfect()
  self.attri_dirty = true
  self:UpdateEffect()
end
local PointMask_SpriteName = {
  [1] = "xingpan_bg_chongzhi",
  [2] = "xingpan_bg_jihuo2",
  [3] = "xingpan_bg_jihuo",
  [4] = "xingpan_bg_save",
  [5] = "xingpan_bg_new"
}
local Special_PointMask_SpriteName = {
  [1] = "xingpan_bg_chongzhib",
  [2] = "xingpan_bg_jihuo2b",
  [3] = "xingpan_bg_jihuob",
  [4] = "xingpan_bg_saveb",
  [5] = "xingpan_bg_newb"
}
function Astrolabe_PointCell:SetMaskType(type)
  if self.data and self.data.guid == Astrolabe_Origin_PointID then
    return
  end
  if type == nil then
    self:RemoveMask()
    return
  end
  if self.data:IsActive() and (type == 2 or type == 3) then
    return
  end
  if PointMask_SpriteName[type] then
    if self.mask == nil then
      local mask = Game.AssetManager_UI:CreateAstrolabeAsset(self.Point_Mask_Path, self.trans)
      mask.transform.localPosition = LuaGeometry.Const_V3_zero
      mask.transform.localRotation = LuaGeometry.Const_Qua_identity
      mask.transform.localScale = LuaGeometry.Const_V3_one
      self.mask = mask:GetComponent(UISprite)
    end
    local index = self.data:GetIconIndex()
    if index == 0 or index == 5 or index == 6 then
      self.mask.spriteName = Special_PointMask_SpriteName[type]
    else
      self.mask.spriteName = PointMask_SpriteName[type]
    end
    self.mask:MakePixelPerfect()
  else
    self:RemoveMask()
  end
end
function Astrolabe_PointCell:RemoveMask()
  if self.mask then
    Game.GOLuaPoolManager:AddToAstrolabePool(self.Point_Mask_Path, self.mask.gameObject)
  end
  self.mask = nil
end
function Astrolabe_PointCell:UpdateEffect()
  if not self.attriGO_Active then
    return
  end
  if not self.attri_dirty then
    return
  end
  self.attri_dirty = false
  local data = self.data
  local effect = data:GetEffect()
  if effect then
    local str = ""
    for attriType, value in pairs(effect) do
      local config = PropNameConfig[attriType]
      if config ~= nil then
        local displayName = config.RuneName ~= "" and config.RuneName or config.PropName
        str = str .. displayName
        if value > 0 then
          str = str .. " +"
        end
        if config.IsPercent == 1 then
          str = str .. value * 100 .. "%"
        else
          str = str .. value
        end
      else
        redlog("Canot Find Attri" .. attriType .. " ID:" .. data.guid)
      end
    end
    self.attrilabel.text = str
  else
    self.attrilabel.text = ""
  end
end
function Astrolabe_PointCell:ActiveAttriInfo(b)
  if b == self.attriGO_Active then
    return
  end
  self.attriGO_Active = b
  if b then
    self:UpdateEffect()
  end
  self.attriGO:SetActive(b)
end
function Astrolabe_PointCell:IsClickMe(obj)
  if obj == self.gameObject then
    return true
  end
  return false
end
function Astrolabe_PointCell:OnAdd(parent)
  self.trans:SetParent(parent.transform, false)
  self.bg:ParentHasChanged()
  self.trans.localScale = LuaGeometry.Const_V3_one
end
function Astrolabe_PointCell:OnRemove()
  self:RemoveMask()
  AstrolabeCellPool.Instance:AddToTempPool(self.gameObject)
end
function Astrolabe_PointCell:OnDestroy()
  Game.GOLuaPoolManager:AddToAstrolabePool(Astrolabe_PointCell.Rid, self.gameObject)
end
