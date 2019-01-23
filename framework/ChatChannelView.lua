autoImport("WrapScrollViewHelper")
autoImport("ChatRoomCombineCell")

ChatChannelView = class("ChatChannelView",SubView)

function ChatChannelView:Init()

	self.Color = { Default = "FFFFFF" , Toggle = "6a9af6" }

	self:FindObjs()
	self:AddEvts()
	self:AddViewEvts()
	self:InitShow()
end

function ChatChannelView:FindObjs()
	self.ChatChannel = self.container.ChatChannel
	self.contentScrollView=self:FindGO("contentScrollView",self.ChatChannel):GetComponent(UIScrollView)
	self.ContentPanel = self.contentScrollView.gameObject:GetComponent(UIPanel)
	self.ChannelToggle_system=self:FindGO("ChannelToggle_system",self.ChatChannel):GetComponent(UIToggle)
	self.ChannelToggle_world=self:FindGO("ChannelToggle_world",self.ChatChannel):GetComponent(UIToggle)
	self.ChannelToggle_current=self:FindGO("ChannelToggle_current",self.ChatChannel):GetComponent(UIToggle)
	self.ChannelToggle_guild=self:FindGO("ChannelToggle_guild",self.ChatChannel):GetComponent(UIToggle)
	self.ChannelToggle_Team=self:FindGO("ChannelToggle_Team",self.ChatChannel):GetComponent(UIToggle)
	self.SystemLabel = self:FindGO("SystemLabel" , self.ChannelToggle_system.gameObject):GetComponent(UILabel)
	self.WorldLabel = self:FindGO("WorldLabel" , self.ChannelToggle_world.gameObject):GetComponent(UILabel)
	self.CurrentLabel = self:FindGO("CurrentLabel" , self.ChannelToggle_current.gameObject):GetComponent(UILabel)
	self.GuildLabel = self:FindGO("GuildLabel" , self.ChannelToggle_guild.gameObject):GetComponent(UILabel)
	self.TeamLabel = self:FindGO("TeamLabel" , self.ChannelToggle_Team.gameObject):GetComponent(UILabel)
	self.ContentTable = self:FindGO("ContentTable" , self.ChatChannel)
	self.NewMessage = self:FindGO("NewMessageBg",self.ChatChannel)
	self.NewMessageLabel = self:FindGO("NewMessageLabel",self.NewMessage):GetComponent(UILabel)
	self.BarrageRoot = self:FindGO("BarrageRoot",self.ChatChannel):GetComponent(UIMultiSprite)
	self.BarrageOff = self:FindGO("BarrageOff",self.BarrageRoot.gameObject)
	self.BarrageOn = self:FindGO("BarrageOn",self.BarrageRoot.gameObject)
end

function ChatChannelView:AddEvts()
	self:AddClickEvent(self.ChannelToggle_system.gameObject,function (g)
		self:ClickChannelToggle_system(g)
	end)
	self:AddClickEvent(self.ChannelToggle_world.gameObject,function (g)
		self:ClickChannelToggle_world(g)
	end)
	self:AddClickEvent(self.ChannelToggle_current.gameObject,function (g)
		self:ClickChannelToggle_current(g)
	end)
	self:AddClickEvent(self.ChannelToggle_guild.gameObject,function (g)
		self:ClickChannelToggle_guild(g)
	end)
	self:AddClickEvent(self.ChannelToggle_Team.gameObject,function (g)
		self:ClickChannelToggle_Team(g)
	end)
	self:AddClickEvent(self.NewMessage,function (g)
		self:HandleNewMessage()
	end)
	self:AddClickEvent(self.BarrageRoot.gameObject,function (g)
		self:ClickBarrage()
	end)
	-- self.contentScrollView.onMomentumMove=function()
	-- 	if self.itemContent:GetIsMoveToFirst() then
	-- 		self:ResetNewMessage()
	-- 	else
	-- 		self.isLock = true
	-- 	end
	-- end
end

