FunctionVisitNpc = class("FunctionVisitNpc")
AccessCustomType = {
  Quest = 1,
  Follow = 2,
  ReviveBySkill = 4,
  UseItem = 5,
  CatchPet = 6,
  UseSkill = 7
}
AutoTriggerQuestMap = {
  [QuestDataType.QuestDataType_MAIN] = 1,
  [QuestDataType.QuestDataType_BRANCH] = 1,
  [QuestDataType.QuestDataType_WANTED] = 1,
  [QuestDataType.QUESTDATATYPE_SATISFACTION] = 1,
  [QuestDataType.QuestDataType_ELITE] = 1,
  [QuestDataType.QuestDataType_Raid_Talk] = 1,
  [QuestDataType.QuestDataType_CCRASTEHAM] = 1,
  [QuestDataType.QuestDataType_CHILD] = 1
}
local tempV3 = LuaVector3()
local _tutorMatchStatus = TutorProxy.TutorMatchStatus
function FunctionVisitNpc.Me()
  if nil == FunctionVisitNpc.me then
    FunctionVisitNpc.me = FunctionVisitNpc.new()
  end
  return FunctionVisitNpc.me
end
function FunctionVisitNpc:ctor()
  self.visitRef = 0
end
function FunctionVisitNpc:GetTargetId()
  return self.targetId
end
function FunctionVisitNpc:GetTarget()
  return SceneCreatureProxy.FindCreature(self.targetId)
end
function FunctionVisitNpc.AccessGuildFlag(flagid, trans)
  if GameConfig.SystemForbid.GVG then
    return
  end
  if trans == nil then
    return
  end
  tempV3:Set(LuaGameObject.GetPosition(trans))
  local myPos = Game.Myself:GetPosition()
  local distance = LuaVector3.Distance(tempV3, myPos)
  if distance > 0.1 then
    Game.Myself:Client_MoveTo(tempV3, nil, FunctionVisitNpc._AccessGuildFlag, self, flagid, 1)
  else
    FunctionVisitNpc.Me():_AccessGuildFlag(flagid)
  end
end
function FunctionVisitNpc:_AccessGuildFlag(flagid)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GvgLandInfoPopUp,
    viewdata = {flagid = flagid}
  })
end
function FunctionVisitNpc:AccessCatchingPet(target)
  if self.canShowCatchPetMsg then
    self.canShowCatchPetMsg = false
    MsgManager.ShowMsgByIDTable(9016)
  end
  if self.cd_LT then
    self.cd_LT:cancel()
    self.cd_LT = nil
  end
  self.cd_LT = LeanTween.delayedCall(1, function()
    self.canShowCatchPetMsg = true
    self.cd_LT = nil
  end)
