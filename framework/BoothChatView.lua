autoImport("MainViewChatGroup")
autoImport("ChatSimplifyView")

BoothChatView = class("BoothChatView", SubView)

function BoothChatView:Init()
	self:InitPage();
end

function BoothChatView:InitPage()	
	self:FindObjs()
	self:AddEvts()
	self:MapListenEvt()
	self:InitShow()
end

function BoothChatView:FindObjs()
	local ChatParent = self:FindGO("ChatParent")
	self.mainViewChat = self:LoadCellPfb("MainViewChat", "MainViewChat", ChatParent)

	local objFadeBtn = self:FindGO("FadeBtn")
	if (objFadeBtn) then objFadeBtn:SetActive(false) end

	self.objButtonGrid = self:FindGO("ButtonGrid")

	self.teamSpeech = self:FindGO("TeamSpeech"):GetComponent(UISprite)
	self.guildSpeech = self:FindGO("GuildSpeech"):GetComponent(UISprite)
	if GameConfig.SystemForbid.OpenVoiceSend then
    		self.teamSpeech.gameObject:SetActive(false)
    		self.guildSpeech.gameObject:SetActive(false)
    else
   
    end
end

function BoothChatView:AddEvts()
	self:AddClickEvent(self:FindGO("WorldMsg"),function (go)
		self:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.ChatRoomPage,force = force})
	end)

	local emojiButton = self:FindGO("EmojiButton");
	FunctionUnLockFunc.Me():RegisteEnterBtnByPanelID(PanelConfig.ChatEmojiView.id, emojiButton)
	self:AddClickEvent(emojiButton, function ()
		if(not self.isEmojiShow)then
			self:ToView(PanelConfig.ChatEmojiView);
		else
			self:sendNotification(UIEvent.CloseUI, UIViewType.ChatLayer); 
		end
	end);

	self:AddClickEvent(self.teamSpeech.gameObject, function ()
		FunctionSecurity.Me():TryDoRealNameCentify();
	end);
	local teamSpeechLongPress = self.teamSpeech.gameObject:GetComponent(UILongPress)
	if teamSpeechLongPress then
		teamSpeechLongPress.pressEvent = function (obj,state)
			self:TryTeamVoiceRecognizer(state);
		end
	end

	self:AddClickEvent(self.guildSpeech.gameObject, function ()
		FunctionSecurity.Me():TryDoRealNameCentify();
	end);
	local guildSpeechLongPress = self.guildSpeech.gameObject:GetComponent(UILongPress)
	if guildSpeechLongPress then
		guildSpeechLongPress.pressEvent = function ( obj,state )
			self:TryGuildVoiceRecognizer(state);
		end
	end
end

function BoothChatView:TryTeamVoiceRecognizer(state)
	if(FunctionSecurity.Me():NeedDoRealNameCentify())then
		return;
	end

	if state then
		if TeamProxy.Instance:IHaveTeam() then
			local allow = ChatRoomProxy.Instance:TryRecognizer()
			if allow then
				self.isTeamSpeech = true
				self.curChannel = ChatChannelEnum.Team
			end
		else
			MsgManager.ShowMsgByIDTable(332)
		end			
	else
		if self.isTeamSpeech then
			local isInRange = Game.UILongPressManager:GetState()
			if not isInRange then
				self.curChannel = nil
			end

			self.isTeamSpeech = false
			self:sendNotification(ChatRoomEvent.StopRecognizer)
		end
	end
end

function BoothChatView:TryGuildVoiceRecognizer(state)
	if(FunctionSecurity.Me():NeedDoRealNameCentify())then
		return;
	end

	if state then
		if GuildProxy.Instance:IHaveGuild() then
			local allow = ChatRoomProxy.Instance:TryRecognizer()
			if allow then
				self.isGuildSpeech = true
				self.curChannel = ChatChannelEnum.Guild
			end
		else
			MsgManager.ShowMsgByIDTable(2620)
		end			
	else
		if self.isGuildSpeech then
			local isInRange = Game.UILongPressManager:GetState()
			if not isInRange then
				self.curChannel = nil
			end

			self.isGuildSpeech = false
			self:sendNotification(ChatRoomEvent.StopRecognizer)
		end
	end
end

function BoothChatView:MapListenEvt()
	self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam , self.EnterTeam)
	self:AddListenEvt(ServiceEvent.SessionTeamExitTeam , self.ExitTeam)
	self:AddListenEvt(ServiceEvent.GuildCmdEnterGuildGuildCmd , self.EnterGuild)
	self:AddListenEvt(ServiceEvent.GuildCmdExitGuildGuildCmd , self.ExitGuild)

	self:AddListenEvt(MainViewEvent.EmojiViewShow, self.HandleEmojiShowSync);
end

function BoothChatView:InitShow()
	self.isTeamSpeech = false
	self.isGuildSpeech = false

	local initParama = ReusableTable.CreateTable()
	initParama.gameObject = self.mainViewChat
	initParama.chatCellCtrl = MainViewChatGroup
	initParama.chatCellPfb = "MainViewChatGroup"
	self.chatSimplifyView = self:AddSubView("ChatSimplifyView", ChatSimplifyView, initParama)
	ReusableTable.DestroyAndClearTable(initParama)

	if TeamProxy.Instance:IHaveTeam() then
		self:EnterTeam()
	else
		self:ExitTeam()
	end

	if GuildProxy.Instance:IHaveGuild() then
		self:EnterGuild()
	else
		self:ExitGuild()
	end

	local cells = self.chatSimplifyView.chatCtl:GetCells()
	for i=1,#cells do
		local cell = cells[i]
		local channel = GameConfig.ChatRoom.MainView[i]
		if channel then
			cell:SetTweenLevel(2)
		end
	end
end

function BoothChatView:LoadCellPfb(cellPfb,cName,parent)
	local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cellPfb))
	cellpfb.transform:SetParent(parent.transform,false)
	cellpfb.name = cName
	return cellpfb
end

function BoothChatView:HandleEmojiShowSync(note)
	self.isEmojiShow = note.body;
end

--显示与否语音图标
function BoothChatView:EnterTeam()
	self.teamSpeech.gameObject:SetActive(true)
	if GameConfig.SystemForbid.OpenVoiceSend then
    	self.teamSpeech.gameObject:SetActive(false)
    	self.guildSpeech.gameObject:SetActive(false)
    else
   
    end
end

function BoothChatView:ExitTeam()
	self.teamSpeech.gameObject:SetActive(false)
end

function BoothChatView:EnterGuild()
	self.guildSpeech.gameObject:SetActive(true)
	if GameConfig.SystemForbid.OpenVoiceSend then
    	self.teamSpeech.gameObject:SetActive(false)
    	self.guildSpeech.gameObject:SetActive(false)
    else
   
    end
end

function BoothChatView:ExitGuild()
	self.guildSpeech.gameObject:SetActive(false)
end