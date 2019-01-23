SkillHelperFunc = {}

--客户端使用的各事件监听枚举
local Base_PreConditionType={
	AfterUseSkill = 1,
	WearEquip = 2,
	HpLessThan = 3,
	MyselfState = 4,
	Partner = 5,
	Buff = 6,
	--检测学习了某个技能，不需要注册监听事件
	LearnedSkill = 7,
	BeingState = 8,
	EquipTakeOff = 9,
	EquipBreak = 10,
}

--前置条件Protype枚举
local SKILL_ABACHECK = 1
local SKILL_ARCH = 2 
local SKILL_Lianhuan = 3
local SKILL_HUPAO = 4
local SKILL_Machine = 5
local SKILL_WOLF = 6
local SKILL_POISON = 7

--前置条件Protype 所牵涉到的基础事件枚举数组
local Pro_PreCondtionType = {
	--Aba
	[SKILL_ABACHECK] = {baseTypes = {6}},
	[SKILL_ARCH] = {baseTypes = {6}},
	[SKILL_Lianhuan]= {baseTypes = {6}},
	[SKILL_HUPAO] = {baseTypes = {6}},
	[SKILL_Machine] = {baseTypes = {6}},
	[SKILL_WOLF] = {baseTypes = {5,6}},
	[SKILL_POISON] = {baseTypes = {6}},
}

--客户端通过Protype获取需要监听的事件枚举
function SkillHelperFunc.GetProRelateCheckTypes(proType)
	local config = Pro_PreCondtionType[proType]
	if(config) then
		return config.baseTypes
	end
	return nil
end

--前后端通过protype和传入srcuser，检测是否满足protype释放条件
function SkillHelperFunc.CheckPrecondtionByProType(proType,srcuser )
	if(proType~=nil and srcuser~=nil) then
		local func = Pro_PreCondtionType[proType].Func
		if(func) then
			return func(srcuser)
		else
			error(string.format("我，申林，素质差，没配%s这个类型的检查函数",proType))
		end
	end
	return false
end

-- start 具体检测前置条件的判断函数体们
function SkillHelperFunc.AbaPreCheck(srcuser)
	--1.判断 暴气状态
	if(not srcuser:HasBuffID(100510)) then
		return false
	end
	--2. 有没有蓄气
	local powerLayer = srcuser:GetBuffLayer(100500)
	if(powerLayer==0) then
		return false
	end

	--3 获取蓄气数量num

	--4.1 有没有1个蓄气
	if(powerLayer>=1) then
		--4.1.1 气绝buff
		if(srcuser:HasBuffID(100700)) then
			return true
		end
	--4.2 有没有3个蓄气
		if(powerLayer>=3)then
		--4.2.1 伏虎buff
			if(srcuser:HasBuffID(100631)) then
				return true
			end
	--4.2 有没有4个蓄气
			if(powerLayer>=4)then
		--4.2.1 猛龙buff
		--4.2.2 真剑buff
				if(srcuser:HasBuffID(100620) or srcuser:HasBuffID(100685)) then
					return true
				end
	--4.3 有没有5个蓄气
				if(powerLayer>=5)then
					return true
				end
			end
		end
	end
	return false
end
--------------------------------------------------------------弓身弹影
function SkillHelperFunc.ARCH(srcuser)
	if srcuser:HasBuffID(100510) or srcuser:HasBuffID(100500) then   -------------爆气状态或有气弹可施放
		return true
	end
	return false
end
--------------------------------------------------------------连环全身
function SkillHelperFunc.Lianhuan(srcuser)
	if srcuser:HasBuffID(100685) or srcuser:HasBuffID(100600) then   -------------真剑状态或承接六合拳可施放
		return true
	end
	return false
end
---------------------------------------------------------------虎炮
function SkillHelperFunc.HUPAO(srcuser)
	local powerLayer = srcuser:GetBuffLayer(100500)
	if srcuser:HasBuffID(100510) and powerLayer>=2 then   -------------爆气状态或有气弹可施放
		return true
	end
	return false
end
---------------------------------------------------------------操作魔导机械
function SkillHelperFunc.Machine(srcuser)

	if srcuser:HasBuffID(117850) then   -------------魔导机械
		return true
	end

	return false
