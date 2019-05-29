StageView = class("StageView", ContainerView)
StageView.ViewType = UIViewType.InterstitialLayer
autoImport("PhotographSingleFilterText")
autoImport("SceneRoleTopSymbol")
autoImport("StageCombineItemCell")
autoImport("StageItemNormalList")
StageView.FOCUS_VIEW_PORT_RANGE = {
  x = {0.1, 0.9},
  y = {0.1, 0.9}
}
StageView.NEAR_FOCUS_DISTANCE = GameConfig.PhotographPanel and GameConfig.PhotographPanel.Near_Focus_Distance or 15
StageView.FAR_FOCUS_DISTANCE = GameConfig.PhotographPanel and GameConfig.PhotographPanel.Far_Focus_Distance or 40
StageView.ChangeCompositionDuration = 0.3
local PHOTOGRAPHER_StickArea = Rect(0, 0, 1, 1)
StageView.filterType = {
  Text = 1,
  Faction = 2,
  Team = 3,
  All = 4
}
StageView.DefaultMode = {SELFIE = 1, PHOTOGRAPHER = 2}
StageView.TickType = {
  Zoom = 1,
  CheckFocus = 4,
  CheckIfHasFocusCreature = 3,
  CheckAnim = 5,
  UpdateAxis = 2,
  Showtime = 6
}
StageView.FocusStatus = {
  Fit = 1,
  Less = 2,
  FarMore = 3
}
StageView.PhotographMode = {SELFIE = 1, PHOTOGRAPHER = 2}
StageView.filters = {
  {
    id = GameConfig.FilterType.PhotoFilter.Self
  },
  {
    id = GameConfig.FilterType.PhotoFilter.Team
  },
  {
    id = GameConfig.FilterType.PhotoFilter.Guild
  },
  {
    id = GameConfig.FilterType.PhotoFilter.PassBy
  },
  {
    id = GameConfig.FilterType.PhotoFilter.Monster
  },
  {
    id = GameConfig.FilterType.PhotoFilter.Npc
  },
  {
    id = GameConfig.FilterType.PhotoFilter.Text
  },
  {
    id = FunctionSceneFilter.AllEffectFilter,
    text = ZhString.PhotoFilter_Effect
  },
  {id = 29}
}
StageView.TabName = {
  [1] = ZhString.StageView_EquipTabName,
  [2] = ZhString.StageView_FashionTabName
}
local tempVector3 = LuaVector3.zero
local tempArray = {}
function StageView:Init()
  StageProxy.Instance:InitStageData()
  self.compositionIndex = 1
  self:initView()
  self:initData()
  self:addEventListener()
end
function StageView:changeTakeTypeBtnView()
  if self.curPhotoMode == StageView.PhotographMode.SELFIE then
    self:Show(self.takeTypeBtn)
  else
    self:Hide(self.takeTypeBtn)
  end
end
function StageView:changeCameraDisView()
  if self.curPhotoMode == StageView.PhotographMode.SELFIE then
    self:Show(self.disScrollBar)
  else
  end
