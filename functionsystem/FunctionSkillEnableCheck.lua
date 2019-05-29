autoImport("SkillPrecondCheck")
autoImport("SkillHelperFunc")
FunctionSkillEnableCheck = class("FunctionSkillEnableCheck")
function FunctionSkillEnableCheck.Me()
  if nil == FunctionSkillEnableCheck.me then
    FunctionSkillEnableCheck.me = FunctionSkillEnableCheck.new()
  end
  return FunctionSkillEnableCheck.me
end
function FunctionSkillEnableCheck:ctor()
  self:SetMySelf(Game.Myself)
  self.tick = TimeTickManager.Me():CreateTick(0, 100, self.TickCheck, self, 1, true)
  self.skillsTypeCheck = {
    whole = {}
  }
  self.skillsCondition = {}
  self.usedSkillPassTime = {}
  self.stateSkill = {}
  self.typeChecks = {}
  self.typeChecks[SkillPrecondCheck.PreConditionType.AfterUseSkill] = self.AfterUseSkillCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.WearEquip] = self.WearEquipCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.HpLessThan] = self.HpLessThanCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.MyselfState] = self.MyselfStateCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.Partner] = self.MyselfPartnerCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.Buff] = self.BuffCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.BeingState] = self.BeingStateCheck
  self.typeChecks[SkillPrecondCheck.PreConditionType.Map] = self.MapCheck
  self.typeOnAdd = {}
  self.typeOnAdd[SkillPrecondCheck.PreConditionType.MyselfState] = self.OnAddStateCheckSkill
  self.typeOnRemove = {}
  self.typeOnRemove[SkillPrecondCheck.PreConditionType.MyselfState] = self.OnRemoveStateCheckSkill
  self:AddListener()
end
function FunctionSkillEnableCheck:AddListener()
  EventManager.Me():AddEventListener(SkillEvent.SkillEquip, self.AddCheckSkill, self)
  EventManager.Me():AddEventListener(SkillEvent.SkillDisEquip, self.RemoveCheckSkill, self)
  EventManager.Me():AddEventListener(SkillEvent.SkillUpdate, self.SkillUpdateHandler, self)
  EventManager.Me():AddEventListener(ServiceEvent.SkillMultiSkillOptionSyncSkillCmd, self.SkillOptionSyncHandler, self)
  EventManager.Me():AddEventListener(SkillEvent.UpdateSubSkill, self.SkillOptionUpdateHandler, self)
  EventManager.Me():AddEventListener(RoleEquipEvent.TakeOn, self.RoleEquipUpdateCheck, self)
  EventManager.Me():AddEventListener(RoleEquipEvent.TakeOff, self.RoleEquipUpdateCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.UsedSkill, self.UsedSkillCheck, self)
  EventManager.Me():AddEventListener(SceneCreatureEvent.PropHpChange, self.HpCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.PartnerChange, self.PartnerUpdateCheck, self)
  EventManager.Me():AddEventListener(MyselfEvent.BuffChange, self.BuffUpdateCheck, self)
  EventManager.Me():AddEventListener(PetEvent.BeingInfoData_SummonChange, self.SummonChangeCheck, self)
  EventManager.Me():AddEventListener(PetEvent.BeingInfoData_AliveChange, self.SummonChangeCheck, self)
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.MapUpdateCheck, self)
  FunctionCheck.Me():AddEventListener(MyselfEvent.MyPropChange, self.PropChangeCheck, self)
end
function FunctionSkillEnableCheck:Log(arg1, arg2, arg3, arg4, arg5)
  if self.enableLog then
    helplog(arg1, arg2, arg3, arg4, arg5)
  end
end
function FunctionSkillEnableCheck:Reset()
end
function FunctionSkillEnableCheck:SetMySelf(myself)
  if myself then
    self.myself = myself
  end
end
function FunctionSkillEnableCheck:Launch()
  if self.isRunning then
    return
  end
  self.isRunning = true
