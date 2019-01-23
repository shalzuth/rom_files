LotteryExpressPresentView = class("LotteryExpressPresentView",SubView)

function LotteryExpressPresentView:Init()
	self:FindObj()
	self:AddBtnEvt()
	self:AddViewEvt()
	self:InitShow()
end

function LotteryExpressPresentView:FindObj()
	self.gameObject = self:FindGO("ExpressRoot")
	self.ReturnBtn = self:FindGO("ReturnBtn")
	self.PresentBtn = self:FindGO("PresentBtn")
	self.ContentInput = self:FindGO("ContentInput"):GetComponent(UIInput)
	UIUtil.LimitInputCharacter(self.ContentInput, 45)
	self.fromName = self:FindGO("FromName"):GetComponent(UILabel)
	self.toName = self:FindGO("ToName"):GetComponent(UILabel)
	UIUtil.LimitInputCharacter(self.ContentInput, 30)
end

local pbData = {}
function LotteryExpressPresentView:AddBtnEvt()
	self:AddClickEvent(self.ReturnBtn, function ()
		self.container:ShowBuyView(true)
	end)
	EventDelegate.Set(self.ContentInput.onChange,function ()
		self:InputOnChange()
	end)
	self:AddClickEvent(self.PresentBtn,function ()
		local presentCount = self.container:GetPresentCount()
		local dmsg = self.configId and nil or self.ContentInput.value
		if(""==self.ContentInput.value)then
			MsgManager.ShowMsgByID(25308)
			return
		end
		if self.receiveId == nil then
			MsgManager.ShowMsgByID(25006)
			return
		end
		
		local monthData = self.container.monthData
		if(not monthData)then return end
		pbData.year = monthData.year
		pbData.month = monthData.month
		pbData.count = presentCount
		pbData.content = dmsg
		pbData.configid = self.configId
		pbData.receiverid = self.receiveId
		ServiceRecordTradeProxy.Instance:CallLotteryGiveCmd(pbData)
		self.container:CloseSelf()
	end)
end

function LotteryExpressPresentView:AddViewEvt()
	self:AddListenEvt(ShopMallEvent.ExchangeSelectFriend, self.HandleSelectFriend)
end

function LotteryExpressPresentView:InputOnChange()
	if(self.inputSet and self.configId)then
		self.configId=nil
	end
end

function LotteryExpressPresentView:HandleSelectFriend(note)
	local data = note.body
	if data then
		local friendData = FriendProxy.Instance:GetFriendById(data)
		if friendData then
			self.receiveId = friendData.guid
			self.toName.text = friendData.name
		end
	end
end

function LotteryExpressPresentView:InitShow()
	local addBtn = self:FindGO("AddBtn")
	self:AddClickEvent(addBtn,function ()
		FriendProxy.Instance:SetPresentMode(FriendProxy.PresentMode.Lottery)
		self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.ExchangeFriendView})
	end)
	self.toName.text=ZhString.Lottery_PresentReceiver
	self.fromName.text = string.format(ZhString.Lottery_PresentFrom, Game.Myself.data.name)
	local config = GameConfig.Lottery and GameConfig.Lottery.SendRandomLetter
	if(config)then
		self.configId = config[math.random(1,#config)]
		self.ContentInput.value=Table_LoveLetter[self.configId].Letter
		self.inputSet=true
	end
end



