using("RO.RoleAvatar")
autoImport("Appellation")
autoImport("Occupation")
local MyselfProxy = class("MyselfProxy", pm.Proxy)
MyselfProxy.Instance = nil
MyselfProxy.NAME = "MyselfProxy"
function MyselfProxy:ctor(proxyName, data)
  self.proxyName = proxyName or MyselfProxy.NAME
  if MyselfProxy.Instance == nil then
    MyselfProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.selectAutoNormalAtk = true
end
function MyselfProxy:onRegister()
  self.myself = nil
  self.vars = nil
  self.buffers = nil
  self.buffAttr = nil
  self.buffersProps = RolePropsContainer.CreateAsTable()
  self.extraProps = RolePropsContainer.CreateAsTable()
  self:ClearProps()
  self.buffAttr = {}
  self.traceItems = {}
  self.equipPosStateTimeMap = {}
  self.unlockActionIds = {}
  self.unlockEmojiIds = {}
  self:InitPropsTab()
  self.debtDatas = {}
  self.accvars = nil
end
function MyselfProxy:ClearProps()
  if self.buffersProps then
    for _, o in pairs(self.buffersProps.configs) do
      self.buffersProps:SetValueById(o.id, 0)
    end
  end
  if self.extraProps then
    for _, o in pairs(self.extraProps.configs) do
      self.extraProps:SetValueById(o.id, 0)
    end
  end
end
function MyselfProxy:CurMaxJobLevel()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.CUR_MAXJOB) or 0
end
function MyselfProxy:onRemove()
  self.buffersProps:Destroy()
  self.buffersProps = nil
  self.extraProps:Destroy()
  self.extraProps = nil
end
function MyselfProxy:SetUserRolesInfo(snapShotUserInfo)
  if self.snapShotUserInfo == nil then
    self.snapShotUserInfo = {}
  else
    TableUtility.TableClear(self.snapShotUserInfo)
  end
  local client_datas = {}
  local server_datas = snapShotUserInfo.data
  for i = 1, #server_datas do
    local server_data = server_datas[i]
    local snapShotDataPB = {}
    snapShotDataPB.id = server_data.id
    snapShotDataPB.baselv = server_data.baselv
    snapShotDataPB.hair = server_data.hair
    snapShotDataPB.haircolor = server_data.haircolor
    snapShotDataPB.lefthand = server_data.lefthand
    snapShotDataPB.righthand = server_data.righthand
    snapShotDataPB.body = server_data.body
    snapShotDataPB.head = server_data.head
    snapShotDataPB.back = server_data.back
    snapShotDataPB.face = server_data.face
    snapShotDataPB.tail = server_data.tail
    snapShotDataPB.mount = server_data.mount
    snapShotDataPB.eye = server_data.eye
    snapShotDataPB.partnerid = server_data.partnerid
    snapShotDataPB.portrait = server_data.portrait
    snapShotDataPB.mouth = server_data.mouth
    snapShotDataPB.clothcolor = server_data.clothcolor
    snapShotDataPB.name = server_data.name
    snapShotDataPB.sequence = server_data.sequence
    snapShotDataPB.isopen = server_data.isopen
    snapShotDataPB.deletetime = server_data.deletetime
    snapShotDataPB.gender = server_data.gender
    snapShotDataPB.profession = server_data.profession
    table.insert(client_datas, snapShotDataPB)
  end
  self.snapShotUserInfo.data = client_datas
  self.snapShotUserInfo.lastselect = snapShotUserInfo.lastselect
  self.snapShotUserInfo.deletechar = snapShotUserInfo.deletechar
  self.snapShotUserInfo.deletecdtime = snapShotUserInfo.deletecdtime
  self.snapShotUserInfo.maincharid = snapShotUserInfo.maincharid
end
function MyselfProxy:GetUserRolesInfo()
  return self.snapShotUserInfo
