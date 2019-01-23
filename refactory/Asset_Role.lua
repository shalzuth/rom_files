Asset_Role = class("Asset_Role", ReusableObject)

if not Asset_Role.Asset_Role_Inited then
	Asset_Role.PoolSize = 100

	Asset_Role.Gender = {
		Male = 1,
		Female = 2
	}

	Asset_Role.PartIndex = {
		Body = 1,
		Hair = 2,
		LeftWeapon = 3,
		RightWeapon = 4,
		Head = 5,
		Wing = 6,
		Face = 7,
		Tail = 8,
		Eye = 9,
		Mouth = 10,
		Mount = 11,
	}
	Asset_Role.PartIndexEx = {
		Gender = 12,
		HairColorIndex = 13,
		EyeColorIndex = 14,
		SmoothDisplay = 15,
		BodyColorIndex = 16,
	}
	setmetatable(Asset_Role.PartIndexEx, {__index = Asset_Role.PartIndex})
	Asset_Role.PartCount = 11

	Asset_Role.ActionName = {
		Idle = "wait",
		IdleHandIn = "wait_HandIn",
		IdleInHand = "wait_InHand",
		IdleHold = "wait_HoldPet",
		IdleBeHolded = "wait_BeHold",
		Move = "walk",
		MoveHandIn = "walk_HandIn",
		MoveInHand = "walk_InHand",
		MoveHold = "walk_HoldPet",
		MoveBeHolded = "walk_BeHold",
		Sitdown = "sit_down",
		AttackIdle = "attack_wait",
		Attack = "attack",
		Hit = "hit",
		Die = "die",
		PlayShow = "playshow",
		Photograph = "shooting",
		Born = "born",
	}
	Asset_Role.ActionPrefix_Mount = "ride"

	Asset_Role.Asset_Role_Inited = true
end

-- init interface begin
-- Asset_Role:SetGUID( guid )
-- Asset_Role:SetClickPriority(p) -- 0 > 1 > 2 ...
-- Asset_Role:SetName( name )
-- Asset_Role:SetInvisible(invisible)
-- Asset_Role:SetShadowEnable( enable )
-- Asset_Role:SetColliderEnable( enable )
-- Asset_Role:SetWeaponDisplay( display )
-- Asset_Role:SetMountDisplay( display )
-- Asset_Role:SetActionSpeed(speed)
-- Asset_Role:PlayAction(params)
-- Asset_Role:SetPosition( p )
-- Asset_Role:SetEulerAngles( p ) or Asset_Role:SetRotation( quaternion )
-- Asset_Role:SetScale( scale )
-- init interface end

local FixKatarAngels = LuaVector3.New(0,0,180)

-- local DelayShowBodyAlphaDuration = 0.3

local PartIndex = Asset_Role.PartIndexEx
local PartCount = Asset_Role.PartCount
local Gender = Asset_Role.Gender
local ActionName = Asset_Role.ActionName
local ActionPrefix_Mount = Asset_Role.ActionPrefix_Mount

local ShowWeaponTypeKey = {
	[1] = "ShowWeapon_1",
	[2] = "ShowWeapon_2",
	[3] = "ShowWeapon_3",
	[4] = "ShowWeapon_4",
	[5] = "ShowWeapon_5",
	[6] = "ShowWeapon_6",
}

local WeakDataKeys = {
	ActionEffect = 1,
}

function Asset_Role.CreatePartArray()
	local array = ReusableTable.CreateRolePartArray()
	for i=1, PartCount do
		array[i] = 0
	end
	return array
end

function Asset_Role.DestroyPartArray(array)
	ReusableTable.DestroyRolePartArray(array)
end

local tempVector3 = LuaVector3.zero
local tempPartArray = Asset_Role.CreatePartArray()
local tempPartArray_1 = Asset_Role.CreatePartArray()

-- parts = {
-- 	[1] = bodyID, -- int, default 0
-- 	[2] = hairID, -- int, default 0
-- 	[3] = leftWeaponID, -- int, default 0
-- 	[4] = rightWeaponID, -- int, default 0
-- 	[5] = headID, -- int, default 0
-- 	[6] = wingID, -- int, default 0
-- 	[7] = faceID, -- int, default 0
-- 	[8] = tailID, -- int, default 0
-- 	[9] = eyeID, -- int, default 0
-- 	[10] = mountID, -- int, default 0
-- 	[11] = gender, -- int, default 0
-- 	[12] = hairColor(index), -- int, default 0
-- 	[13] = eyeColor(index), -- int, default 0
-- 	[14] = smoothDisplay, -- bool, default false
-- }
function Asset_Role.Create( parts )
	return ReusableObject.Create( Asset_Role, true, parts )
end

local tempPlayActionParams = {
	[1] = nil, -- name
	[2] = nil, -- defaultName
	[3] = 1, -- speed
	[4] = 0, -- normalizedTime
	[5] = false, -- loop
	[6] = false, -- force
	[7] = nil, -- callback
	[8] = nil, -- callback arg
	[9] = 0, -- end
}
function Asset_Role.GetPlayActionParams(name, defaultName, speed)
	tempPlayActionParams[1] = name
	tempPlayActionParams[2] = defaultName or name
	tempPlayActionParams[3] = speed
	tempPlayActionParams[4] = 0
	tempPlayActionParams[5] = false
	tempPlayActionParams[6] = false
	tempPlayActionParams[7] = nil
	tempPlayActionParams[8] = nil
	return tempPlayActionParams
end

function Asset_Role.ClearPlayActionParams(params)
	params[7] = nil
	params[8] = nil
end

