WorldTeleport = class("WorldTeleport")
WorldTeleport.DESTINATION_VALID_RANGE = 5
local PositionLockedCountLimit = 60
local tempBPArray = {}
local tempVector3 = LuaVector3.zero
function WorldTeleport.GetTransitNPCInfo(sourceMapID, targetMapID)
  if nil == MapOutterTeleport then
    errorLog("MapOutterTeleport is nil")
    return nil
  end
  if nil == MapOutterTeleport[sourceMapID] then
    return nil
  end
  if nil == MapOutterTeleport[sourceMapID][targetMapID] then
    return nil
  end
  local outterInfo = MapOutterTeleport[sourceMapID][targetMapID]
  return outterInfo.transitNPC, outterInfo.transitMap, outterInfo.transitNPCToMap
end
function WorldTeleport.CanArriveMap(sourceMapID, targetMapID)
  if sourceMapID == targetMapID then
    return true
  end
  if nil == MapOutterTeleport then
    errorLog("MapOutterTeleport is nil")
    return false
  end
  if nil == MapOutterTeleport[sourceMapID] then
    return false
  end
  if nil == MapOutterTeleport[sourceMapID][targetMapID] then
    return false
  end
  return true
end
function WorldTeleport.CreateInnerTeleportInfo(sourcePos, targetPos)
  local currentMapID = Game.MapManager:GetMapID()
  if NavMeshUtils.CanArrived(sourcePos, targetPos, WorldTeleport.DESTINATION_VALID_RANGE, true, nil) then
    local innerTeleportInfo = ReusableTable.CreateInnerTeleportInfo()
    innerTeleportInfo.mapID = currentMapID
    if nil ~= targetPos then
      innerTeleportInfo.targetPos = targetPos:Clone()
    end
    return innerTeleportInfo
  end
  if nil == MapInnerTeleport[currentMapID] then
    return nil
  end
  if nil == MapInnerTeleport[currentMapID].inner then
    return nil
  end
  local exitPointMap = Game.MapManager:GetExitPointMap()
  if nil == exitPointMap then
    return nil
  end
  local bps = Game.MapManager:GetBornPointArray()
  if nil == bps or #bps <= 0 then
    return nil
  end
  local endBPs = tempBPArray
  for i = 1, #bps do
    local bp = bps[i]
    local canArrive = false
    local path
    canArrive, path = NavMeshUtils.CanArrived(bp.position, targetPos, WorldTeleport.DESTINATION_VALID_RANGE, true, nil)
    if canArrive then
      table.insert(endBPs, {
        bornPoint = bp,
        cost = NavMeshUtils.GetPathDistance(path)
      })
    end
  end
  if 0 == #endBPs then
    return nil
  end
  local startEP, nextEP, endBP
  local minCost = 9999999999
  for k, v in pairs(MapInnerTeleport[currentMapID].inner) do
    for i = 1, #endBPs do
      local bpInfo = endBPs[i]
      if nil ~= v[bpInfo.bornPoint.ID] then
        local ep = exitPointMap[k]
        local canArrive = false
        local path
        canArrive, path = NavMeshUtils.CanArrived(sourcePos, ep.position, WorldTeleport.DESTINATION_VALID_RANGE, true, nil)
        if canArrive then
          local cost = NavMeshUtils.GetPathDistance(path) + v[bpInfo.bornPoint.ID].totalCost + bpInfo.cost
          if minCost > cost then
            minCost = cost
            startEP = ep
            endBP = bpInfo.bornPoint
            local nextEPID = v[bpInfo.bornPoint.ID].nextEP
            if nil ~= nextEPID then
              nextEP = exitPointMap[nextEPID]
            else
              nextEP = nil
            end
          end
        end
      end
    end
  end
  TableUtility.ArrayClear(endBPs)
  if nil == startEP then
    return nil
  end
  local innerTeleportInfo = ReusableTable.CreateInnerTeleportInfo()
  innerTeleportInfo.mapID = currentMapID
  if nil ~= targetPos then
    innerTeleportInfo.targetPos = targetPos:Clone()
  end
  innerTeleportInfo.ep = startEP
  innerTeleportInfo.nextEP = nextEP
  innerTeleportInfo.targetBPID = endBP.ID
  return innerTeleportInfo