end
function FunctionSkillEnableCheck:ShutDown()
  if not self.isRunning then
    return
  end
  self.isRunning = false
end
function FunctionSkillEnableCheck:SkillUpdateHandler()
  if SkillProxy.Instance.equipedAutoArrayDirty then
    local skill, incheck
    local instance = SkillProxy.Instance
    if GameConfig.AutoSkillGroup then
      for k, v in pairs(GameConfig.AutoSkillGroup) do
        if #v > 1 then
          for i = 1, #v do
            skill = instance:GetLearnedSkillBySortID(v[i])
            if skill then
              incheck = self.skillsCondition[skill.guid]
              if skill and not incheck then
                self:AddCheckSkill(skill)
              end
            end
          end
        end
      end
    end
    for k, v in pairs(self.skillsCondition) do
      self:PureAddCheckSubSkill(v.skillItemData)
    end
    for k, v in pairs(self.skillsCondition) do
      skill = instance:GetLearnedSkill(v.skillItemData.id)
      if skill == nil then
        self:RemoveCheckSkill(v)
      end
    end
  end
end
function FunctionSkillEnableCheck:SkillOptionSyncHandler(data)
  local opt, subSkillList, subSkill
  local BuffSkillList = SkillOptionManager.OptionEnum.BuffSkillList
  local instance = SkillProxy.Instance
  local CheckReasonSubSkill = SkillPrecondCheck.CheckReason.SubSkill
  for i = 1, #data.opts do
    opt = data.opts[i]
    if opt.opt == BuffSkillList then
      subSkillList = Game.SkillOptionManager:GetMultiSkillOption(opt.opt, opt.value)
      if subSkillList ~= nil then
        for i = 1, #subSkillList do
          subSkill = instance:GetLearnedSkill(subSkillList[i])
          if subSkill ~= nil then
            self:PureAddCheckSkill(subSkill, CheckReasonSubSkill)
          end
        end
      end
    end
  end
end
function FunctionSkillEnableCheck:SkillOptionUpdateHandler(data)
  local subSkill
  local instance = SkillProxy.Instance
  local CheckReasonSubSkill = SkillPrecondCheck.CheckReason.SubSkill
  for k, v in pairs(data) do
    subSkill = instance:GetLearnedSkill(k)
    if subSkill ~= nil then
      if v == 1 then
        self:PureAddCheckSkill(subSkill, CheckReasonSubSkill)
      elseif v == 0 then
        self:PureRemoveCheckSkill(subSkill, CheckReasonSubSkill)
      end
    end
  end
end
function FunctionSkillEnableCheck:AddCheckSkill(skillItemData, checkReason)
  self:PureAddCheckSkill(skillItemData, checkReason)
  self:PureAddCheckSubSkill(skillItemData)
end
function FunctionSkillEnableCheck:RemoveCheckSkill(skillItemData, checkReason)
  self:PureRemoveCheckSkill(skillItemData, checkReason)
  self:PureRemoveCheckSubSkill(skillItemData)
end
function FunctionSkillEnableCheck:PureAddCheckSkill(skillItemData, checkReason)
  checkReason = checkReason or SkillPrecondCheck.CheckReason.Skill
  local preCondtionCheck = self.skillsCondition[skillItemData.guid]
  if preCondtionCheck == nil then
    local conditionCheck = SkillPrecondCheck.new(skillItemData)
    conditionCheck:SetCheckReason(checkReason)
    self:AddTypeCheck(skillItemData, conditionCheck)
    self.skillsCondition[skillItemData.guid] = conditionCheck
    self:CheckSkill(conditionCheck)
  else
    preCondtionCheck:SetCheckReason(checkReason)
  end
