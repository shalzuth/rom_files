local baseCell = autoImport("BaseCell")
JobTreeCell = class("JobTreeCell", baseCell)
local tempVector3 = LuaVector3.zero
function JobTreeCell:Init()
  self:initView()
end
function JobTreeCell:initView()
  self.TopJobNode = self:FindGO("TopJobNode")
  self.TwoBranchLine = self:FindGO("TwoBranchLine")
  self.OneBranchJobEmpty = self:FindGO("OneBranchJobEmpty")
  self.OneBranchLine = self:FindGO("OneBranchLine")
  self.TwoBranchJob = self:FindGO("TwoBranchJob")
  self.TwoBranchJob_l1 = GameObjectUtil.Instance:DeepFindChild(self.TwoBranchJob, "l1")
  self.TwoBranchJob_l2 = GameObjectUtil.Instance:DeepFindChild(self.TwoBranchJob, "l2")
  self.TwoBranchJob_l3 = GameObjectUtil.Instance:DeepFindChild(self.TwoBranchJob, "l3")
  self.TwoBranchJob_r1 = GameObjectUtil.Instance:DeepFindChild(self.TwoBranchJob, "r1")
  self.TwoBranchJob_r2 = GameObjectUtil.Instance:DeepFindChild(self.TwoBranchJob, "r2")
  self.TwoBranchJob_r3 = GameObjectUtil.Instance:DeepFindChild(self.TwoBranchJob, "r3")
  self.TwoBranchJob_LeftTable = {
    self.TwoBranchJob_l1,
    self.TwoBranchJob_l2,
    self.TwoBranchJob_l3
  }
  self.TwoBranchJob_RightTable = {
    self.TwoBranchJob_r1,
    self.TwoBranchJob_r2,
    self.TwoBranchJob_r3
  }
  self.OneBranchJob = self:FindGO("OneBranchJob")
  self.OneBranchJob_c1 = GameObjectUtil.Instance:DeepFindChild(self.OneBranchJob, "c1")
  self.OneBranchJob_c2 = GameObjectUtil.Instance:DeepFindChild(self.OneBranchJob, "c2")
  self.OneBranchJob_c3 = GameObjectUtil.Instance:DeepFindChild(self.OneBranchJob, "c3")
  self.OneBranchJob_CenterTable = {
    self.OneBranchJob_c1,
    self.OneBranchJob_c2,
    self.OneBranchJob_c3
  }
  self.ThisCellJobIconTable = {}
  self.TwoBranchLine_c1_UISprite = GameObjectUtil.Instance:DeepFindChild(self.TwoBranchLine, "c1"):GetComponent(UISprite)
  self.TwoBranchLine_c2_UISprite = GameObjectUtil.Instance:DeepFindChild(self.TwoBranchLine, "c2"):GetComponent(UISprite)
  self.TwoBranchLine_l1_UISprite = GameObjectUtil.Instance:DeepFindChild(self.TwoBranchLine, "l1"):GetComponent(UISprite)
  self.TwoBranchLine_l2_UISprite = GameObjectUtil.Instance:DeepFindChild(self.TwoBranchLine, "l2"):GetComponent(UISprite)
  self.TwoBranchLine_l3_UISprite = GameObjectUtil.Instance:DeepFindChild(self.TwoBranchLine, "l3"):GetComponent(UISprite)
  self.TwoBranchLine_l4_UISprite = GameObjectUtil.Instance:DeepFindChild(self.TwoBranchLine, "l4"):GetComponent(UISprite)
  self.TwoBranchLine_r1_UISprite = GameObjectUtil.Instance:DeepFindChild(self.TwoBranchLine, "r1"):GetComponent(UISprite)
  self.TwoBranchLine_r2_UISprite = GameObjectUtil.Instance:DeepFindChild(self.TwoBranchLine, "r2"):GetComponent(UISprite)
  self.TwoBranchLine_r3_UISprite = GameObjectUtil.Instance:DeepFindChild(self.TwoBranchLine, "r3"):GetComponent(UISprite)
  self.TwoBranchLine_r4_UISprite = GameObjectUtil.Instance:DeepFindChild(self.TwoBranchLine, "r4"):GetComponent(UISprite)
  self.TwoBranchLine_LeftTable = {
    self.TwoBranchLine_l1_UISprite,
    self.TwoBranchLine_l2_UISprite,
    self.TwoBranchLine_l3_UISprite,
    self.TwoBranchLine_l4_UISprite
  }
  self.TwoBranchLine_RightTable = {
    self.TwoBranchLine_r1_UISprite,
    self.TwoBranchLine_r2_UISprite,
    self.TwoBranchLine_r3_UISprite,
    self.TwoBranchLine_r4_UISprite
  }
  self.OneBranchLine_c1_UISprite = GameObjectUtil.Instance:DeepFindChild(self.OneBranchLine, "c1"):GetComponent(UISprite)
  self.OneBranchLine_c2_UISprite = GameObjectUtil.Instance:DeepFindChild(self.OneBranchLine, "c2"):GetComponent(UISprite)
  self.OneBranchLine_c3_UISprite = GameObjectUtil.Instance:DeepFindChild(self.OneBranchLine, "c3"):GetComponent(UISprite)
  self.OneBranchLine_c4_UISprite = GameObjectUtil.Instance:DeepFindChild(self.OneBranchLine, "c4"):GetComponent(UISprite)
  self.OneBranchLine_c5_UISprite = GameObjectUtil.Instance:DeepFindChild(self.OneBranchLine, "c5"):GetComponent(UISprite)
  self.OneBranchLine_Table = {
    self.OneBranchLine_c1_UISprite,
    self.OneBranchLine_c2_UISprite,
    self.OneBranchLine_c3_UISprite,
    self.OneBranchLine_c4_UISprite,
    self.OneBranchLine_c5_UISprite
  }
