CheckAllProfessionPanel = class("CheckAllProfessionPanel", BaseView)
CheckAllProfessionPanel.ViewType = UIViewType.NormalLayer
CheckAllProfessionPanel.cellRes = ResourcePathHelper.UICell("ProfessionIconCell")
CheckAllProfessionPanel.lineRes = ResourcePathHelper.UICell("MPLineCell")
autoImport("ProfessionIconCell")
autoImport("JobTreeCell")
CheckAllProfessionPanel.PlusClick = "CheckAllProfessionPanel_PlusClick"
local S_ProfessionDatas = {}
local topScrollViewIconTable = {}
local ProfessionIconCellTable = {}
local IconCellTable = {}
local LineTable = {}
local tempArray = {}
function CheckAllProfessionPanel:RecvProfessionChangeUserCmd(data)
  if data ~= nil and data.body ~= nil and data.body.branch ~= nil and data.body.success ~= nil then
    if data.body.success then
    else
      helplog("RecvProfessionChangeUserCmd Failed reviewCode")
    end
  else
    helplog("error message From server")
  end
end
function CheckAllProfessionPanel:RecvProfessionBuyUserCmd(data)
  if data ~= nil and data.body ~= nil and data.body.branch ~= nil and data.body.success ~= nil then
    if data.body.success then
      local boughtId = ProfessionProxy.Instance:GetBoughtProfessionIdThroughBranch(data.body.branch)
      if data.body.branch == 71 then
        helplog("\232\182\133\229\136\157\231\137\185\230\174\138\229\164\132\231\144\134")
        boughtId = 143
      end
      self.PurchaseView.gameObject:SetActive(false)
      local SysmsgData = Table_Sysmsg[25412]
      for k, v in pairs(Table_Class) do
        if v.TypeBranch == data.body.branch and v.id % 10 == 2 then
          MsgManager.FloatMsg(nil, string.format(SysmsgData.Text, v.NameZh))
          break
        end
        if v.TypeBranch == data.body.branch and v.id == 143 then
          MsgManager.FloatMsg(nil, string.format(SysmsgData.Text, v.NameZh))
          break
        end
      end
      for k, v in pairs(self.JobTreeList:GetCells()) do
        v:RecvBuyJob(boughtId)
      end
      local S_ProfessionDatas = ProfessionProxy.Instance:GetProfessionQueryUserTable()
      S_ProfessionDatas[data.body.branch] = {}
      S_ProfessionDatas[data.body.branch].branch = data.body.branch
      local b = data.body.branch
      helplog("RecvProfessionBuyUserCmd:b:" .. b)
      if b == 71 then
        S_ProfessionDatas[data.body.branch].profession = 143
      else
        S_ProfessionDatas[data.body.branch].profession = b - b % 10 + 1
      end
      S_ProfessionDatas[data.body.branch].joblv = 0
      S_ProfessionDatas[data.body.branch].isbuy = true
      S_ProfessionDatas[data.body.branch].iscurrent = false
    else
      helplog("RecvProfessionBuyUserCmd Failed reviewCode")
    end
  else
    helplog("error message From server 2")
  end
end
function CheckAllProfessionPanel:RecvProfessionQueryUserCmd(data)
end
function CheckAllProfessionPanel:RecvUpdateBranchInfoUserCmd(data)
end
function CheckAllProfessionPanel:Init()
  self:initView()
  self:addViewListener()
  self:initData()
