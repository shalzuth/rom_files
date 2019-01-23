autoImport("CardRandomMakeCombineCell")
autoImport("CardRandomGetCombineCell")

CardRandomMakeView = class("CardRandomMakeView", ContainerView)

CardRandomMakeView.ViewType = UIViewType.NormalLayer

local maxCard = 3
local skipType = SKIPTYPE.CardRandomMake

function CardRandomMakeView:OnEnter()
	CardRandomMakeView.super.OnEnter(self)

	if self.viewdata.viewdata.npcdata then
		local npcRootTrans = self.viewdata.viewdata.npcdata.assetRole.completeTransform

		local viewPort = CameraConfig.NPC_Dialog_ViewPort
		if type(self.camera)=="number" then
			viewPort = Vector3(viewPort.x, viewPort.y, self.camera)
		end
		local duration = CameraConfig.NPC_Dialog_DURATION
		self:CameraFocusOnNpc(npcRootTrans, viewPort, duration)
	end
end

function CardRandomMakeView:OnExit()
	self:CameraReset()
	CardRandomMakeView.super.OnExit(self)
end

function CardRandomMakeView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function CardRandomMakeView:FindObjs()
	self.filter = self:FindGO("Filter"):GetComponent(UIPopupList)
	self.title = self:FindGO("Title"):GetComponent(UILabel)
	self.tip = self:FindGO("Tip"):GetComponent(UILabel)
	self.costLabel = self:FindGO("Cost"):GetComponent(UILabel)
	self.confirmButton = self:FindGO("ConfirmButton"):GetComponent(UIMultiSprite)
	self.confirmLabel = self:FindGO("Label", self.confirmButton.gameObject):GetComponent(UILabel)
	self.randomRoot = self:FindGO("RandomRoot"):GetComponent(TweenPosition)
	self.getRoot = self:FindGO("GetRoot")
	self.fadeInOut = self:FindGO("FadeInOut"):GetComponent(TweenPosition)
	self.fadeInOutSp = self:FindGO("FadeInOutSymbol"):GetComponent(UISprite)
	self.bgTp = self:FindGO("Bg"):GetComponent(TweenPosition)
	self.bgTw = self.bgTp.gameObject:GetComponent(TweenWidth)
	self.bg1 = self:FindGO("Bg1"):GetComponent(TweenWidth)
	self.skipBtn = self:FindGO("SkipBtn"):GetComponent(UISprite)

	--todo xde fix ui
	self.lTitle = self:FindGO("Title",self:FindGO("RandomRoot")):GetComponent(UILabel)
	self.lTitle.overflowMethod = 3;
	self.lTitle.width = 230
	self.lTitle.transform.localPosition = Vector3(-70,208.2,0)

	self.rTitle = self:FindGO("Title",self.getRoot):GetComponent(UILabel)
	self.rTitle.overflowMethod = 3;
	self.rTitle.width = 160
	self.rTitle.transform.localPosition = Vector3(180,208.2,0)
	
	self.popBg = self:FindGO("Sprite",self:FindGO("Filter")):GetComponent(UISprite)
	self.popBg.width =160

	self.filterNext = self:FindGO("FilterNext",self:FindGO("Filter")):GetComponent(UISprite)
	self.filterNext.rightAnchor.target =  self.popBg.gameObject.transform
	self.filterNext.rightAnchor.relative = 1
	self.filterNext.rightAnchor.absolute = -8

	self.filterNext.leftAnchor.target =  self.popBg.gameObject.transform
	self.filterNext.leftAnchor.relative = 1
	self.filterNext.leftAnchor.absolute = -8 -self.filterNext.width
end

