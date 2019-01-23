StartGamePanel = class("StartGamePanel",BaseView)
autoImport("NetPrefix")
autoImport('CSharpObjectForLogin')
autoImport('UIRoleSelect')
autoImport('LoginRoleSelector')
autoImport('FunctionLoginAnnounce')
autoImport('MonthlyVIPTip')
StartGamePanel.ViewType = UIViewType.MainLayer

PlayerPrefsMYServer = "PlayerPrefsMYServer";
PlayerPrefsQuickAcc = "PlayerPrefsQuickAcc";
PlayerPrefsDefaultName = "PlayerPrefsDefaultName";
PlayerPrefsAgreement = "PlayerPrefsAgreement";

-- StartGamePanel.LogoTextureName = "login_bg_logo";
local tempVector3 = LuaVector3.zero
StartGamePanel.BgTextureName = "login_bg_bottom";

function StartGamePanel:Init()
	self:initView();	
	self:AddEvt();
	self:MapSwitchHandler();
end

function StartGamePanel:OnEnter(  )
	-- body
	self:initData()
	self:InitShow();
	self:ChangeBtnStToNormal()
	self:updateAgreementPos()
end

function StartGamePanel:initData(  )
	self:initLoginView()
	self:UpdateServerList()
	self:SetVersion()
	self:initAgreement()
end

function StartGamePanel:initAgreement()
	if(PlayerPrefs.HasKey(PlayerPrefsAgreement)) then
		local value = PlayerPrefs.GetInt(PlayerPrefsAgreement,0) == 1
		self.checkBox.value = value
	end
end

function StartGamePanel:requestAnnouncement()
	if(self.BlockRequestAnnounceTwId)then
		LeanTween.cancel(self.gameObject,self.BlockRequestAnnounceTwId)
		self.BlockRequestAnnounceTwId = nil
	end
	local ret = LeanTween.delayedCall(self.gameObject,0.05,function (  )
		self.BlockRequestAnnounceTwId = nil
		FunctionLoginAnnounce.Me():requestAnnouncement()
	end)
	self.BlockRequestAnnounceTwId = ret.uniqueId
end

function StartGamePanel:initLoginView()
	-- body
	local SDKEnable = FunctionLogin.Me():getSdkEnable()
	if(SDKEnable)then
		self:Hide(self.accInput.gameObject)
		self:Hide(self.quickEnterBtn.gameObject)
		self:HideZoneBTN()
		self:Hide(self.deleteBtn.gameObject)
		local pos = self.clickBtn.transform.localPosition
		local _,y,_ = LuaGameObject.GetLocalPosition(self.clickBtn.transform)
		tempVector3:Set(0,y,0);
		self.clickBtn.transform.localPosition = tempVector3
		self:Show(self.goPlatformEntrance)
		-- todo xde 移除依赖version的开屏公告 兼容v16 以及之前的
		if BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V16) then
			self:requestAnnouncement()
		end
		-- FunctionLogin.Me():launchAndLoginSdk(  )
--		self:Show(self.goPlatformEntrance)
		-- self:requestAnnouncement()
		--todo xde 如果需要SDK 要登出
		if(PlayerPrefs.GetInt("NeedSDKLogout") == 1) then
			local txwysdkApplicationInfo = AppBundleConfig.GetTXWYSDKInfo()
			if txwysdkApplicationInfo ~=nil then
				local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
				local lang = AppBundleConfig.GetSDKLang()
				helplog('txwysdkApplicationInfo.APP_ID = ', txwysdkApplicationInfo.APP_ID)
				helplog('txwysdkApplicationInfo.LANG = ', lang)
				overseasManager:InitTXWYSDK(
					txwysdkApplicationInfo.APP_ID,
					txwysdkApplicationInfo.APP_KEY,
					txwysdkApplicationInfo.FUID,
					lang)
				overseasManager:SignOut()
			end
		end
		PlayerPrefs.DeleteKey("NeedSDKLogout")

		FunctionLogin.Me():launchAndLoginSdk()
	else
		self:ShowZoneBTN()
		self:Show(self.accInput.gameObject)
		if(PlayerPrefs.HasKey(PlayerPrefsMYServer)) then
			self.serverid = PlayerPrefs.GetInt(PlayerPrefsMYServer)
			self.serverData = Table_ServerList[self.serverid]
		end
		if(self.serverid and not self.serverData)then
			self.serverid = nil
		end
