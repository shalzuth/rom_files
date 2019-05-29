ServiceRecordCmdAutoProxy = class("ServiceRecordCmdAutoProxy", ServiceProxy)
ServiceRecordCmdAutoProxy.Instance = nil
ServiceRecordCmdAutoProxy.NAME = "ServiceRecordCmdAutoProxy"
function ServiceRecordCmdAutoProxy:ctor(proxyName)
  if ServiceRecordCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceRecordCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceRecordCmdAutoProxy.Instance = self
  end
end
function ServiceRecordCmdAutoProxy:Init()
end
function ServiceRecordCmdAutoProxy:onRegister()
  self:Listen(200, 1, function(data)
    self:RecvNotifyLoginRecordCmd(data)
  end)
  self:Listen(200, 2, function(data)
    self:RecvUserDataRecordCmd(data)
  end)
  self:Listen(200, 3, function(data)
    self:RecvErrUserCharBaseRecordCmd(data)
  end)
  self:Listen(200, 6, function(data)
    self:RecvMusicUpdateCmd(data)
  end)
  self:Listen(200, 7, function(data)
    self:RecvLoadLuaSceneRecordCmd(data)
  end)
  self:Listen(200, 14, function(data)
    self:RecvChangeAuthorizeRecordCmd(data)
  end)
  self:Listen(200, 15, function(data)
    self:RecvGuildMusicQueryRecordCmd(data)
  end)
  self:Listen(200, 16, function(data)
    self:RecvGuildMusicUpdateCmd(data)
  end)
  self:Listen(200, 17, function(data)
    self:RecvGuildMusicDeleteRecordCmd(data)
  end)
  self:Listen(200, 11, function(data)
    self:RecvDelPatchCharRecordCmd(data)
  end)
  self:Listen(200, 12, function(data)
    self:RecvChatSaveRecordCmd(data)
  end)
  self:Listen(200, 13, function(data)
    self:RecvQueryChatRecordCmd(data)
  end)
  self:Listen(200, 18, function(data)
    self:RecvUserRenameQueryRecordCmd(data)
  end)
  self:Listen(200, 19, function(data)
    self:RecvUserRenameResultRecordCmd(data)
  end)
  self:Listen(200, 20, function(data)
    self:RecvLotteryResultRecordCmd(data)
  end)
  self:Listen(200, 21, function(data)
    self:RecvReqUserProfessionCmd(data)
  end)
  self:Listen(200, 22, function(data)
    self:RecvProfessionSaveRecordCmd(data)
  end)
  self:Listen(200, 23, function(data)
    self:RecvProfessionQueryRecordCmd(data)
  end)
  self:Listen(200, 24, function(data)
    self:RecvCheatTagRecordCmd(data)
  end)
  self:Listen(200, 25, function(data)
    self:RecvCheatTagQueryRecordCmd(data)
  end)
  self:Listen(200, 26, function(data)
    self:RecvClickPosRecordCmd(data)
  end)
  self:Listen(200, 28, function(data)
    self:RecvClearClickPosDataCmd(data)
  end)
  self:Listen(200, 29, function(data)
    self:RecvClickPosClearFinishCmd(data)
  end)
  self:Listen(200, 27, function(data)
    self:RecvGCharDataUpdateRecordCmd(data)
  end)
  self:Listen(200, 30, function(data)
    self:RecvKFCEnrollRecordCmd(data)
  end)
  self:Listen(200, 31, function(data)
    self:RecvKFCEnrollReplyCmd(data)
  end)
  self:Listen(200, 32, function(data)
    self:RecvKFCEnrollQueryRecordCmd(data)
  end)
  self:Listen(200, 33, function(data)
    self:RecvKFCHasEnrolledRecordCmd(data)
  end)
  self:Listen(200, 34, function(data)
    self:RecvKFCPhoneQueryRecordCmd(data)
  end)
  self:Listen(200, 35, function(data)
    self:RecvKFCHasPhoneUsedRecordCmd(data)
  end)
