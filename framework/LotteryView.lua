autoImport("FuncZenyShop")
LotteryView = class("LotteryView", ContainerView)
LotteryView.ViewType = UIViewType.NormalLayer
local _Ten = 10
local tempVector3 = LuaVector3.zero
local _AEDiscountCoinTypeCoin = AELotteryDiscountData.CoinType.Coin
local _AEDiscountCoinTypeTicket = AELotteryDiscountData.CoinType.Ticket
function LotteryView:OnEnter()
  LotteryView.super.OnEnter(self)
  local _LotteryProxy = LotteryProxy.Instance
  _LotteryProxy:CallQueryLotteryInfo(self.lotteryType)
  _LotteryProxy:SetIsOpenView(true)
  self:NormalCameraFaceTo()
  self:sendNotification(LotteryEvent.LotteryViewEnter)
end
function LotteryView:OnExit()
  LotteryProxy.Instance:SetIsOpenView(false)
  self:CameraReset()
  LotteryView.super.OnExit(self)
end
function LotteryView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end
function LotteryView:FindObjs()
  self.money = self:FindGO("Money"):GetComponent(UILabel)
  self.cost = self:FindGO("Cost"):GetComponent(UILabel)
  self.skipBtn = self:FindGO("SkipBtn"):GetComponent(UISprite)
  self.lotteryDiscount = self:FindGO("LotteryDiscount"):GetComponent(UILabel)
  self.lotteryLimit = self:FindGO("LotteryLimit"):GetComponent(UILabel)
  self.lotteryLimitBg = self:FindGO("Bg1", self.lotteryLimit.gameObject):GetComponent(UISprite)
  self.lotteryBtn = self:FindGO("LotteryBtn")
  self.ticketDiscount = self:FindGO("TicketDiscount")
  if self.ticketDiscount then
    self.ticketDiscount = self.ticketDiscount:GetComponent(UILabel)
  end
  self.ticketLimit = self:FindGO("TicketLimit")
  if self.ticketLimit then
    self.ticketLimit = self.ticketLimit:GetComponent(UILabel)
  end
  self.tenCost = self:FindGO("TenCost")
  if self.tenCost then
    self.tenCost = self.tenCost:GetComponent(UILabel)
  end
  self.lotteryTenBtn = self:FindGO("LotteryTenBtn")
  self.btnGrid = self:FindGO("BtnGrid")
  if self.btnGrid then
    self.btnGrid = self.btnGrid:GetComponent(UIGrid)
  end
end
function LotteryView:AddEvts()
  local addMoney = self:FindGO("AddMoney")
  self:AddClickEvent(addMoney, function()
    self:JumpZenyShop()
  end)
  self:AddClickEvent(self.skipBtn.gameObject, function()
    self:Skip()
  end)
  self:AddClickEvent(self.lotteryBtn, function()
    OverseaHostHelper:GachaUseComfirm(self.costValue, function()
      self:Lottery()
    end)
  end)
  if self.lotteryTenBtn then
    self:AddClickEvent(self.lotteryTenBtn, function()
      OverseaHostHelper:GachaUseComfirm(self.costValue * 10, function()
        self:LotteryTen()
      end)
    end)
  end
end
function LotteryView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
  self:AddListenEvt(ServiceEvent.ItemQueryLotteryInfo, self.InitView)
  self:AddListenEvt(LotteryEvent.EffectStart, self.HandleEffectStart)
  self:AddListenEvt(LotteryEvent.EffectEnd, self.HandleEffectEnd)
  self:AddListenEvt(ServiceEvent.ItemLotteryCmd, self.UpdateLimit)
  self:AddListenEvt(ServiceEvent.ActivityEventActivityEventNtf, self.HandleActivityEventNtf)
  self:AddListenEvt(ServiceEvent.ActivityEventActivityEventNtfEventCntCmd, self.HandleActivityEventNtfEventCnt)
  self:AddListenEvt(XDEUIEvent.LotteryAnimationEnd, self.lotteryAnimationEnd)
