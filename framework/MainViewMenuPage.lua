autoImport("GainWayTip")
autoImport("SystemUnLockView")

MainViewMenuPage = class("MainViewMenuPage", SubView)

autoImport("MainViewButtonCell");
autoImport("PersonalPicturePanel");

function MainViewMenuPage:Init()
	self:InitUI();
	self:MapViewInterests();
end

function MainViewMenuPage:InitUI()
	self.moreBtn = self:FindGO("MoreButton");
	self.moreBord = self:FindGO("MoreBord");
	self.moreGrid = self:FindComponent("Grid", UIGrid, self.moreBord);
	self.topRFuncGrid = self:FindComponent("TopRightFunc", UIGrid);
	self.topRFuncGrid2 = self:FindComponent("TopRightFunc2", UIGrid);

	self.rewardBtn = self:FindGO("RewardButton");
	self.tempAlbumButton = self:FindGO("TempAlbumButton");
	self.bagBtn = self:FindGO("BagButton");
	self.autoBattleButton =	self:FindGO("AutoBattleButton");
	self.glandStatusButton = self:FindGO("GlandStatusButton");
	self:AddClickEvent(self.glandStatusButton, function (go)
		self:ToView(PanelConfig.GLandStatusListView);
	end);

	self:InitEmojiButton();
	self:InitVoiceButton();
	self:InitMenuButton();
	self:InitActivityButton();
	
	self:AddClickEvent(self.rewardBtn, function (go)  
		self:ToView(PanelConfig.PostView); 
	end);

	self:AddClickEvent(self.tempAlbumButton, function (go)
		self:ToView(PanelConfig.TempPersonalPicturePanel); 
	end);
	self:AddButtonEvent("CloseMore",nil,{hideClickSound = true})
	self:AddButtonEvent("CloseMap",nil,{hideClickSound = true})
	self:AddButtonEvent("BagButton",function () self:ToView(PanelConfig.Bag); end)

	self:AddOrRemoveGuideId(self.moreBtn, 102)
	self:AddOrRemoveGuideId(self.bagBtn, 103)

	self.tempBagButton = self:FindGO("TempBagButton");
	self.tempBagWarning = self:FindGO("Warning", self.tempBagButton);
	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PACK_TEMP, self.tempBagButton, 42)
	self:AddClickEvent(self.tempBagButton, function (go)
		self:ToView(PanelConfig.TempPackageView);
	end);

	local hkBtn = self:FindGO("HouseKeeperButton")
	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SERVANT_RECOMMNED, hkBtn, 42)
	local hkLabel = self:FindComponent("Label",UILabel,hkBtn)
	hkLabel.text = ZhString.MainviewMenu_HouseKeeper
	local data = FunctionUnLockFunc.Me():GetMenuDataByPanelID(1620, MenuUnlockType.View);
	if(data)then
		FunctionUnLockFunc.Me():RegisteEnterBtn(FunctionUnLockFunc.Me():GetMenuId(data), hkBtn)
	end
	self:AddButtonEvent("HouseKeeperButton",function ()
		local curImageId = ServicePlayerProxy.Instance:GetCurMapImageId() or 0;
		local isRaid = Game.MapManager:IsRaidMode() or curImageId > 0;
		if(isRaid)then
			MsgManager.ShowMsgByID(25417)
			return
		end
        local myServantid = Game.Myself.data.userdata:Get(UDEnum.SERVANTID) or 0
        if(myServantid ~= 0)then
			self:ToView(PanelConfig.ServantMainView); 
		else
			MsgManager.ConfirmMsgByID(25405,function ( )
				-- body
				FuncShortCutFunc.Me():CallByID(1005);
			end)
		end
	end)
	self:InitActivityBtn()
end

