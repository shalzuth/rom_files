autoImport("FloatMessage")
autoImport("CountDownMsg")
autoImport("FloatMessageEight")
autoImport("QueuePusherCtrl")
autoImport("QueueWaitCtrl")
autoImport("MidMsg")
autoImport("MidAlphaMsg")
autoImport("ShowyMsg")
autoImport("MaintenanceMsg")
autoImport("TypeNineFloatPanel")
autoImport("UIViewAchievementPopupTip")
FloatingPanel = class("FloatingPanel", ContainerView)
FloatingPanel.Instance = nil
FloatingPanel.ViewType = UIViewType.FloatLayer
function FloatingPanel:Init()
  self.pushCtrl = QueuePusherCtrl.new(self.gameObject, FloatMessage)
  self.pushCtrl.maxNum = 3
  self.pushCtrl.gap = -30
  self.pushCtrl.speed = 95
  self.pushCtrl.hideDelay = 0.5
  self.pushCtrl.hideDelayGrow = 0.4
  self.pushCtrl:SetStartPos(0, -60)
  self.pushCtrl:SetEndPos(0, -10)
  self.pushCtrl:SetDir(QueuePusherCtrl.Dir.Vertical)
  if FloatingPanel.Instance == nil then
    FloatingPanel.Instance = self
  end
  self.waitCtrl = QueueWaitCtrl.CreateAsArray(100)
  self.beforePanel = self:FindGO("BeforePanel")
  self.goUIViewAchievementPopupTip = self:FindGO("UIViewAchievementPopupTip", self.gameObject)
  self:AddSubViews()
  self:AddEvtListener()
end
function FloatingPanel:AddSubViews()
  self.typeNineSubView = self:AddSubView("typeNineView", TypeNineFloatPanel)
  self.uiViewAchievementPopupTip = self:AddSubView("UIViewAchievementPopupTip", UIViewAchievementPopupTip)
  self.uiViewAchievementPopupTip:SetGameObject(self.goUIViewAchievementPopupTip)
  self.uiViewAchievementPopupTip:GetGameObjects()
  self.uiViewAchievementPopupTip:GetModelSet()
  self.uiViewAchievementPopupTip:LoadView()
end
function FloatingPanel:AddEvtListener()
  EventManager.Me():AddEventListener(ServiceEvent.PlayerMapChange, self.SceneLoadHandler, self)
  helplog("FloatingPanel AddEvtListener")
end
function FloatingPanel:HandlePlayUIEffect(note)
  local effect_path = note.body.path
  helplog("FloatingPanel PlayUIEffect:", effect_path)
  self:PlayUIEffect(effect_path, self.gameObject, true)
end
function FloatingPanel:SceneLoadHandler(note)
  if self.countDownMsg ~= nil and self.countDownMsg.DestroyWhenLoadScene then
    self:RemoveCountDown(self.countDownMsg.data.id)
  end
  self:RemoveMidMsg()
  ComboCtl.Instance:Clear()
end
function FloatingPanel:SetStartPos(pos)
  self.pushCtrl:SetStartPos(pos.start.x, pos.start.y)
  self.pushCtrl:SetEndPos(pos.endPos.x, pos.endPos.y)
end
function FloatingPanel:ResetDefaultPos()
  self.pushCtrl:SetStartPos(0, -60)
  self.pushCtrl:SetEndPos(0, -10)
end
function FloatingPanel:FloatMiddleBottom(sortID, text)
  self.typeNineSubView:AddSysMsg(sortID, text)
end
function FloatingPanel:ClearFloatMiddleBottom()
  self.typeNineSubView:Clear()
end
function FloatingPanel:TryFloatMessageByText(text)
  local cell = self:GetFloatCell()
  cell:SetMsg(text)
  self.pushCtrl:AddCell(cell)
end
function FloatingPanel:FloatTypeEightMsgByData(data, startPos, offset)
  local cell = FloatMessageEight.new(self.gameObject, data, startPos, offset)
  self.waitCtrl:AddCell(cell, 0.5)
end
function FloatingPanel:StopFloatTypeEightMsg()
  self.waitCtrl:Clear()
end
function FloatingPanel:TryFloatMessageByTextWithTransparentBg(text)
  local cell = self:GetFloatCellWithTransparentBg()
  cell:SetMsgCenterAlign(text)
  self.pushCtrl:AddCell(cell)
end
function FloatingPanel:GetFloatCellWithTransparentBg()
  local floatMsg = FloatMessage.new(self.gameObject)
  floatMsg:Hide(floatMsg.bg.gameObject)
  return floatMsg
end
function FloatingPanel:TryFloatMessageByData(data)
  self.pushCtrl:AddData(data)
