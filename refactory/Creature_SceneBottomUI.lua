Creature_SceneBottomUI = reusableClass("Creature_SceneBottomUI")
Creature_SceneBottomUI.PoolSize = 100
function Creature_SceneBottomUI:ctor()
  Creature_SceneBottomUI.super.ctor(self)
end
local cellData = {}
local tempVector3 = LuaVector3.zero
function Creature_SceneBottomUI:DoConstruct(asArray, creature)
  self.id = creature.data.id
  self.followParents = {}
  self.isSelected = false
  self.isBeHit = false
  self.isDead = creature:IsDead()
  self:checkCreateHpSp(creature)
  self:checkCreateNameFaction(creature)
end
function Creature_SceneBottomUI:GetSceneUIBottomFollow(type, creature)
  if not type then
    return
  end
  if not self.followParents[type] then
    local container = SceneUIManager.Instance:GetSceneUIContainer(type)
    if container then
      local follow = GameObject(string.format("RoleBottomFollow_%s", creature.data:GetName()))
      follow.transform:SetParent(container.transform, false)
      follow.layer = container.layer
      tempVector3:Set(0, -0.2, 0)
      creature:Client_RegisterFollow(follow.transform, tempVector3, 0, nil, nil)
      self.followParents[type] = follow
    end
  end
  return self.followParents[type]
end
function Creature_SceneBottomUI:UnregisterSceneUITopFollows()
  for key, follow in pairs(self.followParents) do
    if not LuaGameObject.ObjectIsNull(follow) then
      Game.RoleFollowManager:UnregisterFollow(follow.transform)
      GameObject.Destroy(follow)
    end
    self.followParents[key] = nil
  end
end
function Creature_SceneBottomUI:DoDeconstruct(asArray)
  self:DestroyBottomUI()
  self:UnregisterSceneUITopFollows()
end
function Creature_SceneBottomUI:isHpSpVisible(creature)
  local id = creature.data.id
  local camp = creature.data:GetCamp()
  local neutral = RoleDefines_Camp.NEUTRAL == camp
  local creatureType = creature:GetCreatureType()
  local isMyself = creatureType == Creature_Type.Me
  local isPet = creatureType == Creature_Type.Pet
  local isSelected = self.isSelected
  local isBeHit = self.isBeHit
  local isDead = self.isDead
  local isInMyTeam = TeamProxy.Instance:IsInMyTeam(id)
  local detailedType = creature.data.detailedType
  local isMvpOrMini = detailedType == NpcData.NpcDetailedType.MINI or detailedType == NpcData.NpcDetailedType.MVP
  local sceneUI = creature:GetSceneUI()
  if not sceneUI or not sceneUI:MaskByType(MaskPlayerUIType.BloodType) then
    local maskBloodIndex
  end
  if not sceneUI or not sceneUI:MaskByType(MaskPlayerUIType.BloodNameHonorFactionEmojiType) then
    local maskBNHFEIndex
  end
  local inEdMap = false
  local mapId = Game.MapManager:GetMapID()
  if mapId then
    local raidData = Table_MapRaid[mapId]
    inEdMap = raidData and raidData.Type == 11 or false
  end
  local mask = maskBloodIndex ~= nil or maskBNHFEIndex ~= nil
  local isSkillNpc = detailedType == NpcData.NpcDetailedType.SkillNpc
  local isInVisible = mask or inEdMap or isPet and not isSkillNpc or neutral or isDead
  if isInVisible then
    return false
  elseif isMyself or TeamProxy.Instance:IsInMyTeam(id) or isSkillNpc then
    return true
  elseif camp ~= RoleDefines_Camp.ENEMY then
    if isSelected then
      return true
    end
  elseif self.isBeHit or isMvpOrMini or isSelected then
    return true
  end
  return false
end
function Creature_SceneBottomUI:checkCreateHpSp(creature)
  local isVisible = self:isHpSpVisible(creature)
  if isVisible then
    self:createHpSpCell(creature)
  end
