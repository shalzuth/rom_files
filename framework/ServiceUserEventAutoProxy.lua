ServiceUserEventAutoProxy = class("ServiceUserEventAutoProxy", ServiceProxy)
ServiceUserEventAutoProxy.Instance = nil
ServiceUserEventAutoProxy.NAME = "ServiceUserEventAutoProxy"
function ServiceUserEventAutoProxy:ctor(proxyName)
  if ServiceUserEventAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceUserEventAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceUserEventAutoProxy.Instance = self
  end
end
function ServiceUserEventAutoProxy:Init()
end
function ServiceUserEventAutoProxy:onRegister()
  self:Listen(25, 1, function(data)
    self:RecvFirstActionUserEvent(data)
  end)
  self:Listen(25, 2, function(data)
    self:RecvDamageNpcUserEvent(data)
  end)
  self:Listen(25, 3, function(data)
    self:RecvNewTitle(data)
  end)
  self:Listen(25, 4, function(data)
    self:RecvAllTitle(data)
  end)
  self:Listen(25, 5, function(data)
    self:RecvUpdateRandomUserEvent(data)
  end)
  self:Listen(25, 6, function(data)
    self:RecvBuffDamageUserEvent(data)
  end)
  self:Listen(25, 7, function(data)
    self:RecvChargeNtfUserEvent(data)
  end)
  self:Listen(25, 8, function(data)
    self:RecvChargeQueryCmd(data)
  end)
  self:Listen(25, 9, function(data)
    self:RecvDepositCardInfo(data)
  end)
  self:Listen(25, 10, function(data)
    self:RecvDelTransformUserEvent(data)
  end)
  self:Listen(25, 11, function(data)
    self:RecvInviteCatFailUserEvent(data)
  end)
  self:Listen(25, 12, function(data)
    self:RecvTrigNpcFuncUserEvent(data)
  end)
  self:Listen(25, 13, function(data)
    self:RecvSystemStringUserEvent(data)
  end)
  self:Listen(25, 14, function(data)
    self:RecvHandCatUserEvent(data)
  end)
  self:Listen(25, 15, function(data)
    self:RecvChangeTitle(data)
  end)
  self:Listen(25, 16, function(data)
    self:RecvQueryChargeCnt(data)
  end)
  self:Listen(25, 17, function(data)
    self:RecvNTFMonthCardEnd(data)
  end)
  self:Listen(25, 18, function(data)
    self:RecvLoveLetterUse(data)
  end)
  self:Listen(25, 19, function(data)
    self:RecvQueryActivityCnt(data)
  end)
  self:Listen(25, 20, function(data)
    self:RecvUpdateActivityCnt(data)
  end)
  self:Listen(25, 23, function(data)
    self:RecvNtfVersionCardInfo(data)
  end)
  self:Listen(25, 24, function(data)
    self:RecvDieTimeCountEventCmd(data)
  end)
  self:Listen(25, 22, function(data)
    self:RecvGetFirstShareRewardUserEvent(data)
  end)
  self:Listen(25, 25, function(data)
    self:RecvQueryResetTimeEventCmd(data)
  end)
  self:Listen(25, 26, function(data)
    self:RecvInOutActEventCmd(data)
  end)
  self:Listen(25, 27, function(data)
    self:RecvUserEventMailCmd(data)
  end)
  self:Listen(25, 28, function(data)
    self:RecvLevelupDeadUserEvent(data)
  end)
  self:Listen(25, 29, function(data)
    self:RecvSwitchAutoBattleUserEvent(data)
  end)
  self:Listen(25, 30, function(data)
    self:RecvGoActivityMapUserEvent(data)
  end)
