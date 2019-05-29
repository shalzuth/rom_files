autoImport("ServantImproveCell")
autoImport("ServantImproveCellNew")
autoImport("ImproveGiftCell")
autoImport("RewardListTip")
autoImport("EquipRecommendMainNew")
autoImport("jihuacombinecell")
ServantImproveViewNew = class("ServantImproveViewNew", SubView)
ServantImproveViewNew.ServantImproveCellNew_cellRes = ResourcePathHelper.UICell("ServantImproveCellNew")
autoImport("HappyShopBuyItemCell")
local Prefab_Path = ResourcePathHelper.UIView("ServantImproveViewNew")
local tempVector3 = LuaVector3.zero
local ACTIVITY_TYPE = SceneUser2_pb.EGROWTH_TYPE_TIME_LIMIT
ServantImproveViewNew.ColorTheme = {
  [1] = {
    color = LuaColor.New(0.6588235294117647, 0.6588235294117647, 0.6588235294117647, 1)
  },
  [2] = {
    color = LuaColor.New(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
  }
}
local ColorEffectOrange = ColorUtil.ButtonLabelOrange
local ColorEffectBlue = ColorUtil.ButtonLabelBlue
ServantImproveViewNew.ShopType = 3240
function ServantImproveViewNew:Init()
  self:FindObjs()
end
function ServantImproveViewNew:LoadPurchaseDetailView(shop_item_data)
  self:SetActivePurchaseDetail(true)
  if self.puchaseDetailCtrl == nil then
    self.puchaseDetailCtrl = HappyShopBuyItemCell.new(self.goPurchaseDetail)
    self.puchaseDetailCtrl:AddConfirmClickEvent()
  end
  self.puchaseDetailCtrl:SetData(shop_item_data)
end
function ServantImproveViewNew:SetActivePurchaseDetail(b)
  self.goPurchaseDetail:SetActive(b)
end
function ServantImproveViewNew:OnClickForShop(shopItemData)
  self:LoadPurchaseDetailView(shopItemData)
  HappyShopProxy.Instance:SetSelectId(shopItemData.id)
end
function ServantImproveViewNew:ShowSelf()
  if self.containergo then
    self.containergo.gameObject:SetActive(true)
  else
  end
end
function ServantImproveViewNew:HideSelf()
  if self.containergo then
    self.containergo.gameObject:SetActive(false)
  end
end
function ServantImproveViewNew:ShowEquipRecommendMainNew(b)
  if self.EquipRecommendMainNew then
    if b then
      self.EquipRecommendMainNew:SelfShow()
    else
      self.EquipRecommendMainNew:Hide()
    end
  end
end
function ServantImproveViewNew:IsToggle3Fobid()
  local isForbid = false
  if GameConfig.SystemForbid and GameConfig.SystemForbid.OpenServantEquipRecommend then
    isForbid = GameConfig.SystemForbid.OpenServantEquipRecommend
  else
    isForbid = false
  end
  return isForbid
end
function ServantImproveViewNew:FindObjs()
  self.containergo = self:FindGO("improveView")
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.containergo, true)
  obj.name = "ServantImproveViewNew"
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.mainTable = self:FindComponent("ImproveTable", UITable)
  self.emptySymol = self:FindGO("EmptySymol")
  self.functionPlanList = self:FindGO("FunctionPlanList")
  self.planListScrollView = self:FindComponent("PlanListScrollView", UIScrollView)
  self.planListTable = self:FindComponent("PlanListTable", UITable)
  self.luckyScrollView = self:FindComponent("LuckyScrollView", UIScrollView)
  self.giftGrid = self:FindComponent("giftTable", UIGrid)
  self.giftListCtl = UIGridListCtrl.new(self.giftGrid, ImproveGiftCell, "ImproveGiftCell")
  self.giftListCtl:AddEventListener(MouseEvent.LongPress, self.HandleGiftLongPress, self)
  self.luckyProgressBack = self:FindComponent("LuckyProgressBack", UISprite)
  self.luckyProgress = self:FindComponent("LuckyProgress", UISprite)
  self.Node = self:FindGO("Node")
  self.ToggleRoot = self:FindGO("ToggleRoot", self.Node)
  self.Toggle_1 = self:FindGO("Toggle_1", self.ToggleRoot)
  self.Toggle_2 = self:FindGO("Toggle_2", self.ToggleRoot)
  self.Toggle_3 = self:FindGO("Toggle_3", self.ToggleRoot)
  self.Toggle_1_UILabel = self.Toggle_1:GetComponent(UILabel)
  self.Toggle_2_UILabel = self.Toggle_2:GetComponent(UILabel)
  self.Toggle_3_UILabel = self.Toggle_3:GetComponent(UILabel)
  OverseaHostHelper:FixLabelOverV1(self.Toggle_2_UILabel, 3, 180)
  if self:IsToggle3Fobid() then
    self.Toggle_3.gameObject:SetActive(false)
    self.Toggle_2_Bg = self:FindGO("Bg", self.Toggle_2)
    self.Toggle_2_ChooseBg = self:FindGO("ChooseBg", self.Toggle_2)
    self.Toggle_2_Bg_UISprite = self.Toggle_2_Bg:GetComponent(UISprite)
    self.Toggle_2_ChooseBg_UISprite = self.Toggle_2_ChooseBg:GetComponent(UISprite)
    self.Toggle_2_Bg_UISprite.spriteName = "taskmanual_btn_1"
    self.Toggle_2_ChooseBg_UISprite.spriteName = "taskmanual_btn_2"
    self.Toggle_2_Bg_UISprite.width = 216
    self.Toggle_2_ChooseBg_UISprite.width = 216
    self.ToggleRoot.transform.localPosition = LuaVector3(150, 311, 0)
  else
    self.Toggle_3.gameObject:SetActive(true)
  end
  self.ToggleRoot.transform.localPosition = Vector3(146.2, 314, 0)
  self.Toggle_1.transform.localPosition = Vector3(-197.5, -1, 0)
  self.Toggle_1_ChooseBg = self:FindGO("ChooseBg", self.Toggle_1):GetComponent(UISprite)
  self.Toggle_1_ChooseBg.width = 216
  self.Toggle_2.transform.localPosition = Vector3(-1.3, 0, 0)
  self.Node_ScrollView = self:FindGO("ScrollView", self.Node)
  self.Node_ScrollView_UIScrollView = self.Node_ScrollView:GetComponent(UIScrollView)
  self.Node_ScrollView_UIPanel = self.Node_ScrollView:GetComponent(UIPanel)
  self.ImproveTable = self:FindGO("ImproveTable", self.Node_ScrollView)
  self.ImproveTable_UITable = self.ImproveTable:GetComponent(UIGrid)
  self.ImproveCtl = UIGridListCtrl.new(self.ImproveTable_UITable, ServantImproveCellNew, "ServantImproveCellNew")
  self.ImproveCtl:AddEventListener(ServantImproveEvent.TraceBtnClick, self.ClickFunctionBtnNew, self)
  self.Node_DetailView = self:FindGO("DetailView", self.Node)
  self.Node_DetailView.gameObject:SetActive(false)
  self.ShopPanel = self:FindGO("ShopPanel", self.Node_DetailView)
  self.Node_DetailView_ServantImproveCellNewPoint = self:FindGO("ServantImproveCellNewPoint", self.Node_DetailView)
  obj = Game.AssetManager_UI:CreateAsset(ServantImproveViewNew.ServantImproveCellNew_cellRes, self.Node_DetailView_ServantImproveCellNewPoint)
  tempVector3:Set(0, 0, 0)
  obj.transform.localPosition = tempVector3
  self.DetailView_leftcell = ServantImproveCellNew.new(obj)
  self.DetailView_ScrollView = self:FindGO("ScrollView", self.Node_DetailView)
  self.jihuaTable = self:FindGO("jihuaTable", self.DetailView_ScrollView)
  self.goalslist_UITable = self.jihuaTable:GetComponent(UITable)
  self.goalListCtl = UIGridListCtrl.new(self.goalslist_UITable, jihuacombinecell, "jihuacombinecell")
  self.goalListCtl:AddEventListener(MouseEvent.MouseClick, self.ClickGoal, self)
  self.TipRelative = self:FindGO("TipRelative", self.Node_DetailView)
  self.TipRelative_UIWidget = self.TipRelative:GetComponent(UIWidget)
  self:AddClickEvent(self.DetailView_leftcell.gameObject, function(go)
    local jiemianid = ServantRecommendProxy.Instance:GetCurrentShowJieMianId()
    self:ShowTiShenJiHua(jiemianid)
  end)
  self.DetailView_leftcell:AddEventListener(MouseEvent.LongPress, self.HandleGiftLongPress, self)
  self.TypeGrid = self:FindGO("TypeGrid")
  self.TypeGrid.gameObject:SetActive(false)
  self:ShowTiShenJiHua(1)
  self:AddButtonEvent("FunctionPlanCloseButton", function()
    self.functionPlanList:SetActive(false)
  end)
  self:UpdateMainItemListNew()
  function self.luckyScrollView.onDragStarted()
    TipManager.Instance:CloseRewardListTip()
  end
  self:AddClickEvent(self.Toggle_1, function(go)
    self:ShowEquipRecommendMainNew(false)
    self:ShowTiShenJiHua(1)
  end)
  self:AddClickEvent(self.Toggle_2, function(go)
    self:ShowEquipRecommendMainNew(false)
    self:ShowTiShenJiHua(2)
  end)
  self:AddClickEvent(self.Toggle_3, function(go)
    self:ShowTiShenJiHua(3)
    ServantRecommendProxy.Instance:SetCurrentShowJieMianId(3)
    self.Node_DetailView.gameObject:SetActive(false)
    self.Node_ScrollView.gameObject:SetActive(false)
    if not self.EquipRecommendMainNew then
      self.EquipRecommendMainNew = self:AddSubView("EquipRecommendMainNew", EquipRecommendMainNew)
    end
    self.EquipRecommendMainNew:SelfShow()
  end)
  ServantRecommendProxy.Instance:SetCurrentShowJieMianId(1)
  self.goPurchaseDetail = self:LoadPreferb("cell/HappyShopBuyItemCell", self.ShopPanel.gameObject, true)
  self.goPurchaseDetail.gameObject:SetActive(false)
  self.emptySymol:SetActive(false)
