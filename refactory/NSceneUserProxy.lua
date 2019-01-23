autoImport("SceneCreatureProxy")
NSceneUserProxy = class('NSceneUserProxy', SceneCreatureProxy)

NSceneUserProxy.Instance = nil;

NSceneUserProxy.NAME = "NSceneUserProxy"

-- autoImport("Table_RoleData")

function NSceneUserProxy:ctor(proxyName, data)
	self:CountClear()
	self.userMap = {}
	if(NSceneUserProxy.Instance == nil) then
		NSceneUserProxy.Instance = self
	end
	self.proxyName = proxyName or NSceneUserProxy.NAME
	if(Game and Game.LogicManager_Creature) then
		Game.LogicManager_Creature:SetSceneUserProxy(self)
	end
end

function NSceneUserProxy:FindOtherRole(guid)
	--临时不处理玩家自己的添加
	-- if(Player.Me.activeRoleInfo.ID == guid) then
	if(Game.Myself and Game.Myself.data and Game.Myself.data.id == guid) then
		return nil
	end
	return self:Find(guid)
end

function NSceneUserProxy:Find(guid)
	if(Game.Myself and Game.Myself.data and Game.Myself.data.id == guid) then
		return Game.Myself
	end
	return self.userMap[guid]
end

function NSceneUserProxy:SyncMove(data)
	local role = self:FindOtherRole(data.charid)
	if nil ~= role then
		role:Server_MoveToXYZCmd(data.pos.x,data.pos.y,data.pos.z)
		return true
	end
	return false
end

function NSceneUserProxy:SyncServerSkill(data)
	if nil ~= data.petid and 0 ~= data.petid then
		if 0 < data.petid then
			return self:SyncServerPetSkill(data)
		else
			if not self:NotifyUseSkill(data) then
				return NSceneUserProxy.super.SyncServerSkill(self,data)
			end
		end
	else
		-- if(data.charid ==Game.Myself.data.id) then
		-- 	local skillConfig = Table_Skill[data.skillID]
		-- 	if(skillConfig.SkillType == GameConfig.SkillType.Purify.type) then
		-- 		FunctionPurify.Me():StartPurifyByServerSkill(data)
		-- 	end
		-- 	return true
		-- else
		-- 	return NSceneUserProxy.super.SyncServerSkill(self,data)
		-- end
		return NSceneUserProxy.super.SyncServerSkill(self,data)
	end
end

function NSceneUserProxy:Add(data,classRef)
	local role = nil
	if Game.Myself.data.id == data.guid then
		-- helplog("设置自己的称号： ",tostring(data.achievetitle))
		Game.Myself.data:SetAchievementtitle(data.achievetitle)
		role = Game.Myself
		--是我自己
		role.data:SetTeamID(data.teamid)
		-- self:HandleConnectRole(data.lines)
		role:InitBuffs(data,false)
		GameFacade.Instance:sendNotification(MyselfEvent.AddBuffs,data.buffs)
		role:Server_SetUserDatas(data.datas,true)
	else
		role = self:Find(data.guid)
		if nil ~= role then
			return role
		end
		role = NPlayer.CreateAsTable(data)
		self.userMap[data.guid] = role
		self:CountPlus()

		if(data.dest ~= nil and not PosUtil.IsZero(data.dest)) then
			role:Server_MoveToXYZCmd(data.dest.x,data.dest.y,data.dest.z,1000)
		end
	end
	self:HandleAddScenicBuffs(data)
	local spEffectDatas = data.speffectdata
	if nil ~= spEffectDatas then
		for i=1, #spEffectDatas do
			role:Server_AddSpEffect(spEffectDatas[i])
		end
	end
	SceneAINpcProxy.Instance:AddHandNpc(role, data.handnpc , data.pos)
	SceneAINpcProxy.Instance:AddExpressNpc(role, data.givenpcdatas, data.pos)
	return role
end

