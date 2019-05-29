autoImport("ShortCutSkill")
autoImport("UIGridListCtrl")
MainViewSkillPage = class("MainViewSkillPage", SubView)
local SceneSeatSkillID = 50031001
function MainViewSkillPage:Init()
  FunctionCDCommand.Me():StartCDProxy(ShotCutSkillCDRefresher, 16)
  self.touchBoard = self:FindChild("TouchCollider"):GetComponent(UIWidget)
  self.skillGrid = self:FindChild("SkillBord")
  self.skillGrid = self:FindChild("SkillGrid", self.skillGrid):GetComponent(UIGridActiveSelf)
  self.currentSelectPhaseSkillID = 0
  self.phaseSkillEffect = self:FindChild("PhaseSkillSelectEffect")
  self.skillShotCutList = UIGridListCtrl.new(self.skillGrid, ShortCutSkill, "ShortCutSkill")
  self.skillShotCutList:SetAddCellHandler(self.AddShortCutCellHandler, self)
  self.cancelTransformBtn = self:FindChild("cancelTransformBtn")
  self.skillShotCutList:AddEventListener(MouseEvent.MouseClick, self.ClickSkillHandler, self)
  self:InitSwitchShortCut()
  self.shortcutSwitchIndex = 1
  self:SwitchShortCutTo(ShortCutProxy.SwitchList[self.shortcutSwitchIndex])
  self:AddViewEvts()
end
function MainViewSkillPage:InitSwitchShortCut()
  self.skillShortCutAnchor = self:FindChild("SwtichContainer"):GetComponent(UIWidget)
  self.skillShortCutSwitchIcon = self:FindChild("SwitchIcon"):GetComponent(UIMultiSprite)
  self.skillShortCutSwtichBtn = self:FindChild("SkillShortCutSwitch")
  self:AddButtonEvent("SkillShortCutSwitch", function()
    self:TryGetNextSwitchID()
    self:SwitchShortCutTo(self.shortcutSwitchID)
  end)
  self:AddButtonEvent("cancelTransformBtn", function()
    MsgManager.ConfirmMsgByID(924, function()
      self:callCancelTransformState()
    end, nil, nil)
  end)
end
function MainViewSkillPage:TryGetNextSwitchID(gap)
  gap = gap or 1
  local max_index = #ShortCutProxy.SwitchList
  self.shortcutSwitchIndex = self.shortcutSwitchIndex + gap
  if max_index < self.shortcutSwitchIndex then
    self.shortcutSwitchIndex = self.shortcutSwitchIndex % max_index
  end
  local id = ShortCutProxy.SwitchList[self.shortcutSwitchIndex]
  local funcEnable = ShortCutProxy.Instance:ShortCutListIsEnable(id)
  local isEmpty = SkillProxy.Instance:IsEquipedSkillEmpty(id)
  if funcEnable and not isEmpty then
    self.shortcutSwitchID = id
  else
    self:TryGetNextSwitchID(gap)
  end
end
function MainViewSkillPage:callCancelTransformState()
  ServiceUserEventProxy.Instance:CallDelTransformUserEvent()
end
function MainViewSkillPage:SwitchShortCutTo(id)
  if id ~= nil then
    self.shortcutSwitchID = id
    self.skillShortCutSwitchIcon.CurrentState = self.shortcutSwitchIndex - 1
    helplog(id, self.shortcutSwitchIndex, self.skillShortCutSwitchIcon.CurrentState)
    self:UpdateSkills()
    local skillID = Game.SkillClickUseManager:GetNextUseSkillID()
    local cell = self:GetCell(skillID)
    if cell then
      self:_ShowWaitNextUseEffect(cell)
    else
      self:CancelWaitNextUseHandler()
    end
  end
end
function MainViewSkillPage:HandleShortCutSwitchActive(note)
  local funcEnable = false
  local isEmpty = true
  local _ShortCutEnum = ShortCutProxy.ShortCutEnum
  local _ShortCutProxy = ShortCutProxy.Instance
  local _SkillProxy = SkillProxy.Instance
  local ID1 = _ShortCutEnum.ID1
  for k, v in pairs(_ShortCutEnum) do
    if v ~= ID1 then
      if _ShortCutProxy:ShortCutListIsEnable(v) then
        funcEnable = true
      end
      if not _SkillProxy:IsEquipedSkillEmpty(v) then
        isEmpty = false
      end
    end
    if not funcEnable or isEmpty then
    end
  end
  if (not funcEnable or isEmpty) and self.shortcutSwitchID ~= ID1 then
    self.shortcutSwitchIndex = 1
    self:SwitchShortCutTo(ID1)
  end
  local transformSkills = _SkillProxy:GetTransformedSkills()
  local transformed = Game.Myself.data:IsTransformed()
  if not funcEnable or isEmpty or transformed and transformSkills ~= nil then
    self:SetActive(self.skillShortCutSwtichBtn, false)
  else
    self:SetActive(self.skillShortCutSwtichBtn, true)
  end