function MainViewMenuPage:InitActivityBtn()
	--同人
	self.TopRightFunc = self:FindGO("TopRightFunc");
	self.DoujinshiButton = self:FindGO("DoujinshiButton",self.TopRightFunc);
	self.ActivityNode = self:FindGO("ActivityNode",self.TopRightFunc);

	--todo xde
	local closeWhenNotClickUIComp = self.ActivityNode:GetComponent("CloseWhenNotClickUI")
	closeWhenNotClickUIComp.enabled = false

	if GameConfig.System.ShieldMaskDoujinshi==1 then
		self:Hide(self.DoujinshiButton)
		self:Show(self.ActivityNode)
		return
	else
		self:Hide(self.ActivityNode)
		self:Show(self.DoujinshiButton)
	end
	self.DoujinshiSprite_UISpirte = self:FindGO("Sprite",self.DoujinshiButton):GetComponent(UISprite);
	IconManager:SetUIIcon("Community", self.DoujinshiSprite_UISpirte)

	self.Label_UILabel = self:FindGO("Label",self.DoujinshiButton):GetComponent(UILabel);
	self.Label_UILabel.text = ZhString.MainviewMenu_ChuXinSheQu

	self.DoujinshiNode = self:FindGO("DoujinshiNode");
	self.DoujinshiNode.gameObject:SetActive(false)
	self:AddClickEvent(self.DoujinshiButton, function (go)  		
		if self.DoujinshiNode.gameObject.activeInHierarchy then
			self.DoujinshiNode.gameObject:SetActive(false)
		else
			self.DoujinshiNode.gameObject:SetActive(true)
            self:Hide(self.moreBord);
		end	
	end);

	-- 同人
	self.DoujinshiWorkBtnButton = self:FindGO("DoujinshiWorkBtnButton",self.DoujinshiNode);

	self.Label_UILabel = self:FindGO("Label",self.DoujinshiWorkBtnButton):GetComponent(UILabel);
	self.Label_UILabel.text = ZhString.MainviewMenu_TongRen
	self:AddClickEvent(self.DoujinshiWorkBtnButton, function (go)
		self.DoujinshiNode.gameObject:SetActive(false)
		if(ApplicationInfo.IsIOSVersionUnder8())then
			MsgManager.ShowMsgByID(25717);
			return;
		end
		local functionSdk = FunctionLogin.Me():getFunctionSdk()
		if functionSdk and functionSdk:getToken() then
			helplog("抓到token")
			helplog("functionSdk:getToken():"..functionSdk:getToken())
			GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.WebviewPanel, viewdata = {token = functionSdk:getToken()}})
		else
			helplog("没有抓到token")
			GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.WebviewPanel, viewdata = {token = nil}})
		end	
	end);
end

function MainViewMenuPage:InitMenuButton()
	self.menuCtl = UIGridListCtrl.new(self.moreGrid, MainViewButtonCell, "MainViewButtonCell");
	self.menuCtl:AddEventListener(MouseEvent.MouseClick, self.ClickButton, self);
	self.menuCtl:AddEventListener(MainViewButtonEvent.ResetPosition, self.ResetMenuButtonPosition, self);

	self:UpdateMenuDatas();
end

function MainViewMenuPage:InitEmojiButton()
	local emojiButton = self:FindGO("EmojiButton");
	FunctionUnLockFunc.Me():RegisteEnterBtnByPanelID(PanelConfig.ChatEmojiView.id, emojiButton)
	self:AddClickEvent(emojiButton, function ()
		if(not self.isEmojiShow)then
			self:ToView(PanelConfig.ChatEmojiView);
		else
			self:sendNotification(UIEvent.CloseUI, UIViewType.ChatLayer); 
		end
	end);
end