end
local tempArgs = {}
function FunctionVisitNpc:AccessTarget(target, custom, customType)
  if nil == target then
    self.targetId = 0
    return
  end
  self.targetId = target.data.id
  local targetStaticID = 0
  if target.data and target.data.staticData then
    targetStaticID = target.data.staticData.id
  end
  local bossStepQuest = QuestProxy.Instance.worldbossQuest
  if targetStaticID == bossStepQuest.npcid then
    local dlist
    redlog("bossStepQuest[dialog_select]", bossStepQuest.dialog_select)
    redlog(type(bossStepQuest.dialog_select))
    if bossStepQuest.dialog_select == 1 then
      redlog("yes")
      printData(bossStepQuest.yes_dialogs)
      dlist = bossStepQuest.yes_dialogs
    elseif bossStepQuest.dialog_select == 2 then
      redlog("no")
      dlist = bossStepQuest.no_dialogs
      printData(bossStepQuest.no_dialogs)
    end
    local viewdata = {
      viewname = "DialogView",
      dialoglist = dlist,
      npcinfo = target,
      callback = self.callNextBossStep
    }
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
    return
  end
  local target = self:GetTarget()
  if not target then
    return
  end
  local myself = Game.Myself
  local handed, handowner = myself:IsHandInHand()
  if handed and not handowner then
    MsgManager.ShowMsgByIDTable(824)
    return
  end
  if Game.Myself:IsInBooth() then
    MsgManager.ShowMsgByID(25710)
    return
  end
  if target.data then
    local _PvpTeamRaid = DungeonProxy.Instance:GetConfigPvpTeamRaid()
    if Game.MapManager:IsPVPMode_TeamPws() then
      if target.data.IsElementNpc_Mid and target.data:IsElementNpc_Mid() then
        if not Game.Myself:GetTeamPwsBall() then
          MsgManager.ShowMsgByIDTable(25928)
          return
        end
        local elementSkillID = _PvpTeamRaid.BuffCollectSkillID
        Game.Myself:Client_UseSkill(elementSkillID, target, nil, nil, true)
        return
      end
      if target.data.IsElementNpc and target.data:IsElementNpc() then
        local elementSkillID = _PvpTeamRaid.ElementCollectSkillID
        Game.Myself:Client_UseSkill(elementSkillID, target, nil, nil, true)
        return
      end
    end
  end
  if custom then
    if not customType then
      errorLog("customType Is Nil")
      customType = AccessCustomType.Quest
    end
  else
    customType = nil
  end
  if customType == AccessCustomType.ReviveBySkill then
    MsgManager.ConfirmMsgByID(2513, function()
      Game.Myself:Client_UseSkill(custom, target, nil, nil, true)
    end, nil, nil, target.data.name)
    return
  elseif customType == AccessCustomType.UseItem then
    FunctionItemFunc.TryUseItem(custom, target)
    return
  elseif customType == AccessCustomType.CatchPet then
    ServiceScenePetProxy.Instance:CallCatchPetPetCmd(custom, false)
    return
  elseif customType == AccessCustomType.UseSkill then
    Game.Myself:Client_UseSkill(custom, target, nil, nil, true)
    return
  end
  if target:GetCreatureType() == Creature_Type.Npc then
    local npcData = target.data.staticData
    if not npcData then
      return
    end
    local ntype = npcData.Type
    if ntype == NpcData.NpcDetailedType.SealNPC then
      FunctionRepairSeal.Me():AccessTarget(target)
      return
    end
    if ntype == NpcData.NpcDetailedType.FoodNpc then
      FunctionFood.Me():AccessFoodNpc(target)
      return
    end
    if ntype == NpcData.NpcDetailedType.PetNpc then
      return
    end
    if ntype == NpcData.NpcDetailedType.CatchNpc then
      return
    end
    local npcfunc = npcData.NpcFunction
    ServiceQuestProxy.Instance:CallVisitNpcUserCmd(target.data.id)
    if customType == AccessCustomType.Quest then
      local questData = QuestProxy.Instance:getQuestDataByIdAndType(custom)
      if not questData then
        helplog("No QuestData !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        return
      end
      local questParama = questData.staticData.Params
      local npc = questParama.npc
      if type(npc) == "table" then
        npc = npc[1]
      end
      if npcData.id == npc then
        self:ExcuteQuestEvent(target, questData)
        return
      end
    elseif customType == AccessCustomType.Follow then
      local triggerQuest, branchlsts = self:CheckNpcQuest(npcData.id, target.data.uniqueid)
      if self:HandleFollowTransfer(triggerQuest, branchlsts, custom) then
        return
      end
    end
    local triggerQuest, branchlsts = self:CheckNpcQuest(npcData.id, target.data.uniqueid)
    if triggerQuest then
      self:ExcuteQuestEvent(target, triggerQuest)
    else
      for _, trapId in pairs(GameConfig.TrapNpcID) do
        if npcData.id == trapId then
          return
        end
      end
      self:ExcuteDefaultDialog(target, branchlsts)
    end
  end
end
function FunctionVisitNpc._HelpDoFollowTransfer(quest, toMapId)
  local params = quest.staticData.Params
  if params.telePath then
    for i = 1, #params.telePath do
      if params.telePath[i][1] == toMapId then
        local optionid
        if params.telePath[i][2] and params.telePath[i][2] ~= 0 then
          optionid = params.telePath[i][2]
        end
        FunctionVisitNpc._DialogEndCall(quest.id, optionid, true, quest.scope)
        return true
      end
    end
  elseif params.teleMap then
    for i = 1, #params.teleMap do
      if params.teleMap[i] == toMapId then
        FunctionVisitNpc._DialogEndCall(quest.id, nil, true, quest.scope)
        return true
      end
    end
  end
  return false
end
function FunctionVisitNpc:HandleFollowTransfer(triggerQuest, branchlsts, followTargetMap)
  if not followTargetMap then
    return false
  end
  if followTargetMap == Game.MapManager:GetMapID() then
    return false
  end
  if triggerQuest and FunctionVisitNpc._HelpDoFollowTransfer(triggerQuest, followTargetMap) then
    return true
  end
  if branchlsts then
    for k = 1, #branchlsts do
      if FunctionVisitNpc._HelpDoFollowTransfer(branchlsts[k], followTargetMap) then
        return true
      end
    end
  end
  FunctionSystem.InterruptMyFollow()
  return false
end
function FunctionVisitNpc:ExcuteQuestEvent(target, questData)
  local stepType = questData.questDataStepType
  if not questData.staticData then
    errorLog("QUEST ERROR ~!~")
    return
  end
  local isValid = false
  local params = questData.staticData.Params
  if params.uniqueid then
    isValid = target.data.uniqueid == params.uniqueid
  elseif type(params.npc) == "number" then
    isValid = target.data.staticData.id == params.npc
  elseif type(params.npc) == "table" then
    for _, npcid in pairs(params.npc) do
      if npcid == target.data.staticData.id then
        isValid = true
        break
      end
    end
  elseif params.monster == target.data.staticData.id then
    isValid = true
  end
  if isValid then
    if stepType == QuestDataStepType.QuestDataStepType_COLLECT then
      local collectSkillId = GameConfig.NewRole.riskskill[1]
      Game.Myself:Client_UseSkill(collectSkillId, target, nil, nil, true)
    elseif stepType == QuestDataStepType.QuestDataStepType_VISIT then
      self:ExcuteDialogEvent(target, questData)
    end
  else
    errorLog("Visit Npc is illegal")
  end
end
function FunctionVisitNpc._SortQuest(a, b)
  local aPriority, bPriority = 1, 1
  if a.type ~= b.type then
    if a.scope == QuestDataScopeType.QuestDataScopeType_FUBEN then
      aPriority = 1
    elseif a.type == QuestDataType.QuestDataType_MAIN then
      aPriority = 2
    elseif a.type == QuestDataType.QuestDataType_WANTED then
      aPriority = 3
    elseif a.type == QuestDataType.QuestDataType_BRANCH then
      aPriority = 4
    else
      aPriority = 5
    end
    if b.scope == QuestDataScopeType.QuestDataScopeType_FUBEN then
      bPriority = 1
    elseif b.type == QuestDataType.QuestDataType_MAIN then
      bPriority = 2
    elseif b.type == QuestDataType.QuestDataType_WANTED then
      bPriority = 3
    elseif b.type == QuestDataType.QuestDataType_BRANCH then
      bPriority = 4
    else
      bPriority = 5
    end
  end
  if aPriority ~= bPriority then
    return aPriority < bPriority
  end
  return a.id < b.id
end
function FunctionVisitNpc:CheckNpcQuest(npcid, uniqueid)
  local triggerlsts, branchlsts = {}, {}
  local questlst = QuestProxy.Instance:getDialogQuestListByNpcId(npcid, uniqueid) or {}
  for i = 1, #questlst do
    local d = questlst[i]
    if (AutoTriggerQuestMap[d.type] or d.scope == QuestDataScopeType.QuestDataScopeType_FUBEN) and d.staticData.Params.ManualTrigger ~= 1 then
      table.insert(triggerlsts, d)
    end
    table.insert(branchlsts, d)
  end
  local triggerQuest
  if #triggerlsts == 1 then
    triggerQuest = triggerlsts[1]
  else
    local collectlst = QuestProxy.Instance:getCollectQuestListByNpcId(npcid)
    triggerQuest = collectlst and collectlst[1]
  end
  table.sort(branchlsts, FunctionVisitNpc._SortQuest)
  return triggerQuest, branchlsts
end
function FunctionVisitNpc._DialogEndCall(questId, optionid, isSuccess, scope)
  if isSuccess and questId then
    LogUtility.Info(string.format("NotifyQuestState: questId:%s optionId:%s ", tostring(questId), tostring(optionid)))
    QuestProxy.Instance:notifyQuestState(scope, questId, optionid)
  end
end
function FunctionVisitNpc:ExcuteDialogEvent(target, questData)
  local questParama = questData.staticData.Params
  local ifAccessFc = questParama.ifAccessFc
  local questId = questData.id
  if ifAccessFc then
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id)
    self:ExcuteDefaultDialog(target)
    return
  end
  local dialoglist = questParama.dialog or {}
  local viewdata = {
    viewname = "DialogView",
    dialoglist = dialoglist,
    dialognpcs = questParama.npc,
    npcinfo = target,
    camera = questParama.camera,
    wait = questParama.finish_wait,
    questId = questId,
    callback = FunctionVisitNpc._DialogEndCall,
    callbackData = questId,
    questScope = questData.scope
  }
  if type(viewdata.dialoglist) == "table" and #viewdata.dialoglist == 0 then
    FunctionVisitNpc._DialogEndCall(questId, nil, true, questData.scope)
  else
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  end
end
function FunctionVisitNpc:ExcuteDefaultDialog(target, events)
  target = target or self:GetTarget()
  if target then
    local npcData = target.data.staticData
    local npcfunc = npcData.NpcFunction
    if npcData.id == GameConfig.System.musicboxnpc then
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
        viewname = "SoundBoxView",
        npcInfo = target,
        viewdata = {isNpcFuncView = true}
      })
      return
    elseif npcData.id == 1200 then
      FunctionVisitNpc.VisitEndLessTower(target, events)
      return
    elseif npcfunc then
      for i = 1, #npcfunc do
        local single = npcfunc[i]
        if single.type then
          local funcCfg = Table_NpcFunction and Table_NpcFunction[single.type]
          if funcCfg and funcCfg.Type then
            local configFunc = FunctionVisitNpc.SNpcFuncMap[funcCfg.Type]
            if configFunc and configFunc(npcfunc, target, events) then
              return
            end
          end
        end
      end
    end
    local defaultDialogId = FunctionVisitNpc.GetDefaultDialog(target)
    if npcData.DefaultDialog == nil then
      return
    end
    local needRequireNpcFunc = npcData.NeedRequireNpcFunction
    if needRequireNpcFunc and needRequireNpcFunc == 1 then
      ServiceNUserProxy.Instance:CallRequireNpcFuncUserCmd(npcData.id)
    end
    local viewdata = {
      viewname = "DialogView",
      tasks = events,
      npcinfo = target,
      defaultDialogId = defaultDialogId
    }
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  else
    printRed("\230\137\190\228\184\141\229\136\176\232\175\165Npc \230\136\150\232\128\133 \232\175\165Npc\228\184\141\229\156\168\233\133\141\231\189\174\232\161\168\228\185\139\229\134\133")
  end
