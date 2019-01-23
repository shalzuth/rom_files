SceneRangeFilter = class("SceneRangeFilter")

function SceneRangeFilter.Me()
	if nil == SceneRangeFilter.me then
		SceneRangeFilter.me = SceneRangeFilter.new()
	end
	return SceneRangeFilter.me
end

function SceneRangeFilter:ctor()
end

function SceneRangeFilter.CheckNotTeam(creature)
	if(creature:GetCreatureType() == Creature_Type.Player) then
		return not TeamProxy.Instance:IsInMyTeam(creature.data.id)
	elseif(creature:GetCreatureType() == Creature_Type.Pet) then
		if(creature.data.ownerID~= Game.Myself.data.id) then
			return not TeamProxy.Instance:IsInMyTeam(creature.data.ownerID)
		end
	end
	return true
end

function SceneRangeFilter.CheckSameTeam(creature)
	if(creature:GetCreatureType() == Creature_Type.Player) then
		return TeamProxy.Instance:IsInMyTeam(creature.data.id)
	elseif(creature:GetCreatureType() == Creature_Type.Pet) then
		if(creature.data.ownerID~= Game.Myself.data.id) then
			return TeamProxy.Instance:IsInMyTeam(creature.data.ownerID)
		end
	end
	return false
end

function SceneRangeFilter.CheckSameGuild(creature)
	if(creature:GetCreatureType() == Creature_Type.Player) then
		return GuildProxy.Instance:CheckPlayerInMyGuild(creature.data.id)
	elseif(creature:GetCreatureType() == Creature_Type.Pet) then
		if(creature.data.ownerID~= Game.Myself.data.id) then
			return GuildProxy.Instance:CheckPlayerInMyGuild(creature.data.ownerID)
		end
	end
	return false
end

function SceneRangeFilter.CheckNotTeamOther(creature)
	if(creature:GetCreatureType() == Creature_Type.Me) then
		return false
	else
		--player
		local playerID = creature.data.id
		if(creature:GetCreatureType() == Creature_Type.Pet) then
			playerID = creature.data.ownerID
		end
		-- for propose
		local proposeID = WeddingProxy.Instance:Get_Courtship_PlayerId()
		if(proposeID and proposeID == playerID) then
			return false
		end
		return not TeamProxy.Instance:IsInMyTeam(playerID)
	end
	return true
end

function SceneRangeFilter.CheckNotGuildOther(creature)
	if(creature:GetCreatureType() == Creature_Type.Me) then
		return false
	else
		--player
		local playerID = creature.data.id
		if(creature:GetCreatureType() == Creature_Type.Pet) then
			playerID = creature.data.ownerID
		end
		-- for propose
		local proposeID = WeddingProxy.Instance:Get_Courtship_PlayerId()
		if(proposeID and proposeID == playerID) then
			return false
		end
		return not GuildProxy.Instance:CheckPlayerInMyGuild(playerID)
	end
	return true
end

function SceneRangeFilter.CheckAll(creature)
	return true
end

function SceneRangeFilter.CheckAllOther(creature)
	if(creature:GetCreatureType() == Creature_Type.Pet) then
		return creature.data.ownerID ~= Game.Myself.data.id
	end
	return creature:GetCreatureType() ~= Creature_Type.Me
	-- return true
end

function SceneRangeFilter.CheckSelf(creature)
	if(creature:GetCreatureType() == Creature_Type.Pet) then
		return creature.data.ownerID == Game.Myself.data.id
	end
	return creature:GetCreatureType() == Creature_Type.Me
end