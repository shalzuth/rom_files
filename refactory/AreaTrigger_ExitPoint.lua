AreaTrigger_ExitPoint = class("AreaTrigger_ExitPoint")
local UpdateInterval = 0.1
local EffectPathMap = {
  [16] = "Common/16TeleportPoint",
  [26] = "Common/26TeleportPointP",
  [123] = "Common/123TeleportPoint"
}
function AreaTrigger_ExitPoint:ctor()
  self.invisibleEPMap = {}
  self.eps = {}
  self.epEffects = {}
  self:_Reset()
end
function AreaTrigger_ExitPoint:_Reset()
  TableUtility.ArrayClear(self.eps)
  TableUtility.ArrayClear(self.epEffects)
  TableUtility.TableClear(self.invisibleEPMap)
  self.currentEP = nil
  self.nextUpdateTime = 0
  self.onlyEPID = nil
  self.disable = 0
end
local OnEffectCreated = function(effectHandler, ep)
  Game.AreaTrigger_ExitPoint:_OnEffectCreated(effectHandler, ep)
end
function AreaTrigger_ExitPoint:_OnEffectCreated(effectHandler, ep)
  if nil ~= effectHandler and 0 < TableUtility.ArrayFindIndex(self.eps, ep) then
    Game.CullingObjectManager:Register_ExitPoint(ep, effectHandler)
  end
end
function AreaTrigger_ExitPoint:_AddEP(ep)
  TableUtility.ArrayPushBack(self.eps, ep)
  local effectPath = EffectPathMap[ep.commonEffectID]
  local effect = Asset_Effect.PlayAt(effectPath, ep.position, OnEffectCreated, ep)
  TableUtility.ArrayPushBack(self.epEffects, effect)
end
function AreaTrigger_ExitPoint:_RemoveEP(i)
  local ep = self.eps[i]
  local effect = self.epEffects[i]
  table.remove(self.eps, i)
  table.remove(self.epEffects, i)
  Game.CullingObjectManager:Unregister_ExitPoint(ep)
  effect:Destroy()
end
function AreaTrigger_ExitPoint:IsInvisible(id)
  return true == self.invisibleEPMap[id]
end
function AreaTrigger_ExitPoint:SetInvisibleEPs(epArray)
  TableUtility.TableClear(self.invisibleEPMap)
  if nil ~= epArray and #epArray > 0 then
    for i = 1, #epArray do
      self.invisibleEPMap[epArray[i]] = true
    end
  end
end
function AreaTrigger_ExitPoint:SetEPEnable(epID, enable)
  if self.running then
    if enable then
      if self.invisibleEPMap[epID] then
        self.invisibleEPMap[epID] = false
        local epMap = Game.MapManager:GetExitPointMap()
        local ep = epMap[epID]
        if nil ~= ep then
          self:_AddEP(ep)
        end
      end
    elseif not self.invisibleEPMap[epID] then
      local epMap = Game.MapManager:GetExitPointMap()
      local ep = epMap[epID]
      if nil ~= ep then
        local i = TableUtility.ArrayFindIndex(self.eps, ep)
        if i > 0 then
          self.invisibleEPMap[epID] = true
          self:_RemoveEP(i)
        end
      end
    end
  else
    self.invisibleEPMap[epID] = not enable
  end
end
function AreaTrigger_ExitPoint:CullingStateChange(epID, isVisible, currentDistance)
  if nil == isVisible then
    return
  end
  local eps = self.eps
  if #eps > 0 then
    for i = 1, #eps do
      local ep = eps[i]
      if epID == ep.ID then
        local epEffect = self.epEffects[i]
        if nil ~= epEffect then
          epEffect:SetActive(0 ~= isVisible)
        end
        return
      end
    end
  end
end
function AreaTrigger_ExitPoint:SetOnlyEP(epID)
  self.onlyEPID = epID
end
function AreaTrigger_ExitPoint:ClearOnlyEP()
  self.onlyEPID = nil
end
function AreaTrigger_ExitPoint:SetDisable(disable)
  if disable then
    self.disable = self.disable + 1
  else
    self.disable = self.disable - 1
  end
end
function AreaTrigger_ExitPoint:Launch()
  if self.running then
    return
  end
  self.running = true
  local epArray = Game.MapManager:GetExitPointArray()
  if nil ~= epArray and #epArray > 0 then
    for i = 1, #epArray do
      local ep = epArray[i]
      if not self.invisibleEPMap[ep.ID] then
        self:_AddEP(ep)
      end
    end
  end
end
function AreaTrigger_ExitPoint:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  for i = 1, #self.epEffects do
    local effect = self.epEffects[i]
    effect:Destroy()
  end
  Game.CullingObjectManager:Clear_ExitPoint()
  self:_Reset()
end
function AreaTrigger_ExitPoint:Update(time, deltaTime)
  if not self.running then
    return
  end
  if time < self.nextUpdateTime then
    return
  end
  self.nextUpdateTime = time + UpdateInterval
  local myselfPosition = Game.Myself:GetPosition()
  if nil ~= self.currentEP then
    local distance = VectorUtility.DistanceXZ(myselfPosition, self.currentEP.position)
    if distance < self.currentEP.range then
      return
    else
      self.currentEP = nil
    end
  end
  local eps = self.eps
  if #eps > 0 then
    for i = 1, #eps do
      local ep = eps[i]
      local distance = VectorUtility.DistanceXZ(myselfPosition, ep.position)
      if distance < ep.range then
        self.currentEP = ep
        LogUtility.InfoFormat("<color=blue>Enter Exit Point: </color>{0}, {1}, {2}", ep.ID, self.disable, self.onlyEPID)
        if 0 < self.disable then
          if nil ~= self.onlyEPID and self.onlyEPID == ep.ID then
            Game.Myself:Client_EnterExitRangeHandler(ep)
          end
          break
        end
        Game.Myself:Client_EnterExitRangeHandler(ep)
        break
      end
    end
  end
end
function AreaTrigger_ExitPoint:OnDrawGizmos()
  local eps = self.eps
  if #eps > 0 then
    if not Game.Myself or not Game.Myself:GetPosition() then
      local myselfPosition
    end
    for i = 1, #eps do
      local ep = eps[i]
      local color = LuaGeometry.Const_Col_blue
      if nil ~= myselfPosition then
        local distance = VectorUtility.DistanceXZ(myselfPosition, ep.position)
        if distance < ep.range then
          color = LuaGeometry.Const_Col_red
        end
      end
      DebugUtils.DrawCircle(ep.position, LuaGeometry.Const_Qua_identity, ep.range, 50, color)
    end
  end
end