end
function FunctionVisitNpc.GetDefaultDialog(npc)
  if npc == nil then
    return
  end
  local npcData = npc.data.staticData
  local activity_defaultDlg = Activity_NpcDefaultDialog
  if activity_defaultDlg ~= nil then
    local cfg = activity_defaultDlg[npcData.id]
    if cfg then
      local choose_did, closeest_time
      for aid, dialogid in pairs(cfg) do
        local adata = FunctionActivity.Me():GetActivityData(aid)
        if adata ~= nil then
          if closeest_time == nil then
            closeest_time = adata.starttime
            choose_did = dialogid
          elseif closeest_time < adata.starttime then
            closeest_time = adata.starttime
            choose_did = dialogid
          end
        end
      end
      if choose_did ~= nil then
        return choose_did
      end
    end
  end
  local gameconfig_wedding = GameConfig.Wedding
  if gameconfig_wedding then
    local engage_Npc = gameconfig_wedding and gameconfig_wedding.Engage_Npc
    local weddingCememony_ID = gameconfig_wedding and gameconfig_wedding.Cememony_Npc
    if npcData.id == weddingCememony_ID then
      if WeddingProxy.Instance:IsSelfInWeddingTime() then
        return gameconfig_wedding.Cememony_Dialog
      end
    elseif npcData.id == engage_Npc then
      if WeddingProxy.Instance:IsSelfMarried() then
        return gameconfig_wedding.married
      elseif WeddingProxy.Instance:IsSelfEngage() then
        return gameconfig_wedding.engaged
      elseif WeddingProxy.Instance:IsSelfSingle() then
        return gameconfig_wedding.single
      end
    end
  end
  return npcData.DefaultDialog