end
function ServiceUserEventAutoProxy:CallFirstActionUserEvent(firstaction)
  local msg = UserEvent_pb.FirstActionUserEvent()
  if firstaction ~= nil then
    msg.firstaction = firstaction
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallDamageNpcUserEvent(npcguid, userid)
  local msg = UserEvent_pb.DamageNpcUserEvent()
  if npcguid ~= nil then
    msg.npcguid = npcguid
  end
  if userid ~= nil then
    msg.userid = userid
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallNewTitle(title_data, charid)
  local msg = UserEvent_pb.NewTitle()
  if title_data ~= nil and title_data.title_type ~= nil then
    msg.title_data.title_type = title_data.title_type
  end
  if title_data ~= nil and title_data.id ~= nil then
    msg.title_data.id = title_data.id
  end
  if title_data ~= nil and title_data.createtime ~= nil then
    msg.title_data.createtime = title_data.createtime
  end
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallAllTitle(title_datas)
  local msg = UserEvent_pb.AllTitle()
  if title_datas ~= nil then
    for i = 1, #title_datas do
      table.insert(msg.title_datas, title_datas[i])
    end
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallUpdateRandomUserEvent(beginindex, endindex, randoms)
  local msg = UserEvent_pb.UpdateRandomUserEvent()
  if beginindex ~= nil then
    msg.beginindex = beginindex
  end
  if endindex ~= nil then
    msg.endindex = endindex
  end
  if randoms ~= nil then
    for i = 1, #randoms do
      table.insert(msg.randoms, randoms[i])
    end
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallBuffDamageUserEvent(charid, damage, etype)
  local msg = UserEvent_pb.BuffDamageUserEvent()
  if charid ~= nil then
    msg.charid = charid
  end
  if damage ~= nil then
    msg.damage = damage
  end
  if etype ~= nil then
    msg.etype = etype
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallChargeNtfUserEvent(charid, dataid)
  local msg = UserEvent_pb.ChargeNtfUserEvent()
  if charid ~= nil then
    msg.charid = charid
  end
  if dataid ~= nil then
    msg.dataid = dataid
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallChargeQueryCmd(data_id, ret, charged_count)
  local msg = UserEvent_pb.ChargeQueryCmd()
  if data_id ~= nil then
    msg.data_id = data_id
  end
  if ret ~= nil then
    msg.ret = ret
  end
  if charged_count ~= nil then
    msg.charged_count = charged_count
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallDepositCardInfo(card_datas)
  local msg = UserEvent_pb.DepositCardInfo()
  if card_datas ~= nil then
    for i = 1, #card_datas do
      table.insert(msg.card_datas, card_datas[i])
    end
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallDelTransformUserEvent()
  local msg = UserEvent_pb.DelTransformUserEvent()
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallInviteCatFailUserEvent()
  local msg = UserEvent_pb.InviteCatFailUserEvent()
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallTrigNpcFuncUserEvent(npcguid, funcid)
  local msg = UserEvent_pb.TrigNpcFuncUserEvent()
  msg.npcguid = npcguid
  msg.funcid = funcid
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallSystemStringUserEvent(etype)
  local msg = UserEvent_pb.SystemStringUserEvent()
  if etype ~= nil then
    msg.etype = etype
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallHandCatUserEvent(catguid, breakup)
  local msg = UserEvent_pb.HandCatUserEvent()
  msg.catguid = catguid
  if breakup ~= nil then
    msg.breakup = breakup
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallChangeTitle(title_data, charid)
  local msg = UserEvent_pb.ChangeTitle()
  if title_data ~= nil and title_data.title_type ~= nil then
    msg.title_data.title_type = title_data.title_type
  end
  if title_data ~= nil and title_data.id ~= nil then
    msg.title_data.id = title_data.id
  end
  if title_data ~= nil and title_data.createtime ~= nil then
    msg.title_data.createtime = title_data.createtime
  end
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallQueryChargeCnt(info)
  local msg = UserEvent_pb.QueryChargeCnt()
  if info ~= nil then
    for i = 1, #info do
      table.insert(msg.info, info[i])
    end
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallNTFMonthCardEnd()
  local msg = UserEvent_pb.NTFMonthCardEnd()
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallLoveLetterUse(itemguid, targets, content, type)
  local msg = UserEvent_pb.LoveLetterUse()
  if itemguid ~= nil then
    msg.itemguid = itemguid
  end
  if targets ~= nil then
    msg.targets = targets
  end
  if content ~= nil then
    msg.content = content
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallQueryActivityCnt(info)
  local msg = UserEvent_pb.QueryActivityCnt()
  if info ~= nil then
    for i = 1, #info do
      table.insert(msg.info, info[i])
    end
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallUpdateActivityCnt(info)
  local msg = UserEvent_pb.UpdateActivityCnt()
  if info ~= nil and info.activityid ~= nil then
    msg.info.activityid = info.activityid
  end
  if info ~= nil and info.count ~= nil then
    msg.info.count = info.count
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallNtfVersionCardInfo(info)
  local msg = UserEvent_pb.NtfVersionCardInfo()
  if info ~= nil then
    for i = 1, #info do
      table.insert(msg.info, info[i])
    end
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallDieTimeCountEventCmd(time, name)
  local msg = UserEvent_pb.DieTimeCountEventCmd()
  if time ~= nil then
    msg.time = time
  end
  if name ~= nil then
    msg.name = name
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallGetFirstShareRewardUserEvent()
  local msg = UserEvent_pb.GetFirstShareRewardUserEvent()
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallQueryResetTimeEventCmd(etype, resettime)
  local msg = UserEvent_pb.QueryResetTimeEventCmd()
  msg.etype = etype
  if resettime ~= nil then
    msg.resettime = resettime
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallInOutActEventCmd(actid, inout)
  local msg = UserEvent_pb.InOutActEventCmd()
  msg.actid = actid
  if inout ~= nil then
    msg.inout = inout
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallUserEventMailCmd(eType, param32, param64)
  local msg = UserEvent_pb.UserEventMailCmd()
  if eType ~= nil then
    msg.eType = eType
  end
  if param32 ~= nil then
    for i = 1, #param32 do
      table.insert(msg.param32, param32[i])
    end
  end
  if param64 ~= nil then
    for i = 1, #param64 do
      table.insert(msg.param64, param64[i])
    end
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallLevelupDeadUserEvent()
  local msg = UserEvent_pb.LevelupDeadUserEvent()
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallSwitchAutoBattleUserEvent(open)
  local msg = UserEvent_pb.SwitchAutoBattleUserEvent()
  if open ~= nil then
    msg.open = open
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:CallGoActivityMapUserEvent(actid, mapid)
  local msg = UserEvent_pb.GoActivityMapUserEvent()
  if actid ~= nil then
    msg.actid = actid
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  self:SendProto(msg)
end
function ServiceUserEventAutoProxy:RecvFirstActionUserEvent(data)
  self:Notify(ServiceEvent.UserEventFirstActionUserEvent, data)
