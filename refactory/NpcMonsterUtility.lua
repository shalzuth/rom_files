NpcMonsterUtility = class("NpcMonsterUtility")

--与Npc表和monster表相关的

local NpcType = {
	"NPC",
	"GatherNPC",
	"SealNPC",
	"WeaponPet",
	"FoodNpc",
	"CatchNpc",
}

local FriendNpcType = {
	"FriendNpc",
}

local MonsterType = {
	"Monster",
	"MINI",
	"MVP",
}

local PetType = {
	"PetNpc",
	"BeingNpc",
}

function NpcMonsterUtility.GetConfig(id)
	return Table_Npc[id] or Table_Monster[id]
end
local GetConfig = NpcMonsterUtility.GetConfig

function NpcMonsterUtility.IsType(data,types)
	if(data and types) then
		local _type = data.Type
		for i=1, #types do
			if(_type==types[i]) then
				return true
			end
		end
	end
	return false
end
local isType = NpcMonsterUtility.IsType

function NpcMonsterUtility.IsFriendNpcByData(data)
	return isType(data,FriendNpcType)
end
local IsFriendNpcByData = NpcMonsterUtility.IsFriendNpcByData

function NpcMonsterUtility.IsFriendNpcByID(id)
	local data = GetConfig(id)
	return IsFriendNpcByData(data)
end

function NpcMonsterUtility.IsNpcByData(data)
	return isType(data,NpcType)
end
local IsNpcByData = NpcMonsterUtility.IsNpcByData

function NpcMonsterUtility.IsNpcByID(id)
	local data = GetConfig(id)
	return IsNpcByData(data)
end

function NpcMonsterUtility.IsMonsterByData(data)
	return isType(data,MonsterType)
end
local IsMonsterByData = NpcMonsterUtility.IsMonsterByData

function NpcMonsterUtility.IsMonsterByID(id)
	local data = GetConfig(id)
	return IsMonsterByData(data)
end

function NpcMonsterUtility.IsPetByData(data)
	return isType(data,PetType)
end
local IsPetByData = NpcMonsterUtility.IsPetByData

function NpcMonsterUtility.IsPetByID(id)
	local data = GetConfig(id)
	return IsPetByData(data)
end