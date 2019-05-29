PVPFactory = class("PVPFactory")
local _gameFacade
local notify = function(eventname, eventbody)
  if _gameFacade == nil then
    _gameFacade = GameFacade.Instance
  end
  _gameFacade:sendNotification(eventname, eventbody)
end
local HandleRolesBase = function(roles)
  local teamProxy = TeamProxy.Instance
  local role, teamid
  for i = 1, #roles do
    role = roles[i]
    if myself ~= role then
      teamid = role.data:GetTeamID()
      role.data:Camp_SetIsInPVP(true)
      role.data:Camp_SetIsInMyTeam(teamProxy:IsInMyTeam(role.data.id))
    end
  end
end
local HandleRolesGVG = function(roles, isGVGStart, ignoreTeam)
  local myselfTeamID = Game.Myself.data:GetTeamID()
  local myselfGuildData = Game.Myself.data:GetGuildData()
  local role, teamid, guildData
  for i = 1, #roles do
    role = roles[i]
    if myself ~= role then
      teamid = role.data:GetTeamID()
      guildData = role.data:GetGuildData()
      role.data:Camp_SetIsInGVG(isGVGStart)
      if ignoreTeam ~= true then
        role.data:Camp_SetIsInMyTeam(myselfTeamID == teamid)
      end
      if myselfGuildData ~= nil and guildData ~= nil then
        role.data:Camp_SetIsInMyGuild(myselfGuildData.id == guildData.id)
      else
        role.data:Camp_SetIsInMyGuild(false)
      end
    end
  end
end
local HandleNpcsGVG = function(roles, isGVGStart)
  local myselfGuildData = Game.Myself.data:GetGuildData()
  local role, guildData
  for k, role in pairs(roles) do
    if myself ~= role then
      guildData = role.data:GetGuildData()
      role.data:Camp_SetIsInGVG(isGVGStart)
      if myselfGuildData ~= nil and guildData ~= nil then
        role.data:Camp_SetIsInMyGuild(myselfGuildData.id == guildData.id)
      else
        role.data:Camp_SetIsInMyGuild(false)
      end
    end
  end
end
local SinglePVP = class("SinglePVP")
function SinglePVP:Launch()
  notify(PVPEvent.PVPDungeonLaunch)
  notify(PVPEvent.PVP_ChaosFightLaunch)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
end
function SinglePVP:Shutdown()
  notify(PVPEvent.PVPDungeonShutDown)
  notify(PVPEvent.PVP_ChaosFightShutDown)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
end
function SinglePVP:HandleAddRoles(roles)
  HandleRolesBase(roles)
end
function SinglePVP:Update()
end
local TwoTeamPVP = class("TwoTeamPVP")
function TwoTeamPVP:Launch()
  notify(PVPEvent.PVPDungeonLaunch)
  notify(PVPEvent.PVP_DesertWolfFightLaunch)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
end
function TwoTeamPVP:Shutdown()
  notify(PVPEvent.PVPDungeonShutDown)
  notify(PVPEvent.PVP_DesertWolfFightShutDown)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
end
function TwoTeamPVP:HandleAddRoles(roles)
  HandleRolesBase(roles)
end
function TwoTeamPVP:Update()
end
local MvpFight = class("MvpFight")
function MvpFight:ctor()
  self.isMvpFight = true
end
function MvpFight:Launch()
  self.isMvpFight = true
  notify(PVPEvent.PVP_MVPFightLaunch)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
end
function MvpFight:Shutdown()
  self.isMvpFight = false
  notify(PVPEvent.PVP_MVPFightShutDown)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
end
function MvpFight:HandleAddRoles(roles)
  HandleRolesBase(roles)
end
function MvpFight:Update()
end
local TeamsPVP = class("TeamsPVP")
function TeamsPVP:Launch()
  notify(PVPEvent.PVPDungeonLaunch)
  notify(PVPEvent.PVP_GlamMetalFightLaunch)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
end
function TeamsPVP:Shutdown()
  notify(PVPEvent.PVPDungeonShutDown)
  notify(PVPEvent.PVP_GlamMetalFightShutDown)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  if Game.Myself ~= nil then
    Game.Myself:PlayTeamCircle(0)
  end