end
function FunctionSkillEnableCheck:PureRemoveCheckSkill(skillItemData, checkReason)
  checkReason = checkReason or SkillPrecondCheck.CheckReason.Skill
  local preCondtionCheck = self.skillsCondition[skillItemData.guid]
  if preCondtionCheck then
    preCondtionCheck:RemoveCheckReason(checkReason)
    if not preCondtionCheck:HasCheckReason() then
      self:OnRemoveStateCheckSkill(preCondtionCheck)
      self:RemoveTypeCheck(skillItemData)
      self.skillsCondition[skillItemData.guid] = nil
    end
  end
end
function FunctionSkillEnableCheck:PureAddCheckSubSkill(skillItemData)
  if skillItemData:HasSubSkill() then
    local subSkillList = Game.SkillOptionManager:GetMultiSkillOption(SkillOptionManager.OptionEnum.BuffSkillList, skillItemData:GetID())
    if subSkillList ~= nil then
      local subSkill, condition
      local instance = SkillProxy.Instance
      local CheckReasonSubSkill = SkillPrecondCheck.CheckReason.SubSkill
      for i = 1, #subSkillList do
        subSkill = instance:GetLearnedSkill(subSkillList[i])
        if subSkill ~= nil then
          self:PureAddCheckSkill(subSkill, CheckReasonSubSkill)
        end
      end
    end
  end
end
function FunctionSkillEnableCheck:PureRemoveCheckSubSkill(skillItemData)
  if skillItemData:HasSubSkill() then
    local subSkillList = Game.SkillOptionManager:GetMultiSkillOption(SkillOptionManager.OptionEnum.BuffSkillList, skillItemData:GetID())
    if subSkillList ~= nil then
      local subSkill, condition
      local instance = SkillProxy.Instance
      local CheckReasonSubSkill = SkillPrecondCheck.CheckReason.SubSkill
      for i = 1, #subSkillList do
        subSkill = instance:GetLearnedSkill(subSkillList[i])
        if subSkill ~= nil then
          condition = self.skillsCondition[subSkill.guid]
          if condition ~= nil then
            self:PureRemoveCheckSkill(subSkill, CheckReasonSubSkill)
          end
        end
      end
    end
  end