end
autoImport("EndLessTowerCountDownInfo")
function FunctionVisitNpc.VisitEndLessTower(target, events)
  ServiceUserEventProxy.Instance:CallQueryResetTimeEventCmd(AERewardType.Tower)
  local midShowFuncParam
  local hideFunc = function(gameObject)
    midShowFuncParam:OnExit()
  end
  local midShowFunc = function(gameObject)
    local top = GameObjectUtil.Instance:DeepFind(gameObject, "Anchor_Top")
    midShowFuncParam = EndLessTowerCountDownInfo.new(top)
    midShowFuncParam:CreateSelf()
    midShowFuncParam:OnEnter()
    return hideFunc
  end
  local viewdata = {
    viewname = "DialogView",
    tasks = events,
    npcinfo = target,
    midShowFunc = midShowFunc,
    midShowFuncParam = midShowFuncParam
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
end
function FunctionVisitNpc:AddVisitRef()
  self.visitRef = self.visitRef + 1
  if self.visitRef == 1 then
    self:PreVisit()
  end
end
function FunctionVisitNpc:RemoveVisitRef()
  self.visitRef = self.visitRef - 1
  if self.visitRef == 0 then
    self:EndVisit()
  end
end
function FunctionVisitNpc:PreVisit()
  Game.Myself:Client_PauseIdleAI()
  FunctionSystem.WeakInterruptMyself(true)
  local lnpc = self:GetTarget()
  if lnpc and lnpc.data and lnpc.data.staticData then
    if lnpc.data.staticData.IsVeer == 1 then
      self:NpcTurnToMe(lnpc)
    end
    local visitVocal = lnpc.data.staticData.VisitVocal
    if visitVocal ~= "" then
      AudioUtil.PlayNpcVisitVocal(visitVocal)
    end
    local sceneUI = lnpc:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:ActiveQuestSymbolEffect(false)
    end
    if lnpc.data.staticData.id == 2160 then
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_Summer)
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_Autumn)
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_Charge)
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_CodeBW)
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_CodeMX)
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_MonthCard)
    elseif lnpc.data.staticData.id == 2186 then
      local activityData = FunctionActivity.Me():GetActivityData(ACTIVITYTYPE.EACTIVITYTYPE_READBAG)
      if activityData then
        ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_RedBag)
      end
    elseif lnpc.data.staticData.id == 4285 then
      ServiceSessionSocialityProxy.Instance:CallOperateQuerySocialCmd(SessionSociality_pb.EOperateType_Phone)
    elseif lnpc.data.staticData.id == 5668 then
      local tutorMatchStatus = TutorProxy.Instance:GetTutorMatStatus()
      local check = not tutorMatchStatus or _tutorMatchStatus.Stop == tutorMatchStatus or _tutorMatchStatus.Restart == tutorMatchStatus
      local isFindTutor = TutorProxy.Instance:CanAsStudent()
      if not check then
        if isFindTutor then
          MsgManager.ShowMsgByIDTable(25453, ZhString.Tutor_Title)
        else
          MsgManager.ShowMsgByIDTable(25453, ZhString.Tutor_Student)
        end
        return
      end
    end
  end