end
function MyselfProxy:GetROB()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.SILVER) or 0
end
function MyselfProxy:GetGold()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.GOLD) or 0
end
function MyselfProxy:GetDiamond()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.DIAMOND) or 0
end
function MyselfProxy:GetGarden()
  return BagProxy.Instance:GetItemNumByStaticID(GameConfig.MoneyId.Happy)
end
function MyselfProxy:GetLaboratory()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.LABORATORY) or 0
end
function MyselfProxy:RoleLevel()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) or 0
end
function MyselfProxy:JobLevel()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.JOBLEVEL) or 0
end
function MyselfProxy:GetMyProfession()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.PROFESSION) or 0
end
function MyselfProxy:GetMyProfessionType()
  local profession = self:GetMyProfession()
  profession = Table_Class[profession]
  return profession and profession.Type or 0
end
function MyselfProxy:GetMyMapID()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.MAPID) or 0
end
function MyselfProxy:GetMySex()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.SEX) or 1
end
function MyselfProxy:GetZoneId()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.ZONEID) or 0
end
function MyselfProxy:GetZoneString()
  return ChangeZoneProxy.Instance:ZoneNumToString(self:GetZoneId())
end
function MyselfProxy:GetQuota()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUOTA) or 0
end
function MyselfProxy:GetQuotaLock()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.QUOTA_LOCK) or 0
end
function MyselfProxy:GetHasCharge()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.HASCHARGE) or 0
end
function MyselfProxy:GetFashionHide()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.FASHIONHIDE) or 0
end
function MyselfProxy:GetPvpCoin()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.PVPCOIN) or 0
end
function MyselfProxy:GetLottery()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.LOTTERY) or 0
end
function MyselfProxy:GetGuildHonor()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.GUILDHONOR) or 0
end
function MyselfProxy:GetServantFavorability()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.FAVORABILITY) or 0
end
function MyselfProxy:GetBoothScore()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.BOOTH_SCORE) or 0
end
function MyselfProxy:GetExpRaidScore()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.EXPRAID_SCORE) or 0
end
function MyselfProxy:GetExpRaidScoreInRaid()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.EXPRAID_SCORE_RAID) or 0
end
function MyselfProxy:GetFreeLottery()
  return Game.Myself and Game.Myself.data.userdata:Get(UDEnum.FREELOTTERY) or 0
end
function MyselfProxy:ResetMyBornPos(x, y, z)
  LogUtility.Info("bornPos.." .. x .. " " .. y .. " " .. z)
  if Game.Myself then
    Game.Myself:Server_SetPosXYZCmd(x, y, z, 1000)
  end
end
function MyselfProxy:ResetMyPos(x, y, z, isgomap)
  if isgomap == nil then
    isgomap = false
  end
  if Game.Myself then
    Game.Myself:Server_SetPosXYZCmd(x, y, z, 1000)
  else
    LogUtility.Info("\229\176\157\232\175\149\233\135\141\231\189\174\228\189\141\231\189\174\239\188\140\228\189\134\230\156\170\230\137\190\229\136\176myself")
  end
  EventManager.Me():DispatchEvent(ServiceEvent.SceneGoToUserCmd, isgomap)
end
function MyselfProxy:SetProps(UserAttrSyncCmd, update)
  self:setExtraProps(UserAttrSyncCmd.pointattrs, update)
  if Game.Myself then
    Game.Myself:Server_SetUserDatas(UserAttrSyncCmd.datas, not update)
    Game.Myself:Server_SetAttrs(UserAttrSyncCmd.attrs)
  end
end
function MyselfProxy:InitNMyself(data)
  if Game.Myself == nil then
    local myData = MyselfData.CreateAsTable(data)
    Game.Myself = NMyselfPlayer.CreateAsTable(myData)
  end
  FunctionSkillEnableCheck.Me():SetMySelf(Game.Myself)
