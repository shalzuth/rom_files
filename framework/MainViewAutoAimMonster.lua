autoImport("MainViewAimMonsterCell")
MainViewAutoAimMonster = class("MainViewAutoAimMonster", SubView)
local noSweepBgHeight = 426
local sweepBgHeight = 466
function MainViewAutoAimMonster:Init()
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvt()
  self:InitShow()
end
function MainViewAutoAimMonster:FindObj()
  local BeforePanel = self:FindGO("BeforePanel")
  local Anchor_DownRight = self:FindGO("Anchor_DownRight", BeforePanel)
  self.autoAimMonster = self:LoadPreferb("view/MainViewAutoAimMonster", Anchor_DownRight, true)
  self.autoFightBtn = self:FindGO("AutoBattleButton")
  self.autoFight = self:FindGO("Auto", self.autoFightBtn)
  self.autoAim = self:FindGO("AutoAim", self.autoFightBtn)
  self.autoBattleBtnSps = self:FindComponent("AutoBattleBg", UISprite, self.autoFightBtn)
  self.autoFightTip = self:FindComponent("Label", UILabel, self.autoFightBtn)
  self.protectToggle = self:FindGO("ProtectToggle"):GetComponent(UIToggle)
  self.stayToggle = self:FindGO("StayToggle"):GetComponent(UIToggle)
  self.sweepBtn = self:FindGO("SweepBtn")
  self.sweepCheckmark = self:FindGO("Checkmark", self.sweepBtn)
  self.bg = self:FindGO("Bg", self.autoAimMonster):GetComponent(UISprite)
end
function MainViewAutoAimMonster:AddButtonEvt()
  local closeButton = self:FindGO("CloseButton", self.autoAimMonster)
  self:AddClickEvent(closeButton, function(go)
    self:SelfClose()
  end)
  self.closecomp = self.autoAimMonster:GetComponent(CloseWhenClickOtherPlace)
  function self.closecomp.callBack(go)
    self:SelfClose()
  end
  self:AddClickEvent(self.autoFightBtn, function()
    local myself = Game.Myself
    local isHanding, handowner = myself:IsHandInHand()
    local isAuto = Game.AutoBattleManager.on
    if not isHanding or handowner == true then
      if isAuto then
        self.isSweep = false
        Game.AutoBattleManager:AutoBattleOff()
        Game.Myself:Client_SetAutoEndlessTowerSweep(self.isSweep)
      elseif myself:Client_GetFollowLeaderID() ~= 0 then
        Game.AutoBattleManager:AutoBattleOn()
      else
        self:SetBubbleTipActive(not state)
        if SkillProxy.Instance:HasLearnedSkill(GameConfig.AutoAimMonster.SkillId) then
          self:ShowView(true)
        end
      end
    end
  end)
  self:AddClickEvent(self.sweepBtn, function()
    if Game.Myself:Client_GetFollowLeaderID() ~= 0 then
      MsgManager.ShowMsgByID(3433)
      return
    end
    self.isSweep = not self.isSweep
    self:UpdateSweepCheckmark(self.isSweep)
    if self.isSweep then
      self:SelfClose()
    end
  end)
  self:AddClickEvent(self.stayToggle.gameObject, function(go)
    Game.Myself:Client_SetAutoBattleStanding(self.stayToggle.value)
  end)
end
function MainViewAutoAimMonster:AddViewEvt()
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.UpdateInfo)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.UpdateInfo)
  self:AddDispatcherEvt(AutoBattleManagerEvent.StateChanged, self.UpdateAutoBattle)
  self:AddListenEvt(GuideEvent.ShowAutoFightBubble, self.HandleGuideBubbleTip)
  self:AddListenEvt(SkillEvent.SkillUpdate, self.UpdateSkill)
end
function MainViewAutoAimMonster:InitShow()
  self.isShowSweep = nil
  self.isSweep = false
  local container = self:FindGO("Container")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 10,
    cellName = "MainViewAimMonsterCell",
    control = MainViewAimMonsterCell,
    dir = 1
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.itemWrapHelper:AddEventListener(MainViewAimMonsterCellEvent.ValueChange, self.HandleValueChange, self)
  EventManager.Me():AddEventListener(MainViewAimMonsterCellEvent.BossCellHasSet, self.HandleBossCellHasSet, self)
  self:UpdateAutoBattle()
  local isProtect, isStay = false, false
  self.save_str = LocalSaveProxy.Instance:GetMainViewAutoAimMonster()
  local history = string.split(self.save_str, "_")
  if #history == 2 then
    isProtect = history[1]
  end
  self.protectToggle.value = tonumber(isProtect) == 1
  self.stayToggle.value = tonumber(isStay) == 1
  self:UpdateSkill()
  self:ShowView(false)
end
function MainViewAutoAimMonster:HandleValueChange(param)
  local cell, value = param[1], param[2]
end
function MainViewAutoAimMonster:HandleBossCellHasSet(param)
  if self:IsShowView() and not AAAManager.Me():IsCmiOn() then
    AAAManager.Me():StartCmi()
  end
