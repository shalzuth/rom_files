FunctionSkillSimulate = class("FunctionSkillSimulate")
FunctionSkillSimulate.SimulateSkillPointChange = "FunctionSkillSimulate_SimulateSkillPointChange"
FunctionSkillSimulate.HasNoModifiedSkills = "FunctionSkillSimulate_HasNoModifiedSkills"

function FunctionSkillSimulate.Me()
	if nil == FunctionSkillSimulate.me then
		FunctionSkillSimulate.me = FunctionSkillSimulate.new()
	end
	return FunctionSkillSimulate.me
end

function FunctionSkillSimulate:ctor()
	self:Reset()
end

function FunctionSkillSimulate:Reset()
	self.skillCells = {}
	self.professDatas = {}
	self.modifiedSkillBySort = {}
	self.isIsSimulating = false
	self.totalPoints = 0
	self.initTotalPoints = 0
end

function FunctionSkillSimulate:CancelSimulate()
	self:Reset()
	SimulateSkillProxy.Instance:RollBack()
end

function FunctionSkillSimulate:End()
	self:Reset()
end

function FunctionSkillSimulate:GetModifiedSkills()
	return TableUtil.HashToArray(self.modifiedSkillBySort)
end

function FunctionSkillSimulate:StartSimulate(skillCells,professDatas,totalPoints)
	if(self.isIsSimulating) then return end
	self.isIsSimulating = true
	--?????????????????????
	SimulateSkillProxy.Instance:ReInit()
	local skill
	for i=1,#skillCells do
		skill = skillCells[i]
		self.skillCells[skill.data.sortID] = skill
	end
	local profess
	if(professDatas) then
		for i=1,#professDatas do
			profess = professDatas[i]
			self.professDatas[profess.data.profession] = profess
		end
	end
	self:SetNewTotalPoints(totalPoints)
	self:ScallAllDatas()
end

function FunctionSkillSimulate:SetNewTotalPoints(totalPoints)
	if(not self.isIsSimulating) then return end
	if(self.initTotalPoints==0) then
		self.initTotalPoints = totalPoints
		self.totalPoints = totalPoints
	else
		local delta = totalPoints - self.initTotalPoints
		self.totalPoints = self.totalPoints + delta
		self.initTotalPoints = totalPoints
	end
end

--?????????????????????
function FunctionSkillSimulate:Upgrade(cell)
	local breakEnable = SkillProxy.Instance:GetSkillCanBreak()
	local simuateBreakEnable = SimulateSkillProxy.Instance:GetSkillCanBreak()
	local canUsePoints = self.totalPoints
	if(not breakEnable and simuateBreakEnable) then
		canUsePoints = 0
		MsgManager.ShowMsgByIDTable(3432)
		return false
	end
	local simulate = SimulateSkillProxy.Instance:GetSimulateSkill(cell.data.sortID)
	local fitCost = simulate:FitNextSkillPointCost(canUsePoints)
	if(fitCost) then
		local myJobLevel = MyselfProxy.Instance:JobLevel()
		local fitJobLv,needJobLv = simulate:FitNextJobLevel(myJobLevel)
		if(fitJobLv) then
			local upgradeSuccess,points = SimulateSkillProxy.Instance:UpgradeSkillBySortID(cell.data.sortID)
			if(upgradeSuccess) then
				self.totalPoints = self.totalPoints - points
				cell:ShowDowngrade(true)
				self:UpdateLevel(cell,simulate)
				self.modifiedSkillBySort[simulate.sortID] = simulate.id
			end
			self:CheckCellState(cell,simulate)
			self:UpdateProfess(cell.data.profession)
			self:ScallAllDatas()
			return true
		else
			--??????job????????????
			MsgManager.ShowMsgByIDTable(603,{Table_Class[simulate.profession].NameZh,Occupation.GetFixedJobLevel(needJobLv,simulate.profession)})
		end
	else
		--?????????????????????
		MsgManager.ShowMsgByIDTable(604)
	end
	return false
end

function FunctionSkillSimulate:CheckCellState(cell,simulate)
	simulate = simulate or SimulateSkillProxy.Instance:GetSimulateSkill(cell.data.sortID)
	cell:EnableGray(not simulate.data.learned)
end

function FunctionSkillSimulate:UpdateProfess(pro)
	local profess = SimulateSkillProxy.Instance:GetSimulateProfess(pro)
	if(profess) then
		local data = self.professDatas[pro]
		data.points = profess.points
		-- cell:SetPoints(profess.points)
		-- local nextProfess = SimulateSkillProxy.Instance:GetSimulateProfessNext(pro)
		-- if(nextProfess) then
		-- 	local nextCell = self.professCells[nextProfess.id]
		-- 	if(nextCell) then
		-- 		nextCell:ShowEnable(nextProfess.active)
		-- 	end
		-- end
	end
