ServerSkill = class("ServerSkill", SkillBase)

local FindCreature = SceneCreatureProxy.FindCreature

function ServerSkill:ctor()
	ServerSkill.super.ctor(self)
end

function ServerSkill:GetCastTime(creature)
	return self.phaseData:GetCastTime()
end

function ServerSkill:SetPhase(phaseData, creature)
	-- LogUtility.InfoFormat("<color=green>{0} Use Skill: </color>{1}\n{2}", 
	-- 	creature.data and creature.data:GetName() or "No Name",
	-- 	phaseData:GetSkillID(),
	-- 	phaseData:GetSkillPhase())
	-- local targetCount = phaseData:GetTargetCount()
	-- local logString = LogUtility.StringFormat("Targets: {0}\n", targetCount)
	-- for i=1, targetCount do
	-- 	local guid, damageType, damage, shareDamageInfos = phaseData:GetTarget(i)
	-- 	local targetCreature = SceneCreatureProxy.FindCreature(guid)
	-- 	logString = LogUtility.StringFormat("{0}{1}, {2}\n", 
	-- 		logString, 
	-- 		LogUtility.StringFormat("({0}, {1})", 
	-- 			targetCreature and targetCreature.data and targetCreature.data:GetName() or "Null", 
	-- 			guid),
	-- 		LogUtility.StringFormat("{0}, {1}", 
	-- 			damageType, 
	-- 			damage))
	-- end
	-- LogUtility.Info(logString)
	
	if 0 == phaseData:GetSkillID() then
		LogUtility.InfoFormat("<color=red>[{0}] ServerSkill:SetPhase: </color>skillID=0",
			creature.data and creature.data:GetName() or "No Name")
		return false
	end
	local skillPhase = phaseData:GetSkillPhase()
	if SkillPhase.Cast == skillPhase then
		self:_TryBeAutoLocked(phaseData, creature)
		self:_TryRefreshHatred(phaseData, creature)
		self:_SetPhaseData(phaseData, creature)
		self:_SwitchToCast(creature)
		if self.running then
			return true, true
		end
	elseif SkillPhase.Attack == skillPhase then
		self:_TryBeAutoLocked(phaseData, creature)
		self:_TryRefreshHatred(phaseData, creature)
		self:_SetPhaseData(phaseData, creature)
		if nil ~= self.phaseData 
			and nil ~= self.info 
			and SkillTargetType.Point == self.info:GetTargetType(creature) then
			self.phaseData:SamplePosition()
		end
		self:_SwitchToAttack(creature)
		if self.running then
			return true, false
		end
	elseif SkillPhase.None == skillPhase then
		if self.phaseData:GetSkillID() == phaseData:GetSkillID() then
			self:_SetPhaseData(phaseData, creature)
			self:_End(creature)
		end
	end
	return false
end

function ServerSkill:OnDelayHit(creature, phaseData)
	self:_TryBeAutoLocked(phaseData, creature)
	self:_TryRefreshHatred(phaseData, creature)
end

function ServerSkill:_TryBeAutoLocked(phaseData, creature)
	local targetCount = phaseData:GetTargetCount()
	if 0 >= targetCount then
		return
	end
	if nil ~= creature.data then
		if RoleDefines_Camp.ENEMY == creature.data:GetCamp() then
			-- try auto lock
			if nil == Game.Myself:GetLockTarget() then
				local myselfID = Game.Myself.data.id
				for i=1, targetCount do
					local targetID = phaseData:GetTarget(i)
					if targetID == myselfID then
						Game.Myself:Client_LockTarget(creature)
						break
					end
				end
			end
		else
			-- try refresh follow master target
			if Game.Myself:Client_GetFollowLeaderID() == creature.data.id then
				for i=1, targetCount do
					local targetID = phaseData:GetTarget(i)
					local targetCreature = FindCreature(targetID)
					if nil ~= targetCreature and RoleDefines_Camp.ENEMY == targetCreature.data:GetCamp() then
						-- LogUtility.InfoFormat("<color=yellow>Client_SetFollowLeaderTarget: </color>{0}, {1}", 
						-- 	targetID, targetCreature.data:GetName())
						Game.Myself:Client_SetFollowLeaderTarget(targetID, Time.time)
						break
					end
				end
			end
		end
	end
end

function ServerSkill:_TryRefreshHatred(phaseData, creature)
	local targetCount = phaseData:GetTargetCount()
	if 0 >= targetCount then
		return
	end
	if nil ~= creature.data and RoleDefines_Camp.ENEMY == creature.data:GetCamp() then
		if TeamProxy.Instance:IHaveTeam() then
			local myTeam = TeamProxy.Instance.myTeam
			for i=1, targetCount do
				local targetID = phaseData:GetTarget(i)
				if nil ~= myTeam:GetMemberByGuid(targetID) then
					-- refresh hatred
					creature:BeHatred(true, Time.time)
					break
				end
			end
		end
	end
end

function ServerSkill:_SetPhaseData(phaseData, creature)
	-- 1. 
	self:_Clear(creature)
	-- 2.
	if nil ~= phaseData then
		self:SetSkillID(phaseData:GetSkillID())
		phaseData:CopyTo(self.phaseData)
	else
		self:SetSkillID(0)
		self.phaseData:Reset(0)
	end
end

-- override begin
function ServerSkill:_End(creature)
	self.phaseData:SetSkillPhase(SkillPhase.None)
	ServerSkill.super._End(self, creature)
end

function ServerSkill:_CheckAttackResult(ret, actionPlayed)
	if ret and actionPlayed then
		return ServerSkill.super._CheckAttackResult(self, ret, actionPlayed)
	end
	return false
end

function ServerSkill:Update_Cast(time, deltaTime, creature)
	return true
end
-- override end