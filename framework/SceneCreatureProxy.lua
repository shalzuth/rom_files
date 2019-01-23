autoImport("SceneObjectProxy")
SceneCreatureProxy = class('SceneCreatureProxy', SceneObjectProxy)

SceneCreatureProxy.Instance = nil;

SceneCreatureProxy.NAME = "SceneCreatureProxy"

SceneCreatureProxy.FADE_IN_OUT_DURATION = 1
SceneCreatureProxy.SampleInterval = 0

--场景玩家（可见玩家）数据管理，添加、删除、查找玩家

function SceneCreatureProxy:ctor(proxyName, data)
	self.proxyName = proxyName or SceneCreatureProxy.NAME
	self:CountClear()
	self.userMap = {}
	self.addMode = SceneObjectProxy.AddMode.Normal
	if(SceneCreatureProxy.Instance == nil) then
		SceneCreatureProxy.Instance = self
	end
	
	if data ~= nil then
		self:setData(data)
	end
end

function SceneCreatureProxy.FindCreature(guid)
	local target = NSceneUserProxy.Instance:Find(guid)
	if(target==nil) then
		target = NSceneNpcProxy.Instance:Find(guid)
		if target == nil then
			target = NScenePetProxy.Instance:Find(guid)
			if target == nil then
				target = SceneAINpcProxy.Instance:Find(guid)
			end
		end
	end
	return target
end

function SceneCreatureProxy.FindOtherCreature(guid)
	local myself = Game.Myself
	if(myself and myself.data and guid == myself.data.id) then
		return nil
	end
	local target = NSceneUserProxy.Instance:Find(guid)
	if(target==nil) then
		target = NSceneNpcProxy.Instance:Find(guid)
		if target == nil then
			target = NScenePetProxy.Instance:Find(guid)
		end
	end
	return target
end

function SceneCreatureProxy.ResetPos(guid,pos,isgomap)
	if(guid == 0) then
		guid = Game.Myself.data.id
	end
	if(SceneCarrierProxy.Instance:CreatureIsInCarrier(guid)) then
		errorLog(string.format("玩家%s已在载具中，服务器通知重设位置",guid))
	else
		if(guid == Game.Myself.data.id) then
			MyselfProxy.Instance:ResetMyPos(pos.x,pos.y,pos.z,isgomap)
		else
			local creature = SceneCreatureProxy.FindCreature(guid)
			if(creature) then
				creature:Server_SetPosXYZCmd(pos.x,pos.y,pos.z,1000)
			end
		end
	end
end

function SceneCreatureProxy.ForEachCreature(func, args)
	if NSceneUserProxy.Instance:ForEach(func, args) then
		return
	end
	if NSceneNpcProxy.Instance:ForEach(func, args) then
		return
	end
	-- ScenePetProxy.Instance:ForEach(func)
	if nil ~= Game.Myself then
		func(Game.Myself,args)
	end
end

-- function SceneCreatureProxy.CallCreatureSampleInterval(creature)
-- 	creature:SetSampleInterval(SceneCreatureProxy.SampleInterval)
-- end

-- function SceneCreatureProxy.SetCreatureSampleInterval(sampleInterval)
-- 	if SceneCreatureProxy.SampleInterval == sampleInterval then
-- 		return
-- 	end
-- 	SceneCreatureProxy.SampleInterval = sampleInterval
-- 	SceneCreatureProxy.ForEachCreature(SceneCreatureProxy.CallCreatureSampleInterval)
-- end

-- function SceneCreatureProxy.CallCreaturePerformance(creature)
-- 	if nil ~= creature.roleAgent then
-- 		RoleUtil.PerformanceSetting(creature.roleAgent, SceneCreatureProxy.PerformanceSetting)
-- 	end
-- 	local partner = creature:GetPartner()
-- 	if nil ~= partner and nil ~= partner.followerRole then
-- 		RoleUtil.PerformanceSetting(partner.followerRole, SceneCreatureProxy.PerformanceSetting)
-- 	end
-- end

-- function SceneCreatureProxy.SetCreaturePerformance(setting)
-- 	SceneCreatureProxy.PerformanceSetting = setting
-- 	SceneCreatureProxy.ForEachCreature(SceneCreatureProxy.CallCreaturePerformance)
-- 	local localNPCManager = NPCPointManagerLocal.Instance
-- 	if nil ~= localNPCManager then
-- 		for roleAgent in Slua.iter(localNPCManager.roleList) do 
-- 			RoleUtil.PerformanceSetting(roleAgent, SceneCreatureProxy.PerformanceSetting)
-- 		end
-- 	end
-- end

function SceneCreatureProxy:Add(data)
	return nil
end

function SceneCreatureProxy:SetProps(guid,attrs,update)
	local creature = self:Find(guid)
	-- print("creature change props.."..guid)
	if(creature~=nil) then
		creature:SetProps(attrs,update)
	end
end

