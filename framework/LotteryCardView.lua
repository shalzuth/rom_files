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
 	self:AddClickEvent(help, function ()
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
	for i=1,#rangeList do
		local rangeData = randomFilter[rangeList[i]]
		self.filter:AddItem(rangeData , rangeList[i])
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

function LotteryCardView:Lottery()
	local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
	if data then
		self:CallLottery(data.price)
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

 		self.rateSb:AppendLine(ZhString.Lottery_RateUrl)

 		local _ItemType = GameConfig.Lottery.ItemType
 		local _rateTip = ZhString.Lottery_RateTip

 		local leftRate = 100;
 		for i=1,#data.infos do
 			local info = data.infos[i]
 			if info.rate ~= 0 then
 				local name = _ItemType[info.type] or ""
 				self.rateSb:Append(name)
 				self.rateSb:AppendLine(string.format(_rateTip, info.rate / 10000))
 				leftRate = leftRate - info.rate / 10000;
 			end
 		end
 		-- self.rateSb:AppendLine(ZhString.Lottery_Left .. string.format(_rateTip, leftRate))

 		TipsView.Me():ShowGeneralHelp(self.rateSb:ToString(), "")
 	end
end