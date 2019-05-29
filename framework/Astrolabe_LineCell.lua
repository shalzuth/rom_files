Astrolabe_LineCell = class("Astrolabe_LineCell", BaseCell)
local Line_Path = ResourcePathHelper.UICell("Astrolabe_line")
local Line_Mask_Path = ResourcePathHelper.UICell("Astrolabe_line_mask")
local tempV3_1, tempV3_2 = LuaVector3(), LuaVector3()
local tempRot = LuaQuaternion()
function Astrolabe_LineCell:ctor()
  self.gameObject = Game.AssetManager_UI:CreateAstrolabeAsset(Line_Path)
  self.transform = self.gameObject.transform
  self.transform.localScale = LuaGeometry.Const_V3_one
  self.line = self.gameObject:GetComponent(UISprite)
end
function Astrolabe_LineCell:ReSetPos(p1_x, p1_y, p1_z, p2_x, p2_y, p2_z)
  tempV3_1:Set(p1_x, p1_y, p1_z)
  tempV3_2:Set(p2_x, p2_y, p2_z)
  self.transform.localPosition = tempV3_1
  self:SetSize(LuaVector3.Distance(tempV3_1, tempV3_2))
  local x, y, z = tempV3_1[1], tempV3_1[2], tempV3_1[3]
  tempV3_1:Set(tempV3_2[1] - x, tempV3_2[2] - y, tempV3_2[3] - z)
  tempV3_2:Set(1, 0, 0)
  local angle = LuaVector3.Angle(tempV3_2, tempV3_1)
  if not (0 < tempV3_1.y) or not angle then
    angle = -angle
  end
  tempV3_1:Set(0, 0, angle)
  tempRot.eulerAngles = tempV3_1
  self.transform.localRotation = tempRot
end
function Astrolabe_LineCell:SetData(point1, point2, priStateMap)
  if point1 and point2 then
    self.point1 = point1
    self.point2 = point2
    local p1_state = priStateMap and priStateMap[point1.guid]
    local p2_state = priStateMap and priStateMap[point2.guid]
    if p1_state == nil then
      p1_state = point1:GetState()
    end
    if p2_state == nil then
      p2_state = point2:GetState()
    end
    if p1_state == Astrolabe_PointData_State.On and p2_state == Astrolabe_PointData_State.On then
      if self.line.spriteName ~= "xingpan_line_light" then
        self.line.spriteName = "xingpan_line_light"
        self.line.height = 22
      end
    elseif self.line.spriteName ~= "xingpan_line_dack" then
      self.line.spriteName = "xingpan_line_dack"
      self.line.height = 12
    end
  end
end
function Astrolabe_LineCell:SetSprite(name)
  self.line.sprinteName = name
end
function Astrolabe_LineCell:SetSize(w, h)
  if w then
    self.line.width = w
    if self.mask then
      self.mask.width = w
    end
  end
  if h then
    self.line.height = h
  end
end
local LineMask_SpriteName = {
  [1] = "xingpan_line_chongzhi",
  [2] = "xingpan_line_jihuo2",
  [3] = "xingpan_line_jihuo1",
  [4] = "xingpan_line_save",
  [5] = "xingpan_line_new"
}
function Astrolabe_LineCell:SetMaskType(type)
  if type == nil then
    self:RemoveMask()
    return
  end
  local sp = LineMask_SpriteName[type]
  if sp == nil then
    self:RemoveMask()
    return
  end
  if self.maskGO == nil then
    self.maskGO = Game.AssetManager_UI:CreateAstrolabeAsset(Line_Mask_Path, self.transform)
    local maskTrans = self.maskGO.transform
    maskTrans.localPosition = LuaGeometry.Const_V3_zero
    maskTrans.localRotation = LuaGeometry.Const_Qua_identity
    maskTrans.localScale = LuaGeometry.Const_V3_one
    self.mask = self.maskGO:GetComponent(UISprite)
  end
  if sp ~= self.mask.spriteName then
    self.mask.spriteName = sp
  end
  self.mask.width = self.line.width
end
function Astrolabe_LineCell:RemoveMask()
  if self.maskGO then
    Game.GOLuaPoolManager:AddToAstrolabePool(Line_Mask_Path, self.maskGO)
  end
  self.maskGO = nil
  self.mask = nil
end
function Astrolabe_LineCell:OnAdd(parent)
  self.transform:SetParent(parent.transform, false)
  self.transform.localScale = LuaGeometry.Const_V3_one
  self.line:ParentHasChanged()
end
function Astrolabe_LineCell:OnRemove()
  self.point1 = nil
  self.point2 = nil
  AstrolabeCellPool.Instance:AddToTempPool(self.gameObject)
end
function Astrolabe_LineCell:OnDestroy()
  self.point1 = nil
  self.point2 = nil
  self:RemoveMask()
  Game.GOLuaPoolManager:AddToAstrolabePool(Line_Path, self.gameObject)
end