--		self:Show(self.deleteBtn.gameObject)
	--  todo xde editor show entrance
		self:Show(self.goPlatformEntrance)
	end
end

function StartGamePanel:ShowZoneBTN()
	local transZoneBTN = self.zoneBtn.transform
	local localPos = transZoneBTN.localPosition
	localPos.y = -75.3
	transZoneBTN.localPosition = localPos
	self:Show(self.zoneBtn.gameObject)
end

function StartGamePanel:HideZoneBTN()
	if(EnvChannel.Channel.Name == EnvChannel.ChannelConfig.Release.Name)then
		self:Hide(self.zoneBtn.gameObject)
	end
end

function StartGamePanel:initView()
	self.container = self:FindComponent("Container",UIWidget)
	self.accInput = self:FindComponent("AccountInput",UIInput)
	local label = self:FindComponent("Label",UILabel,self.accInput.gameObject)

	-- EventDelegate.Set(self.accInput.onChange, function ( result)
	-- 	-- body
	-- 	-- helplog(result)
	-- 	helplog(self.accInput.value)
	-- 	-- return 5
	-- 	label.text = "****"
	-- end)


	self.clickBtn = self:FindGO("StartBtn")
	self.StartBtnCollider = self:FindComponent("StartBtnCollider",BoxCollider)
	self.zoneBtn = self:FindComponent("ZoneBtn", UIButton);

	self.serverLab = self:FindComponent("serviceLabel", UILabel);
	self.serverLab.text = ZhString.StartGamePanel_ChooseServerPrompt

	self.deleteBtn = self:FindComponent("DeleteRoleBtn", UIButton);
	self.quickEnterBtn = self:FindComponent("quickEnterBtn", UIButton);
	self.versionLabel = self:FindComponent("VersionLabel",UILabel)
	self.isDeleteRole = false
	self.EnableStartBtn = true
	self.ErrorOrSusBack = false
	self.BlockRequest = false
	self.EnableStartBtnTwId = nil
	self.BlockRequestTwId = nil
	self.BlockRequestAnnounceTwId = nil
	-- self.logoTexture = self:FindComponent("Logo", UITexture);
	self.bgTexture = self:FindComponent("BgTexture", UITexture);

	self.selectTipLabel = self:FindComponent("selectTipLabel",UILabel)
	self.selectTipLabel.text = ZhString.StartGamePanel_SelectTipLabel

	local ServerConnectingLabel = self:FindComponent("ServerConnectingLabel",UILabel)
	ServerConnectingLabel.text = ZhString.Login_ConnectingServer

	self.ServerConnecting = self:FindGO("ServerConnecting")
	self.cancelConnBtn = self:FindGO("cancelConnBtn")

	self.goPlatformEntrance = self:FindGO("PlatformEntrance")
	self.waitingView = self:FindGO("WaitingView")
	local WaitingLabel = self:FindComponent("WaitingLabel",UILabel)
	WaitingLabel.text = ZhString.StartGamePanel_WaitingLabel
	local WaitingViewSp = self:FindComponent("WaitingViewSp",UISprite)
	WaitingViewSp:UpdateAnchors()
	local WaitingContainer = self:FindGO("WaitingContainer")
	local bound = NGUIMath.CalculateRelativeWidgetBounds(WaitingContainer.transform,true)
	local sizeX = bound.size.x
	tempVector3:Set(sizeX/2,0,0)
	WaitingContainer.transform.localPosition = tempVector3
	-- PictureManager.Instance:SetUI(StartGamePanel.LogoTextureName, self.logoTexture);
	-- self.logoTexture:MakePixelPerfect();
	PictureManager.Instance:SetUI(StartGamePanel.BgTextureName, self.bgTexture);
	self.bgTexture:MakePixelPerfect();
	PictureManager.ReFitiPhoneXScreenHeight(self.bgTexture)
	self:HideConnecting()
	self:Hide(self.cancelConnBtn)

	self.startEffectPath = ResourcePathHelper.EffectUI(EffectMap.UI.GameStart)
	local obj = Game.AssetManager_UI:CreateAsset(self.startEffectPath,self.clickBtn)
	if(obj and self:FindComponents(Animator,obj))then
		tempVector3:Set(0,0,0)
		obj.transform.localPosition = tempVector3
		tempVector3:Set(1,1,1)
		obj.transform.localScale = tempVector3
		local anims = self:FindComponents(Animator,obj)
		self.anim = anims[1]
	end

	local agreetmentLabel = self:FindComponent("agreetmentLabel",UILabel)
	agreetmentLabel.text = ZhString.StartGamePanel_AgreetmentLabel
	self:AddClickEvent(agreetmentLabel.gameObject,function (  )
		-- body
		self:ShowAgreement()
	end)
	self.checkBox = self:FindComponent("checkBox",UIToggle)
	local copyrightLabel = self:FindComponent("copyrightLabel",UILabel)
	copyrightLabel.text = ZhString.StartGamePanel_CopyRightTips
	EventDelegate.Set(self.checkBox.onChange,function ()
    	self:CheckBoxChange()
    end)


	--todo xde 去除不必要的显示
	local copyrightCtObj = self:FindGO("copyrightCt")
	copyrightCtObj:SetActive(false)
	agreetmentLabel.gameObject:SetActive(false)
	self.checkBox.gameObject:SetActive(false)
		-- self:InitializeAnnouncement()
	-- self:HideAnnouncement()
