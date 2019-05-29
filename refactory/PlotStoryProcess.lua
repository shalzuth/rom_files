autoImport("EventDispatcher")
autoImport("CameraAdditiveEffectManager")
PlotStoryProcess = class("PlotStoryProcess", EventDispatcher)
PlotStoryEvent = {
  End = "PlotStoryEvent_End",
  ShutDown = "PlotStoryEvent_ShutDown"
}
PlotViewShowType = {Enter = 1, Exit = 2}
local tempPos = LuaVector3()
local tempRotPos, tempRot = LuaVector3(), LuaQuaternion()
local tempArray, tempTable = {}, {}
function PlotStoryProcess:ctor(plotid, config_Prefix)
  self.config_Prefix = config_Prefix or PlotConfig_Prefix.Quest
  local config = PlotStoryProcess._getStroyConfig(plotid, self.config_Prefix)
  if not config then
    self:ErrorLog_Plot()
    return
  end
  self.running = false
  self.scene_effectid_map = {}
  self.config = config
  self.maxStep = 1
  for _, stepCfg in pairs(config) do
    self.maxStep = math.max(self.maxStep, stepCfg.id)
  end
  self.plotid = plotid
  self.nowStep = 1
  self.dialogState = 0
end
function PlotStoryProcess._getStroyConfig(plotid, config_Prefix)
  local configName = config_Prefix .. plotid
  local config = _G[configName]
  if not config then
    config = autoImport(configName)
    if type(config) ~= "table" then
      config = _G[configName]
    end
  end
  return config
end
function PlotStoryProcess:GetNowPlotAndStepId()
  return self.plotid, self.nowStep
end
function PlotStoryProcess:ErrorLog_Plot()
  LogUtility.Info(string.format("<color=red>Plot(plotid:%s stepid:%s) Error Config.</color>", tostring(self.plotid), tostring(self.nowStep)))
end
function PlotStoryProcess:Launch(startStep)
  if self.running then
    return
  end
  self.running = true
  self.startStep = startStep
  self.nowStep = startStep or 1
end
function PlotStoryProcess:ShutDown()
  if not self.running then
    return
  end
  self.running = false
  for id, _ in pairs(self.scene_effectid_map) do
    NSceneEffectProxy.Instance:Client_RemoveSceneEffect(PlotStoryProcess._createSceneId(id))
    self.scene_effectid_map[id] = nil
  end
  self:PassEvent(PlotStoryEvent.ShutDown, self)
end
function PlotStoryProcess:Update(time, deltaTime)
  if not self.running then
    return
  end
  local stepCfg = self.config[self.nowStep]
  if not stepCfg then
    self:ErrorLog_Plot()
  else
    local typeFunc = self[stepCfg.Type]
    if typeFunc then
      if not stepCfg.Params then
        self:ErrorLog_Plot()
      end
      if not typeFunc(self, stepCfg.Params, time, deltaTime) then
        return
      end
    else
      self:ErrorLog_Plot()
    end
  end
  helplog(string.format("PlotStoryProcess Update %s->%s", self.nowStep, self.nowStep + 1))
  self.nowStep = self.nowStep + 1
  if self.nowStep > self.maxStep then
    self:PlotEnd()
  end
end
function PlotStoryProcess:camera(params)
  if params.type == nil or params.type == 0 then
    local tpos, trot
    if params.pos then
      tempPos:Set(params.pos[1], params.pos[2], params.pos[3])
      tpos = tempPos
    end
    if params.rotate then
      tempRotPos:Set(params.rotate[1], params.rotate[2], params.rotate[3])
      tempRot.eulerAngles = tempRotPos
      trot = tempRot
    end
    Game.PlotStoryManager:SetCamera(tpos, trot, params.fieldview)
    Game.PlotStoryManager:SetCameraEndStay(params.endstay == 1)
  elseif params.type == 1 then
  end
  return true
end
function PlotStoryProcess:play_camera_anim(params)
  if params.name then
    time = params.time or 0
    Game.MapManager:SceneAnimationLaunch(params.name, time)
  end
  return true
end
function PlotStoryProcess:reset_camera(params)
  Game.MapManager:SceneAnimationShutdown(true)
  Game.PlotStoryManager:ActiveCameraControl(true, params.duration)
  return true
end
function PlotStoryProcess:_getTargetByParams(params)
  local tempTargets = {}
  if params.player == 1 then
    tempTargets[1] = Game.Myself
  elseif params.npcuid then
    tempTargets[1] = Game.PlotStoryManager:GetNpcRole(self.plotid, params.npcuid)
  elseif params.groupid then
    tempTargets = Game.PlotStoryManager:GetNpcRoles_ByGroupId(params.groupid)
  elseif params.mapnpcid then
    local npcs = NSceneNpcProxy.Instance:FindNpcs(params.mapnpcid)
    if npcs then
      for _, npcRole in pairs(npcs) do
        if params.mapnpcuid then
          if params.mapnpcuid == npcRole.data.uniqueid then
            table.insert(tempTargets, npcRole)
          end
        else
          table.insert(tempTargets, npcRole)
        end
      end
    end
  end
  return tempTargets