end
function FunctionVisitNpc:EndVisit()
  Game.Myself:Client_ResumeIdleAI()
  local lnpc = self:GetTarget()
  if lnpc and lnpc.data and lnpc.data.staticData then
    self:NpcTurnBack(lnpc)
    local endVocal = lnpc.data.staticData.EndVocal
    if endVocal ~= "" then
      AudioUtil.PlayNpcVisitVocal(endVocal)
    end
    local sceneUI = lnpc:GetSceneUI()
    if sceneUI then
      sceneUI.roleTopUI:ActiveQuestSymbolEffect(true)
    end
  end
  self:AccessTarget(nil)
end
function FunctionVisitNpc:NpcTurnToMe(lnpc)
  if lnpc then
    lnpc:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.LookAtCreature, Game.Myself.data.id)
    Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.LookAtCreature, lnpc.data.id)
  end
end
function FunctionVisitNpc:NpcTurnBack(lnpc)
  if lnpc == nil then
    return
  end
  local F_StayVisit = lnpc.data.GetFeature_StayVisitRot
  if F_StayVisit and F_StayVisit(lnpc.data) then
    return
  end
  local originalRotY = lnpc.originalRotation
  lnpc:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, originalRotY)
end
function FunctionVisitNpc.openWantedQuestPanel(wantedid, target)
  local isInWantedQuestActivity = QuestProxy.Instance:isInWantedQuestInActivity()
  if isInWantedQuestActivity then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AnnounceQuestActivityPanel,
      viewdata = {
        wanted = wantedid,
        npcTarget = target,
        isNpcFuncView = true
      }
    })
  else
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AnnounceQuestPanel,
      viewdata = {
        wanted = wantedid,
        npcTarget = target,
        isNpcFuncView = true
      }
    })
  end
