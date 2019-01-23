autoImport("Creature_SceneUI")
NNpc = reusableClass("NNpc",NCreatureWithPropUserdata)
NNpc.PoolSize = 100

autoImport("NNpc_Effect")
autoImport("NNpc_Logic")

local ForceRemoveDelay = 3
local SmoothRemoveDuration = 0.3

local MonsterDressDisableDistanceLevel = 1

function NNpc:ctor(aiClass)
	NNpc.super.ctor(self,aiClass)
	self.sceneui = nil
	self.userDataManager = Game.LogicManager_Npc_Userdata
	self.propmanager = Game.LogicManager_Npc_Props
	self.skill = ServerSkill.new()
	self.originalRotation = nil
end

function NNpc:GetCreatureType()
	return Creature_Type.Npc
end

function NNpc:GetSceneUI()
	return self.sceneui
end

function NNpc:Server_SetDirCmd(mode,dir,noSmooth)
	if(self.originalRotation == nil and mode == AI_CMD_SetAngleY.Mode.SetAngleY) then
		self.originalRotation = dir
	end
	self.ai:PushCommand(FactoryAICMD.GetSetAngleYCmd(mode,dir,noSmooth), self)
end

function NNpc:InitAssetRole()
	NNpc.super.InitAssetRole(self)
	local assetRole = self.assetRole

	assetRole:SetGUID( self.data.id )
	assetRole:SetName( self.data:GetOriginName() )
	assetRole:SetClickPriority(self.data:GetClickPriority())

	if self.data.staticData==nil then
		do return end
	end	

	assetRole:SetShadowEnable( self.data.staticData.move ~= 1 )
	assetRole:SetColliderEnable( not self.data:NoAccessable() )
	assetRole:SetInvisible(false)
	assetRole:SetWeaponDisplay( true )
	assetRole:SetMountDisplay( true )
	assetRole:SetRenderEnable( true )
	assetRole:SetActionSpeed(1)
	-- assetRole:SetActionConfig(Game.Config_NPCAction)
	-- assetRole:PlayAction(name, defaultName, speed, normalizedTime, force)
	local defaultGear = self.data:GetDefaultGear()
	if nil ~= defaultGear then
		local actionName = string.format("state%d", defaultGear)
		assetRole:PlayAction_Simple(actionName)
	end
end

function NNpc:SetDressEnable(v)
end

function NNpc:GetDressParts()
	if(not self:IsDressEnable()) then
		return NSceneNpcProxy.Instance:GetNpcEmptyParts(),true
	end
	local parts = self.data:GetDressParts()
	return parts,not self.data.useServerDressData
end

local superServer_SetPosCmd = NNpc.super.Server_SetPosCmd
function NNpc:Server_SetPosCmd(p,ignoreNavMesh)
	superServer_SetPosCmd(self,p,self.data:GetFeature_IgnoreNavmesh())
end

-- local superServer_MoveToCmd = NNpc.super.Server_MoveToCmd
-- function NNpc:Server_MoveToCmd(p,ignoreNavMesh)
-- 	superServer_MoveToCmd(self,p,self.data:GetFeature_IgnoreNavmesh())
-- end