function MainViewMenuPage:InitVoiceButton()
	self.ButtonGrid = self:FindGO("ButtonGrid");
	self.ButtonGrid_UIGrid = self:FindGO("ButtonGrid"):GetComponent(UIGrid);

	self.TeamVoice = self:FindGO("TeamVoice",self.ButtonGrid);
	self.GuildVoice = self:FindGO("GuildVoice",self.ButtonGrid);
	self.TeamVoiceSprite_UISprite = self:FindGO("Sprite",self.TeamVoice):GetComponent(UISprite)
	self.GuildVoiceSprite_UISprite = self:FindGO("Sprite",self.GuildVoice):GetComponent(UISprite)

	if GameConfig.OpenVoice~=nil and GameConfig.OpenVoice == false then
		Debug.Log("-------------------实时语音不开放-------请找策划配置------------")
		self.TeamVoice.gameObject:SetActive(false)
		self.GuildVoice.gameObject:SetActive(false)
		do return end
	else
		Debug.Log("-------------------实时语音开放------")
	end	

	if TeamProxy.Instance:IHaveTeam() then
		Debug.Log("」』」我有队伍")
		self.TeamVoice.gameObject:SetActive(true)
	else
		Debug.Log("」』」我没有队伍")
		self.TeamVoice.gameObject:SetActive(false)
	end	

	if GuildProxy.Instance:IHaveGuild() then
		self.GuildVoice.gameObject:SetActive(true)
	else
		self.GuildVoice.gameObject:SetActive(false)
	end	

	if self.ButtonGrid_UIGrid then
		self.ButtonGrid_UIGrid:Reposition()
	end

	self.TeamVoice_VoiceOption = self:FindGO("VoiceOption",self.TeamVoice);
	self.GuildVoice_VoiceOption = self:FindGO("VoiceOption",self.GuildVoice);
	self.TeamVoice_VoiceOption_State_a = self:FindGO("State_a",self.TeamVoice_VoiceOption);
	self.TeamVoice_VoiceOption_State_b = self:FindGO("State_b",self.TeamVoice_VoiceOption);
	self.TeamVoice_VoiceOption_State_c = self:FindGO("State_c",self.TeamVoice_VoiceOption);
	self.TeamVoice_VoiceOption_State_d = self:FindGO("State_d",self.TeamVoice_VoiceOption);
	self.GuildVoice_VoiceOption_State_a = self:FindGO("State_a",self.GuildVoice_VoiceOption);
	self.GuildVoice_VoiceOption_State_b = self:FindGO("State_b",self.GuildVoice_VoiceOption);
	self.GuildVoice_VoiceOption_State_c = self:FindGO("State_c",self.GuildVoice_VoiceOption);
	self.GuildVoice_VoiceOption_State_d = self:FindGO("State_d",self.GuildVoice_VoiceOption);
	self.TeamVoiceSprite_UISprite.spriteName = "ui_microphone_a_JM"
	self.GuildVoiceSprite_UISprite.spriteName = "ui_microphone_a_JM"
	self:AddClickEvent(self.TeamVoice, function ()
		self.TeamVoice_VoiceOption.gameObject:SetActive(not self.TeamVoice_VoiceOption.gameObject.activeInHierarchy);
		GVoiceProxy.Instance:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)

	end);
	self:AddClickEvent(self.TeamVoice_VoiceOption_State_a, function ()
		GVoiceProxy.Instance:ChangeTeamVoiceState(StateOfVoiceFunctionButton.STATE_A)
		self.TeamVoice_VoiceOption.gameObject:SetActive(false);
		self.TeamVoiceSprite_UISprite.spriteName = "ui_microphone_a_JM"

		MsgManager.ShowMsgByID(25491)
	end);
	self:AddClickEvent(self.TeamVoice_VoiceOption_State_b, function ()
		GVoiceProxy.Instance:ChangeTeamVoiceState(StateOfVoiceFunctionButton.STATE_B)
		self.TeamVoice_VoiceOption.gameObject:SetActive(false);
		self.TeamVoiceSprite_UISprite.spriteName = "ui_microphone_b_JM"

		MsgManager.ShowMsgByID(25491)
	end);
	self:AddClickEvent(self.TeamVoice_VoiceOption_State_c, function ()
		GVoiceProxy.Instance:ChangeTeamVoiceState(StateOfVoiceFunctionButton.STATE_C)
		self.TeamVoice_VoiceOption.gameObject:SetActive(false);
		self.TeamVoiceSprite_UISprite.spriteName = "ui_microphone_c_JM"

		MsgManager.ShowMsgByID(25490)
	end);
	self:AddClickEvent(self.TeamVoice_VoiceOption_State_d, function ()
		self.TeamVoice_VoiceOption.gameObject:SetActive(false);
	end);
	self:AddClickEvent(self.GuildVoice, function ()
		self.GuildVoice_VoiceOption.gameObject:SetActive(not self.GuildVoice_VoiceOption.gameObject.activeInHierarchy);
		GVoiceProxy.Instance:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
	end);
	self:AddClickEvent(self.GuildVoice_VoiceOption_State_a, function ()
		GVoiceProxy.Instance:ChangeGuildVoiceState(StateOfVoiceFunctionButton.STATE_A)
		self.GuildVoice_VoiceOption.gameObject:SetActive(false);
		self.GuildVoiceSprite_UISprite.spriteName = "ui_microphone_a_JM"

		MsgManager.ShowMsgByID(25495)
	end);
	self:AddClickEvent(self.GuildVoice_VoiceOption_State_b, function ()
		GVoiceProxy.Instance:ChangeGuildVoiceState(StateOfVoiceFunctionButton.STATE_B)
		self.GuildVoice_VoiceOption.gameObject:SetActive(false);
		self.GuildVoiceSprite_UISprite.spriteName = "ui_microphone_b_JM"

		MsgManager.ShowMsgByID(25495)
	end);
	self:AddClickEvent(self.GuildVoice_VoiceOption_State_c, function ()
		GVoiceProxy.Instance:ChangeGuildVoiceState(StateOfVoiceFunctionButton.STATE_C)
		self.GuildVoice_VoiceOption.gameObject:SetActive(false);
		self.GuildVoiceSprite_UISprite.spriteName = "ui_microphone_c_JM"

		MsgManager.ShowMsgByID(25494)
	end);
	self:AddClickEvent(self.GuildVoice_VoiceOption_State_d, function ()
		self.TeamVoice_VoiceOption.gameObject:SetActive(false);
	end);
