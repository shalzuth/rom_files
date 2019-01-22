SwitchRolePanel = class("SwitchRolePanel",ContainerView)
SwitchRolePanel.ViewType = UIViewType.LoadingLayer

local tempVector3 = LuaVector3.zero
autoImport('OverseaHostHelper')
autoImport("SwitchRoleLoadingView")
autoImport("LoadingSceneView")
autoImport("DefaultLoadModeView")
SwitchRolePanel.toswitchroleid = "SwitchRolePanel_toswitchroleid";
SwitchRolePanel.accid = "PlayerPrefsMYACC";
SwitchRolePanel.serverid = "PlayerPrefsMYServer";

SwitchRolePanel.isSwitchRoleIng = false
function SwitchRolePanel:Init()
	self:initView();
	-- self:initData();
	self:AddListenerEvts();
end

function SwitchRolePanel:OnEnter(  )
	-- body
	self:initData()
	SwitchRolePanel.SetIsSwitchRole( true )
end

function SwitchRolePanel.SetIsSwitchRole( result  )
	SwitchRolePanel.isSwitchRoleIng = result
end

function SwitchRolePanel:initData(  )
	self.isSdkLogin = false
	self.isConnectServer = false
	self.currentProgress = 0
	self.switchRole = nil
	if(PlayerPrefs.HasKey(ServiceLoginUserCmdProxy.toswitchroleid)) then
		self.switchRole = PlayerPrefs.GetString(ServiceLoginUserCmdProxy.toswitchroleid)
	end

	self.switchAcc = nil
	if(PlayerPrefs.HasKey(SwitchRolePanel.accid)) then
		self.switchAcc = PlayerPrefs.GetString(SwitchRolePanel.accid)
	end

	if(not self.switchRole)then
		self:goBackLogin()
		return
	end

	local SDKEnable = FunctionLogin.Me():getSdkEnable()
	if(SDKEnable)then
		FunctionLogin.Me():launchAndLoginSdk(function (  )
			-- body
			self.isSdkLogin = true
			self:UpdateServerList()
			if(not self.serverData)then
				self:goBackLogin()
				return 
			end
			FunctionLogin.Me():startGameLogin(self.serverData,nil,function ( )
						-- body
				self.isConnectServer = true
				FunctionLogin.Me():LoginUserCmd()
				PlayerPrefs.DeleteKey(ServiceLoginUserCmdProxy.toswitchroleid)
			end)
		end)
	else
		if(PlayerPrefs.HasKey(SwitchRolePanel.serverid)) then
			self.serverid = PlayerPrefs.GetInt(SwitchRolePanel.serverid)
			self.serverData = Table_ServerList[self.serverid]
		end
		if(not self.serverid or not self.serverData)then
			self:goBackLogin()
			return
		end
		self.isSdkLogin = true
		FunctionLogin.Me():startGameLogin(self.serverData,self.switchAcc,function ( )
			-- body
			self.isConnectServer = true
			FunctionLogin.Me():LoginUserCmd()
			PlayerPrefs.DeleteKey(ServiceLoginUserCmdProxy.toswitchroleid)
		end)
	end
	self.currentView:Progress(0)
end

function SwitchRolePanel:goBackLogin(  )
	helplog("goBackLogin")
	SwitchRolePanel.SetIsSwitchRole( false )
	ServiceConnProxy.Instance:StopHeart()
	Game.Me():BackToLogo()
end

function SwitchRolePanel:initView()
	self.currentView = self:AddSubView("DefaultLoadModeView",SwitchRoleLoadingView)
	self.blackBg = self:FindGO("BlackBg"):GetComponent(UISprite)
	self:AddClickEvent(self.blackBg.gameObject,nil,{hideClickSound = true})
	self.timeTick = TimeTickManager.Me():CreateTick(0,16,self.Update,self,1)
end

function SwitchRolePanel:OnExit()
	SwitchRolePanel.SetIsSwitchRole( false )
	SwitchRolePanel.super.OnExit(self);
	self.timeTick:ClearTick()
	FunctionBGMCmd.Me():GetDefaultBGM()
end


function SwitchRolePanel:ErrorMsg(msg)
	MsgManager.FloatMsgTableParam(nil, msg);	
end

