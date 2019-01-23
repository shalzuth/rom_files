
local tempVector3 = LuaVector3.zero

function NCreature:Logic_PlayAction(params)
	if self.data and self.data:Freeze() then
		return false
	end
	if nil == params[3] then -- speed
		params[3] = 1
	end
	if nil == params[2] then
		params[2] = self:GetIdleAction()
	end
	self.assetRole:PlayAction(params)
	return true
end

function NCreature:Logic_PlayAction_Simple(name, defaultName, speed)
	if self.data and self.data:Freeze() then
		return false
	end
	if nil == speed then
		speed = 1
	end
	if nil == defaultName then
		defaultName = self:GetIdleAction()
	end
	self.assetRole:PlayAction_Simple(name, defaultName, speed)
	return true
end

function NCreature:Logic_PlayAction_Idle()
	return self:Logic_PlayAction_Simple(self:GetIdleAction())
end

function NCreature:Logic_PlayAction_Move()
	if self.data and self.data:Freeze() then
		return false
	end
	local name = self:GetMoveAction()

	local moveActionScale = 1
	local staticData = self.data.staticData
	if nil ~= staticData and nil ~= staticData.MoveSpdRate then
		moveActionScale = staticData.MoveSpdRate
	end

	local moveSpeed = self.data.props.MoveSpd:GetValue()
	-- local fastForwardSpeed = self.logicTransform:GetFastForwardSpeed()
	local actionSpeed = moveActionScale * moveSpeed-- * fastForwardSpeed
	self.assetRole:PlayAction_Simple(name, nil, actionSpeed)
	return true
end

function NCreature:Logic_PlaceXYZTo(x,y,z)
	tempVector3:Set(x,y,z)
	self:Logic_PlaceTo(tempVector3)
end

function NCreature:Logic_PlaceTo(p)
	self.logicTransform:PlaceTo(p)
end

function NCreature:Logic_NavMeshPlaceXYZTo(x,y,z)
	tempVector3:Set(x,y,z)
	self:Logic_NavMeshPlaceTo(tempVector3)
end

function NCreature:Logic_NavMeshPlaceTo(p)
	self.logicTransform:NavMeshPlaceTo(p)
end

function NCreature:Logic_MoveTo(p)
	self.logicTransform:MoveTo(p)
end

function NCreature:Logic_NavMeshMoveTo(p)
	return self.logicTransform:NavMeshMoveTo(p)
end

function NCreature:Logic_StopMove()
	self.logicTransform:StopMove()
end

function NCreature:Logic_SamplePosition(time)
	self.logicTransform:SamplePosition()
end

function NCreature:Logic_SetAngleY(v)
	self.logicTransform:SetAngleY(v)
end

function NCreature:Logic_Hit(action, stiff)
	self.ai:PushCommand(FactoryAICMD.GetHitCmd(false, action, stiff), self)
end

function NCreature:Logic_DeathBegin()
	
end

-- function NCreature:Logic_DeathEnd() -- not called
	
-- end

function NCreature:Logic_CastBegin()
	EventManager.Me():DispatchEvent(SkillEvent.SkillCastBegin, self)
end

function NCreature:Logic_CastEnd()
	EventManager.Me():DispatchEvent(SkillEvent.SkillCastEnd, self)
end

function NCreature:Logic_Freeze(on)
	if (not on) then
		on = self.data:WeakFreeze()
	end
	
	if on then
		self.assetRole:SetActionSpeed(0)
	else
		self.assetRole:SetActionSpeed(1)
	end
end

function NCreature:Logic_NoAct(on)
	if on and not self.data:Freeze() then
		self:Logic_PlayAction_Idle()
	end
end

function NCreature:Logic_FearRun(on)
end

local CreatureFollowTarget = "CreatureFollowTarget"
function NCreature:Logic_GetFollowTarget()
	return self:GetWeakData(CreatureFollowTarget)
end

function NCreature:Logic_CanUseSkill()
	return true
end