autoImport("SceneCreatureProxy")
SceneAINpcProxy = class('SceneAINpcProxy', SceneCreatureProxy)

SceneAINpcProxy.Instance = nil;

SceneAINpcProxy.NAME = "SceneAINpcProxy"

--AI npc（艾娃）数据管理，添加、删除、查找npc
function SceneAINpcProxy:ctor(proxyName, data)
	self.proxyName = proxyName or SceneAINpcProxy.NAME
	self.userMap = {}
	if(SceneAINpcProxy.Instance == nil) then
		SceneAINpcProxy.Instance = self
	end

	self.delayRemoveDuration = {}
	self.delayRemoveDuration[NpcData.NpcDetailedType.NPC] = GameConfig.MonsterBodyDisappear.NPC
end

function SceneAINpcProxy:Find(guid)
	return self.userMap[guid]
end

function SceneAINpcProxy:Add(data, classRef)
	local npc = self:Find(data.guid)
	if npc ~= nil then
		return npc
	end

	if classRef then
		npc = classRef.CreateAsTable(data)
		self:PureAdd(npc.data.id, npc)
	end

	return npc
end

function SceneAINpcProxy:PureAdd(id, creature)
	self.userMap[id] = creature
end

function SceneAINpcProxy:Remove(guid, fade)
	if self.userMap[guid] then
		self.userMap[guid]:Destroy()
		self:PureRemove(guid)

		return true
	end

	return false
end

function SceneAINpcProxy:PureRemove(guid)
	self.userMap[guid] = nil
end

function SceneAINpcProxy:Die(guid, npc)
	if npc == nil then
		npc = self:Find(guid)
	end
	if npc then
		npc:Server_PlayActionCmd(Asset_Role.ActionName.Die,nil,false,false)
		local delay = self.delayRemoveDuration[npc.data.detailedType]
		if delay==nil then
			delay = 1600
		end
		npc:SetDelayRemove(delay/1000)
	end
	return npc
end

function SceneAINpcProxy:Clear()
	self:ChangeAddMode(SceneCreatureProxy.AddMode.Normal)
	self:ClearNpc()
	SceneAINpcProxy.super.Clear(self)
end

function SceneAINpcProxy:ClearNpc()
	for k,v in pairs(self.userMap) do
		v:Destroy()
		self:PureRemove(k)
	end
end

--艾娃(添加/删除)
function SceneAINpcProxy:SetHandNpc(data)
	if data.userid then
		local user = NSceneUserProxy.Instance:Find(data.userid) 
		if user ~= nil then
			local serverData = data.data
			if data.ishand then
				local npc = self:Find(serverData.guid)
				if npc then
					npc:ResetData(serverData)
				else
					npc = SceneAINpcProxy.Instance:Add( serverData, NHandNpc)
					user:AddHandNpc( npc.data.id )
				end

				npc:SetMaster(user)
				npc:SetPos(user)
			else
				user:RemoveHandNpc()
				self:Remove( serverData.guid )
			end
		end
	end
end

--九屏添加艾娃
function SceneAINpcProxy:AddHandNpc(role,handnpcData,serverpos)
	if handnpcData.body ~= 0 then
		local npc = self:Find(handnpcData.guid)
		if npc then
			npc:ResetData(handnpcData)
		else
			npc = SceneAINpcProxy.Instance:Add( handnpcData, NHandNpc)
			role:AddHandNpc( npc.data.id )
		end

		npc:SetMaster(role)
		npc:SetPos(role, serverpos)
	end
end

--姜饼人(添加/删除)
function SceneAINpcProxy:SetExpressNpc(data)
	if data.userid then
		local user = NSceneUserProxy.Instance:Find(data.userid) 
		if user ~= nil then
			local id = data.data.guid
			if data.isadd then
				if not user:IsExpressNpc(id) then
					local npc = self:Add( data.data, NExpressNpc)
					if npc then
						npc:SetMaster(user)
						npc:SetPos(user, data.bornpos)

						user:AddExpressNpc(id)
					end
				end
			else
				self:Die(id)

				if id == FunctionVisitNpc.Me():GetTargetId() then
					self:sendNotification(UIEvent.CloseUI, UIViewType.DialogLayer)
				end
			end
		end
	end	
end

--九屏添加姜饼人
function SceneAINpcProxy:AddExpressNpc(role,expressnpcDatas,serverpos)
	if expressnpcDatas and #expressnpcDatas > 0 then
		role:ClearExpressNpc()

		for i=1,#expressnpcDatas do
			local npc = self:Add( expressnpcDatas[i], NExpressNpc)
			if npc then
				npc:SetMaster(role)
				npc:SetPos(role, serverpos)

				role:AddExpressNpc(npc.data.id)
			end
		end
	end
end