end
FunctionVisitNpc.SNpcFuncMap = {}
function FunctionVisitNpc.SNpcFuncMap.seal(npcfunction, target)
  local funcID = 0
  for i = 1, #npcfunction do
    local type = npcfunction[i].type
    local funcData = type and Table_NpcFunction[type]
    if funcData.NameEn == "seal" then
      funcID = type
    end
  end
  if FunctionUnLockFunc.Me():CheckCanOpenByPanelId(funcID) then
    local viewdata = {
      viewname = "DialogView",
      dialoglist = {5},
      npcinfo = target,
      addconfig = npcfunction
    }
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
    return true
  end
  return false
end
function FunctionVisitNpc.SNpcFuncMap.Raid(npcfunction, target)
  local canOpen = FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.RaidInfoPopUp.id)
  if canOpen then
    local single = npcfunction[1]
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RaidInfoPopUp,
      viewdata = {
        raidid = single.param
      }
    })
    return true
  end
  return false
end
function FunctionVisitNpc.SNpcFuncMap.wanted(npcfunction, target)
  local canOpen = FunctionUnLockFunc.Me():CheckCanOpenByPanelId(PanelConfig.AnnounceQuestPanel.id)
  if canOpen then
    local questlst = QuestProxy.Instance:getDialogQuestListByNpcId(target.data.staticData.id, target.data.uniqueid)
    if questlst then
      local triggerQuest, triggerWanted
      for i = 1, #questlst do
        local d = questlst[i]
        if AutoTriggerQuestMap[d.type] then
          if d.type == QuestDataType.QuestDataType_WANTED then
            triggerWanted = d
          else
            triggerQuest = d
          end
        end
      end
      triggerQuest = triggerQuest or triggerWanted
      if triggerQuest then
        local finishJump = triggerQuest.staticData.FinishJump
        QuestProxy.Instance:notifyQuestState(triggerQuest.scope, triggerQuest.id, finishJump)
      end
    end
    local wantedid = npcfunction[1] and npcfunction[1].param
    FunctionVisitNpc.openWantedQuestPanel(wantedid, target)
  else
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {viewname = "DialogView", npcinfo = target})
  end
  return true
end
function FunctionVisitNpc.SNpcFuncMap.GuildBuildingSubmit(npcfunction, target)
  local typeID = npcfunction[1] and npcfunction[1].param
  if typeID then
    local buildingData = GuildBuildingProxy.Instance:GetCurBuilding(typeID)
    if buildingData then
      if buildingData.isbuilding and 0 == buildingData.level then
        GuildBuildingProxy.Instance:InitBuilding(target, typeID)
        GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
          viewname = "GuildBuildingMatSubmitView",
          npcinfo = target
        })
        return true
      else
        return false
      end
    else
      return false
    end
  end
end
function FunctionVisitNpc.SNpcFuncMap.Guild(npcfunction, target)
  FunctionGuild.Me():ShowGuildDialog(target)
  return true
