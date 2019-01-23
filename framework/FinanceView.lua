autoImport("FinanceCell")
autoImport("LineChartCell")

FinanceView = class("FinanceView", SubView)

local View_Path = ResourcePathHelper.UIView("FinanceView")

local _ColorBlue = LuaColor.New(66/255, 123/255, 193/255, 1)
local _ColorBlack = LuaColor.New(0, 0, 0, 1)
local _VecPos = LuaVector3.zero
local _redColor = LuaColor.New(208/255, 48/255, 38/255, 1)
local _greenColor = LuaColor.New(80/255, 200/255, 47/255, 1)
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

local _ColorTitleGray = ColorUtil.TitleGray
local _FinanceDateTypeThree = FinanceDateTypeEnum.Three

function FinanceView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
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
	self.tableObj = self:FindGO("Table")
	self.scrollView = self:FindGO("ScrollView"):GetComponent(UIScrollView)

	--todo xde
--	local l = self:FindGO("DealCountToggle"):GetComponent(UILabel)
--	l.fontSize = 23
--	OverseaHostHelper:FixLabelOverV1(l,3,160)

	local threeT = self:FindGO("DateThreeToggle")
	threeT:GetComponent(UILabel).fontSize = 22
	local bg = self:FindGO("Bg",threeT):GetComponent(UISprite)
	bg.width = 180
	local cbg = self:FindGO("ChooseBg",threeT):GetComponent(UISprite)
	cbg.width = 180

	local threeT = self:FindGO("DateSevenToggle")
	threeT.transform.localPosition = Vector3(180,0,0)
	threeT:GetComponent(UILabel).fontSize = 22
	local bg = self:FindGO("Bg",threeT):GetComponent(UISprite)
	bg.width = 180
	local cbg = self:FindGO("ChooseBg",threeT):GetComponent(UISprite)
	cbg.width = 180

	local perWidth = 140
	OverseaHostHelper:FixLabelOverV1(self.dealCountLabel,3,perWidth)
	self:FindGO("DealCountToggle"):GetComponent(BoxCollider).size = Vector3(perWidth,50,0)
	self:FindGO("Line",self.dealCountToggle.gameObject):GetComponent(UISprite).width = perWidth
	self.dealCountLabel.fontSize = 22
	self.dealCountLabel.transform.localPosition = Vector3(-417,0,0)

	OverseaHostHelper:FixLabelOverV1(self.upRatioLabel,3,perWidth)
	self:FindGO("UpRatioToggle"):GetComponent(BoxCollider).size = Vector3(perWidth,50,0)
	self:FindGO("Line",self.upRatioToggle.gameObject):GetComponent(UISprite).width = perWidth
	self.upRatioLabel.fontSize = 22
	self.upRatioLabel.transform.localPosition = Vector3(-417 + perWidth,0,0)

	OverseaHostHelper:FixLabelOverV1(self.downRatioLabel,3,perWidth)
	self:FindGO("DownRatioToggle"):GetComponent(BoxCollider).size = Vector3(perWidth,50,0)
	self:FindGO("Line",self.downRatioToggle.gameObject):GetComponent(UISprite).width = perWidth
	self.downRatioLabel.fontSize = 22
	self.downRatioLabel.transform.localPosition = Vector3(-417 + 2 *  perWidth,0,0)
	
	local bgLine =self:FindGO("BgLine")
	bgLine:GetComponent(UISprite).width = perWidth * 3
	bgLine.transform.localPosition = Vector3(-80,38,0)
end

function FinanceView:AddEvts()
	self:AddToggleChange(self.dealCountToggle, self.dealCountLabel, _ColorBlue, _ColorTitleGray, self.ClickDealCount)
	self:AddToggleChange(self.upRatioToggle, self.upRatioLabel, _ColorBlue, _ColorTitleGray, self.ClickUpRatio)
	self:AddToggleChange(self.downRatioToggle, self.downRatioLabel, _ColorBlue, _ColorTitleGray, self.ClickDownRatio)
	self:AddToggleChange(self.dateThreeToggle, self.dateThreeLabel, _ColorBlue, _ColorBlack, self.ClickDateThree)
	self:AddToggleChange(self.dateSevenToggle, self.dateSevenLabel, _ColorBlue, _ColorBlack, self.ClickDateSeven)