end
function ServantImproveViewNew:ClickGoal(parama)
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
  else
    self.goal = self.fatherGoalId
  end
  self.goalListCtl:Layout()
end
function ServantImproveViewNew:_resetCurCombine()
  if self.combineGoal then
    self.combineGoal = nil
  end
end
function ServantImproveViewNew:ShowTiShenJiHua(currentType)
  if self.ImproveCtl == nil then
    return
  end
  if currentType == 1 then
    self.Toggle_1_UILabel.effectColor = ColorEffectOrange
    self.Toggle_2_UILabel.effectColor = ColorEffectBlue
    self.Toggle_3_UILabel.effectColor = ColorEffectBlue
  elseif currentType == 2 then
    self.Toggle_1_UILabel.effectColor = ColorEffectBlue
    self.Toggle_2_UILabel.effectColor = ColorEffectOrange
    self.Toggle_3_UILabel.effectColor = ColorEffectBlue
  elseif currentType == 3 then
    self.Toggle_1_UILabel.effectColor = ColorEffectBlue
    self.Toggle_2_UILabel.effectColor = ColorEffectBlue
    self.Toggle_3_UILabel.effectColor = ColorEffectOrange
    return
  end
  self.Node_ScrollView.gameObject:SetActive(true)
  self.Node_DetailView.gameObject:SetActive(false)
  ServantRecommendProxy.Instance:SetCurrentShowJieMianId(currentType)
  local bigCardTable = ServantRecommendProxy.Instance:GetCurrentBigCardTable()
  self.ImproveCtl:ResetDatas(bigCardTable)
  local cells = self.ImproveCtl:GetCells()
  local currentjinduid = ServantRecommendProxy.Instance:GetCurrentJinDuId()
  self.Node_ScrollView_MyUICenterOnChild = self.Node_ScrollView:GetComponent(MyUICenterOnChild)
  if self.Node_ScrollView_MyUICenterOnChild == nil then
    self.Node_ScrollView_MyUICenterOnChild = self.Node_ScrollView:AddComponent(MyUICenterOnChild)
  end
  for k, v in pairs(cells) do
    if currentjinduid == v:GetDataId() then
      if k == 1 or k == 2 then
        self.Node_ScrollView_UIScrollView:ResetPosition()
        self.ImproveTable_UITable:Reposition()
        self.ImproveTable_UITable.repositionNow = true
        break
      end
      if k == #cells then
        self.Node_ScrollView_MyUICenterOnChild:CenterOn(cells[k - 1].gameObject.transform)
        break
      end
      self.Node_ScrollView_MyUICenterOnChild:CenterOn(v.gameObject.transform)
      break
    end
  end
  self.emptySymol:SetActive(false)
  self.Node_ScrollView_UIScrollView:ResetPosition()
