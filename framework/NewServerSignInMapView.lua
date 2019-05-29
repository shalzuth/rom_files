autoImport("NewServerSignInMapCell")
NewServerSignInMapView = class("NewServerSignInMapView", BaseView)
NewServerSignInMapView.ViewType = UIViewType.NormalLayer
NewServerSignInMapView.FlippedRotation = LuaVector3.New(0, 180, 0)
NewServerSignInMapView.SYZFarewellTime = "2020-03-01 05:00:00"
local proxyInstance, cellState
local hintLocalPos = LuaVector3.New(0.34, -11.9, 0)
function NewServerSignInMapView:Init()
  proxyInstance, cellState = NewServerSignInProxy.Instance, NewServerSignInMapCell.State
  self.isFromCat = self.viewdata.viewdata
  self:FindObjs()
  self:UpdateShow(true)
  self:AddEvents()
end
function NewServerSignInMapView:FindObjs()
  self.mapBgTex = self:FindComponent("MapBg", UITexture)
  self.tipButtonTex = self:FindComponent("TipButtonTex", UITexture)
  self.tipButton = self:FindGO("TipButton")
  self.catParent = self:FindGO("Cat")
  self.flowEffectParent = self:FindGO("FlowEffect")
  self.lastDayCellEffectParent = self:FindGO("LastDayCellEffect")
  self.signInDayCellCtlMap = {}
  local cellGO
  for i = 1, NewServerSignInProxy.PeriodDayCount do
    cellGO = self:FindGO("NewServerSignInMapCell" .. i)
    if not cellGO then
      LogUtility.ErrorFormat("Cannot find NewServerSignInMapCell{0}", i)
      return
    end
    self.signInDayCellCtlMap[i] = NewServerSignInMapCell.new(cellGO, i)
  end
  self.signInMapCell0 = self:FindGO("NewServerSignInMapCell0")
end
function NewServerSignInMapView:UpdateShow(isFirstCall)
  local maxDay = NewServerSignInProxy.PeriodDayCount
  for i = 1, maxDay do
    self.signInDayCellCtlMap[i]:SwitchToState(cellState.Unsigned)
  end
  self:UpdateTodayCell()
  if proxyInstance.signedCount == 0 then
    self.signedCountRemainder = 0
    self.passPeriodCount = 0
  else
    self.signedCountRemainder = proxyInstance:GetRemainderOfDay(proxyInstance.signedCount, maxDay)
    self.passPeriodCount = math.floor((proxyInstance.signedCount - self.signedCountRemainder) / maxDay)
  end
  if isFirstCall and self.signedCountRemainder == maxDay then
    self.passPeriodCount = self.passPeriodCount + 1
    self.signedCountRemainder = 0
  end
  for i = 1, self.signedCountRemainder do
    self.signInDayCellCtlMap[i]:SwitchToState(cellState.Signed)
  end
  for i = 1, maxDay - self.signedCountRemainder do
    if proxyInstance:IsDayWithSmallGift(proxyInstance.signedCount + i) then
      self.signInDayCellCtlMap[i + self.signedCountRemainder]:SwitchToState(cellState.SmallGift)
    end
    if proxyInstance:IsDayWithLargeGift(proxyInstance.signedCount + i) then
      self.signInDayCellCtlMap[i + self.signedCountRemainder]:SwitchToState(cellState.LargeGift)
    end
  end
  if not self.cat then
    self:CreateCat()
  end
  local dest = self.signedCountRemainder == 0 and self.signInMapCell0.transform.position or self.signInDayCellCtlMap[self.signedCountRemainder].gameObject.transform.position
  if isFirstCall then
    self.catParent.transform.position = dest
    self:TryFlipCat()
  else
    self:PlayCatMoveAct(dest)
  end
  self.lastDayCellEffectParent:SetActive(maxDay > self.signedCountRemainder)
end
function NewServerSignInMapView:AddEvents()
  for index, cellCtl in pairs(self.signInDayCellCtlMap) do
    self:AddClickEvent(cellCtl.gameObject, function()
      local day = self.passPeriodCount * NewServerSignInProxy.PeriodDayCount + index
      self:ShowRewardPreview(day)
      if cellCtl.state == cellState.Barrier then
        self:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.SignInQAView,
          viewdata = day
        })
      end
    end)
    break
  end
  self:AddClickEvent(self.tipButton, function()
    local viewCfg = PanelConfig.SignInTipsView
    if not UIManagerProxy.Instance:HasUINode(viewCfg) then
      self:sendNotification(UIEvent.JumpPanel, {view = viewCfg})
    end
  end)
  self:AddListenEvt(ServiceEvent.NUserSignInNtfUserCmd, self.HandleSignInNotify)
  self:AddListenEvt(NewServerSignInEvent.RemoveBarrier, self.HandleRemoveBarrier)
  self:AddListenEvt(XDEUIEvent.SignInMapViewBack, function()
    self:CloseSelf()
  end)
end
function NewServerSignInMapView:OnEnter()
  NewServerSignInMapView.super.OnEnter(self)
  self.mapBgTexName = "sign_map"
  self.tipButtonTexName = "sign_icon_help"
  PictureManager.Instance:SetMap(self.mapBgTexName, self.mapBgTex)
  PictureManager.Instance:SetUI(self.tipButtonTexName, self.tipButtonTex)
  self.flowEffect = self:PlayUIEffect(EffectMap.UI.SignIn_Flow, self.flowEffectParent, false)
  self.lastDayCellEffect = self:PlayUIEffect(EffectMap.UI.SignIn_Box, self.lastDayCellEffectParent, false)