end

function StartGamePanel:updateAgreementPos()
	local agreetmentCt = self:FindGO("labelCt")
	local bound = NGUIMath.CalculateRelativeWidgetBounds(agreetmentCt.transform,true)
	local x,y,z = LuaGameObject.GetLocalPosition(agreetmentCt.transform)
	local posX = bound.center.x
	tempVector3:Set(0,y,z);
	agreetmentCt.transform.localPosition = tempVector3
end

function StartGamePanel:ShowAgreement()
	GameFacade.Instance:sendNotification(UIEvent.ShowUI,{viewname = "AgreementPanel"})
end

function StartGamePanel:CheckBoxChange()
	local value = self.checkBox.value
	PlayerPrefs.SetInt(PlayerPrefsAgreement,value and 1 or 0)
end

function StartGamePanel:OnExit()
	-- PictureManager.Instance:UnLoadUI(StartGamePanel.LogoTextureName,self.logoTexture);
	PictureManager.Instance:UnLoadUI(StartGamePanel.BgTextureName,self.bgTexture);
	StartGamePanel.super.OnExit(self);
	if(self.cancelLoginTipId)then
		LeanTween.cancel(self.gameObject,self.cancelLoginTipId)
	else
		LeanTween.cancel(self.gameObject)
	end
end

function StartGamePanel:SetVersion()
	local clientVersion = Application.version .. "@" .. tostring(CompatibilityVersion.version)
	local resVersion = VersionUpdateManager.CurrentVersion
	if(resVersion==nil) then resVersion = "Unknown" end
	self.versionLabel.text = string.format(ZhString.StartGamePanel_Version,clientVersion,resVersion)
	----[[ todo xde 使用 oversea 自己的 versioncode
	status, result = pcall(function()
		-- body
		self.versionLabel.text = string.format(ZhString.StartGamePanel_Version,Application.version .. "@".. CompatibilityVersion.overseaVersion,resVersion)
	end)
	xdlog(status, result)
	--]]
end

function StartGamePanel:AddEvt()
	self:AddClickEvent(self.StartBtnCollider.gameObject,function(go)
--	  	local value = self.checkBox.value
--	  	if(value)then
--			self:CallServer();
--		else
--			MsgManager.ShowMsgByIDTable(114)
--		end
	--todo xde force login
		self:CallServer();
	end, {hideClickSound = true})
		
	self:AddClickEvent(self.quickEnterBtn.gameObject,function (go)
		local acc = self:GetQuickAcc();
		go:GetComponent(UIButton).isEnabled = not self:CallServer(acc, nil);
	end)

	self:AddClickEvent(self.deleteBtn.gameObject,function (go)
		go:GetComponent(UIButton).isEnabled = not self:CallServer(nil, true);
	end)

	self:AddClickEvent(self.zoneBtn.gameObject ,function(go)
		self:sendNotification(UIEvent.ShowUI,{viewname = "SelectServerPanel",index = self.serverid})
	end)
	self:AddButtonEvent("cancelConnBtn" ,function(go)
		-- self:Hide(self.ServerConnecting)
		FunctionLogin.Me():stopTryReconnect()
	end)

	self:AddClickEvent(self.goPlatformEntrance, function (go)
		--todo xde editor show plat
		local SDKEnable = FunctionLogin.Me():getSdkEnable()
		if(SDKEnable) then
			local isLogined = FunctionLogin.Me():isLogined()
			if(isLogined)then
				local runtimePlatform = ApplicationInfo.GetRunPlatform()
				if(FunctionLogin.Me():getSdkType()  == FunctionSDK.E_SDKType.TXWY)then
					self:ShowTXWYPlatform()
				elseif runtimePlatform == RuntimePlatform.Android then
					if(not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V13)) then
						LogUtility.Info("android StartGamePanel:FunctionXDSDK()  OpenUserCenter")
						-- todo xde cancel android xdsdk
						--					FunctionXDSDK.Ins:OpenUserCenter()
						return
					end
				end
				-- todo xde cancel android xdsdk
				--			FunctionSDK.Instance:EnterPlatform()
			else
				if(not self.BlockRequest)then
					self:StartLogin()
					FunctionLogin.Me():startGameLogin(self.serverData)
				end
			end
		else
			self:ShowTXWYPlatform()
		end
	end)
