autoImport("Creature_SceneUI")
NPlayer = reusableClass("NPlayer",NCreatureWithPropUserdata)
NPlayer.PoolSize = 80

autoImport("NPlayer_Effect")
autoImport("NPlayer_Logic")
local EmptyTable =_EmptyTable
function NPlayer:ctor(aiClass)
	NPlayer.super.ctor(self,aiClass)
	self.sceneui = nil
	self.skill = ServerSkill.new()
	self.userDataManager = Game.LogicManager_Player_Userdata
	self.propmanager = Game.LogicManager_Player_Props
end

function NPlayer:GetCreatureType()
	return Creature_Type.Player
end

function NPlayer:GetSceneUI()
	return self.sceneui
end

-- function NPlayer:SetActionConfig(config)
-- 	if(assetRole) then
-- 		assetRole:SetActionConfig(config)
-- 	end
-- end

function NPlayer:AllowSpEffect_OnFloor()
	if nil == self.ai.parent -- not on bus
		and not self:IsOnSceneSeat() then
		local head = self.data.userdata:Get(UDEnum.HEAD)
		if (45086 == head or 145086 == head) then
			return true
		end
	end
	return false
end

function NPlayer:Update(time, deltaTime)
	NPlayer.super.Update(self,time,deltaTime)
	self:_UpdateEffect(time,deltaTime)
end

function NPlayer:HandlerAssetRoleSuffixMap()
	local profess = self.data:GetProfesstion()
	if(profess and self.assetRole) then
		local classData = Table_Class[profess]
		if(classData and classData.ActionSuffixMap~=EmptyTable) then
			local bodyID = self.data.userdata:Get(UDEnum.BODY) or 0
			local bodyData = Table_Body[bodyID]
			if(bodyData and bodyData.Feature and bodyData.Feature & 1 >0) then
				self.assetRole:SetSuffixReplaceMap(classData.ActionSuffixMap)
			else
				self.assetRole:SetSuffixReplaceMap(nil)
			end
		else
			self.assetRole:SetSuffixReplaceMap(nil)
		end
	end
end

function NPlayer:InitAssetRole()
	NPlayer.super.InitAssetRole(self)
	local assetRole = self.assetRole
	assetRole:SetGUID( self.data.id )
	assetRole:SetName( self.data:GetName() )
	assetRole:SetClickPriority(self.data:GetClickPriority())
	assetRole:SetInvisible(false)
	assetRole:SetShadowEnable( true )
	assetRole:SetRenderEnable( true )
	assetRole:SetColliderEnable( true )
	assetRole:SetWeaponDisplay( true )
	assetRole:SetMountDisplay( true )
	assetRole:SetActionSpeed(1)
	self:HandlerAssetRoleSuffixMap()
	-- assetRole:SetActionConfig(Game.Config_PlayerAction)
	-- assetRole:PlayAction(name, defaultName, speed, normalizedTime, force)
end

function NPlayer:DeterminPriority()
	if(TeamProxy.Instance:IsInMyTeam(self.data.id))then
		return LogicManager_RoleDress.Priority.Team
	end
	if(FriendProxy.Instance:IsFriend(self.data.id))then
		return LogicManager_RoleDress.Priority.Friend
	end
	if(GuildProxy.Instance:CheckPlayerInMyGuild(self.data.id))then
		return LogicManager_RoleDress.Priority.Guild
	end
	return LogicManager_RoleDress.Priority.Normal
end

function NPlayer:GetDressPriority()
	return self.priority
end

function NPlayer:OnAvatarPriorityChanged()
	local newPriority = self:DeterminPriority()
	if newPriority == self.priority then
		LogUtility.InfoFormat("<color=red>Bug!!! Same priority: </color>{0}", newPriority)
		return
	end
	local oldPriority = self.priority
	self.priority = newPriority
	Game.LogicManager_RoleDress:RefreshPriority(self, oldPriority, newPriority)
end

function NPlayer:ReDress()
	--??????????????????
	if(self._changeJobTimeFlag) then
		return
	end
	NPlayer.super.ReDress(self)
end

function NPlayer:Sever_SetTitleID(serverTitleData)
	if(serverTitleData)then
		self.data:SetAchievementtitle(serverTitleData.id)
		local sceneUI = self:GetSceneUI() or nil
		if(sceneUI)then
			sceneUI.roleBottomUI:HandleChangeTitle(self)
		end	
	end
end

function NPlayer:RegisterRoleDress()
	Game.LogicManager_RoleDress:Add(self)
end
function NPlayer:UnregisterRoleDress()
	Game.LogicManager_RoleDress:Remove(self)
end

