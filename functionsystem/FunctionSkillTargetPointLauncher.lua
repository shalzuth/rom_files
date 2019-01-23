
FunctionSkillTargetPointLauncher = class("FunctionSkillTargetPointLauncher")

FunctionSkillTargetPointLauncherEvent = {
	StateChanged = "E_FunctionSkillTargetPointLauncher_StateChanged"
}

local tempVector3 = LuaVector3.zero

local function AdjustPointEffectSize(effectHandle, size)
	ModelUtils.AdjustSize(effectHandle.gameObject, size)
end

function FunctionSkillTargetPointLauncher.Me()
	if nil == FunctionSkillTargetPointLauncher.me then
		FunctionSkillTargetPointLauncher.me = FunctionSkillTargetPointLauncher.new()
	end
	return FunctionSkillTargetPointLauncher.me
end

function FunctionSkillTargetPointLauncher:ctor()
	self:Reset()
end

function FunctionSkillTargetPointLauncher:Reset()
	self.running = false
	self.skillIDAndLevel = nil
	if nil ~= self.position then
		self.position:Destroy()
		self.position = nil
	end
	self.active = false
	self:ResetEffect(nil)
end

function FunctionSkillTargetPointLauncher:ResetEffect(newEffect)
	local oldEffect = self.effect
	if nil ~= oldEffect then
		oldEffect:Destroy()
	end

	self.effect = newEffect
end

function FunctionSkillTargetPointLauncher:Launch(skillIDAndLevel)
	if self.running then
		return
	end

	local creature = Game.Myself
	local assetRole = creature.assetRole
	local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillIDAndLevel)

	self.running = true
	self.skillIDAndLevel = skillIDAndLevel
	self.active = false

	local effectPath = skillInfo:GetPointEffectPath(creature)
	local effectSize = skillInfo:GetPointEffectSize(creature)
	
	local p = tempVector3
	p:Set(LuaGameObject.GetForwardPosition(assetRole.completeTransform, effectSize))

	local effect = Asset_Effect.PlayAt(effectPath, p, AdjustPointEffectSize, effectSize)
	self:ResetEffect(effect)

	if nil == self.inputListener then
		self.inputListener = function (inputInfo)
			self:OnInputEvent(inputInfo)
		end
	end
	FunctionSystem.SetExtraInputListener(self, self.inputListener, function ()
		self:Shutdown()
	end,false)

	local eventManager = EventManager.Me()
	eventManager:DispatchEvent(FunctionSkillTargetPointLauncherEvent.StateChanged, self)
end

function FunctionSkillTargetPointLauncher:Shutdown()
	if not self.running then
		return
	end

	FunctionSystem.ClearExtraInputListener(self, self.inputListener)

	self:Reset()
	local eventManager = EventManager.Me()
	eventManager:DispatchEvent(FunctionSkillTargetPointLauncherEvent.StateChanged, self)
end

function FunctionSkillTargetPointLauncher:OnInputEvent(inputInfo)
	if not self.running then
		return
	end

	if not self.active and not inputInfo.overUI then
		self.active = true
	end

	if self.active then
		self:TrackTargetPosition(inputInfo.touchPoint)
		if TouchEventType.END == inputInfo.touchEventType then
			self:LaunchSkill()
		end
	end

	if TouchEventType.END == inputInfo.touchEventType then
		self:Shutdown()
	end
end

function FunctionSkillTargetPointLauncher:TrackTargetPosition(touchPoint)
	local onTerrain, x,y,z = LuaUtils.RaycastTerrain(touchPoint)
	if not onTerrain then
		return
	end

	tempVector3:Set(x,y,z)
	NavMeshUtility.SelfSample(tempVector3)

	self.position = VectorUtility.Asign_3(self.position, tempVector3)

	if nil ~= self.effect then
		self.effect:ResetLocalPosition(tempVector3)
	end
end

function FunctionSkillTargetPointLauncher:LaunchSkill()
	if nil == self.position then
		return
	end
	Game.SkillClickUseManager:TryLaunchPointTargetTypeSkill(self.skillIDAndLevel,self.position)
	-- Game.Myself:Client_UseSkill(self.skillIDAndLevel, nil, self.position)
end


