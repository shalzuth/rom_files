AI_Base = class("AI_Base")

local tempVector3 = LuaVector3.zero

function AI_Base:ctor()
	self.dieBlockers = {}
	self.idleAIManager = IdleAIManager.new()
	self:_InitIdleAI(self.idleAIManager)
	self._alive = false
end

function AI_Base:Construct(creature)
	if self._alive then
		return
	end
	self._alive = true
	self.parent = nil
	self.prevPosition = nil
	self.prevAngleY = nil
	self.prevScale = nil
	self.idle = false
	self.idleElapsed = 0
	self.idleAction = nil

	self.requestClear = false
end

function AI_Base:Deconstruct(creature)
	if not self._alive then
		return
	end
	self:_Clear(0,0,creature)
	self._alive = false
end

function AI_Base:_InitIdleAI(idleAIManager)
	
end

function AI_Base:_Idle(time, deltaTime, creature)
	if nil ~= self.parent then
		return false
	end

	-- if creature:IsFakeDead() then
	-- 	return false
	-- end
	local creatureData = creature.data
	if creatureData:Freeze()
		or creatureData:NoAct() then
		return false
	end

	if not self.idle then
		self.idle = true
		self.idleElapsed = 0

		self:_PlayIdleAction(time, deltaTime, creature)
	else
		self.idleElapsed = self.idleElapsed + deltaTime
	end
	self:_IdleAIUpdate(time, deltaTime, creature)
	return true
end

function AI_Base:_PlayIdleAction(time, deltaTime, creature)
	-- LogUtility.InfoFormat("<color=yellow>[{0}] PlayIdleAction: </color>{1}", 
	-- 	creature.data and creature.data:GetName() or "No Name",
	-- 	LogUtility.ToString(self.idleAction))
	if nil ~= self.idleAction then
		if "none" ~= self.idleAction then
			creature:Logic_PlayAction_Simple(self.idleAction)
		end
		self.idleAction = nil
	else
		creature:Logic_PlayAction_Idle()
	end
end

function AI_Base:_IdleBreak(time, deltaTime, creature)
	if not self.idle then
		return
	end
	self.idle = false
	self.idleElapsed = 0
	self.idleAIManager:Break(self.idleElapsed, time, deltaTime, creature)
end

function AI_Base:_IdleAIUpdate(time, deltaTime, creature)
	return self.idleAIManager:Update(self.idleElapsed, time, deltaTime, creature)
end

function AI_Base:SetParent(parentTransform, creature)
	if self.parent == parentTransform then
		return
	end
	self.parent = parentTransform
	creature.assetRole:SetParent(self.parent, true)

	-- if nil ~= self.parent then
		-- reset when no parent
		if nil ~= self.prevPosition then
			self.prevPosition:Destroy()
			self.prevPosition = nil
		end
		self.prevAngleY = nil 
		self.prevScale = nil 
		creature.assetRole:SetPosition(LuaGeometry.Const_V3_zero)
		creature.assetRole:SetEulerAngles(LuaGeometry.Const_V3_zero)
		creature.assetRole:SetScale(LuaGeometry.Const_V3_one)
	-- end
end

function AI_Base:PauseIdleAI(creature)
	self.idleAIManager:Pause(creature)
end

function AI_Base:ResumeIdleAI(creature)
	self.idleAIManager:Resume(creature)
end

function AI_Base:SetIdleAction(action)
	self.idleAction = action
end

function AI_Base:SetNoIdleAction()
	self.idleAction = "none"
end

function AI_Base:DieBlocked()
	return 0 < #self.dieBlockers
end

function AI_Base:SetDieBlocker(blocker)
	-- LogUtility.InfoFormat("<color=red>SetDieBlocker: </color>{0}",
	-- 	LogUtility.ToString(blocker))
	TableUtility.ArrayPushBack(self.dieBlockers, blocker)
end

function AI_Base:ClearDieBlocker(blocker)
	-- LogUtility.InfoFormat("<color=red>ClearDieBlocker: </color>{0}",
	-- 	LogUtility.ToString(blocker))
	TableUtility.ArrayRemove(self.dieBlockers, blocker)
end

-- request begin
function AI_Base:Clear(time, deltaTime, creature)
	self.requestClear = true