end
function MyselfProxy:SetMySelfCurRole(data)
  if not self.myself then
    self:InitNMyself(data)
  end
  FunctionPlayerPrefs.Me():InitUser(data.id)
  LocalSaveProxy.Instance:InitDontShowAgain()
  FunctionPerformanceSetting.Me():Load()
end
function MyselfProxy:InitRole(data)
  local p = self.myself or MySelfPlayer.new(data.id)
  p.name = data.name
  p.roleInfo.ID = data.id
  p:ResetPropToRoleInfo()
  return p
end
function MyselfProxy:SetChooseRoleId(id)
  self.chooseRoleId = id
end
function MyselfProxy:GetChooseRoleId()
  return self.chooseRoleId
end
function MyselfProxy:SetShortCuts(shortCuts)
  if shortCuts ~= nil then
    for i = 1, #shortCuts do
    end
  end
end
function MyselfProxy:RecvVarUpdate(data)
  if self.vars == nil then
    self.vars = {}
  end
  if self.accvars == nil then
    self.accvars = {}
  end
  if data ~= nil and data.vars ~= nil then
    local vars = data.vars
    local varslen = #vars
    for i = 1, varslen do
      local single = vars[i]
      if single then
        local varData = self.vars[single.type]
        if not varData then
          varData = {
            type = single.type,
            time = single.time
          }
          self.vars[single.type] = varData
        end
        varData.value = single.value
      end
    end
  end
  if data ~= nil and data.accvars ~= nil then
    local accvars = data.accvars
    local acclen = #accvars
    for i = 1, acclen do
      local single = accvars[i]
      if single then
        local accvarData = self.accvars[single.type]
        if not accvarData then
          accvarData = {
            type = single.type,
            time = single.time
          }
          self.accvars[single.type] = accvarData
        end
        accvarData.value = single.value
      end
    end
  end
end
function MyselfProxy:getVarByType(type)
  if self.vars == nil then
    return
  end
  return self.vars[type]
end
function MyselfProxy:getVarValueByType(type)
  if not self.vars then
    return
  end
  return self.vars[type] and self.vars[type].value
end
function MyselfProxy:GetAccVarByType(type)
  if self.accvars == nil then
    return
  end
  return self.accvars[type]
end
function MyselfProxy:GetAccVarValueByType(type)
  if not self.accvars then
    return
  end
  return self.accvars[type] and self.accvars[type].value
end
function MyselfProxy:RecvBufferUpdate(data)
  printRed("MyselfProxy:RecvBufferUpdate( data )")
  self.buffers = self.buffers or {}
  local updateBffs = {}
  local addBffs = {}
  if data.buff then
    for i = 1, #data.buff do
      local single = data.buff[i]
      if self.buffers[single.id] then
        local data = {}
        data.id = single.id
        data.oldLayer = self.buffers[single.id]
        data.newLayer = single.layer
        table.insert(updateBffs, data)
      else
        table.insert(addBffs, single)
      end
      self.buffers[single.id] = single.layer
    end
  end
  for i = 1, #updateBffs do
    local single = updateBffs[i]
    local buffData = Table_Buffer[single.id]
    local effect = buffData.BuffEffect
    local newLayer = single.newLayer
    local oldLayer = single.oldLayer
    if effect.type == "AttrChange" then
      for j, w in pairs(effect) do
        local prop = self.buffersProps[j]
        if j ~= "type" and prop and type(w) == "number" then
          local oldValue = self.buffersProps:GetValueByName(j)
          local deltaValue = (newLayer - oldLayer) * w
          if prop.propVO.isPercent then
            deltaValue = deltaValue * 1000
            oldValue = oldValue * 1000
          end
          local value = oldValue + deltaValue
          self.buffersProps:SetValueByName(j, value)
          self.buffAttr[j] = value
        end
      end
    end
  end
  for i = 1, #addBffs do
    local single = addBffs[i]
    local buffData = Table_Buffer[single.id]
    if buffData ~= nil and buffData.BuffEffect ~= nil then
      local effect = buffData.BuffEffect
      local v = single.layer
      if effect.type == "AttrChange" then
        for j, w in pairs(effect) do
          if j ~= "type" and type(w) == "number" then
            local prop = self.buffersProps[j]
            if prop then
              local oldValue = self.buffersProps:GetValueByName(j)
              local deltaValue = w * v
              if prop.propVO.isPercent then
                deltaValue = deltaValue * 1000
                oldValue = oldValue * 1000
              end
              local vl = deltaValue + oldValue
              self.buffersProps:SetValueByName(j, vl)
              self.buffAttr[j] = vl
            end
          end
        end
      end
    end
  end