end
function WorldTeleport.DestroyInnerTeleportInfo(info)
  ReusableTable.DestroyInnerTeleportInfo(info)
end
function WorldTeleport.CreateOutterTeleportInfo(sourcePos, targetMapID, targetBPID, targetPos)
  if nil == MapOutterTeleport then
    return nil
  end
  local currentMapID = Game.MapManager:GetMapID()
  if nil == MapOutterTeleport[currentMapID] then
    return nil
  end
  if nil == MapOutterTeleport[currentMapID][targetMapID] then
    return nil
  end
  local exitPointMap = Game.MapManager:GetExitPointMap()
  if nil == exitPointMap then
    return nil
  end
  local epID, nextMapID, nextBPID, nextEPID, outterInfo, outterInfoEPID, outterInfoBPID
  local outterMinCost = 9999999999
  for k, v in pairs(MapOutterTeleport[currentMapID][targetMapID]) do
    if nil ~= targetBPID then
      local info = v[targetBPID]
      if outterMinCost > info.totalCost then
        outterMinCost = info.totalCost
        outterInfo = info
        outterInfoEPID = k
        outterInfoBPID = targetBPID
      end
    elseif type(v) == "table" then
      for bk, bv in pairs(v) do
        if outterMinCost > bv.totalCost then
          outterMinCost = bv.totalCost
          outterInfo = bv
          outterInfoEPID = k
          outterInfoBPID = bk
        end
      end
    end
  end
  if nil == outterInfo then
    return nil
  end
  local outterEP = exitPointMap[outterInfoEPID]
  local p = outterEP.position
  tempVector3:Set(p[1], p[2], p[3])
  local innerTeleportInfo = WorldTeleport.CreateInnerTeleportInfo(sourcePos, tempVector3)
  if nil == innerTeleportInfo then
    return nil
  end
  if nil == innerTeleportInfo.ep then
    innerTeleportInfo.ep = outterEP
  end
  local outterTeleportInfo = ReusableTable.CreateOutterTeleportInfo()
  outterTeleportInfo.mapID = currentMapID
  outterTeleportInfo.epID = outterEP.ID
  outterTeleportInfo.nextMapID = outterEP.nextSceneID
  outterTeleportInfo.nextBPID = outterEP.nextSceneBornPointID
  outterTeleportInfo.nextEPID = outterInfo.nextEP
  outterTeleportInfo.targetMapID = targetMapID
  if nil ~= targetPos then
    outterTeleportInfo.targetPos = targetPos:Clone()
  end
  outterTeleportInfo.targetBPID = outterInfoBPID
  return outterTeleportInfo, innerTeleportInfo
end
function WorldTeleport.DestroyOutterTeleportInfo(info)
  ReusableTable.DestroyOutterTeleportInfo(info)
end
function WorldTeleport:ctor()
  self:Reset()
end
function WorldTeleport:Reset()
  self.pausing = false
  self.running = false
  if nil ~= self.innerTeleportInfo then
    local innerTargetPos = self.innerTeleportInfo.ep and self.innerTeleportInfo.epTargetPos or self.innerTeleportInfo.targetPos
    if nil ~= innerTargetPos then
      tempVector3:Set(innerTargetPos[1], innerTargetPos[2], innerTargetPos[3])
      if nil ~= Game.Myself.logicTransform.targetPosition and LuaVector3.Equal(innerTargetPos, Game.Myself.logicTransform.targetPosition) then
        Game.Myself:Logic_StopMove()
        Game.Myself:Logic_PlayAction_Idle()
      end
    end
    WorldTeleport.DestroyInnerTeleportInfo(self.innerTeleportInfo)
    self.innerTeleportInfo = nil
  end
  if nil ~= self.outterTeleportInfo then
    WorldTeleport.DestroyOutterTeleportInfo(self.outterTeleportInfo)
    self.outterTeleportInfo = nil
  end
  self.targetMapID = 0
  self.targetBPID = 0
  if nil ~= self.targetPos then
    self.targetPos:Destroy()
    self.targetPos = nil
  end
  self.innerMoving = false
  if self.clickGroundDisplaying then
    self.clickGroundDisplaying = false
    Game.ClickGroundEffectManager:HideEffect()
  end
  self.showClickGround = false
  if nil ~= self.prevPosition then
    self.prevPosition:Destroy()
    self.prevPosition = nil
  end
  self.positionLockedCount = 0
