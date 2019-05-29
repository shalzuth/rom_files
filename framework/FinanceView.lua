autoImport("FinanceCell")
autoImport("LineChartCell")
FinanceView = class("FinanceView", SubMediatorView)
local View_Path = ResourcePathHelper.UIView("FinanceView")
local _ColorEffectBlue = ColorUtil.ButtonLabelBlue
local _ColorEffectOrange = ColorUtil.ButtonLabelOrange
local _ColorBlue = LuaColor.New(0.25882352941176473, 0.4823529411764706, 0.7568627450980392, 1)
local _ColorBlack = LuaColor.New(0, 0, 0, 1)
local _VecPos = LuaVector3.zero
local _redColor = LuaColor.New(0.8156862745098039, 0.18823529411764706, 0.14901960784313725, 1)
local _greenColor = LuaColor.New(0.3137254901960784, 0.7843137254901961, 0.1843137254901961, 1)
local _dateThreeTips = {
  [1] = string.format(ZhString.Finance_DayTip, 2),
  [2] = string.format(ZhString.Finance_DayTip, 1),
  [3] = ZhString.Finance_TodayTip
}
local _dateSevenTips = {
  [1] = string.format(ZhString.Finance_DayTip, 6),
  [2] = string.format(ZhString.Finance_DayTip, 3),
  [3] = ZhString.Finance_TodayTip
}
local _FinanceDateTypeThree = FinanceDateTypeEnum.Three
function FinanceView:OnExit()
  self:ResetChoose()
  FinanceView.super.OnExit(self)
end
function FinanceView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
  self:OnEnter()
end
function FinanceView:FindObjs()
  self:LoadSubView()
  self.dealCountToggle = self:FindGO("DealCountToggle"):GetComponent(UIToggle)
  self.upRatioToggle = self:FindGO("UpRatioToggle"):GetComponent(UIToggle)
  self.downRatioToggle = self:FindGO("DownRatioToggle"):GetComponent(UIToggle)
  self.dateThreeToggle = self:FindGO("DateThreeToggle"):GetComponent(UIToggle)
  self.dateSevenToggle = self:FindGO("DateSevenToggle"):GetComponent(UIToggle)
  self.dealCountLabel = self.dealCountToggle.gameObject:GetComponent(UILabel)
  self.upRatioLabel = self.upRatioToggle.gameObject:GetComponent(UILabel)
  self.downRatioLabel = self.downRatioToggle.gameObject:GetComponent(UILabel)
  self.dateThreeLabel = self.dateThreeToggle.gameObject:GetComponent(UILabel)
  self.dateSevenLabel = self.dateSevenToggle.gameObject:GetComponent(UILabel)
  self.itemContainer = self:FindGO("Container")
  self.sellBtn = self:FindGO("SellBtn")
  self.sellBtnSprite = self.sellBtn:GetComponent(UIMultiSprite)
  self.sellLabel = self:FindGO("Label", self.sellBtn):GetComponent(UILabel)
  self.detailEmpty = self:FindGO("DetailEmpty")
  self.itemEmpty = self:FindGO("ItemEmpty")
end
function FinanceView:AddEvts()
  self:AddToggleChange(self.dealCountToggle, self.dealCountLabel, "effectColor", _ColorEffectOrange, _ColorEffectBlue, self.ClickDealCount)
  self:AddToggleChange(self.upRatioToggle, self.upRatioLabel, "effectColor", _ColorEffectOrange, _ColorEffectBlue, self.ClickUpRatio)
  self:AddToggleChange(self.downRatioToggle, self.downRatioLabel, "effectColor", _ColorEffectOrange, _ColorEffectBlue, self.ClickDownRatio)
  self:AddToggleChange(self.dateThreeToggle, self.dateThreeLabel, "color", _ColorBlue, _ColorBlack, self.ClickDateThree)
  self:AddToggleChange(self.dateSevenToggle, self.dateSevenLabel, "color", _ColorBlue, _ColorBlack, self.ClickDateSeven)
  self:AddClickEvent(self.sellBtn, function()
    if self.canSell and self.chooseItem ~= nil then
      local itemData = BagProxy.Instance:GetNewestItemByStaticID(self.chooseItem)
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ShopMallExchangeSellInfoView,
        viewdata = {
          data = itemData,
          type = ShopMallExchangeSellEnum.Sell
        }
      })
    end
  end)