end
function StageView:initView()
  local filtersBg = self:FindChild("filterContentBg"):GetComponent(UISprite)
  filtersBg.height = 49.15 * #StageView.filters + 16
  filtersBg.width = 240
  filtersBg.transform.localPosition = Vector3(-200, -69, 0)
  local girdView = self:FindChild("Grid"):GetComponent(UIGrid)
  self.filterGridList = UIGridListCtrl.new(girdView, PhotographSingleFilterText, "PhotographSingleFilterText")
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self.filterGridList:AddEventListener(MouseEvent.MouseClick, self.filterCellClick, self)
  self.filterGridList:ResetDatas(StageView.filters)
  self.filterBtn = self:FindChild("filterBtn")
  self.quitBtn = self:FindChild("quitBtn")
  self.takePicBtn = self:FindChild("takePicBtn")
  self.fovScrollBar = self:FindChild("FovScrollBar")
  self.fovScrollBarCpt = self:FindGO("BackGround", self.fovScrollBar):GetComponent(UICustomScrollBar)
  self.disScrollBar = self:FindChild("DisScrollBar")
  self.disScrollBarCpt = self:FindGO("BackGround", self.disScrollBar):GetComponent(UICustomScrollBar)
  self.turnRightBtn = self:FindChild("turnRightBtn")
  self.turnLeftBtn = self:FindChild("turnLeftBtn")
  self.focusFrame = self:FindGO("focusFrame")
  self.playRotating = self.focusFrame:GetComponent(BoxCollider)
  self.photographResult = self:FindChild("photographResult")
  self.whiteMask = self:FindChild("whiteMask")
  self.focalLen = self:FindGO("focalLen")
  self.focalLenLabel = self:FindGO("Label", self.focalLen):GetComponent(UILabel)
  self.cameraDis = self:FindGO("Distance")
  self.cameraDisLabel = self:FindGO("Label", self.cameraDis):GetComponent(UILabel)
  self:Hide(self.cameraDis)
  self.boliSp = self:FindComponent("boli", UISprite)
  self:AddButtonEvent("filterBtn", nil)
  self.takeTypeBtn = self:FindGO("takeTypeBtn")
  self.itemBord = self:FindGO("StageItemNormalList")
  self.itemlist = StageItemNormalList.new(self.itemBord, StageCombineItemCell)
  self.equibTab = self:FindGO("EquibTab")
  self:AddTabChangeEvent(self.equibTab, self.itemBord, PanelConfig.StageView)
  self.itemlist:InitTabList()
  self.equibTabIconSp = self:FindGO("Icon", self.equibTab):GetComponent(UISprite)
  local equibTabLabel = self:FindGO("Label", self.equibTab)
  self.fashionTab = self:FindGO("FashionTab")
  self:AddTabChangeEvent(self.fashionTab, self.itemBord, PanelConfig.StageOutfit)
  self.fashionTabIconSp = self:FindGO("Icon", self.fashionTab):GetComponent(UISprite)
  local fashionTabLabel = self:FindGO("Label", self.fashionTab)
  local fashionTabLbl = self:FindGO("Label", fashionTab):GetComponent(UILabel)
  fashionTabLbl.text = ZhString.Oversea_Pfb_StageView_Label1
  self.themeButton = self:FindGO("ThemeButton")
  self:AddClickEvent(self.themeButton, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.StageStyleView
    })
  end)
  self.emojiButton = self:FindGO("EmojiButton")
  self.fadeInOutSymbol = self:FindGO("fadeInOutSymbol"):GetComponent(UISprite)
  self.tweenParent = self:FindGO("GridView"):GetComponent(TweenPosition)
  self.tweenParent:PlayReverse()
  self.fadeInOutBtn = self:FindGO("fadeInOutSymbol")
  self.nextToggle = true
  self:AddClickEvent(self.fadeInOutBtn, function(go)
    if not self.nextToggle then
      self.tweenParent:PlayReverse()
      self.fadeInOutSymbol.flip = 1
    else
      self.tweenParent:PlayForward()
      self.fadeInOutSymbol.flip = 0
    end
    self.nextToggle = not self.nextToggle
  end)
  self.chatRoot = self:FindGO("ChatRoomBtn")
  self.hideableRoot = self:FindGO("Hideable")
  self:SetMyDirection()
  self.beginTime = ServerTime.CurServerTime()
  self.countDown = self:FindGO("Timing"):GetComponent(UILabel)
  self:AddListenEvt(ServiceEvent.NUserQueryStageUserCmd, self.ResetShowtime)
  if not self.timeTick then
    TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountDown, self, StageView.TickType.Showtime)
  end
  self.isShowStageView = true
  self:ShowStageView()
  local iconActive, nameLabelActive
  if not GameConfig.SystemForbid.TabNameTip then
    iconActive = true
    nameLabelActive = false
  else
    iconActive = false
    nameLabelActive = true
  end
  self.equibTabIconSp.gameObject:SetActive(iconActive)
  self.fashionTabIconSp.gameObject:SetActive(iconActive)
  equibTabLabel:SetActive(nameLabelActive)
  fashionTabLabel:SetActive(nameLabelActive)
end
local stagedir = GameConfig.DressUp.stagedir
function StageView:SetMyDirection()
  local currentstage = StageProxy.Instance:GetCurrentStageid()
  if stagedir[currentstage] and stagedir[currentstage].dir then
    Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, stagedir[currentstage].dir, true)
  end
end
function StageView:initData()
  FunctionCameraEffect.Me():Pause()
  self.cameraController = CameraController.Instance
  if not self.cameraController then
    LeanTween.cancel(self.gameObject)
    LeanTween.delayedCall(self.gameObject, 0.1, function()
      self:CloseSelf()
    end)
    return
  end
  self.channelNames = ChatRoomProxy.Instance.channelNames
  Game.AreaTriggerManager:SetIgnore(true)
  self:changeTurnBtnState(false)
  self.focusSuccess = false
  self.isShowFocalLen = false
  self.hasNotifyServer = false
  self.charid = nil
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
  self.uiCm = NGUIUtil:GetCameraByLayername("SceneUI")
  self:initCameraData()
  TimeTickManager.Me():CreateTick(0, 100, self.updateScrollBar, self, StageView.TickType.Zoom)
