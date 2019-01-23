autoImport("LotteryView")
autoImport("LotteryDetailCombineCell")
autoImport("LotteryRecoverCombineCell")

LotteryEquipView = class("LotteryEquipView", LotteryView)

LotteryEquipView.ViewType = LotteryView.ViewType

local wrapConfig = {}

function LotteryEquipView:FindObjs()
	LotteryEquipView.super.FindObjs(self)

	self.ticket = self:FindGO("Ticket"):GetComponent(UILabel)
	self.ticketCost = self:FindGO("TicketCost"):GetComponent(UILabel)
	self.detailRoot = self:FindGO("DetailRoot")
	self.recoverRoot = self:FindGO("RecoverRoot")
	self.recoverEmpty = self:FindGO("RecoverEmpty")
	self.recoverTotalLabel = self:FindGO("RecoverTotalLabel"):GetComponent(UILabel)
	self.recoverLabel = self:FindGO("RecoverLabel"):GetComponent(UILabel)
	self.recoverBtn = self:FindGO("RecoverBtn"):GetComponent(UIMultiSprite)
end

function LotteryEquipView:AddEvts()
	LotteryEquipView.super.AddEvts(self)

	local ticketBtn = self:FindGO("TicketBtn")
	self:AddClickEvent(ticketBtn, function ()
		self:Ticket()
	end)

	local toRecoverBtn = self:FindGO("ToRecoverBtn")
	self:AddClickEvent(toRecoverBtn, function ()
		self:ToRecover()
	end)

	local recoverReturnBtn = self:FindGO("RecoverReturnBtn")
	self:AddClickEvent(recoverReturnBtn, function ()
		self:ShowRecover(false)
	end)

	self:AddClickEvent(self.recoverBtn.gameObject, function ()
		self:Recover()
	end)
end

function LotteryEquipView:AddViewEvts()
	LotteryEquipView.super.AddViewEvts(self)

	self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
end

function LotteryEquipView:InitShow()
	LotteryEquipView.super.InitShow(self)

	self.lotteryType = LotteryType.Equip

	self.recoverSelect = {}
	self.isUpdateRecover = true

	local detailContainer = self:FindGO("DetailContainer")
	self.detailHelper = WrapListCtrl.new(detailContainer, LotteryDetailCell, "LotteryEquipCell", WrapListCtrl_Dir.Vertical, 3, 135)
	self.detailHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)

	--recover
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

	--icon
	self:InitTicket()
	self:InitRecover()

	self:UpdateTicket()
	self:UpdateTicketCost()
	self:ShowRecover(false)
	self:InitView()
end

function LotteryEquipView:Lottery()
	local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
	if data then
		self:CallLottery(data.price)
	end
end

function LotteryEquipView:Ticket()
	self:CallTicket()
end

function LotteryEquipView:InitView()
	LotteryEquipView.super.InitView(self)
	
	local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
	if data then
		self:UpdateCost()

		self.detailHelper:ResetDatas(data.items)
	end
end

function LotteryEquipView:UpdateSkip()
	local isShow = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.LotteryEquip)
	self.skipBtn.gameObject:SetActive(not isShow)	
end

function LotteryEquipView:ShowRecover(isShow)
	self.isShowRecover = isShow

	self.detailRoot:SetActive(not isShow)
	self.recoverRoot:SetActive(isShow)
end

function LotteryEquipView:HandleItemUpdate(note)
	self:UpdateTicket()

	if self.isShowRecover then
		self:UpdateRecover()
	else
		self.isUpdateRecover = true
	end
end