end


function MainViewMenuPage:InitActivityButton()
	self.activityCtl = UIGridListCtrl.new(self.moreGrid, MainViewButtonCell, "MainViewButtonCell");
	self.activityCtl:AddEventListener(MouseEvent.MouseClick, self.ClickButton, self);
	self.activityCtl:AddEventListener(MainViewButtonEvent.ResetPosition, self.ResetMenuButtonPosition, self);

	self:UpdateActivityDatas();
end

function MainViewMenuPage:UpdateMenuDatas()
	self.mainButtonDatas = {};
	for k,v in pairs(Table_MainViewButton)do
		local data = {};
		data.type = MainViewButtonType.Menu;
		data.staticData = v;
		table.insert(self.mainButtonDatas, data);
	end
	table.sort(self.mainButtonDatas, function (a,b)
		return a.staticData.id < b.staticData.id;
	end)
	self.menuCtl:ResetDatas(self.mainButtonDatas);

	local cells = self.menuCtl:GetCells();
	for i=1,#cells do
		local cdata = cells[i].data;
		if(cdata.type == MainViewButtonType.Menu)then
			local go = cells[i].gameObject;
			local data = cdata.staticData;
			if(data)then
				-- 注册红点
				if(data.redtiptype and #data.redtiptype>0)then
					self:RegisterRedTipCheckByIds(data.redtiptype, self.moreBtn, 42)
					self:RegisterRedTipCheckByIds(data.redtiptype, go, 42)
				end
				if(data.GroupID and #data.GroupID > 0)then
					for i=1,#data.GroupID do
						local groupId = data.GroupID[i];
						RedTipProxy.Instance:RegisterUIByGroupID(groupId ,self.moreBtn, 42);
						RedTipProxy.Instance:RegisterUIByGroupID(groupId ,go, 42);
					end
				end
				-- 注册功能开放按钮
				FunctionUnLockFunc.Me():RegisteEnterBtnByPanelID(data.panelid, go)

				local guideId = data.guideiconID
				if(guideId)then
					self:AddOrRemoveGuideId(go,guideId)
				end
			end
		end
	end

	self:ResetMenuButtonPosition();
end

function MainViewMenuPage:UpdateActivityDatas()
	self.activityDatas = {};
	for _, aData in pairs(Table_OperationActivity)do
		if(aData.Type == 1)then
			local data = {};
			data.type = MainViewButtonType.Activity;
			data.staticData = aData;
			table.insert(self.activityDatas, data);
		end
	end
	self.activityCtl:ResetDatas(self.activityDatas);

	self:ResetMenuButtonPosition();
end

function MainViewMenuPage:ClickButton(cellctl)
	local data = cellctl.data;
	if(data)then
		if(data.type == MainViewButtonType.Menu)then
			local sData = data.staticData;
			if(sData.panelid == PanelConfig.PhotographPanel.id)then
				-- 拍照
				if(self.isEmojiShow)then
					self.isEmojiShow = false;
					self:sendNotification(UIEvent.CloseUI, UIViewType.ChatLayer); 
				end
				self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid));
			elseif(sData.panelid == PanelConfig.CreateChatRoom.id)then
				local handed,handowner = Game.Myself:IsHandInHand();
				if(handed and not handowner)then
					MsgManager.ShowMsgByIDTable(824);
					return;
				end
				if Game.Myself:IsInBooth() then
					MsgManager.ShowMsgByID(25708)
					return
				end
				self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid));
			elseif sData.panelid == PanelConfig.PvpMainView.id then
				if PvpProxy.Instance:IsSelfInPvp() then
					MsgManager.ShowMsgByID(951)
				elseif PvpProxy.Instance:IsSelfInGuildBase() then
					MsgManager.ShowMsgByID(983)
				elseif Game.Myself:IsDead() then
					MsgManager.ShowMsgByID(2500)
				elseif Game.Myself:IsInBooth() then
					MsgManager.ShowMsgByID(25708)
				else
					self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid), {ButtonConfig = sData})
				end
			--todo xde add line
			elseif sData.panelid == PanelConfig.LinePanel.id then
				Application.OpenURL("https://line.me/R/ti/p/fbIXz8W-lH")
			else
				self:ToView(FunctionUnLockFunc.Me():GetPanelConfigById(sData.panelid), {ButtonConfig = sData});
			end

			self:Hide(self.moreBord);
		elseif(data.type == MainViewButtonType.Activity)then
			local sData = data.staticData;
			self:ToView(PanelConfig.TempActivityView, {Config = sData});
		end
	end
end