end
function StageView:calFOVValue(zoom)
  local value = 2 * math.atan(21.635 / zoom) * 180 / math.pi
  return value
end
function StageView:calZoom(del)
  local value = 21.635 / math.tan(del / 2 / 180 * math.pi)
  return value
end
function StageView:SetCompositionIndex(index)
  self.compositionIndex = index
end
function StageView:MoveCompositionIndexToNext()
  local index = self.compositionIndex + 1
  if nil == self:GetComposition(index) then
    index = 1
  end
  MsgManager.ShowMsgByIDTable(853, tostring(index))
  self:SetCompositionIndex(index)
end
function StageView:GetComposition(index)
  index = index or self.compositionIndex
  if nil == self.cameraData or nil == self.cameraData.Composition then
    return nil
  end
  return self.cameraData.Composition[index]
end
function StageView:ApplyComposition()
  local composition = self:GetComposition()
  if nil == composition then
    return
  end
  if nil == self.cameraController then
    return
  end
  local fo = self.cameraController.targetFocusOffset
  local fvp = self.cameraController.targetFocusViewPort
  fvp.x = composition[1]
  fvp.y = composition[2]
  self.cameraController:FocusTo(fo, fvp, StageView.ChangeCompositionDuration, nil)
end
function StageView:initCameraData()
  self.originFovMin = nil
  self.originFovMax = nil
  self.originAllowLowerThanFocus = nil
  local currentstage = StageProxy.Instance:GetCurrentStageid()
  local cameraconfig = GameConfig.StageConfig[currentstage]
  if cameraconfig then
    self.cameraId = cameraconfig.cameraid
  else
    self.cameraId = 12
  end
  self.cameraData = Table_Camera[self.cameraId]
  if not self.cameraData or not self.cameraController then
    return
  end
  local layer = LayerMask.NameToLayer("UI")
  if layer then
    self.uiCemera = UICamera.FindCameraForLayer(layer)
    if self.uiCemera then
      self.originUiCmTouchDragThreshold = self.uiCemera.touchDragThreshold
      self.uiCemera.touchDragThreshold = 1
    end
  end
  self.originInputTouchSenseInch = Game.InputManager.touchSenseInch
  Game.InputManager.touchSenseInch = 0
  Game.InputManager:ResetParams()
  Game.InputManager.model = InputManager.Model.PHOTOGRAPH
  self.originNearClipPlane = self.cameraController.activeCamera.nearClipPlane
  self.originFarClipPlane = self.cameraController.activeCamera.farClipPlane
  self.cameraController.activeCamera.nearClipPlane = self.cameraData.ClippingPlanes[1]
  self.cameraController.activeCamera.farClipPlane = self.cameraData.ClippingPlanes[2]
  self.originAllowLowerThanFocus = self.cameraController.allowLowerThanFocus
  if self.cameraData.Y_Limit == 1 then
    self.cameraController.allowLowerThanFocus = false
  elseif self.cameraData.Y_Limit == 0 then
    self.cameraController.allowLowerThanFocus = true
  end
  self.originFovMin = Game.InputManager.cameraFieldOfViewMin
  self.originFovMax = Game.InputManager.cameraFieldOfViewMax
  self.fovMin = self.fovMin and self.fovMin or self.cameraData.Zoom[1]
  self.fovMax = self.fovMax and self.fovMax or self.cameraData.Zoom[2]
  self.fovMinValue = self:calFOVValue(self.fovMax)
  self.fovMaxValue = self:calFOVValue(self.fovMin)
  Game.InputManager.cameraFieldOfViewMin = self.fovMinValue
  Game.InputManager.cameraFieldOfViewMax = self.fovMaxValue
  local close = self.cameraData.Close
  if close ~= 1 then
    self:Hide(self.quitBtn)
    self.forbiddenClose = true
  else
    self:Show(self.quitBtn)
  end
  local switchBtn = self:FindGO("modeSwitch")
  self:SetCompositionIndex(1)
  local pgInfo = self.cameraController.photographInfo
  if pgInfo then
    self.originFocusViewPort = pgInfo.focusViewPort
    local composition = self:GetComposition()
    if nil ~= composition then
      tempVector3:Set(composition[1], composition[2], self.cameraData.Radius)
    else
      tempVector3:Set(self.originFocusViewPort.x, self.originFocusViewPort.y, self.cameraData.Radius)
    end
    pgInfo.focusViewPort = tempVector3
    local defaultZoom = self.cameraData.DefaultZoom
    if defaultZoom then
      self.originFieldOfView = pgInfo.fieldOfView
      local fieldOfView = self:calFOVValue(defaultZoom)
      pgInfo.fieldOfView = fieldOfView
    end
  end
  local defaultDir = self.cameraData.DefaultDir
  if #defaultDir == 0 then
    if not self.forceRotation then
      self.forceRotation = LuaVector3.zero
    end
    self.forceRotation = LuaVector3(defaultDir[1], defaultDir[2], defaultDir[3])
  end
  local defaultRoleDir = self.cameraData.DefaultRoleDir
  if defaultRoleDir and #defaultRoleDir ~= 0 then
    local x, y, z = Game.Myself.assetRole:GetEulerAnglesXYZ()
    local cx = defaultRoleDir[1] or 0
    local cy = defaultRoleDir[2] or 0
    local cz = defaultRoleDir[3] or 0
    x = x + cx
    y = y + cy
    z = z + cz
    self.forceRotation = LuaVector3(0, y, z)
  end
  self.isNeedSaveSetting = self.cameraData.SaveSetting
  self.isNeedSaveSetting = self.isNeedSaveSetting and self.isNeedSaveSetting ~= 0 or false
  local cells = self.filterGridList:GetCells()
  if self.isNeedSaveSetting then
    local filters = LocalSaveProxy.Instance:getPhotoFilterSetting(cells)
    for j = 1, #cells do
      local single = cells[j]
      local bFilter = filters[single.data.id]
      single:setIsSelect(bFilter)
      if not bFilter then
        self:filterCellClick(single)
      end
    end
  else
    self.defaultHide = self.cameraData.DefaultHide
    if self.defaultHide and 0 < #self.defaultHide then
      for i = 1, #self.defaultHide do
        local fileterItem = self.defaultHide[i]
        for j = 1, #cells do
          local single = cells[j]
          if fileterItem == single.data.id then
            single:setIsSelect(false)
            self:filterCellClick(single)
          end
        end
      end
    end
  end
  self.originStickArea = Game.InputManager.forceJoystickArea
  local StickArea = self.cameraData.StickArea
  if StickArea and #StickArea > 1 and StickArea[1] > 0 and 0 < StickArea[2] then
    self.selfieStickArea = Rect(0, 0, StickArea[1], StickArea[2])
  end
  local defaultMode = self.cameraData.DefaultMode
  if defaultMode == StageView.DefaultMode.PHOTOGRAPHER then
    self:changePhotoMode(StageView.PhotographMode.PHOTOGRAPHER)
  else
    self:changePhotoMode(StageView.PhotographMode.SELFIE)
    LeanTween.delayedCall(self.cameraDis, 1, function()
      self:updateDisScrollBar()
    end)
  end
  local Emoji = self.cameraData.Emoji or 0
  local action = self.cameraData.Act or 0
  self.actEmoj = Emoji * 2 + action
