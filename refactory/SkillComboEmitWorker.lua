SkillComboEmitWorker = class("SkillComboEmitWorker", ReusableObject)

if not SkillComboEmitWorker.SkillComboEmitWorker_Inited then
	SkillComboEmitWorker.SkillComboEmitWorker_Inited = true
	SkillComboEmitWorker.PoolSize = 200
end

local FindCreature = SceneCreatureProxy.FindCreature
local CreateSkillHitParams = ReusableTable.CreateSkillHitParams
local ComboInterval = 0.2

local tempComboEmitArgs = {
	[1] = 0, -- creatureGUID
	[2] = 0, -- fireEP
	[3] = nil, -- targetCreature
	[4] = nil, -- emitParams
	[5] = nil, -- hitWorker
	[6] = 0, -- comboCount
}

function SkillComboEmitWorker.GetArgs()
	return tempComboEmitArgs
end

function SkillComboEmitWorker.ClearArgs(args)
	args[3] = nil
	args[4] = nil
	args[5] = nil
end

function SkillComboEmitWorker.Create( args )
	return ReusableObject.Create( SkillComboEmitWorker, true, args )
end

function SkillComboEmitWorker:ctor()
	self.args = {}
end

function SkillComboEmitWorker:Update(time, deltaTime)
	local args = self.args
	if time < args[8] then
		return
	end
	args[8] = time + ComboInterval

	local creature = FindCreature(args[1])
	if nil == creature then
		self:Destroy()
		return
	end

	local targetCreature = FindCreature(args[3])
	if nil == targetCreature then
		self:Destroy()
		return
	end

	SkillLogic_Base.EmitFire(
		creature, 
		targetCreature, 
		nil,
		args[2], 
		args[4], 
		args[5], 
		true,
		args[7],
		args[6])

	if args[7] >= args[6] then -- index >= count
		self:Destroy()
	else
		args[7] = args[7] + 1
	end
end

-- override begin
function SkillComboEmitWorker:DoConstruct(asArray, args)
	local targetCreature = args[3]
	targetCreature.ai:SetDieBlocker(self)
	TableUtility.ArrayShallowCopyWithCount(self.args, args, 6)
	self.args[3] = targetCreature.data.id
	self.args[5]:AddRef()
	self.args[5]:Delay()

	self.args[7] = 1 -- index
	self.args[8] = 0 -- nextUpdateTime
end

function SkillComboEmitWorker:DoDeconstruct(asArray)
	local targetCreature = FindCreature(self.args[3])
	if nil ~= targetCreature then
		targetCreature.ai:ClearDieBlocker(self)
	end
	self.args[5]:SubRef()
	self.args[5] = nil
end
-- override end