end
function PlotStoryProcess:showview(params)
  local panelid, showtype = params.panelid, params.showtype
  if panelid then
    if showtype == PlotViewShowType.Enter then
      Game.PlotStoryManager:AddUIView(panelid)
    else
      Game.PlotStoryManager:CloseUIView(panelid)
    end
  end
  return true
end
function PlotStoryProcess:addbutton(params)
  local id, eventtype = params.id, params.eventtype
  if id and eventtype then
    local func = self["button_" .. eventtype]
    if func then
      local buttonData = {}
      buttonData.id = params.id
      buttonData.clickEvent = func
      buttonData.clickEventParam = self
      buttonData.text = params.text
      buttonData.pos = params.pos
      buttonData.removeWhenClick = true
      Game.PlotStoryManager:AddButton(self.plotid, params.id, buttonData)
    end
  else
    self:ErrorLog_Plot()
  end
  return true
end
function PlotStoryProcess:button_goon(buttonData)
  if buttonData and buttonData.id then
    Game.PlotStoryManager:SetButtonState(self.plotid, buttonData.id, 2)
  end
end
function PlotStoryProcess:_dialogend()
  self.dialogState = 2
end
function PlotStoryProcess:dialog(params)
  if self.dialogState == 0 then
    self.dialogState = 1
    local viewdata = {
      viewname = "DialogView",
      dialoglist = params.dialog
    }
    viewdata.callback = self._dialogend
    viewdata.callbackData = self
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, viewdata)
  end
  if self.dialogState == 2 then
    self.dialogState = 0
    return true
  end
  return false
end
function PlotStoryProcess:summon(params)
  local npcuid = params.npcuid
  local npcid = params.npcid
  local npcindex = params.npcindex
  local npcname
  if npcid == nil and params.npcindex then
    local npcInfo = Game.PlotStoryManager:GetPlotCustomNpcInfo(self.config_Prefix, self.plotid, params.npcindex)
    if npcInfo then
      npcid = npcInfo.npcid
      npcname = npcInfo.name
    end
  end
  if npcuid == nil or npcid == nil then
    self:ErrorLog_Plot()
  end
  local npcRole = Game.PlotStoryManager:GetNpcRole(self.plotid, npcuid)
  if not npcRole then
    local pos = params.pos
    local dir = params.dir or 0
    if not pos then
      tempPos:Set(0, 0, 0)
    elseif pos.forward_player then
      local myself = Game.Myself
      if myself and myself.assetRole and myself.assetRole.completeTransform then
        local angleY = myself.assetRole.completeTransform.localEulerAngles.y
        dir = angleY + 180
        local radAngleY = math.rad(angleY)
        local x = pos.forward_player * math.sin(radAngleY)
        local z = pos.forward_player * math.cos(radAngleY)
        tempPos:Set(x, 0, z)
        tempPos:Add(myself:GetPosition())
      else
        tempPos:Set(0, 0, 0)
      end
    else
      tempPos:Set(pos[1] or 0, pos[2] or 0, pos[3] or 0)
    end
    tempPos[1] = math.floor(tempPos[1] * 1000) / 1000
    tempPos[2] = math.floor(tempPos[2] * 1000) / 1000
    tempPos[3] = math.floor(tempPos[3] * 1000) / 1000
    if npcid then
      npcRole = Game.PlotStoryManager:CreateNpcRole(self.plotid, npcuid, npcid, tempPos, params.groupid, npcname)
    end
    if npcRole ~= nil then
      npcRole:Server_SetPosXYZCmd(tempPos[1], tempPos[2], tempPos[3], nil, params.ignoreNavMesh)
      npcRole:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir, true)
      if params.waitaction then
        npcRole:Server_PlayActionCmd(params.waitaction)
      else
        npcRole:Server_PlayActionCmd("wait")
      end
    else
      redlog(tostring(npcid) .. "not Find In Table_Npc")
    end
  end
  return true
end
function PlotStoryProcess:summon_customnpc(params)
  local npcuid = params.npcuid
  local npcid = params.npcid
end
function PlotStoryProcess:remove_npc(params)
  local npcuid = params.npcuid
  if not npcuid then
    self:ErrorLog_Plot()
  else
    Game.PlotStoryManager:DestroyNpcRole(self.plotid, npcuid)
  end
  return true