end

function FinanceView:AddToggleChange(toggle, label, toggleColor, normalColor, handler)
	EventDelegate.Add(toggle.onChange, function () 
		if toggle.value then
			label.color = toggleColor
			if handler ~= nil then
				handler(self)
			end
		else
			label.color = normalColor
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

	local table = self.tableObj:GetComponent(UITable)
	self.itemCtl = UIGridListCtrl.new(table, FinanceCell, "FinanceCell")
	self.itemCtl:AddEventListener(FinanceEvent.ShowDetail, self.ClickShowDetail, self)
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
		self.rankType = rankType
		self.dateType = dateType

		local isCall = ShopMallProxy.Instance:CallTodayFinanceRank(rankType, dateType)
		if isCall then
			self.tableObj:SetActive(false)
		else
			self:UpdateView()
		end
	end
end

function FinanceView:UpdateView()
	if not self.tableObj.activeSelf then
		self.tableObj:SetActive(true)
	end

	local data = ShopMallProxy.Instance:GetFinanceData(self.rankType, self.dateType)
	if data ~= nil then
		if self.detailCell ~= nil then
			self.detailCell:ShowSelf(false)
			self.detailCell.gameObject.transform:SetParent(self.trans)
		end

		self.itemCtl:ResetDatas(data:GetItemList())
		self.scrollView:ResetPosition()
	end
end

function FinanceView:HandleItemUpdate(note)
	local cells = self.itemCtl:GetCells()
	for i=1,#cells do
		cells[i]:UpdateSellBtn()
	end
end

function FinanceView:HandleTodayFinanceRank(note)
	local data = note.body
	if data then
		if data.rank_type == self.rankType and data.date_type == self.dateType then
			self:UpdateView()
		end
	end
end

function FinanceView:HandleTodayFinanceDetail(note)
	local data = note.body
	if data then
		if data.rank_type == self.rankType and data.date_type == self.dateType then
			if self.lastDetailCell ~= nil then
				local cellData = self.lastDetailCell.data
				if cellData ~= nil and cellData.itemid == data.item_id then
					self:UpdateDetail(self.lastDetailCell)
				end
			end
		end
	end
end

function FinanceView:ClickShowDetail(cell)
	local data = cell.data
	if data ~= nil then
		if self.lastDetailCell ~= nil then
			self.lastDetailCell:ShowDetail(false)
		end

		local isShowDetail = cell.isShowDetail
		if isShowDetail then
			self:UpdateDetailCell(cell)
			self.lastDetailCell = cell
		else
			self.lastDetailCell = nil
		end
		if self.detailCell ~= nil then
			self.detailCell.gameObject:SetActive(isShowDetail)
		end

		self.itemCtl:Layout()
	end
end

function FinanceView:UpdateDetailCell(cell)
	local detailCell = self.detailCell
	local obj
	if detailCell == nil then
		obj = self:LoadPreferb("cell/FinanceDetailCell", cell.gameObject)

		detailCell = LineChartCell.new(obj)
		self.detailCell = detailCell
		detailCell:SetXRange(-217, 217)
		detailCell:SetYRange(-45, 45)
	else
		obj = detailCell.gameObject
		obj.transform:SetParent(cell.gameObject.transform)
	end
	_VecPos:Set(10, -171, 0)
	obj.transform.localPosition = _VecPos

	local data = cell.data
	if data then
		local isCall = ShopMallProxy.Instance:CallTodayFinanceDetail(data.itemid, data.rankType, data.dateType)
		if isCall then
			detailCell:ShowYTips(false)
			detailCell:ShowChart(false)
		else
			self:UpdateDetail(cell)
		end

		if data.dateType == _FinanceDateTypeThree then
			self.detailCell:SetXTips(_dateThreeTips)
		else
			self.detailCell:SetXTips(_dateSevenTips)
		end
	end
end

function FinanceView:UpdateDetail(cell)
	if cell.data then
		local data = ShopMallProxy.Instance:GetFinanceItemData(cell.data.rankType, cell.data.dateType, cell.data.itemid)
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
			if cell.data.rankType == FinanceRankTypeEnum.DownRatio then
				color = _greenColor
			end
			detailCell:SetChart(data:GetDetailList(), data:GetMaxDetailRatio(), data:GetMinDetailRatio(), color)
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
end