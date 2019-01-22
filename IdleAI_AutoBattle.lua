IdleAI_AutoBattle = class("IdleAI_AutoBattle")

local UpdateInterval = 0.1
local FindCreature = SceneCreatureProxy.FindCreature

function IdleAI_AutoBattle:ctor()
	self.autoBattle = AutoBattle.new()
	self.skillInfo = nil
	self.skillNoTarget = false
	self.skillLaunchRange = 0
	self.targetFilter = function (target)
		if nil ~= target then
			if nil ~= self.skillInfo and not self.skillNoTarget then
				if self.skillInfo:CheckTarget(Game.Myself, target) then
					if self.standing and 0 < self.skillLaunchRange then
						local dist = VectorUtility.DistanceXZ(
							target:GetPosition(), 
							Game.Myself:GetPosition())
						if dist > self.skillLaunchRange then
							return false
						end
					end
					return true
				end
			else
				if not target:IsDead()
					and not target.data:NoAccessable() then
					return true
				end
			end
		end
		return false
	end

	self.on = false
	self.requestOn = nil
	self.lockID = 0
	self.protectTeam = false
	self.standing = false
	self.currentTargetGUID = 0

	self.nextUpdateTime = 0
end

function IdleAI_AutoBattle:Clear(idleElapsed, time, deltaTime, creature)
	self.autoBattle:Reset()
	self.nextUpdateTime = 0
end

function IdleAI_AutoBattle:Prepare(idleElapsed, time, deltaTime, creature)
	if nil ~= creature.ai.parent then
		return false
	end
	-- if FunctionCameraEffect.Me():Bussy() then
	-- 	return false
	-- end
	if nil ~= self.requestOn then
		local on = self.requestOn
		self.requestOn = nil
		self:_Set(on)
	end
	return self.on
end

function IdleAI_AutoBattle:Start(idleElapsed, time, deltaTime, creature)
	
end

function IdleAI_AutoBattle:End(idleElapsed, time, deltaTime, creature)

end

function IdleAI_AutoBattle:Update(idleElapsed, time, deltaTime, creature)
	if time < self.nextUpdateTime then
		return true
	end
	self.nextUpdateTime = time + UpdateInterval

	if 0 ~= self.lockID then
		if creature.data:NoAttack() then
			return true
		end

		local ret, skillIDAndLevel, noTarget, forceLockCreature, skillInfo = self.autoBattle:Attack_Step1(creature)
		if not ret then
			return true
		end

		-- LogUtility.InfoFormat("<color=yellow>AutoLockTarget 1: </color>skill={0}, noTarget={1}, forceLockCreature={2}", 
		-- 	skillIDAndLevel,
		-- 	noTarget,
		-- 	forceLockCreature and forceLockCreature.data:GetName() or "nil")
		
		if nil ~= forceLockCreature then
			self.autoBattle:Attack_Step2(
				creature, 
				nil, 
				skillIDAndLevel, 
				noTarget, 
				forceLockCreature, 
				skillInfo, 
				false,
				true)
			return true
		end

		local targetCreature = self:GetLockTarget(creature, skillInfo, noTarget)
		-- LogUtility.InfoFormat("<color=yellow>AutoLockTarget 2: </color>targetCreature={0}, NoTargetAutoCast={1}", 
		-- 	targetCreature and targetCreature.data:GetName() or "nil",
		-- 	skillInfo:NoTargetAutoCast(creature))
		if nil ~= targetCreature then
			self.autoBattle:Attack_Step2(
				creature, 
				targetCreature, 
				skillIDAndLevel, 
				noTarget, 
				forceLockCreature, 
				skillInfo, 
				false,
				true)
		else
			-- onlyNoTargetAutoCast
			if skillInfo:NoTargetAutoCast(creature) then
				self.autoBattle:Attack_Step2(
					creature, 
					targetCreature, 
					skillIDAndLevel, 
					noTarget, 
					forceLockCreature, 
					skillInfo, 
					true,
					true)
			-- else
			-- 	self.autoBattle:Attack(creature, targetCreature, nil, true)
			end
		end
	else
		self.autoBattle:Update(creature, nil, nil, true)
	end
	return true
end

function IdleAI_AutoBattle:_Set(on)
	-- if self.on == on then
	-- 	return
	-- end
	-- if on and FunctionCameraEffect.Me():Bussy() then
	-- 	return
	-- end
	self.on = on
	if self.on then
		self.ignoreAutoBattle = true
		Game.AutoBattleManager:SetController(self)
		self.ignoreAutoBattle = nil
		
		if Game.AutoBattleManager.on then
			local eventManager = EventManager.Me()
			eventManager:DispatchEvent(
				AutoBattleManagerEvent.StateChanged, 
				Game.AutoBattleManager)
		else
			Game.AutoBattleManager:AutoBattleOn()
		end
	else
		self.lockID = 0
		self.currentTargetGUID = 0
		self.protectTeam = false
		self.standing = false
		Game.AutoBattleManager:ClearController(self, true)
	end
end

