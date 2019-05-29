autoImport("EventDispatcher")
CoreView = class("CoreView", EventDispatcher)
CoreView.OpenLog = true
CoreView.RotateCamera = true
autoImport("UIPlayerSceneInfo")
function CoreView:ctor(go)
  self.gameObject = go
  if go ~= nil then
    self.trans = go.transform
  end
  self.effectCache = {}
  self:AddHelpButtonEvent()
end
function CoreView:AddGameObjectComp()
  if self.gameObject then
    local comp = self.gameObject:GetComponent(GameObjectForLua)
    comp = comp or self.gameObject:AddComponent(GameObjectForLua)
    function comp.onEnable(go)
      self:OnEnable()
    end
    function comp.onDisable(go)
      self:OnDisable()
    end
    function comp.onDestroy(go)
      self:OnDestroy()
    end
  end
end
function CoreView:AddHelpButtonEvent()
  local go = self:FindGO("HelpButton")
  if go then
    self:AddClickEvent(go, function(g)
      self:OpenHelpView()
    end)
  end
end
function CoreView:OpenHelpView(data)
  if data == nil then
    data = Table_Help[self.viewdata.view.id]
  end
  if data then
    TipsView.Me():ShowGeneralHelp(data.Desc, data.Title)
  else
    errorLog("can not find Table_Help content,id is " .. self.viewdata.view.id)
  end
end
function CoreView:OnEnable()
end
function CoreView:OnDisable()
end
function CoreView:OnDestroy()
end
function CoreView:FindChild(name, parent)
  parent = parent or self.gameObject
  if parent == nil then
    return nil
  else
    return GameObjectUtil.Instance:DeepFindChild(parent, name)
  end
end
function CoreView:FindGO(name, parent)
  parent = parent or self.gameObject
  return parent ~= nil and GameObjectUtil.Instance:DeepFind(parent, name) or nil
end
function CoreView:FindComponent(name, comp, parent)
  local obj = self:FindGO(name, parent)
  obj = obj and obj:GetComponent(comp)
  return obj
end
function CoreView:FindComponents(compType, parent, containSelf)
  parent = parent or self.gameObject
  containSelf = containSelf == nil or true
  if not self:ObjIsNil(parent) then
    return GameObjectUtil.Instance:GetAllComponentsInChildren(parent, compType, containSelf) or {}
  end
  return {}
end
function CoreView:AddButtonEvent(name, event, hideType)
  local buttonobj = self:FindGO(name)
  if buttonobj then
    self:AddClickEvent(buttonobj, event, hideType)
  end
end
function CoreView:AddClickEvent(obj, event, hideType)
  if event == nil then
    UIEventListener.Get(obj).onClick = nil
    return
  end
  UIEventListener.Get(obj).onClick = function(go)
    if go and not GameObjectUtil.Instance:ObjectIsNULL(go) then
      local cmt = go:GetComponent(GuideTagCollection)
      if cmt and cmt.id ~= -1 then
        FunctionGuide.Me():triggerWithTag(cmt.id)
      end
      local positionX, positionY = LuaGameObject.GetMousePosition()
      AAAManager.Me():ClickEvent(go.name, positionX, positionY)
    end
    if not hideType or hideType and not hideType.hideClickSound then
      self:PlayUISound(AudioMap.UI.Click)
    end
    if event then
      event(go)
    end
  end
end
function CoreView:AddDoubleClickEvent(obj, event)
  local myDClick = obj:GetComponent(MyCheckDoublcClick)
  myDClick = myDClick or obj:AddComponent(MyCheckDoublcClick)
  function myDClick.onDoubleClick(go)
    event()
  end
end
function CoreView:AddPressEvent(obj, event, hideType)
  UIEventListener.Get(obj).onPress = function(obj, isPress)
    if event then
      event(obj, isPress)
    end
    local hideRet = not hideType or hideType and not hideType.hideClickEffect
    local start = hideRet and isPress
    if not self.effectCache then
      return
    end
    if start then
      local count = self.effectCache[obj] or 0
      self.effectCache[obj] = count + 1
      local delay = GameConfig.ClickEffectDelay or 0.6
      LeanTween.delayedCall(delay, function()
        self:reduceEffectCacheCount(obj)
      end)
    else
      local endR = hideRet and not isPress
      if endR and self.effectCache[obj] and self.effectCache[obj] > 0 then
        ClickEffectView.ShowClickEffect()
        self:reduceEffectCacheCount(obj)
      end
    end
  end
