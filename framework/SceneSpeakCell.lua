SceneSpeakCell = reusableClass("SceneSpeakCell")
SceneSpeakCell.PoolSize = 10
SceneSpeakCell.ResID = ResourcePathHelper.UICell("SceneSpeakCell")
function SceneSpeakCell:CreateSpeakGO()
  if LuaGameObject.ObjectIsNull(self.parent) then
    return
  end
  if self.gameObject == nil or LuaGameObject.ObjectIsNull(self.gameObject) then
    self.gameObject = Game.AssetManager_UI:CreateSceneUIAsset(SceneSpeakCell.ResID, self.parent)
    self.gameObject.transform:SetParent(self.parent.transform, false)
    self.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.gameObject.transform.localScale = LuaGeometry.Const_V3_one
    self:SetOffsetY(0)
    self.widget = self.gameObject:GetComponent(UIWidget)
    self.label = GameObjectUtil.Instance:DeepFind(self.gameObject, "Label"):GetComponent(UILabel)
  end
  return self.gameObject
end
local cellOffset = LuaVector3()
function SceneSpeakCell:SetOffsetY(offsetY)
  cellOffset:Set(0, 10 + offsetY, 0)
  self.gameObject.transform.localPosition = cellOffset
end
function SceneSpeakCell:SetDelayDestroy(fadeInTime, stayTime, fadeOutTime)
  if self.gameObject then
    self.widget.alpha = 0
    self.fadeInTime = fadeInTime or 0
    self.stayTime = stayTime or 3
    self.fadeOutTime = fadeOutTime or 0
    self:_FadeIn()
  end
end
function SceneSpeakCell:CancelTween()
  if self.lt then
    self.lt:cancel()
    self.lt = nil
  end
end
function SceneSpeakCell:_FadeIn()
  self:CancelTween()
  if not Slua.IsNull(self.gameObject) then
    self.lt = LeanTween.value(self.gameObject, SceneSpeakCell._AlphaTo, 0, 1, self.fadeInTime)
    self.lt.onUpdateParam = self
    self.lt.onCompleteObject = SceneSpeakCell._FadeOut
    self.lt.onCompleteParam = self
  end
end
function SceneSpeakCell._AlphaTo(alpha, self)
  self.widget.alpha = alpha
end
function SceneSpeakCell:_FadeOut()
  self:CancelTween()
  if not Slua.IsNull(self.gameObject) then
    self.lt = LeanTween.value(self.gameObject, SceneSpeakCell._AlphaTo, 1, 0, self.fadeOutTime)
    self.lt.delay = self.stayTime
    self.lt.onUpdateParam = self
    self.lt.onCompleteObject = SceneSpeakCell._FadeEnd
    self.lt.onCompleteParam = self
  end
end
function SceneSpeakCell:_FadeEnd()
  self:CancelTween()
  local leftlen = StringUtil.getTextLen(self.leftStr)
  if type(self.leftStr) == "string" and leftlen > 0 then
    self:SetData(self.leftStr)
  elseif not Slua.IsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(SceneSpeakCell.ResID, self.gameObject)
    self.gameObject = nil
  end
end
function SceneSpeakCell:SetData(text)
  self:CreateSpeakGO()
  if self.gameObject == nil then
    return
  end
  if text and self.label then
    text = OverSea.LangManager.Instance():GetLangByKey(text)
    self:UpdateGameObjectActive()
    self.label.text = text
    UIUtil.FitLabelHeight(self.label, 230)
    local len = StringUtil.getTextLen(self.label.processedText)
    local textlen = StringUtil.getTextLen(text)
    if len < textlen then
      self.leftStr = StringUtil.getTextByIndex(text, len + 1, textlen)
    else
      self.leftStr = ""
    end
    self:SetDelayDestroy(0.3, 2, 0.5)
  end
end
function SceneSpeakCell:Active(b)
  self.objActive = b
  self:UpdateGameObjectActive()
end
function SceneSpeakCell:UpdateGameObjectActive()
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    self.gameObject:SetActive(self.objActive)
  end
end
function SceneSpeakCell:DoConstruct(asArray, parent)
  self.leftStr = ""
  self.objActive = true
  self.parent = parent
end
function SceneSpeakCell:DoDeconstruct(asArray)
  self:CancelTween()
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    Game.GOLuaPoolManager:AddToSceneUIPool(SceneSpeakCell.ResID, self.gameObject)
  end
  self.gameObject = nil
  self.parent = nil
end
