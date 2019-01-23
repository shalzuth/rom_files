
EffectWorker_OnFloor = class("EffectWorker_OnFloor", ReusableObject)

local FindCreature = SceneCreatureProxy.FindCreature

-- local tempVector3 = LuaVector3.zero

-- Args = ID

local function _OnEffectCreated(effectHandle, effectWorker)
	effectWorker:OnEffectCreated(effectHandle)
end

function EffectWorker_OnFloor.Create( ID )
	return ReusableObject.Create( EffectWorker_OnFloor, true, ID )
end

function EffectWorker_OnFloor:ctor()
	self.effect = nil
end

function EffectWorker_OnFloor:SetArgs(args, creature)
	if nil ~= self.effect then
		return
	end
	if FunctionPerformanceSetting.Me():GetSetting().effectLow then
		return
	end
	self.effect = Asset_Effect.PlayAt(
		self.performData.effect, 
		creature:GetPosition(),
		_OnEffectCreated,
		self)
end

function EffectWorker_OnFloor:OnEffectCreated(effectHandle)
	effectHandle.enabled = false
	self.effectHandle = effectHandle
end

function EffectWorker_OnFloor:Update(time, deltaTime, creature)
end

-- override begin
function EffectWorker_OnFloor:DoConstruct(asArray, ID)
	self.performData = Table_SpEffect[ID].Perform
	self.effect = nil
end

function EffectWorker_OnFloor:DoDeconstruct(asArray)
	if nil ~= self.effect then
		self.effect:RemoveCreatedCallBack()
		if not LuaGameObject.ObjectIsNull(self.effectHandle) then
			self.effectHandle.enabled = true
			local animator = self.effect:GetComponent(Animator)
			if nil ~= animator then
				animator:Play("end")
				Game.AssetManager_Effect:AddAutoDestroyEffect(self.effect)
			else
				self.effect:Destroy()
			end
		else
			self.effect:Destroy()
		end
		self.effect = nil
	end
	self.effectHandle = nil
	self.performData = nil
end
-- override end