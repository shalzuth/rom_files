autoImport("ServantImproveCell")
autoImport("ImproveGiftCell")
autoImport("RewardListTip")
ServantImproveView = class("ServantImproveView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("ServantImproveView")
ServantImproveView.ColorTheme = {
  [1] = {
    color = LuaColor.New(0.6588235294117647, 0.6588235294117647, 0.6588235294117647, 1)
  },
  [2] = {
    color = LuaColor.New(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
  }
}
local ACTIVITY_TYPE = SceneUser2_pb.EGROWTH_TYPE_TIME_LIMIT
function ServantImproveView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:InitView()
end
function ServantImproveView:InitView()
end
function ServantImproveView:FindObjs()
  local container = self:FindGO("improveView")
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, container, true)
  obj.name = "ServantImproveView"
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.mainTable = self:FindComponent("ImproveTable", UITable)
  self.cellCtl = UIGridListCtrl.new(self.mainTable, ServantImproveCell, "ServantImproveCell")
  self.cellCtl:AddEventListener(MouseEvent.MouseClick, self.ClickChoose, self)
  self.cellCtl:AddEventListener(ServantImproveEvent.TraceBtnClick, self.ClickFunctionBtn, self)
  self.emptySymol = self:FindGO("EmptySymol")
  self.typeLabelList = {}
  self.typeLineList = {}
  local firstTab
  for i = 1, 2 do
    local btnName = "ServantImproveType" .. i
    local typeGo = self:FindGO(btnName)
    self.typeLineList[btnName] = self:FindGO("ImproveChooseImg" .. i)
    self.typeLabelList[btnName] = self:FindComponent("ImproveTypeName" .. i, UILabel)
    self:AddButtonEvent(btnName, function()
      self:TypeChangeHandler(typeGo)
    end)
    if i == 1 then
      firstTab = typeGo
    else
    end
  end
  if firstTab then
    self:TypeChangeHandler(firstTab)
  end
  self.functionPlanList = self:FindGO("FunctionPlanList")
  self:AddButtonEvent("FunctionPlanCloseButton", function()
    self.functionPlanList:SetActive(false)
  end)
  self.planListScrollView = self:FindComponent("PlanListScrollView", UIScrollView)
  self.planListTable = self:FindComponent("PlanListTable", UITable)
  self.planListCtl = UIGridListCtrl.new(self.planListTable, ServantImproveCell, "ServantImproveCell")
  self.planListCtl:AddEventListener(MouseEvent.MouseClick, self.ClickFunclistChoose, self)
  self.planListCtl:AddEventListener(ServantImproveEvent.TraceBtnClick, self.ClickFunctionBtn, self)
  self.luckyScrollView = self:FindComponent("LuckyScrollView", UIScrollView)
  self.giftGrid = self:FindComponent("giftTable", UIGrid)
  self.giftListCtl = UIGridListCtrl.new(self.giftGrid, ImproveGiftCell, "ImproveGiftCell")
  self.giftListCtl:AddEventListener(MouseEvent.LongPress, self.HandleGiftLongPress, self)
  self.luckyProgressBack = self:FindComponent("LuckyProgressBack", UISprite)
  self.luckyProgress = self:FindComponent("LuckyProgress", UISprite)
  function self.luckyScrollView.onDragStarted()
    TipManager.Instance:CloseRewardListTip()
  end
end
function ServantImproveView:AddViewEvts()
  self:AddListenEvt(ServantImproveEvent.FunctionListUpdate, self.UpdateFunctionList)
  self:AddListenEvt(ServantImproveEvent.ItemListUpdate, self.UpdateGroup)
  self:AddListenEvt(ServantImproveEvent.GiftProgressUpdate, self.UpdateGiftProgress)
end
function ServantImproveView:ClickChoose(cell)
  if self.currentExpandCell ~= cell then
    if self.currentExpandCell then
    end
    self.currentExpandCell = cell
  else
  end
  self.currentExpandCell:setSelected(not cell.isSelected)
  self.cellCtl:Layout()
end
function ServantImproveView:HandleGiftLongPress(param)
  local state, cellCtl = param[1], param[2]
  if state then
    self.currentPressCell = cellCtl
    self.startPressTime = ServerTime.CurServerTime()
    if self.tickMg then
      self.tickMg:ClearTick(self)
    else
      self.tickMg = TimeTickManager.Me()
    end
    self.tickMg:CreateTick(0, 100, self.updatePressItemCount, self)
  elseif self.tickMg then
    self.tickMg:ClearTick(self)
    self.tickMg = nil
  end
end
function ServantImproveView:updatePressItemCount()
  local holdTime = ServerTime.CurServerTime() - self.startPressTime
  local changeCount = 1
  if holdTime > 200 then
    local cellData = self.currentPressCell.data
    TipManager.Instance:ShowRewardListTip(cellData, self.currentPressCell.stick, NGUIUtil.AnchorSide.DownRight, {35, 35})
  end
end
function ServantImproveView:ClickFunclistChoose(cell)
  if self.currentExpandFunclistCell ~= cell then
    if self.currentExpandFunclistCell and Slua.IsNull(self.currentExpandFunclistCell.gameObject) == false then
      self.currentExpandFunclistCell:setSelected(false)
    end
    self.currentExpandFunclistCell = cell
    self.currentExpandFunclistCell:setSelected(true)
  else
    self.currentExpandFunclistCell:setSelected(not cell.isSelected)
  end
  self.planListCtl:Layout()
end
function ServantImproveView:ClickFunctionBtn(cell)
  if cell.btnType == 1 then
    self.functionPlanList:SetActive(true)
    self.currentViewGroupId = cell.data.groupid
    self:UpdateGroupItemList()
    self:UpdateGiftProgress()
    self.planListScrollView:ResetPosition()
  elseif cell.btnType == 2 then
    if cell.gotoMode ~= _EmptyTable then
      FuncShortCutFunc.Me():CallByID(cell.gotoMode)
    else
      MsgManager.ShowMsgByID(26010)
    end
  elseif cell.btnType == 3 then
    ServiceNUserProxy.Instance:CallReceiveGrowthServantUserCmd(0, cell.data.dwid)
  elseif cell.btnType == 5 then
    local groupData = Table_ServantImproveGroup[cell.data.groupid]
    if groupData and groupData.nextid then
      ServiceNUserProxy.Instance:CallGrowthOpenServantUserCmd(cell.data.groupid)
    else
      MsgManager.ShowMsgByID(26011)
    end
  end
end
function ServantImproveView:TypeChangeHandler(go)
  if self.currentType ~= go then
    if self.currentType then
      self.typeLineList[self.currentType.name]:SetActive(false)
      self.typeLabelList[self.currentType.name].color = ServantImproveView.ColorTheme[1].color
    end
    self.currentType = go
    local typeName = go.name
    self.typeLineList[typeName]:SetActive(true)
    self.typeLabelList[typeName].color = ServantImproveView.ColorTheme[2].color
    self:LoadTabContent(typeName)
  end
end
function ServantImproveView:LoadTabContent(typeName)
  local tempDataList = {}
  if typeName == "ServantImproveType1" then
    self:UpdateMainItemList()
  else
    self:UpdateFunctionList()
  end
  self.currentExpandCell = nil
end
function ServantImproveView:UpdateGroup()
  self:UpdateMainItemList()
  self:UpdateGroupItemList()
end
function ServantImproveView:UpdateMainItemList()
  if self.currentType and self.currentType.name == "ServantImproveType1" then
    local groupList = ServantRecommendProxy.Instance:GetImproveGroupList()
    table.sort(groupList, function(l, r)
      return self:sort(l, r)
    end)
    self.cellCtl:ResetDatas(groupList)
    self.cellCtl:Layout()
    self.emptySymol:SetActive(false)
  end
end
function ServantImproveView:sort(l, r)
  if l == nil or r == nil then
    return false
  end
  local lType = Table_ServantImproveGroup[l.groupid].type
  local rType = Table_ServantImproveGroup[r.groupid].type
  if lType == ACTIVITY_TYPE or rType == ACTIVITY_TYPE then
    return lType == ACTIVITY_TYPE
  end
  return lType < rType
end
function ServantImproveView:UpdateFunctionList()
  if self.currentType and self.currentType.name == "ServantImproveType2" then
    local growthList = ServantRecommendProxy.Instance:GetImproveFunctionList()
    local functionlist = {}
    for i = 1, #growthList do
      local growthItem = Table_Growth[growthList[i]]
      if growthItem and #growthItem.unlockfunction > 0 then
        local unlock = growthItem.unlockfunction
        for j = 1, #unlock do
          functionlist[#functionlist + 1] = unlock[j]
        end
      end
    end
    if #functionlist > 0 then
      self.cellCtl:ResetDatas(functionlist)
      self.cellCtl:Layout()
      self.emptySymol:SetActive(false)
    else
      self.cellCtl:ResetDatas(functionlist)
      self.emptySymol:SetActive(true)
    end
  end
end
function ServantImproveView:UpdateGroupItemList()
  local groupData = ServantRecommendProxy.Instance:GetImproveGroup(self.currentViewGroupId)
  if groupData and groupData.itemList and #groupData.itemList > 0 then
    local itemList = groupData.itemList
    table.sort(groupData.itemList, function(l, r)
      local growthDataL = Table_Growth[l.dwid]
      local growthDataR = Table_Growth[r.dwid]
      if l.status == r.status then
        return growthDataL.sort < growthDataR.sort
      else
        return l.status < r.status
      end
    end)
    local recieveList = {}
    local noneRecieveList = {}
    local lockList = {}
    for i = 1, #itemList do
      if itemList[i].status == SceneUser2_pb.EGROWTH_STATUS_MIN then
        local growthData = Table_Growth[itemList[i].dwid]
        if growthData and growthData.unlock_desc ~= "" then
          lockList[#lockList + 1] = itemList[i]
        end
      elseif itemList[i].status == SceneUser2_pb.EGROWTH_STATUS_RECEIVE then
        recieveList[#recieveList + 1] = itemList[i]
      else
        noneRecieveList[#noneRecieveList + 1] = itemList[i]
      end
    end
    for i = 1, #noneRecieveList do
      recieveList[#recieveList + 1] = noneRecieveList[i]
    end
    for i = 1, #lockList do
      recieveList[#recieveList + 1] = lockList[i]
    end
    self.planListCtl:ResetDatas(recieveList)
  end
end
function ServantImproveView:UpdateGiftProgress()
  local groupData = ServantRecommendProxy.Instance:GetImproveGroup(self.currentViewGroupId)
  if groupData then
    local totalGrowthValue = self:GetGroupTotalGrowth(groupData.groupid)
    local currentProgress = groupData.growth or 0
    local growthReward = GameConfig.Servant.growth_reward[groupData.groupid]
    self.luckyProgressBack.width = totalGrowthValue * 5
    self.luckyProgress.width = currentProgress * 5
    self.luckyProgress.gameObject:SetActive(currentProgress ~= 0)
    self.giftListCtl:ResetDatas(growthReward)
    local cells = self.giftListCtl:GetCells()
    for i = 1, #cells do
      cells[i]:UpdateGiftState(groupData)
    end
    self.giftListCtl:Layout()
    self:UpdateMainItemList()
  end
end
function ServantImproveView:GetGroupTotalGrowth(groupId)
  local totalGrowth = 0
  for k, v in pairs(Table_Growth) do
    local tGid = math.floor(k / 1000)
    if tGid == groupId then
      totalGrowth = totalGrowth + v.Growth
    end
  end
  return totalGrowth
end
