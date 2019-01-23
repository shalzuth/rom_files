autoImport("ConditionCheck")
SkillPrecondCheck = class("SkillPrecondCheck")

SkillPrecondCheck.PreConditionType={
	AfterUseSkill = 1,
	WearEquip = 2,
	HpLessThan = 3,
	MyselfState = 4,
	Partner = 5,
	Buff = 6,
	--检测学习了某个技能，不需要注册监听事件
	LearnedSkill = 7,
	BeingState = 8,
	Map = 11,
}

local MapMsgID = {
	[SkillPrecondCheck.PreConditionType.AfterUseSkill] = 609,
	[SkillPrecondCheck.PreConditionType.WearEquip] = 609,
	[SkillPrecondCheck.PreConditionType.HpLessThan] = 609,
	[SkillPrecondCheck.PreConditionType.MyselfState] = 609,
	[SkillPrecondCheck.PreConditionType.Partner] = 609,
	[SkillPrecondCheck.PreConditionType.Buff] = 609,
	[SkillPrecondCheck.PreConditionType.LearnedSkill] = 609,
	[SkillPrecondCheck.PreConditionType.BeingState] = 609,
	[SkillPrecondCheck.PreConditionType.Map] = 609,
}

function SkillPrecondCheck:ctor(skillItemData)
   self.skillItemData = skillItemData
   self:ReInit()
end

function SkillPrecondCheck:ReInit()
	self.preconditions = {}
	self.notFitReasonType = {}
	local staticData = self.skillItemData.staticData
	local preCond
	local conds
	if(staticData.PreCondition.both and staticData.PreCondition.both == 1) then
		self.conditionCheck = LogicalConditionCheckWithDirty.new(LogicalConditionCheckWithDirty.And)
	else
		self.conditionCheck = LogicalConditionCheckWithDirty.new(LogicalConditionCheckWithDirty.Or)
	end
	for i=1,#staticData.PreCondition do
		preCond = staticData.PreCondition[i]
		conds = self.preconditions[preCond.type]
		if(conds==nil) then
			conds = {}
			self.preconditions[preCond.type] = conds
		end
		conds[#conds+1] = preCond
		self.conditionCheck:RemoveReason(self:GetKey(preCond))
	end
end

function SkillPrecondCheck:GetKey(preCond)
	if(preCond.type == SkillPrecondCheck.PreConditionType.AfterUseSkill) then
		return preCond.type.."_"..preCond.skillid
	elseif(preCond.type == SkillPrecondCheck.PreConditionType.WearEquip) then
		local itemtype = preCond.itemtype or ""
		local itemid = preCond.itemid or ""
		return preCond.type.."_"..itemtype.."_"..itemid
	elseif(preCond.type == SkillPrecondCheck.PreConditionType.HpLessThan) then
		return preCond.type.."_"..preCond.value
	elseif(preCond.type == SkillPrecondCheck.PreConditionType.MyselfState or preCond.type == SkillPrecondCheck.PreConditionType.BeingState) then
		local propName
		for k,v in pairs(preCond) do
			if(k~="type") then
				propName = k
				break
			end
		end
		return preCond.type.."_"..propName
	elseif(preCond.type == SkillPrecondCheck.PreConditionType.Partner) then
		return preCond.type
	elseif(preCond.type == SkillPrecondCheck.PreConditionType.Buff) then
		return preCond.type.."_"..preCond.id
	elseif(preCond.type == SkillPrecondCheck.PreConditionType.Map) then
		return preCond.type.."_"..preCond.id
	end
	errorLog(string.format("SkillPrecondCheck hasnt support %s type precondition check",preCond.type))
	return "whatfuck?"
end

function SkillPrecondCheck:GetPrecondtionsByType(t)
	return self.preconditions[t]
end

function SkillPrecondCheck:SetReason(preCondition)
	self.notFitReasonType[preCondition.type] = nil
	self.conditionCheck:SetReason(self:GetKey(preCondition))
end

function SkillPrecondCheck:RemoveReason(preCondition)
	self.notFitReasonType[preCondition.type] = preCondition
	self.conditionCheck:RemoveReason(self:GetKey(preCondition))
end

function SkillPrecondCheck:GetFirstReason()
	local index,value = next(self.notFitReasonType)
	return index,value
end

function SkillPrecondCheck:MsgReason()
	local index,value = self:GetFirstReason()
	if(index) then
		local msgID = MapMsgID[index]
		if(index == SkillPrecondCheck.PreConditionType.BeingState) then
			if(value.not_exist) then
				msgID = 614
			elseif(value.died)then
				msgID = 609
			elseif(value.alive)then
				msgID = 612
			end
		end
		MsgManager.ShowMsgByIDTable(msgID)
	end
end

function SkillPrecondCheck:HasReason()
	return self.conditionCheck:HasReason()
end

function SkillPrecondCheck:IsDirty()
	return self.conditionCheck:IsDirty()
end