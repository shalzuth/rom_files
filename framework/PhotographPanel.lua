PhotographPanel = class("PhotographPanel", ContainerView)
autoImport("PhotographSingleFilterText")
autoImport("CarrierSubView")
autoImport("SceneRoleTopSymbol")
autoImport("FlyMessageView")
PhotographPanel.ViewType = UIViewType.FocusLayer
PhotographPanel.FOCUS_VIEW_PORT_RANGE = {
  x = {0.1, 0.9},
  y = {0.1, 0.9}
}
PhotographPanel.NEAR_FOCUS_DISTANCE = GameConfig.PhotographPanel and GameConfig.PhotographPanel.Near_Focus_Distance or 15
PhotographPanel.FAR_FOCUS_DISTANCE = GameConfig.PhotographPanel and GameConfig.PhotographPanel.Far_Focus_Distance or 40
PhotographPanel.ChangeCompositionDuration = 0.3
local PHOTOGRAPHER_StickArea = Rect(0, 0, 1, 1)
PhotographPanel.taskCellRes = TaskCell
PhotographPanel.filterType = {
  Text = 1,
  Faction = 2,
  Team = 3,
  All = 4
}
PhotographPanel.DefaultMode = {SELFIE = 1, PHOTOGRAPHER = 2}
PhotographPanel.TickType = {
  Zoom = 1,
  CheckFocus = 4,
  CheckIfHasFocusCreature = 3,
  CheckAnim = 5,
  UpdateAxis = 2
}
PhotographPanel.FocusStatus = {
  Fit = 1,
  Less = 2,
  FarMore = 3
}
PhotographPanel.PhotographMode = {SELFIE = 1, PHOTOGRAPHER = 2}
PhotographPanel.filters = {
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
  {
    id = GameConfig.FilterType.PhotoFilter.PetTalk
  },
  {
    id = GameConfig.FilterType.PhotoFilter.HunterPet
  }
}
local tempVector3 = LuaVector3.zero
local tempArray = {}
function PhotographPanel:Init()
  self.compositionIndex = 1
  self:initView()
  self:initData()
  self:addEventListener()
end
function PhotographPanel:changeTakeTypeBtnView()
  if self.curPhotoMode == PhotographPanel.PhotographMode.SELFIE and self.hasLearnTakePicSkill then
    self:Show(self.takeTypeBtn)
  else
    self:Hide(self.takeTypeBtn)
  end
end
function PhotographPanel:changeCameraDisView()
  if self.curPhotoMode == PhotographPanel.PhotographMode.SELFIE and self.hasLearnChangeCameraSkill then
    self:Show(self.disScrollBar)
  else
    self:Hide(self.disScrollBar)
  end
end
function PhotographPanel:initView()
  self.carrierSubView = self:AddSubView("CarrierSubView", CarrierSubView)
  self.flyMessageView = self:AddSubView("FlyMessageView", FlyMessageView)
  local filtersBg = self:FindChild("filterContentBg"):GetComponent(UISprite)
  filtersBg.height = 49.15 * #PhotographPanel.filters + 16
  filtersBg.width = 240
  filtersBg.transform.localPosition = Vector3(-200, -69, 0)
  local girdView = self:FindChild("Grid"):GetComponent(UIGrid)
  self.filterGridList = UIGridListCtrl.new(girdView, PhotographSingleFilterText, "PhotographSingleFilterText")
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self.filterGridList:AddEventListener(MouseEvent.MouseClick, self.filterCellClick, self)
  self.filterGridList:ResetDatas(PhotographPanel.filters)
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
  self:Hide(self.focalLen)
  self.cameraDis = self:FindGO("Distance")
  self.cameraDisLabel = self:FindGO("Label", self.cameraDis):GetComponent(UILabel)
  self:Hide(self.cameraDis)
  self.boliSp = self:FindComponent("boli", UISprite)
  self:AddButtonEvent("filterBtn", nil)
  self.emojiButton = self:FindGO("EmojiButton")
  FunctionUnLockFunc.Me():RegisteEnterBtnByPanelID(PanelConfig.ChatEmojiView.id, self.emojiButton)
  self.questPanel = self:FindGO("TaskQuestPanel")
  self.takeTypeBtn = self:FindGO("takeTypeBtn")
  self.callServentBtn = self:FindGO("callServentBtn")
  self.servantEmojiButton = self:FindGO("ServantEmojiButton")
  self.oprForbidBg = self:FindGO("oprForbidBg")
  self:Hide(self.questPanel)