-- 1 mask face
-- 2 mask hair
-- 4 mask mouth
-- 8 mask eye
function Asset_Role.ApplyMask(parts, mask)
	if nil == mask then
		return
	end
	if 0 ~= BitUtil.band(mask, 0) then
		parts[PartIndex.Face] = 0
	end
	if 0 ~= BitUtil.band(mask, 1) then
		parts[PartIndex.Hair] = 0
	end
	if 0 ~= BitUtil.band(mask, 2) then
		parts[PartIndex.Mouth] = 0
	end
	if 0 ~= BitUtil.band(mask, 3) then
		parts[PartIndex.Eye] = 0
	end
	if 0 ~= BitUtil.band(mask, 4) then
		parts[PartIndex.Head] = 0
	end
end

function Asset_Role.PreprocessParts(parts, gender)
	local headID = parts[PartIndex.Head]
	local hairID = parts[PartIndex.Hair]

	-- head apply mask
	if 0 < headID then
		local headData = Table_Equip[headID]
		if nil ~= headData then
			Asset_Role.ApplyMask(parts, headData.display)
			if 0 ~= parts[PartIndex.Hair] then
				local invalidHairIDs = headData.HairID
				if nil ~= invalidHairIDs and 0 < #invalidHairIDs 
					and 0 < TableUtility.ArrayFindIndex(invalidHairIDs, hairID) then
					if Gender.Male == gender then
						parts[PartIndex.Hair] = 998
					elseif Gender.Female == gender then
						parts[PartIndex.Hair] = 999
					end
				end
			end
		end
	end

	-- face apply mask
	local faceID = parts[PartIndex.Face]
	if 0 < faceID then
		local faceData = Table_Equip[faceID]
		if nil ~= faceData then
			Asset_Role.ApplyMask(parts, faceData.display)
		end
	end

	-- body
	local bodyID = parts[PartIndex.Body];
	if 0 < bodyID then
		local display = Game.Config_BodyDisplay[bodyID];
		if(display)then
			Asset_Role.ApplyMask(parts, display)
		end
	end

	-- local wingID = parts[PartIndex.Wing]
	-- if 0 < wingID then
	-- 	-- switch part index(just wing to tail)
	-- 	local wingInfo = Table_Equip[wingID]
	-- 	if nil ~= wingInfo 
	-- 		and nil ~= wingInfo.CP 
	-- 		and 0 < wingInfo.CP 
	-- 		and PartCount > wingInfo.CP then
	-- 		local newPartIndex = wingInfo.CP+1
	-- 		if PartIndex.Wing ~= newPartIndex then
	-- 			parts[newPartIndex] = wingID
	-- 			parts[PartIndex.Wing] = 0
	-- 		end
	-- 	end
	-- end

	-- -- test begin
	-- if nil == parts[PartIndex.Eye] or 0 == parts[PartIndex.Eye] then
	-- 	if Gender.Male == gender then
	-- 		parts[PartIndex.Eye] = 1
	-- 	elseif Gender.Female == gender then
	-- 		parts[PartIndex.Eye] = 2
	-- 	end 
	-- end
	-- -- test end
end

function Asset_Role:DontDestroyOnLoad()
	GameObject.DontDestroyOnLoad(self.complete.gameObject)

	self.dontDestroyOnLoad = true;
end

function Asset_Role:GetPartID( part )
	return self.partIDs[part]
end

function Asset_Role:GetWeaponID()
	local weaponID = self.partIDs[PartIndex.RightWeapon]
	if 0 == weaponID then
		weaponID = self.partIDs[PartIndex.LeftWeapon]
	end
	return weaponID
end

function Asset_Role:GetPartObject( part )
	return self.partObjs[part]
end

function Asset_Role:GetEP(epID)
	return self.complete:GetEP(epID)
end

function Asset_Role:GetEPOrRoot(epID)
	local epTransform = self.complete:GetEP(epID)
	if nil == epTransform then
		return self.completeTransform
	end
	return epTransform
end

function Asset_Role:GetCP(cpID)
	return self.complete:GetCP(cpID)
end

function Asset_Role:GetCPOrRoot(cpID)
	local cpTransform = self.complete:GetCP(cpID)
	if nil == cpTransform then
		return self.completeTransform
	end
	return cpTransform
end

function Asset_Role:GetPartsInfo(parts)
	local partIDs = self.partIDs
	for i=1, PartCount do
		parts[i] = partIDs[i]
	end
	parts[PartIndex.Gender] = self.gender or 0
	parts[PartIndex.HairColorIndex] = self.hairColorIndex or 0
	parts[PartIndex.EyeColorIndex] = self.eyeColorIndex or 0
	parts[PartIndex.BodyColorIndex] = self.bodyColorIndex or 0
end

function Asset_Role:IgnoreHead(ignore)
	self.ignoreHead = ignore
end

function Asset_Role:IgnoreFace(ignore)
	self.ignoreFace = ignore
end

function Asset_Role:RedressPart( partIndex, partID )
	if self.ignoreHead and PartIndex.Head == partIndex then
		partID = 0
	end
	if self.ignoreFace and PartIndex.Face == partIndex then
		partID = 0
	end
	self:GetPartsInfo(tempPartArray_1)
	if tempPartArray[partIndex] == partID then
		return
	end
	tempPartArray_1[partIndex] = partID
	self:Redress(tempPartArray_1)
end

function Asset_Role:RedressWithCache( parts )
	local headID = parts[PartIndex.Head]
	if self.ignoreHead then
		parts[PartIndex.Head] = 0
	end
	if self.ignoreFace then
		parts[PartIndex.Face] = 0
	end
	local hairID = parts[PartIndex.Hair]
	local faceID = parts[PartIndex.Face]

	local gender = parts[PartIndex.Gender] or 0

	-- 1.
	Asset_Role.PreprocessParts(parts, gender)
	-- 2.
	local allInCache = true
	for i=1, PartCount do
		if 0 ~= parts[i] then
			if 0 >= self.assetManager:GetPartCacheCount(i, parts[i]) then
				allInCache = false
				break
			end
		end
	end
	-- 3.
	if allInCache then
		self:_Redress( parts )
	end

	parts[PartIndex.Head] = headID
	parts[PartIndex.Hair] = hairID
	parts[PartIndex.Face] = faceID

	return allInCache
