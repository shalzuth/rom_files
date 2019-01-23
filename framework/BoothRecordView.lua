autoImport("BoothRecordCell")
BoothRecordView = class("BoothRecordView", SubView)

function BoothRecordView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function BoothRecordView:FindObjs()
	self.objRoot = self:FindGO("RecordRoot" , self.container.recordRoot)
	self.contentContainer = self:FindGO("RecordsContainer" , self.objRoot)
	self.empty = self:FindGO("RecordEmpty" , self.objRoot)
	self.tips = self:FindGO("Tips" , self.objRoot):GetComponent(UILabel)
	self.loadingRoot = self:FindGO("LoadingRoot", self.objRoot)
end

function BoothRecordView:AddEvts()
	self:AddClickEvent(self:FindGO("QuickTakeBtn", self.objRoot), function() self:ClickQuickTake() end)

	local scrollView = self:FindGO("RecordsScrollView", self.objRoot):GetComponent(UIScrollView)
	NGUIUtil.HelpChangePageByDrag(scrollView, 
		function() self:DragUp() end,
		function() self:DragDown() end,
		50)
end

function BoothRecordView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.RecordTradeMyTradeLogRecordTradeCmd , self.RecvMyTradeLog)
	self:AddListenEvt(ServiceEvent.RecordTradeListNtfRecordTrade , self.RecvListNtf)
	self:AddListenEvt(ServiceEvent.RecordTradeTakeLogCmd , self.RecvTakeLog)
	self:AddListenEvt(ServiceEvent.RecordTradeAddNewLog , self.RecvLog)
	self:AddListenEvt(ServiceEvent.RecordTradeQucikTakeLogTradeCmd , self.RecvQucikTakeLogTrade)
	self:AddListenEvt(ServiceEvent.RecordTradeUpdateOrderTradeCmd, self.RecvUpdateOrderTrade)
end

function BoothRecordView:InitShow()
	local day = 24 * 60 * 60

	self.tips.text = string.format(ZhString.Booth_ExchangeRecordMaxLog,
		math.floor(GameConfig.Exchange.LogTime / day),
		math.floor(GameConfig.Exchange.ReceiveTime / day))

	self.empty:SetActive(false)
	self.loadingRoot:SetActive(false)

	local wrapConfig = {
		wrapObj = self.contentContainer, 
		pfbNum = 9, 
		cellName = "BoothRecordCell", 
		control = BoothRecordCell, 
		dir = 1,
	}
	self.wrapHelper = WrapCellHelper.new(wrapConfig)

	self:UpdateRecord()
	self:ResetPage()
	self:CallRecordList( self.currentPage )
end

function BoothRecordView:UpdateRecord()
	local data = BoothProxy.Instance:GetBoothSellRecordList()
	self.wrapHelper:UpdateInfo(data)
	self.wrapHelper:ResetPosition()
	self.empty:SetActive(#data < 1)
end

function BoothRecordView:ResetPage()
	self.currentPage = 1
	self.totalPage = 1
end

function BoothRecordView:RecvMyTradeLog(note)
	if (not note.body or note.body.trade_type ~= BoothProxy.TradeType.Booth) then return end
	self:RecvLog(note)
	self.wrapHelper:ResetPosition()
end

function BoothRecordView:RecvLog(note)
	local data = note.body
	local tradeType = data.trade_type or (data.log and data.log.trade_type)
	if data and tradeType == BoothProxy.TradeType.Booth then
		self:UpdateRecord()
		self.totalPage = data.total_page_count and math.max(data.total_page_count, 1) or 1
		if data.index then
			self.currentPage = math.clamp(data.index + 1, 1, self.totalPage)
		end
	end
end

function BoothRecordView:RecvListNtf(note)
	local data = note.body
	if (not data or data.trade_type ~= BoothProxy.TradeType.Booth) then return end
	if data.type == RecordTrade_pb.ELIST_NTF_MY_LOG then
		self:CallRecordList( self.currentPage )
	end
end

function BoothRecordView:RecvTakeLog(note)
	local data = note.body
	if data.success and (not data.log or data.log.trade_type == BoothProxy.TradeType.Booth) then
		self:UpdateRecord()
	end
end

function BoothRecordView:RecvUpdateOrderTrade(note)
	local data = note.body
	if data and data.charid == self.container.playerID and data.type == BoothProxy.TradeType.Booth then
		self:CallRecordList( self.currentPage )
	end	
end

function BoothRecordView:RecvQucikTakeLogTrade(note)
	if (not note.body or note.body.trade_type ~= BoothProxy.TradeType.Booth) then return end
	self:ClearQuickTakeLt()
	self.loadingRoot:SetActive(false)
end

function BoothRecordView:DragUp()
	local page = self.currentPage - 1
	if page >= 1 then
		self.currentPage = page
		self:CallRecordList( self.currentPage )
	end
end

function BoothRecordView:DragDown()
	self:CallRecordList( self.currentPage + 1 )
end

function BoothRecordView:ClickQuickTake()
	local sellReceiveCount = BoothProxy.Instance:GetBoothSellRecordReceiveCount()
	if sellReceiveCount > 0 then
		self:ClearQuickTakeLt()
		self.quickTakeLt = LeanTween.delayedCall(15, function ()
			self.quickTakeLt = nil
			if (self.loadingRoot.gameObject) then
				self.loadingRoot:SetActive(false)
			end
		end)

		self.loadingRoot:SetActive(true)
		ServiceRecordTradeProxy.Instance:CallQucikTakeLogTradeCmd(BoothProxy.TradeType.Booth)
	end
end

function BoothRecordView:CallRecordList(index)
	if index and index > 0 and index <= self.totalPage then
		ServiceRecordTradeProxy.Instance:CallMyTradeLogRecordTradeCmd(Game.Myself.data.id, index - 1, nil, nil, BoothProxy.TradeType.Booth)
	end
end

function BoothRecordView:ClearQuickTakeLt()
	if self.quickTakeLt then
		self.quickTakeLt:cancel()
		self.quickTakeLt = nil
	end
end