end
function Creature_SceneBottomUI:createHpSpCell(creature)
  local parent
  if creature:GetCreatureType() == Creature_Type.Npc then
    if creature.data:IsMonster() then
      parent = self:GetSceneUIBottomFollow(SceneUIType.MonsterBottomInfo, creature)
    else
      parent = self:GetSceneUIBottomFollow(SceneUIType.NpcBottomInfo, creature)
    end
  else
    parent = self:GetSceneUIBottomFollow(SceneUIType.PlayerBottomInfo, creature)
  end
  local resId = SceneBottomHpSpCell.resId
  Game.CreatureUIManager:AsyncCreateUIAsset(self.id, resId, parent, self.createHpSpCellFinish, creature)
end
function Creature_SceneBottomUI.createHpSpCellFinish(obj, creature)
  if obj then
    TableUtility.ArrayClear(cellData)
    cellData[1] = obj
    cellData[2] = creature
    if not creature or not creature:GetSceneUI() then
      local sceneUI
    end
    if sceneUI then
      local bottomUI = sceneUI.roleBottomUI
      Game.CreatureUIManager:RemoveCreatureWaitUI(bottomUI.id, SceneBottomHpSpCell.resId)
      bottomUI.hpSpCell = SceneBottomHpSpCell.CreateAsArray(cellData)
      local isVisible = bottomUI:isHpSpVisible(creature)
      bottomUI.hpSpCell:setHpSpVisible(isVisible)
    end
  end
end
function Creature_SceneBottomUI:SetHp(ncreature)
  if self.hpSpCell then
    local hp = ncreature.data.props.Hp:GetValue()
    local maxHp = ncreature.data.props.MaxHp:GetValue()
    self.hpSpCell:SetHp(hp, maxHp)
    if hp <= 0 then
      self.isDead = true
    else
      self.isDead = false
    end
    local isHpSpVisible = self:isHpSpVisible(ncreature)
    if isHpSpVisible then
      self.hpSpCell:setHpSpVisible(true)
    end
  end
end
function Creature_SceneBottomUI:SetSp(ncreature)
  if self.hpSpCell then
    local sp = ncreature.data.props.Sp:GetValue()
    local maxSp = ncreature.data.props.MaxSp:GetValue()
    self.hpSpCell:SetSp(sp, maxSp)
  end
end
function Creature_SceneBottomUI:isNameFactionVisible(creature)
  local id = creature.data.id
  local camp = creature.data:GetCamp()
  local neutral = RoleDefines_Camp.NEUTRAL == camp
  local creatureType = creature:GetCreatureType()
  local isMyself = creatureType == Creature_Type.Me
  local isPet = creatureType == Creature_Type.Pet
  local isMyPet = isPet and creature:IsMyPet() or false
  local isSelected = self.isSelected
  local detailedType = creature.data.detailedType
  local sceneUI = creature:GetSceneUI()
  if not sceneUI or not sceneUI:MaskByType(MaskPlayerUIType.NameType) then
    local maskBloodIndex
  end
  if not sceneUI or not sceneUI:MaskByType(MaskPlayerUIType.NameHonorFactionType) then
    local maskBNHFIndex
  end
  if not sceneUI or not sceneUI:MaskByType(MaskPlayerUIType.BloodNameHonorFactionEmojiType) then
    local maskBNHFEIndex
  end
  local showName = FunctionPerformanceSetting.Me():IsShowOtherName()
  if isMyself or isMyPet then
    showName = true
  end
  local mask = not showName or maskBloodIndex ~= nil or maskBNHFIndex ~= nil or maskBNHFEIndex ~= nil
  local isPlayer = creatureType == Creature_Type.Player or creatureType == Creature_Type.Me
  local isNpc = creatureType == Creature_Type.Npc and camp ~= RoleDefines_Camp.ENEMY
  local isCatchPet = isPet and creature.data.IsPet and creature.data:IsPet()
  local isMvpOrMini = detailedType == NpcData.NpcDetailedType.MINI or detailedType == NpcData.NpcDetailedType.MVP
  local isInMyTeam = TeamProxy.Instance:IsInMyTeam(id)
  local allShowName = false
  local allInVisible = false
  local selectShow = false
  local staticData = creature.data.staticData
  if staticData then
    allShowName = staticData.ShowName == 2
    allInVisible = staticData.ShowName == 1
    selectShow = not staticData.ShowName or staticData.ShowName == 0
    selectShow = selectShow and isSelected or false
  end
  local visible = isPlayer or selectShow or isCatchPet or isMyPet or isMvpOrMini or isInMyTeam or isSelected or allShowName
  visible = visible and not allInVisible
  if mask then
    return false
  else
    return visible
  end