end

function Asset_Role:Redress( parts )
	local headID = parts[PartIndex.Head]
	if self.ignoreHead then
		parts[PartIndex.Head] = 0
	end
	if self.ignoreFace then
		parts[PartIndex.Face] = 0
	end
	local hairID = parts[PartIndex.Hair]
	local faceID = parts[PartIndex.Face]

	local gender = parts[PartIndex.Gender] or 0

	-- 1.
	Asset_Role.PreprocessParts(parts, gender)
	-- 2.
	self:_Redress( parts )

	parts[PartIndex.Head] = headID
	parts[PartIndex.Hair] = hairID
	parts[PartIndex.Face] = faceID
end

function Asset_Role:_Redress( parts )
	local oldBody = self:GetPartObject(PartIndex.Body)
	local bodyID = parts[PartIndex.Body]

	self.gender = parts[PartIndex.Gender] or 0

	-- 1.
	for i=1, PartCount do
		tempPartArray[i] = self:_SetPartID(i, parts[i])
	end
	for i=1, PartCount do
		local oldID = tempPartArray[i]
		if nil ~= oldID then
			self:_CreatePart(i, oldID)
		end
	end
	-- 2.
	self:SetHairColor(parts[PartIndex.HairColorIndex] or 0)
	self:SetEyeColor(parts[PartIndex.EyeColorIndex] or 0)
	self:SetBodyColor(parts[PartIndex.BodyColorIndex] or 0)

	-- 3.
	if nil == oldBody and 0 ~= bodyID then
		-- alpha to display
		if self:_IsLoading() then
			self:_DressHideBody(true)
		else
			self:_DressHideBody(false)
			self:_SmoothShowBody()
		end
	else
		self:_DressHideBody(false)
	end

	Game.LogicManager_RolePart:OnAssetRoleRedressed(self)
end

function Asset_Role:SetSmoothDisplayBody(duration)
	self.smoothShowBody = duration
end

function Asset_Role:SetGUID( guid )
	self.complete.GUID = guid
end

function Asset_Role:SetClickPriority(p)
	self.complete.clickPriority = p
end

function Asset_Role:SetName( name )
	self.complete.name = name
end

function Asset_Role:SetHairColor( n )
	if 0 == n then
		-- use default
		local hairID = self.partIDs[PartIndex.Hair]
		if 0 ~= hairID then
			n = Table_HairStyle[hairID].DefaultColor or 0
		end
	end
	if n == self.hairColorIndex then
		return
	end
	self.hairColorIndex = n
	self.complete.hairColorIndex = n-1
end

function Asset_Role:SetEyeColor( n )
	if 0 == n then
		-- use default
		local eyeID = self.partIDs[PartIndex.Eye]
		if 0 ~= eyeID then
			n = Table_Eye[eyeID].DefaultColor or 0
		end
	end
	if n == self.eyeColorIndex then
		return
	end
	self.eyeColorIndex = n
	self.complete.eyeColorIndex = n-1
end
function Asset_Role:SetBodyColor( n )
	if 0 == n then
		-- use default
		local bodyID = self.partIDs[PartIndex.Body]
		if 0 ~= bodyID then
			n = Table_Body[bodyID].DefaultColor or 0
		end
	end
	if n == self.bodyColorIndex then
		return
	end
	self.bodyColorIndex = n
	self.complete.bodyColorIndex = n-1
end

function Asset_Role:SetLayer( layer )
	self.complete.layer = layer
end

function Asset_Role:GetInvisible()
	return self.forceInvisible or self.complete.shadowInvisible
end
function Asset_Role:SetInvisible( invisible )
	if nil ~= self.forceInvisible then
		self.realInvisible = invisible
		if invisible then
			invisible = self.forceInvisible
		end
	end
	self.complete.shadowInvisible = invisible
	self:SetBodyDisplay(not invisible)
	self:NotifyObserver(invisible)
end
function Asset_Role:SetForceInvisible( invisible )
	if self.forceInvisible == invisible then
		return
	end
	self.forceInvisible = invisible
	if nil ~= invisible then
		self.realInvisible = self.complete.shadowInvisible
		if not self.realInvisible then
			self.complete.shadowInvisible = invisible
			self:SetBodyDisplay(not invisible)
			self:NotifyObserver(invisible)
		end
	else
		self.complete.shadowInvisible = self.realInvisible
		self:SetBodyDisplay(not self.realInvisible)
		self:NotifyObserver(self.realInvisible)
		self.realInvisible = nil
	end
end

function Asset_Role:SetShadowEnable( enable )
	self.complete.shadowEnable = enable
end

function Asset_Role:GetColliderEnable()
	return self.forceColliderEnable or self.complete.colliderEnable
end
function Asset_Role:SetColliderEnable( enable )
	if nil ~= self.forceColliderEnable then
		self.realColliderEnable = enable
		if enable then
			enable = self.forceColliderEnable
		end
	end
	self.complete.colliderEnable = enable
end
function Asset_Role:SetForceColliderEnable( enable )
	if self.forceColliderEnable == enable then
		return
	end
	self.forceColliderEnable = enable
	if nil ~= enable then
		self.realColliderEnable = self.complete.colliderEnable
		if self.realColliderEnable then
			self.complete.colliderEnable = enable
		end
	else
		self.complete.colliderEnable = self.realColliderEnable
		self.realColliderEnable = nil
	end
end

function Asset_Role:ColliderEnable()
	return self.complete.colliderEnable
end