function NNpc:Init(serverData)
	self:InitAssetRole()
	self:InitLogicTransform(serverData.pos.x,serverData.pos.y,serverData.pos.z,nil,1)
	self:Server_SetUserDatas(serverData.datas,true)
	self:Server_SetAttrs(serverData.attrs)
	self.sceneui = Creature_SceneUI.CreateAsTable(self)

	if(serverData.isbirth) then
		local BirthTime = self.data.staticData.BirthTime
		if(BirthTime and BirthTime>0) then
			--出生的话播出生动画
			self:Server_PlayActionCmd(Asset_Role.ActionName.Born,nil,false,false,BirthTime)
		end
	else
		--如果有actionID 尝试播放
		local actionid = serverData.motionactionid
		if(actionid and actionid~=0) then
			local actionData = Table_ActionAnime[actionid]
			if actionData then
				local actionName = actionData.Name
				self:Server_PlayActionCmd(actionName)
			end
		end
	end

	self:InitBuffs(serverData)

	--目标点
	local dest = serverData.dest
	if(dest and not PosUtil.IsZero(dest)) then
		self:Server_MoveToXYZCmd(dest.x,dest.y,dest.z,1000)
	end
	local npc = Table_Monster[serverData.npcID] or Table_Npc[serverData.npcID]
	if(npc and npc.SE) then
		self.assetRole:PlaySEOneShotOn(npc.SE[math.random(1,#npc.SE)])
	end
	if(serverData.fadein and serverData.fadein>0) then
		if(self.assetRole) then
			--设置自动出现时间为0，复用我们的时间
			self.assetRole:SetSmoothDisplayBody(0)
			local to = self.data.userdata:Get(UDEnum.ALPHA) or 1
			self.assetRole:AlphaFromTo(0,to,serverData.fadein/1000)
		end
	end
end

function NNpc:ShowViewRange(range)
	if nil == self.effectControllerViewRange then
		self.effectControllerViewRange = ViewRangeEffect.CreateAsTable(self.data.id)
	end

	if nil ~= self.effectControllerViewRange then
		self.effectControllerViewRange:ShowRange(range)
	end
end

function NNpc:ParseServerData(serverData)
	return NpcData.CreateAsTable(serverData)
end

function NNpc:SetDelayRemove(delayTime,duration)
	-- LogUtility.InfoFormat("NNpc:SetDelayRemove {0} {1} {2}",self.data:GetName(),delayTime,duration )
	if nil ~= self.delayRemoveTimeFlag then
		return
	end
	self.smoothRemoving = false
	if(delayTime) then
		self:SetClickable(false)
		self.delayRemoveTimeFlag = Time.time + delayTime
		self.fadeOutRemoveDuration = duration or SmoothRemoveDuration
	else
		self.delayRemoveTimeFlag = nil
		self.fadeOutRemoveDuration = nil
	end
end

local superUpdate = NNpc.super.Update
function NNpc:Update(time, deltaTime)
	superUpdate(self,time,deltaTime)
	if(self.delayRemoveTimeFlag~=nil) then
		if(time >= self.delayRemoveTimeFlag) then
			if not self.smoothRemoving then
				if nil ~= self.forceRemoveTimeFlag then
					if time < self.forceRemoveTimeFlag 
						and self.ai:IsDiePending() then
						return
					end
				else
					if self.ai:IsDiePending() then
						self.forceRemoveTimeFlag = time + ForceRemoveDelay
						return
					end
				end
				self.smoothRemoving = true
				local duration = self.fadeOutRemoveDuration or SmoothRemoveDuration
				self.delayRemoveTimeFlag = self.delayRemoveTimeFlag+ duration
				self.assetRole:AlphaTo(0, duration)
			else
				self:_DelayDestroy()
			end
		end
	end
end

function NNpc:_DelayDestroy()
	if(not NSceneNpcProxy.Instance:RealRemove(self.data.id,true)) then
		self:Destroy()
	end
end

function NNpc:GetDressDisableDistanceLevel()
	if self.data:IsMonster() then
		return MonsterDressDisableDistanceLevel
	end
	return NNpc.super.GetDressDisableDistanceLevel(self)
end


function NNpc:SetSkillNpc(skillConfig)
	if(skillConfig) then
		self.sourceSkill = skillConfig
		local funcType = skillConfig.Logic_Param.function_type
		if(funcType == "Bi_Transport") then
			self:_AddSkillTransportTrigger()
		end
	else
		self:_EndSkillNpc()
	end
end

function NNpc:_EndSkillNpc()
	if(self.sourceSkill) then
		local funcType = self.sourceSkill.Logic_Param.function_type
		if(funcType == "Bi_Transport") then
			self:_RemoveSkillTransportTrigger()
		end
		self.sourceSkill = nil
	end
end

local triggerData = {}
function NNpc:_AddSkillTransportTrigger()
	triggerData.id = self.data.id
	triggerData.type = AreaTrigger_Skill.Transport
	triggerData.creature = self
	triggerData.reachDis = self.sourceSkill.Logic_Param.range
	local trigger = SkillAreaTrigger.CreateAsTable(triggerData)
	Game.AreaTrigger_Skill:AddCheck(trigger)
	TableUtility.TableClear(triggerData)
end

function NNpc:_RemoveSkillTransportTrigger()
	Game.AreaTrigger_Skill:RemoveCheck(self.data.id)
end

-- override begin
function NNpc:DoConstruct(asArray, serverData)
	self:CreateWeakData()
	local data = self:ParseServerData(serverData)
	NNpc.super.DoConstruct(self,asArray,data)
	self:Init(serverData)
	--cullingGrp
	self:RegistCulling()
end

function NNpc:DoDeconstruct(asArray)
	self:_EndSkillNpc()
	self:UnRegistCulling()
	NNpc.super.DoDeconstruct(self,asArray)
	self.delayRemoveTimeFlag = nil
	self.fadeOutRemoveDuration = nil
	self.forceRemoveTimeFlag = nil
	self.smoothRemoving = false
	if(self.effectControllerViewRange~=nil) then
		self.effectControllerViewRange:Destroy()
		self.effectControllerViewRange = nil
	end
	self.originalRotation = nil
	self.sceneui:Destroy()
	self.sceneui = nil
	self.assetRole:Destroy()
	self.assetRole = nil
end
-- override end