end
function FloatingPanel:GetFloatCell()
  return FloatMessage.new(self.gameObject)
end
function FloatingPanel:ShowMapName(name1, name2)
  if self:ObjIsNil(self.mapPfb) then
    self.mapPfb = self:LoadPreferb("tip/MapNameTip", self.gameObject)
    local maplab1 = self:FindChild("MapLabel1", self.mapPfb):GetComponent(UILabel)
    maplab1.text = name1
    local maplab2 = self:FindChild("MapLabel2", self.mapPfb):GetComponent(UILabel)
    maplab2.text = name2
    LeanTween.delayedCall(self.mapPfb, 5, function()
      if not self:ObjIsNil(self.mapPfb) then
        GameObject.Destroy(self.mapPfb)
      end
      self.mapPfb = nil
    end):setDestroyOnComplete(true)
  end
end
function FloatingPanel:FloatingMidEffect(effectid)
  if effectid == 76 then
    local menuId = GameConfig.SystemOpen_MenuId.BigCatInvade
    if menuId and not FunctionUnLockFunc.Me():CheckCanOpen(menuId) then
      return
    end
  end
  local effectName = effectid and EffectMap.UIEffect_IdMap[effectid]
  if effectName then
    self:PlayUIEffect(effectName, self.beforePanel, true, FloatingPanel._HandleMidEffectShow, self)
  end
end
function FloatingPanel:HandleMidEffectShow(effectHandle)
  local effectGO = effectHandle.gameObject
  local panels = UIUtil.GetAllComponentsInChildren(effectGO, UIPanel, true)
  if #panels == 0 then
    return
  end
  local upPanel = GameObjectUtil.Instance:FindCompInParents(effectGO, UIPanel)
  local minDepth
  for i = 1, #panels do
    if minDepth == nil then
      minDepth = panels[i].depth
    else
      minDepth = math.min(panels[i].depth, minDepth)
    end
  end
  local startDepth = 1
  for i = 1, #panels do
    panels[i].depth = panels[i].depth + startDepth + upPanel.depth - minDepth
  end
end
function FloatingPanel._HandleMidEffectShow(effectHandle, owner)
  if effectHandle and owner then
    owner:HandleMidEffectShow(effectHandle)
  end
end
function FloatingPanel:PlayMidEffect(effectPath, callBack)
  self:PlayUIEffect(effectPath, self.beforePanel, true, self._HandleMidEffectCreate_Mediator, {self, callBack})
end
function FloatingPanel._HandleMidEffectCreate_Mediator(effectHandle, param)
  local owner, callBack = param[1], param[2]
  owner:_HandleMidEffectCreate(effectHandle)
  if callBack then
    callBack(effectHandle)
  end
end
function FloatingPanel:_HandleMidEffectCreate(effectHandle)
  local go = effectHandle.gameObject
  local widgets = UIUtil.GetAllComponentsInChildren(go, UIWidget)
  for i = 1, #widgets do
    widgets[i].gameObject:SetActive(false)
    widgets[i].gameObject:SetActive(true)
  end
end
function FloatingPanel:ShowPowerUp(upvalue, effectid, tip)
  local effectid = effectid or EffectMap.UI.Score_Up
  local tip = tip or ZhString.Float_PlayerScoreUp
  local rid = ResourcePathHelper.EffectUI(effectid)
  local anchorDown = self:FindGO("Anchor_Down")
  local scoreup = self:ReInitEffect(rid, anchorDown, Vector3(0, 180), function(go)
    LeanTween.cancel(go)
  end)
  local frome = 0
  local to = upvalue or 200
  local time = math.max(0.7, (to - frome) * 0.005)
  time = math.min(time, 1.5)
  local label = self:FindGO("Label", scoreup):GetComponent(UILabel)
  local anim = scoreup:GetComponent(Animator)
  LeanTween.value(scoreup, function(f)
    label.text = tip .. math.floor(f)
  end, frome, to, time):setOnComplete(function()
    LeanTween.delayedCall(scoreup, 0.3, function(f)
      anim:Play("Score_up2", -1, 0)
      local autodestroy = scoreup:AddComponent(EffectAutoDestroy)
      function autodestroy.OnFinish()
        scoreup = nil
      end
    end)
  end):setDestroyOnComplete(true)
end
function FloatingPanel:ShowManualUp()
  self:PlayUIEffect(EffectMap.UI.UIAdventureLv_up, nil, true, FloatingPanel.UIAdventureLv_upEffectHandle, self)