end
function ServantImproveViewNew:AddViewEvts()
end
function ServantImproveViewNew:OnReceiveUpdateShopGotItem(data)
  helplog("--recv OnReceiveUpdateShopGotItem")
  local openid = self:GetCurrentPlayerOpenCellId()
  if openid then
    self:AddMoneyRelatedDatasToFatherTable(openid)
  end
end
function ServantImproveViewNew:RecvQueryShopConfig(data)
  helplog("--recv RecvQueryShopConfig")
  if data.body and data.body.goods and #data.body.goods > 0 then
    local openid = self:GetCurrentPlayerOpenCellId()
    if openid then
      self:AddMoneyRelatedDatasToFatherTable(openid)
    end
  end
end
function ServantImproveViewNew:IsThisShopItemHaveSoldOut(goodData)
  local canBuyCount, limitType = HappyShopProxy.Instance:GetCanBuyCount(goodData)
  if canBuyCount and goodData.LimitNum and canBuyCount == 0 then
    return true
  end
  return false
end
function ServantImproveViewNew:AddMoneyRelatedDatasToFatherTable(idFromClickCell)
  local goods = ShopProxy.Instance:GetConfigByTypeId(ServantImproveViewNew.ShopType, self.currentShopId)
  local SoldOutTable = {}
  local SellingTable = {}
  for m, n in pairs(goods) do
    if self:IsThisShopItemHaveSoldOut(n) then
      table.insert(SoldOutTable, n)
    else
      table.insert(SellingTable, n)
    end
  end
  local weiwanchengTable = {}
  local yiwanchengTable = {}
  local fatherTable = ServantRecommendProxy.Instance:GetFatherTable(idFromClickCell)
  if fatherTable == nil then
    helplog("if fatherTable==nil then idFromClickCell:" .. idFromClickCell)
    return
  end
  for k, v in pairs(fatherTable) do
    if v.fatherGoal.NameZh == "\230\173\163\229\156\168\232\191\155\232\161\140\231\154\132\232\174\161\229\136\146" then
      weiwanchengTable = v
    elseif v.fatherGoal.NameZh == "\229\183\178\229\174\140\230\136\144\231\154\132\232\174\161\229\136\146" then
      yiwanchengTable = v
    end
  end
  local AdvancedFartherTable = {}
  local fatherGoal = {}
  fatherGoal.NameZh = "\230\173\163\229\156\168\232\191\155\232\161\140\231\154\132\232\174\161\229\136\146"
  local newGoal = {}
  newGoal.fatherGoal = fatherGoal
  newGoal.childGoals = {}
  if weiwanchengTable.childGoals ~= nil then
    for k, v in pairs(weiwanchengTable.childGoals) do
      table.insert(newGoal.childGoals, v)
    end
  end
  for k, v in pairs(SellingTable) do
    table.insert(newGoal.childGoals, v)
  end
  table.insert(AdvancedFartherTable, newGoal)
  local fatherGoal = {}
  fatherGoal.NameZh = "\229\183\178\229\174\140\230\136\144\231\154\132\232\174\161\229\136\146"
  local newGoal = {}
  newGoal.fatherGoal = fatherGoal
  newGoal.childGoals = {}
  if yiwanchengTable.childGoals ~= nil then
    for k, v in pairs(yiwanchengTable.childGoals) do
      table.insert(newGoal.childGoals, v)
    end
  end
  for k, v in pairs(SoldOutTable) do
    table.insert(newGoal.childGoals, v)
  end
  table.insert(AdvancedFartherTable, newGoal)
  self.goalListCtl:ResetDatas()
  self.goalListCtl:ResetDatas(AdvancedFartherTable)
  for k, v in pairs(self.goalListCtl:GetCells()) do
    local ctl = v:GetChildCtl()
    ctl:AddEventListener(MouseEvent.MouseClick, self.ClickChooseNew, self)
    ctl:AddEventListener(ServantImproveEvent.TraceBtnClick, self.ClickFunctionBtn, self)
    ctl:AddEventListener(ServantImproveEvent.JiHuaIconClick, self.JiHuaIconClick, self)
  end