end

function StartGamePanel:ShowTXWYPlatform()
	self:sendNotification(UIEvent.JumpPanel,{view = PanelConfig.TXWYPlatPanel});
end

function StartGamePanel:CallServer(acc, deleteRole)

	local callSuc = false;
	if(acc)then
		self.accInput.value = acc;
	else
		acc = self.accInput.value;
	end
	if(acc)then
		self.accInput:SaveValue();
	end

	local SDKEnable = FunctionLogin.Me():getSdkEnable()
	if(not SDKEnable)then


		if(ApplicationInfo.GetRunPlatform() == RuntimePlatform.Android) then
			if FunctionSDK.Instance.IsInitialized == false then
				Debug.Log("初始化SDK 只为android 分享")
				local xdsdkApplicationInfo = AppBundleConfig.GetXDSDKInfo()
				FunctionSDK.Instance:XDSDKInitialize(
					xdsdkApplicationInfo.APP_ID,
					xdsdkApplicationInfo.APP_SECRET,
					xdsdkApplicationInfo.PRIVATE_SECRET,
					xdsdkApplicationInfo.ORIENTATION,
					function (sucMsg )
						-- body
						FunctionSDK.Instance.IsInitialized = true

					end,function ( failMsg )
						-- body
						FunctionSDK.Instance.IsInitialized = false

					end)
			end
		end

		if(self.serverData)then
			PlayerPrefs.SetInt(PlayerPrefsMYServer,self.serverid or 0)
			if(acc and acc~="")then
				if(string.sub(acc, 1, 1)=="-")then
					acc = string.sub(acc, 2,-1);
				end
				if(tonumber(acc)>100)then
					PlayerPrefs.SetString(PlayerPrefsDefaultName, acc);				
					self.isDeleteRole = deleteRole == true;
					self:StartLogin()
					self:ChangeBtnStToClicked()
					FunctionLogin.Me():startGameLogin(self.serverData,acc,function ( )
						-- body
						FunctionLogin.Me():LoginUserCmd()
					end)
				else
					self:ErrorMsg(ZhString.StartGamePanel_InputErrorPrompt)
				end
			else
				self:ErrorMsg(ZhString.StartGamePanel_InputPrompt)
			end
		else
			self:ErrorMsg(ZhString.StartGamePanel_ChooseServerPrompt)
		end
	else
		local serverDatas = FunctionLogin.Me():getServerDatas()
		local isLogined = FunctionLogin.Me():isLogined(  )
		if serverDatas and isLogined and not self.serverData then
			self:ErrorMsg(ZhString.StartGamePanel_ChooseServerPrompt)
		else
			if(not self.BlockRequest)then
				self:StartLogin()
				self:ChangeBtnStToClicked()
				self:delayEnableStartBtn()
				FunctionLogin.Me():startGameLogin(self.serverData)
			end			
		end
	end
end

function StartGamePanel:ErrorMsg(msg)
	MsgManager.FloatMsgTableParam(nil, msg);	
end

function StartGamePanel:StartReconnect(  )
	-- body
	self:Show(self.ServerConnecting)
end

function StartGamePanel:StopReconnect(  )
	-- body
	self:HideConnecting()
end

function StartGamePanel:HideConnecting(  )
	-- body
	self:Hide(self.ServerConnecting)
end