end
function WorldTeleport:ResetPath()
  if nil ~= self.innerTeleportInfo then
    WorldTeleport.DestroyInnerTeleportInfo(self.innerTeleportInfo)
    self.innerTeleportInfo = nil
  end
  if nil ~= self.outterTeleportInfo then
    WorldTeleport.DestroyOutterTeleportInfo(self.outterTeleportInfo)
    self.outterTeleportInfo = nil
  end
  local myPosition = Game.Myself:GetPosition()
  local currentMapID = Game.MapManager:GetMapID()
  if currentMapID == self.targetMapID then
    if nil ~= self.targetPos then
      self.innerTeleportInfo = WorldTeleport.CreateInnerTeleportInfo(myPosition, self.targetPos)
      if nil == self.innerTeleportInfo then
        return false
      end
    else
      return false
    end
  else
    local outterTeleportInfo, innerTeleportInfo = WorldTeleport.CreateOutterTeleportInfo(myPosition, self.targetMapID, self.targetBPID, self.targetPos)
    if nil == outterTeleportInfo or nil == innerTeleportInfo then
      return false
    end
    local exitPointMap = Game.MapManager:GetExitPointMap()
    if nil == exitPointMap then
      return false
    end
    self.outterTeleportInfo = outterTeleportInfo
    self.innerTeleportInfo = innerTeleportInfo
    LogUtility.Info("<color=green>WorldTeleport:ResetPath</color> outter")
  end
  return true
end
function WorldTeleport:ResetTarget(targetMapID, targetBPID, targetPos, showClickGround)
  self.targetMapID = targetMapID
  self.targetBPID = targetBPID
  if nil ~= targetPos then
    self.targetPos = VectorUtility.Asign_3(self.targetPos, targetPos)
  elseif nil ~= self.targetPos then
    self.targetPos:Destroy()
    self.targetPos = nil
  end
  self.showClickGround = showClickGround or false
  if self:ResetPath() then
    self:InnerTeleportMove()
    return true
  else
    return false
  end
end
function WorldTeleport:Launch(targetMapID, targetBPID, targetPos, showClickGround, allowExitPoint)
  if self.running then
    self:Shutdown()
  end
  self.running = self:ResetTarget(targetMapID, targetBPID, targetPos, showClickGround)
  if self.running then
    if not allowExitPoint then
      self.exitPointDisabled = true
      Game.AreaTrigger_ExitPoint:SetDisable(true)
    end
    local eventManager = EventManager.Me()
    eventManager:AddEventListener(MyselfEvent.PlaceTo, self.OnMyselfPlaceTo, self)
    eventManager:AddEventListener(MyselfEvent.LeaveScene, self.OnMyselfLeaveScene, self)
  end
  return self.running
end
function WorldTeleport:Update()
  if not self.running then
    return
  end
  if self.pausing then
    return
  end
  self:OutterTeleportUpdate()
  local positionLocked = self:InnerTeleportUpdate()
  if positionLocked or self:OutterArrived() and self:InnerArrived() then
    self.positionLockedCount = 0
    self:Shutdown()
  end
end
function WorldTeleport:Shutdown()
  if not self.running then
    return
  end
  Game.AreaTrigger_ExitPoint:ClearOnlyEP()
  if self.exitPointDisabled then
    self.exitPointDisabled = false
    Game.AreaTrigger_ExitPoint:SetDisable(false)
  end
  self:Reset()
  local eventManager = EventManager.Me()
  eventManager:RemoveEventListener(MyselfEvent.PlaceTo, self.OnMyselfPlaceTo, self)
  eventManager:RemoveEventListener(MyselfEvent.LeaveScene, self.OnMyselfLeaveScene, self)
end
function WorldTeleport:Pause()
  if self.pausing then
    return
  end
  self.pausing = true
end
function WorldTeleport:Resume()
  if not self.pausing then
    return
  end
  self.pausing = false
  if self.running then
    if nil ~= self.outterTeleportInfo then
      local currentMapID = Game.MapManager:GetMapID()
      if currentMapID ~= self.outterTeleportInfo.mapID then
        self:ResetPath()
        return
      end
    end
    if nil == self.innerTeleportInfo then
      self:ResetPath()
    else
      local currentMapID = Game.MapManager:GetMapID()
      if currentMapID ~= self.targetMapID then
        self:ResetPath()
      end
    end
    if nil ~= self.innerTeleportInfo then
      self:InnerTeleportMove()
    end
  end