end
function FunctionSkillEnableCheck:OnAddStateCheckSkill(preCondtionCheck)
  local skill = preCondtionCheck.skillItemData
  local preConditions = skill.staticData.PreCondition
  local prop, preCondition
  for i = 1, #preConditions do
    preCondition = preConditions[i]
    for k, v in pairs(preCondition) do
      if k ~= "type" then
        prop = k
        if prop then
          local skills = self.stateSkill[prop]
          if skills == nil then
            skills = {}
            self.stateSkill[prop] = skills
          end
          local index = TableUtil.ArrayIndexOf(skills, preCondtionCheck)
          if index == 0 then
            skills[#skills + 1] = preCondtionCheck
          end
        end
      end
    end
  end
end
function FunctionSkillEnableCheck:OnRemoveStateCheckSkill(preCondtionCheck)
  local skill = preCondtionCheck.skillItemData
  local preConditions = skill.staticData.PreCondition
  local preCondition
  for i = 1, #preConditions do
    preCondition = preConditions[i]
    if preCondition.type == SkillPrecondCheck.PreConditionType.MyselfState then
      local prop
      for k, v in pairs(preCondition) do
        if k ~= "type" then
          prop = k
          if prop then
            local skills = self.stateSkill[prop]
            if skills then
              TableUtil.Remove(skills, preCondtionCheck)
            end
          end
        end
      end
    end
  end
end
function FunctionSkillEnableCheck:AddTypeCheck(skill, preCondtionCheck)
  local preCondition = skill.staticData.PreCondition
  if preCondition then
    if preCondition.ProType then
      preCondition = SkillHelperFunc.GetProRelateCheckTypes(preCondition.ProType)
    end
    if #preCondition > 0 then
      local pcond, pcondType
      for i = 1, #preCondition do
        pcond = preCondition[i]
        if type(pcond) == "number" then
          pcondType = pcond
        else
          pcondType = pcond.type
        end
        local typeMap = self.skillsTypeCheck[pcondType]
        if typeMap == nil then
          typeMap = {}
          self.skillsTypeCheck[pcondType] = typeMap
        end
        local onAdd = self.typeOnAdd[pcondType]
        if onAdd then
          onAdd(self, preCondtionCheck)
        end
        typeMap[skill.guid] = preCondtionCheck
        self.skillsTypeCheck.whole[skill.guid] = preCondtionCheck
      end
      return true
    end
  end
  return false
end
function FunctionSkillEnableCheck:RemoveTypeCheck(skill)
  local preCondition = skill.staticData.PreCondition
  if preCondition then
    if preCondition.ProType then
      preCondition = SkillHelperFunc.GetProRelateCheckTypes(preCondition.ProType)
    end
    if #preCondition > 0 then
      local pcond, pcondType
      for i = 1, #preCondition do
        pcond = preCondition[i]
        if type(pcond) == "number" then
          pcondType = pcond
        else
          pcondType = pcond.type
        end
        local typeMap = self.skillsTypeCheck[pcondType]
        if typeMap then
          typeMap[skill.guid] = nil
          self.skillsTypeCheck.whole[skill.guid] = nil
        end
      end
    end
  end
end
function FunctionSkillEnableCheck:GetFirstNotFitPrecondition(skillItemData)
  local precondition = self.skillsTypeCheck.whole[skillItemData.guid]
  if precondition and precondition:HasReason() then
    return precondition:GetFirstReason()
  end
  return nil
end
function FunctionSkillEnableCheck:MsgNotFit(skillItemData)
  local precondition = self.skillsTypeCheck.whole[skillItemData.guid]
  if precondition then
    precondition:MsgReason()
  end
end
function FunctionSkillEnableCheck:CheckSkill(conditionCheck)
  local skill = conditionCheck.skillItemData
  local preCondition = skill.staticData.PreCondition
  if preCondition then
    if preCondition.ProType then
      local res = SkillHelperFunc.CheckPrecondtionByProType(preCondition.ProType, Game.Myself.data, skill:GetID())
      self:_SetSkillPreCondAndFireEvent(skill, res)
    elseif #preCondition > 0 then
      local pcond, pcondType
      for i = 1, #preCondition do
        pcond = preCondition[i]
        if type(pcond) == "number" then
          pcondType = pcond
        else
          pcondType = pcond.type
        end
        self:Log("check skill ", skill.staticData.NameZh, " type: ", pcondType)
        local check = self.typeChecks[pcondType]
        if check then
          check(self, conditionCheck)
        end
      end
    end
  end
end
function FunctionSkillEnableCheck:UpdateReason(check, state, skill, reason)
  if state then
    check:SetReason(reason and reason or skill.guid)
  else
    check:RemoveReason(reason and reason or skill.guid)
  end
  if check:IsDirty() then
    self:_SetSkillPreCondAndFireEvent(skill, check:HasReason())
  end
end
function FunctionSkillEnableCheck:_ProCheckSkillPreCond(conditionCheck)
  local skill = conditionCheck.skillItemData
  local preCondition = skill.staticData.PreCondition
  if preCondition and preCondition.ProType then
    local res = SkillHelperFunc.CheckPrecondtionByProType(preCondition.ProType, Game.Myself.data, skill:GetID())
    self:_SetSkillPreCondAndFireEvent(skill, res)
    return true
  end
  return false
end
function FunctionSkillEnableCheck:_SetSkillPreCondAndFireEvent(skill, value)
  local nowPrecond = skill:GetFitPreCond()
  if nowPrecond ~= value then
    skill:SetFitPreCond(value)
    EventManager.Me():PassEvent(SkillEvent.SkillFitPreCondtion, skill)
  end
end
function FunctionSkillEnableCheck:BuffCheck(conditionCheck)
  local skill = conditionCheck.skillItemData
  local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.Buff)
  local myself = Game.Myself
  if needChecks then
    local preCondition
    for i = 1, #needChecks do
      preCondition = needChecks[i]
      if myself:HasBuff(preCondition.id) then
        self:UpdateReason(conditionCheck, true, skill, preCondition)
      else
        self:UpdateReason(conditionCheck, false, skill, preCondition)
      end
    end
  end
