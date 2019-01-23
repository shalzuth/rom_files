
LogicManager_RoleDress = class("LogicManager_RoleDress")

LogicManager_RoleDress.Priority = {
	Normal = 1,
	Friend = 2,
	Guild = 3,
	Team = 4,
	_Count = 4
}

local function FindHighAndLowPriorityCreature(creatures, highPriorityCreature, highPriority, lowPriorityCreature, lowPriority)
	local highIndex = 0
	local lowIndex = 0
	local creatureCount = #creatures
	if 0 < creatureCount then
		for i=1, creatureCount do
			local creature = creatures[i]
			local priority = creature:GetDressPriority()
			if priority > highPriority then
				highPriorityCreature = creature
				highPriority = priority
				highIndex = i
			end
			if priority < lowPriority then
				lowPriorityCreature = creature
				lowPriority = priority
				lowIndex = i
			end
		end
	end
	return highPriorityCreature, highPriority, highIndex, lowPriorityCreature, lowPriority, lowIndex
end

local function FindHighPriorityCreature(creatures, highPriorityCreature, highPriority)
	local index = 0
	local creatureCount = #creatures
	if 0 < creatureCount then
		for i=1, creatureCount do
			local creature = creatures[i]
			local priority = creature:GetDressPriority()
			if priority > highPriority then
				highPriorityCreature = creature
				highPriority = priority
				index = i
			end
		end
	end
	return highPriorityCreature, highPriority, index
end

function LogicManager_RoleDress:ctor()
	self.dressedCreatures = {
	}
	self.dressedCount = 0

	self.undressedCreatures = {
	}
	self.undressedCount = 0

	for i=1, LogicManager_RoleDress.Priority._Count do
		self.dressedCreatures[i] = {}
		self.undressedCreatures[i] = {}
	end

	self.limitCount = 0
	self.dressDisable = false

	self.waitingDressedCreatures = {}
	self.waitingUndressedCreatures = {}
end

function LogicManager_RoleDress:Add(creature)
	-- wait for refresh
	if creature:IsDressEnable() then
		TableUtility.ArrayPushBack(self.waitingDressedCreatures, creature)
	else
		TableUtility.ArrayPushBack(self.waitingUndressedCreatures, creature)
	end
end

function LogicManager_RoleDress:Remove(creature)
	local priority = creature:GetDressPriority()
	-- LogUtility.InfoFormat("<color=yellow>RoleDress Remove: </color>{0}, {1}-->{2}", 
	-- 	creature.data and creature.data:GetName() or "No Name",
	-- 	creature:IsDressEnable(),
	-- 	priority)
	if creature:IsDressEnable() then
		if 0 < TableUtility.ArrayRemove(self.dressedCreatures[priority], creature) then
			self.dressedCount = self.dressedCount - 1
			return
		end
		TableUtility.ArrayRemove(self.waitingDressedCreatures, creature)
	else
		if 0 < TableUtility.ArrayRemove(self.undressedCreatures[priority], creature) then
			self.undressedCount = self.undressedCount - 1
			return
		end
		TableUtility.ArrayRemove(self.waitingUndressedCreatures, creature)
	end
end

function LogicManager_RoleDress:RefreshPriority(creature, oldPriority, newPriority)
	-- LogUtility.InfoFormat("<color=yellow>RefreshPriority: </color>{0}, {1}-->{2}", 
	-- 	creature.data and creature.data:GetName() or "No Name",
	-- 	oldPriority,
	-- 	newPriority)
	if creature:IsDressEnable() then
		if self.dressedCount < self:GetLimitCount() then
			-- all dressed
			return
		end
		if oldPriority < newPriority then
			-- up shift
			if 0 < TableUtility.ArrayRemove(self.dressedCreatures[oldPriority], creature) then
				TableUtility.ArrayPushBack(self.dressedCreatures[newPriority], creature)
			end
			return
		end
		-- wait for refresh
		if 0 < TableUtility.ArrayRemove(self.dressedCreatures[oldPriority], creature) then
			self.dressedCount = self.dressedCount - 1
			TableUtility.ArrayPushBack(self.waitingDressedCreatures, creature)
		end
	else
		if oldPriority > newPriority then
			-- down shift
			if 0 < TableUtility.ArrayRemove(self.undressedCreatures[oldPriority], creature) then
				TableUtility.ArrayPushBack(self.undressedCreatures[newPriority], creature)
			end
			return
		end
		-- wait for refresh
		if 0 < TableUtility.ArrayRemove(self.undressedCreatures[oldPriority], creature) then
			self.undressedCount = self.undressedCount - 1
			TableUtility.ArrayPushBack(self.waitingUndressedCreatures, creature)
		end
	end
end

function LogicManager_RoleDress:SetLimitCount(count)
	if self.limitCount == count then
		return
	end
	self.limitCount = count
end

function LogicManager_RoleDress:GetLimitCount(count)
	if self.dressDisable then
		return 0
	end
	return self.limitCount
end

function LogicManager_RoleDress:SetDressDisable(disable)
	self.dressDisable = disable
end