end

function FunctionSkillSimulate:HasModifiedSkill()
	for k,v in pairs(self.modifiedSkillBySort) do
		return true
	end
	return false
end

--?????????profess?????????????????????
function FunctionSkillSimulate:_GetSkillPointsUptoProfess(profess)
	local point = 0
	local proxy = SimulateSkillProxy.Instance
	local count = 0
	while(profess and count<=5) do
		count = count + 1
		point = point + profess.points
		profess = proxy:GetSimulateProfessPrevious(profess.id)
	end
	return point
end

--?????????????????????
function FunctionSkillSimulate:Downgrade(cell)
	local proxy = SimulateSkillProxy.Instance
	local simulate = proxy:GetSimulateSkill(cell.data.sortID)
	--?????????????????????????????????????????????????????????????????????????????????
	if(simulate.unlockSimulateData and simulate.unlockSimulateData.learned) then
		if(simulate.id==simulate.unlockSimulateData.sourceSkill.requiredSkillID) then
			MsgManager.ShowMsgByIDTable(607,{simulate.unlockSimulateData.data.staticData.NameZh})
			return false
		end
	end
	--??????????????????????????????????????????????????????????????????40???
	local profess = proxy:GetSimulateProfess(cell.data.profession)
	if(profess) then
		local nextProfess = proxy:GetSimulateProfessNext(cell.data.profession)
		if(nextProfess) then
			--?????????????????????????????????????????????
			local foundNotFitPointsProfess
			local uptoSkillPoints = self:_GetSkillPointsUptoProfess(profess)
			local unlockPoints = SkillProxy.UNLOCKPROSKILLPOINTS
			local count = 0
			local _UnlockExtraSkillPoints = GameConfig.Peak.UnlockExtraSkillPoints
			while(foundNotFitPointsProfess == nil and nextProfess~=nil and count<=5) do
				count = count + 1
				local extraPoints = _UnlockExtraSkillPoints[nextProfess.index-1] or 0
				if(nextProfess.active and nextProfess.points>0 and uptoSkillPoints <= (nextProfess.index-1)*unlockPoints + extraPoints) then
					foundNotFitPointsProfess = proxy:GetSimulateProfessPrevious(nextProfess.id)
				else
					uptoSkillPoints = uptoSkillPoints + nextProfess.points
					nextProfess = proxy:GetSimulateProfessNext(nextProfess.id)
				end
			end
			if(foundNotFitPointsProfess) then
				local professName = "[EBECA7]"
				while nextProfess and nextProfess.points > 0 do
					professName = professName..Table_Class[nextProfess.id].NameZh
					nextProfess = proxy:GetSimulateProfessNext(nextProfess.id)
					if(nextProfess and nextProfess.points>0) then
						professName = professName..","
					end
				end
				professName = professName.."[-]"
				MsgManager.ConfirmMsgByID( 606,function ()
					self:ResetWholeSkillsAfterProfess(foundNotFitPointsProfess.id)
					self:Downgrade(cell)
					GameFacade.Instance:sendNotification(FunctionSkillSimulate.SimulateSkillPointChange)
				end,nil,nil,professName)
				return false
			end
		end
	end
	local downgradeSuccess,points = proxy:DowngradeSkillBySortID(cell.data.sortID)
	if(downgradeSuccess) then
		self.totalPoints = self.totalPoints - points
		self.modifiedSkillBySort[simulate.sortID] = simulate.id
	end
	self:UpdateLevel(cell,simulate)
	if(not proxy:HasPreviousSimulateSkillData(cell.data.sortID)) then
		self.modifiedSkillBySort[simulate.sortID] = nil
		cell:ShowDowngrade(false)
	end
	self:UpdateProfess(cell.data.profession)
	self:CheckCellState(cell,simulate)
	self:ScallAllDatas()
	if(self:HasModifiedSkill()==false) then
		GameFacade.Instance:sendNotification(FunctionSkillSimulate.HasNoModifiedSkills)
	end
	return true
end

