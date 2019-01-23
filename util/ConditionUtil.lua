ConditionUtil = {}
ConditionUtil.CostType = {
	SkillPoint = 1,
	AdventureSkillPoint = 2
}

function ConditionUtil.Init()
	if(not ConditionUtil.inited) then
		ConditionUtil.inited = true
		ConditionUtil.SkillCheck = {
			{checkParam = "allquestid",func = ConditionUtil.SkillCheckTask,params = ConditionUtil.GetQuestParams,fit = ZhString.SkillTip_FitQuest,notfit = ZhString.SkillTip_NeedFitQuest},
			{checkParam = "joblv",func = ConditionUtil.SkillCheckJobLevel,params = ConditionUtil.GetJobLVParams,fit = ZhString.SkillTip_FitJobLV,notfit = ZhString.SkillTip_NeedFitJobLV},
			{checkParam = "skillid",func = ConditionUtil.SkillCheckSkill,params = ConditionUtil.GetSkillParams,fit = ZhString.SkillTip_SkillLV,notfit = ZhString.SkillTip_NeedSkillLV},
			{checkParam = "riskid",func = ConditionUtil.SkillCheckRisk,params = ConditionUtil.GetRiskParams,fit = ZhString.SkillTip_FitRisk,notfit = ZhString.SkillTip_NeedFitRisk},
		}
	end
end

--技能检查是否职业等级足够
function ConditionUtil.SkillCheckJobLevel(skilldata)
	local myJobLevel = MyselfProxy.Instance:JobLevel()
	return skilldata.Contidion.joblv <= myJobLevel
end

--技能检查任务是否完成
function ConditionUtil.SkillCheckTask(quest)
	return QuestProxy.Instance:isQuestComplete(quest)
end

--技能检查是否已学习了某个技能
function ConditionUtil.SkillCheckSkill(skilldata)
	if(FunctionSkillSimulate.Me().isIsSimulating) then
		local simulateSkill = SimulateSkillProxy.Instance:GetSimulateSkill(math.floor(skilldata.Contidion.skillid/1000))
		return simulateSkill~=nil and simulateSkill.learned and simulateSkill.id >= skilldata.Contidion.skillid
	else
		return SkillProxy.Instance:HasLearnedSkill(skilldata.Contidion.skillid)
	end
end

--技能检查冒险相关是否满足
function ConditionUtil.SkillCheckRisk(skilldata)
	local myAppelationID = MyselfProxy.Instance:GetCurManualAppellation().id
	return myAppelationID>=skilldata.Contidion.riskid
end

function ConditionUtil.CondStrHelper(cond,config,param,showFittedCond,breakOnNotFit)
	if(config.func(param)) then
		if(showFittedCond and not breakOnNotFit) then
			cond = cond..string.format(config.fit,config.params(param)).."\n"
		end
	else
		cond = cond..string.format(config.notfit,config.params(param))
		if(breakOnNotFit) then return cond,true end
		cond = cond.."\n"
	end
	return cond
end

--costType:是消耗技能点呢，还是消耗冒险技能点
function ConditionUtil.GetSkillConditionStr(skilldata,showFittedCond,breakOnNotFit,costType)
	ConditionUtil.Init()
	costType = costType or ConditionUtil.CostType.SkillPoint
	local cond = ""
	local config
	local condition
	local needBreak
	for i=1,#ConditionUtil.SkillCheck do
		config = ConditionUtil.SkillCheck[i]
		if(skilldata.Contidion) then
			condition= skilldata.Contidion[config.checkParam]
		end
		if(condition) then
			if(type(condition)=="table") then
				for i=1,#condition do
					cond,needBreak = ConditionUtil.CondStrHelper(cond,config,condition[i],showFittedCond,breakOnNotFit)
					if(needBreak) then break end
				end
			else
				cond,needBreak = ConditionUtil.CondStrHelper(cond,config,skilldata,showFittedCond,breakOnNotFit)
			end
			if(needBreak) then break end
		end
	end
	if(not breakOnNotFit) then
		if(costType==ConditionUtil.CostType.SkillPoint) then
			-- if(MyselfProxy.Instance.myself.userData:Get(UDEnum.SKILL_POINT)>=skilldata.Cost) then
			-- 	cond = cond..string.format(ZhString.SkillTip_SkillCost,skilldata.Cost).."\n"
			-- else
			-- 	cond = cond..string.format(ZhString.SkillTip_NeedSkillCost,skilldata.Cost).."\n"
			-- end
		else
			if(AdventureDataProxy.Instance:getSkillPoint()>=skilldata.Cost) then
				cond = cond..string.format(ZhString.AdventureSkill_CostAdventureSkillPoint1,skilldata.Cost).."\n"
			else
				cond = cond..string.format(ZhString.AdventureSkill_NeedCostAdventureSkillPoint,skilldata.Cost).."\n"
			end
		end
		-- local profess = skilldata.Class
		-- if(profess) then
		-- 	local pTree = ProfessionProxy.Instance:GetProfessionTreeByClassId(profess)
		-- 	if(pTree and pTree.transferRoot.id ~= profess) then
		-- 		--不是初心者或者一转职业
		-- 		local pointsEnough = false
		-- 		local previousP = ProfessionProxy.Instance:GetPreviousProfess(profess)
		-- 		if(FunctionSkillSimulate.Me().isIsSimulating) then
		-- 			--模拟中
		-- 			local simulateProfess = SimulateSkillProxy.Instance:GetSimulateProfess(profess)
		-- 			if(simulateProfess) then
		-- 				pointsEnough = simulateProfess.active
		-- 			end
		-- 		else
		-- 			pointsEnough = SkillProxy.Instance:HasEnoughSkillPoint(previousP.id)
		-- 		end
		-- 		if(pointsEnough) then
		-- 			cond = cond..string.format(ZhString.SkillTip_PreviousProfessSkillPoints,previousP.data.NameZh,SkillProxy.UNLOCKPROSKILLPOINTS)
		-- 		else
		-- 			cond = cond..string.format(ZhString.SkillTip_NeedPreviousProfessSkillPoints,previousP.data.NameZh,SkillProxy.UNLOCKPROSKILLPOINTS)
		-- 		end
		-- 	end
		-- end
	end
	return cond
end

function ConditionUtil.GetQuestParams(quest)
	return QuestProxy.Instance:getStaticDataById(quest).Name
end

function ConditionUtil.GetJobLVParams(skilldata)
	return Table_Class[skilldata.Class].NameZh,Occupation.GetFixedJobLevel(skilldata.Contidion.joblv,skilldata.Class)
end

function ConditionUtil.GetSkillParams(skilldata)
	local skill = Table_Skill[skilldata.Contidion.skillid]
	return Table_Class[skill.Class].NameZh,skill.NameZh,skill.Level
end

function ConditionUtil.GetRiskParams(skilldata)
	local appellation = Table_Appellation[skilldata.Contidion.riskid]
	if(appellation) then
		return appellation.Name
	end
	return "NULL"
end