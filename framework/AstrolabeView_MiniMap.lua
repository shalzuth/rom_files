local uiCamera
local tempV3 = LuaVector3()
function AstrolabeView:InitMiniMap()
  uiCamera = NGUIUtil:GetCameraByLayername("UI")
  self.miniMap = self:FindGO("MiniMap")
  self.screen = self:FindComponent("ScreenView", UISprite, self.miniMap)
  self.mapTexture = self:FindComponent("Map", UITexture, self.miniMap)
  self.mapSize = {
    self.mapTexture.width,
    self.mapTexture.height
  }
  self.mapScale = 9500 / self.mapSize[1]
  self:AddClickEvent(self.mapTexture.gameObject, function()
    self:ClickMiniMap()
  end)
  self.scaleButton = self:FindGO("ScaleButton")
  self.scaleButton_Symbol = self:FindComponent("Symbol", UISprite, self.scaleButton)
  self:AddClickEvent(self.scaleButton, function(go)
    if self.islarge then
      self:ZoomScrollView(Astrolabe_PlateZoom_Param, 0.4, function()
        self.islarge = false
        self.scaleButton_Symbol.spriteName = "com_btn_enlarge"
        if self.isAttriInfoActive then
          self:ActiveAttriInfo(false)
        end
        self:UpdateMiniMapSize()
      end)
    else
      self:ZoomScrollView(1, 0.4, function()
        self.islarge = true
        self.scaleButton_Symbol.spriteName = "com_btn_narrow"
        self:UpdateMiniMapSize()
      end)
    end
  end)
  self.islarge = true
  self:UpdateMiniMapSize()
  self.miniMapEffectContainer = self:FindGO("MiniMapEffectContainer", self.miniMap)
  self.screenView:AddEventListener(Astrolabe_ScreenView_Event.PanelMove, self.RefreshMiniMap, self)
end
function AstrolabeView:UpdateMiniMapSize()
  if self.islarge then
    self.screen.width = 1280 / self.mapScale * 2
    self.screen.height = 720 / self.mapScale * 2
  else
    self.screen.width = 1280 / (self.mapScale * Astrolabe_PlateZoom_Param) * 2
    self.screen.height = 720 / (self.mapScale * Astrolabe_PlateZoom_Param) * 2
  end
end
function AstrolabeView:ClickMiniMap()
  local inputWorldPos = uiCamera:ScreenToWorldPoint(Input.mousePosition)
  local x, y, z = LuaGameObject.InverseTransformPointByVector3(self.mapTexture.transform, inputWorldPos)
  self:CenterOnLocalPos(self:Pos_MiniMap2Map(x, y, z))
end
function AstrolabeView:Pos_MiniMap2Map(x, y, z)
  return x * self.mapScale, y * self.mapScale, z * self.mapScale
end
function AstrolabeView:Pos_Map2MiniMap(x, y, z)
  return x / self.mapScale, y / self.mapScale, z / self.mapScale
end
function AstrolabeView:RefreshMiniMap()
  local centerPos = self:GetNowLocalCenter()
  local x, y, z = self:Pos_Map2MiniMap(centerPos[1], centerPos[2], centerPos[3])
  tempV3:Set(x, y, z)
  self.screen.transform.localPosition = tempV3
end
local SearchPointCellPath = ResourcePathHelper.UICell("AstrolabeView_SPEffect_MiniMap")
function AstrolabeView:AddMiniMapSearchPointEffect(point)
  if self.miniMapSearchPointEffectMap == nil then
    self.miniMapSearchPointEffectMap = {}
  end
  local effect = self.miniMapSearchPointEffectMap[point.guid]
  if effect == nil then
    effect = self:LoadPreferb_ByFullPath(SearchPointCellPath, self.miniMapEffectContainer)
    self.miniMapSearchPointEffectMap[point.guid] = effect
    tempV3:Set(self:Pos_Map2MiniMap(point:GetWorldPos_XYZ()))
    effect.transform.localPosition = tempV3
  end
end
function AstrolabeView:ClearMiniMapSearchPointEffect()
  if self.miniMapSearchPointEffectMap == nil then
    return
  end
  for id, effectGO in pairs(self.miniMapSearchPointEffectMap) do
    if not Slua.IsNull(effectGO) then
      GameObject.Destroy(effectGO)
    end
  end
  self.miniMapSearchPointEffectMap = {}
end
