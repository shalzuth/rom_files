Asset_RoleUtility = class("Asset_RoleUtility")
function Asset_RoleUtility.CreateRoleParts(staticData)
	if nil == staticData then
		return nil 
	end
	local parts = Asset_Role.CreatePartArray();
	Asset_RoleUtility.SetRoleParts(staticData, parts);
	return parts;
end

function Asset_RoleUtility.SetRoleParts(staticData, parts)
	if nil == staticData then
		return
	end

	local partIndex = Asset_Role.PartIndex;
	parts[partIndex.Body] = staticData.Body or 0
	parts[partIndex.Hair] = staticData.Hair or 0
	parts[partIndex.LeftWeapon] = staticData.LeftHand or 0
	parts[partIndex.RightWeapon] = staticData.RightHand or 0
	parts[partIndex.Head] = staticData.Head or 0
	parts[partIndex.Wing] = staticData.Wing or 0
	parts[partIndex.Face] = staticData.Face or 0
	parts[partIndex.Tail] = staticData.Tail or 0
	parts[partIndex.Eye] = staticData.Eye or 0
	parts[partIndex.Mount] = staticData.Mount or 0
	-- parts[partIndex.Mouth] = staticData.Mount or 0

	local partIndexEx = Asset_Role.PartIndexEx;
	-- parts[11] = staticData.Gender or 0
	parts[partIndexEx.HairColorIndex] = staticData.HeadDefaultColor or 0
	parts[partIndexEx.EyeColorIndex] = staticData.EyeDefaultColor or 0
end

-- npc begin
function Asset_RoleUtility.CreateNpcRoleParts(npcid)
	return Asset_RoleUtility.CreateRoleParts(Table_Npc[npcid]);
end

function Asset_RoleUtility.SetNpcRoleParts( npcid, parts )
	 Asset_RoleUtility.SetRoleParts(Table_Npc[npcid], parts)
end

function Asset_RoleUtility.CreateNpcRole( npcid )
	local npcParts = Asset_RoleUtility.CreateNpcRoleParts(npcid)
	local assetRole = Asset_Role.Create( npcParts );
	assetRole:PlayAction_Idle();
	Asset_Role.DestroyPartArray( npcParts );
	return assetRole;
end
-- npc end


-- monster begin
function Asset_RoleUtility.CreateMonsterRoleParts(monsterid)
	return Asset_RoleUtility.CreateRoleParts(Table_Monster[monsterid]);
end

function Asset_RoleUtility.SetMonsterRoleParts( monsterid, parts )
	 Asset_RoleUtility.SetRoleParts(Table_Monster[monsterid], parts)
end

function Asset_RoleUtility.CreateMonsterRole( monsterid )
	local monsterParts = Asset_RoleUtility.CreateMonsterRoleParts(monsterid)
	local assetRole = Asset_Role.Create( monsterParts );
	Asset_Role.DestroyPartArray( monsterParts );
	return assetRole;
end
-- monster end

function Asset_RoleUtility.CreateNpcOrMonsterRoleParts(staticID)
	return Asset_RoleUtility.CreateRoleParts(Table_Monster[staticID] or Table_Npc[staticID]);
end

function Asset_RoleUtility.SetNpcOrMonsterRoleParts( monsterid, parts )
	 Asset_RoleUtility.SetRoleParts(Table_Monster[staticID] or Table_Npc[staticID], parts)
end



