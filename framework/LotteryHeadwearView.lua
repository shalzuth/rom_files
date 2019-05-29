autoImport("LotteryView")
autoImport("LotteryMonthGroupCell")
autoImport("LotteryMonthCell")
autoImport("DotCell")
autoImport("LotteryRecoverCombineCell")
autoImport("LotteryDetailCell")
LotteryHeadwearView = class("LotteryHeadwearView", LotteryView)
LotteryHeadwearView.ViewType = LotteryView.ViewType
local wrapConfig = {}
function LotteryHeadwearView:OnExit()
  local cells = self.monthCtl:GetCells()
  for i = 1, #cells do
    cells[i]:DestroyPicture()
  end
  LotteryHeadwearView.super.OnExit(self)
end
function LotteryHeadwearView:FindObjs()
  LotteryHeadwearView.super.FindObjs(self)
  self.ticket = self:FindGO("Ticket"):GetComponent(UILabel)
  self.lotteryRoot = self:FindGO("LotteryRoot")
  self.ticketCost = self:FindGO("TicketCost"):GetComponent(UILabel)
  self.monthGrid = self:FindGO("MonthGrid"):GetComponent(UIGrid)
  self.centerOnChild = self.monthGrid.gameObject:GetComponent("UICenterOnChild")
  self.recoverRoot = self:FindGO("RecoverRoot")
  self.recoverEmpty = self:FindGO("RecoverEmpty")
  self.recoverTotalLabel = self:FindGO("RecoverTotalLabel"):GetComponent(UILabel)
  self.recoverLabel = self:FindGO("RecoverLabel"):GetComponent(UILabel)
  self.recoverBtn = self:FindGO("RecoverBtn"):GetComponent(UIMultiSprite)
  self.detailRoot = self:FindGO("DetailRoot")
  self.bgTrans = self:FindGO("Bg1").transform
  self.sendBtn = self:FindGO("SendBtn")
  self.sendBtn:SetActive(not GameConfig.SystemForbid.LotteryExpress)
  self:FindGO("Bg"):SetActive(false)
  self.bgTrans.gameObject:SetActive(false)
  self.helpButton = self:LoadPreferb("cell/HelpButton", self.detailRoot)
  self.helpButton.transform.localPosition = Vector3(224, 320, 0)
  self.helpButton.transform.localScale = Vector3(0.8, 0.8, 1)
  self:AddClickEvent(self.helpButton, function(go)
    if self.rateSb == nil then
      self.rateSb = LuaStringBuilder.CreateAsTable()
    else
      self.rateSb:Clear()
    end
    local lines = string.split(ZhString.HeaderLotteryHelp, "\n")
    for _, v in pairs(lines) do
      self.rateSb:AppendLine(v)
    end
    TipsView.Me():ShowGeneralHelp(self.rateSb:ToString(), "")
  end)
end
function LotteryHeadwearView:AddEvts()
  LotteryHeadwearView.super.AddEvts(self)
  self:AddClickEvent(self.sendBtn, function()
    self:Send()
  end)
  local ticketBtn = self:FindGO("TicketBtn")
  self:AddClickEvent(ticketBtn, function()
    self:Ticket()
  end)
  local detailBtn = self:FindGO("DetailBtn")
  self:AddClickEvent(detailBtn, function()
    if self.monthData then
      self:ShowDetail(true)
      self:UpdateDetail(self.monthData)
    end
  end)
  local toRecoverBtn = self:FindGO("ToRecoverBtn")
  self:AddClickEvent(toRecoverBtn, function()
    self:ToRecover()
  end)
  function self.centerOnChild.onCenter(centeredObject)
    if self.centerMonthTrans and self.centerMonthTrans.gameObject ~= centeredObject then
      self:CenterOn(self.centerMonthTrans)
      return
    end
    for i = 1, #self.monthCtl:GetCells() do
      local cell = self.monthCtl:GetCells()[i]
      if cell.gameObject == centeredObject then
        if self.lastDot then
          self.lastDot:SetChoose(false)
        end
        self.lastDot = self.dotCtl:GetCells()[i]
        self.lastDot:SetChoose(true)
        self.monthData = cell.data
        self:UpdatePicUrl(cell)
        self:UpdateCost()
        self:UpdateTicketCost()
        self:UpdateDiscount()
        self:UpdateLimit()
        self.centerMonthTrans = nil
        break
      end
    end
  end
  local recoverReturnBtn = self:FindGO("RecoverReturnBtn")
  self:AddClickEvent(recoverReturnBtn, function()
    self:ShowRecover(false)
  end)
  local detailReturnBtn = self:FindGO("DetailReturnBtn")
  self:AddClickEvent(detailReturnBtn, function()
    self:ShowDetail(false)
  end)
  self:AddClickEvent(self.recoverBtn.gameObject, function()
    self:Recover()
  end)
