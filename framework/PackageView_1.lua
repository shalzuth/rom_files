PackageView = class("PackageView", ContainerView)
autoImport("PackageMainPage")
autoImport("PackageEquipPage")
autoImport("PackageSetQuickPage")
autoImport("PackageBarrowBagPage")
autoImport("BaseAttributeView")
autoImport("EquipStrengthen")
PackageView.ViewType = UIViewType.NormalLayer
PackageView.LeftViewState = {
  Default = "PackageView_LeftViewState_Default",
  Fashion = "PackageView_LeftViewState_Fashion",
  RoleInfo = "PackageView_LeftViewState_RoleInfo",
  BarrowBag = "PackageView_LeftViewState_BarrowBag"
}
PackageView.TabName = {
  [1] = ZhString.PackageView_BagTabName,
  [2] = ZhString.PackageView_StrengthTabName
}
function PackageView:GetShowHideMode()
  return PanelShowHideMode.MoveOutAndMoveIn
end
function PackageView:Init()
  self.normalStick = self:FindComponent("NormalStick", UISprite)
  self.mainPage = self:AddSubView("PackageMainPage", PackageMainPage)
  self.equipPage = self:AddSubView("PackageEquipPage", PackageEquipPage)
  self.equipStrengthenViewController = self:AddSubView("EquipStrengthen", EquipStrengthen)
  self.BarrowBagPage = self:AddSubView("PackageBarrowBagPage", PackageBarrowBagPage)
  self.shortCutIsSetting = false
  self:InitUI()
  self:MapEvent()