function ChatChannelView:AddViewEvts()
	self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam , self.HandleResetTalk)
	self:AddListenEvt(ServiceEvent.SessionTeamExitTeam , self.HandleResetTalk)
	self:AddListenEvt(ServiceEvent.GuildCmdEnterGuildGuildCmd , self.HandleResetTalk)
	self:AddListenEvt(ServiceEvent.GuildCmdExitGuildGuildCmd , self.HandleResetTalk)
	self:AddListenEvt(ChatRoomEvent.ForceChannel , self.HandleForceChannel)
end

function ChatChannelView:InitShow()

	self.SystemLabel.text = ZhString.Chat_system
	self.WorldLabel.text = ZhString.Chat_world
	self.CurrentLabel.text = ZhString.Chat_current
	self.GuildLabel.text = ZhString.Chat_guild
	self.TeamLabel.text = ZhString.Chat_team

	self:InitContentList()

	-- self:UpdateChatChannelInfo()
end

function ChatChannelView:InitUI()
	local viewdata = self.container.viewdata.viewdata
	local channel
	if viewdata and viewdata.key == "Channel" then
		channel = viewdata.channel or ChatChannelEnum.System
	else
		channel = ChatRoomProxy.Instance:GetChatRoomChannel()
		if channel == ChatChannelEnum.Private then
			channel = nil
		end
	end

	if channel ~= nil then
		self:SetDefaultColor()
		self.curChannel = channel
		self:SetToggle(self.curChannel)
		self:SetToggleColor()

		self:ResetTalk()
	end

	self:ResetNewMessage()
	
	self.ContentTable:SetActive(true)
end

function ChatChannelView:OnEnter()
	self.super.OnEnter(self)

	self:InitUI()
end

function ChatChannelView:OnExit()

	self.ContentTable:SetActive(false)

	ChatChannelView.super.OnExit(self);
end

function ChatChannelView:RecvChatRetUserCmd(note)

	if note.body:GetChannel() ~= self.curChannel then
		return
	end

	if self.isLock then
		if note.body:GetId() == Game.Myself.data.id then
			self.isLock = false
			self.unRead = 0
		else
			self.unRead = self.unRead + 1
		end
	end
	
	-- self:UpdateChatChannelInfo(self.curChannel)

	if self.unRead > 0 then
		self:ShowNewMessage()

		self:UpdateChatChannelInfo(self.curChannel)
	else
		self.NewMessage:SetActive(false)
		-- self.itemTableContent:ResetPosition()
		self:ResetPositionInfo()
	end
end

function ChatChannelView:InitContentList()
	-- self.itemTableContent = UITableListCtrl.new(self.ContentTable , "Chat" , 1)
	-- local config = {
	-- 	cellType = ChatTypeEnum.MySelfMessage,
	-- 	cellName = "ChatRoomMySelfCell",
	-- 	control = ChatRoomMySelfCell
	-- }
	-- self.itemTableContent:SetType(config)

	-- config.cellType = ChatTypeEnum.SomeoneMessage
	-- config.cellName = "ChatRoomSomeoneCell"
	-- config.control = ChatRoomSomeoneCell
	-- self.itemTableContent:SetType(config)

	-- config.cellType = ChatTypeEnum.SystemMessage
	-- config.cellName = "ChatRoomSystemCell"
	-- config.control = ChatRoomSystemCell
	-- self.itemTableContent:SetType(config)

	-- self.itemTableContent:AddEventListener(ChatRoomEvent.SelectHead, self.container.HandleClickHead , self)

	self.itemContent = WrapScrollViewHelper.new(ChatRoomCombineCell, ChatRoomPage.rid, 
		self.contentScrollView.gameObject, self.ContentTable, 25, function ()
			if self.itemContent:GetIsMoveToFirst() then
				self:ResetNewMessage()
			else
				self.isLock = true
			end
		end)

	self.itemContent:AddEventListener(ChatRoomEvent.SelectHead, self.container.HandleClickHead , self)