function IdleAI_AutoBattle:GetLockTarget(creature, skillInfo, noTarget)
	self.skillInfo = skillInfo
	if nil ~= skillInfo then
		if SkillTargetType.Creature == skillInfo:GetTargetType(self) then
			self.skillNoTarget = false
		else
			self.skillNoTarget = noTarget or false
		end
		self.skillLaunchRange = skillInfo:GetLaunchRange(creature)
	else
		self.skillNoTarget = false
		self.skillLaunchRange = 0
	end

	local lockedTarget = creature:GetLockTarget()
	if nil ~= lockedTarget 
		and nil ~= lockedTarget.data 
		and nil ~= lockedTarget.data.staticData
		and self.lockID == lockedTarget.data.staticData.id
		and self.targetFilter(lockedTarget) then
		self.currentTargetGUID = 0
		self.skillInfo = nil
		self.skillNoTarget = false
		self.skillLaunchRange = 0
		-- LogUtility.DebugInfoFormat(
		-- 	lockedTarget.assetRole.complete,
		-- 	"<color=yellow>GetLockTarget 1: </color>{0}", 
		-- 	lockedTarget.data:GetName())
		return lockedTarget
	end

	local targetCreature = nil
	if 0 ~= self.currentTargetGUID then
		targetCreature = FindCreature(self.currentTargetGUID)
		if nil ~= targetCreature then
			if self.targetFilter(targetCreature) then
				self.skillInfo = nil
				self.skillNoTarget = false
				self.skillLaunchRange = 0
				-- LogUtility.DebugInfoFormat(
				-- 	targetCreature.assetRole.complete,
				-- 	"<color=yellow>GetLockTarget 2: </color>{0}", 
				-- 	targetCreature.data:GetName())
				return targetCreature
			else
				targetCreature = nil
			end 
		else
			self.currentTargetGUID = 0
		end
	end

	local randomRange = nil
	if nil ~= skillInfo then
		randomRange = skillInfo:GetLaunchRange(creature)
		if 0 >= randomRange then
			randomRange = AutoBattle.SearchRandomDistance
		end
	else
		randomRange = AutoBattle.SearchRandomDistance
	end
	targetCreature = NSceneNpcProxy.Instance:FindNearestNpc(
		creature:GetPosition(), 
		self.lockID, 
		self.targetFilter,
		randomRange)
	if nil ~= targetCreature then
		-- LogUtility.DebugInfoFormat(
		-- 	targetCreature.assetRole.complete,
		-- 	"<color=yellow>GetLockTarget 3: </color>{0}, in range {1}", 
		-- 	targetCreature.data:GetName(),
		-- 	randomRange)
		self.currentTargetGUID = targetCreature.data.id
	end

	self.skillInfo = nil
	self.skillNoTarget = false
	self.skillLaunchRange = 0
	return targetCreature
end

function IdleAI_AutoBattle:SearchLockTarget(creature, skillInfo, noTarget)
	self.skillInfo = skillInfo
	if nil ~= skillInfo then
		if SkillTargetType.Creature == skillInfo:GetTargetType(self) then
			self.skillNoTarget = false
		else
			self.skillNoTarget = noTarget or false
		end
		self.skillLaunchRange = skillInfo:GetLaunchRange(creature)
	else
		self.skillNoTarget = false
		self.skillLaunchRange = 0
	end

	local randomRange = nil
	if nil ~= skillInfo then
		randomRange = skillInfo:GetLaunchRange(creature)
		if 0 >= randomRange then
			randomRange = AutoBattle.SearchRandomDistance
		end
	else
		randomRange = AutoBattle.SearchRandomDistance
	end
	targetCreature = NSceneNpcProxy.Instance:FindNearestNpc(
		creature:GetPosition(), 
		self.lockID, 
		self.targetFilter,
		randomRange)
	if nil ~= targetCreature then
		-- LogUtility.DebugInfoFormat(
		-- 	targetCreature.assetRole.complete,
		-- 	"<color=yellow>SearchLockTarget: </color>{0}, in range {1}", 
		-- 	targetCreature.data:GetName(),
		-- 	randomRange)
		self.currentTargetGUID = targetCreature.data.id
	else
		self.currentTargetGUID = 0
	end

	self.skillInfo = nil
	self.skillNoTarget = false
	self.skillLaunchRange = 0
	return targetCreature
end

function IdleAI_AutoBattle:IsProtectingTeam(creature)
	return self.on and self.protectTeam
end

function IdleAI_AutoBattle:IsStanding(creature)
	return self.on and self.standing
end

-- control begin
function IdleAI_AutoBattle:Request_ClearCurrentTarget()
	self.currentTargetGUID = 0
end
function IdleAI_AutoBattle:Request_SetLockID(lockID)
	self.lockID = lockID
	if 0 == lockID then
		self.currentTargetGUID = 0
	end
end
function IdleAI_AutoBattle:Request_SetProtectTeam(on)
	self.protectTeam = on
end
function IdleAI_AutoBattle:Request_SetStanding(on)
	self.standing = on
end
function IdleAI_AutoBattle:Request_Set(on)
	-- if on and FunctionCameraEffect.Me():Bussy() then
	-- 	return
	-- end
	self.requestOn = on
end

-- auto battle manager begin
function IdleAI_AutoBattle:AutoBattleOn()
	if self.ignoreAutoBattle then
		return
	end
	if nil ~= self.requestOn then
		if self.requestOn then
			return
		end
	else
		if self.on then
			return
		end
	end
	Game.Myself.ai:SetAuto_Battle(true, Game.Myself)
end

function IdleAI_AutoBattle:AutoBattleOff()
	if self.ignoreAutoBattle then
		return
	end
	if nil ~= self.requestOn then
		if not self.requestOn then
			return
		end
	else
		if not self.on then
			return
		end
	end
	local myself = Game.Myself
	local myAI = myself.ai
	myAI:SetAuto_Battle(false, myself)
end

function IdleAI_AutoBattle:AutoBattleLost()
	if self.on then
		self:_Set(false)
	end
end
-- auto battle manager end
-- ocontrol end