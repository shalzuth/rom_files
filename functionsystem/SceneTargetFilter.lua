SceneTargetFilter = class("SceneTargetFilter")
function SceneTargetFilter.Me()
  if nil == SceneTargetFilter.me then
    SceneTargetFilter.me = SceneTargetFilter.new()
  end
  return SceneTargetFilter.me
end
function SceneTargetFilter:ctor()
end
function SceneTargetFilter.CheckIsPlayer(creature)
  return creature:GetCreatureType() == Creature_Type.Player or creature:GetCreatureType() == Creature_Type.Me
end
function SceneTargetFilter.CheckIsNpc(creature)
  if creature:GetCreatureType() == Creature_Type.Npc then
    return creature.data:IsNpc()
  end
  return false
end
function SceneTargetFilter.CheckIsMonster(creature)
  if creature:GetCreatureType() == Creature_Type.Npc then
    return creature.data:IsMonster()
  end
  return false
end
function SceneTargetFilter.CheckIsPet(creature)
  return creature:GetCreatureType() == Creature_Type.Pet
end
function SceneTargetFilter.CheckIsPetPartner(creature)
  return creature:GetCreatureType() == Creature_Type.Pet
end
