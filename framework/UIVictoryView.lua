UIVictoryView = class("UIVictoryView", ContainerView)
UIVictoryView.ViewType = UIViewType.NormalLayer
local effectResID
local ActionState = {
  None = 0,
  Lose = 1,
  Victory_1 = 2,
  Victory_2 = 3,
  Victory_3 = 4
}
local NextState = {}
NextState[ActionState.Victory_1] = ActionState.Victory_2
NextState[ActionState.Victory_2] = ActionState.Victory_3
NextState[ActionState.Victory_3] = ActionState.Victory_2
function UIVictoryView:Init()
  self:InitCalls()
  self:FindObjs()
  self:ShowModel()
  self:AddEvtListener()
  local result = self.viewdata.viewdata.result
  if result == 1 then
    effectResID = EffectMap.UI.PVP_Win
  elseif result == 2 then
    effectResID = EffectMap.UI.PVP_Lose
  else
    helplog("UIVictoryView error result : ", result)
    return
  end
  self:OpenEffect()
end
function UIVictoryView:InitCalls()
  self.calls = {}
  self.calls[ActionState.Lose] = self._LoseHandle
  self.calls[ActionState.Victory_1] = self._Victory_1Handle
  self.calls[ActionState.Victory_2] = self._Victory_2Handle
  self.calls[ActionState.Victory_3] = self._Victory_3Handle
end
function UIVictoryView:FindObjs()
  self.uiTexture = self:FindComponent("victoryTexture", UITexture)
  self.effectPos = self:FindGO("effectRoot")
end
function UIVictoryView:AddEvtListener()
  EventManager.Me():AddEventListener(ServiceEvent.PlayerMapChange, self._sceneLoadHandler, self)
end
function UIVictoryView:_sceneLoadHandler()
  TimeTickManager.Me():ClearTick(self)
  self.super.CloseSelf(self)
end
function UIVictoryView:OpenEffect()
  if nil == self.Effect then
    self:PlayUIEffect(effectResID, self.effectPos, false, nil, self)
  end
end
function UIVictoryView:OnExit()
  UIVictoryView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
end
function UIVictoryView:CloseSelf()
  self.super.CloseSelf(self)
