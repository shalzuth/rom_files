FunctionStage = class("FunctionStage")
local nSceneUserProxy
function FunctionStage.Me()
  if nil == FunctionStage.me then
    FunctionStage.me = FunctionStage.new()
  end
  return FunctionStage.me
end
function FunctionStage:ctor()
  self.onStagePlayers = {}
  nSceneUserProxy = NSceneUserProxy.Instance
end
function FunctionStage:AddPlayerOnStage(playerid, player, newValue)
  self.onStagePlayers[playerid] = newValue
  if player == nil then
    return
  end
  self:UpdatePlayerShowOnStage(playerid, player, newValue)
end
function FunctionStage:UpdatePlayerShowOnStage(playerid, player, newValue)
  if self:IsMyselfWattineEnterStage() then
    local inMyGroup = StageProxy.Instance:IsVisible(playerid)
    if inMyGroup then
      player:OnStageShow()
    else
      player:OnStageHide()
    end
    return
  end
  if not newValue then
    newValue = player.data.userdata:Get(UDEnum.DRESSUP)
    redlog("newValue", newValue)
  end
  local isPlayer_waittingEnter = newValue == 1
  if isPlayer_waittingEnter then
    player:OnStageHide()
  else
    player:OnStageShow()
  end
end
function FunctionStage:RemovePlayerOnStage(playerid)
  self.onStagePlayers[playerid] = nil
  local player = nSceneUserProxy:Find(playerid)
  if player == nil then
    return
  end
  player:OnStageShow()
end
function FunctionStage:UpdatePlayersShowOnStage()
  local player
  for playerid, _ in pairs(self.onStagePlayers) do
    player = nSceneUserProxy:Find(playerid)
    if player then
      self:UpdatePlayerShowOnStage(playerid, player, nil)
    else
      self.onStagePlayers[playerid] = nil
    end
  end
end
function FunctionStage:SetMyStageState(state)
  if state == self.state then
    return
  end
  if self.state == 1 then
    StageProxy.Instance:ClearStageReplaceCache()
  end
  self.state = state
  self:UpdatePlayersShowOnStage()
end
function FunctionStage:IsMyselfWattineEnterStage()
  return self.state == 1
end
