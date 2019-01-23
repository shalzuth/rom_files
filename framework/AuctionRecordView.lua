autoImport("AuctionRecordCell")

AuctionRecordView = class("AuctionRecordView", ContainerView)

AuctionRecordView.ViewType = UIViewType.PopUpLayer

local day = 24*60*60

function AuctionRecordView:OnExit()
	local cells = self.wrapHelper:GetCellCtls()
	for i=1,#cells do
		cells[i]:OnDestroy()
	end
	AuctionRecordView.super.OnExit(self)
end

function AuctionRecordView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function AuctionRecordView:FindObjs()
	self.contentContainer = self:FindGO("RecordContainer")
	self.empty = self:FindGO("RecordEmpty")
	self.tips = self:FindGO("Tips"):GetComponent(UILabel)
	self.receive = self:FindGO("RecordReceive"):GetComponent(UILabel)
	self.turnLeft = self:FindGO("TurnLeft")
	self.turnRight = self:FindGO("TurnRight")
	self.page = self:FindGO("Page"):GetComponent(UILabel)	
	
	--todo xde 
	OverseaHostHelper:FixLabelOverV1(self.tips,3,514)
end

function AuctionRecordView:AddEvts()
	self:AddClickEvent(self.receive.gameObject,function ()
		self:ClickReceive()
	end)
	self:AddClickEvent(self.turnLeft,function ()
		self:ClickTurnLeft()
	end)	
	self:AddClickEvent(self.turnRight,function ()
		self:ClickTurnRight()
	end)	
end

function AuctionRecordView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.AuctionCCmdReqAuctionRecordCCmd , self.RecvRecord)
	self:AddListenEvt(ServiceEvent.AuctionCCmdTakeAuctionRecordCCmd , self.UpdateView)
	self:AddListenEvt(ServiceEvent.AuctionCCmdNtfCanTakeCntCCmd , self.UpdateReceive)
end

function AuctionRecordView:InitShow()

	self.tips.text = string.format(ZhString.Auction_RecordMaxLog,
		tostring(math.floor(GameConfig.Auction.LogTime / day)),
		tostring(math.floor(GameConfig.Auction.ReceiveTime / day)))

	local wrapConfig = {
		wrapObj = self.contentContainer, 
		pfbNum = 10, 
		cellName = "AuctionRecordCell", 
		control = AuctionRecordCell, 
		dir = 1,
	}
	self.wrapHelper = WrapCellHelper.new(wrapConfig)

	self:UpdateView()
	self:ResetPage()

	self:CallRecordList(self.currentPage)
end

function AuctionRecordView:UpdateView()
	self:UpdateRecord()
	self:UpdateReceive()
end

function AuctionRecordView:UpdateReceive()
	local sellReceiveCount = AuctionProxy.Instance:GetRecordReceiveCount()
	self.receive.gameObject:SetActive(sellReceiveCount > 0)
	self.receive.text = string.format(ZhString.Auction_RecordReceive, sellReceiveCount)
end

function AuctionRecordView:UpdateRecord()
	local data = AuctionProxy.Instance:GetRecordList()
	self.wrapHelper:UpdateInfo(data)

	if #data > 0 then
		self.empty:SetActive(false)
	else
		self.empty:SetActive(true)
	end
end

function AuctionRecordView:UpdatePage()
	self.page.text = self.currentPage.."/"..self.totalPage
end

function AuctionRecordView:ResetPage()
	self.currentPage = 1
	self.totalPage = 1
	self:UpdatePage()
end

function AuctionRecordView:ClickReceive()
	if self.wrapHelper then
		local cells = self.wrapHelper:GetCellCtls()
		for i=1,8 do
			if cells[i].data and cells[i].data:CanReceive() then
				return
			end
		end
	end

	local closestIndex = AuctionProxy.Instance:GetClosestReceiveIndex()
	if closestIndex then
		self.wrapHelper:SetStartPositionByIndex(closestIndex)
	end
end

function AuctionRecordView:ClickTurnLeft()
	local page = self.currentPage - 1
	if page >= 1 then
		self.currentPage = page

		self:CallRecordList(self.currentPage)
	end
end

function AuctionRecordView:ClickTurnRight()
	self:CallRecordList(self.currentPage + 1)
end

function AuctionRecordView:RecvRecord(note)
	local data = note.body
	if data then
		self:UpdateView()
		self.wrapHelper:ResetPosition()

		if data.total_page_cnt then
			self.totalPage = math.max(data.total_page_cnt, 1)
		else
			self.totalPage = 1
		end
		if data.index then
			self.currentPage = math.clamp(data.index + 1, 1, self.totalPage)
		end
		
		self:UpdatePage()
	end	
end

function AuctionRecordView:CallRecordList(index)
	if index and index > 0 and index <= self.totalPage then
		ServiceAuctionCCmdProxy.Instance:CallReqAuctionRecordCCmd(index - 1)
	end
end