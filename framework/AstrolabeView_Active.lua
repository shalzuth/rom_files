local tempV3 = LuaVector3()
local NumThousandFormat = StringUtil.NumThousandFormat
local PathChooseOption = {
  {
    ZhString.AstrolabeView_Simulation_SPPath,
    FunctionAstrolabe.SearchType.Path
  },
  {
    ZhString.AstrolabeView_Simulation_SPGold,
    FunctionAstrolabe.SearchType.Gold
  }
}
autoImport("AstrolabeView_SearchPointCell")
local tempColor = LuaColor.New(1, 1, 1, 1)
local localSaveProxy
function AstrolabeView:InitActive()
  localSaveProxy = LocalSaveProxy.Instance
  self.handlePointsMap = {}
  self.handlePointsList = {}
  self.savePointsMap = {}
  self.inSaveModePriStateMap = {}
  self:MapActiveEvent()
  self:InitActiveInfo()
  self:InitResetInfo()
  self:InitSimulateInfo()
end
function AstrolabeView:InitActiveInfo()
  self.activeInfo = self:FindGO("ActiveBriefInfo")
  self.activeInfoTween = self.activeInfo:GetComponent(UIPlayTween)
  self.activeButtonGO = self:FindGO("ActiveButton", self.activeInfo)
  self.activeButton_label = self:FindComponent("Label", UILabel, self.activeButtonGO)
  self:AddClickEvent(self.activeButtonGO, function()
    self:ClickActiveButton()
  end)
  self.activeBord = self:FindGO("ActiveBord")
  self.activeBord_ConfirmButton = self:FindGO("ConfirmButton", self.activeBord)
  self.activeBord_ConfirmButton_Sp = self.activeBord_ConfirmButton:GetComponent(UISprite)
  self.activeBord_ConfirmButton_Collider = self.activeBord_ConfirmButton:GetComponent(BoxCollider)
  self.activeBord_ConfirmButton_Sprite = self:FindComponent("Sprite", UISprite, self.activeBord_ConfirmButton)
  self.activeBord_CancelButton = self:FindGO("CancelButton", self.activeBord)
  self.activeBord_ActivePoint = self:FindComponent("ActivePoint", UILabel, self.activeBord)
  self.activeBord_ReturnGold = self:FindComponent("CostGold", UILabel, self.activeBord)
  local activeBord_SymbolGold = self:FindComponent("SymbolGold", UISprite)
  IconManager:SetItemIcon("item_5261", activeBord_SymbolGold, self.activeBord)
  self:AddClickEvent(self.activeBord_ConfirmButton, function()
    if self.inSaveMode then
      self:DoServerSave()
    else
      self:DoServerActive()
    end
  end)
  self:AddClickEvent(self.activeBord_CancelButton, function()
    self:ResetHandlePointsInfo()
    self.waitCancelChooseOnect = true
  end)
end
function AstrolabeView:InitResetInfo()
  self.resetBord = self:FindGO("ResetBord")
  self.resetBord_ConfirmButton = self:FindGO("ConfirmButton", self.resetBord)
  self.resetBord_ConfirmButton_Sp = self.resetBord_ConfirmButton:GetComponent(UISprite)
  self.resetBord_ConfirmButton_Collider = self.resetBord_ConfirmButton:GetComponent(BoxCollider)
  self.resetBord_ConfirmButton_Sprite = self:FindComponent("Sprite", UISprite, self.resetBord_ConfirmButton)
  self.resetBord_CancelButton = self:FindGO("CancelButton", self.resetBord)
  self.resetBord_ResetPoint = self:FindComponent("ResetPoint", UILabel, self.resetBord)
  self.resetBord_CostZeny = self:FindComponent("CostZeny", UILabel, self.resetBord)
  self:AddClickEvent(self.resetBord_ConfirmButton, function()
    self:DoServerReset()
  end)
  self:AddClickEvent(self.resetBord_CancelButton, function()
    self:ResetHandlePointsInfo()
    self.waitCancelChooseOnect = true
  end)