end
function FinanceView:AddToggleChange(toggle, label, property, toggleColor, normalColor, handler)
  EventDelegate.Add(toggle.onChange, function()
    if toggle.value then
      label[property] = toggleColor
      if handler ~= nil then
        handler(self)
      end
    else
      label[property] = normalColor
    end
  end)
end
function FinanceView:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.RecordTradeTodayFinanceRank, self.HandleTodayFinanceRank)
  self:AddListenEvt(ServiceEvent.RecordTradeTodayFinanceDetail, self.HandleTodayFinanceDetail)
end
function FinanceView:InitShow()
  self.upRatioToggle:Set(true)
  self.itemCtl = WrapListCtrl.new(self.itemContainer, FinanceCell, "FinanceCell", WrapListCtrl_Dir.Vertical)
  self.itemCtl:AddEventListener(FinanceEvent.ShowDetail, self.ClickShowDetail, self)
  local obj = self:LoadPreferb("cell/FinanceDetailCell", self.gameObject)
  _VecPos:Set(-165, -13, 0)
  obj.transform.localPosition = _VecPos
  local detailCell = LineChartCell.new(obj)
  self.detailCell = detailCell
  detailCell:SetXRange(-241, 241)
  detailCell:SetYRange(-147, 147)
end
function FinanceView:ClickDealCount()
  self:ChangeView(FinanceRankTypeEnum.DealCount, _FinanceDateTypeThree)
  self:SetDefaultDate()
end
function FinanceView:ClickUpRatio()
  self:ChangeView(FinanceRankTypeEnum.UpRatio, _FinanceDateTypeThree)
  self:SetDefaultDate()
end
function FinanceView:ClickDownRatio()
  self:ChangeView(FinanceRankTypeEnum.DownRatio, _FinanceDateTypeThree)
  self:SetDefaultDate()
end
function FinanceView:ClickDateThree()
  self:ChangeView(nil, _FinanceDateTypeThree)
end
function FinanceView:ClickDateSeven()
  self:ChangeView(nil, FinanceDateTypeEnum.Seven)
end
function FinanceView:SetDefaultDate()
  UIToggle.current = nil
  self.dateThreeToggle:Set(true)
end
function FinanceView:ChangeView(rankType, dateType)
  rankType = rankType or self.rankType
  dateType = dateType or self.dateType
  if rankType == self.rankType and dateType == self.dateType then
    return
  end
  if rankType ~= nil and dateType ~= nil then
    local detailCell = self.detailCell
    if detailCell ~= nil then
      self:UpdateDetailXTips(dateType)
      detailCell:ShowYTips(false)
      detailCell:ShowChart(false)
      self.detailEmpty:SetActive(true)
    end
    self.canSell = false
    self:UpdateSellBtn()
    self:ResetChoose()
    self.rankType = rankType
    self.dateType = dateType
    local isCall = ShopMallProxy.Instance:CallTodayFinanceRank(rankType, dateType)
    if isCall then
      self.itemContainer:SetActive(false)
    else
      self:UpdateView()
    end
  end
