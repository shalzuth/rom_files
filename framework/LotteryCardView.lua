autoImport("LotteryView")
autoImport("LotteryDetailCombineCell")
LotteryCardView = class("LotteryCardView", LotteryView)
LotteryCardView.ViewType = LotteryView.ViewType
local wrapConfig = {}
function LotteryCardView:OnExit()
  if self.rateSb ~= nil then
    self.rateSb:Destroy()
    self.rateSb = nil
  end
  LotteryCardView.super.OnExit(self)
end
function LotteryCardView:FindObjs()
  LotteryCardView.super.FindObjs(self)
  self.filter = self:FindGO("Filter"):GetComponent(UIPopupList)
  local discountCard = self:FindGO("LotteryDiscount"):GetComponent(UILabel)
  discountCard.fontSize = 17
  discountCard.effectColor = LuaColor(1.0, 0.3137254901960784, 0 / 255, 1)
  discountCard.transform.localPosition = Vector3(-88, 45, 0)
  OverseaHostHelper:FixLabelOverV1(discountCard, 3, 50)
  local Bg1 = self:FindGO("Bg1", discountCard.gameObject)
  Bg1.transform.localScale = Vector3(1.1, 1.1, 1)
  local Bg2 = self:FindGO("Bg2", discountCard.gameObject)
  Bg2.transform.localPosition = Vector3(12, -22, 0)
  local helpbtn = self:FindGO("HelpButton")
  helpbtn.transform.localPosition = Vector3(224, 320, 0)
  helpbtn.transform.localScale = Vector3(0.8, 0.8, 1)
end
function LotteryCardView:AddEvts()
  LotteryCardView.super.AddEvts(self)
  EventDelegate.Add(self.filter.onChange, function()
    if self.filter.data == nil then
      return
    end
    if self.filterData ~= self.filter.data then
      self.filterData = self.filter.data
      self:ResetCard()
    end
  end)
  local help = self:FindGO("HelpButton")
  self:AddClickEvent(help, function()
    ServiceItemProxy.Instance:CallLotteryRateQueryCmd(self.lotteryType)
  end)
end
function LotteryCardView:AddViewEvts()
  LotteryCardView.super.AddViewEvts(self)
  self:AddListenEvt(ServiceEvent.ItemLotteryRateQueryCmd, self.HandleLotteryRateQuery)
end
function LotteryCardView:InitShow()
  LotteryCardView.super.InitShow(self)
  self.lotteryType = LotteryType.Card
  local detailContainer = self:FindGO("DetailContainer")
  TableUtility.TableClear(wrapConfig)
  wrapConfig.wrapObj = detailContainer
  wrapConfig.pfbNum = 6
  wrapConfig.cellName = "LotteryDetailCombineCell"
  wrapConfig.control = LotteryDetailCombineCell
  wrapConfig.dir = 1
  self.detailHelper = WrapCellHelper.new(wrapConfig)
  self.detailHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  self:InitFilter()
  self:InitView()
end
function LotteryCardView:InitView()
  LotteryCardView.super.InitView(self)
  self:UpdateCost()
  self:UpdateCard()
end
function LotteryCardView:UpdateSkip()
  local isShow = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.LotteryCard)
  self.skipBtn.gameObject:SetActive(not isShow)
end
function LotteryCardView:InitFilter()
  self.filter:Clear()
  local randomFilter = GameConfig.CardMake.RandomFilter
  local rangeList = CardMakeProxy.Instance:GetFilter(randomFilter)
  for i = 1, #rangeList do
    local rangeData = randomFilter[rangeList[i]]
    self.filter:AddItem(rangeData, rangeList[i])
  end
  if #rangeList > 0 then
    local range = rangeList[1]
    self.filterData = range
    local rangeData = randomFilter[range]
    self.filter.value = rangeData
  end
end
function LotteryCardView:ResetCard()
  self:UpdateCard()
  self.detailHelper:ResetPosition()
end
function LotteryCardView:UpdateCard()
  local list = LotteryProxy.Instance:FilterCard(self.filterData)
  if list then
    local newData = self:ReUniteCellData(list, 3)
    self.detailHelper:UpdateInfo(newData)
  end
end
function LotteryCardView:HandleLotteryRateQuery(note)
  local data = note.body
  if data and data.type == self.lotteryType then
    if self.rateSb == nil then
      self.rateSb = LuaStringBuilder.CreateAsTable()
    else
      self.rateSb:Clear()
    end
    local lines = string.split(ZhString.CardLotteryHelp, "\n")
    for _, v in pairs(lines) do
      self.rateSb:AppendLine(v)
    end
    self.rateSb:AppendLine("")
    if not GameConfig.SystemForbid.LotteryRateUrl then
      self.rateSb:AppendLine(ZhString.Lottery_RateUrl)
    end
    local _ItemType = GameConfig.Lottery.ItemType
    local _rateTip = ZhString.Lottery_RateTip2
    local leftRate = 100
    for i = 1, #data.infos do
      local info = data.infos[i]
      if info.rate ~= 0 then
        local name = Table_Item[info.type].NameZh or ""
        self.rateSb:AppendLine(string.format(_rateTip, name, info.rate / 10000))
        leftRate = leftRate - info.rate / 10000
      end
    end
    TipsView.Me():ShowGeneralHelp(self.rateSb:ToString(), "")
  end
end
