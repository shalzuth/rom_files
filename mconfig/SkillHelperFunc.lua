SkillHelperFunc = {}
local Base_PreConditionType = {
  AfterUseSkill = 1,
  WearEquip = 2,
  HpLessThan = 3,
  MyselfState = 4,
  Partner = 5,
  Buff = 6,
  LearnedSkill = 7,
  BeingState = 8,
  EquipTakeOff = 9,
  EquipBreak = 10
}
local SKILL_ABACHECK = 1
local SKILL_ARCH = 2
local SKILL_Lianhuan = 3
local SKILL_HUPAO = 4
local SKILL_Machine = 5
local SKILL_WOLF = 6
local SKILL_POISON = 7
local SKILL_SOLO = 8
local SKILL_ENSEMBLE = 9
local Pro_PreCondtionType = {
  [SKILL_ABACHECK] = {
    baseTypes = {6}
  },
  [SKILL_ARCH] = {
    baseTypes = {6}
  },
  [SKILL_Lianhuan] = {
    baseTypes = {6}
  },
  [SKILL_HUPAO] = {
    baseTypes = {6}
  },
  [SKILL_Machine] = {
    baseTypes = {6}
  },
  [SKILL_WOLF] = {
    baseTypes = {5, 6}
  },
  [SKILL_POISON] = {
    baseTypes = {6}
  },
  [SKILL_SOLO] = {
    baseTypes = {2, 6}
  },
  [SKILL_ENSEMBLE] = {
    baseTypes = {2, 6}
  }
}
function SkillHelperFunc.GetProRelateCheckTypes(proType)
  local config = Pro_PreCondtionType[proType]
  if config then
    return config.baseTypes
  end
  return nil
end
function SkillHelperFunc.CheckPrecondtionByProType(proType, srcuser, skillid)
  if proType ~= nil and srcuser ~= nil then
    local func = Pro_PreCondtionType[proType].Func
    if func then
      return func(srcuser, skillid)
    else
      error(string.format("\230\136\145\239\188\140\231\148\179\230\158\151\239\188\140\231\180\160\232\180\168\229\183\174\239\188\140\230\178\161\233\133\141%s\232\191\153\228\184\170\231\177\187\229\158\139\231\154\132\230\163\128\230\159\165\229\135\189\230\149\176", proType))
    end
  end
  return false
end
function SkillHelperFunc.AbaPreCheck(srcuser)
  if not srcuser:HasBuffID(100510) then
    return false
  end
  local powerLayer = srcuser:GetBuffLayer(100500)
  if powerLayer == 0 then
    return false
  end
  if powerLayer >= 1 then
    if srcuser:HasBuffID(100700) then
      return true
    end
    if powerLayer >= 3 then
      if srcuser:HasBuffID(100631) then
        return true
      end
      if powerLayer >= 4 then
        if srcuser:HasBuffID(100620) or srcuser:HasBuffID(100685) then
          return true
        end
        if powerLayer >= 5 then
          return true
        end
      end
    end
  end
  return false
end
function SkillHelperFunc.ARCH(srcuser)
  if srcuser:HasBuffID(100510) or srcuser:HasBuffID(100500) then
    return true
  end
  return false
end
function SkillHelperFunc.Lianhuan(srcuser)
  if srcuser:HasBuffID(100685) or srcuser:HasBuffID(100600) then
    return true
  end
  return false
end
function SkillHelperFunc.HUPAO(srcuser)
  local powerLayer = srcuser:GetBuffLayer(100500)
  if srcuser:HasBuffID(100510) and powerLayer >= 2 then
    return true
  end
  return false
end
function SkillHelperFunc.Machine(srcuser)
  if srcuser:HasBuffID(117856) then
    return true
  end
  return false
end
function SkillHelperFunc.WOLF(srcuser)
  if srcuser:IsPartner(5049) or srcuser:IsPartner(5090) or srcuser:IsPartner(6657) or srcuser:HasBuffID(117460) then
    return true
  end
  return false
end
function SkillHelperFunc.POISON(srcuser)
  if srcuser:HasBuffID(116015) then
    return true
  end
  return false
end
function SkillHelperFunc.SOLO(srcuser)
  if srcuser:HasBuffID(119301) or srcuser:GetEquipedWeaponType() ~= 260 and srcuser:GetEquipedWeaponType() ~= 270 then
    return false
  end
  return true
end
function SkillHelperFunc.ENSEMBLE(srcuser, skillid)
  if srcuser:GetEquipedWeaponType() ~= 260 and srcuser:GetEquipedWeaponType() ~= 270 then
    return false
  end
  return true
end
Pro_PreCondtionType[SKILL_ABACHECK].Func = SkillHelperFunc.AbaPreCheck
Pro_PreCondtionType[SKILL_ARCH].Func = SkillHelperFunc.ARCH
Pro_PreCondtionType[SKILL_Lianhuan].Func = SkillHelperFunc.Lianhuan
Pro_PreCondtionType[SKILL_HUPAO].Func = SkillHelperFunc.HUPAO
Pro_PreCondtionType[SKILL_Machine].Func = SkillHelperFunc.Machine
Pro_PreCondtionType[SKILL_WOLF].Func = SkillHelperFunc.WOLF
Pro_PreCondtionType[SKILL_POISON].Func = SkillHelperFunc.POISON
Pro_PreCondtionType[SKILL_SOLO].Func = SkillHelperFunc.SOLO
Pro_PreCondtionType[SKILL_ENSEMBLE].Func = SkillHelperFunc.ENSEMBLE
function SkillHelperFunc.DoDynamicCost(costtype, srcUser, skillid)
  local func = SkillHelperFunc.DynamicCostFunc[costtype]
  if func == nil then
    return
  end
  func(srcUser)
end
function SkillHelperFunc.DoDynamicCost_Aba(srcUser, skillid)
  if not srcUser:HasBuffID(100510) then
    return false
  end
  local powerLayer = srcUser:GetBuffLayer(100500)
  if powerLayer == 0 then
    return false
  end
  if powerLayer >= 1 then
    if srcUser:HasBuffID(100700) then
      srcUser:DelSkillBuff(100500, 1)
      return true
    end
    if powerLayer >= 3 then
      if srcUser:HasBuffID(100631) then
        srcUser:DelSkillBuff(100500, 3)
        return true
      end
      if powerLayer >= 4 then
        if srcUser:HasBuffID(100620) or srcUser:HasBuffID(100685) then
          srcUser:DelSkillBuff(100500, 4)
          return true
        end
        if powerLayer >= 5 then
          srcUser:DelSkillBuff(100500, 5)
          return true
        end
      end
    end
  end
  return false
end
function SkillHelperFunc.DoDynamicCost_Arch(srcUser, skillid)
  if srcUser == nil then
    return
  end
  local inBomb = srcUser:HasBuffID(100510)
  if inBomb == true then
    return
  end
  srcUser:DelSkillBuff(100500, 1)
end
function SkillHelperFunc.DoDynamicCost_Lianhuan(srcUser, skillid)
  if srcUser == nil then
    return
  end
  if srcUser:HasBuffID(100685) then
    return
  elseif srcUser:HasBuffID(100600) then
    srcUser:DelSkillBuff(100600, 1)
    return
  end
end
SkillHelperFunc.DynamicCostFunc = {
  [1] = SkillHelperFunc.DoDynamicCost_Aba,
  [2] = SkillHelperFunc.DoDynamicCost_Arch,
  [3] = SkillHelperFunc.DoDynamicCost_Lianhuan
}
