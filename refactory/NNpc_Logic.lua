
local SampleInterval = 0.1
local nextSampleTime = 0

function NNpc.StaticUpdate(time, deltaTime)
	if time >= nextSampleTime then
		nextSampleTime = time + SampleInterval
	end
end

function NNpc:Logic_SamplePosition(time)
	if time < nextSampleTime then
		self.logicTransform:SamplePosition()
	end
end

function NNpc:Logic_Hit(action, stiff)
	local changeColor = true
	if Game.HandUpManager:IsInHandingUp() 
		or FunctionPerformanceSetting.Me():GetSetting().effectLow then
		changeColor = false
	end
	self.ai:PushCommand(FactoryAICMD.GetHitCmd(changeColor, action, stiff), self)
end

function NNpc:Logic_DeathBegin()
	if nil == Table_DeathEffect then
		return
	end
	local effectInfo = Table_DeathEffect[self.data:GetStaticID()]
	if nil ~= effectInfo then
		if 1 == effectInfo.Type then
			self.assetRole:AlphaTo(0.3, 0)
		end
		local p = self:GetPosition()
		local effectPath = effectInfo.Effect
		if nil ~= effectPath and "" ~= effectPath then
			Asset_Effect.PlayOneShotAt(effectPath, p)
		end
		local sePath = effectInfo.EffectSe
		if nil ~= sePath and "" ~= sePath then
			local resPath = ResourcePathHelper.AudioSE(sePath)
			AudioUtility.PlayOneShotAt_Path(resPath, p)
		end
		local params = effectInfo.Parameter
		if nil ~= params then
			local assetRole = self.assetRole
			effectPath = params.effect_on
			if nil ~= effectPath and "" ~= effectPath then
				local epID = params.ep or 0
				assetRole:PlayEffectOneShotOn(effectPath, epID)
			end
			sePath = params.se_on
			if nil ~= sePath and "" ~= sePath then
				assetRole:PlaySEOneShotOn(sePath)
			end
		end
	end
end