end
function AstrolabeView:InitSimulateInfo()
  self.helpGO = self:FindGO("HelpButton")
  self.simulateButton = self:FindGO("SimulateButton")
  local simulateButton_Label = self:FindComponent("Label", UILabel, self.simulateButton)
  simulateButton_Label.text = ZhString.AstrolabeView_Simulation_EnterSaveMode
  self.handleState = AstrolabeView.HandleSate.None
  self:AddClickEvent(self.simulateButton, function(go)
    self:ResetHandlePointsInfo(true)
    if self.inSaveMode then
      self.inSaveMode = not self.inSaveMode
      self:HideAndResetSimulateSaveInfo()
      simulateButton_Label.text = ZhString.AstrolabeView_Simulation_EnterSaveMode
    else
      self.inSaveMode = not self.inSaveMode
      self:ShowAndUpdateSimulateSaveInfo()
      simulateButton_Label.text = ZhString.AstrolabeView_Simulation_ExitSaveMode
    end
    self:ShowOrHidePointActiveInfo()
  end)
  self.simulateInfoGO = self:FindGO("SimulateInfo", self.activeInfo)
  self.simulateBord = self:FindGO("SimulateBord", self.simulateInfoGO)
  self.simulateBord_SearchBord = self:FindGO("SearchBord", self.simulateBord)
  self.simulateBord_CostBord = self:FindGO("CostBord", self.simulateBord)
  self.simulateBord_Title = self:FindComponent("Label", UILabel, self.simulateBord_CostBord)
  self.simulateBord_CostContri = self:FindComponent("CostContri", UILabel, self.simulateBord_CostBord)
  self.simulateBord_CostGold = self:FindComponent("CostGold", UILabel, self.simulateBord_CostBord)
  local pathButton = self:FindGO("PathButton")
  self.pathButton_Symbol = self:FindComponent("Symbol", UISprite, pathButton)
  self.pathButton_Symbol.spriteName = "xingpan_icon_path_hide"
  self:AddClickEvent(pathButton, function(go)
    if self.saveInfoShow then
      self:HideAndResetSimulateSaveInfo()
    else
      self:ShowAndUpdateSimulateSaveInfo()
    end
  end)
  local detailButton = self:FindGO("DetailButton", self.simulateInfoGO)
  self:AddClickEvent(detailButton, function()
    local data = {}
    if self.inSaveMode then
      data.bordData = self.curBordData
      data.savedata = self.curBordData:GetPlanIdsMap()
    else
      data.bordData = self.curBordData
      data.savedata = self.curBordData:GetActivePointsMap()
    end
    data.newdata = {}
    for id, _ in pairs(self.handlePointsMap) do
      if id ~= Astrolabe_Origin_PointID and not data.savedata[id] then
        data.newdata[id] = 1
      end
    end
    TipManager.Instance:ShowAstrolabeContraceTip(data)
  end)
  self.searchPointsBord = self:FindGO("SearchPointsBord")
  local closecomp = self.searchPointsBord:GetComponent(CloseWhenClickOtherPlace)
  function closecomp.callBack(go)
    self:HideSearchPointsBord()
  end
  local searchWrap = self:FindGO("SearchPointsGrid", self.searchPointsBord)
  self.searchPointsCtl = WrapListCtrl.new(searchWrap, AstrolabeView_SearchPointCell, "AstrolabeView_SearchPointCell", WrapListCtrl_Dir.Vertical)
  self.searchPointsCtl:AddEventListener(MouseEvent.MouseClick, self.ClickSearchPoint, self)
  self.simulateSearchInputGO = self:FindGO("SearchInput", self.simulateBord)
  self.simulateSearchInput = self.simulateSearchInputGO:GetComponent(UIInput)
  local doSearchButton = self:FindGO("S_Down", self.simulateSearchInputGO)
  self:AddClickEvent(doSearchButton, function(go)
    if self.searchPointsBord_Show then
      self:DoSearchPoint(self.simulateSearchInput.value)
      self.searchPointsBord:SetActive(false)
      self:HideSearchPointsBord()
    else
      self:ShowSearchPointsBord()
    end
  end)
  local delButton = self:FindGO("S_Del", simulateSearchInputGO)
  self:AddClickEvent(delButton, function(go)
    self:ClearSearchPointEffect()
  end)
  self.searchDownTrans = self:FindGO("S_Down", simulateSearchInputGO).transform
  EventDelegate.Set(self.simulateSearchInput.onChange, function()
    if self.searchPointsBord_Show then
      self:DoSearchPoint(self.simulateSearchInput.value)
      return
    end
  end)
  local pathChoosePopUpListGO = self:FindGO("PathChoosePopUpList", searchBord)
  self.pathChoosePopUpList = pathChoosePopUpListGO:GetComponent(UIPopupList)
  self.pathChoosePopUpDownTrans = self:FindGO("S_Down", pathChoosePopUpListGO).transform
  for i = 1, #PathChooseOption do
    self.pathChoosePopUpList:AddItem(PathChooseOption[i][1], PathChooseOption[i][2])
  end
  EventDelegate.Add(self.pathChoosePopUpList.onChange, function(value)
    self:DoPathChoose(value)
  end)