end
function FunctionSkillEnableCheck:AfterUseSkillCheck(conditionCheck)
  local skill = conditionCheck.skillItemData
  local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.AfterUseSkill)
  if needChecks then
    local preCondition
    for i = 1, #needChecks do
      preCondition = needChecks[i]
      local passedTime = self.usedSkillPassTime[preCondition.skillid]
      if passedTime ~= nil and passedTime <= preCondition.time then
        self:UpdateReason(conditionCheck, true, skill, preCondition)
      else
        self:UpdateReason(conditionCheck, false, skill, preCondition)
      end
    end
  end
end
function FunctionSkillEnableCheck:WearEquipCheck(conditionCheck)
  local skill = conditionCheck.skillItemData
  local equipBag = BagProxy.Instance:GetRoleEquipBag()
  local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.WearEquip)
  if needChecks then
    local preCondition
    for i = 1, #needChecks do
      preCondition = needChecks[i]
      local itemtype = preCondition.itemtype
      local itemid = preCondition.itemid
      if itemtype ~= nil then
        local num = equipBag:GetNumByItemType(itemtype)
        if num > 0 then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      elseif itemid ~= nil then
        local num = equipBag:GetStaticIdMap()[itemid]
        if num ~= nil then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      end
    end
  end
end
function FunctionSkillEnableCheck:HpLessThanCheck(conditionCheck)
  if self.myself then
    local skill = conditionCheck.skillItemData
    local hpPercent = self.myself.data.props.Hp:GetValue() / self.myself.data.props.MaxHp:GetValue() * 100
    local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.HpLessThan)
    if needChecks then
      local preCondition
      for i = 1, #needChecks do
        preCondition = needChecks[i]
        local hpPercentCond = preCondition.value
        if hpPercent > hpPercentCond then
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        end
      end
    end
  end
end
function FunctionSkillEnableCheck:MyselfPartnerCheck(conditionCheck, partnerID)
  if self.myself then
    local skill = conditionCheck.skillItemData
    partnerID = partnerID or self.myself.data.userdata:Get(UDEnum.PET_PARTNER)
    local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.Partner)
    if needChecks then
      local preCondition
      for i = 1, #needChecks do
        preCondition = needChecks[i]
        local fitParnter = false
        for i = 1, #preCondition.id do
          if partnerID == preCondition.id[i] then
            fitParnter = true
          end
        end
        if fitParnter then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      end
    end
  end
end
function FunctionSkillEnableCheck:GetPrecondtionProp(preCondition)
  local prop
  for k, v in pairs(preCondition) do
    if k ~= "type" then
      prop = k
      break
    end
  end
  return prop
end
function FunctionSkillEnableCheck:MyselfStateCheck(conditionCheck, prop)
  if self.myself then
    local skill = conditionCheck.skillItemData
    local preCondition = skill.staticData.PreCondition
    local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.MyselfState)
    if needChecks then
      local preCondition
      if prop == nil then
        for i = 1, #needChecks do
          preCondition = needChecks[i]
          for k, v in pairs(preCondition) do
            if k ~= "type" then
              prop = k
              if prop then
                prop = self.myself.data.props[prop]
                self:PropCheck(conditionCheck, prop, skill, preCondition)
              end
            end
          end
        end
      else
        for i = 1, #needChecks do
          preCondition = needChecks[i]
          local condP = self:GetPrecondtionProp(preCondition)
          if not condP or condP ~= prop.propVO.name then
          end
        end
        self:PropCheck(conditionCheck, prop, skill, preCondition)
      end
    end
  end