end
function WorldTeleport:OutterArrived()
  return nil == self.outterTeleportInfo or Game.MapManager:GetMapID() == self.outterTeleportInfo.targetMapID
end
function WorldTeleport:OutterTeleportUpdate()
  local currentMapID = Game.MapManager:GetMapID()
  if nil == self.outterTeleportInfo then
    if currentMapID ~= self.targetMapID then
      Game.Myself:Logic_PlayAction_Idle()
      self:ResetPath()
    end
    return
  end
  local outterTeleportInfo = self.outterTeleportInfo
  local targetMapID = outterTeleportInfo.targetMapID
  if currentMapID == targetMapID then
    Game.Myself:Logic_PlayAction_Idle()
    self:ResetPath()
  elseif currentMapID == outterTeleportInfo.nextMapID then
    Game.Myself:Logic_PlayAction_Idle()
    local bpID = outterTeleportInfo.nextBPID
    local epID = outterTeleportInfo.nextEPID
    local targetBPID = outterTeleportInfo.targetBPID
    local outterInfo = MapOutterTeleport[currentMapID][targetMapID][epID][targetBPID]
    local exitPointMap = Game.MapManager:GetExitPointMap()
    local ep = exitPointMap[epID]
    outterTeleportInfo.mapID = currentMapID
    outterTeleportInfo.nextMapID = ep.nextSceneID
    outterTeleportInfo.nextBPID = ep.nextSceneBornPointID
    outterTeleportInfo.nextEPID = outterInfo.nextEP
    local innerTeleportInfo = ReusableTable.CreateInnerTeleportInfo()
    local p = ep.position
    innerTeleportInfo.targetPos = LuaVector3.New(p[1], p[2], p[3])
    local innerOutterInfo = MapInnerTeleport[currentMapID].outter[bpID][epID]
    if nil ~= innerOutterInfo.startEP then
      local innerInnerInfo = MapInnerTeleport[currentMapID].inner[innerOutterInfo.startEP][innerOutterInfo.endBP]
      local startEP = exitPointMap[innerOutterInfo.startEP]
      local nextEP = exitPointMap[innerInnerInfo.nextEP]
      innerTeleportInfo.ep = startEP
      innerTeleportInfo.nextEP = nextEP
      innerTeleportInfo.targetBPID = innerOutterInfo.endBP
    end
    if nil ~= self.innerTeleportInfo then
      WorldTeleport.DestroyInnerTeleportInfo(self.innerTeleportInfo)
    end
    self.innerTeleportInfo = innerTeleportInfo
    self:InnerTeleportMove()
  elseif currentMapID == self.outterTeleportInfo.mapID then
  else
    Game.Myself:Logic_PlayAction_Idle()
    self:ResetPath()
  end
end
function WorldTeleport:InnerArrived()
  if nil == self.innerTeleportInfo then
    return true
  end
  if Game.MapManager:GetMapID() ~= self.innerTeleportInfo.mapID then
    return true
  end
  if VectorUtility.AlmostEqual_3_XZ(Game.Myself:GetPosition(), self.innerTeleportInfo.targetPos) then
    if nil ~= self.innerTeleportInfo.nextEP then
      return false
    end
    if nil ~= self.innerTeleportInfo.ep and nil ~= self.targetPos then
      return false
    end
    return true
  end
  return false
end
function WorldTeleport:InnerTeleportUpdate()
  if nil == self.innerTeleportInfo then
    return false
  end
  if not Game.Myself:IsMoving() then
    if self:InnerArrived() then
      WorldTeleport.DestroyInnerTeleportInfo(self.innerTeleportInfo)
      self.innerTeleportInfo = nil
      if self.innerMoving then
        Game.Myself:Logic_PlayAction_Idle()
        self.innerMoving = false
      end
      return
    end
    self:InnerTeleportMove()
  else
    Game.Myself:Logic_SamplePosition(time)
    local newPosition = Game.Myself:GetPosition()
    if nil ~= self.prevPosition and LuaVector3.Equal(self.prevPosition, newPosition) then
      self.positionLockedCount = self.positionLockedCount + 1
      if PositionLockedCountLimit < self.positionLockedCount then
        return true
      end
    else
      self.prevPosition = VectorUtility.Asign_3(self.prevPosition, newPosition)
      self.positionLockedCount = 0
    end
  end
  return false
