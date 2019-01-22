NMyselfPlayer = reusableClass("NMyselfPlayer",NPlayer)
NMyselfPlayer.WeakKey_LockTarget = "WeakKey_LockTarget"
NMyselfPlayer.WeakKey_AttackTarget = "WeakKey_AttackTarget"
NMyselfPlayer.WeakKey_AccessTarget = "WeakKey_AccessTarget"


autoImport("NMyselfPlayer_Effect")
autoImport("NMyselfPlayer_Client")
autoImport("NMyselfPlayer_Logic")
autoImport("FakeDeadLogic")

local ArroundRange = 100

function NMyselfPlayer:ctor()
	NMyselfPlayer.super.ctor(self,AI_Myself)
	self.fakeDeadLogic = FakeDeadLogic.new(self)
	self.cannotUseSkillChecker = ConditionCheck.new()
	self.userDataManager = Game.LogicManager_Myself_Userdata
	self.propmanager = Game.LogicManager_Myself_Props
	self.skill = ClientSkill.new()
	self:CreateWeakData()
end
function NMyselfPlayer:GetCreatureType()
	return Creature_Type.Me
end

function NMyselfPlayer:InitLogicTransform()
	self.logicTransform:SetOwner(self)
	self.logicTransform:SetMoveSpeed(self.data:ReturnMoveSpeedWithFactor(moveSpeed))
	self.logicTransform:SetRotateSpeed(self.data:ReturnRotateSpeedWithFactor(rotateSpeed))
	self.logicTransform:SetScaleSpeed(self.data:ReturnScaleSpeedWithFactor(scaleSpeed))
end

function NMyselfPlayer:GetLockTarget()
	return self:GetWeakData(NMyselfPlayer.WeakKey_LockTarget)
end

function NMyselfPlayer:IsAutoBattleProtectingTeam()
	return self.ai:IsAutoBattleProtectingTeam(self)
end

function NMyselfPlayer:IsAutoBattleStanding()
	return self.ai:IsAutoBattleStanding(self)
end

-- cmds begin
local tmpVector3 = LuaVector3.zero
function NMyselfPlayer:Server_SetPosXYZCmd(x,y,z,div)
	tmpVector3:Set(x,y,z)
	-- local pos = LuaVector3(x,y,z)
	if(div~=nil) then
		tmpVector3:Div(div)
	end
	self:Server_SetPosCmd(tmpVector3)
	-- pos:Destroy()
end

function NMyselfPlayer:Server_SetPosCmd(p,ignoreNavMesh)
	self.ai:PushCommand(FactoryAICMD.Me_GetPlaceToCmd(p,ignoreNavMesh), self)
end

function NMyselfPlayer:Server_PlayActionCmd(name,normalizedTime,loop,fakeDead,forceDuration)
	self.ai:PushCommand(FactoryAICMD.Me_GetPlayActionCmd(name,normalizedTime,loop,fakeDead,forceDuration), self)
end

function NMyselfPlayer:Server_DieCmd(noaction)
	self.ai:PushCommand(FactoryAICMD.Me_GetDieCmd(noaction), self)
end

function NMyselfPlayer:Server_ReviveCmd(name,normalizedTime,loop)
end

function NMyselfPlayer:Server_SetScaleCmd(scale,noSmooth)
	self.data.bodyScale = scale
	local scaleX,scaleY,scaleZ = self:GetScaleWithFixHW()
	self.ai:PushCommand(FactoryAICMD.Me_GetSetScaleCmd(scaleX,scaleY,scaleZ,noSmooth), self)
end

function NMyselfPlayer:Server_SetDirCmd(mode,dir,noSmooth)
	self.ai:PushCommand(FactoryAICMD.Me_GetSetAngleYCmd(mode,dir,noSmooth), self)
end

function NMyselfPlayer:Server_SyncSkill(phaseData)
	-- do nothing
end

function NMyselfPlayer:Server_UseSkill(skillID, targetCreature, targetPosition)
	self:Client_UseSkill(skillID, targetCreature, targetPosition, nil, nil, nil, nil, true)
end

function NMyselfPlayer:Server_BreakSkill(skillID)
	if self.skill:GetSkillID() == skillID then
		self.disableSkillBroadcast = true
		self.skill:InterruptCast(self)
		self.disableSkillBroadcast = false
	end
end

function NMyselfPlayer:Server_CameraFlash()
	-- do nothing
end

function NMyselfPlayer:Server_SetHandInHand(masterID, running)
	helplog("Server_SetHandInHand:", masterID, running);
	if self.ai:GetFollowLeaderID(self) == masterID then
		self.ai:SetAuto_FollowHandInHandState(running, self)
	end
end
function NMyselfPlayer:Server_SetDoubleAction(masterID, running)
	helplog("NMyselfPlayer Server_SetDoubleAction", masterID, running);
	self.doubleaction_build = running;
end

function NMyselfPlayer:PlayDoubleAction(isMaster)
	if(isMaster)then
		self.ai:TryBreakAll(Time.time, Time.deltaTime, self);
	end
	NMyselfPlayer.super.PlayDoubleAction(self, isMaster);