function SwitchRolePanel:AddListenerEvts()
	self:AddListenEvt(ServiceEvent.UserRecvRoleInfo, self.HandlerRecvRoleInfo);
	self:AddListenEvt(NewLoginEvent.LaunchFailure, self.goBackLogin);
	self:AddListenEvt(NewLoginEvent.SDKLoginFailure, self.goBackLogin);
	self:AddListenEvt(NewLoginEvent.LoginFailure, self.goBackLogin);
	self:AddListenEvt(ServiceEvent.ErrorUserCmdMaintainUserCmd, self.goBackLogin);

	self:AddListenEvt(LoadEvent.SceneFadeOut,self.SceneFadeOut)
	self:AddListenEvt(LoadEvent.StartLoadScene,self.StartLoadScene)
	self:AddListenEvt(LoadEvent.FinishLoadScene,self.HandlerLogin)
	self:AddListenEvt(ServiceEvent.Error,self.HandlerServiceError)
	self:AddListenEvt(ServiceEvent.ConnNetDown,self.HandlerConnDown)
end

function SwitchRolePanel:UpdateServerList( note )
	-- body
	local SDKEnable = FunctionLogin.Me():getSdkEnable()
	if(SDKEnable)then
		local serverDatas = FunctionLogin.Me():getServerDatas()
		if(serverDatas and #serverDatas >1)then
			--todo xde ??????????????????????????? ???????????????????????????????????????????????????????????????????????????
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
					helplog('???????????????server?????????' .. storeServerid)
					self.serverData = serverDatas[#serverDatas]
				end
			else
				local tmpServer = FunctionLogin.Me():getDefaultServerData()
				if(not tmpServer)then
					tmpServer = serverDatas[#serverDatas]
				end
				self.serverData = tmpServer
			end
			--todo xde ??????????????????????????? ??????WWserverInfo
			OverseaHostHelper:RefreshServerInfo(self.serverData)
		elseif(serverDatas)then
			self.serverData = serverDatas[1]
		end	
	end
end

function SwitchRolePanel:HandlerRecvRoleInfo(note)
	local allRoles = ServiceUserProxy.Instance:GetAllRoleInfos()
	if allRoles and #allRoles >0 then
		for i=1,#allRoles do
			local single = allRoles[i]
			if(tostring(single.id) == self.switchRole and single.deletetime == 0)then
				ServiceUserProxy.Instance:CallSelect(tonumber(self.switchRole))
				return
			end
		end
	end
	self:goBackLogin()
end

function SwitchRolePanel:HandlerServiceError(note)
	self.serverError = true
	self:CheckNetError()
end

function SwitchRolePanel:HandlerConnDown(note)
	self.serverError = true
	self:CheckNetError()
end

function SwitchRolePanel:SceneFadeOut(note)
	-- LeanTween.cancel(self.blackBg.gameObject)
	-- self.currentView:SceneFadeOut()
	SceneProxy.Instance:ASyncLoad()
end

function SwitchRolePanel:LoadFinish()
	self.currentView:LoadFinish()
end

function SwitchRolePanel:CheckNetError()
	if(self.serverError and self.Loaded) then
		FunctionMapEnd.Me():Launch()
	end
end

function SwitchRolePanel:FireLoadFinishEvent()
	self:CheckNetError()
    self:sendNotification(ServiceEvent.PlayerMapChange,self.sceneInfo,LoadSceneEvent.FinishLoad)
end

-- function SwitchRolePanel:LoadSceneLoaded(note)
-- 	self.currentView:tryShowBg()
-- end

function SwitchRolePanel:StartLoadScene(note)
	self.sceneInfo = note.body
	self.Loaded = false
	SceneProxy.Instance:SetLoadFinish(function(info)
		self.Loaded = true
		self.timeTick:ClearTick()
		self:LoadFinish()
	end)
	self.timeTick:Restart()
end

function SwitchRolePanel:Update(delta)
	-- self.currentView:Update(delta)
	if(not self.isSdkLogin)then
		self.currentProgress = self.currentProgress + 0.13
		if(self.currentProgress>=20)then
			self.currentProgress = 20
		end
	elseif(self.isSdkLogin and not self.isConnectServer)then
		if(self.currentProgress <25)then
			self.currentProgress = 25
		end
		self.currentProgress = self.currentProgress + 0.13
		if(self.currentProgress>=40)then
			self.currentProgress = 40
		end
	elseif(self.isConnectServer)then
		self.currentProgress = 50
	end
	self.currentView:Progress(self.currentProgress+SceneProxy.Instance:LoadingProgress()/2)
end

return SwitchRolePanel