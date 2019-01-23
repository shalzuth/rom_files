SkillBase = class("SkillBase")

local FindCreature = SceneCreatureProxy.FindCreature
local CreatureHideOpt = Asset_Effect.DeActiveOpt.CreatureHide
local AttackDurationLimit = 3
-- local AttackDurationLimit_Adjust = 1/30
local AttackDurationLimit_NoAction = 1

local AttackWorker = {
	[1] = nil,
	[2] = autoImport("SkillAttackWorker_Dive"),
	[3] = autoImport("SkillAttackWorker_MissileFrom"),
	[4] = autoImport("SkillAttackWorker_Dash"),
}

local tempEffectArray = {}

function SkillBase:ctor()
	self.info = nil
	self.visible = true
	self.phaseData = SkillPhaseData.Create(0)
	self.oldPhase = SkillPhase.None
	self.fireIndex = 1
	self.fireCount = 1
	self.instanceID = 1
	self.effects = {}
	self.ses = {}
	self.comboDamageLabels = {}
	self.attackWorker = nil
	self.attackTimeElapsed = -1
	self.attackTimeDuration = -1
	self.running = false
end

function SkillBase:OnDelayHit(creature, phaseData)
	
end

function SkillBase:SetEffectVisible( visible )
	if(self.visible ~= visible) then
		self.visible = visible
		local effect
		for i=1,#self.effects do
			effect = self.effects[i]
			if(effect~=nil) then
				effect:SetActive(self.visible,CreatureHideOpt)
			end
		end
	end
end

function SkillBase:Speak(creature)
	-- LogUtility.InfoFormat("<color=yellow>Speak: </color>skillID={0}, attackSkillID={1}", 
	-- 	self.info:GetSkillID(), creature.data:GetAttackSkillIDAndLevel())
	if self:IsAttackSkill(creature) then
		return
	end

	local skillName = self.info:GetSpeakName(creature)
	if nil == skillName then
		return
	end

	local sceneUI = creature:GetSceneUI()
	if nil ~= sceneUI then
		sceneUI.roleTopUI:Speak(skillName)
	end
end

-- interface begin
function SkillBase:GetSkillID()
	return self.info:GetSkillID()
end

function SkillBase:SetSkillID(skillID)
	if 0 ~= skillID then
		self.info = Game.LogicManager_Skill:GetSkillInfo(skillID)
		Debug_AssertFormat((nil ~= self.info and nil ~= self.info.LogicClass), "Skill or LogicClass is nil: {0}", skillID)
	else
		self.info = nil
	end
end

function SkillBase:GetCastTime(creature)
	local castTime,_ = self.info:GetCastInfo(creature)
	return castTime
end

function SkillBase:IsAttackSkill(creature)
	return nil ~= creature.data and creature.data:GetAttackSkillIDAndLevel() == self.info:GetSkillID()
end

function SkillBase:AddEffect(effect)
	if(false == self.visible and effect~=nil) then
		effect:SetActive(self.visible,CreatureHideOpt)
	end
	TableUtility.ArrayPushBack(self.effects, effect)
	effect:RegisterWeakObserver(self)
end

function SkillBase:ObserverDestroyed(effect) -- for effects
	TableUtility.ArrayRemove(self.effects, effect)
end

function SkillBase:AddSE(se)
	TableUtility.ArrayPushBack(self.ses, se)
end

function SkillBase:CreateComboDamageLabel(i)
	local comboDamageLabel = self.comboDamageLabels[i]
	if nil == comboDamageLabel then
		comboDamageLabel = SceneUIManager.Instance:GetStaticHurtLabelWorker()
		comboDamageLabel:AddRef()
		self.comboDamageLabels[i] = comboDamageLabel
	end
	return comboDamageLabel
end

function SkillBase:GetComboDamageLabel(i)
	return self.comboDamageLabels[i]
end