end
function ServiceRecordCmdAutoProxy:CallNotifyLoginRecordCmd(id, accid, sceneName)
  local msg = RecordCmd_pb.NotifyLoginRecordCmd()
  if id ~= nil then
    msg.id = id
  end
  if accid ~= nil then
    msg.accid = accid
  end
  if sceneName ~= nil then
    msg.sceneName = sceneName
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallUserDataRecordCmd(charid, accid, unregType, first, over, data, zoneid, processid, timestamps, saveindex)
  local msg = RecordCmd_pb.UserDataRecordCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if accid ~= nil then
    msg.accid = accid
  end
  if unregType ~= nil then
    msg.unregType = unregType
  end
  if first ~= nil then
    msg.first = first
  end
  if over ~= nil then
    msg.over = over
  end
  if data ~= nil then
    msg.data = data
  end
  if zoneid ~= nil then
    msg.zoneid = zoneid
  end
  if processid ~= nil then
    msg.processid = processid
  end
  if timestamps ~= nil then
    msg.timestamps = timestamps
  end
  if saveindex ~= nil then
    msg.saveindex = saveindex
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallErrUserCharBaseRecordCmd(id)
  local msg = RecordCmd_pb.ErrUserCharBaseRecordCmd()
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallMusicUpdateCmd(item)
  local msg = RecordCmd_pb.MusicUpdateCmd()
  if item ~= nil and item.charid ~= nil then
    msg.item.charid = item.charid
  end
  if item ~= nil and item.demandtime ~= nil then
    msg.item.demandtime = item.demandtime
  end
  if item ~= nil and item.mapid ~= nil then
    msg.item.mapid = item.mapid
  end
  if item ~= nil and item.npcid ~= nil then
    msg.item.npcid = item.npcid
  end
  if item ~= nil and item.musicid ~= nil then
    msg.item.musicid = item.musicid
  end
  if item ~= nil and item.starttime ~= nil then
    msg.item.starttime = item.starttime
  end
  if item ~= nil and item.endtime ~= nil then
    msg.item.endtime = item.endtime
  end
  if item ~= nil and item.status ~= nil then
    msg.item.status = item.status
  end
  if item ~= nil and item.name ~= nil then
    msg.item.name = item.name
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallLoadLuaSceneRecordCmd(table, lua, log)
  local msg = RecordCmd_pb.LoadLuaSceneRecordCmd()
  if table ~= nil then
    msg.table = table
  end
  if lua ~= nil then
    msg.lua = lua
  end
  if log ~= nil then
    msg.log = log
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallChangeAuthorizeRecordCmd(accid, password, resettime)
  local msg = RecordCmd_pb.ChangeAuthorizeRecordCmd()
  if accid ~= nil then
    msg.accid = accid
  end
  if password ~= nil then
    msg.password = password
  end
  if resettime ~= nil then
    msg.resettime = resettime
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallGuildMusicQueryRecordCmd(scenename, sceneid, guildid, items)
  local msg = RecordCmd_pb.GuildMusicQueryRecordCmd()
  if scenename ~= nil then
    msg.scenename = scenename
  end
  if sceneid ~= nil then
    msg.sceneid = sceneid
  end
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallGuildMusicUpdateCmd(guildid, item)
  local msg = RecordCmd_pb.GuildMusicUpdateCmd()
  if guildid ~= nil then
    msg.guildid = guildid
  end
  if item ~= nil and item.charid ~= nil then
    msg.item.charid = item.charid
  end
  if item ~= nil and item.demandtime ~= nil then
    msg.item.demandtime = item.demandtime
  end
  if item ~= nil and item.mapid ~= nil then
    msg.item.mapid = item.mapid
  end
  if item ~= nil and item.npcid ~= nil then
    msg.item.npcid = item.npcid
  end
  if item ~= nil and item.musicid ~= nil then
    msg.item.musicid = item.musicid
  end
  if item ~= nil and item.starttime ~= nil then
    msg.item.starttime = item.starttime
  end
  if item ~= nil and item.endtime ~= nil then
    msg.item.endtime = item.endtime
  end
  if item ~= nil and item.status ~= nil then
    msg.item.status = item.status
  end
  if item ~= nil and item.name ~= nil then
    msg.item.name = item.name
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallGuildMusicDeleteRecordCmd(guildid)
  local msg = RecordCmd_pb.GuildMusicDeleteRecordCmd()
  if guildid ~= nil then
    msg.guildid = guildid
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallDelPatchCharRecordCmd(charid, type, accid)
  local msg = RecordCmd_pb.DelPatchCharRecordCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if type ~= nil then
    msg.type = type
  end
  if accid ~= nil then
    msg.accid = accid
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallChatSaveRecordCmd(charid, portrait, time, data)
  local msg = RecordCmd_pb.ChatSaveRecordCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if portrait ~= nil then
    msg.portrait = portrait
  end
  if time ~= nil then
    msg.time = time
  end
  if data ~= nil then
    msg.data = data
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallUserRenameQueryRecordCmd(charid, accid, oldname, newname, scenename, code)
  local msg = RecordCmd_pb.UserRenameQueryRecordCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if accid ~= nil then
    msg.accid = accid
  end
  if oldname ~= nil then
    msg.oldname = oldname
  end
  if newname ~= nil then
    msg.newname = newname
  end
  if scenename ~= nil then
    msg.scenename = scenename
  end
  if code ~= nil then
    msg.code = code
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallUserRenameResultRecordCmd(charid, accid, newname, oldname, success)
  local msg = RecordCmd_pb.UserRenameResultRecordCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if accid ~= nil then
    msg.accid = accid
  end
  if newname ~= nil then
    msg.newname = newname
  end
  if oldname ~= nil then
    msg.oldname = oldname
  end
  if success ~= nil then
    msg.success = success
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallLotteryResultRecordCmd(charid, itemid, name, itemname, type, rate)
  local msg = RecordCmd_pb.LotteryResultRecordCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if itemid ~= nil then
    msg.itemid = itemid
  end
  if name ~= nil then
    msg.name = name
  end
  if itemname ~= nil then
    msg.itemname = itemname
  end
  if type ~= nil then
    msg.type = type
  end
  if rate ~= nil then
    msg.rate = rate
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallReqUserProfessionCmd(charid, accid, scenename, datas)
  local msg = RecordCmd_pb.ReqUserProfessionCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if accid ~= nil then
    msg.accid = accid
  end
  if scenename ~= nil then
    msg.scenename = scenename
  end
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallProfessionSaveRecordCmd(charid, branch, data)
  local msg = RecordCmd_pb.ProfessionSaveRecordCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if branch ~= nil then
    msg.branch = branch
  end
  if data ~= nil then
    msg.data = data
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallProfessionQueryRecordCmd(charid, scenename, datas)
  local msg = RecordCmd_pb.ProfessionQueryRecordCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if scenename ~= nil then
    msg.scenename = scenename
  end
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallCheatTagRecordCmd(charid, avginterval, avgframe, count, cheated, mvpandmini)
  local msg = RecordCmd_pb.CheatTagRecordCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if avginterval ~= nil then
    msg.avginterval = avginterval
  end
  if avgframe ~= nil then
    msg.avgframe = avgframe
  end
  if count ~= nil then
    msg.count = count
  end
  if cheated ~= nil then
    msg.cheated = cheated
  end
  if mvpandmini ~= nil then
    msg.mvpandmini = mvpandmini
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallCheatTagQueryRecordCmd(charid, scenename)
  local msg = RecordCmd_pb.CheatTagQueryRecordCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if scenename ~= nil then
    msg.scenename = scenename
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallClickPosRecordCmd(charid, scenename, clickposlist)
  local msg = RecordCmd_pb.ClickPosRecordCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if scenename ~= nil then
    msg.scenename = scenename
  end
  if clickposlist ~= nil then
    for i = 1, #clickposlist do
      table.insert(msg.clickposlist, clickposlist[i])
    end
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallClearClickPosDataCmd(charid, scenename)
  local msg = RecordCmd_pb.ClearClickPosDataCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if scenename ~= nil then
    msg.scenename = scenename
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallClickPosClearFinishCmd(charid)
  local msg = RecordCmd_pb.ClickPosClearFinishCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallGCharDataUpdateRecordCmd(charid, accid, datas)
  local msg = RecordCmd_pb.GCharDataUpdateRecordCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if accid ~= nil then
    msg.accid = accid
  end
  if datas ~= nil then
    for i = 1, #datas do
      table.insert(msg.datas, datas[i])
    end
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallKFCEnrollRecordCmd(phone, charid, district, scenename)
  local msg = RecordCmd_pb.KFCEnrollRecordCmd()
  if phone ~= nil then
    msg.phone = phone
  end
  if charid ~= nil then
    msg.charid = charid
  end
  if district ~= nil then
    msg.district = district
  end
  if scenename ~= nil then
    msg.scenename = scenename
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallKFCEnrollReplyCmd(result, district, index, charid)
  local msg = RecordCmd_pb.KFCEnrollReplyCmd()
  if result ~= nil then
    msg.result = result
  end
  if district ~= nil then
    msg.district = district
  end
  if index ~= nil then
    msg.index = index
  end
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallKFCEnrollQueryRecordCmd(charid, scenename)
  local msg = RecordCmd_pb.KFCEnrollQueryRecordCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if scenename ~= nil then
    msg.scenename = scenename
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallKFCHasEnrolledRecordCmd(charid, hasenrolled)
  local msg = RecordCmd_pb.KFCHasEnrolledRecordCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if hasenrolled ~= nil then
    msg.hasenrolled = hasenrolled
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallKFCPhoneQueryRecordCmd(charid, scenename, phone)
  local msg = RecordCmd_pb.KFCPhoneQueryRecordCmd()
  if charid ~= nil then
    msg.charid = charid
  end
  if scenename ~= nil then
    msg.scenename = scenename
  end
  if phone ~= nil then
    msg.phone = phone
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:CallKFCHasPhoneUsedRecordCmd(phone, hasenrolled, charid)
  local msg = RecordCmd_pb.KFCHasPhoneUsedRecordCmd()
  if phone ~= nil then
    msg.phone = phone
  end
  if hasenrolled ~= nil then
    msg.hasenrolled = hasenrolled
  end
  if charid ~= nil then
    msg.charid = charid
  end
  self:SendProto(msg)
