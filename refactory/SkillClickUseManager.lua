SkillClickUseManager = class("SkillClickUseManager")
local SkillInterval = 1000
local SkillUse_Opportunity_Cannot = 0
local SkillUse_Opportunity_Now = 1
local SkillUse_Opportunity_WaitForNext = 2
local SkillWaitForUse = class("SkillWaitForUse")
function SkillWaitForUse:ctor()
  self.pointPos = LuaVector3()
  self.weakHoldData = {}
  setmetatable(self.weakHoldData, {__mode = "v"})
end
function SkillWaitForUse:SetSkillItemData(skillItemData, pos)
  self.weakHoldData[1] = skillItemData
  self:SetData(skillItemData.id, skillItemData:GetID(), skillItemData:GetPosInShortCutGroup(ShortCutProxy.ShortCutEnum.ID1))
end
function SkillWaitForUse:SetData(skillIDandLevel, launchSkillID, pos)
  self.skillIDandLevel = skillIDandLevel
  self.launchSkillID = launchSkillID
  self.pos = pos
  self.isPointPosType = false
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(launchSkillID)
  if skillInfo then
    local skillTargetType = skillInfo:GetTargetType()
    if skillTargetType == SkillTargetType.Point then
      self.isPointPosType = true
    end
  end
end
function SkillWaitForUse:SetSkillPointPos(pos)
  if pos then
    self.pointPos[1], self.pointPos[2], self.pointPos[3] = pos[1], pos[2], pos[3]
  end
end
function SkillWaitForUse:IsNull()
  return self.skillIDandLevel == nil
end
function SkillWaitForUse:Cancel()
  self.skillIDandLevel = nil
  self.weakHoldData[1] = nil
end
function SkillWaitForUse:GetSkillData()
  return self.weakHoldData[1]
end
function SkillWaitForUse:IsEqual(skillItemData)
  if skillItemData.id == self.skillIDandLevel and skillItemData:GetID() == self.launchSkillID and self.pos == skillItemData:GetPosInShortCutGroup(ShortCutProxy.ShortCutEnum.ID1) then
    return true
  end
  return false
end
function SkillClickUseManager:ctor()
  self._waitForUse = SkillWaitForUse.new()
  self._preWaitForUse = SkillWaitForUse.new()
  self.currentSelectPhaseSkillID = 0
  EventManager.Me():AddEventListener(FunctionSkillTargetPointLauncherEvent.StateChanged, self.HandlePhaseSkillEffect, self)
end
function SkillClickUseManager:GetNextUseSkillID()
  return self._waitForUse.skillIDandLevel
end
function SkillClickUseManager:Launch()
  if self.running then
    return
  end
  self.running = true
  EventManager.Me():AddEventListener(LoadSceneEvent.BeginLoadScene, self.OnSceneBeginChanged, self)
  EventManager.Me():AddEventListener(MyselfEvent.TransformChange, self.OnTransformChangeHandler, self)
  EventManager.Me():AddEventListener(SkillEvent.SkillUpdate, self.OnSkillUpdateHandler, self)
end
function SkillClickUseManager:ShutDown()
  if not self.running then
    return
  end
  self.running = false
  EventManager.Me():RemoveEventListener(LoadSceneEvent.BeginLoadScene, self.OnSceneBeginChanged, self)
  EventManager.Me():RemoveEventListener(MyselfEvent.TransformChange, self.OnTransformChangeHandler, self)
  EventManager.Me():RemoveEventListener(SkillEvent.SkillUpdate, self.OnSkillUpdateHandler, self)
  self:_CancelWaitForUse()
end
function SkillClickUseManager:OnTransformChangeHandler()
  self:_CancelWaitForUse()
end
function SkillClickUseManager:OnSkillUpdateHandler()
  if self._waitForUse:IsNull() then
    return
  end
  local skillItemData = SkillProxy.Instance:GetEquipedSkillByGuid(self._waitForUse.skillIDandLevel, false)
  if skillItemData then
    if not self._waitForUse:IsEqual(skillItemData) then
      self:_CancelWaitForUse()
    end
  else
    self:_CancelWaitForUse()
  end
end
function SkillClickUseManager:OnSceneBeginChanged()
  self:_CancelWaitForUse()
end
function SkillClickUseManager:_CancelWaitForUse()
  if self._preWaitForUse:IsNull() == false then
    self._preWaitForUse:Cancel()
  end
  if self._waitForUse:IsNull() then
    return
  end
  self._waitForUse:Cancel()
  GameFacade.Instance:sendNotification(SkillEvent.SkillCancelWaitNextUse)
end
function SkillClickUseManager:_ChangeWaitForUse(skillItemData, pointPos)
  self._waitForUse:SetSkillItemData(skillItemData)
  self._waitForUse:SetSkillPointPos(pointPos)
  GameFacade.Instance:sendNotification(SkillEvent.SkillWaitNextUse, skillItemData.id)