end
function CoreView:reduceEffectCacheCount(obj)
  local count = self.effectCache[obj] or 0
  count = count - 1
  if count < 1 then
    self.effectCache[obj] = nil
  else
    self.effectCache[obj] = count
  end
end
function CoreView:AddDragEvent(obj, event)
  UIEventListener.Get(obj).onDrag = event
end
function CoreView:AddTabEvent(obj, event, hideSound)
  if obj then
    do
      local togs = GameObjectUtil.Instance:GetAllComponentsInChildren(obj, UIToggle, true)
      local tog = togs and togs[1]
      self:AddClickEvent(obj, function(go)
        local value = false
        if tog then
          value = tog.value
        end
        if event then
          event(go, value)
        end
        if not hideSound then
          self:PlayUISound(AudioMap.UI.Tab)
        end
      end, {hideClickSound = true})
    end
  else
  end
end
function CoreView:PlayAnim(go, animName)
  local animator = go:GetComponent(Animator)
  if animator then
    animator:Play(animName, -1, 0)
  end
end
function CoreView:ObjIsNil(obj)
  return LuaGameObject.ObjectIsNull(obj)
end
function CoreView:LoadPreferb(viewName, parent, initPanel)
  return self:LoadPreferb_ByFullPath(ResourcePathHelper.UIV1(viewName), parent, initPanel)
end
function CoreView:LoadPreferb_ByFullPath(path, parent, initPanel)
  local parent = parent or self.gameObject
  local obj = Game.AssetManager_UI:CreateAsset(path, parent.gameObject)
  if obj == nil then
    errorLog(path)
    return
  end
  obj.transform.localPosition = Vector3.zero
  if obj and initPanel then
    local upPanel = UIUtil.GetComponentInParents(obj, UIPanel)
    if upPanel then
      local panels = UIUtil.GetAllComponentsInChildren(obj, UIPanel, true)
      for i = 1, #panels do
        panels[i].depth = panels[i].depth + upPanel.depth
      end
    end
  end
  return obj, path
end
function CoreView:PlayUIEffect(id, container, once, callback, callArgs)
  local effect
  container = container or self.gameObject
  if not self:ObjIsNil(container) then
    local path = ResourcePathHelper.UIEffect(id)
    if once then
      effect = Asset_Effect.PlayOneShotOn(path, container.transform, callback, callArgs)
    else
      effect = Asset_Effect.PlayOn(path, container.transform, callback, callArgs)
    end
  end
  return effect
end
function CoreView:PlayUITrailEffect(id, container)
  container = container or self.gameObject
  local path = ResourcePathHelper.UIEffect(id)
  return Asset_Effect.PlayOn(path, container)
end
function CoreView:CopyGameObject(obj, parent)
  if self:ObjIsNil(obj) then
    return
  end
  local result = GameObject.Instantiate(obj)
  if parent == nil then
    parent = obj.transform.parent
  else
    parent = parent.transform
  end
  if parent ~= nil then
    result.transform:SetParent(parent, false)
  end
  return result
end
function CoreView:SetGOActive(gmeobj, b)
  if gmeobj.activeSelf ~= b then
    gmeobj:SetActive(b)
  end
end
function CoreView:SetActive(obj, state)
  if obj and obj.gameObject then
    obj.gameObject:SetActive(state)
  end
end
function CoreView:Show(target)
  target = target and target.gameObject or self.gameObject
  if target and target.activeSelf == false then
    target:SetActive(true)
  end
end
function CoreView:Hide(target)
  target = target and target.gameObject or self.gameObject
  if target and target.activeSelf == true then
    target:SetActive(false)
  end