local function _ClickTopChatRoom(playerID)
	FunctionSecurity.Me():TryDoRealNameCentify( function (go)
		local player = NSceneUserProxy.Instance:Find(playerID)
		local zoomInfo = nil
		if(player~=nil) then
			zoomInfo = player.data.chatRoomData
		end
		if not zoomInfo then
			return
		end
		if (zoomInfo.curnum >= zoomInfo.maxnum) then
			MsgManager.ShowMsgByIDTable(808)
		else
			if ChatZoomProxy.Instance:CachedZoomInfo() then
				GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.ChatRoomPage, viewdata = { key = "ChatZone"}})
			else
				if (zoomInfo.pswd == "") then
					ServiceChatRoomProxy.Instance:CallJoinChatRoom(zoomInfo.roomid, "")
				else
					GameFacade.Instance:sendNotification(UIEvent.ShowUI,{viewname = "InputSecretChatZoom"})
					GameFacade.Instance:sendNotification(ChatZoomEvent.TransmitChatZoomSummary, zoomInfo)
				end
			end
		end
	end,callbackParam )
end
function NPlayer:CreateChatRoom(chatRoomInfo)
	self.data:InitChatRoomData(chatRoomInfo)
	local chatRoomData = self.data.chatRoomData
	if(chatRoomData and self.sceneui) then
		local icon = ((chatRoomData.roomtype == SceneChatRoom_pb.ECHATROOMTYPE_PUBLIC) and "69") or "70"
		local str1 = chatRoomData.name
		local str2 = "(" .. chatRoomData.curnum .. "/" .. chatRoomData.maxnum .. ")"
		local text = {left = str1, right = str2}
		self.sceneui.roleTopUI:SetTopFuncFrame(text, icon, _ClickTopChatRoom, chatRoomData.ownerid, self);
	end
end

function NPlayer:UpdateChatRoom(chatRoomInfo)
	self:DestroyChatRoom()
	self:CreateChatRoom(chatRoomInfo)
end

function NPlayer:DestroyChatRoom(withData)
	if(self.sceneui)then
		self.sceneui.roleTopUI:RemoveTopFuncFrame();
	end
	if(withData and self.data.chatRoomData) then
		self.data.chatRoomData:Destroy()
		self.data.chatRoomData = nil
	end
end

local function _ClickTopBooth(playerID)
	local player = NSceneUserProxy.Instance:Find(playerID)
	if player == nil then
		return
	end

	GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.BoothMainView, viewdata = {playerID = playerID}})
end

function NPlayer:UpdateBooth(boothInfo)
	if self.sceneui and boothInfo and #boothInfo.name > 0 then
		self.data:UpdateBoothData(boothInfo)

		local boothData = self.data.boothData

		local icon = ""
		local scoreConfig = GameConfig.Booth.score[boothData:GetSign()]
		if scoreConfig ~= nil then
			icon = scoreConfig.icon
		end
		self.sceneui.roleTopUI:SetTopFuncFrame(boothData:GetName(), icon, _ClickTopBooth, self.data.id, self, SceneUIType.RoleTopBoothInfo)
	end
end

function NPlayer:DestroyBooth()
	if self.sceneui then
		self.sceneui.roleTopUI:RemoveTopFuncFrame()
	end
	self.data:ClearBoothData()
end

function NPlayer:IsInBooth()
	return self.data.boothData ~= nil
end

function NPlayer:_InitData(serverData)
	if(self.data==nil) then
		return PlayerData.CreateAsTable(serverData)
	end
	return nil
end

-- override begin
function NPlayer:DoConstruct(asArray, serverData)
	self:CreateWeakData()
	local data = self:_InitData(serverData)
	NPlayer.super.DoConstruct(self,asArray,data)
	self:InitAssetRole()
	self:InitLogicTransform(serverData.pos.x,serverData.pos.y,serverData.pos.z,nil,nil)
	self.sceneui = Creature_SceneUI.CreateAsTable(self)
	self:Server_SetUserDatas(serverData.datas,true)
	self:Server_SetAttrs(serverData.attrs)
	self:InitBuffs(serverData)

	--1. ?????????
	local dest = serverData.dest
	if(dest and not PosUtil.IsZero(dest)) then
		self:Server_MoveToXYZCmd(dest.x,dest.y,dest.z,1000)
	end

	--2. get on seat
	if nil ~= serverData.seatid 
		and 0 ~= serverData.seatid then
		self:Server_GetOnSeat(serverData.seatid)
	end

	--3. ?????????actionID ????????????
	if(serverData.motionactionid and serverData.motionactionid~=0) then
		local actionData = Table_ActionAnime[serverData.motionactionid]
		if actionData then
			local actionName = actionData.Name
			self:Server_PlayActionCmd(actionName,nil,true)
		end
	end
	--4. ?????????????????????
	self:CreateChatRoom(serverData.chatroom)

	--5. ??????????????????
	self:UpdateBooth(serverData.info)

	-- 1.
	self.priority = self:DeterminPriority()
	-- 2.
	self:RegisterRoleDress()
	
	--cullingGrp
	self:RegistCulling()
end

function NPlayer:DoDeconstruct(asArray)
	self:UnRegistCulling()
	self:UnregisterRoleDress()
	NPlayer.super.DoDeconstruct(self,asArray)
	self:_ClearTrackEffects()
	if(self.sceneui) then
		self.sceneui:Destroy()
		self.sceneui = nil
	end
	self.assetRole:Destroy()
	self.assetRole = nil
end
-- override end