end
local tempLuaQuaternion = LuaQuaternion.identity
function StageView:calFOVByPos()
  local position
  if self.creatureGuid then
    local creatureObj = SceneCreatureProxy.FindCreature(self.creatureGuid)
    if creatureObj then
      local topFocusUI = creatureObj:GetSceneUI().roleTopUI.topFocusUI
      position = topFocusUI:getPosition()
    end
  elseif self.symbol then
    position = self.symbol:getTarPosition()
  end
  if position then
    local cpTransform = Game.Myself.assetRole:GetCPOrRoot(RoleDefines_CP.Hair)
    tempVector3:Set(LuaGameObject.GetPosition(cpTransform))
    LuaVector3.Better_Sub(position, tempVector3, tempVector3)
    LuaQuaternion.Better_LookRotation(tempVector3, LuaVector3.up, tempLuaQuaternion)
    if not self.forceRotation then
      self.forceRotation = LuaVector3.zero
    end
    tempLuaQuaternion:Better_GetEulerAngles(tempVector3)
    self.forceRotation = tempVector3:Clone()
  end
end
function StageView:resetCameraData()
  Game.InputManager.model = InputManager.Model.DEFAULT
  if nil ~= self.cameraController then
    if self.originAllowLowerThanFocus then
      self.cameraController.allowLowerThanFocus = self.originAllowLowerThanFocus
    end
    if self.originNearClipPlane then
      self.cameraController.activeCamera.nearClipPlane = self.originNearClipPlane
      self.cameraController.activeCamera.farClipPlane = self.originFarClipPlane
    end
    if self.originFocusViewPort then
      self.cameraController.photographInfo.focusViewPort = self.originFocusViewPort
    end
    if self.originFieldOfView then
      self.cameraController.photographInfo.fieldOfView = self.originFieldOfView
    end
  end
  if self.originStickArea then
    Game.InputManager.forceJoystickArea = self.originStickArea
  end
  if self.originFovMax then
    Game.InputManager.cameraFieldOfViewMin = self.originFovMin
    Game.InputManager.cameraFieldOfViewMax = self.originFovMax
  end
