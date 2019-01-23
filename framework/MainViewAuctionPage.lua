autoImport("MainViewButtonCell")
autoImport("MainViewAuctionCell")

MainViewAuctionPage = class("MainViewAuctionPage",SubView)

local SHOWTYPE = {
	More = 1,	--拍卖按钮在更多按钮里显示
	Public = 2,	--拍卖按钮在主界面显示
}

local weakDialog = {}

function MainViewAuctionPage:OnExit()
	self:ClearTimeTick()
	MainViewAuctionPage.super.OnExit(self)
end

function MainViewAuctionPage:Init()
	self:AddViewEvt()
	self:InitShow()
end

function MainViewAuctionPage:AddViewEvt()
	self:AddListenEvt(ServiceEvent.AuctionCCmdNtfAuctionStateCCmd, self.UpdateAuction)
	self:AddListenEvt(ServiceEvent.AuctionCCmdNtfCurAuctionInfoCCmd, self.HandleWeakDialog)
	self:AddListenEvt(ServiceEvent.AuctionCCmdAuctionDialogCCmd, self.HandleAuctionDialog)
	self:AddListenEvt(ServiceEvent.AuctionCCmdNtfOverTakePriceCCmd, self.HandleOverTakePrice)
end

function MainViewAuctionPage:InitShow()
	local menuPage = self.container.menuPage
	self.moreCtl = UIGridListCtrl.new(menuPage.moreGrid, MainViewButtonCell, "MainViewButtonCell")
	self.moreCtl:AddEventListener(MouseEvent.MouseClick, self.ClickButton, self)

	self.topRightFuncGrid = self:FindGO("TopRightFunc2"):GetComponent(UIGrid)
	self.activityCtl = UIGridListCtrl.new(self.topRightFuncGrid, MainViewAuctionCell, "MainViewAuctionCell")
	self.activityCtl:AddEventListener(MouseEvent.MouseClick, self.ClickButton, self)

	self.countdownData = {}
	self.countdownData.type = MainViewButtonType.Auction
	self.countdownData.Name = ZhString.Auction_CountdownName
	self.countdownData.Icon = "exchange"

	self.mianViewCountdownData = {}
	self.mianViewCountdownData.type = MainViewButtonType.Auction
	self.mianViewCountdownData.Name = ZhString.Auction_MainViewCountdownName

	self.moreDatas = {}
	self.activityDatas = {}

	self:UpdateAuction()
end

function MainViewAuctionPage:InitMoreDatas(isAdd)
	TableUtility.ArrayClear(self.moreDatas)

	if isAdd then
		TableUtility.ArrayPushBack(self.moreDatas, self.countdownData)
	end

	self.moreCtl:ResetDatas(self.moreDatas)

	local _RedTipProxy = RedTipProxy.Instance
	local redTipId = SceneTip_pb.EREDSYS_AUCTION_RECORD
	local cells = self.moreCtl:GetCells()
	for i=1,#cells do
		_RedTipProxy:RegisterUI(redTipId, cells[i].sprite, 3, {-5,-5})
	end
	_RedTipProxy:RegisterUI(redTipId, self.container.menuPage.moreBtn, 42)

	self.container.menuPage:ResetMenuButtonPosition()
end

function MainViewAuctionPage:InitActivityDatas(isAdd)
	TableUtility.ArrayClear(self.activityDatas)

	if isAdd then
		TableUtility.ArrayPushBack(self.activityDatas, self.mianViewCountdownData)
	end

	self.activityCtl:ResetDatas(self.activityDatas)

	self.topRightFuncGrid.repositionNow = true
end

function MainViewAuctionPage:UpdateAuction()
	local curState = AuctionProxy.Instance:GetCurrentState()
	if curState == AuctionState.Close then
		self:Clear()
		return

	elseif curState == AuctionState.SignUp or curState == AuctionState.SignUpVerify then
		self.countdownData.Name = ZhString.Auction_CountdownName
		self.mianViewCountdownData.Name = ZhString.Auction_MainViewCountdownName

	elseif curState == AuctionState.Auction then
		self:AuctionProgress()
		return

	elseif curState == AuctionState.AuctionEnd then
		self:AuctionEnd()
		return
	end

	local totalSec, hour, min, sec = AuctionProxy.Instance:GetAuctionFormatTime()
	if totalSec == nil then
		--数据异常
		self:Clear()
		return
	else
		if totalSec >= 0 then
			if self.timeTick == nil then
				self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountdown, self)
			end
		end
	end
