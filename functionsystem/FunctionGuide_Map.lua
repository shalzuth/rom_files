Guild_RemoveType = {Click = 1, Time = 2}
local Remove_DefaultTime = 3
function FunctionGuide:AddMapGuide(questData)
  if questData == nil then
    return
  end
  if questData.map == self.guide_mapid then
    return
  end
  self.guide_mapid = questData.map
  self.guide_SymbolType = QuestSymbolCheck.GetQuestSymbolByQuest(questData)
  local mapAreaData = WorldMapProxy.Instance:GetMapAreaDataByMapId(self.guide_mapid)
  if mapAreaData == nil then
    return
  end
  if mapAreaData.isactive then
    self:RemoveMapGuide(mapid, true)
    self.guide_mapid = mapid
    return
  end
  GameFacade.Instance:sendNotification(GuideEvent.MapGuide_Change)
end
function FunctionGuide:RemoveMapGuide(mapid)
  if mapid ~= nil and mapid ~= self.guide_mapid then
    return
  end
  self:ClearGuide()
  self.guide_mapid = nil
  self.guide_SymbolType = nil
  GameFacade.Instance:sendNotification(GuideEvent.MapGuide_Change)
end
function FunctionGuide:GetGuildMapId()
  return self.guide_mapid, self.guide_SymbolType
end
local tempV3 = LuaVector3()
function FunctionGuide:AttachGuideEffect(attachGO, removeType, removetime)
  if self.guide_mapid == nil then
    return
  end
  if attachGO == nil then
    return
  end
  if self.EFFECT_RESPATH == nil then
    self.EFFECT_RESPATH = ResourcePathHelper.EffectUI(EffectMap.UI.HlightBox)
  end
  if self.effectMap == nil then
    self.effectMap = {}
  end
  local effectGO = self.effectMap[attachGO]
  if effectGO == nil then
    local bound = NGUIMath.CalculateRelativeWidgetBounds(attachGO.transform, true)
    effectGO = Game.AssetManager_UI:CreateAsset(self.EFFECT_RESPATH, attachGO)
    effectGO.transform.localPosition = LuaVector3.zero
    effectGO.transform.localScale = LuaVector3.one
    local uitex = UIUtil.FindComponent("pic_skill_uv_add", UIWidget, effectGO)
    effectGO:SetActive(true)
    uitex.width = bound.size.x + 20
    uitex.height = bound.size.y + 30
    self.effectMap[attachGO] = effectGO
    if removeType & Guild_RemoveType.Click > 0 then
      UIUtil.AddClickEvent(attachGO, FunctionGuide.event_RemoveGuildEffect)
    end
  end
  if effectGO ~= nil and 0 < removeType & Guild_RemoveType.Time then
    removetime = removetime or Remove_DefaultTime
    if self.timeRemoveCheckMap == nil then
      self.timeRemoveCheckMap = {}
    end
    self.timeRemoveCheckMap[attachGO] = removetime * 1000
    self:AddTimeRemoveCheck()
  end
end
function FunctionGuide.event_RemoveGuildEffect(attachGO)
  FunctionGuide.Me():RemoveGuideEffect(attachGO)
end
function FunctionGuide:AddTimeRemoveCheck()
  if self.timeRemoveCheckMap == nil then
    return
  end
  if not self:_UpdateTimeRemoveCheck(0) then
    return
  end
  if self.timeRemoveCheck ~= nil then
    return
  end
  self.timeRemoveCheck = TimeTickManager.Me():CreateTick(1000, 1000, self._UpdateTimeRemoveCheck, self, 1)
end
function FunctionGuide:_UpdateTimeRemoveCheck(deltatime)
  local left = false
  for attachGO, lefttime in pairs(self.timeRemoveCheckMap) do
    local effectGO = self.effectMap[attachGO]
    if effectGO == nil then
      self.timeRemoveCheckMap[attachGO] = nil
    end
    lefttime = lefttime - deltatime
    if lefttime <= 0 then
      self:RemoveGuideEffect(attachGO)
      self.timeRemoveCheckMap[attachGO] = nil
    else
      self.timeRemoveCheckMap[attachGO] = lefttime
      left = true
    end
  end
  if left == false then
    self:RemoveTimeRemoveCheck()
    return false
  end
  return true
end
function FunctionGuide:RemoveTimeRemoveCheck()
  if self.timeRemoveCheck == nil then
    return
  end
  TimeTickManager.Me():ClearTick(self, 1)
  self.timeRemoveCheck = nil
end
function FunctionGuide:RemoveGuideEffect(attachGO)
  if self.effectMap == nil then
    return
  end
  local effectGO = self.effectMap[attachGO]
  if effectGO ~= nil then
    Game.GOLuaPoolManager:AddToUIPool(self.EFFECT_RESPATH, effectGO)
    self.effectMap[attachGO] = nil
    UIUtil.RemoveClickEvent(attachGO, FunctionGuide.event_RemoveGuildEffect)
  end
end
function FunctionGuide:ClearGuide()
  if self.effectMap == nil then
    return
  end
  for attachGO, v in pairs(self.effectMap) do
    self:RemoveGuideEffect(attachGO)
  end
end