end
function TeamsPVP:HandleAddRoles(roles)
  HandleRolesBase(roles)
end
function TeamsPVP:Update()
end
local GuildMetalGVG = class("GuildMetalGVG")
function GuildMetalGVG:ctor()
  self.noSelectTarget = true
  self.isGVG = true
  self.calmDown = true
end
function GuildMetalGVG:Launch()
  notify(GVGEvent.GVGDungeonLaunch)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
  EventManager.Me():AddEventListener(ServiceEvent.GuildCmdEnterGuildGuildCmd, self.HandleSomeGuildChange, self)
  EventManager.Me():AddEventListener(ServiceEvent.GuildCmdExitGuildGuildCmd, self.HandleSomeGuildChange, self)
end
function GuildMetalGVG:Shutdown()
  notify(GVGEvent.GVGDungeonShutDown)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.GuildCmdEnterGuildGuildCmd, self.HandleSomeGuildChange, self)
  EventManager.Me():RemoveEventListener(ServiceEvent.GuildCmdExitGuildGuildCmd, self.HandleSomeGuildChange, self)
end
function GuildMetalGVG:HandleSomeGuildChange(note)
  local roles = NSceneNpcProxy.Instance.userMap
  HandleNpcsGVG(roles, not self.calmDown)
end
function GuildMetalGVG:HandleAddRoles(roles)
  HandleRolesGVG(roles, not self.calmDown)
end
function GuildMetalGVG:HandleAddNpcs(roles)
  HandleNpcsGVG(roles, not self.calmDown)
end
function GuildMetalGVG:SetCalmDown(val)
  if self.calmDown ~= val then
    self.calmDown = val
    self:SetRolesInGVG(not val)
    self:SetNpcsInGVG(not val)
  end
end
function GuildMetalGVG:SetRolesInGVG(val)
  local roles = NSceneUserProxy.Instance:GetAll()
  for k, v in pairs(roles) do
    v.data:Camp_SetIsInGVG(val)
  end
end
function GuildMetalGVG:SetNpcsInGVG(val)
  local roles = NSceneNpcProxy.Instance:GetAll()
  for k, v in pairs(roles) do
    v.data:Camp_SetIsInGVG(val)
  end
end
function GuildMetalGVG:Update()
end
autoImport("PoringFightTipView")
local PoringFight = class("PoringFight")
function PoringFight:ctor()
  self.noSelectTarget = true
  self.isPoringFight = true
end
function PoringFight:Launch()
  notify(PVPEvent.PVPDungeonLaunch)
  notify(PVPEvent.PVP_PoringFightLaunch)
  if self.cache_MyPos == nil then
    self.cache_MyPos = LuaVector3()
    local myPos = Game.Myself:GetPosition()
    self.cache_MyPos:Set(myPos[1], myPos[2], myPos[3])
  end
  self.initfight = false
  self:HandleMatchCCmdGodEndTimeCCmd()
  Game.AutoBattleManager:AutoBattleOff()
  EventManager.Me():AddEventListener(MyselfEvent.TransformChange, self.OnTransformChangeHandler, self)
  EventManager.Me():AddEventListener(ServiceEvent.MatchCCmdPvpResultCCmd, self.PoringFightResult, self)
end
function PoringFight:PoringFightResult(data)
  local dataType = data and data.type
  if dataType == PvpProxy.Type.PoringFight then
    notify(UIEvent.CloseUI, PoringFightTipView.ViewType)
  end
end
function PoringFight:HandleMatchCCmdGodEndTimeCCmd(data)
  if self.initfight then
    return false
  end
  self.initfight = true
  self:RemoveLt()
  local endtime = PvpProxy.Instance:GetGodEndTime() or 0
  local leftSec = math.ceil(endtime - ServerTime.CurServerTime() / 1000)
  helplog("ServerTime.CurServerTime()", os.date("%Y-%m-%d-%H-%M-%S", endtime), os.date("%Y-%m-%d-%H-%M-%S", ServerTime.CurServerTime() / 1000), leftSec)
  if leftSec and leftSec > 0 then
    notify(MainViewEvent.ShowOrHide, false)
    self:DoCameraEffect()
    MsgManager.ShowMsgByIDTable(3608, {leftSec})
    self.effectlt = LeanTween.delayedCall(leftSec, function()
      notify(MainViewEvent.ShowOrHide, true)
      self:CameraReset()
      self:RemoveLt()
    end)
  end