function SkillBase:Fire(creature)
	if not self.running then
		return
	end

	if self.fireIndex > self.fireCount then
		return
	end

	-- multi fire no combo damage By ZhangShenlin
	-- if 1 < self.fireCount then
	-- 	self:_CreateComboDamageLabels(creature)
	-- end

	local LogicClass = self.info.LogicClass
	LogicClass.Fire(self, creature)

	self.fireIndex = self.fireIndex + 1
	if self.fireIndex > self.fireCount then
		self:_BeNotDieBlocker()
	end
end

function SkillBase:End(creature)
	if not self.running then
		return
	end
	self:_End(creature)
end
-- interface end

function SkillBase:_OnPhaseChanged(creature)
	local newPhase = self.phaseData:GetSkillPhase()
	if self.oldPhase == newPhase then
		return
	end
	-- LogUtility.InfoFormat("<color=yellow>Skill Phase Change: </color>{0}, {1}-->{2}", 
	-- 	self.phaseData:GetSkillID(),
	-- 	self.oldPhase,
	-- 	newPhase)

	if SkillPhase.Cast == newPhase then
		self:_OnLaunch(creature)
		creature:Logic_CastBegin()
	else
		if SkillPhase.Cast == self.oldPhase then
			creature:Logic_CastEnd()
		end
		if SkillPhase.Attack == newPhase then
			if SkillPhase.Cast ~= self.oldPhase then
				self:_OnLaunch(creature)
			end
			self:_OnAttack(creature)
		end 
	end
	self.oldPhase = newPhase
end

function SkillBase:_OnLaunch(creature)
	self:Speak(creature)
end

function SkillBase:_OnAttack(creature)

end

function SkillBase:_BeDieBlocker(creature)
	local phaseData = self.phaseData
	local targetCount = phaseData:GetTargetCount()
	if 0 < targetCount then
		for i=1, targetCount do
			local guid,_,__ = phaseData:GetTarget(i)
			local creature = FindCreature(guid)
			if nil ~= creature and not creature:IsDead() then
				creature.ai:SetDieBlocker(self)
			end
		end
	end
end

function SkillBase:_BeNotDieBlocker(creature)
	local phaseData = self.phaseData
	local targetCount = phaseData:GetTargetCount()
	if 0 < targetCount then
		for i=1, targetCount do
			local guid,_,__ = phaseData:GetTarget(i)
			local creature = FindCreature(guid)
			if nil ~= creature then
				creature.ai:ClearDieBlocker(self)
			end
		end
	end
end

function SkillBase:_DestroyEffects(creature)
	TableUtility.ArrayShallowCopy(tempEffectArray, self.effects)
	TableUtility.ArrayClear(self.effects)
	for i=#tempEffectArray, 1, -1 do
		tempEffectArray[i]:Destroy()
		tempEffectArray[i] = nil
	end
end

function SkillBase:_DestroySEs(creature)
	for i=#self.ses, 1, -1 do
		self.ses[i]:Stop()
		self.ses[i] = nil
	end
end

function SkillBase:_CreateComboDamageLabels(creature)
	if 0 < #self.comboDamageLabels then
		return
	end
	local targetCount = self.phaseData:GetTargetCount()
	if 0 < targetCount then
		local labels = self.comboDamageLabels
		for i=1, targetCount do
			labels[i] = SceneUIManager.Instance:GetStaticHurtLabelWorker()
			labels[i]:AddRef()
		end
	end
end

function SkillBase:_DestroyComboDamageLabels(creature)
	if 0 < #self.comboDamageLabels then
		local labels = self.comboDamageLabels
		for i=#labels, 1, -1 do
			labels[i]:SubRef()
			labels[i] = nil
		end
	end
end