end
function PackageView:OnEnter()
  PackageView.super.OnEnter(self)
  self:CameraRotateToMe()
  self:SetLeftViewState(PackageView.LeftViewState.Default)
  self:ActiveSetShortCut(false)
  self.mainPage:SetItemDragEnabled(true)
  EventManager.Me():AddEventListener(PackageEvent.ActivateSetShortCut, self.ActivateSetShortCut, self)
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  end
end
function PackageView:InitUI()
  self.onFashionBtn = self:FindGO("OnFashionBtn")
  self.onInfoBtn = self:FindGO("OnInfoBtn")
  self.equipBord = self:FindGO("EquipBord")
  self.fashionBord = self:FindGO("FashionEquipBord")
  self.infoBord = self:FindGO("attrViewHolder")
  self.barrowBagBord = self:FindGO("BarrowBagHolder")
  self.topCoins = self:FindGO("TopCoins")
  self.itemBord = self:FindGO("ItemNormalList")
  self.viewState = PackageView.LeftViewState.Default
  self:AddClickEvent(self.onFashionBtn, function(go)
    if self.markingFavoriteMode then
      return
    end
    if self.viewState == PackageView.LeftViewState.Fashion then
      self:SetLeftViewState(PackageView.LeftViewState.Default)
    else
      self:SetLeftViewState(PackageView.LeftViewState.Fashion)
    end
  end)
  self:AddClickEvent(self.onInfoBtn, function(go)
    if self.markingFavoriteMode then
      return
    end
    if self.viewState == PackageView.LeftViewState.RoleInfo then
      self:SetLeftViewState(PackageView.LeftViewState.Default)
    else
      self:SetLeftViewState(PackageView.LeftViewState.RoleInfo)
    end
  end)
  self.quickUseTween = self:FindComponent("QuickUseTweenButton", UIPlayTween)
  self:AddButtonEvent("QuickUseTweenButton", function(go)
    if self.markingFavoriteMode then
      return
    end
    self:ActiveSetShortCut(not self.shortCutIsSetting)
  end)
  self.goQuickUseTweenButton = self:FindGO("QuickUseTweenButton")
  local bagTab = self:FindGO("BagTab")
  self:AddTabChangeEvent(bagTab, self.itemBord, PanelConfig.Bag)
  RedTipProxy.Instance:RegisterUI(SceneTip_pb.EREDSYS_PET_ADVENTURE, bagTab)
  local strengthTab = self:FindGO("StrengthTab")
  self:AddOrRemoveGuideId(strengthTab, 35)
  self:AddTabChangeEvent(strengthTab, self.goEquipStrengthen, PanelConfig.EquipStrengthen)
  local tabList = {bagTab, strengthTab}
  for i, v in ipairs(tabList) do
    do
      local longPress = v:GetComponent(UILongPress)
      function longPress.pressEvent(obj, state)
        self:PassEvent(TipLongPressEvent.PackageView, {state, i})
      end
    end
    break
  end
  self:AddEventListener(TipLongPressEvent.PackageView, self.HandleLongPress, self)
  local iconActive, nameLabelActive
  if not GameConfig.SystemForbid.TabNameTip then
    iconActive = true
    nameLabelActive = false
  else
    iconActive = false
    nameLabelActive = true
  end
  self.tabIconSpList = {}
  for i, v in ipairs(tabList) do
    local icon = GameObjectUtil.Instance:DeepFindChild(v, "Icon")
    icon:SetActive(iconActive)
    self.tabIconSpList[#self.tabIconSpList + 1] = icon:GetComponent(UISprite)
    local label = GameObjectUtil.Instance:DeepFindChild(v, "Label")
    label:SetActive(nameLabelActive)
  end
  self:AddEventListener(PackageEvent.SwitchMarkingFavoriteMode, self.HandleSwitchMarkingFavoriteMode, self)
end
function PackageView:TabChangeHandler(key)
  if self.markingFavoriteMode then
    return
  end
  if PackageView.super.TabChangeHandler(self, key) then
    if key == 1 then
      self.itemBord:SetActive(true)
      self.goQuickUseTweenButton:SetActive(true)
      self.equipPage:RemoveMaskOnItems()
      self.equipStrengthenViewController:Hide()
      self.equipStrengthenIsShow = false
    elseif key == 2 then
      self.itemBord:SetActive(false)
      self.equipPage:AddMaskOnItems()
      self.goQuickUseTweenButton:SetActive(false)
      self:ActiveSetShortCut(false)
      self.equipStrengthenViewController:Show()
      local equipCtrl = self.equipPage.chooseEquip
      if equipCtrl then
        local equipData = equipCtrl.data
        if equipData then
          local equipInfo = equipData.equipInfo
          local isCouldStrengthen = self.equipStrengthenViewController:IsCouldStrengthen(equipData.index) and equipInfo:CanStrength()
          if isCouldStrengthen then
            if equipInfo.damage then
              self.equipPage:SetChoose()
              self.equipStrengthenViewController:SetEmpty()
            else
              self.equipStrengthenViewController:Refresh(equipCtrl.data.index)
            end
          else
            self.equipPage:SetChoose()
            self.equipStrengthenViewController:SetEmpty()
          end
        else
          self.equipPage:SetChoose()
          self.equipStrengthenViewController:SetEmpty()
        end
      else
        self.equipPage:SetChoose()
        self.equipStrengthenViewController:SetEmpty()
      end
      self.equipStrengthenIsShow = true
    end
    self:SetCurrentTabIconColor(self.coreTabMap[key].go)
  end
end
function PackageView:GetBaseAttriView()
  if not self.baseAttributeView then
    self.baseAttributeView = self:AddSubView("BaseAttributeView", BaseAttributeView)
    self.baseAttributeView:OnEnter()
    self.baseAttributeView:HideHelpBtn()
  end
  return self.baseAttributeView
end
function PackageView:ActiveSetShortCut(active)
  if self.shortCutIsSetting ~= active then
    if active and not self.packageSetQuickPage then
      self.packageSetQuickPage = self:AddSubView("PackageSetQuickPage", PackageSetQuickPage)
      self.packageSetQuickPage:OnEnter()
    end
    self.quickUseTween:Play(active)
    self.equipPage:SetItemDragEnabled(active)
    self.shortCutIsSetting = active
  end
end
function PackageView:SetLeftViewState(viewState)
  local onRotation, offRotation = Quaternion.Euler(0, 180, 0), Quaternion.identity
  if self.viewState ~= viewState then
    if self.viewState == PackageView.LeftViewState.BarrowBag then
      self.BarrowBagPage:Close()
    end
    self.barrowBagBord:SetActive(viewState == PackageView.LeftViewState.BarrowBag)
    local rotation1, rotation2 = offRotation, offRotation
    if viewState == PackageView.LeftViewState.Default then
    elseif viewState == PackageView.LeftViewState.Fashion then
      rotation1 = onRotation
    elseif viewState == PackageView.LeftViewState.RoleInfo then
      rotation2 = onRotation
      self:GetBaseAttriView():showMySelf()
    elseif viewState == PackageView.LeftViewState.Strength then
    elseif viewState == PackageView.LeftViewState.BarrowBag then
      self.BarrowBagPage:Open()
    end
    self.onFashionBtn.transform.localRotation = rotation1
    self.onInfoBtn.transform.localRotation = rotation2
    self.equipBord:SetActive(viewState == PackageView.LeftViewState.Default)
    self.fashionBord:SetActive(viewState == PackageView.LeftViewState.Fashion)
    self.infoBord:SetActive(viewState == PackageView.LeftViewState.RoleInfo)
    self.topCoins:SetActive(viewState ~= PackageView.LeftViewState.RoleInfo and viewState ~= PackageView.LeftViewState.BarrowBag)
    self.viewState = viewState
  end
end
local FashionEquipMap = {
  [6] = 5,
  [8] = 7
}
local EquipFashionMap = {
  [5] = 6,
  [7] = 8
}
function PackageView:GetDataFuncs(data, source)
  local result = {}
  if data then
    local type = isDress and 2 or 1
    if self.viewState == PackageView.LeftViewState.BarrowBag then
      result = {37}
    else
      result = FunctionItemFunc.GetItemFuncIds(data.staticData.id, source, self.viewState == PackageView.LeftViewState.Fashion)
    end
  end
  return result
end
function PackageView:GetItemDefaultFunc(data, source)
  source = source or FunctionItemFunc_Source.MainBag
  return FunctionItemFunc.Me():GetItemDefaultFunc(data, source, self.viewState == PackageView.LeftViewState.Fashion)
end
function PackageView:MapEvent()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleMapChange)
  self:AddListenEvt(LoadSceneEvent.SceneAnimEnd, self.HandleSceneAnimEnd)
  self:AddListenEvt(PackageEvent.OpenBarrowBag, self.HandleOpenBarrowBag)
