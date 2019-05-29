autoImport("SkillProfessData")
SkillItemData = class("SkillItemData")
SkillItemData.ForbidUse = {GVG = 1, NotInTeamPws = 8}
SkillItemData.FuncType = {
  Normal = 1,
  Rune = 2,
  Option = 3
}
function SkillItemData:ctor(id, pos, autopos, profession, sourceId, extendpos, shortcuts)
  self.shortcuts = {}
  self:Reset(id, pos, autopos, 0, sourceId, extendpos, shortcuts)
  self.profession = profession
  self.isUnlock = false
  self.classId = 0
  self.leftTimes = 0
  self.maxTimes = 0
  self.cdTime = 0
  self.timeRecoveryStamp = 0
  self.active = false
  self.learned = false
  self.shadow = false
  self.fitPreCondion = true
  self.runeSpecialID = 0
  self.replaceID = 0
  self.enableSpecialEffect = true
  self.extraLevelSkillID = 0
  self.isShare = false
end
function SkillItemData:Reset(id, pos, autopos, cd, sourceId, extendpos, shortcuts)
  if pos ~= nil then
    self.shortcuts[ShortCutProxy.ShortCutEnum.ID1] = pos
    self.pos = pos
  end
  if autopos ~= nil then
    self.shortcuts[ShortCutProxy.SkillShortCut.Auto] = autopos
  end
  sourceId = sourceId or 0
  self.sourceId = sourceId
  if self.id ~= id then
    self.requiredSkillID = nil
    self.nextSkillData = nil
    self.id = id
    self.sortID = math.floor(self.id / 1000)
    self.staticData = Table_Skill[id]
    if self.staticData ~= nil then
      self.level = self.staticData.Level
      if self.staticData.NextID ~= nil then
        self.nextSkillData = Table_Skill[self.staticData.NextID]
      end
      local config = Table_Skill[self.sortID * 1000 + 1]
      if config and config.Contidion and config.Contidion.skillid then
        self.requiredSkillID = config.Contidion.skillid
      end
    else
      self.level = 0
    end
    self.guid = self.id .. "_" .. self.sourceId
  end
  local maxLevelStaticData
  if self.staticData ~= nil and self.staticData.NextID ~= nil then
    self.maxLevel, maxLevelStaticData = self:_GetMaxlevel("NextID")
  else
    self.maxLevel = self.level
    maxLevelStaticData = self.staticData
  end
  if maxLevelStaticData ~= nil and maxLevelStaticData.NextBreakID then
    self.breakMaxLevel, maxLevelStaticData = self:_GetMaxlevel("NextBreakID", maxLevelStaticData)
  else
    self.breakMaxLevel = 0
  end
  if maxLevelStaticData ~= nil and maxLevelStaticData.NextNewID then
    self.breakNewMaxLevel = self:_GetMaxlevel("NextNewID", maxLevelStaticData)
  else
    self.breakNewMaxLevel = 0
  end
  if shortcuts ~= nil then
    TableUtility.TableClear(self.shortcuts)
    for i = 1, #shortcuts do
      local shortcut = shortcuts[i]
      self.shortcuts[shortcut.type] = shortcut.pos
    end
  end
end
function SkillItemData:_GetMaxlevel(paramName, staticData)
  staticData = staticData or self.staticData
  if staticData and staticData[paramName] then
    local tempData = staticData
    local num = 0
    local tempDataID, nextID
    while tempData[paramName] ~= nil and num < 99 do
      tempDataID = tempData.id
      nextID = tempData[paramName]
      tempData = Table_Skill[nextID]
      if num >= 98 then
        error("\230\163\128\230\159\165\230\138\128\232\131\189\232\161\168\239\188\140NextID\233\133\141\231\189\174\233\148\153\232\175\175\239\188\140\229\175\188\232\135\180\230\173\187\229\190\170\231\142\175- -#.." .. staticData.id)
      end
      if tempData == nil then
        LogUtility.ErrorFormat("\229\176\157\232\175\149\230\159\165\230\137\190 {0} \231\154\132\228\184\139\228\184\128\228\184\170\230\138\128\232\131\189 {1},\233\133\141\231\189\174\232\161\168\228\184\173\228\184\141\229\173\152\229\156\168", tempDataID, nextID)
        break
      end
      num = num + 1
    end
    return tempData.Level, tempData
  end