end
function ServantImproveViewNew:ClickChoose(cell)
  cell:setSelected(not cell.isSelected)
end
function ServantImproveViewNew:HandleGiftLongPress(param)
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
function ServantImproveViewNew:updatePressItemCount()
  local holdTime = ServerTime.CurServerTime() - self.startPressTime
  local changeCount = 1
  if holdTime > 200 then
    local cellData = self.currentgrowthRewarddata
    TipManager.Instance:ShowRewardListTip(cellData, self.currentPressCell.Stick_UIWidget, NGUIUtil.AnchorSide.DownRight, {35, 35})
  end
end
function ServantImproveViewNew:ClickFunclistChoose(cell)
  if self.currentExpandFunclistCell ~= cell then
    if self.currentExpandFunclistCell and Slua.IsNull(self.currentExpandFunclistCell.gameObject) == false then
      self.currentExpandFunclistCell:setSelected(false)
    end
    self.currentExpandFunclistCell = cell
    self.currentExpandFunclistCell:setSelected(true)
  else
    self.currentExpandFunclistCell:setSelected(not cell.isSelected)
  end
end
function ServantImproveViewNew:ClickFunctionBtnNew(cell)
  helplog("\231\130\185\228\186\134\230\143\144\229\141\135\232\174\161\229\136\146 ep\229\141\161\230\159\144\228\184\170cell")
  self.Node_ScrollView.gameObject:SetActive(false)
  self.Node_DetailView.gameObject:SetActive(true)
  self:SetCurrentPlayerOpenCellId(cell.data.id)
  self.DetailView_leftcell:SetClickBG3Func(function(obj)
    local jiemianid = ServantRecommendProxy.Instance:GetCurrentShowJieMianId()
    self:ShowTiShenJiHua(jiemianid)
  end)
  self.DetailView_leftcell:SetData(cell.data)
  self:UpdateRightJiHuaView(cell.data.id)
  self:UpdateGiftProgressNew()
  self.DetailView_leftcell:ShowState(4)
  self.goalListCtl:Layout()
