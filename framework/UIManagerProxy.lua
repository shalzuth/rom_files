autoImport("UILayer")
autoImport("UINode")
UIManagerProxy = class("UIManagerProxy", pm.Proxy)
UIManagerProxy.Instance = nil
function UIManagerProxy:ctor()
  self.proxyName = "UIManagerProxy"
  self:InitMyMobileScreenAdaption()
  self.UIRoot = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("UIRoot"))
  local uiroot = self.UIRoot:GetComponent(UIRoot)
  if uiroot then
    local screen = NGUITools.screenSize
    local aspect = screen.x / screen.y
    local initialAspect = uiroot.manualWidth / uiroot.manualHeight
    if aspect > initialAspect + 0.1 then
      uiroot.fitWidth = false
      uiroot.fitHeight = true
      local manualHeight = self:GetMyMobileScreenAdaptionManualHeight()
      if manualHeight then
        uiroot.manualHeight = manualHeight
      end
    end
    self.rootSize = {
      math.floor(uiroot.activeHeight * aspect),
      uiroot.activeHeight
    }
    self.UIRootComp = uiroot
  end
  GameObject.DontDestroyOnLoad(self.UIRoot)
  local speechGO = GameObject("SpeechRecognizer")
  speechGO.transform.parent = self.UIRoot.transform
  speechGO:AddComponent(AudioSource)
  self.speechRecognizer = speechGO:AddComponent(SpeechRecognizer)
  self.layers = {}
  self.forbidview_map = {}
  UIManagerProxy.Instance = self
  self:InitLayers()
  self:InitRollBack()
  self:InitViewPop()
  self:DoMobileScreenAdaptionAnchors()
end
function UIManagerProxy:GetUIRootSize()
  return self.rootSize
