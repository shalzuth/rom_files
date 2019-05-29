autoImport("SkillItemData")
autoImport("SkillPvpTalentData")
autoImport("SkillDynamicInfo")
autoImport("EquipedSkills")
SkillProxy = class("SkillProxy", pm.Proxy)
SkillProxy.Instance = nil
SkillProxy.NAME = "SkillProxy"
SkillProxy.UNLOCKPROSKILLPOINTS = 40
SkillProxy.ManulSkillsIndex = 1
SkillProxy.AutoSkillsIndex = 2
SkillProxy.AutoSkillsWithComboIndex = 3
local ArrayFind = function(array, data, paramName)
  for i = 1, #array do
    if array[i][paramName] == data[paramName] then
      return array[i]
    end
  end
  return nil
end
local GetSubSkillOriginSP = function(id, param, totalSp)
  local staticData = Table_Skill[id]
  if staticData ~= nil then
    local sp = staticData.SkillCost.sp
    if sp ~= nil then
      totalSp = totalSp + sp
    end
    return totalSp
  end
end
local GetSubSkillSP = function(id, creature, totalSp)
  local subSkill = Game.LogicManager_Skill:GetSkillInfo(id)
  if subSkill ~= nil then
    local sp = subSkill:GetSP(creature)
    if sp ~= nil then
      totalSp = totalSp + sp
    end
    return totalSp
  end