function FunctionSkillSimulate:ResetWholeSkillsAfterProfess(pro)
	local skillProxy = SkillProxy.Instance
	local simulateSkillProxy = SimulateSkillProxy.Instance
	local nextProfess = simulateSkillProxy:GetSimulateProfessNext(pro)
	local simulate
	local professSkills
	local skill
	local cell
	local downgradeSuccess,downgradeLevel
	while nextProfess~=nil and nextProfess.points >0 do
		professSkills = skillProxy:FindProfessSkill(nextProfess.id).skills
		-- print("????????????",nextProfess.id)
		for i=1,#professSkills do
			skill = professSkills[i]
			if(self.modifiedSkillBySort[skill.sortID]~=nil) then 
				cell = self.skillCells[skill.sortID]
				simulate = simulateSkillProxy:GetSimulateSkill(cell.data.sortID)
				if(cell) then
					downgradeSuccess,downgradeLevel = SimulateSkillProxy.Instance:DowngradeSkillBySortID(cell.data.sortID,10000)
					if(downgradeSuccess) then
						-- print(cell.data.id,downgradeLevel)
						self.totalPoints = self.totalPoints - downgradeLevel
						self.modifiedSkillBySort[simulate.sortID] = nil
						cell:ShowDowngrade(false)
					end
					self:UpdateLevel(cell,simulate)
					self:CheckCellState(cell,simulate)
				end
			end
		end
		self:UpdateProfess(nextProfess.id)
		nextProfess = simulateSkillProxy:GetSimulateProfessNext(nextProfess.id)
	end
	self:ScallAllDatas()
	GameFacade.Instance:sendNotification(FunctionSkillSimulate.SimulateSkillPointChange)
end

function FunctionSkillSimulate:UpdateLevel(cell,simulate,breakEnable)
	if(simulate.id ~= simulate.sourceSkill.id or simulate.learned~=simulate.sourceSkill.learned) then
		cell:SetLevel(Table_Skill[simulate.id].Level,"54B30A",breakEnable)
		cell:SetDragEnable(true)
	else
		if(simulate.learned) then
			cell:SetDragEnable(true)
			cell:SetLevel(Table_Skill[simulate.id].Level,nil,breakEnable)
		else
			cell:SetDragEnable(false)
			cell:SetLevel(0,nil,breakEnable)
		end
	end
end

--?????????4??????1??????job?????????2????????????????????????????????????3?????????????????????4??????????????????40?????????
function FunctionSkillSimulate:ScallAllDatas()
	local myJobLevel = MyselfProxy.Instance:JobLevel()
	local professes = SkillProxy.Instance.professionSkills
	local simulateProfesses = SimulateSkillProxy.Instance.simulateProfessSkillTab
	local simulateSkills = SimulateSkillProxy.Instance.simulateSkillID
	local cell = nil
	local p
	local fitJob,fitRequiredSkill,hasPoint,pActive
	local realSimulate = self.totalPoints~=self.initTotalPoints
	local canUsePoints = self.totalPoints
	local breakEnable = SkillProxy.Instance:GetSkillCanBreak()
	local simuateBreakEnable = SimulateSkillProxy.Instance:GetSkillCanBreak()
	if(not breakEnable and simuateBreakEnable) then
		canUsePoints = 0
	end
	for i=1,#professes do 
		p = simulateProfesses[professes[i].profession]
		if(p.skills) then
			-- print("????????????",#p.skills)
			pActive = p.active
			for k,skill in pairs(p.skills) do
				cell = self.skillCells[skill.data.sortID]
				if(cell) then
					fitJob = skill:FitNextJobLevel(myJobLevel)
					fitRequiredSkill = skill:FitRequiredSkill()
					hasPoint = skill:FitNextSkillPointCost(canUsePoints)
					if(cell.data.breakMaxLevel>0)then
						self:UpdateLevel(cell,skill,breakEnable or simuateBreakEnable)
					end
					if(skill.learned) then
						cell:EnableGray(false)
						if(not breakEnable and simuateBreakEnable and skill.data.staticData.NextBreakID) then
							cell:ShowPreview(true)
						else
							cell:ShowPreview(false)
							cell:ShowUpgrade(skill:HasNextLevel())
						end
						if(not hasPoint or not fitJob or not skill:HasNextLevel()) then
							if(realSimulate) then
								cell:SetUpgradeEnable(false,breakEnable)
							else
								cell:SetNameBgEnable(false)
								cell:ShowUpgrade(false)
							end
						else
							cell:SetUpgradeEnable(true,breakEnable)
							cell:SetNameBgEnable(true)
						end
					else
						--?????????
						if(fitJob and fitRequiredSkill and hasPoint and pActive) then
							--?????????,?????????
							cell:ShowUpgrade(true)
							cell:SetUpgradeEnable(true,breakEnable)
							cell:EnableGray(false)
						else
							cell:ShowUpgrade(false)
							cell:EnableGray(true)
						end
					end
					--????????????
					if(cell.requiredCell) then
						cell.requiredCell:LinkUnlock(fitRequiredSkill)
					end
				end
			end
		end
	end
end