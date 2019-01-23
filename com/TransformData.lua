TransformData = class('TransformData')
local npcType = 1
local monsterType = 2
function TransformData:ctor()
end

-- self origin = {
-- 	[1] = type, 
-- 	[2] = shape, 
-- 	[3] = race, 
-- 	[4] = transformID, 
-- 	[5] = (1)npc大类/(2)monster大类/-1, 
-- }
function TransformData:CacheOrigin(data)
	self[1] = data.type
	self[2] = data.shape
	self[3] = data.race
end

function TransformData:SetTransformID(creature,transformID)
	self[4] = transformID
	if(transformID~=0) then
		local staticData = Table_Monster[transformID]
		if(staticData==nil) then
			staticData = Table_Npc[transformID]
		end
		
		if(staticData) then
			if(NpcMonsterUtility.IsMonsterByData(staticData)) then
				creature.data.type = NpcData.NpcType.Monster
				self[5] = monsterType
			else
				creature.data.type = NpcData.NpcType.Npc
				self[5] = npcType
			end
			creature.data.shape = staticData.Shape
			creature.data.race = staticData.Race_Parsed
		end
	else
		--rollback
		creature.data.type = self[1]
		creature.data.shape = self[2]
		creature.data.race = self[3]
		self[5] = -1
	end
end

--是否npc组
function TransformData:IsNpcGroup()
	return self[5] == npcType
end

--是否怪物组
function TransformData:IsMonsterGroup()
	return self[5] == monsterType
end