end
function AstrolabeView:OnEnter_Active()
  function UICamera.onSelect(go, select)
    if go ~= self.simulateSearchInputGO then
      return
    end
    if select then
      self:ShowSearchPointsBord()
    end
  end
  self:UpdatePreview()
end
function AstrolabeView:OnExit_Active()
  UICamera.onSelect = nil
end
function AstrolabeView:ClickSearchPoint(cell)
  self:ChooseSearchPoint(cell.data)
  self.searchPointsBord:SetActive(false)
  self:HideSearchPointsBord()
end
function AstrolabeView:ChooseSearchPoint(data)
  self:ClearSearchPointEffect()
  local name = data:GetName()
  self.simulateSearchInput.value = name
  TableUtility.TableClear(self.searchPoints)
  self.curBordData:MatchSpecialPointByName(name, self.searchPoints, false)
  for i = 1, #self.searchPoints do
    self:AddSearchPointEffect(self.searchPoints[i])
  end
end
local SearchPointCellPath = ResourcePathHelper.EffectUI("SelectRune")
function AstrolabeView:AddSearchPointEffect(point)
  self:AddMiniMapSearchPointEffect(point)
  if self.searchPointEffectMap == nil then
    self.searchPointEffectMap = {}
  end
  local effect = self.searchPointEffectMap[point.guid]
  if effect == nil then
    effect = self:LoadPreferb_ByFullPath(SearchPointCellPath, self.effectContainer)
    self.searchPointEffectMap[point.guid] = effect
    tempV3:Set(point:GetWorldPos_XYZ())
    effect.transform.localPosition = tempV3
  end
end
function AstrolabeView:ClearSearchPointEffect()
  self:ClearMiniMapSearchPointEffect()
  if self.searchPointEffectMap == nil then
    return
  end
  for id, effectGO in pairs(self.searchPointEffectMap) do
    if not Slua.IsNull(effectGO) then
      GameObject.Destroy(effectGO)
    end
  end
  self.searchPointEffectMap = {}
  self.simulateSearchInput.value = ""
end
function AstrolabeView:ShowSearchPointsBord()
  self:DoSearchPoint(self.simulateSearchInput.value)
  self.searchPointsBord_Show = true
  self.searchPointsBord:SetActive(true)
  tempV3:Set(0, 0, 90)
  self.searchDownTrans.eulerAngles = tempV3
end
function AstrolabeView:HideSearchPointsBord()
  self.searchPointsBord_Show = false
  tempV3:Set(0, 0, -90)
  self.searchDownTrans.eulerAngles = tempV3
end
function AstrolabeView:DoSearchPoint(value)
  if self.searchPoints == nil then
    self.searchPoints = {}
  else
    TableUtility.TableClear(self.searchPoints)
  end
  self.curBordData:MatchSpecialPointByName(value, self.searchPoints, true)
  self.searchPointsCtl:ResetPosition()
  if #self.searchPoints == 0 then
    local spcPoints = self.curBordData:GetAllSpeicalPoints(true)
    self.searchPointsCtl:ResetDatas(spcPoints)
  else
    self.searchPointsCtl:ResetDatas(self.searchPoints)
  end
end
function AstrolabeView:DoPathChoose(value)
  local data = self.pathChoosePopUpList.data
  local savedata = localSaveProxy:GetAstrolabeView_PathFliter()
  if data == savedata then
    return
  end
  localSaveProxy:SetAstrolabeView_PathFliter(data)
  self.pathFliterValue = math.floor(data)
  if self.pathChoosePopUpList.isOpen then
    tempV3:Set(0, 0, 90)
  else
    tempV3:Set(0, 0, -90)
  end
  self.pathChoosePopUpDownTrans.eulerAngles = tempV3
end
function AstrolabeView:UpdateActiveInfo()
  self:UpdateSimulateSearchInfo()
  self:UpdateHandleCost(nil)
end
function AstrolabeView:UpdateSimulateSearchInfo()
  local savedata2 = localSaveProxy:GetAstrolabeView_PathFliter()
  self.pathFliterValue = math.floor(tonumber(savedata2))
  for i = 1, #PathChooseOption do
    if PathChooseOption[i][2] == savedata2 then
      self.pathChoosePopUpList.value = PathChooseOption[i][1]
      break
    end
  end