end
function CheckAllProfessionPanel:initView()
  self.PurchaseView = self:FindGO("PurchaseView")
  self.Bg = self:FindGO("Bg", self.PurchaseView)
  self.Btns = self:FindGO("Btns", self.Bg)
  self.CancelBtn = self:FindGO("CancelBtn", self.Btns)
  self.ConfirmBtn = self:FindGO("ConfirmBtn", self.Btns)
  self.icon_zeny = self:FindGO("icon_zeny", self.PurchaseViewBg)
  self.icon_gold = self:FindGO("icon_gold", self.PurchaseViewBg)
  self.icon_gold_UISprite = self:FindGO("icon_gold", self.PurchaseViewBg):GetComponent(UISprite)
  IconManager:SetItemIcon("item_151", self.icon_gold_UISprite)
  self.icon_zenyUILabel = self:FindGO("Label", self.icon_zeny):GetComponent(UILabel)
  self.icon_goldUILabel = self:FindGO("Label", self.icon_gold):GetComponent(UILabel)
  self.contentUILabel = self:FindGO("content", self.PurchaseView):GetComponent(UILabel)
  self.PurchaseView.gameObject:SetActive(false)
  self.Collider = self:FindGO("Collider", self.PurchaseView)
  local tipData = Table_Sysmsg[26110]
  if tipData then
    self.contentUILabel.text = tipData.Text
  else
    helplog("\231\173\150\229\136\146\230\178\161\233\133\141\239\188\129\239\188\129\239\188\129\239\188\129\239\188\12926110")
  end
  self.screenView = self:FindComponent("ScrollView", UIScrollViewEx)
  self.Anchor_TopRight = self:FindGO("Anchor_TopRight")
  self.scaleButton = self:FindGO("ScaleButton", self.Anchor_TopRight)
  self.scaleButton_Symbol = self:FindComponent("Symbol", UISprite, self.scaleButton)
  self.scaleButton_Symbol.spriteName = "com_btn_enlarge"
  self.islarge = true
  self.mapBord = self:FindGO("MapBord")
  self.centerTarget = GameObjectUtil.Instance:DeepFindChild(self.mapBord, "CenterTarget")
  self.centerTarget = self.centerTarget.transform
  self.scrollView = self:FindComponent("ScrollView", UIScrollViewEx)
  self.mapScale = 1
  self.mPanel = self.scrollView.panel
  function self.mPanel.onClipMove()
    self:UpdateCenterScreen()
  end
  local panel_worldCorners = self.mPanel.worldCorners
  local worldCenterV3 = (panel_worldCorners[1] + panel_worldCorners[3]) * 0.5
  self.worldCenter = LuaVector3()
  self.worldCenter:Set(worldCenterV3[1], worldCenterV3[2], worldCenterV3[3])
  self.localCenter = LuaVector3()
  self.scrollBound = GameObjectUtil.Instance:DeepFindChild(self.mapBord, "ScrollBound")
  self.AttriIInfoButton = self:FindGO("AttriIInfoButton")
  self.AttriIInfoButtonLabel_UILabel = self:FindGO("Label", self.AttriIInfoButton):GetComponent(UILabel)
  self.AttriIInfoButtonLabel_UILabel.fontSize = GameConfig.Profession.RightTopFontSize ~= nil and GameConfig.Profession.RightTopFontSize or 14
  self.JobTreeScrollView = GameObjectUtil.Instance:DeepFindChild(self.mapBord, "JobTreeScrollView")
  self.LineTop = GameObjectUtil.Instance:DeepFindChild(self.mapBord, "LineTop")
  self.LineTop_UISprite = self.LineTop:GetComponent(UISprite)
  self.TopIcon = GameObjectUtil.Instance:DeepFindChild(self.mapBord, "TopIcon")
  self.shiyitu = GameObjectUtil.Instance:DeepFindChild(self.mapBord, "shiyitu")
  self.shiyitu.gameObject:SetActive(false)
  self.JobTreeScrollView.gameObject.transform.localPosition = Vector3(-914, -166, 0)
  self.LineTop.gameObject.transform.localPosition = Vector3(-788, 207, 0)
  self.TopIcon.gameObject.transform.localPosition = Vector3(0.9, 289.2, 0)
  if Table_Class[143] == nil then
    self.JobTreeScrollView.gameObject.transform.localPosition = Vector3(-773, -166, 0)
    self.LineTop.gameObject.transform.localPosition = Vector3(-647, 207, 0)
    self.TopIcon.gameObject.transform.localPosition = Vector3(0.9, 289.2, 0)
    self.LineTop_UISprite.width = 1314
  end
  if CheckAllProfessionProxy.Instance:IsSelfTest() then
    self.JobTreeScrollView.gameObject:SetActive(true)
    self.LineTop.gameObject:SetActive(true)
    self.TopIcon.gameObject:SetActive(true)
    self.JobTreeBord = GameObjectUtil.Instance:DeepFindChild(self.JobTreeScrollView, "JobTreeBord")
    self.JobTreeTable = self.JobTreeBord:GetComponent(UITable)
    self.JobTreeList = UIGridListCtrl.new(self.JobTreeTable, JobTreeCell, "JobTreeCell")
    tempArray = CheckAllProfessionProxy.Instance:GetCellFirstRowTable()
    self.JobTreeList:ResetDatas(tempArray)
    for k, v in pairs(self.JobTreeList:GetCells()) do
      local icontable = v:GetIconTable()
      for m, n in pairs(icontable) do
        n:AddEventListener(CheckAllProfessionPanel.PlusClick, self.clickPlusHandler, self)
      end
    end
  else
    self.JobTreeScrollView.gameObject:SetActive(false)
    self.LineTop.gameObject:SetActive(false)
    self.TopIcon.gameObject:SetActive(false)
  end
  self.HelpButton = self:FindGO("HelpButton")
  if self.HelpButton then
    self:AddClickEvent(self.HelpButton, function(go)
      local helpData = Table_Help[127]
      if helpData then
        TipsView.Me():ShowGeneralHelp(helpData.Desc, helpData.Title)
      end
    end)
  else
  end
  local Astrolabe_PlateZoom_Param = 2
  self:ZoomScrollView(0.7, 0.1, function()
    self.islarge = true
    self.scaleButton_Symbol.spriteName = "com_btn_enlarge"
  end)
  self:AddClickEvent(self.scaleButton, function(go)
    if self.islarge then
      self:ZoomScrollView(Astrolabe_PlateZoom_Param, 0.4, function()
        self.islarge = false
        self.scaleButton_Symbol.spriteName = "com_btn_narrow"
      end)
    else
      self:ZoomScrollView(0.7, 0.4, function()
        self.islarge = true
        self.scaleButton_Symbol.spriteName = "com_btn_enlarge"
      end)
    end
  end)