end

function MainViewAuctionPage:UpdateCountdown()
	if GameConfig.Auction == nil or GameConfig.Auction.PublicTime == nil then
		helplog("GameConfig.Auction.PublicTime is nil")
		return
	end

	local showType
	local totalSec, hour, min, sec = AuctionProxy.Instance:GetAuctionFormatTime()
	if totalSec > GameConfig.Auction.PublicTime then
		showType = SHOWTYPE.More
	else
		showType = SHOWTYPE.Public
	end

	if showType ~= self.auctionShowType then
		if showType == SHOWTYPE.More then
			self:IsShowPublic(false)
		elseif showType == SHOWTYPE.Public then
			self:IsShowPublic(true)
			self:SetNormalWeakDialog(93)
		end
	end

	if totalSec then
		local moreCells = self.moreCtl:GetCells()
		for i=1,#moreCells do
			moreCells[i]:UpdateAuction(totalSec, hour, min, sec)
		end

		local activityCells = self.activityCtl:GetCells()
		for i=1,#activityCells do
			activityCells[i]:UpdateAuction(totalSec, min, sec)
		end
	end

	if totalSec < 0 then
		self:ClearTimeTick()
	end
end

function MainViewAuctionPage:AuctionProgress()
	self:ClearTimeTick()

	self.countdownData.Name = ZhString.Auction_ProgressName
	self.mianViewCountdownData.Name = ZhString.Auction_MainViewProgressName
	self:IsShowPublic(true)
end

function MainViewAuctionPage:AuctionEnd()
	self:ClearTimeTick()

	self.countdownData.Name = ZhString.Auction_EndName
	self.mianViewCountdownData.Name = ZhString.Auction_MainViewEndName
	self:IsShowPublic(false)
end

function MainViewAuctionPage:IsShowPublic(isShow)
	self:InitMoreDatas(true)
	self:InitActivityDatas(isShow)

	if isShow then
		self.auctionShowType = SHOWTYPE.Public
	else
		self.auctionShowType = SHOWTYPE.More
	end
end

function MainViewAuctionPage:Clear()
	self:InitMoreDatas(false)
	self:InitActivityDatas(false)

	self:ClearTimeTick()
end

function MainViewAuctionPage:ClearTimeTick()
	if self.timeTick then
		TimeTickManager.Me():ClearTick(self)
		self.timeTick = nil
	end
end

function MainViewAuctionPage:ClickButton(cellctl)
	FunctionSecurity.Me():TryDoRealNameCentify( self._clickButton,cellctl.data );
end

function MainViewAuctionPage._clickButton(data)
	if data then
		if data.type == MainViewButtonType.Auction then
			ServiceAuctionCCmdProxy.Instance:CallReqAuctionInfoCCmd()
		end
	end
end

function MainViewAuctionPage:SetNormalWeakDialog(dialogId)
	self:sendNotification(MyselfEvent.AddWeakDialog, DialogUtil.GetDialogData(dialogId))
end

function MainViewAuctionPage:HandleWeakDialog(note)
	local data = note.body
	if data then
		local dialog = DialogUtil.GetDialogData(92)
		if dialog then
			local itemData = Table_Item[data.itemid]
			if itemData then
				TableUtility.TableClear(weakDialog)
				weakDialog.Speaker = dialog.Speaker
				weakDialog.Text = string.format(dialog.Text, itemData.NameZh)
				self:sendNotification(MyselfEvent.AddWeakDialog, weakDialog)
			end
		end
	end
end

function MainViewAuctionPage:HandleAuctionDialog(note)
	local data = note.body
	if data then
		local dialog = DialogUtil.GetDialogData(data.msg_id)
		if dialog then
			TableUtility.TableClear(weakDialog)
			weakDialog.Speaker = dialog.Speaker
			weakDialog.Text = string.format(dialog.Text, unpack(data.params))
			self:sendNotification(MyselfEvent.AddWeakDialog, weakDialog)
		end
	end
end

function MainViewAuctionPage:HandleOverTakePrice(note)
	local data = note.body
	if data then
		self:SetNormalWeakDialog(95)
	end
end