function Asset_Role:BodyDisplaying()
	return self.bodyDisplay and not self.dressHideBody
end

function Asset_Role:SetBodyDisplay( display )
	if self.bodyDisplay == display then
		return
	end
	self.bodyDisplay = display

	if not self.dressHideBody then
		self.complete.invisible = not display
	end
end

function Asset_Role:_DressHideBody( hide )
	if self.dressHideBody == hide then
		return
	end
	self.dressHideBody = hide

	if hide then
		self.complete.invisible = true
	else
		if self.bodyDisplay then
			self.complete.invisible = false
		end
	end
end

function Asset_Role:_SmoothShowBody()
	if self:BodyDisplaying() and 0 < self.smoothShowBody then
		self:AlphaFromTo(0, self.alpha, self.smoothShowBody)
	end
end

function Asset_Role:WeaponDisplaying()
	return self.weaponDisplay and not self.actionHideWeapon
end

function Asset_Role:SetWeaponDisplay( display )
	if self.weaponDisplay == display then
		return
	end
	self.weaponDisplay = display

	if not self.actionHideWeapon then
		self.complete.weaponEnable = display
	end
end

function Asset_Role:_ActionHideWeapon( hide )
	if self.actionHideWeapon == hide then
		return
	end
	self.actionHideWeapon = hide

	if hide then
		self.complete.weaponEnable = false
	else
		if self.weaponDisplay then
			self.complete.weaponEnable = true
		end
	end
end

function Asset_Role:MountDisplaying()
	return self.mountDisplay and not self.actionHideMount
end

function Asset_Role:SetMountDisplay( display )
	if self.mountDisplay == display then
		return
	end
	self.mountDisplay = display

	if not self.actionHideMount then
		self.complete.mountEnable = display
	end
end

function Asset_Role:_ActionHideMount( hide )
	if self.actionHideMount == hide then
		return
	end
	self.actionHideMount = hide

	if hide then
		self.complete.mountEnable = false
	else
		if self.mountDisplay then
			self.complete.mountEnable = true
		end
	end
end

function Asset_Role:SetActionSpeed(speed)
	if self.actionSpeed == speed then
		return
	end
	self.actionSpeed = speed
	self.complete.actionSpeed = speed * self.speedScale
end

function Asset_Role:SetSpeedScale(scale)
	if self.speedScale == scale then
		return
	end
	self.speedScale = scale
	if nil ~= self.actionSpeed then
		self.complete.actionSpeed = self.actionSpeed * self.speedScale
	end
end

function Asset_Role:SetSuffixReplaceMap(suffixReplace)
	self.suffixReplace = suffixReplace
end

function Asset_Role:IsPlayingActionRaw(name)
	return self.actionRaw == name
end

function Asset_Role:HasActionRaw(name)
	local nameHash = ActionUtility.GetNameHash(name)
	return self.complete:HasAction(nameHash)
end

function Asset_Role:PlayActionRaw(params)
	if not params[6] and self.actionRaw == params[1] then
		return
	end

	local name = params[1]
	if nil == name or "" == name then
		name = ActionName.Idle
	end
	local defaultName = params[2]
	if nil == defaultName or "" == defaultName then
		defaultName = ActionName.Idle
	end
	self.actionRaw = name

	-- hide weapon
	local showWeapon = true
	local bodyID = self:GetPartID(PartIndex.Body)
	-- LogUtility.InfoFormat("<color=yellow>PlayAction: </color>{0}, {1}, {2}", 
	-- 	self.complete.name, bodyID, name)
	if 0 < bodyID then
		local testName = name
		if not self:HasActionRaw(testName) then
			if name ~= defaultName then
				testName = defaultName
				if not self:HasActionRaw(testName) then
					testName = nil
				end
			else
				testName = nil
			end
		end
		if nil ~= testName then
			local showWeaponType = Table_Body[bodyID].ShowWeaponType
			local actionConfig = Game.Config_Action[testName]
			if nil ~= actionConfig then
				showWeapon = (1 == actionConfig[ShowWeaponTypeKey[showWeaponType]])
			end
		end
	end
	self:SetWeaponDisplay(showWeapon)

	-- set speed
	if nil ~= params[3] then
		self.actionSpeed = params[3]
	elseif nil == self.actionSpeed then
		self.actionSpeed = 1
	end

	local nameHash = ActionUtility.GetNameHash(name)
	local defaultNameHash = ActionUtility.GetNameHash(defaultName)
	self.complete:PlayAction(
		nameHash, 
		defaultNameHash, 
		self.actionSpeed * self.speedScale, 
		params[4], 
		params[5],
		params[7],
		params[8])

	-- action effect
	self:PlayActionEffect(name)
end

function Asset_Role:PlayActionRaw_Simple(name, defaultName, speed)
	self:PlayActionRaw(Asset_Role.GetPlayActionParams(name, defaultName, speed))
end

function Asset_Role:GetActionSuffix()
	local weaponID = self:GetWeaponID()
	if 0 ~= weaponID then
		if nil == Table_Equip[weaponID] then
			LogUtility.InfoFormat("<color=red>Table_Equip[{0}] is nil</color>", 
				weaponID)
			return nil
		end
		local weaponType = Table_Equip[weaponID].Type
		if nil ~= weaponType and "" ~= weaponType then
			if(self.suffixReplace~=nil) then
				local suffixReplaced = self.suffixReplace[weaponType]
				if(nil ~= suffixReplaced and ""~=suffixReplaced) then
					return suffixReplaced
				end
			end
			return weaponType
		end
	end
	return nil
end

function Asset_Role:GetFullAction(name,ignoreMount)
	local namePrefix = nil
	local nameSuffix = self:GetActionSuffix()

	if not ignoreMount and self:MountDisplaying() then
		namePrefix = ActionPrefix_Mount
	elseif nil == nameSuffix then
		return name
	end
	return ActionUtility.BuildName(name, namePrefix, nameSuffix)