end
function PhotographPanel:initData()
  FunctionCameraEffect.Me():Pause()
  self.cameraController = CameraController.Instance
  if not self.cameraController then
    printRed("cameraController is nil")
    LeanTween.cancel(self.gameObject)
    LeanTween.delayedCall(self.gameObject, 0.1, function()
      self:CloseSelf()
    end)
    return
  end
  local viewdata = self.viewdata.viewdata
  if viewdata then
    local id = viewdata.cameraId
    if id then
      printRed("PhotographPanel:from carrier cameraId:", id)
      self.cameraId = id
    end
  end
  self:checkQuest()
  local skillid = GameConfig.PhotographAdSkill.copSkill
  local skillData = Table_Skill[skillid]
  if skillData and SkillProxy.Instance:HasLearnedSkill(skillid) then
    self.hasLearnTakePicSkill = true
  end
  skillid = GameConfig.PhotographAdSkill.cgDisSkill
  skillData = Table_Skill[skillid]
  if skillData and SkillProxy.Instance:HasLearnedSkill(skillid) then
    self.hasLearnChangeCameraSkill = true
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
  self.photoSkillId = GameConfig.NewRole.flashskill
  self.uiCm = NGUIUtil:GetCameraByLayername("SceneUI")
  local servantID = Game.Myself.data.userdata:Get(UDEnum.SERVANTID)
  if servantID ~= 0 then
    self:Show(self.callServentBtn)
    self:LoadServant()
  else
    self:Hide(self.callServentBtn)
  end
  self:initCameraData()
  TimeTickManager.Me():CreateTick(0, 100, self.updateScrollBar, self, PhotographPanel.TickType.Zoom)
  TimeTickManager.Me():CreateTick(500, 3000, self.checkIfHasFocusCreature, self, PhotographPanel.TickType.CheckIfHasFocusCreature)
  TimeTickManager.Me():CreateTick(0, 100, self.setTargetPositionAndSymbol, self, PhotographPanel.TickType.CheckFocus)
  self.myId = Game.Myself.data.id
end
function PhotographPanel:checkQuest()
  if self.viewdata.viewdata then
    self.questData = self.viewdata.viewdata.questData
    if self.questData then
      self.creatureId = self.questData.params.npc
      self.questScenicSpotID = self.questData.params.spotId
      self.oprForbid = self.questData.params.oprForbid == 1
      local tarpos = self.questData.params.tarpos
      if not self.creatureId and tarpos then
        self.questTargetPosition = LuaVector3(tarpos[1], tarpos[2], tarpos[3])
      end
      local id = self.questData.params.cameraId
      if id then
        printRed("PhotographPanel:from quest cameraId:", id)
        self.cameraId = id
      end
      if not self.oprForbid then
        self:showQuestTrace()
      else
        self:Show(self.oprForbidBg)
        LeanTween.delayedCall(self.gameObject, 2, function()
          self:questCellClick()
        end)
      end
    end
  end
end
function PhotographPanel:showQuestTrace()
  self:Show(self.questPanel)
  local taskCell = self:FindGO("TaskCell")
  local taskCellObj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("TaskQuestCell"), taskCell)
  taskCellObj.transform.localPosition = LuaVector3.zero
  local questCell = TaskQuestCell.new(taskCellObj)
  questCell:AddEventListener(MouseEvent.MouseClick, self.questCellClick, self)
  questCell:SetData(self.questData)
end
function PhotographPanel:questCellClick()
  Game.InputManager.photograph:Exit()
  self:setForceRotation()
  if self.curPhotoMode == PhotographPanel.PhotographMode.SELFIE then
    Game.InputManager.photograph:Enter(PhotographMode.SELFIE)
  else
    Game.InputManager.photograph:Enter(PhotographMode.PHOTOGRAPHER)
  end
end
function PhotographPanel:calFOVValue(zoom)
  local value = 2 * math.atan(21.635 / zoom) * 180 / math.pi
  return value
end
function PhotographPanel:calZoom(del)
  local value = 21.635 / math.tan(del / 2 / 180 * math.pi)
  return value
end
function PhotographPanel:SetCompositionIndex(index)
  self.compositionIndex = index
end
function PhotographPanel:MoveCompositionIndexToNext()
  local index = self.compositionIndex + 1
  if nil == self:GetComposition(index) then
    index = 1
  end
  MsgManager.ShowMsgByIDTable(853, tostring(index))
  self:SetCompositionIndex(index)
end
function PhotographPanel:GetComposition(index)
  index = index or self.compositionIndex
  if nil == self.cameraData or nil == self.cameraData.Composition then
    return nil
  end
  return self.cameraData.Composition[index]
end
function PhotographPanel:ApplyComposition()
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
  self.cameraController:FocusTo(fo, fvp, PhotographPanel.ChangeCompositionDuration, nil)