end
function NewServerSignInMapView:OnExit()
  PictureManager.Instance:UnLoadMap(self.mapBgTexName, self.mapBgTex)
  PictureManager.Instance:UnLoadUI(self.tipButtonTexName, self.tipButtonTex)
  if self.cat then
    Game.GOLuaPoolManager:AddToSceneUIPool(self.resPath, self.cat)
  end
  if self.flowEffect then
    self.flowEffect:Destroy()
  end
  if self.lastDayCellEffect then
    self.lastDayCellEffect:Destroy()
  end
  if self.isFromCat then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SignInCatEncounterView,
      viewdata = true
    })
    self:sendNotification(NewServerSignInEvent.MapViewFromCatClose)
  end
  self:sendNotification(NewServerSignInEvent.MapViewClose)
  NewServerSignInMapView.super.OnExit(self)
end
function NewServerSignInMapView:UpdateTodayCell()
  local today = proxyInstance:GetToday()
  if today then
    local todayCell = self.signInDayCellCtlMap[proxyInstance:GetRemainderOfDay(today, NewServerSignInProxy.PeriodDayCount)]
    if todayCell then
      if not proxyInstance.isTodaySigned then
        if proxyInstance:IsDayWithQuestion(today) and not proxyInstance.isTodayQuestionAnswered then
          todayCell:SwitchToState(cellState.Barrier)
        else
          self:AddHintToCell(todayCell)
        end
      else
        self:DestroyHint()
      end
    end
  end
end
function NewServerSignInMapView:CreateCat()
  local isSYZ = NewServerSignInMapView.CheckIfSYZCanShow()
  local catPrefabName = isSYZ and "rosyz" or "sign_bigcat"
  self.resPath = ResourcePathHelper.Emoji(catPrefabName)
  self.cat = Game.AssetManager_UI:CreateSceneUIAsset(self.resPath, self.catParent)
  if not self.cat then
    LogUtility.Error("Cannot find cat")
    return
  end
  self.cat.transform.localPosition = LuaVector3.New(0, -10, 0)
  UIUtil.ChangeLayer(self.cat, self.catParent.layer)
  self.cat.transform.localScale = isSYZ and LuaVector3.New(0.8, 0.8, 0.8) or LuaVector3.one
  self.cat.gameObject:SetActive(true)
  self.cat.name = catPrefabName
  self.catAnimComp = self.cat:GetComponent(SkeletonAnimation)
  self:PlayCatStand()
  local uiSpine = self.cat:GetComponent(UISpine)
  uiSpine.depth = 20
end
function NewServerSignInMapView:ReplaceCat()
  if self.cat then
    Game.GOLuaPoolManager:AddToSceneUIPool(self.resPath, self.cat)
  end
  self:CreateCat()
end
function NewServerSignInMapView:PlayCatMoveAct(toPosition)
  local isSyz = self.cat.name == "rosyz"
  local animName = isSyz and "walk" or "jump"
  self:PlayCatAnim(animName, function()
    self:PlayCatStand()
    self:TryFlipCat()
  end)
  if not toPosition then
    return
  end
  local duration = isSyz and 1.0 or 0.5
  local delay = isSyz and 0 or 0.2
  local tp = TweenPosition.Begin(self.catParent, duration, toPosition, true)
  tp.delay = delay
end
function NewServerSignInMapView:PlayCatStand()
  self:PlayCatAnim("stand")
end
function NewServerSignInMapView:PlayCatAnim(animName, callback)
  self.catAnimComp:Reset()
  self.catAnimComp.loop = animName == "stand"
  SpineLuaHelper.PlayAnim(self.catAnimComp, animName, callback)
end
function NewServerSignInMapView:TryFlipCat()
  local day = self.signedCountRemainder
  local isFlip = day > 9 and day < 21 or day > 27
  self.cat.transform.localRotation = isFlip and NewServerSignInMapView.FlippedRotation or LuaQuaternion.identity
end
function NewServerSignInMapView:ShowRewardPreview(day)
  if UIManagerProxy.Instance:HasUINode(PanelConfig.SignInRewardPreview) then
    self:sendNotification(NewServerSignInEvent.UpdateRewardPreview, day)
  else
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SignInRewardPreview,
      viewdata = day
    })
  end
end
function NewServerSignInMapView:HandleSignInNotify()
  self:UpdateShow(not proxyInstance.isTodaySigned)
  if not proxyInstance.isTodaySigned and not NewServerSignInMapView.CheckIfSYZCanShow() then
    self:ReplaceCat()
  end
end
function NewServerSignInMapView:HandleRemoveBarrier()
  proxyInstance:SetTodayQuestionAnswered()
  self:UpdateShow()
end
function NewServerSignInMapView.CheckIfSYZCanShow()
  return false
end
function NewServerSignInMapView:AddHintToCell(cellCtl)
  if not self.hintGO then
    local hintResPath = ResourcePathHelper.EffectUI(EffectMap.UI.GlowHint4)
    self.hintGO = Game.AssetManager_UI:CreateAsset(hintResPath, cellCtl.gameObject)
    self.hintGO.transform.localPosition = hintLocalPos
    self.hintGO.transform.localScale = LuaVector3.one
  else
    self.hintGO.transform:SetParent(cellCtl.gameObject.transform, false)
  end
end
function NewServerSignInMapView:DestroyHint()
  if self.hintGO then
    GameObject.Destroy(self.hintGO)
    self.hintGO = nil
  end
end