end

function NMyselfPlayer:Server_GetOnSeat(seatID)
	local isCustom = Game.SceneSeatManager:SeatIsCustom(seatID)
	if(isCustom) then
		FunctionSystem.InterruptMyselfAll()
		self.ai:PushCommand(FactoryAICMD.GetGetOnSeatCmd(seatID), self)
	end
end
-- cmds end

local superUpdate = NMyselfPlayer.Update
function NMyselfPlayer:Update(time, deltaTime)
	self.fakeDeadLogic:Update(time,deltaTime)
	superUpdate(self,time,deltaTime)
end

function NMyselfPlayer:_UpdateArroundMyself(time, deltaTime)
	-- do nothing
end

function NMyselfPlayer:InitAssetRole()
	NMyselfPlayer.super.InitAssetRole(self)
	local assetRole = self.assetRole

	assetRole:SetGUID( self.data.id )
	assetRole:SetName( self.data:GetName() )
	assetRole:SetShadowEnable( true )
	assetRole:SetColliderEnable( false )
	assetRole:SetWeaponDisplay( true )
	assetRole:SetMountDisplay( true )
	assetRole:SetRenderEnable( true )
	assetRole:SetActionSpeed(1)
	--????????????????????????Npc
	-- if(self.data.props.TransformID:GetValue()~= 0) then
	-- 	assetRole:SetActionConfig(Game.Config_NPCAction)
	-- else
	-- 	assetRole:SetActionConfig(Game.Config_PlayerAction)
	-- end

	assetRole:DontDestroyOnLoad()
	LuaLuancher.Instance.myself = self.assetRole.complete
end

function NMyselfPlayer:GetDressParts()
	return self.data:GetDressParts()
end

function NMyselfPlayer:AllowDress()
	return true
end

function NMyselfPlayer:GetArroundLevel(p, distance)
	if nil == distance then
		distance = VectorUtility.DistanceXZ(self:GetPosition(), p)
	end
	if(distance<=0) then
		return 1
	end
	if ArroundRange > distance then
		local moveSpeed = self.logicTransform:GetMoveSpeed()
		if 0 >= moveSpeed then
			moveSpeed = 1
		end
		return math.ceil(distance * 2 / moveSpeed) -- cross time(seconds)
	end 
	return 0
end

function NMyselfPlayer:InitSet()
end

function NMyselfPlayer:EnterScene()
	--????????????partner
	self.sceneui = Creature_SceneUI.CreateAsTable(self)
	self:TryRecreatePartner()
	if(self.enterScencePausedIdleAI) then
		self.enterScencePausedIdleAI = false
		self:Client_ResumeIdleAI()
	end
end

function NMyselfPlayer:LeaveScene()
	EventManager.Me():PassEvent(MyselfEvent.LeaveScene)
	if(self.sceneui) then
		self.sceneui:Destroy()
		self.sceneui = nil
	end
	self:RemoveObjsWhenLeaveScene()
	if(not self.enterScencePausedIdleAI) then
		self.enterScencePausedIdleAI = true
		self:Client_PauseIdleAI()
	end
end

function NMyselfPlayer:RemoveObjsWhenLeaveScene()
	self:_ClearTrackEffects()
	self:RemovePartner()
	self:RemoveHandNpc()
	self:ClearExpressNpc()
end

function NMyselfPlayer:SetPartner(id)
	NMyselfPlayer.super.SetPartner(self,id)
	if(self.partner) then
		EventManager.Me():PassEvent(MyselfEvent.PartnerChange,id)
	else
		EventManager.Me():PassEvent(MyselfEvent.PartnerChange,nil)
	end
end

function NMyselfPlayer:TryRecreatePartner()
	local partnerID = self.data.userdata:Get(UDEnum.PET_PARTNER)
	if(partnerID and partnerID>0) then
		self:SetPartner(partnerID)
	end
end

function NMyselfPlayer:OnAvatarPriorityChanged()
	-- do nothing
end

function NMyselfPlayer:RegisterRoleDress()
	-- do nothing
end
function NMyselfPlayer:UnregisterRoleDress()
	-- do nothing
end

function NMyselfPlayer:RegistCulling()
	-- do nothing
end
function NMyselfPlayer:UnRegistCulling()
	-- do nothing
end

-- override begin
function NMyselfPlayer:DoConstruct(asArray, data)
	NMyselfPlayer.super.super.DoConstruct(self,asArray,data)
	self:InitAssetRole()
	self:InitLogicTransform()
end

function NMyselfPlayer:DoDeconstruct(asArray)
	NMyselfPlayer.super.DoDeconstruct(self,asArray)
	self.cannotUseSkillChecker:Reset()
end

function NMyselfPlayer:OnObserverDestroyed(k, obj)
	NMyselfPlayer.super.OnObserverDestroyed(self,k,obj)
	if(k == NMyselfPlayer.WeakKey_LockTarget) then
		self:Client_LockTarget(nil)
	end
end
-- override end