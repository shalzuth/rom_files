autoImport("MainViewChatGroup")
autoImport("ChatSimplifyView")

MainViewChatMsgPage = class("MainViewChatMsgPage",SubView)

function MainViewChatMsgPage:Init()
	self:InitPage();

	ServiceChatCmdProxy.Instance:CallGetVoiceIDChatCmd()

	ChatRoomProxy.Instance:CheckRedTip()
end

function MainViewChatMsgPage:OnEnter()
	MainViewChatMsgPage.super.OnEnter(self)
end

function MainViewChatMsgPage:OnExit()
	self.speechRecognizer.handler = nil
end

function MainViewChatMsgPage:OnShow()
	MainViewChatMsgPage.super.OnEnter(self)
	if self.chatSimplifyView.chatCtl then
		local cells = self.chatSimplifyView.chatCtl:GetCells()
		for i=1,#cells do
			cells[i]:Refresh()
		end
	end
end

function MainViewChatMsgPage:InitPage()	
	self:FindObjs()
	self:AddEvts()
	self:MapListenEvt()
	self:InitShow()
end

function MainViewChatMsgPage:FindObjs()

	local Anchor_DownLeft = self:FindGO("Anchor_DownLeft")
	self.mainViewChat = self:LoadCellPfb("MainViewChat","MainViewChat",Anchor_DownLeft)
	self.fadeBtnSp = self:FindGO("FadeBtn"):GetComponent(UISprite)

	self.worldMsgTween = self:FindGO("WorldMsg"):GetComponent(TweenHeight)
	self.fadeBtnTween = self.fadeBtnSp.gameObject:GetComponent(TweenPosition)
	self.chatGridTween = self:FindGO("ChatGrid"):GetComponent(TweenPosition)
	self.buttonGridTween = self:FindGO("ButtonGrid"):GetComponent(TweenPosition)

	self.worldMsgCollider = self.worldMsgTween.gameObject:GetComponent(BoxCollider)

	self.teamSpeech = self:FindGO("TeamSpeech"):GetComponent(UISprite)
	self.guildSpeech = self:FindGO("GuildSpeech"):GetComponent(UISprite)
	
	self.speechRecognizer = UIManagerProxy.Instance.speechRecognizer

	if GameConfig.SystemForbid.OpenVoiceSend then
		self.teamSpeech.gameObject:SetActive(false)
		self.guildSpeech.gameObject:SetActive(false)
	else

	end
end

function MainViewChatMsgPage:AddEvts()

	self:AddClickEvent(self.worldMsgTween.gameObject,function (go)
		self:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.ChatRoomPage,force = force})
	end)

	self:AddClickEvent(self.fadeBtnTween.gameObject,function (go)
		self:FadeTween()
	end)

	self.worldMsgTween:SetOnFinished(function ()
		if self.worldMsgTween.value == self.worldMsgTween.to then
			self.worldMsgCollider.size = self.worldMsgCollider.size * self.scale
		end
	end)

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

	self.speechRecognizer.handler = function (bytes,time,result)
		self:sendNotification(ChatRoomEvent.StopRecognizer)

		local voice = Slua.ToString(bytes)
		if result and #result>0 then
			--在占卜状态下
			if AuguryProxy.Instance:GetInAugury() then
				ServiceSceneAuguryProxy.Instance:CallAuguryChat( result , Game.Myself.data.name)
			--点击主界面公会/组队语音按钮
			elseif self.curChannel then
				ServiceChatCmdProxy.Instance:CallChatCmd(self.curChannel,result,nil,bytes,time)
				-- ChatRoomNetProxy.Instance:CallChatUserCmd(self.curChannel,result,nil,bytes,time)
				self.curChannel = nil
			--普通聊天栏
			else
				local isInRange = Game.UILongPressManager:GetState()
				if isInRange then
					self:sendNotification(ChatRoomEvent.SendSpeech , { content = result , voice = bytes , voicetime = time } )
				end
			end		
		end
	end

	self.speechRecognizer:SetName(FunctionChatSpeech.Me().speechFileName)
end

function MainViewChatMsgPage:TryTeamVoiceRecognizer(state)
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

function MainViewChatMsgPage:TryGuildVoiceRecognizer(state)
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

