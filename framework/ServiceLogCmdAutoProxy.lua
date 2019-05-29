ServiceLogCmdAutoProxy = class("ServiceLogCmdAutoProxy", ServiceProxy)
ServiceLogCmdAutoProxy.Instance = nil
ServiceLogCmdAutoProxy.NAME = "ServiceLogCmdAutoProxy"
function ServiceLogCmdAutoProxy:ctor(proxyName)
  if ServiceLogCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceLogCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceLogCmdAutoProxy.Instance = self
  end
end
function ServiceLogCmdAutoProxy:Init()
end
function ServiceLogCmdAutoProxy:onRegister()
  self:Listen(204, 1, function(data)
    self:RecvLoginLogCmd(data)
  end)
  self:Listen(204, 2, function(data)
    self:RecvAccountLogCmd(data)
  end)
  self:Listen(204, 3, function(data)
    self:RecvCreateLogCmd(data)
  end)
  self:Listen(204, 4, function(data)
    self:RecvChangeFlagLogCmd(data)
  end)
  self:Listen(204, 5, function(data)
    self:RecvChargeLogCmd(data)
  end)
  self:Listen(204, 6, function(data)
    self:RecvEventLogCmd(data)
  end)
  self:Listen(204, 7, function(data)
    self:RecvIncomeLogCmd(data)
  end)
  self:Listen(204, 8, function(data)
    self:RecvConsumeLogCmd(data)
  end)
  self:Listen(204, 9, function(data)
    self:RecvItemLogCmd(data)
  end)
  self:Listen(204, 10, function(data)
    self:RecvPropsLogCmd(data)
  end)
  self:Listen(204, 11, function(data)
    self:RecvTransactionLogCmd(data)
  end)
  self:Listen(204, 12, function(data)
    self:RecvChatLogCmd(data)
  end)
  self:Listen(204, 13, function(data)
    self:RecvLevelLogCmd(data)
  end)
  self:Listen(204, 14, function(data)
    self:RecvOnlineLogCmd(data)
  end)
  self:Listen(204, 16, function(data)
    self:RecvCheckpointLogCmd(data)
  end)
  self:Listen(204, 17, function(data)
    self:RecvRankLogCmd(data)
  end)
  self:Listen(204, 18, function(data)
    self:RecvQueryChatLogCmd(data)
  end)
  self:Listen(204, 39, function(data)
    self:RecvChangeLogCmd(data)
  end)
  self:Listen(204, 31, function(data)
    self:RecvEquipLogCmd(data)
  end)
  self:Listen(204, 30, function(data)
    self:RecvCardLogCmd(data)
  end)
  self:Listen(204, 41, function(data)
    self:RecvEquipUpLogCmd(data)
  end)
  self:Listen(204, 33, function(data)
    self:RecvSocailLogCmd(data)
  end)
  self:Listen(204, 34, function(data)
    self:RecvQuestLogCmd(data)
  end)
  self:Listen(204, 37, function(data)
    self:RecvManualLogCmd(data)
  end)
  self:Listen(204, 35, function(data)
    self:RecvCompleteLogCmd(data)
  end)
  self:Listen(204, 42, function(data)
    self:RecvTowerLogCmd(data)
  end)
  self:Listen(204, 40, function(data)
    self:RecvItemOperLogCmd(data)
  end)
  self:Listen(204, 38, function(data)
    self:RecvKillLogCmd(data)
  end)
  self:Listen(204, 43, function(data)
    self:RecvRewardLogCmd(data)
  end)
  self:Listen(204, 44, function(data)
    self:RecvMailLogCmd(data)
  end)
  self:Listen(204, 45, function(data)
    self:RecvDojoLogCmd(data)
  end)
  self:Listen(204, 46, function(data)
    self:RecvEnchantLogCmd(data)
  end)
  self:Listen(204, 47, function(data)
    self:RecvGuildPrayLogCmd(data)
  end)
  self:Listen(204, 48, function(data)
    self:RecvUseSkillLogCmd(data)
  end)
  self:Listen(204, 49, function(data)
    self:RecvActiveLogCmd(data)
  end)
  self:Listen(204, 50, function(data)
    self:RecvTradeLogCmd(data)
  end)
  self:Listen(204, 51, function(data)
    self:RecvDeleteCharLogCmd(data)
  end)
  self:Listen(204, 52, function(data)
    self:RecvComposeLogCmd(data)
  end)
  self:Listen(204, 53, function(data)
    self:RecvJumpzoneLogCmd(data)
  end)
  self:Listen(204, 54, function(data)
    self:RecvTeamLogCmd(data)
  end)
  self:Listen(204, 55, function(data)
    self:RecvTradeAdjustPriceLogCmd(data)
  end)
  self:Listen(204, 56, function(data)
    self:RecvTradePriceLogCmd(data)
  end)
  self:Listen(204, 57, function(data)
    self:RecvPetChangeLogCmd(data)
  end)
  self:Listen(204, 58, function(data)
    self:RecvPetAdventureLogCmd(data)
  end)
  self:Listen(204, 60, function(data)
    self:RecvInactiveUserLogCmd(data)
  end)
  self:Listen(204, 59, function(data)
    self:RecvTradeUntakeLogCmd(data)
  end)
  self:Listen(204, 61, function(data)
    self:RecvCreditLogCmd(data)
  end)
  self:Listen(204, 62, function(data)
    self:RecvTradeGiveLogCmd(data)
  end)
  self:Listen(204, 63, function(data)
    self:RecvQuotaLogCmd(data)
  end)
  self:Listen(204, 64, function(data)
    self:RecvGuildItemLogCmd(data)
  end)
  self:Listen(204, 65, function(data)
    self:RecvAstrolabeLogCmd(data)
  end)
  self:Listen(204, 66, function(data)
    self:RecvDebtLogCmd(data)
  end)