end
function FinanceView:UpdateView()
  if not self.itemContainer.activeSelf then
    self.itemContainer:SetActive(true)
  end
  local data = ShopMallProxy.Instance:GetFinanceData(self.rankType, self.dateType)
  if data ~= nil then
    local itemlist = data:GetItemList()
    self.itemCtl:ResetDatas(itemlist, true)
    self.itemEmpty:SetActive(#itemlist == 0)
    local cells = self.itemCtl:GetCells()
    if #cells > 0 then
      self:ClickShowDetail(cells[1])
    end
  end
end
function FinanceView:HandleItemUpdate(note)
  if self.chooseItem ~= nil then
    self:UpdateCanSell(self.chooseItem)
  end
end
function FinanceView:HandleTodayFinanceRank(note)
  local data = note.body
  if data and data.rank_type == self.rankType and data.date_type == self.dateType then
    self:UpdateView()
  end
end
function FinanceView:HandleTodayFinanceDetail(note)
  local data = note.body
  if data and data.rank_type == self.rankType and data.date_type == self.dateType and self.chooseItem ~= nil and self.chooseItem == data.item_id then
    local financeData = ShopMallProxy.Instance:GetFinanceData(self.rankType, self.dateType)
    if financeData ~= nil then
      local list = financeData:GetItemList()
      for i = 1, #list do
        if list[i].itemid == data.item_id then
          self:UpdateDetail(list[i])
        end
      end
    end
  end
end
function FinanceView:ClickShowDetail(cell)
  local data = cell.data
  if data ~= nil then
    self:ResetChoose()
    cell:ShowChoose(true)
    self.chooseItem = cell.data.itemid
    self:UpdateDetailCell(cell)
    self:UpdateCanSell(self.chooseItem)
  end
end
function FinanceView:UpdateDetailCell(cell)
  local detailCell = self.detailCell
  self.detailEmpty:SetActive(false)
  local data = cell.data
  if data then
    local isCall = ShopMallProxy.Instance:CallTodayFinanceDetail(data.itemid, data.rankType, data.dateType)
    if isCall then
      detailCell:ShowYTips(false)
      detailCell:ShowChart(false)
    else
      self:UpdateDetail(data)
    end
    self:UpdateDetailXTips(data.dateType)
  end
end
function FinanceView:UpdateDetail(financeItemData)
  if financeItemData then
    local data = ShopMallProxy.Instance:GetFinanceItemData(financeItemData.rankType, financeItemData.dateType, financeItemData.itemid)
    if data ~= nil then
      local detailCell = self.detailCell
      detailCell:ShowYTips(true)
      local yTips = ReusableTable.CreateArray()
      yTips[1] = self:TransNum(data:GetMaxDetailRatio())
      yTips[2] = self:TransNum(data:GetMiddleDetailRatio())
      yTips[3] = self:TransNum(data:GetMinDetailRatio())
      detailCell:SetYTips(yTips)
      ReusableTable.DestroyAndClearArray(yTips)
      detailCell:ShowChart(true)
      local color = _redColor
      if financeItemData.rankType == FinanceRankTypeEnum.DownRatio then
        color = _greenColor
      end
      detailCell:SetChart(data:GetDetailList(), data:GetMaxDetailRatio(), data:GetMinDetailRatio(), color)
    end
  end
end
function FinanceView:UpdateDetailXTips(dateType)
  self.detailCell:SetXTips(dateType == _FinanceDateTypeThree and _dateThreeTips or _dateSevenTips)
end
function FinanceView:UpdateCanSell(itemid)
  if itemid ~= nil then
    self.canSell = BagProxy.Instance:GetItemNumByStaticID(itemid) > 0
    self:UpdateSellBtn()
  end
end
function FinanceView:UpdateSellBtn()
  if self.canSell then
    self.sellBtnSprite.CurrentState = 0
    self.sellLabel.effectColor = _ColorEffectOrange
  else
    self.sellBtnSprite.CurrentState = 1
    self.sellLabel.effectColor = ColorUtil.NGUIGray
  end
end
function FinanceView:ResetChoose()
  if self.chooseItem ~= nil then
    local data
    local cells = self.itemCtl:GetCells()
    for i = 1, #cells do
      data = cells[i].data
      if data ~= nil and data.itemid == self.chooseItem then
        cells[i]:ShowChoose(false)
        self.chooseItem = nil
      end
    end
    if self.chooseItem ~= nil then
      data = ShopMallProxy.Instance:GetFinanceData(self.rankType, self.dateType)
      if data ~= nil then
        local itemlist = data:GetItemList()
        for i = 1, #itemlist do
          if itemlist[i].itemid == self.chooseItem then
            itemlist[i]:SetChoose(false)
            self.chooseItem = nil
          end
        end
      end
    end
  end
end
function FinanceView:LoadSubView()
  local container = self:FindGO("financeView")
  self.gameObject = self:LoadPreferb_ByFullPath(View_Path, container, true)
end
function FinanceView:TransNum(num)
  if num ~= nil then
    local hm = num / 100000000
    if hm > 1 then
      return string.format(ZhString.Finance_HundredsMillions, hm)
    else
      local tt = num / 10000
      if tt > 1 then
        return string.format(ZhString.Finance_TenThousand, tt)
      end
    end
  end
  return math.floor(num)
end