end
function FunctionSkillEnableCheck:PropCheck(conditionCheck, prop, skill, preCondition)
  if prop then
    local propValue = prop:GetValue()
    if prop.propVO.name == "AttrEffect" then
      propValue = BitUtil.band(propValue, preCondition.AttrEffect - 1)
    end
    if propValue > 0 then
      self:UpdateReason(conditionCheck, true, skill, preCondition)
    else
      self:UpdateReason(conditionCheck, false, skill, preCondition)
    end
  else
    self:UpdateReason(conditionCheck, true, skill, preCondition)
  end
end
function FunctionSkillEnableCheck:UsedSkillCheck(skillIDAndLevel, passedTime)
  passedTime = passedTime or 0
  local skillID = math.floor(skillIDAndLevel / 1000)
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.AfterUseSkill]
  if preConditions then
    local preCondition
    for k, v in pairs(preConditions) do
      local needChecks = v:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.AfterUseSkill)
      if needChecks then
        local preCondition
        for i = 1, #needChecks do
          preCondition = needChecks[i]
          if preCondition.skillid == skillID then
            if passedTime <= preCondition.time then
              self:UpdateReason(v, true, v.skillItemData, preCondition)
            else
              self:UpdateReason(v, false, v.skillItemData, preCondition)
            end
          end
        end
      end
    end
  end
  self.usedSkillPassTime[skillID] = passedTime
end
function FunctionSkillEnableCheck:RoleEquipUpdateCheck(item)
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.WearEquip]
  if preConditions then
    local preCondition
    local equipBag = BagProxy.Instance:GetRoleEquipBag()
    local numType = equipBag:GetNumByItemType(item.staticData.Type)
    local num = equipBag:GetStaticIdMap()[item.staticData.id]
    for k, v in pairs(preConditions) do
      if self:_ProCheckSkillPreCond(v) == false then
        local needChecks = v:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.WearEquip)
        if needChecks then
          local preCondition
          for i = 1, #needChecks do
            preCondition = needChecks[i]
            if preCondition.itemtype == item.staticData.Type then
              if numType > 0 then
                self:UpdateReason(v, true, v.skillItemData, preCondition)
              else
                self:UpdateReason(v, false, v.skillItemData, preCondition)
              end
            elseif preCondition.itemid == item.staticData.id then
              if num ~= nil then
                self:UpdateReason(v, true, v.skillItemData, preCondition)
              else
                self:UpdateReason(v, false, v.skillItemData, preCondition)
              end
            end
          end
        end
      end
    end
  end
end
function FunctionSkillEnableCheck:BuffUpdateCheck()
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.Buff]
  if preConditions then
    local preCondition
    local myself = Game.Myself
    for k, v in pairs(preConditions) do
      self:_ProCheckSkillPreCond(v)
      local needChecks = v:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.Buff)
      if needChecks then
        local preCondition
        for i = 1, #needChecks do
          preCondition = needChecks[i]
          if myself:HasBuff(preCondition.id) then
            self:UpdateReason(v, true, v.skillItemData, preCondition)
          else
            self:UpdateReason(v, false, v.skillItemData, preCondition)
          end
        end
      end
    end
  end
end
function FunctionSkillEnableCheck:HpCheck()
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.HpLessThan]
  if preConditions then
    local preCondition
    local hpPercent = self.myself.data.props.Hp:GetValue() / self.myself.data.props.MaxHp:GetValue() * 100
    for k, v in pairs(preConditions) do
      if self:_ProCheckSkillPreCond(v) == false then
        local needChecks = v:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.HpLessThan)
        if needChecks then
          local preCondition
          for i = 1, #needChecks do
            preCondition = needChecks[i]
            if hpPercent <= preCondition.value then
              self:UpdateReason(v, true, v.skillItemData, preCondition)
            else
              self:UpdateReason(v, false, v.skillItemData, preCondition)
            end
          end
        end
      end
    end
  end