end
function SkillItemData:Clone()
  local cloned = SkillItemData.new(self.id, self.pos, self.autopos, self.profession, self.sourceId)
  cloned.learned = self.learned
  for k, v in pairs(self.shortcuts) do
    cloned.shortcuts[k] = v
  end
  return cloned
end
function SkillItemData:GetBreakLevel()
  if self.staticData then
    return self.staticData.PeakLevel or 0
  end
  return 0
end
function SkillItemData:ResetUseTimes(left, max, stamp)
  self.leftTimes = left
  self.maxTimes = max
  self.timeRecoveryStamp = stamp * 1000
end
function SkillItemData:SetFitPreCond(fitPreCondion)
  self.fitPreCondion = fitPreCondion
end
function SkillItemData:GetFitPreCond()
  return self.fitPreCondion
end
function SkillItemData:setId(id)
  self.id = id
end
function SkillItemData:GetID()
  local replaceID = self:GetReplaceID()
  if replaceID ~= nil and replaceID ~= 0 then
    return replaceID
  end
  if self:GetExtraStaticData() ~= nil then
    return self:GetExtraStaticData().id
  end
  return self.id
end
function SkillItemData:GetStaticData()
  local replaceID = self:GetReplaceID()
  if replaceID ~= nil and replaceID ~= 0 then
    return Table_Skill[replaceID]
  end
  if self:GetExtraStaticData() ~= nil then
    return self:GetExtraStaticData()
  end
  return self.staticData
end
function SkillItemData:SetShadow(val)
  self.shadow = val
end
function SkillItemData:SetActive(active)
  self.active = active
end
function SkillItemData:SetLearned(learned)
  self.learned = learned
end
function SkillItemData:SetSpecialID(runeSpecialID)
  self.runeSpecialID = runeSpecialID
end
function SkillItemData:GetSpecialID()
  return self.runeSpecialID
end
function SkillItemData:SetEnableSpecialEffect(v)
  self.enableSpecialEffect = v
end
function SkillItemData:GetEnableSpecialEffect()
  return self.enableSpecialEffect
end
function SkillItemData:SetReplaceID(replaceID)
  self.replaceID = replaceID
end
function SkillItemData:GetReplaceID()
  return self.replaceID
end
function SkillItemData:SetSource(source)
  self.source = source
end
function SkillItemData:setIsUnlock(isUnlock)
  self.isUnlock = isUnlock
end
function SkillItemData:getIsUnlock()
  return self.isUnlock
end
function SkillItemData:setLevel(level)
  self.level = level or 0
end
function SkillItemData:getLevel()
  return self.level
end
function SkillItemData:GetLevelWithExtra()
  return self.level + self:GetExtraLevel()
end
function SkillItemData:GetMaxLevelWithExtra()
  return self.maxLevel + self:GetExtraLevel()
end
function SkillItemData:setClassId(id)
  self.classId = id or 0
end
function SkillItemData:getClassId()
  return self.classId
end
function SkillItemData:getCdTime()
  return self.cdTime
end
function SkillItemData:GetCDMax()
  return self.cdMax
end
function SkillItemData:IsMagicType()
  return self.staticData.RollType == 2
end
function SkillItemData:IsAutoShortCutLocked()
  local _ShortCutProxy = ShortCutProxy
  return _ShortCutProxy.Instance:AutoSkillIsLocked(self:GetPosInShortCutGroup(_ShortCutProxy.SkillShortCut.Auto))
end
function SkillItemData:SetPosInShortCutGroup(grpID, pos)
  if grpID ~= nil and pos ~= nil then
    self.shortcuts[grpID] = pos
  end
end
function SkillItemData:GetPosInShortCutGroup(grpID)
  if grpID == ShortCutProxy.SkillShortCut.BeingAuto then
    return self.pos
  else
    return self.shortcuts[grpID] or 0
  end