end
function CoreView:PlayUISoundOnGameObject(obj, source)
  local soundComp = obj:GetComponent(UIPlaySound)
  soundComp = soundComp or obj:AddComponent(UIPlaySound)
  local resPath = ResourcePathHelper.AudioSEUI(source)
  if resPath then
    local volume = AudioUtility.GetVolume(v) or 1
    soundComp.volume = volume
    local clip = ResourceManager.Instance:SLoadByType(resPath, AudioClip)
    soundComp.audioClip = clip
    soundComp.trigger = 3
  end
end
function CoreView:PlayUISound(source)
  return AudioUtility.PlayOneShot2D_Path(ResourcePathHelper.AudioSEUI(source))
end
function CoreView:PlayCommonSound(source)
  return AudioUtility.PlayOneShot2D_Path(ResourcePathHelper.AudioSECommon(source))
end
function CoreView:sendNotification(notificationName, body, type)
  GameFacade.Instance:sendNotification(notificationName, body, type)
end
function CoreView:AddOrRemoveGuideId(objOrName, id)
  local argType = type(objOrName)
  local obj = objOrName
  if argType == "string" then
    obj = self:FindGO(objOrName)
    if obj == nil then
      printRed("can't find the gameObject" .. objOrName)
      return
    end
  end
  if obj == nil then
    printRed("the gameObject is nil")
  else
    local cmt = obj:GetComponent(GuideTagCollection)
    local collider = obj:GetComponent(BoxCollider)
    if id and id ~= -1 then
      cmt = cmt or obj:AddComponent(GuideTagCollection)
      if not collider then
        obj:AddComponent(BoxCollider)
      end
      cmt.id = id
      FunctionGuide.Me():setGuideUIActive(id, true)
    elseif cmt then
      FunctionGuide.Me():setGuideUIActive(cmt.id, false)
      cmt.id = -1
    end
  end
end
function CoreView:removeChildren(go)
  if not self:ObjIsNil(go) then
    local count = go.transform.childCount
    self:Log(count)
    for i = 0, count - 1 do
      local obj = go.transform:GetChild(0)
      if obj then
        GameObject.DestroyImmediate(obj.gameObject)
      end
    end
  end
end
function CoreView:SetTextureGrey(go, effectColor)
  self:SetTextureColor(go, Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941))
  local labels = GameObjectUtil.Instance:GetAllComponentsInChildren(go.gameObject, UILabel, true)
  for i = 1, #labels do
    labels[i].effectColor = effectColor or Color(0.615686274509804, 0.615686274509804, 0.615686274509804)
    labels[i].gradientTop = Color(0.615686274509804, 0.615686274509804, 0.615686274509804)
  end
end
function CoreView:SetTextureWhite(go, effectColor)
  self:SetTextureColor(go)
  local labels = GameObjectUtil.Instance:GetAllComponentsInChildren(go.gameObject, UILabel, true)
  for i = 1, #labels do
    labels[i].effectColor = effectColor or Color(1, 1, 1)
    labels[i].gradientTop = Color(1, 1, 1)
  end
end
function CoreView:SetTextureColor(go, color, includeChild)
  if color == nil then
    color = Color(1, 1, 1)
  end
  if includeChild == nil then
    includeChild = true
  end
  if includeChild then
    local sprites = GameObjectUtil.Instance:GetAllComponentsInChildren(go.gameObject, UISprite, true)
    for i = 1, #sprites do
      sprites[i].color = color
    end
  else
    local sprite = go:GetComponent(UISprite)
    sprite.color = color
  end
end
function CoreView:GetRestrictViewPort(oriViewPort)
  local vp_x, vp_y, vp_z = oriViewPort[1], oriViewPort[2], oriViewPort[3]
  local viewWidth = UIManagerProxy.Instance:GetUIRootSize()[1]
  vp_x = 0.5 - (0.5 - vp_x) * 1280 / viewWidth
  if self.temp_ViewPort == nil then
    self.temp_ViewPort = LuaVector3()
  end
  self.temp_ViewPort:Set(vp_x, vp_y, vp_z)
  return self.temp_ViewPort