local tmpRoles = {}
function NSceneUserProxy:PureAddSome(datas)
	for i = 1, #datas do
		if datas[i] ~= nil then
			local role = self:Add(datas[i])
			if(role ~=nil) then
				tmpRoles[#tmpRoles+1] = role
				-- table.insert(roles,role)
			end
		end
	end
	GameFacade.Instance:sendNotification(SceneUserEvent.SceneAddRoles,tmpRoles)
	EventManager.Me():PassEvent(SceneUserEvent.SceneAddRoles, tmpRoles)

	SceneCarrierProxy.Instance:PureAddSome(datas)
	TableUtility.TableClear(tmpRoles)
end

--attention：array 需要在使用完毕清空内容
function NSceneUserProxy:FindCreateByGuild(guild,array)
	TableUtility.TableClear(array)
	for k,user in pairs(self.userMap) do
		local guildData = user.data:GetGuildData()
		if(guildData and guildData.id == guild)then
			array[#array+1] = user
		end
	end
	if(Game.Myself.data and Game.Myself.data:GetGuildData())then
		local selfData = Game.Myself.data:GetGuildData()
		if(selfData and selfData.id == guild)then
			array[#array+1] = Game.Myself
		end
	end
end

function NSceneUserProxy:RemoveSome(guids)
	local roles = NSceneUserProxy.super.RemoveSome(self,guids)
	if(roles and #roles >0) then
		GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveRoles,roles)
		EventManager.Me():PassEvent(SceneUserEvent.SceneRemoveRoles, roles)
		self:HandleRemoveScenicBuffs(roles)
	end
end

local tempPos = LuaVector3.zero

function NSceneUserProxy:FindNearUsers(position,distance,filter)
	tempPos:Set(position[1],position[2],position[3])
	local list = {}
	for k,user in pairs(self.userMap) do
		if nil == filter or filter(user) then
			local dist = LuaVector3.Distance(user:GetPosition(),tempPos)
			if distance >= dist then
				table.insert(list,user)
			end
		end
	end
	return list
end

function NSceneUserProxy:Clear()
	print("清空场景玩家")
	local clears = NSceneUserProxy.super.Clear(self)
	if(clears and #clears >0) then
		GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveRoles,clears)
		EventManager.Me():PassEvent(SceneUserEvent.SceneRemoveRoles, clears)
	end
end

function NSceneUserProxy:AddScenicBuff(guid,buffId)
	local buffData = Table_Buffer[buffId]
	if(buffData and buffData.BuffEffect.type == "Scenery")then
		local data = FunctionScenicSpot.Me():AddCreatureScenicSpot(guid,buffData.BuffEffect.scenic)
		if(data)then
			GameFacade.Instance:sendNotification(MiniMapEvent.CreatureScenicAdd,{data})
		end
	end
end


local tempArray = {}
function NSceneUserProxy:HandleAddScenicBuffs(serverData)
	TableUtility.ArrayClear(tempArray)
	local buffDatas = serverData.buffs
	if(buffDatas and #buffDatas>0) then
		for i=1,#buffDatas do
			local scenic = self:AddScenicBuff(serverData.guid,buffDatas[i].id)			
			if(scenic)then
				tempArray[#tempArray+1] = scenic
			end
		end
	end	
end

function NSceneUserProxy:RemoveScenicBuff(guid,buffId)
	local ssId = nil
	if(buffId)then
		local buffData = Table_Buffer[buffId]
		if(buffData and buffData.BuffEffect.type == "Scenery")then
			ssId = buffData.BuffEffect.scenic
			FunctionScenicSpot.Me():RemoveCreatureScenicSpot(guid,ssId)
		end
	end
	
	-- GameFacade.Instance:sendNotification(AdventureDataEvent.SceneItemsUpdate,ssId)
end

function NSceneUserProxy:HandleRemoveScenicBuffs(guids)
	for i=1,#guids do
		-- self:RemoveScenicBuff(guids[i])
		FunctionScenicSpot.Me():RemoveCreatureScenicSpot(guids[i])
	end	
end