end
function ServiceRecordCmdAutoProxy:RecvNotifyLoginRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdNotifyLoginRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvUserDataRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdUserDataRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvErrUserCharBaseRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdErrUserCharBaseRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvMusicUpdateCmd(data)
  self:Notify(ServiceEvent.RecordCmdMusicUpdateCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvLoadLuaSceneRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdLoadLuaSceneRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvChangeAuthorizeRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdChangeAuthorizeRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvGuildMusicQueryRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdGuildMusicQueryRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvGuildMusicUpdateCmd(data)
  self:Notify(ServiceEvent.RecordCmdGuildMusicUpdateCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvGuildMusicDeleteRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdGuildMusicDeleteRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvDelPatchCharRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdDelPatchCharRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvChatSaveRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdChatSaveRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvQueryChatRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdQueryChatRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvUserRenameQueryRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdUserRenameQueryRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvUserRenameResultRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdUserRenameResultRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvLotteryResultRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdLotteryResultRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvReqUserProfessionCmd(data)
  self:Notify(ServiceEvent.RecordCmdReqUserProfessionCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvProfessionSaveRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdProfessionSaveRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvProfessionQueryRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdProfessionQueryRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvCheatTagRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdCheatTagRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvCheatTagQueryRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdCheatTagQueryRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvClickPosRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdClickPosRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvClearClickPosDataCmd(data)
  self:Notify(ServiceEvent.RecordCmdClearClickPosDataCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvClickPosClearFinishCmd(data)
  self:Notify(ServiceEvent.RecordCmdClickPosClearFinishCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvGCharDataUpdateRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdGCharDataUpdateRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvKFCEnrollRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdKFCEnrollRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvKFCEnrollReplyCmd(data)
  self:Notify(ServiceEvent.RecordCmdKFCEnrollReplyCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvKFCEnrollQueryRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdKFCEnrollQueryRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvKFCHasEnrolledRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdKFCHasEnrolledRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvKFCPhoneQueryRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdKFCPhoneQueryRecordCmd, data)
end
function ServiceRecordCmdAutoProxy:RecvKFCHasPhoneUsedRecordCmd(data)
  self:Notify(ServiceEvent.RecordCmdKFCHasPhoneUsedRecordCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.RecordCmdNotifyLoginRecordCmd = "ServiceEvent_RecordCmdNotifyLoginRecordCmd"
ServiceEvent.RecordCmdUserDataRecordCmd = "ServiceEvent_RecordCmdUserDataRecordCmd"
ServiceEvent.RecordCmdErrUserCharBaseRecordCmd = "ServiceEvent_RecordCmdErrUserCharBaseRecordCmd"
ServiceEvent.RecordCmdMusicUpdateCmd = "ServiceEvent_RecordCmdMusicUpdateCmd"
ServiceEvent.RecordCmdLoadLuaSceneRecordCmd = "ServiceEvent_RecordCmdLoadLuaSceneRecordCmd"
ServiceEvent.RecordCmdChangeAuthorizeRecordCmd = "ServiceEvent_RecordCmdChangeAuthorizeRecordCmd"
ServiceEvent.RecordCmdGuildMusicQueryRecordCmd = "ServiceEvent_RecordCmdGuildMusicQueryRecordCmd"
ServiceEvent.RecordCmdGuildMusicUpdateCmd = "ServiceEvent_RecordCmdGuildMusicUpdateCmd"
ServiceEvent.RecordCmdGuildMusicDeleteRecordCmd = "ServiceEvent_RecordCmdGuildMusicDeleteRecordCmd"
ServiceEvent.RecordCmdDelPatchCharRecordCmd = "ServiceEvent_RecordCmdDelPatchCharRecordCmd"
ServiceEvent.RecordCmdChatSaveRecordCmd = "ServiceEvent_RecordCmdChatSaveRecordCmd"
ServiceEvent.RecordCmdQueryChatRecordCmd = "ServiceEvent_RecordCmdQueryChatRecordCmd"
ServiceEvent.RecordCmdUserRenameQueryRecordCmd = "ServiceEvent_RecordCmdUserRenameQueryRecordCmd"
ServiceEvent.RecordCmdUserRenameResultRecordCmd = "ServiceEvent_RecordCmdUserRenameResultRecordCmd"
ServiceEvent.RecordCmdLotteryResultRecordCmd = "ServiceEvent_RecordCmdLotteryResultRecordCmd"
ServiceEvent.RecordCmdReqUserProfessionCmd = "ServiceEvent_RecordCmdReqUserProfessionCmd"
ServiceEvent.RecordCmdProfessionSaveRecordCmd = "ServiceEvent_RecordCmdProfessionSaveRecordCmd"
ServiceEvent.RecordCmdProfessionQueryRecordCmd = "ServiceEvent_RecordCmdProfessionQueryRecordCmd"
ServiceEvent.RecordCmdCheatTagRecordCmd = "ServiceEvent_RecordCmdCheatTagRecordCmd"
ServiceEvent.RecordCmdCheatTagQueryRecordCmd = "ServiceEvent_RecordCmdCheatTagQueryRecordCmd"
ServiceEvent.RecordCmdClickPosRecordCmd = "ServiceEvent_RecordCmdClickPosRecordCmd"
ServiceEvent.RecordCmdClearClickPosDataCmd = "ServiceEvent_RecordCmdClearClickPosDataCmd"
ServiceEvent.RecordCmdClickPosClearFinishCmd = "ServiceEvent_RecordCmdClickPosClearFinishCmd"
ServiceEvent.RecordCmdGCharDataUpdateRecordCmd = "ServiceEvent_RecordCmdGCharDataUpdateRecordCmd"
ServiceEvent.RecordCmdKFCEnrollRecordCmd = "ServiceEvent_RecordCmdKFCEnrollRecordCmd"
ServiceEvent.RecordCmdKFCEnrollReplyCmd = "ServiceEvent_RecordCmdKFCEnrollReplyCmd"
ServiceEvent.RecordCmdKFCEnrollQueryRecordCmd = "ServiceEvent_RecordCmdKFCEnrollQueryRecordCmd"
ServiceEvent.RecordCmdKFCHasEnrolledRecordCmd = "ServiceEvent_RecordCmdKFCHasEnrolledRecordCmd"
ServiceEvent.RecordCmdKFCPhoneQueryRecordCmd = "ServiceEvent_RecordCmdKFCPhoneQueryRecordCmd"
ServiceEvent.RecordCmdKFCHasPhoneUsedRecordCmd = "ServiceEvent_RecordCmdKFCHasPhoneUsedRecordCmd"
