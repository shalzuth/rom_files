local baseCell = autoImport("BaseCell")
QuestTraceCell = class("QuestTraceCell", baseCell)
function QuestTraceCell:Init()
  self:initView()
end
function QuestTraceCell:initView()
  self.stepName = self:FindComponent("StepName", UILabel)
  self.stepTarget = self:FindComponent("StepTarget", UILabel)
  self.traceScrollViewPanel = self:FindComponent("TraceScrollView", UIPanel)
  self.traceScrollView = self:FindComponent("TraceScrollView", UIScrollView)
  self.traceMark = self:FindGO("TraceMark")
  self.angle = self:FindGO("angle")
  self.questState = self:FindGO("questState")
  self:AddButtonEvent("TraceMark", function()
    if self.data.questData then
      if not self.isMainViewTrace then
        EventManager.Me():DispatchEvent(QuestManualEvent.BeforeGoClick, self)
      end
      FunctionQuest.Me():executeManualQuest(self.data.questData)
    end
  end)
end
function QuestTraceCell:SetData(data)
  self.data = data
  local isAcceptable = true
  local questData = data.questData
  self.questId = questData.id
  self.stepTarget.text = ""
  if questData.staticData then
    self.stepName.text = questData.staticData.Name
    local desStr = questData:parseTranceInfo()
    if questData.type == QuestDataType.QuestDataType_DAILY then
      local dailyData = QuestProxy.Instance:getDailyQuestData(SceneQuest_pb.EOTHERDATA_DAILY)
      local ratio = "0%"
      local exp = "0"
      if dailyData then
        ratio = dailyData.param4 * 100
        ratio = ratio .. "%"
        exp = dailyData.param3
      end
      desStr = string.format(desStr, exp)
    end
    local tempdesStr = ""
    if data.type ~= SceneQuest_pb.EQUESTLIST_ACCEPT then
      local qStaticData = questData.staticData
      local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
      if mylv <= qStaticData.Level and qStaticData.Level ~= 0 then
        tempdesStr = string.format(ZhString.QuestManual_Level, qStaticData.Level)
      end
      local myRisk = AdventureDataProxy.Instance:getManualLevel()
      if myRisk <= qStaticData.Risklevel and qStaticData.Risklevel ~= 0 then
        tempdesStr = tempdesStr .. string.format(ZhString.QuestManual_RiskLevel, qStaticData.Risklevel)
      end
      local myjob = Game.Myself.data.userdata:Get(UDEnum.JOBLEVEL)
      if myjob <= qStaticData.Joblevel and qStaticData.Joblevel ~= 0 then
        tempdesStr = tempdesStr .. string.format(ZhString.QuestManual_JobLevel, qStaticData.Joblevel)
      end
      local mycook = Game.Myself.data.userdata:Get(UDEnum.COOKER_LV)
      if mycook <= qStaticData.CookerLv and qStaticData.CookerLv ~= 0 then
        tempdesStr = tempdesStr .. string.format(ZhString.QuestManual_CookerLevel, qStaticData.CookerLv)
      end
      local mytaste = Game.Myself.data.userdata:Get(UDEnum.TASTER_LV)
      if mytaste <= qStaticData.TasterLv and qStaticData.TasterLv ~= 0 then
        tempdesStr = tempdesStr .. string.format(ZhString.QuestManual_TasterLevel, qStaticData.TasterLv)
      end
      preQuestList = questData.preQuest
      local isPrenameAdded = false
      if preQuestList and 0 < #preQuestList then
        tempdesStr = tempdesStr .. ZhString.QuestManual_FormerQuest
        isPrenameAdded = true
        for i = 1, #preQuestList do
          local questName = QuestManualProxy.Instance:GetQuestNameById(preQuestList[i])
          if questName then
            tempdesStr = tempdesStr .. string.format(ZhString.QuestManual_QuestName, questName)
          end
        end
      end
      mustPreQuestList = questData.mustPreQuest
      if mustPreQuestList and 0 < #mustPreQuestList then
        if not isPrenameAdded then
          tempdesStr = tempdesStr .. ZhString.QuestManual_FormerQuest
        end
        for i = 1, #mustPreQuestList do
          local questName = QuestManualProxy.Instance:GetQuestNameById(mustPreQuestList[i])
          tempdesStr = tempdesStr .. string.format(ZhString.QuestManual_QuestName, questName)
        end
      end
      if tempdesStr and tempdesStr ~= "" then
        desStr = tempdesStr
      end
    end
    if questData.staticData.PreNoShow == 1 then
      self.stepTarget.text = ""
    else
      self.stepTarget.text = string.gsub(desStr, "ffff00", "FFA823")
    end
    self.traceScrollView:ResetPosition()
  else
    self.stepName.text = data.questPreName
  end
  if data.type then
    if data.type == SceneQuest_pb.EQUESTLIST_ACCEPT then
      self.traceMark:SetActive(true)
      self.questState:SetActive(false)
    elseif data.type == SceneQuest_pb.EQUESTLIST_CANACCEPT then
      self.traceMark:SetActive(false)
      self.questState:SetActive(false)
    elseif data.type == SceneQuest_pb.EQUESTLIST_SUBMIT then
      self.traceMark:SetActive(false)
      self.questState:SetActive(true)
    else
      self.traceMark:SetActive(false)
      self.questState:SetActive(false)
    end
  end
  if self.angle then
    if questData.type == QuestDataType.QuestDataType_MAIN or questData.type == QuestDataType.QuestDataType_CCRASTEHAM then
      self.angle:SetActive(true)
    else
      self.angle:SetActive(false)
    end
  end
  local upPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
  if upPanel and self.traceScrollViewPanel then
    self.traceScrollViewPanel.depth = upPanel.depth + 1
  end
end
function QuestTraceCell:SetIsMainViewTrace()
  self.isMainViewTrace = true
end