end
function JobTreeCell:SetData(data)
  self.originid = data.id
  if data.id == 143 then
  else
    self:CreateJobIconUnderThisGameObj(data.id, self.TopJobNode)
  end
  if data and data.AdvanceClass then
    if #data.AdvanceClass == 1 then
      if data.id == 143 then
        self.TwoBranchLine.gameObject:SetActive(false)
        self.TwoBranchJob.gameObject:SetActive(false)
        self.OneBranchLine.gameObject:SetActive(true)
        self.OneBranchJobEmpty.gameObject:SetActive(true)
        self:CreateJobIconUnderThisGameObj(143, self.OneBranchJob_c2)
        self:CreateJobIconUnderThisGameObj(144, self.OneBranchJob_c3)
      else
        self.OneBranchJobEmpty.gameObject:SetActive(false)
        self.OneBranchLine.gameObject:SetActive(true)
        self.TwoBranchLine.gameObject:SetActive(false)
        self.TwoBranchJob.gameObject:SetActive(false)
        self.OneBranchJob.gameObject:SetActive(true)
        self:FullUpJobNodeTableWithStartId(data.AdvanceClass[1], self.OneBranchJob_CenterTable)
      end
    elseif #data.AdvanceClass == 2 then
      self.OneBranchJobEmpty.gameObject:SetActive(false)
      self.OneBranchLine.gameObject:SetActive(false)
      self.TwoBranchLine.gameObject:SetActive(true)
      self.TwoBranchJob.gameObject:SetActive(true)
      self:FullUpJobNodeTableWithStartId(data.AdvanceClass[1], self.TwoBranchJob_LeftTable)
      self:FullUpJobNodeTableWithStartId(data.AdvanceClass[2], self.TwoBranchJob_RightTable)
    elseif #data.AdvanceClass == 3 then
      self.OneBranchJobEmpty.gameObject:SetActive(false)
      self.OneBranchLine.gameObject:SetActive(false)
      if data.id == 41 then
        self.OneBranchJobEmpty.gameObject:SetActive(false)
        self.OneBranchLine.gameObject:SetActive(false)
        self.TwoBranchLine.gameObject:SetActive(true)
        self.TwoBranchJob.gameObject:SetActive(true)
        local rightTable = self:GetRightUpgrateTableForGongJianShou()
        self:FullUpJobNodeTableWithStartId(rightTable[1], self.TwoBranchJob_LeftTable)
        self:FullUpJobNodeTableWithStartId(rightTable[2], self.TwoBranchJob_RightTable)
      end
    end
  else
  end
  self:Update()
end
function JobTreeCell:Update()
  self:UpdateThisCellJobIconState()
  self:UpdateThisCellLineState()