end
function PhotographPanel:initCameraData()
  self.originFovMin = nil
  self.originFovMax = nil
  self.originAllowLowerThanFocus = nil
  if not self.cameraId then
    local currentMap = SceneProxy.Instance.currentScene
    if currentMap then
      self.cameraId = Table_Map[currentMap.mapID].Camera
    end
  end
  if not self.cameraId then
    self.cameraId = 1
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
  else
    if self.cameraData.Y_Limit == 0 then
      self.cameraController.allowLowerThanFocus = true
    else
    end
  end
  self.originFovMin = Game.InputManager.cameraFieldOfViewMin
  self.originFovMax = Game.InputManager.cameraFieldOfViewMax
  local minskillId = GameConfig.PhotographAdSkill.minViewPortSkill
  local maxskillId = GameConfig.PhotographAdSkill.maxViewPortSkill
  local skillData = Table_Skill[minskillId]
  if SkillProxy.Instance:HasLearnedSkill(minskillId) and skillData then
    self.fovMin = skillData.Logic_Param.minfov
    self.fovMin = self.fovMin and self.fovMin or self.cameraData.Zoom[1]
  else
    self.fovMin = self.cameraData.Zoom[1]
  end
  skillData = Table_Skill[maxskillId]
  if SkillProxy.Instance:HasLearnedSkill(maxskillId) and skillData then
    self.fovMax = skillData.Logic_Param.maxfov
    self.fovMax = self.fovMax and self.fovMax or self.cameraData.Zoom[2]
  else
    self.fovMax = self.cameraData.Zoom[2]
  end
  self.fovMinValue = self:calFOVValue(self.fovMax)
  self.fovMaxValue = self:calFOVValue(self.fovMin)
  Game.InputManager.cameraFieldOfViewMin = self.fovMinValue
  Game.InputManager.cameraFieldOfViewMax = self.fovMaxValue
  local danmaku = self.cameraData.Danmaku
  if danmaku == 1 and not GameConfig.SystemForbid.Barrage then
    self.flyMessageView:StartRecieveBarrage()
  else
    self.flyMessageView:CloseUIWidgets()
  end
  local nearChat = self.cameraData.NearChat
  if nearChat ~= 1 then
  end
  local close = self.cameraData.Close
  if close ~= 1 then
    self:Hide(self.quitBtn)
    self.forbiddenClose = true
  else
    self:Show(self.quitBtn)
  end
  local Emoji = self.cameraData.Emoji or 0
  local action = self.cameraData.Act or 0
  self.actEmoj = Emoji * 2 + action
  if self.actEmoj == 0 then
    self:Hide(self.emojiButton)
  end
  local ferrisItem = self.cameraData.FerrisItem
  if ferrisItem ~= 1 then
  else
  end
  local switchMode = self.cameraData.SwitchMode
  local switchBtn = self:FindGO("modeSwitch")
  if switchMode ~= 1 or ApplicationInfo.IsRunOnWindowns() then
    self:Hide(switchBtn)
  else
    self:Show(switchBtn)
  end
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
    if self.questData then
      self:setTargetPositionAndSymbol()
      self:calFOVByPos()
    end
  else
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
  if defaultMode == PhotographPanel.DefaultMode.PHOTOGRAPHER then
    self:changePhotoMode(PhotographPanel.PhotographMode.PHOTOGRAPHER)
  else
    self:changePhotoMode(PhotographPanel.PhotographMode.SELFIE)
    LeanTween.delayedCall(self.cameraDis, 1, function()
      self:updateDisScrollBar()
    end)
  end
end
local tempLuaQuaternion = LuaQuaternion.identity
function PhotographPanel:calFOVByPos()
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
function PhotographPanel:resetCameraData()
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
function PhotographPanel:changeShowFocalLen(isShow)
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
        self:Hide(self.focalLen)
      end)
    end
  end
end
function PhotographPanel:changeShowDisLen(isShow)
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
function PhotographPanel:addEventListener()
  self:AddButtonEvent("quitBtn", function(go)
    FunctionBarrage.Me():ShutDown()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.takePicBtn, function(go)
    self:takePic()
    AudioUtility.PlayOneShot2D_Path(ResourcePathHelper.AudioSEUI(AudioMap.UI.Picture))
  end)
  self:AddButtonEvent("modeSwitch", function(go)
    local mode = self.curPhotoMode == PhotographPanel.PhotographMode.SELFIE and PhotographPanel.PhotographMode.PHOTOGRAPHER or PhotographPanel.PhotographMode.SELFIE
    local isDead = Game.Myself:IsDead()
    if isDead then
      MsgManager.ShowMsgByID(2500)
      return
    end
    if mode == PhotographPanel.PhotographMode.PHOTOGRAPHER and not SkillProxy.Instance:HasLearnedSkill(GameConfig.PhotographAdSkill.freeViewSkill) then
      MsgManager.ShowMsgByID(557)
      return
    end
    self:changePhotoMode(mode)
  end)
  self:AddClickEvent(self.emojiButton, function(go)
    if not self.isEmojiShow then
      self.isEmojiShow = true
      local forbidAction = self.actEmoj
      if self.actEmoj == 1 and self.curPhotoMode == PhotographPanel.PhotographMode.PHOTOGRAPHER then
        forbidAction = 0
      elseif self.actEmoj == 3 and self.curPhotoMode == PhotographPanel.PhotographMode.PHOTOGRAPHER then
        forbidAction = 1
      end
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ChatEmojiView,
        viewdata = {state = forbidAction}
      })
    else
      self.isEmojiShow = false
      self:sendNotification(UIEvent.CloseUI, UIViewType.ChatLayer)
    end
  end)
  self:AddClickEvent(self.takeTypeBtn, function(go)
    self:MoveCompositionIndexToNext()
    self:ApplyComposition()
  end)
  self:AddClickEvent(self.callServentBtn, function(go)
    self:TriggerServant()
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
    local port = LuaVector3(focusViewPort.x, focusViewPort.y, zoom)
    self.cameraController:ResetFocusViewPort(port)
    self:changeShowDisLen(true)
  end)
  self:AddClickEvent(self.servantEmojiButton, function(go)
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "ServantEmojiView",
      npc = self.servant,
      npcId = self.servantId
    })
  end)
  self:AddListenEvt(SceneUserEvent.SceneAddPets, self.HandleAddServant)