function LogicManager_RoleDress:Update(time, deltaTime)
	if self.dressedCount < self:GetLimitCount() then
		if 0 >= #self.waitingDressedCreatures 
			and 0 >= #self.waitingUndressedCreatures
			and 0 >= self.undressedCount then
			return
		end
	end

	-- 1. try dress
	local highPriorityCreature = nil
	local highPriority = 0
	local highPriorityCreatureArray = nil
	local highPriorityIndex = 0

	local lowPriorityCreature = nil
	local lowPriority = 9999999
	local lowPriorityIndex = 0

	local creatures = self.waitingDressedCreatures
	highPriorityCreature, highPriority, highPriorityIndex, lowPriorityCreature, lowPriority, lowPriorityIndex = FindHighAndLowPriorityCreature(
		self.waitingDressedCreatures,
		highPriorityCreature,
		highPriority,
		lowPriorityCreature,
		lowPriority)
	if 0 < highPriorityIndex then
		highPriorityCreatureArray = self.waitingDressedCreatures
	end
	local newHighPriorityCreature, newHighPriority, newHighPriorityIndex = FindHighPriorityCreature(
		self.waitingUndressedCreatures,
		highPriorityCreature,
		highPriority)
	if 0 < newHighPriorityIndex then
		highPriorityCreatureArray = self.waitingUndressedCreatures
		highPriorityCreature = newHighPriorityCreature
		highPriority = newHighPriority
		highPriorityIndex = newHighPriorityIndex
	end

	if nil ~= highPriorityCreature and self:_TryDress(highPriorityCreature, highPriority) then
		table.remove(highPriorityCreatureArray, highPriorityIndex)
		if highPriorityCreature == lowPriorityCreature then
			lowPriorityCreature = nil
		end
	else
		self:_TryDressOne()
	end

	-- 2. try undress
	if nil ~= lowPriorityCreature and self:_TryUndress(lowPriorityCreature, lowPriority) then
		table.remove(self.waitingDressedCreatures, lowPriorityIndex)
	else
		self:_TryUndressOne()
	end
end

function LogicManager_RoleDress:_TryDress(creature, priority)
	if self.dressedCount < self:GetLimitCount() then
		-- add
		TableUtility.ArrayPushBack(self.dressedCreatures[priority], creature)
		self.dressedCount = self.dressedCount + 1
		creature:SetDressEnable(true)
		-- LogUtility.InfoFormat("<color=yellow>Dress: </color>{0}, {1}, {2}", 
		-- 	creature.data:GetName(),
		-- 	self.dressedCount,
		-- 	self:GetLimitCount())
		return true
	end

	for i=1, priority-1 do
		local dressedCreatures = self.dressedCreatures[i]
		if 0 < #dressedCreatures then
			-- replace
			local replacedCreature = TableUtility.ArrayPopBack(dressedCreatures)
			TableUtility.ArrayPushBack(self.undressedCreatures[i], replacedCreature)
			self.undressedCount = self.undressedCount + 1
			replacedCreature:SetDressEnable(false)

			TableUtility.ArrayPushBack(self.dressedCreatures[priority], creature)
			creature:SetDressEnable(true)
			-- LogUtility.InfoFormat("<color=yellow>Replace Dress: </color>{0}, {1}, {2}", 
			-- 	creature.data:GetName(),
			-- 	self.dressedCount,
			-- 	self:GetLimitCount())
			return true
		end
	end

	return false
end

function LogicManager_RoleDress:_TryUndress(creature, priority)
	if self.dressedCount < self:GetLimitCount() then
		return false
	end
	
	TableUtility.ArrayPushBack(
		self.undressedCreatures[priority], 
		creature)
	self.undressedCount = self.undressedCount + 1
	creature:SetDressEnable(false)
	-- LogUtility.InfoFormat("<color=yellow>Undress: </color>{0}, {1}, {2}", 
	-- 	creature.data:GetName(),
	-- 	self.dressedCount,
	-- 	self:GetLimitCount())
	return true
end

function LogicManager_RoleDress:_TryDressOne()
	if self.dressedCount >= self:GetLimitCount() then
		return false
	end
	
	for i=LogicManager_RoleDress.Priority._Count, 1, -1 do
		local undressedCreatures = self.undressedCreatures[i]
		if 0 < #undressedCreatures then
			-- replace
			local creature = TableUtility.ArrayPopBack(undressedCreatures)
			self.undressedCount = self.undressedCount - 1
			TableUtility.ArrayPushBack(self.dressedCreatures[i], creature)
			self.dressedCount = self.dressedCount + 1
			creature:SetDressEnable(true)
			-- LogUtility.InfoFormat("<color=yellow>Replace Dress: </color>{0}, {1}, {2}", 
			-- 	creature.data:GetName(),
			-- 	self.dressedCount,
			-- 	self:GetLimitCount())
			return true
		end
	end
	return false
end

function LogicManager_RoleDress:_TryUndressOne()
	if self.dressedCount <= self:GetLimitCount() then
		return false
	end
	
	for i=1, LogicManager_RoleDress.Priority._Count do
		local dressedCreatures = self.dressedCreatures[i]
		if 0 < #dressedCreatures then
			-- replace
			local creature = TableUtility.ArrayPopBack(dressedCreatures)
			self.dressedCount = self.dressedCount - 1
			TableUtility.ArrayPushBack(self.undressedCreatures[i], creature)
			self.undressedCount = self.undressedCount + 1
			creature:SetDressEnable(false)
			-- LogUtility.InfoFormat("<color=yellow>Replace Undress: </color>{0}, {1}, {2}", 
			-- 	creature.data:GetName(),
			-- 	self.dressedCount,
			-- 	self:GetLimitCount())
			return true
		end
	end
	return false
end