end
function MainViewAutoAimMonster:OnExit()
  EventManager.Me():RemoveEventListener(MainViewAimMonsterCellEvent.BossCellHasSet, self.HandleBossCellHasSet, self)
  MainViewAutoAimMonster.super.OnExit(self)
end
local infoList = {}
local mvpMiniIndexMap = {}
function MainViewAutoAimMonster:UpdateInfo()
  if not self:IsShowView() then
    return
  end
  local functionMonster = FunctionMonster.Me()
  local _, hasMvpOrMini = functionMonster:FilterMonsterStaticInfo()
  if not hasMvpOrMini then
    AAAManager.Me():ClearCmi()
  end
  TableUtility.ArrayClear(infoList)
  TableUtility.ArrayShallowCopy(infoList, functionMonster:SortMonsterStaticInfo())
  if not next(mvpMiniIndexMap) then
    self:ShuffleMvpMini(infoList)
  else
    self:MaintainMvpMiniIndex(infoList)
  end
  local all = AutoAimMonsterData.new()
  all:SetId(0)
  TableUtility.ArrayPushFront(infoList, all)
  self.itemWrapHelper:UpdateInfo(infoList)
  if #infoList <= 5 then
    self.itemWrapHelper:ResetPosition()
  end
  self:UpdateAutoBattle()
  local cellCtls = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cellCtls do
    local id = cellCtls[i].data and cellCtls[i].data:GetId() or 0
    if self.currentIds and self.currentIds[id] then
      cellCtls[i]:SetChoose(true)
    else
      cellCtls[i]:SetChoose(false)
    end
  end
  self:UpdateSweep()
  self:UpdateSweepCheckmark(self.isSweep)
end
function MainViewAutoAimMonster:HandleClickItem(cellctl)
  if cellctl.data then
    local currentId = cellctl.data:GetId()
    if currentId == 0 then
      Game.AutoBattleManager:AutoBattleOn()
      if not SkillProxy.Instance:HasAttackSkill(SkillProxy.Instance.equipedAutoSkills) then
        MsgManager.DontAgainConfirmMsgByID(1712)
      end
      self:SelfClose()
    else
      local myself = Game.Myself
      local value = cellctl:GetChooseValue()
      if value then
        myself:Client_UnSetAutoBattleLockID(currentId)
      elseif myself:Client_GetFollowLeaderID() ~= 0 then
        MsgManager.ShowMsgByID(1713)
      else
        MsgManager.FloatMsg(nil, string.format(ZhString.AutoAimMonster_Tip, cellctl.name.text))
        myself:Client_SetAutoBattleLockID(currentId)
        myself:Client_SetAutoBattle(true)
      end
      cellctl:SetChoose(not value)
      local monster = Table_Monster[currentId]
      if monster and (monster.Type == "MVP" or monster.Type == "MINI") then
        AAAManager.Me():Rcmc()
      end
    end
    Game.Myself:Client_SetAutoBattleProtectTeam(self.protectToggle.value)
    Game.Myself:Client_SetAutoBattleStanding(self.stayToggle.value)
  end
end
function MainViewAutoAimMonster:ShowView(isShow)
  self.autoAimMonster:SetActive(isShow)
  if isShow then
    self:UpdateInfo()
  else
    AAAManager.Me():ClearCmi()
    TableUtility.TableClear(mvpMiniIndexMap)
  end
end
function MainViewAutoAimMonster:OffAutoAim()
  self.currentIds = nil
end
function MainViewAutoAimMonster:IsShowView()
  return self.autoAimMonster.activeSelf
end
function MainViewAutoAimMonster:SelfClose()
  self:ShowView(false)
  if self.currentIds and next(self.currentIds) then
    for currentId, _ in pairs(self.currentIds) do
      self:NotifyGuideQuestState(currentId)
    end
  end
  self:SetBubbleTipActive(true)
  local protect, stay
  if self.protectToggle.value then
    protect = 1
  else
    protect = 0
  end
  if self.stayToggle.value then
    stay = 1
  else
    stay = 0
  end
  local str = protect .. "_" .. stay
  if str ~= self.save_str then
    LocalSaveProxy.Instance:SetMainViewAutoAimMonster(str)
  end
  if self.isShowSweep then
    local _Myself = Game.Myself
    if _Myself:Client_GetFollowLeaderID() == 0 and self.isSweep ~= _Myself:Client_GetAutoEndlessTowerSweep() then
      local _AutoBattleManager = Game.AutoBattleManager
      if self.isSweep then
        _AutoBattleManager:AutoBattleOn()
      else
        _AutoBattleManager:AutoBattleOff()
      end
      _Myself:Client_SetAutoEndlessTowerSweep(self.isSweep)
    end
  end
end
function MainViewAutoAimMonster:UpdateSkill()
  self.protectToggle.gameObject:SetActive(SkillProxy.Instance:HasLearnedSkill(GameConfig.AutoAimMonster.ProtectSkillId))
  self.stayToggle.gameObject:SetActive(SkillProxy.Instance:HasLearnedSkill(GameConfig.AutoAimMonster.UnmovableSkillId))