end
function WorldTeleport:InnerTeleportMove()
  if self.pausing then
    return
  end
  local innerTeleportInfo = self.innerTeleportInfo
  if nil ~= innerTeleportInfo then
    if self.showClickGround then
      self.clickGroundDisplaying = true
      if nil == self.outterTeleportInfo and nil ~= self.targetPos then
        Game.ClickGroundEffectManager:SetPos(self.targetPos)
      else
        Game.ClickGroundEffectManager:SetPos(innerTeleportInfo.targetPos)
      end
    end
    Game.Myself:Logic_PlayAction_Move()
    if nil ~= innerTeleportInfo.ep then
      local epPos = innerTeleportInfo.ep.position
      Game.AreaTrigger_ExitPoint:SetOnlyEP(innerTeleportInfo.ep.ID)
      Game.Myself:Logic_NavMeshMoveTo(epPos)
      local targetPosition = Game.Myself.logicTransform.targetPosition
      if nil ~= targetPosition then
        innerTeleportInfo.epTargetPos = VectorUtility.Asign_3(innerTeleportInfo.epTargetPos, targetPosition)
      end
    else
      if nil ~= self.outterTeleportInfo then
        Game.AreaTrigger_ExitPoint:SetOnlyEP(self.outterTeleportInfo.epID)
      else
        Game.AreaTrigger_ExitPoint:ClearOnlyEP()
      end
      Game.Myself:Logic_NavMeshMoveTo(innerTeleportInfo.targetPos)
      local targetPosition = Game.Myself.logicTransform.targetPosition
      if nil ~= targetPosition then
        innerTeleportInfo.targetPos = VectorUtility.Asign_3(innerTeleportInfo.targetPos, targetPosition)
      end
    end
    self.innerMoving = true
  end
end
function WorldTeleport:InnerTeleportSwitch()
  local innerTeleportInfo = self.innerTeleportInfo
  innerTeleportInfo.ep = innerTeleportInfo.nextEP
  innerTeleportInfo.nextEP = nil
  if nil ~= innerTeleportInfo.ep then
    local currentMapID = Game.MapManager:GetMapID()
    local innerInnerInfo = MapInnerTeleport[currentMapID].inner[innerTeleportInfo.ep.ID][innerTeleportInfo.targetBPID]
    if nil ~= innerInnerInfo.nextEP then
      innerTeleportInfo.nextEP = Game.MapManager:GetExitPointMap()[innerInnerInfo.nextEP]
    end
  elseif nil == self.outterTeleportInfo then
    if nil ~= self.targetPos then
      innerTeleportInfo.targetPos = VectorUtility.Asign_3(innerTeleportInfo.targetPos, self.targetPos)
    else
      innerTeleportInfo.targetPos = VectorUtility.Asign_3(innerTeleportInfo.targetPos, Game.Myself:GetPosition())
      return
    end
  end
  self:InnerTeleportMove()
end
function WorldTeleport:OnMyselfPlaceTo(event)
  if not event.data then
    return
  end
  local innerTeleportInfo = self.innerTeleportInfo
  if nil == innerTeleportInfo then
    return
  end
  if Game.MapManager:GetMapID() ~= innerTeleportInfo.mapID then
    if nil == self.outterTeleportInfo then
      self:Shutdown()
    end
    return
  end
  self:InnerTeleportSwitch()
end
function WorldTeleport:OnMyselfLeaveScene(event)
  local innerTeleportInfo = self.innerTeleportInfo
  if nil == innerTeleportInfo then
    return
  end
  WorldTeleport.DestroyInnerTeleportInfo(self.innerTeleportInfo)
  self.innerTeleportInfo = nil
  if self.innerMoving then
    Game.Myself:Logic_PlayAction_Idle()
    self.innerMoving = false
  end
  if nil == self.outterTeleportInfo then
    self:Shutdown()
  end
end
