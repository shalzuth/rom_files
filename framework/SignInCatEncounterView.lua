SignInCatEncounterView = class("SignInCatEncounterView", BaseView)
SignInCatEncounterView.ViewType = UIViewType.NormalLayer
SignInCatAnimState = {
  WalkIn = 1,
  TurnLeft = 2,
  BoardDrop = 3,
  Wait = 4,
  TurnRight = 5,
  WalkOut = 6
}
SignInCatAnimDuration = {
  Walk = 1.1,
  Turn = 0.5,
  Functional_Action = 1.333
}
function SignInCatEncounterView.TryShow()
  local userData = Game.Myself.data.userdata
  local nowRoleLevel = userData:Get(UDEnum.ROLELEVEL)
  if nowRoleLevel <= 10 then
    xdlog("\230\156\170\230\187\161 10 \231\186\167\228\184\141\230\152\190\231\164\186\231\173\190\229\136\176")
    return
  else
    xdlog("\230\152\190\231\164\186\231\173\190\229\136\176")
  end
  helplog(NewServerSignInProxy.Instance.isSignInNotifyReceived)
  helplog(NewServerSignInProxy.Instance.isCatShowed)
  if not NewServerSignInProxy.Instance:IsSignInNotifyReceived() then
    return
  end
  if NewServerSignInProxy.Instance.isCatShowed then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SignInCatEncounterView
  })
end
local uiManagerIns, tickManagerIns, arrayPushBack, arrayClear, arrayPopFront
local clickHintLocalPos = LuaVector3.New(-85, 52, 0)
function SignInCatEncounterView:Init()
  uiManagerIns = UIManagerProxy.Instance
  tickManagerIns = TimeTickManager.Me()
  arrayPushBack = TableUtility.ArrayPushBack
  arrayClear = TableUtility.ArrayClear
  arrayPopFront = TableUtility.ArrayPopFront
  self:FindObjs()
  self:InitView()
  self:AddListenEvts()
end
function SignInCatEncounterView:FindObjs()
  self.modelContainer = self:FindGO("ModelContainer")
  self.clickZone = self:FindGO("ClickZone")
  self.catTweenTransform = self.modelContainer:GetComponent(TweenTransform)
  self.wayPoints = {
    walkInFrom = self:FindGO("WalkInFrom").transform,
    turnLeftFrom = self:FindGO("TurnLeftFrom").transform,
    wait = self:FindGO("Wait").transform,
    turnRightTo = self:FindGO("TurnRightTo").transform,
    walkOutTo = self:FindGO("WalkOutTo").transform
  }
end
function SignInCatEncounterView:InitView()
  self.catMoveState = 0
  self.keyFrames = {}
  self.keyFrameCalls = {}
  self.catTweenTransform:SetOnFinished(function()
    self:MoveToNextState()
  end)
  self:AddClickEvent(self.clickZone, function()
    if not self.clickZoneEnabled then
      return
    end
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.NewServerSignInMapView,
      viewdata = true
    })
  end)
  self:CreateFakeCat()
end
function SignInCatEncounterView:AddListenEvts()
  self:AddListenEvt(NewServerSignInEvent.TryBeginCatEncounterAnim, self.HandleTryBeginEncounterAnim)
  self:AddListenEvt(LoadingSceneView.ServerReceiveLoaded, self.HandleTryBeginEncounterAnim)
  self:AddListenEvt(ServiceEvent.NUserSignInNtfUserCmd, self.HandleTryBeginEncounterAnim)
end
function SignInCatEncounterView:OnEnter()
  SignInCatEncounterView.super.OnEnter(self)
  local isPlayFarewellAnim = self.viewdata.viewdata
  if not isPlayFarewellAnim then
    self.delayedBeginRealCatEncounterAnim = LeanTween.delayedCall(0.15, function()
      self:CreateRealCat()
      self:BeginEncounterAnim()
      NewServerSignInProxy.Instance.isCatShowed = true
      self.delayedBeginRealCatEncounterAnim = nil
    end)
  else
    self:CreateRealCat()
    self:BeginFarewellAnim()
    NewServerSignInProxy.Instance.isCatShowed = true
  end
end
function SignInCatEncounterView:OnExit()
  if self.delayedBeginRealCatEncounterAnim then
    self.delayedBeginRealCatEncounterAnim:cancel()
    self.delayedBeginRealCatEncounterAnim = nil
  end
  tickManagerIns:ClearTick(self)
  self.catTweenTransform.enabled = false
  SignInCatEncounterView.super.OnExit(self)
end
function SignInCatEncounterView:OnDestroy()
  if self.model then
    self.model:Destroy()
    self.model = nil
  end
  SignInCatEncounterView.super.OnDestroy(self)
end
function SignInCatEncounterView:CreateFakeCat()
  local parts = Asset_Role.CreatePartArray()
  self.model = Asset_Role.Create(parts)
  self.model:SetParent(self.modelContainer.transform)
  self.model:SetLayer(RO.Config.Layer.UI.Value)
  self.model:SetPosition(LuaVector3.zero)
  self.model:SetRotation(LuaQuaternion.identity)
  self.model:SetScale(150)
  self.model:RegisterWeakObserver(self)
  Asset_Role.DestroyPartArray(parts)
end
function SignInCatEncounterView:CreateRealCat()
  local parts = Asset_Role.CreatePartArray()
  parts[Asset_Role.PartIndex.Body] = 1595
  self.model:Redress(parts, true)
  Asset_Role.DestroyPartArray(parts)
  self.isRealCatCreated = true
