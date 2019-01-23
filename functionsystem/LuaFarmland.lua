autoImport('ArrayUtil')
autoImport('LuaDynamicGrass')
autoImport('AudioPlayerOfInteractionGrass')

LuaFarmland = class('LuaFarmland')

local gReusableArray1 = {}
local gReusableArray2 = {}
local gReusableArray3 = {}
local gReusableArray4 = {}

local gReusableLuaVector3 = LuaVector3.zero

LuaFarmland.PlantType = {
	Wheat = 0,
	Convallaria = 1,
	Clover = 2
}

local ArrayClear = TableUtility.ArrayClear
local ArrayShallowCopy = TableUtility.ArrayShallowCopy

function LuaFarmland:ctor()
	self.rect = LuaRect.new(0,0,0,0)
end

function LuaFarmland:IsOverlapOther(otherLand)
	return self.rect:Overlaps(otherLand.rect)
end

function LuaFarmland:AttachGameObject(go)
	self.gameObject = go
end

function LuaFarmland:Transform()
	return self.gameObject.transform
end

function LuaFarmland:Initialize()
	self.dynamicGrasses = {}
	local transPlants = self:Transform():Find('Plants')
	local plantsCount = transPlants.childCount
	for i = 0, plantsCount - 1 do
		local transPlant = transPlants:GetChild(i)
		local goPlant = transPlant.gameObject
		local dg = LuaDynamicGrass.new()
		self.dynamicGrasses[tonumber(goPlant.name)] = dg
		dg:AttachGameObject(goPlant)
		dg:Initialize()
		dg:Launch(self.csfarmland.plantType, self.csfarmland.effectiveDistance)
	end
	self.lastEffectiveUnitsOfRoles = {}
	self.unitPosOfRoles = {}
end

function LuaFarmland:SetCSFarmland(csfarmland)
	self.csfarmland = csfarmland
	self.csfarmlandAnchorPoint = self.csfarmland.AnchorPoint
	if(self.csfarmland) then
		self.id = self.csfarmland.id
		self.idBitValue = 2 ^ (self.id-1)
		self.widthBaseUnit = self.csfarmland.widthBaseUnit
		self.heightBaseUnit = self.csfarmland.heightBaseUnit
		self.rect:SetPos_XY(self.csfarmlandAnchorPoint[1],self.csfarmlandAnchorPoint[3])
		self.rect:SetSize_WH(self.csfarmland.Width,self.csfarmland.Height)
	end
end

function LuaFarmland:GetIDBitValue()
	return self.idBitValue
end

function LuaFarmland:IsPointInside(point)
	return self.rect:Contains_3(point)
end

function LuaFarmland:GetPosBaseUnit(unit_index)
	if unit_index > 0 and unit_index <= self.csfarmland.unitIndexMax then
		if self.csfarmland.widthBaseUnit > 0 then
			local line = 0
			local column = 0
			local divisor = math.CaculateQuotient(unit_index, self.csfarmland.widthBaseUnit)
			local remainder = math.CaculateRemainder(unit_index, self.csfarmland.widthBaseUnit)
			if remainder > 0 then
				column = remainder
				line = divisor + 1
			else
				column = self.csfarmland.widthBaseUnit
				line = divisor
			end
			return {[1] = line, [2] = column}
		end
	end
	return nil
end

function LuaFarmland:_UnitPosToPosID(column,line)
	return column*1000 + line
end

function LuaFarmland:_PosIDToUnitPos(posID)
	return math.floor(posID/1000),posID % 1000
end

local validUnitsIndex = {}
function LuaFarmland:_GetEffectiveUnitsFromLocalPos(localPos)
	local x,z = localPos[1],localPos[3]
	local column,line = math.ceil(self.widthBaseUnit * x/ self.csfarmland.Width),math.ceil(self.heightBaseUnit * z / self.csfarmland.Height)
	validUnitsIndex = self:_GetEffectUnitsFromColunmLine(column,line)
	return validUnitsIndex,self:_UnitPosToPosID(column,line)
end