end
function LotteryHeadwearView:AddViewEvts()
  LotteryHeadwearView.super.AddViewEvts(self)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(LotteryEvent.MagicPictureComplete, self.HandlePicture)
end
function LotteryHeadwearView:InitShow()
  LotteryHeadwearView.super.InitShow(self)
  self.lotteryType = LotteryType.Head
  self.recoverSelect = {}
  self.isUpdateRecover = true
  local grid = self:FindGO("MonthGroupGrid"):GetComponent(UIGrid)
  grid.gameObject:SetActive(false)
  self.monthGroupCtl = UIGridListCtrl.new(grid, LotteryMonthGroupCell, "LotteryMonthGroupCell")
  self.monthGroupCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMonthGroup, self)
  self.monthCtl = UIGridListCtrl.new(self.monthGrid, LotteryMonthCell, "LotteryMonthCell")
  grid = self:FindGO("MonthDotGrid"):GetComponent(UIGrid)
  grid.gameObject:SetActive(false)
  self.dotCtl = UIGridListCtrl.new(grid, DotCell, "ChatDotCell")
  local container = self:FindGO("RecoverContainer")
  TableUtility.TableClear(wrapConfig)
  wrapConfig.wrapObj = container
  wrapConfig.pfbNum = 5
  wrapConfig.cellName = "LotteryRecoverCombineCell"
  wrapConfig.control = LotteryRecoverCombineCell
  wrapConfig.dir = 1
  self.recoverHelper = WrapCellHelper.new(wrapConfig)
  self.recoverHelper:AddEventListener(MouseEvent.MouseClick, self.ClickRecover, self)
  self.recoverHelper:AddEventListener(LotteryEvent.Select, self.SelectRecover, self)
  local detailGrid = self:FindGO("DetailGrid"):GetComponent(UIGrid)
  self.detailCtl = UIGridListCtrl.new(detailGrid, LotteryDetailCell, "LotteryHeadwearDetailCell")
  self.detailCtl:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  self:InitTicket()
  self:InitRecover()
  self:UpdateTicket()
  self:UpdateTicketCost()
  self:ShowRecover(false)
  self:InitView()
end
function LotteryHeadwearView:Send()
  if self.monthData ~= nil then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LotteryExpressView,
      viewdata = self.monthData
    })
  end
end
function LotteryHeadwearView:Lottery()
  local month = self.monthData
  if month then
    self:CallLottery(month.price, month.year, month.month)
  end
end
function LotteryHeadwearView:LotteryTen()
  local month = self.monthData
  if month then
    self:CallLottery(month.price, month.year, month.month, 10)
  end
end
function LotteryHeadwearView:Ticket()
  local month = self.monthData
  if month then
    self:CallTicket(month.year, month.month)
  end
end
function LotteryHeadwearView:ShowRecover(isShow)
  self.isShowRecover = isShow
  self.lotteryRoot:SetActive(not isShow)
  self.recoverRoot:SetActive(isShow)
end
function LotteryHeadwearView:ShowDetail(isShow)
  self.lotteryRoot:SetActive(not isShow)
  self.detailRoot:SetActive(isShow)
end
function LotteryHeadwearView:ClickMonthGroup(cell)
  local data = cell.data
  if data and self.lastMonthGroup ~= cell then
    if self.lastMonthGroup then
      self.lastMonthGroup:SetChoose(false)
    end
    cell:SetChoose(true)
    self.bgTrans:SetParent(cell.trans, false)
    self.lastMonthGroup = cell
    local month = data:GetMonth()
    self:UpdateMonth(month)
    local cells = self.monthCtl:GetCells()
    for i = 1, #cells do
      local monthCell = cells[i]
      local monthData = monthCell.data
      if monthData and monthData.year == self.curYear and monthData.month == self.curMonth then
        self:CenterOn(monthCell.trans)
        return
      end
    end
    if #cells > 0 then
      self:CenterOn(cells[1].trans)
    end
  end