end
function CheckAllProfessionPanel:UpdateCenterScreen()
  local x, y, z = LuaGameObject.InverseTransformPointByVector3(self.mapBord.transform, self.worldCenter)
  self.localCenter:Set(x, y, z)
end
local tempV3_1, tempV3_2 = LuaVector3(), LuaVector3()
local tempV3_3 = LuaVector3()
function CheckAllProfessionPanel:ZoomScrollView(endScale, time, onfinish)
  time = time or 1
  tempV3_1:Set(self.mapScale, self.mapScale, self.mapScale)
  tempV3_3:Set(endScale, endScale, 1)
  self.centerTarget.transform.localPosition = self.localCenter
  tempV3_2:Set(LuaGameObject.GetPosition(self.centerTarget))
  local mTrans = self.scrollView.transform
  LeanTween.cancel(mTrans.gameObject)
  LeanTween.value(mTrans.gameObject, function(f)
    self.mapBord.transform.localScale = LuaVector3.Lerp(tempV3_1, tempV3_3, f)
    local before = self.centerTarget.transform.position
    local after = LuaVector3.Lerp(tempV3_2, self.worldCenter, f)
    local offset = after - before
    local mlPosition = mTrans.localPosition
    mTrans.position = mTrans.position + offset
    self.mPanel.clipOffset = self.mPanel.clipOffset - (mTrans.localPosition - mlPosition)
    local b = NGUIMath.CalculateRelativeWidgetBounds(mTrans, self.scrollBound.transform)
    local calOffset = self.mPanel:CalculateConstrainOffset(b.min, b.max)
    if calOffset.magnitude >= 0.01 then
      mTrans.localPosition = mTrans.localPosition + calOffset
      self.mPanel.clipOffset = self.mPanel.clipOffset - LuaVector2(calOffset.x, calOffset.y)
    end
  end, 0, 1, time):setOnComplete(function()
    if onfinish then
      onfinish()
    end
    self.mapScale = endScale
  end):setDestroyOnComplete(true)
