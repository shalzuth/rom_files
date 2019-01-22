autoImport("LotteryView")
autoImport("LotteryRecoverCombineCell")
autoImport("LotteryDetailCell")

LotteryMagicView = class("LotteryMagicView", LotteryView)

LotteryMagicView.ViewType = LotteryView.ViewType

function LotteryMagicView:OnExit()
	if self.rateSb ~= nil then
 		self.rateSb:Destroy()
 		self.rateSb = nil
 	end
	GameObject.DestroyImmediate(self.bg.mainTexture)
	LotteryMagicView.super.OnExit(self)
end

function LotteryMagicView:FindObjs()
	LotteryMagicView.super.FindObjs(self)

	self.bg = self:FindGO("Background"):GetComponent(UITexture)
	self.ticket = self:FindGO("Ticket"):GetComponent(UILabel)
	self.lotteryRoot = self:FindGO("LotteryRoot")
	self.discountRoot = self:FindGO("DiscountRoot")
	self.discount = self:FindGO("Discount"):GetComponent(UILabel)
	self.discountTime = self:FindGO("DiscountTime"):GetComponent(UILabel)
	self.ticketCost = self:FindGO("TicketCost"):GetComponent(UILabel)
	self.recoverRoot = self:FindGO("RecoverRoot")
	self.recoverEmpty = self:FindGO("RecoverEmpty")
	self.recoverTotalLabel = self:FindGO("RecoverTotalLabel"):GetComponent(UILabel)
	self.recoverLabel = self:FindGO("RecoverLabel"):GetComponent(UILabel)
	self.recoverBtn = self:FindGO("RecoverBtn"):GetComponent(UIMultiSprite)
	self.detailRoot = self:FindGO("DetailRoot")
end

function LotteryMagicView:AddEvts()
	LotteryMagicView.super.AddEvts(self)

	local ticketBtn = self:FindGO("TicketBtn")
	self:AddClickEvent(ticketBtn, function ()
		self:Ticket()
	end)

	local detailBtn = self:FindGO("DetailBtn")
	self:AddClickEvent(detailBtn, function ()
		self:ShowDetail(true)
	end)

	local toRecoverBtn = self:FindGO("ToRecoverBtn")
	self:AddClickEvent(toRecoverBtn, function ()
		self:ToRecover()
	end)

	local recoverReturnBtn = self:FindGO("RecoverReturnBtn")
	self:AddClickEvent(recoverReturnBtn, function ()
		self:ShowRecover(false)
	end)

	local detailReturnBtn = self:FindGO("DetailReturnBtn")
	self:AddClickEvent(detailReturnBtn, function ()
		self:ShowDetail(false)
	end)

	self:AddClickEvent(self.recoverBtn.gameObject, function ()
		self:Recover()
	end)

	local help = self:FindGO("HelpButton")
 	self:AddClickEvent(help, function ()
 		ServiceItemProxy.Instance:CallLotteryRateQueryCmd(self.lotteryType)
 	end)
end

function LotteryMagicView:AddViewEvts()
	LotteryMagicView.super.AddViewEvts(self)

	self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
	self:AddListenEvt(LotteryEvent.MagicPictureComplete, self.HandlePicture)
	self:AddListenEvt(ServiceEvent.ItemLotteryRateQueryCmd, self.HandleLotteryRateQuery)
end

function LotteryMagicView:InitShow()
	LotteryMagicView.super.InitShow(self)

	self.lotteryType = LotteryType.Magic

	self.recoverSelect = {}
	self.isUpdateRecover = true

	--recover
	local container = self:FindGO("RecoverContainer")
	local wrapConfig = ReusableTable.CreateTable()
	wrapConfig.wrapObj = container
	wrapConfig.pfbNum = 5
	wrapConfig.cellName = "LotteryRecoverCombineCell"
	wrapConfig.control = LotteryRecoverCombineCell
	wrapConfig.dir = 1
	self.recoverHelper = WrapCellHelper.new(wrapConfig)
	self.recoverHelper:AddEventListener(MouseEvent.MouseClick, self.ClickRecover, self)
	self.recoverHelper:AddEventListener(LotteryEvent.Select, self.SelectRecover, self)

	--detail
	local detailContainer = self:FindGO("DetailContainer")
	TableUtility.TableClear(wrapConfig)
	wrapConfig.wrapObj = detailContainer
	wrapConfig.pfbNum = 7
	wrapConfig.cellName = "LotteryMagicDetailCell"
	wrapConfig.control = LotteryDetailCell
	wrapConfig.dir = 1
	self.detailHelper = WrapCellHelper.new(wrapConfig)
	self.detailHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
	ReusableTable.DestroyAndClearTable(wrapConfig)

	--icon
	self:InitTicket()
	self:InitRecover()

	self:UpdateTicket()
	self:UpdateTicketCost()
	self:ShowRecover(false)
	self:InitView()

	self:UpdatePicUrl()
	
	--fix btn
	local lotLabel = self:FindGO("Label",self:FindGO("LotteryBtn")):GetComponent(UILabel)
	lotLabel.pivot = UIWidget.Pivot.Right

	local lotLabel = self:FindGO("Label",self:FindGO("TicketBtn")):GetComponent(UILabel)
	lotLabel.pivot = UIWidget.Pivot.Right