end
function MainViewSkillPage:AddShortCutCellHandler(cell)
  cell.container = self.skillGrid
end
function MainViewSkillPage:ClickSkillHandler(obj)
  local id = obj.data.data:GetID()
  if id ~= 0 then
    if self.currentSelectPhaseSkillID == id then
      self:sendNotification(MyselfEvent.CancelAskUseSkill, id)
    else
      self:sendNotification(MyselfEvent.AskUseSkill, id)
    end
  elseif not ApplicationInfo.IsRunOnWindowns() then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CharactorProfessSkill
    })
  end
end
function MainViewSkillPage:KeyBoardUseSkillHandler(key)
  local index = key
  local cells = self.skillShotCutList:GetCells()
  if index > 0 and index <= #cells then
    local cell = cells[index]
    if cell and cell:CanUseSkill() then
      local hpEnough = SkillProxy.Instance:HasEnoughHp(cell.data:GetID())
      if cell.data.fitPreCondion and hpEnough then
        self:ClickSkillHandler({data = cell})
      else
        FunctionSkillEnableCheck.Me():MsgNotFit(cell.data)
      end
    end
  end
end
function MainViewSkillPage:ShowPhaseSkillEffect(skillID)
  local cell = self:GetCell(skillID)
  if not cell then
    return
  end
  if self.phaseEffectCtrl == nil then
    self.phaseEffectCtrl = self:PlayUIEffect(EffectMap.UI.SkillsPlay, self.phaseSkillEffect.transform)
  end
  local x, y, z = LuaGameObject.InverseTransformPointByTransform(self.phaseSkillEffect.transform, cell.gameObject.transform, Space.World)
  self.phaseEffectCtrl:ResetLocalPositionXYZ(x, y, z)
end
function MainViewSkillPage:HidePhaseSkillEffect(skillID)
  if self.phaseEffectCtrl then
    self.phaseEffectCtrl:Destroy()
    self.phaseEffectCtrl = nil
  end
end
function MainViewSkillPage:GetCell(skillID)
  if skillID then
    local cells = self.skillShotCutList:GetCells()
    for index, cell in pairs(cells) do
      if cell.data:GetID() == skillID then
        return cell
      end
    end
  end
  return nil
end
function MainViewSkillPage:AddViewEvts()
  self:AddListenEvt(SkillEvent.SkillUpdate, self.UpdateSkills)
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.UpdateSkills)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.ItemUpdateHandler)
  self:AddListenEvt(MyselfEvent.ZenyChange, self.ItemUpdateHandler)
  self:AddListenEvt(MyselfEvent.SyncBuffs, self.BuffUpdateHandler)
  self:AddListenEvt(MyselfEvent.SelectTargetChange, self.SelectTargetChangeHandler)
  self:AddListenEvt(SkillEvent.SkillUnlockPos, self.UnlockPosHandler)
  self:AddListenEvt(SkillEvent.SkillStartEvent, self.StartSkillCD)
  self:AddListenEvt(SkillEvent.SkillWaitNextUse, self.WaitNextUseHandler)
  self:AddListenEvt(SkillEvent.SkillCancelWaitNextUse, self.CancelWaitNextUseHandler)
  self:AddListenEvt(SkillEvent.SkillSelectPhaseStateChange, self.HandlePhaseSkillEffect)
  self:AddListenEvt(MyselfEvent.TransformChange, self.HandleTransformChange)
  self:AddListenEvt(ServiceEvent.SkillDynamicSkillCmd, self.UpdateSkills)
  self:AddListenEvt(ServiceEvent.SkillUpdateDynamicSkillCmd, self.UpdateSkills)
  self:AddListenEvt(TeamEvent.MemberEnterTeam, self.TeamMemberUpdateHandler)
  self:AddListenEvt(TeamEvent.MemberExitTeam, self.TeamMemberUpdateHandler)
  self:AddDispatcherEvt(SkillEvent.SkillFitPreCondtion, self.UpdateSkillPreCondtion)
  self:AddDispatcherEvt(MyselfEvent.SkillGuideBegin, self.SkillGuideBeginHandler)
  self:AddDispatcherEvt(MyselfEvent.SkillGuideEnd, self.SkillGuideEndHandler)
  self:AddDispatcherEvt(MyselfEvent.SelectTargetClassChange, self.SelectTargetClassChangeHandler)
  self:AddDispatcherEvt(DungeonManager.Event.Launched, self.CheckSkillForbid)
  self:AddDispatcherEvt("CJKeyBoardUseSkillEvent", self.KeyBoardUseSkillHandler)
  self:AddListenEvt(HotKeyEvent.UseShortCutSkill, self.HandleUseShortCutIndex)
  self:AddListenEvt(HotKeyEvent.SwitchShortCutSkillIndex, self.HandleSwitchShortCutIndex)
  self:AddListenEvt(SceneSeatEvent.TriggerChange, self.HandleSeatTriggerChange)
  EventManager.Me():AddEventListener(SkillEvent.UpdateSubSkill, self.UpdateSubSkillPreCondtion, self)