end
function PhotographPanel:checkIfHasFocusCreature()
  local nearDis = GameConfig.PhotographPanel.Near_Focus_Distance_Monster
  if not nearDis or not nearDis then
    nearDis = PhotographPanel.NEAR_FOCUS_DISTANCE
  end
  local nearMonster = NSceneNpcProxy.Instance:FindNearNpcs(Game.Myself:GetPosition(), nearDis, function(npc)
    local pos = npc:GetPosition()
    local cmd = FunctionPhoto.Me():GetCmd(PhotoCommandShowGhost)
    if self:checkFocus(Game.Myself:GetPosition(), pos, nearDis) == PhotographPanel.FocusStatus.Fit then
      if cmd and SkillProxy.Instance:HasLearnedSkill(GameConfig.PhotographAdSkill.gostSkill) then
        cmd:GhostInSight(npc)
      end
      return true
    elseif cmd and SkillProxy.Instance:HasLearnedSkill(GameConfig.PhotographAdSkill.gostSkill) then
      cmd:GhostOutSight(npc)
    end
  end)
  local data = ReusableTable.CreateArray()
  for i = 1, #nearMonster do
    table.insert(data, nearMonster[i].data.id)
  end
  if #data > 0 then
    ServiceNUserProxy.Instance:CallCameraFocus(data)
    ReusableTable.DestroyArray(data)
  end
end
function PhotographPanel:getValidScenery(scenicSpotID)
  local scenicSpot
  if scenicSpotID then
    scenicSpot = FunctionScenicSpot.Me():GetScenicSpot(scenicSpotID)
    if scenicSpot then
      local camera = self.cameraController.activeCamera
      local viewport = camera:WorldToViewportPoint(scenicSpot.position)
      if not (0 < viewport.x) or not (viewport.x < 1) or not (0 < viewport.y) or not (1 > viewport.y) or not (camera.nearClipPlane < viewport.z) or not (camera.farClipPlane > viewport.z) then
      end
    end
  else
    local cameraPos = self.cameraController.activeCamera.transform.position
    scenicSpot = FunctionScenicSpot.Me():GetNearestScenicSpot(cameraPos, self.cameraController.activeCamera)
  end
  if scenicSpot then
    self.charid = scenicSpot.guid
    local result = self:checkFocus(Game.Myself:GetPosition(), scenicSpot.position)
    if result ~= PhotographPanel.FocusStatus.FarMore then
      return scenicSpot
    end
  end
end
function PhotographPanel:getValidCreature()
  local creatureObj = NSceneNpcProxy.Instance:FindNearestNpc(Game.Myself:GetPosition(), self.creatureId)
  if creatureObj then
    local result = self:checkFocus(Game.Myself:GetPosition(), creatureObj:GetPosition())
    if result ~= PhotographPanel.FocusStatus.FarMore then
      return creatureObj
    end
  end
end
function PhotographPanel:removeCreatureTopFocusUI()
  if self.creatureGuid then
    local creatureObj = SceneCreatureProxy.FindCreature(self.creatureGuid)
    if creatureObj then
      creatureObj:GetSceneUI().roleTopUI:DestroyTopFocusUI()
    end
  end
  self.creatureGuid = nil
end
function PhotographPanel:removeSceneFocusUI()
  if not self.symbol then
    return
  end
  if self.symbol:Alive() then
    ReusableObject.Destroy(self.symbol)
  end
  self.symbol = nil