function MainViewChatMsgPage:MapListenEvt()
	self:AddListenEvt(ServiceEvent.ChatCmdChatRetCmd,self.UpdateChatRoom)
	self:AddListenEvt(ChatRoomEvent.SystemMessage,self.UpdateChatRoom)
	self:AddListenEvt(ServiceEvent.ConnNetDelay, self.HandleConnNetDelay)
	self:AddListenEvt(ServiceUserProxy.RecvLogin , self.HandleRedTip)
	self:AddListenEvt(ServiceEvent.ChatCmdQueryVoiceUserCmd , self.RecvQueryVoice)

	self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam , self.EnterTeam)
	self:AddListenEvt(ServiceEvent.SessionTeamExitTeam , self.ExitTeam)
	self:AddListenEvt(ServiceEvent.GuildCmdEnterGuildGuildCmd , self.EnterGuild)
	self:AddListenEvt(ServiceEvent.GuildCmdExitGuildGuildCmd , self.ExitGuild)

	self:AddListenEvt(PVPEvent.PVP_PoringFightLaunch, self.HandlePoringFightBegin);
	self:AddListenEvt(PVPEvent.PVP_PoringFightShutdown, self.HandlePoringFightEnd);
end

function MainViewChatMsgPage:HandlePoringFightBegin(note)
	self.mainViewChat:SetActive(false);
	self.buttonGridTween.gameObject:SetActive(false);
end

function MainViewChatMsgPage:HandlePoringFightEnd(note)
	self.mainViewChat:SetActive(true);
	self.buttonGridTween.gameObject:SetActive(true);
end

function MainViewChatMsgPage:InitShow()

	self.scale = 0.8

	self.worldMsgTweenValue = {76,120,406}
	self.fadeBtnTweenValue = { Vector3(self.fadeBtnTween.from.x , 62.5 , self.fadeBtnTween.from.z) ,
								Vector3(self.fadeBtnTween.from.x , 106.5 , self.fadeBtnTween.from.z) , 
								Vector3(self.fadeBtnTween.from.x , 392.5 , self.fadeBtnTween.from.z)}
	self.chatGridTweenValue = { Vector3(self.chatGridTween.from.x , 68.5 , self.chatGridTween.from.z) ,
								Vector3(self.chatGridTween.from.x , 112.5 , self.chatGridTween.from.z) , 
								Vector3(self.chatGridTween.from.x , 398.5 , self.chatGridTween.from.z)}
	self.buttonGridTweenValue = { Vector3(self.buttonGridTween.from.x , 146 , self.buttonGridTween.from.z) ,
								Vector3(self.buttonGridTween.from.x , 190 , self.buttonGridTween.from.z) , 
								Vector3(self.buttonGridTween.from.x , 476 , self.buttonGridTween.from.z)}

	self.tweenLevel = LocalSaveProxy.Instance:GetMainViewChatTweenLevel()
	self.isTeamSpeech = false
	self.isGuildSpeech = false

	local initParama = ReusableTable.CreateTable()
	initParama.gameObject = self.mainViewChat
	initParama.chatCellCtrl = MainViewChatGroup
	initParama.chatCellPfb = "MainViewChatGroup"
	self.chatSimplifyView = self:AddSubView("ChatSimplifyView", ChatSimplifyView, initParama)
	ReusableTable.DestroyAndClearTable(initParama)

	FunctionChatSpeech.Me():Reset(self.speechRecognizer.gameObject,function ()

		self:sendNotification(ChatRoomEvent.StopVoice)
		FunctionChatSpeech.Me():SetCurrentVoiceId(nil)

		ChatRoomProxy.Instance:AutoSpeechFinish()

		FunctionBGMCmd.Me():EndSpeakVoice()
	end)

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
			cell:SetTweenLevel(self.tweenLevel)
		end
	end

	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PRIVATE_CHAT, self.fadeBtnSp, 42, {0,10})

	self:InitTween()
end

--chat room region
function MainViewChatMsgPage:UpdateChatRoom(note)
	if note then
		local data = note.body
		if data and data:GetCellType() ~= ChatTypeEnum.SystemMessage then
			if ChatRoomProxy.Instance:IsPlayerSpeak(data:GetChannel()) then
				local playerid, str = data:GetId(), data:GetStr(true)
				if(playerid and str)then
					SceneUIManager.Instance:PlayerSpeak(playerid, str)
				end
			end
		end
	end
end

function MainViewChatMsgPage:LoadCellPfb(cellPfb,cName,parent)
	local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(cellPfb))
	cellpfb.transform:SetParent(parent.transform,false)
	cellpfb.name = cName
	return cellpfb
end