end
function LotteryView:InitShow()
  self.tipData = {}
  self.tipData.funcConfig = {}
  local npcdata = self:GetNpcDataFromViewData()
  self.npcId = npcdata == nil and 0 or npcdata.data.id
  local moneyIcon = self:FindGO("MoneyIcon"):GetComponent(UISprite)
  local lotteryIcon = self:FindGO("LotteryIcon"):GetComponent(UISprite)
  local lotteryTenIcon = self:FindGO("LotteryTenIcon")
  lotteryTenIcon = lotteryTenIcon and lotteryTenIcon:GetComponent(UISprite)
  local money = Table_Item[GameConfig.MoneyId.Lottery]
  if money then
    local icon = money.Icon
    if icon then
      IconManager:SetItemIcon(icon, moneyIcon)
      IconManager:SetItemIcon(icon, lotteryIcon)
      if lotteryTenIcon then
        IconManager:SetItemIcon(icon, lotteryTenIcon)
      end
    end
  end
  self:UpdateMoney()
  self:UpdateSkip()
end
function LotteryView:InitView()
  self:UpdateDiscount()
  self:UpdateLimit()
  self:UpdateOnceMaxCount()
end
function LotteryView:JumpZenyShop()
  FuncZenyShop.Instance():OpenUI(PanelConfig.ZenyShopGachaCoin)
end
function LotteryView:Skip()
  local skipType = LotteryProxy.Instance:GetSkipType(self.lotteryType)
  TipManager.Instance:ShowSkipAnimationTip(skipType, self.skipBtn, NGUIUtil.AnchorSide.Top, {120, 50})
end
function LotteryView:Lottery()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    self:CallLottery(data.price)
  end
end
function LotteryView:LotteryTen()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    self:CallLottery(data.price, nil, nil, _Ten)
  end
end
function LotteryView:ToRecover()
  self:ShowRecover(true)
  if self.isUpdateRecover then
    self:UpdateRecover()
    self.isUpdateRecover = false
  end