end
function MainViewSkillPage:TeamMemberUpdateHandler(note)
  local member = note.body
  if member then
    local memberGUID = member.id
    local target = Game.Myself:GetLockTarget()
    if target and target.data.id == memberGUID then
      self:_HandleSelectTargetChange(target)
    end
  end
end
function MainViewSkillPage:_HandleSelectTargetChange(creature)
  local cells = self.skillShotCutList:GetCells()
  for i = 1, #cells do
    cells[i]:CheckTargetValid(creature)
  end
end
function MainViewSkillPage:SelectTargetClassChangeHandler(creature)
  self:_HandleSelectTargetChange(creature)
end
function MainViewSkillPage:SelectTargetChangeHandler(note)
  self:_HandleSelectTargetChange(note.body)
end
function MainViewSkillPage:UpdateSkillPreCondtion(skill)
  local cells = self.skillShotCutList:GetCells()
  local cell, data
  for i = 1, #cells do
    cell = cells[i]
    data = cell.data
    if data:GetID() == skill.id or data.staticData ~= nil and data:HasSubSkill() then
      cell:UpdatePreCondition()
    end
  end
end
function MainViewSkillPage:UpdateSubSkillPreCondtion(dirtySkills)
  local cells = self.skillShotCutList:GetCells()
  local cell, data
  for i = 1, #cells do
    cell = cells[i]
    data = cell.data
    if data.staticData ~= nil and data:HasSubSkill() then
      cell:UpdatePreCondition()
    end
  end
end
function MainViewSkillPage:WaitNextUseHandler(note)
  local skillID = note.body
  if skillID then
    local cell = self:GetCell(skillID)
    if cell then
      self:_ShowWaitNextUseEffect(cell)
    end
  end
end
function MainViewSkillPage:_ShowWaitNextUseEffect(cell)
  if self.nextEffectCtrl == nil then
    self.nextEffectCtrl = self:PlayUIEffect(EffectMap.UI.SkillWait, self.phaseSkillEffect.transform)
  end
  local x, y, z = LuaGameObject.InverseTransformPointByTransform(self.phaseSkillEffect.transform, cell.gameObject.transform, Space.World)
  self.nextEffectCtrl:ResetLocalPositionXYZ(x, y, z)
end
function MainViewSkillPage:CancelWaitNextUseHandler(note)
  if self.nextEffectCtrl then
    self.nextEffectCtrl:Destroy()
    self.nextEffectCtrl = nil
  end
end
function MainViewSkillPage:HandlePhaseSkillEffect(note)
  local skillID = Game.SkillClickUseManager.currentSelectPhaseSkillID
  if skillID == 0 then
    self:HidePhaseSkillEffect(skillID)
  else
    self:ShowPhaseSkillEffect(skillID)
  end
end
function MainViewSkillPage:UnlockPosHandler(note)
  ShortCutProxy.Instance:SetCacheListToRealList()
  self:UpdateSkills(note)
end
function MainViewSkillPage:ShowCancelTransBtn(bShow)
  local _MapManager = Game.MapManager
  if _MapManager:IsPVPMode_PoringFight() or _MapManager:IsPveMode_AltMan() then
    bShow = false
  end
  if bShow then
    self:Show(self.cancelTransformBtn)
  else
    self:Hide(self.cancelTransformBtn)
  end