end
function ServantImproveViewNew:SetCurrentPlayerOpenCellId(idFromClickCell)
  self.CurrentPlayerOpenCellId = idFromClickCell
end
function ServantImproveViewNew:GetCurrentPlayerOpenCellId()
  return self.CurrentPlayerOpenCellId
end
function ServantImproveViewNew:UpdateRightJiHuaView(idFromClickCell)
  local currentjinduid = ServantRecommendProxy.Instance:GetCurrentJinDuId()
  if idFromClickCell ~= nil and idFromClickCell < currentjinduid then
    local thisBigCellFatherTable = ServantRecommendProxy.Instance:GetFatherTable(idFromClickCell)
    if not thisBigCellFatherTable then
      local yiwanchengTable = {}
      local weiwanchengTable = {}
      local suoyouTable = {}
      for k, v in pairs(Table_Growth) do
        if (v.id - v.id % 1000) / 1000 == idFromClickCell then
          table.insert(suoyouTable, v)
        end
      end
      local fatherTable = {}
      self:MakeFatherTable(fatherTable, "\230\173\163\229\156\168\232\191\155\232\161\140\231\154\132\232\174\161\229\136\146", weiwanchengTable)
      self:MakeFatherTable(fatherTable, "\229\183\178\229\174\140\230\136\144\231\154\132\232\174\161\229\136\146", suoyouTable)
      ServantRecommendProxy.Instance:SetFatherTable(idFromClickCell, fatherTable)
      thisBigCellFatherTable = fatherTable
    end
    self.goalListCtl:ResetDatas(thisBigCellFatherTable)
    for k, v in pairs(self.goalListCtl:GetCells()) do
      local ctl = v:GetChildCtl()
      ctl:AddEventListener(MouseEvent.MouseClick, self.ClickChooseNew, self)
      ctl:AddEventListener(ServantImproveEvent.TraceBtnClick, self.ClickFunctionBtn, self)
      ctl:AddEventListener(ServantImproveEvent.JiHuaIconClick, self.JiHuaIconClick, self)
    end
    self.DetailView_leftcell:SetToOldState(idFromClickCell)
  elseif currentjinduid == idFromClickCell then
    local groupData = ServantRecommendProxy.Instance:GetImproveGroup(idFromClickCell)
    if groupData.itemList and #groupData.itemList > 0 then
      local yiwanchengTable = {}
      local weiwanchengTable = {}
      local suoyouTable = {}
      for k, v in pairs(Table_Growth) do
        if (v.id - v.id % 1000) / 1000 == currentjinduid then
          table.insert(suoyouTable, v)
        end
      end
      local WeiWanchengListFromServer = self:GetWeiWanchengListFromServer(groupData)
      for k, v in pairs(suoyouTable) do
        local thisidyiwancheng = true
        for m, n in pairs(groupData.itemList) do
          if n.dwid == v.id then
            thisidyiwancheng = false
          end
        end
        for m, n in pairs(WeiWanchengListFromServer) do
          if n.dwid == v.id then
            if n.status == SceneUser2_pb.EGROWTH_STATUS_FINISH then
              table.insert(yiwanchengTable, v)
            elseif n.status ~= SceneUser2_pb.EGROWTH_STATUS_FINISH then
              if n.status == SceneUser2_pb.EGROWTH_STATUS_RECEIVE then
                table.insert(weiwanchengTable, 1, v)
              else
                table.insert(weiwanchengTable, v)
              end
            end
          end
        end
        if thisidyiwancheng == false then
        else
          table.insert(yiwanchengTable, v)
        end
      end
      local thisBigCellFatherTable = ServantRecommendProxy.Instance:GetFatherTable(currentjinduid)
      local fatherTable = {}
      self:MakeFatherTable(fatherTable, "\230\173\163\229\156\168\232\191\155\232\161\140\231\154\132\232\174\161\229\136\146", weiwanchengTable)
      self:MakeFatherTable(fatherTable, "\229\183\178\229\174\140\230\136\144\231\154\132\232\174\161\229\136\146", yiwanchengTable)
      ServantRecommendProxy.Instance:SetFatherTable(currentjinduid, fatherTable)
      thisBigCellFatherTable = fatherTable
      self.goalListCtl:ResetDatas(fatherTable)
      for k, v in pairs(self.goalListCtl:GetCells()) do
        local ctl = v:GetChildCtl()
        ctl:AddEventListener(MouseEvent.MouseClick, self.ClickChooseNew, self)
        ctl:AddEventListener(ServantImproveEvent.TraceBtnClick, self.ClickFunctionBtn, self)
        ctl:AddEventListener(ServantImproveEvent.JiHuaIconClick, self.JiHuaIconClick, self)
      end
    end
  end
  if Table_ServantImproveGroup[idFromClickCell] == nil then
    return
  end
  local shopid = Table_ServantImproveGroup[idFromClickCell].shopid
  if shopid then
    self.currentShopId = shopid
    ShopProxy.Instance:CallQueryShopConfig(ServantImproveViewNew.ShopType, shopid)
    HappyShopProxy.Instance:InitShop(nil, shopid, ServantImproveViewNew.ShopType)
    self:AddMoneyRelatedDatasToFatherTable(idFromClickCell)
  else
    self.currentShopId = nil
  end