end
function LotteryView:Recover()
  Table_Sysmsg[3552].Text = "\233\129\184\230\138\158\227\129\151\227\129\159[c][63cd4e]%s[-][/c]\229\128\139\227\129\174\227\130\162\227\130\164\227\131\134\227\131\160\227\130\146[c][63cd4e]%s[-][/c]\229\128\139\227\129\174%s\227\129\168\228\186\164\230\143\155\227\129\151\227\129\190\227\129\153\227\129\139\239\188\159"
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  local rItemId = Ticket.recoverItemId ~= nil and Ticket.recoverItemId or Ticket.itemid
  local ticketName = Table_Item[rItemId].NameZh
  if self.canRecover then
    self.isRecover = true
    local isExist, ticketCount = LotteryProxy.Instance:GetSpecialEquipCount(self.recoverSelect, self.lotteryType)
    if isExist then
      helplog("LotteryView:Recover 1")
      MsgManager.DontAgainConfirmMsgByID(3556, function()
        helplog("CallLotteryRecoveryCmd")
        ServiceItemProxy.Instance:CallLotteryRecoveryCmd(self.recoverSelect, self.npcId, self.lotteryType)
      end, nil, nil, #self.recoverSelect, LotteryProxy.Instance:GetRecoverTotalPrice(self.recoverSelect, self.lotteryType), ticketName, ticketCount, ticketName)
    else
      helplog("LotteryView:Recover 2")
      MsgManager.ConfirmMsgByID(3552, function()
        helplog("CallLotteryRecoveryCmd")
        ServiceItemProxy.Instance:CallLotteryRecoveryCmd(self.recoverSelect, self.npcId, self.lotteryType)
      end, nil, nil, #self.recoverSelect, LotteryProxy.Instance:GetRecoverTotalPrice(self.recoverSelect, self.lotteryType), ticketName)
    end
  end
end
function LotteryView:CallLottery(price, year, month, times)
  times = times or 1
  local discount
  price, discount = self:GetDiscountByCoinType(_AEDiscountCoinTypeCoin, price * times)
  if price ~= self.costValue * times and not discount:IsInActivity() then
    MsgManager.ConfirmMsgByID(25314, function()
      self:UpdateCost()
      self:UpdateDiscount()
      self:UpdateLimit()
    end)
    return
  end
  if price > MyselfProxy.Instance:GetLottery() then
    MsgManager.ConfirmMsgByID(3551, function()
      self:JumpZenyShop()
    end)
    return
  end
  local _LotteryProxy = LotteryProxy.Instance
  if not _LotteryProxy:CheckTodayCanBuy(self.lotteryType, times) then
    MsgManager.ShowMsgByID(3641)
    return
  end
  local skipType = _LotteryProxy:GetSkipType(self.lotteryType)
  local skipValue = _LotteryProxy:IsSkipGetEffect(skipType)
  ServiceItemProxy.Instance:CallLotteryCmd(year, month, self.npcId, skipValue, price, nil, self.lotteryType, times)
end
function LotteryView:CallTicket(year, month, times)
  times = times or 1
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    local cost, discount = self:GetDiscountByCoinType(_AEDiscountCoinTypeTicket, Ticket.count * times)
    if cost ~= self.ticketCostValue and not discount:IsInActivity() then
      MsgManager.ConfirmMsgByID(25314, function()
        self:UpdateTicketCost()
        self:UpdateDiscount()
        self:UpdateLimit()
      end)
      return
    end
    if cost > BagProxy.Instance:GetItemNumByStaticID(Ticket.itemid) then
      MsgManager.ShowMsgByID(3554, self.ticketName)
      return
    end
    local _LotteryProxy = LotteryProxy.Instance
    local skipType = _LotteryProxy:GetSkipType(self.lotteryType)
    local skipValue = _LotteryProxy:IsSkipGetEffect(skipType)
    ServiceItemProxy.Instance:CallLotteryCmd(year, month, self.npcId, skipValue, nil, Ticket.itemid, self.lotteryType, times)
  end
end
function LotteryView:InitTicket()
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    local ticketIcon = self:FindGO("TicketIcon"):GetComponent(UISprite)
    local ticketCostIcon = self:FindGO("TicketCostIcon"):GetComponent(UISprite)
    local ticket = Table_Item[Ticket.itemid]
    if ticket then
      IconManager:SetItemIcon(ticket.Icon, ticketIcon)
      IconManager:SetItemIcon(ticket.Icon, ticketCostIcon)
      self.ticketName = ticket.NameZh
    end
  end
end
function LotteryView:InitRecover()
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    local recoverIcon = self:FindGO("RecoverIcon"):GetComponent(UISprite)
    local toRecoverIcon = self:FindGO("ToRecoverIcon"):GetComponent(UISprite)
    local recoverTitle = self:FindGO("RecoverTitle"):GetComponent(UILabel)
    helplog("LotteryView:InitRecover()", Ticket.recoverItemId)
    local rItemId = Ticket.recoverItemId ~= nil and Ticket.recoverItemId or Ticket.itemid
    local ticket = Table_Item[rItemId]
    if ticket then
      IconManager:SetItemIcon(ticket.Icon, recoverIcon)
      IconManager:SetItemIcon(ticket.Icon, toRecoverIcon)
      recoverTitle.text = string.format(ZhString.Lottery_RecoverTitle, ticket.NameZh)
    end
  end
end
function LotteryView:UpdateMoney()
  if self.money ~= nil then
    self.money.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetLottery())
  end
end
function LotteryView:UpdateCost()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data then
    self:TryShowOff(data.todayCount)
    self:UpdateCostValue(data.price, data.onceMaxCount)
  end
end
function LotteryView:TryShowOff(count)
  local discount = self:FindGO("LotteryDiscount")
  if discount ~= nil then
    if self.lotteryType == 3 and count == 0 then
      discount:SetActive(true)
    else
      discount:SetActive(false)
    end
  end
end
function LotteryView:UpdateCostValue(cost, onceMaxCount)
  self.costValue = self:GetDiscountByCoinType(_AEDiscountCoinTypeCoin, cost)
  self.cost.text = self.costValue
  if self.tenCost and onceMaxCount == _Ten then
    self.tenCost.text = self.costValue * _Ten
  end
end
function LotteryView:UpdateTicket()
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    self.ticket.text = StringUtil.NumThousandFormat(BagProxy.Instance:GetItemNumByStaticID(Ticket.itemid))
  end
end
function LotteryView:UpdateTicketCost()
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    self.ticketCostValue = self:GetDiscountByCoinType(_AEDiscountCoinTypeTicket, Ticket.count)
    self.ticketCost.text = self.ticketCostValue
  end
end
function LotteryView:UpdateSkip()
end
function LotteryView:getSkip()
  local _LotteryProxy = LotteryProxy.Instance
  local skipType = _LotteryProxy:GetSkipType(self.lotteryType)
  return _LotteryProxy:IsSkipGetEffect(skipType)
end
function LotteryView:lotteryAnimationEnd()
  if self.isShowRecover and self:getSkip() == false then
    self:TryUpdateRecover(true)
  end
end
function LotteryView:TryUpdateRecover(animationEnd)
  if self.isRecover then
    self:UpdateRecover()
    self.isRecover = false
  elseif self:getSkip() == true or animationEnd then
    self:UpdateRecover()
  end
end
function LotteryView:UpdateRecover()
  local data = LotteryProxy.Instance:GetRecover(self.lotteryType)
  if data then
    local newData = self:ReUniteCellData(data, 3)
    self.recoverHelper:UpdateInfo(newData)
    self.recoverEmpty:SetActive(#data == 0)
  end
  TableUtility.ArrayClear(self.recoverSelect)
  self:UpdateRecoverBtn()
end
function LotteryView:UpdateRecoverBtn()
  local total = LotteryProxy.Instance:GetRecoverTotalCost(self.recoverSelect, self.lotteryType)
  self.recoverTotalLabel.text = total
  self.canRecover = #self.recoverSelect > 0
  if self.canRecover then
    self.recoverBtn.CurrentState = 0
    self.recoverLabel.effectStyle = UILabel.Effect.Outline
  else
    self.recoverBtn.CurrentState = 1
    self.recoverLabel.effectStyle = UILabel.Effect.None
  end
end
function LotteryView:UpdateDiscount()
  local price, coinDiscount, ticketDiscount
  price, coinDiscount = self:GetDiscountByCoinType(_AEDiscountCoinTypeCoin)
  if coinDiscount ~= nil then
    local discountValue = coinDiscount:GetDiscount()
    local isShow = discountValue ~= 100
    self.lotteryDiscount.gameObject:SetActive(isShow)
    if isShow then
      self.lotteryDiscount.text = string.format(ZhString.Lottery_Discount, 100 - discountValue)
    end
  else
    self.lotteryDiscount.gameObject:SetActive(false)
  end
  if self.ticketDiscount then
    price, ticketDiscount = self:GetDiscountByCoinType(_AEDiscountCoinTypeTicket)
    if ticketDiscount ~= nil then
      local discountValue = ticketDiscount:GetDiscount()
      local isShow = discountValue ~= 100
      self.ticketDiscount.gameObject:SetActive(isShow)
      if isShow then
        self.ticketDiscount.text = string.format(ZhString.Lottery_Discount, 100 - discountValue)
      end
    else
      self.ticketDiscount.gameObject:SetActive(false)
    end
  end
end
function LotteryView:UpdateOnceMaxCount()
  if self.lotteryTenBtn then
    local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
    if data ~= nil then
      local isTen = data.onceMaxCount == _Ten
      self.lotteryTenBtn:SetActive(isTen)
      self.btnGrid.cellWidth = isTen and 220 or 290
      self.btnGrid:Reposition()
      local trans = self.lotteryLimit.transform
      tempVector3:Set(LuaGameObject.GetLocalPosition(trans))
      if isTen then
        tempVector3:Set(-356, tempVector3.y, tempVector3.z)
      else
        tempVector3:Set(-393, tempVector3.y, tempVector3.z)
      end
      trans.localPosition = tempVector3
    end
  end
end
function LotteryView:UpdateLimit()
  local sb = LuaStringBuilder.CreateAsTable()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data ~= nil then
    if data.maxCount ~= 0 then
      sb:Append(string.format(ZhString.Lottery_TodayLimit, data.todayCount, data.maxCount))
    end
    if self.lotteryType == LotteryType.Card then
      if 0 < #sb.content then
        sb:Append("  ")
      end
      sb:Append(string.format(ZhString.Lottery_CardLimit, data.todayExtraCount, data.maxExtraCount))
    end
  end
  local price, coinDiscount, ticketDiscount
  price, coinDiscount = self:GetDiscountByCoinType(_AEDiscountCoinTypeCoin)
  if coinDiscount ~= nil then
    local isShow = coinDiscount:IsInActivity() and coinDiscount.count ~= 0
    if isShow then
      if 0 < #sb.content then
        sb:Append("  ")
      end
      sb:Append(string.format(ZhString.Lottery_DiscountLimit, coinDiscount.usedCount, coinDiscount.count))
    end
  end
  if self.ticketLimit then
    price, ticketDiscount = self:GetDiscountByCoinType(_AEDiscountCoinTypeTicket)
    if ticketDiscount ~= nil then
      local isShow = ticketDiscount:IsInActivity() and ticketDiscount.count ~= 0
      self.ticketLimit.gameObject:SetActive(isShow)
      if isShow then
        self.ticketLimit.text = string.format(ZhString.Lottery_DiscountLimit, ticketDiscount.usedCount, ticketDiscount.count)
      end
    else
      self.ticketLimit.gameObject:SetActive(false)
    end
  end
  local isShow = 0 < #sb.content
  if self.lotteryLimit and self.lotteryLimitBg then
    self.lotteryLimit.gameObject:SetActive(false)
    if isShow then
      self.lotteryLimit.text = sb:ToString()
      self.lotteryLimitBg.width = self.lotteryLimit.localSize.x + 70
    end
  end
  sb:Destroy()
end
function LotteryView:GetDiscountByCoinType(cointype, price)
  local discount = ActivityEventProxy.Instance:GetLotteryDiscountByCoinType(self.lotteryType, cointype)
  if discount ~= nil and price ~= nil then
    price = math.floor(price * (discount:GetDiscount() / 100))
  end
  return price, discount
end
function LotteryView:ClickRecover(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data.itemData
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end
function LotteryView:ClickDetail(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data:GetItemData()
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Right, {-220, 0})
  end
end
function LotteryView:SelectRecover(cell)
  local data = cell.data
  if data then
    cell:SetChoose()
    local isChoose = cell:GetChoose()
    if isChoose then
      TableUtility.ArrayPushBack(self.recoverSelect, data.itemData.id)
    else
      TableUtility.ArrayRemove(self.recoverSelect, data.itemData.id)
    end
    self:UpdateRecoverBtn()
  end
end
function LotteryView:HandleEffectStart()
  self:SetActionBtnsActive(false)
  if LotteryProxy.Instance:IsPocketLotteryViewShowing() then
    return
  end
  self.gameObject:SetActive(false)
  self:CameraReset()
  local npcdata = self:GetNpcDataFromViewData()
  if npcdata then
    local viewPort = CameraConfig.Lottery_Effect_ViewPort
    local rotation = CameraConfig.Lottery_Rotation
    self:CameraFaceTo(npcdata.assetRole.completeTransform, viewPort, rotation)
  end
end
function LotteryView:HandleEffectEnd()
  self:SetActionBtnsActive(true)
  if LotteryProxy.Instance:IsPocketLotteryViewShowing() then
    return
  end
  self.gameObject:SetActive(true)
  self:CameraReset()
  self:NormalCameraFaceTo()
end
function LotteryView:HandleActivityEventNtf(note)
  local data = note.body
  if data then
    self:UpdateDiscount()
    self:UpdateLimit()
    self:UpdateCost()
    self:UpdateTicketCost()
  end
end
function LotteryView:HandleActivityEventNtfEventCnt(note)
  local data = note.body
  if data then
    self:UpdateDiscount()
    self:UpdateLimit()
    self:UpdateCost()
    self:UpdateTicketCost()
  end
end
function LotteryView:NormalCameraFaceTo()
  local npcdata = self:GetNpcDataFromViewData()
  if npcdata then
    local viewPort = CameraConfig.Lottery_ViewPort
    local rotation = CameraConfig.Lottery_Rotation
    self:CameraFaceTo(npcdata.assetRole.completeTransform, viewPort, rotation)
  end
end
function LotteryView:ReUniteCellData(datas, perRowNum)
  local newData = {}
  if datas ~= nil and #datas > 0 then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end
function LotteryView:GetNpcDataFromViewData()
  local viewdata = self.viewdata.viewdata
  if not viewdata or type(viewdata) ~= "table" then
    return nil
  end
  return viewdata.npcdata
end
function LotteryView:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
    GameFacade.Instance:sendNotification(LotteryEvent.LotteryViewClose)
  end)
end
function LotteryView:SetActionBtnsActive(isActive)
  isActive = isActive or false
  if self.btnGrid then
    self.btnGrid.gameObject:SetActive(isActive)
  else
    if self.lotteryBtn then
      self.lotteryBtn:SetActive(isActive)
    end
    if self.ticketBtn then
      self.ticketBtn:SetActive(isActive)
    end
  end
end