end

function ChatChannelView:ChatRoomPageData(channel)
	return ChatRoomProxy.Instance:GetMessagesByChannel(channel);
end

function ChatChannelView:UpdateChatChannelInfo(channel)
	if(channel==nil)then
		channel = self.curChannel
	end
	local datas = self:ChatRoomPageData(channel);
	if(datas)then
		self.itemContent:UpdateInfo(datas,self.isLock)
	end
end

function ChatChannelView:ResetPositionInfo(isCheckCanDestroy)
	local datas = self:ChatRoomPageData(self.curChannel)
	if datas then
		if isCheckCanDestroy then
			Game.ChatSystemManager:CheckCanDestroy(datas)
		end

		self.itemContent:ResetPosition(datas)
	end
end

function ChatChannelView:ClickChannelToggle_system(g)
	self:HandleClickChannel(ChatChannelEnum.System)
end

function ChatChannelView:ClickChannelToggle_world(g)
	self:HandleClickChannel(ChatChannelEnum.World)
end

function ChatChannelView:ClickChannelToggle_current(g)
	self:HandleClickChannel(ChatChannelEnum.Current)
end

function ChatChannelView:ClickChannelToggle_guild(g)
	self:HandleClickChannel(ChatChannelEnum.Guild)
end

function ChatChannelView:ClickChannelToggle_Team(g)
	self:HandleClickChannel(ChatChannelEnum.Team)
end

function ChatChannelView:HandleClickChannel(channel)
	self:SetDefaultColor()
	self.curChannel = channel
	self:SetToggleColor()
	self:ResetNewMessage()
	self:ResetPositionInfo(true)
	self.container:ResetKeyword()
	-- self.itemTableContent:ResetPosition()
	-- self:ResetPositionInfo()
	self:ResetTalk()
end

function ChatChannelView:HandleNewMessage()
	self:ResetNewMessage()
	-- self:UpdateChatChannelInfo()
	-- self.itemTableContent:ResetPosition()
	self:ResetPositionInfo()
end

function ChatChannelView:ClickBarrage()
	if self.BarrageRoot.CurrentState == BarrageStateEnum.Off then
		self:ShowBarrage(BarrageStateEnum.On)
	elseif self.BarrageRoot.CurrentState == BarrageStateEnum.On then
		self:ShowBarrage(BarrageStateEnum.Off)
	end
	ChatRoomProxy.Instance:SetBarrageState(self.curChannel,self.BarrageRoot.CurrentState)
end

-- state = 0 : off ,state = 1 : on
function ChatChannelView:ShowBarrage(state)
	self.BarrageRoot.CurrentState = state
	if state == BarrageStateEnum.Off then
		self.BarrageOff:SetActive(true)
		self.BarrageOn:SetActive(false)
	elseif state == BarrageStateEnum.On then
		self.BarrageOff:SetActive(false)
		self.BarrageOn:SetActive(true)
	end
end

function ChatChannelView:ResetNewMessage()
	self.isLock = false
	self.unRead = 0
	if self.NewMessage.activeSelf then
		self.NewMessage:SetActive(false)	
	end
end

function ChatChannelView:HandleResetTalk()
	if self.container.CurrentState == ChatRoomEnum.CHANNEL then
		self:ResetTalk()
	end
end

function ChatChannelView:HandleForceChannel(note)
	local data = note.body
	if data then
		self:HandleClickChannel(data.channel)
		self:SetToggle(self.curChannel)
		self.container:SwitchValue(ChatRoomEnum.CHANNEL)

		local content = ChatRoomProxy.Instance:AddTutor(data.tutorType)
		if content ~= nil then
			self.container.contentInput.value = content
		end
	end
end

