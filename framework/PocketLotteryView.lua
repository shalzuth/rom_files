PocketLotteryView = class("PocketLotteryView", BaseView)
PocketLotteryView.ViewType = UIViewType.InterstitialLayer
local tempRect = Rect(0, 0, 1, 1)
local bgUVMoveDirX, bgUVMoveDirY = 1, 1
local bgUVMoveSpeed = 0.1
local switchAnimDuration = 0.2
function PocketLotteryView:Init()
  self:AddListenEvts()
  self:FindObjs()
  self:InitView()
  self:AddEvents()
  self:AddListenEvt(XDEUIEvent.PocketLotteryViewBack, function()
    self:CloseSelf()
  end)
end
function PocketLotteryView:FindObjs()
  self.bgTex = self:FindComponent("Bg", UITexture)
  self.slots = {}
  TableUtility.ArrayPushBack(self.slots, self:FindSlot("Front"))
  TableUtility.ArrayPushBack(self.slots, self:FindSlot("BackLeft"))
  TableUtility.ArrayPushBack(self.slots, self:FindSlot("BackRight"))
  self.prevButton = self:FindGO("Previous")
  self.nextButton = self:FindGO("Next")
  self.swipeLongPress = self:FindComponent("SwipeZone", UILongPress)
  self.noneTip = self:FindGO("NoneTip")
end
function PocketLotteryView:InitView()
  self.time = 0
  self.typeModelMap = {}
  self.modelCount = 0
  self.switchEnabled = false
  self.isMagic = self.viewdata.viewdata
  local slotRotationY = 0
  if self.isMagic then
    self:TryResetMagic()
    slotRotationY = -15
  else
    self.modelCount = 3
    self:CreateSlotContents(self.slots[1], 1240, LotteryType.Head, "LotteryHeadwearView")
    self:CreateSlotContents(self.slots[2], 1239, LotteryType.Equip, "LotteryEquipView")
    self:CreateSlotContents(self.slots[3], 1241, LotteryType.Card, "LotteryCardView")
    self.prevButton:SetActive(true)
    self.nextButton:SetActive(true)
  end
  for i = 1, #self.slots do
    self.slots[i].trans.localRotation = Quaternion.Euler(0, slotRotationY, 0)
    self.slots[i].containerTrans.localRotation = Quaternion.Euler(0, slotRotationY, 0)
  end
end
function PocketLotteryView:AddEvents()
  self:AddClickEvent(self.prevButton, function()
    self:TrySwitchPrev()
  end)
  self:AddClickEvent(self.nextButton, function()
    self:TrySwitchNext()
  end)
  function self.swipeLongPress.pressEvent(longPress, isPressing)
    if not self.switchEnabled then
      return
    end
    if isPressing then
      self.swipeBeginPosX = LuaGameObject.GetMousePosition()
    else
      if not self.swipeBeginPosX then
        return
      end
      local endPosX = LuaGameObject.GetMousePosition()
      local delta = endPosX - self.swipeBeginPosX
      if delta > 0 then
        self:TrySwitchPrev()
      elseif delta < 0 then
        self:TrySwitchNext()
      end
      self.swipeBeginPosX = nil
    end
  end
end
function PocketLotteryView:AddListenEvts()
  self:AddListenEvt(LotteryEvent.LotteryViewEnter, self.HandleLotteryViewEnter)
  self:AddListenEvt(LotteryEvent.LotteryViewClose, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.ItemLotteryCmd, self.HandleLotteryCmd)
  self:AddListenEvt(ServiceEvent.ItemLotteryActivityNtfCmd, self.TryResetMagic)
end
function PocketLotteryView:OnEnter()
  PocketLotteryView.super.OnEnter(self)
  LotteryProxy.Instance:SetPocketLotteryViewShowing(true)
  self.bgTexName = "gashapon_bg"
  PictureManager.Instance:SetUI(self.bgTexName, self.bgTex)
  TimeTickManager.Me():CreateTick(0, 16, self.UpdateBgMove, self)
  self:JumpToFrontSlotView()
end
function PocketLotteryView:OnExit()
  self:ClearAllSlotContents()
  for _, slot in pairs(self.slots) do
    TableUtility.TableClear(slot)
  end
  TableUtility.TableClear(self.slots)
  PictureManager.Instance:UnLoadUI(self.bgTexName, self.bgTex)
  TimeTickManager.Me():ClearTick(self)
  LotteryProxy.Instance:SetPocketLotteryViewShowing(false)
  PocketLotteryView.super.OnExit(self)
