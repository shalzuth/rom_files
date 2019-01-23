IdleAI_FakeDead = class("IdleAI_FakeDead")

local UpdateInterval = 0.5
local TryUseSkillInterval = 1
local check
local FindCreature = SceneCreatureProxy.FindCreature

local Hp_Min = 10.0
local Sp_Min = 10.0

local Hp_Max = 90.0
local Sp_Max = 90.0

local FakeState = {
	None = 0,
	RequestFakeDead = 1,
	InFakeDead = 2,
	RequestFakeDead_Off = 3,
}

function IdleAI_FakeDead:ctor()
	self.nextUpdateTime = 0
	self.nextTryTime = 0
	self.state = FakeState.None
end

function IdleAI_FakeDead:Clear(idleElapsed, time, deltaTime, creature)
	self.nextUpdateTime = 0
	self.nextTryTime = 0
	self.state = FakeState.None
end

function IdleAI_FakeDead:Prepare(idleElapsed, time, deltaTime, creature)
	if nil ~= creature.ai.parent then
		return false
	end

	self.myself = Game.Myself
	if(self.myselfProps == nil) then
		self.myselfProps = Game.Myself.data and Game.Myself.data.props
	end

	--变身无法释放
	if(self.myself.data:IsTransformed()) then
		return false
	end

	if(Game.AutoBattleManager.on) then
		if(self.on) then
			if(self.state ~= FakeState.None) then
				return true
			end
			if(not self.myself:IsFakeDead()) then
				local props = self.myselfProps
				if nil ~= props then
					-- hp/sp lower than 10%
					local maxHP = props.MaxHp:GetValue()
					local HP = props.Hp:GetValue()

					local maxSP = props.MaxSp:GetValue()
					local SP = props.Sp:GetValue()

					if HP <= Hp_Min/100.0*maxHP or SP <= Sp_Min/100.0*maxSP then
						if(self.skillID~=nil and self.skillID>0) then
							if(SkillProxy.Instance:SkillCanBeUsedByID(self.skillID)) then
								-- helplog("auto fake dead")
								return true
							end
						end
					end
				end
			else
				self.state = FakeState.InFakeDead
				return true
			end
		end
	end
	return false
end

function IdleAI_FakeDead:_TryUseSkill(time,interval)
	if time < self.nextTryTime then
		return
	end
	self.nextTryTime = time + interval
	FunctionSkill.Me():TryUseSkill(self.skillID)
end

function IdleAI_FakeDead:Start(idleElapsed, time, deltaTime, creature)
	self.nextTryTime = 0
	-- helplog("IdleAI_FakeDead:Start")
	if(self.state == FakeState.None) then
		self.state = FakeState.RequestFakeDead
	end
end

function IdleAI_FakeDead:End(idleElapsed, time, deltaTime, creature)
	self.nextTryTime = 0
	-- helplog("IdleAI_FakeDead:End")
	self.state = FakeState.None
end

function IdleAI_FakeDead:Update(idleElapsed, time, deltaTime, creature)
	if time < self.nextUpdateTime then
		return true
	end
	self.nextUpdateTime = time + UpdateInterval

	if(self.state == FakeState.RequestFakeDead) then
		if(self.myself:IsFakeDead()) then
			self.state = FakeState.InFakeDead
		else
			self:_TryUseSkill(time,TryUseSkillInterval)
		end
	elseif(self.state == FakeState.InFakeDead) then
		if(not self.myself:IsFakeDead()) then
			return false
		end
		local props = self.myselfProps
		if nil ~= props then
			-- hp/sp lower than 10%
			local maxHP = props.MaxHp:GetValue()
			local HP = props.Hp:GetValue()

			local maxSP = props.MaxSp:GetValue()
			local SP = props.Sp:GetValue()

			if HP >= Hp_Max/100.0*maxHP and SP >= Sp_Max/100.0*maxSP then
				if(self.skillID~=nil and self.skillID>0) then
					if(SkillProxy.Instance:SkillCanBeUsedByID(self.skillID)) then
						self:_TryUseSkill(time,TryUseSkillInterval)
						return true
					end
				end
			end
		end
	end
	return true
end

function IdleAI_FakeDead:_Set(on)
	self.on = on
	if self.on then
	else
	end
end

function IdleAI_FakeDead:Set_AutoFakeDead(skillID)
	self.skillID = skillID
	if(self.skillID~=nil and self.skillID>0) then
		self:_Set(true)
	else
		self:_Set(false)
	end
end