end
function AstrolabeView:ShowAndUpdateSimulateSaveInfo()
  self.pathButton_Symbol.spriteName = "xingpan_icon_path"
  self.saveInfoShow = true
  self.maskPointsDirty = true
  TableUtility.TableClear(self.savePointsMap)
  local planIdsMap = self.curBordData:GetPlanIdsMap()
  if planIdsMap == nil or not next(planIdsMap) then
    self:RedrawHandlePoints()
    return
  end
  for guid, _ in pairs(planIdsMap) do
    self.savePointsMap[guid] = Astrolabe_Handle_PointType.Simulate_Save
  end
  self:RedrawHandlePoints()
end
function AstrolabeView:HideAndResetSimulateSaveInfo()
  if self.inSaveMode then
    return
  end
  self.pathButton_Symbol.spriteName = "xingpan_icon_path_hide"
  self.saveInfoShow = false
  self.maskPointsDirty = true
  TableUtility.TableClear(self.savePointsMap)
  self:RedrawHandlePoints()
end
function AstrolabeView:UpdateHandleCost(pointState, title, checkValid)
  if title then
    self.simulateBord_Title.text = title or ""
  end
  if pointState == nil then
    self.simulateBord_CostContri.text = "0"
    self.simulateBord_CostGold.text = "0"
    return
  end
  local pointData
  if self.handleCostRecv == nil then
    self.handleCostRecv = {}
  else
    TableUtility.TableClear(self.handleCostRecv)
  end
  local checkIn = function(state)
    if type(pointState) == "table" then
      for _, st in pairs(pointState) do
        if state == st then
          return true
        end
      end
      return false
    else
      return state == pointState
    end
  end
  for id, state in pairs(self.handlePointsMap) do
    if checkIn(state) then
      pointData = self.curBordData:GetPointByGuid(id)
      if checkValid == nil or checkValid(pointData) then
        self:_HelpUpdateActiveCostData(pointData:GetCost(), self.handleCostRecv, 1)
      end
    end
  end
  self.simulateBord_CostContri.text = self.handleCostRecv[140] or 0
  self.simulateBord_CostGold.text = self.handleCostRecv[5261] or 0
end
function AstrolabeView:ClickActiveButton()
  if self.choosePointData == nil then
    return
  end
  if self.inSaveMode then
    local pid = self.choosePointData.guid
    if self.curBordData:CheckIsInPlaned(pid) then
      self:TryResetPoints()
    else
      self:TrySavePoints()
    end
  elseif self.choosePointData:IsActive() then
    self:TryResetPoints()
  else
    self:TryActivePoints()
  end
  self:HideActiveBord()
end
function AstrolabeView:ShowOrHidePointActiveInfo(b)
  if self.inSaveMode and not self.init_inSaveModePriStateMap then
    self.init_inSaveModePriStateMap = true
    TableUtility.TableClear(self.inSaveModePriStateMap)
    local plateMap = self.curBordData:GetPlateMap()
    for _, plate in pairs(plateMap) do
      local pointMap = plate:GetPointMap()
      for _, pointCell in pairs(pointMap) do
        if Astrolabe_Origin_PointID ~= pointCell.guid then
          self.inSaveModePriStateMap[pointCell.guid] = Astrolabe_PointData_State.Lock
        else
          self.inSaveModePriStateMap[pointCell.guid] = Astrolabe_PointData_State.On
        end
      end
    end
  end
  self.screenView:RefreshDraw(true)
end
function AstrolabeView:DoServerActive()
  if #self.handlePointsList == 0 then
    return
  end
  local activePointsMap = AstrolabeProxy.Instance:GetActivePointsMap()
  local id
  for i = #self.handlePointsList, 1, -1 do
    id = self.handlePointsList[i]
    if activePointsMap[id] then
      table.remove(self.handlePointsList, i)
    end
  end
  ServiceAstrolabeCmdProxy.Instance:CallAstrolabeActivateStarCmd(self.handlePointsList)