end
function CheckAllProfessionPanel:addViewListener()
  self:AddClickEvent(self.Collider.gameObject, function(go)
    self.PurchaseView.gameObject:SetActive(false)
  end)
  self:AddClickEvent(self.CancelBtn.gameObject, function(go)
    self.PurchaseView.gameObject:SetActive(false)
  end)
  self:AddListenEvt(ServiceEvent.NUserProfessionQueryUserCmd, self.RecvProfessionQueryUserCmd)
  self:AddListenEvt(ServiceEvent.NUserProfessionBuyUserCmd, self.RecvProfessionBuyUserCmd)
  self:AddListenEvt(ServiceEvent.NUserProfessionChangeUserCmd, self.RecvProfessionChangeUserCmd)
  self:AddListenEvt(ServiceEvent.NUserUpdateBranchInfoUserCmd, self.RecvUpdateBranchInfoUserCmd)
end
function CheckAllProfessionPanel:initData()
  S_ProfessionDatas = {}
  topScrollViewIconTable = {}
  ProfessionIconCellTable = {}
  IconCellTable = {}
  LineTable = {}
end
function CheckAllProfessionPanel:OnExit()
  CheckAllProfessionPanel.super.OnExit(self)
  local gOManager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  gOManager_Camera:ActiveMainCamera(true)
end
function CheckAllProfessionPanel:OnEnter()
  CheckAllProfessionPanel.super.OnEnter(self)
  local gOManager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  gOManager_Camera:ActiveMainCamera(false)
  if CheckAllProfessionProxy.Instance:IsSelfTest() then
  else
    self:GetNextTurnTableAndShow(1, nil)
    self.FirstRowIconTable = {1}
    self.SecondRowIconTable = {
      12,
      72,
      22,
      82,
      32,
      92,
      42,
      102,
      52,
      22,
      62,
      132
    }
    self.ThirdRowIconTable = {}
    self.FourthRowIconTable = {}
    for k, v in pairs(LineTable) do
      local id = v:GetId()
      local classData = Table_Class[id]
      if id % 10 >= 3 and not ProfessionProxy.Instance:ShouldThisIdVisible(id) then
        v.gameObject:SetActive(false)
      end
      if classData and classData.IsOpen ~= 1 then
        v.gameObject:SetActive(false)
      end
    end
  end
end
function CheckAllProfessionPanel:GetMaxBranchCount()
  local i = 0
  for k, v in pairs(Table_Class) do
    if v.id % 10 == 2 then
      i = i + 1
      if v.gender ~= nil and v.gender ~= ProfessionProxy.Instance:GetCurSex() or v.IsOpen ~= 1 then
        i = i - 1
      end
    end
  end
  if Table_Class[143] ~= nil then
    i = i + 1
  end
  return i