function SkillBase:_Clear(creature)
	self:_BeNotDieBlocker(creature)
	self:_DestroyEffects(creature)
	self:_DestroySEs(creature)
	self:_DestroyComboDamageLabels(creature)
	if nil ~= self.attackWorker then
		self.attackWorker:End(self, creature)
		self.attackWorker:Destroy()
		self.attackWorker = nil
	end
	self.fireIndex = 1
	self.fireCount = 1
end

function SkillBase:_SwitchToCast(creature)
	local LogicClass = self.info.LogicClass
	self.instanceID = self.instanceID+1
	if LogicClass.Cast(self, creature) then
		self.running = true
		self:_OnPhaseChanged(creature)
	else
		self:_End(creature)
	end
end

function SkillBase:_SwitchToAttack(creature)
	local preAttackParams = self.info:GetPreAttackParams(creature)
	if nil ~= preAttackParams then
		self.fireIndex = self.fireIndex + 1 -- pre-attack worker hit target, it's a real fire

		local attackWorkerClass = AttackWorker[preAttackParams.type]
		local worker = attackWorkerClass.Create(preAttackParams)
		if worker:Start(self, creature) then
			self.attackWorker = worker
			self.running = true
			self:_BeDieBlocker(creature)
			self:_OnPhaseChanged(creature)
		else
			worker:Destroy()
			self:_End(creature)
		end
		return
	end

	local LogicClass = self.info.LogicClass
	self.instanceID = self.instanceID+1
	local ret, actionPlayed, attackSpeed = LogicClass.Attack(self, creature)
	if self:_CheckAttackResult(ret, actionPlayed, attackSpeed) then
		self.running = true
		if not actionPlayed and self.info:NoAction(creature) then
			self:Fire(creature)
			self.attackTimeDuration = 0
		end
		self:_BeDieBlocker(creature)
		self:_OnPhaseChanged(creature)
	else
		self:_End(creature)
	end
end

function SkillBase:_CheckAttackResult(ret, actionPlayed, attackSpeed)
	if ret then
		self.attackTimeElapsed = 0
		if actionPlayed then
			-- if nil ~= attackSpeed and 1 < attackSpeed then
			-- 	self.attackTimeDuration = 1/attackSpeed - AttackDurationLimit_Adjust
			-- else
				self.attackTimeDuration = AttackDurationLimit
			-- end
		else
			self.attackTimeDuration = AttackDurationLimit_NoAction
		end
	end
	return ret
end

function SkillBase:_End(creature)
	-- if SkillPhase.Attack == self.phaseData:GetSkillPhase() 
	-- 	and self.fireIndex <= self.fireCount then
	-- 	-- Fire
	-- end
	self:_Clear(creature)
	self.running = false
	self:_OnPhaseChanged(creature)
end

function SkillBase:Update_Cast(time, deltaTime, creature)
	return self.info.LogicClass.Update_Cast(self, time, deltaTime, creature)
end

function SkillBase:Update_Attack(time, deltaTime, creature)
	local ret = false
	if nil ~= self.attackWorker then
		ret = self.attackWorker:Update(self, time, deltaTime, creature)
	else
		ret = self.info.LogicClass.Update_Attack(self, time, deltaTime, creature)
	end
	if ret then
		if 0 <= self.attackTimeElapsed then
			-- wait for self.attackTimeDuration second
			self.attackTimeElapsed = self.attackTimeElapsed + deltaTime
			if self.attackTimeDuration <= self.attackTimeElapsed then
				self.attackTimeElapsed = -1
				return false
			end
		end
	end
	return ret
end

function SkillBase:Update(time, deltaTime, creature)
	if not self.running then
		return
	end
	local skillPhase = self.phaseData:GetSkillPhase()
	if SkillPhase.Cast == skillPhase then
		if not self:Update_Cast(time, deltaTime, creature) and self.running then
			self:_SwitchToAttack(creature)
		end
	elseif SkillPhase.Attack == skillPhase then
		if not self:Update_Attack(time, deltaTime, creature) then
			self:_End(creature)
		end
	end
end