end
---------------------------------------------------------------携带 狼
function SkillHelperFunc.WOLF(srcuser)

	if (srcuser:IsPartner(5049) or srcuser:IsPartner(5090) or srcuser:IsPartner(6657)) or srcuser:HasBuffID(117460) then   -------------携带 狼
		return true
	end

	return false
end
---------------------------------------------------------------剧毒武器状态下
function SkillHelperFunc.POISON(srcuser)

	if srcuser:HasBuffID(116015) then   -------------剧毒武器状态下
		return true
	end

	return false
end
-- end 具体检测前置条件的判断函数体们
-------------------------------------------------弓身弹影

--Protype 对应的检测函数
Pro_PreCondtionType[SKILL_ABACHECK].Func = SkillHelperFunc.AbaPreCheck
Pro_PreCondtionType[SKILL_ARCH].Func = SkillHelperFunc.ARCH
Pro_PreCondtionType[SKILL_Lianhuan].Func = SkillHelperFunc.Lianhuan
Pro_PreCondtionType[SKILL_HUPAO].Func = SkillHelperFunc.HUPAO
Pro_PreCondtionType[SKILL_Machine].Func = SkillHelperFunc.Machine
Pro_PreCondtionType[SKILL_WOLF].Func = SkillHelperFunc.WOLF
Pro_PreCondtionType[SKILL_POISON].Func = SkillHelperFunc.POISON
-- *******************************************************************
-- *******************************************************************
-- *******************************************************************
-- 服务度使用, 技能动态消耗

function SkillHelperFunc.DoDynamicCost(costtype, srcUser, skillid)
  local func = SkillHelperFunc.DynamicCostFunc[costtype]
  if func == nil then
    return
  end

  func(srcUser)
end

function SkillHelperFunc.DoDynamicCost_Aba(srcUser, skillid)
		--1.判断 暴气状态
	if(not srcUser:HasBuffID(100510)) then
		return false
	end
	--2. 有没有蓄气
	local powerLayer = srcUser:GetBuffLayer(100500)
	if(powerLayer==0) then
		return false
	end

	--3 获取蓄气数量num

	--4.1 有没有1个蓄气
	if(powerLayer>=1) then
		--4.1.1 气绝buff
		if(srcUser:HasBuffID(100700)) then
			srcUser:DelSkillBuff(100500,1)
			return true
		end
	--4.2 有没有3个蓄气
		if(powerLayer>=3)then
		--4.2.1 伏虎buff
			if(srcUser:HasBuffID(100631)) then
				srcUser:DelSkillBuff(100500,3)
				return true
			end
	--4.2 有没有4个蓄气
			if(powerLayer>=4)then
		--4.2.1 猛龙buff
		--4.2.2 真剑buff
				if(srcUser:HasBuffID(100620) or srcUser:HasBuffID(100685)) then
					srcUser:DelSkillBuff(100500,4)
					return true
				end
	--4.3 有没有5个蓄气
				if(powerLayer>=5)then
				srcUser:DelSkillBuff(100500,5)
					return true
				end
			end
		end
	end
	return false
end

-- 弓身弹影 消耗
function SkillHelperFunc.DoDynamicCost_Arch(srcUser, skillid)
  if srcUser == nil then
    return
  end

  local inBomb = srcUser:HasBuffID(100510)
  if inBomb ==true then
    return
  end

  srcUser:DelSkillBuff(100500,1)
end

-- 连环全身掌 消耗
function SkillHelperFunc.DoDynamicCost_Lianhuan(srcUser, skillid)
  if srcUser == nil then
    return
  end
  if srcUser:HasBuffID(100685) then
  	return
  elseif srcUser:HasBuffID(100600) then
  	srcUser:DelSkillBuff(100600,1)
  	return
  end
end


-- NOTICE: 必须放在子函数实现后面!!!
SkillHelperFunc.DynamicCostFunc = {
  [1] = SkillHelperFunc.DoDynamicCost_Aba,
  [2] = SkillHelperFunc.DoDynamicCost_Arch, -- 弓身弹影
  [3] = SkillHelperFunc.DoDynamicCost_Lianhuan -- 连环全身掌
}