end

function Asset_Role:IsPlayingAction(name)
	return self.action == name
end

function Asset_Role:HasAction(name)
	return self:HasActionRaw(self:GetFullAction(name))
end

function Asset_Role:HasActionIgnoreMount(name)
	return self:HasActionRaw(self:GetFullAction(name,true))
end

function Asset_Role:_PrePlayAction(params)
	if not params[6] and self.action == params[1] then
		return false
	end
	local name = params[1]
	if nil == name or "" == name then
		name = ActionName.Idle
	end
	local defaultName = params[2]
	if nil == defaultName or "" == defaultName then
		defaultName = ActionName.Idle
	end
	self.action = name
	self.actionDefault = defaultName

	-- handle name
	local namePrefix = nil
	local nameSuffix = self:GetActionSuffix()
	local fullName = name

	-- mount
	local objMount = self.partObjs[PartIndex.Mount]
	if nil ~= objMount then
		local tempName = ActionUtility.BuildName(name, ActionPrefix_Mount)
		if self.actionHideMount then
			if self:HasActionRaw(tempName) then
				self:_ActionHideMount(false)
			elseif nil ~= nameSuffix then
				-- try suffix
				tempName = ActionUtility.BuildName(name, ActionPrefix_Mount, nameSuffix)
				if self:HasActionRaw(tempName) then
					self:_ActionHideMount(false)
					fullName = tempName
					nameSuffix = nil
				end
			end
		else
			if not self:HasActionRaw(tempName) then
				if nil ~= nameSuffix then
					-- try suffix
					tempName = ActionUtility.BuildName(name, ActionPrefix_Mount, nameSuffix)
					if not self:HasActionRaw(tempName) then
						self:_ActionHideMount(true)
					end
				else
					self:_ActionHideMount(true)
				end
			end
		end

		if self:MountDisplaying() then
			namePrefix = ActionPrefix_Mount
			fullName = tempName
		end
	else
		self:_ActionHideMount(true)
	end

	-- suffix
	if nil ~= nameSuffix then
		local tempName = ActionUtility.BuildName(name, namePrefix, nameSuffix)
		if self:HasActionRaw(tempName) then
			fullName = tempName
		end
	end
	name = fullName

	if ActionName.Die == params[1] then
		self:StartPlayActionDie()
	else
		self:EndPlayActionDie()
	end

	-- reset name
	params[1] = name
	return true
end

function Asset_Role:PlayAction(params)
	if not self:_PrePlayAction(params) then
		return
	end
	self:PlayActionRaw(params)
end

function Asset_Role:PlayAction_Simple(name, defaultName, speed)
	self:PlayAction(Asset_Role.GetPlayActionParams(name, defaultName, speed))
end

function Asset_Role:PlayAction_Idle()
	self:PlayAction_Simple(ActionName.Idle)
end
function Asset_Role:PlayAction_Move()
	self:PlayAction_Simple(ActionName.Move)
end
function Asset_Role:PlayAction_Sitdown()
	self:PlayAction_Simple(ActionName.Sitdown)
end
function Asset_Role:PlayAction_AttackIdle()
	self:PlayAction_Simple(ActionName.AttackIdle)
end
function Asset_Role:PlayAction_Attack()
	self:PlayAction_Simple(ActionName.Attack)
end
function Asset_Role:PlayAction_Hit()
	self:PlayAction_Simple(ActionName.Hit)
end
function Asset_Role:PlayAction_Die()
	self:PlayAction_Simple(ActionName.Die)
end
function Asset_Role:PlayAction_PlayShow()
	self:PlayAction_Simple(ActionName.PlayShow)
end

function Asset_Role:StartPlayActionDie()
	if self.actionDiePlaying then
		return
	end
	self.actionDiePlaying = true
	self:DoSpectialHeadDie()
end

function Asset_Role:EndPlayActionDie()
	if not self.actionDiePlaying then
		return
	end
	self.actionDiePlaying = false
	self:UndoSpectialHeadDie()
end

function Asset_Role:DoSpectialAssesoryDie_(partID)
	if nil == Table_AssesoriesDie then
		return false
	end

	local partObj = self.partObjs[partID]
	if nil == partObj then
		return false
	end

	local assesoryID = self.partIDs[partID]
	local dieConfig = Table_AssesoriesDie[assesoryID]
	if nil == dieConfig then
		return false
	end

	tempVector3:Set(0,0,0)

	local bodyID = self.partIDs[PartIndex.Body]
	local bodyConfig = Table_Body[bodyID]
	if nil ~= bodyConfig and nil ~= bodyConfig.AssesoriesDiePoint and 3 <= #bodyConfig.AssesoriesDiePoint then
		tempVector3:Add(bodyConfig.AssesoriesDiePoint)
	end

	if nil ~= dieConfig.CheepCoordinate and 3 <= #dieConfig.CheepCoordinate then
		tempVector3:Add(dieConfig.CheepCoordinate)
	end

	local objTransform = partObj.transform
	objTransform.parent = self.completeTransform
	objTransform.localPosition = tempVector3
	objTransform.localRotation = LuaGeometry.Const_V3_zero
	objTransform.localScale = LuaGeometry.Const_V3_one

	return true
end

function Asset_Role:UndoSpectialAssesoryDie_(partID)
	local partObj = self.partObjs[partID]
	if nil == partObj then
		return
	end

	local objTransform = partObj.transform
	if objTransform.parent == self.completeTransform then
		local cp = self:GetCP(partID-1)
		if nil ~= cp then
			objTransform.parent = cp
			objTransform.localPosition = LuaGeometry.Const_V3_zero
			objTransform.localRotation = LuaGeometry.Const_V3_zero
			objTransform.localScale = LuaGeometry.Const_V3_one
		end
	end