end
function AstrolabeView:BuildActiveHandlePath(pointState, searchFrom, checkActive, clearPre)
  if clearPre then
    TableUtility.TableClear(self.handlePointsMap)
    TableUtility.ArrayClear(self.handlePointsList)
  end
  local id = self.choosePointData and self.choosePointData.guid
  local pathIds = FunctionAstrolabe.GetPath(id, math.floor(self.pathFliterValue), searchFrom)
  if pathIds == nil or #pathIds == 0 then
    MsgManager.ShowMsgByIDTable(2852)
    self:ResetHandlePointsInfo()
    self:RedrawHandlePoints()
    return
  end
  self.maskPointsDirty = true
  local pointData, cost
  local totalCost = {}
  local left_Cost, _helpCheckNotEnough
  if checkActive then
    left_Cost = {}
    local userdata = Game.Myself and Game.Myself.data.userdata
    left_Cost[100] = userdata:Get(UDEnum.SILVER) or 0
    left_Cost[140] = userdata:Get(UDEnum.CONTRIBUTE) or 0
    left_Cost[5261] = BagProxy.Instance:GetItemNumByStaticID(5261)
    function _helpCheckNotEnough(t)
      for k, v in pairs(t) do
        if type(v) == "number" and v < 0 then
          return true
        end
      end
      return false
    end
  end
  local suc
  local handlePointNum = 0
  for i = 1, #pathIds do
    pointData = self.curBordData:GetPointByGuid(pathIds[i])
    self.handlePointsMap[pathIds[i]] = pointState
    suc = true
    cost = pointData:GetCost()
    if checkActive then
      if not pointData:IsActive() then
        self:_HelpUpdateActiveCostData(cost, totalCost, 1)
        self:_HelpUpdateActiveCostData(cost, left_Cost, -1)
        handlePointNum = handlePointNum + 1
      end
      if _helpCheckNotEnough(left_Cost) then
        self.handlePointsMap[pathIds[i]] = Astrolabe_Handle_PointType.Active_NotCan
        suc = false
      end
    else
      self:_HelpUpdateActiveCostData(cost, totalCost, 1)
      handlePointNum = handlePointNum + 1
    end
    if suc then
      table.insert(self.handlePointsList, pathIds[i])
    end
  end
  self.activeBord:SetActive(true)
  self.activeBord_ActivePoint.text = handlePointNum
  self:RedrawHandlePoints()
  return totalCost, left_Cost
end
function AstrolabeView:_HelpUpdateActiveCostData(cost, costRev, operate)
  operate = operate or 1
  for i = 1, #cost do
    local id, value = cost[i][1], cost[i][2]
    costRev[id] = costRev[id] or 0
    costRev[id] = costRev[id] + value * operate
  end