function MainViewMenuPage:ResetMenuButtonPosition()
	self.moreGrid.repositionNow = true;

	if self.ButtonGrid_UIGrid then
		self.ButtonGrid_UIGrid.repositionNow = true
	end	
end

function MainViewMenuPage:HandleUpdatetemScene()
	local bRet = AdventureDataProxy.Instance:HasTempSceneryExsit()
	if(bRet)then
		self:Show(self.tempAlbumButton)
	else
		self:Hide(self.tempAlbumButton)
	end
end

function MainViewMenuPage:UpdateRewardButton()
	local rewardList = PostProxy.Instance:GetPostList();
	self.rewardBtn:SetActive(#rewardList>0);
	self.topRFuncGrid2.repositionNow = true;
end

function MainViewMenuPage:UpdateBagNum()
	if(not self.bagNum)then
		self.bagNum = self:FindComponent("BagNum", UILabel, self.bagBtn);
	end

	local bagData = BagProxy.Instance.bagData;
	local bagItems = bagData:GetItems();
	local uplimit = bagData:GetUplimit();

	if(uplimit > 0 and #bagItems >= uplimit)then
		self.bagNum.gameObject:SetActive(true);
		self.bagNum.text = #bagItems.."/"..uplimit;
	else
		self.bagNum.gameObject:SetActive(false);
	end
end

function MainViewMenuPage:UpdateTempBagButton()
	local tempBagdatas = BagProxy.Instance.tempBagData:GetItems();
	local hasDelWarnning = false;
	for i=1,#tempBagdatas do
		if( tempBagdatas[i]:GetDelWarningState() )then
			hasDelWarnning = true;
			break;
		end
	end
	self.tempBagWarning:SetActive(hasDelWarnning);
	self.tempBagButton:SetActive(#tempBagdatas>0);
	-- self.tempBagButton:SetActive(true);
end

function MainViewMenuPage:HandleTowerSummaryCmd(note)
	if EndlessTowerProxy.Instance:IsTeamMembersFighting() then
		MsgManager.ConfirmMsgByID(1312,function ()
			ServiceInfiniteTowerProxy.Instance:CallEnterTower(0,Game.Myself.data.id)
		end , nil , nil)
	else
		self:ToView(PanelConfig.EndlessTower)
	end
end

function MainViewMenuPage:HandleEnterTower(note)
	ServiceInfiniteTowerProxy.Instance:CallEnterTower(note.body.layer,Game.Myself.data.id)
end

function MainViewMenuPage:HandleTowerInfo(note)
	self:ToView(PanelConfig.EndlessTower)
end

function MainViewMenuPage:ToView(viewconfig,viewdata)
	if(viewconfig and viewconfig.id == 83)then
		PersonalPicturePanel.ViewType = UIViewType.NormalLayer
	end
	self:sendNotification(UIEvent.JumpPanel,{view = viewconfig, viewdata = viewdata});
end

function MainViewMenuPage:MapViewInterests()
	self:AddListenEvt(MainViewEvent.EmojiViewShow, self.HandleEmojiShowSync);
	self:AddListenEvt(ServiceEvent.InfiniteTowerTeamTowerSummaryCmd,self.HandleTowerSummaryCmd);
	
	self:AddListenEvt(MyselfEvent.DeathStatus,self.HandleDeathBegin);
	self:AddListenEvt(MyselfEvent.ReliveStatus,self.HandleReliveStatus);
	
	self:AddListenEvt(ServiceEvent.InfiniteTowerEnterTower,self.HandleEnterTower);
	self:AddListenEvt(ServiceEvent.InfiniteTowerTowerInfoCmd,self.HandleTowerInfo);

	self:AddListenEvt(ServiceEvent.SessionMailQueryAllMail, self.UpdateRewardButton);
	self:AddListenEvt(ServiceEvent.SessionMailMailUpdate, self.UpdateRewardButton);

	self:AddListenEvt(ServiceEvent.SceneManualUpdateSolvedPhotoManualCmd,self.HandleUpdatetemScene);


	self:AddListenEvt(UIMenuEvent.UnRegisitButton, self.UnLockMenuButton);
	self:AddListenEvt(UIMenuEvent.UnRegisitButton, self.UnLockMenuButton);

	self:AddListenEvt(ItemEvent.TempBagUpdate, self.UpdateTempBagButton);
	self:AddListenEvt(TempItemEvent.TempWarnning, self.UpdateTempBagButton);
	
	self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateBagNum);
	self:AddListenEvt(ServiceEvent.ItemPackSlotNtfItemCmd, self.UpdateBagNum);

	self:AddListenEvt(MainViewEvent.MenuActivityOpen, self.HandleUpdateActivity);
	self:AddListenEvt(MainViewEvent.MenuActivityClose, self.HandleUpdateActivity);

	self:AddListenEvt(ServiceUserProxy.RecvLogin, self.HandleUpdateMatchInfo);
	self:AddListenEvt(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, self.HandleUpdateMatchInfo);
	self:AddListenEvt(MainViewEvent.UpdateMatchBtn, self.HandleUpdateMatchInfo)
	self:AddListenEvt(PVPEvent.PVP_MVPFightLaunch, self.CloseMatchInfo)
	self:AddListenEvt(LoadSceneEvent.FinishLoad, self.HandleUpdateMatchInfo)
	self:AddListenEvt(PVPEvent.PVP_MVPFightShutDown,self.HandleUpdateMatchInfo)

	self:AddListenEvt(LoadSceneEvent.FinishLoad, self.HandleMapLoaded);

	self:AddListenEvt(ServiceEvent.GuildCmdGvgOpenFireGuildCmd, self.HandleGvgOpenFireGuildCmd);

	self:AddListenEvt(GVGEvent.GVG_FinalFightLaunch, self.UpdateGvgOpenFireButton);
	self:AddListenEvt(GVGEvent.GVG_FinalFightShutDown, self.UpdateGvgOpenFireButton);

	self:AddListenEvt(MainViewEvent.UpdateTutorMatchBtn,self.UpdateTutorMatchInfo)
	self:AddListenEvt(LoadSceneEvent.FinishLoad, self.UpdateTutorMatchInfo);

	self:AddListenEvt(ServiceEvent.ChatCmdQueryRealtimeVoiceIDCmd, self.RecvChatCmdQueryRealtimeVoiceIDCmd)
	self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.RecvSessionTeamExitTeam)
	self:AddListenEvt(ServiceEvent.GuildCmdExitGuildGuildCmd , self.RecvGuildCmdExitGuildGuildCmd)
end

function MainViewMenuPage:RecvGuildCmdExitGuildGuildCmd(data)
	self.GuildVoice.gameObject:SetActive(false)
end	

function MainViewMenuPage:RecvSessionTeamExitTeam(data)
	self.TeamVoice.gameObject:SetActive(false)
end	

function MainViewMenuPage:RecvChatCmdQueryRealtimeVoiceIDCmd(data)
	if GameConfig.OpenVoice~=nil and GameConfig.OpenVoice == false then
		Debug.Log("-------------------实时语音不开放-------请找策划配置------------")
		if self.TeamVoice~=nil and self.GuildVoice~=nil then
			self.TeamVoice.gameObject:SetActive(false)
			self.GuildVoice.gameObject:SetActive(false)
		end	
		do return end
	else
		Debug.Log("-------------------实时语音开放------")
	end	

	self.curChannel = data.body.channel
	self.roomid = data.body.id
	if self.curChannel ==nil then

	elseif self.curChannel ==ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index then
		self.TeamVoice.gameObject:SetActive(true)
	elseif self.curChannel ==ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index then	
		self.GuildVoice.gameObject:SetActive(true)
	end	

	if self.ButtonGrid_UIGrid then
		self.ButtonGrid_UIGrid:Reposition()
		self.ButtonGrid_UIGrid.repositionNow = true
	else
		
	end	
end


function MainViewMenuPage:HandleMapLoaded(note)
	if(self.matchInfo_cancelBord == nil)then
		return;
	end
	
	self.matchInfo_cancelBord:SetActive(false);
end

function MainViewMenuPage:HandleGvgOpenFireGuildCmd(note)
	self:UpdateGvgOpenFireButton();	
end

function MainViewMenuPage:UpdateGvgOpenFireButton()
	-- gvg决战副本中屏蔽gvg战况按钮
	if(Game.MapManager:IsGvgMode_Droiyan())then
		self.glandStatusButton:SetActive(false);
		self.topRFuncGrid2.repositionNow = true;
		return;
	end

	local b = GvgProxy.Instance:GetGvgOpenFireState();
	self.glandStatusButton:SetActive(b == true);
	self.topRFuncGrid2.repositionNow = true;
end


-- MatchInfo Begin
local tempV3 = LuaVector3();
function MainViewMenuPage:InitMatchInfo()
	if(self.matchInfoButton == nil)then
		self.matchInfoButton = self:FindGO("MatchInfoButton");

		self.matchInfoIcon = self:FindComponent("Sprite", UISprite, self.matchInfoButton);
		self.inMatchLabel = self:FindGO("Label",self.matchInfoButton):GetComponent(UILabel)

		self.matchInfo_cancelBord = self:FindGO("CancelBord");

		self.matchInfo_cancelBord_Bg = self:FindComponent("Bg", UISprite, self.matchInfo_cancelBord);
		self.matchInfo_cancelBord = self:FindGO("CancelBord");
		self:AddClickEvent(self.matchInfoButton, function ()
			local etype, matchStatus = PvpProxy.Instance:GetNowMatchInfo()
			local isMatching = nil
			local isfighting = nil
			if matchStatus then
				isMatching =  matchStatus.ismatch
				isfighting = matchStatus.isfighting
				redlog("matchStatus",matchStatus.ismatch,matchStatus.isfighting)
			else
				redlog("matchStatus nil")
			end
			if isMatching then
				tempV3:Set(LuaGameObject.GetPosition(self.matchInfoButton.transform))
				self.matchInfo_cancelBord.transform.position = tempV3;
				tempV3:Set(LuaGameObject.GetLocalPosition(self.matchInfo_cancelBord.transform));
				tempV3:Set(tempV3[1], tempV3[2]-115, tempV3[3]);
				self.matchInfo_cancelBord.transform.localPosition = tempV3;

				self.matchInfo_cancelBord:SetActive(true);
				self.inMatchLabel.gameObject:SetActive(true)
				self.inMatchLabel.text = ZhString.MVPMatch_InMatch
			elseif isfighting then
				ServiceMatchCCmdProxy.Instance:CallJoinFightingCCmd(PvpProxy.Type.MvpFight)
				self.inMatchLabel.gameObject:SetActive(true)
				self.inMatchLabel.text = ZhString.MVPMatch_JoinTeam
			else
				self.matchInfo_cancelBord:SetActive(false)
				self.inMatchLabel.gameObject:SetActive(false)
				GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.MvpMatchView})
			end
		end);

		self.matchInfo_cancelButton = self:FindGO("CancelMatchButton", self.matchInfo_cancelBord);
		self:AddClickEvent(self.matchInfo_cancelButton, function (go)
			self:ClickCancelMatch();
		end);

		self.matchInfo_gotoButton = self:FindGO("GotoButton", self.matchInfo_cancelBord);
		self:AddClickEvent(self.matchInfo_gotoButton, function (go)
			self:ClickMatchGotoButton();
		end);

	end