end
local topFocusUIData = {}
function PhotographPanel:setTargetPositionAndSymbol()
  local symbol
  if self.creatureId then
    if self.creatureGuid then
      local creatureObj = SceneCreatureProxy.FindCreature(self.creatureGuid)
      if creatureObj then
        local result = self:checkFocus(Game.Myself:GetPosition(), creatureObj:GetPosition())
        if result == PhotographPanel.FocusStatus.FarMore then
          local validCreatureObj = self:getValidCreature()
          if validCreatureObj then
            self:removeCreatureTopFocusUI()
            self.creatureGuid = validCreatureObj.data.id
            symbol = validCreatureObj:GetSceneUI().roleTopUI:createOrGetTopFocusUI()
          else
            symbol = creatureObj:GetSceneUI().roleTopUI.topFocusUI
          end
        else
          symbol = creatureObj:GetSceneUI().roleTopUI.topFocusUI
        end
      else
        self:removeCreatureTopFocusUI()
        creatureObj = self:getValidCreature()
        if creatureObj then
          self.creatureGuid = creatureObj.data.id
          symbol = creatureObj:GetSceneUI().roleTopUI:createOrGetTopFocusUI()
        end
      end
    else
      creatureObj = self:getValidCreature()
      if creatureObj then
        self.creatureGuid = creatureObj.data.id
        symbol = creatureObj:GetSceneUI().roleTopUI:createOrGetTopFocusUI()
      else
      end
    end
  elseif self.questTargetPosition then
    local result = self:checkFocus(Game.Myself:GetPosition(), self.questTargetPosition)
    if result ~= PhotographPanel.FocusStatus.FarMore then
      if not self.symbol then
        TableUtility.ArrayClear(topFocusUIData)
        topFocusUIData[1] = SceneTopFocusUI.FocusType.SceneObject
        self.symbol = SceneTopFocusUI.CreateAsArray(topFocusUIData)
      end
      self.symbol:reSetFollowPos(self.questTargetPosition)
    end
  elseif self.questScenicSpotID then
    local scenicSpot = self:getValidScenery(self.questScenicSpotID)
    if scenicSpot then
      local pos = scenicSpot.position
      if not self.symbol then
        TableUtility.ArrayClear(topFocusUIData)
        topFocusUIData[1] = SceneTopFocusUI.FocusType.SceneObject
        self.symbol = SceneTopFocusUI.CreateAsArray(topFocusUIData)
      end
      self.scenicSpotID = scenicSpot.ID
      self.symbol:reSetFollowPos(pos)
    end
  end
  if not symbol then
    local scenicSpot = self:getValidScenery()
    if not self.symbol then
      if scenicSpot then
        local pos = scenicSpot.position
        TableUtility.ArrayClear(topFocusUIData)
        topFocusUIData[1] = SceneTopFocusUI.FocusType.SceneObject
        self.symbol = SceneTopFocusUI.CreateAsArray(topFocusUIData)
        self.symbol:reSetFollowPos(pos)
        self.scenicSpotID = scenicSpot.ID
        symbol = self.symbol
        LogUtility.InfoFormat("creat 1 x:{0},y:{1},z:{2}", pos.x, pos.y, pos.z)
      end
    else
      if not self.questScenicSpotID and not self.questTargetPosition then
        local pos = self.symbol:getPosition()
        if scenicSpot and not pos:Equal(scenicSpot.position) then
          local oldResult = self:checkFocus(Game.Myself:GetPosition(), pos)
          local newResult = self:checkFocus(Game.Myself:GetPosition(), scenicSpot.position)
          if oldResult == PhotographPanel.FocusStatus.FarMore then
            pos = scenicSpot.position
            self.symbol:reSetFollowPos(pos)
            self.scenicSpotID = scenicSpot.ID
          elseif oldResult ~= PhotographPanel.FocusStatus.Fit and newResult ~= PhotographPanel.FocusStatus.FarMore then
            pos = scenicSpot.position
            self.symbol:reSetFollowPos(pos)
            self.scenicSpotID = scenicSpot.ID
          elseif self.scenicSpotID == scenicSpot.ID then
            pos = scenicSpot.position
            self.symbol:reSetFollowPos(pos)
          end
        elseif not scenicSpot then
          self:removeSceneFocusUI()
          self.scenicSpotID = nil
        end
      end
      symbol = self.symbol
    end
  end
  if symbol then
    self:changeFocusStatus(symbol)
  end
end
function PhotographPanel:getSceneFocusUI()
  local symbol
  if self.creatureGuid then
    local creatureObj = SceneCreatureProxy.FindCreature(self.creatureGuid)
    if creatureObj then
      symbol = creatureObj:GetSceneUI().roleTopUI.topFocusUI
    end
  elseif self.symbol then
    symbol = self.symbol
  end
  return symbol