end
function CheckAllProfessionPanel:GetNextTurnTableAndShow(id, previousId, countOfBro, index, turnNumber)
  countOfBro = countOfBro or 1
  index = index or 0
  turnNumber = turnNumber or 1
  local nowClassData = Table_Class[id]
  if nowClassData.IsOpen == 0 then
    return nil
  end
  if nowClassData ~= nil then
    self:DrawHeadIcon(id, previousId, countOfBro, index, turnNumber)
    local nextTurnTable = nowClassData.AdvanceClass
    if id == 1 then
      do
        local haveFoundChaoChu = false
        for k, v in pairs(nextTurnTable) do
          if v == 143 then
            haveFoundChuXin = true
          end
        end
        if haveFoundChaoChu == false then
          nextTurnTable = {}
          for k, v in pairs(nowClassData.AdvanceClass) do
            table.insert(nextTurnTable, v)
          end
          table.insert(nextTurnTable, 143)
          helplog("\232\175\183\231\173\150\229\136\146\230\163\128\230\159\165\233\133\141\231\189\174\232\161\168\239\188\129\239\188\129\239\188\129\239\188\129\239\188\129\239\188\129143\230\188\143\228\186\134\239\188\129\239\188\129\239\188\129\239\188\129\239\188\129\239\188\129\239\188\129")
        end
      end
    else
    end
    if nextTurnTable ~= nil then
      local countOfBroXiuzheng = #nextTurnTable
      for k, v in pairs(nextTurnTable) do
        if Table_Class[v].IsOpen == 0 then
          countOfBroXiuzheng = countOfBroXiuzheng - 1
        end
        if Table_Class[v].gender ~= nil and Table_Class[v].gender ~= ProfessionProxy.Instance:GetCurSex() then
          countOfBroXiuzheng = countOfBroXiuzheng - 1
        end
      end
      local kXiuZheng = 1
      for k, v in pairs(nextTurnTable) do
        if Table_Class[v].gender ~= nil and Table_Class[v].gender ~= ProfessionProxy.Instance:GetCurSex() then
        else
          self:GetNextTurnTableAndShow(v, id, countOfBroXiuzheng, kXiuZheng, turnNumber + 1)
          kXiuZheng = kXiuZheng + 1
        end
      end
    elseif nextTurnTable == nil then
      local nextId = id + 1
      self:GetNextTurnTableAndShow(nextId, id, 1, 1, turnNumber + 1)
    end
  else
  end
  return nil
end
local tempVector3 = LuaVector3.zero
local IconCellTable = {}
function CheckAllProfessionPanel:GetThisIdForwardBranch(id, branchnumber)
  local forward = id - 10
  local classData = Table_Class[forward]
  if forward == 1 then
    return 0
  end
  if classData then
    local addNumber = #classData.AdvanceClass
    for k, v in pairs(classData.AdvanceClass) do
      if Table_Class[v].IsOpen == 0 or Table_Class[v].gender ~= nil and Table_Class[v].gender ~= ProfessionProxy.Instance:GetCurSex() then
        addNumber = addNumber - 1
      end
    end
    branchnumber = self:GetThisIdForwardBranch(forward, branchnumber) + addNumber
    return branchnumber
  else
    return 0
  end