end
function MainViewSkillPage:UpdateSkills(note)
  self:ShowCancelTransBtn(Game.Myself.data:IsTransformed())
  local equipDatas
  self:HandleShortCutSwitchActive()
  local transformSkills = SkillProxy.Instance:GetTransformedSkills()
  local transformed = Game.Myself.data:IsTransformed()
  if transformed then
    equipDatas = transformSkills
  else
    equipDatas = SkillProxy.Instance:GetCurrentEquipedSkillData(true, self.shortcutSwitchID)
  end
  if equipDatas ~= nil then
    self.skillShotCutList:ResetDatas(equipDatas)
    local cells = self.skillShotCutList:GetCells()
    if cells and not transformed then
      local data, locked
      for i = 1, #cells do
        data = cells[i].data
        if data then
          locked = ShortCutProxy.Instance:SkillIsLocked(i, self.shortcutSwitchID)
          if self.shortcutSwitchID == ShortCutProxy.ShortCutEnum.ID1 then
            cells[i]:NeedHide(locked)
          elseif locked then
            if i > ShortCutProxy.Instance:GetUnLockSkillMaxIndex(ShortCutProxy.ShortCutEnum.ID1) then
              cells[i]:NeedHide(true)
            else
              cells[i]:ExtendsEmptyShow()
            end
          else
            cells[i]:NeedHide(false)
          end
        end
      end
      self.skillShotCutList:Layout()
    end
  end
  local cellnum = 0
  for k, v in pairs(self.skillShotCutList:GetCells()) do
    if v.gameObject.activeSelf then
      cellnum = cellnum + 1
    end
  end
  self.touchBoard.width = cellnum * self.skillGrid.cellWidth
  NGUITools.UpdateWidgetCollider(self.touchBoard.gameObject)
  self.skillShortCutAnchor:UpdateAnchors()
end
function MainViewSkillPage:StartSkillCD(note)
  local cells = self.skillShotCutList:GetCells()
  local skill = note.body
  for _, o in pairs(cells) do
    o:TryStartCd()
  end
  if self.sceneSeatSkill ~= nil then
    self.sceneSeatSkill:TryStartCd()
  end
end
function MainViewSkillPage:ItemUpdateHandler(note)
  local cells = self.skillShotCutList:GetCells()
  for i = 1, #cells do
    cells[i]:UpdatePreCondition()
  end
end
function MainViewSkillPage:BuffUpdateHandler(note)
  self:ItemUpdateHandler(note)
end
function MainViewSkillPage:SkillGuideBeginHandler(skillInfo)
  if skillInfo then
    local cell = self:GetCell(skillInfo:GetSkillID())
    if cell then
      cell:GuideBegin(skillInfo)
    end
  end
end
function MainViewSkillPage:SkillGuideEndHandler(skillInfo)
  if skillInfo then
    local cell = self:GetCell(skillInfo:GetSkillID())
    if cell then
      cell:GuideEnd()
    end
  end
end
function MainViewSkillPage:CheckSkillForbid()
  local cells = self.skillShotCutList:GetCells()
  for i = 1, #cells do
    cells[i]:CheckEnableUseSkill()
  end
end
function MainViewSkillPage:HandleUseShortCutIndex(note)
  local param = note.body
  if param.index then
    local cells = self.skillShotCutList:GetCells()
    local cell = cells[param.index]
    if cell == nil then
      return
    end
    local d = cell.data
    if d == nil then
      return
    end
    if d:GetID() == 0 then
      self:ClickSkillHandler({data = cell})
    else
      Game.SkillClickUseManager:ClickSkill(cell)
    end
  end
end
function MainViewSkillPage:HandleSwitchShortCutIndex(note)
  local param = note.body
  if param.add_index then
    self:TryGetNextSwitchID(param.add_index)
    self:SwitchShortCutTo(self.shortcutSwitchID)
    return
  end
  if param.index then
    local id = ShortCutProxy.SwitchList[param.index]
    local funcEnable = ShortCutProxy.Instance:ShortCutListIsEnable(id)
    if funcEnable then
      self.shortcutSwitchIndex = param.index
      local max_index = #ShortCutProxy.SwitchList
      if max_index < self.shortcutSwitchIndex then
        self.shortcutSwitchIndex = self.shortcutSwitchIndex % max_index
      end
      self:SwitchShortCutTo(id)
    end
  end
end
function MainViewSkillPage:HandleTransformChange(note)
  self:UpdateSkills()
  if self.sceneSeatSkill ~= nil then
    self.sceneSeatSkill:CheckEnableUseSkill(not Game.Myself.data:IsTransformed())
  end
end
function MainViewSkillPage:HandleSeatTriggerChange(note)
  local data = note.body
  if data == true then
    if self.sceneSeatSkill == nil then
      local root = self:FindGO("SceneSeatSkill")
      local go = self:LoadPreferb("cell/ShortCutSkill")
      go.transform:SetParent(root.transform, false)
      self.sceneSeatSkill = ShortCutSkill.new(go)
    end
    local skill = SkillProxy.Instance:GetLearnedSkill(SceneSeatSkillID)
    if skill ~= nil then
      self.sceneSeatSkill:SetData(skill)
      self.sceneSeatSkill:CheckEnableUseSkill(not Game.Myself.data:IsTransformed())
    end
  end
  if self.sceneSeatSkill ~= nil then
    self.sceneSeatSkill.gameObject:SetActive(data == true)
  end
end
