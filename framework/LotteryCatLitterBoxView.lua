autoImport("LotteryView")
autoImport("LotteryDetailCombineCell")

LotteryCatLitterBoxView = class("LotteryCatLitterBoxView", LotteryView)

LotteryCatLitterBoxView.ViewType = LotteryView.ViewType

local maskReason = PUIVisibleReason.CatLitterBox
local skipType = SKIPTYPE.LotteryCatLitter

function LotteryCatLitterBoxView:OnEnter()
	LotteryCatLitterBoxView.super.OnEnter(self)

	local _FunctionPlayerUI = FunctionPlayerUI.Me()
	local roles = NSceneNpcProxy.Instance:GetAll()
	for k,v in pairs(roles) do
		_FunctionPlayerUI:MaskTopFrame(v, maskReason, false)
		_FunctionPlayerUI:MaskNameHonorFactionType(v, maskReason, false)
	end
end

function LotteryCatLitterBoxView:OnExit()
	local _FunctionPlayerUI = FunctionPlayerUI.Me()
	local roles = NSceneNpcProxy.Instance:GetAll()
	for k,v in pairs(roles) do
		_FunctionPlayerUI:UnMaskTopFrame(v, maskReason, false)
		_FunctionPlayerUI:UnMaskNameHonorFactionType(v, maskReason, false)
	end

	LotteryCatLitterBoxView.super.OnExit(self)
end

function LotteryCatLitterBoxView:FindObjs()
	self.ticket = self:FindGO("Ticket"):GetComponent(UILabel)
	self.ticketCost = self:FindGO("TicketCost"):GetComponent(UILabel)
	self.detailTween = self:FindGO("DetailRoot"):GetComponent(TweenPosition)
	self.tweenDetailBtn = self:FindGO("TweenDetailBtn")
	self.skipBtn = self:FindGO("SkipBtn"):GetComponent(UISprite)

	--todo xde fixui
	self.TicketCostIcon = self:FindGO("TicketCostIcon")
	self.TicketCostIcon.transform.localPosition = Vector3(22,5.1,0)
	self.Bg = self:FindGO("Bg",self.TicketCostIcon.gameObject)
	self.Bg.transform.localPosition = Vector3(-10,0,0)
	self.ticketCost.transform.localPosition = Vector3(83.3,5,0)
end

function LotteryCatLitterBoxView:AddEvts()
	local ticketBtn = self:FindGO("TicketBtn")
	self:AddClickEvent(ticketBtn, function ()
		self:Ticket()
	end)

	self:AddClickEvent(self.tweenDetailBtn, function ()
		self.detailTween:PlayForward()
		self.tweenDetailBtn:SetActive(false)
	end)

	local closeDetailBtn = self:FindGO("CloseDetailBtn")
	self:AddClickEvent(closeDetailBtn, function ()
		self.detailTween:PlayReverse()
		self.tweenDetailBtn:SetActive(true)
	end)
	self:AddClickEvent(self.skipBtn.gameObject, function ()
		self:Skip()
	end)
end

function LotteryCatLitterBoxView:Skip()
	TipManager.Instance:ShowSkipAnimationTip(skipType, self.skipBtn , NGUIUtil.AnchorSide.Right, {184,0})
end

function LotteryCatLitterBoxView:AddViewEvts()
	LotteryCatLitterBoxView.super.AddViewEvts(self)

	self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
end

function LotteryCatLitterBoxView:InitShow()
	self.tipData = {}
	self.tipData.funcConfig = {}
	self.npcId = self.viewdata.viewdata.npcdata.data.id

	self.lotteryType = LotteryType.CatLitterBox

	local detailGrid = self:FindGO("DetailGrid"):GetComponent(UIGrid)
	self.detailCtl = UIGridListCtrl.new(detailGrid, LotteryDetailCell, "LotteryItemCell")
	self.detailCtl:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)

	self:InitTicket()

	self:UpdateTicket()
	self:UpdateTicketCost()
end

function LotteryCatLitterBoxView:InitView()
	local data = LotteryProxy.Instance:GetInfo(self.lotteryType)
	if data then
		self.detailCtl:ResetDatas(data.items)
	end
end

function LotteryCatLitterBoxView:Ticket()
	self:CallTicket()
end

function LotteryCatLitterBoxView:HandleItemUpdate(note)
	self:UpdateTicket()
end

function LotteryCatLitterBoxView:NormalCameraFaceTo()
	local npcdata = self.viewdata.viewdata.npcdata
	if npcdata then
		local viewPort = CameraConfig.Lottery_Effect_ViewPort
		local rotation = CameraConfig.Lottery_CatLitterBox_Rotation
		self:CameraFocusAndRotateTo(npcdata.assetRole.completeTransform, viewPort, rotation)
	end
end

function LotteryCatLitterBoxView:HandleEffectStart()
	self.gameObject:SetActive(false)
end

function LotteryCatLitterBoxView:HandleEffectEnd()
	self.gameObject:SetActive(true)
end