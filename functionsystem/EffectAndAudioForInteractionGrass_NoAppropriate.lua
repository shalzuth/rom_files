-- unused 2017/6/21

autoImport('AudioPlayerOfInteractionGrass')

EffectAndAudioForInteractionGrass_NoAppropriate = class("EffectAndAudioForInteractionGrass_NoAppropriate")

EffectAndAudioForInteractionGrass_NoAppropriate.PlantType = {
	Wheat = 0,
}

function EffectAndAudioForInteractionGrass_NoAppropriate.Instance()
	if EffectAndAudioForInteractionGrass_NoAppropriate.ins == nil then
		EffectAndAudioForInteractionGrass_NoAppropriate.ins = EffectAndAudioForInteractionGrass_NoAppropriate.new()
	end
	return EffectAndAudioForInteractionGrass_NoAppropriate.ins
end

local tablePool = {}
-- {
-- 	[1] = {
-- 		tab = {}, -- table
-- 		isIdle = true -- is idle
-- 	}
-- }

function EffectAndAudioForInteractionGrass_NoAppropriate:GetTableFromPool()
	for _, v in pairs(tablePool) do
		local isIdle = v.isIdle
		if isIdle then
			v.isIdle = false
			return v.tab
		end
	end
	local newTable = {}
	table.insert(tablePool, {isIdle = false, tab = newTable})
	return newTable
end

function EffectAndAudioForInteractionGrass_NoAppropriate:TableBackToPool(pTab)
	for _, v in pairs(tablePool) do
		local tab = v.tab
		if tab == pTab then
			v.isIdle = true
			TableUtility.TableClear(tab)
			break
		end
	end
end

function EffectAndAudioForInteractionGrass_NoAppropriate:Open()
	if self.farmlandManager == nil then
		self.farmlandManager = LuaFarmlandManager.Ins()
	end

	if self.tick == nil then
		local tickID = 1
		self.tick = TimeTickManager.Me():CreateTick(0, 0.1 * 1000, self.OnTick, self, tickID)
	end
end

function EffectAndAudioForInteractionGrass_NoAppropriate:Close()
	if self.tick ~= nil then
		self.tick:ClearTick()
	end
	self:CancelListen()
end

function EffectAndAudioForInteractionGrass_NoAppropriate:PlayEffect(transParent, plant_type)
	if plant_type == EffectAndAudioForInteractionGrass_NoAppropriate.PlantType.Wheat then
		local effectPath = EffectMap.Maps.InteractionPlant_Wheat
		local assetEffect = Asset_Effect.PlayOneShotOn(effectPath, transParent)
		assetEffect:ResetLocalPositionXYZ(0, 0, 0)
	end
end

function EffectAndAudioForInteractionGrass_NoAppropriate:PlayAudio(audio_path, audio_source)
	self:DoPlayAudio(audio_path, audio_source)
end

function EffectAndAudioForInteractionGrass_NoAppropriate:OnTick()
	for i = 1, #self.farmlandManager.cachedFarmlands do
		local luaFarmland = self.farmlandManager.cachedFarmlands[i]
		if not GameObjectUtil.Instance:ObjectIsNULL(luaFarmland.csfarmland) then
			local farmlandID = luaFarmland.csfarmland.id

			local dynamicGrasses = luaFarmland.dynamicGrasses
			for _, v in pairs(dynamicGrasses) do
				local luaDynamicGrass = v
				local funcGetPreEffectiveBodysCount = self.GetPreEffectiveBodysCount
				local preEffectiveBodysCount = funcGetPreEffectiveBodysCount(self, farmlandID, luaDynamicGrass.gameObject.name)
				local effectiveBodysCount = luaDynamicGrass:EffectiveBodysCount()
				if preEffectiveBodysCount == 0 and effectiveBodysCount > 0 then
					local funcPlayEffect = self.PlayEffect
					funcPlayEffect(self, luaDynamicGrass:Transform(), luaFarmland.csfarmland.plantType)

					if luaFarmland.csfarmland.plantType == EffectAndAudioForInteractionGrass_NoAppropriate.PlantType.Wheat then
						local audioSource = luaFarmland:GetAudioSource()
						if not audioSource.isPlaying then
							local funcPlayAudio = self.PlayAudio
							funcPlayAudio(self, AudioMap.Maps.WheatBeShoved, audioSource)
						end
					end
				end
				local funcSetPreEffectiveBodysCount = self.SetPreEffectiveBodysCount
				funcSetPreEffectiveBodysCount(self, farmlandID, luaDynamicGrass.gameObject.name, effectiveBodysCount)
			end
		else
			self.farmlandManager.cachedFarmlands[i] = nil
		end
	end
end

local cachedEffectiveBodysCount = {}
-- {
-- 	[1] = { -- farmland id
-- 		[1] = 1, -- name of dynamic grass's gameobject = count of effective bodys
-- 		...
-- 	}
-- }
function EffectAndAudioForInteractionGrass_NoAppropriate:GetPreEffectiveBodysCount(farmland_id, dynamic_grass_gameobject_name)
	local combinationKey = farmland_id .. '_' .. dynamic_grass_gameobject_name
	local effectiveBodysCount = cachedEffectiveBodysCount[combinationKey]
	return effectiveBodysCount or 0
end

function EffectAndAudioForInteractionGrass_NoAppropriate:SetPreEffectiveBodysCount(farmland_id, dynamic_grass_gameobject_name, count)
	if count and (type(count) == 'number') then
		local combinationKey = farmland_id .. '_' .. dynamic_grass_gameobject_name
		cachedEffectiveBodysCount[combinationKey] = count
	end
end

function EffectAndAudioForInteractionGrass_NoAppropriate:DoPlayAudio(audio_path, audio_source)
	AudioPlayerOfInteractionGrass.PlayOneShot(audio_path, audio_source)
end

function EffectAndAudioForInteractionGrass_NoAppropriate:DoPlayAudioAt(audio_path, position)
	AudioPlayerOfInteractionGrass.PlayOneShotAt(audio_path, position)
end

function EffectAndAudioForInteractionGrass_NoAppropriate:IsExistAnyFarmland()
	for k, v in pairs(self.farmlandManager.cachedFarmlands) do
		local luaFarmland = v
		if GameObjectUtil.Instance:ObjectIsNULL(luaFarmland.csfarmland) then
			self.farmlandManager.cachedFarmlands[k] = nil
		end
	end

	if #self.farmlandManager.cachedFarmlands > 0 then
		return true
	end
	return false
end

function EffectAndAudioForInteractionGrass_NoAppropriate:Reset()
	TableUtility.TableClear(cachedEffectiveBodysCount)
end