end
function FunctionVisitNpc.SNpcFuncMap.Common_GuildRaid(npcfunction, target)
  FunctionGuild.Me():ShowGuildRaidDialog(target)
  return true
end
function FunctionVisitNpc.SNpcFuncMap.ShakeTree(npcfunction, target)
  FunctionShakeTree.Me():TryShakeTree(target)
  return true
end
function FunctionVisitNpc.SNpcFuncMap.ChangeLine(npcfunction, target)
  ServiceNUserProxy.Instance:CallQueryZoneStatusUserCmd()
  local ChangeLine = {
    event = function(npcinfo)
      FunctionNpcFunc.JumpPanel(PanelConfig.ChangeZoneView, npcinfo)
    end,
    closeDialog = true,
    NameZh = ZhString.ChangeZone_ChangeLine
  }
  local BackGuildLine = {
    event = function(npcinfo)
      if GuildProxy.Instance:IHaveGuild() then
        local zoneid = GuildProxy.Instance.myGuildData.zoneid
        ServiceNUserProxy.Instance:CallJumpZoneUserCmd(npcinfo.data.id, zoneid)
      end
    end,
    closeDialog = true,
    NameZh = ZhString.ChangeZone_BackGuildLine
  }
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {1312545},
    npcinfo = target,
    addfunc = {ChangeLine}
  }
  if GuildProxy.Instance:IHaveGuild() and MyselfProxy.Instance:GetZoneId() ~= GuildProxy.Instance.myGuildData.zoneid then
    viewdata.addfunc[#viewdata.addfunc + 1] = BackGuildLine
  end
  FunctionNpcFunc.ShowUI(viewdata)
  return true
end
function FunctionVisitNpc.SNpcFuncMap.EquipReplace(npcfunction, target)
  FunctionSecurity.Me():HoleEquip(function()
    FunctionDialogEvent.SetDialogEventEnter(DialogEventType.EquipReplace, target)
  end)
  return true
end
function FunctionVisitNpc.SNpcFuncMap.EquipUpgrade(npcfunction, target)
  FunctionSecurity.Me():LevelUpEquip(function()
    FunctionDialogEvent.SetDialogEventEnter(DialogEventType.EquipUpgrade, target)
  end)
  return true
end
function FunctionVisitNpc.UpdateAuctionDialog(npcid)
  local time = AuctionProxy.Instance:GetAuctionTime() or 0
  local nowtime = ServerTime.CurServerTime() / 1000
  if time < nowtime then
    local npcData = Table_Npc[npcid]
    local defaultDialogId = npcData.DefaultDialog or 417
    return true, DialogUtil.GetDialogData(defaultDialogId).Text
  end
  local timeInfo = os.date("*t", time)
  local nowInfo = os.date("*t", nowtime)
  local openText = ""
  local count = 0
  if timeInfo.month > nowInfo.month then
    count = count + 1
    openText = timeInfo.month .. ZhString.FunctionVisitNpc_AuctionDialog_Month
  end
  count = count + 1
  openText = openText .. timeInfo.day .. ZhString.FunctionVisitNpc_AuctionDialog_Day
  if count < 2 then
    openText = openText .. timeInfo.hour .. ZhString.FunctionVisitNpc_AuctionDialog_Hour
  end
  return false, string.format(ZhString.FunctionVisitNpc_AuctionDialog_OpenTip, openText)
end
function FunctionVisitNpc.SNpcFuncMap.Auction(npcfunction, target, events)
  for k, v in pairs(npcfunction) do
    helplog(k, v)
  end
  local viewdata = {
    viewname = "DialogView",
    tasks = events,
    npcinfo = target
  }
  GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  GameFacade.Instance:sendNotification(DialogEvent.AddUpdateSetTextCall, {
    FunctionVisitNpc.UpdateAuctionDialog,
    target.data.staticData.id
  })
  return true
end
function FunctionVisitNpc:callNextBossStep()
  local bossStepQuest = QuestProxy.Instance.worldbossQuest
  if bossStepQuest.dialog_select and bossStepQuest.dialog_select == 1 then
    ServiceBossCmdProxy.Instance:CallStepSyncBossCmd(nil)
  end
  return
end