end
function ServiceUserEventAutoProxy:RecvDamageNpcUserEvent(data)
  self:Notify(ServiceEvent.UserEventDamageNpcUserEvent, data)
end
function ServiceUserEventAutoProxy:RecvNewTitle(data)
  self:Notify(ServiceEvent.UserEventNewTitle, data)
end
function ServiceUserEventAutoProxy:RecvAllTitle(data)
  self:Notify(ServiceEvent.UserEventAllTitle, data)
end
function ServiceUserEventAutoProxy:RecvUpdateRandomUserEvent(data)
  self:Notify(ServiceEvent.UserEventUpdateRandomUserEvent, data)
end
function ServiceUserEventAutoProxy:RecvBuffDamageUserEvent(data)
  self:Notify(ServiceEvent.UserEventBuffDamageUserEvent, data)
end
function ServiceUserEventAutoProxy:RecvChargeNtfUserEvent(data)
  self:Notify(ServiceEvent.UserEventChargeNtfUserEvent, data)
end
function ServiceUserEventAutoProxy:RecvChargeQueryCmd(data)
  self:Notify(ServiceEvent.UserEventChargeQueryCmd, data)
end
function ServiceUserEventAutoProxy:RecvDepositCardInfo(data)
  self:Notify(ServiceEvent.UserEventDepositCardInfo, data)
end
function ServiceUserEventAutoProxy:RecvDelTransformUserEvent(data)
  self:Notify(ServiceEvent.UserEventDelTransformUserEvent, data)
end
function ServiceUserEventAutoProxy:RecvInviteCatFailUserEvent(data)
  self:Notify(ServiceEvent.UserEventInviteCatFailUserEvent, data)
end
function ServiceUserEventAutoProxy:RecvTrigNpcFuncUserEvent(data)
  self:Notify(ServiceEvent.UserEventTrigNpcFuncUserEvent, data)
end
function ServiceUserEventAutoProxy:RecvSystemStringUserEvent(data)
  self:Notify(ServiceEvent.UserEventSystemStringUserEvent, data)
end
function ServiceUserEventAutoProxy:RecvHandCatUserEvent(data)
  self:Notify(ServiceEvent.UserEventHandCatUserEvent, data)
end
function ServiceUserEventAutoProxy:RecvChangeTitle(data)
  self:Notify(ServiceEvent.UserEventChangeTitle, data)
end
function ServiceUserEventAutoProxy:RecvQueryChargeCnt(data)
  self:Notify(ServiceEvent.UserEventQueryChargeCnt, data)
end
function ServiceUserEventAutoProxy:RecvNTFMonthCardEnd(data)
  self:Notify(ServiceEvent.UserEventNTFMonthCardEnd, data)
end
function ServiceUserEventAutoProxy:RecvLoveLetterUse(data)
  self:Notify(ServiceEvent.UserEventLoveLetterUse, data)
end
function ServiceUserEventAutoProxy:RecvQueryActivityCnt(data)
  self:Notify(ServiceEvent.UserEventQueryActivityCnt, data)
end
function ServiceUserEventAutoProxy:RecvUpdateActivityCnt(data)
  self:Notify(ServiceEvent.UserEventUpdateActivityCnt, data)
end
function ServiceUserEventAutoProxy:RecvNtfVersionCardInfo(data)
  self:Notify(ServiceEvent.UserEventNtfVersionCardInfo, data)
end
function ServiceUserEventAutoProxy:RecvDieTimeCountEventCmd(data)
  self:Notify(ServiceEvent.UserEventDieTimeCountEventCmd, data)