end

function LotteryMagicView:Lottery()
	local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
	if data then
		self:CallLottery(data.price)
	end
end

function LotteryMagicView:Ticket()
	self:CallTicket()
end

function LotteryMagicView:ShowRecover(isShow)
	self.isShowRecover = isShow

	self.lotteryRoot:SetActive(not isShow)
	self.recoverRoot:SetActive(isShow)
end

function LotteryMagicView:ShowDetail(isShow)
	self.lotteryRoot:SetActive(not isShow)
	self.detailRoot:SetActive(isShow)
end

function LotteryMagicView:InitView()
	LotteryMagicView.super.InitView(self)
	
	local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
	if data then
		self:UpdateCost()

		self.detailHelper:UpdateInfo(data.items)
	end	
end

function LotteryMagicView:UpdateSkip()
	local isShow = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.LotteryMagic)
	self.skipBtn.gameObject:SetActive(not isShow)
end

function LotteryMagicView:UpdatePicUrl()
	local list = ActivityEventProxy.Instance:GetLotteryBanner(self.lotteryType)
	if list ~= nil and #list > 0 then
		local picUrl = list[#list].path  --todo xde ??????path
		if self.picUrl ~= picUrl then
			self.picUrl = picUrl
			local bytes = self:UpdateDownloadPic()
			if bytes then
				self:UpdatePicture(bytes)
			end
		end
	end
end

function LotteryMagicView:UpdateDownloadPic()
	if self.picUrl ~= nil then
		return LotteryProxy.Instance:DownloadMagicPicFromUrl(self.picUrl)
	end
end

function LotteryMagicView:UpdatePicture(bytes)
	local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
	local ret = ImageConversion.LoadImage(texture, bytes)
	if ret then
		GameObject.DestroyImmediate(self.bg.mainTexture)

		self.bg.mainTexture = texture
	end
end

function LotteryMagicView:UpdateDiscount()
	LotteryMagicView.super.UpdateDiscount(self)

	local aeDiscount = ActivityEventProxy.Instance:GetLotteryDiscountByCoinType(self.lotteryType, AELotteryDiscountData.CoinType.Coin)
	if aeDiscount ~= nil and aeDiscount:IsInActivity() then
		self.discountRoot:SetActive(true)

		self.discount.text = string.format(ZhString.Lottery_Discount, 100 - aeDiscount.discount)

		local beginTime = os.date("*t", aeDiscount.beginTime)
		local endTime = os.date("*t", aeDiscount.endTime)
		self.discountTime.text = string.format(ZhString.Lottery_DiscountTime, beginTime.month, beginTime.day, endTime.month, endTime.day)
	else
		self.discountRoot:SetActive(false)
	end
end

function LotteryMagicView:HandleItemUpdate(note)
	self:UpdateTicket()

	if self.isShowRecover then
		self:UpdateRecover()
	else
		self.isUpdateRecover = true
	end
end

function LotteryMagicView:HandleActivityEventNtf(note)
	LotteryMagicView.super.HandleActivityEventNtf(self)

	self:UpdatePicUrl()
end

function LotteryMagicView:HandlePicture(note)
	local data = note.body
	if data then
		if self.picUrl == data.picUrl then
			self:UpdatePicture(data.bytes)
		end
	end
end

function LotteryMagicView:HandleLotteryRateQuery(note)
 	local data = note.body
 	if data and data.type == self.lotteryType then
 		if self.rateSb == nil then
 			self.rateSb = LuaStringBuilder.CreateAsTable()
 		else
 			self.rateSb:Clear()
 		end

 		self.rateSb:AppendLine(ZhString.Lottery_RateUrl)
 		self.rateSb:AppendLine(ZhString.Lottery_MagicRateTip)
 		self.rateSb:AppendLine("")

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
end