end
local args = {}
local scale = 1
local pos, rotation
local tempV3, tempRot = LuaVector3(), LuaQuaternion()
local result
function UIVictoryView:RefreshTexture(teamData)
  self.memberStates = {}
  result = self.viewdata.viewdata.result
  for i = 1, #teamData do
    local parts = Asset_Role.CreatePartArray()
    local partIndex = Asset_Role.PartIndex
    local partIndexEx = Asset_Role.PartIndexEx
    if teamData[i].id == Game.Myself.data.id then
      local userdata = Game.Myself.data.userdata
      parts[partIndex.Body] = userdata:Get(UDEnum.BODY) or 0
      parts[partIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0
      parts[partIndex.LeftWeapon] = 0
      parts[partIndex.RightWeapon] = 0
      parts[partIndex.Head] = userdata:Get(UDEnum.HEAD) or 0
      parts[partIndex.Wing] = userdata:Get(UDEnum.BACK) or 0
      parts[partIndex.Face] = userdata:Get(UDEnum.FACE) or 0
      parts[partIndex.Tail] = userdata:Get(UDEnum.TAIL) or 0
      parts[partIndex.Eye] = userdata:Get(UDEnum.EYE) or 0
      parts[partIndex.Mount] = 0
      parts[partIndex.Mouth] = userdata:Get(UDEnum.MOUTH) or 0
      parts[partIndexEx.Gender] = userdata:Get(UDEnum.SEX) or 0
      parts[partIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0
      parts[partIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0
      parts[partIndexEx.BodyColorIndex] = userdata:Get(UDEnum.CLOTHCOLOR) or 0
    else
      parts[partIndex.Body] = teamData[i].body or 0
      parts[partIndex.Hair] = teamData[i].hair or 0
      parts[partIndex.LeftWeapon] = 0
      parts[partIndex.RightWeapon] = 0
      parts[partIndex.Head] = teamData[i].head or 0
      parts[partIndex.Wing] = teamData[i].wing or 0
      parts[partIndex.Face] = teamData[i].face or 0
      parts[partIndex.Tail] = teamData[i].tail or 0
      parts[partIndex.Eye] = teamData[i].eye or 0
      parts[partIndex.Mount] = 0
      parts[partIndex.Mouth] = teamData[i].mouth or 0
      parts[partIndexEx.Gender] = teamData[i].gender or 0
      parts[partIndexEx.HairColorIndex] = teamData[i].haircolor or 0
      parts[partIndexEx.BodyColorIndex] = teamData[i].bodycolor or 0
    end
    local config = self.config[i]
    tempV3:Set(config.position[1], config.position[2], config.position[3])
    pos = tempV3
    tempV3 = LuaVector3()
    tempV3:Set(config.rotation[1], config.rotation[2], config.rotation[3])
    tempRot.eulerAngles = tempV3
    rotation = tempRot
    args[1] = parts
    args[2] = self.uiTexture
    args[3] = pos
    args[4] = rotation
    args[5] = scale
    args[6] = nil
    args[7] = nil
    args[8] = nil
    args[9] = nil
    args[10] = false
    local model = UIMultiModelUtil.Instance:SetModels(i, args)
    if 1 == result then
      self:UpdateState(i, ActionState.Victory_1)
      self:_StartTimeTick()
    elseif 2 == result then
      self:UpdateState(i, ActionState.Lose)
    end
  end
end
function UIVictoryView:ShowModel()
  local myTeam = TeamProxy.Instance.myTeam
  if myTeam then
    local memberlist = myTeam:GetMembersList()
    local memberData = {}
    for i = 1, #memberlist do
      if not memberlist[i]:IsHireMember() then
        table.insert(memberData, memberlist[i])
      end
    end
    if #memberData == 3 or #memberData == 5 then
      self.config = GameConfig.MultiModelTrans.part
    else
      self.config = GameConfig.MultiModelTrans.total
    end
    if memberData and #memberData > 0 then
      self:RefreshTexture(memberData)
    end
  end
end
function UIVictoryView:UpdateState(index, actionState)
  local call = self.calls[actionState]
  if call then
    call(self, index, actionState)
  end
end
function UIVictoryView:_SetMemberState(index, state, duration)
  local memberstate = self.memberStates[index]
  if memberstate == nil then
    memberstate = {}
    self.memberStates[index] = memberstate
  end
  memberstate[1] = state
  memberstate[2] = duration
end
function UIVictoryView:_LoseHandle(index, actionState)
  local config = self.config[index]
  if config.failedAction then
    UIMultiModelUtil.Instance:PlayAction(index, config.failedAction, false)
  else
    helplog("GameConfig.MultiModelTrans \230\156\170\233\133\141\229\173\151\230\174\181 failedAction")
  end
end
function UIVictoryView:_Victory_1Handle(index, actionState)
  local config = self.config[index]
  if config.action then
    self:_SetMemberState(index, actionState, config.action[2])
    UIMultiModelUtil.Instance:PlayAction(index, config.action[1], false)
  else
    helplog("GameConfig.MultiModelTrans \230\156\170\233\133\141\229\173\151\230\174\181 action")
  end
end
function UIVictoryView:_Victory_2Handle(index, actionState)
  self:_SetMemberState(index, actionState, 3)
  UIMultiModelUtil.Instance:PlayAction(index, Asset_Role.ActionName.Idle, false)
end
function UIVictoryView:_Victory_3Handle(index, actionState)
  local config = self.config[index]
  if config.actions then
    local r = math.random(#config.actions)
    local actionConfig = config.actions[r]
    if actionConfig then
      self:_SetMemberState(index, actionState, actionConfig[2])
      UIMultiModelUtil.Instance:PlayAction(index, actionConfig[1], false)
    end
  else
    helplog("GameConfig.MultiModelTrans \230\156\170\233\133\141\229\173\151\230\174\181 actions")
  end
end
function UIVictoryView:_Tick(deltaTime)
  local state
  for i = 1, #self.memberStates do
    state = self.memberStates[i]
    if state then
      state[2] = state[2] - deltaTime
      if state[2] <= 0 then
        state[2] = 0
        local nextState = NextState[state[1]]
        if nextState then
          self:UpdateState(i, nextState)
        end
      end
    end
  end
end
function UIVictoryView:_StartTimeTick()
  TimeTickManager.Me():CreateTick(0, 50, self._Tick, self, 1, true)
end