end
function PoringFight:OnTransformChangeHandler()
  local props = Game.Myself.data.props
  local monsterId = props.TransformID:GetValue()
  helplog("OnTransformChangeHandler : ", monsterId)
  if monsterId == 20004 then
    notify(UIEvent.JumpPanel, {
      view = PanelConfig.PoringFightTipView
    })
  else
    notify(UIEvent.CloseUI, PoringFightTipView.ViewType)
  end
end
function PoringFight:GetRestrictViewPort(oriViewPort)
  local vp_x, vp_y, vp_z = oriViewPort[1], oriViewPort[2], oriViewPort[3]
  local viewWidth = UIManagerProxy.Instance:GetUIRootSize()[1]
  vp_x = 0.5 - (0.5 - vp_x) * 1280 / viewWidth
  if self.temp_ViewPort == nil then
    self.temp_ViewPort = LuaVector3()
  end
  self.temp_ViewPort:Set(vp_x, vp_y, vp_z)
  return self.temp_ViewPort
end
function PoringFight:DoCameraEffect()
  local rot_V3 = LuaVector3()
  local myTrans = Game.Myself.assetRole.completeTransform
  if myTrans then
    rot_V3:Set(CameraConfig.FoodMake_Rotation_OffsetX, CameraConfig.FoodMake_Rotation_OffsetY, 0)
    self:CameraFaceTo(myTrans, CameraConfig.FoodMake_ViewPort, nil, nil, rot_V3)
  end
  FunctionSystem.InterruptMyself()
end
function PoringFight:CameraFaceTo(transform, viewPort, rotation, duration, rotateOffset, listener)
  if nil == CameraController.singletonInstance then
    return
  end
  viewPort = viewPort or CameraConfig.UI_ViewPort
  rotation = rotation or CameraController.singletonInstance.targetRotationEuler
  duration = duration or CameraConfig.UI_Duration
  self.cft = CameraEffectFaceTo.new(transform, nil, self:GetRestrictViewPort(viewPort), rotation, duration, listener)
  if rotateOffset then
    self.cft:SetRotationOffset(rotateOffset)
  end
  FunctionCameraEffect.Me():Start(self.cft)
end
function PoringFight:CameraReset()
  if self.cft ~= nil then
    FunctionCameraEffect.Me():End(self.cft)
    self.cft = nil
  end
end
function PoringFight:RemoveLt()
  if self.effectlt then
    self.effectlt:cancel()
    self.effectlt = nil
  end
end
function PoringFight:Update()
  if self.cft and self:I_IsMove() then
    self:CameraReset()
  end
end
function PoringFight:I_IsMove()
  local role = Game.Myself
  if role then
    local nowMyPos = role:GetPosition()
    if not nowMyPos then
      return false
    end
    if VectorUtility.DistanceXZ(self.cache_MyPos, nowMyPos) > 0.01 then
      self.cache_MyPos:Set(nowMyPos[1], nowMyPos[2], nowMyPos[3])
      return true
    end
  end
  return false
end
function PoringFight:Shutdown()
  if self.cache_MyPos then
    self.cache_MyPos:Destroy()
    self.cache_MyPos = nil
  end
  notify(MainViewEvent.ShowOrHide, true)
  self:CameraReset()
  self:RemoveLt()
  notify(PVPEvent.PVPDungeonShutDown)
  notify(PVPEvent.PVP_PoringFightShutdown)
  EventManager.Me():RemoveEventListener(MyselfEvent.TransformChange, self.OnTransformChangeHandler, self)
end
function PVPFactory.GetSinglePVP()
  return SinglePVP.new()
end
function PVPFactory.GetTwoTeamPVP()
  return TwoTeamPVP.new()
end
function PVPFactory.GetTeamsPVP()
  return TeamsPVP.new()
end
function PVPFactory.GetGuildMetalGVG()
  return GuildMetalGVG.new()
