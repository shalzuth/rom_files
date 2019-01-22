
SkillPhaseData = class("SkillPhaseData", ReusableObject)
SkillPhaseData.PoolSize = 200

local S2C_Number = ProtolUtility.S2C_Number
local C2S_Number = ProtolUtility.C2S_Number
local C2S_Vector3 = ProtolUtility.C2S_Vector3

local function CreateShareDamageInfos(origin, infos)
	if nil ~= origin and 0 < #origin then
		if nil == infos then
			infos = ReusableTable.CreateArray()
		end
		local shareDamageCount = #origin
		infos[1] = shareDamageCount
		local shareIndex = 1
		for i=1, shareDamageCount do
			local shareDamageInfo = origin[i]
			infos[shareIndex+1] = shareDamageInfo.charid
			infos[shareIndex+2] = shareDamageInfo.type
			infos[shareIndex+3] = shareDamageInfo.damage
			shareIndex = shareIndex+3
		end
	else
		if nil ~= infos then
			DestroyShareDamageInfos(infos)
			infos = nil
		end
	end
	return infos
end

local function DestroyShareDamageInfos(infos)
	if nil ~= infos then
		ReusableTable.DestroyArray(infos)
	end
end

-- args = skillID -- int
function SkillPhaseData.Create(args)
	return ReusableObject.Create( SkillPhaseData, true, args )
end

function SkillPhaseData:ctor()
	self.data = {
		0, -- skillID
		0, -- skillPhase
		nil, -- position
		nil, -- angleY
		0, -- cast time
		0 -- targetCount
	}

	SkillPhaseData.super.ctor(self)
end

function SkillPhaseData:ToServerData(msg, creature, targetCreatureGUID)
	local data = msg.data
	msg.skillID = self:GetSkillID()

	local skillPhase = self:GetSkillPhase()
	data.number = skillPhase

	local pos = self:GetPosition() or creature:GetPosition()
	if nil ~= pos then
		ProtolUtility.C2S_Vector3(pos, data.pos)
	end

	local dir = self:GetAngleY() or creature:GetAngleY()
	if nil ~= dir then
		data.dir = math.floor(C2S_Number(GeometryUtils.UniformAngle(dir)))
	end
	local targetsCount = self:GetTargetCount()
	if 0 < targetsCount then
		-- hitedTargets
		for i = 1, targetsCount do
			local hit = SceneUser_pb.HitedTarget()
			hit.charid,hit.type,hit.damage = self:GetTarget(i)
			if CommonFun.DamageType.Treatment == hit.type then
				hit.type = CommonFun.DamageType.Normal
				hit.damage = -hit.damage
			elseif CommonFun.DamageType.Treatment_Sp == hit.type then
				hit.type = CommonFun.DamageType.Normal_Sp
				hit.damage = -hit.damage
			end
			table.insert(data.hitedTargets,hit)
		end
	elseif SkillPhase.Cast == skillPhase then
		if nil ~= targetCreatureGUID and 0 ~= targetCreatureGUID then
			local hit = SceneUser_pb.HitedTarget()
			hit.charid,hit.type,hit.damage = targetCreatureGUID,0,0
			table.insert(data.hitedTargets,hit)
		end
	end
end

function SkillPhaseData:ParseFromServer(msg)
	local data = msg.data
	self:SetSkillPhase(data.number)
	local pos = data.pos
	self:SetPositionXYZ(
		ProtolUtility.S2C_Number(pos.x),
		S2C_Number(pos.y),
		S2C_Number(pos.z))
	self:SetAngleY(S2C_Number(data.dir))
	self:SetCastTime(S2C_Number(msg.chanttime))
	self:ClearTargets()
	if nil ~= data.hitedTargets then
		local hit
		for i=1,#data.hitedTargets do
			hit = data.hitedTargets[i]
			if 0 > hit.damage then
				if CommonFun.DamageType.Normal_Sp == hit.type 
					or CommonFun.DamageType.Treatment_Sp == hit.type then
					self:AddTarget(
						hit.charid,
						CommonFun.DamageType.Treatment_sp,
						-hit.damage,
						hit.shareTargets)
				else
					self:AddTarget(
						hit.charid,
						CommonFun.DamageType.Treatment,
						-hit.damage,
						hit.shareTargets)
				end
			else
				self:AddTarget(
					hit.charid,
					hit.type,
					hit.damage,
					hit.shareTargets)
			end
		end
	end
end

function SkillPhaseData:Clone()
	local newData = SkillPhaseData.Create(self.data[1])
	self:CopyTo(newData)
	return newData
end