end
function CheckAllProfessionPanel:DrawHeadIcon(id, previousId, countOfBro, index, turnNumber)
  local size = UIManagerProxy.Instance.rootSize
  local MaxBranchCount = self:GetMaxBranchCount()
  local spaceV = size[2] / 6
  local spaceH = size[1] / (MaxBranchCount + 1)
  if id == 1 then
    tempVector3:Set(0, size[2] / 2 - spaceV, 0)
  elseif id % 10 == 1 then
    local classData = Table_Class[id]
    local index = classData.Type
    local BelowBranchNumber = #Table_Class[id].AdvanceClass
    for k, v in pairs(Table_Class[id].AdvanceClass) do
      if Table_Class[v].IsOpen == 0 or Table_Class[v].gender ~= nil and Table_Class[v].gender ~= ProfessionProxy.Instance:GetCurSex() then
        BelowBranchNumber = BelowBranchNumber - 1
      end
    end
    local forwardbranchnumber = self:GetThisIdForwardBranch(id, 0)
    tempVector3:Set(0 - size[1] / 2 + size[1] / (MaxBranchCount + 1) * (forwardbranchnumber + 1) + size[1] / (MaxBranchCount + 1) * (0.5 * (BelowBranchNumber - 1)), size[2] / 2 - spaceV * 2, 0)
  elseif id % 10 == 2 then
    local previousX = 0
    if IconCellTable[previousId] ~= nil then
      previousX = IconCellTable[previousId].transform.localPosition.x
    end
    tempVector3:Set(previousX - spaceH / 2 * (countOfBro - 1) + spaceH * (index - 1), size[2] / 2 - spaceV * 3, 0)
  elseif id == 143 or id == 144 then
    local shuIndex = id % 10 + 1
    if IconCellTable[previousId] ~= nil and IconCellTable ~= nil and IconCellTable[previousId] ~= nil then
      local forwardbranchnumber = self:GetThisIdForwardBranch(61, 0)
      local tmpX = 0 - size[1] / 2 + size[1] / (MaxBranchCount + 1) * (forwardbranchnumber + 1) + size[1] / (MaxBranchCount + 1) * 0.5
      local tmpX2 = tmpX - spaceH / 2 * 1 + spaceH * 2
      tempVector3:Set(tmpX2, size[2] / 2 - spaceV * shuIndex, 0)
    else
      helplog("review code!!!!")
    end
  elseif turnNumber >= 3 then
    local shuIndex = id % 10 + 1
    if IconCellTable[previousId] ~= nil and IconCellTable ~= nil and IconCellTable[previousId] ~= nil then
      tempVector3:Set(IconCellTable[previousId].transform.localPosition.x, size[2] / 2 - spaceV * shuIndex, 0)
    else
      helplog("review code!!!!")
    end
  end
  local holder = self:FindGO("ScrollView")
  local obj
  if obj == nil then
    obj = Game.AssetManager_UI:CreateAsset(CheckAllProfessionPanel.cellRes, holder)
  end
  IconCellTable[id] = obj
  obj.gameObject.name = tostring(id)
  obj.gameObject.transform:SetParent(self.mapBord.transform, false)
  obj.transform.localPosition = tempVector3
  pCell = ProfessionIconCell.new(obj)
  pCell:SetIcon(id)
  pCell:Setid(id)
  if id == 1 then
    pCell:SetState(0, id)
  elseif ProfessionProxy.Instance:IsThisIdYiJiuZhi(id) then
    pCell:SetState(1, id)
  elseif ProfessionProxy.Instance:IsThisIdYiGouMai(id) == false and ProfessionProxy.Instance:IsThisIdKeGouMai(id) then
    pCell:SetState(3, id)
  else
    pCell:SetState(4, id)
  end
  local attr = GameConfig.ProfessionAttrPlus[id] or ""
  pCell:SetAttr(attr)
  self:DrawLine(id, previousId, countOfBro, index, turnNumber)
  pCell:AddEventListener(CheckAllProfessionPanel.PlusClick, self.clickPlusHandler, self)
  if GameConfig.Profession and GameConfig.Profession.banThirdJobChange and GameConfig.Profession.banThirdJobChange == true and id % 10 > 3 then
    pCell.gameObject:SetActive(false)
  end
  table.insert(ProfessionIconCellTable, pCell)