end
function StageView:changeShowFocalLen(isShow)
  if Slua.IsNull(self.focalLen) then
    return
  end
  local value = self.fovScrollBarCpt.value
  local fieldOfView = (self.fovMax - self.fovMin) * value + self.fovMin
  fieldOfView = math.floor(fieldOfView + 0.5)
  self.focalLenLabel.text = fieldOfView .. "mm"
  if self.isShowFocalLen ~= isShow and self.focalLen then
    self.focalLen:SetActive(isShow)
    self.isShowFocalLen = isShow
    if isShow then
      LeanTween.cancel(self.focalLen)
      LeanTween.delayedCall(self.focalLen, 1, function()
        self.isShowFocalLen = false
      end)
    end
  end
end
function StageView:changeShowDisLen(isShow)
  local value = self.disScrollBarCpt.value
  local cameraDis = 7 * value + 3
  cameraDis = math.floor(cameraDis + 0.5)
  self.cameraDisLabel.text = string.format(ZhString.PhotoCameraDisTip, cameraDis)
  self.boliSp.height = 75 + value * 355
  if self.isShowcameraDisLabel ~= isShow then
    self.cameraDis:SetActive(isShow)
    self.isShowcameraDisLabel = isShow
    if isShow then
      LeanTween.cancel(self.cameraDis)
      LeanTween.delayedCall(self.cameraDis, 1, function()
        self.isShowcameraDisLabel = false
        self:Hide(self.cameraDis)
      end)
    end
  end
end
function StageView:addEventListener()
  self:AddButtonEvent("quitBtn", function(go)
    ServiceNUserProxy.Instance:CallDressUpLineUpUserCmd(nil, nil, false)
    self:sendNotification(UIEvent.CloseUI, UIViewType.ChatLayer)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.takePicBtn, function(go)
    self:takePic()
    AudioUtility.PlayOneShot2D_Path(ResourcePathHelper.AudioSEUI(AudioMap.UI.Picture))
  end)
  self:AddButtonEvent("modeSwitch", function(go)
    if not self.isShowStageView then
      self:ShowStageView()
      self.isShowStageView = true
    else
      self:HideStageView()
      self.isShowStageView = false
    end
  end)
  self:AddClickEvent(self.takeTypeBtn, function(go)
    self:MoveCompositionIndexToNext()
    self:ApplyComposition()
  end)
  self:AddPressEvent(self.focusFrame, function(obj, state)
    self:changeTurnBtnState(state)
  end)
  self:AddDragEvent(self.focusFrame, function(obj, delta)
    local toY = Game.Myself:GetAngleY() - delta.x
    Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, toY, true)
  end)
  EventDelegate.Add(self.fovScrollBarCpt.onChange, function()
    if not self.fovScrollBarCpt.isDragging or self:ObjIsNil(self.cameraController) then
      return
    end
    local value = self.fovScrollBarCpt.value
    local zoom = (self.fovMax - self.fovMin) * value + self.fovMin
    local fieldOfView = self:calFOVValue(zoom)
    self.cameraController:ResetFieldOfView(fieldOfView)
    self:changeShowFocalLen(true)
  end)
  EventDelegate.Add(self.disScrollBarCpt.onChange, function()
    if self:ObjIsNil(self.cameraController) then
      return
    end
    local value = self.disScrollBarCpt.value
    local focusViewPort = self.cameraController.focusViewPort
    local zoom = 7 * value + 3
    redlog("disScrollBar value zoom", value, zoom)
    local port = LuaVector3(focusViewPort.x, focusViewPort.y, zoom)
    self.cameraController:ResetFocusViewPort(port)
    self:changeShowDisLen(true)
  end)
  self:AddClickEvent(self.emojiButton, function(go)
    if not self.isEmojiShow then
      self.isEmojiShow = true
      local forbidAction = self.actEmoj
      if self.actEmoj == 1 and self.curPhotoMode == StageView.PhotographMode.PHOTOGRAPHER then
        forbidAction = 0
      elseif self.actEmoj == 3 and self.curPhotoMode == StageView.PhotographMode.PHOTOGRAPHER then
        forbidAction = 1
      end
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ChatEmojiView,
        viewdata = {state = forbidAction},
        force = true
      })
    else
      self.isEmojiShow = false
      self:sendNotification(UIEvent.CloseUI, UIViewType.ChatLayer)
    end
  end)
  self:AddClickEvent(self.chatRoot, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChatRoomPage,
      force = true
    })
  end)
  self:AddListenEvt(StageEvent.ChangeCountDown, self.UpdateMyCountdown, self)
  self.tabList = {
    self.equibTab,
    self.fashionTab
  }
  for i, v in ipairs(self.tabList) do
    do
      local longPress = v:GetComponent(UILongPress)
      function longPress.pressEvent(obj, state)
        self:PassEvent(TipLongPressEvent.StageView, {state, i})
      end
    end
    break
  end
  self:AddEventListener(TipLongPressEvent.StageView, self.HandleLongPress, self)