function CardRandomMakeView:AddEvts()
	EventDelegate.Add(self.filter.onChange, function()
		if self.filter.data == nil then
			return
		end
		if self.filterData ~= self.filter.data then
			self.filterData = self.filter.data

			self:ResetCard()
		end
	end)

	self:AddClickEvent(self.confirmButton.gameObject,function ()
		self:Confirm()
	end)

	self:AddClickEvent(self.fadeInOut.gameObject,function ()
		self:FadeInOut()
	end)

	local closeButton = self:FindGO("CloseButton")
	self:AddClickEvent(closeButton,function ()
		SceneUIManager.Instance:PlayerSpeak(self.npcId, ZhString.CardMark_EndDialog)
		self:CloseSelf()
	end)

	self:AddClickEvent(self.skipBtn.gameObject, function ()
		self:Skip()
	end)
end

function CardRandomMakeView:AddViewEvts()
	self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
	self:AddListenEvt(ServiceEvent.ItemExchangeCardItemCmd, self.HandleExchangeCardItem)
	self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpc)
	self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
	self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.UpdateTipInfo)
end

function CardRandomMakeView:InitShow()
	self.tipData = {}
	self.tipData.funcConfig = {}
	self.canChoose = true
	self.canMake = false
	self.isFadeInOut = true
	self.npcId = self.viewdata.viewdata.npcdata.data.id

	self:InitRandomCard()

	local container = self:FindGO("Container")
	local wrapConfig = {
		wrapObj = container, 
		pfbNum = 4, 
		cellName = "CardRandomMakeCombineCell", 
		control = CardRandomMakeCombineCell, 
		dir = 1,
	}
	self.wrapHelper = WrapCellHelper.new(wrapConfig)
	self.wrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClick, self)
	self.wrapHelper:AddEventListener(CardMakeEvent.Select, self.HandleSelect, self)

	local getContainer = self:FindGO("GetContainer")
	TableUtility.TableClear(wrapConfig)
	wrapConfig.wrapObj = getContainer
	wrapConfig.pfbNum = 5
	wrapConfig.cellName = "CardRandomGetCombineCell"
	wrapConfig.control = CardRandomGetCombineCell
	wrapConfig.dir = 1
	self.getWrapHelper = WrapCellHelper.new(wrapConfig)
	self.getWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleGet, self)

	self:InitFilter()

	self:UpdateCard()
	self:UpdateGetCard()
	self:SetConfirm(not self.canMake)
	self:UpdateTip()
	self:UpdateSkip()
end

function CardRandomMakeView:InitRandomCard()
	CardMakeProxy.Instance:InitRandomCard()
end

function CardRandomMakeView:InitFilter()
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

function CardRandomMakeView:UpdateCard()
	local data = CardMakeProxy.Instance:FilterRandomCard(self.filterData)
	self:UpdateCardInfo(data)
end

function CardRandomMakeView:CheckUpdateCard()
	local data = CardMakeProxy.Instance:CheckFilterRandomCardList(self.filterData)
	self:UpdateCardInfo(data)
end

function CardRandomMakeView:UpdateCardInfo(data)
	if data then
		local newData = self:ReUniteCellData(data, 4)
		self.wrapHelper:UpdateInfo(newData)
	end
end

function CardRandomMakeView:ResetCard()
	self:UpdateCard()
	self.wrapHelper:ResetPosition()
end

function CardRandomMakeView:UpdateGetCard()
	local data = CardMakeProxy.Instance:GetRandomGetList()
	if data then
		local newData = self:ReUniteCellData(data, 2)
		self.getWrapHelper:UpdateInfo(newData)
	end
end

function CardRandomMakeView:UpdateTip()

	self.costLabel.gameObject:SetActive(self.canMake)
	self.tip.gameObject:SetActive(not self.canMake)
	self:UpdateTipInfo()

	if self.canMake then
		self.cost = CardMakeProxy.Instance:GetRandomCost()
		if self.cost then
			self.costLabel.text = StringUtil.NumThousandFormat(self.cost)
		end
	end
end

function CardRandomMakeView:UpdateTipInfo()
	local count = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_EXCHANGECARD_DRAWMAX) or 0
	local maxCount = GameConfig.Card.exchangecard_draw_max
	count = maxCount - count
	if count < 0 then
		count = 0
	end
	self.tip.text = string.format(ZhString.CardMark_Tip, count, maxCount)
end

