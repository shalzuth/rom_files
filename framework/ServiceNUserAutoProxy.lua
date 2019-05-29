ServiceNUserAutoProxy = class("ServiceNUserAutoProxy", ServiceProxy)
ServiceNUserAutoProxy.Instance = nil
ServiceNUserAutoProxy.NAME = "ServiceNUserAutoProxy"
function ServiceNUserAutoProxy:ctor(proxyName)
  if ServiceNUserAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceNUserAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceNUserAutoProxy.Instance = self
  end
end
function ServiceNUserAutoProxy:Init()
end
function ServiceNUserAutoProxy:onRegister()
  self:Listen(9, 1, function(data)
    self:RecvGoCity(data)
  end)
  self:Listen(9, 2, function(data)
    self:RecvSysMsg(data)
  end)
  self:Listen(9, 3, function(data)
    self:RecvNpcDataSync(data)
  end)
  self:Listen(9, 4, function(data)
    self:RecvUserNineSyncCmd(data)
  end)
  self:Listen(9, 5, function(data)
    self:RecvUserActionNtf(data)
  end)
  self:Listen(9, 6, function(data)
    self:RecvUserBuffNineSyncCmd(data)
  end)
  self:Listen(9, 7, function(data)
    self:RecvExitPosUserCmd(data)
  end)
  self:Listen(9, 8, function(data)
    self:RecvRelive(data)
  end)
  self:Listen(9, 9, function(data)
    self:RecvVarUpdate(data)
  end)
  self:Listen(9, 10, function(data)
    self:RecvTalkInfo(data)
  end)
  self:Listen(9, 11, function(data)
    self:RecvServerTime(data)
  end)
  self:Listen(9, 14, function(data)
    self:RecvEffectUserCmd(data)
  end)
  self:Listen(9, 15, function(data)
    self:RecvMenuList(data)
  end)
  self:Listen(9, 16, function(data)
    self:RecvNewMenu(data)
  end)
  self:Listen(9, 17, function(data)
    self:RecvTeamInfoNine(data)
  end)
  self:Listen(9, 18, function(data)
    self:RecvUsePortrait(data)
  end)
  self:Listen(9, 19, function(data)
    self:RecvUseFrame(data)
  end)
  self:Listen(9, 20, function(data)
    self:RecvNewPortraitFrame(data)
  end)
  self:Listen(9, 24, function(data)
    self:RecvQueryPortraitListUserCmd(data)
  end)
  self:Listen(9, 25, function(data)
    self:RecvUseDressing(data)
  end)
  self:Listen(9, 26, function(data)
    self:RecvNewDressing(data)
  end)
  self:Listen(9, 27, function(data)
    self:RecvDressingListUserCmd(data)
  end)
  self:Listen(9, 21, function(data)
    self:RecvAddAttrPoint(data)
  end)
  self:Listen(9, 22, function(data)
    self:RecvQueryShopGotItem(data)
  end)
  self:Listen(9, 23, function(data)
    self:RecvUpdateShopGotItem(data)
  end)
  self:Listen(9, 29, function(data)
    self:RecvOpenUI(data)
  end)
  self:Listen(9, 30, function(data)
    self:RecvDbgSysMsg(data)
  end)
  self:Listen(9, 32, function(data)
    self:RecvFollowTransferCmd(data)
  end)
  self:Listen(9, 33, function(data)
    self:RecvCallNpcFuncCmd(data)
  end)
  self:Listen(9, 34, function(data)
    self:RecvModelShow(data)
  end)
  self:Listen(9, 35, function(data)
    self:RecvSoundEffectCmd(data)
  end)
  self:Listen(9, 36, function(data)
    self:RecvPresetMsgCmd(data)
  end)
  self:Listen(9, 37, function(data)
    self:RecvChangeBgmCmd(data)
  end)
  self:Listen(9, 38, function(data)
    self:RecvQueryFighterInfo(data)
  end)
  self:Listen(9, 40, function(data)
    self:RecvGameTimeCmd(data)
  end)
  self:Listen(9, 41, function(data)
    self:RecvCDTimeUserCmd(data)
  end)
  self:Listen(9, 42, function(data)
    self:RecvStateChange(data)
  end)
  self:Listen(9, 44, function(data)
    self:RecvPhoto(data)
  end)
  self:Listen(9, 45, function(data)
    self:RecvShakeScreen(data)
  end)
  self:Listen(9, 47, function(data)
    self:RecvQueryShortcut(data)
  end)
  self:Listen(9, 48, function(data)
    self:RecvPutShortcut(data)
  end)
  self:Listen(9, 49, function(data)
    self:RecvNpcChangeAngle(data)
  end)
  self:Listen(9, 50, function(data)
    self:RecvCameraFocus(data)
  end)
  self:Listen(9, 51, function(data)
    self:RecvGoToListUserCmd(data)
  end)
  self:Listen(9, 52, function(data)
    self:RecvGoToGearUserCmd(data)
  end)
  self:Listen(9, 12, function(data)
    self:RecvNewTransMapCmd(data)
  end)
  self:Listen(9, 151, function(data)
    self:RecvDeathTransferListCmd(data)
  end)
  self:Listen(9, 152, function(data)
    self:RecvNewDeathTransferCmd(data)
  end)
  self:Listen(9, 153, function(data)
    self:RecvUseDeathTransferCmd(data)
  end)
  self:Listen(9, 53, function(data)
    self:RecvFollowerUser(data)
  end)
  self:Listen(9, 96, function(data)
    self:RecvBeFollowUserCmd(data)
  end)
  self:Listen(9, 54, function(data)
    self:RecvLaboratoryUserCmd(data)
  end)
  self:Listen(9, 57, function(data)
    self:RecvGotoLaboratoryUserCmd(data)
  end)
  self:Listen(9, 56, function(data)
    self:RecvExchangeProfession(data)
  end)
  self:Listen(9, 58, function(data)
    self:RecvSceneryUserCmd(data)
  end)
  self:Listen(9, 59, function(data)
    self:RecvGoMapQuestUserCmd(data)
  end)
  self:Listen(9, 60, function(data)
    self:RecvGoMapFollowUserCmd(data)
  end)
  self:Listen(9, 61, function(data)
    self:RecvUserAutoHitCmd(data)
  end)
  self:Listen(9, 62, function(data)
    self:RecvUploadSceneryPhotoUserCmd(data)
  end)
  self:Listen(9, 80, function(data)
    self:RecvDownloadSceneryPhotoUserCmd(data)
  end)
  self:Listen(9, 63, function(data)
    self:RecvQueryMapArea(data)
  end)
  self:Listen(9, 64, function(data)
    self:RecvNewMapAreaNtf(data)
  end)
  self:Listen(9, 66, function(data)
    self:RecvBuffForeverCmd(data)
  end)
  self:Listen(9, 67, function(data)
    self:RecvInviteJoinHandsUserCmd(data)
  end)
  self:Listen(9, 68, function(data)
    self:RecvBreakUpHandsUserCmd(data)
  end)
  self:Listen(9, 95, function(data)
    self:RecvHandStatusUserCmd(data)
  end)
  self:Listen(9, 69, function(data)
    self:RecvQueryShow(data)
  end)
  self:Listen(9, 70, function(data)
    self:RecvQueryMusicList(data)
  end)
  self:Listen(9, 71, function(data)
    self:RecvDemandMusic(data)
  end)
  self:Listen(9, 72, function(data)
    self:RecvCloseMusicFrame(data)
  end)
  self:Listen(9, 73, function(data)
    self:RecvUploadOkSceneryUserCmd(data)
  end)
  self:Listen(9, 74, function(data)
    self:RecvJoinHandsUserCmd(data)
  end)
  self:Listen(9, 75, function(data)
    self:RecvQueryTraceList(data)
  end)
  self:Listen(9, 76, function(data)
    self:RecvUpdateTraceList(data)
  end)
  self:Listen(9, 77, function(data)
    self:RecvSetDirection(data)
  end)
  self:Listen(9, 82, function(data)
    self:RecvBattleTimelenUserCmd(data)
  end)
  self:Listen(9, 83, function(data)
    self:RecvSetOptionUserCmd(data)
  end)
  self:Listen(9, 84, function(data)
    self:RecvQueryUserInfoUserCmd(data)
  end)
  self:Listen(9, 85, function(data)
    self:RecvCountDownTickUserCmd(data)
  end)
  self:Listen(9, 86, function(data)
    self:RecvItemMusicNtfUserCmd(data)
  end)
  self:Listen(9, 87, function(data)
    self:RecvShakeTreeUserCmd(data)
  end)
  self:Listen(9, 88, function(data)
    self:RecvTreeListUserCmd(data)
  end)
  self:Listen(9, 89, function(data)
    self:RecvActivityNtfUserCmd(data)
  end)
  self:Listen(9, 91, function(data)
    self:RecvQueryZoneStatusUserCmd(data)
  end)
  self:Listen(9, 92, function(data)
    self:RecvJumpZoneUserCmd(data)
  end)
  self:Listen(9, 93, function(data)
    self:RecvItemImageUserNtfUserCmd(data)
  end)
  self:Listen(9, 97, function(data)
    self:RecvInviteFollowUserCmd(data)
  end)
  self:Listen(9, 98, function(data)
    self:RecvChangeNameUserCmd(data)
  end)
  self:Listen(9, 99, function(data)
    self:RecvChargePlayUserCmd(data)
  end)
  self:Listen(9, 100, function(data)
    self:RecvRequireNpcFuncUserCmd(data)
  end)
  self:Listen(9, 101, function(data)
    self:RecvCheckSeatUserCmd(data)
  end)
  self:Listen(9, 102, function(data)
    self:RecvNtfSeatUserCmd(data)
  end)
  self:Listen(9, 114, function(data)
    self:RecvYoyoSeatUserCmd(data)
  end)
  self:Listen(9, 115, function(data)
    self:RecvShowSeatUserCmd(data)
  end)
  self:Listen(9, 103, function(data)
    self:RecvSetNormalSkillOptionUserCmd(data)
  end)
  self:Listen(9, 106, function(data)
    self:RecvNewSetOptionUserCmd(data)
  end)
  self:Listen(9, 104, function(data)
    self:RecvUnsolvedSceneryNtfUserCmd(data)
  end)
  self:Listen(9, 105, function(data)
    self:RecvNtfVisibleNpcUserCmd(data)
  end)
  self:Listen(9, 107, function(data)
    self:RecvUpyunAuthorizationCmd(data)
  end)
  self:Listen(9, 108, function(data)
    self:RecvTransformPreDataCmd(data)
  end)
  self:Listen(9, 109, function(data)
    self:RecvUserRenameCmd(data)
  end)
  self:Listen(9, 111, function(data)
    self:RecvBuyZenyCmd(data)
  end)
  self:Listen(9, 112, function(data)
    self:RecvCallTeamerUserCmd(data)
  end)
  self:Listen(9, 113, function(data)
    self:RecvCallTeamerReplyUserCmd(data)
  end)
  self:Listen(9, 116, function(data)
    self:RecvSpecialEffectCmd(data)
  end)
  self:Listen(9, 117, function(data)
    self:RecvMarriageProposalCmd(data)
  end)
  self:Listen(9, 118, function(data)
    self:RecvMarriageProposalReplyCmd(data)
  end)
  self:Listen(9, 119, function(data)
    self:RecvUploadWeddingPhotoUserCmd(data)
  end)
  self:Listen(9, 120, function(data)
    self:RecvMarriageProposalSuccessCmd(data)
  end)
  self:Listen(9, 121, function(data)
    self:RecvInviteeWeddingStartNtfUserCmd(data)
  end)
  self:Listen(9, 128, function(data)
    self:RecvKFCShareUserCmd(data)
  end)
  self:Listen(9, 162, function(data)
    self:RecvKFCEnrollUserCmd(data)
  end)
  self:Listen(9, 168, function(data)
    self:RecvKFCEnrollCodeUserCmd(data)
  end)
  self:Listen(9, 163, function(data)
    self:RecvKFCEnrollReplyUserCmd(data)
  end)
  self:Listen(9, 167, function(data)
    self:RecvKFCEnrollQueryUserCmd(data)
  end)
  self:Listen(9, 166, function(data)
    self:RecvKFCHasEnrolledUserCmd(data)
  end)
  self:Listen(9, 130, function(data)
    self:RecvCheckRelationUserCmd(data)
  end)
  self:Listen(9, 129, function(data)
    self:RecvTwinsActionUserCmd(data)
  end)
  self:Listen(9, 122, function(data)
    self:RecvShowServantUserCmd(data)
  end)
  self:Listen(9, 123, function(data)
    self:RecvReplaceServantUserCmd(data)
  end)
  self:Listen(9, 124, function(data)
    self:RecvServantService(data)
  end)
  self:Listen(9, 125, function(data)
    self:RecvRecommendServantUserCmd(data)
  end)
  self:Listen(9, 126, function(data)
    self:RecvReceiveServantUserCmd(data)
  end)
  self:Listen(9, 127, function(data)
    self:RecvServantRewardStatusUserCmd(data)
  end)
  self:Listen(9, 131, function(data)
    self:RecvProfessionQueryUserCmd(data)
  end)
  self:Listen(9, 132, function(data)
    self:RecvProfessionBuyUserCmd(data)
  end)
  self:Listen(9, 133, function(data)
    self:RecvProfessionChangeUserCmd(data)
  end)
  self:Listen(9, 134, function(data)
    self:RecvUpdateRecordInfoUserCmd(data)
  end)
  self:Listen(9, 135, function(data)
    self:RecvSaveRecordUserCmd(data)
  end)
  self:Listen(9, 136, function(data)
    self:RecvLoadRecordUserCmd(data)
  end)
  self:Listen(9, 137, function(data)
    self:RecvChangeRecordNameUserCmd(data)
  end)
  self:Listen(9, 138, function(data)
    self:RecvBuyRecordSlotUserCmd(data)
  end)
  self:Listen(9, 139, function(data)
    self:RecvDeleteRecordUserCmd(data)
  end)
  self:Listen(9, 140, function(data)
    self:RecvUpdateBranchInfoUserCmd(data)
  end)
  self:Listen(9, 110, function(data)
    self:RecvEnterCapraActivityCmd(data)
  end)
  self:Listen(9, 142, function(data)
    self:RecvInviteWithMeUserCmd(data)
  end)
  self:Listen(9, 143, function(data)
    self:RecvQueryAltmanKillUserCmd(data)
  end)
  self:Listen(9, 144, function(data)
    self:RecvBoothReqUserCmd(data)
  end)
  self:Listen(9, 145, function(data)
    self:RecvBoothInfoSyncUserCmd(data)
  end)
  self:Listen(9, 146, function(data)
    self:RecvDressUpModelUserCmd(data)
  end)
  self:Listen(9, 147, function(data)
    self:RecvDressUpHeadUserCmd(data)
  end)
  self:Listen(9, 148, function(data)
    self:RecvQueryStageUserCmd(data)
  end)
  self:Listen(9, 149, function(data)
    self:RecvDressUpLineUpUserCmd(data)
  end)
  self:Listen(9, 150, function(data)
    self:RecvDressUpStageUserCmd(data)
  end)
  self:Listen(9, 141, function(data)
    self:RecvGoToFunctionMapUserCmd(data)
  end)
  self:Listen(9, 154, function(data)
    self:RecvGrowthServantUserCmd(data)
  end)
  self:Listen(9, 155, function(data)
    self:RecvReceiveGrowthServantUserCmd(data)
  end)
  self:Listen(9, 156, function(data)
    self:RecvGrowthOpenServantUserCmd(data)
  end)
  self:Listen(9, 157, function(data)
    self:RecvCheatTagUserCmd(data)
  end)
  self:Listen(9, 158, function(data)
    self:RecvCheatTagStatUserCmd(data)
  end)
  self:Listen(9, 159, function(data)
    self:RecvClickPosList(data)
  end)
  self:Listen(9, 164, function(data)
    self:RecvSignInUserCmd(data)
  end)
  self:Listen(9, 165, function(data)
    self:RecvSignInNtfUserCmd(data)
  end)
  self:Listen(9, 160, function(data)
    self:RecvBeatPoriUserCmd(data)
  end)
  self:Listen(9, 161, function(data)
    self:RecvUnlockFrameUserCmd(data)
  end)
  self:Listen(9, 170, function(data)
    self:RecvAltmanRewardUserCmd(data)
  end)
  self:Listen(9, 171, function(data)
    self:RecvServantReqReservationUserCmd(data)
  end)
  self:Listen(9, 172, function(data)
    self:RecvServantReservationUserCmd(data)
  end)
  self:Listen(9, 173, function(data)
    self:RecvServantRecEquipUserCmd(data)
  end)