end
function CheckAllProfessionPanel:clickPlusHandler(id)
  if GameConfig.SystemForbid.OpenJapanMultiJobs then
    helplog("\230\178\161\230\168\170\229\178\151 \230\137\147\229\188\128")
    local moneynumber, moneytype = ProfessionProxy.Instance:GetRightMoneyNumberAndMoneyTypeForThisId(id)
    if moneytype.id == 100 then
      self.icon_zeny.gameObject:SetActive(true)
      self.icon_gold.gameObject:SetActive(false)
      self.icon_zenyUILabel.text = moneynumber
    elseif moneytype.id == 151 then
      self.icon_zeny.gameObject:SetActive(false)
      self.icon_gold.gameObject:SetActive(true)
      self.icon_goldUILabel.text = moneynumber
    end
  else
    local isOriginProfession = ProfessionProxy.Instance:isOriginProfession(id)
    if isOriginProfession then
      local needmoney = GameConfig.Profession.price_zeny or 0
      self.icon_zeny.gameObject:SetActive(true)
      self.icon_gold.gameObject:SetActive(false)
      self.icon_zenyUILabel.text = needmoney
    else
      local needmoney = GameConfig.Profession.price_gold
      self.icon_zeny.gameObject:SetActive(false)
      self.icon_gold.gameObject:SetActive(true)
      self.icon_goldUILabel.text = needmoney
    end
  end
  self:AddClickEvent(self.ConfirmBtn.gameObject, function(go)
    ProfessionProxy.Instance:PurchaseFunc(id)
  end)
  self.PurchaseView.gameObject:SetActive(true)
end
function CheckAllProfessionPanel:DrawLine(id, previousId, countOfBro, index, turnNumber)
  local holder = self:FindGO("ScrollView")
  local obj, lineCell
  for k, v in pairs(LineTable) do
    if v.gameObject.name == "resetline" then
      obj = v.gameObject
      lineCell = v
      break
    end
  end
  if lineCell == nil then
    obj = Game.AssetManager_UI:CreateAsset(ProfessionPage.lineRes, self.mapBord)
    lineCell = MPLineCell.new(obj)
  end
  obj.gameObject.name = "line" .. id
  lineCell:SetId(id)
  lineCell:SetPreviousId(previousId)
  local leftid, rightid, centerid
  if id == 1 then
    obj.gameObject.transform.localPosition = Vector3(-17, 194, 0)
    local thisidClass = Table_Class[id]
    local thisac = thisidClass.AdvanceClass
    local p1 = ProfessionProxy.Instance:IsThisIdYiJiuZhi(thisac[1])
    local p2 = ProfessionProxy.Instance:IsThisIdYiJiuZhi(thisac[2])
    local p3 = ProfessionProxy.Instance:IsThisIdYiJiuZhi(thisac[3])
    local p4 = ProfessionProxy.Instance:IsThisIdYiJiuZhi(thisac[4])
    local p5 = ProfessionProxy.Instance:IsThisIdYiJiuZhi(thisac[5])
    local p6 = ProfessionProxy.Instance:IsThisIdYiJiuZhi(thisac[6])
    local p7 = ProfessionProxy.Instance:IsThisIdYiJiuZhi(thisac[7])
    lineCell:ShowLine(4)
    lineCell:CRootSetState(p1, p2, p3, p4, p5, p6, p7)
  elseif id % 10 == 1 then
    local size = UIManagerProxy.Instance.rootSize
    local spaceV = size[2] / 6
    local thisIconCell = IconCellTable[id]
    local x = thisIconCell.gameObject.transform.localPosition.x
    local thisY = thisIconCell.gameObject.transform.localPosition.y
    obj.gameObject.transform.localPosition = Vector3(x, thisY - spaceV / 2, 0)
    local thisidClass = Table_Class[id]
    local thisac = thisidClass.AdvanceClass
    local fixedacNumber = #thisac
    local fixedacTable = {}
    for k, v in pairs(thisac) do
      if Table_Class[v].IsOpen == 0 then
      elseif Table_Class[v].gender ~= nil and Table_Class[v].gender ~= ProfessionProxy.Instance:GetCurSex() then
      else
        table.insert(fixedacTable, v)
      end
    end
    if #fixedacTable == 1 then
      local thisIconCell = IconCellTable[id]
      local previousIdIconCell = IconCellTable[previousId]
      local x = thisIconCell.gameObject.transform.localPosition.x
      local thisY = thisIconCell.gameObject.transform.localPosition.y
      local finalY = thisY - spaceV / 2
      obj.gameObject.transform.localPosition = Vector3(x, finalY, 0)
      local lineCell = MPLineCell.new(obj)
      lineCell:ShowLine(2)
      lineCell:BranchSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(fixedacTable[1]))
    elseif #fixedacTable == 2 then
      lineCell:ShowLine(5)
      leftid = fixedacTable[1]
      rightid = fixedacTable[2]
      lineCell:CRootTwoSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(leftid), ProfessionProxy.Instance:IsThisIdYiJiuZhi(rightid))
    elseif #fixedacTable == 3 then
      lineCell:ShowLine(6)
      leftid = fixedacTable[1]
      centerid = fixedacTable[2]
      rightid = fixedacTable[3]
      lineCell:CRootThreeSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(leftid), ProfessionProxy.Instance:IsThisIdYiJiuZhi(centerid), ProfessionProxy.Instance:IsThisIdYiJiuZhi(rightid))
    else
      helplog("reviewCode")
    end
  elseif id % 10 == 2 then
    obj.gameObject.transform.localPosition = Vector3(100000, 0, 0)
  elseif 2 < id % 10 then
    local thisIconCell = IconCellTable[id]
    local previousIdIconCell = IconCellTable[previousId]
    local x = thisIconCell.gameObject.transform.localPosition.x
    local thisY = thisIconCell.gameObject.transform.localPosition.y
    local previousY = previousIdIconCell.gameObject.transform.localPosition.y
    local finalY = (thisY + previousY) / 2
    obj.gameObject.transform.localPosition = Vector3(x, finalY, 0)
    local lineCell = MPLineCell.new(obj)
    lineCell:ShowLine(2)
    lineCell:BranchSetState(ProfessionProxy.Instance:IsThisIdYiJiuZhi(id))
  else
    helplog("reviewcode")
  end
  if GameConfig.Profession and GameConfig.Profession.banThirdJobChange and GameConfig.Profession.banThirdJobChange == true and 3 < id % 10 then
    lineCell.gameObject:SetActive(false)
  end
  if id == 143 then
    lineCell.gameObject:SetActive(false)
  end
  table.insert(LineTable, lineCell)