function LuaFarmland:_GetEffectUnitsFromColunmLine(column,line)
	ArrayClear(validUnitsIndex)
	local unitIndex
	for i = column-1,column+1 do
		if(i>0 and i<=self.widthBaseUnit) then
			for j = line-1,line+1 do
				if(j>0 and j<=self.heightBaseUnit) then
					unitIndex = self:GetUnitIndexFromPosBaseUnit(j, i)
					if(self.dynamicGrasses[unitIndex]) then
						validUnitsIndex[#validUnitsIndex+1] = unitIndex
					end
				end
			end
		end
	end
	return validUnitsIndex
end

function LuaFarmland:GetEffectiveUnitsFromPos(pos)
	gReusableLuaVector3:Set(pos[1] - self.csfarmlandAnchorPoint[1], pos[2] - self.csfarmlandAnchorPoint[2], pos[3] - self.csfarmlandAnchorPoint[3])
	return self:_GetEffectiveUnitsFromLocalPos(gReusableLuaVector3)
end

function LuaFarmland:GetUnitIndexFromPosBaseUnit(line, column)
	return (line - 1) * self.csfarmland.widthBaseUnit + column
end

function LuaFarmland:SomebodyOccur(role_id,pos)
	local tempUnitsIndex,unitPosID = self:GetEffectiveUnitsFromPos(pos)
	if tempUnitsIndex ~= nil and #tempUnitsIndex > 0 then
		for i = 1, #tempUnitsIndex do
			local dg = self:GetDynamicGrassFromUnitIndex(tempUnitsIndex[i])
			dg:MoveOrAdd(role_id)
		end
		self:TryPlayAudio()
	end
	local lastUnitPosID = self.unitPosOfRoles[role_id]
	if(lastUnitPosID~=unitPosID) then
		if(lastUnitPosID) then
			--todo
		end
		self.unitPosOfRoles[role_id] = unitPosID
	end
end

function LuaFarmland:_HandleMoveOrAdd(role_id,unitsIndex)
	if unitsIndex ~= nil and #unitsIndex > 0 then
		for i = 1, #unitsIndex do
			local dg = self:GetDynamicGrassFromUnitIndex(unitsIndex[i])
			dg:MoveOrAdd(role_id)
		end
		self:TryPlayAudio()
	end
end

local cachedIndexs2 = {}
function LuaFarmland:SomebodyMove(role_id,pos)
	local tempUnitsIndex,unitPosID = self:GetEffectiveUnitsFromPos(pos)
	local lastUnitPosID = self.unitPosOfRoles[role_id]
	if(lastUnitPosID~=unitPosID) then
		self.unitPosOfRoles[role_id] = unitPosID
		ArrayClear(cachedIndexs2)
		ArrayShallowCopy(cachedIndexs2,tempUnitsIndex)
		if(lastUnitPosID) then
			local lastColumn,lastLine = self:_PosIDToUnitPos(lastUnitPosID)
			local lastUnits = self:_GetEffectUnitsFromColunmLine(lastColumn,lastLine)
			if lastUnits ~= nil and #lastUnits > 0 then
				for i = 1, #lastUnits do
					local dg = self:GetDynamicGrassFromUnitIndex(lastUnits[i])
					dg:DirtyRemove(role_id)
				end
			end
			tempUnitsIndex = cachedIndexs2
		end
	end
	self:_HandleMoveOrAdd(role_id,tempUnitsIndex)
end

function LuaFarmland:SomebodyIdle(role_id)
end

function LuaFarmland:SomebodyLeave(role_id)
	local lastUnitPosID = self.unitPosOfRoles[role_id]
	if(lastUnitPosID) then
		local lastColumn,lastLine = self:_PosIDToUnitPos(lastUnitPosID)
		local lastUnits = self:_GetEffectUnitsFromColunmLine(lastColumn,lastLine)
		if lastUnits ~= nil and #lastUnits > 0 then
			for i = 1, #lastUnits do
				local dg = self:GetDynamicGrassFromUnitIndex(lastUnits[i])
				dg:RemoveEffectiveBody(role_id)
			end
		end
	end
	self.unitPosOfRoles[role_id] = nil
end

function LuaFarmland:GetDynamicGrassFromUnitIndex(unit_index)
	return self.dynamicGrasses[unit_index]
end

function LuaFarmland:Release()
	-- release dynamicGrasses
	for _, v in pairs(self.dynamicGrasses) do
		local dg = v
		dg:Release()
	end
	self.dynamicGrasses = nil
	-- release lastEffectiveUnitsOfRoles
	self.lastEffectiveUnitsOfRoles = nil
	self.unitPosOfRoles = nil
end

function LuaFarmland:Update()
	for _, v in pairs(self.dynamicGrasses) do
		local dg = v
		dg:Update()
	end
end

function LuaFarmland:GetAudioSource()
	if self.audioSource == nil then
		local audioSource = self:Transform():GetComponentInChildren(AudioSource)
		if audioSource == nil then
			audioSource = self.gameObject:AddComponent(AudioSource)
		end
		self.audioSource = audioSource
	end
	return self.audioSource
end

function LuaFarmland:TryPlayAudio()
	local audioSource = self:GetAudioSource()
	if not audioSource.isPlaying then
		if self.csfarmland.plantType == LuaFarmland.PlantType.Wheat then
			self:PlayAudio(AudioMap.Maps.WheatBeShoved, audioSource)
		end
	end
end

function LuaFarmland:PlayAudio(audio_path, audio_source)
	self:DoPlayAudio(audio_path, audio_source)
end

function LuaFarmland:DoPlayAudio(audio_path, audio_source)
	AudioPlayerOfInteractionGrass.PlayOneShot(audio_path, audio_source)
end