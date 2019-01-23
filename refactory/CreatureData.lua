autoImport("BehaviourData")
autoImport("AttrEffect")
CreatureData = class("CreatureData",ReusableObject)

CreatureData.MoveSpeedFactor = 3.5
CreatureData.RotateSpeedFactor = 720
CreatureData.ScaleSpeedFactor = 1

local CompatibilityMode_V9 = BackwardCompatibilityUtil.CompatibilityMode_V9
local CullingIDUtility = CullingIDUtility
local ArrayRemove = TableUtility.ArrayRemove
local DestroyArray = ReusableTable.DestroyArray

-- 生物的数据基类
function CreatureData:ctor()
	CreatureData.super.ctor(self)
	--唯一标识ID
	self.id = nil
	--阵营
	self:SetCamp(RoleDefines_Camp.NEUTRAL)

	self.bodyScale = nil

	-- options
	-- self.petIDs = nil
end

function CreatureData:GetHoldScale()
	return 1
end

function CreatureData:GetHoldDir()
	return 0
end

local defaultOffest = {}
function CreatureData:GetHoldOffset()
	return defaultOffest
end

function CreatureData:GetDefaultGear()
	return nil
end

function CreatureData:GetName()
	return nil
end

function CreatureData:SetCamp(camp)
	self.camp = camp
end

function CreatureData:GetCamp()
	return self.camp
end

function CreatureData:NoAccessable()
	return true
end

function CreatureData:NoPlayIdle()
	return false
end

function CreatureData:NoPlayShow()
	return false
end

function CreatureData:NoAutoAttack()
	return false
end

function CreatureData:GetGuid()
	return self.id
end

function CreatureData:GetFollowEP()
	return 0
end

function CreatureData:GetFollowType()
	return 0
end

function CreatureData:GetInnerRange()
	return 0
end

function CreatureData:GetOutterRange()
	return 0
end

function CreatureData:GetOutterHeight()
	return 0
end

function CreatureData:GetDampDuration()
	return 0
end

function CreatureData:ReturnMoveSpeedWithFactor(moveSpeed)
	return (moveSpeed or 1 )*CreatureData.MoveSpeedFactor
end

function CreatureData:ReturnRotateSpeedWithFactor(rotateSpeed)
	return (rotateSpeed or 1 )*CreatureData.RotateSpeedFactor
end


function CreatureData:ReturnScaleSpeedWithFactor(scaleSpeed)
	return (scaleSpeed or 1 )*CreatureData.ScaleSpeedFactor
end

function CreatureData:GetClickPriority()
	local camp = self:GetCamp()
	if(camp == RoleDefines_Camp.ENEMY) then
		return 0
	elseif(camp == RoleDefines_Camp.NEUTRAL)then
		return 1
	elseif(camp == RoleDefines_Camp.FRIEND)then
		return 2
	end
	return 0
end

function CreatureData:SetDressEnable(v)
	self.dressEnable = v
end

function CreatureData:IsDressEnable()
	return self.dressEnable
end

function CreatureData:SetBaseLv(value)
	self.BaseLv = value;
end

