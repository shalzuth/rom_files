autoImport("SubView")
autoImport("SkillTip")
autoImport("PeakSkillPreviewTip")
autoImport("SkillCell")
SkillContentPage = class("SkillContentPage", SubView)
local tmpPos = LuaVector3.zero
function SkillContentPage:Init()
  self.tipdata = {}
  self.cellHeight = 0
  self.cellWidth = 0
  self:FindObjs()
  self:InitCommonSkill()
  self:InitProfessSkill()
  self:AddViewListener()
  self:RegisterGuide()
end
function SkillContentPage:OnEnter()
  self.professDatas = nil
  self.proContentScroll:ResetPosition()
  self.proContentScroll.panel.clipOffset = Vector2.zero
  self.proContentScroll.transform.localPosition = Vector3.zero
  self.professesSkillCenterPos = {}
  self:SetEditMode(false)
  FunctionSkillSimulate.Me():CancelSimulate()
  self:SetCommonSkills()
  self:SetProfessSkills(nil, true)
  self:RefreshPoints()
  self:TrySimulate()
  local profess = SkillProxy.Instance:GetMyProfession()
  self:SetScrollToProfess(profess)
  self.comContentPanel:ResetAndUpdateAnchors()
  self.proContentPanel:ResetAndUpdateAnchors()
end
function SkillContentPage:AddViewListener()
  self:AddListenEvt(FunctionSkillSimulate.SimulateSkillPointChange, self.RefreshPointsAndUpdateCurrent)
  self:AddListenEvt(FunctionSkillSimulate.HasNoModifiedSkills, self.NoModifiedHandler)
  self:AddListenEvt(SkillEvent.SkillUpdate, self.RefreshSkills)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleMyDataChange)