end
function ServiceNUserAutoProxy:CallGoCity(mapid)
  local msg = SceneUser2_pb.GoCity()
  if mapid ~= nil then
    msg.mapid = mapid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallSysMsg(id, type, params, act, delay)
  local msg = SceneUser2_pb.SysMsg()
  if id ~= nil then
    msg.id = id
  end
  if type ~= nil then
    msg.type = type
  end
  if params ~= nil then
    for i = 1, #params do
      table.insert(msg.params, params[i])
    end
  end
  if act ~= nil then
    msg.act = act
  end
  if delay ~= nil then
    msg.delay = delay
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallNpcDataSync(guid, attrs, datas)
  local msg = SceneUser2_pb.NpcDataSync()
  if guid ~= nil then
    msg.guid = guid
  end
  if attrs ~= nil then
    for i = 1, #attrs do
      table.insert(msg.attrs, attrs[i])
    end
  end
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUserNineSyncCmd(guid, datas, attrs)
  local msg = SceneUser2_pb.UserNineSyncCmd()
  if guid ~= nil then
    msg.guid = guid
  end
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  if attrs ~= nil then
    for i = 1, #attrs do
      table.insert(msg.attrs, attrs[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUserActionNtf(charid, value, type, delay)
  local msg = SceneUser2_pb.UserActionNtf()
  if charid ~= nil then
    msg.charid = charid
  end
  if value ~= nil then
    msg.value = value
  end
  if type ~= nil then
    msg.type = type
  end
  if delay ~= nil then
    msg.delay = delay
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUserBuffNineSyncCmd(guid, updates, dels)
  local msg = SceneUser2_pb.UserBuffNineSyncCmd()
  if guid ~= nil then
    msg.guid = guid
  end
  if updates ~= nil then
    for i = 1, #updates do
      table.insert(msg.updates, updates[i])
    end
  end
  if dels ~= nil then
    for i = 1, #dels do
      table.insert(msg.dels, dels[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallExitPosUserCmd(pos, exitid, mapid)
  local msg = SceneUser2_pb.ExitPosUserCmd()
  if pos ~= nil and pos.x ~= nil then
    msg.pos.x = pos.x
  end
  if pos ~= nil and pos.y ~= nil then
    msg.pos.y = pos.y
  end
  if pos ~= nil and pos.z ~= nil then
    msg.pos.z = pos.z
  end
  if exitid ~= nil then
    msg.exitid = exitid
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallRelive(type)
  local msg = SceneUser2_pb.Relive()
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallVarUpdate(vars, accvars)
  local msg = SceneUser2_pb.VarUpdate()
  if vars ~= nil then
    for i = 1, #vars do
      table.insert(msg.vars, vars[i])
    end
  end
  if accvars ~= nil then
    for i = 1, #accvars do
      table.insert(msg.accvars, accvars[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallTalkInfo(guid, talkid, talkmessage, params)
  local msg = SceneUser2_pb.TalkInfo()
  if guid ~= nil then
    msg.guid = guid
  end
  if talkid ~= nil then
    msg.talkid = talkid
  end
  if talkmessage ~= nil then
    msg.talkmessage = talkmessage
  end
  if params ~= nil then
    for i = 1, #params do
      table.insert(msg.params, params[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallServerTime(time)
  local msg = SceneUser2_pb.ServerTime()
  if time ~= nil then
    msg.time = time
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallEffectUserCmd(effecttype, charid, effectpos, pos, effect, msec, times, index, opt, posbind, epbind, delay, id, dir, skillid, ignorenavmesh)
  local msg = SceneUser2_pb.EffectUserCmd()
  if effecttype ~= nil then
    msg.effecttype = effecttype
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if effectpos ~= nil then
    msg.effectpos = effectpos
  end
  if pos ~= nil and pos.x ~= nil then
    msg.pos.x = pos.x
  end
  if pos ~= nil and pos.y ~= nil then
    msg.pos.y = pos.y
  end
  if pos ~= nil and pos.z ~= nil then
    msg.pos.z = pos.z
  end
  if effect ~= nil then
    msg.effect = effect
  end
  if msec ~= nil then
    msg.msec = msec
  end
  if times ~= nil then
    msg.times = times
  end
  if index ~= nil then
    msg.index = index
  end
  if opt ~= nil then
    msg.opt = opt
  end
  if posbind ~= nil then
    msg.posbind = posbind
  end
  if epbind ~= nil then
    msg.epbind = epbind
  end
  if delay ~= nil then
    msg.delay = delay
  end
  if id ~= nil then
    msg.id = id
  end
  if dir ~= nil then
    msg.dir = dir
  end
  if skillid ~= nil then
    msg.skillid = skillid
  end
  if ignorenavmesh ~= nil then
    msg.ignorenavmesh = ignorenavmesh
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallMenuList(list, dellist)
  local msg = SceneUser2_pb.MenuList()
  if list ~= nil then
    for i = 1, #list do
      table.insert(msg.list, list[i])
    end
  end
  if dellist ~= nil then
    for i = 1, #dellist do
      table.insert(msg.dellist, dellist[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallNewMenu(animplay, list)
  local msg = SceneUser2_pb.NewMenu()
  if animplay ~= nil then
    msg.animplay = animplay
  end
  if list ~= nil then
    for i = 1, #list do
      table.insert(msg.list, list[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallTeamInfoNine(userid, id, name)
  local msg = SceneUser2_pb.TeamInfoNine()
  if userid ~= nil then
    msg.userid = userid
  end
  if id ~= nil then
    msg.id = id
  end
  if name ~= nil then
    msg.name = name
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUsePortrait(id)
  local msg = SceneUser2_pb.UsePortrait()
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUseFrame(id)
  local msg = SceneUser2_pb.UseFrame()
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallNewPortraitFrame(portrait, frame)
  local msg = SceneUser2_pb.NewPortraitFrame()
  if portrait ~= nil then
    for i = 1, #portrait do
      table.insert(msg.portrait, portrait[i])
    end
  end
  if frame ~= nil then
    for i = 1, #frame do
      table.insert(msg.frame, frame[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallQueryPortraitListUserCmd(portrait)
  local msg = SceneUser2_pb.QueryPortraitListUserCmd()
  if portrait ~= nil then
    for i = 1, #portrait do
      table.insert(msg.portrait, portrait[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUseDressing(id, charid, type)
  local msg = SceneUser2_pb.UseDressing()
  if id ~= nil then
    msg.id = id
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallNewDressing(type, dressids)
  local msg = SceneUser2_pb.NewDressing()
  if type ~= nil then
    msg.type = type
  end
  if dressids ~= nil then
    for i = 1, #dressids do
      table.insert(msg.dressids, dressids[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallDressingListUserCmd(type, dressids)
  local msg = SceneUser2_pb.DressingListUserCmd()
  if type ~= nil then
    msg.type = type
  end
  if dressids ~= nil then
    for i = 1, #dressids do
      table.insert(msg.dressids, dressids[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallAddAttrPoint(type, strpoint, intpoint, agipoint, dexpoint, vitpoint, lukpoint)
  local msg = SceneUser2_pb.AddAttrPoint()
  if type ~= nil then
    msg.type = type
  end
  if strpoint ~= nil then
    msg.strpoint = strpoint
  end
  if intpoint ~= nil then
    msg.intpoint = intpoint
  end
  if agipoint ~= nil then
    msg.agipoint = agipoint
  end
  if dexpoint ~= nil then
    msg.dexpoint = dexpoint
  end
  if vitpoint ~= nil then
    msg.vitpoint = vitpoint
  end
  if lukpoint ~= nil then
    msg.lukpoint = lukpoint
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallQueryShopGotItem(items, discountitems, limititems)
  local msg = SceneUser2_pb.QueryShopGotItem()
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  if discountitems ~= nil then
    for i = 1, #discountitems do
      table.insert(msg.discountitems, discountitems[i])
    end
  end
  if limititems ~= nil then
    for i = 1, #limititems do
      table.insert(msg.limititems, limititems[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUpdateShopGotItem(item, discountitem, limititem)
  local msg = SceneUser2_pb.UpdateShopGotItem()
  if item ~= nil and item.id ~= nil then
    msg.item.id = item.id
  end
  if item ~= nil and item.count ~= nil then
    msg.item.count = item.count
  end
  if discountitem ~= nil and discountitem.id ~= nil then
    msg.discountitem.id = discountitem.id
  end
  if discountitem ~= nil and discountitem.count ~= nil then
    msg.discountitem.count = discountitem.count
  end
  if limititem ~= nil and limititem.id ~= nil then
    msg.limititem.id = limititem.id
  end
  if limititem ~= nil and limititem.count ~= nil then
    msg.limititem.count = limititem.count
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallOpenUI(id, ui)
  local msg = SceneUser2_pb.OpenUI()
  if id ~= nil then
    msg.id = id
  end
  if ui ~= nil then
    msg.ui = ui
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallDbgSysMsg(type, content)
  local msg = SceneUser2_pb.DbgSysMsg()
  msg.type = type
  msg.content = content
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallFollowTransferCmd(targetId)
  local msg = SceneUser2_pb.FollowTransferCmd()
  if targetId ~= nil then
    msg.targetId = targetId
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallCallNpcFuncCmd(type, funparam)
  local msg = SceneUser2_pb.CallNpcFuncCmd()
  if type ~= nil then
    msg.type = type
  end
  if funparam ~= nil then
    msg.funparam = funparam
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallModelShow(type, data)
  local msg = SceneUser2_pb.ModelShow()
  if type ~= nil then
    msg.type = type
  end
  if data ~= nil then
    msg.data = data
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallSoundEffectCmd(se, pos, msec, times, delay)
  local msg = SceneUser2_pb.SoundEffectCmd()
  if se ~= nil then
    msg.se = se
  end
  if pos ~= nil and pos.x ~= nil then
    msg.pos.x = pos.x
  end
  if pos ~= nil and pos.y ~= nil then
    msg.pos.y = pos.y
  end
  if pos ~= nil and pos.z ~= nil then
    msg.pos.z = pos.z
  end
  if msec ~= nil then
    msg.msec = msec
  end
  if times ~= nil then
    msg.times = times
  end
  if delay ~= nil then
    msg.delay = delay
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallPresetMsgCmd(msgs)
  local msg = SceneUser2_pb.PresetMsgCmd()
  if msgs ~= nil then
    for i = 1, #msgs do
      table.insert(msg.msgs, msgs[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallChangeBgmCmd(bgm, play, times, type)
  local msg = SceneUser2_pb.ChangeBgmCmd()
  if bgm ~= nil then
    msg.bgm = bgm
  end
  if play ~= nil then
    msg.play = play
  end
  if times ~= nil then
    msg.times = times
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallQueryFighterInfo(fighters)
  local msg = SceneUser2_pb.QueryFighterInfo()
  if fighters ~= nil then
    for i = 1, #fighters do
      table.insert(msg.fighters, fighters[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallGameTimeCmd(opt, sec, speed)
  local msg = SceneUser2_pb.GameTimeCmd()
  if opt ~= nil then
    msg.opt = opt
  end
  if sec ~= nil then
    msg.sec = sec
  end
  if speed ~= nil then
    msg.speed = speed
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallCDTimeUserCmd(list)
  local msg = SceneUser2_pb.CDTimeUserCmd()
  if list ~= nil then
    for i = 1, #list do
      table.insert(msg.list, list[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallStateChange(status)
  local msg = SceneUser2_pb.StateChange()
  if status ~= nil then
    msg.status = status
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallPhoto(guid)
  local msg = SceneUser2_pb.Photo()
  if guid ~= nil then
    msg.guid = guid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallShakeScreen(maxamplitude, msec, shaketype)
  local msg = SceneUser2_pb.ShakeScreen()
  if maxamplitude ~= nil then
    msg.maxamplitude = maxamplitude
  end
  if msec ~= nil then
    msg.msec = msec
  end
  if shaketype ~= nil then
    msg.shaketype = shaketype
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallQueryShortcut(list)
  local msg = SceneUser2_pb.QueryShortcut()
  if list ~= nil then
    for i = 1, #list do
      table.insert(msg.list, list[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallPutShortcut(item)
  local msg = SceneUser2_pb.PutShortcut()
  if item ~= nil and item.guid ~= nil then
    msg.item.guid = item.guid
  end
  if item ~= nil and item.type ~= nil then
    msg.item.type = item.type
  end
  if item ~= nil and item.pos ~= nil then
    msg.item.pos = item.pos
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallNpcChangeAngle(guid, targetid, angle)
  local msg = SceneUser2_pb.NpcChangeAngle()
  if guid ~= nil then
    msg.guid = guid
  end
  if targetid ~= nil then
    msg.targetid = targetid
  end
  if angle ~= nil then
    msg.angle = angle
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallCameraFocus(targets)
  local msg = SceneUser2_pb.CameraFocus()
  if targets ~= nil then
    for i = 1, #targets do
      table.insert(msg.targets, targets[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallGoToListUserCmd(mapid)
  local msg = SceneUser2_pb.GoToListUserCmd()
  if mapid ~= nil then
    for i = 1, #mapid do
      table.insert(msg.mapid, mapid[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallGoToGearUserCmd(mapid, type, otherids)
  local msg = SceneUser2_pb.GoToGearUserCmd()
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if type ~= nil then
    msg.type = type
  end
  if otherids ~= nil then
    for i = 1, #otherids do
      table.insert(msg.otherids, otherids[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallNewTransMapCmd(mapid)
  local msg = SceneUser2_pb.NewTransMapCmd()
  if mapid ~= nil then
    for i = 1, #mapid do
      table.insert(msg.mapid, mapid[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallDeathTransferListCmd(npcId)
  local msg = SceneUser2_pb.DeathTransferListCmd()
  if npcId ~= nil then
    for i = 1, #npcId do
      table.insert(msg.npcId, npcId[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallNewDeathTransferCmd(npcId)
  local msg = SceneUser2_pb.NewDeathTransferCmd()
  if npcId ~= nil then
    msg.npcId = npcId
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUseDeathTransferCmd(fromNpcId, toNpcId)
  local msg = SceneUser2_pb.UseDeathTransferCmd()
  if fromNpcId ~= nil then
    msg.fromNpcId = fromNpcId
  end
  if toNpcId ~= nil then
    msg.toNpcId = toNpcId
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallFollowerUser(userid, eType)
  local msg = SceneUser2_pb.FollowerUser()
  if userid ~= nil then
    msg.userid = userid
  end
  if eType ~= nil then
    msg.eType = eType
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallBeFollowUserCmd(userid, eType)
  local msg = SceneUser2_pb.BeFollowUserCmd()
  if userid ~= nil then
    msg.userid = userid
  end
  if eType ~= nil then
    msg.eType = eType
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallLaboratoryUserCmd(round, curscore, maxscore)
  local msg = SceneUser2_pb.LaboratoryUserCmd()
  if round ~= nil then
    msg.round = round
  end
  if curscore ~= nil then
    msg.curscore = curscore
  end
  if maxscore ~= nil then
    msg.maxscore = maxscore
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallGotoLaboratoryUserCmd(funid)
  local msg = SceneUser2_pb.GotoLaboratoryUserCmd()
  if funid ~= nil then
    msg.funid = funid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallExchangeProfession(guid, datas, attrs, pointattrs, type)
  local msg = SceneUser2_pb.ExchangeProfession()
  if guid ~= nil then
    msg.guid = guid
  end
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  if attrs ~= nil then
    for i = 1, #attrs do
      table.insert(msg.attrs, attrs[i])
    end
  end
  if pointattrs ~= nil then
    for i = 1, #pointattrs do
      table.insert(msg.pointattrs, pointattrs[i])
    end
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallSceneryUserCmd(mapid, scenerys)
  local msg = SceneUser2_pb.SceneryUserCmd()
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if scenerys ~= nil then
    for i = 1, #scenerys do
      table.insert(msg.scenerys, scenerys[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallGoMapQuestUserCmd(questid)
  local msg = SceneUser2_pb.GoMapQuestUserCmd()
  if questid ~= nil then
    msg.questid = questid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallGoMapFollowUserCmd(mapid, charid)
  local msg = SceneUser2_pb.GoMapFollowUserCmd()
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUserAutoHitCmd(charid)
  local msg = SceneUser2_pb.UserAutoHitCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUploadSceneryPhotoUserCmd(type, sceneryid, policy, signature)
  local msg = SceneUser2_pb.UploadSceneryPhotoUserCmd()
  if type ~= nil then
    msg.type = type
  end
  if sceneryid ~= nil then
    msg.sceneryid = sceneryid
  end
  if policy ~= nil then
    msg.policy = policy
  end
  if signature ~= nil then
    msg.signature = signature
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallDownloadSceneryPhotoUserCmd(urls)
  local msg = SceneUser2_pb.DownloadSceneryPhotoUserCmd()
  if urls ~= nil then
    for i = 1, #urls do
      table.insert(msg.urls, urls[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallQueryMapArea(areas)
  local msg = SceneUser2_pb.QueryMapArea()
  if areas ~= nil then
    for i = 1, #areas do
      table.insert(msg.areas, areas[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallNewMapAreaNtf(area)
  local msg = SceneUser2_pb.NewMapAreaNtf()
  if area ~= nil then
    msg.area = area
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallBuffForeverCmd(buff)
  local msg = SceneUser2_pb.BuffForeverCmd()
  if buff ~= nil then
    for i = 1, #buff do
      table.insert(msg.buff, buff[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallInviteJoinHandsUserCmd(charid, masterid, time, mastername, sign)
  local msg = SceneUser2_pb.InviteJoinHandsUserCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if masterid ~= nil then
    msg.masterid = masterid
  end
  if time ~= nil then
    msg.time = time
  end
  if mastername ~= nil then
    msg.mastername = mastername
  end
  if sign ~= nil then
    msg.sign = sign
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallBreakUpHandsUserCmd()
  local msg = SceneUser2_pb.BreakUpHandsUserCmd()
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallHandStatusUserCmd(build, masterid, followid, type)
  local msg = SceneUser2_pb.HandStatusUserCmd()
  if build ~= nil then
    msg.build = build
  end
  if masterid ~= nil then
    msg.masterid = masterid
  end
  if followid ~= nil then
    msg.followid = followid
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallQueryShow(actionid, expression)
  local msg = SceneUser2_pb.QueryShow()
  if actionid ~= nil then
    for i = 1, #actionid do
      table.insert(msg.actionid, actionid[i])
    end
  end
  if expression ~= nil then
    for i = 1, #expression do
      table.insert(msg.expression, expression[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallQueryMusicList(npcid, items)
  local msg = SceneUser2_pb.QueryMusicList()
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallDemandMusic(npcid, musicid)
  local msg = SceneUser2_pb.DemandMusic()
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if musicid ~= nil then
    msg.musicid = musicid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallCloseMusicFrame()
  local msg = SceneUser2_pb.CloseMusicFrame()
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUploadOkSceneryUserCmd(sceneryid, status, anglez, time)
  local msg = SceneUser2_pb.UploadOkSceneryUserCmd()
  if sceneryid ~= nil then
    msg.sceneryid = sceneryid
  end
  if status ~= nil then
    msg.status = status
  end
  if anglez ~= nil then
    msg.anglez = anglez
  end
  if time ~= nil then
    msg.time = time
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallJoinHandsUserCmd(masterid, sign, time)
  local msg = SceneUser2_pb.JoinHandsUserCmd()
  if masterid ~= nil then
    msg.masterid = masterid
  end
  if sign ~= nil then
    msg.sign = sign
  end
  if time ~= nil then
    msg.time = time
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallQueryTraceList(items)
  local msg = SceneUser2_pb.QueryTraceList()
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUpdateTraceList(updates, dels)
  local msg = SceneUser2_pb.UpdateTraceList()
  if updates ~= nil then
    for i = 1, #updates do
      table.insert(msg.updates, updates[i])
    end
  end
  if dels ~= nil then
    for i = 1, #dels do
      table.insert(msg.dels, dels[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallSetDirection(dir)
  local msg = SceneUser2_pb.SetDirection()
  if dir ~= nil then
    msg.dir = dir
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallBattleTimelenUserCmd(timelen, totaltime, musictime, tutortime, estatus)
  local msg = SceneUser2_pb.BattleTimelenUserCmd()
  if timelen ~= nil then
    msg.timelen = timelen
  end
  if totaltime ~= nil then
    msg.totaltime = totaltime
  end
  if musictime ~= nil then
    msg.musictime = musictime
  end
  if tutortime ~= nil then
    msg.tutortime = tutortime
  end
  if estatus ~= nil then
    msg.estatus = estatus
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallSetOptionUserCmd(type, fashionhide, wedding_type)
  local msg = SceneUser2_pb.SetOptionUserCmd()
  if type ~= nil then
    msg.type = type
  end
  if fashionhide ~= nil then
    msg.fashionhide = fashionhide
  end
  if wedding_type ~= nil then
    msg.wedding_type = wedding_type
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallQueryUserInfoUserCmd(charid, teamid, blink)
  local msg = SceneUser2_pb.QueryUserInfoUserCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if teamid ~= nil then
    msg.teamid = teamid
  end
  if blink ~= nil then
    msg.blink = blink
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallCountDownTickUserCmd(type, tick, time, sign, extparam, gomaptype)
  local msg = SceneUser2_pb.CountDownTickUserCmd()
  if type ~= nil then
    msg.type = type
  end
  if tick ~= nil then
    msg.tick = tick
  end
  if time ~= nil then
    msg.time = time
  end
  if sign ~= nil then
    msg.sign = sign
  end
  if extparam ~= nil then
    msg.extparam = extparam
  end
  if gomaptype ~= nil then
    msg.gomaptype = gomaptype
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallItemMusicNtfUserCmd(add, uri, starttime)
  local msg = SceneUser2_pb.ItemMusicNtfUserCmd()
  if add ~= nil then
    msg.add = add
  end
  if uri ~= nil then
    msg.uri = uri
  end
  if starttime ~= nil then
    msg.starttime = starttime
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallShakeTreeUserCmd(npcid, result)
  local msg = SceneUser2_pb.ShakeTreeUserCmd()
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if result ~= nil then
    msg.result = result
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallTreeListUserCmd(updates, dels)
  local msg = SceneUser2_pb.TreeListUserCmd()
  if updates ~= nil then
    for i = 1, #updates do
      table.insert(msg.updates, updates[i])
    end
  end
  if dels ~= nil then
    for i = 1, #dels do
      table.insert(msg.dels, dels[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallActivityNtfUserCmd(id, mapid, endtime, progress)
  local msg = SceneUser2_pb.ActivityNtfUserCmd()
  if id ~= nil then
    msg.id = id
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if endtime ~= nil then
    msg.endtime = endtime
  end
  if progress ~= nil then
    msg.progress = progress
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallQueryZoneStatusUserCmd(infos, recents)
  local msg = SceneUser2_pb.QueryZoneStatusUserCmd()
  if infos ~= nil then
    for i = 1, #infos do
      table.insert(msg.infos, infos[i])
    end
  end
  if recents ~= nil then
    for i = 1, #recents do
      table.insert(msg.recents, recents[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallJumpZoneUserCmd(npcid, zoneid)
  local msg = SceneUser2_pb.JumpZoneUserCmd()
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallItemImageUserNtfUserCmd(userid)
  local msg = SceneUser2_pb.ItemImageUserNtfUserCmd()
  if userid ~= nil then
    msg.userid = userid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallInviteFollowUserCmd(charid, follow)
  local msg = SceneUser2_pb.InviteFollowUserCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if follow ~= nil then
    msg.follow = follow
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallChangeNameUserCmd(name)
  local msg = SceneUser2_pb.ChangeNameUserCmd()
  if name ~= nil then
    msg.name = name
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallChargePlayUserCmd(chargeids)
  local msg = SceneUser2_pb.ChargePlayUserCmd()
  if chargeids ~= nil then
    for i = 1, #chargeids do
      table.insert(msg.chargeids, chargeids[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallRequireNpcFuncUserCmd(npcid, functions)
  local msg = SceneUser2_pb.RequireNpcFuncUserCmd()
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if functions ~= nil then
    for i = 1, #functions do
      table.insert(msg.functions, functions[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallCheckSeatUserCmd(seatid, success)
  local msg = SceneUser2_pb.CheckSeatUserCmd()
  if seatid ~= nil then
    msg.seatid = seatid
  end
  if success ~= nil then
    msg.success = success
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallNtfSeatUserCmd(charid, seatid, isseatdown)
  local msg = SceneUser2_pb.NtfSeatUserCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if seatid ~= nil then
    msg.seatid = seatid
  end
  if isseatdown ~= nil then
    msg.isseatdown = isseatdown
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallYoyoSeatUserCmd(guid)
  local msg = SceneUser2_pb.YoyoSeatUserCmd()
  if guid ~= nil then
    msg.guid = guid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallShowSeatUserCmd(seatid, show)
  local msg = SceneUser2_pb.ShowSeatUserCmd()
  if seatid ~= nil then
    for i = 1, #seatid do
      table.insert(msg.seatid, seatid[i])
    end
  end
  if show ~= nil then
    msg.show = show
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallSetNormalSkillOptionUserCmd(flag)
  local msg = SceneUser2_pb.SetNormalSkillOptionUserCmd()
  if flag ~= nil then
    msg.flag = flag
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallNewSetOptionUserCmd(type, flag)
  local msg = SceneUser2_pb.NewSetOptionUserCmd()
  if type ~= nil then
    msg.type = type
  end
  if flag ~= nil then
    msg.flag = flag
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUnsolvedSceneryNtfUserCmd(ids)
  local msg = SceneUser2_pb.UnsolvedSceneryNtfUserCmd()
  if ids ~= nil then
    for i = 1, #ids do
      table.insert(msg.ids, ids[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallNtfVisibleNpcUserCmd(npcs, type)
  local msg = SceneUser2_pb.NtfVisibleNpcUserCmd()
  if npcs ~= nil then
    for i = 1, #npcs do
      table.insert(msg.npcs, npcs[i])
    end
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUpyunAuthorizationCmd(authvalue)
  local msg = SceneUser2_pb.UpyunAuthorizationCmd()
  if authvalue ~= nil then
    msg.authvalue = authvalue
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallTransformPreDataCmd(datas)
  local msg = SceneUser2_pb.TransformPreDataCmd()
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUserRenameCmd(name, code)
  local msg = SceneUser2_pb.UserRenameCmd()
  if name ~= nil then
    msg.name = name
  end
  if code ~= nil then
    msg.code = code
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallBuyZenyCmd(bcoin, zeny, ret)
  local msg = SceneUser2_pb.BuyZenyCmd()
  if bcoin ~= nil then
    msg.bcoin = bcoin
  end
  if zeny ~= nil then
    msg.zeny = zeny
  end
  if ret ~= nil then
    msg.ret = ret
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallCallTeamerUserCmd(masterid, sign, time, username, mapid, pos)
  local msg = SceneUser2_pb.CallTeamerUserCmd()
  if masterid ~= nil then
    msg.masterid = masterid
  end
  if sign ~= nil then
    msg.sign = sign
  end
  if time ~= nil then
    msg.time = time
  end
  if username ~= nil then
    msg.username = username
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if pos ~= nil and pos.x ~= nil then
    msg.pos.x = pos.x
  end
  if pos ~= nil and pos.y ~= nil then
    msg.pos.y = pos.y
  end
  if pos ~= nil and pos.z ~= nil then
    msg.pos.z = pos.z
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallCallTeamerReplyUserCmd(masterid, sign, time, mapid, pos)
  local msg = SceneUser2_pb.CallTeamerReplyUserCmd()
  if masterid ~= nil then
    msg.masterid = masterid
  end
  if sign ~= nil then
    msg.sign = sign
  end
  if time ~= nil then
    msg.time = time
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if pos ~= nil and pos.x ~= nil then
    msg.pos.x = pos.x
  end
  if pos ~= nil and pos.y ~= nil then
    msg.pos.y = pos.y
  end
  if pos ~= nil and pos.z ~= nil then
    msg.pos.z = pos.z
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallSpecialEffectCmd(dramaid, starttime, times)
  local msg = SceneUser2_pb.SpecialEffectCmd()
  if dramaid ~= nil then
    msg.dramaid = dramaid
  end
  if starttime ~= nil then
    msg.starttime = starttime
  end
  if times ~= nil then
    msg.times = times
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallMarriageProposalCmd(masterid, itemid, time, mastername, sign)
  local msg = SceneUser2_pb.MarriageProposalCmd()
  if masterid ~= nil then
    msg.masterid = masterid
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if time ~= nil then
    msg.time = time
  end
  if mastername ~= nil then
    msg.mastername = mastername
  end
  if sign ~= nil then
    msg.sign = sign
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallMarriageProposalReplyCmd(masterid, reply, time, sign)
  local msg = SceneUser2_pb.MarriageProposalReplyCmd()
  if masterid ~= nil then
    msg.masterid = masterid
  end
  if reply ~= nil then
    msg.reply = reply
  end
  if time ~= nil then
    msg.time = time
  end
  if sign ~= nil then
    msg.sign = sign
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUploadWeddingPhotoUserCmd(itemguid, index, time)
  local msg = SceneUser2_pb.UploadWeddingPhotoUserCmd()
  if itemguid ~= nil then
    msg.itemguid = itemguid
  end
  if index ~= nil then
    msg.index = index
  end
  if time ~= nil then
    msg.time = time
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallMarriageProposalSuccessCmd(charid, ismaster)
  local msg = SceneUser2_pb.MarriageProposalSuccessCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if ismaster ~= nil then
    msg.ismaster = ismaster
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallInviteeWeddingStartNtfUserCmd(itemguid)
  local msg = SceneUser2_pb.InviteeWeddingStartNtfUserCmd()
  if itemguid ~= nil then
    msg.itemguid = itemguid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallKFCShareUserCmd(sharetype)
  local msg = SceneUser2_pb.KFCShareUserCmd()
  if sharetype ~= nil then
    msg.sharetype = sharetype
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallKFCEnrollUserCmd(phone)
  local msg = SceneUser2_pb.KFCEnrollUserCmd()
  if phone ~= nil then
    msg.phone = phone
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallKFCEnrollCodeUserCmd(code, district)
  local msg = SceneUser2_pb.KFCEnrollCodeUserCmd()
  if code ~= nil then
    msg.code = code
  end
  if district ~= nil then
    msg.district = district
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallKFCEnrollReplyUserCmd(result, district, index)
  local msg = SceneUser2_pb.KFCEnrollReplyUserCmd()
  if result ~= nil then
    msg.result = result
  end
  if district ~= nil then
    msg.district = district
  end
  if index ~= nil then
    msg.index = index
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallKFCEnrollQueryUserCmd()
  local msg = SceneUser2_pb.KFCEnrollQueryUserCmd()
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallKFCHasEnrolledUserCmd(hasenrolled)
  local msg = SceneUser2_pb.KFCHasEnrolledUserCmd()
  if hasenrolled ~= nil then
    msg.hasenrolled = hasenrolled
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallCheckRelationUserCmd(charid, etype, ret)
  local msg = SceneUser2_pb.CheckRelationUserCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if ret ~= nil then
    msg.ret = ret
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallTwinsActionUserCmd(userid, actionid, etype, sponsor)
  local msg = SceneUser2_pb.TwinsActionUserCmd()
  if userid ~= nil then
    msg.userid = userid
  end
  if actionid ~= nil then
    msg.actionid = actionid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if sponsor ~= nil then
    msg.sponsor = sponsor
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallShowServantUserCmd(show)
  local msg = SceneUser2_pb.ShowServantUserCmd()
  if show ~= nil then
    msg.show = show
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallReplaceServantUserCmd(replace, servant)
  local msg = SceneUser2_pb.ReplaceServantUserCmd()
  if replace ~= nil then
    msg.replace = replace
  end
  if servant ~= nil then
    msg.servant = servant
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallServantService(type)
  local msg = SceneUser2_pb.ServantService()
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallRecommendServantUserCmd(items)
  local msg = SceneUser2_pb.RecommendServantUserCmd()
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallReceiveServantUserCmd(favorability, dwid)
  local msg = SceneUser2_pb.ReceiveServantUserCmd()
  if favorability ~= nil then
    msg.favorability = favorability
  end
  if dwid ~= nil then
    msg.dwid = dwid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallServantRewardStatusUserCmd(items, stayfavo)
  local msg = SceneUser2_pb.ServantRewardStatusUserCmd()
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  if stayfavo ~= nil then
    msg.stayfavo = stayfavo
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallProfessionQueryUserCmd(items)
  local msg = SceneUser2_pb.ProfessionQueryUserCmd()
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallProfessionBuyUserCmd(branch, success, onlymoney)
  local msg = SceneUser2_pb.ProfessionBuyUserCmd()
  if branch ~= nil then
    msg.branch = branch
  end
  if success ~= nil then
    msg.success = success
  end
  if onlymoney ~= nil then
    msg.onlymoney = onlymoney
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallProfessionChangeUserCmd(branch, success)
  local msg = SceneUser2_pb.ProfessionChangeUserCmd()
  if branch ~= nil then
    msg.branch = branch
  end
  if success ~= nil then
    msg.success = success
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUpdateRecordInfoUserCmd(slots, records, delete_ids, card_expiretime, astrol_data)
  local msg = SceneUser2_pb.UpdateRecordInfoUserCmd()
  if slots ~= nil then
    for i = 1, #slots do
      table.insert(msg.slots, slots[i])
    end
  end
  if records ~= nil then
    for i = 1, #records do
      table.insert(msg.records, records[i])
    end
  end
  if delete_ids ~= nil then
    for i = 1, #delete_ids do
      table.insert(msg.delete_ids, delete_ids[i])
    end
  end
  if card_expiretime ~= nil then
    msg.card_expiretime = card_expiretime
  end
  if astrol_data ~= nil then
    for i = 1, #astrol_data do
      table.insert(msg.astrol_data, astrol_data[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallSaveRecordUserCmd(slotid, record_name)
  local msg = SceneUser2_pb.SaveRecordUserCmd()
  if slotid ~= nil then
    msg.slotid = slotid
  end
  if record_name ~= nil then
    msg.record_name = record_name
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallLoadRecordUserCmd(slotid)
  local msg = SceneUser2_pb.LoadRecordUserCmd()
  if slotid ~= nil then
    msg.slotid = slotid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallChangeRecordNameUserCmd(slotid, record_name)
  local msg = SceneUser2_pb.ChangeRecordNameUserCmd()
  if slotid ~= nil then
    msg.slotid = slotid
  end
  if record_name ~= nil then
    msg.record_name = record_name
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallBuyRecordSlotUserCmd(slotid)
  local msg = SceneUser2_pb.BuyRecordSlotUserCmd()
  if slotid ~= nil then
    msg.slotid = slotid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallDeleteRecordUserCmd(slotid)
  local msg = SceneUser2_pb.DeleteRecordUserCmd()
  if slotid ~= nil then
    msg.slotid = slotid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUpdateBranchInfoUserCmd(datas, sync_type)
  local msg = SceneUser2_pb.UpdateBranchInfoUserCmd()
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  if sync_type ~= nil then
    msg.sync_type = sync_type
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallEnterCapraActivityCmd()
  local msg = SceneUser2_pb.EnterCapraActivityCmd()
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallInviteWithMeUserCmd(sendid, time, reply, sign)
  local msg = SceneUser2_pb.InviteWithMeUserCmd()
  if sendid ~= nil then
    msg.sendid = sendid
  end
  if time ~= nil then
    msg.time = time
  end
  if reply ~= nil then
    msg.reply = reply
  end
  if sign ~= nil then
    msg.sign = sign
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallQueryAltmanKillUserCmd()
  local msg = SceneUser2_pb.QueryAltmanKillUserCmd()
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallBoothReqUserCmd(name, oper, success)
  local msg = SceneUser2_pb.BoothReqUserCmd()
  if name ~= nil then
    msg.name = name
  end
  if oper ~= nil then
    msg.oper = oper
  end
  if success ~= nil then
    msg.success = success
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallBoothInfoSyncUserCmd(charid, oper, info)
  local msg = SceneUser2_pb.BoothInfoSyncUserCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if oper ~= nil then
    msg.oper = oper
  end
  if info ~= nil and info.name ~= nil then
    msg.info.name = info.name
  end
  if info ~= nil and info.sign ~= nil then
    msg.info.sign = info.sign
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallDressUpModelUserCmd(stageid, type, value)
  local msg = SceneUser2_pb.DressUpModelUserCmd()
  if stageid ~= nil then
    msg.stageid = stageid
  end
  if type ~= nil then
    msg.type = type
  end
  if value ~= nil then
    msg.value = value
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallDressUpHeadUserCmd(type, value, puton)
  local msg = SceneUser2_pb.DressUpHeadUserCmd()
  if type ~= nil then
    msg.type = type
  end
  if value ~= nil then
    msg.value = value
  end
  if puton ~= nil then
    msg.puton = puton
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallQueryStageUserCmd(stageid, info)
  local msg = SceneUser2_pb.QueryStageUserCmd()
  if stageid ~= nil then
    msg.stageid = stageid
  end
  if info ~= nil then
    for i = 1, #info do
      table.insert(msg.info, info[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallDressUpLineUpUserCmd(stageid, mode, enter)
  local msg = SceneUser2_pb.DressUpLineUpUserCmd()
  if stageid ~= nil then
    msg.stageid = stageid
  end
  if mode ~= nil then
    msg.mode = mode
  end
  if enter ~= nil then
    msg.enter = enter
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallDressUpStageUserCmd(userid, stageid, datas)
  local msg = SceneUser2_pb.DressUpStageUserCmd()
  if userid ~= nil then
    for i = 1, #userid do
      table.insert(msg.userid, userid[i])
    end
  end
  if stageid ~= nil then
    msg.stageid = stageid
  end
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallGoToFunctionMapUserCmd(etype)
  local msg = SceneUser2_pb.GoToFunctionMapUserCmd()
  msg.etype = etype
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallGrowthServantUserCmd(datas, unlockitems)
  local msg = SceneUser2_pb.GrowthServantUserCmd()
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  if unlockitems ~= nil then
    for i = 1, #unlockitems do
      table.insert(msg.unlockitems, unlockitems[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallReceiveGrowthServantUserCmd(dwid, dwvalue)
  local msg = SceneUser2_pb.ReceiveGrowthServantUserCmd()
  if dwid ~= nil then
    msg.dwid = dwid
  end
  if dwvalue ~= nil then
    msg.dwvalue = dwvalue
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallGrowthOpenServantUserCmd(groupid)
  local msg = SceneUser2_pb.GrowthOpenServantUserCmd()
  if groupid ~= nil then
    msg.groupid = groupid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallCheatTagUserCmd(interval, frame)
  local msg = SceneUser2_pb.CheatTagUserCmd()
  if interval ~= nil then
    msg.interval = interval
  end
  if frame ~= nil then
    msg.frame = frame
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallCheatTagStatUserCmd(cheated, clickmvpthreshold, buttonthreshold)
  local msg = SceneUser2_pb.CheatTagStatUserCmd()
  if cheated ~= nil then
    msg.cheated = cheated
  end
  if clickmvpthreshold ~= nil then
    msg.clickmvpthreshold = clickmvpthreshold
  end
  if buttonthreshold ~= nil then
    for i = 1, #buttonthreshold do
      table.insert(msg.buttonthreshold, buttonthreshold[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallClickPosList(clickbuttonpos)
  local msg = SceneUser2_pb.ClickPosList()
  if clickbuttonpos ~= nil then
    for i = 1, #clickbuttonpos do
      table.insert(msg.clickbuttonpos, clickbuttonpos[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallSignInUserCmd(success)
  local msg = SceneUser2_pb.SignInUserCmd()
  if success ~= nil then
    msg.success = success
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallSignInNtfUserCmd(count, issign, isshowed)
  local msg = SceneUser2_pb.SignInNtfUserCmd()
  if count ~= nil then
    msg.count = count
  end
  if issign ~= nil then
    msg.issign = issign
  end
  if isshowed ~= nil then
    msg.isshowed = isshowed
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallBeatPoriUserCmd(start, success)
  local msg = SceneUser2_pb.BeatPoriUserCmd()
  if start ~= nil then
    msg.start = start
  end
  if success ~= nil then
    msg.success = success
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallUnlockFrameUserCmd(frameid)
  local msg = SceneUser2_pb.UnlockFrameUserCmd()
  if frameid ~= nil then
    for i = 1, #frameid do
      table.insert(msg.frameid, frameid[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallAltmanRewardUserCmd(passtime, items, getrewardid)
  local msg = SceneUser2_pb.AltmanRewardUserCmd()
  if passtime ~= nil then
    msg.passtime = passtime
  end
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  if getrewardid ~= nil then
    msg.getrewardid = getrewardid
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallServantReqReservationUserCmd(actid, time, reservation, type)
  local msg = SceneUser2_pb.ServantReqReservationUserCmd()
  if actid ~= nil then
    msg.actid = actid
  end
  if time ~= nil then
    msg.time = time
  end
  if reservation ~= nil then
    msg.reservation = reservation
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallServantReservationUserCmd(datas, opt)
  local msg = SceneUser2_pb.ServantReservationUserCmd()
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  if opt ~= nil then
    msg.opt = opt
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:CallServantRecEquipUserCmd(datas)
  local msg = SceneUser2_pb.ServantRecEquipUserCmd()
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  self:SendProto(msg)
end
function ServiceNUserAutoProxy:RecvGoCity(data)
  self:Notify(ServiceEvent.NUserGoCity, data)
end
function ServiceNUserAutoProxy:RecvSysMsg(data)
  self:Notify(ServiceEvent.NUserSysMsg, data)
end
function ServiceNUserAutoProxy:RecvNpcDataSync(data)
  self:Notify(ServiceEvent.NUserNpcDataSync, data)
end
function ServiceNUserAutoProxy:RecvUserNineSyncCmd(data)
  self:Notify(ServiceEvent.NUserUserNineSyncCmd, data)
end
function ServiceNUserAutoProxy:RecvUserActionNtf(data)
  self:Notify(ServiceEvent.NUserUserActionNtf, data)
end
function ServiceNUserAutoProxy:RecvUserBuffNineSyncCmd(data)
  self:Notify(ServiceEvent.NUserUserBuffNineSyncCmd, data)
end
function ServiceNUserAutoProxy:RecvExitPosUserCmd(data)
  self:Notify(ServiceEvent.NUserExitPosUserCmd, data)
end
function ServiceNUserAutoProxy:RecvRelive(data)
  self:Notify(ServiceEvent.NUserRelive, data)
end
function ServiceNUserAutoProxy:RecvVarUpdate(data)
  self:Notify(ServiceEvent.NUserVarUpdate, data)
end
function ServiceNUserAutoProxy:RecvTalkInfo(data)
  self:Notify(ServiceEvent.NUserTalkInfo, data)
end
function ServiceNUserAutoProxy:RecvServerTime(data)
  self:Notify(ServiceEvent.NUserServerTime, data)
end
function ServiceNUserAutoProxy:RecvEffectUserCmd(data)
  self:Notify(ServiceEvent.NUserEffectUserCmd, data)
end
function ServiceNUserAutoProxy:RecvMenuList(data)
  self:Notify(ServiceEvent.NUserMenuList, data)
end
function ServiceNUserAutoProxy:RecvNewMenu(data)
  self:Notify(ServiceEvent.NUserNewMenu, data)
end
function ServiceNUserAutoProxy:RecvTeamInfoNine(data)
  self:Notify(ServiceEvent.NUserTeamInfoNine, data)
end
function ServiceNUserAutoProxy:RecvUsePortrait(data)
  self:Notify(ServiceEvent.NUserUsePortrait, data)
end
function ServiceNUserAutoProxy:RecvUseFrame(data)
  self:Notify(ServiceEvent.NUserUseFrame, data)
end
function ServiceNUserAutoProxy:RecvNewPortraitFrame(data)
  self:Notify(ServiceEvent.NUserNewPortraitFrame, data)
end
function ServiceNUserAutoProxy:RecvQueryPortraitListUserCmd(data)
  self:Notify(ServiceEvent.NUserQueryPortraitListUserCmd, data)
end
function ServiceNUserAutoProxy:RecvUseDressing(data)
  self:Notify(ServiceEvent.NUserUseDressing, data)
end
function ServiceNUserAutoProxy:RecvNewDressing(data)
  self:Notify(ServiceEvent.NUserNewDressing, data)
end
function ServiceNUserAutoProxy:RecvDressingListUserCmd(data)
  self:Notify(ServiceEvent.NUserDressingListUserCmd, data)
end
function ServiceNUserAutoProxy:RecvAddAttrPoint(data)
  self:Notify(ServiceEvent.NUserAddAttrPoint, data)
end
function ServiceNUserAutoProxy:RecvQueryShopGotItem(data)
  self:Notify(ServiceEvent.NUserQueryShopGotItem, data)
end
function ServiceNUserAutoProxy:RecvUpdateShopGotItem(data)
  self:Notify(ServiceEvent.NUserUpdateShopGotItem, data)
end
function ServiceNUserAutoProxy:RecvOpenUI(data)
  self:Notify(ServiceEvent.NUserOpenUI, data)
end
function ServiceNUserAutoProxy:RecvDbgSysMsg(data)
  self:Notify(ServiceEvent.NUserDbgSysMsg, data)
end
function ServiceNUserAutoProxy:RecvFollowTransferCmd(data)
  self:Notify(ServiceEvent.NUserFollowTransferCmd, data)
end
function ServiceNUserAutoProxy:RecvCallNpcFuncCmd(data)
  self:Notify(ServiceEvent.NUserCallNpcFuncCmd, data)
end
function ServiceNUserAutoProxy:RecvModelShow(data)
  self:Notify(ServiceEvent.NUserModelShow, data)
end
function ServiceNUserAutoProxy:RecvSoundEffectCmd(data)
  self:Notify(ServiceEvent.NUserSoundEffectCmd, data)
end
function ServiceNUserAutoProxy:RecvPresetMsgCmd(data)
  self:Notify(ServiceEvent.NUserPresetMsgCmd, data)
end
function ServiceNUserAutoProxy:RecvChangeBgmCmd(data)
  self:Notify(ServiceEvent.NUserChangeBgmCmd, data)
end
function ServiceNUserAutoProxy:RecvQueryFighterInfo(data)
  self:Notify(ServiceEvent.NUserQueryFighterInfo, data)
end
function ServiceNUserAutoProxy:RecvGameTimeCmd(data)
  self:Notify(ServiceEvent.NUserGameTimeCmd, data)
end
function ServiceNUserAutoProxy:RecvCDTimeUserCmd(data)
  self:Notify(ServiceEvent.NUserCDTimeUserCmd, data)
end
function ServiceNUserAutoProxy:RecvStateChange(data)
  self:Notify(ServiceEvent.NUserStateChange, data)
end
function ServiceNUserAutoProxy:RecvPhoto(data)
  self:Notify(ServiceEvent.NUserPhoto, data)
end
function ServiceNUserAutoProxy:RecvShakeScreen(data)
  self:Notify(ServiceEvent.NUserShakeScreen, data)
end
function ServiceNUserAutoProxy:RecvQueryShortcut(data)
  self:Notify(ServiceEvent.NUserQueryShortcut, data)
end
function ServiceNUserAutoProxy:RecvPutShortcut(data)
  self:Notify(ServiceEvent.NUserPutShortcut, data)
end
function ServiceNUserAutoProxy:RecvNpcChangeAngle(data)
  self:Notify(ServiceEvent.NUserNpcChangeAngle, data)
end
function ServiceNUserAutoProxy:RecvCameraFocus(data)
  self:Notify(ServiceEvent.NUserCameraFocus, data)
end
function ServiceNUserAutoProxy:RecvGoToListUserCmd(data)
  self:Notify(ServiceEvent.NUserGoToListUserCmd, data)
end
function ServiceNUserAutoProxy:RecvGoToGearUserCmd(data)
  self:Notify(ServiceEvent.NUserGoToGearUserCmd, data)
end
function ServiceNUserAutoProxy:RecvNewTransMapCmd(data)
  self:Notify(ServiceEvent.NUserNewTransMapCmd, data)
end
function ServiceNUserAutoProxy:RecvDeathTransferListCmd(data)
  self:Notify(ServiceEvent.NUserDeathTransferListCmd, data)
end
function ServiceNUserAutoProxy:RecvNewDeathTransferCmd(data)
  self:Notify(ServiceEvent.NUserNewDeathTransferCmd, data)
end
function ServiceNUserAutoProxy:RecvUseDeathTransferCmd(data)
  self:Notify(ServiceEvent.NUserUseDeathTransferCmd, data)
end
function ServiceNUserAutoProxy:RecvFollowerUser(data)
  self:Notify(ServiceEvent.NUserFollowerUser, data)
end
function ServiceNUserAutoProxy:RecvBeFollowUserCmd(data)
  self:Notify(ServiceEvent.NUserBeFollowUserCmd, data)
end
function ServiceNUserAutoProxy:RecvLaboratoryUserCmd(data)
  self:Notify(ServiceEvent.NUserLaboratoryUserCmd, data)
end
function ServiceNUserAutoProxy:RecvGotoLaboratoryUserCmd(data)
  self:Notify(ServiceEvent.NUserGotoLaboratoryUserCmd, data)
end
function ServiceNUserAutoProxy:RecvExchangeProfession(data)
  self:Notify(ServiceEvent.NUserExchangeProfession, data)
end
function ServiceNUserAutoProxy:RecvSceneryUserCmd(data)
  self:Notify(ServiceEvent.NUserSceneryUserCmd, data)
end
function ServiceNUserAutoProxy:RecvGoMapQuestUserCmd(data)
  self:Notify(ServiceEvent.NUserGoMapQuestUserCmd, data)
end
function ServiceNUserAutoProxy:RecvGoMapFollowUserCmd(data)
  self:Notify(ServiceEvent.NUserGoMapFollowUserCmd, data)
end
function ServiceNUserAutoProxy:RecvUserAutoHitCmd(data)
  self:Notify(ServiceEvent.NUserUserAutoHitCmd, data)
end
function ServiceNUserAutoProxy:RecvUploadSceneryPhotoUserCmd(data)
  self:Notify(ServiceEvent.NUserUploadSceneryPhotoUserCmd, data)
end
function ServiceNUserAutoProxy:RecvDownloadSceneryPhotoUserCmd(data)
  self:Notify(ServiceEvent.NUserDownloadSceneryPhotoUserCmd, data)
end
function ServiceNUserAutoProxy:RecvQueryMapArea(data)
  self:Notify(ServiceEvent.NUserQueryMapArea, data)
end
function ServiceNUserAutoProxy:RecvNewMapAreaNtf(data)
  self:Notify(ServiceEvent.NUserNewMapAreaNtf, data)
end
function ServiceNUserAutoProxy:RecvBuffForeverCmd(data)
  self:Notify(ServiceEvent.NUserBuffForeverCmd, data)
end
function ServiceNUserAutoProxy:RecvInviteJoinHandsUserCmd(data)
  self:Notify(ServiceEvent.NUserInviteJoinHandsUserCmd, data)
end
function ServiceNUserAutoProxy:RecvBreakUpHandsUserCmd(data)
  self:Notify(ServiceEvent.NUserBreakUpHandsUserCmd, data)
end
function ServiceNUserAutoProxy:RecvHandStatusUserCmd(data)
  self:Notify(ServiceEvent.NUserHandStatusUserCmd, data)
end
function ServiceNUserAutoProxy:RecvQueryShow(data)
  self:Notify(ServiceEvent.NUserQueryShow, data)
end
function ServiceNUserAutoProxy:RecvQueryMusicList(data)
  self:Notify(ServiceEvent.NUserQueryMusicList, data)
end
function ServiceNUserAutoProxy:RecvDemandMusic(data)
  self:Notify(ServiceEvent.NUserDemandMusic, data)
end
function ServiceNUserAutoProxy:RecvCloseMusicFrame(data)
  self:Notify(ServiceEvent.NUserCloseMusicFrame, data)
end
function ServiceNUserAutoProxy:RecvUploadOkSceneryUserCmd(data)
  self:Notify(ServiceEvent.NUserUploadOkSceneryUserCmd, data)
end
function ServiceNUserAutoProxy:RecvJoinHandsUserCmd(data)
  self:Notify(ServiceEvent.NUserJoinHandsUserCmd, data)
end
function ServiceNUserAutoProxy:RecvQueryTraceList(data)
  self:Notify(ServiceEvent.NUserQueryTraceList, data)
end
function ServiceNUserAutoProxy:RecvUpdateTraceList(data)
  self:Notify(ServiceEvent.NUserUpdateTraceList, data)
end
function ServiceNUserAutoProxy:RecvSetDirection(data)
  self:Notify(ServiceEvent.NUserSetDirection, data)
end
function ServiceNUserAutoProxy:RecvBattleTimelenUserCmd(data)
  self:Notify(ServiceEvent.NUserBattleTimelenUserCmd, data)
end
function ServiceNUserAutoProxy:RecvSetOptionUserCmd(data)
  self:Notify(ServiceEvent.NUserSetOptionUserCmd, data)
end
function ServiceNUserAutoProxy:RecvQueryUserInfoUserCmd(data)
  self:Notify(ServiceEvent.NUserQueryUserInfoUserCmd, data)
end
function ServiceNUserAutoProxy:RecvCountDownTickUserCmd(data)
  self:Notify(ServiceEvent.NUserCountDownTickUserCmd, data)
end
function ServiceNUserAutoProxy:RecvItemMusicNtfUserCmd(data)
  self:Notify(ServiceEvent.NUserItemMusicNtfUserCmd, data)
end
function ServiceNUserAutoProxy:RecvShakeTreeUserCmd(data)
  self:Notify(ServiceEvent.NUserShakeTreeUserCmd, data)
end
function ServiceNUserAutoProxy:RecvTreeListUserCmd(data)
  self:Notify(ServiceEvent.NUserTreeListUserCmd, data)
end
function ServiceNUserAutoProxy:RecvActivityNtfUserCmd(data)
  self:Notify(ServiceEvent.NUserActivityNtfUserCmd, data)
end
function ServiceNUserAutoProxy:RecvQueryZoneStatusUserCmd(data)
  self:Notify(ServiceEvent.NUserQueryZoneStatusUserCmd, data)
end
function ServiceNUserAutoProxy:RecvJumpZoneUserCmd(data)
  self:Notify(ServiceEvent.NUserJumpZoneUserCmd, data)
end
function ServiceNUserAutoProxy:RecvItemImageUserNtfUserCmd(data)
  self:Notify(ServiceEvent.NUserItemImageUserNtfUserCmd, data)
end
function ServiceNUserAutoProxy:RecvInviteFollowUserCmd(data)
  self:Notify(ServiceEvent.NUserInviteFollowUserCmd, data)
end
function ServiceNUserAutoProxy:RecvChangeNameUserCmd(data)
  self:Notify(ServiceEvent.NUserChangeNameUserCmd, data)
end
function ServiceNUserAutoProxy:RecvChargePlayUserCmd(data)
  self:Notify(ServiceEvent.NUserChargePlayUserCmd, data)
end
function ServiceNUserAutoProxy:RecvRequireNpcFuncUserCmd(data)
  self:Notify(ServiceEvent.NUserRequireNpcFuncUserCmd, data)
end
function ServiceNUserAutoProxy:RecvCheckSeatUserCmd(data)
  self:Notify(ServiceEvent.NUserCheckSeatUserCmd, data)
end
function ServiceNUserAutoProxy:RecvNtfSeatUserCmd(data)
  self:Notify(ServiceEvent.NUserNtfSeatUserCmd, data)
end
function ServiceNUserAutoProxy:RecvYoyoSeatUserCmd(data)
  self:Notify(ServiceEvent.NUserYoyoSeatUserCmd, data)
end
function ServiceNUserAutoProxy:RecvShowSeatUserCmd(data)
  self:Notify(ServiceEvent.NUserShowSeatUserCmd, data)
end
function ServiceNUserAutoProxy:RecvSetNormalSkillOptionUserCmd(data)
  self:Notify(ServiceEvent.NUserSetNormalSkillOptionUserCmd, data)
end
function ServiceNUserAutoProxy:RecvNewSetOptionUserCmd(data)
  self:Notify(ServiceEvent.NUserNewSetOptionUserCmd, data)
end
function ServiceNUserAutoProxy:RecvUnsolvedSceneryNtfUserCmd(data)
  self:Notify(ServiceEvent.NUserUnsolvedSceneryNtfUserCmd, data)
end
function ServiceNUserAutoProxy:RecvNtfVisibleNpcUserCmd(data)
  self:Notify(ServiceEvent.NUserNtfVisibleNpcUserCmd, data)
end
function ServiceNUserAutoProxy:RecvUpyunAuthorizationCmd(data)
  self:Notify(ServiceEvent.NUserUpyunAuthorizationCmd, data)
end
function ServiceNUserAutoProxy:RecvTransformPreDataCmd(data)
  self:Notify(ServiceEvent.NUserTransformPreDataCmd, data)
end
function ServiceNUserAutoProxy:RecvUserRenameCmd(data)
  self:Notify(ServiceEvent.NUserUserRenameCmd, data)
end
function ServiceNUserAutoProxy:RecvBuyZenyCmd(data)
  self:Notify(ServiceEvent.NUserBuyZenyCmd, data)
end
function ServiceNUserAutoProxy:RecvCallTeamerUserCmd(data)
  self:Notify(ServiceEvent.NUserCallTeamerUserCmd, data)
end
function ServiceNUserAutoProxy:RecvCallTeamerReplyUserCmd(data)
  self:Notify(ServiceEvent.NUserCallTeamerReplyUserCmd, data)
end
function ServiceNUserAutoProxy:RecvSpecialEffectCmd(data)
  self:Notify(ServiceEvent.NUserSpecialEffectCmd, data)
end
function ServiceNUserAutoProxy:RecvMarriageProposalCmd(data)
  self:Notify(ServiceEvent.NUserMarriageProposalCmd, data)
end
function ServiceNUserAutoProxy:RecvMarriageProposalReplyCmd(data)
  self:Notify(ServiceEvent.NUserMarriageProposalReplyCmd, data)
end
function ServiceNUserAutoProxy:RecvUploadWeddingPhotoUserCmd(data)
  self:Notify(ServiceEvent.NUserUploadWeddingPhotoUserCmd, data)
end
function ServiceNUserAutoProxy:RecvMarriageProposalSuccessCmd(data)
  self:Notify(ServiceEvent.NUserMarriageProposalSuccessCmd, data)
end
function ServiceNUserAutoProxy:RecvInviteeWeddingStartNtfUserCmd(data)
  self:Notify(ServiceEvent.NUserInviteeWeddingStartNtfUserCmd, data)
end
function ServiceNUserAutoProxy:RecvKFCShareUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCShareUserCmd, data)
end
function ServiceNUserAutoProxy:RecvKFCEnrollUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCEnrollUserCmd, data)
end
function ServiceNUserAutoProxy:RecvKFCEnrollCodeUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCEnrollCodeUserCmd, data)
end
function ServiceNUserAutoProxy:RecvKFCEnrollReplyUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCEnrollReplyUserCmd, data)
end
function ServiceNUserAutoProxy:RecvKFCEnrollQueryUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCEnrollQueryUserCmd, data)
end
function ServiceNUserAutoProxy:RecvKFCHasEnrolledUserCmd(data)
  self:Notify(ServiceEvent.NUserKFCHasEnrolledUserCmd, data)
end
function ServiceNUserAutoProxy:RecvCheckRelationUserCmd(data)
  self:Notify(ServiceEvent.NUserCheckRelationUserCmd, data)
end
function ServiceNUserAutoProxy:RecvTwinsActionUserCmd(data)
  self:Notify(ServiceEvent.NUserTwinsActionUserCmd, data)
end
function ServiceNUserAutoProxy:RecvShowServantUserCmd(data)
  self:Notify(ServiceEvent.NUserShowServantUserCmd, data)
end
function ServiceNUserAutoProxy:RecvReplaceServantUserCmd(data)
  self:Notify(ServiceEvent.NUserReplaceServantUserCmd, data)
end
function ServiceNUserAutoProxy:RecvServantService(data)
  self:Notify(ServiceEvent.NUserServantService, data)
end
function ServiceNUserAutoProxy:RecvRecommendServantUserCmd(data)
  self:Notify(ServiceEvent.NUserRecommendServantUserCmd, data)
end
function ServiceNUserAutoProxy:RecvReceiveServantUserCmd(data)
  self:Notify(ServiceEvent.NUserReceiveServantUserCmd, data)
end
function ServiceNUserAutoProxy:RecvServantRewardStatusUserCmd(data)
  self:Notify(ServiceEvent.NUserServantRewardStatusUserCmd, data)
end
function ServiceNUserAutoProxy:RecvProfessionQueryUserCmd(data)
  self:Notify(ServiceEvent.NUserProfessionQueryUserCmd, data)
end
function ServiceNUserAutoProxy:RecvProfessionBuyUserCmd(data)
  self:Notify(ServiceEvent.NUserProfessionBuyUserCmd, data)
end
function ServiceNUserAutoProxy:RecvProfessionChangeUserCmd(data)
  self:Notify(ServiceEvent.NUserProfessionChangeUserCmd, data)
end
function ServiceNUserAutoProxy:RecvUpdateRecordInfoUserCmd(data)
  self:Notify(ServiceEvent.NUserUpdateRecordInfoUserCmd, data)
end
function ServiceNUserAutoProxy:RecvSaveRecordUserCmd(data)
  self:Notify(ServiceEvent.NUserSaveRecordUserCmd, data)
end
function ServiceNUserAutoProxy:RecvLoadRecordUserCmd(data)
  self:Notify(ServiceEvent.NUserLoadRecordUserCmd, data)
end
function ServiceNUserAutoProxy:RecvChangeRecordNameUserCmd(data)
  self:Notify(ServiceEvent.NUserChangeRecordNameUserCmd, data)
end
function ServiceNUserAutoProxy:RecvBuyRecordSlotUserCmd(data)
  self:Notify(ServiceEvent.NUserBuyRecordSlotUserCmd, data)
end
function ServiceNUserAutoProxy:RecvDeleteRecordUserCmd(data)
  self:Notify(ServiceEvent.NUserDeleteRecordUserCmd, data)
end
function ServiceNUserAutoProxy:RecvUpdateBranchInfoUserCmd(data)
  self:Notify(ServiceEvent.NUserUpdateBranchInfoUserCmd, data)
end
function ServiceNUserAutoProxy:RecvEnterCapraActivityCmd(data)
  self:Notify(ServiceEvent.NUserEnterCapraActivityCmd, data)
end
function ServiceNUserAutoProxy:RecvInviteWithMeUserCmd(data)
  self:Notify(ServiceEvent.NUserInviteWithMeUserCmd, data)
end
function ServiceNUserAutoProxy:RecvQueryAltmanKillUserCmd(data)
  self:Notify(ServiceEvent.NUserQueryAltmanKillUserCmd, data)
end
function ServiceNUserAutoProxy:RecvBoothReqUserCmd(data)
  self:Notify(ServiceEvent.NUserBoothReqUserCmd, data)
end
function ServiceNUserAutoProxy:RecvBoothInfoSyncUserCmd(data)
  self:Notify(ServiceEvent.NUserBoothInfoSyncUserCmd, data)
end
function ServiceNUserAutoProxy:RecvDressUpModelUserCmd(data)
  self:Notify(ServiceEvent.NUserDressUpModelUserCmd, data)
end
function ServiceNUserAutoProxy:RecvDressUpHeadUserCmd(data)
  self:Notify(ServiceEvent.NUserDressUpHeadUserCmd, data)
end
function ServiceNUserAutoProxy:RecvQueryStageUserCmd(data)
  self:Notify(ServiceEvent.NUserQueryStageUserCmd, data)
end
function ServiceNUserAutoProxy:RecvDressUpLineUpUserCmd(data)
  self:Notify(ServiceEvent.NUserDressUpLineUpUserCmd, data)
end
function ServiceNUserAutoProxy:RecvDressUpStageUserCmd(data)
  self:Notify(ServiceEvent.NUserDressUpStageUserCmd, data)
end
function ServiceNUserAutoProxy:RecvGoToFunctionMapUserCmd(data)
  self:Notify(ServiceEvent.NUserGoToFunctionMapUserCmd, data)
end
function ServiceNUserAutoProxy:RecvGrowthServantUserCmd(data)
  self:Notify(ServiceEvent.NUserGrowthServantUserCmd, data)
end
function ServiceNUserAutoProxy:RecvReceiveGrowthServantUserCmd(data)
  self:Notify(ServiceEvent.NUserReceiveGrowthServantUserCmd, data)
end
function ServiceNUserAutoProxy:RecvGrowthOpenServantUserCmd(data)
  self:Notify(ServiceEvent.NUserGrowthOpenServantUserCmd, data)
end
function ServiceNUserAutoProxy:RecvCheatTagUserCmd(data)
  self:Notify(ServiceEvent.NUserCheatTagUserCmd, data)
end
function ServiceNUserAutoProxy:RecvCheatTagStatUserCmd(data)
  self:Notify(ServiceEvent.NUserCheatTagStatUserCmd, data)
end
function ServiceNUserAutoProxy:RecvClickPosList(data)
  self:Notify(ServiceEvent.NUserClickPosList, data)
end
function ServiceNUserAutoProxy:RecvSignInUserCmd(data)
  self:Notify(ServiceEvent.NUserSignInUserCmd, data)
end
function ServiceNUserAutoProxy:RecvSignInNtfUserCmd(data)
  self:Notify(ServiceEvent.NUserSignInNtfUserCmd, data)
end
function ServiceNUserAutoProxy:RecvBeatPoriUserCmd(data)
  self:Notify(ServiceEvent.NUserBeatPoriUserCmd, data)
end
function ServiceNUserAutoProxy:RecvUnlockFrameUserCmd(data)
  self:Notify(ServiceEvent.NUserUnlockFrameUserCmd, data)
end
function ServiceNUserAutoProxy:RecvAltmanRewardUserCmd(data)
  self:Notify(ServiceEvent.NUserAltmanRewardUserCmd, data)
end
function ServiceNUserAutoProxy:RecvServantReqReservationUserCmd(data)
  self:Notify(ServiceEvent.NUserServantReqReservationUserCmd, data)
end
function ServiceNUserAutoProxy:RecvServantReservationUserCmd(data)
  self:Notify(ServiceEvent.NUserServantReservationUserCmd, data)
end
function ServiceNUserAutoProxy:RecvServantRecEquipUserCmd(data)
  self:Notify(ServiceEvent.NUserServantRecEquipUserCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.NUserGoCity = "ServiceEvent_NUserGoCity"
ServiceEvent.NUserSysMsg = "ServiceEvent_NUserSysMsg"
ServiceEvent.NUserNpcDataSync = "ServiceEvent_NUserNpcDataSync"
ServiceEvent.NUserUserNineSyncCmd = "ServiceEvent_NUserUserNineSyncCmd"
ServiceEvent.NUserUserActionNtf = "ServiceEvent_NUserUserActionNtf"
ServiceEvent.NUserUserBuffNineSyncCmd = "ServiceEvent_NUserUserBuffNineSyncCmd"
ServiceEvent.NUserExitPosUserCmd = "ServiceEvent_NUserExitPosUserCmd"
ServiceEvent.NUserRelive = "ServiceEvent_NUserRelive"
ServiceEvent.NUserVarUpdate = "ServiceEvent_NUserVarUpdate"
ServiceEvent.NUserTalkInfo = "ServiceEvent_NUserTalkInfo"
ServiceEvent.NUserServerTime = "ServiceEvent_NUserServerTime"
ServiceEvent.NUserEffectUserCmd = "ServiceEvent_NUserEffectUserCmd"
ServiceEvent.NUserMenuList = "ServiceEvent_NUserMenuList"
ServiceEvent.NUserNewMenu = "ServiceEvent_NUserNewMenu"
ServiceEvent.NUserTeamInfoNine = "ServiceEvent_NUserTeamInfoNine"
ServiceEvent.NUserUsePortrait = "ServiceEvent_NUserUsePortrait"
ServiceEvent.NUserUseFrame = "ServiceEvent_NUserUseFrame"
ServiceEvent.NUserNewPortraitFrame = "ServiceEvent_NUserNewPortraitFrame"
ServiceEvent.NUserQueryPortraitListUserCmd = "ServiceEvent_NUserQueryPortraitListUserCmd"
ServiceEvent.NUserUseDressing = "ServiceEvent_NUserUseDressing"
ServiceEvent.NUserNewDressing = "ServiceEvent_NUserNewDressing"
ServiceEvent.NUserDressingListUserCmd = "ServiceEvent_NUserDressingListUserCmd"
ServiceEvent.NUserAddAttrPoint = "ServiceEvent_NUserAddAttrPoint"
ServiceEvent.NUserQueryShopGotItem = "ServiceEvent_NUserQueryShopGotItem"
ServiceEvent.NUserUpdateShopGotItem = "ServiceEvent_NUserUpdateShopGotItem"
ServiceEvent.NUserOpenUI = "ServiceEvent_NUserOpenUI"
ServiceEvent.NUserDbgSysMsg = "ServiceEvent_NUserDbgSysMsg"
ServiceEvent.NUserFollowTransferCmd = "ServiceEvent_NUserFollowTransferCmd"
ServiceEvent.NUserCallNpcFuncCmd = "ServiceEvent_NUserCallNpcFuncCmd"
ServiceEvent.NUserModelShow = "ServiceEvent_NUserModelShow"
ServiceEvent.NUserSoundEffectCmd = "ServiceEvent_NUserSoundEffectCmd"
ServiceEvent.NUserPresetMsgCmd = "ServiceEvent_NUserPresetMsgCmd"
ServiceEvent.NUserChangeBgmCmd = "ServiceEvent_NUserChangeBgmCmd"
ServiceEvent.NUserQueryFighterInfo = "ServiceEvent_NUserQueryFighterInfo"
ServiceEvent.NUserGameTimeCmd = "ServiceEvent_NUserGameTimeCmd"
ServiceEvent.NUserCDTimeUserCmd = "ServiceEvent_NUserCDTimeUserCmd"
ServiceEvent.NUserStateChange = "ServiceEvent_NUserStateChange"
ServiceEvent.NUserPhoto = "ServiceEvent_NUserPhoto"
ServiceEvent.NUserShakeScreen = "ServiceEvent_NUserShakeScreen"
ServiceEvent.NUserQueryShortcut = "ServiceEvent_NUserQueryShortcut"
ServiceEvent.NUserPutShortcut = "ServiceEvent_NUserPutShortcut"
ServiceEvent.NUserNpcChangeAngle = "ServiceEvent_NUserNpcChangeAngle"
ServiceEvent.NUserCameraFocus = "ServiceEvent_NUserCameraFocus"
ServiceEvent.NUserGoToListUserCmd = "ServiceEvent_NUserGoToListUserCmd"
ServiceEvent.NUserGoToGearUserCmd = "ServiceEvent_NUserGoToGearUserCmd"
ServiceEvent.NUserNewTransMapCmd = "ServiceEvent_NUserNewTransMapCmd"
ServiceEvent.NUserDeathTransferListCmd = "ServiceEvent_NUserDeathTransferListCmd"
ServiceEvent.NUserNewDeathTransferCmd = "ServiceEvent_NUserNewDeathTransferCmd"
ServiceEvent.NUserUseDeathTransferCmd = "ServiceEvent_NUserUseDeathTransferCmd"
ServiceEvent.NUserFollowerUser = "ServiceEvent_NUserFollowerUser"
ServiceEvent.NUserBeFollowUserCmd = "ServiceEvent_NUserBeFollowUserCmd"
ServiceEvent.NUserLaboratoryUserCmd = "ServiceEvent_NUserLaboratoryUserCmd"
ServiceEvent.NUserGotoLaboratoryUserCmd = "ServiceEvent_NUserGotoLaboratoryUserCmd"
ServiceEvent.NUserExchangeProfession = "ServiceEvent_NUserExchangeProfession"
ServiceEvent.NUserSceneryUserCmd = "ServiceEvent_NUserSceneryUserCmd"
ServiceEvent.NUserGoMapQuestUserCmd = "ServiceEvent_NUserGoMapQuestUserCmd"
ServiceEvent.NUserGoMapFollowUserCmd = "ServiceEvent_NUserGoMapFollowUserCmd"
ServiceEvent.NUserUserAutoHitCmd = "ServiceEvent_NUserUserAutoHitCmd"
ServiceEvent.NUserUploadSceneryPhotoUserCmd = "ServiceEvent_NUserUploadSceneryPhotoUserCmd"
ServiceEvent.NUserDownloadSceneryPhotoUserCmd = "ServiceEvent_NUserDownloadSceneryPhotoUserCmd"
ServiceEvent.NUserQueryMapArea = "ServiceEvent_NUserQueryMapArea"
ServiceEvent.NUserNewMapAreaNtf = "ServiceEvent_NUserNewMapAreaNtf"
ServiceEvent.NUserBuffForeverCmd = "ServiceEvent_NUserBuffForeverCmd"
ServiceEvent.NUserInviteJoinHandsUserCmd = "ServiceEvent_NUserInviteJoinHandsUserCmd"
ServiceEvent.NUserBreakUpHandsUserCmd = "ServiceEvent_NUserBreakUpHandsUserCmd"
ServiceEvent.NUserHandStatusUserCmd = "ServiceEvent_NUserHandStatusUserCmd"
ServiceEvent.NUserQueryShow = "ServiceEvent_NUserQueryShow"
ServiceEvent.NUserQueryMusicList = "ServiceEvent_NUserQueryMusicList"
ServiceEvent.NUserDemandMusic = "ServiceEvent_NUserDemandMusic"
ServiceEvent.NUserCloseMusicFrame = "ServiceEvent_NUserCloseMusicFrame"
ServiceEvent.NUserUploadOkSceneryUserCmd = "ServiceEvent_NUserUploadOkSceneryUserCmd"
ServiceEvent.NUserJoinHandsUserCmd = "ServiceEvent_NUserJoinHandsUserCmd"
ServiceEvent.NUserQueryTraceList = "ServiceEvent_NUserQueryTraceList"
ServiceEvent.NUserUpdateTraceList = "ServiceEvent_NUserUpdateTraceList"
ServiceEvent.NUserSetDirection = "ServiceEvent_NUserSetDirection"
ServiceEvent.NUserBattleTimelenUserCmd = "ServiceEvent_NUserBattleTimelenUserCmd"
ServiceEvent.NUserSetOptionUserCmd = "ServiceEvent_NUserSetOptionUserCmd"
ServiceEvent.NUserQueryUserInfoUserCmd = "ServiceEvent_NUserQueryUserInfoUserCmd"
ServiceEvent.NUserCountDownTickUserCmd = "ServiceEvent_NUserCountDownTickUserCmd"
ServiceEvent.NUserItemMusicNtfUserCmd = "ServiceEvent_NUserItemMusicNtfUserCmd"
ServiceEvent.NUserShakeTreeUserCmd = "ServiceEvent_NUserShakeTreeUserCmd"
ServiceEvent.NUserTreeListUserCmd = "ServiceEvent_NUserTreeListUserCmd"
ServiceEvent.NUserActivityNtfUserCmd = "ServiceEvent_NUserActivityNtfUserCmd"
ServiceEvent.NUserQueryZoneStatusUserCmd = "ServiceEvent_NUserQueryZoneStatusUserCmd"
ServiceEvent.NUserJumpZoneUserCmd = "ServiceEvent_NUserJumpZoneUserCmd"
ServiceEvent.NUserItemImageUserNtfUserCmd = "ServiceEvent_NUserItemImageUserNtfUserCmd"
ServiceEvent.NUserInviteFollowUserCmd = "ServiceEvent_NUserInviteFollowUserCmd"
ServiceEvent.NUserChangeNameUserCmd = "ServiceEvent_NUserChangeNameUserCmd"
ServiceEvent.NUserChargePlayUserCmd = "ServiceEvent_NUserChargePlayUserCmd"
ServiceEvent.NUserRequireNpcFuncUserCmd = "ServiceEvent_NUserRequireNpcFuncUserCmd"
ServiceEvent.NUserCheckSeatUserCmd = "ServiceEvent_NUserCheckSeatUserCmd"
ServiceEvent.NUserNtfSeatUserCmd = "ServiceEvent_NUserNtfSeatUserCmd"
ServiceEvent.NUserYoyoSeatUserCmd = "ServiceEvent_NUserYoyoSeatUserCmd"
ServiceEvent.NUserShowSeatUserCmd = "ServiceEvent_NUserShowSeatUserCmd"
ServiceEvent.NUserSetNormalSkillOptionUserCmd = "ServiceEvent_NUserSetNormalSkillOptionUserCmd"
ServiceEvent.NUserNewSetOptionUserCmd = "ServiceEvent_NUserNewSetOptionUserCmd"
ServiceEvent.NUserUnsolvedSceneryNtfUserCmd = "ServiceEvent_NUserUnsolvedSceneryNtfUserCmd"
ServiceEvent.NUserNtfVisibleNpcUserCmd = "ServiceEvent_NUserNtfVisibleNpcUserCmd"
ServiceEvent.NUserUpyunAuthorizationCmd = "ServiceEvent_NUserUpyunAuthorizationCmd"
ServiceEvent.NUserTransformPreDataCmd = "ServiceEvent_NUserTransformPreDataCmd"
ServiceEvent.NUserUserRenameCmd = "ServiceEvent_NUserUserRenameCmd"
ServiceEvent.NUserBuyZenyCmd = "ServiceEvent_NUserBuyZenyCmd"
ServiceEvent.NUserCallTeamerUserCmd = "ServiceEvent_NUserCallTeamerUserCmd"
ServiceEvent.NUserCallTeamerReplyUserCmd = "ServiceEvent_NUserCallTeamerReplyUserCmd"
ServiceEvent.NUserSpecialEffectCmd = "ServiceEvent_NUserSpecialEffectCmd"
ServiceEvent.NUserMarriageProposalCmd = "ServiceEvent_NUserMarriageProposalCmd"
ServiceEvent.NUserMarriageProposalReplyCmd = "ServiceEvent_NUserMarriageProposalReplyCmd"
ServiceEvent.NUserUploadWeddingPhotoUserCmd = "ServiceEvent_NUserUploadWeddingPhotoUserCmd"
ServiceEvent.NUserMarriageProposalSuccessCmd = "ServiceEvent_NUserMarriageProposalSuccessCmd"
ServiceEvent.NUserInviteeWeddingStartNtfUserCmd = "ServiceEvent_NUserInviteeWeddingStartNtfUserCmd"
ServiceEvent.NUserKFCShareUserCmd = "ServiceEvent_NUserKFCShareUserCmd"
ServiceEvent.NUserKFCEnrollUserCmd = "ServiceEvent_NUserKFCEnrollUserCmd"
ServiceEvent.NUserKFCEnrollCodeUserCmd = "ServiceEvent_NUserKFCEnrollCodeUserCmd"
ServiceEvent.NUserKFCEnrollReplyUserCmd = "ServiceEvent_NUserKFCEnrollReplyUserCmd"
ServiceEvent.NUserKFCEnrollQueryUserCmd = "ServiceEvent_NUserKFCEnrollQueryUserCmd"
ServiceEvent.NUserKFCHasEnrolledUserCmd = "ServiceEvent_NUserKFCHasEnrolledUserCmd"
ServiceEvent.NUserCheckRelationUserCmd = "ServiceEvent_NUserCheckRelationUserCmd"
ServiceEvent.NUserTwinsActionUserCmd = "ServiceEvent_NUserTwinsActionUserCmd"
ServiceEvent.NUserShowServantUserCmd = "ServiceEvent_NUserShowServantUserCmd"
ServiceEvent.NUserReplaceServantUserCmd = "ServiceEvent_NUserReplaceServantUserCmd"
ServiceEvent.NUserServantService = "ServiceEvent_NUserServantService"
ServiceEvent.NUserRecommendServantUserCmd = "ServiceEvent_NUserRecommendServantUserCmd"
ServiceEvent.NUserReceiveServantUserCmd = "ServiceEvent_NUserReceiveServantUserCmd"
ServiceEvent.NUserServantRewardStatusUserCmd = "ServiceEvent_NUserServantRewardStatusUserCmd"
ServiceEvent.NUserProfessionQueryUserCmd = "ServiceEvent_NUserProfessionQueryUserCmd"
ServiceEvent.NUserProfessionBuyUserCmd = "ServiceEvent_NUserProfessionBuyUserCmd"
ServiceEvent.NUserProfessionChangeUserCmd = "ServiceEvent_NUserProfessionChangeUserCmd"
ServiceEvent.NUserUpdateRecordInfoUserCmd = "ServiceEvent_NUserUpdateRecordInfoUserCmd"
ServiceEvent.NUserSaveRecordUserCmd = "ServiceEvent_NUserSaveRecordUserCmd"
ServiceEvent.NUserLoadRecordUserCmd = "ServiceEvent_NUserLoadRecordUserCmd"
ServiceEvent.NUserChangeRecordNameUserCmd = "ServiceEvent_NUserChangeRecordNameUserCmd"
ServiceEvent.NUserBuyRecordSlotUserCmd = "ServiceEvent_NUserBuyRecordSlotUserCmd"
ServiceEvent.NUserDeleteRecordUserCmd = "ServiceEvent_NUserDeleteRecordUserCmd"
ServiceEvent.NUserUpdateBranchInfoUserCmd = "ServiceEvent_NUserUpdateBranchInfoUserCmd"
ServiceEvent.NUserEnterCapraActivityCmd = "ServiceEvent_NUserEnterCapraActivityCmd"
ServiceEvent.NUserInviteWithMeUserCmd = "ServiceEvent_NUserInviteWithMeUserCmd"
ServiceEvent.NUserQueryAltmanKillUserCmd = "ServiceEvent_NUserQueryAltmanKillUserCmd"
ServiceEvent.NUserBoothReqUserCmd = "ServiceEvent_NUserBoothReqUserCmd"
ServiceEvent.NUserBoothInfoSyncUserCmd = "ServiceEvent_NUserBoothInfoSyncUserCmd"
ServiceEvent.NUserDressUpModelUserCmd = "ServiceEvent_NUserDressUpModelUserCmd"
ServiceEvent.NUserDressUpHeadUserCmd = "ServiceEvent_NUserDressUpHeadUserCmd"
ServiceEvent.NUserQueryStageUserCmd = "ServiceEvent_NUserQueryStageUserCmd"
ServiceEvent.NUserDressUpLineUpUserCmd = "ServiceEvent_NUserDressUpLineUpUserCmd"
ServiceEvent.NUserDressUpStageUserCmd = "ServiceEvent_NUserDressUpStageUserCmd"
ServiceEvent.NUserGoToFunctionMapUserCmd = "ServiceEvent_NUserGoToFunctionMapUserCmd"
ServiceEvent.NUserGrowthServantUserCmd = "ServiceEvent_NUserGrowthServantUserCmd"
ServiceEvent.NUserReceiveGrowthServantUserCmd = "ServiceEvent_NUserReceiveGrowthServantUserCmd"
ServiceEvent.NUserGrowthOpenServantUserCmd = "ServiceEvent_NUserGrowthOpenServantUserCmd"
ServiceEvent.NUserCheatTagUserCmd = "ServiceEvent_NUserCheatTagUserCmd"
ServiceEvent.NUserCheatTagStatUserCmd = "ServiceEvent_NUserCheatTagStatUserCmd"
ServiceEvent.NUserClickPosList = "ServiceEvent_NUserClickPosList"
ServiceEvent.NUserSignInUserCmd = "ServiceEvent_NUserSignInUserCmd"
ServiceEvent.NUserSignInNtfUserCmd = "ServiceEvent_NUserSignInNtfUserCmd"
ServiceEvent.NUserBeatPoriUserCmd = "ServiceEvent_NUserBeatPoriUserCmd"
ServiceEvent.NUserUnlockFrameUserCmd = "ServiceEvent_NUserUnlockFrameUserCmd"
ServiceEvent.NUserAltmanRewardUserCmd = "ServiceEvent_NUserAltmanRewardUserCmd"
ServiceEvent.NUserServantReqReservationUserCmd = "ServiceEvent_NUserServantReqReservationUserCmd"
ServiceEvent.NUserServantReservationUserCmd = "ServiceEvent_NUserServantReservationUserCmd"
ServiceEvent.NUserServantRecEquipUserCmd = "ServiceEvent_NUserServantRecEquipUserCmd"
