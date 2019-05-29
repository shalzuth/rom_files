autoImport("LBehaviorTree")
autoImport("SceneFilterDefine")
autoImport("SceneFilterNode")
FunctionSceneFilter = class("FunctionSceneFilter")
FunctionSceneFilter.AllEffectFilter = 14789
FunctionSceneFilter.PeakEffectFilter = 14790
function FunctionSceneFilter.Me()
  if nil == FunctionSceneFilter.me then
    FunctionSceneFilter.me = FunctionSceneFilter.new()
  end
  return FunctionSceneFilter.me
end
function FunctionSceneFilter:ctor()
  self.enabled = false
  self.groupFilter = {}
  self.filterTree = LBehaviorTree.new("\229\177\143\232\148\189\229\134\179\231\173\150\230\160\145")
  self.filterTree:Run()
  local root = self.filterTree:GetRootNode(true)
  self.parallelNode = LParallelNode.new(tree)
  root:SetDirecteNode(self.parallelNode)
  self.checkFunc = {}
  self.checkFunc[SceneFilterDefine.Target.Player] = self.SceneAddRolesHandler
  self.checkFunc[SceneFilterDefine.Target.Npc] = self.SceneAddNpcsHandler
  self.checkFunc[SceneFilterDefine.Target.Pet] = self.SceneAddPetsHandler
  self.checkFunc[SceneFilterDefine.Target.Monster] = self.SceneAddNpcsHandler
end
function FunctionSceneFilter:GetGroupFilter(id)
  local conf = Table_ScreenFilter[id]
  if conf then
    return self.groupFilter[conf.Group]
  end
  return nil
end
function FunctionSceneFilter:SetEnable(value)
  if self.enabled ~= value then
    self.enabled = value
    if value then
      EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.SceneAddRolesHandler, self)
      EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.SceneAddNpcsHandler, self)
      EventManager.Me():AddEventListener(SceneUserEvent.SceneAddPets, self.SceneAddPetsHandler, self)
      EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveRoles, self.SceneRemoveCreaturesHandler, self)
      EventManager.Me():AddEventListener(SceneUserEvent.SceneRemoveNpcs, self.SceneRemoveCreaturesHandler, self)
      EventManager.Me():AddEventListener(SceneUserEvent.SceneRemovePets, self.SceneRemoveCreaturesHandler, self)
      EventManager.Me():AddEventListener(TeamEvent.MemberEnterTeam, self.AddTeamHandler, self)
      EventManager.Me():AddEventListener(TeamEvent.MemberExitTeam, self.ExitTeamHandler, self)
      EventManager.Me():AddEventListener(TeamEvent.ExitTeam, self.MeExitTeamHandler, self)
      EventManager.Me():AddEventListener(MyselfEvent.MyselfSceneUIClear, self.MeSceneUIClear, self)
      EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.MeChangedScene, self)
      EventManager.Me():AddEventListener(BoothEvent.OpenBooth, self.BoothHandler, self)
      EventManager.Me():AddEventListener(BoothEvent.CloseBooth, self.BoothHandler, self)
    else
      EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.SceneAddRolesHandler, self)
      EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs, self.SceneAddNpcsHandler, self)
      EventManager.Me():RemoveEventListener(SceneUserEvent.SceneRemoveRoles, self.SceneRemoveCreaturesHandler, self)
      EventManager.Me():RemoveEventListener(SceneUserEvent.SceneRemoveNpcs, self.SceneRemoveCreaturesHandler, self)
      EventManager.Me():RemoveEventListener(TeamEvent.MemberEnterTeam, self.AddTeamHandler, self)
      EventManager.Me():RemoveEventListener(TeamEvent.MemberExitTeam, self.ExitTeamHandler, self)
      EventManager.Me():RemoveEventListener(TeamEvent.ExitTeam, self.MeExitTeamHandler, self)
      EventManager.Me():RemoveEventListener(MyselfEvent.MyselfSceneUIClear, self.MeSceneUIClear, self)
      EventManager.Me():RemoveEventListener(LoadSceneEvent.FinishLoadScene, self.MeChangedScene, self)
      EventManager.Me():RemoveEventListener(BoothEvent.OpenBooth, self.BoothHandler, self)
      EventManager.Me():RemoveEventListener(BoothEvent.CloseBooth, self.BoothHandler, self)
    end
  end
end
function FunctionSceneFilter:SceneRemoveCreaturesHandler(ids)
  for i = 1, #ids do
    SceneFilterProxy.Instance:RemoveCreature(ids[i])
  end
end
function FunctionSceneFilter:MeChangedScene()
  self:CheckCreature(Game.Myself)
end
function FunctionSceneFilter:MeSceneUIClear()
  SceneFilterProxy.Instance:RemoveCreature(Game.Myself.data.id)
end
function FunctionSceneFilter:SceneAddRolesHandler(players)
  local myself
  if not players then
    myself = Game.Myself
  end
  players = players or NSceneUserProxy.Instance:GetAll()
  for k, v in pairs(players) do
    self:CheckCreature(v)
  end
  if myself then
    self:CheckCreature(myself)
  end
end
function FunctionSceneFilter:SceneAddNpcsHandler(npcs)
  npcs = npcs or NSceneNpcProxy.Instance:GetAll()
  for k, v in pairs(npcs) do
    self:CheckCreature(v)
  end
