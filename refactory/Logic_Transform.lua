
autoImport ("Logic_Transform_DirMove")

Logic_Transform = class("Logic_Transform")

-- init interface begin
-- Logic_Transform:PlaceTo(p)
-- Logic_Transform:SetAngleY(v)
-- Logic_Transform:SetScale(v)
-- Logic_Transform:SetMoveSpeed(v)
-- Logic_Transform:SetRotateSpeed(v)
-- Logic_Transform:SetScaleSpeed(v)
-- init interface end

-- NOTE: if nil ~= logic.targetXXX then -- processing

local tempVector3_1 = LuaVector3.New()

-- Owner = {
-- 	function Logic_OnMoveToNextCorner(nextCorner) end
-- }

function Logic_Transform:ctor()
	self.speed = {1,1,1,1,1}
	self.extraLogics = {}
	self._alive = false
end

function Logic_Transform:SetOwner(owner)
	self.owner = owner
end

function Logic_Transform:Construct()
	if self._alive then
		return
	end
	self._alive = true
	self.targetPosition = nil
	self.targetAngleY = nil
	self.targetScale = nil

	self.currentPosition = LuaVector3.New(10000,10000,10000)
	self.currentAngleY = 0
	self.currentScale = LuaVector3.one

	self.useNavMesh = nil
	self.navMeshPathAgent = nil
	self.nextCorner = nil
	self.cornerIndex = nil
end

function Logic_Transform:Deconstruct()
	if not self._alive then
		return
	end
	self.targetPosition = VectorUtility.Destroy(self.targetPosition)
	self.currentPosition = VectorUtility.Destroy(self.currentPosition)

	self.targetScale = VectorUtility.Destroy(self.targetScale)
	self.currentScale = VectorUtility.Destroy(self.currentScale)

	self.navMeshPathAgent = nil
	self.nextCorner = VectorUtility.Destroy(self.nextCorner)

	if 0 < #self.extraLogics then
		local extraLogics = self.extraLogics
		for i=#extraLogics, 1, -1 do
			local logic = extraLogics[i]
			table.remove(extraLogics, i)
			logic:Destroy()
		end
	end
	self._alive = false
end

local tempExtraDirMoveArgs = {
}
function Logic_Transform:ExtraDirMove(dirAngleY, distance, speed)
	tempExtraDirMoveArgs[1] = dirAngleY
	tempExtraDirMoveArgs[2] = distance
	tempExtraDirMoveArgs[3] = speed
	local logic = Logic_Transform_DirMove.Create(tempExtraDirMoveArgs)
	TableUtility.ArrayPushBack(self.extraLogics, logic)
end

function Logic_Transform:SetMoveSpeed(v)
	self.speed[1] = v
end

function Logic_Transform:GetMoveSpeed()
	return self.speed[1]
end

function Logic_Transform:GetMoveSpeedWithFastForward()
	return self.speed[1] * self.speed[4]
end

function Logic_Transform:SetFastForwardSpeed(v)
	self.speed[4] = v
end

function Logic_Transform:GetFastForwardSpeed()
	return self.speed[4]
end

function Logic_Transform:SetTargetPosition(p)
	self.targetPosition = VectorUtility.Asign_3(self.targetPosition, p)
end

function Logic_Transform:NavMeshMoveTo(p, sampleRange)
	if self.useNavMesh 
		and nil ~= self.targetPosition 
		and VectorUtility.AlmostEqual_3(self.targetPosition, p) then
		return true
	end
	
	local ret,newP = NavMeshUtility.Better_Sample(p, tempVector3_1, sampleRange)
	if not ret then
		return false
	end

	self.useNavMesh = true
	if nil == self.currentPosition then
		self:PlaceTo(newP)
		return true
	end

	self.targetPosition = VectorUtility.Asign_3(self.targetPosition, newP)
	
	if nil == self.navMeshPathAgent then
		self.navMeshPathAgent = NavMeshPathAgent()
	else
		self.navMeshPathAgent:Clear()
	end

	if not self:_CalcNavMeshPath() then
		-- calc path failed
		self:StopMove()
		return false
	end
	return true
end

