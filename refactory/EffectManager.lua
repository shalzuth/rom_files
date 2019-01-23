
EffectManager = class("EffectManager")

EffectManager.FilterType = {
	All = 1
}

EffectManager.EffectType = {
	Loop=1,
	OneShot = 2,
}

function EffectManager:ctor()
	self.effects = {}
	self.autoDestroyEffects = {}
	self.isFilter = false
end

function EffectManager:Filter(filterType)
	self.isFilter = true
	--以后做扩展，现在默认只处理全部
	for k,autoDestroyEffect in pairs(self.autoDestroyEffects) do
		self.autoDestroyEffects[k] = nil
		autoDestroyEffect:Stop()
	end

	for k,effect in pairs(self.effects) do
		effect:SetActive(false,Asset_Effect.DeActiveOpt.Filter)
	end
end

function EffectManager:UnFilter(filterType)
	self.isFilter = false
	for k,effect in pairs(self.effects) do
		effect:SetActive(true,Asset_Effect.DeActiveOpt.Filter)
	end
end

function EffectManager:IsFiltered()
	return self.isFilter
end

function EffectManager:RegisterEffect( effect ,autoDestroy)
	if(effect~=nil) then
		if(autoDestroy) then
			self.effects[effect.id] = nil
			self.autoDestroyEffects[effect.id] = effect
		else
			self.effects[effect.id] = effect
		end
	end
end

function EffectManager:UnRegisterEffect( effect )
	if(effect~=nil) then
		self.effects[effect.id] = nil
		self.autoDestroyEffects[effect.id] = nil
	end
end