end

function Asset_Role:DoSpectialHeadDie()
	local i = 0
	if self:DoSpectialAssesoryDie_(PartIndex.Head) then
		i = i+1
	end
	if self:DoSpectialAssesoryDie_(PartIndex.Wing) then
		i = i+1
	end
	if self:DoSpectialAssesoryDie_(PartIndex.Tail) then
		i = i+1
	end
	self.ignoreLogic = (0 < i)
end

function Asset_Role:UndoSpectialHeadDie()
	self.ignoreLogic = nil
	self:UndoSpectialAssesoryDie_(PartIndex.Head)
	self:UndoSpectialAssesoryDie_(PartIndex.Wing)
	self:UndoSpectialAssesoryDie_(PartIndex.Tail)
end

function Asset_Role:NoLogic()
	return self.ignoreLogic
end

function Asset_Role:SetParent( p, worldPositionStays )
	worldPositionStays = worldPositionStays or false
	self.completeTransform:SetParent(p, worldPositionStays)

	if(self.dontDestroyOnLoad)then
		GameObject.DontDestroyOnLoad(self.complete.gameObject);
	end
end

function Asset_Role:SetPosition( p )
	self.completeTransform.localPosition = p
end

function Asset_Role:SetRotation( quaternion )
	self.completeTransform.localRotation = quaternion
end

function Asset_Role:SetEulerAngles( p )
	self.completeTransform.localEulerAngles = p
end

function Asset_Role:SetEulerAngleY( v )
	-- LuaGameObject.SetLocalEulerAngleY(self.completeTransform, v)
	tempVector3:Set(0, v, 0)
	self.completeTransform.localEulerAngles = tempVector3
end

function Asset_Role:SetScale( scale )
	if(scale == 0)then
		helplog("Asset_Role SetScale");
	end
	tempVector3:Set(scale, scale, scale)
	self.completeTransform.localScale = tempVector3
end

function Asset_Role:SetScaleXYZ( x,y,z )
	if(x==0 and y==0 and z==0)then
		helplog("Asset_Role SetScale");
	end
	tempVector3:Set(x, y, z)
	self.completeTransform.localScale = tempVector3
end

function Asset_Role:RotateTo( p )
	LuaGameObject.LocalRotateToByAxisY(self.completeTransform, p)
end

function Asset_Role:RotateDelta( delta )
	LuaGameObject.LocalRotateDeltaByAxisY(self.completeTransform, delta)
end

function Asset_Role:GetPositionXYZ()
	return LuaGameObject.GetPosition(self.completeTransform)
end

function Asset_Role:GetEulerAnglesXYZ()
	return LuaGameObject.GetEulerAngles(self.completeTransform)
end

function Asset_Role:GetScaleXYZ()
	return LuaGameObject.GetScale(self.completeTransform)
end

function Asset_Role:TransformPoint(p, ret)
	ret:Set(LuaGameObject.TransformPoint(self.completeTransform, p))
end

function Asset_Role:InverseTransformPoint(p, ret)
	ret:Set(LuaGameObject.InverseTransformPointByVector3(self.completeTransform, p))
end

-- effect begin
function Asset_Role:PlayActionEffect(action)
	local oldActionEffect = self:GetWeakData(WeakDataKeys.ActionEffect)
	if oldActionEffect ~= nil then
		oldActionEffect:Destroy()
		self:SetWeakData(WeakDataKeys.ActionEffect)
	end

	local bodyID = self:GetPartID(PartIndex.Body)
	if bodyID > 0 then
		local configs = Game.Config_ActionEffect[bodyID]
		if configs == nil then
			return
		end

		for i=1,#configs do
			local config = Table_ActionEffect[configs[i]]
			if config ~= nil and config.NameAction == action then
				local effectConfig = Table_ActionEffectSetUp[config.EffectID]
				if effectConfig ~= nil then
					if effectConfig.Loop == 1 then
						local effect
						if effectConfig.EPFollow == 1 then
							effect = self:PlayEffectOn(effectConfig.Path, effectConfig.EPID)
						else
							effect = self:PlayEffectAt(effectConfig.Path, effectConfig.EPID)
						end

						self:CreateWeakData()
						self:SetWeakData(WeakDataKeys.ActionEffect, effect)
					else
						if effectConfig.EPFollow == 1 then
							self:PlayEffectOneShotOn(effectConfig.Path, effectConfig.EPID)
						else
							self:PlayEffectOneShotAt(effectConfig.Path, effectConfig.EPID)
						end
					end
				end
			end
		end
	end
end

