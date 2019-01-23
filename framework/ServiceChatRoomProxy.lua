autoImport('ServiceChatRoomAutoProxy')
ServiceChatRoomProxy = class('ServiceChatRoomProxy', ServiceChatRoomAutoProxy)
ServiceChatRoomProxy.Instance = nil
ServiceChatRoomProxy.NAME = 'ServiceChatRoomProxy'

function ServiceChatRoomProxy:ctor(proxyName)
	if ServiceChatRoomProxy.Instance == nil then
		self.proxyName = proxyName or ServiceChatRoomProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceChatRoomProxy.Instance = self
	end
end

function ServiceChatRoomProxy:RecvEnterChatRoom(data)
	-- LogUtility.Info("FUN >>> ServiceChatRoomProxy:RecvEnterChatRoom")
	-- cache room information
	ChatZoomProxy.Instance:CacheZoomInfo(data.data)
	-- send notification
	self:Notify(ServiceEvent.ChatRoomEnterChatRoom, data)
	-- show ui
	-- self:sendNotification(UIEvent.ShowUI,{viewname="ChatZoom"})
	self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.ChatRoomPage, viewdata = { key = "ChatZone"}})

	if Game.Myself:Client_GetFollowLeaderID() ~= 0 then
		MsgManager.ShowMsgByIDTable(862)
		self:sendNotification(FollowEvent.CancelFollow)
	end

	FunctionSystem.WeakInterruptMyself(true) -- ignore action
	FunctionSystem.InterruptMyselfAI()
	InputManager.Instance.disableMove = InputManager.Instance.disableMove + 1
	Game.Myself:Client_NoMove(true)

	MsgManager.ShowMsgByIDTable(811)
end

function ServiceChatRoomProxy:RecvJoinChatRoom(data)
	self:Notify(ServiceEvent.ChatRoomJoinChatRoom, data)
end

function ServiceChatRoomProxy:RecvExitChatRoom(data)
	SceneUIManager.Instance:RemoveRoleTopFuncWords(Game.Myself)
	ChatZoomProxy.Instance:ClearMessageQueue()
	ChatZoomProxy.Instance:ClearZoomInfo()
	self:Notify(ServiceEvent.ChatRoomExitChatRoom, data)

	InputManager.Instance.disableMove = InputManager.Instance.disableMove - 1
	Game.Myself:Client_NoMove(false)

	MsgManager.ShowMsgByIDTable(812)
end

function ServiceChatRoomProxy:RecvRoomMemberUpdate(data)
	-- LogUtility.Info("FUN >>> ServiceChatRoomProxy:RecvRoomMemberUpdate")
	ChatZoomProxy.Instance:UpdateMembers(data.updates)
	ChatZoomProxy.Instance:DeleteMembers(data.deletes)
	self:Notify(ServiceEvent.ChatRoomRoomMemberUpdate, data)
end

function ServiceChatRoomProxy:RecvChatRoomDataSync(data)
	if (data == nil) then
		return
	end

	local zoomInfo = data.data
	if (data.esync == SceneChatRoom_pb.ECHATROOMSYNC_REMOVE) then
		local player = NSceneUserProxy.Instance:Find(zoomInfo.ownerid)
		if(player) then
			player:DestroyChatRoom(true)
		else
			LogUtility.ErrorFormat("移除一个非玩家的聊天室？%s",zoomInfo.ownerid)
		end
	elseif (data.esync == SceneChatRoom_pb.ECHATROOMSYNC_UPDATE) then
		local player = NSceneUserProxy.Instance:Find(zoomInfo.ownerid)
		if(player) then
			player:UpdateChatRoom(zoomInfo)
		else
			LogUtility.ErrorFormat("添加一个非玩家的聊天室？%s",zoomInfo.ownerid)
		end
	end

	self:Notify(ServiceEvent.ChatRoomChatRoomDataSync, data)
end

function ServiceChatRoomProxy:RecvKickChatMember(data)
	print("FUN >>> ServiceChatRoomProxy:RecvKickChatMember")
	print("data folowing...")
	ChatZoomProxy.Instance:ClearMessageQueue()
	ChatZoomProxy.Instance:ClearZoomInfo()
	self:Notify(ServiceEvent.ChatRoomKickChatMember, data)

	InputManager.Instance.disableMove = InputManager.Instance.disableMove - 1
	Game.Myself:Client_NoMove(false)
end