function StartGamePanel:GetQuickAcc()
	local quickacc = 0;
	if(PlayerPrefs.HasKey(PlayerPrefsQuickAcc)) then
		quickacc = PlayerPrefs.GetInt(PlayerPrefsQuickAcc);
	end
	if(not quickacc or quickacc<100)then
		quickacc = GameObjectUtil.Instance:ToHashCode(SystemInfo.deviceUniqueIdentifier);
		quickacc = math.abs(quickacc);
		while(quickacc<100)do
			quickacc = quickacc + 100;
		end
		PlayerPrefs.SetInt(PlayerPrefsQuickAcc, quickacc);
	end
	return string.sub("-"..quickacc, 1, 10);
end

function StartGamePanel:InitShow()
	self:UpdateServerShow();
end

function StartGamePanel:UpdateServerShow()

	if(self.serverData)then
		self.serverLab.text = self.serverData.name;
		self.serverLab.color = Color(1,1,1);
	else
		self.serverLab.text = ZhString.StartGamePanel_NoChooseServer;
		self.serverLab.color = Color(157/255,157/255,157/255);
	end
end

function StartGamePanel:MapSwitchHandler()
	self:AddListenEvt(ServiceEvent.ChooseServer, self.HandlerSelectServer);
	self:AddListenEvt(ServiceEvent.ConnSuccess, self.HandlerConnnection);
	self:AddListenEvt(ServiceEvent.UserRecvRoleInfo, self.HandlerRecvRoleInfo);
	self:AddListenEvt(ServiceEvent.PlayerMapChange, self.EnterInGameEvt);
	self:AddListenEvt(LoadScene.LoadSceneLoaded, self.CloseSelf);
	self:AddListenEvt(ServiceEvent.Error, self.HandlerSError);
	self:AddListenEvt(NewLoginEvent.LoginFailure, self.HandlerSError);
	self:AddListenEvt(NewLoginEvent.StartLogin, self.StartLogin);
	self:AddListenEvt(NewLoginEvent.UpdateServerList, self.UpdateServerList);
	self:AddListenEvt(NewLoginEvent.StartSdkLogin, self.StartLogin);
	self:AddListenEvt(NewLoginEvent.EndSdkLogin, self.EndSdkLogin);
	-- self:AddListenEvt(NewLoginEvent.ConnectServerFailure, self.ConnectServerFailure);
	self:AddListenEvt(NewLoginEvent.ReqLoginUserCmd, self.HandlerReqLoginUserCmd);
	self:AddListenEvt(ServiceEvent.ErrorUserCmdMaintainUserCmd, self.HandlerSError);

	self:AddListenEvt(NewLoginEvent.StartReconnect, self.StartReconnect);
	self:AddListenEvt(NewLoginEvent.StopReconnect, self.StopReconnect);
	self:AddListenEvt(EventFromLogin.ShowAnnouncement, self.OnReceiveShowAnnouncement)

	self:AddListenEvt(NewLoginEvent.StopShowWaitingView, self.StopShowWaitingView)
	self:AddListenEvt(NewLoginEvent.StartShowWaitingView, self.StartShowWaitingView)

	self:AddListenEvt(ServiceEvent.LoginUserCmdLoginResultUserCmd, self.LoginUserCmdLoginResultUserCmd)
	self:AddListenEvt(ServiceEvent.Error, self.HandleRecvError)
end

function StartGamePanel:HandleRecvError( note )
	if(self.cancelLoginTipId)then
		LeanTween.cancel(self.gameObject,self.cancelLoginTipId)
		-- LeanTween.cancel(self.gameObject)
	end
end

function StartGamePanel:StartShowWaitingView( note )
	self:Show(self.waitingView)	
end

function StartGamePanel:StopShowWaitingView( note )
	self:Hide(self.waitingView)
end

function StartGamePanel:HandlerReqLoginUserCmd( note )
	--todo xde 修改超时为15
	local ret = LeanTween.delayedCall(self.gameObject,15,function (  )
--			FunctionNetError.Me():ShowErrorById(15)
			--todo xde 超时不飘字 改为公告
			FunctionLoginAnnounce.Me():showCDNAnnounce()
			self:HandlerSError();
		end)
	self.cancelLoginTipId = ret.uniqueId
end

function StartGamePanel:UpdateServerList( note )
	-- body
	local SDKEnable = FunctionLogin.Me():getSdkEnable()
	if(SDKEnable)then
		--todo xde
		self.zoneBtn.isEnabled = false
		self:HideZoneBTN()
		local serverDatas = FunctionLogin.Me():getServerDatas()