-- it will be auto destroy(so don't cache it)
function Asset_Role:PlayEffectOneShotAt( path, epID, offset, callback, callbackArg  )
	local epTransform = self:GetEP(epID)
	if nil ~= epTransform then
		tempVector3:Set(LuaGameObject.GetPosition(epTransform))
	else
		tempVector3:Set(LuaGameObject.GetPosition(self.completeTransform))
	end
	if nil ~= offset then
		tempVector3:Add(offset)
	end
	local effect = Asset_Effect.PlayOneShotAt(path, tempVector3, callback, callbackArg )
	if(self:GetInvisible()) then
		effect:Stop()
	end
	return effect
end

-- it will be auto destroy(so don't cache it)
function Asset_Role:PlayEffectOneShotOn( path, epID, offset, callback, callbackArg  )
	local effect = nil

	if 0 ~= epID then
		local epTransform = self:GetEP(epID)
		if nil ~= epTransform then
			effect = Asset_Effect.PlayOneShotOn( path, epTransform, callback, callbackArg  )
		else
			effect = Asset_Effect.PlayOneShotOn( path, self.complete.tempOwner, callback, callbackArg  )
		end
	else
		effect = Asset_Effect.PlayOneShotOn( path, self.completeTransform, callback, callbackArg  )
	end
	if nil ~= offset then
		effect:ResetLocalPosition(offset)
	end
	effect:ObserveRole(self, epID)
	if(self:GetInvisible()) then
		effect:Stop()
	end
	return effect
end

-- return Asset_Effect
function Asset_Role:PlayEffectAt( path, epID, offset, callback, callbackArg  )
	local epTransform = self:GetEP(epID)
	if nil ~= epTransform then
		local x,y,z = LuaGameObject.GetPosition(epTransform)
		return Asset_Effect.PlayAtXYZ(
			path, 
			x,y,z, -- must use local x,y,z
			callback, 
			callbackArg )
	else
		return Asset_Effect.PlayAtXYZ(
			path, 
			LuaGameObject.GetPosition(self.completeTransform))
	end
end

-- return Asset_Effect(it maybe Destroy when Asset_Role Destroy)
function Asset_Role:PlayEffectOn( path, epID, offset, callback, callbackArg  )
	local effect = nil

	if 0 ~= epID then
		local epTransform = self:GetEP(epID)
		if nil ~= epTransform then
			effect = Asset_Effect.PlayOn( path, epTransform, callback, callbackArg )
		else
			effect = Asset_Effect.PlayOn( path, self.complete.tempOwner, callback, callbackArg  )
		end
	else
		effect = Asset_Effect.PlayOn( path, self.completeTransform, callback, callbackArg  )
	end
	
	if nil ~= offset then
		effect:ResetLocalPosition(offset)
	end
	effect:ObserveRole(self, epID)
	return effect
end
-- effect end

-- SE begin
function Asset_Role:PlaySEOneShotAt( path, epID, offset )
	local epTransform = self:GetEP(epID)
	if nil ~= epTransform then
		tempVector3:Set(LuaGameObject.GetPosition(epTransform))
	else
		tempVector3:Set(LuaGameObject.GetPosition(self.completeTransform))
	end
	if nil ~= offset then
		tempVector3:Add(offset)
	end

	local resPath = ResourcePathHelper.AudioSE(path)
	AudioUtility.PlayOneShotAt_Path(resPath, tempVector3)
end
function Asset_Role:PlaySEOneShotOn( path )
	local resPath = ResourcePathHelper.AudioSE(path)
	AudioUtility.PlayOneShotOn_Path(resPath, self.audioSource)
end
function Asset_Role:PlaySEOn( path )
	local resPath = ResourcePathHelper.AudioSE(path)
	AudioUtility.PlayOn_Path(resPath, self.audioSource)
end
-- SE end

-- render begin
function Asset_Role:SetRenderEnable(enable)
	self.complete.renderEnable = enable
end
function Asset_Role:AlphaTo(alpha, duration)
	self.alpha = alpha
	self.complete:AlphaTo(alpha, duration)
end
function Asset_Role:AlphaFromTo(fromAlpha, toAlpha, duration)
	self.alpha = toAlpha
	self.complete:AlphaFromTo(fromAlpha, toAlpha, duration)
end
function Asset_Role:ChangeColorTo(color, duration)
	self.complete:ChangeColorTo(color, duration)
end
function Asset_Role:ChangeColorFromTo(fromColor, toColor, duration)
	self.complete:ChangeColorFromTo(fromColor, toColor, duration)
end
-- render end

function Asset_Role:_DestroyPartObject(part, oldID, undress)
	local oldPartObj = self.partObjs[part]
	self.partObjs[part] = nil
	if nil ~= oldPartObj then
		self.complete:SetPart(part-1, nil, undress)
		self.assetManager:DestroyPart(part, oldID, oldPartObj)

		if undress and PartIndex.Mount == part and self:MountDisplaying() then
			-- restore action
			self:RestoreAction()
		elseif PartIndex.LeftWeapon == part or PartIndex.RightWeapon == part then
			self:RestoreWeaponAction()
		end
	end
end

function Asset_Role:_CancelLoading(part, oldID)
	local oldPartLoadTag = self.loadTags[part]
	self.loadTags[part] = nil
	if nil ~= oldPartLoadTag then
		self.assetManager:CancelCreatePart(part, oldID, oldPartLoadTag)
	end
end

function Asset_Role:_SetPartID( part, ID )
	local oldID = self.partIDs[part]
	if oldID == ID then
		return nil -- no need to _CreatePart
	end
	self.partIDs[part] = ID

	if 0 ~= oldID then
		self:_CancelLoading(part, oldID)
		if 0 ~= ID then
			-- delay to dress and move effects
			-- self:_DestroyPartObject(part, oldID, true) 
		else
			-- move effect
			if PartIndex.Body == part then
				local oldObj = self.partObjs[part]
				if nil ~= oldObj then
					oldObj:MoveEffectToTransform(self.complete.tempOwner)
				end
			end
			self:_DestroyPartObject(part, oldID, true)
		end
	end

	return oldID
end

function Asset_Role:_CreatePart( part, oldID )
	local ID = self.partIDs[part]
	if 0 ~= ID then
		-- temp ignore eye
		-- if PartIndex.Eye == part then
		-- 	return
		-- end
		local loadTag = self.assetManager:CreatePart(part, ID, self.OnPartCreated, self, oldID)
		if nil ~= loadTag then
			self.loadTags[part] = loadTag
		end
	end
end

function Asset_Role:OnPartCreated( tag, obj, part, ID, oldID )
	if self.partIDs[part] ~= ID or self.loadTags[part] ~= tag then
		self.assetManager:DestroyPart(part, ID, obj)
		return
	end
	self.loadTags[part] = nil
	if nil == obj then
		LogUtility.WarningFormat("Load Role Part Failed: part={0}, ID={1}", part, ID)
	end
	self:_TryDressPart(part, obj, oldID)
end

function Asset_Role:RestoreAction()
	self.complete:ActionCallback() -- try fixbug
	if nil ~= self.action and nil ~= self.actionRaw then
		local config = Game.Config_Action[self.actionRaw]
		if nil ~= config then
			local restoreType = config.RestoreType
			if 1 == restoreType then
				-- don't restore
				self:PlayAction_Idle()
			elseif 2 == restoreType then
				-- restore
				local params = Asset_Role.GetPlayActionParams(self.action, self.actionDefault)
				params[6] = true -- force
				self:PlayAction(params)
			elseif 3 == restoreType then
				-- restore to last frame
				local params = Asset_Role.GetPlayActionParams(self.action, self.actionDefault)
				params[4] = 1 -- normalizedTime
				params[6] = true -- force
				self:PlayAction(params)
			end
		else
			LogUtility.InfoFormat("<color=red>Action no config: </color>{0}", self.actionRaw)
		end
	end
end

function Asset_Role:RestoreWeaponAction()
	if nil ~= self.action and nil ~= self.actionRaw then
		local config = Game.Config_Action[self.actionRaw]
		if nil ~= config then
			if 1 == config.CheckMatching then
				-- restore
				local params = Asset_Role.GetPlayActionParams(self.action, self.actionDefault)
				params[6] = true -- force
				self:_PrePlayAction(params)
				params[6] = false -- not force
				self:PlayActionRaw(params)
			end
		else
			LogUtility.InfoFormat("<color=red>Action no config: </color>{0}", self.actionRaw)
		end
	end
end

function Asset_Role:_IsLoading()
	for part=1, PartCount do
		if nil ~= self.loadTags[part] then
			return true
		end
	end
	return false
end

function Asset_Role:_TryFlipRightWeapon(obj)
	if(nil ~= obj) then
		local weaponID = self.partIDs[PartIndex.RightWeapon]
		if(weaponID~=0) then
			local weaponType = Table_Equip[weaponID].Type
			if "Katar" == weaponType 
				or "Knuckle" == weaponType then
					obj.transform.localEulerAngles = FixKatarAngels
			end
		end
	end
end

function Asset_Role:_TryDressPart(part, obj, oldID)
	-- move effect
	if PartIndex.Body == part then
		local oldObj = self.partObjs[part]
		if nil ~= oldObj then
			if nil ~= obj then
				oldObj:MoveEffect(obj)
			else
				oldObj:MoveEffectToTransform(self.complete.tempOwner)
			end
		end
	end

	self:_DestroyPartObject(part, oldID, true)
	if nil ~= obj then
		self.complete:SetPart(part-1, obj, true)
	end
	self.partObjs[part] = obj

	-- restore action
	if PartIndex.Body == part then
		if self.actionDiePlaying then
			self:DoSpectialHeadDie()
		end
		self:RestoreAction()
		self:_TryFlipRightWeapon(self.partObjs[PartIndex.RightWeapon])
	elseif PartIndex.Mount == part then
		self:RestoreAction()
	elseif PartIndex.LeftWeapon == part then
		self:RestoreWeaponAction()
	elseif PartIndex.RightWeapon == part then
		self:RestoreWeaponAction()
		self:_TryFlipRightWeapon(obj)
	elseif PartIndex.Head == part then
		if self.actionDiePlaying then
			self:DoSpectialHeadDie()
		end
	end
	if not self:_IsLoading() then
		local bodyHidding = self.dressHideBody
		self:_DressHideBody(false)
		if bodyHidding then
			self:_SmoothShowBody()
		end
	end
end

-- override begin
function Asset_Role:DoConstruct(asArray, parts)
	Debug_AssertFormat(PartCount <= #parts, "Asset_Role args length invalid: {0}", #parts)
	
	self.assetManager = Game.AssetManager_Role
	self.partIDs = Asset_Role.CreatePartArray()
	self.partObjs = ReusableTable.CreateRolePartTable()
	self.loadTags = ReusableTable.CreateRolePartTable()

	self.gender = 0
	self.hairColorIndex = 0
	self.eyeColorIndex = 0
	self.bodyColorIndex = 0

	self.complete = self.assetManager:CreateComplete()
	self.complete.GUID = 0
	self.completeTransform = self.complete.transform
	self.audioSource = self.complete.audioSource

	self.weaponDisplay = false
	self.mountDisplay = false
	self.actionHideMount = false
	self.actionHideWeapon = false
	self.actionSpeed = nil
	self.action = nil
	self.actionDefault = nil
	self.actionRaw = nil
	self.actionDiePlaying = false
	self.bodyDisplay = true
	self.dressHideBody = false
	self.smoothShowBody = parts[PartIndex.SmoothDisplay] or 0
	self.alpha = 1
	self.speedScale = 1

	self.forceInvisible = nil
	self.realInvisible = nil
	self.forceColliderEnable = nil
	self.realColliderEnable = nil

	self.ignoreHead = nil
	self.ignoreFace = nil
	self.ignoreLogic = nil

	self:Redress(parts)
end

function Asset_Role:DoDeconstruct(asArray)
	for part=1, PartCount do
		local ID = self.partIDs[part]
		self:_CancelLoading(part, ID)
		self:_DestroyPartObject(part, ID, false)
	end

	self.assetManager:DestroyComplete(self.complete)
	self.complete = nil
	self.dontDestroyOnLoad = nil;
	self.completeTransform = nil
	self.audioSource = nil

	Asset_Role.DestroyPartArray(self.partIDs)
	self.partIDs = nil
	ReusableTable.DestroyRolePartTable(self.partObjs)
	self.partObjs = nil
	ReusableTable.DestroyRolePartTable(self.loadTags)
	self.loadTags = nil

	self.suffixReplace = nil
end
-- override end