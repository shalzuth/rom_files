autoImport("SkillSimulateData")
SimulateSkillProxy = class('SimulateSkillProxy', pm.Proxy)
SimulateSkillProxy.Instance = nil;
SimulateSkillProxy.NAME = "SimulateSkillProxy"

--场景管理，场景的加载队列管理等

function SimulateSkillProxy:ctor(proxyName, data)
	self.proxyName = proxyName or SimulateSkillProxy.NAME
	if(SimulateSkillProxy.Instance == nil) then
		SimulateSkillProxy.Instance = self
	end
	self:Reset()
end

function SimulateSkillProxy:Reset()
	self.simulateSkillID = {}
	self.simulateProfessSkillTab = {}
end

function SimulateSkillProxy:RollBack()
	for k,sskill in pairs(self.simulateSkillID) do
		sskill:Reset()
	end
	for k,p in pairs(self.simulateProfessSkillTab) do
		p.points = p.sourcePoint
	end
end

function SimulateSkillProxy:ReInit()
	local myProfess = MyselfProxy.Instance:GetMyProfession()
	local needReset = false
	if(self.professionID ~= myProfess) then
		self:Reset()
		self.professionID = myProfess
		needReset = true
		local professTree = ProfessionProxy.Instance:GetProfessionTreeByClassId(myProfess)
		if(professTree~=nil) then
			--如果不是初心者的话(找到职业技能树)，才需要显示职业技能
			local p = professTree.transferRoot
			local typeBranch = Table_Class[myProfess].TypeBranch
			while p~=nil do
				SkillProxy.Instance:FindProfessSkill(p.id,true)
				p = p:GetNextByBranch(typeBranch)
			end
		end
	end
	self.totalUsedPoint = 0
	self.totalUsedBasePoint = 0
	local professes = SkillProxy.Instance.professionSkills
	local rootProfessID = ProfessionProxy.Instance.rootProfession.id
	local p
	local skill
	local data
	local cacheSkill
	local previousProfess
	local basePoints
	for i=1,#professes do
		p = professes[i]
		self.totalUsedPoint = self.totalUsedPoint + p.points
		basePoints = p.basePoints or p.points
		self.totalUsedBasePoint = self.totalUsedBasePoint + basePoints
		data = {
			id=p.profession,
			points = p.points,
			sourcePoint = p.points, 
			nextProfession = professes[i+1] , 
			active = (p.points>=SkillProxy.UNLOCKPROSKILLPOINTS)
		}
		local skills = {}
		self.simulateProfessSkillTab[p.profession] =data
		if(p.profession~= rootProfessID) then
			--职业技能缓存模拟
			for j=1,#p.skills do
				skill = p.skills[j]
				cacheSkill = self.simulateSkillID[skill.sortID]
				if(cacheSkill==nil) then
					cacheSkill = SkillSimulateData.new(skill)
					self.simulateSkillID[skill.sortID] = cacheSkill
				else
					cacheSkill:ResetSource(skill)
				end
				skills[#skills + 1] = cacheSkill
			end
			data.skills = skills
		else
			data.active = true
		end
	end

	local professRoot = self:GetSimulateProfessNext(rootProfessID)
	if(professRoot) then
		local index = 1
		professRoot.active = true
		professRoot.index = index
		while professRoot.nextProfession ~= nil do
			self:RefreshProfessPoints(professRoot.id,0)
			local nextP = self:GetSimulateProfessNext(professRoot.id)
			nextP.previousProfessID = professRoot.id
			professRoot = nextP
			index = index + 1
			professRoot.index = index
		end
	end
	if(needReset) then
		self:ResetSkillLinks()
	end
end

function SimulateSkillProxy:ResetSkillLinks()
	local sortID
	local requiredSkill
	for k,skill in pairs(self.simulateSkillID) do
		if(skill.sourceSkill.requiredSkillID) then
			sortID = math.floor(skill.sourceSkill.requiredSkillID/1000)
			-- local find = false
			requiredSkill = self.simulateSkillID[sortID]
			if(requiredSkill) then
				requiredSkill:SetUnlockSimulate(skill,skill.sourceSkill.requiredSkillID)
				skill:SetRequiredSimulate(requiredSkill)
				-- find = true
			end
			-- print(skill.id,"need",sortID,skill.sourceSkill.requiredSkillID,tostring(find))
		end
	end
end

function SimulateSkillProxy:GetSimulateProfess(pro)
	return self.simulateProfessSkillTab[pro]
end

function SimulateSkillProxy:GetSimulateProfessPrevious(pro)
	local p = self.simulateProfessSkillTab[pro]
	local previous
	if(p and p.previousProfessID) then
		previous = self.simulateProfessSkillTab[p.previousProfessID]
	end
	return previous
end

function SimulateSkillProxy:GetSimulateProfessNext(pro)
	local p = self.simulateProfessSkillTab[pro]
	local nextP
	if(p and p.nextProfession) then
		nextP = self.simulateProfessSkillTab[p.nextProfession.profession]
	end
	return nextP
end

function SimulateSkillProxy:RefreshProfessPoints(pro,delta,recursive,baseDelta)
	local p = self.simulateProfessSkillTab[pro]
	if(p) then
		baseDelta = baseDelta or 0
		p.points = p.points + delta
		self.totalUsedPoint = self.totalUsedPoint + delta
		self.totalUsedBasePoint = self.totalUsedBasePoint + baseDelta
		-- helplog("totalUsedBasePoint",self.totalUsedBasePoint,baseDelta)
		if(p.nextProfession) then
			local nextP = self.simulateProfessSkillTab[p.nextProfession.profession]
			if(nextP) then
				-- 旧版：职业技能是否激活是按照前一职业技能是否点满40点
				-- nextP.active = (p.points>=SkillProxy.UNLOCKPROSKILLPOINTS)

				-- 新版：职业技能是否激活，按照之前是否加满 40*深度
				local extraPoints = GameConfig.Peak.UnlockExtraSkillPoints[p.index] or 0
				nextP.active = (self.totalUsedPoint >= (p.index * SkillProxy.UNLOCKPROSKILLPOINTS + extraPoints))
				if(recursive) then
					self:RefreshProfessPoints(nextP.id,0,recursive)
				end
			end
		end
	end
end

function SimulateSkillProxy:UpgradeSkillBySortID(sortID)
	local simulateData = self.simulateSkillID[sortID]
	local changed,delta,baseDelta = simulateData:Upgrade()
	if(changed) then
		self:RefreshProfessPoints(simulateData.profession,delta,true,baseDelta)
	end
	return changed,delta
end

function SimulateSkillProxy:DowngradeSkillBySortID(sortID,level)
	local simulateData = self.simulateSkillID[sortID]
	local changed,delta,baseDelta = simulateData:Downgrade(level)
	if(changed) then
		self:RefreshProfessPoints(simulateData.profession,delta,true,baseDelta)
	end
	return changed,delta
end

function SimulateSkillProxy:HasNextSimulateSkillData(sortID)
	local skill = self.simulateSkillID[sortID]
	if(skill) then
		return skill:HasNextLevel()
	end
	return false
end

function SimulateSkillProxy:HasPreviousSimulateSkillData(sortID)
	local skill = self.simulateSkillID[sortID]
	if(skill) then
		return skill:HasPreviousLevel()
	end
	return false
end

function SimulateSkillProxy:GetSimulateSkill(sortID)
	return self.simulateSkillID[sortID]
end

function SimulateSkillProxy:GetSimulateSkillItemData(sortID,autoCreate)
	if(autoCreate==nil) then autoCreate = true end
	local simulateData = self.simulateSkillID[sortID]
	if(simulateData) then
		local data = simulateData.data
		if(data ==nil and autoCreate) then
			simulateData.data = SkillItemData.new(simulateData.id,0,0,0,0)
			data = simulateData.data
			data.learned = simulateData.sourceSkill.learned
		elseif(data.id ~= simulateData.id) then
			data:Reset(simulateData.id,0,0,0,0)
		end
		return data
	end
	return nil
end

function SimulateSkillProxy:GetSkillCanBreak()
	if(MyselfProxy.Instance:HasJobBreak()) then
		if(FunctionSkillSimulate.Me().isIsSimulating and self.totalUsedBasePoint >=GameConfig.Peak.SkillPointToBreak) then
			return true
		end
	end
	return false
end