end
function ServantImproveViewNew:UpdateGroupItemListNew(idFromClickCell)
end
function ServantImproveViewNew:GetWeiWanchengListFromServer(groupData)
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
  return recieveList
end
function ServantImproveViewNew:JiHuaIconClick(cell)
  local goodData = cell:GetGoodData()
  if goodData then
    local itemData = ItemData.new(nil, goodData.goodsID)
    local tab = ReusableTable.CreateTable()
    tab.itemdata = itemData
    self:ShowItemTip(tab, self.TipRelative_UIWidget, NGUIUtil.AnchorSide.Center, {-148, -37})
    ReusableTable.DestroyAndClearTable(tab)
  end
end
function ServantImproveViewNew:ClickChooseNew(cell)
  local goodData = cell:GetGoodData()
  if goodData then
    local goods = ShopProxy.Instance:GetConfigByTypeId(ServantImproveViewNew.ShopType, self.currentShopId)
    local shopItemData = goods[goodData.id]
    if shopItemData then
      self:OnClickForShop(shopItemData)
    else
    end
  else
    cell:setSelected(not cell.isSelected)
    for k, v in pairs(self.goalListCtl:GetCells()) do
      v:OnTweenScaleOnFinished()
    end
    self.goalListCtl:Layout()
  end
end
function ServantImproveViewNew:MakeFatherTable(orginTable, NameForfather, TableForSon)
  local fatherGoal = {}
  fatherGoal.NameZh = NameForfather
  local newGoal = {}
  newGoal.fatherGoal = fatherGoal
  newGoal.childGoals = {}
  for k, v in pairs(TableForSon) do
    table.insert(newGoal.childGoals, v)
  end
  table.insert(orginTable, newGoal)
  return orginTable