end

local Match_CancelMsgId_Map = 
{
	[PvpProxy.Type.PoringFight] = 3610,
	[PvpProxy.Type.MvpFight] = 7311,
}

function MainViewMenuPage:ClickCancelMatch()
	if(self.matchType == nil)then
		return;
	end

	local msgId = Match_CancelMsgId_Map[ self.matchType ];
	if(msgId == nil)then
		return;
	end

	MsgManager.ConfirmMsgByID(msgId, function ()
		ServiceMatchCCmdProxy.Instance:CallLeaveRoomCCmd(self.matchType);
	end, nil, nil)
	self.matchInfo_cancelBord:SetActive(false);
end
function MainViewMenuPage:ClickMatchGotoButton()
	local actData = FunctionActivity.Me():GetActivityData( GameConfig.PoliFire.PoringFight_ActivityId or 111 );
	if(actData)then
		FuncShortCutFunc.Me():CallByID(actData.traceId);
	end
	self.matchInfo_cancelBord:SetActive(false);
end
function MainViewMenuPage:HandleUpdateMatchInfo(note)
	self:UpdateMatchInfo();
end

function MainViewMenuPage:CloseMatchInfo()
	self.matchInfoButton:SetActive(false)
end

local MatchInfoSprite_Map = 
{
	[PvpProxy.Type.PoringFight] = "main_icon_chaos",
	[PvpProxy.Type.MvpFight] = "main_icon_mvp2",
}
function MainViewMenuPage:UpdateMatchInfo(activityType)
	if Game.MapManager:IsPVPMode_MvpFight() then
		self.matchInfoButton:SetActive(false)
		self.topRFuncGrid2:Reposition()
		return
	end
	local etype, matchStatus = PvpProxy.Instance:GetNowMatchInfo();
	local active = nil
	local isfighting = nil
	if matchStatus then
		active =  matchStatus.ismatch
		isfighting = matchStatus.isfighting		
		redlog("matchStatus",matchStatus.ismatch,matchStatus.isfighting)
	else
		redlog("matchStatus nil")
	end

	self.matchType = etype;
	self:InitMatchInfo();
	self.matchInfoIcon.spriteName = MatchInfoSprite_Map[ etype ] or ""

	local actData = FunctionActivity.Me():GetActivityData(GameConfig.MvpBattle.ActivityID)
	if actData then
		self.matchInfoButton:SetActive(true);
		self.matchInfoIcon.spriteName = "main_icon_mvp2"
	elseif activityType == GameConfig.MvpBattle.ActivityID then
		self.matchInfoButton:SetActive(false)
	else
		self.matchInfoButton:SetActive(active == true)
	end
	self.inMatchLabel.gameObject:SetActive(active == true or isfighting == true)
	if active then
		self.inMatchLabel.text = ZhString.MVPMatch_InMatch
	elseif isfighting then
		self.inMatchLabel.text = ZhString.MVPMatch_JoinTeam
	end
	if(etype == PvpProxy.Type.MvpFight)then
		self.matchInfo_gotoButton:SetActive(false);
		self.matchInfo_cancelBord_Bg.height = 106;
	else
		self.matchInfo_gotoButton:SetActive(true);
		self.matchInfo_cancelBord_Bg.height = 166;
	end

	self.topRFuncGrid2:Reposition();