end
function PlotStoryProcess:move(params)
  local pos = params.pos
  if not pos then
    self:ErrorLog_Plot()
    return true
  end
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    if target == Game.Myself then
      if params.spd ~= nil then
        Game.PlotStoryManager:SetRoleMoveSpd(Game.Myself, params.spd)
      end
      Game.Myself:Client_MoveXYZTo(pos[1] or 0, pos[2] or 0, pos[3] or 0)
    else
      if params.spd ~= nil then
        Game.PlotStoryManager:SetRoleMoveSpd(target, params.spd)
      end
      target:Server_MoveToXYZCmd(pos[1] or 0, pos[2] or 0, pos[3] or 0)
    end
  end
  return true
end
function PlotStoryProcess:set_dir(params)
  local dir = params.dir
  if not dir then
    self:ErrorLog_Plot()
    return true
  end
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    if target == Game.Myself then
      Game.Myself:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir)
    else
      target:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir)
    end
  end
  return true
end
function PlotStoryProcess:action(params)
  local actionid = params.id
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    local actionData = Table_ActionAnime[actionid]
    if actionData then
      local actionName = actionData.Name
      if target == Game.Myself then
        target:Client_PlayAction(actionName, nil, false)
      else
        target:Server_PlayActionCmd(actionName, nil, false)
      end
    end
  end
  return true
end
function PlotStoryProcess:scene_action(params)
  local actionid, npcid, uniqueid = params.id, params.npcid, params.uniqueid
  if actionid == nil or uniqueid == nil then
    redlog("No Find Npc")
    return true
  end
  local npcs = NSceneNpcProxy.Instance:FindNpcByUniqueId(uniqueid)
  if npcs == nil or npcs[1] == nil then
    redlog("No Find Npc")
    return true
  end
  local actionData = Table_ActionAnime[actionid]
  local actionName = actionData.Name
  npcs[1]:Server_PlayActionCmd(actionName, nil, false)
  return true
end
function PlotStoryProcess:emoji(params)
  local emojiid = params.id
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    local sceneUI = target:GetSceneUI()
    local emojiData = Table_Expression[emojiid]
    if sceneUI and emojiData then
      sceneUI.roleTopUI:PlayEmoji(emojiData.NameEn, nil, nil, target)
    end
  end
  return true
end
function PlotStoryProcess:play_effect(params)
  local path = params.path
  local ep = params.ep or RoleDefines_EP.Top
  local targets = self:_getTargetByParams(params)
  if #targets > 0 then
    for i = 1, #targets do
      local target = targets[i]
      target:PlayEffect(nil, path, ep, nil, false, true)
    end
  else
  end
  return true
end
function PlotStoryProcess:play_effect_ui(params)
  local path = params.path
  if path == nil then
    redlog("play_effect_ui: params error!")
    return true
  end
  helplog("play_effect_ui", path)
  FloatingPanel.Instance:PlayMidEffect(path)
  return true
end
function PlotStoryProcess._createSceneId(id)
  return string.format("Plot%s", tostring(id))
end
function PlotStoryProcess:play_effect_scene(params)
  local id = params.id
  local path = params.path
  local pos = params.pos
  tempPos:Set(pos[1] or 0, pos[2] or 0, pos[3] or 0)
  local onshot = params.onshot
  NSceneEffectProxy.Instance:Client_AddSceneEffect(PlotStoryProcess._createSceneId(id), tempPos, path, onshot)
  if not onshot then
    self.scene_effectid_map[id] = 1
  end
  return true
end
function PlotStoryProcess:remove_effect_scene(params)
  local id = params.id
  if self.scene_effectid_map[id] then
    self.scene_effectid_map[id] = nil
    NSceneEffectProxy.Instance:Client_RemoveSceneEffect(PlotStoryProcess._createSceneId(id))
  end
  return true
end
function PlotStoryProcess:play_sound(params)
  local path = params.path
  if not path then
    self:ErrorLog_Plot()
  else
    path = ResourcePathHelper.AudioSE(path)
    local targets = self:_getTargetByParams(params)
    if #targets > 0 then
      for i = 1, #targets do
        local target = targets[i]
        local ep = params.ep or RoleDefines_EP.Top
        local epTrans = target.assetRole:GetEPOrRoot(ep)
        if epTrans then
          local x, y, z = LuaGameObject.GetPosition(epTrans)
          tempPos:Set(x, y, z)
          AudioUtility.PlayOneShotAt_Path(path, tempPos)
        end
      end
    else
      AudioUtility.PlayOneShot2D_Path(path)
    end
  end
  return true
end
function PlotStoryProcess:talk(params)
  local talkid = params.talkid
  if not talkid then
    self:ErrorLog_Plot()
  else
    local msg = DialogUtil.GetDialogData(talkid) and DialogUtil.GetDialogData(talkid).Text
    local targets = self:_getTargetByParams(params)
    for i = 1, #targets do
      local target = targets[i]
      local sceneUI = target:GetSceneUI()
      if sceneUI then
        sceneUI.roleTopUI:Speak(msg, target)
      end
    end
  end
  return true