end
function CoreView:CameraRotateToMe(replaceMySceneInfo, viewPort, rotation, rotateOffset)
  if not CoreView.RotateCamera then
    return
  end
  if self.cft ~= nil then
    self:CameraReset()
  end
  if nil == CameraController.singletonInstance then
    return
  end
  local myTrans = Game.Myself.assetRole.completeTransform
  viewPort = viewPort or CameraConfig.UI_ViewPort
  if rotation == nil then
    rotation = CameraController.singletonInstance.targetRotationEuler
    rotation = Vector3(CameraConfig.UI_ViewRotationX, rotation.y, rotation.z)
  end
  self.cft = CameraEffectFocusAndRotateTo.new(myTrans, nil, self:GetRestrictViewPort(viewPort), rotation, CameraConfig.UI_Duration)
  FunctionCameraEffect.Me():Start(self.cft)
  if replaceMySceneInfo then
    self.uiPlayerSceneInfo = UIPlayerSceneInfo.new(self.gameObject, self.viewdata.view.id)
    self.uiPlayerSceneInfo:OnEnter()
  end
end
function CoreView:CameraFaceTo(transform, viewPort, rotation, duration, rotateOffset, listener)
  if not CoreView.RotateCamera then
    return
  end
  if nil == CameraController.singletonInstance then
    return
  end
  viewPort = viewPort or CameraConfig.UI_ViewPort
  rotation = rotation or CameraController.singletonInstance.targetRotationEuler
  duration = duration or CameraConfig.UI_Duration
  self.cft = CameraEffectFaceTo.new(transform, nil, self:GetRestrictViewPort(viewPort), rotation, duration, listener)
  if rotateOffset then
    self.cft:SetRotationOffset(rotateOffset)
  end
  FunctionCameraEffect.Me():Start(self.cft)
end
function CoreView:CameraFocusAndRotateTo(transform, viewPort, rotation, duration, listener)
  if not CoreView.RotateCamera then
    return
  end
  if nil == CameraController.singletonInstance then
    return
  end
  viewPort = viewPort or CameraConfig.UI_ViewPort
  duration = duration or CameraConfig.UI_Duration
  rotation = rotation or CameraController.singletonInstance.targetRotationEuler
  self.cft = CameraEffectFocusAndRotateTo.new(transform, nil, self:GetRestrictViewPort(viewPort), rotation, duration, listener)
  FunctionCameraEffect.Me():Start(self.cft)
end
function CoreView:CameraFocusOnNpc(npcTrans, viewPort, duration)
  if not CoreView.RotateCamera then
    return
  end
  viewPort = viewPort or CameraConfig.NPC_FuncPanel_ViewPort
  duration = duration or CameraConfig.NPC_Dialog_DURATION
  self.cft = CameraEffectFocusTo.new(npcTrans, self:GetRestrictViewPort(viewPort), duration)
  FunctionCameraEffect.Me():Start(self.cft)
end
function CoreView:CameraReset()
  if self.cft ~= nil then
    FunctionCameraEffect.Me():End(self.cft)
    self.cft = nil
  end
  if self.uiPlayerSceneInfo then
    self.uiPlayerSceneInfo:OnExit()
    self.uiPlayerSceneInfo = nil
  end
end
function CoreView:ShowItemTip(data, stick, side, offset, isShowFavorite)
  if data then
    local view = self.viewdata and self.viewdata.view
    if data.hideGetPath == nil then
      local hideGetPath = false
      if view and view.id then
        local hideViews = GameConfig.ItemTipGetPathShow and GameConfig.ItemTipGetPathShow.HideViews
        if hideViews then
          hideGetPath = TableUtil.HasValue(hideViews, view.id)
        end
      end
      data.hideGetPath = hideGetPath
    end
    return TipManager.Instance:ShowItemFloatTip(data, stick, side, offset, isShowFavorite)
  else
    TipManager.Instance:CloseItemTip()
  end
end
function CoreView:AddSelectEvent(obj, event)
  if not self:ObjIsNil(obj) then
    obj = obj.gameObject
    local func = function(go, state)
      if event then
        event(go, state)
      end
    end
    UIEventListener.Get(obj).onSelect = {"+=", func}
  end
end
function CoreView:Log(...)
  if self.OpenLog then
    helplog(...)
  end
end
function CoreView:LogError(prefix, data)
  if self.OpenLog then
    helpPrint(prefix, "red")
    if data ~= nil then
      printData(data)
    end
  end
end