end
function SkillContentPage:FindObjs()
  local scrollArea = self:FindGO("ScrollArea")
  self.scrollAreaMines = self:FindGO("Mines", scrollArea)
  self.contentMines = self:FindGO("Mines", self:FindGO("Contents"))
  local UpLeft = self:FindGO("Up")
  self.upleftMines = self:FindGO("Mines", UpLeft)
  local BottomLeft = self:FindGO("BottomLeft")
  local BottomRight = self:FindGO("BottomRight")
  local Right = self:FindGO("RightBtns")
  self.bottomleftMines = self:FindGO("Mines", BottomLeft)
  self.bottomrightMines = self:FindGO("Mines", Right)
  self.leftPointsLabel = self:FindGO("SkillPoints"):GetComponent(UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn"):GetComponent(UIButton)
  self.confirmBtnSp = self:FindGO("ConfirmBtnSp")
  self.cancelBtn = self:FindGO("CancelBtn"):GetComponent(UIButton)
  self.shortCutArea = self:FindGO("ShortCutArea"):GetComponent(UIWidget)
  self.commonScrollArea = self:FindGO("CommonArea")
  self.professScrollArea = self:FindGO("ProfessArea")
  self.proContentPanel = self:FindGO("ProfessContent"):GetComponent(UIPanel)
  self.proContentScroll = self:FindGO("ProfessContent"):GetComponent(ScrollViewWithProgress)
  self.comContentPanel = self:FindGO("CommonContent"):GetComponent(UIPanel)
  self.commonGrid = self:FindGO("CommonGrid"):GetComponent(UIGrid)
  self.professGrid = self:FindGO("ProfessGrid")
  self.skillCellPlaceHolder = self:FindGO("SkillCellPlaceHolder")
  self.professBtnGrid = self:FindGO("ProfessionGrid"):GetComponent(UIGrid)
  self.professBgGrid = self:FindGO("ProfessBgGrid"):GetComponent(UITable)
  self.sperate = self:FindGO("Sperate")
  self.comContentPanel:ResetAndUpdateAnchors()
  self.proContentPanel:ResetAndUpdateAnchors()
  self.cellHeight = math.min(self.comContentPanel.height / 5, self.proContentPanel.height / 5) - 3
  self.cellWidth = 80
  self.professBtnGrid.cellHeight = self.cellHeight
  self.commonGrid.cellHeight = self.cellHeight
  self.commonGrid.transform.localPosition = Vector3(0, self.cellHeight + self.comContentPanel.baseClipRegion.y, 0)
  self:AddClickEvent(self.cancelBtn.gameObject, function()
    self:CancelSimulate()
  end)
  self:AddClickEvent(self.confirmBtn.gameObject, function()
    local skillIDs = FunctionSkillSimulate.Me():GetModifiedSkills()
    self:CheckNeedShowOverFlow(skillIDs)
    ServiceSkillProxy.Instance:CallLevelupSkill(SceneSkill_pb.ELEVELUPTYPE_MT, skillIDs)
  end)
  function self.proContentScroll.onProgressStateChange(progress, state)
    self:ScrollStateChange(progress, state)
  end
  local ConfirmTipLabel = self:FindGO("ConfirmTipLabel"):GetComponent(UILabel)
  ConfirmTipLabel.fontSize = 15
  OverseaHostHelper:FixLabelOverV1(ConfirmTipLabel, 3, 280)
  ConfirmTipLabel.transform.localPosition = Vector3(-130, -206, 0)
  local ConfirmTip = self:FindGO("ConfirmTip"):GetComponent(UISprite)
  ConfirmTip.width = 300
  ConfirmTip.transform.localPosition = Vector3(-130, -206, 0)
end
function SkillContentPage:Switch(val)
  if self.switch ~= val then
    self.switch = val
    if val then
      self:Show(self.upleftMines)
      self:Show(self.bottomleftMines)
      self:Show(self.scrollAreaMines)
      self:Show(self.contentMines)
      self:Show(self.bottomrightMines)
    else
      self:Hide(self.upleftMines)
      self:Hide(self.bottomleftMines)
      self:Hide(self.scrollAreaMines)
      self:Hide(self.contentMines)
      self:Hide(self.bottomrightMines)
    end
  end
end
function SkillContentPage:RegisterGuide()
  self:AddOrRemoveGuideId(self.confirmBtnSp.gameObject, 30)
end
function SkillContentPage:InitCommonSkill()
  self.commonList = ListCtrl.new(self.commonGrid, AdventureSkillCell, "SkillCell")
  self.commonList:AddEventListener(MouseEvent.MouseClick, self.ShowTipHandler, self)
end
function SkillContentPage:InitProfessSkill()
  self.professList = ListCtrl.new(self.professGrid, SkillCell, "SkillCell")
  self.professList:AddEventListener(MouseEvent.MouseClick, self.ShowTipHandler, self)
  self.professList:AddEventListener(SkillCell.Click_PreviewPeak, self.ShowPeakTipHandler, self)
  self.professList:AddEventListener(SkillCell.SimulationUpgrade, self.SimulationUpgradeHandler, self)
  self.professList:AddEventListener(SkillCell.SimulationDowngrade, self.SimulationDowngradeHandler, self)
end
function SkillContentPage:ShowTipHandler(cell)
  self:_ShowTip(cell, SkillTip, "SkillTip")
end
function SkillContentPage:ShowPeakTipHandler(cell)
  self:_ShowTip(cell, PeakSkillPreviewTip, "PeakSkillPreviewTip")
end
function SkillContentPage:_ShowTip(cell, tipCtrl, tipView)
  local camera = NGUITools.FindCameraForLayer(cell.gameObject.layer)
  if camera then
    local viewPos = camera:WorldToViewportPoint(cell.gameObject.transform.position)
    local data = cell.data
    if self.isEditMode then
      data = SimulateSkillProxy.Instance:GetSimulateSkillItemData(data.sortID)
    end
    self.tipdata.data = data
    TipsView.Me():ShowTip(tipCtrl, self.tipdata, tipView)
    local tip = TipsView.Me().currentTip
    if tip then
      tip:SetCheckClick(self:TipClickCheck())
      if viewPos.x <= 0.5 then
        tmpPos[1], tmpPos[2], tmpPos[3] = self.comContentPanel.width / 4, 0, 0
      else
        tmpPos[1], tmpPos[2], tmpPos[3] = -self.comContentPanel.width / 4, 0, 0
      end
      tip.gameObject.transform.localPosition = tmpPos
    end
  end
end
function SkillContentPage:TipClickCheck()
  if self.tipCheck == nil then
    function self.tipCheck()
      local click = UICamera.selectedObject
      if click then
        local cells = self.commonList:GetCells()
        if self:CheckIsClickCell(cells, click) then
          return true
        end
        cells = self.professList:GetCells()
        if self:CheckIsClickCell(cells, click) then
          return true
        end
      end
      return false
    end
  end
  return self.tipCheck
end
function SkillContentPage:CheckIsClickCell(cells, clickedObj)
  for i = 1, #cells do
    if cells[i]:IsClickMe(clickedObj) then
      return true
    end
  end
  return false
end
function SkillContentPage:ClickProfessBtn(cell)
end
function SkillContentPage:SetScrollToProfess(profess)
  local index
  local datas = self.professDatas
  if datas then
    for i = 1, #datas do
      if profess == datas[i].data.profession then
        index = i
      end
    end
  end
  if index then
    self:ScrollToProfess(index, false)
  end
end
function SkillContentPage:ScrollToProfess(index, spring)
  local sv = self.proContentScroll
  local data = self.professesSkillCenterPos[index]
  local offset = data.pos
  if not sv.canMoveHorizontally then
    offset.x = self.proContentPanel.cachedTransform.localPosition.x
  end
  if not sv.canMoveVertically then
    offset.y = self.proContentPanel.cachedTransform.localPosition.y
  end
  if spring then
    SpringPanel.Begin(self.proContentPanel.cachedGameObject, offset, 10)
  else
    self.proContentScroll:MoveRelative(offset)
  end
end
function SkillContentPage:SimulationUpgradeHandler(cell)
  if FunctionSkillSimulate.Me():Upgrade(cell) then
    self:SetEditMode(true)
    self:RefreshPoints()
    self:UpdateCurrentProfessSkillPoints()
  end
end
function SkillContentPage:SimulationDowngradeHandler(cell)
  FunctionSkillSimulate.Me():Downgrade(cell)
  self:RefreshPoints()
  self:UpdateCurrentProfessSkillPoints()
end
function SkillContentPage:NoModifiedHandler(note)
  self:SetEditMode(false)
end
function SkillContentPage:RefreshSkills(note)
  self:CancelSimulate()
  if self.currentScrollProfessData then
    self.container:UpdateTopByProfess(self.currentScrollProfessData.data.profession)
  end
end
function SkillContentPage:RefreshProfess(note)
end
function SkillContentPage:QuitProfess(toDo, owner)
  if self.isEditMode then
    MsgManager.ConfirmMsgByID(602, function()
      self:CancelSimulate()
      toDo(owner)
    end)
  else
    toDo(owner)
  end
end
function SkillContentPage:TrySimulate()
  if self.container.multiSaveId ~= nil then
    local cells = self.professList:GetCells()
    for i = 1, #cells do
      local cell = cells[i]
      if cell then
        cell:ShowUpgrade(false)
        cell:SetDragEnable(false)
      end
    end
    local commoncells = self.commonList:GetCells()
    for i = 1, #commoncells do
      local cell = commoncells[i]
      if cell then
        cell:SetDragEnable(false)
      end
    end
    return
  end
  if not FunctionSkillSimulate.Me().isIsSimulating then
    FunctionSkillSimulate.Me():StartSimulate(self.professList:GetCells(), self.professDatas, self:GetSkillPoint())
  end
end
function SkillContentPage:CancelSimulate()
  self:SetEditMode(false)
  FunctionSkillSimulate.Me():CancelSimulate()
  self:SetProfessSkills()
  self:TrySimulate()
  self:RefreshPoints()
end
function SkillContentPage:ShowCommon()
  self.ShowingCommon = true
  self:Show(self.commonScrollArea)
  self:Show(self.comContentPanel.gameObject)
  self:Hide(self.professScrollArea)
  self:Hide(self.proContentPanel.gameObject)
  self:Hide(self.professBtnGrid.gameObject)
  self:SetEditMode(false)
  self.commonGrid:Reposition()
end
function SkillContentPage:ShowProfess()
  self.ShowingCommon = false
  self:Hide(self.commonScrollArea)
  self:Hide(self.comContentPanel.gameObject)
  self:Show(self.professScrollArea)
  self:Show(self.proContentPanel.gameObject)
  self:SetEditMode(false)
end
function SkillContentPage:SetCommonSkills(professSkill)
  professSkill = professSkill or SkillProxy.Instance:FindProfessSkill(ProfessionProxy.Instance.rootProfession.id)
  if professSkill then
    local num = 0
    for i = 1, #professSkill.skills do
      if not professSkill.skills[i].shadow then
        num = num + 1
      end
    end
    local pos = self.commonGrid.transform.localPosition
    if num <= self.commonGrid.maxPerLine then
      pos.x = 0
    else
      num = math.floor((num - 1) / self.commonGrid.maxPerLine)
      pos.x = -num * self.commonGrid.cellWidth / 2
    end
    pos.x = pos.x - 80
    self.commonGrid.transform.localPosition = pos
    self.commonList:ResetDatas(professSkill.skills)
  end
end
function SkillContentPage:SetProfessSkills(skills, needLayout)
  local myProfess = SkillProxy.Instance:GetMyProfession()
  local professTree = ProfessionProxy.Instance:GetProfessionTreeByClassId(myProfess)
  if professTree ~= nil then
    local professes = {}
    local skills = {}
    local p = professTree.transferRoot
    local ps
    local typeBranch = Table_Class[myProfess].TypeBranch
    local mydepth = professTree:GetProfessDataByClassID(myProfess).depth
    while p ~= nil do
      ps = SkillProxy.Instance:FindProfessSkill(p.id, true)
      professes[#professes + 1] = ps
      TableUtil.InsertArray(skills, ps.skills)
      if mydepth ~= 1 then
        p = p:GetNextByBranch(typeBranch)
      end
    end
    self:SetProfessBtns(professes)
    self.professList:ResetDatas(skills, true, false)
    if needLayout then
      self:LayOutProfessSkills(professTree)
    end
  end
end
function SkillContentPage:LayOutProfessSkills(professTree)
  professTree:InitSkillPath(SkillProxy.Instance:GetMyProfession())
  local cells = self.professList:GetCells()
  local firstCell, cell, x, y
  local minCell = {x = 1000, y = 1000}
  local config
  local sortMap = {}
  local requiringCells = {}
  local professDatas = {}
  local professData
  local professCount = 0
  for i = 1, #cells do
    cell = cells[i]
    sortMap[cell.data.sortID] = cell
    if cell.data.requiredSkillID then
      requiringCells[#requiringCells + 1] = cell
    end
    cell:RemoveLink()
    cell:ResetLink()
    x, y = cell:GetGridXY()
    minCell.x = math.min(minCell.x, x)
    if x == minCell.x then
      minCell.y = math.min(minCell.y, y)
      if y == minCell.y then
        firstCell = cell
      end
    end
    tmpPos:Set(self:GetX(x), -(y - 3) * self.cellHeight, 0)
    cell.gameObject.transform.localPosition = tmpPos
    professData = professDatas[cell.data.profession]
    if professData == nil then
      professCount = professCount + 1
      professData = {
        minX = 10000,
        maxX = 0,
        id = cell.data.profession
      }
      professDatas[cell.data.profession] = professData
    end
    professData.minX = math.min(professData.minX, x)
    professData.maxX = math.max(professData.maxX, x)
  end
  local requiredSkill, requiredSort
  for i = 1, #requiringCells do
    cell = requiringCells[i]
    requiredSort = math.floor(cell.data.requiredSkillID / 1000)
    requiredSkill = sortMap[requiredSort]
    if requiredSkill then
      local x, y = requiredSkill:GetGridXY()
      local path = professTree.paths[y][x]
      requiredSkill:DrawLink(cell, path.between, path.up)
      if self.container.multiSaveId ~= nil then
        requiredSkill:LinkUnlock(requiredSkill.data.id >= cell.data.requiredSkillID and requiredSkill.data.learned)
      end
    end
  end
  self:SetProgressScroll(professDatas, professData.maxX)
  self:TrySperate(professDatas, professCount > 1)
  tmpPos:Set(self:GetX(professData.maxX + 4), 0)
  self.skillCellPlaceHolder.transform.localPosition = tmpPos
  if firstCell ~= nil then
    self:AddOrRemoveGuideId(firstCell.upgradeBtn, 32)
  end
end
function SkillContentPage:GetX(x)
  return x * self.cellWidth - self.comContentPanel.width / 2
end
function SkillContentPage:TrySperate(professDatas, needCreate)
  if self.sperates then
    for i = 1, #self.sperates do
      GameObject.Destroy(self.sperates[i])
    end
  end
  self.sperates = {}
  if needCreate then
    local xs = {}
    for k, v in pairs(professDatas) do
      xs[#xs + 1] = v.maxX
    end
    table.sort(xs)
    table.remove(xs, #xs)
    local height = self.comContentPanel.height - 30
    local centerY = self.professGrid.transform.localPosition.y
    for i = 1, #xs do
      local s = GameObject.Instantiate(self.sperate)
      s.transform:SetParent(self.sperate.transform.parent)
      s:SetActive(true)
      s.transform.localScale = Vector3.one
      s.transform.localPosition = Vector3(self:GetX(xs[i] + 3.64), centerY, 0)
      local sp = self:FindGO("SUp", s):GetComponent(UISprite)
      sp.height = height / 2
      sp = self:FindGO("SDown", s):GetComponent(UISprite)
      sp.height = height / 2
      self.sperates[#self.sperates + 1] = s
    end
  end
end
function SkillContentPage:SetProgressScroll(gridXYs, max)
  local datas = self.professDatas
  local progress = 0
  local professData
  self.professesSkillCenterCell = {}
  local stateMax
  for i = 1, #datas do
    professData = gridXYs[datas[i].data.profession]
    if professData ~= nil then
      local centerX = math.ceil((professData.maxX + professData.minX) / 2)
      local x = -centerX * self.cellWidth + self.comContentPanel.width / 2
      if x > 0 then
        x = x - professData.minX * self.cellWidth
      else
        x = x - 120
      end
      self.professesSkillCenterPos[#self.professesSkillCenterPos + 1] = {
        pos = Vector3(x, 0, 0),
        minX = professData.minX,
        maxX = professData.maxX
      }
      stateMax = professData.maxX / max
      self.proContentScroll:AddStateRange(i, progress, stateMax, false)
      progress = stateMax
    end
  end
  local state = self.proContentScroll.state
  self.proContentScroll:CheckState()
  if state == self.proContentScroll.state then
    self:ScrollStateChange(0, state)
  end
end
function SkillContentPage:ScrollStateChange(progress, state)
  if self.professDatas == nil then
    return
  end
  local cellData = self.professDatas[state]
  if cellData ~= self.currentScrollProfessData then
    self.currentScrollProfessData = cellData
  end
  if self.currentScrollProfessData then
    self.container:UpdateTopByProfess(self.currentScrollProfessData.data.profession)
  end
  self:UpdateCurrentProfessSkillPoints()
end
function SkillContentPage:UpdateCurrentProfessSkillPoints()
  if self.currentScrollProfessData then
    self.container:UpdateProfessSkillPoints(self.currentScrollProfessData.points)
  end
end
function SkillContentPage:SetProfessBtns(professes)
  if self.professDatas == nil then
    self.professDatas = {}
    for i = 1, #professes do
      self.professDatas[#self.professDatas + 1] = {
        data = professes[i],
        points = professes[i].points
      }
    end
  end
end
function SkillContentPage:SetEditMode(val)
  if self.isEditMode ~= val then
    self.isEditMode = val
    if val then
      self:Show(self.confirmBtn.gameObject)
      self:Show(self.cancelBtn.gameObject)
    else
      self:Hide(self.confirmBtn.gameObject)
      self:Hide(self.cancelBtn.gameObject)
      self:ResetProfessPoints()
    end
  end
end
function SkillContentPage:ResetProfessPoints()
  if self.professDatas then
    local data
    for i = 1, #self.professDatas do
      data = self.professDatas[i]
      data.points = data.data.points
    end
    self:UpdateCurrentProfessSkillPoints()
  end
end
function SkillContentPage:RefreshPointsAndUpdateCurrent()
  self:RefreshPoints()
  self:UpdateCurrentProfessSkillPoints()
end
function SkillContentPage:RefreshPoints()
  local points
  if self.isEditMode then
    points = FunctionSkillSimulate.Me().totalPoints
  else
    points = self:GetSkillPoint()
  end
  self.leftPointsLabel.text = string.format(ZhString.SkillView_LeftSkillPointText, points)
  FunctionGuide.Me():skillPointCheck(points)
end
function SkillContentPage:OnExit()
  FunctionSkillSimulate.Me():CancelSimulate()
end
function SkillContentPage:CheckNeedShowOverFlow(levelUpSkillIDs)
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
function SkillContentPage:GetSkillPoint()
  local multiSaveId = self.container.multiSaveId
  if multiSaveId ~= nil then
    local point = SaveInfoProxy.Instance:GetUnusedSkillPoint(multiSaveId, self.container.multiSaveType)
    if point ~= nil then
      return point
    end
  end
  return Game.Myself.data.userdata:Get(UDEnum.SKILL_POINT)
end
function SkillContentPage:HandleMyDataChange(note)
  local data = note.body
  if data ~= nil then
    local skillType = ProtoCommon_pb.EUSERDATATYPE_SKILL_POINT
    for i = 1, #data do
      if data[i].type == skillType then
        self:RefreshPoints()
        break
      end
    end
  end
end