function SkillPhaseData:Reset(skillID)
	self.data[1] = skillID
	self.data[2] = SkillPhase.None
	self:ClearTargets()
	self.data[6] = 0 -- target count
end

function SkillPhaseData:CopyTo(to)
	local fromData = self.data
	local toData = to.data

	toData[1] = fromData[1]
	toData[2] = fromData[2]
	toData[3] = VectorUtility.TryAsign_3(toData[3], fromData[3])
	toData[4] = fromData[4]
	toData[5] = fromData[5]
	toData[6] = fromData[6]

	-- copy targets
	local targetCount = fromData[6]
	if 0 < targetCount then
		local index = 6
		for i=1, targetCount do
			toData[index+1] = fromData[index+1]
			toData[index+2] = fromData[index+2]
			toData[index+3] = fromData[index+3]
			local shareDamageInfos = fromData[index+4]
			if nil ~= shareDamageInfos and 0 < #shareDamageInfos then
				local toShareDamageInfos = toData[index+4]
				if nil == toShareDamageInfos then
					toShareDamageInfos = ReusableTable.CreateArray()
					toData[index+4] = toShareDamageInfos
				end
				TableUtility.ArrayShallowCopyWithCount(
					toShareDamageInfos, 
					shareDamageInfos, 
					shareDamageInfos[1]*3+1)
			else
				DestroyShareDamageInfos(toData[index+4])
				toData[index+4] = nil
			end
			index = index+4
		end
	end
end

function SkillPhaseData:GetSkillID()
	return self.data[1]
end

function SkillPhaseData:GetSkillPhase()
	return self.data[2]
end

function SkillPhaseData:SetSkillPhase(phase)
	self.data[2] = phase
end

-- return maybe nil
function SkillPhaseData:GetPosition()
	return self.data[3]
end

-- return maybe nil
function SkillPhaseData:GetPositionClone()
	return self.data[3] and self.data[3]:Clone() or nil
end

function SkillPhaseData:SetPosition(p)
	if nil ~= self.data[3] then
		self.data[3]:Set(p[1], p[2], p[3])
	else
		self.data[3] = p:Clone()
	end
end

function SkillPhaseData:SamplePosition(p)
	if nil ~= self.data[3] then
		NavMeshUtility.SelfSample(self.data[3])
	end
end

function SkillPhaseData:SetPositionXYZ(x, y, z)
	if nil ~= self.data[3] then
		self.data[3]:Set(x, y, z)
	else
		self.data[3] = LuaVector3.New(x, y, z)
	end
end

-- return maybe nil
function SkillPhaseData:GetAngleY()
	return self.data[4]
end

function SkillPhaseData:SetAngleY(v)
	self.data[4] = v
end

function SkillPhaseData:GetCastTime()
	return self.data[5]
end

function SkillPhaseData:SetCastTime(v)
	self.data[5] = v
end

function SkillPhaseData:AddTarget(guid, damageType, damage, shareDamageInfos)
	local data = self.data

	local targetCount = data[6]
	local index = 6+targetCount*4

	targetCount = targetCount + 1
	data[6] = targetCount

	data[index+1] = guid
	data[index+2] = damageType
	data[index+3] = damage
	data[index+4] = CreateShareDamageInfos(shareDamageInfos, data[index+4])
end

function SkillPhaseData:GetTargetCount()
	return self.data[6]
end

-- return guid, damageType, damage, shareDamageInfos
function SkillPhaseData:GetTarget(index)
	local data = self.data

	index = 6 + (index-1) * 4
	return data[index+1], data[index+2], data[index+3], data[index+4]
end

function SkillPhaseData:SetTarget(index, guid, damageType, damage, shareDamageInfos)
	local data = self.data

	index = 6 + (index-1) * 3
	data[index+1] = guid
	data[index+2] = damageType
	data[index+3] = damage
	data[index+4] = CreateShareDamageInfos(shareDamageInfos, data[index+4])
end

function SkillPhaseData:ClearTargets()
	local data = self.data
	local targetCount = data[6]
	data[6] = 0

	if 0 < targetCount then
		local index = 6
		for i=1, targetCount do
			DestroyShareDamageInfos(data[index+4])
			data[index+4] = nil
			index = index+4
		end
	end
end

-- override begin
function SkillPhaseData:DoConstruct(asArray, args)
	self:Reset(args)
end

function SkillPhaseData:DoDeconstruct(asArray)
	if nil ~= self.data[3] then
		self.data[3]:Destroy()
		self.data[3] = nil
	end
	self.data[4] = nil -- angle Y
	self:ClearTargets()
end
-- override end