end
function PhotographPanel:checkFocus_N(creature, nearFocus)
  local result
  local playerPos = Game.Myself:GetPosition()
  local targetPosition = creature:GetPosition()
  local distance = LuaVector3.Distance(playerPos, targetPosition)
  local dis = nearFocus and nearFocus or PhotographPanel.NEAR_FOCUS_DISTANCE
  local isFit = distance <= dis
  if isFit then
    local viewportRange = PhotographPanel.FOCUS_VIEW_PORT_RANGE
    local viewport = self.uiCm:WorldToViewportPoint(targetPosition)
    local isVisible = viewport.x > viewportRange.x[1] and viewport.x < viewportRange.x[2] and viewport.y > viewportRange.y[1] and viewport.y < viewportRange.y[2] and viewport.z > self.uiCm.nearClipPlane and viewport.z < self.uiCm.farClipPlane
    if isVisible then
      return PhotographPanel.FocusStatus.Fit
    end
    if creature.assetRole then
      local epTransform = creature.assetRole:GetEP(RoleDefines_EP.Middle)
      if nil ~= epTransform then
        tempVector3:Set(LuaGameObject.GetPosition(epTransform))
        viewport = self.uiCm:WorldToViewportPoint(tempVector3)
        isVisible = viewport.x > viewportRange.x[1] and viewport.x < viewportRange.x[2] and viewport.y > viewportRange.y[1] and viewport.y < viewportRange.y[2] and viewport.z > self.uiCm.nearClipPlane and viewport.z < self.uiCm.farClipPlane
        if isVisible then
          return PhotographPanel.FocusStatus.Fit
        end
      end
      epTransform = creature.assetRole:GetEP(RoleDefines_EP.Top)
      if nil ~= epTransform then
        tempVector3:Set(LuaGameObject.GetPosition(epTransform))
        viewport = self.uiCm:WorldToViewportPoint(tempVector3)
        isVisible = viewport.x > viewportRange.x[1] and viewport.x < viewportRange.x[2] and viewport.y > viewportRange.y[1] and viewport.y < viewportRange.y[2] and viewport.z > self.uiCm.nearClipPlane and viewport.z < self.uiCm.farClipPlane
        if isVisible then
          return PhotographPanel.FocusStatus.Fit
        end
      end
    end
    return PhotographPanel.FocusStatus.Less
  elseif distance <= PhotographPanel.FAR_FOCUS_DISTANCE then
    result = PhotographPanel.FocusStatus.Less
  else
    result = PhotographPanel.FocusStatus.FarMore
  end
  return result
end
function PhotographPanel:checkFocus(playerPos, targetPosition, nearFocus)
  local result
  local distance = LuaVector3.Distance(playerPos, targetPosition)
  local dis = nearFocus and nearFocus or PhotographPanel.NEAR_FOCUS_DISTANCE
  local isFit = distance <= dis
  if isFit then
    local viewport = self.uiCm:WorldToViewportPoint(targetPosition)
    local viewportRange = PhotographPanel.FOCUS_VIEW_PORT_RANGE
    local isVisible = viewport.x > viewportRange.x[1] and viewport.x < viewportRange.x[2] and viewport.y > viewportRange.y[1] and viewport.y < viewportRange.y[2] and viewport.z > self.uiCm.nearClipPlane and viewport.z < self.uiCm.farClipPlane
    if isVisible then
      result = PhotographPanel.FocusStatus.Fit
    else
      result = PhotographPanel.FocusStatus.Less
    end
  elseif distance <= PhotographPanel.FAR_FOCUS_DISTANCE then
    result = PhotographPanel.FocusStatus.Less
  else
    result = PhotographPanel.FocusStatus.FarMore
  end
  return result
end
function PhotographPanel:changeFocusStatus(symbol)
  if not symbol then
    return
  end
  local status = self:checkFocus(Game.Myself:GetPosition(), symbol:getPosition())
  if self.status ~= status then
    if status == PhotographPanel.FocusStatus.Fit then
      symbol:Show()
      symbol:playFocusAnim()
      self.focusSuccess = true
      self:setTakePicEnable(true)
    elseif status == PhotographPanel.FocusStatus.Less then
      self:setTakePicEnable(false)
      symbol:Show()
      symbol:playLostFocusAnim()
      self.focusSuccess = false
    else
      self:setTakePicEnable(false)
      symbol:Hide()
      self.focusSuccess = false
    end
    self.status = status
  end
end
function PhotographPanel:setTakePicEnable(isEnabled)
  if self.questData then
    local box = self.takePicBtn:GetComponent(BoxCollider)
    local sprite = self.takePicBtn:GetComponent(UISprite)
    local icon = self:FindGO("icon", self.takePicBtn):GetComponent(UISprite)
    local button = self.takePicBtn:GetComponent(UIButton)
    if isEnabled then
      button.isEnabled = true
    else
      button.isEnabled = false
    end
  end
end
function PhotographPanel:updateScrollBar()
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
function PhotographPanel:updateDisScrollBar()
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
function PhotographPanel:changeTurnBtnState(visible)
  self.turnRightBtn:SetActive(visible)
  self.turnLeftBtn:SetActive(visible)
end
function PhotographPanel:OnEnter()
  FunctionPhoto.Me():Launch()