end
function PocketLotteryView:FindSlot(objName)
  local container = self:FindGO("ModelContainer" .. #self.slots + 1)
  local slot = {}
  slot.trans = self:FindGO(objName).transform
  slot.containerTrans = container.transform
  slot.tween = container:GetComponent(TweenTransform)
  return slot
end
function PocketLotteryView:CreateSlotContents(slot, body, lotteryType, panelName)
  if not self:IsTable(slot) then
    LogUtility.Warning("PocketLotteryView: Cannot create slot contents when slot is not table!")
    return
  end
  slot.model = self:CreateModelByBody(body)
  slot.model:SetParent(slot.containerTrans)
  self.typeModelMap[lotteryType] = slot.model
  slot.viewCfg = slot.viewCfg or {}
  TableUtility.TableClear(slot.viewCfg)
  TableUtility.TableShallowCopy(slot.viewCfg, PanelConfig[panelName])
  slot.viewCfg.hideCollider = true
  slot.containerTrans.localPosition = slot.trans.localPosition
  slot.containerTrans.localRotation = slot.trans.localRotation
  slot.containerTrans.localScale = slot.trans.localScale
end
function PocketLotteryView:TrySwitchPrev()
  LogUtility.Info("TrySwitchPrev")
  self:TrySwitch(2)
end
function PocketLotteryView:TrySwitchNext()
  LogUtility.Info("TrySwitchNext")
  self:TrySwitch(3)
end
function PocketLotteryView:TrySwitch(slotIndexToBeNewFront)
  if not self:CheckIfCanSwitch() then
    return
  end
  if slotIndexToBeNewFront < 2 or slotIndexToBeNewFront > 3 then
    LogUtility.Error("Wrong slot index!!!")
    return
  end
  if not self.slots[slotIndexToBeNewFront].model then
    MsgManager.ShowMsg(nil, ZhString.PocketLottery_SwitchToAnEnd, 1)
    return
  end
  local anotherSlotIndex = slotIndexToBeNewFront == 2 and 3 or 2
  self:PlaySlotModelTween(self.slots[1], self.slots[anotherSlotIndex])
  self:PlaySlotModelTween(self.slots[anotherSlotIndex], self.slots[slotIndexToBeNewFront])
  self:PlaySlotModelTween(self.slots[slotIndexToBeNewFront], self.slots[1])
  local tempSlot = ReusableTable.CreateTable()
  self:AssignSlotContents(tempSlot, self.slots[1])
  self:AssignSlotContents(self.slots[1], self.slots[slotIndexToBeNewFront])
  self:AssignSlotContents(self.slots[slotIndexToBeNewFront], self.slots[anotherSlotIndex])
  self:AssignSlotContents(self.slots[anotherSlotIndex], tempSlot)
  ReusableTable.DestroyAndClearTable(tempSlot)
  self:DelayedJumpToFrontSlotView()
end
function PocketLotteryView:CheckIfCanSwitch()
  if self.modelCount < 2 then
    return false
  end
  return self.switchEnabled
end
function PocketLotteryView:AssignSlotContents(slotA, slotB)
  if not self:IsTable(slotA) or not self:IsTable(slotB) then
    LogUtility.Error("PocketLotteryView: Cannot assign slot contents!")
    return
  end
  slotA.containerTrans = slotB.containerTrans
  slotA.tween = slotB.tween
  slotA.model = slotB.model
  slotA.viewCfg = slotB.viewCfg
end
function PocketLotteryView:HandleLotteryCmd(note)
  local data = note.body
  if not data then
    return
  end
  if data.charid ~= Game.Myself.data.id then
    return
  end
  local lotteryProxy = LotteryProxy.Instance
  if lotteryProxy:IsSkipGetEffect(lotteryProxy:GetSkipType(data.type)) then
    return
  end
  local model = self.typeModelMap[data.type]
  if not model then
    return
  end
  self:CancelDelayedCall()
  self.switchEnabled = false
  self:PlayModelAction(model, "functional_action")
  self.delayedCall = LeanTween.delayedCall(GameConfig.Delay.lottery / 1000, function()
    self:PlayModelAction(model, "wait")
    self.switchEnabled = true
    self.delayedCall = nil
  end)
end
function PocketLotteryView:HandleLotteryViewEnter()
  self:SetNoneTipActive(false)
end
function PocketLotteryView:TryResetMagic()
  if not self.isMagic then
    return
  end
  local isInitializing = self.modelCount == 0
  self:ClearAllSlotContents(not isInitializing)
  local activityInfo = LotteryProxy.Instance:GetLotteryActivityInfo()
  if not activityInfo or not next(activityInfo) then
    self:SetNoneTipActive(true)
    return
  else
    self:SetNoneTipActive(false)
  end
  self.modelCount = 0
  local panelName
  for type, bodyId in pairs(activityInfo) do
    if type == SceneItem_pb.ELotteryType_Magic then
      panelName = "LotteryMagicView"
    elseif type == SceneItem_pb.ELotteryType_Magic_2 then
      panelName = "LotteryMagicSecView"
    else
      LogUtility.ErrorFormat("PocketLotteryView: recv invalid type:{0}", type)
      return
    end
    self.modelCount = self.modelCount + 1
    self:CreateSlotContents(self.slots[self.modelCount], bodyId, type, panelName)
  end
  if not isInitializing then
    self:DelayedJumpToFrontSlotView(0.1)
  end
  self.prevButton:SetActive(self.modelCount > 1)
  self.nextButton:SetActive(self.modelCount > 1)
end
function PocketLotteryView:UpdateBgMove(interval)
  self.time = self.time + interval / 1000
  self:SetBgUVRect(self.time * bgUVMoveDirX * bgUVMoveSpeed, self.time * bgUVMoveDirY * bgUVMoveSpeed)
end
function PocketLotteryView:SetBgUVRect(x, y, width, height)
  tempRect.x = x
  tempRect.y = y
  tempRect.width = width or 1
  tempRect.height = height or 1
  self.bgTex.uvRect = tempRect
end
function PocketLotteryView:JumpToFrontSlotView()
  local viewCfg = self.slots[1].viewCfg
  if not viewCfg then
    LogUtility.Warning("PocketLotteryView: Cannot jump to view of front slot because front slot contents are nil!")
    return
  end
  self:sendNotification(UIEvent.JumpPanel, {view = viewCfg})
end
function PocketLotteryView:DelayedJumpToFrontSlotView(duration)
  duration = duration or switchAnimDuration
  self.delayedCall = LeanTween.delayedCall(duration, function()
    self:JumpToFrontSlotView()
    self.delayedCall = nil
  end)
end
function PocketLotteryView:CreateModelByBody(body, pos, rot, scl)
  pos = pos or LuaVector3.zero
  rot = rot or LuaQuaternion.identity
  scl = scl or 1
  local parts = Asset_Role.CreatePartArray()
  parts[Asset_Role.PartIndex.Body] = body
  local model = Asset_Role.Create(parts)
  model:SetLayer(RO.Config.Layer.UI.Value)
  model:SetPosition(pos)
  model:SetRotation(rot)
  model:SetScale(scl)
  model:RegisterWeakObserver(self)
  Asset_Role.DestroyPartArray(parts)
  return model
end
function PocketLotteryView:PlayModelAction(model, actionName)
  if not model then
    LogUtility.Warning("PocketLotteryView: Cannot play action when model = nil!")
    return
  end
  local params = Asset_Role.GetPlayActionParams(actionName)
  params[6] = true
  model:PlayAction(params)
end
function PocketLotteryView:PlaySlotModelTween(slot, toSlot)
  if not self:IsTable(slot) or not slot.tween then
    LogUtility.Warning("PocketLotteryView: Cannot find slot tween.")
    return
  end
  self:SetTweenTransformAndPlay(slot.tween, slot.trans, toSlot.trans)
end
function PocketLotteryView:SetTweenTransformAndPlay(tween, from, to, onFinished)
  tween.enabled = false
  tween.from = from
  tween.to = to
  tween.duration = switchAnimDuration
  tween:ResetToBeginning()
  tween:SetOnFinished(onFinished)
  tween.enabled = true
  tween:PlayForward()
end
function PocketLotteryView:ClearAllSlotContents(needCloseLotteryView)
  for _, slot in pairs(self.slots) do
    if slot.model then
      slot.model:Destroy()
      slot.model = nil
    end
  end
  TableUtility.TableClear(self.typeModelMap)
  self:CancelDelayedCall()
  if needCloseLotteryView ~= false then
    self:sendNotification(UIEvent.CloseUI, LotteryView.ViewType)
  end
end
function PocketLotteryView:SetNoneTipActive(isActive)
  isActive = isActive or false
  self.noneTip:SetActive(isActive)
  self.switchEnabled = not isActive
end
function PocketLotteryView:CancelDelayedCall()
  if self.delayedCall then
    self.delayedCall:cancel()
    self.delayedCall = nil
  end
end
function PocketLotteryView:ObserverDestroyed(model)
  if not model then
    return
  end
  model:SetParent(nil)
  TableUtility.TableRemove(self.typeModelMap, model)
  for _, slot in pairs(self.slots) do
    if model == slot.model then
      slot.model = nil
    end
  end
end
function PocketLotteryView:IsTable(a)
  return a ~= nil and type(a) == "table"
end