end
function ServiceUserEventAutoProxy:RecvGetFirstShareRewardUserEvent(data)
  self:Notify(ServiceEvent.UserEventGetFirstShareRewardUserEvent, data)
end
function ServiceUserEventAutoProxy:RecvQueryResetTimeEventCmd(data)
  self:Notify(ServiceEvent.UserEventQueryResetTimeEventCmd, data)
end
function ServiceUserEventAutoProxy:RecvInOutActEventCmd(data)
  self:Notify(ServiceEvent.UserEventInOutActEventCmd, data)
end
function ServiceUserEventAutoProxy:RecvUserEventMailCmd(data)
  self:Notify(ServiceEvent.UserEventUserEventMailCmd, data)
end
function ServiceUserEventAutoProxy:RecvLevelupDeadUserEvent(data)
  self:Notify(ServiceEvent.UserEventLevelupDeadUserEvent, data)
end
function ServiceUserEventAutoProxy:RecvSwitchAutoBattleUserEvent(data)
  self:Notify(ServiceEvent.UserEventSwitchAutoBattleUserEvent, data)
end
function ServiceUserEventAutoProxy:RecvGoActivityMapUserEvent(data)
  self:Notify(ServiceEvent.UserEventGoActivityMapUserEvent, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.UserEventFirstActionUserEvent = "ServiceEvent_UserEventFirstActionUserEvent"
ServiceEvent.UserEventDamageNpcUserEvent = "ServiceEvent_UserEventDamageNpcUserEvent"
ServiceEvent.UserEventNewTitle = "ServiceEvent_UserEventNewTitle"
ServiceEvent.UserEventAllTitle = "ServiceEvent_UserEventAllTitle"
ServiceEvent.UserEventUpdateRandomUserEvent = "ServiceEvent_UserEventUpdateRandomUserEvent"
ServiceEvent.UserEventBuffDamageUserEvent = "ServiceEvent_UserEventBuffDamageUserEvent"
ServiceEvent.UserEventChargeNtfUserEvent = "ServiceEvent_UserEventChargeNtfUserEvent"
ServiceEvent.UserEventChargeQueryCmd = "ServiceEvent_UserEventChargeQueryCmd"
ServiceEvent.UserEventDepositCardInfo = "ServiceEvent_UserEventDepositCardInfo"
ServiceEvent.UserEventDelTransformUserEvent = "ServiceEvent_UserEventDelTransformUserEvent"
ServiceEvent.UserEventInviteCatFailUserEvent = "ServiceEvent_UserEventInviteCatFailUserEvent"
ServiceEvent.UserEventTrigNpcFuncUserEvent = "ServiceEvent_UserEventTrigNpcFuncUserEvent"
ServiceEvent.UserEventSystemStringUserEvent = "ServiceEvent_UserEventSystemStringUserEvent"
ServiceEvent.UserEventHandCatUserEvent = "ServiceEvent_UserEventHandCatUserEvent"
ServiceEvent.UserEventChangeTitle = "ServiceEvent_UserEventChangeTitle"
ServiceEvent.UserEventQueryChargeCnt = "ServiceEvent_UserEventQueryChargeCnt"
ServiceEvent.UserEventNTFMonthCardEnd = "ServiceEvent_UserEventNTFMonthCardEnd"
ServiceEvent.UserEventLoveLetterUse = "ServiceEvent_UserEventLoveLetterUse"
ServiceEvent.UserEventQueryActivityCnt = "ServiceEvent_UserEventQueryActivityCnt"
ServiceEvent.UserEventUpdateActivityCnt = "ServiceEvent_UserEventUpdateActivityCnt"
ServiceEvent.UserEventNtfVersionCardInfo = "ServiceEvent_UserEventNtfVersionCardInfo"
ServiceEvent.UserEventDieTimeCountEventCmd = "ServiceEvent_UserEventDieTimeCountEventCmd"
ServiceEvent.UserEventGetFirstShareRewardUserEvent = "ServiceEvent_UserEventGetFirstShareRewardUserEvent"
ServiceEvent.UserEventQueryResetTimeEventCmd = "ServiceEvent_UserEventQueryResetTimeEventCmd"
ServiceEvent.UserEventInOutActEventCmd = "ServiceEvent_UserEventInOutActEventCmd"
ServiceEvent.UserEventUserEventMailCmd = "ServiceEvent_UserEventUserEventMailCmd"
ServiceEvent.UserEventLevelupDeadUserEvent = "ServiceEvent_UserEventLevelupDeadUserEvent"
ServiceEvent.UserEventSwitchAutoBattleUserEvent = "ServiceEvent_UserEventSwitchAutoBattleUserEvent"
ServiceEvent.UserEventGoActivityMapUserEvent = "ServiceEvent_UserEventGoActivityMapUserEvent"