end
function PhotographPanel:OnExit()
  FunctionPhoto.Me():ShutDown()
  TimeTickManager.Me():ClearTick(self)
  self.needCheckReady = false
  self.focusSuccess = false
  FunctionSceneFilter.Me():EndFilter(GameConfig.FilterType.PhotoFilter)
  FunctionSceneFilter.Me():EndFilter(FunctionSceneFilter.AllEffectFilter)
  if self.defaultHide then
    for i = 1, #self.defaultHide do
      local fileterItem = self.defaultHide[i]
      FunctionSceneFilter.Me():EndFilter(fileterItem)
    end
  end
  self:removeSceneFocusUI()
  self:removeCreatureTopFocusUI()
  if self.cameraAxisY then
    Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, self.cameraAxisY)
  end
  Game.AreaTriggerManager:SetIgnore(false)
  if self.isEmojiShow or self.chatroomShow then
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
  if self.questData and not self.hasNotifyServer then
    local cmd = Game.AreaTrigger_Mission
    if cmd then
      cmd:ForceReCheck(self.questData.id)
    end
    printRed("self.questData and not self.hasNotifyServe")
  end
  if self.uiCemera then
    self.uiCemera.touchDragThreshold = self.originUiCmTouchDragThreshold
  end
  if self.originInputTouchSenseInch then
    Game.InputManager.touchSenseInch = self.originInputTouchSenseInch
    Game.InputManager:ResetParams()
  end
  if self.servant then
    ServiceNUserProxy.Instance:CallShowServantUserCmd(false)
  end
  if self.servantEffect then
    self.servantEffect:Destroy()
    self.servantEffect = nil
  end
  self:CancelLeanTween()
end
function PhotographPanel:filterCellClick(obj)
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
function PhotographPanel:setPhotoResultVisible(state)
  self.photographResult:SetActive(state)
end
function PhotographPanel:preTakePic()
  local symbol = self:getSceneFocusUI()
  if symbol then
    symbol:Hide()
  end
  local nearDis = GameConfig.PhotographPanel.Near_Focus_Distance_Monster
  if not nearDis or not nearDis then
    nearDis = PhotographPanel.NEAR_FOCUS_DISTANCE
  end
  local nearMonster = NSceneNpcProxy.Instance:FindNearNpcs(Game.Myself:GetPosition(), nearDis, function(npc)
    if self:checkFocus_N(npc, nearDis) == PhotographPanel.FocusStatus.Fit then
      return true
    end
  end)
  local nearPlayers = NSceneUserProxy.Instance:FindNearUsers(Game.Myself:GetPosition(), nearDis, function(npc)
    if self:checkFocus_N(npc, nearDis) == PhotographPanel.FocusStatus.Fit then
      return true
    end
  end)
  local selfPos = Game.Myself:GetPosition()
  if self:checkFocus_N(Game.Myself, nearDis) == PhotographPanel.FocusStatus.Fit then
    nearPlayers[#nearPlayers + 1] = Game.Myself
  end
  local phaseData = SkillPhaseData.Create(self.photoSkillId)
  for i = 1, #nearMonster do
    phaseData:AddTarget(nearMonster[i].data.id, 1, 1)
  end
  for i = 1, #nearPlayers do
    phaseData:AddTarget(nearPlayers[i].data.id, 1, 1)
  end
  self.sceneries = self:checkCombineScenery(nearPlayers)
  phaseData:SetSkillPhase(SkillPhase.Attack)
  Game.Myself:Client_UseSkillHandler(0, phaseData)
  phaseData:Destroy()
  phaseData = nil
  if self.curPhotoMode == PhotographPanel.PhotographMode.PHOTOGRAPHER then
    ServiceNUserProxy.Instance:CallPhoto(Game.Myself.data.id)
  end
  if self.focusSuccess and self.questData and not self.hasNotifyServer then
    local questData = self.questData
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
    self.hasNotifyServer = true
  else
  end
  ResourceManager.Instance:GC()
  MyLuaSrv.Instance:LuaManualGC()
end
function PhotographPanel:checkCombineScenery(creatures)
  if not creatures then
    return
  end
  local user_extra = GameConfig.Scenery.user_extra
  if not user_extra then
    return
  end
  local tempArray = {}
  for k, v in pairs(user_extra) do
    local bFindScenery = true
    for j = 1, #v do
      local single = v[j]
      local bFindBuff = false
      for i = 1, #creatures do
        local creature = creatures[i]
        if creature.data:HasBuffID(single) then
          bFindBuff = true
          break
        end
      end
      if not bFindBuff then
        bFindScenery = false
        break
      end
    end
    if bFindScenery then
      tempArray[#tempArray + 1] = k
    end
  end
  return tempArray
end
function PhotographPanel:doneTakePic()
  local symbol = self:getSceneFocusUI()
  if symbol then
    symbol:Show()
  end
  if symbol and self.focusSuccess then
    symbol:playStopFocusAnim()
  end
end
function PhotographPanel:takePic()
  self:preTakePic()
  local gmCm = NGUIUtil:GetCameraByLayername("Default")
  local bgCm = NGUIUtil:GetCameraByLayername("SceneUIBackground")
  local uiBgCm = NGUIUtil:GetCameraByLayername("UIBackground")
  local _, _, anglez = LuaGameObject.GetEulerAngles(gmCm.transform)
  anglez = GeometryUtils.UniformAngle(anglez)
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self.screenShotHelper:Setting(self.screenShotWidth, self.screenShotHeight, self.textureFormat, self.texDepth, self.antiAliasing)
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
        scenicSpotIDs = self.sceneries
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
        scenicSpotIDs = self.sceneries
      }
    end
    self:sendNotification(UIEvent.ShowUI, viewdata)
    self:doneTakePic()
  end, bgCm, uiBgCm, gmCm, self.uiCm)