function CardRandomMakeView:UpdateSkip()
	local isShow = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.ExchangeCard)
	self.skipBtn.gameObject:SetActive(not isShow)
end

function CardRandomMakeView:SetConfirm(isGray)
	if isGray then
		self.confirmButton.CurrentState = 1
		self.confirmLabel.effectStyle = UILabel.Effect.None
	else
		self.confirmButton.CurrentState = 0
		self.confirmLabel.effectStyle = UILabel.Effect.Outline
	end
end

function CardRandomMakeView:HandleItemUpdate()
	self:InitRandomCard()
	self:ResetCard()
end

function CardRandomMakeView:HandleExchangeCardItem(note)
	local data = note.body
	if data then
		if data.charid == Game.Myself.data.id then
			self:CloseSelf()
		end
	end
end

function CardRandomMakeView:HandleRemoveNpc(note)
	local data = note.body
	if data and #data > 0 then
		for i=1,#data do
			if self.npcId == data[i] then
				self:CloseSelf()
				break
			end
		end	
	end
end

function CardRandomMakeView:HandleClick(cell)
	local data = cell.data
	if data then
		local canChoose = true

		if not data.isChoose then
			canChoose = self.canChoose
		end

		if canChoose then
			cell:SetChoose()

			self:CheckUpdateCard()

			local list = CardMakeProxy.Instance:GetRandomChooseList()
			local count = #list
			self.canChoose = count < maxCard
			self.canMake = count == maxCard

			self:SetConfirm(not self.canMake)
			self:UpdateTip()
		else
			MsgManager.ShowMsgByID(985)
		end
	end
end

function CardRandomMakeView:HandleSelect(cell)
	local data = cell.data
	if data then
		self.tipData.itemdata = data.itemData
		self:ShowItemTip(self.tipData, self.title, NGUIUtil.AnchorSide.Left, {-225,-250})	
	end
end

function CardRandomMakeView:HandleGet(cell)
	local data = cell.data
	if data then
		self.tipData.itemdata = data
		self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Right, {220,0})	
	end
end

function CardRandomMakeView:Confirm()
	if self.canMake then
		if MyselfProxy.Instance:GetROB() < self.cost then
			MsgManager.ShowMsgByID(1)
			return
		end
		
		self:CallExchangeCardItem()
	end
end

function CardRandomMakeView:FadeInOut()
	self.isFadeInOut = not self.isFadeInOut
	if self.isFadeInOut then
		self.fadeInOut:PlayForward()
		self.randomRoot:PlayForward()
		self.bgTp:PlayForward()
		self.bgTw:PlayForward()
		self.bg1:PlayForward()
		self.fadeInOutSp.flip = 0
	else
		self.fadeInOut:PlayReverse()
		self.randomRoot:PlayReverse()
		self.bgTp:PlayReverse()
		self.bgTw:PlayReverse()
		self.bg1:PlayReverse()
		self.fadeInOutSp.flip = 1
	end

	self.getRoot:SetActive(self.isFadeInOut)
end

function CardRandomMakeView:Skip()
	TipManager.Instance:ShowSkipAnimationTip(skipType, self.skipBtn , NGUIUtil.AnchorSide.Right, {150,0})
end

function CardRandomMakeView:CallExchangeCardItem()
	local list = CardMakeProxy.Instance:GetRandomChooseIdList()
	local skipValue = CardMakeProxy.Instance:IsSkipGetEffect(skipType)
	ServiceItemProxy.Instance:CallExchangeCardItemCmd(CardMakeProxy.MakeType.Random, self.npcId, list, nil, nil, not skipValue)
end

function CardRandomMakeView:ReUniteCellData(datas, perRowNum)
	local newData = {}
	if(datas~=nil and #datas>0)then
		for i = 1,#datas do
			local i1 = math.floor((i-1)/perRowNum)+1;
			local i2 = math.floor((i-1)%perRowNum)+1;
			newData[i1] = newData[i1] or {};
			if(datas[i] == nil)then
				newData[i1][i2] = nil;
			else
				newData[i1][i2] = datas[i];
			end
		end
	end
	return newData;
end