end
function SkillClickUseManager:ClickSkill(shortcutSkillCell)
  local id = shortcutSkillCell.data:GetID()
  if id ~= 0 then
    self:_TryAutoOption(id)
    local opportunity
    if FunctionSkill.Me().isCasting then
      opportunity = SkillUse_Opportunity_WaitForNext
    else
      opportunity = self:_SkillUseOpportunity(shortcutSkillCell.data)
    end
    if opportunity == SkillUse_Opportunity_Now then
      self:_CancelWaitForUse()
      if self.currentSelectPhaseSkillID == id then
        GameFacade.Instance:sendNotification(MyselfEvent.CancelAskUseSkill, id)
      else
        GameFacade.Instance:sendNotification(MyselfEvent.AskUseSkill, id)
      end
    elseif self.running then
      if self._waitForUse:IsEqual(shortcutSkillCell.data) then
        self:_CancelWaitForUse()
      else
        if not shortcutSkillCell.data.fitPreCondion then
          FunctionSkillEnableCheck.Me():MsgNotFit(shortcutSkillCell.data)
        end
        local skillInfo = Game.LogicManager_Skill:GetSkillInfo(id)
        if skillInfo then
          local skillTargetType = skillInfo:GetTargetType()
          if skillTargetType == SkillTargetType.Point then
            self._preWaitForUse:SetSkillItemData(shortcutSkillCell.data)
            FunctionSkillTargetPointLauncher.Me():Shutdown()
            FunctionSkillTargetPointLauncher.Me():Launch(id)
          else
            self:_ChangeWaitForUse(shortcutSkillCell.data)
          end
        end
      end
    end
  else
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CharactorProfessSkill
    })
  end
end
function SkillClickUseManager:_SkillUseOpportunity(skillItemData)
  if skillItemData ~= nil then
    if not skillItemData.shadow then
      if not SkillProxy.Instance:SkillCanBeUsed(skillItemData) then
        return SkillUse_Opportunity_WaitForNext
      else
        if Game.Myself.data:GetAttackSkillIDAndLevel() ~= skillItemData.staticData.id then
          local timeStamp = CDProxy.Instance:GetTimeStampMapById(CDProxy.CommunalSkillCDSortID)
          if timeStamp ~= nil and ServerTime.ServerTime - timeStamp <= SkillInterval then
            return SkillUse_Opportunity_WaitForNext
          end
        end
        return SkillUse_Opportunity_Now
      end
    end
    return SkillUse_Opportunity_Cannot
  end
  return SkillUse_Opportunity_Cannot
end
function SkillClickUseManager:HandlePhaseSkillEffect(evt)
  local funcSkill = FunctionSkillTargetPointLauncher.Me()
  local skill = funcSkill.skillIDAndLevel
  if funcSkill.running then
    self.currentSelectPhaseSkillID = skill
  elseif not skill or skill == self.currentSelectPhaseSkillID then
    self.currentSelectPhaseSkillID = 0
  end
  GameFacade.Instance:sendNotification(SkillEvent.SkillSelectPhaseStateChange)
end
function SkillClickUseManager:TryLaunchPointTargetTypeSkill(skillIDAndLevel, point)
  if self._preWaitForUse:IsNull() then
    Game.Myself:Client_UseSkill(skillIDAndLevel, nil, point)
  elseif self._preWaitForUse.launchSkillID == skillIDAndLevel then
    self:_ChangeWaitForUse(self._preWaitForUse:GetSkillData(), point)
    self._preWaitForUse:Cancel()
  end
end
function SkillClickUseManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  if self._waitForUse:IsNull() == false and not FunctionSkill.Me().isCasting then
    local skillItemData = self._waitForUse:GetSkillData()
    if skillItemData then
      if self:_SkillUseOpportunity(skillItemData) == SkillUse_Opportunity_Now then
        local id = self._waitForUse.launchSkillID
        local skillInfo = Game.LogicManager_Skill:GetSkillInfo(id)
        if skillInfo then
          local skillTargetType = skillInfo:GetTargetType()
          if skillTargetType == SkillTargetType.Point then
            Game.Myself:Client_UseSkill(id, nil, self._waitForUse.pointPos)
          else
            GameFacade.Instance:sendNotification(MyselfEvent.AskUseSkill, id)
          end
        end
        self:_CancelWaitForUse()
      end
    else
      self:_CancelWaitForUse()
    end
  end
end
function SkillClickUseManager:_TryInitAutoOption()
  if self.autoOptionMap == nil then
    self.autoOptionMap = {}
    local autoOptionID = GameConfig.SkillAutoOptionID
    local staticData, skill, autoOptionSkill
    for i = 1, #autoOptionID do
      staticData = Table_Skill[autoOptionID[i]]
      if staticData ~= nil then
        skill = staticData.Logic_Param.skill_opt_ids
        if skill ~= nil then
          for j = 1, #skill do
            autoOptionSkill = self.autoOptionMap[skill[j]]
            if autoOptionSkill == nil then
              autoOptionSkill = {}
              self.autoOptionMap[skill[j]] = autoOptionSkill
            end
            autoOptionSkill[#autoOptionSkill + 1] = autoOptionID[i]
          end
        end
      end
    end
  end
end
function SkillClickUseManager:_TryAutoOption(id)
  self:_TryInitAutoOption()
  local sortID = math.floor(id / 1000)
  local autoOptionID = self.autoOptionMap[sortID]
  if autoOptionID ~= nil then
    for i = 1, #autoOptionID do
      local staticData = Table_Skill[autoOptionID[i]]
      if staticData ~= nil then
        local optionType = staticData.Logic_Param.skill_opt_type
        if optionType ~= nil then
          local _SkillOptionManager = Game.SkillOptionManager
          if _SkillOptionManager:GetSkillOption(optionType) ~= sortID then
            _SkillOptionManager:SetSkillOption(optionType, sortID)
          end
        end
      end
    end
  end
end