end
function JobTreeCell:FullUpJobNodeTableWithStartId(startid, branchTable)
  for k, v in pairs(branchTable) do
    if startid then
      self:CreateJobIconUnderThisGameObj(startid, v)
      if Table_Class[startid] then
        if Table_Class[startid].AdvanceClass and #Table_Class[startid].AdvanceClass == 1 then
          startid = Table_Class[startid].AdvanceClass[1]
        else
          break
        end
      end
    end
  end
end
function JobTreeCell:GetRightUpgrateTableForGongJianShou()
  local rightTable = {}
  for k, v in pairs(Table_Class[41].AdvanceClass) do
    if Table_Class[v].gender ~= nil and Table_Class[v].gender ~= ProfessionProxy.Instance:GetCurSex() then
    else
      table.insert(rightTable, v)
    end
  end
  return rightTable
end
function JobTreeCell:CreateJobIconUnderThisGameObj(jobid, gameobj)
  local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("ProfessionIconCell"), gameobj)
  obj.transform.localPosition = LuaVector3.zero
  local pCell = ProfessionIconCell.new(obj)
  pCell:SetIcon(jobid)
  pCell:Setid(jobid)
  table.insert(self.ThisCellJobIconTable, pCell)
  return obj
end
function JobTreeCell:UpdateThisCellJobIconState()
  for k, v in pairs(self.ThisCellJobIconTable) do
    local id = v:Getid()
    if id == 1 then
      v:SetState(0, id)
    elseif id % 10 == 1 then
      v:SetState(0, id)
    elseif id % 10 == 2 then
      v:SetState(0, id)
      if ProfessionProxy.Instance:IsThisIdYiGouMai(id) == false and ProfessionProxy.Instance:IsThisIdKeGouMai(id) then
        v:SetState(3, id)
      elseif ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) then
        v:SetState(1, id)
      else
        v:SetState(4, id)
      end
    elseif id % 10 == 3 then
      if id == 143 then
        if ProfessionProxy.Instance:IsThisIdYiGouMai(id) == false and ProfessionProxy.Instance:IsThisIdKeGouMai(id) then
          v:SetState(3, id)
        elseif ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) then
          v:SetState(1, id)
        else
          v:SetState(4, id)
        end
      elseif ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) then
        v:SetState(1, id)
      else
        v:SetState(4, id)
      end
    elseif id % 10 == 4 then
      if ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) then
        v:SetState(1, id)
      else
        v:SetState(4, id)
      end
    end
  end
end
function JobTreeCell:UpdateThisCellLineState()
  local data = Table_Class[self.originid]
  if #data.AdvanceClass == 1 then
    if data.id == 143 then
      self:ChangeLineColorForChaoChu()
    else
      self:ChangeLineColorWithStartIdForOneBranchLine(data.AdvanceClass[1], self.OneBranchLine_Table)
    end
  elseif #data.AdvanceClass == 2 then
    self:ChangeLineColorWithStartId(data.AdvanceClass[1], self.TwoBranchLine_LeftTable)
    self:ChangeLineColorWithStartId(data.AdvanceClass[2], self.TwoBranchLine_RightTable)
  else
    if #data.AdvanceClass == 3 and data.id == 41 then
      local rightTable = self:GetRightUpgrateTableForGongJianShou()
      self:ChangeLineColorWithStartId(rightTable[1], self.TwoBranchLine_LeftTable)
      self:ChangeLineColorWithStartId(rightTable[2], self.TwoBranchLine_RightTable)
    else
    end
  end
end
function JobTreeCell:RecvBuyJob(buyId)
  for k, v in pairs(self.ThisCellJobIconTable) do
    local id = v:Getid()
    if buyId == id then
      v:SetState(4, buyId)
    end
  end