end
function Creature_SceneBottomUI:checkCreateNameFaction(creature)
  local isVisible = self:isNameFactionVisible(creature)
  if isVisible then
    self:createNameFaction(creature)
  end
end
function Creature_SceneBottomUI:createNameFaction(creature)
  local parent
  if creature:GetCreatureType() == Creature_Type.Npc then
    if creature.data:IsMonster() then
      parent = self:GetSceneUIBottomFollow(SceneUIType.MonsterBottomInfo, creature)
    else
      parent = self:GetSceneUIBottomFollow(SceneUIType.NpcBottomInfo, creature)
    end
  else
    parent = self:GetSceneUIBottomFollow(SceneUIType.PlayerBottomInfo, creature)
  end
  local resId = SceneBottomNameFactionCell.resId
  Game.CreatureUIManager:AsyncCreateUIAsset(self.id, resId, parent, self.createNameFactionFinish, creature, nil, SceneBottomNameFactionCell.OpitimizedMode)
end
function Creature_SceneBottomUI.createNameFactionFinish(obj, creature)
  if obj then
    TableUtility.ArrayClear(cellData)
    cellData[1] = obj
    cellData[2] = creature
    local sceneUI = creature:GetSceneUI()
    if sceneUI then
      local bottomUI = sceneUI.roleBottomUI
      Game.CreatureUIManager:RemoveCreatureWaitUI(bottomUI.id, SceneBottomNameFactionCell.resId)
      bottomUI.nameFactionCell = SceneBottomNameFactionCell.CreateAsArray(cellData)
      local isVisible = bottomUI:isNameFactionVisible(creature)
      bottomUI.nameFactionCell:setNameFactionVisible(isVisible)
      local creatureType = creature:GetCreatureType()
      local showPre = creatureType == Creature_Type.Npc
      if showPre and FunctionQuest.Me():checkShowMonsterNamePre(creature) then
        bottomUI.nameFactionCell:SetQuestPrefixName(creature, true)
      end
    end
  end
end
function Creature_SceneBottomUI:HandleSettingMask(creature)
  if self.hpSpCell then
    local isVisible = self:isHpSpVisible(creature)
    self.hpSpCell:setHpSpVisible(isVisible)
  else
    self:checkCreateHpSp(creature)
  end
  if self.nameFactionCell then
    local isVisible = self:isNameFactionVisible(creature)
    self.nameFactionCell:setNameFactionVisible(isVisible)
  else
    self:checkCreateNameFaction(creature)
  end
end
function Creature_SceneBottomUI:HandlerPlayerFactionChange(creature)
  if self.nameFactionCell then
    self.nameFactionCell:SetFaction(creature)
  else
    self:checkCreateNameFaction(creature)
  end
end
function Creature_SceneBottomUI:HandleChangeTitle(creature)
  if self.nameFactionCell then
    self.nameFactionCell:SetName(creature)
  else
    self:checkCreateNameFaction(creature)
  end
end
function Creature_SceneBottomUI:HandlerMemberDataChange(creature)
  if self.hpSpCell then
    local isVisible = self:isHpSpVisible(creature)
    self.hpSpCell:setHpSpVisible(isVisible)
  else
    self:checkCreateHpSp(creature)
  end