end
-- MatchInfo End


function MainViewMenuPage:HandleUpdateActivity(note)
	local activityType = note.body;
	if(not activityType)then
		return;
	end

	local cells = self.activityCtl:GetCells();
	for i=1,#cells do
		local data = cells[i].data;
		if(data.type == MainViewButtonType.Activity and 
			data.staticData.id == activityType)then
			cells[i]:UpdateActivityState();
			break;
		end
	end
	self:ResetMenuButtonPosition();
end

function MainViewMenuPage:GetSkillButton()
	if(not self.skillButton)then
		local buttons = self.activityCtl:GetCells();
		for i=1,#buttons do
			local buttonData = buttons[i].data;
			if(buttonData.panelid == PanelConfig.CharactorProfessSkill.id)then
				self.skillButton = buttons[i].gameObject;
			end
		end
	end
	return self.skillButton;
end

function MainViewMenuPage:HandleDeathBegin(note)
	self:SetTextureGrey(self.bagBtn);
	self.bagBtn:GetComponent(BoxCollider).enabled = false;

	local skillButton = self:GetSkillButton();
	if(skillButton)then
		self:SetTextureGrey(skillButton);
		skillButton:GetComponent(BoxCollider).enabled = false;
	end
end

function MainViewMenuPage:HandleReliveStatus(note)
	self:SetTextureColor(self.bagBtn, Color(1,1,1), true);
	self.bagBtn:GetComponent(BoxCollider).enabled = true;
	self:FindComponent("Label", UILabel, self.bagBtn).effectColor = Color(9/255,27/255,90/255);

	local skillButton = self:GetSkillButton();
	if(skillButton)then
		self:SetTextureColor(skillButton, Color(1,1,1), true);
		skillButton:GetComponent(BoxCollider).enabled = true;
		self:FindComponent("Label", UILabel, skillButton).effectColor = Color(9/255,27/255,90/255);
	end