end
function UIManagerProxy:InitLayers()
  local layers = {}
  for k, v in pairs(UIViewType) do
    layers[#layers + 1] = v
  end
  table.sort(layers, function(l, r)
    return l.depth < r.depth
  end)
  for i = 1, #layers do
    self.layers[layers[i].name] = self:SpawnLayer(layers[i])
  end
  self.childPopObjList = {}
end
function UIManagerProxy:InitRollBack()
  self.rollBackMap = {}
  local panelData, viewClass
  for i = 1, #UIRollBackID do
    panelData = PanelProxy.Instance:GetData(UIRollBackID[i])
    if panelData then
      viewClass = self:GetImport(panelData.class)
      if viewClass then
        self.rollBackMap[viewClass] = 1
      end
    end
  end
end
function UIManagerProxy:SpawnLayer(data)
  local layer = UILayer.new(data, self.UIRoot)
  layer:AddEventListener(UILayer.AddChildEvent, self.LayerAddChildHandler, self)
  layer:AddEventListener(UILayer.EmptyChildEvent, self.LayerEmptyHandler, self)
  return layer
end
function UIManagerProxy:ShowUI(data, prefab, class)
  local viewid = data.view and data.view.id
  local forbid_msg = viewid and self.forbidview_map[viewid]
  if forbid_msg then
    if forbid_msg ~= -1 then
      MsgManager.ShowMsgByIDTable(forbid_msg)
    end
    return
  end
  FunctionPreload.Me():AddLoadFrequency_UI(prefab or data.viewname, 1)
  local viewClass = self:GetImport(class or data.viewname)
  if viewClass then
    local viewType = viewClass.ViewType
    local layer = self:GetLayerByType(viewType)
    if layer then
      return layer:CreateChild(data, prefab, class, self.rollBackMap[viewClass] ~= nil)
    end
  end
  return nil
end
function UIManagerProxy:ShowUIByConfig(data)
  return self:ShowUI(data, data.view.prefab, data.view.class)
end
function UIManagerProxy:CloseUI(viewCtrl)
  if viewCtrl then
    local viewType = viewCtrl.ViewType
    local layer = self:GetLayerByType(viewType)
    if layer then
      layer:DestoryChildByCtrl(viewCtrl)
      layer:TryRollBackPrevious()
    end
  end
end
function UIManagerProxy:CloseLayerAllChildren(viewType)
  if viewType then
    local layer = self:GetLayerByType(viewType)
    if layer then
      layer:DestoryAllChildren()
      layer:TryRollBackPrevious()
    end
  end
end
function UIManagerProxy:LayerAddChildHandler(evt)
  self:AddHideOtherLayers(evt.target)
  self:CloseOtherLayers(evt.target)
end
function UIManagerProxy:LayerEmptyHandler(evt)
  self:RemoveHideOtherLayers(evt.target)
end
function UIManagerProxy:CloseOtherLayers(layer)
  local closeOthers = layer.data.closeOtherLayer
  if closeOthers then
    for k, v in pairs(closeOthers) do
      self:CloseLayerAllChildren(UIViewType[k])
    end
  end
end
function UIManagerProxy:AddHideOtherLayers(layer)
  if layer.data.hideOtherLayer then
    local hideOther = layer.data.hideOtherLayer
    local otherLayer, name
    for k, v in pairs(hideOther) do
      name = UIViewType[k].name
      otherLayer = self.layers[name]
      otherLayer:AddHideMasterLayer(layer)
    end
  end
end
function UIManagerProxy:RemoveHideOtherLayers(layer)
  if layer.data.hideOtherLayer then
    local hideOther = layer.data.hideOtherLayer
    local otherLayer, name
    for k, v in pairs(hideOther) do
      name = UIViewType[k].name
      otherLayer = self.layers[name]
      otherLayer:RemoveHideMasterLayer(layer)
    end
  end
end
function UIManagerProxy:GetLayerByType(viewType)
  return self.layers[viewType.name]
end
function UIManagerProxy:HasUINode(panelConfig)
  local class = self:GetImport(panelConfig.class)
  if class ~= nil and class.ViewType ~= nil then
    local layer = self:GetLayerByType(class.ViewType)
    if layer then
      return layer:FindNodeByClassName(panelConfig.class) ~= nil
    end
  end
  return false
end
function UIManagerProxy:GetImport(viewname)
  local viewCtrl = _G[viewname]
  if not viewCtrl then
    viewCtrl = autoImport(viewname)
    if type(viewCtrl) ~= "table" then
      viewCtrl = _G[viewname]
    end
  end
  return viewCtrl
end
function UIManagerProxy:InitViewPop()
  self.modalLayer = {
    UIViewType.ChatroomLayer,
    UIViewType.ChitchatLayer,
    UIViewType.TeamLayer,
    UIViewType.ChatLayer,
    UIViewType.FocusLayer,
    UIViewType.NormalLayer,
    UIViewType.PopUpLayer,
    UIViewType.ConfirmLayer,
    UIViewType.SystemOpenLayer,
    UIViewType.Show3D2DLayer,
    UIViewType.ShareLayer,
    UIViewType.Popup10Layer,
    UIViewType.TipLayer,
    UIViewType.DialogLayer
  }
  for i = #self.modalLayer, 1, -1 do
    if self.modalLayer[i] == nil then
      table.remove(self.modalLayer, i)
    end
  end
  table.sort(self.modalLayer, function(l, r)
    return l.depth < r.depth
  end)
end
function UIManagerProxy:GetModalPopCount()
  local count = 0
  local layer
  for i = 1, #self.modalLayer do
    layer = self.layers[self.modalLayer[i].name]
    if UIViewType.TipLayer.name == layer.name and UIViewType.TipLayer.depth == layer.depth then
      if TipsView:Me().currentTip ~= nil then
        count = count + 1
      end
    else
      count = count + #layer.nodes
    end
  end
  local obj
  for i = 1, #self.childPopObjList do
    obj = self.childPopObjList[i][2]
    if not Slua.IsNull(obj) and obj.activeInHierarchy then
      count = count + 1
    end
  end
  helplog("\229\189\147\229\137\141\232\191\152\230\156\137", count)
  return count
end
function UIManagerProxy:DoesModalPopHaveDialogLayer()
  local count = 0
  local layer
  for i = 1, #self.modalLayer do
    layer = self.layers[self.modalLayer[i].name]
    if UIViewType.TipLayer.name == layer.name and UIViewType.TipLayer.depth == layer.depth then
      if self.modalLayer[i] == UIViewType.DialogLayer then
        return true
      end
    elseif 0 < #layer.nodes and self.modalLayer[i] == UIViewType.DialogLayer then
      return true
    end
  end
  return false
end
function UIManagerProxy:PopView()
  helplog("pop \228\184\128\228\184\170\231\149\140\233\157\162")
  local layer, suc
  for i = #self.modalLayer, 1, -1 do
    layer = self.layers[self.modalLayer[i].name]
    if UIViewType.TipLayer.name == layer.name and UIViewType.TipLayer.depth == layer.depth then
      if TipsView:Me().currentTip ~= nil then
        helplog(layer.name, layer.nodes[#layer.nodes].viewname)
        TipsView.Me():HideCurrent()
        suc = true
        break
      end
    elseif #layer.nodes > 0 then
      helplog(layer.name, layer.nodes[#layer.nodes].viewname)
      layer:DestoryChild(layer.nodes[#layer.nodes])
      layer:TryRollBackPrevious()
      suc = true
      break
    end
  end
  if not suc then
    for i = #self.childPopObjList, 1, -1 do
      local obj = self.childPopObjList[i][2]
      if Slua.IsNull(obj) then
        table.remove(self.childPopObjList, i)
      elseif obj.activeInHierarchy then
        obj:SetActive(false)
        break
      end
    end
  end
  return self:GetModalPopCount()
end
function UIManagerProxy:SetForbidView(viewid, forbidMsgid, forceClose)
  self.forbidview_map[viewid] = forbidMsgid or -1
  if forceClose then
    local viewdata = PanelProxy.Instance:GetData(viewid)
    if viewdata then
      self:CloseLayerAllChildren(self:GetImport(viewdata.class).ViewType)
    end
  end
end
function UIManagerProxy:UnSetForbidView(viewid)
  self.forbidview_map[viewid] = nil
end
function UIManagerProxy:NeedEnableAndroidKey(needEnable, callBack)
  if BackwardCompatibilityUtil.CompatibilityMode_V28 then
  else
    AndroidKey.Instance:NeedEnableAndroidKey(needEnable, function()
      if UIManagerProxy.Instance:DoesModalPopHaveDialogLayer() then
        MsgManager.ShowMsgByID(27001)
      elseif callBack then
        callBack()
      end
    end)
  end
end
function UIManagerProxy:InitMyMobileScreenAdaption()
  self.isLandscapeLeft = true
  EventManager.Me():AddEventListener(AppStateEvent.OrientationChange, self.HandleOrientationChange, self)
  self.mobileScreenAdaptionMap = {}
  local modelName = SystemInfo.deviceModel
  LogUtility.InfoFormat("DeviceModel: {0}", modelName)
  local adaptMap = self.mobileScreenAdaptionMap
  for _, v in pairs(Table_MobileScreenAdaption) do
    if v.IsValid and v.IsValid > 0 and v.DeviceInfo == modelName then
      adaptMap.ManualHeight = adaptMap.ManualHeight or v.ManualHeight
      adaptMap.SpecialView = adaptMap.SpecialView or v.SpecialView
      adaptMap[v.RotationType] = adaptMap[v.RotationType] or {}
      local rotMap = adaptMap[v.RotationType]
      if not next(rotMap) then
        rotMap.l = v.offset_left
        rotMap.t = v.offset_top
        rotMap.r = v.offset_right
        rotMap.b = v.offset_bottom
      end
    end
  end
end
function UIManagerProxy:DoMobileScreenAdaptionAnchors()
  if self.mobileScreenAdaptionMap and not next(self.mobileScreenAdaptionMap) then
    self.mobileScreenAdaptionMap = nil
    return false
  end
  if GameConfig.SystemForbid.MobileScreenAdaption then
    return false
  end
  if BackwardCompatibilityUtil.CompatibilityMode_V29 then
    return false
  end
  local l, t, r, b = self:GetMyMobileScreenAdaptionOffsets(self.isLandscapeLeft)
  if l then
    ApplicationInfo.SetSafeAreaSides(l, t, r, b)
    if not self.UIRootComp then
      self.UIRootComp = self.UIRoot:GetComponent(UIRoot)
    end
    if self.UIRootComp then
      self.UIRootComp:ResetAnchorsAndUpdateAllChildren()
      return true
    end
  end
  return false
end
function UIManagerProxy:DoMobileScreenAdaptionOfViewCtl(ctl, action)
  if GameConfig.SystemForbid.MobileScreenAdaption then
    return false
  end
  local ctlAdaptionData = self:GetMyMobileScreenAdaptionOfViewCtl(ctl.__cname)
  if not ctlAdaptionData or not next(ctlAdaptionData) then
    LogUtility.WarningFormat("Cannot find adaption data of viewctl:{0} when doing MobileScreenAdaption!", ctl.__cname)
    return false
  end
  for key, data in pairs(ctlAdaptionData) do
    action(key, data)
  end
  return true
end
function UIManagerProxy:HandleOrientationChange(note)
  if note.data == nil then
    LogUtility.Warning("UIManagerProxy: received AppStateEvent.OrientationChange with isLandscapeLeft = nil")
    return
  end
  self.isLandscapeLeft = note.data
  self:DoMobileScreenAdaptionAnchors()
  for _, layer in pairs(self.layers) do
    layer:DisposeCachedNodeByShowHideMode(PanelShowHideMode.MoveOutAndMoveIn)
  end
end
function UIManagerProxy:GetMyMobileScreenAdaptionOffsets(isLandscapeLeft)
  local rotationType = isLandscapeLeft ~= false and 1 or 2
  local rotMap = self:GetMyMobileScreenAdaptionValue(rotationType)
  if not rotMap or not next(rotMap) then
    return nil
  end
  return rotMap.l, rotMap.t, rotMap.r, rotMap.b
end
function UIManagerProxy:GetMyMobileScreenAdaptionManualHeight()
  return self:GetMyMobileScreenAdaptionValue("ManualHeight")
end
function UIManagerProxy:GetMyMobileScreenAdaptionSpecialView()
  return self:GetMyMobileScreenAdaptionValue("SpecialView")
end
function UIManagerProxy:GetMyMobileScreenAdaptionOfViewCtl(ctlName)
  local specialViewMap = self:GetMyMobileScreenAdaptionSpecialView()
  if not specialViewMap or not ctlName then
    return nil
  end
  for name, data in pairs(specialViewMap) do
    if name == ctlName then
      return data
    end
  end
  return nil
end
function UIManagerProxy:GetMyMobileScreenAdaptionValue(key)
  if not self.mobileScreenAdaptionMap then
    return nil
  end
  return self.mobileScreenAdaptionMap[key]
end
function UIManagerProxy:GetMyMobileScreenSize(exVal)
  exVal = exVal or 0
  local screen = NGUITools.screenSize
  local aspect = screen.x / screen.y
  local manualHeight = self:GetMyMobileScreenAdaptionManualHeight()
  if manualHeight then
    return exVal + aspect * manualHeight, exVal + manualHeight
  else
    return 1280 + exVal, 1280 / aspect + exVal
  end
end
function UIManagerProxy:RegisterChildPopObj(layer, obj)
  local length = #self.childPopObjList
  if length == 0 then
    table.insert(self.childPopObjList, {layer, obj})
    return
  end
  local clayer
  for i = 1, length do
    clayer = self.childPopObjList[i][1]
    if layer.depth < clayer.depth then
      table.insert(self.childPopObjList, i, {layer, obj})
      inserted = true
      break
    elseif i == length then
      table.insert(self.childPopObjList, {layer, obj})
    end
  end
end
function UIManagerProxy:UnRegisterChildPopObj(layer)
  local clayer
  for i = #self.childPopObjList, 1, -1 do
    if clayer == layer then
      table.remove(self.childPopObjList, i)
    end
  end
end
XDEUIEvent = {
  RoleBack = "XDERoleBack",
  CreateBack = "XDECreateBack",
  SignInMapViewBack = "SignInMapViewBack",
  ChargeLimitPanelBack = "ChargeLimitPanelBack",
  CreditNodeBack = "CreditNodeBack",
  PocketLotteryViewBack = "PocketLotteryView",
  ChatEmpty = "ChatEmpty",
  CloseCharTitle = "CloseCharTitle",
  LotteryAnimationEnd = "LotteryAnimationEnd",
  CloseCreateRoleTip = "CloseCreateRoleTip"
}
function UIManagerProxy:HasUINodeByName(panelConfig)
  local class = self:GetImport(panelConfig.class)
  if class ~= nil and class.ViewType ~= nil then
    local layer = self:GetLayerByType(class.ViewType)
    if layer then
      return layer:FindNodeByName(panelConfig.class) ~= nil
    end
  end
  return false
end
function UIManagerProxy.CSPopView()
  local count = UIManagerProxy.Instance:GetModalPopCount()
  if count == 0 then
    local viewClass = UIManagerProxy.Instance:GetImport("DialogView")
    if viewClass then
      local viewType = viewClass.ViewType
      local layer = UIManagerProxy.Instance:GetLayerByType(viewType)
      if layer then
        local tmp = layer:FindNodeByName("DialogView")
        if tmp ~= nil then
          MsgManager.FloatMsg("", ZhString.Oversea_Msg_1)
          return
        else
          helplog("\230\178\161\230\137\190\229\136\176 DialogView")
        end
      end
    end
    if UIManagerProxy.Instance:HasUINode(PanelConfig.RolesSelect) then
      GameFacade.Instance:sendNotification(XDEUIEvent.RoleBack)
    elseif UnityEngine.GameObject.Find("CreateRoleViewV2") then
      GameFacade.Instance:sendNotification(XDEUIEvent.CreateBack)
    elseif UIManagerProxy.Instance:HasUINode(PanelConfig.NewServerSignInMapView) then
      GameFacade.Instance:sendNotification(XDEUIEvent.SignInMapViewBack)
    else
      UIUtil.PopUpConfirmYesNoView("\230\143\144\231\164\186", "\231\162\186\229\174\154\233\128\128\229\135\186\233\129\138\230\136\178\239\188\159", function()
        OverSeas_TW.OverSeasManager.GetInstance():TryKillSelf()
      end, function()
      end, nil, "\231\161\174\229\174\154", "\229\143\150\230\182\136")
    end
  elseif UIManagerProxy.Instance:HasUINodeByName(PanelConfig.ChargeLimitPanel) then
    GameFacade.Instance:sendNotification(XDEUIEvent.ChargeLimitPanelBack)
    GameFacade.Instance:sendNotification(XDEUIEvent.CreditNodeBack)
  elseif UIManagerProxy.Instance:HasUINodeByName(PanelConfig.PocketLotteryView) then
    GameFacade.Instance:sendNotification(XDEUIEvent.PocketLotteryViewBack)
  else
    UIManagerProxy.Instance:PopView()
  end
end