local tempVector3 = LuaVector3.zero
function MainViewChatMsgPage:InitTween()
	local worldMsgSp = self.worldMsgTween.gameObject:GetComponent(UISprite)
	worldMsgSp.height = self.worldMsgTweenValue[self.tweenLevel]
	tempVector3:Set(self.worldMsgCollider.size.x * self.scale, self.worldMsgTweenValue[self.tweenLevel] * self.scale, self.worldMsgCollider.size.z * self.scale)
	self.worldMsgCollider.size = tempVector3
	tempVector3:Set(self.worldMsgCollider.center.x , self.worldMsgTweenValue[self.tweenLevel] / 2 , self.worldMsgCollider.center.z)
	self.worldMsgCollider.center = tempVector3

	self.fadeBtnSp.transform.localPosition = self.fadeBtnTweenValue[self.tweenLevel]
	if self.tweenLevel == #self.worldMsgTweenValue then
		self.fadeBtnSp.flip = 1
	else
		self.fadeBtnSp.flip = 0
	end

	self.chatGridTween.transform.localPosition = self.chatGridTweenValue[self.tweenLevel]
	self.buttonGridTween.transform.localPosition = self.buttonGridTweenValue[self.tweenLevel]
end

function MainViewChatMsgPage:FadeTween()
	self:SetTweenValue()

	self.worldMsgTween:ResetToBeginning()
	self.fadeBtnTween:ResetToBeginning()
	self.chatGridTween:ResetToBeginning()
	self.buttonGridTween:ResetToBeginning()

	self.worldMsgTween:PlayForward()
	self.fadeBtnTween:PlayForward()
	self.chatGridTween:PlayForward()
	self.buttonGridTween:PlayForward()

	local cells = self.chatSimplifyView.chatCtl:GetCells()
	for i=1,#cells do
		cells[i]:SetTweenLevel(self.tweenLevel)
	end

	if self.tweenLevel == #self.worldMsgTweenValue then
		self.fadeBtnSp.flip = 1
	else
		self.fadeBtnSp.flip = 0
	end
end

function MainViewChatMsgPage:SetTweenValue()
	if self.worldMsgTweenValue[self.tweenLevel] then
		local nextLevel = self.tweenLevel + 1
		if self.worldMsgTweenValue[nextLevel] == nil then
			nextLevel = 1
		end

		self.worldMsgTween.from = self.worldMsgTweenValue[self.tweenLevel]
		self.worldMsgTween.to = self.worldMsgTweenValue[nextLevel]

		self.fadeBtnTween.from = self.fadeBtnTweenValue[self.tweenLevel]
		self.fadeBtnTween.to = self.fadeBtnTweenValue[nextLevel]

		self.chatGridTween.from = self.chatGridTweenValue[self.tweenLevel]
		self.chatGridTween.to = self.chatGridTweenValue[nextLevel]

		self.buttonGridTween.from = self.buttonGridTweenValue[self.tweenLevel]
		self.buttonGridTween.to = self.buttonGridTweenValue[nextLevel]

		self.tweenLevel = nextLevel
		LocalSaveProxy.Instance:SetMainViewChatTweenLevel(self.tweenLevel)
	end
end

function MainViewChatMsgPage:HandleConnNetDelay()
	if ChatZoomProxy.Instance:IsInChatZone() then
		ServiceChatRoomProxy.Instance:RecvExitChatRoom()
	end
end

function MainViewChatMsgPage:HandleRedTip()
	ChatRoomProxy.Instance:CheckRedTip()
end

--语音
function MainViewChatMsgPage:RecvQueryVoice(note)
	local data = note.body
	printOrange("RecvQueryVoice")
	if data and data.path then
		FunctionChatSpeech.Me():PlayAudioByPath(data.path,data.voiceid)
	end
end

--显示与否语音图标
function MainViewChatMsgPage:EnterTeam()
	self.teamSpeech.gameObject:SetActive(true)
	if GameConfig.SystemForbid.OpenVoiceSend then
    	self.teamSpeech.gameObject:SetActive(false)
    	self.guildSpeech.gameObject:SetActive(false)
    end
end

function MainViewChatMsgPage:ExitTeam()
	self.teamSpeech.gameObject:SetActive(false)
end

function MainViewChatMsgPage:EnterGuild()
	self.guildSpeech.gameObject:SetActive(true)
	if GameConfig.SystemForbid.OpenVoiceSend then
    	self.teamSpeech.gameObject:SetActive(false)
    	self.guildSpeech.gameObject:SetActive(false)
    end
end

function MainViewChatMsgPage:ExitGuild()
	self.guildSpeech.gameObject:SetActive(false)
end