end
local AddSpecialCost = function(list, staticData, paramName)
  if staticData[paramName] then
    local value = ArrayFind(list, staticData, paramName)
    if value == nil then
      local data = ReusableTable.CreateTable()
      data[paramName] = staticData[paramName]
      data.num = staticData.num
      list[#list + 1] = data
    else
      value.num = value.num + staticData.num
    end
  end
end
local GetSubSkillSpecialCost = function(id, param, list)
  local staticData = Table_Skill[id]
  if staticData ~= nil then
    local costs = staticData.SkillCost
    for i = 1, #costs do
      AddSpecialCost(list, costs[i], "itemID")
      AddSpecialCost(list, costs[i], "buffID")
    end
  end
  return list
end
function SkillProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SkillProxy.NAME
  if SkillProxy.Instance == nil then
    SkillProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.professionSkills = {}
  self.pvpTalentSkills = {}
  self.transformProfess = SkillProfessData.new(99999, 0)
  self.equipedSkills = {}
  self.equipedAutoSkills = {}
  self.equipedSkillsArrays = {
    {},
    {},
    {}
  }
  self.comboGetPrevious = {}
  self.equipedAutoArrayDirty = false
  self:ResetTransformSkills(0)
  self.learnedSkills = {}
  self.sameProfessionType = {}
  self.dynamicSkillInfos = {}
  self:initSameProfessionType()
  self:InitCombo()
  FunctionSkillEnableCheck.Me():Launch()
end
function SkillProxy:InitCombo()
  if GameConfig.AutoSkillGroup then
    for k, v in pairs(GameConfig.AutoSkillGroup) do
      if #v > 1 then
        for i = #v, 2, -1 do
          self.comboGetPrevious[v[i]] = v[i - 1]
        end
      end
    end
  end
end
function SkillProxy:initSameProfessionType()
  for key, value in pairs(Table_Class) do
    local singleItem = Table_Class[key]
    self.sameProfessionType[singleItem.Type] = self.sameProfessionType[singleItem.Type] or {}
    table.insert(self.sameProfessionType[singleItem.Type], singleItem)
  end
  for key, value in pairs(self.sameProfessionType) do
    table.sort(value, function(l, r)
      return l.id <= r.id
    end)
    local list = {}
    for i = 1, #value do
      local cur = value[i]
      local advanceClasses = cur.AdvanceClass
      if advanceClasses then
        for j = 1, #advanceClasses do
          local single = advanceClasses[j]
          list[tostring(single)] = cur
        end
      end
    end
    for i = 1, #value do
      local cur = value[i]
      local singleData = list[tostring(cur.id)]
      if not singleData and key ~= 0 then
        singleData = Table_Class[1]
      end
      cur.previousClasses = singleData
    end
  end
end
function SkillProxy:GetEquipedSkillBySort(sortID)
  for k, v in pairs(self.equipedSkills) do
    if v.sortID == sortID and v.sourceId == 0 then
      return true
    end
  end
  return false
end
function SkillProxy:GetEquipedSkillByGuid(skillId, includeAuto)
  local skill = self.equipedSkills[skillId]
  if skill == nil and includeAuto then
    skill = self:GetEquipedAutoSkillByGuid(skillId)
  end
  return skill
end
function SkillProxy:GetEquipedAutoSkillByGuid(skillId)
  return self.equipedAutoSkills[skillId]
end
function SkillProxy:startCdTimeBySkillId(skillId)
  local sortID = math.floor(skillId / 1000)
  local skills = self.learnedSkills[sortID]
  local findSkill = self:FindSkill(skillId)
  local skillCD, skillDelayCD
  if findSkill and Game.Myself ~= nil then
    local skillInfo = Game.LogicManager_Skill:GetSkillInfo(findSkill:GetID())
    skillCD = skillInfo:GetCD(Game.Myself)
    skillDelayCD = skillInfo:GetDelayCD(Game.Myself)
    if skills then
      local skill
      for i = 1, #skills do
        skill = self:GetEquipedSkillByGuid(skills[i].guid, true)
        if skill == nil then
          skill = self:GetTransformedSkill(skills[i].id)
        end
        if skill == nil then
          skill = skills[i]
        end
        self:_InnerStartCD(skill, skillCD, skillDelayCD)
      end
    else
      self:_InnerStartCD(findSkill, skillCD, skillDelayCD)
    end
    GameFacade.Instance:sendNotification(SkillEvent.SkillStartEvent)
  end
end
function SkillProxy:_InnerStartCD(skillItemData, skillCD, skillDelayCD)
  if skillItemData then
    if skillCD then
      CDProxy.Instance:AddSkillCD(skillItemData.id, 0, skillCD, skillCD)
    end
    local staticData = skillItemData:GetStaticData()
    if staticData then
      local buff
      if Game.MapManager:IsPVPMode() then
        buff = staticData.Buff
      else
        buff = staticData.Pvp_buff
      end
      if buff.self ~= nil then
        local buffConfig, cdTime, buffcd
        for i = 1, #buff.self do
          buffConfig = Table_Buffer[buff.self[i]]
          if buffConfig and buffConfig.BuffEffect and buffConfig.BuffEffect.type and buffConfig.BuffEffect.type == "AddSkillCD" then
            buffcd = buffConfig.BuffEffect.cd
            if buffcd then
              for j = 1, #buffcd do
                cdTime = buffcd[j].time
                CDProxy.Instance:AddSkillCDBySortID(buffcd[j].id, 0, cdTime, cdTime)
              end
            end
          end
        end
      end
    end
    if skillDelayCD and skillDelayCD > 0 then
      CDProxy.Instance:AddSkillCD(CDProxy.CommunalSkillCDID, 0, skillDelayCD, skillDelayCD)
    end
  end
end
function SkillProxy:HasEnoughSkillPoint(pro)
  local p = self:FindProfessSkill(pro)
  if p then
    return p.points >= SkillProxy.UNLOCKPROSKILLPOINTS
  end
  return false
end
function SkillProxy:FindProfessSkill(pro, autoCreate)
  if self.multiSaveId ~= nil then
    local skills = SaveInfoProxy.Instance:GetProfessionSkill(self.multiSaveId, self.multiSaveType)
    if skills ~= nil then
      for i = 1, #skills do
        if pro == skills[i].profession then
          return skills[i]
        end
      end
    end
  else
    for i = 1, #self.professionSkills do
      if pro == self.professionSkills[i].profession then
        return self.professionSkills[i]
      end
    end
  end
  if autoCreate then
    local professData = SkillProfessData.new(pro, 0)
    local p = Table_Class[pro]
    for i = 1, #p.Skill do
      professData:AutoFillAdd(p.Skill[i])
    end
    self:AddProfessSkill(professData)
    return professData
  end
  return nil
end
function SkillProxy:FindSkill(skillID, profession)
  local professionSkill
  if profession then
    professionSkill = self:FindProfessSkill(profession)
    if professionSkill then
      return professionSkill:FindSkillById(skillID)
    end
  end
  local skill
  for i = 1, #self.professionSkills do
    skill = self.professionSkills[i]:FindSkillById(skillID)
    if skill then
      return skill
    end
  end
  for i = 1, #self.pvpTalentSkills do
    skill = self.pvpTalentSkills[i]:FindSkillById(skillID)
    if skill then
      return skill
    end
  end
  return self:GetTransformedSkill(skillID)
end
function SkillProxy:GetPvpTalentSkillsData()
  return self.pvpTalentSkills and #self.pvpTalentSkills > 0 and self.pvpTalentSkills[1] or nil
end
function SkillProxy:ServerReInit(serverData)
  Game.Myself:Client_SetAutoFakeDead(0)
  self.professionSkills = {}
  self.pvpTalentSkills = {}
  self:ClearEquipedSkill()
  self:ClearEquipedSkill(true)
  self.learnedSkills = {}
  local professSkill
  for i = 1, #serverData.data do
    self:AddProfessSkill(self:CreateProfessSkill(serverData.data[i]))
  end
  for i = 1, #serverData.talentdata do
    self:AddLearnedPvpTalentSkill(serverData.talentdata[i])
  end
end
function SkillProxy:ClearEquipedSkill(isAutoMode)
  local t = isAutoMode and self.equipedAutoSkills or self.equipedSkills
  for k, v in pairs(t) do
    FunctionSkillEnableCheck.Me():RemoveCheckSkill(v)
  end
  if isAutoMode then
    self.equipedAutoSkills = {}
    self.equipedSkillsArrays[SkillProxy.AutoSkillsIndex] = {}
  else
    self.equipedSkills = {}
    self.equipedSkillsArrays[SkillProxy.ManulSkillsIndex] = {}
  end
end
function SkillProxy:CreateProfessSkill(serverSkillData)
  local data, skill
  local professSkill = SkillProfessData.new(serverSkillData.profession, serverSkillData.usedpoint)
  local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
  for j = 1, #serverSkillData.items do
    data = serverSkillData.items[j]
    skill = professSkill:UpdateSkill(data)
    if self:_CheckPosInShortCut(skill) then
      self:AddEquipSkill(skill)
    end
    if skill:GetPosInShortCutGroup(shortCutAuto) > 0 then
      self:AddEquipSkill(skill, true)
    end
    if skill.learned then
      self:LearnedSkill(skill)
    end
  end
  professSkill:SortSkills()
  professSkill:UpdateBasePoints(serverSkillData.primarypoint)
  return professSkill
end
function SkillProxy:AddLearnedPvpTalentSkill(serverTalentData)
  local data, skill
  local talentSkills = SkillPvpTalentData.new(serverTalentData.usedpoint)
  local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
  for i = 1, #serverTalentData.items do
    data = serverTalentData.items[i]
    skill = talentSkills:UpdateSkill(data)
    if self:_CheckPosInShortCut(skill) then
      self:AddEquipSkill(skill)
    end
    if skill:GetPosInShortCutGroup(shortCutAuto) > 0 then
      self:AddEquipSkill(skill, true)
    end
    self:LearnedSkill(skill)
  end
  self.pvpTalentSkills[#self.pvpTalentSkills + 1] = talentSkills
end
function SkillProxy:_CheckPosInShortCut(skill)
  if skill ~= nil then
    local _ShortCutEnum = ShortCutProxy.ShortCutEnum
    for k, v in pairs(_ShortCutEnum) do
      if skill:GetPosInShortCutGroup(v) > 0 then
        return true
      end
    end
  end
  return false
end
function SkillProxy:AddProfessSkill(professSkill)
  self.professionSkills[#self.professionSkills + 1] = professSkill
  table.sort(self.professionSkills, function(l, r)
    return l.profession < r.profession
  end)
end
function SkillProxy:AddEquipSkill(skillItemData, isAutoMode)
  local skilltable = isAutoMode and self.equipedAutoSkills or self.equipedSkills
  local skill = skilltable[skillItemData.guid]
  if skill == nil or skill ~= skillItemData then
    EventManager.Me():PassEvent(SkillEvent.SkillEquip, skillItemData)
    skilltable[skillItemData.guid] = skillItemData
  end
  local skillArray = self:GetEquipedSkillsArray(isAutoMode)
  if skillItemData.shadow == false then
    local shortCutType
    if isAutoMode then
      shortCutType = ShortCutProxy.SkillShortCut.Auto
    else
      shortCutType = ShortCutProxy.ShortCutEnum.ID1
    end
    if TableUtil.IndexOf(skillArray, skillItemData) == 0 then
      local added = false
      for i = 1, #skillArray do
        if skillArray[i]:GetPosInShortCutGroup(shortCutType) > skillItemData:GetPosInShortCutGroup(shortCutType) then
          table.insert(skillArray, i, skillItemData)
          added = true
          break
        elseif skillArray[i]:GetPosInShortCutGroup(shortCutType) == skillItemData:GetPosInShortCutGroup(shortCutType) then
          skillArray[i] = skillItemData
          added = true
          break
        end
      end
      if not added then
        skillArray[#skillArray + 1] = skillItemData
      end
      if isAutoMode then
        self.equipedAutoArrayDirty = true
        if skillItemData.staticData.SkillType == SkillType.FakeDead then
          Game.Myself:Client_SetAutoFakeDead(skillItemData:GetID())
        end
      end
    else
      table.sort(skillArray, function(l, r)
        return l:GetPosInShortCutGroup(shortCutType) < r:GetPosInShortCutGroup(shortCutType)
      end)
      break
    end
  else
    TableUtil.Remove(skillArray, skillItemData)
  end
end
function SkillProxy:RemoveEquipSkill(skillItemData, isAutoMode)
  local skilltable = isAutoMode and self.equipedAutoSkills or self.equipedSkills
  skilltable[skillItemData.guid] = nil
  local skillArray = self:GetEquipedSkillsArray(isAutoMode)
  if TableUtil.Remove(skillArray, skillItemData) > 0 and isAutoMode then
    self.equipedAutoArrayDirty = true
  end
  if self.equipedAutoSkills[skillItemData.guid] == nil and self.equipedSkills[skillItemData.guid] == nil then
    EventManager.Me():PassEvent(SkillEvent.SkillDisEquip, skillItemData)
  end
  if isAutoMode and self.equipedAutoSkills[skillItemData.guid] == nil and skillItemData.staticData.SkillType == SkillType.FakeDead then
    Game.Myself:Client_SetAutoFakeDead(0)
  end
end
function SkillProxy:LearnedSkill(skillItemData)
  self.equipedAutoArrayDirty = true
  local skills = self.learnedSkills[skillItemData.sortID]
  if not skills then
    skills = {}
    self.learnedSkills[skillItemData.sortID] = skills
    skills[1] = skillItemData
  elseif TableUtil.IndexOf(skills, skillItemData) == 0 then
    skills[#skills + 1] = skillItemData
  end
  if skillItemData.id == GameConfig.Expression_Blink.needskill then
    FunctionPlayerHead.Me():EnableBlinkEye()
  end
  local beings = self:GetSummonBeings(skillItemData.staticData)
  if beings and #beings > 0 then
    CreatureSkillProxy.Instance:SetEnableBeings(beings, true)
  end
  CDProxy.Instance:UpdateCDData(skillItemData)
end
function SkillProxy:GetSummonBeings(staticData)
  if staticData and staticData.Logic_Param then
    local Logic_Param = staticData.Logic_Param
    if Logic_Param then
      return Logic_Param.being_ids
    end
  end
end
function SkillProxy:RemoveLearnedSkill(skillItemData)
  local skills = self.learnedSkills[skillItemData.sortID]
  if skills then
    TableUtil.Remove(skills, skillItemData)
    if #skills == 0 then
      self.learnedSkills[skillItemData.sortID] = nil
      local beings = self:GetSummonBeings(skillItemData.staticData)
      if beings and #beings > 0 then
        CreatureSkillProxy.Instance:SetEnableBeings(beings, false)
      end
    end
  end
end
function SkillProxy:GetUsedPoints()
  if self.usedPointDirty then
    self.usedPointDirty = false
    self.totalUsedPoint = 0
    for i = 1, #self.professionSkills do
      if self.professionSkills[i].points then
        self.totalUsedPoint = self.totalUsedPoint + self.professionSkills[i].points
      end
    end
  end
  return self.totalUsedPoint
end
function SkillProxy:Update(data)
  local update = data.update
  local del = data.del
  local talentUpdate = data.talent_update
  local talentDel = data.talent_del
  local myself = Game.Myself
  local proId = myself.data.userdata:Get(UDEnum.PROFESSION)
  local profess, professSkill, data, skill, talentData
  for i = 1, #del do
    profess = del[i]
    professSkill = self:FindProfessSkill(profess.profession)
    if professSkill then
      for j = 1, #profess.items do
        data = profess.items[j]
        skill = professSkill:RemoveSkill(data)
        if skill then
          self:RemoveEquipSkill(skill)
          self:RemoveEquipSkill(skill, true)
          self:RemoveLearnedSkill(skill)
        end
      end
    end
  end
  for i = 1, #update do
    profess = update[i]
    professSkill = self:FindProfessSkill(profess.profession)
    if professSkill then
      self.usedPointDirty = true
      professSkill:UpdatePoints(profess.usedpoint)
      local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
      for j = 1, #profess.items do
        data = profess.items[j]
        skill = professSkill:UpdateSkill(data)
        if data.consume then
          GameFacade.Instance:sendNotification(SkillEvent.SkillWithUseTimesChanged, skill.id)
        end
        if self:_CheckPosInShortCut(skill) then
          self:AddEquipSkill(skill)
        else
          self:RemoveEquipSkill(skill)
        end
        if skill:GetPosInShortCutGroup(shortCutAuto) > 0 then
          self:AddEquipSkill(skill, true)
        else
          self:RemoveEquipSkill(skill, true)
        end
        if skill.learned then
          self:LearnedSkill(skill)
        end
      end
      professSkill:UpdateBasePoints(profess.primarypoint)
      professSkill:SortSkills()
    else
      self:AddProfessSkill(self:CreateProfessSkill(profess))
    end
  end
  local talentSkills = self:GetPvpTalentSkillsData()
  for i = 1, #talentDel do
    talentData = talentDel[i]
    talentSkills:UpdatePoints(talentData.usedpoint)
    for j = 1, #talentData.items do
      skill = talentSkills:RemoveSkill(talentData.items[j])
      if skill then
        self:RemoveEquipSkill(skill)
        self:RemoveEquipSkill(skill, true)
        self:RemoveLearnedSkill(skill)
      end
    end
  end
  for i = 1, #talentUpdate do
    talentData = talentUpdate[i]
    if talentSkills then
      talentSkills:UpdatePoints(talentData.usedpoint)
      local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
      for j = 1, #talentData.items do
        data = talentData.items[j]
        skill = talentSkills:UpdateSkill(data)
        if data.consume then
          GameFacade.Instance:sendNotification(SkillEvent.SkillWithUseTimesChanged, skill.id)
        end
        if self:_CheckPosInShortCut(skill) then
          self:AddEquipSkill(skill)
        else
          self:RemoveEquipSkill(skill)
        end
        if skill:GetPosInShortCutGroup(shortCutAuto) > 0 then
          self:AddEquipSkill(skill, true)
        else
          self:RemoveEquipSkill(skill, true)
        end
        self:LearnedSkill(skill)
      end
    else
      self:AddLearnedPvpTalentSkill(talentData)
    end
  end
end
function SkillProxy:GetEquipedSkillsArray(isAuto)
  if isAuto then
    return self.equipedSkillsArrays[SkillProxy.AutoSkillsIndex]
  else
    return self.equipedSkillsArrays[SkillProxy.ManulSkillsIndex]
  end
end
function SkillProxy:IsEquipedSkillEmpty(shortCutID)
  local pos
  for k, v in pairs(self.equipedSkills) do
    pos = v:GetPosInShortCutGroup(shortCutID)
    if pos ~= nil and pos ~= 0 then
      return false
    end
  end
  return true
end
function SkillProxy:GetCurrentEquipedSkillData(autoFill, shortCutID)
  if shortCutID == nil then
    shortCutID = ShortCutProxy.ShortCutEnum.ID1
  end
  if autoFill then
    local equipedSkillData = {}
    if autoFill then
      for i = 1, ShortCutData.CONFIGSKILLNUM do
        local item = SkillItemData.new(0, i, nil, nil, nil, i)
        item:SetPosInShortCutGroup(shortCutID, i)
        equipedSkillData[i] = item
      end
    end
    local pos, equipedSkills
    if self.multiSaveId ~= nil then
      equipedSkills = SaveInfoProxy.Instance:GetEquipedSkills(self.multiSaveId, self.multiSaveType)
    end
    equipedSkills = equipedSkills or self.equipedSkills
    for k, v in pairs(equipedSkills) do
      if autoFill then
        pos = v:GetPosInShortCutGroup(shortCutID)
        if pos ~= nil and pos ~= 0 then
          equipedSkillData[pos] = v
        end
      elseif not v.shadow then
        table.insert(equipedSkillData, v)
      end
    end
    if not autoFill then
      do
        local ID1 = ShortCutProxy.ShortCutEnum.ID1
        table.sort(equipedSkillData, function(l, r)
          return l:GetPosInShortCutGroup(ID1) < r:GetPosInShortCutGroup(ID1)
        end)
      end
    else
    end
    return equipedSkillData
  end
  return self:GetEquipedSkillsArray(false)
end
function SkillProxy:GetEquipedAutoSkillData(autoFill)
  if autoFill then
    do
      local equipedSkillData = {}
      if autoFill then
        for i = 1, ShortCutData.CONFIGAUTOSKILLNUM do
          local item = SkillItemData.new(0, 0, i)
          equipedSkillData[i] = item
        end
      end
      local equipedAutoSkills
      if self.multiSaveId ~= nil then
        equipedAutoSkills = SaveInfoProxy.Instance:GetEquipedAutoSkills(self.multiSaveId, self.multiSaveType)
      end
      equipedAutoSkills = equipedAutoSkills or self.equipedAutoSkills
      local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
      for k, v in pairs(equipedAutoSkills) do
        if autoFill then
          equipedSkillData[v:GetPosInShortCutGroup(shortCutAuto)] = v
        elseif not v.shadow then
          table.insert(equipedSkillData, v)
        end
      end
      local sproxy = ShortCutProxy.Instance
      table.sort(equipedSkillData, function(l, r)
        if sproxy:AutoSkillIsLocked(l:GetPosInShortCutGroup(shortCutAuto)) == sproxy:AutoSkillIsLocked(r:GetPosInShortCutGroup(shortCutAuto)) then
          return l:GetPosInShortCutGroup(shortCutAuto) < r:GetPosInShortCutGroup(shortCutAuto)
        end
        return not sproxy:AutoSkillIsLocked(l:GetPosInShortCutGroup(shortCutAuto))
      end)
      return equipedSkillData
    end
  else
  end
  return self:GetEquipedSkillsArray(true)
end
function SkillProxy:GetEquipedAutoSkillNum(includeShadow)
  local num = 0
  local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
  for k, v in pairs(self.equipedAutoSkills) do
    if (not v.shadow or v.shadow and includeShadow) and not ShortCutProxy.Instance:AutoSkillIsLocked(v:GetPosInShortCutGroup(shortCutAuto)) then
      num = num + 1
    end
  end
  return num
end
function SkillProxy:HasLearnedSkill(skillID)
  local skill = self:GetLearnedSkillWithSameSort(skillID)
  return skill ~= nil and skillID <= skill.id
end
function SkillProxy:HasLearnedSkillBySort(skillSortID)
  local skill = self:GetLearnedSkillBySortID(skillSortID)
  return skill ~= nil
end
function SkillProxy:GetLearnedSkill(skillID)
  local sortID = math.floor(skillID / 1000)
  local skills = self.learnedSkills[sortID]
  if skills then
    for i = 1, #skills do
      if skills[i].id == skillID then
        return skills[i]
      end
    end
  end
  return nil
end
function SkillProxy:GetLearnedSkillWithSameSort(skillID)
  local sortID = math.floor(skillID / 1000)
  return self:GetLearnedSkillBySortID(sortID)
end
function SkillProxy:GetLearnedSkillBySortID(sortID)
  local skills = self.learnedSkills[sortID]
  return skills ~= nil and skills[1] or nil
end
function SkillProxy:ForbitUse(skillItemData)
  local staticData = skillItemData and skillItemData.staticData
  if staticData and staticData.ForbidUse ~= nil then
    if Game.MapManager:IsPVPMode_GVGDetailed() and staticData.ForbidUse & SkillItemData.ForbidUse.GVG > 0 then
      return true
    end
    if not Game.MapManager:IsPVPMode_TeamPws() and 0 < staticData.ForbidUse & SkillItemData.ForbidUse.NotInTeamPws then
      return true
    end
  end
  return false
end
function SkillProxy:SkillCanBeUsed(skillItem)
  local myselfData = Game.Myself.data
  if self:CanMagicSkillUse(skillItem) == false then
    return false
  end
  if myselfData:HasLimitSkill() then
    local skillID
    if type(skillItem) == "number" then
      skillID = skillItem
    else
      skillID = skillItem:GetID()
    end
    if myselfData:GetLimitSkillTarget(skillID) == nil then
      return false
    end
  elseif myselfData:HasLimitNotSkill() then
    local skillID
    if type(skillItem) == "number" then
      skillID = skillItem
    else
      skillID = skillItem:GetID()
    end
    if myselfData:GetLimitNotSkill(skillID) ~= nil then
      return false
    end
  end
  if self:ForbitUse(skillItem) then
    return false
  end
  return not self:IsInCD(skillItem) and self:HasEnoughSp(skillItem) and self:HasEnoughHp(skillItem) and self:IsFitPreCondition(skillItem) and self:IsSubSkillFitPreCondition(skillItem) and self:HasFitSpecialCost(skillItem) or false
end
function SkillProxy:SkillCanBeUsedByID(skillID, allowNoLearned)
  local myselfData = Game.Myself.data
  if myselfData:HasLimitSkill() then
    if myselfData:GetLimitSkillTarget(skillID) == nil then
      return false
    end
  elseif myselfData:HasLimitNotSkill() and myselfData:GetLimitNotSkill(skillID) ~= nil then
    return false
  end
  local learnedSkill = self:GetLearnedSkill(skillID)
  if learnedSkill then
    if self:CanMagicSkillUse(learnedSkill) == false then
      return false
    end
    local canBeUsed = not self:IsInCD(learnedSkill) and self:HasEnoughSp(learnedSkill) and self:HasEnoughHp(learnedSkill) and self:IsFitPreCondition(learnedSkill) and self:IsSubSkillFitPreCondition(learnedSkill) and self:HasFitSpecialCost(learnedSkill) or false
    if self:ForbitUse(skillItem) then
      return false
    end
    return canBeUsed
  else
    learnedSkill = self:FindSkill(skillID)
    if learnedSkill then
      return self:SkillCanBeUsed(learnedSkill)
    end
    return allowNoLearned or false
  end
end
function SkillProxy:IsInCD(skillItem)
  if skillItem then
    if skillItem.staticData.id == Game.Myself.data:GetAttackSkillIDAndLevel() then
      return false
    end
    return CDProxy.Instance:SkillIsInCD(skillItem.sortID)
  end
  return true
end
function SkillProxy:IsFitPreCondition(skillItem)
  return skillItem.fitPreCondion
end
function SkillProxy:IsSubSkillFitPreCondition(skillItem)
  if skillItem:HasSubSkill() then
    local subSkillList = Game.SkillOptionManager:GetMultiSkillOption(SkillOptionManager.OptionEnum.BuffSkillList, skillItem:GetID())
    if subSkillList ~= nil then
      local subSkill
      for i = 1, #subSkillList do
        subSkill = self:GetLearnedSkill(subSkillList[i])
        if subSkill ~= nil and not subSkill.fitPreCondion then
          return false
        end
      end
    end
  end
  return true
end
function SkillProxy:HasEnoughSp(skillItem, sp)
  local myself = Game.Myself
  if myself.data:IsTransformed() then
    return true
  end
  if sp == nil then
    sp = myself.data.props.Sp:GetValue()
  end
  local skillID
  if type(skillItem) == "number" then
    skillID = skillItem
  else
    skillID = skillItem:GetID()
  end
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillID)
  if skillInfo then
    local cost = self:GetSP(skillInfo, myself)
    if cost and sp < cost then
      return false
    else
      return true
    end
  end
  return false
end
function SkillProxy:HasEnoughHp(skillItem, hp)
  local myself = Game.Myself
  if hp == nil then
    hp = myself.data.props.Hp:GetValue()
  end
  return self:_HasEnoughProp(myself, skillItem, "GetHP", hp)
end
function SkillProxy:_HasEnoughProp(myself, skillItem, skillInfoFuncName, value)
  local skillID
  if type(skillItem) == "number" then
    skillID = skillItem
  else
    skillID = skillItem:GetID()
  end
  local skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillID)
  if skillInfo then
    local func = skillInfo[skillInfoFuncName]
    if func then
      local cost = func(skillInfo, myself)
      if cost and value < cost then
        return false
      else
        return true
      end
    end
  end
  return false
end
function SkillProxy:HasFitSpecialCost(skillItem)
  local myself = Game.Myself
  if myself.data:IsTransformed() then
    return true
  end
  local skillStaticData
  if type(skillItem) == "number" then
    skillStaticData = Table_Skill[skillItem]
  else
    skillStaticData = skillItem:GetStaticData()
  end
  if skillStaticData then
    local dynamicSkillInfo = myself.data:GetDynamicSkillInfo(skillStaticData.id)
    local dynamicAllSkillInfo = self:GetDynamicAllSkillInfo()
    local isNoItem = dynamicAllSkillInfo ~= nil and dynamicAllSkillInfo:GetIsNoItem()
    local skillCost = self:GetOriginSpecialCost(skillStaticData)
    if #skillCost > 0 then
      local specialCost, num
      for i = 1, #skillCost do
        specialCost = skillCost[i]
        if specialCost.itemID and not isNoItem then
          if dynamicSkillInfo ~= nil then
            num = dynamicSkillInfo:GetItemNewCost(specialCost.itemID, specialCost.num)
          else
            num = specialCost.num
          end
          if num > BagProxy.Instance:GetItemNumByStaticID(specialCost.itemID) then
            return false, Table_Item[specialCost.itemID], num, true
          end
        end
        if specialCost.buffID then
          num = specialCost.num
          if num > myself:GetBuffLayer(specialCost.buffID) then
            return false, "nil", num, false
          end
        end
      end
    elseif dynamicSkillInfo and dynamicSkillInfo.costs and not isNoItem then
      for k, cost in pairs(dynamicSkillInfo.costs) do
        if cost[1] ~= nil and 0 < cost[2] and BagProxy.Instance:GetItemNumByStaticID(cost[1]) < cost[2] then
          return false, Table_Item[cost[1]], cost[2], true
        end
      end
    end
  end
  return true
end
function SkillProxy:GetLearnedSkillLevelBySortID(sortID)
  local skills = self.learnedSkills[sortID]
  if skills and #skills > 0 then
    return skills[1].level
  end
  return 0
end
function SkillProxy:GetLearnedSkills()
  return self.learnedSkills
end
function SkillProxy:HasAttackSkill(skills)
  local hasAttackTypeSkill
  for k, skillData in pairs(skills) do
    if skillData and skillData.staticData then
      local config = Table_SkillMould[skillData.sortID * 1000 + 1]
      if config and config.Atktype and config.Atktype == 1 then
        hasAttackTypeSkill = true
        break
      end
    end
  end
  return hasAttackTypeSkill
end
function SkillProxy:GetTransformedSkills()
  if self.dynamicTransformedSkills then
    return self.dynamicTransformedSkills:GetSkills()
  end
  return self.equipedTransformSkills
end
function SkillProxy:UpdateTransformedSkills(update, del, clear)
  local data
  if update and #update > 0 then
    if self.dynamicTransformedSkills == nil then
      self.dynamicTransformedSkills = TransformedEquipSkills.new("pos")
    end
    self.dynamicTransformedSkills:RefreshServerSkills(update)
  elseif self.dynamicTransformedSkills then
    self.dynamicTransformedSkills:RefreshServerSkills({})
  end
  if clear then
    self.dynamicTransformedSkills = nil
  end
end
function SkillProxy:ResetTransformSkills(monsterID)
  if monsterID == 0 then
    if self.equipedTransformSkills then
      for i = 1, #self.equipedTransformSkills do
        self:RemoveLearnedSkill(self.equipedTransformSkills[i])
      end
    end
    self.equipedTransformSkills = nil
    self:UpdateTransformedSkills(nil, nil, true)
  else
    local monster = Table_Monster[monsterID]
    if monster then
      self.equipedTransformSkills = {}
      local skills = monster.Transform_Skill
      for i = 1, #skills do
        local skill = SkillItemData.new(skills[i], i, 0, 0, 0)
        self.equipedTransformSkills[#self.equipedTransformSkills + 1] = skill
        self:LearnedSkill(skill)
      end
    end
  end
end
function SkillProxy:GetAutoBattleSkills()
  if self.equipedTransformSkills ~= nil and #self.equipedTransformSkills > 0 then
    return self.equipedTransformSkills
  end
  return self:GetEquipedAutoSkillData()
end
local _removeDuplicates = {}
function SkillProxy:GetAutoBattleSkillsWithCombo()
  if self.equipedTransformSkills ~= nil and #self.equipedTransformSkills > 0 then
    return self.equipedTransformSkills
  end
  local array = self.equipedSkillsArrays[SkillProxy.AutoSkillsWithComboIndex]
  if self.equipedAutoArrayDirty then
    self.equipedAutoArrayDirty = false
    TableUtility.ArrayClear(array)
    TableUtility.TableClear(_removeDuplicates)
    local rawAutos = self:GetEquipedAutoSkillData()
    local skill, sortID, comboPrevious
    local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
    if GameConfig.AutoSkillGroup then
      for k, v in pairs(GameConfig.AutoSkillGroup) do
        local duplicateCount = 0
        if #v > 1 then
          for i = #v, 1, -1 do
            skill = self:GetLearnedSkillBySortID(v[i])
            if skill and 0 < skill:GetPosInShortCutGroup(shortCutAuto) then
              duplicateCount = duplicateCount + 1
              if duplicateCount > 1 then
                _removeDuplicates[skill:GetPosInShortCutGroup(shortCutAuto)] = 1
              end
            end
          end
        end
      end
    end
    for i = #rawAutos, 1, -1 do
      skill = rawAutos[i]
      if _removeDuplicates[skill:GetPosInShortCutGroup(shortCutAuto)] == nil then
        self:_RecursiveGetComboPrevious(array, skill)
      end
    end
  end
  return array
end
function SkillProxy:_RecursiveGetComboPrevious(array, skill)
  if skill ~= nil then
    comboPrevious = self.comboGetPrevious[skill.sortID]
    if skill.staticData.SkillType ~= GameConfig.SkillType.Passive.type and skill.staticData.SkillType ~= SkillType.FakeDead then
      table.insert(array, 1, skill)
    end
    if comboPrevious ~= nil then
      skill = self:GetLearnedSkillBySortID(comboPrevious)
      while skill == nil and comboPrevious ~= nil do
        comboPrevious = self.comboGetPrevious[comboPrevious]
        skill = self:GetLearnedSkillBySortID(comboPrevious)
      end
      self:_RecursiveGetComboPrevious(array, skill)
    end
  end
end
function SkillProxy:GetTransformedSkill(id)
  local skills = self:GetTransformedSkills()
  if skills ~= nil and #skills > 0 then
    for i = 1, #skills do
      if skills[i].id == id then
        return skills[i]
      end
    end
  end
end
function SkillProxy:RefreshSkills()
  if self.learnedSkills then
    for k, skills in pairs(self.learnedSkills) do
      for i = 1, #skills do
        SkillUtils.RefreshPlayerSkillData(skills[i].id)
      end
    end
  end
end
function SkillProxy:LearnedExpressionBlink()
  return self:HasLearnedSkill(GameConfig.Expression_Blink.needskill)
end
function SkillProxy:Server_UpdateDynamicSkillInfos(serverData)
  local dynamicServerData, dynamicData
  for i = 1, #serverData.specinfo do
    dynamicServerData = serverData.specinfo[i]
    dynamicData = self.dynamicSkillInfos[dynamicServerData.id]
    if dynamicData == nil then
      dynamicData = SkillDynamicInfo.new()
      self.dynamicSkillInfos[dynamicServerData.id] = dynamicData
    end
    dynamicData:SetServerInfo(dynamicServerData)
    local skill = self:GetLearnedSkillBySortID(dynamicServerData.id)
    if skill and self:_CheckPosInShortCut(skill) then
      EventManager.Me():PassEvent(SkillEvent.SkillFitPreCondtion, skill)
    end
  end
  if self.dynamicAllSkillInfo == nil then
    self.dynamicAllSkillInfo = SkillDynamicInfo.new()
  end
  self.dynamicAllSkillInfo:SetServerInfo(serverData.allskillInfo)
end
function SkillProxy:GetDynamicSkillInfoByID(skillID)
  local sortID = math.floor(skillID / 1000)
  return self.dynamicSkillInfos[sortID]
end
function SkillProxy:GetDynamicAllSkillInfo()
  return self.dynamicAllSkillInfo
end
function SkillProxy:GetSkillCanBreak()
  if MyselfProxy.Instance:HasJobBreak() then
    return self:GetUsedPoints() >= GameConfig.Peak.SkillPointToBreak
  end
  return false
end
function SkillProxy:SetMultiSave(multiSaveId, multiSaveType)
  self.multiSaveId = multiSaveId
  self.multiSaveType = multiSaveType
end
function SkillProxy:IsMultiSave()
  return self.multiSaveId ~= nil
end
function SkillProxy:GetMyProfession()
  if self.multiSaveId ~= nil then
    local profession = SaveInfoProxy.Instance:GetProfession(self.multiSaveId, self.multiSaveType)
    if profession ~= nil then
      return profession
    end
  end
  return MyselfProxy.Instance:GetMyProfession()
end
function SkillProxy:GetBeingNpcInfo(beingid)
  if beingid == nil then
    return nil
  end
  if self.multiSaveId == nil then
    return PetProxy.Instance:GetMyBeingNpcInfo(beingid)
  else
    return SaveInfoProxy.Instance:GetBeingInfo(self.multiSaveId, beingid, self.multiSaveType)
  end
end
function SkillProxy:CanMagicSkillUse(skillItem)
  if skillItem == nil then
    return false
  end
  if skillItem:IsMagicType() and Game.Myself.data:NoMagicSkill() then
    return false
  end
  return true
end
function SkillProxy:GetSubSkillParam(staticData, totalParam, getParamFunc, funcParam)
  if staticData == nil or getParamFunc == nil then
    return
  end
  if staticData.Logic_Param.sub_skill_count == nil then
    return
  end
  local subSkillList = Game.SkillOptionManager:GetMultiSkillOption(SkillOptionManager.OptionEnum.BuffSkillList, staticData.id)
  if subSkillList == nil then
    return
  end
  for i = 1, #subSkillList do
    totalParam = getParamFunc(subSkillList[i], funcParam, totalParam)
  end
  return totalParam
end
function SkillProxy:GetOriginSP(staticData)
  local sp = staticData.SkillCost.sp
  local subSkillSp = self:GetSubSkillParam(staticData, 0, GetSubSkillOriginSP)
  if subSkillSp ~= nil and subSkillSp ~= 0 then
    if sp ~= nil then
      sp = sp + subSkillSp
    else
      sp = subSkillSp
    end
  end
  return sp
end
function SkillProxy:GetSP(skillInfo, creature)
  local sp = skillInfo:GetSP(creature)
  local subSkillSp = self:GetSubSkillParam(skillInfo.staticData, 0, GetSubSkillSP, creature)
  if subSkillSp ~= nil and subSkillSp ~= 0 then
    if sp ~= nil then
      sp = sp + subSkillSp
    else
      sp = subSkillSp
    end
  end
  return sp
end
local specialCost = {}
function SkillProxy:GetOriginSpecialCost(staticData)
  if staticData.Logic_Param.sub_skill_count == nil then
    return staticData.SkillCost
  end
  for i = #specialCost, 1, -1 do
    ReusableTable.DestroyAndClearTable(specialCost[i])
    specialCost[i] = nil
  end
  GetSubSkillSpecialCost(staticData.id, nil, specialCost)
  self:GetSubSkillParam(staticData, specialCost, GetSubSkillSpecialCost)
  return specialCost
end