end
function PlotStoryProcess:changejob(params)
  local targets = self:_getTargetByParams(params)
  for i = 1, #targets do
    local target = targets[i]
    if target then
      if params.body then
        target.data.userdata:Set(UDEnum.BODY, params.body)
      end
      target:PlayChangeJob()
    end
  end
  return true
end
function PlotStoryProcess:change_bgm(params)
  local path = params.path
  if not path then
    self:ErrorLog_Plot()
  else
    local time = params.time or 0
    FunctionBGMCmd.Me():PlayMissionBgm(path, time)
  end
  return true
end
local _waittime = 0
function PlotStoryProcess:wait_time(params, time, deltaTime)
  if not params.time then
    self:ErrorLog_Plot()
    _waittime = 0
    return true
  end
  _waittime = _waittime + math.floor(deltaTime * 1000)
  if _waittime >= params.time then
    _waittime = 0
    return true
  end
  return false
end
function PlotStoryProcess:wait_pos(params)
  local target
  if params.player == 1 then
    target = Game.Myself
  elseif params.npcuid then
    target = Game.PlotStoryManager:GetNpcRole(self.plotid, params.npcuid)
  end
  if target then
    local pos = params.pos
    if pos then
      tempPos:Set(pos[1], pos[2], pos[3])
      local distance = params.distance or 1
      local targetPos = target:GetPosition()
      if targetPos then
        return distance >= LuaVector3.Distance(targetPos, pos)
      end
    else
      self:ErrorLog_Plot()
    end
  else
    self:ErrorLog_Plot()
  end
  return true
end
function PlotStoryProcess:wait_ui(params)
  local buttonid = params.button
  if buttonid then
    local buttonState = Game.PlotStoryManager:GetButtonState(self.plotid, buttonid)
    if buttonState == 2 then
      Game.PlotStoryManager:SetButtonState(self.plotid, buttonid, 0)
      return true
    else
      return false
    end
  end
  self:ErrorLog_Plot()
  return true
end
function PlotStoryProcess:wait_step(params)
  local stepid, plotid = params.stepid, params.plotid
  if stepid then
    local progress = self
    if plotid then
      progress = Game.PlotStoryManager:GetProgressById(plotid)
    end
    if progress then
      local _, nowstep = progress:GetNowPlotAndStepId()
      return stepid <= nowstep
    else
      self:ErrorLog_Plot()
    end
  end
  return true
end
function PlotStoryProcess:start_plot(params)
  local plotid = params.plotid
  if not plotid then
    self:ErrorLog_Plot()
  else
    Game.PlotStoryManager:Play(plotid, PlotConfig_Prefix.Anim, self.config_Prefix)
  end
  return true
end
function PlotStoryProcess:stop_plot(params)
  local plotid = params.plotid
  if not plotid then
    self:ErrorLog_Plot()
  else
    Game.PlotStoryManager:StopProgressById(plotid)
  end
  return true
end
function PlotStoryProcess:set_timescale(params)
  local timescale = params.timescale
  if type(timescale) ~= "number" then
    self:ErrorLog_Plot()
  else
    UnityEngine.Time.timeScale = timescale
  end
  return true
end
function PlotStoryProcess:exchangenpc(params)
end
function PlotStoryProcess:startfilter(params)
  FunctionSceneFilter.Me():StartFilter(params.fliter)
  return true
end
function PlotStoryProcess:endfilter(params)
  FunctionSceneFilter.Me():EndFilter(params.fliter)
  return true
end
function PlotStoryProcess:onoff_camerapoint(params)
  local groupid, active = params.groupid, params.on
  if groupid == nil then
    return true
  end
  helplog("onoff_camerapoint:", groupid, active)
  if active == true then
    CameraPointManager.Instance:EnableGroup(groupid)
  else
    CameraPointManager.Instance:DisableGroup(groupid)
  end
  return true
end
function PlotStoryProcess:shakescreen(params)
  local range = params.amplitude / 100
  local duration = params.time / 1000
  CameraAdditiveEffectManager.Me():StartShake(range, duration)
  return true
end
function PlotStoryProcess:filter(params)
  local filter = params.filter
  if filter == nil then
    return true
  end
  local on = params.on
  if on == 1 then
    FunctionSceneFilter.Me():StartFilter(filter)
  else
    FunctionSceneFilter.Me():StartFilter(filter)
  end
  return true
end
function PlotStoryProcess:SetEndCall(endCall)
  self.endCall = endCall
end
function PlotStoryProcess:PlotEnd()
  self:PassEvent(PlotStoryEvent.End, self)
  if self.endCall then
    self.endCall()
  end
  self.endCall = nil
end