function Logic_Transform:MoveTo(p, rotateToP)
	self.useNavMesh = false
	self.targetPosition = VectorUtility.Asign_3(self.targetPosition, p)
	-- rotate
	self:RotateTo(rotateToP or p)
end

function Logic_Transform:NavMeshPlaceTo(p, sampleRange)
	self.targetPosition = VectorUtility.Destroy(self.targetPosition)
	self.currentPosition:Set(p[1],p[2],p[3])
	NavMeshUtility.SelfSample(self.currentPosition, sampleRange or 1)
end

function Logic_Transform:PlaceTo(p)
	self.targetPosition = VectorUtility.Destroy(self.targetPosition)
	self.currentPosition:Set(p[1],p[2],p[3])
end

function Logic_Transform:SamplePosition(sampleRange)
	NavMeshUtility.SelfSample(self.currentPosition, sampleRange)
end

function Logic_Transform:StopMove()
	self.targetPosition = VectorUtility.Destroy(self.targetPosition)
end

function Logic_Transform:SetRotateSpeed(v)
	self.speed[2] = v
end

function Logic_Transform:GetRotateSpeed()
	return self.speed[2]
end

function Logic_Transform:GetRotateSpeedWithScale()
	return self.speed[2] * self.speed[5]
end

function Logic_Transform:SetRotateSpeedScale(v)
	self.speed[5] = v
end

function Logic_Transform:GetRotateSpeedScale()
	return self.speed[5]
end

function Logic_Transform:RotateTo(p)
	if nil == self.currentAngleY then
		self.currentAngleY = VectorHelper.GetAngleByAxisY(self.currentPosition, p)
		-- LogUtility.InfoFormat("<color=yellow>RotateTo: </color>{0}, currentAngleY={1}",
		-- 	p, self.currentAngleY)
		return
	end
	self.targetAngleY = VectorHelper.GetAngleByAxisY(self.currentPosition, p)
	-- LogUtility.InfoFormat("<color=yellow>RotateTo: </color>{0}, targetAngleY={1}",
	-- 		p, self.targetAngleY)
end

function Logic_Transform:LookAt(p)
	self.targetAngleY = nil
	self.currentAngleY = VectorHelper.GetAngleByAxisY(self.currentPosition, p)
	-- LogUtility.InfoFormat("<color=yellow>LookAt: </color>{0}, currentAngleY={1}",
	-- 	p, self.currentAngleY)
end

function Logic_Transform:SetTargetAngleY(v)
	if nil == self.currentAngleY then
		self.currentAngleY = v
		-- LogUtility.InfoFormat("<color=yellow>SetTargetAngleY: </color>{0}, currentAngleY={1}",
		-- 	v, self.currentAngleY)
		return
	end
	self.targetAngleY = v
	-- LogUtility.InfoFormat("<color=yellow>SetTargetAngleY: </color>{0}, targetAngleY={1}",
	-- 	v, self.targetAngleY)
end

function Logic_Transform:SetAngleY(v)
	self.targetAngleY = nil
	self.currentAngleY = v
	-- LogUtility.InfoFormat("<color=yellow>SetAngleY: </color>{0}, currentAngleY={1}",
	-- 	v, self.currentAngleY)
end

function Logic_Transform:StopRotation()
	self.targetAngleY = nil
	-- LogUtility.InfoFormat("<color=yellow>StopRotation: </color>{0}",
	-- 	self.currentAngleY)
end

function Logic_Transform:SetScaleSpeed(v)
	self.speed[3] = v
end

function Logic_Transform:GetScaleSpeed()
	return self.speed[3]
end

function Logic_Transform:ScaleTo(v)
	if nil ~= self.targetScale then
		self.targetScale:Set(v,v,v)
	else
		self.targetScale = LuaVector3.New(v,v,v)
	end
end

function Logic_Transform:SetScale(v)
	self.targetScale = VectorUtility.Destroy(self.targetScale)
	self.currentScale:Set(v,v,v)
end

function Logic_Transform:ScaleToXYZ(x, y, z)
	if nil ~= self.targetScale then
		self.targetScale:Set(x, y, z)
	else
		self.targetScale = LuaVector3.New(x, y, z)
	end
end