end
function MainViewAutoAimMonster:NotifyGuideQuestState(selectId)
  local questList = QuestProxy.Instance:getLockMonsterGuideByMonsterId(selectId)
  if not questList then
    return
  end
  for i = 1, #questList do
    QuestProxy.Instance:notifyQuestState(nil, questList[i])
  end
end
function MainViewAutoAimMonster:UpdateAutoBattle(note)
  local isAuto = Game.AutoBattleManager.on
  if isAuto then
    local lockids = Game.Myself:Client_GetAutoBattleLockIDs()
    if not next(lockids) then
      self:ShowAuto(isAuto, not isAuto)
    else
      self:ShowAuto(not isAuto, isAuto)
    end
    self.currentIds = lockids
  else
    self:ShowAuto(isAuto, isAuto)
    self:OffAutoAim()
    self.currentIds = nil
  end
  self.autoFightTip.text = isAuto and ZhString.MainViewInfoPage_Cancel or ZhString.MainViewInfoPage_Auto
end
function MainViewAutoAimMonster:ShowAuto(isAutoFight, isAutoAim)
  self.autoFight:SetActive(isAutoFight)
  self.autoAim:SetActive(isAutoAim)
end
function MainViewAutoAimMonster:TryAutoBattleOn()
  Game.AutoBattleManager:AutoBattleOn()
  if not SkillProxy.Instance:HasAttackSkill(SkillProxy.Instance.equipedAutoSkills) then
    MsgManager.DontAgainConfirmMsgByID(1712)
  end
end
local anchorOffset = {0, 40}
function MainViewAutoAimMonster:HandleGuideBubbleTip(note)
  local data = note.body
  if data then
    if data.isShow then
      if self.bubbleTip == nil then
        self.bubbleTip = TipManager.Instance:ShowBubbleTipById(data.bubbleId, self.autoBattleBtnSps, NGUIUtil.AnchorSide.Left, anchorOffset)
        self.bubbleTip:ActiveCloseButton(false)
      end
    elseif self.bubbleTip then
      self.bubbleTip:CloseSelf()
      self.bubbleTip = nil
    end
  end
end
function MainViewAutoAimMonster:SetBubbleTipActive(b)
  if self.bubbleTip then
    self.bubbleTip:SetActive(b)
  end
end
function MainViewAutoAimMonster:UpdateSweep()
  local isShow = Game.MapManager:IsEndlessTower()
  self.isSweep = isShow
  if isShow == self.isShowSweep then
    return
  end
  self.isShowSweep = isShow
  self.sweepBtn:SetActive(isShow)
  if isShow then
    self.bg.height = sweepBgHeight
  else
    self.bg.height = noSweepBgHeight
  end
end
function MainViewAutoAimMonster:UpdateSweepCheckmark(isShow)
  self.sweepCheckmark:SetActive(isShow)
end
function MainViewAutoAimMonster:IsMonsterMvpOrMini(monsterId)
  local monster = Table_Monster[monsterId]
  return monster and (monster.Type == "MVP" or monster.Type == "MINI")
end
function MainViewAutoAimMonster:MaintainMvpMiniIndex(infoList)
  local firstPageItemCount = math.min(#infoList, 4)
  local newIndex, mvpMiniData, insertIndex
  for mvpMiniId, mvpMiniIndex in pairs(mvpMiniIndexMap) do
    newIndex = -1
    for i = 1, firstPageItemCount do
      if mvpMiniId == infoList[i]:GetId() then
        newIndex = i
        break
      end
    end
    if newIndex > 0 then
      insertIndex = math.min(mvpMiniIndex, #infoList)
      if insertIndex ~= newIndex then
        mvpMiniData = infoList[newIndex]
        table.remove(infoList, newIndex)
        if insertIndex <= #infoList then
          table.insert(infoList, insertIndex, mvpMiniData)
        else
          table.insert(infoList, mvpMiniData)
          insertIndex = #infoList
        end
      end
    end
  end
  for i = 1, firstPageItemCount do
    local id = infoList[i]:GetId()
    if self:IsMonsterMvpOrMini(id) then
      mvpMiniIndexMap[id] = i
    end
  end
end
function MainViewAutoAimMonster:ShuffleMvpMini(infoList)
  local mvpMiniCount = 0
  local firstPageItemCount = math.min(#infoList, 4)
  for i = 1, firstPageItemCount do
    if self:IsMonsterMvpOrMini(infoList[i]:GetId()) then
      mvpMiniCount = mvpMiniCount + 1
    end
  end
  for i = 1, mvpMiniCount do
    local insertHeadIndex = mvpMiniCount + 1 - i
    if not (firstPageItemCount < insertHeadIndex) then
      local j = math.random(insertHeadIndex, firstPageItemCount)
      local mvpTemp = infoList[1]
      for k = 1, j - 1 do
        infoList[k] = infoList[k + 1]
      end
      infoList[j] = mvpTemp
    end
  end
  for i = 1, firstPageItemCount do
    local id = infoList[i]:GetId()
    if self:IsMonsterMvpOrMini(id) then
      mvpMiniIndexMap[id] = i
    end
  end
  return infoList
end
