SkillSimulateData = class("SkillSimulateData")

function SkillSimulateData:ctor(sourceSkillData)
	self:ResetSource(sourceSkillData)
end

function SkillSimulateData:ResetSource(sourceSkillData)
	self.sourceSkill = sourceSkillData
	self.sortID = self.sourceSkill.sortID
	self.profession = self.sourceSkill.profession
	self:SetID(self.sourceSkill.id)
	self:SetLearned(self.sourceSkill.learned)
end

function SkillSimulateData:Reset()
	self:SetID(self.sourceSkill.id)
	self:SetLearned(self.sourceSkill.learned)
end

function SkillSimulateData:SetID(id)
	if(id~=nil) then
		if(self.id~=id) then
			self.id = id
			if(self.data==nil) then
				self.data = SkillItemData.new(self.id,0,0,0,0)
			else
				self.data:Reset(self.id,0,0,0,0)
			end
			self.data:SetExtraLevel(self.sourceSkill:GetExtraLevel())
		end
		if(self.data) then
			local nextID = self.data:GetNextID(MyselfProxy.Instance:HasJobBreak())
			if(nextID) then
				self.nextStaticData = Table_Skill[nextID]
			else
				self.nextStaticData = nil
			end
		end
	end
end

function SkillSimulateData:SetLearned(v)
	self.learned = v
	if(self.data) then
		self.data.learned = v
	end
end

--可解锁技能
function SkillSimulateData:SetUnlockSimulate(data,unlockID)
	self.unlockSimulateData = data
	self.unlockID = unlockID
end

--返回成功与否和真正升级的点数,以及改变的基础点数
function SkillSimulateData:Upgrade(delta)
	delta = delta or 1
	local changed = false
	local realDelta = 0
	local realBaseDelta = 0
	for i=1,delta do
		if(self.id == self.sourceSkill.id and self.learned == false) then
			self:SetLearned(true)
			realDelta = realDelta + (self.sourceSkill.staticData.Cost or 0)
			if(self.data:GetBreakLevel()==0) then
				realBaseDelta = realBaseDelta + (self.data.staticData.Cost or 0)
			end
			changed = true
		else
			local nextID = self.data:GetNextID(MyselfProxy.Instance:HasJobBreak())
			if(nextID) then
				self:SetID(nextID)
				realDelta = realDelta + (self.data.staticData.Cost or 0)
				if(self.data:GetBreakLevel()==0) then
					realBaseDelta = realBaseDelta + (self.data.staticData.Cost or 0)
				end
				changed = true
			end
		end
	end
	return changed,realDelta,realBaseDelta
end

--返回成功与否和真正升级的点数,以及改变的基础点数
function SkillSimulateData:Downgrade(delta)
	delta = delta or 1
	local changed = false
	local realDelta = 0
	local realBaseDelta = 0
	local previous
	local id = self.id
	local staticData
	for i=1,delta do
		previous = math.max(id - 1,self.sourceSkill.id)
		if(previous~=id or (self.sourceSkill.learned==false and self.learned)) then
			if(previous==id and self.learned) then
				-- print("变回没学习状态")
				self:SetLearned(false)
			end
			realDelta = realDelta - (Table_Skill[id].Cost or 0)
			changed = true
			id = previous
			staticData = Table_Skill[id]
			if(staticData.PeakLevel == nil) then
				realBaseDelta = realBaseDelta - (staticData.Cost or 0)
			end
		end
	end
	if(changed) then
		self:SetID(previous)
	end
	return changed,realDelta,realBaseDelta
end

function SkillSimulateData:GetLimitLevel()
	return self.sourceSkill.id
end

function SkillSimulateData:HasNextLevel()
	return self.data:HasNextID(SkillProxy.Instance:GetSkillCanBreak() or SimulateSkillProxy.Instance:GetSkillCanBreak())
end

--前置技能
function SkillSimulateData:SetRequiredSimulate(data)
	self.requiredSimulateData = data
end

function SkillSimulateData:HasPreviousLevel()
	if(self.id <= self.sourceSkill.id) then
		if(self.sourceSkill.level == 1) then
			return (self.learned and not self.sourceSkill.learned)
		else
			return false
		end
	end
	return true
end

function SkillSimulateData:FitNextJobLevel(jobLevel)
	local needLv
	if(self.data.learned==false) then
		needLv = self.data.staticData.Contidion.joblv
	elseif(self.nextStaticData and self.nextStaticData.Contidion) then
		needLv = self.nextStaticData.Contidion.joblv
	end
	if(needLv) then
		return jobLevel>=needLv,needLv
	end
	return true,0
end

function SkillSimulateData:FitRequiredSkill()
	if(self.requiredSimulateData) then
		return (self.requiredSimulateData.id >= self.sourceSkill.requiredSkillID and self.requiredSimulateData.learned)
	end
	return true
end

function SkillSimulateData:FitNextSkillPointCost(points)
	local needPoint = self:UpgradeCost()
	return points>=needPoint,needPoint
end

function SkillSimulateData:UpgradeCost()
	local cost = 0
	if(self.data.learned==false) then
		cost = self.data.staticData.Cost
	elseif(self.nextStaticData) then
		cost = self.nextStaticData.Cost
	end
	return cost
end

function SkillSimulateData:IsSimulating()
	if(self.id ~= self.sourceSkill.id) then
		return true
	end
	if(self.learned ~= self.sourceSkill.learned) then
		return true
	end
	return false
end