end
function StageView:updateScrollBar()
  if self.fovScrollBarCpt.isDragging or self:ObjIsNil(self.cameraController) then
    return
  end
  if Slua.IsNull(self.fovScrollBarCpt) then
    return
  end
  local fieldOfView = self.cameraController.cameraFieldOfView
  fieldOfView = Mathf.Clamp(fieldOfView, self.fovMinValue, self.fovMaxValue)
  local fov = self:calZoom(fieldOfView)
  local sclValue = (fov - self.fovMin) / (self.fovMax - self.fovMin)
  sclValue = math.floor(sclValue * 100 + 0.5) / 100
  local barCptValue = math.floor(self.fovScrollBarCpt.value * 100 + 0.5) / 100
  if sclValue ~= barCptValue then
    self.fovScrollBarCpt.value = sclValue
    self:changeShowFocalLen(true)
  end
end
function StageView:updateDisScrollBar()
  if self.disScrollBarCpt.isDragging or self:ObjIsNil(self.cameraController) then
    return
  end
  local dis = self.cameraController.focusViewPort.z
  local sclValue = (dis - 3) / 7
  sclValue = math.floor(sclValue * 100 + 0.5) / 100
  local barCptValue = math.floor(self.disScrollBarCpt.value * 100 + 0.5) / 100
  if sclValue ~= barCptValue then
    self.disScrollBarCpt.value = sclValue
    self:changeShowDisLen(true)
  end
end
function StageView:changeTurnBtnState(visible)
  self.turnRightBtn:SetActive(visible)
  self.turnLeftBtn:SetActive(visible)
end
function StageView:OnEnter()
  FunctionPhoto.Me():Launch()
  self:TabChangeHandler(1)
  EventManager.Me():AddEventListener(StageEvent.CloseStageUI, self.HandleClose, self)
end
function StageView:OnExit()
  FunctionPhoto.Me():ShutDown()
  TimeTickManager.Me():ClearTick(self)
  self.needCheckReady = false
  self.focusSuccess = false
  FunctionSceneFilter.Me():EndFilter(GameConfig.FilterType.PhotoFilter)
  FunctionSceneFilter.Me():EndFilter(FunctionSceneFilter.AllEffectFilter)
  FunctionSceneFilter.Me():EndFilter(29)
  if self.defaultHide then
    for i = 1, #self.defaultHide do
      local fileterItem = self.defaultHide[i]
      FunctionSceneFilter.Me():EndFilter(fileterItem)
    end
  end
  if self.cameraAxisY then
    Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, self.cameraAxisY)
  end
  Game.AreaTriggerManager:SetIgnore(false)
  if self.chatroomShow then
    self:sendNotification(UIEvent.CloseUI, UIViewType.ChatLayer)
  end
  ServiceNUserProxy.Instance:CallStateChange(ProtoCommon_pb.ECREATURESTATUS_MIN)
  self.super.OnExit(self)
  FunctionCameraEffect.Me():Resume()
  self:resetCameraData()
  FunctionBarrage.Me():ShutDown()
  if self.isNeedSaveSetting then
    local cells = self.filterGridList:GetCells()
    local list = ReusableTable.CreateTable()
    for j = 1, #cells do
      local single = cells[j]
      local data = {}
      data.id = single.data.id
      data.isSelect = single:getIsSelect()
      table.insert(list, data)
    end
    LocalSaveProxy.Instance:savePhotoFilterSetting(list)
    ReusableTable.DestroyAndClearTable(list)
  end
  if self.uiCemera then
    self.uiCemera.touchDragThreshold = self.originUiCmTouchDragThreshold
  end
  if self.originInputTouchSenseInch then
    Game.InputManager.touchSenseInch = self.originInputTouchSenseInch
    Game.InputManager:ResetParams()
  end
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
  EventManager.Me():RemoveEventListener(StageEvent.CloseStageUI, self.HandleClose, self)