end
function PVPFactory.GetPoringFight()
  return PoringFight.new()
end
function PVPFactory.GetMvpFight()
  return MvpFight.new()
end
local GvgDroiyan = class("GvgDroiyan")
function GvgDroiyan:ctor()
  self.isGvgDroiyan = true
  self.triggerDatas = {}
end
function GvgDroiyan:Launch()
  notify(GVGEvent.GVG_FinalFightLaunch)
  self:InitFightForeAreaTriggers()
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
end
function GvgDroiyan:InitFightForeAreaTriggers()
  local config = GameConfig.GvgDroiyan and GameConfig.GvgDroiyan.RobPlatform
  if config == nil then
    config = {
      [1] = {
        pos = {
          0,
          0,
          0
        }
      },
      [2] = {
        pos = {
          0,
          0,
          0
        }
      },
      [3] = {
        pos = {
          0,
          0,
          0
        }
      }
    }
  end
  for guid, v in pairs(config) do
    self:AddGvgDroiyan_FightForeArea_Trigger(guid, v.pos, v.RobPlatform_Area)
  end
end
function GvgDroiyan:AddGvgDroiyan_FightForeArea_Trigger(guid, pos, triggerArea)
  self:RemoveFightForAreaTrigger(guid)
  local triggerData = ReusableTable.CreateTable()
  triggerData.id = guid
  triggerData.type = AreaTrigger_Common_ClientType.GvgDroiyan_FightForArea
  local triggerPos = LuaVector3(pos[1], pos[2], pos[3])
  triggerData.pos = triggerPos
  triggerData.range = triggerArea or 5
  self.triggerDatas[guid] = triggerData
  SceneTriggerProxy.Instance:Add(triggerData)
end
function GvgDroiyan:RemoveFightForAreaTrigger(guid)
  local triggerData = self.triggerDatas[guid]
  if triggerData == nil then
    return
  end
  SceneTriggerProxy.Instance:Remove(guid)
  if triggerData.pos then
    triggerData.pos:Destroy()
    triggerData.pos = nil
  end
  ReusableTable.DestroyTable(triggerData)
  self.triggerDatas[guid] = nil
end
function GvgDroiyan:ClearTirggerDatas()
  for guid, data in pairs(self.triggerDatas) do
    self:RemoveFightForAreaTrigger(guid)
  end
end
function GvgDroiyan:HandleAddRoles(roles)
  HandleRolesGVG(roles, true, true)
end
function GvgDroiyan:HandleAddNpcs(roles)
  HandleNpcsGVG(roles, true)
end
function GvgDroiyan:Update()
end
function GvgDroiyan:Shutdown()
  notify(GVGEvent.GVG_FinalFightShutDown)
  self:ClearTirggerDatas()
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddNpcs, self.HandleAddNpcs, self)
end
function PVPFactory.GetGvgDroiyan()
  return GvgDroiyan.new()
end
local TeamPws = class("TeamPws")
function TeamPws:ctor()
  self.isTeamPws = true
end
function TeamPws:Launch()
  helplog("TeamPws Launch")
  notify(PVPEvent.TeamPws_Launch)
  EventManager.Me():AddEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  Game.HandUpManager:MaunalClose()
  local setting = FunctionPerformanceSetting.Me()
  local cacheSetting = setting:GetSetting()
  self.beforeSetting = {}
  TableUtility.ArrayShallowCopy(self.beforeSetting, cacheSetting)
  setting:SetScreenCount(GameConfig.Setting.ScreenCountHigh)
  setting:SetSkillEffect(true)
  setting:Apply(cacheSetting)
end
function TeamPws:HandleAddRoles(roles)
  HandleRolesBase(roles)
end
function TeamPws:Update()
end
function TeamPws:Shutdown()
  Game.HandUpManager:MaunalOpen()
  helplog("TeamPws Shutdown")
  notify(PVPEvent.TeamPws_ShutDown)
  EventManager.Me():RemoveEventListener(SceneUserEvent.SceneAddRoles, self.HandleAddRoles, self)
  FunctionPerformanceSetting.Me():Apply(self.beforeSetting)
end
function PVPFactory.GetTeamPws()
  return TeamPws.new()
end