end
function LotteryHeadwearView:CenterOn(trans)
  self.centerMonthTrans = trans
  self.centerOnChild:CenterOn(trans)
end
function LotteryHeadwearView:InitView()
  LotteryHeadwearView.super.InitView(self)
  self.lastMonthGroup = nil
  local time = os.date("*t", ServerTime.CurServerTime() / 1000)
  self.curYear = time.year
  self.curMonth = time.month
  self:UpdateMonthGroup()
  local monthGroupId = LotteryProxy.Instance:GetMonthGroupId(self.curYear, self.curMonth)
  local cells = self.monthGroupCtl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    if cell.data and cell.data.id == monthGroupId then
      self:ClickMonthGroup(cell)
      return
    end
  end
  if #cells > 0 then
    self:ClickMonthGroup(cells[1])
  end
end
function LotteryHeadwearView:UpdateSkip()
  local isShow = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.Lottery)
  self.skipBtn.gameObject:SetActive(not isShow)
end
function LotteryHeadwearView:UpdateMonthGroup()
  local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
  if data ~= nil then
    self.monthGroupCtl:ResetDatas(data:GetMonthGroupList())
  end
end
function LotteryHeadwearView:UpdateMonth(data)
  helplog("LotteryHeadwearView:UpdateMonth", #data)
  local realData = {}
  helplog(self.curYear, self.curMonth)
  for _, d in pairs(data) do
    helplog(d.year, d.month)
    if d.month == self.curMonth and d.year == self.curYear then
      helplog("has")
      table.insert(realData, d)
    end
  end
  helplog(#realData)
  self.monthCtl:ResetDatas(realData)
  self.dotCtl:ResetDatas(realData)
end
function LotteryHeadwearView:UpdateDetail(data)
  if data then
    self.detailCtl:ResetDatas(data.items)
  end
end
function LotteryHeadwearView:UpdateCost()
  if self.monthData ~= nil then
    local onceMaxCount
    local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
    if data ~= nil then
      onceMaxCount = data.onceMaxCount
    end
    self:UpdateCostValue(self.monthData.price, onceMaxCount)
  end
end
function LotteryHeadwearView:UpdatePicUrl(monthCell)
  local monthData = monthCell.data
  if monthData ~= nil then
    local picUrl = self:GetLotteryBanner(monthData.year, monthData.month)
    if self.picUrl ~= picUrl then
      self.picUrl = picUrl
      local bytes = self:UpdateDownloadPic()
      if bytes then
        monthCell:UpdatePicture(bytes)
      else
        monthCell:DestroyPicture()
      end
    elseif picUrl == nil then
      monthCell:DestroyPicture()
    end
  end
end
function LotteryHeadwearView:UpdateDownloadPic()
  if self.picUrl ~= nil then
    return LotteryProxy.Instance:DownloadMagicPicFromUrl(self.picUrl)
  end
end
function LotteryHeadwearView:GetDiscountByCoinType(cointype, price)
  local discount
  if self.monthData ~= nil then
    discount = ActivityEventProxy.Instance:GetLotteryDiscountByCoinType(self.lotteryType, cointype, self.monthData.year, self.monthData.month)
    if discount ~= nil and price ~= nil then
      price = math.floor(price * (discount:GetDiscount() / 100))
    end
  end
  return price, discount
end
function LotteryHeadwearView:GetLotteryBanner(year, month)
  local list = ActivityEventProxy.Instance:GetLotteryBanner(self.lotteryType)
  if list ~= nil then
    for i = 1, #list do
      local data = list[i]
      local time = os.date("*t", data.begintime)
      if time.year == year and time.month == month then
        return data:GetPath()
      end
    end
  end
end
function LotteryHeadwearView:HandleItemUpdate(note)
  self:UpdateTicket()
  if self.isShowRecover then
    self:TryUpdateRecover()
  else
    self.isUpdateRecover = true
  end
end
function LotteryHeadwearView:HandlePicture(note)
  local data = note.body
  if data then
    local cells = self.monthCtl:GetCells()
    for i = 1, #cells do
      local cell = cells[i]
      local celldata = cell.data
      if celldata ~= nil then
        local url = self:GetLotteryBanner(celldata.year, celldata.month)
        if data.picUrl == url then
          cell:UpdatePicture(data.bytes)
          break
        end
      end
    end
  end
end