end
function ServiceLogCmdAutoProxy:CallLoginLogCmd(cid, sid, hid, account, pid, time, ip, type, ispay, level, vip, mark, sign, device, guest, mac, agent, mapid, onlinetime, teamtimelen, isnew, logid, zoneid, clickpos)
  local msg = LogCmd_pb.LoginLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if ip ~= nil then
    msg.ip = ip
  end
  if type ~= nil then
    msg.type = type
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if level ~= nil then
    msg.level = level
  end
  if vip ~= nil then
    msg.vip = vip
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if sign ~= nil then
    msg.sign = sign
  end
  if device ~= nil then
    msg.device = device
  end
  if guest ~= nil then
    msg.guest = guest
  end
  if mac ~= nil then
    msg.mac = mac
  end
  if agent ~= nil then
    msg.agent = agent
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if onlinetime ~= nil then
    msg.onlinetime = onlinetime
  end
  if teamtimelen ~= nil then
    msg.teamtimelen = teamtimelen
  end
  if isnew ~= nil then
    msg.isnew = isnew
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if clickpos ~= nil then
    msg.clickpos = clickpos
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallAccountLogCmd(cid, sid, account, time, ip, guest, device, mac, source, agent, logid)
  local msg = LogCmd_pb.AccountLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if account ~= nil then
    msg.account = account
  end
  if time ~= nil then
    msg.time = time
  end
  if ip ~= nil then
    msg.ip = ip
  end
  if guest ~= nil then
    msg.guest = guest
  end
  if device ~= nil then
    msg.device = device
  end
  if mac ~= nil then
    msg.mac = mac
  end
  if source ~= nil then
    msg.source = source
  end
  if agent ~= nil then
    msg.agent = agent
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallCreateLogCmd(cid, sid, account, pid, time, ip, name, guest, device, mac, source, agent, gender, hair, haircolor, logid)
  local msg = LogCmd_pb.CreateLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if ip ~= nil then
    msg.ip = ip
  end
  if name ~= nil then
    msg.name = name
  end
  if guest ~= nil then
    msg.guest = guest
  end
  if device ~= nil then
    msg.device = device
  end
  if mac ~= nil then
    msg.mac = mac
  end
  if source ~= nil then
    msg.source = source
  end
  if agent ~= nil then
    msg.agent = agent
  end
  if gender ~= nil then
    msg.gender = gender
  end
  if hair ~= nil then
    msg.hair = hair
  end
  if haircolor ~= nil then
    msg.haircolor = haircolor
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallChangeFlagLogCmd(cid, sid, pid, time, falg, from, to, param1, logid)
  local msg = LogCmd_pb.ChangeFlagLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if falg ~= nil then
    msg.falg = falg
  end
  if from ~= nil then
    msg.from = from
  end
  if to ~= nil then
    msg.to = to
  end
  if param1 ~= nil then
    msg.param1 = param1
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallChargeLogCmd(cid, sid, hid, account, pid, time, ip, oid, type, level, amount, coins, mark, name, device, ctime, currency, provider, itemid, logid)
  local msg = LogCmd_pb.ChargeLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if ip ~= nil then
    msg.ip = ip
  end
  if oid ~= nil then
    msg.oid = oid
  end
  if type ~= nil then
    msg.type = type
  end
  if level ~= nil then
    msg.level = level
  end
  if amount ~= nil then
    msg.amount = amount
  end
  if coins ~= nil then
    msg.coins = coins
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if name ~= nil then
    msg.name = name
  end
  if device ~= nil then
    msg.device = device
  end
  if ctime ~= nil then
    msg.ctime = ctime
  end
  if currency ~= nil then
    msg.currency = currency
  end
  if provider ~= nil then
    msg.provider = provider
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallEventLogCmd(cid, sid, hid, account, pid, time, microtime, eid, ispay, type, subtype, count, mark, logid)
  local msg = LogCmd_pb.EventLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if microtime ~= nil then
    msg.microtime = microtime
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if type ~= nil then
    msg.type = type
  end
  if subtype ~= nil then
    msg.subtype = subtype
  end
  if count ~= nil then
    msg.count = count
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallIncomeLogCmd(cid, sid, hid, account, pid, time, microtime, eid, ispay, value, coin_type, type, after, mark, logid, source, count)
  local msg = LogCmd_pb.IncomeLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if microtime ~= nil then
    msg.microtime = microtime
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if value ~= nil then
    msg.value = value
  end
  if coin_type ~= nil then
    msg.coin_type = coin_type
  end
  if type ~= nil then
    msg.type = type
  end
  if after ~= nil then
    msg.after = after
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if source ~= nil then
    msg.source = source
  end
  if count ~= nil then
    msg.count = count
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallConsumeLogCmd(cid, sid, hid, account, pid, time, microtime, eid, ispay, value, coin_type, type, after, mark, logid, kind, source, count, chargecount, remaincharge, mapid)
  local msg = LogCmd_pb.ConsumeLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if microtime ~= nil then
    msg.microtime = microtime
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if value ~= nil then
    msg.value = value
  end
  if coin_type ~= nil then
    msg.coin_type = coin_type
  end
  if type ~= nil then
    msg.type = type
  end
  if after ~= nil then
    msg.after = after
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if kind ~= nil then
    msg.kind = kind
  end
  if source ~= nil then
    msg.source = source
  end
  if count ~= nil then
    msg.count = count
  end
  if chargecount ~= nil then
    msg.chargecount = chargecount
  end
  if remaincharge ~= nil then
    msg.remaincharge = remaincharge
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallItemLogCmd(cid, sid, hid, account, pid, eid, time, microtime, logid, ispay, type, itemid, value, from_pid, after, amount, amount2, mark, source, count, shoptype, mapid)
  local msg = LogCmd_pb.ItemLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if time ~= nil then
    msg.time = time
  end
  if microtime ~= nil then
    msg.microtime = microtime
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if type ~= nil then
    msg.type = type
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if value ~= nil then
    msg.value = value
  end
  if from_pid ~= nil then
    msg.from_pid = from_pid
  end
  if after ~= nil then
    msg.after = after
  end
  if amount ~= nil then
    msg.amount = amount
  end
  if amount2 ~= nil then
    msg.amount2 = amount2
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if source ~= nil then
    msg.source = source
  end
  if count ~= nil then
    msg.count = count
  end
  if shoptype ~= nil then
    msg.shoptype = shoptype
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallPropsLogCmd(cid, sid, hid, account, pid, eid, time, microtime, logid, ispay, itemid, value, type, after, mark, source, count, iteminfo)
  local msg = LogCmd_pb.PropsLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if time ~= nil then
    msg.time = time
  end
  if microtime ~= nil then
    msg.microtime = microtime
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if value ~= nil then
    msg.value = value
  end
  if type ~= nil then
    msg.type = type
  end
  if after ~= nil then
    msg.after = after
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if source ~= nil then
    msg.source = source
  end
  if count ~= nil then
    msg.count = count
  end
  if iteminfo ~= nil then
    msg.iteminfo = iteminfo
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallTransactionLogCmd(cid, sid, hid, from_account, from_pid, to_account, to_pid, eid, time, ispay, itemid, value, mark, fee, fee2, logid)
  local msg = LogCmd_pb.TransactionLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if from_account ~= nil then
    msg.from_account = from_account
  end
  if from_pid ~= nil then
    msg.from_pid = from_pid
  end
  if to_account ~= nil then
    msg.to_account = to_account
  end
  if to_pid ~= nil then
    msg.to_pid = to_pid
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if time ~= nil then
    msg.time = time
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if value ~= nil then
    msg.value = value
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if fee ~= nil then
    msg.fee = fee
  end
  if fee2 ~= nil then
    msg.fee2 = fee2
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallChatLogCmd(cid, sid, hid, from_account, from_name, from_pid, to_account, to_name, to_pid, type, time, ispay, content, content, vip, level, eid, chattype, voicelen, logid)
  local msg = LogCmd_pb.ChatLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if from_account ~= nil then
    msg.from_account = from_account
  end
  if from_name ~= nil then
    msg.from_name = from_name
  end
  if from_pid ~= nil then
    msg.from_pid = from_pid
  end
  if to_account ~= nil then
    msg.to_account = to_account
  end
  if to_name ~= nil then
    msg.to_name = to_name
  end
  if to_pid ~= nil then
    msg.to_pid = to_pid
  end
  if type ~= nil then
    msg.type = type
  end
  if time ~= nil then
    msg.time = time
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if content ~= nil then
    msg.content = content
  end
  if content ~= nil then
    msg.content = content
  end
  if vip ~= nil then
    msg.vip = vip
  end
  if level ~= nil then
    msg.level = level
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if chattype ~= nil then
    msg.chattype = chattype
  end
  if voicelen ~= nil then
    msg.voicelen = voicelen
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallLevelLogCmd(cid, sid, hid, account, pid, time, from, to, ispay, type, mark, logid, costtime)
  local msg = LogCmd_pb.LevelLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if from ~= nil then
    msg.from = from
  end
  if to ~= nil then
    msg.to = to
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if type ~= nil then
    msg.type = type
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if costtime ~= nil then
    msg.costtime = costtime
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallOnlineLogCmd(cid, sid, time, count_all, count_web, count_client, count_ios, count_android, logid, lineid)
  local msg = LogCmd_pb.OnlineLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if time ~= nil then
    msg.time = time
  end
  if count_all ~= nil then
    msg.count_all = count_all
  end
  if count_web ~= nil then
    msg.count_web = count_web
  end
  if count_client ~= nil then
    msg.count_client = count_client
  end
  if count_ios ~= nil then
    msg.count_ios = count_ios
  end
  if count_android ~= nil then
    msg.count_android = count_android
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if lineid ~= nil then
    msg.lineid = lineid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallCheckpointLogCmd(cid, sid, hid, account, pid, eid, time, type, cpid, result, star, ispay, vip, logid, isfirst)
  local msg = LogCmd_pb.CheckpointLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if time ~= nil then
    msg.time = time
  end
  if type ~= nil then
    msg.type = type
  end
  if cpid ~= nil then
    msg.cpid = cpid
  end
  if result ~= nil then
    msg.result = result
  end
  if star ~= nil then
    msg.star = star
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if vip ~= nil then
    msg.vip = vip
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if isfirst ~= nil then
    msg.isfirst = isfirst
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallRankLogCmd(cid, sid, hid, type, pid, value, date, time, logid)
  local msg = LogCmd_pb.RankLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if type ~= nil then
    msg.type = type
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if value ~= nil then
    msg.value = value
  end
  if date ~= nil then
    msg.date = date
  end
  if time ~= nil then
    msg.time = time
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallQueryChatLogCmd(cond, res)
  local msg = LogCmd_pb.QueryChatLogCmd()
  if cond ~= nil and cond.who ~= nil then
    msg.cond.who = cond.who
  end
  if cond ~= nil and cond.fromtime ~= nil then
    msg.cond.fromtime = cond.fromtime
  end
  if cond ~= nil and cond.totime ~= nil then
    msg.cond.totime = cond.totime
  end
  if cond ~= nil and cond.chattype ~= nil then
    msg.cond.chattype = cond.chattype
  end
  if res ~= nil then
    for i = 1, #res do
      table.insert(msg.res, res[i])
    end
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallChangeLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, flag, from, to, param1, mark, logid)
  local msg = LogCmd_pb.ChangeLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if flag ~= nil then
    msg.flag = flag
  end
  if from ~= nil then
    msg.from = from
  end
  if to ~= nil then
    msg.to = to
  end
  if param1 ~= nil then
    msg.param1 = param1
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallEquipLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, type, old_equipid, old_equipgid, old_strengthlv, old_refinelv, old_isdamage, new_equipid, new_equipgid, new_strengthlv, new_refinelv, new_isdamage, mark, logid)
  local msg = LogCmd_pb.EquipLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if type ~= nil then
    msg.type = type
  end
  if old_equipid ~= nil then
    msg.old_equipid = old_equipid
  end
  if old_equipgid ~= nil then
    msg.old_equipgid = old_equipgid
  end
  if old_strengthlv ~= nil then
    msg.old_strengthlv = old_strengthlv
  end
  if old_refinelv ~= nil then
    msg.old_refinelv = old_refinelv
  end
  if old_isdamage ~= nil then
    msg.old_isdamage = old_isdamage
  end
  if new_equipid ~= nil then
    msg.new_equipid = new_equipid
  end
  if new_equipgid ~= nil then
    msg.new_equipgid = new_equipgid
  end
  if new_strengthlv ~= nil then
    msg.new_strengthlv = new_strengthlv
  end
  if new_refinelv ~= nil then
    msg.new_refinelv = new_refinelv
  end
  if new_isdamage ~= nil then
    msg.new_isdamage = new_isdamage
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallCardLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, equipid, equipgid, type, cardid, cardgid, useslot, maxslot, mark, logid)
  local msg = LogCmd_pb.CardLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if equipid ~= nil then
    msg.equipid = equipid
  end
  if equipgid ~= nil then
    msg.equipgid = equipgid
  end
  if type ~= nil then
    msg.type = type
  end
  if cardid ~= nil then
    msg.cardid = cardid
  end
  if cardgid ~= nil then
    msg.cardgid = cardgid
  end
  if useslot ~= nil then
    msg.useslot = useslot
  end
  if maxslot ~= nil then
    msg.maxslot = maxslot
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallEquipUpLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, type, equipid, equipguid, count, old_lv, new_lv, isfail, cost_money, cost_item, isdamage, mark, logid)
  local msg = LogCmd_pb.EquipUpLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if type ~= nil then
    msg.type = type
  end
  if equipid ~= nil then
    msg.equipid = equipid
  end
  if equipguid ~= nil then
    msg.equipguid = equipguid
  end
  if count ~= nil then
    msg.count = count
  end
  if old_lv ~= nil then
    msg.old_lv = old_lv
  end
  if new_lv ~= nil then
    msg.new_lv = new_lv
  end
  if isfail ~= nil then
    msg.isfail = isfail
  end
  if cost_money ~= nil then
    msg.cost_money = cost_money
  end
  if cost_item ~= nil then
    msg.cost_item = cost_item
  end
  if isdamage ~= nil then
    msg.isdamage = isdamage
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallSocailLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, type, inid, otherid, param1, param2, mark, logid)
  local msg = LogCmd_pb.SocailLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if type ~= nil then
    msg.type = type
  end
  if inid ~= nil then
    msg.inid = inid
  end
  if otherid ~= nil then
    msg.otherid = otherid
  end
  if param1 ~= nil then
    msg.param1 = param1
  end
  if param2 ~= nil then
    msg.param2 = param2
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallQuestLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, questid, type, targetid, baseexp, jobexp, rewarditem, level, mark, logid, lineid)
  local msg = LogCmd_pb.QuestLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if questid ~= nil then
    msg.questid = questid
  end
  if type ~= nil then
    msg.type = type
  end
  if targetid ~= nil then
    msg.targetid = targetid
  end
  if baseexp ~= nil then
    msg.baseexp = baseexp
  end
  if jobexp ~= nil then
    msg.jobexp = jobexp
  end
  if rewarditem ~= nil then
    msg.rewarditem = rewarditem
  end
  if level ~= nil then
    msg.level = level
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if lineid ~= nil then
    msg.lineid = lineid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallManualLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, type, by, what, param1, mark, logid)
  local msg = LogCmd_pb.ManualLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if type ~= nil then
    msg.type = type
  end
  if by ~= nil then
    msg.by = by
  end
  if what ~= nil then
    msg.what = what
  end
  if param1 ~= nil then
    msg.param1 = param1
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallCompleteLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, type, targetid, today_count, reward_type, reward_count, level, mark, logid)
  local msg = LogCmd_pb.CompleteLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if type ~= nil then
    msg.type = type
  end
  if targetid ~= nil then
    msg.targetid = targetid
  end
  if today_count ~= nil then
    msg.today_count = today_count
  end
  if reward_type ~= nil then
    msg.reward_type = reward_type
  end
  if reward_count ~= nil then
    msg.reward_count = reward_count
  end
  if level ~= nil then
    msg.level = level
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallTowerLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, type, curLayer, maxLayer, teamId, level, mark, logid)
  local msg = LogCmd_pb.TowerLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if type ~= nil then
    msg.type = type
  end
  if curLayer ~= nil then
    msg.curLayer = curLayer
  end
  if maxLayer ~= nil then
    msg.maxLayer = maxLayer
  end
  if teamId ~= nil then
    msg.teamId = teamId
  end
  if level ~= nil then
    msg.level = level
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallItemOperLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, type, itemid, count, mark, logid)
  local msg = LogCmd_pb.ItemOperLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if type ~= nil then
    msg.type = type
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if count ~= nil then
    msg.count = count
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallKillLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, monsterid, monstergid, monstergroup, baseexp, jobexp, ismvp, mark, type, level, killtype, logid, lineid)
  local msg = LogCmd_pb.KillLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if monsterid ~= nil then
    msg.monsterid = monsterid
  end
  if monstergid ~= nil then
    msg.monstergid = monstergid
  end
  if monstergroup ~= nil then
    msg.monstergroup = monstergroup
  end
  if baseexp ~= nil then
    msg.baseexp = baseexp
  end
  if jobexp ~= nil then
    msg.jobexp = jobexp
  end
  if ismvp ~= nil then
    msg.ismvp = ismvp
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if type ~= nil then
    msg.type = type
  end
  if level ~= nil then
    msg.level = level
  end
  if killtype ~= nil then
    msg.killtype = killtype
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if lineid ~= nil then
    msg.lineid = lineid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallRewardLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, id, profession, rewarditem, mark, logid)
  local msg = LogCmd_pb.RewardLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if id ~= nil then
    msg.id = id
  end
  if profession ~= nil then
    msg.profession = profession
  end
  if rewarditem ~= nil then
    msg.rewarditem = rewarditem
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallMailLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, id, sysid, mailtype, title, rewarditem, mark, logid)
  local msg = LogCmd_pb.MailLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if id ~= nil then
    msg.id = id
  end
  if sysid ~= nil then
    msg.sysid = sysid
  end
  if mailtype ~= nil then
    msg.mailtype = mailtype
  end
  if title ~= nil then
    msg.title = title
  end
  if rewarditem ~= nil then
    msg.rewarditem = rewarditem
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallDojoLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, dojoid, mapid, passtype, level, mark, logid)
  local msg = LogCmd_pb.DojoLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if dojoid ~= nil then
    msg.dojoid = dojoid
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if passtype ~= nil then
    msg.passtype = passtype
  end
  if level ~= nil then
    msg.level = level
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallEnchantLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, equipguid, itemid, enchanttype, oldattr, newattr, oldbufid, newbufid, costitemid, costitemcount, costmoney, mark, logid)
  local msg = LogCmd_pb.EnchantLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if equipguid ~= nil then
    msg.equipguid = equipguid
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if enchanttype ~= nil then
    msg.enchanttype = enchanttype
  end
  if oldattr ~= nil then
    msg.oldattr = oldattr
  end
  if newattr ~= nil then
    msg.newattr = newattr
  end
  if oldbufid ~= nil then
    msg.oldbufid = oldbufid
  end
  if newbufid ~= nil then
    msg.newbufid = newbufid
  end
  if costitemid ~= nil then
    msg.costitemid = costitemid
  end
  if costitemcount ~= nil then
    msg.costitemcount = costitemcount
  end
  if costmoney ~= nil then
    msg.costmoney = costmoney
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallGuildPrayLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, prayid, addattr, costitem, costmoney, costcon, mark, logid)
  local msg = LogCmd_pb.GuildPrayLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if prayid ~= nil then
    msg.prayid = prayid
  end
  if addattr ~= nil then
    msg.addattr = addattr
  end
  if costitem ~= nil then
    msg.costitem = costitem
  end
  if costmoney ~= nil then
    msg.costmoney = costmoney
  end
  if costcon ~= nil then
    msg.costcon = costcon
  end
  if mark ~= nil then
    for i = 1, #mark do
      table.insert(msg.mark, mark[i])
    end
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallUseSkillLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, skillid, logid)
  local msg = LogCmd_pb.UseSkillLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if skillid ~= nil then
    msg.skillid = skillid
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallActiveLogCmd(channel, cdkey, account, time, logid)
  local msg = LogCmd_pb.ActiveLogCmd()
  if channel ~= nil then
    msg.channel = channel
  end
  if cdkey ~= nil then
    msg.cdkey = cdkey
  end
  if account ~= nil then
    msg.account = account
  end
  if time ~= nil then
    msg.time = time
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallTradeLogCmd(cid, sid, pid, time, type, itemid, count, price, tax, moneycount, iteminfo, otherid, logid, strotherid, spend_quota)
  local msg = LogCmd_pb.TradeLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if type ~= nil then
    msg.type = type
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if count ~= nil then
    msg.count = count
  end
  if price ~= nil then
    msg.price = price
  end
  if tax ~= nil then
    msg.tax = tax
  end
  if moneycount ~= nil then
    msg.moneycount = moneycount
  end
  if iteminfo ~= nil then
    msg.iteminfo = iteminfo
  end
  if otherid ~= nil then
    msg.otherid = otherid
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if strotherid ~= nil then
    msg.strotherid = strotherid
  end
  if spend_quota ~= nil then
    msg.spend_quota = spend_quota
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallDeleteCharLogCmd(cid, sid, account, pid, time, eid, etype, logid)
  local msg = LogCmd_pb.DeleteCharLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallComposeLogCmd(cid, sid, account, pid, time, eid, etype, itemid, itemguid, cost, logid)
  local msg = LogCmd_pb.ComposeLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if itemguid ~= nil then
    msg.itemguid = itemguid
  end
  if cost ~= nil then
    msg.cost = cost
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallJumpzoneLogCmd(cid, sid, account, pid, time, eid, etype, oldzoneid, newzoneid, isfirst, cost, logid, mapid)
  local msg = LogCmd_pb.JumpzoneLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if oldzoneid ~= nil then
    msg.oldzoneid = oldzoneid
  end
  if newzoneid ~= nil then
    msg.newzoneid = newzoneid
  end
  if isfirst ~= nil then
    msg.isfirst = isfirst
  end
  if cost ~= nil then
    msg.cost = cost
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallTeamLogCmd(cid, sid, hid, account, pid, ispay, time, eid, etype, inid, otherid, logid)
  local msg = LogCmd_pb.TeamLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if hid ~= nil then
    msg.hid = hid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if ispay ~= nil then
    msg.ispay = ispay
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if inid ~= nil then
    msg.inid = inid
  end
  if otherid ~= nil then
    msg.otherid = otherid
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallTradeAdjustPriceLogCmd(cid, sid, pid, time, item_id, t, k, sold_count, kt, qk, r, up_ratio, down_ratio, new_price, old_price, last_time, status, logid, real_price)
  local msg = LogCmd_pb.TradeAdjustPriceLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if item_id ~= nil then
    msg.item_id = item_id
  end
  if t ~= nil then
    msg.t = t
  end
  if k ~= nil then
    msg.k = k
  end
  if sold_count ~= nil then
    msg.sold_count = sold_count
  end
  if kt ~= nil then
    msg.kt = kt
  end
  if qk ~= nil then
    msg.qk = qk
  end
  if r ~= nil then
    msg.r = r
  end
  if up_ratio ~= nil then
    msg.up_ratio = up_ratio
  end
  if down_ratio ~= nil then
    msg.down_ratio = down_ratio
  end
  if new_price ~= nil then
    msg.new_price = new_price
  end
  if old_price ~= nil then
    msg.old_price = old_price
  end
  if last_time ~= nil then
    msg.last_time = last_time
  end
  if status ~= nil then
    msg.status = status
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if real_price ~= nil then
    msg.real_price = real_price
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallTradePriceLogCmd(cid, sid, pid, time, item_id, k, price, logid)
  local msg = LogCmd_pb.TradePriceLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if item_id ~= nil then
    msg.item_id = item_id
  end
  if k ~= nil then
    msg.k = k
  end
  if price ~= nil then
    msg.price = price
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallPetChangeLogCmd(cid, sid, account, pid, time, eid, etype, type, monsterid, name, before, after, skill_before, skill_after, logid)
  local msg = LogCmd_pb.PetChangeLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if type ~= nil then
    msg.type = type
  end
  if monsterid ~= nil then
    msg.monsterid = monsterid
  end
  if name ~= nil then
    msg.name = name
  end
  if before ~= nil then
    msg.before = before
  end
  if after ~= nil then
    msg.after = after
  end
  if skill_before ~= nil then
    msg.skill_before = skill_before
  end
  if skill_after ~= nil then
    msg.skill_after = skill_after
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallPetAdventureLogCmd(cid, sid, account, pid, time, eid, etype, type, id, names, cond, logid)
  local msg = LogCmd_pb.PetAdventureLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if eid ~= nil then
    msg.eid = eid
  end
  if etype ~= nil then
    msg.etype = etype
  end
  if type ~= nil then
    msg.type = type
  end
  if id ~= nil then
    msg.id = id
  end
  if names ~= nil then
    msg.names = names
  end
  if cond ~= nil then
    msg.cond = cond
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallInactiveUserLogCmd(cid, sid, account, pid, time, name, job, level, left_zeny, mapid, create_time, send_count, logid, guildid)
  local msg = LogCmd_pb.InactiveUserLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if name ~= nil then
    msg.name = name
  end
  if job ~= nil then
    msg.job = job
  end
  if level ~= nil then
    msg.level = level
  end
  if left_zeny ~= nil then
    msg.left_zeny = left_zeny
  end
  if mapid ~= nil then
    msg.mapid = mapid
  end
  if create_time ~= nil then
    msg.create_time = create_time
  end
  if send_count ~= nil then
    msg.send_count = send_count
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if guildid ~= nil then
    msg.guildid = guildid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallTradeUntakeLogCmd(cid, sid, pid, time, name, zeny, guildname, logid)
  local msg = LogCmd_pb.TradeUntakeLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if name ~= nil then
    msg.name = name
  end
  if zeny ~= nil then
    msg.zeny = zeny
  end
  if guildname ~= nil then
    msg.guildname = guildname
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallCreditLogCmd(cid, sid, pid, time, name, type, before, after, logid)
  local msg = LogCmd_pb.CreditLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if name ~= nil then
    msg.name = name
  end
  if type ~= nil then
    msg.type = type
  end
  if before ~= nil then
    msg.before = before
  end
  if after ~= nil then
    msg.after = after
  end
  if logid ~= nil then
    msg.logid = logid
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallTradeGiveLogCmd(cid, sid, pid, time, event, itemid, quota, iteminfo, otherid, logid, name, othername, givetime, givetype, itemcount)
  local msg = LogCmd_pb.TradeGiveLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if event ~= nil then
    msg.event = event
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if quota ~= nil then
    msg.quota = quota
  end
  if iteminfo ~= nil then
    msg.iteminfo = iteminfo
  end
  if otherid ~= nil then
    msg.otherid = otherid
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if name ~= nil then
    msg.name = name
  end
  if othername ~= nil then
    msg.othername = othername
  end
  if givetime ~= nil then
    msg.givetime = givetime
  end
  if givetype ~= nil then
    msg.givetype = givetype
  end
  if itemcount ~= nil then
    msg.itemcount = itemcount
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallQuotaLogCmd(cid, sid, account, pid, time, logid, opttype, quotatype, changed, quota, lock)
  local msg = LogCmd_pb.QuotaLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if opttype ~= nil then
    msg.opttype = opttype
  end
  if quotatype ~= nil then
    msg.quotatype = quotatype
  end
  if changed ~= nil then
    msg.changed = changed
  end
  if quota ~= nil then
    msg.quota = quota
  end
  if lock ~= nil then
    msg.lock = lock
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallGuildItemLogCmd(cid, sid, gid, time, logid, itemid, changed, count, type)
  local msg = LogCmd_pb.GuildItemLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if gid ~= nil then
    msg.gid = gid
  end
  if time ~= nil then
    msg.time = time
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if changed ~= nil then
    msg.changed = changed
  end
  if count ~= nil then
    msg.count = count
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallAstrolabeLogCmd(cid, sid, account, pid, time, logid, itemid, changed, count, packcount, type)
  local msg = LogCmd_pb.AstrolabeLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if changed ~= nil then
    msg.changed = changed
  end
  if count ~= nil then
    msg.count = count
  end
  if packcount ~= nil then
    msg.packcount = packcount
  end
  if type ~= nil then
    msg.type = type
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:CallDebtLogCmd(cid, sid, account, pid, time, logid, itemid, olddebt, olddebtmax, debt, debtmax, after)
  local msg = LogCmd_pb.DebtLogCmd()
  if cid ~= nil then
    msg.cid = cid
  end
  if sid ~= nil then
    msg.sid = sid
  end
  if account ~= nil then
    msg.account = account
  end
  if pid ~= nil then
    msg.pid = pid
  end
  if time ~= nil then
    msg.time = time
  end
  if logid ~= nil then
    msg.logid = logid
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if olddebt ~= nil then
    msg.olddebt = olddebt
  end
  if olddebtmax ~= nil then
    msg.olddebtmax = olddebtmax
  end
  if debt ~= nil then
    msg.debt = debt
  end
  if debtmax ~= nil then
    msg.debtmax = debtmax
  end
  if after ~= nil then
    msg.after = after
  end
  self:SendProto(msg)