end
-- request end

function AI_Base:_Clear(time, deltaTime, creature)
	self.requestClear = false
	self:SetParent(nil, creature)
	self.idleAIManager:Clear(self.idleElapsed, time, deltaTime, creature)
	TableUtility.ArrayClear(self.dieBlockers)
	if nil ~= self.prevPosition then
		self.prevPosition:Destroy()
		self.prevPosition = nil
	end
	self.prevAngleY = nil
	if nil ~= self.prevScale then
		self.prevScale:Destroy()
		self.prevScale = nil
	end
end

function AI_Base:SyncLogicTransform(time, deltaTime, creature)
	local logicTransform = creature.logicTransform
	local assetRole = creature.assetRole

	if nil == self.prevPosition 
		or not LuaVector3.Equal(self.prevPosition, logicTransform.currentPosition) then
		assetRole:SetPosition(logicTransform.currentPosition)
		self.prevPosition = VectorUtility.Asign_3(self.prevPosition, logicTransform.currentPosition)
	end

	if self.prevAngleY ~= logicTransform.currentAngleY then
		assetRole:SetEulerAngleY(logicTransform.currentAngleY)
		self.prevAngleY = logicTransform.currentAngleY
	end

	if nil == self.prevScale 
		or not LuaVector3.Equal(self.prevScale, logicTransform.currentScale) then
		local s = logicTransform.currentScale
		assetRole:SetScaleXYZ(s[1],s[2],s[3])
		self.prevScale = VectorUtility.Asign_3(self.prevScale, logicTransform.currentScale)
	end
end

function AI_Base:Update(time, deltaTime, creature)
	local oldIdleAction = self.idleAction
	self:_DoRequest(time, deltaTime, creature)
	self:_DoUpdate(time, deltaTime, creature)
	self:_DoRequest(time, deltaTime, creature)
	if oldIdleAction == self.idleAction then
		self.idleAction = nil -- clear idleAction per frame
	end
end

function AI_Base:_DoUpdate(time, deltaTime, creature)
	local parent = self.parent
	-- sync
	local logicTransform = creature.logicTransform
	if nil ~= parent then
		tempVector3:Set(LuaGameObject.GetPosition(parent))
		logicTransform:PlaceTo(tempVector3)
	end

	local assetRole = creature.assetRole
	if nil ~= parent then
		-- do nothing
	else
		if nil == self.prevPosition 
			or not VectorUtility.AlmostEqual_3(self.prevPosition, logicTransform.currentPosition) then
			-- if 0 == logicTransform.currentPosition[1]
			-- 	and 0 == logicTransform.currentPosition[2]
			-- 	and 0 == logicTransform.currentPosition[3] then
			-- 	LogUtility.DebugInfo(creature.assetRole.complete, "<color=red>current position is zero</color>")
			-- end
			assetRole:SetPosition(logicTransform.currentPosition)
			self.prevPosition = VectorUtility.Asign_3(self.prevPosition, logicTransform.currentPosition)
		end
	end

	-- if nil ~= parent then
	-- 	tempVector3:Set(LuaGameObject.GetEulerAngles(parent))
	-- 	if nil ~= logicTransform.currentAngleY then
	-- 		tempVector3[2] = NumberUtility.Repeat(tempVector3[2]+logicTransform.currentAngleY, 360)
	-- 	end
	-- 	assetRole:SetEulerAngles(tempVector3)
	-- else
		if nil == self.prevAngleY 
			or not NumberUtility.AlmostEqual(self.prevAngleY, logicTransform.currentAngleY) then
			assetRole:SetEulerAngleY(logicTransform.currentAngleY)
			self.prevAngleY = logicTransform.currentAngleY
		end
	-- end

	if nil == self.prevScale 
		or not VectorUtility.AlmostEqual_3(self.prevScale, logicTransform.currentScale) then
		local s = logicTransform.currentScale
		assetRole:SetScaleXYZ(s[1],s[2],s[3])
		self.prevScale = VectorUtility.Asign_3(self.prevScale, logicTransform.currentScale)
	end
end

function AI_Base:_DoRequest(time, deltaTime, creature)
	if self.requestClear then
		self:_Clear(time, deltaTime, creature)
	end
end