function Logic_Transform:SetScaleXYZ(x, y, z)
	self.targetScale = VectorUtility.Destroy(self.targetScale)
	self.currentScale:Set(x, y, z)
end

function Logic_Transform:StopScaling()
	self.targetScale = VectorUtility.Destroy(self.targetScale)
end

function Logic_Transform:_MoveToNextCorner()
	self.cornerIndex = self.cornerIndex + 1
	local ret,x,y,z=self.navMeshPathAgent:GetCorner(self.cornerIndex)
	if ret then
		if nil == self.nextCorner then
			self.nextCorner = LuaVector3.New(x,y,z)
		else
			self.nextCorner:Set(x,y,z)
		end
		-- rotate
		self:RotateTo(self.nextCorner)

		if nil ~= self.owner then
			self.owner:Logic_OnMoveToNextCorner(self.nextCorner)
		end
	end
	return ret
end

function Logic_Transform:_CalcNavMeshPath()
	local ret,x,y,z = self.navMeshPathAgent:Calc(self.currentPosition, self.targetPosition)
	if ret then
		if self.navMeshPathAgent.complete 
			or self.navMeshPathAgent.completePartial then
			-- reset target position
			self.targetPosition:Set(x,y,z)
			self.cornerIndex = 0
			if not self:_MoveToNextCorner() then
				-- no corners
				ret = false
			end
		elseif self.navMeshPathAgent.invalid then
			-- calc path failed
			ret = false
		end
	end
	return ret
end

function Logic_Transform:Update(time, deltaTime)
	-- position
	if nil ~= self.targetPosition then
		if self.useNavMesh then
			if self.navMeshPathAgent.idle then
				-- calc
				if not self:_CalcNavMeshPath() then
					-- calc path failed
					self:StopMove()
				end
			else
				-- try move
				if self.navMeshPathAgent.complete
					or self.navMeshPathAgent.completePartial then
					local deltaDistance = self:GetMoveSpeedWithFastForward() * deltaTime
					-- Debug_AssertFormat(0 < deltaDistance, "Invalid deltaDistance: {0}", deltaDistance)
					LuaVector3.SelfMoveTowards(self.currentPosition, self.nextCorner, deltaDistance)
					if VectorUtility.AlmostEqual_3(self.currentPosition, self.nextCorner) then
						if not self:_MoveToNextCorner() then
							-- arrived
							VectorUtility.Asign_3(self.currentPosition, self.nextCorner)
							self:StopMove()
						end
					end
				elseif self.navMeshPathAgent.invalid then
					self:StopMove()
				end
			end
		else
			local deltaDistance = self:GetMoveSpeedWithFastForward() * deltaTime
			LuaVector3.SelfMoveTowards(self.currentPosition, self.targetPosition, deltaDistance)
			if VectorUtility.AlmostEqual_3(self.currentPosition, self.targetPosition) then
				VectorUtility.Asign_3(self.currentPosition, self.targetPosition)
				self:StopMove()
			end
		end
	end

	-- rotation
	if nil ~= self.targetAngleY then
		local deltaAngle = self:GetRotateSpeedWithScale() * deltaTime
		self.currentAngleY = NumberUtility.MoveTowardsAngle(self.currentAngleY, self.targetAngleY, deltaAngle)
		if NumberUtility.AlmostEqualAngle(self.currentAngleY, self.targetAngleY) then
			-- arrived
			self.currentAngleY = self.targetAngleY
			self:StopRotation()
		end
	end

	-- scale
	if nil ~= self.targetScale then
		local deltaScale = self.speed[3] * deltaTime
		LuaVector3.SelfMoveTowards(self.currentScale, self.targetScale, deltaScale)
		if VectorUtility.AlmostEqual_3(self.currentScale, self.targetScale) then
			-- arrived
			VectorUtility.Asign_3(self.currentScale, self.targetScale)
			self:StopScaling()
		end
	end

	-- extra
	if 0 < #self.extraLogics then
		local extraLogics = self.extraLogics
		for i=#extraLogics, 1, -1 do
			local logic = extraLogics[i]
			logic:Update(self, time, deltaTime)
			if not logic.running then
				table.remove(extraLogics, i)
				logic:Destroy()
			end
		end
	end
end