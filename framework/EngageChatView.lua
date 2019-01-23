EngageChatView = class("EngageChatView",SubView)

local channel = 2
local _ChatRoomProxy = ChatRoomProxy.Instance

function EngageChatView:OnEnter()
	EngageChatView.super.OnEnter(self)
	
	self.barrage = _ChatRoomProxy:GetBarrageState(channel)
	_ChatRoomProxy:SetBarrageState(channel, BarrageStateEnum.On)
end

function EngageChatView:OnExit()
	_ChatRoomProxy:SetBarrageState(channel, self.barrage)

	EngageChatView.super.OnExit(self)
end

function EngageChatView:Init()
	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function EngageChatView:FindObjs()
	self.gameObject = self:FindGO("ChatRoot")
	self.contentInput = self:FindGO("ContentInput"):GetComponent(UIInput)
	UIUtil.LimitInputCharacter(self.contentInput, 39)
end

function EngageChatView:AddEvts()
	local sendButton = self:FindGO("SendButton")
	self:AddClickEvent(sendButton, function ()
		self:ClickSendBtn()
	end)	
end

function EngageChatView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.UpdateShow)
	self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.UpdateShow)	
end

function EngageChatView:InitShow()
	self:UpdateShow()
end

function EngageChatView:UpdateShow()
	self.gameObject:SetActive(TeamProxy.Instance:IHaveTeam())
end

function EngageChatView:ClickSendBtn()
	local content = self.contentInput.value
	if content and #content>0 then
		if self.lastTime == nil or Time.realtimeSinceStartup - self.lastTime > 2 then
			ServiceChatCmdProxy.Instance:CallChatCmd(channel, content)

			self.lastTime = Time.realtimeSinceStartup
			self.contentInput.value = ""
		else
			MsgManager.FloatMsgTableParam(nil,ZhString.Chat_inputTooFrequently)
		end
	else
		MsgManager.FloatMsgTableParam(nil,ZhString.Chat_send)
	end	
end