end
function MyselfProxy:setExtraProps(props, update)
  if props ~= nil and #props > 0 then
    for i = 1, #props do
      if props[i] ~= nil then
        self.extraProps:SetValueById(props[i].type, props[i].value)
      end
    end
  end
end
function MyselfProxy:checkProfessionIsOpenById(profession)
  self:checkProfessionIsOpenByProfessionData(Table_Class[profession])
  return false
end
function MyselfProxy:checkProfessionIsOpenByProfessionData(professionData)
  return false
end
function MyselfProxy:initAllTitle(data)
  self.appellations = {}
  local titles = data.title_datas
  for i = 1, #titles do
    local title = titles[i]
    local Appellation = Appellation.new(title.id, title.title_type, title.createtime)
    self.appellations[#self.appellations + 1] = Appellation
  end
end
function MyselfProxy:newTitle(data)
  local titleData = data.title_data
  local id = data.charid
  if id == Game.Myself.data.id then
    local Appellation = Appellation.new(titleData.id, titleData.title_type, titleData.createtime)
    for i = 1, #self.appellations do
      local title = self.appellations[i]
      if title.id == Appellation.id then
        self.appellations[i] = Appellation
        return
      end
    end
    self.appellations[#self.appellations + 1] = Appellation
  end
  if titleData.title_type == UserEvent_pb.ETITLE_TYPE_MANNUAL then
    local creature = NSceneUserProxy.Instance:Find(id)
    if creature then
      GameFacade.Instance:sendNotification(SceneUserEvent.LevelUp, creature, SceneUserEvent.AppellationUp)
    end
  end
end
function MyselfProxy:GetCurManualAppellation()
  local curApp
  for i = 1, #self.appellations do
    local title = self.appellations[i]
    if title.titleType == UserEvent_pb.ETITLE_TYPE_MANNUAL and not curApp then
      curApp = title
      break
    end
  end
  if curApp then
    local nextApp = self:getAppellationById(curApp.staticData.PostID)
    while nextApp do
      curApp = nextApp
      nextApp = self:getAppellationById(curApp.staticData.PostID)
    end
  end
  return curApp
end
function MyselfProxy:GetCurFoodCookerApl()
  local curApp
  for i = 1, #self.appellations do
    local title = self.appellations[i]
    if title.titleType == UserEvent_pb.ETITLE_TYPE_FOODCOOKER and not curApp then
      curApp = title
      break
    end
  end
  if curApp then
    local nextApp = self:getAppellationById(curApp.staticData.PostID)
    while nextApp do
      curApp = nextApp
      nextApp = self:getAppellationById(curApp.staticData.PostID)
    end
  end
  return curApp
end
function MyselfProxy:GetCurFoodTasteApl()
  local curApp
  for i = 1, #self.appellations do
    local title = self.appellations[i]
    if title.titleType == UserEvent_pb.ETITLE_TYPE_FOODTASTER and not curApp then
      curApp = title
      break
    end
  end
  if curApp then
    local nextApp = self:getAppellationById(curApp.staticData.PostID)
    while nextApp do
      curApp = nextApp
      nextApp = self:getAppellationById(curApp.staticData.PostID)
    end
  end
  return curApp
end
function MyselfProxy:getAppellationById(id)
  if not id then
    return
  end
  for i = 1, #self.appellations do
    local title = self.appellations[i]
    if title.id == id then
      return title
    end
  end
end
function MyselfProxy:SetTraceItem(updates, dels)
  if updates then
    for i = 1, #updates do
      local upItem = updates[i]
      self.traceItems[upItem.itemid] = upItem
    end
  end
  if dels then
    for i = 1, #dels do
      local delid = dels[i]
      self.traceItems[delid] = nil
    end
  end
end
function MyselfProxy:GetTraceItems()
  local result = {}
  for _, item in pairs(self.traceItems) do
    table.insert(result, item)
  end
  return result
end
function MyselfProxy:GetTraceItemByItemId(itemid)
  return self.traceItems[itemid]
end
function MyselfProxy:SetUnlockActionIdMap(ids)
  for i = 1, #ids do
    local id = ids[i]
    self.unlockActionIds[id] = 1
  end
end
function MyselfProxy:GetUnlockActionMap()
  return self.unlockActionIds
end
function MyselfProxy:SetUnlockEmojiMap(ids)
  for i = 1, #ids do
    local id = ids[i]
    self.unlockEmojiIds[id] = 1
  end
end
function MyselfProxy:GetUnlockEmojiMap()
  return self.unlockEmojiIds
end
function MyselfProxy:HasJobBreak()
  if GameConfig.SystemForbid.Peak then
    return false
  end
  return FunctionUnLockFunc.Me():CheckCanOpen(450)
end
function MyselfProxy:HasJobNewBreak()
  return FunctionUnLockFunc.Me():CheckCanOpen(451)
end
function MyselfProxy:HasMaxJobBreak()
  return self:HasJobBreak() and self:CurMaxJobLevel() >= GameConfig.Dead.max_peaklv or false
end
function MyselfProxy:UpdateRandomFunc(array, beginIndex, endIndex)
  if nil ~= self.myself then
    self.myself:UpdateRandomFunc(array, beginIndex, endIndex)
  end
  if nil ~= Game.Myself then
    Game.Myself.data:UpdateRandomFunc(array, beginIndex, endIndex)
  end
end
function MyselfProxy:Test_SetEquipPos()
  local server_EquipPosDatas = {}
  for i = 1, 3 do
    local t = {}
    t.pos = i
    t.offstarttime = ServerTime.CurServerTime() / 1000
    t.offendtime = t.offstarttime + 60
    t.protecttime = 0
    t.protectalways = 1
    table.insert(server_EquipPosDatas, t)
  end
  self:Server_SetEquipPos_StateTime(server_EquipPosDatas)
end
function MyselfProxy:Server_SetEquipPos_StateTime(server_EquipPosDatas)
  local logStr = "\232\132\177\229\141\184\232\163\133\229\164\135:"
  for i = 1, #server_EquipPosDatas do
    local d = server_EquipPosDatas[i]
    local ld = self.equipPosStateTimeMap[d.pos]
    if ld == nil then
      ld = {}
      self.equipPosStateTimeMap[d.pos] = ld
    end
    ld.offstarttime = d.offstarttime
    ld.offendtime = d.offendtime
    ld.offduration = d.offendtime - d.offstarttime
    ld.protecttime = d.protecttime
    ld.protectalways = d.protectalways
    logStr = logStr .. string.format("\233\131\168\228\189\141:%s || \232\132\177\229\141\184\229\188\128\229\167\139\230\151\182\233\151\180:%s \232\132\177\229\141\184\231\187\147\230\157\159\230\151\182\233\151\180:%s \232\163\133\229\164\135\228\191\157\230\138\164\230\151\182\233\151\180:%s \232\163\133\229\164\135\230\176\184\228\185\133\228\191\157\230\138\164:%s", tostring(d.pos), os.date("%m\230\156\136%d\230\151\165%H\231\130\185%M\229\136\134%S\231\167\146", d.offstarttime), os.date("%m\230\156\136%d\230\151\165%H\231\130\185%M\229\136\134%S\231\167\146", d.offendtime), os.date("%m\230\156\136%d\230\151\165%H\231\130\185%M\229\136\134%S\231\167\146", d.protecttime), tostring(d.protectalways))
    logStr = logStr .. "\n"
  end
  helplog(logStr)
  FunctionBuff.Me():UpdateOffingEquipBuff()
  FunctionBuff.Me():UpdateProtectEquipBuff()
end
function MyselfProxy:EquipPos_UpdateBuff()
end
function MyselfProxy:GetEquipPos_StateTime(site)
  return self.equipPosStateTimeMap[site]
end
function MyselfProxy:IsEquipPosInOffing(site)
  local stateTime = self:GetEquipPos_StateTime(site)
  if stateTime and stateTime.offendtime and stateTime.offendtime > 0 then
    return 0 < ServerTime.ServerDeltaSecondTime(stateTime.offendtime * 1000)
  end
  return false
end
function MyselfProxy:GetOffingEquipPoses()
  local offPoses = {}
  for k, v in pairs(self.equipPosStateTimeMap) do
    if self:IsEquipPosInOffing(k) then
      table.insert(offPoses, k)
    end
  end
  table.sort(offPoses, function(a, b)
    return a < b
  end)
  return offPoses
end
function MyselfProxy:IsEquipPosInProtecting(site)
  local stateTime = self:GetEquipPos_StateTime(site)
  if stateTime then
    if stateTime.protectalways > 0 then
      return true
    end
    if stateTime.protecttime and 0 < stateTime.protecttime then
      return 0 < ServerTime.ServerDeltaSecondTime(stateTime.protecttime * 1000)
    end
  end
  return false
end
function MyselfProxy:HandleRelieveCd(data)
  self.reliveStamp = data.time + ServerTime.CurServerTime() / 1000
  self.reliveName = data.name
end
function MyselfProxy:ClearReliveCd()
  self.reliveStamp = nil
  self.reliveName = nil
end
function MyselfProxy:GetProtectEquipPoses()
  local protectPoses = {}
  for k, v in pairs(self.equipPosStateTimeMap) do
    if self:IsEquipPosInProtecting(k) then
      table.insert(protectPoses, k)
    end
  end
  table.sort(protectPoses, function(a, b)
    return a < b
  end)
  return protectPoses
end
function MyselfProxy:IsUnlockAstrolabe()
  local panelId = PanelConfig.AstrolabeView.id
  return FunctionUnLockFunc.Me():CheckCanOpenByPanelId(panelId)
end
function MyselfProxy:InitPropsTab()
  self.propTabConfigs = {}
  local PropTabConfig = GameConfig.PropTabConfig
  if not PropTabConfig then
    return
  end
  local propsTable = Table_RoleData
  for k, v in pairs(propsTable) do
    local class = v.class
    if class then
      local propTab = PropTabConfig[class]
      if propTab then
        if not self.propTabConfigs[class] then
          local propConfigData = {
            desc = propTab.desc,
            name = propTab.name,
            props = {},
            id = propTab.id
          }
        end
        local props = propConfigData.props
        props[#props + 1] = v
        self.propTabConfigs[class] = propConfigData
      end
    end
  end
  for k, v in pairs(self.propTabConfigs) do
    local props = v.props
    table.sort(props, function(l, r)
      return l.order < r.order
    end)
  end
end
function MyselfProxy:SetDebts(itemDatas)
  TableUtility.ArrayClear(self.debtDatas)
  if not itemDatas or #itemDatas == 0 then
    return
  end
  for i = 1, #itemDatas do
    local single = itemDatas[i].base
    local data = {
      id = single.id,
      num = single.count
    }
    self.debtDatas[#self.debtDatas + 1] = data
  end
end
function MyselfProxy:GetDebts()
  return self.debtDatas
end
return MyselfProxy