end
function PackageView:SetRefineEquip(equip)
  if self.tabType ~= PackageView.TabType.Refine then
    return
  end
end
function PackageView:IsRefinePage()
  return self.tabType == PackageView.TabType.Refine
end
function PackageView:SetChooseEquip(cell)
  self.equipPage:SetChoose(cell)
end
function PackageView:GetChooseEquip()
  return self.equipPage.chooseEquip
end
function PackageView:HandleMapChange(note)
  if Game.MapManager:Previewing() then
    return
  end
  if note.type == LoadSceneEvent.FinishLoad and note.body then
    self:CameraRotateToMe()
  end
end
function PackageView:HandleSceneAnimEnd(note)
  self:CameraRotateToMe()
end
function PackageView:HandleOpenBarrowBag(note)
  self:SetLeftViewState(PackageView.LeftViewState.BarrowBag)
end
function PackageView:ActivateSetShortCut()
  if self.markingFavoriteMode then
    return
  end
  self:ActiveSetShortCut(true)
end
function PackageView:HandleSwitchMarkingFavoriteMode(on)
  self.markingFavoriteMode = on
  if on then
    self:ActiveSetShortCut(false)
  end
end
function PackageView:OnExit()
  EventManager.Me():RemoveEventListener(PackageEvent.ActivateSetShortCut, self.ActivateSetShortCut, self)
  UIUtil.StopEightTypeMsg()
  ServiceItemProxy.Instance:CallBrowsePackage(SceneItem_pb.EPACKTYPE_MAIN)
  PackageView.super.OnExit(self)
  self:CameraReset()
end
function PackageView:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function()
    self.mainPage:CheckFavoriteModeOnExit(function()
      self:CloseSelf()
    end)
  end)
end
function PackageView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  if not GameConfig.SystemForbid.TabNameTip then
    if isPressing then
      local backgroundSp = self.coreTabMap[index].go:GetComponent(UISprite)
      TipManager.Instance:TryShowHorizontalTabNameTip(PackageView.TabName[index], backgroundSp, NGUIUtil.AnchorSide.Left)
    else
      TipManager.Instance:CloseTabNameTipWithFadeOut()
    end
  end
end
function PackageView:ResetTabIconColor()
  for i, v in ipairs(self.tabIconSpList) do
    v.color = ColorUtil.TabColor_White
  end
end
function PackageView:SetCurrentTabIconColor(currentTabGo)
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