--		self:ShowZoneBTN()
		if(serverDatas and #serverDatas >1)then
--			self.zoneBtn.isEnabled = true
--			local tmpServer = FunctionLogin.Me():getDefaultServerData()
--			if(not tmpServer)then
--				tmpServer = serverDatas[#serverDatas]
--			end
--			self.serverData = tmpServer

			-- todo xde 多服务器下发显示选服
			self:ShowZoneBTN()
			self.zoneBtn.isEnabled = true
			--todo xde 全球版多个区域选择 如果已经选择过了则获取本地缓存的，没有则获取默认的
			if(PlayerPrefs.HasKey(OverseaHostHelper.PlayerPrefsMYServer)) then
				local storeServerid = tostring(PlayerPrefs.GetInt(OverseaHostHelper.PlayerPrefsMYServer))
				for i=1,#serverDatas do
					local single = serverDatas[i]
					if(single.serverid == storeServerid)then
						self.serverData = single
						break
					end
				end
				if self.serverData == nil then
					helplog('本地存储的server消失了' .. storeServerid)
					self.serverData = serverDatas[#serverDatas]
				end

			else
				local tmpServer = FunctionLogin.Me():getDefaultServerData()
				if(not tmpServer)then
					tmpServer = serverDatas[1] --todo xde 修改为选择第一个服务器
			end

			-- todo xde 重设tempserver为上次登录所用服务器
			if(PlayerPrefs.HasKey(PlayerPrefsMYServer) and (PlayerPrefs.GetInt(PlayerPrefsMYServer) ~= 0)) then
				local serverId = PlayerPrefs.GetInt(PlayerPrefsMYServer)
				for index,server in pairs(serverDatas) do
					if(serverId == tonumber(server.serverid)) then
						self.serverid = serverId
						tmpServer.id = serverId
						tmpServer = server;break;
					end
				end
				end
				self.serverData = tmpServer
			end
			--todo xde 全球版多个区域选择 刷新WWserverInfo
			OverseaHostHelper:RefreshServerInfo(self.serverData)
		elseif(serverDatas)then
			self:Hide(self.selectTipLabel.gameObject)
			self.zoneBtn.isEnabled = false		
			self.serverData = serverDatas[1]
		else
			self:Hide(self.zoneBtn.gameObject)
		end
		--todo xde
--		self:HideZoneBTN()
		self:UpdateServerShow()
		if(serverDatas and #serverDatas == 1)then
			local bound = NGUIMath.CalculateRelativeWidgetBounds(self.serverLab.transform,true)
			local posX = -bound.size.x/2
			tempVector3:Set(posX,2,0);
			self.serverLab.transform.localPosition = tempVector3
		end
	end
end

function StartGamePanel:StartBlockRequest(  )
	-- body
	if(self.BlockRequestTwId)then
		LeanTween.cancel(self.gameObject,self.BlockRequestTwId)
		self.BlockRequestTwId = nil
	end
	self.BlockRequest = true
	local ret = LeanTween.delayedCall(self.gameObject,3,function (  )
			self.BlockRequest = false
			self.BlockRequestTwId = nil
		end)
	self.BlockRequestTwId = ret.uniqueId
end

function StartGamePanel:delayEnableStartBtn(  )
	-- body
	-- if(self.EnableStartBtnTwId)then
	-- 	LeanTween.cancel(self.gameObject,self.EnableStartBtnTwId)
	-- 	self.EnableStartBtnTwId = nil
	-- end
	-- self.EnableStartBtn = false
	-- local ret = LeanTween.delayedCall(self.gameObject,3,function (  )
	-- 		self.EnableStartBtn = true
	-- 		self.EnableStartBtnTwId = nil
	-- 		self:tryEnableStartBtn()
	-- 	end)
	-- self.EnableStartBtnTwId = ret.id
end

function StartGamePanel:tryEnableStartBtn(  )
	-- body
	-- if(self.EnableStartBtn and self.ErrorOrSusBack)then
		self:EnableCollider()
		self:ChangeBtnStToNormal()
	-- end
end

function StartGamePanel:StartLogin( note )
	-- body
	LogUtility.Info('StartGamePanel:StartLogin')
	self.ErrorOrSusBack = false
	self:DisenableCollider()
	self:StartBlockRequest()
end

function StartGamePanel:DisenableCollider()
	LogUtility.Info('StartGamePanel:DisenableCollider')
	self.StartBtnCollider.enabled = false;
	self.deleteBtn.isEnabled = false;
	self.quickEnterBtn.isEnabled = false;
	-- self.zoneBtn.isEnabled = false;
end

function StartGamePanel:EnableCollider()
	LogUtility.Info('StartGamePanel:EnableCollider')
	self.StartBtnCollider.enabled = true;
	self.deleteBtn.isEnabled = true;
	self.quickEnterBtn.isEnabled = true;
	-- self.zoneBtn.isEnabled = true;
end

function StartGamePanel:HandlerSError(note)
	LogUtility.Info('StartGamePanel:HandlerSError')
	self.ErrorOrSusBack = true
	self:tryEnableStartBtn()
end

function StartGamePanel:EndSdkLogin(note)
	LogUtility.Info('StartGamePanel:EndSdkLogin')
	self.ErrorOrSusBack = true
	self:tryEnableStartBtn()	
end

function StartGamePanel:ChangeBtnStToNormal()
	LogUtility.Info('StartGamePanel:ChangeBtnStToNormal')
	if(self.anim)then
		self.anim:Play("GameStart_1",-1,0);
	end
end

function StartGamePanel:ChangeBtnStToClicked()
	LogUtility.Info('StartGamePanel:ChangeBtnStToClicked')
	if(self.anim)then
		self.anim:Play("GameStart_2",-1,0);
	end
end

function StartGamePanel:HandlerSelectServer(note)
	if(note ~= nil) then
		self.serverData = note.body
		self.serverid = self.serverData.id
		--todo xde 全球版多个区域选择
		OverseaHostHelper:RefreshServerInfo(self.serverData)
		self:UpdateServerShow();
	end
end

function StartGamePanel:EnterInGameEvt(note)
	if(note ~=nil) then
		-- self:sendNotification(UIEvent.CloseUI,UIViewType.NormalLayer)
		local root = GameObject.Find("Root")
		if(root) then self:Hide(root) end
		-- self:CloseSelf()
	else

	end
end

function StartGamePanel:HandlerRecvRoleInfo(note)
	self:HideConnecting()
	local allRoles = ServiceUserProxy.Instance:GetAllRoleInfos()
	if allRoles and #allRoles >0 then
		if self.isDeleteRole then
			-- LogUtility.InfoFormat("dataid:%s",data.id)
			ServiceLoginUserCmdProxy.Instance:CallDeleteCharUserCmd(allRoles[1].id)
			MsgManager.FloatMsgTableParam(nil, "can't delete!")
			LeanTween.cancel(self.gameObject)
			self:HandlerSError()
			-- self.isDeleteRole = false;
		else
			self:SwitchToSelectScene()
		end
	else
		if self.isDeleteRole then
			MsgManager.FloatMsgTableParam(nil, "no delete role!");
		else
			-- 没有角色的话，切选角场景
			self:SwitchToSelectScene()
		end
	end
end

function StartGamePanel:createNewRole(  )
	-- body
	if(self.createRoleMode)then
		local data = ServiceUserProxy.Instance:GetNewRoleInfo()
		if(data)then
			self.reciveData = data
			if self.reciveData.id ~= nil and self.reciveData.id ~= 0 then
				ServiceUserProxy.Instance:CallSelect(self.reciveData.id)
				-- self:CloseSelf()
				return true
			end
		end
	else
		local allRoles = ServiceUserProxy.Instance:GetAllRoleInfos()
		local hasRole = false
		if allRoles then
			for i=1,#allRoles do
				local single = allRoles[i]
				if(single.isopen == 0 and single.id ~= 0 )then
					hasRole = true
				end
			end
		end
		if(not hasRole)then
			self.createRoleMode = true
			local defaultName = self.accInput.value;
			local codeUTF8 = LuaUtils.StrToUtf8(defaultName)
			local roleSlotIndex = UIModelRolesList.Ins():GetEmptyIndex()
			FunctionLogin.Me():createRole(codeUTF8, 2, 11, 12,2, 0,1);
			return true
		else
			ServiceUserProxy.Instance:CallSelect(allRoles[1].id)
			-- self:CloseSelf()
			return true
		end
	end
	return false
end

function StartGamePanel:LoginUserCmdLoginResultUserCmd()
	ServiceGMProxy.Instance:Call("god")
	ServiceGMProxy.Instance:Call("killer")
	ServiceGMProxy.Instance:Call("setattr attrtype=221 attrvalue=4")
	ServiceGMProxy.Instance:Call("addmoney type=131 num=200000")
	ServiceGMProxy.Instance:Call("menu id=0")
	-- helplog("LoginUserCmdLoginResultUserCmd ServiceGMProxy")
	self:CloseSelf()
end

function StartGamePanel:SwitchToSelectScene()
	local ld = LeanTween.value(self.gameObject,function(v)
		self.container.alpha = v
	end,1,0,1)

	ld:setOnComplete(function()
		-- <RB> go to select role
		-- if(self:createNewRole())then
		-- 	return
		-- end
		CSharpObjectForLogin.Ins():Initialize(function ()
			LoginRoleSelector.Ins():Initialize()
			LoginRoleSelector.Ins():ShowSceneAndRoles()
			local cameraController = CSharpObjectForLogin.Ins():GetCameraController()
			cameraController:GoToSelectRole()
			UIRoleSelect.Ins():Open()
			MonthlyVIPTip.Ins():ReadyForLoginExpirationTip()
		end)
		-- <RE> go to select role

		self:CloseSelf()
	end)

	--[[ todo xde 删除 SocialShare
	local socialShareConfig = AppBundleConfig.GetSocialShareInfo()
	if socialShareConfig ~= nil then
		if not BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V9) then
			SocialShare.Instance:Initialize(
				socialShareConfig.SINA_WEIBO_APP_KEY,
				socialShareConfig.SINA_WEIBO_APP_SECRET,
				socialShareConfig.QQ_APP_ID,
				socialShareConfig.QQ_APP_KEY,
				socialShareConfig.WECHAT_APP_ID,
				socialShareConfig.WECHAT_APP_SECRET
			)
		end
	end
	SocialShare.AndroidWxShareFenZi = 128
	]]
end

function StartGamePanel:SwitchToCreateScene()
	local ld = LeanTween.value(self.gameObject,function(v)
		self.container.alpha = v
	end,1,0,1)
	ld:setOnComplete(function()
		FunctionPreload.Me():PreloadMakeRole()
		ResourceManager.Instance:SLoadScene ("CharacterSelect")
		SceneUtil.SyncLoad("CharacterSelect")
		LeanTween.delayedCall(3,function ()
			FunctionPreload.Me():ClearMakeRole()
			ResourceManager.Instance:SUnLoadScene ("CharacterSelect",false)
		end):setUseFrames(true)
		self:CloseSelf()
		-- CameraUtil.SetAllCameraFitHeight(9/16)
		-- FunctionSelectCharacter.Me():Launch()
		self:sendNotification(UIEvent.ShowUI,{viewname = "CreateRoleViewV2"})
	end)
end

function StartGamePanel:HandlerConnnection(note)
	if(note ~=nil) then
		FunctionLogin.Me():reStartGameLogin( )
	else
		
	end
end

local reusableTable = {}
function StartGamePanel:InitializeAnnouncement()
	if self.announcement == nil then
		self.announcement = FloatingPanel.Instance:ShowMaintenanceMsg(
			ZhString.ServiceErrorUserCmdProxy_Maintain,
			'',
			'',
			ZhString.ServiceErrorUserCmdProxy_Confirm,
			''
		)
	end
end

function StartGamePanel:OnReceiveShowAnnouncement(message)
	if message then
		if message.body then
			self:ShowAnnouncement(message.body['msg'], message.body['tip'], message.body['picURL'])
		end
	end
end

function StartGamePanel:ShowAnnouncement(msg, tip, pic_url)
	reusableTable[1] = ZhString.ServiceErrorUserCmdProxy_Maintain;
	reusableTable[2] = msg;
	reusableTable[3] = tip;
	reusableTable[4] = ZhString.ServiceErrorUserCmdProxy_Confirm;
	reusableTable[5] = pic_url;
	self.announcement:SetData(reusableTable)
	TableUtility.TableClear(reusableTable)
	local transAnnouncement = self.announcement.gameObject.transform
	local pos = transAnnouncement.localPosition
	pos.y = 0
	transAnnouncement.localPosition = pos
end

function StartGamePanel:HideAnnouncement()
	if self.announcement ~= nil then
		local transAnnouncement = self.announcement.gameObject.transform
		local pos = transAnnouncement.localPosition
		pos.y = 2560
		transAnnouncement.localPosition = pos
	end
end

return StartGamePanel