end
function SkillItemData:HasRuneSpecials()
  local specials = AstrolabeProxy.Instance:GetSkill_SpecialEffect(self.sortID)
  return specials ~= nil
end
function SkillItemData:HasRuneSelectSpecials()
  local specials = AstrolabeProxy.Instance:GetSkill_SpecialEffect(self.sortID)
  if specials then
    for k, v in pairs(specials) do
      config = Table_RuneSpecial[k]
      if config and config.Type == 2 then
        return true
      end
    end
  end
  return false
end
function SkillItemData:GetRuneSelectSpecials()
  local specials = AstrolabeProxy.Instance:GetSkill_SpecialEffect(self.sortID)
  local res
  if specials then
    for k, v in pairs(specials) do
      config = Table_RuneSpecial[k]
      if config and config.Type == 2 then
        if res == nil then
          res = {}
        end
        res[#res + 1] = config
      end
    end
  end
  return res
end
function SkillItemData:SetExtraLevel(lv)
  if lv then
    if self.staticData == nil then
      return
    end
    self.extraLevelSkillID = self.staticData.id + lv
    self.extraLevelSkillStaticData = Table_Skill[self.extraLevelSkillID]
  else
    self.extraLevelSkillID = 0
    self.extraLevelSkillStaticData = nil
  end
end
function SkillItemData:GetExtraLevel()
  return self.extraLevelSkillStaticData and self.extraLevelSkillStaticData.Level - self.level or 0
end
function SkillItemData:GetExtraStaticData()
  return self.extraLevelSkillStaticData
end
function SkillItemData:SuperUse_NoSkill()
  local staticData = self:GetStaticData()
  if staticData and staticData.SuperUse then
    return staticData.SuperUse & SkillSuperUse.NoSkill > 0
  end
  return false
end
function SkillItemData:GetSuperUse()
  local staticData = self:GetStaticData()
  if staticData and staticData.SuperUse then
    return staticData.SuperUse
  end
  return nil
end
function SkillItemData:HasNextID(breakTop, staticData, newBreakTop)
  return self:GetNextID(breakTop, nil, newBreakTop) ~= nil
end
function SkillItemData:GetNextID(breakTop, staticData, newBreakTop)
  staticData = staticData or self.staticData
  local nextID = staticData.NextID
  if breakTop and staticData.NextBreakID then
    nextID = staticData.NextBreakID
  end
  if newBreakTop and staticData.NextNewID then
    nextID = staticData.NextNewID
  end
  return nextID
end
function SkillItemData:SetOwnerId(ownerid)
  local staticData = self:GetStaticData()
  if staticData and staticData.Share == 1 then
    self.isShare = ownerid ~= Game.Myself.data.id
  end
end
function SkillItemData:GetIsShare()
  return self.isShare
end
function SkillItemData:CheckFuncOpen(funcType)
  if funcType == nil then
    return false
  end
  if funcType == self.FuncType.Normal then
    return self.id == Game.Myself.data:GetAttackSkillIDAndLevel() or GameConfig.SkillAutoQueueID and self.id == GameConfig.SkillAutoQueueID[1]
  elseif funcType == self.FuncType.Rune then
    return self:GetRuneSelectSpecials() ~= nil
  elseif funcType == self.FuncType.Option then
    local logicParam = self.staticData.Logic_Param
    if logicParam then
      if self:_CheckOptionOpen(logicParam.being_ids) then
        return true
      end
      if self:_CheckOptionOpen(logicParam.skill_opt_ids) then
        return true
      end
      if self:_CheckOptionOpen(logicParam.element_ids) then
        return true
      end
    end
    return false
  end
end
function SkillItemData:_CheckOptionOpen(param)
  if param ~= nil and #param > 0 then
    return SkillProxy.Instance:HasLearnedSkill(self.id)
  end
end
function SkillItemData:HasSubSkill()
  return self.staticData.Logic_Param.sub_skill_count ~= nil
end
function SkillItemData:GetSubSkillCount()
  return self.staticData.Logic_Param.sub_skill_count
end
