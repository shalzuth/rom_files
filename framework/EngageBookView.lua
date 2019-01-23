EngageBookView = class("EngageBookView", SubView)

local _ZenyID = GameConfig.MoneyId.Zeny
local _TicketID = GameConfig.Wedding and GameConfig.Wedding.ticket_itemid or 5002

function EngageBookView:Init()
	self:FindObjs()
	self:AddEvts()
	self:InitShow()
end

function EngageBookView:FindObjs()
	self.gameObject = self:LoadPreferb("view/EngageBookView", nil, true)
	self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
	self.zone = self:FindGO("Zone"):GetComponent(UILabel)
	self.date = self:FindGO("Date"):GetComponent(UILabel)
	self.target = self:FindGO("Target"):GetComponent(UILabel)
end

function EngageBookView:AddEvts()
	self.closecomp.callBack = function (go)
		self:ShowSelf(false)
	end

	local bookBtn = self:FindGO("BookBtn")
	self:AddClickEvent(bookBtn, function ()
		self:Book()
	end)
end

function EngageBookView:InitShow()
	local cost = self:FindGO("Cost")
	self.cost = SpriteLabel.new(cost, nil, 32, 32, true)
end

function EngageBookView:SetData(data, stick, side, offset)
	if data then
		self:ShowSelf(true)

		local pos = NGUIUtil.GetAnchorPoint(self.gameObject, stick, side, offset)
		self.gameObject.transform.position = pos

		local date = data.date
		local day = data.day

		self.timeStamp = date.timeStamp
		self.configid = day.configid

		self:UpdateView(date, day)
	end
end

function EngageBookView:UpdateView(date, dayData)
	self.zone.text = string.format(ZhString.Wedding_EngageBookZone, MyselfProxy.Instance:GetZoneString())

	local year = 1900
	self.month = 1
	self.day = 1
	if date ~= nil then
		year = date.time.year
		self.month = date.time.month
		self.day = date.time.day
	end
	self.starthour = 0
	self.endhour = 0
	self.costValue = 9999999999
	if dayData ~= nil then
		self.starthour = dayData:GetStartTimeData().hour
		self.endhour = dayData:GetEndTimeData().hour
		self.costValue = dayData.price
	end
	self.date.text = string.format(ZhString.Wedding_EngageBookDate, year, self.month, self.day, self.starthour, self.endhour)

	local itemid = _ZenyID
	if WeddingProxy.Instance:IsEngageUseTicket() then
		itemid = _TicketID
		self.costValue = 1
	end
	local info = string.format(ZhString.Wedding_EngageBookCost, itemid, self.costValue)
	self.cost:Reset()
	self.cost:SetText(info, true)

	local _Myself = Game.Myself
	local followid = _Myself:Client_GetFollowLeaderID()
	local handFollowerId = _Myself:Client_GetHandInHandFollower()
	local isHanding = _Myself:Client_IsFollowHandInHand()
	
	local handTargetId = isHanding and followid or handFollowerId
	local user = NSceneUserProxy.Instance:Find(handTargetId)
	local name = ""
	if user ~= nil then
		name = user.data.name
	end
	self.target.text = string.format(ZhString.Wedding_EngageBookTarget, name)
end

function EngageBookView:Book()
	if not WeddingProxy.Instance:IsSelfSingle() then
		MsgManager.ShowMsgByID(9648)
		return
	end

	if self.timeStamp ~= nil and self.configid ~= nil then
		--是否牵手
		local _Myself = Game.Myself
		local isHandFollow = _Myself:Client_IsFollowHandInHand()
		local handFollowId = _Myself:Client_GetHandInHandFollower()
		if isHandFollow == false and handFollowId == 0 then
			MsgManager.ShowMsgByID(9600)
			return
		end

		if handFollowId == 0 then
			MsgManager.ShowMsgByID(9628)
			return
		end

		--金币是否足够
		local isUseTicket = WeddingProxy.Instance:IsEngageUseTicket()
		local itemid = _TicketID
		if not isUseTicket then
			local total = MyselfProxy.Instance:GetROB()
			if total < self.costValue then
				MsgManager.ShowMsgByID(9603)
				return
			end

			itemid = _ZenyID
		end

		local sb = LuaStringBuilder.CreateAsTable()
		sb:Append(self.costValue)
		sb:Append(Table_Item[itemid].NameZh)

		MsgManager.ConfirmMsgByID(9604, function ()
			local isHandFollow = _Myself:Client_IsFollowHandInHand()
			local handFollowId = _Myself:Client_GetHandInHandFollower()
			if isHandFollow == false and handFollowId == 0  then
				MsgManager.ShowMsgByID(9600)
				return
			end

			ServiceWeddingCCmdProxy.Instance:CallReserveWeddingDateCCmd(self.timeStamp, self.configid, handFollowId, isUseTicket)

			self:ShowSelf(false)
		end, nil, nil, sb:ToString(), MyselfProxy.Instance:GetZoneString(), self.month, self.day, self.starthour, self.endhour)

		sb:Destroy()
	end
end

function EngageBookView:ShowSelf(isShow)
	self.gameObject:SetActive(isShow)
end