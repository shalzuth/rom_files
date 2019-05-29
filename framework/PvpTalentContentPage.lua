autoImport("SkillTip")
autoImport("PeakSkillPreviewTip")
autoImport("PvpTalentCell")
autoImport("SkillItemData")
PvpTalentContentPage = class("PvpTalentContentPage", SubView)
local tmpPos = LuaVector3.zero
function PvpTalentContentPage:Init()
  local useless, pwsConfig = next(GameConfig.PvpTeamRaid)
  self.pwsConfig = pwsConfig
  self.tipdata = {}
  self.usablePoints = 0
  self.maxPoints = 0
  self:FindObjs()
  self:InitTalentsList()
  self:AddViewListener()
  self:AddButtonEvts()
end
function PvpTalentContentPage:FindObjs()
  self.objLeftTopInfo = self:FindGO("PvpTalent", self:FindGO("Left", self:FindGO("Up")))
  self.labUsablePoints = self:FindComponent("labPvpTalentPoints", UILabel, self.objLeftTopInfo)
  local buttons = self:FindGO("PvpTalent", self:FindGO("RightBtns"))
  self.objBtnConfirm = self:FindGO("PvpTalentConfirmBtn", buttons)
  self.objBtnCancel = self:FindGO("PvpTalentCancelBtn", buttons)
  self.objMineShortCuts = self:FindGO("Mines", self:FindGO("BottomLeft"))
  self.shortCutArea = self:FindComponent("ShortCutArea", UIWidget)
  self.objScrollArea = self:FindGO("PvpTalentArea", self:FindGO("ScrollArea"))
  self.objContents = self:FindGO("PvpTalent", self:FindGO("Contents"))
  self.objBtnReset = self:FindGO("PvpTalentResetBtn", self.objContents)
  self.contentPanel = self:FindComponent("PvpTalentContent", UIPanel, self.objContents)
  self.contentScroll = self.contentPanel.gameObject:GetComponent(ScrollViewWithProgress)
end
function PvpTalentContentPage:InitTalentsList()
  self.listTalents = ListCtrl.new(self:FindGO("pvpTalentGrid", self.objContents), PvpTalentCell, "PvpTalentCell")
  self.listTalents:AddEventListener(MouseEvent.MouseClick, self.ShowTipHandler, self)
  self.listTalents:AddEventListener(SkillCell.Click_PreviewPeak, self.ShowPeakTipHandler, self)
  self.listTalents:AddEventListener(SkillCell.SimulationUpgrade, self.SimulationUpgradeHandler, self)
  self.listTalents:AddEventListener(SkillCell.SimulationDowngrade, self.SimulationDowngradeHandler, self)
end
function PvpTalentContentPage:AddViewListener()
  self:AddListenEvt(SkillEvent.SkillUpdate, self.RefreshSkills)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleMyDataChange)