end
function JobTreeCell:ChangeLineColorWithStartIdForOneBranchLine(startid, branchTable)
  for i = 1, 3 do
    if startid then
      if startid % 10 == 2 then
        if self:GetIdState(startid) == 1 then
          branchTable[1].spriteName = "persona_line"
          branchTable[2].spriteName = "persona_line"
          branchTable[3].spriteName = "persona_line"
        else
          branchTable[1].spriteName = "persona_empty-line"
          branchTable[2].spriteName = "persona_empty-line"
          branchTable[3].spriteName = "persona_line"
        end
      elseif startid % 10 == 3 then
        if self:GetIdState(startid) == 1 then
          branchTable[4].spriteName = "persona_line"
        else
          if ProfessionProxy.Instance:ShouldThisIdVisible(startid) then
            branchTable[4].gameObject:SetActive(true)
          else
            branchTable[4].gameObject:SetActive(false)
          end
          branchTable[4].spriteName = "persona_empty-line"
        end
      elseif startid % 10 == 4 then
        if self:GetIdState(startid) == 1 then
          branchTable[5].spriteName = "persona_line"
        else
          if ProfessionProxy.Instance:ShouldThisIdVisible(startid) then
            branchTable[5].gameObject:SetActive(true)
          else
            branchTable[5].gameObject:SetActive(false)
          end
          branchTable[5].spriteName = "persona_empty-line"
        end
        if Table_Class[startid] and Table_Class[startid].IsOpen ~= 1 then
          branchTable[5].gameObject:SetActive(false)
        end
      end
      if Table_Class[startid] then
        if Table_Class[startid].AdvanceClass and #Table_Class[startid].AdvanceClass == 1 then
          startid = Table_Class[startid].AdvanceClass[1]
        elseif Table_Class[startid].AdvanceClass == nil or #Table_Class[startid].AdvanceClass == 0 then
          if startid % 10 == 2 then
            break
          end
          if startid % 10 == 3 then
            branchTable[5].gameObject:SetActive(false)
          end
          break
        end
      end
    end
  end
end
function JobTreeCell:ChangeLineColorForChaoChu()
  if self.originid == 143 then
    if self:GetIdState(143) == 1 then
      self.OneBranchLine_Table[1].spriteName = "persona_line"
      self.OneBranchLine_Table[2].spriteName = "persona_line"
      self.OneBranchLine_Table[3].spriteName = "persona_line"
    else
      self.OneBranchLine_Table[1].spriteName = "persona_empty-line"
      self.OneBranchLine_Table[2].spriteName = "persona_empty-line"
      self.OneBranchLine_Table[3].spriteName = "persona_empty-line"
    end
    if self:GetIdState(144) == 1 then
      self.OneBranchLine_Table[4].spriteName = "persona_line"
    else
      self.OneBranchLine_Table[4].spriteName = "persona_empty-line"
    end
  end
end
function JobTreeCell:ChangeLineColorWithStartId(startid, branchTable)
  for i = 1, 3 do
    if startid then
      if startid % 10 == 2 then
        if self:GetIdState(startid) == 1 then
          branchTable[1].spriteName = "persona_line"
          branchTable[2].spriteName = "persona_line"
        else
          branchTable[1].spriteName = "persona_empty-line"
          branchTable[2].spriteName = "persona_empty-line"
        end
      elseif startid % 10 == 3 then
        if self:GetIdState(startid) == 1 then
          branchTable[3].spriteName = "persona_line"
        else
          if ProfessionProxy.Instance:ShouldThisIdVisible(startid) then
            branchTable[3].gameObject:SetActive(true)
          else
            branchTable[3].gameObject:SetActive(false)
          end
          branchTable[3].spriteName = "persona_empty-line"
        end
      elseif startid % 10 == 4 then
        if self:GetIdState(startid) == 1 then
          branchTable[4].spriteName = "persona_line"
        else
          if ProfessionProxy.Instance:ShouldThisIdVisible(startid) then
            branchTable[4].gameObject:SetActive(true)
          else
            branchTable[4].gameObject:SetActive(false)
          end
          branchTable[4].spriteName = "persona_empty-line"
        end
        if Table_Class[startid].IsOpen ~= 1 then
          branchTable[4].gameObject:SetActive(false)
        end
      end
      if Table_Class[startid] then
        if Table_Class[startid].AdvanceClass and #Table_Class[startid].AdvanceClass == 1 then
          startid = Table_Class[startid].AdvanceClass[1]
        elseif Table_Class[startid].AdvanceClass == nil or #Table_Class[startid].AdvanceClass == 0 then
          if startid % 10 == 2 then
            break
          end
          if startid % 10 == 3 then
            branchTable[4].gameObject:SetActive(false)
          end
          break
        end
      end
    else
    end
  end
end
function JobTreeCell:GetIdState(thisId)
  for k, v in pairs(self.ThisCellJobIconTable) do
    local id = v:Getid()
    if thisId == id then
      return v:GetState()
    end
  end
end
function JobTreeCell:GetIconTable()
  return self.ThisCellJobIconTable or {}
end
function JobTreeCell:OnCellDestroy()
  TableUtility.TableClear(self.ThisCellJobIconTable)
end