end
function ServiceLogCmdAutoProxy:RecvLoginLogCmd(data)
  self:Notify(ServiceEvent.LogCmdLoginLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvAccountLogCmd(data)
  self:Notify(ServiceEvent.LogCmdAccountLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvCreateLogCmd(data)
  self:Notify(ServiceEvent.LogCmdCreateLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvChangeFlagLogCmd(data)
  self:Notify(ServiceEvent.LogCmdChangeFlagLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvChargeLogCmd(data)
  self:Notify(ServiceEvent.LogCmdChargeLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvEventLogCmd(data)
  self:Notify(ServiceEvent.LogCmdEventLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvIncomeLogCmd(data)
  self:Notify(ServiceEvent.LogCmdIncomeLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvConsumeLogCmd(data)
  self:Notify(ServiceEvent.LogCmdConsumeLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvItemLogCmd(data)
  self:Notify(ServiceEvent.LogCmdItemLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvPropsLogCmd(data)
  self:Notify(ServiceEvent.LogCmdPropsLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvTransactionLogCmd(data)
  self:Notify(ServiceEvent.LogCmdTransactionLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvChatLogCmd(data)
  self:Notify(ServiceEvent.LogCmdChatLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvLevelLogCmd(data)
  self:Notify(ServiceEvent.LogCmdLevelLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvOnlineLogCmd(data)
  self:Notify(ServiceEvent.LogCmdOnlineLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvCheckpointLogCmd(data)
  self:Notify(ServiceEvent.LogCmdCheckpointLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvRankLogCmd(data)
  self:Notify(ServiceEvent.LogCmdRankLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvQueryChatLogCmd(data)
  self:Notify(ServiceEvent.LogCmdQueryChatLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvChangeLogCmd(data)
  self:Notify(ServiceEvent.LogCmdChangeLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvEquipLogCmd(data)
  self:Notify(ServiceEvent.LogCmdEquipLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvCardLogCmd(data)
  self:Notify(ServiceEvent.LogCmdCardLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvEquipUpLogCmd(data)
  self:Notify(ServiceEvent.LogCmdEquipUpLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvSocailLogCmd(data)
  self:Notify(ServiceEvent.LogCmdSocailLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvQuestLogCmd(data)
  self:Notify(ServiceEvent.LogCmdQuestLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvManualLogCmd(data)
  self:Notify(ServiceEvent.LogCmdManualLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvCompleteLogCmd(data)
  self:Notify(ServiceEvent.LogCmdCompleteLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvTowerLogCmd(data)
  self:Notify(ServiceEvent.LogCmdTowerLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvItemOperLogCmd(data)
  self:Notify(ServiceEvent.LogCmdItemOperLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvKillLogCmd(data)
  self:Notify(ServiceEvent.LogCmdKillLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvRewardLogCmd(data)
  self:Notify(ServiceEvent.LogCmdRewardLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvMailLogCmd(data)
  self:Notify(ServiceEvent.LogCmdMailLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvDojoLogCmd(data)
  self:Notify(ServiceEvent.LogCmdDojoLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvEnchantLogCmd(data)
  self:Notify(ServiceEvent.LogCmdEnchantLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvGuildPrayLogCmd(data)
  self:Notify(ServiceEvent.LogCmdGuildPrayLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvUseSkillLogCmd(data)
  self:Notify(ServiceEvent.LogCmdUseSkillLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvActiveLogCmd(data)
  self:Notify(ServiceEvent.LogCmdActiveLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvTradeLogCmd(data)
  self:Notify(ServiceEvent.LogCmdTradeLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvDeleteCharLogCmd(data)
  self:Notify(ServiceEvent.LogCmdDeleteCharLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvComposeLogCmd(data)
  self:Notify(ServiceEvent.LogCmdComposeLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvJumpzoneLogCmd(data)
  self:Notify(ServiceEvent.LogCmdJumpzoneLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvTeamLogCmd(data)
  self:Notify(ServiceEvent.LogCmdTeamLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvTradeAdjustPriceLogCmd(data)
  self:Notify(ServiceEvent.LogCmdTradeAdjustPriceLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvTradePriceLogCmd(data)
  self:Notify(ServiceEvent.LogCmdTradePriceLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvPetChangeLogCmd(data)
  self:Notify(ServiceEvent.LogCmdPetChangeLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvPetAdventureLogCmd(data)
  self:Notify(ServiceEvent.LogCmdPetAdventureLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvInactiveUserLogCmd(data)
  self:Notify(ServiceEvent.LogCmdInactiveUserLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvTradeUntakeLogCmd(data)
  self:Notify(ServiceEvent.LogCmdTradeUntakeLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvCreditLogCmd(data)
  self:Notify(ServiceEvent.LogCmdCreditLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvTradeGiveLogCmd(data)
  self:Notify(ServiceEvent.LogCmdTradeGiveLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvQuotaLogCmd(data)
  self:Notify(ServiceEvent.LogCmdQuotaLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvGuildItemLogCmd(data)
  self:Notify(ServiceEvent.LogCmdGuildItemLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvAstrolabeLogCmd(data)
  self:Notify(ServiceEvent.LogCmdAstrolabeLogCmd, data)
end
function ServiceLogCmdAutoProxy:RecvDebtLogCmd(data)
  self:Notify(ServiceEvent.LogCmdDebtLogCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.LogCmdLoginLogCmd = "ServiceEvent_LogCmdLoginLogCmd"
ServiceEvent.LogCmdAccountLogCmd = "ServiceEvent_LogCmdAccountLogCmd"
ServiceEvent.LogCmdCreateLogCmd = "ServiceEvent_LogCmdCreateLogCmd"
ServiceEvent.LogCmdChangeFlagLogCmd = "ServiceEvent_LogCmdChangeFlagLogCmd"
ServiceEvent.LogCmdChargeLogCmd = "ServiceEvent_LogCmdChargeLogCmd"
ServiceEvent.LogCmdEventLogCmd = "ServiceEvent_LogCmdEventLogCmd"
ServiceEvent.LogCmdIncomeLogCmd = "ServiceEvent_LogCmdIncomeLogCmd"
ServiceEvent.LogCmdConsumeLogCmd = "ServiceEvent_LogCmdConsumeLogCmd"
ServiceEvent.LogCmdItemLogCmd = "ServiceEvent_LogCmdItemLogCmd"
ServiceEvent.LogCmdPropsLogCmd = "ServiceEvent_LogCmdPropsLogCmd"
ServiceEvent.LogCmdTransactionLogCmd = "ServiceEvent_LogCmdTransactionLogCmd"
ServiceEvent.LogCmdChatLogCmd = "ServiceEvent_LogCmdChatLogCmd"
ServiceEvent.LogCmdLevelLogCmd = "ServiceEvent_LogCmdLevelLogCmd"
ServiceEvent.LogCmdOnlineLogCmd = "ServiceEvent_LogCmdOnlineLogCmd"
ServiceEvent.LogCmdCheckpointLogCmd = "ServiceEvent_LogCmdCheckpointLogCmd"
ServiceEvent.LogCmdRankLogCmd = "ServiceEvent_LogCmdRankLogCmd"
ServiceEvent.LogCmdQueryChatLogCmd = "ServiceEvent_LogCmdQueryChatLogCmd"
ServiceEvent.LogCmdChangeLogCmd = "ServiceEvent_LogCmdChangeLogCmd"
ServiceEvent.LogCmdEquipLogCmd = "ServiceEvent_LogCmdEquipLogCmd"
ServiceEvent.LogCmdCardLogCmd = "ServiceEvent_LogCmdCardLogCmd"
ServiceEvent.LogCmdEquipUpLogCmd = "ServiceEvent_LogCmdEquipUpLogCmd"
ServiceEvent.LogCmdSocailLogCmd = "ServiceEvent_LogCmdSocailLogCmd"
ServiceEvent.LogCmdQuestLogCmd = "ServiceEvent_LogCmdQuestLogCmd"
ServiceEvent.LogCmdManualLogCmd = "ServiceEvent_LogCmdManualLogCmd"
ServiceEvent.LogCmdCompleteLogCmd = "ServiceEvent_LogCmdCompleteLogCmd"
ServiceEvent.LogCmdTowerLogCmd = "ServiceEvent_LogCmdTowerLogCmd"
ServiceEvent.LogCmdItemOperLogCmd = "ServiceEvent_LogCmdItemOperLogCmd"
ServiceEvent.LogCmdKillLogCmd = "ServiceEvent_LogCmdKillLogCmd"
ServiceEvent.LogCmdRewardLogCmd = "ServiceEvent_LogCmdRewardLogCmd"
ServiceEvent.LogCmdMailLogCmd = "ServiceEvent_LogCmdMailLogCmd"
ServiceEvent.LogCmdDojoLogCmd = "ServiceEvent_LogCmdDojoLogCmd"
ServiceEvent.LogCmdEnchantLogCmd = "ServiceEvent_LogCmdEnchantLogCmd"
ServiceEvent.LogCmdGuildPrayLogCmd = "ServiceEvent_LogCmdGuildPrayLogCmd"
ServiceEvent.LogCmdUseSkillLogCmd = "ServiceEvent_LogCmdUseSkillLogCmd"
ServiceEvent.LogCmdActiveLogCmd = "ServiceEvent_LogCmdActiveLogCmd"
ServiceEvent.LogCmdTradeLogCmd = "ServiceEvent_LogCmdTradeLogCmd"
ServiceEvent.LogCmdDeleteCharLogCmd = "ServiceEvent_LogCmdDeleteCharLogCmd"
ServiceEvent.LogCmdComposeLogCmd = "ServiceEvent_LogCmdComposeLogCmd"
ServiceEvent.LogCmdJumpzoneLogCmd = "ServiceEvent_LogCmdJumpzoneLogCmd"
ServiceEvent.LogCmdTeamLogCmd = "ServiceEvent_LogCmdTeamLogCmd"
ServiceEvent.LogCmdTradeAdjustPriceLogCmd = "ServiceEvent_LogCmdTradeAdjustPriceLogCmd"
ServiceEvent.LogCmdTradePriceLogCmd = "ServiceEvent_LogCmdTradePriceLogCmd"
ServiceEvent.LogCmdPetChangeLogCmd = "ServiceEvent_LogCmdPetChangeLogCmd"
ServiceEvent.LogCmdPetAdventureLogCmd = "ServiceEvent_LogCmdPetAdventureLogCmd"
ServiceEvent.LogCmdInactiveUserLogCmd = "ServiceEvent_LogCmdInactiveUserLogCmd"
ServiceEvent.LogCmdTradeUntakeLogCmd = "ServiceEvent_LogCmdTradeUntakeLogCmd"
ServiceEvent.LogCmdCreditLogCmd = "ServiceEvent_LogCmdCreditLogCmd"
ServiceEvent.LogCmdTradeGiveLogCmd = "ServiceEvent_LogCmdTradeGiveLogCmd"
ServiceEvent.LogCmdQuotaLogCmd = "ServiceEvent_LogCmdQuotaLogCmd"
ServiceEvent.LogCmdGuildItemLogCmd = "ServiceEvent_LogCmdGuildItemLogCmd"
ServiceEvent.LogCmdAstrolabeLogCmd = "ServiceEvent_LogCmdAstrolabeLogCmd"
ServiceEvent.LogCmdDebtLogCmd = "ServiceEvent_LogCmdDebtLogCmd"