end
function ServantImproveViewNew:SelfDebug(msg)
  helplog("msg:" .. msg)
end
function ServantImproveViewNew:ClickFunctionBtn(cell)
  helplog("ClickFunctionBtn 1")
  if cell.btnType == 1 then
    helplog("ClickFunctionBtn 1")
    self.functionPlanList:SetActive(true)
    self.currentViewGroupId = cell.data.groupid
    self.planListScrollView:ResetPosition()
  elseif cell.btnType == 2 then
    helplog("ClickFunctionBtn 2")
    if cell.gotoMode ~= _EmptyTable then
      FuncShortCutFunc.Me():CallByID(cell.gotoMode)
    else
      MsgManager.ShowMsgByID(26010)
    end
  elseif cell.btnType == 3 then
    helplog("ClickFunctionBtn 3")
    ServiceNUserProxy.Instance:CallReceiveGrowthServantUserCmd(0, cell.data.dwid)
  elseif cell.btnType == 5 then
    helplog("ClickFunctionBtn 5")
    local groupData = Table_ServantImproveGroup[cell.data.groupid]
    if groupData and groupData.nextid then
      ServiceNUserProxy.Instance:CallGrowthOpenServantUserCmd(cell.data.groupid)
    else
      MsgManager.ShowMsgByID(26011)
    end
  end
end
function ServantImproveViewNew:UpdateGroup()
  helplog("---recv UpdateGroup")
  self:UpdateMainItemListNew()
  local openid = self:GetCurrentPlayerOpenCellId()
  if openid then
    self:UpdateRightJiHuaView(openid)
  end