end
function PvpTalentContentPage:AddButtonEvts()
  self:AddClickEvent(self.objBtnCancel, function()
    self:ResetTalents()
    self:SetEditMode(false)
  end)
  self:AddClickEvent(self.objBtnConfirm, function()
    if Game.MapManager:IsPVPMode_TeamPws() then
      MsgManager.ShowMsgByID(25932)
      return
    end
    local skillIDs = ReusableTable.CreateArray()
    local cells = self.listTalents:GetCells()
    local skills, id
    for i = 1, #cells do
      skills = cells[i].listTalents:GetCells()
      for j = 1, #skills do
        id = skills[j]:TryGetSimulateSkillID()
        if id then
          skillIDs[#skillIDs + 1] = id
        end
      end
    end
    self:CheckNeedShowOverFlow(skillIDs)
    ServiceSkillProxy.Instance:CallLevelupSkill(SceneSkill_pb.ELEVELUPTYPE_TALENT, skillIDs)
    ReusableTable.DestroyAndClearArray(skillIDs)
  end)
  self:AddClickEvent(self.objBtnReset, function()
    if self.usablePoints >= self.maxPoints then
      return
    end
    if Game.MapManager:IsPVPMode_TeamPws() then
      MsgManager.ShowMsgByID(25932)
      return
    end
    MsgManager.ConfirmMsgByID(25933, function()
      ServiceSkillProxy.Instance:CallResetTalentSkillCmd()
    end, nil)
  end)
end
function PvpTalentContentPage:OnEnter()
  self.talentDatas = nil
  self.contentScroll:ResetPosition()
  self.contentScroll.panel.clipOffset = Vector2.zero
  self.contentScroll.transform.localPosition = Vector3.zero
  self:RefreshSkills()
end
function PvpTalentContentPage:OnExit()
  self:Switch(false)
  self:ClearTalentDatas()
end
function PvpTalentContentPage:RefreshSkills()
  self:SetEditMode(false)
  self:SetTalentSkills()
  self:UpdateCurrentTalentSkillPoints()
end
function PvpTalentContentPage:ShowTipHandler(cell)
  self:_ShowTip(cell, SkillTip, "SkillTip")
end
function PvpTalentContentPage:ShowPeakTipHandler(cell)
  self:_ShowTip(cell, PeakSkillPreviewTip, "PeakSkillPreviewTip")
end
function PvpTalentContentPage:_ShowTip(cell, tipCtrl, tipView)
  local camera = NGUITools.FindCameraForLayer(cell.gameObject.layer)
  if camera then
    local viewPos = camera:WorldToViewportPoint(cell.gameObject.transform.position)
    self.tipdata.data = cell:GetSimulateSkillItemData()
    TipsView.Me():ShowTip(tipCtrl, self.tipdata, tipView)
    local tip = TipsView.Me().currentTip
    if tip then
      tip:SetCheckClick(self:TipClickCheck())
      if viewPos.x <= 0.5 then
        tmpPos[1], tmpPos[2], tmpPos[3] = self.contentPanel.width / 4, 0, 0
      else
        tmpPos[1], tmpPos[2], tmpPos[3] = -self.contentPanel.width / 4, 0, 0
      end
      tip.gameObject.transform.localPosition = tmpPos
    end
  end
end
function PvpTalentContentPage:TipClickCheck()
  if self.tipCheck == nil then
    function self.tipCheck()
      local click = UICamera.selectedObject
      if click then
        local cells = self.listTalents:GetCells()
        if self:CheckIsClickCell(cells, click) then
          return true
        end
      end
      return false
    end
  end
  return self.tipCheck
end
function PvpTalentContentPage:CheckIsClickCell(cells, clickedObj)
  local skills
  for i = 1, #cells do
    skills = cells[i].listTalents:GetCells()
    for j = 1, #skills do
      if skills[j]:IsClickMe(clickedObj) then
        return true
      end
    end
  end
  return false
end
function PvpTalentContentPage:SimulationUpgradeHandler(cell)
  if Game.MapManager:IsPVPMode_TeamPws() then
    MsgManager.ShowMsgByID(25932)
    return
  end
  if self.usablePoints < 1 then
    MsgManager.ShowMsgByID(604)
    return
  end
  local curLayer = cell.layer
  local cells = self.listTalents:GetCells()
  local curLayerLevel = cells[curLayer]:GetLayerSimulateLevel()
  if curLayerLevel >= self.pwsConfig.LayerNeedPoint then
    MsgManager.ShowMsgByID(25936)
    return
  end
  if cell:TrySimulateUpgrade() then
    if cells[curLayer]:GetLayerSimulateLevel() >= self.pwsConfig.LayerNeedPoint then
      cells[curLayer]:SetLayerUpdateEnable(false)
      if curLayer < #cells then
        cells[curLayer + 1]:SetLayerEnable(true)
      end
    end
    self:SetEditMode(true)
    self.usablePoints = self.usablePoints - 1
    self:UpdateCurrentTalentSkillPoints()
    if self.usablePoints < 1 then
      for i = 1, #cells do
        cells[i]:SetLayerUpdateEnable(false)
      end
    end
  end
end
function PvpTalentContentPage:SimulationDowngradeHandler(cell)
  if Game.MapManager:IsPVPMode_TeamPws() then
    MsgManager.ShowMsgByID(25932)
    return
  end
  local cells = self.listTalents:GetCells()
  local curLayer, maxLayer = cell.layer, #cells
  local curLayerLevel = cells[curLayer]:GetLayerSimulateLevel()
  if curLayer < maxLayer and curLayerLevel <= self.pwsConfig.LayerNeedPoint and cells[curLayer + 1]:GetLayerSimulateLevel() > 0 then
    MsgManager.ShowMsgByID(25934)
    return
  end
  if cell:TrySimulateDowngrade() then
    local haveChange = false
    local cells = self.listTalents:GetCells()
    local skills
    for i = 1, #cells do
      skills = cells[i].listTalents:GetCells()
      for j = 1, #skills do
        if skills[j]:IsChanged() then
          haveChange = true
          break
        end
      end
      if not haveChange then
      end
    end
    if cells[curLayer]:GetLayerSimulateLevel() < self.pwsConfig.LayerNeedPoint then
      cells[curLayer]:SetLayerUpdateEnable(true)
      if curLayer < maxLayer then
        cells[curLayer + 1]:SetLayerEnable(false)
      end
    end
    self.usablePoints = self.usablePoints + 1
    self:UpdateCurrentTalentSkillPoints()
    for i = 1, #cells do
      cells[i]:SetLayerUpdateEnable(true)
    end
    if not haveChange then
      self:SetEditMode(false)
    end
  end
end
function PvpTalentContentPage:SetTalentSkills()
  if not Table_TalentSkill then
    return
  end
  self:ClearTalentDatas()
  local myProfess = SkillProxy.Instance:GetMyProfession()
  local learnedSkills = SkillProxy.Instance:GetPvpTalentSkillsData()
  self.maxPoints = Game.Myself.data.userdata:Get(UDEnum.TALENT_POINT) or 0
  self.usablePoints = self.maxPoints - (learnedSkills and learnedSkills.usedPoints or 0)
  self.talentDatas = ReusableTable.CreateTable()
  local isMyTalent = false
  local pvpTalentData
  for sortID, talent in pairs(Table_TalentSkill) do
    isMyTalent = talent.RequireProfession == nil
    if talent.RequireProfession then
      for i = 1, #talent.RequireProfession do
        if talent.RequireProfession[i] == myProfess then
          isMyTalent = true
          break
        end
      end
    end
    if isMyTalent then
      local layerTalentsData = self.talentDatas[talent.Layer]
      if not layerTalentsData then
        layerTalentsData = ReusableTable.CreateTable()
        layerTalentsData.layer = talent.Layer
        layerTalentsData.skills = ReusableTable.CreateArray()
        self.talentDatas[talent.Layer] = layerTalentsData
      end
      pvpTalentData = ReusableTable.CreateTable()
      pvpTalentData.layer = talent.Layer
      pvpTalentData.maxLevel = talent.MaxLevel
      if learnedSkills and learnedSkills.skills[sortID] then
        pvpTalentData.skill = learnedSkills.skills[sortID]
        pvpTalentData.level = pvpTalentData.skill.level
      else
        pvpTalentData.skill = SkillItemData.new(sortID * 1000 + 1, i, 0, myProfess, 0)
        pvpTalentData.skill:SetLearned(false)
        pvpTalentData.skill:SetActive(true)
        pvpTalentData.level = 0
      end
      layerTalentsData.skills[#layerTalentsData.skills + 1] = pvpTalentData
    end
  end
  for layer, talents in pairs(self.talentDatas) do
    table.sort(talents.skills, function(x, y)
      if not x then
        return true
      end
      if not y then
        return false
      end
      return x.skill.sortID < y.skill.sortID
    end)
  end
  self.listTalents:ResetDatas(self.talentDatas, true, false)
  local cells = self.listTalents:GetCells()
  if #cells > 1 then
    if 0 < self.usablePoints then
      cells[1]:SetLayerEnable(true)
      cells[1]:SetLayerUpdateEnable(true)
      for i = 2, #cells do
        cells[i]:SetLayerEnable(cells[i - 1]:GetLayerSimulateLevel() >= self.pwsConfig.LayerNeedPoint)
        cells[i]:SetLayerUpdateEnable(true)
      end
    else
      for i = 1, #cells do
        cells[i]:SetLayerDisableOperate()
      end
    end
  end
end
function PvpTalentContentPage:ClearTalentDatas()
  if not self.talentDatas then
    return
  end
  for k, talent in pairs(self.talentDatas) do
    for i = 1, #talent.skills do
      ReusableTable.DestroyAndClearTable(talent.skills[i])
    end
    ReusableTable.DestroyAndClearArray(talent.skills)
    ReusableTable.DestroyAndClearTable(talent)
  end
  ReusableTable.DestroyAndClearTable(self.talentDatas)
  self.talentDatas = nil
end
function PvpTalentContentPage:UpdateCurrentTalentSkillPoints()
  self.labUsablePoints.text = string.format(ZhString.SkillView_Talent_UsablePoints, self.usablePoints, self.maxPoints)
end
function PvpTalentContentPage:SetEditMode(val)
  if self.isEditMode ~= val then
    self.isEditMode = val
    if val then
      self:Show(self.objBtnConfirm)
      self:Show(self.objBtnCancel)
    else
      self:Hide(self.objBtnConfirm)
      self:Hide(self.objBtnCancel)
    end
  end
end
function PvpTalentContentPage:ResetTalents()
  local talentData = SkillProxy.Instance:GetPvpTalentSkillsData()
  self.usablePoints = self.maxPoints - (talentData and talentData.usedPoints or 0)
  self:UpdateCurrentTalentSkillPoints()
  local updateEnable = self.usablePoints > 0
  local cells = self.listTalents:GetCells()
  if #cells > 0 then
    cells[1]:ResetLayer()
    cells[1]:SetLayerUpdateEnable(updateEnable)
    cells[1]:SetLayerEnable(true)
  end
  for i = 2, #cells do
    cells[i]:ResetLayer()
    cells[i]:SetLayerUpdateEnable(updateEnable)
    cells[i]:SetLayerEnable(cells[i - 1]:GetLayerSimulateLevel() >= self.pwsConfig.LayerNeedPoint)
  end
end
function PvpTalentContentPage:ConfirmEditMode(toDo, owner, param)
  if self.isEditMode then
    MsgManager.ConfirmMsgByID(602, function()
      self:ResetTalents()
      self:SetEditMode(false)
      toDo(owner, param)
    end)
  else
    toDo(owner, param)
  end
end
function PvpTalentContentPage:Switch(val)
  if self.switch ~= val then
    self.switch = val
    if val then
      self:Show(self.objMineShortCuts)
      self:Show(self.objContents)
      self:Show(self.objScrollArea)
      self:Show(self.objLeftTopInfo)
    else
      self:Hide(self.objMineShortCuts)
      self:Hide(self.objContents)
      self:Hide(self.objScrollArea)
      self:Hide(self.objLeftTopInfo)
    end
  end
end
function PvpTalentContentPage:CheckNeedShowOverFlow(levelUpSkillIDs)
  if FunctionFirstTime.Me():IsFirstTime(FunctionFirstTime.SkillOverFlow) then
    local cells = self.container.shortCutList:GetCells()
    local equipedNum = 0
    for i = 1, #cells do
      if cells[i].data and cells[i].data.staticData then
        equipedNum = equipedNum + 1
      end
    end
    local skillProxy = SkillProxy.Instance
    if equipedNum >= ShortCutProxy.Instance:GetUnLockSkillMaxIndex() then
      local flag = false
      for i = 1, #levelUpSkillIDs do
        if Table_Skill[levelUpSkillIDs[i]].SkillType ~= GameConfig.SkillType.Passive.type and skillProxy:GetEquipedSkillBySort(math.floor(levelUpSkillIDs[i] / 1000)) == false then
          flag = true
          break
        end
      end
      if flag then
        FunctionFirstTime.Me():DoneFirstTime(FunctionFirstTime.SkillOverFlow)
        TipManager.Instance:ShowBubbleTipById(BubbleID.SkillFirstTimeOverFlow, self.shortCutArea, nil, {275, -20})
      end
    end
  end
end
function PvpTalentContentPage:HandleMyDataChange(note)
  local data = note.body
  if not data then
    return
  end
  local skillType = ProtoCommon_pb.EUSERDATATYPE_TALENT_SKILLPOINT
  for i = 1, #data do
    if data[i].type == skillType then
      self.maxPoints = Game.Myself.data.userdata:Get(UDEnum.TALENT_POINT) or 0
      self:UpdateCurrentTalentSkillPoints()
      break
    end
  end
end