end
function PhotographPanel:setForceRotation()
  self:calFOVByPos()
  if nil ~= self.forceRotation then
    Game.InputManager.photograph.useForceRotation = true
    Game.InputManager.photograph.forceRotation = self.forceRotation
  else
    Game.InputManager.photograph.useForceRotation = false
  end
end
function PhotographPanel:changePhotoMode(mode)
  if self.curPhotoMode ~= mode then
    self.curPhotoMode = mode
    self:setForceRotation()
    if self.curPhotoMode == PhotographPanel.PhotographMode.SELFIE then
      if self.selfieStickArea then
        Game.InputManager.forceJoystickArea = self.selfieStickArea
      end
      Game.InputManager.photographMode = PhotographMode.SELFIE
      self.curPhotoMode = PhotographPanel.PhotographMode.SELFIE
      self.playRotating.enabled = true
      TimeTickManager.Me():ClearTick(self, PhotographPanel.TickType.UpdateAxis)
      ServiceNUserProxy.Instance:CallStateChange(ProtoCommon_pb.ECREATURESTATUS_SELF_PHOTO)
      if self.cameraAxisY then
        Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, self.cameraAxisY, true)
        self.cameraAxisY = nil
      end
      self.needCheckReady = false
      self:endFilterInSelfieMode()
      self:sendNotification(PhotographModeChangeEvent.ModeChangeEvent, self.actEmoj)
    else
      if self.selfieStickArea then
        Game.InputManager.forceJoystickArea = PHOTOGRAPHER_StickArea
      end
      Game.InputManager.photographMode = PhotographMode.PHOTOGRAPHER
      self.curPhotoMode = PhotographPanel.PhotographMode.PHOTOGRAPHER
      self.playRotating.enabled = false
      self.needCheckReady = true
      ServiceNUserProxy.Instance:CallStateChange(ProtoCommon_pb.ECREATURESTATUS_PHOTO)
      local forbidAction = self.actEmoj
      if self.actEmoj == 1 and self.curPhotoMode == PhotographPanel.PhotographMode.PHOTOGRAPHER then
        forbidAction = 0
      elseif self.actEmoj == 3 and self.curPhotoMode == PhotographPanel.PhotographMode.PHOTOGRAPHER then
        forbidAction = 1
      end
      self:sendNotification(PhotographModeChangeEvent.ModeChangeEvent, forbidAction)
      TimeTickManager.Me():CreateTick(500, 100, self.updateCameraAxis, self, PhotographPanel.TickType.UpdateAxis)
    end
    self:changeTakeTypeBtnView()
    self:changeCameraDisView()
  end
end
function PhotographPanel:endFilterInSelfieMode()
  local cells = self.filterGridList:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    if GameConfig.FilterType.PhotoFilter.Self == single.data.id and single:getIsSelect() then
      FunctionSceneFilter.Me():EndFilter(GameConfig.FilterType.PhotoFilter.Self)
    end
  end
end
function PhotographPanel:updateCameraAxis()
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
function PhotographPanel:LoadServant()
end
function PhotographPanel:TriggerServant()
  if self.isServantCalled then
    local animParams = Asset_Role.GetPlayActionParams("disappear", nil, 1)
    animParams[6] = true
    animParams[7] = function()
      ServiceNUserProxy.Instance:CallShowServantUserCmd(false)
      self:ShowServantEffect()
    end
    if self.servant then
      self.servant:PlayActionRaw(animParams, true)
    end
    self.isServantCalled = false
    self.servantEmojiButton:SetActive(false)
  else
    ServiceNUserProxy.Instance:CallShowServantUserCmd(true)
  end
end
function PhotographPanel:HandleAddServant(note)
  local npcs = note.body
  if not npcs then
    return
  end
  for _, npc in pairs(npcs) do
    if npc.data and npc.data.ownerID == self.myId then
      self.servant = npc.assetRole
      self.servantId = npc.data.id
      self.isServantCalled = true
      self.servantEmojiButton:SetActive(true)
      self:CancelLeanTween()
      self.delayShowEffectTween = LeanTween.delayedCall(0.2, function()
        self:ShowServantEffect()
      end)
      break
    end
  end
end
function PhotographPanel:ShowServantEffect()
  if self.servant then
    local servantPos = self.servant.completeTransform.localPosition
    local diffpos = LuaVector3(servantPos.x, servantPos.y + 0.5, servantPos.z)
    Asset_Effect.PlayOneShotAt(EffectMap.Maps.ServantShow, diffpos)
  end
end
function PhotographPanel:CancelLeanTween()
  if self.delayShowEffectTween then
    self.delayShowEffectTween:cancel()
  end
  self.delayShowEffectTween = nil
  if self.delayHideNpcTween then
    self.delayHideNpcTween:cancel()
  end
  self.delayHideNpcTween = nil
end
