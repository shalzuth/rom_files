UIUtil = {}
function UIUtil.FitLabelLine(label)
  if label ~= nil then
    local height = label.height
    local size = label.fontSize
    local line = math.floor(height / size)
    if line > 1 then
      label.pivot = UIWidget.Pivot.Left
    else
      label.pivot = UIWidget.Pivot.Center
    end
  end
end
function UIUtil.CenterLabelLine(label)
  if label ~= nil then
    label.pivot = UIWidget.Pivot.Center
  end
end
function UIUtil.FitLabelHeight(label, width)
  if label ~= nil then
    local labelText = label.text
    label.overflowMethod = 3
    label.width = width
    label.text = ""
    local bWarp, strOut, line
    if string.find(labelText, [[
[
]]]) then
      line = 2
    else
      line = 1
    end
    bWarp, strOut = label:Wrap(labelText, strOut, label.height * line)
    if bWarp and strOut ~= "" then
      label.overflowMethod = 2
    end
    label.text = labelText
  end
end
function UIUtil.SceneCountDownMsg(id, params, removeWhenLoadScene)
  MsgManager.ShowMsgByIDTable(id, params, id)
  FloatingPanel.Instance:SetCountDownRemoveOnChangeScene(id, removeWhenLoadScene)
end
function UIUtil.StartSceenCountDown(text, data)
  FloatingPanel.Instance:AddCountDown(text, data)
end
function UIUtil.EndSceenCountDown(id)
  FloatingPanel.Instance:RemoveCountDown(id)
end
function UIUtil.FloatMiddleBottom(sortID, text)
  FloatingPanel.Instance:FloatMiddleBottom(sortID, text)
end
function UIUtil.ClearFloatMiddleBottom()
  FloatingPanel.Instance:ClearFloatMiddleBottom()
end
function UIUtil.FloatMsgByData(text)
  FloatingPanel.Instance:TryFloatMessageByData(text)
end
function UIUtil.FloatShowyMsg(text)
  FloatingPanel.Instance:FloatShowyMsg(text)
end
function UIUtil.FloatMsgByText(text)
  FloatingPanel.Instance:TryFloatMessageByText(text)
end
function UIUtil.ShowEightTypeMsgByData(data, startPos, offset)
  FloatingPanel.Instance:FloatTypeEightMsgByData(data, startPos, offset)
end
function UIUtil.StopEightTypeMsg()
  FloatingPanel.Instance:StopFloatTypeEightMsg()
end
function UIUtil.PopUpConfirmView(titleText, contentText, confirmtext, canceltext, confirm, cancel, src, needCloseBtn, needExitDefaultHandle, unique, lockreason)
  if needExitDefaultHandle == nil then
    needExitDefaultHandle = true
  end
  local viewData = {
    viewname = "UniqueConfirmView",
    title = titleText,
    content = contentText,
    confirmtext = confirmtext,
    canceltext = canceltext,
    confirmHandler = confirm,
    cancelHandler = cancel,
    source = src,
    needCloseBtn = needCloseBtn,
    needExitDefaultHandle = needExitDefaultHandle,
    unique = unique,
    lockreason = lockreason
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewData)
end
function UIUtil.PopUpDontAgainConfirmView(contentText, confirm, cancel, src, data)
  if needExitDefaultHandle == nil then
    needExitDefaultHandle = true
  end
  local viewData = {
    viewname = "DontShowAgainConfirmView",
    data = data,
    content = contentText,
    confirmHandler = confirm,
    cancelHandler = cancel,
    source = src
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewData)
end
function UIUtil.PopUpConfirmYesNoView(title, content, confirmHandler, cancelHandler, source, confirmtext, canceltext, unique, lockreason)
  UIUtil.PopUpConfirmView(title, content, confirmtext, canceltext, confirmHandler, cancelHandler, source, false, false, unique, lockreason)
end
function UIUtil.PopUpFuncView(title, content, confirmHandler, cancelHandler, source, confirmtext, canceltext)
  UIUtil.PopUpConfirmView(title, content, confirmtext, canceltext, confirmHandler, cancelHandler, source, true, false)
end
function UIUtil.WarnPopup(titleText, contentText, confirm, cancel, src, confirmtext, canceltext)
  local data = {
    title = titleText,
    content = contentText,
    confirmtext = confirmtext,
    canceltext = canceltext,
    confirmHandler = confirm,
    cancelHandler = cancel,
    source = src
  }
  if UIWarning.Instance ~= nil then
    UIWarning.Instance:AddWarnPopUp(data)
  end