end

function MainViewMenuPage:HandleEmojiShowSync(note)
	self.isEmojiShow = note.body;
end

function MainViewMenuPage:UnLockMenuButton(id)
	self.moreGrid.repositionNow = true;
	self.topRFuncGrid.repositionNow = true;
end

function MainViewMenuPage:OnEnter()
	MainViewMenuPage.super.OnEnter(self);
	self:UpdateRewardButton();
	self:UpdateTempBagButton();
	self:UpdateBagNum();
	self:RegisterPetAdvRedTip()
	self:HandleUpdatetemScene()
	
	-- 上线更新波利匹配信息
	self:UpdateMatchInfo();
	self:UpdateGvgOpenFireButton();
end

function MainViewMenuPage:RegisterPetAdvRedTip()
	self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PET_ADVENTURE,self.bagBtn,42)
end

function MainViewMenuPage:OnExit()
	MainViewMenuPage.super.OnExit(self);
end

function MainViewMenuPage:UpdateTutorMatchInfo()
	if not self.tutorMatchInfoBtn then
		self.tutorMatchInfoBtn = self:FindGO("TutorMatchInfoBtn")
	end
	if not self.tutorMatchInfoBtn then
		return
	end
	local status = TutorProxy.Instance:GetTutorMatStatus()
	if status == TutorProxy.TutorMatchStatus.Start then
		self.tutorMatchInfoBtn:SetActive(true)
	else
		self.tutorMatchInfoBtn:SetActive(false)
	end
	self.topRFuncGrid2.repositionNow = true

	self:AddClickEvent(self.tutorMatchInfoBtn, function ()
		if TutorProxy.Instance:CanAsStudent() then
			GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TutorMatchView, viewdata = TutorType.Tutor})
		elseif TutorProxy.Instance:CanAsTutor() then
			GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.TutorMatchView, viewdata = TutorType.Student})
		end
		end)
end