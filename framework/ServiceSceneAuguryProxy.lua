autoImport('ServiceSceneAuguryAutoProxy')
ServiceSceneAuguryProxy = class('ServiceSceneAuguryProxy', ServiceSceneAuguryAutoProxy)
ServiceSceneAuguryProxy.Instance = nil
ServiceSceneAuguryProxy.NAME = 'ServiceSceneAuguryProxy'

function ServiceSceneAuguryProxy:ctor(proxyName)
	if ServiceSceneAuguryProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSceneAuguryProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceSceneAuguryProxy.Instance = self
	end
end

function ServiceSceneAuguryProxy:RecvAuguryInviteReply(data)
	AuguryProxy.Instance:SetNpcId(data.npcguid)
	self:sendNotification(UIEvent.CloseUI, UIViewType.DialogLayer)

	if data.type == SceneAugury_pb.EReplyType_Refuse then
		MsgManager.ShowMsgByID(867)
	end
	self:Notify(ServiceEvent.SceneAuguryAuguryInviteReply, data)
end

function ServiceSceneAuguryProxy:RecvAuguryTitle(data)
	AuguryProxy.Instance:RecvAuguryTitle(data)

	if data.titleid then
		local tb = AuguryProxy.Instance:GetTable()
		if tb then
			local staticData = tb[data.titleid]
			if staticData and staticData.Type == 1 then
				local npcId = AuguryProxy.Instance:GetNpcId()
				if npcId then
					local npc = NSceneNpcProxy.Instance:Find(npcId)
					if npc and VectorUtility.DistanceXZ( Game.Myself:GetPosition(), npc:GetPosition() ) <= GameConfig.Augury.Range then
						self:sendNotification(UIEvent.JumpPanel, {view = PanelConfig.AuguryView , viewdata = {isNpcFuncView = true}})
					else
						ServiceSceneAuguryProxy.Instance:CallAuguryQuit()
					end
				end
			end
		end
	end

	self:Notify(ServiceEvent.SceneAuguryAuguryTitle, data)
end

function ServiceSceneAuguryProxy:RecvAuguryChat(data)
	AuguryProxy.Instance:RecvAuguryChat(data)
	self:Notify(ServiceEvent.SceneAuguryAuguryChat, data)
end