end
function FunctionSceneFilter:SceneAddPetsHandler(pets)
  pets = pets or NScenePetProxy.Instance:GetAll()
  for k, v in pairs(pets) do
    self:CheckCreature(v)
  end
end
function FunctionSceneFilter:MeExitTeamHandler(evt)
end
function FunctionSceneFilter:AddTeamHandler(evt)
  local player = NSceneUserProxy.Instance:FindOtherRole(evt.data.id)
  self:CheckCreature(player)
end
function FunctionSceneFilter:ExitTeamHandler(evt)
  local player = NSceneUserProxy.Instance:FindOtherRole(evt.data.id)
  self:CheckCreature(player)
end
function FunctionSceneFilter:BoothHandler(evt)
  local player = evt.data
  if player ~= nil then
    self:CheckCreature(player)
    local petIDs = player.data.petIDs
    if petIDs then
      local _NScenePetProxy = NScenePetProxy.Instance
      local pet
      for i = 1, #petIDs do
        pet = _NScenePetProxy:Find(petIDs[i])
        if pet ~= nil then
          self:CheckCreature(pet)
        end
      end
    end
  end
end
function FunctionSceneFilter:CheckCreature(creature)
  if creature then
    self.filterTree.blackBoard.creature = creature
    self.filterTree:Update()
    self.filterTree.blackBoard.creature = nil
  end
end
function FunctionSceneFilter:AddGroupFilter(groupFilter)
  if groupFilter and self.groupFilter[groupFilter.groupID] == nil then
    self.groupFilter[groupFilter.groupID] = groupFilter
  end
  if groupFilter:IsEnabled() == false then
    groupFilter:SetEnable(true)
  end
end
function FunctionSceneFilter:RemoveGroupFilter(groupFilter)
  if groupFilter and self.groupFilter[groupFilter.groupID] ~= nil then
    groupFilter:SetEnable(false)
  end
end
function FunctionSceneFilter:StartFilter(id, creatures)
  if type(id) == "table" then
    for i = 1, #id do
      self:StartFilterById(id[i], creatures)
    end
  else
    self:StartFilterById(id, creatures)
  end
end
function FunctionSceneFilter:StartFilterById(id, creatures)
  if id == FunctionSceneFilter.AllEffectFilter then
    self:FilterAllEffect(true)
    return
  end
  local groupFilter = self:GetGroupFilter(id)
  if not groupFilter and Table_ScreenFilter[id] then
    groupFilter = SceneFilterNode.new(self.filterTree, Table_ScreenFilter[id].Group)
  end
  if groupFilter then
    self:AddGroupFilter(groupFilter)
    if groupFilter:AddFilter(id) then
      for i = 1, #Table_ScreenFilter[id].Targets do
        self.checkFunc[Table_ScreenFilter[id].Targets[i]](self)
      end
    end
    self:SetEnable(true)
  else
    errorLog(string.format("Table_ScreenFilter\229\177\143\232\148\189\232\161\168\228\184\173\230\137\190\228\184\141\229\136\176id %s", id))
  end
end
function FunctionSceneFilter:EndFilter(id)
  if type(id) == "table" then
    for k, v in pairs(id) do
      self:EndFilterById(v)
    end
  else
    self:EndFilterById(id)
  end
end
function FunctionSceneFilter:EndFilterById(id)
  if id == FunctionSceneFilter.AllEffectFilter then
    self:FilterAllEffect(false)
    return
  end
  local groupFilter = self:GetGroupFilter(id)
  if groupFilter then
    groupFilter:RemoveFilter(id)
    if not groupFilter:HasFilter() then
      self:RemoveGroupFilter(groupFilter)
    end
  end
  local allEnable = false
  for k, v in pairs(self.groupFilter) do
    if v:IsEnabled() == true then
      allEnable = true
      break
    end
  end
  if allEnable == false then
    self:SetEnable(false)
  end
end
function FunctionSceneFilter:StartFilterByGroup(group)
  local groupConfig = SceneFilterProxy.Instance.groupConfig[group]
  printData(groupConfig)
  for k, v in pairs(groupConfig) do
    self:StartFilter(v.id)
  end
end
function FunctionSceneFilter:EndFilterByGroup(group)
  local groupConfig = SceneFilterProxy.Instance.groupConfig[group]
  for k, v in pairs(groupConfig) do
    self:EndFilter(v.id)
  end
end
function FunctionSceneFilter:IsFilterBy(id)
  local grp = self:GetGroupFilter(id)
  if grp then
    return grp:GetFilter(id) ~= nil
  end
  return false
end
function FunctionSceneFilter:ShutDownAll()
  self:SetEnable(false)
  for k, v in pairs(self.groupFilter) do
    v:RemoveAll()
    self:RemoveGroupFilter(v)
  end
end
local allEffectFilter = 0
function FunctionSceneFilter:FilterAllEffect(val)
  if val then
    allEffectFilter = allEffectFilter + 1
    if allEffectFilter == 1 then
      Game.EffectManager:Filter(EffectManager.FilterType.All)
    end
  else
    allEffectFilter = allEffectFilter - 1
    if allEffectFilter == 0 then
      Game.EffectManager:UnFilter(EffectManager.FilterType.All)
    end
    if allEffectFilter < 0 then
      allEffectFilter = 0
    end
  end
end