end
function UIUtil.ShowScreenMask(fadeInTime, fadeOutTime, fadeInCallBack, fadeOutCallBack, color)
  color = color or ColorUtil.NGUIBlack
  local viewData = {
    viewname = "ScreenMaskView",
    fadeInTime = fadeInTime,
    fadeOutTime = fadeOutTime,
    fadeInCallBack = fadeInCallBack,
    fadeOutCallBack = fadeOutCallBack,
    color = color
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewData)
end
function UIUtil.RotateAround()
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewData)
end
function UIUtil.CenterScrollViewPos(scrollView, worldPos, springStr)
  local mTrans = scrollView.transform
  local panel = scrollView.panel
  local cp = mTrans:InverseTransformPoint(worldPos)
  local corners = panel.worldCorners
  local panelCenter = (corners[3] + corners[1]) * 0.5
  local cc = mTrans:InverseTransformPoint(panelCenter)
  LuaGameObject.InverseTransformPointByVector3(mTrans, panelCenter)
  local localOffset = cp - cc
  if springStr then
    SpringPanel.Begin(scrollView.gameObject, mTrans.localPosition - localOffset, springStr)
  else
    mTrans.localPosition = mTrans.localPosition - localOffset
    local co = panel.clipOffset
    panel.clipOffset = co + Vector2(localOffset.x, localOffset.y)
  end
end
function UIUtil.GetUIParticle(effectID, depth, parent)
  local containerResID = ResourcePathHelper.UICell("UIParticleHolder")
  local container = Game.AssetManager_UI:CreateAsset(containerResID, parent)
  local effectResID = ResourcePathHelper.EffectUI(effectID)
  local effect = Game.AssetManager_UI:CreateAsset(effectResID, container)
  local ctrl = container:GetComponent(ChangeRqByTex)
  ctrl.transform.localPosition = LuaVector3.zero
  ctrl.depth = depth
  ctrl:AddChild(effect)
  return ctrl
end
function UIUtil.WrapLabel(uiLabel)
  local strContent = uiLabel.text
  local bWarp, strOut
  bWarp, strOut = uiLabel:Wrap(strContent, strOut, uiLabel.height)
  local length = StringUtil.getTextLen(strOut)
  if not bWarp and length > 2 then
    local repStr = ""
    local count = 0
    local rep_bWrap, rep_strOut = false, strOut
    repeat
      count = count + 1
      repStr = StringUtil.getTextByIndex(rep_strOut, 1, length - count)
      repStr = repStr .. "..."
      rep_bWrap, rep_strOut = uiLabel:Wrap(repStr, rep_strOut, uiLabel.height)
    until rep_bWrap
    uiLabel.text = repStr
  end
  return bWarp
end
function UIUtil.GetWrapLeftString(uiLabel, text)
  uiLabel.text = text
  local bWarp, finalStr
  bWarp, finalStr = uiLabel:Wrap(text, finalStr, uiLabel.height)
  if not bWarp then
    local finallen = StringUtil.getTextLen(finalStr)
    local textlen = StringUtil.getTextLen(text)
    if finallen < textlen then
      leftStr = StringUtil.getTextByIndex(text, finallen, textlen)
    else
      leftStr = ""
    end
  else
    leftStr = nil
  end
  return bWarp, leftStr
end
function UIUtil.GetWrapLeftStringOfEnglishText(uiLabel, text)
  uiLabel.text = text
  local bWarp, finalStr
  bWarp, finalStr = uiLabel:Wrap(text, finalStr, uiLabel.height)
  if not bWarp then
    local finallen = StringUtil.getTextLen(finalStr)
    local lastSpaceIndex = StringUtil.LastIndexOf(finalStr, " ") or finallen
    uiLabel.text = StringUtil.getTextByIndex(finalStr, 1, lastSpaceIndex)
    local textlen = StringUtil.getTextLen(text)
    if finallen < textlen then
      leftStr = StringUtil.getTextByIndex(text, lastSpaceIndex + 1, textlen)
    else
      leftStr = ""
    end
  else
    leftStr = nil
  end
  return bWarp, leftStr
