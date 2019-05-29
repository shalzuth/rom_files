PlayerSingView = class("PlayerSingView", SubView)
autoImport("PlayerSingViewCell")
function PlayerSingView:Init()
  self:AddViewEvents()
end
function PlayerSingView:AddViewEvents()
  EventManager.Me():AddEventListener(SkillEvent.SkillCastBegin, self.HandleStartProcess, self)
  EventManager.Me():AddEventListener(SkillEvent.SkillCastEnd, self.HandleStopProcess, self)
  EventManager.Me():AddEventListener(SkillEvent.SkillFreeCastBegin, self.HandleStartProcess, self)
  EventManager.Me():AddEventListener(SkillEvent.SkillFreeCastEnd, self.HandleStopProcess, self)
end
function PlayerSingView:OnExit()
  EventManager.Me():RemoveEventListener(SkillEvent.SkillCastBegin, self.HandleStartProcess, self)
  EventManager.Me():RemoveEventListener(SkillEvent.SkillCastEnd, self.HandleStopProcess, self)
  EventManager.Me():RemoveEventListener(SkillEvent.SkillFreeCastBegin, self.HandleStartProcess, self)
  EventManager.Me():RemoveEventListener(SkillEvent.SkillFreeCastEnd, self.HandleStopProcess, self)
end
function PlayerSingView:HandleStartProcess(note)
  local creature = note.data
  if not creature then
    return
  end
  local id = creature.data.id
  local castTime = creature.skill and creature.skill:GetCastTime(creature) or 0
  if castTime > 0 then
    local singCell = self:getSingViewCell(id)
    if not singCell then
      local creature = SceneCreatureProxy.FindCreature(id)
      if not creature or not creature:GetSceneUI() then
        local sceneUI
      end
      if sceneUI then
        singCell = sceneUI.roleTopUI:createOrGetTopSingUI()
      end
    end
    if singCell then
      singCell:SetData(creature)
    end
  end
end
function PlayerSingView:getSingViewCell(id)
  local creature = SceneCreatureProxy.FindCreature(id)
  if not creature or not creature:GetSceneUI() then
    local sceneUI
  end
  if sceneUI then
    return sceneUI.roleTopUI.topSingUI
  end
end
function PlayerSingView:HandleStopProcess(note)
  local creature = note.data
  if not creature then
    return
  end
  if creature.data then
    local id = creature.data.id
    local singCell = self:getSingViewCell(id)
    if singCell then
      singCell:delayProcess()
    end
  end
end