end
function FunctionSkillEnableCheck:PropChangeCheck(p)
  local propName = p.propVO.name
  local relativeSkills = self.stateSkill[propName]
  if relativeSkills then
    for k, v in pairs(relativeSkills) do
      self:MyselfStateCheck(v, p)
    end
  end
end
function FunctionSkillEnableCheck:PartnerUpdateCheck(id)
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.Partner]
  if preConditions then
    for k, v in pairs(preConditions) do
      self:_ProCheckSkillPreCond(v)
      self:MyselfPartnerCheck(v, id)
    end
  end
end
function FunctionSkillEnableCheck:TickCheck(deltaTime)
  for k, v in pairs(self.usedSkillPassTime) do
    v = v + deltaTime
    self.usedSkillPassTime[k] = v
  end
  local skills = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.AfterUseSkill]
  if skills then
    for k, v in pairs(skills) do
      self:AfterUseSkillCheck(v)
    end
  end
end
function FunctionSkillEnableCheck:LearnedSkillCheck(skillIDAndLevel)
  local skill = Table_Skill[skillIDAndLevel]
  if skill then
    local preConditions = skill.PreCondition
    if preConditions then
      local precond
      for i = 1, #preConditions do
        precond = preConditions[i]
        if precond ~= nil and precond.type == SkillPrecondCheck.PreConditionType.LearnedSkill then
          return SkillProxy.Instance:GetLearnedSkillBySortID(precond.skillid) ~= nil, precond.skillid
        end
      end
    end
  end
  return true
end
function FunctionSkillEnableCheck:BeingStateCheck(conditionCheck)
  local skill = conditionCheck.skillItemData
  local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.BeingState)
  local summoned = PetProxy.Instance:GetMySummonBeingInfo()
  if needChecks then
    local preCondition
    for i = 1, #needChecks do
      preCondition = needChecks[i]
      if preCondition.not_exist then
        if summoned == nil then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      elseif preCondition.died then
        if summoned ~= nil and not summoned:IsAlive() then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      elseif preCondition.alive then
        local id = preCondition.alive
        if summoned ~= nil and summoned:IsAlive() and (id == 1 or id == summoned.beingid) then
          self:UpdateReason(conditionCheck, true, skill, preCondition)
        else
          self:UpdateReason(conditionCheck, false, skill, preCondition)
        end
      end
    end
  end
end
function FunctionSkillEnableCheck:SummonChangeCheck(beingInfoData)
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.BeingState]
  if preConditions then
    local preCondition
    for k, v in pairs(preConditions) do
      if self:_ProCheckSkillPreCond(v) == false then
        self:BeingStateCheck(v)
      end
    end
  end
end
function FunctionSkillEnableCheck:MapCheck(conditionCheck)
  local skill = conditionCheck.skillItemData
  local needChecks = conditionCheck:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.Map)
  if needChecks then
    local preCondition
    local mapid = Game.MapManager:GetMapID()
    for i = 1, #needChecks do
      preCondition = needChecks[i]
      if preCondition.id == mapid then
        self:UpdateReason(conditionCheck, true, skill, preCondition)
      else
        self:UpdateReason(conditionCheck, false, skill, preCondition)
      end
    end
  end
end
function FunctionSkillEnableCheck:MapUpdateCheck()
  local preConditions = self.skillsTypeCheck[SkillPrecondCheck.PreConditionType.Map]
  if preConditions then
    local preCondition
    local mapid = Game.MapManager:GetMapID()
    for k, v in pairs(preConditions) do
      local needChecks = v:GetPrecondtionsByType(SkillPrecondCheck.PreConditionType.Map)
      if needChecks then
        local preCondition
        for i = 1, #needChecks do
          preCondition = needChecks[i]
          if preCondition.id == mapid then
            self:UpdateReason(v, true, v.skillItemData, preCondition)
          else
            self:UpdateReason(v, false, v.skillItemData, preCondition)
          end
        end
      end
    end
  end
end