end
function Creature_SceneBottomUI:HandleCampChange(creature)
  if self.hpSpCell then
    local isVisible = self:isHpSpVisible(creature)
    self.hpSpCell:setHpSpVisible(isVisible)
    self.hpSpCell:setCamp(creature.data:GetCamp())
  else
    self:checkCreateHpSp(creature)
  end
  if self.nameFactionCell then
    local isVisible = self:isNameFactionVisible(creature)
    self.nameFactionCell:setNameFactionVisible(isVisible)
    self.nameFactionCell:SetName(creature)
  else
    self:checkCreateNameFaction(creature)
  end
end
function Creature_SceneBottomUI:SetIsSelected(isSelected, creature)
  self.isSelected = isSelected
  if self.hpSpCell then
    local isVisible = self:isHpSpVisible(creature)
    self.hpSpCell:setHpSpVisible(isVisible)
  else
    self:checkCreateHpSp(creature)
  end
  if self.nameFactionCell then
    local isVisible = self:isNameFactionVisible(creature)
    self.nameFactionCell:setNameFactionVisible(isVisible)
  else
    self:checkCreateNameFaction(creature)
  end
end
function Creature_SceneBottomUI:SetIsBeHit(isBeHit, creature)
  self.isBeHit = isBeHit
  if self.hpSpCell then
    local isVisible = self:isHpSpVisible(creature)
    self.hpSpCell:setHpSpVisible(isVisible)
  else
    self:checkCreateHpSp(creature)
  end
end
function Creature_SceneBottomUI:ActiveSpHpCell(active)
  if active then
    local creature = SceneCreatureProxy.FindCreature(self.id)
    if not creature then
      return
    end
    if self.hpSpCell and self:isHpSpVisible(creature) then
      self.hpSpCell:Show()
    else
      self:checkCreateHpSp(creature)
    end
  elseif self.hpSpCell then
    self.hpSpCell:Hide()
  end
end
function Creature_SceneBottomUI:ActiveNameFactionCell(active)
  if active then
    local creature = SceneCreatureProxy.FindCreature(self.id)
    if not creature then
      return
    end
    if self.nameFactionCell and self:isNameFactionVisible(creature) then
      self.nameFactionCell:Show()
    else
      self:checkCreateNameFaction(creature)
    end
  elseif self.nameFactionCell then
    self.nameFactionCell:Hide()
  end
end
function Creature_SceneBottomUI:ActiveSceneUI(maskPlayerUIType, active)
  if maskPlayerUIType == MaskPlayerUIType.BloodType then
    self:ActiveSpHpCell(active)
  elseif maskPlayerUIType == MaskPlayerUIType.BloodNameHonorFactionEmojiType then
    self:ActiveSpHpCell(active)
    self:ActiveNameFactionCell(active)
  elseif maskPlayerUIType == MaskPlayerUIType.NameType then
    self:ActiveNameFactionCell(active)
  elseif maskPlayerUIType == MaskPlayerUIType.NameHonorFactionType then
    self:ActiveNameFactionCell(active)
  end
end
function Creature_SceneBottomUI:DestroyBottomUI()
  if self.nameFactionCell then
    ReusableObject.Destroy(self.nameFactionCell)
  end
  if self.hpSpCell then
    ReusableObject.Destroy(self.hpSpCell)
  end
  Game.CreatureUIManager:RemoveCreatureWaitUI(self.id, SceneBottomHpSpCell.resId)
  Game.CreatureUIManager:RemoveCreatureWaitUI(self.id, SceneBottomNameFactionCell.resId)
  self.hpSpCell = nil
  self.nameFactionCell = nil
end
function Creature_SceneBottomUI:SetQuestPrefixVisible(creature, isShow)
  if self.nameFactionCell then
    self.nameFactionCell:SetQuestPrefixName(creature, isShow)
  end
end
