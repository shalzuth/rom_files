EquipRecommendMainNew = class("EquipRecommendMainNew", SubView)
autoImport("TeamCell")
autoImport("TeamGoalCombineCellForER")
autoImport("ERCell")
autoImport("AdventureResearchCategoryCell")
autoImport("AdventureResearchDescriptionCell")
autoImport("AdventureResearchCombineItemCellForER")
autoImport("Charactor")
autoImport("AdventureResearchPage")
autoImport("SetQuickItemCell")
local View_Path = ResourcePathHelper.UIView("EquipRecommendMainNew")
EquipRecommendMainNew.ERCellRes = ResourcePathHelper.UICell("ERCell")
local tempVector3 = LuaVector3.zero
function EquipRecommendMainNew:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:InitView()
end
function EquipRecommendMainNew:InitView()
  self:Show()
  ServiceNUserProxy.Instance:CallServantRecEquipUserCmd({nil})
end
function EquipRecommendMainNew:OnEnter()
end
function EquipRecommendMainNew:FindObjs()
  local container = self:FindGO("ServantImproveViewNew")
  self.gameObject = self:LoadPreferb_ByFullPath(View_Path, container, true)
  self.gameObject:SetActive(true)
  self.JobClassScrollView = self:FindGO("JobClassScrollView", self.gameObject)
  self.JobClassTabel = self:FindGO("JobClassTabel", self.JobClassScrollView)
  local goalslist = self.JobClassTabel:GetComponent(UITable)
  self.goalListCtl = UIGridListCtrl.new(goalslist, TeamGoalCombineCellForER, "TeamGoalCombineCellForER")
  self.goalListCtl:AddEventListener(MouseEvent.MouseClick, self.ClickGoal, self)
  self.TeamScroll = self:FindGO("TeamScroll", self.gameObject)
  self.TeamScroll_UIPanel = self.TeamScroll:GetComponent(UIPanel)
  self.TeamList = self:FindGO("TeamList", self.TeamScroll)
  self.teamTable = self.TeamList:GetComponent(UITable)
  self.teamListCtl = UIGridListCtrl.new(self.teamTable, ERCell, "ERCell")
  self.teamListCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickERCell, self)
  local branchTable = self:GetFatherTable()
  self.goalListCtl:ResetDatas(branchTable)
  local goalCells = self.goalListCtl:GetCells()
  if goalCells and #goalCells > 0 then
    for i = 1, #goalCells do
      local goalData = goalCells[i].data
      if goalData and goalData.fatherGoal.id == self.startGoal then
        goalCells[i]:ClickFather()
        break
      end
    end
    goalCells[1]:ClickFather()
    goalCells[1]:ClickChild()
  end
  self.TanChu = self:FindGO("TanChu")
  self.TanChu.gameObject:SetActive(false)
  self.TanChu_Close = self:FindGO("Close", self.TanChu)
  self.TanChu_UIPanel = self.TanChu:GetComponent(UIPanel)
  self:AddClickEvent(self.TanChu_Close, function()
    self.TanChu.gameObject:SetActive(false)
  end)
  self.ResearchItemList = self:FindGO("ResearchItemList", self.TanChu)
  self.ItemScrollView = self:FindGO("ItemScrollView", self.ResearchItemList)
  self.itemContainer = self:FindGO("bag_itemContainer", self.ItemScrollView)
  self.itemContainer.gameObject.transform.localScale = Vector3(0.8, 0.8, 1)
  local pfbNum = 6
  local rt = Screen.height / Screen.width
  if rt > 0.5625 then
    pfbNum = 10
  end
  local wrapConfig = {
    wrapObj = self.itemContainer,
    pfbNum = pfbNum,
    cellName = "AdventureBagCombineItemCell",
    control = AdventureResearchCombineItemCellForER,
    dir = 1
  }
  self.wraplist = WrapCellHelper.new(wrapConfig)
  self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.ItemWraperScrollView = self.ItemScrollView:GetComponent(ROUIScrollView)
  function self.ItemWraperScrollView.OnStop()
    self.ItemWraperScrollView:Revert()
  end
  self.tipHolder = self:FindComponent("ScrollBg", UIWidget, self.ResearchItemList)
  self.TanChu_ERCellPoint = self:FindGO("ERCellPoint", self.TanChu)
  local obj = Game.AssetManager_UI:CreateAsset(EquipRecommendMainNew.ERCellRes, self.TanChu_ERCellPoint)
  self.TanChu_ERCell = ERCell.new(obj)
  self.TanChu_ERCell.gameObject.transform.localPosition = Vector3(0, 0, 0)
  self.TanChu_TipPoint = self:FindGO("TipPoint", self.TanChu)
  self.TanChu_TipPoint_UIWidget = self.TanChu_TipPoint:GetComponent(UIWidget)
  local allItemCells = self.wraplist:GetCellCtls()
  for k, v in pairs(allItemCells) do
    local cells = v:GetCells()
    for m, n in pairs(cells) do
      n:CanDrag(true)
    end
  end
  if not self.targetCell then
    local headCellObj = self:FindGO("PortraitCell")
    self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId, headCellObj)
    tempVector3:Set(0, 0, 0)
    self.headCellObj.transform.localPosition = tempVector3
    self.targetCell = PlayerFaceCell.new(self.headCellObj)
    self.targetCell:HideLevel()
    self.targetCell:HideHpMp()
  end
  local headData = HeadImageData.new()
  headData:TransByLPlayer(Game.Myself)
  headData.frame = nil
  headData.job = nil
  self.targetCell:SetData(headData)
  self.TanChu_FilterCondition = self:FindGO("FilterCondition", self.TanChu)
  self.FilterCondition = self.TanChu_FilterCondition:GetComponent(UIToggle)
  self.FilterConditionLabel = self:FindComponent("Label", UILabel, self.FilterCondition.gameObject)
  self.FilterConditionLabel.text = "\229\189\147\229\137\141\232\129\140\228\184\154"
  self:AddClickEvent(self.FilterCondition.gameObject, function(obj)
    self.professionSelected = self.FilterCondition.value
    self:tabClick(self.selectTabData)
  end)
  local cellCtrl = self.TanChu_ERCell:Get_EquipRecommendGrid_UIGridListCtrl()
  local cells = cellCtrl:GetCells()
  cellCtrl:AddEventListener(SetQuickItemCell.SwapObj, self.SetQuickUseFunc, self)
  self.rightbtn1 = self:FindGO("rightbtn1", self.TanChu)
  self.rightbtn2 = self:FindGO("rightbtn2", self.TanChu)
  self:AddClickEvent(self.rightbtn1.gameObject, function(obj)
    if self.CurrentTanChuERCellId then
      self.TanChu_ERCell:SetData(Table_Equip_recommend[self.CurrentTanChuERCellId])
      local cellCtrl = self.TanChu_ERCell:Get_EquipRecommendGrid_UIGridListCtrl()
      local cells = cellCtrl:GetCells()
      for k, v in pairs(cells) do
        v:SetQuickPos(k)
        v:RemoveUIDragScrollView()
      end
    end
  end)
  self:AddClickEvent(self.rightbtn2.gameObject, function(obj)
    local ServantEquipItemData
    if NetConfig.PBC then
      ServantEquipItemData = {}
    else
      ServantEquipItemData = SceneUser2_pb.ServantEquipItem()
    end
    ServantEquipItemData.id = self.CurrentTanChuERCellId
    local cellCtrl = self.TanChu_ERCell:Get_EquipRecommendGrid_UIGridListCtrl()
    local cells = cellCtrl:GetCells()
    for k, v in pairs(cells) do
      local vid = v:GetEquipId()
      ServantEquipItemData.equipid[#ServantEquipItemData.equipid + 1] = vid
    end
    MsgManager.ShowMsgByIDTable(34009)
    ServiceNUserProxy.Instance:CallServantRecEquipUserCmd({ServantEquipItemData})
  end)
  self.SearchButton = self:FindGO("SearchButton", self.TanChu)
  self.ContentInput = self:FindGO("ContentInput", self.TanChu)
  self.ContentInput_UIInput = self.ContentInput:GetComponent(UIInput)
  self:AddClickEvent(self.SearchButton.gameObject, function(g)
    if #self.ContentInput_UIInput.value > 0 then
      self:UpdateContent()
    elseif self.datasForTanChu then
      self:SetData(self.datasForTanChu)
    end
  end)
  self.NameForJob = self:FindGO("NameForJob")
  self.NameForJob_UILabel = self.NameForJob:GetComponent(UILabel)
  local jobid = MyselfProxy.Instance:GetMyProfession()
  if self.NameForJob_UILabel == nil then
    helplog("if self.NameForJob_UILabel ==nil then")
  end
  if Table_Class[jobid] == nil then
    helplog("!jobid:" .. jobid .. "\232\191\153\228\184\170\232\129\140\228\184\154\229\156\168\232\191\153\228\184\170\231\142\175\229\162\131\230\152\175\230\178\161\230\156\137\231\154\132\239\188\129")
  else
    self.NameForJob_UILabel.text = Table_Class[jobid].NameZh
  end
  self.NameForZhuan = self:FindGO("NameForZhuan")
  self.NameForZhuan_UILabel = self.NameForZhuan:GetComponent(UILabel)
  local gewei = jobid % 10
  if jobid == 1 then
    self.NameForZhuan_UILabel.text = ""
  elseif gewei == 1 then
    self.NameForZhuan_UILabel.text = "\228\184\128\232\189\172\232\129\140\228\184\154"
  elseif gewei == 2 then
    self.NameForZhuan_UILabel.text = "\228\186\140\232\189\172\232\129\140\228\184\154"
  else
    self.NameForZhuan_UILabel.text = "\228\184\137\232\189\172\232\129\140\228\184\154"
  end
  self.joblv = self:FindGO("joblv")
  self.joblv_Label = self:FindGO("Label", self.joblv)
  self.joblv_Label_UILabel = self.joblv_Label:GetComponent(UILabel)
  local lv = MyselfProxy.Instance:JobLevel()
  local userdata = Game.Myself.data.userdata
  local baseLv = userdata:Get(UDEnum.ROLELEVEL)
  local jobLv = userdata:Get(UDEnum.JOBLEVEL)
  self.joblv_Label_UILabel.text = baseLv
  self.rightTop = self:FindGO("rightTop")
  self:AddClickEvent(self.rightTop.gameObject, function(obj)
    local data = Table_Help[30002]
    if data then
      TipsView.Me():ShowGeneralHelp(data.Desc)
    end
  end)
  self:AddListenEvt(ServiceEvent.NUserServantRecEquipUserCmd, self.RecEquipUserCmd)
end
function EquipRecommendMainNew:UpdateContent()
  local data = self:GetExchangeSearchContent(self.ContentInput_UIInput.value)
  if #data > 0 then
    self:SetData(data, noResetPos)
  else
    MsgManager.ShowMsgByID(34005)
  end
end
local searchContent = {}
function EquipRecommendMainNew:GetExchangeSearchContent(keyword)
  TableUtility.ArrayClear(searchContent)
  keyword = string.lower(keyword)
  local tempName
  if self.datasForTanChu ~= nil then
    for k, v in pairs(self.datasForTanChu) do
      if v.staticData.NameZh then
        tempName = string.lower(v.staticData.NameZh)
        if string.find(tempName, keyword) then
          table.insert(searchContent, v)
        end
      end
    end
  else
  end
  return searchContent
end
function EquipRecommendMainNew:RecEquipUserCmd(param)
  self.ERDatsFromServer = {}
  for i = 1, #param.body.datas do
    local v = param.body.datas[i]
    local t = {}
    t.id = v.id
    t.equipid = {}
    for j = 1, #v.equipid do
      local n = v.equipid[j]
      t.equipid[#t.equipid + 1] = n
    end
    table.insert(self.ERDatsFromServer, t)
  end
  self:UpdateUI()
end
function EquipRecommendMainNew:UpdateUI()
  local cells = self.teamListCtl:GetCells()
  for k, v in pairs(cells) do
    v:ChangeScrollViewDepth(self.TeamScroll_UIPanel.depth + 1)
    local erid = v:GetTableERid()
    if self.ERDatsFromServer then
      for m, n in pairs(self.ERDatsFromServer) do
        if n.id == erid then
          local newData = {}
          newData.id = erid
          newData.branch = Table_Equip_recommend[erid].branch
          newData.genre = Table_Equip_recommend[erid].genre
          newData.equip = n.equipid
          v:SetData(newData)
        else
        end
      end
    end
    local cellCtrl = v:Get_EquipRecommendGrid_UIGridListCtrl()
    local e_cells = cellCtrl:GetCells()
    for m, n in pairs(e_cells) do
      n:CanDrag(false)
    end
  end
end
function EquipRecommendMainNew:SetQuickUseFunc(param)
  local surcData = param.surce.itemdata
  local surcPos = param.surce.pos
  local targetPos = param.target.pos
  local keys = {}
  local key = {
    guid = surcData.id,
    type = surcData.staticData.id,
    pos = targetPos - 1
  }
  table.insert(keys, key)
  local targetEId = param.target.data.staticData.id
  local tempItem = ItemData.new("", param.surce.itemdata.staticData.id)
  param.target:SetData(tempItem)
  if surcPos then
    helplog("\229\156\168\229\191\171\230\141\183\230\160\143\228\186\146\230\141\162\230\131\133\229\134\181\228\184\139 \231\155\174\230\160\135\229\191\171\230\141\183\230\160\143\230\156\137\230\149\176\229\128\188")
    local targetData = param.target.data
    local targetId, typeId
    if targetData then
      targetId = targetData.id
      typeId = targetData.staticData.id
    end
    local key2 = {
      guid = targetId,
      type = typeId,
      pos = surcPos - 1
    }
    table.insert(keys, key2)
    local tempItem = ItemData.new("", targetEId)
    local cellCtrl = self.TanChu_ERCell:Get_EquipRecommendGrid_UIGridListCtrl()
    local cells = cellCtrl:GetCells()
    for k, v in pairs(cells) do
      if k == param.surce.pos then
        v:SetData(tempItem)
      end
    end
  end
end
function EquipRecommendMainNew:SetData(datas, noResetPos)
  datas = datas or {}
  self:resetSelectState(datas, noResetPos)
  local newdata = self:ReUnitData(datas, 10)
  self.wraplist:UpdateInfo(newdata)
  self.selectData = nil
  local defaultItem = self:getDefaultSelectedItemData()
  if not noResetPos then
    self.wraplist:ResetPosition()
  end
end
function EquipRecommendMainNew:ClearSelectData()
  if self.chooseItemData then
    self.chooseItemData:setIsSelected(false)
  end
  if self.chooseItem then
    self.chooseItem:setIsSelected(false)
  end
  self.chooseItem = nil
  self.chooseItemData = nil
end
function EquipRecommendMainNew:resetSelectState(datas, noResetPos)
  if not noResetPos and self.gameObject.activeSelf then
    self.wraplist:ResetPosition()
    if self.chooseItem and self.chooseItemData then
      self.chooseItemData:setIsSelected(false)
      self.chooseItem:setIsSelected(false)
    end
    self:ClearSelectData()
  end
end
function EquipRecommendMainNew:GetItemCells()
  local combineCells = self.wraplist:GetCellCtls()
  local result = {}
  for i = 1, #combineCells do
    local v = combineCells[i]
    local childs = v:GetCells()
    for i = 1, #childs do
      table.insert(result, childs[i])
    end
  end
  return result
end
function EquipRecommendMainNew:getDefaultSelectedItemData()
  local cells = self:GetItemCells() or {}
  if #cells > 0 then
    if self.chooseItemData then
      for i = 1, #cells do
        local single = cells[i]
        if single.data then
          return single
        end
      end
    else
      for i = 1, #cells do
        local cell = cells[i]
        if cell.data then
          return cell
        end
      end
    end
  end
end
function EquipRecommendMainNew:tabClick(selectTabData, noResetPos)
  if not self.data then
    helplog("if(not self.data)then")
    return
  end
  self.selectTabData = selectTabData
  if self.data.staticData.id == AdventureResearchPage.DataFromMenuId then
    self:Hide(self.ResearchItemList)
    self:Show(self.ResearchDescriptionList)
    local descDatas = {}
    for k, v in pairs(Table_GameFunction) do
      table.insert(descDatas, v)
    end
    table.sort(descDatas, function(l, r)
      return l.Order < r.Order
    end)
    table.sort(descDatas, function(l, r)
      if FunctionUnLockFunc.Me():CheckCanOpen(l.MenuID) and FunctionUnLockFunc.Me():CheckCanOpen(r.MenuID) then
        return l.Order < r.Order
      elseif FunctionUnLockFunc.Me():CheckCanOpen(l.MenuID) then
        return true
      else
        return false
      end
    end)
    self.descriptionGrid:ResetDatas(descDatas)
  else
    self.datasForTanChu = nil
    self.datasForTanChu = {}
    if selectTabData and selectTabData.id ~= AdventureItemNormalListPage.MaxCategory.id then
      self.datasForTanChu = AdventureDataProxy.Instance:getItemsByCategoryAndClassifyNew(self.data.staticData.id, self.professionSelected, selectTabData.id, self.currentJobId)
    else
      self.datasForTanChu = AdventureDataProxy.Instance:getItemsByCategoryAndClassifyNew(self.data.staticData.id, self.professionSelected, nil, self.currentJobId)
    end
    for i = #self.datasForTanChu, 1, -1 do
      local data = self.datasForTanChu[i]
      if self:IsThisLock(data) then
        table.remove(self.datasForTanChu, i)
      end
    end
    self:SetData(self.datasForTanChu, noResetPos)
  end
end
function EquipRecommendMainNew:IsThisLock(data)
  local status = true
  if data.type == SceneManual_pb.EMANUALTYPE_EQUIP then
    status = AdventureDataProxy.Instance:checkEquipIsUnlock(data.staticId)
  elseif data.type == SceneManual_pb.EMANUALTYPE_HAIRSTYLE or data.type == SceneManual_pb.EMANUALTYPE_ITEM then
    status = AdventureDataProxy.Instance:checkShopItemIsUnlock(data.staticId)
  elseif data.type == SceneManual_pb.EMANUALTYPE_MATE then
    status = AdventureDataProxy.Instance:checkMercenaryCatIsUnlock(data:getCatId())
  end
  status = not status
  return status
end
function EquipRecommendMainNew:setCategoryData(data)
  self.data = data
  local list = {}
  if data and data.classifys and #data.classifys > 0 then
    for i = 1, #data.classifys do
      local single = data.classifys[i]
      table.insert(list, single)
    end
    table.sort(list, function(l, r)
      return l.Order < r.Order
    end)
    self:tabClick()
    if data.staticData.id == AdventureResearchPage.ShowFilterConditionId then
      self:Show(self.FilterCondition.gameObject)
    else
      self:Hide(self.FilterCondition.gameObject)
    end
  else
    self:Hide(self.FilterCondition.gameObject)
    self:tabClick()
  end
end
function EquipRecommendMainNew:ReUnitData(datas, rowNum)
  if not self.unitData then
    self.unitData = {}
  else
    TableUtility.ArrayClear(self.unitData)
  end
  if datas ~= nil and #datas > 0 then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / rowNum) + 1
      local i2 = math.floor((i - 1) % rowNum) + 1
      self.unitData[i1] = self.unitData[i1] or {}
      if datas[i] == nil then
        self.unitData[i1][i2] = nil
      else
        self.unitData[i1][i2] = datas[i]
      end
    end
  end
  return self.unitData
end
function EquipRecommendMainNew:HandleClickItem(cellCtl, noClickSound)
  if cellCtl and cellCtl.data then
    local data = cellCtl.data
    if self.chooseItem ~= cellCtl or data ~= self.chooseItemData then
      if self.chooseItemData then
        self.chooseItemData:setIsSelected(false)
      end
      if self.chooseItem then
        self.chooseItem:setIsSelected(false)
      end
      if not noClickSound then
        self:PlayUISound(AudioMap.UI.Click)
      end
      data:setIsSelected(true)
      cellCtl:setIsSelected(true)
      self:ShowItemTip(data, self.TanChu_TipPoint_UIWidget)
      self.chooseItem = cellCtl
      self.chooseItemData = data
    elseif self.chooseItem == cellCtl or data == self.chooseItemData then
      self:ClearSelectData()
    end
  end
end
function EquipRecommendMainNew:ShowItemTip(data, go)
  go = go or self.tipHolder
  if data.type == SceneManual_pb.EMANUALTYPE_MATE then
    TipManager.Instance:ShowCatTipById(data:getCatId(), go, NGUIUtil.AnchorSide.Right, {200, 0})
  else
    local item = ItemData.new(data.id, data.staticId)
    TipManager.Instance:ShowFormulaTip(item, go, NGUIUtil.AnchorSide.Right, {200, 347})
  end
end
function EquipRecommendMainNew:OnClickERCell(data)
  self.categorys = AdventureDataProxy.Instance:getTabsByCategory(SceneManual_pb.EMANUALTYPE_RESEARCH)
  local list = {}
  for k, v in pairs(self.categorys.childs) do
    table.insert(list, v)
  end
  table.sort(list, function(l, r)
    return l.staticData.Order < r.staticData.Order
  end)
  if list and #list > 0 then
    self:setCategoryData(list[1])
  end
  self.TanChu.gameObject:SetActive(true)
  if data.data ~= nil then
    self.TanChu_ERCell:SetData(data.data)
    self.TanChu_ERCell:ProcessForTanChu()
    self.TanChu_ERCell:ChangeScrollViewDepth(self.TanChu_UIPanel.depth + 1)
    self.TanChu_ERCell:ShowBG2()
    self.CurrentTanChuERCellId = data.data.id
    local cellCtrl = self.TanChu_ERCell:Get_EquipRecommendGrid_UIGridListCtrl()
    local cells = cellCtrl:GetCells()
    for k, v in pairs(cells) do
      v:SetQuickPos(k)
      v:RemoveUIDragScrollView()
    end
    local job_branch = Table_Equip_recommend[self.CurrentTanChuERCellId].branch
    self.currentJobId = 0
    for k, v in pairs(Table_Class) do
      if v.TypeBranch == job_branch and v.id % 10 == 2 then
        self.currentJobId = v.id
      end
    end
  end
end
function EquipRecommendMainNew:GetFatherTable()
  local branchTable = {}
  for k, v in pairs(Table_Equip_recommend) do
    branchTable[v.branch] = v.branch
  end
  local fatherTable = {}
  local branchTypeTable = {}
  for k, v in pairs(branchTable) do
    local branchType = self:GetTableClassTypeFromBranch(v)
    branchTypeTable[branchType] = branchType
  end
  for k, v in pairs(branchTypeTable) do
    for m, n in pairs(Table_Class) do
      if n.id % 10 == 1 and n.Type == v then
        local newGoal = {}
        newGoal.fatherGoal = Table_Class[n.id]
        newGoal.childGoals = {}
        table.insert(fatherTable, newGoal)
      end
    end
  end
  for k, v in pairs(branchTable) do
    for m, n in pairs(fatherTable) do
      local fathertype = n.fatherGoal.Type
      local thisBranchGettype = self:GetTableClassTypeFromBranch(v)
      if fathertype == thisBranchGettype then
        local data = self:GetTableClassDataFromBranch(v)
        table.insert(n.childGoals, data)
      end
    end
  end
  table.sort(fatherTable, function(a, b)
    return a.fatherGoal.id < b.fatherGoal.id
  end)
  return fatherTable
end
function EquipRecommendMainNew:GetTableClassTypeFromBranch(branchId)
  for k, v in pairs(Table_Class) do
    if v.TypeBranch == branchId then
      return v.Type
    end
  end
  return 0
end
function EquipRecommendMainNew:GetTableClassDataFromBranch(branchId)
  for k, v in pairs(Table_Class) do
    if v.TypeBranch == branchId and v.id % 10 ~= 1 then
      return v
    end
  end
  return {}
end
function EquipRecommendMainNew:_resetCurCombine()
  if self.combineGoal then
    self.combineGoal:SetChoose(false)
    self.combineGoal:SetFolderState(false)
    self.combineGoal = nil
  end
end
function EquipRecommendMainNew:ClickGoal(parama)
  helplog("EquipRecommendMainNew:ClickGoal(parama)")
  if "Father" == parama.type then
    local combine = parama.combine
    if combine == self.combineGoal then
      combine:PlayReverseAnimation()
      return
    end
    self:_resetCurCombine()
    self.combineGoal = combine
    self.combineGoal:PlayReverseAnimation()
    self.fatherGoalId = combine.data.fatherGoal.id
    self.goal = self.fatherGoalId
  elseif parama.child and parama.child.data then
    self.goal = parama.child.data.id
    local tableForRight = {}
    for k, v in pairs(Table_Equip_recommend) do
      if v.branch == parama.child.data.TypeBranch then
        table.insert(tableForRight, v)
      end
    end
    self.teamListCtl:ResetDatas()
    self.teamListCtl:ResetDatas(tableForRight)
    self:UpdateUI()
    local cells = self.teamListCtl:GetCells()
    for k, v in pairs(cells) do
      v:ChangeScrollViewDepth(self.TeamScroll_UIPanel.depth + 1)
      local cellCtrl = v:Get_EquipRecommendGrid_UIGridListCtrl()
      local e_cells = cellCtrl:GetCells()
      for m, n in pairs(e_cells) do
        n:CanDrag(false)
      end
    end
  else
    self.goal = self.fatherGoalId
  end
end
function EquipRecommendMainNew:ResetTeamMembers()
  local cells = self.teamListCtl:GetCells()
  if cells then
    for i = 1, #cells do
      self:Hide(cells[i].listGrid)
    end
    self.teamListCtl:Layout()
  end
end
function EquipRecommendMainNew:HandleApplyCt()
  local cells = self.teamListCtl:GetCells()
  for i = 1, #cells do
    local ctDate = TeamProxy.Instance:GetUserApply(cells[i].data.id)
    cells[i]:CountDown(ctDate)
  end
end
function EquipRecommendMainNew:AddViewEvts()
end
function EquipRecommendMainNew:SelfShow()
  self.gameObject:SetActive(true)
  self:InitView()
end
function EquipRecommendMainNew:initData()
end
function EquipRecommendMainNew:SelfHide()
  self.gameObject:SetActive(false)
end