end
function StageView:HandleClose()
  self:CloseSelf()
end
function StageView:filterCellClick(obj)
  local isSelect = obj:getIsSelect()
  local id = obj.data.id
  if not isSelect then
    FunctionSceneFilter.Me():StartFilter(id)
    if (id == GameConfig.FilterType.PhotoFilter.Guild or id == GameConfig.FilterType.PhotoFilter.Team) and FunctionSceneFilter.Me():IsFilterBy(GameConfig.FilterType.PhotoFilter.Guild) and FunctionSceneFilter.Me():IsFilterBy(GameConfig.FilterType.PhotoFilter.Team) then
      FunctionSceneFilter.Me():StartFilter(GameConfig.FilterType.PhotoFilter.TeamAndGuild)
    end
  else
    FunctionSceneFilter.Me():EndFilter(id)
    if id == GameConfig.FilterType.PhotoFilter.Guild or id == GameConfig.FilterType.PhotoFilter.Team then
      FunctionSceneFilter.Me():EndFilter(GameConfig.FilterType.PhotoFilter.TeamAndGuild)
    end
  end
end
function StageView:setPhotoResultVisible(state)
  self.photographResult:SetActive(state)
end
function StageView:preTakePic()
  local selfPos = Game.Myself:GetPosition()
  if self.curPhotoMode == StageView.PhotographMode.PHOTOGRAPHER then
    ServiceNUserProxy.Instance:CallPhoto(Game.Myself.data.id)
  end
  ResourceManager.Instance:GC()
  MyLuaSrv.Instance:LuaManualGC()
end
function StageView:takePic()
  self:preTakePic()
  local gmCm = NGUIUtil:GetCameraByLayername("Default")
  local bgCm = NGUIUtil:GetCameraByLayername("SceneUIBackground")
  local uiBgCm = NGUIUtil:GetCameraByLayername("UIBackground")
  local _, _, anglez = LuaGameObject.GetEulerAngles(gmCm.transform)
  anglez = GeometryUtils.UniformAngle(anglez)
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self.screenShotHelper:Setting(self.screenShotWidth, self.screenShotHeight, self.textureFormat, self.texDepth, self.antiAliasing)
  if self.textInvisible then
    self.screenShotHelper:GetScreenShot(function(texture)
      local viewdata
      if self.focusSuccess then
        viewdata = {
          charid = self.charid,
          forbiddenClose = self.forbiddenClose,
          viewname = "PhotographResultPanel",
          anglez = anglez,
          cameraData = self.cameraData,
          questData = self.questData,
          texture = texture,
          arg = self.focalLenLabel.text,
          scenicSpotID = self.scenicSpotID,
          isFromStageView = true
        }
      else
        viewdata = {
          charid = self.charid,
          forbiddenClose = self.forbiddenClose,
          viewname = "PhotographResultPanel",
          anglez = anglez,
          cameraData = self.cameraData,
          texture = texture,
          arg = self.focalLenLabel.text,
          isFromStageView = true
        }
      end
      self:sendNotification(UIEvent.ShowUI, viewdata)
    end, bgCm, uiBgCm, gmCm)
  else
    self.screenShotHelper:GetScreenShot(function(texture)
      local viewdata
      if self.focusSuccess then
        viewdata = {
          charid = self.charid,
          forbiddenClose = self.forbiddenClose,
          viewname = "PhotographResultPanel",
          anglez = anglez,
          cameraData = self.cameraData,
          questData = self.questData,
          texture = texture,
          arg = self.focalLenLabel.text,
          scenicSpotID = self.scenicSpotID,
          isFromStageView = true
        }
      else
        viewdata = {
          charid = self.charid,
          forbiddenClose = self.forbiddenClose,
          viewname = "PhotographResultPanel",
          anglez = anglez,
          cameraData = self.cameraData,
          texture = texture,
          arg = self.focalLenLabel.text,
          isFromStageView = true
        }
      end
      self:sendNotification(UIEvent.ShowUI, viewdata)
    end, bgCm, uiBgCm, gmCm, self.uiCm)
  end
