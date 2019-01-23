autoImport("ChatBarrageCell")

AuguryChatView = class("AuguryChatView",SubView)

function AuguryChatView:OnEnter()
	AuguryChatView.super.OnEnter(self)
	AuguryProxy.Instance:SetInAugury(true)
end

function AuguryChatView:OnExit()
	AuguryProxy.Instance:SetInAugury(false)
	AuguryChatView.super.OnExit(self)
end

function AuguryChatView:Init()
	self:FindObj()
	self:AddEvt()
	self:AddViewEvt()
	self:InitShow()
end

function AuguryChatView:FindObj()
	self.chatRoot = self:FindGO("ChatRoot")

	self.switch = self:FindGO("Switch" , self.chatRoot)

	self.talk = self:FindGO("Talk" , self.chatRoot)
	self.contentInput = self:FindGO("ContentInput" , self.talk):GetComponent(UIInput)
	UIUtil.LimitInputCharacter(self.contentInput, 39)
end

function AuguryChatView:AddEvt()
	local sendButton = self:FindGO("SendButton" , self.talk)
	self:AddClickEvent( sendButton ,function ()
		self:ClickSendButton()
	end)

	local inputRoot = self:FindGO("InputRoot" , self.chatRoot)
	local longPress = inputRoot:GetComponent(UILongPress)
	if longPress then
		longPress.pressEvent = function (obj, state)
			if state then
				ChatRoomProxy.Instance:TryRecognizer()
			else
				self:sendNotification(ChatRoomEvent.StopRecognizer)
			end
		end
	end

	self:AddClickEvent( self.switch ,function ()
		self:ClickSwitch()
	end)
end

function AuguryChatView:AddViewEvt()
	self:AddListenEvt(ServiceEvent.SceneAuguryAuguryChat , self.UpdateChatInfo)
end

function AuguryChatView:InitShow()
	self.lastTime = 0
	self.channel = ChatChannelEnum.World

	self:UpdateSwitch( false )
end

function AuguryChatView:ClickSwitch()
	local isTalkShow = self.talk.activeInHierarchy
	self:UpdateSwitch( not isTalkShow )
end

function AuguryChatView:ClickSendButton()
	local content = self.contentInput.value
	if content and #content>0 then
		if Time.realtimeSinceStartup - self.lastTime > 2 then
			content = ChatRoomProxy.Instance:StripSymbols(content)
			content = ChatRoomProxy.Instance:TryParseItemCodeToItemData(content)

			ServiceSceneAuguryProxy.Instance:CallAuguryChat( content , Game.Myself.data.name)

			self.lastTime = Time.realtimeSinceStartup
			self.contentInput.value = ""
			ChatRoomProxy.Instance:ResetItemDataList()
		else
			MsgManager.FloatMsgTableParam(nil,ZhString.Chat_inputTooFrequently)
		end
	else
		MsgManager.FloatMsgTableParam(nil,ZhString.Chat_send)
	end
end

function AuguryChatView:UpdateChatInfo()
	local data = AuguryProxy.Instance:GetAuguryChat()
	if #data > 0 then
		local cellCtr = ChatBarrageCell.CreateAsTable(self.gameObject.transform)
		cellCtr:SetMinH(-220)
		cellCtr:SetMaxH(130)
		cellCtr:SetData(data[1])
		AuguryProxy.Instance:RemoveAuguryChat()
	end
end

function AuguryChatView:UpdateSwitch(isShowTalk)
	self.talk:SetActive(isShowTalk)
end