end
function ServantImproveViewNew:UpdateMainItemListNew()
  local groupList = ServantRecommendProxy.Instance:GetImproveGroupList()
  table.sort(groupList, function(l, r)
    return self:sort(l, r)
  end)
  for k, v in pairs(groupList) do
    if v.groupid ~= nil then
      if v.groupid >= 1 and v.groupid <= 10 then
        local currentid = ServantRecommendProxy.Instance:GetCurrentChengZhangId()
        if currentid ~= v.groupid and self.Node_DetailView then
          self.Node_DetailView.gameObject:SetActive(false)
        end
        ServantRecommendProxy.Instance:SetCurrentChengZhangId(v.groupid)
      elseif v.groupid >= 101 and v.groupid <= 110 then
        local currentid = ServantRecommendProxy.Instance:GetCurrentEPId()
        if currentid ~= v.groupid and self.Node_DetailView then
          self.Node_DetailView.gameObject:SetActive(false)
        end
        ServantRecommendProxy.Instance:SetCurrentEPId(v.groupid)
      end
    else
    end
  end
  local jiemianid = ServantRecommendProxy.Instance:GetCurrentShowJieMianId()
  if self.Node_DetailView and self.Node_DetailView.gameObject.activeInHierarchy then
  else
    self:ShowTiShenJiHua(jiemianid)
  end
end
function ServantImproveViewNew:UpdateMainItemList()
end
function ServantImproveViewNew:sort(l, r)
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
function ServantImproveViewNew:UpdateFunctionList()
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
  else
  end
end
function ServantImproveViewNew:RecEquipUserCmd(data)
  helplog("---recv RecEquipUserCmd")
  if not self.EquipRecommendMainNew then
    return
  end
  self.EquipRecommendMainNew:RecEquipUserCmd(data)
end
function ServantImproveViewNew:UpdateGroupItemList()
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
  end
end
function ServantImproveViewNew:UpdateGiftProgress()
end
function ServantImproveViewNew:UpdateGiftProgressNew()
  helplog("---recv UpdateGiftProgressNew")
  local currentViewGroupId = ServantRecommendProxy.Instance:GetCurrentJinDuId()
  local groupData = ServantRecommendProxy.Instance:GetImproveGroup(currentViewGroupId)
  if groupData then
    local totalGrowthValue = self:GetGroupTotalGrowth(groupData.groupid)
    local currentProgress = groupData.growth or 0
    local growthReward = GameConfig.Servant.growth_reward[groupData.groupid]
    table.sort(growthReward, function(a, b)
      return a.value < b.value
    end)
    local leftQuJianValue = 0
    local rightQuJianValue = 0
    local fenziForShow = 0
    local fenmuforShow = 0
    local liwuid = 0
    for k, v in pairs(growthReward) do
      rightQuJianValue = v.value
      if currentProgress >= leftQuJianValue and currentProgress <= rightQuJianValue then
        fenziForShow = currentProgress - leftQuJianValue
        fenmuforShow = rightQuJianValue - leftQuJianValue
        liwuid = v.rewardid
        self.currentgrowthRewarddata = v
        break
      end
      leftQuJianValue = rightQuJianValue
    end
    self.DetailView_leftcell:SetState4Detail(fenziForShow, fenmuforShow, liwuid, growthReward)
    self.DetailView_leftcell:UpdateGiftState(groupData)
    self.goalListCtl:Layout()
  end
end
function ServantImproveViewNew:GetGroupTotalGrowth(groupId)
  local totalGrowth = 0
  for k, v in pairs(Table_Growth) do
    local tGid = math.floor(k / 1000)
    if tGid == groupId then
      totalGrowth = totalGrowth + v.Growth
    end
  end
  return totalGrowth
end
function ServantImproveViewNew:RecEquipUserCmd(data)
  if not self.EquipRecommendMainNew then
    return
  end
  self.EquipRecommendMainNew:RecEquipUserCmd(data)
end