end
function AstrolabeView:TryActivePoints()
  self.handleState = AstrolabeView.HandleSate.Active
  local totalCost, left_Cost = self:BuildActiveHandlePath(Astrolabe_Handle_PointType.Active_Can, FunctionAstrolabe.SearchFromType.Active, true)
  local checkValid = function(pointData)
    return not pointData:IsActive()
  end
  self:UpdateHandleCost({
    Astrolabe_Handle_PointType.Active_Can,
    Astrolabe_Handle_PointType.Active_NotCan
  }, ZhString.AstrolabeView_Simulation_CostTtile, checkValid)
  local hasNotEnoughCost = false
  if left_Cost == nil or left_Cost[140] < 0 then
    hasNotEnoughCost = true
  end
  if left_Cost == nil or 0 > left_Cost[5261] then
    hasNotEnoughCost = true
  end
  if hasNotEnoughCost then
    tempColor:Set(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
    self.activeBord_ConfirmButton_Sprite.color = tempColor
    self.activeBord_ConfirmButton_Sp.color = tempColor
    self.activeBord_ConfirmButton_Collider.enabled = false
  else
    tempColor:Set(1, 1, 1, 1)
    self.activeBord_ConfirmButton_Sprite.color = tempColor
    self.activeBord_ConfirmButton_Sp.color = tempColor
    self.activeBord_ConfirmButton_Collider.enabled = true
  end
  self:RedrawHandlePoints()
end
function AstrolabeView:DoServerReset()
  if self.inSaveMode then
    self:DoServerReset_Plan()
  else
    self:DoServerReset_Active()
  end
end
function AstrolabeView:DoServerReset_Active()
  if self.choosePointData.guid == Astrolabe_Origin_PointID then
    ServiceAstrolabeCmdProxy.Instance:CallAstrolabeResetCmd({
      Astrolabe_Origin_PointID
    })
    return
  end
  TableUtility.ArrayClear(self.handlePointsList)
  local pointData
  for id, state in pairs(self.handlePointsMap) do
    if state == Astrolabe_Handle_PointType.Reset then
      pointData = self.curBordData:GetPointByGuid(id)
      pointData:SetOldState(pointData:GetState())
      table.insert(self.handlePointsList, id)
    end
  end
  if #self.handlePointsList > 0 then
    ServiceAstrolabeCmdProxy.Instance:CallAstrolabeResetCmd(self.handlePointsList)
  end
end
function AstrolabeView:DoServerReset_Plan()
  if self.choosePointData.guid == Astrolabe_Origin_PointID then
    self:DoServerSave({})
    return
  end
  self:DoServerSave()
end
function AstrolabeView:TryResetPoints()
  TableUtility.TableClear(self.handlePointsMap)
  local id = self.choosePointData.guid
  local pointIds = {}
  if id == Astrolabe_Origin_PointID then
    local pointsMap
    if self.inSaveMode then
      pointsMap = self.curBordData:GetPlanIdsMap()
    else
      pointsMap = self.curBordData:GetActivePointsMap()
    end
    for id, _ in pairs(pointsMap) do
      local pointData = self.curBordData:GetPointByGuid(id)
      if self.inSaveMode then
        table.insert(pointIds, id)
      elseif pointData:IsActive() then
        table.insert(pointIds, id)
      end
    end
  else
    local pointIdMap
    if self.inSaveMode then
      pointIdMap = self.curBordData:ResetPlanPoint(id)
    else
      pointIdMap = self.curBordData:ResetActivePoint(id)
    end
    for id, _ in pairs(pointIdMap) do
      table.insert(pointIds, id)
    end
  end
  if pointIds == nil or #pointIds == 0 then
    self:RedrawHandlePoints()
    return
  end
  self.handleState = AstrolabeView.HandleSate.Reset
  self.maskPointsDirty = true
  local return_slivernum, return_contributenum, return_goldawardnum = 0, 0, 0
  local cost_slivernum = 0
  local pointData, cost
  for i = 1, #pointIds do
    pointData = self.curBordData:GetPointByGuid(pointIds[i])
    cost = pointData:GetCost()
    for j = 1, #cost do
      if cost[j][1] == 100 then
        return_slivernum = return_slivernum + cost[j][2]
      elseif cost[j][1] == 140 then
        return_contributenum = return_contributenum + cost[j][2]
      elseif cost[j][1] == 5261 then
        return_goldawardnum = return_goldawardnum + cost[j][2]
      end
    end
    cost = pointData:GetResetCost()
    for j = 1, #cost do
      if cost[j][1] == 100 then
        cost_slivernum = cost_slivernum + cost[j][2]
      end
    end
    self.handlePointsMap[pointIds[i]] = Astrolabe_Handle_PointType.Reset
    if pointData:IsActive() then
      table.insert(self.handlePointsList, pointIds[i])
    end
  end
  if not self.inSaveMode then
    local checkValid = function(pointData)
      return pointData:IsActive()
    end
    self:UpdateHandleCost(Astrolabe_Handle_PointType.Reset, ZhString.AstrolabeView_Simulation_ReturnTtile, checkValid)
  else
    self:UpdateHandleCost(nil, ZhString.AstrolabeView_Simulation_ReturnTtile)
  end
  self:RedrawHandlePoints()
  self.resetBord_ResetPoint.text = #pointIds
  self.resetBord:SetActive(true)
  if self.inSaveMode then
    cost_slivernum = 0
  else
    local mysliver = Game.Myself.data.userdata:Get(UDEnum.SILVER)
    cost_slivernum = math.min(cost_slivernum, 500000)
    if mysliver < cost_slivernum then
      self.resetBord_CostZeny.text = "[c][E92021]" .. cost_slivernum .. "[-][/c]"
      tempColor:Set(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
      self.resetBord_ConfirmButton_Sprite.color = tempColor
      self.resetBord_ConfirmButton_Sp.color = tempColor
      self.resetBord_ConfirmButton_Collider.enabled = false
      return
    end
  end
  self.resetBord_CostZeny.text = cost_slivernum
  tempColor:Set(1, 1, 1, 1)
  self.resetBord_ConfirmButton_Sprite.color = tempColor
  self.resetBord_ConfirmButton_Sp.color = tempColor
  self.resetBord_ConfirmButton_Collider.enabled = true
end
function AstrolabeView:DoServerSave(savePMap)
  if savePMap == nil then
    savePMap = {}
    for id, state in pairs(self.savePointsMap) do
      if state == Astrolabe_Handle_PointType.Simulate_Save then
        savePMap[id] = 1
      else
        savePMap[id] = nil
      end
    end
    for id, state in pairs(self.handlePointsMap) do
      if state == Astrolabe_Handle_PointType.Simulate_Save then
        savePMap[id] = 1
      else
        savePMap[id] = nil
      end
    end
  end
  if self.saveStars == nil then
    self.saveStars = {}
  else
    TableUtility.TableClear(self.saveStars)
  end
  local insertSort = TableUtility.InsertSort
  local insertSortFunc = function(l, r)
    return r < l
  end
  for id, _ in pairs(savePMap) do
    insertSort(self.saveStars, id, insertSortFunc)
  end
  local idStr = "SaveStars: "
  for i = 1, #self.saveStars do
    idStr = idStr .. " | " .. self.saveStars[i]
  end
  helplog(idStr)
  ServiceAstrolabeCmdProxy.Instance:CallAstrolabePlanSaveCmd(self.saveStars)
  TableUtility.TableClear(self.saveStars)
end
function AstrolabeView:TrySavePoints()
  self.handleState = AstrolabeView.HandleSate.Simulate
  local totalCost, left_Cost = self:BuildActiveHandlePath(Astrolabe_Handle_PointType.Simulate_Save, FunctionAstrolabe.SearchFromType.Plan)
  local planIdsMap = AstrolabeProxy.Instance:GetPlanIdsMap()
  local checkValid = function(pointData)
    return planIdsMap[pointData.id] == nil
  end
  self:UpdateHandleCost(Astrolabe_Handle_PointType.Simulate_Save, ZhString.AstrolabeView_Simulation_CostTtile, checkValid)
end
function AstrolabeView:ResetHandlePointsInfo(notTweenBord)
  self.maskPointsDirty = true
  self.handleState = AstrolabeView.HandleSate.None
  TableUtility.TableClear(self.handlePointsMap)
  TableUtility.TableClear(self.handlePointsList)
  self:UpdateHandleCost(nil)
  self.activeBord:SetActive(false)
  self.resetBord:SetActive(false)
  tempColor:Set(1, 1, 1, 1)
  self.activeBord_ConfirmButton_Sprite.color = tempColor
  self.activeBord_ConfirmButton_Sp.color = tempColor
  self.activeBord_ConfirmButton_Collider.enabled = true
  self:RedrawHandlePoints()
end
function AstrolabeView:ClickPoint_Active(pointData)
  if self.handleState ~= AstrolabeView.HandleSate.None then
    return
  end
  self:ShowActiveBord()
  if self.inSaveMode then
    self:ShowAndUpdateSimulateSaveInfo()
    if self.curBordData:CheckIsInPlaned(pointData.guid) then
      self.activeButton_label.text = ZhString.AstrolabeView_Reset
    else
      self.activeButton_label.text = ZhString.AstrolabeView_Save
    end
  else
    local state = pointData:GetState()
    if state == Astrolabe_PointData_State.On then
      self.activeButton_label.text = ZhString.AstrolabeView_Reset
    else
      self.activeButton_label.text = ZhString.AstrolabeView_Active
    end
  end
end
function AstrolabeView:ShowActiveBord()
  self.activeInfoTween:Play(true)
end
function AstrolabeView:HideActiveBord()
  self.activeInfoTween:Play(false)
end
function AstrolabeView:MapActiveEvent()
  self:AddListenEvt(ServiceEvent.AstrolabeCmdAstrolabeActivateStarCmd, self.HandleActivePoints)
  self:AddListenEvt(ServiceEvent.AstrolabeCmdAstrolabeResetCmd, self.HandleResetPoints)
  self:AddListenEvt(ServiceEvent.AstrolabeCmdAstrolabePlanSaveCmd, self.HandleSavePoints)
end
function AstrolabeView:HandleActivePoints(note)
  local stars = note.body.stars
  local animDatas = {}
  local add_EffectMap = {}
  local add_SpecialEffectMap = {}
  if stars[1] == Astrolabe_Origin_PointID then
    local pointData = self.curBordData:GetPointByGuid(Astrolabe_Origin_PointID)
    table.insert(animDatas, pointData)
  else
    for i = 1, #self.handlePointsList do
      local pointData = self.curBordData:GetPointByGuid(self.handlePointsList[i])
      if pointData:IsActive() then
        table.insert(animDatas, pointData)
      end
      local effect = pointData:GetEffect()
      if effect then
        for attriKey, value in pairs(effect) do
          if add_EffectMap[attriKey] then
            add_EffectMap[attriKey] = add_EffectMap[attriKey] + value
          else
            add_EffectMap[attriKey] = value
          end
        end
      end
      local specialEffect = pointData:GetSpecialEffect()
      if specialEffect then
        if add_SpecialEffectMap[specialEffect] == nil then
          add_SpecialEffectMap[specialEffect] = 1
        else
          add_SpecialEffectMap[specialEffect] = add_SpecialEffectMap[specialEffect] + 1
        end
      end
    end
  end
  AudioUtility.PlayOneShot2D_Path(ResourcePathHelper.AudioSEUI(AudioMap.UI.LinkRune2))
  self:PlayHandleAnims(animDatas, "ToUnlock", function()
    for _, cell in pairs(self.plateCellMap) do
      cell:Refresh()
    end
    self:RedrawOuterLine()
    self.curBordData:CheckNeed_DoServer_InitPlate()
  end)
  local PropNameConfig = Game.Config_PropName
  local str = ""
  for attriType, value in pairs(add_EffectMap) do
    local config = PropNameConfig[attriType]
    if config ~= nil then
      str = config.PropName
      if value > 0 then
        str = str .. " +"
      end
      if config.IsPercent == 1 then
        str = str .. value * 100 .. "%"
      else
        str = str .. value
      end
      MsgManager.ShowMsgByIDTable(2850, {str})
    end
  end
  for specialid, addlv in pairs(add_SpecialEffectMap) do
    local specialData = Table_RuneSpecial[specialid]
    MsgManager.ShowMsgByIDTable(2850, {
      specialData.RuneName
    })
  end
  self:ResetHandlePointsInfo(true)
  if self.choosePointData then
    local state = self.choosePointData:GetState()
    if state == Astrolabe_PointData_State.Lock then
      self.activeButton_label.text = ZhString.AstrolabeView_Active
    elseif state == Astrolabe_PointData_State.On then
      self.activeButton_label.text = ZhString.AstrolabeView_Reset
    elseif state == Astrolabe_PointData_State.Off then
      self.activeButton_label.text = ZhString.AstrolabeView_Active
    end
  end
end
function AstrolabeView:HandleResetPoints(note)
  local animDatas = {}
  local min_EffectMap = {}
  local min_SpecialEffectMap = {}
  for i = 1, #self.handlePointsList do
    local pointData = self.curBordData:GetPointByGuid(self.handlePointsList[i])
    if not pointData:IsActive() then
      table.insert(animDatas, pointData)
      local effect = pointData:GetEffect()
      if effect then
        for attriKey, value in pairs(effect) do
          if min_EffectMap[attriKey] then
            min_EffectMap[attriKey] = min_EffectMap[attriKey] - value
          else
            min_EffectMap[attriKey] = -value
          end
        end
      end
      local specialEffect = pointData:GetSpecialEffect()
      if specialEffect then
        if min_SpecialEffectMap[specialEffect] == nil then
          min_SpecialEffectMap[specialEffect] = 1
        else
          min_SpecialEffectMap[specialEffect] = min_SpecialEffectMap[specialEffect] + 1
        end
      end
    end
  end
  local PropNameConfig = Game.Config_PropName
  local msg, str = "", nil
  for attriType, value in pairs(min_EffectMap) do
    local config = PropNameConfig[attriType]
    if config ~= nil then
      str = config.PropName
      if value > 0 then
        str = str .. " +"
      end
      if config.IsPercent == 1 then
        str = str .. value * 100 .. "%"
      else
        str = str .. value
      end
      MsgManager.ShowMsgByIDTable(2851, {str})
    end
  end
  for specialid, minlv in pairs(min_SpecialEffectMap) do
    local specialData = Table_RuneSpecial[specialid]
    MsgManager.ShowMsgByIDTable(2851, {
      specialData.RuneName
    })
  end
  self:ResetHandlePointsInfo(true)
  AudioUtility.PlayOneShot2D_Path(ResourcePathHelper.AudioSEUI(AudioMap.UI.ResetRune))
  self:PlayHandleAnims(animDatas, "AtharReset", function()
    for _, cell in pairs(self.plateCellMap) do
      cell:Refresh()
    end
    self:RedrawOuterLine()
    self.curBordData:CheckNeed_DoServer_InitPlate()
  end)
end
function AstrolabeView:HandleSavePoints(note)
  self:ShowAndUpdateSimulateSaveInfo()
  self:ResetHandlePointsInfo(true)
end
function AstrolabeView:UpdatePreview()
  helplog("UpdatePreview:", self.isPreview)
  self.helpGO:SetActive(self.isPreview ~= true)
  self.activeInfo:SetActive(self.isPreview ~= true)
  self.simulateButton:SetActive(self.isPreview ~= true)
end