end
function UIUtil.ChangeLayer(go, layer)
  layer = layer or go.gameObject.layer
  go.gameObject.layer = layer
  local trans = go.gameObject.transform
  for i = 0, trans.childCount - 1 do
    local transChild = trans:GetChild(i)
    transChild.gameObject.layer = layer
    UIUtil.ChangeLayer(transChild.gameObject, layer)
  end
end
function UIUtil.GetAllComponentInChildren(go, type)
  local result = UIUtil.GetAllComponentsInChildren(go, type, true)
  return result[1]
end
function UIUtil.GetAllComponentsInChildren(go, type, containSelf)
  local comps = {}
  local sp = go:GetComponent(type)
  if containSelf and sp then
    table.insert(comps, sp)
  end
  local childCount = go.transform.childCount
  for i = 0, childCount - 1 do
    local trans = go.transform:GetChild(i)
    local childComps = UIUtil.GetAllComponentsInChildren(trans.gameObject, type, true)
    for i = 1, #childComps do
      table.insert(comps, childComps[i])
    end
  end
  return comps
end
function UIUtil.GetComponentInParents(go, type)
  if go == nil then
    return nil
  end
  local comp
  local t = go.transform.parent
  while t ~= nil and comp == nil do
    comp = t.gameObject:GetComponent(type)
    t = t.parent
  end
  return comp
end
function UIUtil.LimitInputCharacter(input, limitNum, validFunc)
  local obj = input.gameObject
  if not GameObjectUtil.Instance:ObjectIsNULL(obj) then
    local inputLimit = math.max(limitNum * 5, 20)
    input.characterLimit = inputLimit
    local func = function(go, state)
      if not state then
        local str = input.value
        if type(validFunc) == "function" then
          str = validFunc(str)
        end
        local length = StringUtil.ChLength(str)
        if length > limitNum then
          str = StringUtil.getTextByIndex(str, 1, limitNum)
        end
        input.value = str
      end
    end
    UIEventListener.Get(obj).onSelect = {"+=", func}
  end
end
function UIUtil.PopupTipAchievement(achievement_conf_id)
  UIViewAchievementPopupTip.Instance:ShowAchievementPopupTip(achievement_conf_id)
end
function UIUtil.isClickLeftScreenArea()
  local tempVector3 = LuaVector3.zero
  local uiCamera = NGUIUtil:GetCameraByLayername("UI")
  if not uiCamera then
    return true
  end
  if Input.touchCount > 1 then
    for i = 1, Input.touchCount do
      local single = Input.GetTouch(i - 1)
      if single.phase == TouchPhase.Ended then
        local x, y = LuaGameObject.GetTouchPosition(i - 1, false)
        tempVector3:Set(x, y, 0)
        break
      end
    end
  else
    local x, y, z = LuaGameObject.GetMousePosition()
    tempVector3:Set(x, y, z)
  end
  local x, y, z = LuaGameObject.ScreenToWorldPointByVector3(uiCamera, tempVector3)
  return x <= 0
end
function UIUtil.FindGO(name, parent)
  return parent ~= nil and GameObjectUtil.Instance:DeepFind(parent, name) or nil
end
function UIUtil.FindComponent(name, comp, parent)
  local go = UIUtil.FindGO(name, parent)
  return go ~= nil and go:GetComponent(comp)
end
function UIUtil.FindAllComponents(parent, compType, containSelf)
  if parent == nil then
    return
  end
  return GameObjectUtil.Instance:GetAllComponentsInChildren(parent, compType, containSelf) or {}
end
function UIUtil.AddClickEvent(obj, event)
  if event == nil then
    return
  end
  UIEventListener.Get(obj).onClick = {"+=", event}
end
function UIUtil.RemoveClickEvent(obj, event)
  if event == nil then
    return
  end
  UIEventListener.Get(obj).onClick = {"-=", event}
end
function UIUtil.GetTextBeforeLastSpace(label, withCommon)
  local oldString = label.text
  local lastSpaceIndex = StringUtil.LastIndexOf(oldString, " ")
  if withCommon then
    label.text = StringUtil.getTextByIndex(oldString, 1, lastSpaceIndex) .. "..."
  else
    label.text = StringUtil.getTextByIndex(oldString, 1, lastSpaceIndex)
  end
end
function UIUtil.ResetAndUpdateAllAnchors(go)
  local uiRects = UIUtil.FindAllComponents(go, UIRect, true)
  if not uiRects or not next(uiRects) then
    return
  end
  for i = 1, #uiRects do
    uiRects[i]:ResetAndUpdateAnchors()
  end
end