function CreatureData:AddPetID(petID)
	if(self.petIDs == nil) then
		self.petIDs = ReusableTable.CreateArray()
	end
	if(TableUtility.ArrayFindIndex(self.petIDs, petID) < 1) then
		self.petIDs[#self.petIDs+1] = petID
	end
end

function CreatureData:RemovePetID(petID)
	if(self.petIDs ~= nil) then
		TableUtility.ArrayRemove(self.petIDs, petID)
	end
end

function CreatureData:SpawnCullingID()
	if CompatibilityMode_V9 then
		self.cullingID = CullingIDUtility.GetID()
	else
		self.cullingID = self.id
	end
end

function CreatureData:ClearCullingID()
	if CompatibilityMode_V9 and self.cullingID ~=nil then
		CullingIDUtility.ClearID(self.cullingID)
	end
	self.cullingID = nil
end

function CreatureData:GetDefaultScale()
	return 1
end

function CreatureData:GetClassID()
	return 0
end

function CreatureData:IsBeingPresent(beingID)
	local being = PetProxy.Instance:GetMyBeingNpcInfo(beingID)
	if(being) then
		return being:IsSummoned()
	end
	return false
end

function CreatureData:InGuildZone()
	return false;
end

function CreatureData:InSuperGvg()
	return false;
end

--features start
function CreatureData:GetFeature(bit)
	return false
end

function CreatureData:GetFeature_ChangeLinePunish()
	return false
end

function CreatureData:GetFeature_BeHold()
	return false
end

--features end

-- override begin
function CreatureData:DoConstruct(asArray, parts)
	self.dressEnable = false
end

function CreatureData:DoDeconstruct(asArray)
	if(self.petIDs ~= nil) then
		ReusableTable.DestroyArray(self.petIDs)
		self.petIDs = nil
	end
	self:ClearCullingID()
end

CreatureDataWithPropUserdata = class("CreatureDataWithPropUserdata",CreatureData)

-- 生物的数据（带有属性）
function CreatureDataWithPropUserdata:ctor()
	CreatureDataWithPropUserdata.super.ctor(self)
	--生物属性
	self.props = RolePropsContainer.CreateAsTable()
	self.clientProps = ClientProps.new(self.props.config)
	--生物数据
	self.userdata = UserData.CreateAsTable()

	self.attrEffect = AttrEffect.new()

	self.attrEffect2 = AttrEffectB.new()
	
	self:Reset()
end

function CreatureDataWithPropUserdata:Reset()
	--action
	self.idleAction = nil
	self.moveAction = nil

	--some props
	self.normalAtkID = nil
	self.noStiff = 0;
	self.noAttack = 0;
	self.noSkill = 0;
	self.noPicked = 0;
	self.noAccessable = 0;
	self.noMove = 0;
	self.noAction = 0;
	self.noAttacked = 0;

	--commonfun要计算的属性
	self.shape = nil
	self.race = nil

	self.bodyScale = nil
end

--CommonFun begin
--获取属性
function CreatureDataWithPropUserdata:GetProperty(name)
	if nil == self.props[name] then
		return 0
	end
	return self.props[name]:GetValue()
end

function CreatureDataWithPropUserdata:GetJobLv()
	if( nil ~= self.userdata ) then
		return self.userdata:Get(UDEnum.JOBLEVEL)
	end
	return 1
end

function CreatureDataWithPropUserdata:GetBaseLv()
	if( nil ~= self.userdata ) then
		return self.userdata:Get(UDEnum.ROLELEVEL)
	end
	return 1
end

function CreatureDataWithPropUserdata:GetLernedSkillLevel(skillID)
	return 0
end

function CreatureDataWithPropUserdata:GetDynamicSkillInfo(skillID)
	return nil
end

function CreatureDataWithPropUserdata:IsEnemy(creatureData)
	return creatureData:GetCamp() == RoleDefines_Camp.ENEMY
end

function CreatureDataWithPropUserdata:IsImmuneSkill(skillID)
	return false
end

function CreatureDataWithPropUserdata:IgnoreJinzhanDamage()
    return nil ~= self.attrEffect 
		and self.attrEffect:IgnoreJinzhanDamage()
end

function CreatureDataWithPropUserdata:IsFly()
	return false
end

function CreatureDataWithPropUserdata:SelfBuffChangeSkill(skillIDAndLevel_0)
	if nil == self.skillBuffs then
		return nil
	end
    local buff = self.skillBuffs:GetOwner(BuffConfig.SelfBuff)
	if nil == buff then
		return nil
	end
	return buff:GetParamsByType(BuffConfig.changeskill)[skillIDAndLevel_0]
end

function CreatureDataWithPropUserdata:GetProfressionID()
    return nil ~= self.userdata
    	and self.userdata:Get(UDEnum.PROFESSION) or 0
end

function CreatureDataWithPropUserdata:DefiniteHitAndCritical()
    return nil ~= self.attrEffect 
		and self.attrEffect:DefiniteHitAndCritical()
end

function CreatureDataWithPropUserdata:NextPointTargetSkillLargeLaunchRange()
    return nil ~= self.attrEffect2 
		and self.attrEffect2:NextPointTargetSkillLargeLaunchRange()
end

function CreatureDataWithPropUserdata:NextSkillNoReady()
    return nil ~= self.attrEffect2 
		and self.attrEffect2:NextSkillNoReady()
end

function CreatureDataWithPropUserdata:CanNotBeSkillTargetByEnemy()
    return nil ~= self.attrEffect2 
		and self.attrEffect2:CanNotBeSkillTargetByEnemy()
end

--普攻Id
function CreatureDataWithPropUserdata:GetAttackSkillIDAndLevel()
    return self.normalAtkID or 0
end

function CreatureDataWithPropUserdata:DamageAlways1()
	return false
end

function CreatureDataWithPropUserdata:GetRandom()
   return nil
end

function CreatureDataWithPropUserdata:RemoveInvalidHatred()
end

function CreatureDataWithPropUserdata:RefreshHatred(id)
end

function CreatureDataWithPropUserdata:CheckHatred(id, time)
   return false
end

function CreatureDataWithPropUserdata:GetArrowID()
	return 0
end

function CreatureDataWithPropUserdata:GetEquipedRefineLv(site)
	return 0
end

function CreatureDataWithPropUserdata:GetEquipedItemNum(itemid)
	return 0
end

function CreatureDataWithPropUserdata:GetEquipedWeaponType()
	return 0
end

function CreatureDataWithPropUserdata:GetEquipedType(site)
	return 0
end

function CreatureDataWithPropUserdata:GetEquipedID(site)
	return 0
end

function CreatureDataWithPropUserdata:GetCartNums()
	return 0,0
end

function CreatureDataWithPropUserdata:GetPackageItemNum(itemid)
	return 0
end

function CreatureDataWithPropUserdata:GetEnchantAttrsBySite(site)
	return nil
end

function CreatureDataWithPropUserdata:GetCombineEffectsBySite(site)
	return nil
end

function CreatureDataWithPropUserdata:GetCurrentSkill()
	return self.currentSkill
end

function CreatureDataWithPropUserdata:SetCurrentSkill(skillLogic)
	self.currentSkill = skillLogic
end

function CreatureDataWithPropUserdata:ClearCurrentSkill(skillLogic)
	if self.currentSkill == skillLogic then
		self.currentSkill = nil
	end
end

--访问距离
function CreatureDataWithPropUserdata:GetAccessRange()
	return 2
end

--攻击速度
function CreatureDataWithPropUserdata:SetAttackSpeed(s)
	self.attackSpeed = s
	self.attackSpeedAdjusted = 1/(1/s+0.1)*1.05
end

function CreatureDataWithPropUserdata:GetAttackSpeed()
	return self.attackSpeed
end

function CreatureDataWithPropUserdata:GetAttackSpeed_Adjusted()
	return self.attackSpeedAdjusted
end

function CreatureDataWithPropUserdata:NoStiff()
	return 0 < self.noStiff
end

function CreatureDataWithPropUserdata:NoAttack()
	return 0 < self.noAttack
end

function CreatureDataWithPropUserdata:NoSkill()
	return 0 < self.noSkill
end

function CreatureDataWithPropUserdata:NoHitEffectMove()
	return self.props.NoEffectMove:GetValue() & 1 >0
end

function CreatureDataWithPropUserdata:NoAttackEffectMove()
	return self.props.NoEffectMove:GetValue() & 2 >0
end

function CreatureDataWithPropUserdata:NoPicked()
	return 0 < self.noPicked
end

function CreatureDataWithPropUserdata:NoAccessable()
	return 0 < self.noAccessable or 0 < self.noPicked
end

function CreatureDataWithPropUserdata:NoMove()
	return 0 < self.noMove
end

function CreatureDataWithPropUserdata:NoAttacked()
	return 0 < self.noAttacked
end

function CreatureDataWithPropUserdata:NoAct()
	return 0 < self.props.NoAct:GetValue()
end

function CreatureDataWithPropUserdata:Freeze()
	if(self:WeakFreeze()) then
		return true
	end
	return 0 < self.props.Freeze:GetValue()
end

--client use
function CreatureDataWithPropUserdata:WeakFreeze()
	if(self.weakFreezeBuffs and self.weakFreezeBuffs.count > 0) then
		return true
	end
	return false
end

function CreatureDataWithPropUserdata:FearRun()
	return 0 < self.props.FearRun:GetValue()
end

function CreatureDataWithPropUserdata:PlusClientProp(prop)
	return prop:GetValue() + self.clientProps:GetValueByName(prop.propVO.name)
end

function CreatureDataWithPropUserdata:IsTransformed()
	local prop = self.props.TransformID:GetValue()
	return prop~=0
end

function CreatureDataWithPropUserdata:GetNpcID()
	return 0
end

function CreatureDataWithPropUserdata:GetClassID()
	if(self.userdata) then
		return self.userdata:Get(UDEnum.PROFESSION) or 0
	end
	return 0
end

function CreatureDataWithPropUserdata:HasBuffID(buffID)
	if(self.buffIDs==nil) then
		return false
	end
	return self.buffIDs[buffID]~=nil
end

function CreatureDataWithPropUserdata:GetEquipCardNum(site,cardID)
	return 0
end

function CreatureDataWithPropUserdata:GetRunePoint(specialEffectID)
	return 0
end

function CreatureDataWithPropUserdata:GetActiveAstrolabePoints()
	return 0
end

function CreatureDataWithPropUserdata:GetAdventureSavedHeadWear(quality)
	return 0
end

function CreatureDataWithPropUserdata:GetAdventureSavedCard(quality)
	return 0
end

function CreatureDataWithPropUserdata:GetAdventureTitle()
	return 0
end

function CreatureDataWithPropUserdata:GetBuffListByType(typeParam)
	if(typeParam==nil or self.buffIDs == nil) then
		return nil
	end
	local buff,result
	local configs = Table_Buffer
	for k,v in pairs(self.buffIDs) do
		buff = configs[k]
		if(buff ~= nil and buff.BuffEffect ~= nil and buff.BuffEffect.type == typeParam) then
			result = result or {}
			result[#result+1] = k
		end
	end
	return result
end

function CreatureDataWithPropUserdata:GetBuffEffectByType(typeParam)
	if(typeParam==nil or self.buffIDs == nil) then
		return nil
	end
	local buff
	local configs = Table_Buffer
	for k,v in pairs(self.buffIDs) do
		buff = configs[k]
		if(buff ~= nil and buff.BuffEffect ~= nil and buff.BuffEffect.type == typeParam) then
			return buff.BuffEffect
		end
	end
	return nil
end

function CreatureDataWithPropUserdata:GetBuffFromID(buffID)
	return self:_GetBuffRelate(self.buffIDs,buffID,0)
end

function CreatureDataWithPropUserdata:GetBuffLayer(buffID)
	return self:_GetBuffRelate(self.buffIDLayers,buffID,0)
end

function CreatureDataWithPropUserdata:GetBuffLevel(buffID)
	return self:_GetBuffRelate(self.buffIDLevels,buffID,0)
end

function CreatureDataWithPropUserdata:_GetBuffRelate(t,buffID,defaultValue)
	if(t==nil) then
		return defaultValue or 0
	end
	return t[buffID] or defaultValue
end

function CreatureDataWithPropUserdata:GetDistance(buffFromGuid)
	local proxy = SceneCreatureProxy
	local me = proxy.FindCreature(self.id)
	if(me) then
		local fromCreature = proxy.FindCreature(buffFromGuid)
		if(fromCreature) then
			return VectorUtility.DistanceXZ(me:GetPosition(),fromCreature:GetPosition())
		end
	end
	return 999999
end

function CreatureDataWithPropUserdata:GetRangeEnemy(range)
	return 0
end

function CreatureDataWithPropUserdata:GetMapInfo()
	return 0,0
end

function CreatureDataWithPropUserdata:GetBeingGUID()
	return 0
end

function CreatureDataWithPropUserdata:IsRide(id)
	if self.userdata ~= nil then
		return self.userdata:Get(UDEnum.MOUNT) == id
	end

	return false
end

function CreatureDataWithPropUserdata:IsPartner(id)
	local me = SceneCreatureProxy.FindCreature(self.id)
	if me ~= nil then
		return me:GetPartnerID() == id
	end
	return false
end
--CommonFun end

function CreatureDataWithPropUserdata:HasLimitSkill()
	return false
end

function CreatureDataWithPropUserdata:GetLimitSkillTarget(skillID)
	return nil
end

function CreatureDataWithPropUserdata:GetLimitSkillTargetBySortID(sortID)
	return nil
end

function CreatureDataWithPropUserdata:AddBuff(buffID,fromID,layer,level)
	if(buffID==nil) then
		return
	end
	if(self.buffIDs==nil) then
		self.buffIDs = ReusableTable.CreateTable()
	end
	if(self.buffIDLayers==nil) then
		self.buffIDLayers = ReusableTable.CreateTable()
	end
	if(level~=nil and level>0) then
		if(self.buffIDLevels==nil) then
			self.buffIDLevels = ReusableTable.CreateTable()
		end
		self.buffIDLevels[buffID] = level
	end
	
	self.buffIDs[buffID] = fromID
	self.buffIDLayers[buffID] = layer
end

function CreatureDataWithPropUserdata:_AddBuffRelate(t,buffID,value)

end

function CreatureDataWithPropUserdata:RemoveBuff(buffID)
	if(buffID==nil) then
		return
	end
	self:_RemoveBuffRelate(self.buffIDs,buffID)
	self:_RemoveBuffRelate(self.buffIDLayers,buffID)
	self:_RemoveBuffRelate(self.buffIDLevels,buffID)
end

function CreatureDataWithPropUserdata:_RemoveBuffRelate(t,buffID)
	if(t~=nil) then
		t[buffID] = nil
	end
end

function CreatureDataWithPropUserdata:_AddWeakFreezeSkillBuff( buffInfo,skillIDs )
	if(self.weakFreezeBuffs==nil) then
		self.weakFreezeBuffs = {}
		self.weakFreezeBuffs.count = 0
		self.weakFreezeBuffs.relateBuffs = {}
	end
	local buffID = buffInfo.id
	if(self.weakFreezeBuffs.relateBuffs[buffID]==nil) then
		self.weakFreezeBuffs.count = self.weakFreezeBuffs.count + 1
		self.weakFreezeBuffs.relateBuffs[buffID] = 1
		local skillBuff
		for i=1,#skillIDs do
			skillBuff = self.weakFreezeBuffs[skillIDs[i]]
			if(skillBuff==nil) then
				skillBuff = ReusableTable.CreateArray()
				self.weakFreezeBuffs[skillIDs[i]] = skillBuff
			end
			skillBuff[#skillBuff+1] = buffID
		end
	end
end

function CreatureDataWithPropUserdata:_RemoveWeakFreezeSkillBuff( buffInfo,skillIDs )
	if(self.weakFreezeBuffs) then
		local buffID = buffInfo.id
		if(self.weakFreezeBuffs.relateBuffs[buffID]) then
			self.weakFreezeBuffs.relateBuffs[buffID] = nil
			self.weakFreezeBuffs.count = self.weakFreezeBuffs.count - 1
			local skillBuff
			for i=1,#skillIDs do
				skillBuff = self.weakFreezeBuffs[skillIDs[i]]
				ArrayRemove(skillBuff, buffID)
				if(#skillBuff==0) then
					self.weakFreezeBuffs[skillIDs[i]] = nil
					DestroyArray(skillBuff)
				end
			end
		end
	end
end

function CreatureDataWithPropUserdata:_ClearBuffs()
	if(self.buffIDs~=nil) then
		ReusableTable.DestroyAndClearTable(self.buffIDs)
		self.buffIDs = nil
	end
	if(self.buffIDLayers~=nil) then
		ReusableTable.DestroyAndClearTable(self.buffIDLayers)
		self.buffIDLayers = nil
	end
	if(self.buffIDLevels~=nil) then
		ReusableTable.DestroyAndClearTable(self.buffIDLevels)
		self.buffIDLevels = nil
	end
end

function CreatureDataWithPropUserdata:AddClientProp(propName,value)
	local p = self.clientProps:GetPropByName(propName)
	local old ,clientp = self.clientProps:SetValueByName(propName,p.value + value)
	return p,clientp
end

local PartIndex = nil
local PartIndexEx = nil
function CreatureDataWithPropUserdata:GetDressParts()
	if(PartIndex==nil) then
		PartIndex = Asset_Role.PartIndex
	end
	if(PartIndexEx==nil) then
		PartIndexEx = Asset_Role.PartIndexEx
	end
	local parts = Asset_Role.CreatePartArray()
	if(self.userdata) then
		local userData = self.userdata
		parts[PartIndex.Body] = userData:Get(UDEnum.BODY) or 0
		parts[PartIndex.Hair] = userData:Get(UDEnum.HAIR) or 0
		parts[PartIndex.LeftWeapon] = userData:Get(UDEnum.LEFTHAND) or 0
		parts[PartIndex.RightWeapon] = userData:Get(UDEnum.RIGHTHAND) or 0
		parts[PartIndex.Head] = userData:Get(UDEnum.HEAD) or 0
		parts[PartIndex.Wing] = userData:Get(UDEnum.BACK) or 0
		parts[PartIndex.Face] = userData:Get(UDEnum.FACE) or 0
		parts[PartIndex.Tail] = userData:Get(UDEnum.TAIL) or 0
		parts[PartIndex.Eye] = userData:Get(UDEnum.EYE) or 0
		parts[PartIndex.Mouth] = userData:Get(UDEnum.MOUTH) or 0
		parts[PartIndex.Mount] = userData:Get(UDEnum.MOUNT) or 0
		parts[PartIndexEx.Gender] = userData:Get(UDEnum.SEX) or 0
		parts[PartIndexEx.HairColorIndex] = userData:Get(UDEnum.HAIRCOLOR) or 0
		parts[PartIndexEx.EyeColorIndex] = userData:Get(UDEnum.EYECOLOR) or 0
		parts[PartIndexEx.BodyColorIndex] = userData:Get(UDEnum.CLOTHCOLOR) or 0
	else
		for i=1,12 do
			parts[i] = 0
		end
	end
	return parts
end

-- guild begin
autoImport("SimpleGuildData");
function CreatureDataWithPropUserdata:SetGuildData( data )
	if(data and data[1] and data[1]~=0)then
		if(not self.guildData)then
			self.guildData = SimpleGuildData.CreateAsTable();
		end
		self.guildData:SetData(data);
	else
		self:DestroyGuildData();
	end
end

function CreatureDataWithPropUserdata:DestroyGuildData()
	if(self.guildData)then
		self.guildData:Destroy();
		self.guildData = nil;
	end
end

function CreatureDataWithPropUserdata:GetGuildData( )
	return self.guildData
end
-- guild end

function CreatureDataWithPropUserdata:GetUserDataStatus()
	return self.userdata:Get(UDEnum.STATUS)
end

-- override begin
function CreatureDataWithPropUserdata:DoConstruct(asArray, parts)
	self:SetAttackSpeed(1)
	self.bodyScale = self:GetDefaultScale()
	CreatureDataWithPropUserdata.super.DoConstruct(self,asArray,parts)
end

function CreatureDataWithPropUserdata:DoDeconstruct(asArray)
	CreatureDataWithPropUserdata.super.DoDeconstruct(self,asArray)
	self:Reset()
	self.userdata:Reset()
	self.props:Reset()
	self.clientProps:Reset()
	self.attrEffect:Set(0)
	self.attrEffect2:Reset()
	self:_ClearBuffs()
	self:DestroyGuildData();
end
-- override end