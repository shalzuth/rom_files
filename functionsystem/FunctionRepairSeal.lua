FunctionRepairSeal = class("FunctionRepairSeal")
function FunctionRepairSeal.Me()
  if nil == FunctionRepairSeal.me then
    FunctionRepairSeal.me = FunctionRepairSeal.new()
  end
  return FunctionRepairSeal.me
end
function FunctionRepairSeal:ctor()
end
function FunctionRepairSeal:AccessTarget(target)
  if target and target:GetCreatureType() == Creature_Type.Npc and target.data.staticData.Type == "SealNPC" then
    self:ActiveSeal(target.data.id)
  end
end
function FunctionRepairSeal:ActiveSeal(targetId)
  local nowMapId = Game.MapManager:GetMapID()
  local nowSealItem = SealProxy.Instance:GetSealItem(nowMapId, targetId)
  if not nowSealItem then
    printRed(string.format("cannot find map:%s target:%s", tostring(nowMapId), tostring(targetId)))
    return
  end
  if nowSealItem.etype == SceneSeal_pb.ESEALTYPE_NORMAL then
    local sealingItem = SealProxy.Instance:GetSealingItem()
    if sealingItem then
      if nowSealItem.issealing then
        if SealProxy.Instance.curvalue < SealProxy.Instance.maxvalue then
          self:DoConfirmRepair(nowSealItem.id)
        else
          printRed("\232\191\155\229\186\166\229\183\178\231\187\143\229\136\176\229\164\180\228\186\134 \228\184\141\232\174\169\231\130\185\229\135\187\239\188\129")
        end
      else
        MsgManager.ShowMsgByIDTable(1604)
      end
    elseif TeamProxy.Instance:IHaveTeam() then
      self:DoConfirmRepair(nowSealItem.id)
    else
      MsgManager.ShowMsgByIDTable(1607, {
        confirmHandler = function()
          GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
            view = PanelConfig.TeamFindPopUp,
            goalid = TeamGoalType.RepairSeal
          })
        end,
        cancelHandler = function()
          RClickFunction.CreateTeam()
        end
      })
    end
  elseif nowSealItem.etype == SceneSeal_pb.ESEALTYPE_PERSONAL then
    if nowSealItem.issealing then
      if SealProxy.Instance.curvalue < SealProxy.Instance.maxvalue then
        ServiceSceneSealProxy.Instance:CallBeginSeal(nowSealItem.id)
      else
        printRed("\232\191\155\229\186\166\229\183\178\231\187\143\229\136\176\229\164\180\228\186\134 \228\184\141\232\174\169\231\130\185\229\135\187\239\188\129")
      end
    else
      MsgManager.ConfirmMsgByID(1606, function()
        ServiceSceneSealProxy.Instance:CallBeginSeal(nowSealItem.id)
      end, nil, nil)
    end
  end
end
function FunctionRepairSeal:DoConfirmRepair(sealid)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.RepairSealConfirmPopUp,
    viewdata = {sealid = sealid}
  })
end
function FunctionRepairSeal:EnterSealArea()
  if self.isInSealArea then
    return
  end
  self.isInSealArea = true
  UIUtil.EndSceenCountDown(1603)
end
function FunctionRepairSeal:ExitSealArea(isRemove)
  if not self.isInSealArea then
    return
  end
  self.isInSealArea = false
  if not isRemove then
    UIUtil.SceneCountDownMsg(1603, {5}, true)
    ServiceSceneSealProxy.Instance:CallSealUserLeave()
  end
end
function FunctionRepairSeal:BeginRepairSeal()
  if self.isRepairing then
    return
  end
  self.isRepairing = true
  self:RefreshTraceInfo()
end
function FunctionRepairSeal:RefreshSealTimer()
  self:BeginRepairSeal()
  self:RefreshTraceInfo()
end
function FunctionRepairSeal:EndRepairSeal()
  if not self.isRepairing then
    return
  end
  self.isRepairing = false
  self:RefreshTraceInfo()
end
function FunctionRepairSeal:ResetRepairSeal()
  self.isRepairing = false
  self:CheckSealTraceInfo()