function ChatChannelView:ResetTalk()
	if self.curChannel == ChatChannelEnum.World then
		self.container:SetVisible(true)
		self.BarrageRoot.gameObject:SetActive(false)

	elseif self.curChannel == ChatChannelEnum.Current then
		self.container:SetVisible(true)
		self.BarrageRoot.gameObject:SetActive(false)

	elseif self.curChannel == ChatChannelEnum.Team then
		self.container:IsInTeam()

		self.BarrageRoot.gameObject:SetActive(true)
		self:ShowBarrage(ChatRoomProxy.Instance:GetBarrageState(self.curChannel))

	elseif self.curChannel == ChatChannelEnum.Guild then
		self.container:IsInGuild()

		self.BarrageRoot.gameObject:SetActive(true)
		self:ShowBarrage(ChatRoomProxy.Instance:GetBarrageState(self.curChannel))

	elseif self.curChannel == ChatChannelEnum.System then
		self.container:SetVisible(false)
		self.BarrageRoot.gameObject:SetActive(false)
	end

	-- ChatRoomProxy.Instance:SetCurrentChannel(self.curChannel)
	ChatRoomProxy.Instance:SetCurrentChatChannel(self.curChannel)
end

function ChatChannelView:SetDefaultColor()
	 if self.defaultResultC == nil then
 		local hasC = nil
		hasC , self.defaultResultC = ColorUtil.TryParseHexString(self.Color.Default)
	end
	if self.defaultResultC then
		self:SetColor(self.curChannel,self.defaultResultC)
	end
end

function ChatChannelView:SetToggleColor()
 	if self.toggleResultC == nil then
 		local hasC = nil
		hasC , self.toggleResultC = ColorUtil.TryParseHexString(self.Color.Toggle)
	end
	if self.toggleResultC then
		self:SetColor(self.curChannel,self.toggleResultC)
	end
end

function ChatChannelView:SetToggle(curChannel)
	if curChannel == ChatChannelEnum.System then
		self.ChannelToggle_system.value = true
	elseif curChannel == ChatChannelEnum.World then
		self.ChannelToggle_world.value = true
	elseif curChannel == ChatChannelEnum.Current then
		self.ChannelToggle_current.value = true
	elseif curChannel == ChatChannelEnum.Guild then
		self.ChannelToggle_guild.value = true
	-- elseif curChannel == SceneUser2_pb.ECHAT_CHANNEL_MAP then
	-- 	self.ChannelToggle_party.value = true
	elseif curChannel == ChatChannelEnum.Team then
		self.ChannelToggle_Team.value = true
	end
end

function ChatChannelView:SetColor(curChannel,color)
	if curChannel == ChatChannelEnum.System then
		self.SystemLabel.color = color
	elseif curChannel == ChatChannelEnum.World then
		self.WorldLabel.color = color
	elseif curChannel == ChatChannelEnum.Current then
		self.CurrentLabel.color = color
	elseif curChannel == ChatChannelEnum.Guild then
		self.GuildLabel.color = color
	-- elseif curChannel == SceneUser2_pb.ECHAT_CHANNEL_MAP then
	-- 	self.PartyLabel.color = color
	elseif curChannel == ChatChannelEnum.Team then
		self.TeamLabel.color = color
	end
end

function ChatChannelView:SendMessage(content,voice,voicetime)
	-- ChatRoomNetProxy.Instance:CallChatUserCmd(self.curChannel,content,nil,voice,voicetime)
	ServiceChatCmdProxy.Instance:CallChatCmd(self.curChannel,content,nil,voice,voicetime)
	-- print("CallChatUserCmd,channel is "..self.curChannel)
end

function ChatChannelView:ShowNewMessage()
 	if not self.NewMessage.activeSelf then
 		self.NewMessage:SetActive(true)
 	end
 	self.NewMessageLabel.text = tostring(self.unRead)..ZhString.Chat_newMessage
end

function ChatChannelView:HandleKeywordEffect(note)
	local datas = note.body

	if self.container.CurrentState ~= ChatRoomEnum.CHANNEL then
		return
	end
	
	if datas.message:GetChannel() ~= self.curChannel then
		return
	end

	self.container:AddKeywordEffect(datas.data)
end