end
function StageView:changePhotoMode(mode)
  if self.curPhotoMode ~= mode then
    self.curPhotoMode = mode
    if self.curPhotoMode == StageView.PhotographMode.SELFIE then
      if self.selfieStickArea then
        Game.InputManager.forceJoystickArea = self.selfieStickArea
      end
      Game.InputManager.photographMode = PhotographMode.SELFIE
      self.curPhotoMode = StageView.PhotographMode.SELFIE
      self.playRotating.enabled = true
      TimeTickManager.Me():ClearTick(self, StageView.TickType.UpdateAxis)
      ServiceNUserProxy.Instance:CallStateChange(ProtoCommon_pb.ECREATURESTATUS_SELF_PHOTO)
      if self.cameraAxisY then
        Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, self.cameraAxisY, true)
        self.cameraAxisY = nil
      end
      self.needCheckReady = false
      self:endFilterInSelfieMode()
    else
      if self.selfieStickArea then
        Game.InputManager.forceJoystickArea = PHOTOGRAPHER_StickArea
      end
      Game.InputManager.photographMode = PhotographMode.PHOTOGRAPHER
      self.curPhotoMode = StageView.PhotographMode.PHOTOGRAPHER
      self.playRotating.enabled = false
      self.needCheckReady = true
      ServiceNUserProxy.Instance:CallStateChange(ProtoCommon_pb.ECREATURESTATUS_PHOTO)
      TimeTickManager.Me():CreateTick(500, 100, self.updateCameraAxis, self, StageView.TickType.UpdateAxis)
    end
    self:changeTakeTypeBtnView()
    self:changeCameraDisView()
  end
end
function StageView:endFilterInSelfieMode()
  local cells = self.filterGridList:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    if GameConfig.FilterType.PhotoFilter.Self == single.data.id and single:getIsSelect() then
      FunctionSceneFilter.Me():EndFilter(GameConfig.FilterType.PhotoFilter.Self)
    end
  end
end
function StageView:updateCameraAxis()
  local axisY = self.uiCm.transform.rotation.eulerAngles.y % 360
  self.cameraAxisY = self.cameraAxisY or 0
  local diff = math.abs(self.cameraAxisY - axisY)
  if diff > 5 then
    ServiceNUserProxy.Instance:CallStateChange(ProtoCommon_pb.ECREATURESTATUS_PHOTO)
    self.cameraAxisY = axisY
    Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, self.cameraAxisY, true)
  end
  if self.needCheckReady and Game.InputManager.photograph.ready then
    self.needCheckReady = false
    FunctionSceneFilter.Me():StartFilter(GameConfig.FilterType.PhotoFilter.Self)
  end
end
function StageView:TabChangeHandler(key)
  if StageView.super.TabChangeHandler(self, key) then
    self.itemBord:SetActive(true)
    self.itemlist:UpdateTabList(key)
    self:SetCurrentTabIconColor(self.coreTabMap[key].go)
  end
end
local showtime = GameConfig.DressUp.showtime
local nowTime, rest, min, sec
function StageView:ResetShowtime()
  showtime = StageProxy.Instance:GetWaitTime()
  self.beginTime = ServerTime.CurServerTime()
end
function StageView:UpdateCountDown()
  nowTime = ServerTime.CurServerTime()
  if not StageProxy.Instance.showtime then
    return
  end
  rest = StageProxy.Instance.showtime - (nowTime - StageProxy.Instance.beginTime) / 1000
  if rest < 0 then
    return
  end
  min = rest / 60
  sec = rest % 60
  self.countDown.text = string.format("%02d:%02d", min, sec)
end
function StageView:ShowStageView()
  if self.hideableRoot then
    self.hideableRoot:SetActive(true)
  end
end
function StageView:HideStageView()
  if self.hideableRoot then
    self.hideableRoot:SetActive(false)
  end
end
function StageView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  if not GameConfig.SystemForbid.TabNameTip then
    if isPressing then
      local backgroundSp = self.coreTabMap[index].go:GetComponent(UISprite)
      TipManager.Instance:TryShowHorizontalTabNameTip(StageView.TabName[index], backgroundSp, NGUIUtil.AnchorSide.Left)
    else
      TipManager.Instance:CloseTabNameTipWithFadeOut()
    end
  end
end
function StageView:ResetTabIconColor()
  self.equibTabIconSp.color = ColorUtil.TabColor_White
  self.fashionTabIconSp.color = ColorUtil.TabColor_White
end
function StageView:SetCurrentTabIconColor(currentTabGo)
  self:ResetTabIconColor()
  if not currentTabGo then
    return
  end
  local iconSp = GameObjectUtil.Instance:DeepFindChild(currentTabGo, "Icon"):GetComponent(UISprite)
  if not iconSp then
    return
  end
  iconSp.color = ColorUtil.TabColor_DeepBlue
end