end
function SignInCatEncounterView:HandleTryBeginEncounterAnim()
  if self.delayedBeginRealCatEncounterAnim then
    return
  end
  self:BeginEncounterAnim()
end
function SignInCatEncounterView:BeginEncounterAnim()
  if not self.isRealCatCreated then
    return
  end
  self.catMoveState = SignInCatAnimState.WalkIn
  self:BeginWalkAnim(self.wayPoints.walkInFrom, self.wayPoints.turnLeftFrom, SignInCatAnimDuration.Walk)
end
function SignInCatEncounterView:BeginFarewellAnim()
  if not self.isRealCatCreated then
    return
  end
  self.catMoveState = SignInCatAnimState.TurnRight
  self:BeginWalkAnim(self.wayPoints.wait, self.wayPoints.turnRightTo, SignInCatAnimDuration.Turn)
end
function SignInCatEncounterView:BeginWalkAnim(from, to, duration)
  if self.catMoveState == SignInCatAnimState.WalkIn then
    self.tickTime = 0
    self:ClearKeyFrameCall()
    local durations = SignInCatAnimDuration
    self:AddKeyFrameCall(durations.Walk + durations.Turn + 0.5, function()
      if self.catMoveState == SignInCatAnimState.BoardDrop then
        return
      end
      for i = 1, #self.keyFrames do
        self.keyFrames[i] = self.keyFrames[i] + 0.5
      end
      self.catMoveState = SignInCatAnimState.BoardDrop
      self.model:SetPosition(LuaVector3.zero)
      self:PlayCatAction("functional_action")
    end)
    self:AddKeyFrameCall(durations.Walk + 1.2, function()
      self:SetClickZoneEnabled(true)
    end)
    self:AddKeyFrameCall(durations.Walk + durations.Turn + durations.Functional_Action, function()
      self:PlayCatAction("functional_action2")
    end)
    self.keyFrameCallsTick = tickManagerIns:CreateTick(0, 33, self.TryKeyFrameCalls, self)
  end
  self:SetClickZoneEnabled(false)
  self:SetTweenTransformAndPlay(from, to, duration)
  self:PlayCatAction("walk")
end
function SignInCatEncounterView:TryKeyFrameCalls(interval)
  self.tickTime = self.tickTime + interval / 1000
  if not next(self.keyFrames) then
    self.keyFrameCallsTick:ClearTick()
    return
  end
  if self.tickTime > self.keyFrames[1] then
    self.keyFrameCalls[1]()
    self:PopFrontKeyFrameCall()
  end
end
function SignInCatEncounterView:AddKeyFrameCall(keyFrameTime, keyFrameCall)
  arrayPushBack(self.keyFrames, keyFrameTime)
  arrayPushBack(self.keyFrameCalls, keyFrameCall)
end
function SignInCatEncounterView:ClearKeyFrameCall()
  arrayClear(self.keyFrames)
  arrayClear(self.keyFrameCalls)
end
function SignInCatEncounterView:PopFrontKeyFrameCall()
  arrayPopFront(self.keyFrames)
  arrayPopFront(self.keyFrameCalls)
end
function SignInCatEncounterView:MoveToNextState()
  self.catMoveState = self.catMoveState + 1
  if self.catMoveState == SignInCatAnimState.TurnLeft then
    self:SetTweenTransformAndPlay(self.wayPoints.turnLeftFrom, self.wayPoints.wait, SignInCatAnimDuration.Turn)
  elseif self.catMoveState == SignInCatAnimState.BoardDrop then
    self:PlayCatAction("functional_action")
    self.catTweenTransform.enabled = false
  elseif self.catMoveState == SignInCatAnimState.WalkOut then
    self:SetTweenTransformAndPlay(self.wayPoints.turnRightTo, self.wayPoints.walkOutTo, SignInCatAnimDuration.Walk)
  elseif self.catMoveState > SignInCatAnimState.WalkOut then
    self:CloseSelf()
  end
end
function SignInCatEncounterView:SetClickZoneEnabled(enabled)
  enabled = enabled or false
  self.clickZoneEnabled = enabled
  if enabled and not self.clickHintGO then
    self.clickHintGO = self:CreateClickHint()
  elseif not enabled and self.clickHintGO then
    GameObject.Destroy(self.clickHintGO)
    self.clickHintGO = nil
  end
end
function SignInCatEncounterView:SetTweenTransformAndPlay(from, to, duration)
  local t = self.catTweenTransform
  t.enabled = false
  t.from = from
  t.to = to
  t.duration = duration
  t:ResetToBeginning()
  t.enabled = true
  t:PlayForward()
end
function SignInCatEncounterView:PlayCatAction(actionName)
  local params = Asset_Role.GetPlayActionParams(actionName)
  params[6] = true
  self.model:PlayAction(params)
end
function SignInCatEncounterView:ObserverDestroyed(model)
  if model and model == self.model then
    self.model:SetParent(nil)
    self.model = nil
  end
end
function SignInCatEncounterView:CreateClickHint()
  local hintResPath = ResourcePathHelper.EffectUI(EffectMap.UI.StartDian)
  local effect = Game.AssetManager_UI:CreateAsset(hintResPath, self.gameObject)
  effect.transform.localPosition = clickHintLocalPos
  local effectComp = effect:GetComponent(ChangeRqByTex)
  effectComp.depth = 12
  return effect
end