end
local tempVector3 = LuaVector3.zero
function FloatingPanel.UIAdventureLv_upEffectHandle(effectHandle, owner)
  if owner then
    local effectGO = effectHandle.gameObject
    tempVector3:Set(0, 100, 0)
    effectGO.transform.localPosition = tempVector3
    local shuzi = owner:FindGO("shuzi", effectGO)
    GameObjectUtil.Instance:DestroyAllChildren(shuzi)
    local grid = shuzi:GetComponent(UIGrid)
    grid = grid or shuzi:AddComponent(UIGrid)
    if grid then
      grid.cellWidth = 19
      grid.pivot = UIWidget.Pivot.Center
      local manualLevel = AdventureDataProxy.Instance:getManualLevel()
      manualLevel = StringUtil.StringToCharArray(tostring(manualLevel))
      for i = 1, #manualLevel do
        local obj = GameObject("tx")
        obj.transform:SetParent(grid.transform, false)
        tempVector3:Set(0, 0, 0)
        obj.transform.localPosition = tempVector3
        local sprite = obj:AddComponent(UISprite)
        local atlas = RO.AtlasMap.GetAtlas("NewCom")
        sprite.atlas = atlas
        sprite.depth = 200
        sprite.spriteName = string.format("txt_%d", manualLevel[i])
        sprite:MakePixelPerfect()
      end
      grid:Reposition()
    end
  end
end
function FloatingPanel:ReInitEffect(rid, container, pos, destoryCallback)
  self.catch = self.catch or {}
  local result = self.catch[rid]
  if not self:ObjIsNil(result) then
    if type(destoryCallback) == "function" then
      destoryCallback(result)
    end
    GameObject.DestroyImmediate(result)
  end
  result = GameObjPool.Instance:RGet(rid, "UI", container)
  tempVector3:Set(0, 0, 0)
  result.transform.localPosition = pos or tempVector3
  self.catch[rid] = result
  return result
end
function FloatingPanel:AddCountDown(text, data)
  if self.countDownMsg == nil or self.countDownMsg and self.countDownMsg.hasBeenDestroyed then
    self.countDownMsg = CountDownMsg.new(self.gameObject)
  end
  self.countDownMsg:SetData(text, data)
end
function FloatingPanel:RemoveCountDown(id)
  if self.countDownMsg and not self.countDownMsg.hasBeenDestroyed and self.countDownMsg.data.id == id then
    self.countDownMsg:DestroySelf()
  end
  self.countDownMsg = nil
end
function FloatingPanel:SetCountDownRemoveOnChangeScene(id, value)
  if self.countDownMsg and not self.countDownMsg.hasBeenDestroyed and self.countDownMsg.data.id == id then
    self.countDownMsg.DestroyWhenLoadScene = value
  end
end
function FloatingPanel:GetMidMsg()
  self:RemoveMidMsg()
  self.midMsg = MidMsg.new(self.gameObject)
  return self.midMsg
end
function FloatingPanel:RemoveMidMsg()
  if self.midMsg then
    self.midMsg:Exit()
    self.midMsg = nil
  end
end
function FloatingPanel:ShowMidAlphaMsg(text)
  if not self.midAlphaMsg then
    self.midAlphaMsg = MidAlphaMsg.new(self.gameObject)
  end
  self.midAlphaMsg:SetData(text)
  self.midAlphaMsg:SetExitCall(self.MidAlphaMsgEnd, self)
end
function FloatingPanel:MidAlphaMsgEnd()
  self.midAlphaMsg = nil
end
function FloatingPanel:FloatShowyMsg(text)
  if self.showyMsg then
    self.showyMsg:Exit()
  end
  self.showyMsg = ShowyMsg.new(self.gameObject)
  self.showyMsg:SetExitCall(function()
    self.showyMsg = nil
  end)
  local data = {text = text}
  self.showyMsg:SetData(data)
  self.showyMsg:Enter()
end
local tempArgs = {}
function FloatingPanel:CloseMaintenanceMsg()
  if self.maintenanceMsg then
    self.maintenanceMsg:Exit()
  end
end
function FloatingPanel:ShowMaintenanceMsg(title, text, remark, buttonlab, picPath, confirmCall)
  self:CloseMaintenanceMsg()
  self.maintenanceMsg = MaintenanceMsg.new(self.gameObject)
  self.maintenanceMsg:SetExitCall(function()
    self.maintenanceMsg = nil
  end)
  TableUtility.TableClear(tempArgs)
  tempArgs[1] = title
  tempArgs[2] = text
  tempArgs[3] = remark
  tempArgs[4] = buttonlab
  tempArgs[5] = picPath
  tempArgs[6] = confirmCall
  self.maintenanceMsg:SetData(tempArgs)
  return self.maintenanceMsg
end
