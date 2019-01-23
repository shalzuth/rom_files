SkillWorkerManager = class("SkillWorkerManager")

local function DestroyWorkers(workers)
	if 0 < #workers then
		for i=#workers, 1, -1 do
			workers[i]:Destroy()
			workers[i] = nil
		end
	end
end

local function UpdateWorkers(workers, time, deltaTime)
	if 0 < #workers then
		for i=#workers, 1, -1 do
			local worker = workers[i]
			worker:Update(time, deltaTime)
			if not worker:Alive() then
				table.remove(workers, i)
			end
		end
	end
end

function SkillWorkerManager:ctor()
	self.comboHitWorkers = {}
	self.comboEmitWorkers = {}
	self.subSkillWorkers = {}
	self:_Reset()
end

function SkillWorkerManager:_Reset()
	self.running = false

	DestroyWorkers(self.comboHitWorkers)
	DestroyWorkers(self.comboEmitWorkers)
	DestroyWorkers(self.subSkillWorkers)
end

-- interface begin
function SkillWorkerManager:CreateWorker_ComboHit(args)
	local worker = SkillComboHitWorker.Create( args )
	TableUtility.ArrayPushBack(self.comboHitWorkers, worker)
	return worker
end
function SkillWorkerManager:DestroyWorker_ComboHit(worker)
	TableUtility.ArrayRemove(self.comboHitWorkers, worker)
	worker:Destroy()
end

function SkillWorkerManager:CreateWorker_ComboEmit(args)
	local worker = SkillComboEmitWorker.Create( args )
	TableUtility.ArrayPushBack(self.comboEmitWorkers, worker)
	return worker
end
function SkillWorkerManager:DestroyWorker_ComboEmit(worker)
	TableUtility.ArrayRemove(self.comboEmitWorkers, worker)
	worker:Destroy()
end

function SkillWorkerManager:CreateWorker_SubSkillProjectile(args)
	local worker = SubSkillProjectile.Create( args )
	TableUtility.ArrayPushBack(self.subSkillWorkers, worker)
	return worker
end
function SkillWorkerManager:DestroyWorker_SubSkill(worker)
	TableUtility.ArrayRemove(self.subSkillWorkers, worker)
	worker:Destroy()
end
-- interface end

function SkillWorkerManager:Launch()
	if self.running then
		return
	end
	self.running = true
end

function SkillWorkerManager:Shutdown()
	if not self.running then
		return
	end
	self.running = false
	self:_Reset()
end

function SkillWorkerManager:Update(time, deltaTime)
	if not self.running then
		return
	end

	UpdateWorkers(self.comboHitWorkers, time, deltaTime)
	UpdateWorkers(self.comboEmitWorkers, time, deltaTime)
	UpdateWorkers(self.subSkillWorkers, time, deltaTime)
end