end
function FunctionRepairSeal:CheckSealTraceInfo()
  self:RemoveSealTrace()
  local sealId = SealProxy.Instance.nowAcceptSeal
  if sealId and Table_RepairSeal[sealId] then
    self:AddSealTrace(sealId)
  end
end
function FunctionRepairSeal:AddSealTrace(sealId)
  self.traceInfoData = {
    type = QuestDataType.QuestDataType_SEALTR,
    questDataStepType = QuestDataStepType.QuestDataStepType_MOVE,
    traceTitle = ZhString.MainViewSealInfo_TraceTitle
  }
  local sealData = Table_RepairSeal[sealId]
  self.traceInfoData.id = sealId
  self.traceInfoData.map = sealData.MapID
  self.mapName = Table_Map[sealData.MapID].NameZh
  self.traceInfoData.pos = SealProxy.Instance.nowSealPos
  QuestProxy.Instance:AddTraceCells({
    self.traceInfoData
  })
  self:RefreshTraceInfo()
end
function FunctionRepairSeal:RefreshTraceInfo()
  if not self.traceInfoData then
    return
  end
  local sealProxy = SealProxy.Instance
  self.sealValue = sealProxy.curvalue / sealProxy.maxvalue
  self.sealSpeed = sealProxy.speed / sealProxy.maxvalue
  if self.isRepairing then
    if self.sealSpeed == 0 then
      self:RemoveSealTimer()
    else
      self.timeTick_1 = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateProgress, self, 1)
    end
  else
    self:RemoveSealTimer()
    self.traceInfoData.traceInfo = self.mapName .. "\n" .. ZhString.MainViewSealInfo_GoRepairPct
    QuestProxy.Instance:UpdateTraceInfo(self.traceInfoData.type, self.traceInfoData.id, self.traceInfoData.traceInfo)
  end
end
function FunctionRepairSeal:_UpdateProgress()
  if not self.traceInfoData then
    self:RemoveSealTimer()
    return
  end
  local lastTime = self.lastTime or RealTime.time
  local deltaTime = RealTime.time - lastTime
  self.sealValue = self.sealValue + self.sealSpeed * deltaTime
  self.sealValue = math.max(self.sealValue, 0)
  self.sealValue = math.min(self.sealValue, 1)
  local sealPct = math.floor(self.sealValue * 100)
  if sealPct == 100 then
    self.traceInfoData.traceInfo = self.mapName .. "\n" .. ZhString.MainViewSealInfo_FinishRepair
  else
    self.traceInfoData.traceInfo = self.mapName .. "\n" .. string.format(ZhString.MainViewSealInfo_RepairPct, sealPct)
  end
  QuestProxy.Instance:UpdateTraceInfo(self.traceInfoData.type, self.traceInfoData.id, self.traceInfoData.traceInfo)
  self.lastTime = RealTime.time
end
function FunctionRepairSeal:RemoveSealTimer()
  if self.timeTick_1 then
    TimeTickManager.Me():ClearTick(self, 1)
  end
  self.timeTick_1 = nil
end
function FunctionRepairSeal:RemoveSealTrace()
  self:RemoveSealTimer()
  if self.traceInfoData then
    QuestProxy.Instance:RemoveTraceCell(self.traceInfoData.type, self.traceInfoData.id)
  end
  self.traceInfoData = nil
end
function FunctionRepairSeal:DoMoroccConfirmRepair(npcId)
  local data = MoroccTimeProxy.Instance:GetMoroccSealData()
  if data then
    for activityId, moroccSealInfo in pairs(data) do
      if moroccSealInfo.npcId == npcId then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.RepairSealConfirmPopUp,
          viewdata = {
            isMoroccSeal = true,
            activityId = activityId,
            raidId = moroccSealInfo.raidId
          }
        })
        return
      end
    end
    LogUtility.ErrorFormat("There's no MoroccSealData with npcId={0} when doing MoroccConfirmRepair!!", npcId)
  else
    LogUtility.Error("There's no MoroccSealData when doing MoroccConfirmRepair!!")
  end
end
