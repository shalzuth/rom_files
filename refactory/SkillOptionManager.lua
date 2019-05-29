SkillOptionManager = class("SkillOptionManager")
SkillOptionManager.OptionEnum = {
  AutoQueue = SceneSkill_pb.ESKILLOPTION_AUTOQUEUE,
  SummonBeing = SceneSkill_pb.ESKILLOPTION_SUMMONBEING,
  AutoArchery = SceneSkill_pb.ESKILLOPTION_AUTO_ARCHERY,
  FistsMagic = SceneSkill_pb.ESKILLOPTION_FISTS_MAGIC,
  SummonElement = SceneSkill_pb.ESKILLOPTION_SUMMON_ELEMENT,
  BuffSkillList = SceneSkill_pb.ESKILLOPTION_BUFF_SKILLLIST
}
function SkillOptionManager:ctor()
  self._options = {}
  self._callBacks = {}
  self._dirtySkills = {}
  self:AddChangeCallBack(self.OptionEnum.AutoQueue, self.HandleSkillAutoQueue)
end
function SkillOptionManager:AddChangeCallBack(t, func)
  self._callBacks[t] = func
end
function SkillOptionManager:GetSkillOptionByType(t)
  return self._options[t] or 0
end
function SkillOptionManager:AskSetSkillOption(t, value)
  if value >= 0 then
    local opt = SceneSkill_pb.SkillOption()
    opt.opt = t
    opt.value = value
    ServiceSkillProxy.Instance:CallSkillOptionSkillCmd(opt)
  end
end
function SkillOptionManager:RecvServerOpts(opts)
  if opts ~= nil and #opts > 0 then
    for i = 1, #opts do
      self:HandleOpt(opts[i].opt, opts[i].value)
    end
  end
end
function SkillOptionManager:HandleOpt(t, value)
  local callBack = self._callBacks[t]
  local oldValue = self._options[t]
  if oldValue == nil then
    oldValue = 0
  end
  self._options[t] = value
  if callBack then
    callBack(self, oldValue, value)
  end
end
function SkillOptionManager:GetSkillOption_AutoQueue()
  return self:GetSkillOptionByType(self.OptionEnum.AutoQueue)
end
function SkillOptionManager:SetSkillOption_AutoQueue(value)
  self:AskSetSkillOption(self.OptionEnum.AutoQueue, value == true and 0 or 1)
end
function SkillOptionManager:GetSkillOption(optionType)
  return optionType ~= nil and self:GetSkillOptionByType(optionType) or 0
end
function SkillOptionManager:SetSkillOption(optionType, value)
  if optionType ~= nil then
    self:AskSetSkillOption(optionType, value)
  end
end
function SkillOptionManager:HandleSkillAutoQueue(oldValue, newValue)
  if newValue == 0 then
    Game.SkillClickUseManager:Launch()
  else
    Game.SkillClickUseManager:ShutDown()
  end
end
function SkillOptionManager:RecvMultiSkillOptionSyncSkillCmd(data)
  for i = 1, #data.opts do
    self:UpdateMultiSkillOption(data.opts[i])
  end
end
function SkillOptionManager:RecvMultiSkillOptionUpdateSkillCmd(data)
  self:UpdateMultiSkillOption(data.opt)
  EventManager.Me():PassEvent(SkillEvent.UpdateSubSkill, self._dirtySkills)
end
function SkillOptionManager:UpdateMultiSkillOption(skillOption)
  local skillMap = self._options[skillOption.opt]
  if skillMap == nil then
    skillMap = {}
    self._options[skillOption.opt] = skillMap
  end
  TableUtility.TableClear(self._dirtySkills)
  local subSkillList = skillMap[skillOption.value]
  if subSkillList == nil then
    subSkillList = {}
    skillMap[skillOption.value] = subSkillList
  else
    for i = #subSkillList, 1, -1 do
      self._dirtySkills[subSkillList[i]] = 0
      subSkillList[i] = nil
    end
  end
  local value
  for i = 1, #skillOption.values do
    value = skillOption.values[i]
    if self._dirtySkills[value] == nil then
      self._dirtySkills[value] = 1
    else
      self._dirtySkills[value] = nil
    end
    subSkillList[#subSkillList + 1] = value
  end
end
function SkillOptionManager:GetMultiSkillOption(optionType, skillid)
  local skillMap = self._options[optionType]
  if skillMap == nil then
    return nil
  end
  return skillMap[skillid]
end
function SkillOptionManager:IsInSkillOption(optionType, skillid, subSkillid)
  local skillList = self:GetMultiSkillOption(optionType, skillid)
  if skillList ~= nil then
    for i = 1, #skillList do
      if skillList[i] == subSkillid then
        return true
      end
    end
  end
  return false
end