end
function CheckAllProfessionPanel:BuyThenUpdateLine(buyBranch)
  local advanceClassForChaochu = {}
  for k, v in pairs(Table_Class[1].AdvanceClass) do
    table.insert(advanceClassForChaochu, v)
  end
  table.insert(advanceClassForChaochu, 143)
  for k, v in pairs(LineTable) do
    local lineid = v:GetId()
    if lineid == 1 then
      local ChuXinZheAdvanceClassTable = advanceClassForChaochu
      for m, n in pairs(ChuXinZheAdvanceClassTable) do
        if ProfessionProxy.Instance:DoesThisIdCanBuyBranch(n, buyBranch) then
          local thisidClass = Table_Class[1]
          local thisac = advanceClassForChaochu
          local p1 = ProfessionProxy.Instance:IsThisIdYiJiuZhi(thisac[1]) or n == thisac[1]
          local p2 = ProfessionProxy.Instance:IsThisIdYiJiuZhi(thisac[2]) or n == thisac[2]
          local p3 = ProfessionProxy.Instance:IsThisIdYiJiuZhi(thisac[3]) or n == thisac[3]
          local p4 = ProfessionProxy.Instance:IsThisIdYiJiuZhi(thisac[4]) or n == thisac[4]
          local p5 = ProfessionProxy.Instance:IsThisIdYiJiuZhi(thisac[5]) or n == thisac[5]
          local p6 = ProfessionProxy.Instance:IsThisIdYiJiuZhi(thisac[6]) or n == thisac[6]
          local p7 = ProfessionProxy.Instance:IsThisIdYiJiuZhi(thisac[7]) or n == thisac[7]
          v:CRootSetState(p1, p2, p3, p4, p5, p6, p7)
        end
      end
      break
    end
  end
end