function SceneCreatureProxy:PureAddSome(datas)
	local roles = {}
	for i = 1, #datas do
		if datas[i] ~= nil then
			local role = self:Add(datas[i])
			if(role ~=nil) then
				roles[#roles+1] = role
				-- table.insert(roles,role)
			end
		end
	end
	return roles
end

local S2C_Number = ProtolUtility.S2C_Number
function SceneCreatureProxy:ParsePhaseData(serverSkillBroadCastData)
	if(self.phasedata == nil) then
		self.phasedata = SkillPhaseData.Create(serverSkillBroadCastData.skillID)
	else
		self.phasedata:Reset(serverSkillBroadCastData.skillID)
	end
	self.phasedata:ParseFromServer(serverSkillBroadCastData)
end

--同步技能
function SceneCreatureProxy:SyncServerSkill(data)
	self:ParsePhaseData(data)
	if(SkillPhase.DelayHit == self.phasedata:GetSkillPhase() 
		or SkillPhase.Hit == self.phasedata:GetSkillPhase()) then
		SkillLogic_Base.HitTargetByPhaseData(self.phasedata, data.charid)
		return true
	else
		local role = self:Find(data.charid)
		if nil ~= role and Game.Myself ~= role then
			role:Server_SyncSkill(self.phasedata)
			return true
		end
	end
	return false
end

--使用技能
function SceneCreatureProxy:NotifyUseSkill(data)
	local creature = self:Find(data.charid)
	if nil ~= creature and creature == Game.Myself 
		and nil ~= data.petid and 0 > data.petid then
		if SkillPhase.None == data.data.number then
			-- break skill
			creature:Server_BreakSkill(data.skillID)
			return true
		end
		local phaseDataCustom = data.data
		local targetID,targetCreature,targetPosition
		if(phaseDataCustom.hitedTargets and 0 < #phaseDataCustom.hitedTargets) then
			targetID = phaseDataCustom.hitedTargets[1].charid
			targetCreature = SceneCreatureProxy.FindCreature(targetID)
		else
			targetPosition = ProtolUtility.S2C_Vector3(phaseDataCustom.pos)
		end
		creature:Server_UseSkill(data.skillID, targetCreature, targetPosition)
		if(targetPosition) then
			targetPosition:Destroy()
		end
		-- creature:Server_SyncSkill(self.phasedata)
		return true
	end
	return false
end

function SceneCreatureProxy:SyncServerPetSkill(data)
	local role = self:Find(data.charid)
	if nil ~= role and nil ~= role.partner then
		-- LogUtility.Info("老鹰同步技能")
		self:ParsePhaseData(data)
		role.partner:Server_SyncSkill(self.phasedata)
		return true
	end
	return false
end

function SceneCreatureProxy:Die(guid, creature)
	-- print("npc死亡。"..guid)
	local role = creature
	if nil == creature then
		role = self:Find(guid)
	end
	if(role~=nil) then
		-- print(role.roleAgent)
		if Creature_Type.Me == role.creatureType then
			role.roleAgent:Die()
		else
			RoleControllerInterface.ServerDie(role.roleAgent)
		end
	end
	return role
end

function SceneCreatureProxy:DieWithoutAction(guid, creature)
	-- print("npc死亡。"..guid)
	local role = creature
	if nil == creature then
		role = self:Find(guid)
	end
	if(role~=nil) then
		-- print(role.roleAgent)
		if Creature_Type.Me == role.creatureType then
			role.roleAgent:DieWithoutAction()
		else
			RoleControllerInterface.ServerDieWithoutAction(role.roleAgent)
		end
	end
	return role
end

-- my id in AddRole:77309412473 need add:77309412334

function SceneCreatureProxy:reLive(guid)
	-- print("npc死亡。"..guid)
	local role = self:Find(guid)
	if(role~=nil) then
		if Creature_Type.Me == role.creatureType then
			role.roleAgent:Revive()
		else
			RoleControllerInterface.ServerRevive(role.roleAgent)
		end
	end
	-- body
end

function SceneCreatureProxy:Remove(guid, fade)
	-- print("移除场景生物:"..guid)
	local creature = self.userMap[guid]
	if(creature ~=nil) then
		self.userMap[guid] = nil
		creature:Destroy()
		self:CountMinus()
		EventManager.Me():DispatchEvent(SceneCreatureEvent.CreatureRemove,guid)
		-- if fade then
		-- 	Scene.Instance:RemoveRoleFade(guid, SceneCreatureProxy.FADE_IN_OUT_DURATION)
		-- else
		-- 	Scene.Instance:RemoveRole(guid)
		-- end
		return true
	end
	-- test AssetRole begin
	-- NSceneUserProxy.Instance:Remove(guid)
	-- test AssetRole end
	return false
end

function SceneCreatureProxy:Clear()
	-- print("清空场景生物")
	self.removeSomes = (self.removeSomes and self.removeSomes or {})
	TableUtility.ArrayClear(self.removeSomes)
	self:ChangeAddMode(SceneCreatureProxy.AddMode.Normal)
	for id, o in pairs(self.userMap) do
		EventManager.Me():DispatchEvent(SceneCreatureEvent.CreatureRemove,id)
		self.removeSomes[#self.removeSomes+1] = id
		self.userMap[id] = nil
		o:Destroy()
 	end
 	return self.removeSomes
 	-- GameFacade.Instance:sendNotification(SceneUserEvent.SceneRemoveRoles,roles)
end

function SceneCreatureProxy:CountPlus(num)
	num = num and num or 1
 	self.currentCount = self.currentCount + num
 	-- stack(self.__cname..self.currentCount)
 	self:OnCountChanged()
end

function SceneCreatureProxy:CountMinus(num)
	num = num and num or 1
 	self.currentCount = math.max(0,self.currentCount - num)
 	-- stack(self.__cname..self.currentCount)
 	self:OnCountChanged()
end

function SceneCreatureProxy:CountClear()
 	self.currentCount = 0
 	-- stack(self.__cname..self.currentCount)
 	self:OnCountChanged()
end

function SceneCreatureProxy:GetCount()
	return self.currentCount
end

function SceneCreatureProxy:OnCountChanged()
end

function SceneCreatureProxy:ForEach(func, args)
	if nil ~= self.userMap then
		for k,v in pairs(self.userMap) do
			if func(v, args) then
				return true
			end
		end
	end
	return false
end