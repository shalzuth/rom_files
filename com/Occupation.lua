Occupation = reusableClass("Occupation")
function Occupation:DoConstruct(asArray, data)
  local level = data[1]
  local exp = data[2]
  local profession = data[3]
  self:ResetData(level, exp, profession)
end
function Occupation:ResetData(level, exp, profession)
  if not profession then
    return
  end
  self.exp = exp
  self.profession = profession
  self.professionData = Table_Class[self.profession]
  self:SetLevel(level)
  local curP = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  self.isCurrent = profession == curP and true or false
end
function Occupation:GetLevelText()
  return self.levelText
end
function Occupation:GetLevel()
  return self.level
end
function Occupation.GetFixedJobLevel(lv, profession)
  local professionData = profession
  if profession == nil then
    helplog("profession== nil")
    return 0
  end
  if type(professionData) == "number" then
    professionData = Table_Class[profession]
  end
  local previousClasses = professionData.previousClasses
  local preMaxPJobLv = 0
  local preMaxJobLv = 0
  if previousClasses then
    preMaxPJobLv = previousClasses.MaxPeak or 0
    preMaxJobLv = previousClasses.MaxJobLevel or 0
  end
  if lv < preMaxPJobLv then
    lv = lv - preMaxJobLv
  else
    lv = lv - preMaxPJobLv
  end
  return lv
end
function Occupation.GetMyFixedJobLevelWithMax(lv, profession)
  local hasJobBreak = MyselfProxy.Instance:HasJobBreak()
  return Occupation.GetFixedJobLevelWithMax(lv, profession, hasJobBreak)
end
function Occupation.GetFixedJobLevelWithMax(lv, profession, hasJobBreak)
  local professionData = Table_Class[profession]
  local lv = Occupation.GetFixedJobLevel(lv, professionData)
  local maxJobLv = professionData.MaxJobLevel
  if professionData.MaxPeak then
    maxJobLv = professionData.MaxPeak
  end
  local previousClasses = professionData.previousClasses
  local preMaxJobLv = 0
  preMaxJobLv = previousClasses and (previousClasses.MaxPeak or previousClasses.MaxJobLevel)
  lv = math.max(0, math.min(lv, maxJobLv - preMaxJobLv or 0))
  return lv
end
function Occupation:SetLevel(lv)
  if self.level ~= lv then
    self.level = lv
    self.levelText = Occupation.GetFixedJobLevel(lv, self.professionData)
  end
end
function Occupation:GetExp()
  return self.exp
end
function Occupation:SetExp(exp)
  self.exp = exp
end
