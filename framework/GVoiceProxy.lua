GVoiceProxy = class("GVoiceProxy", pm.Proxy)
GVoiceProxy.Instance = nil
GVoiceProxy.NAME = "GVoiceProxy"
GVoiceTarget = {
  OpenMic = 1,
  CloseMic = 2,
  BuildTeamAndOpenMic = 2,
  BuildTeamAndCloseMic = 3,
  EnterGuildChannelAndCloseMic = 4,
  EnterGuildChannelAndOpenMic = 5,
  EnterGuildChannelAndNotAuthorized = 6,
  BuildTeamAndKeepLastMicState = 7
}
function GVoiceProxy:DebugLog(msg)
  if false then
    LogUtility.Info("GVoiceProxy::::" .. msg)
  end
end
function GVoiceProxy:ctor(proxyName, data)
  self.proxyName = proxyName or GVoiceProxy.NAME
  if GVoiceProxy.Instance == nil then
    GVoiceProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
  self:AddEvts()
end
function GVoiceProxy:TimeTickTest()
  if AppEnvConfig.IsTestApp then
  end
end
VoiceEnvPowerFromOthers = 0.2
VoiceEnvPowerFromMySelf = 0.2
function GVoiceProxy:IsOpenByCeHua()
  return false
end
function GVoiceProxy:HandleRecorderMeteringPeakPowerNotify(msg)
  self:DebugLog("========HandleRecorderMeteringPeakPowerNotify=====msg:" .. msg)
end
function GVoiceProxy:HandleReceiveTextMessageNotify(msg)
  self:DebugLog("$$$HandleReceiveTextMessageNotify Game.Myself.data.id:" .. Game.Myself.data.id)
  local decodeTable = json.decode(msg)
  local data = {}
  if decodeTable.userId and decodeTable.avgPower then
    data.userId = decodeTable.userId
    data.avgPower = tonumber(decodeTable.avgPower)
  else
    helplog("\229\143\130\230\149\176\233\151\174\233\162\152\239\188\129")
    return
  end
  if Game.Myself.data.id ~= data.userId then
    if data.avgPower and data.avgPower > VoiceEnvPowerFromOthers then
      data.showMic = true
      self:DebugLog("$$$data.showMic = true data.avgPower:" .. data.avgPower .. "\tVoiceEnvPower:" .. VoiceEnvPowerFromOthers .. "\tdata.userId" .. data.userId)
    else
      data.showMic = false
      self:DebugLog("$$$data.showMic = true data.avgPower:" .. data.avgPower .. "\tVoiceEnvPower:" .. VoiceEnvPowerFromOthers .. "\tdata.userId" .. data.userId)
    end
    if self.curChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index then
      self:DebugLog("$$$others:TEAM_ENUM")
      EventManager.Me():PassEvent(TeamEvent.VoiceChange, data)
    else
      self:DebugLog("$$$others:Guild")
      EventManager.Me():PassEvent(GuildEvent.VoiceChange, data)
    end
  else
    self:DebugLog("$$$myself:")
    if data.avgPower and data.avgPower > VoiceEnvPowerFromMySelf then
      data.showMic = true
      self:DebugLog("$$$data.showMic = true data.avgPower:" .. data.avgPower .. "\tVoiceEnvPower:" .. VoiceEnvPowerFromMySelf .. "\tdata.userId" .. data.userId)
    else
      data.showMic = false
      self:DebugLog("$$$data.showMic = true data.avgPower:" .. data.avgPower .. "\tVoiceEnvPower:" .. VoiceEnvPowerFromMySelf .. "\tdata.userId" .. data.userId)
    end
    EventManager.Me():PassEvent(MyselfEvent.VoiceChange, data)
  end
end
function GVoiceProxy:Init()
  if self:IsOpenByCeHua() == false then
    return
  end
  if ApplicationInfo.IsRunOnEditor() then
    return
  end
  do return end
  ROVoice.ChatSDKInit(0, "1003051", 1, function(msg)
    self:DebugLog("ROVoice.ChatSDKInit msg:" .. msg)
    self.hasInit = true
  end)
  ROVoice.ReceiveTextMessageNotify(function(msg)
    self:HandleReceiveTextMessageNotify(msg)
  end, function(msg)
  end, function(msg)
  end)
  ROVoice.LoginNotify(function(msg)
    self:DebugLog("@@@ROVoice.LoginNotify msg:" .. msg)
  end)
  ROVoice.LogoutNotify(function(msg)
    self:DebugLog("@@@ROVoice.LogoutNotify msg:" .. msg)
  end)
  function ROVoice._SendRealTimeVoiceMessageErrorNotify(msg)
    self:DebugLog("@@@_SendRealTimeVoiceMessageErrorNotify:" .. msg)
  end
  function ROVoice._ReceiveRealTimeVoiceMessageNofify(msg)
    self:DebugLog("@@@_ReceiveRealTimeVoiceMessageNofify:" .. msg)
  end
  function ROVoice._ReceiveTextMessageNotify(msg)
    self:DebugLog("@@@_ReceiveTextMessageNotify:" .. msg)
  end
  function ROVoice._RecorderMeteringPeakPowerNotify(msg)
    self:DebugLog("@@@ROVoice._RecorderMeteringPeakPowerNotify = function (msg)" .. msg)
  end
  function ROVoice._PlayMeteringPeakPowerNotify(msg)
    self:DebugLog("@@@_PlayMeteringPeakPowerNotify:" .. msg)
  end
  function ROVoice._AudioToolsRecorderMeteringPeakPowerNotify(msg)
    self:DebugLog("@@@_AudioToolsRecorderMeteringPeakPowerNotify:" .. msg)
  end
  function ROVoice._AudioToolsPlayMeteringPeakPowerNotify(msg)
    self:DebugLog("@@@_AudioToolsPlayMeteringPeakPowerNotify:" .. msg)
  end
  function ROVoice._MicStateNotify(msg)
    self:DebugLog("@@@_MicStateNotify:" .. msg)
  end
  function ROVoice._onConnectFail(msg)
    self:DebugLog("@@@_onConnectFail:" .. msg)
  end
  function ROVoice._onReconnectSuccess(msg)
    self:DebugLog("@@@_onReconnectSuccess:" .. msg)
  end
  function ROVoice._LoginNotify(msg)
    self:DebugLog("@@@_LoginNotify:" .. msg)
  end
  function ROVoice._LogoutNotify(msg)
    self:DebugLog("@@@_LogoutNotify:" .. msg)
  end
end
function GVoiceProxy:AddEvts()
end
function GVoiceProxy:ChangeTeamVoiceState(teamVoiceState)
  self:ChangeVoiceState(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index, teamVoiceState)
end
function GVoiceProxy:ChangeVoiceState(voiceType, teamVoiceState)
end
function GVoiceProxy:ChangeGuildVoiceState(guildVoiceState)
  self:ChangeVoiceState(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index, guildVoiceState)
end
function GVoiceProxy:RecvEnterTeam(data)
  if TeamProxy.Instance:IHaveTeam() and self.curTarget == GVoiceTarget.BuildTeamAndOpenMic then
    self:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)
  elseif TeamProxy.Instance:IHaveTeam() and self.curTarget == GVoiceTarget.BuildTeamAndCloseMic then
    self:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)
  end
end
function GVoiceProxy:Reset()
  self.curTarget = nil
  TimeTickManager.Me():ClearTick(self, 3)
end
function GVoiceProxy:RecvExitTeam(data)
  if self:IsOpenByCeHua() == false then
    return
  end
  if ApplicationInfo.IsRunOnEditor() then
    MsgManager.FloatMsg(nil, "\229\189\147\229\137\141\228\184\186\231\188\150\232\190\145\229\153\168 \230\151\160\230\179\149\228\189\191\231\148\168\232\175\173\233\159\179\229\138\159\232\131\189")
    self.curChannel = nil
    self.roomid = nil
    return
  end
  if self.curChannel == nil then
    self:DebugLog("\229\189\147\229\137\141\228\184\141\229\156\168\228\187\187\228\189\149\232\175\173\233\159\179\233\162\145\233\129\147\228\184\173 \228\184\141\231\148\168\229\164\132\231\144\134")
    return
  elseif self.curChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index then
    MsgManager.ShowMsgByID(25489)
    ROVoice.Logout(function(msg)
      self:DebugLog("ROVoice.Logout1 msg:" .. msg)
      self.curChannel = nil
      self.roomid = nil
    end)
  elseif self.curChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index then
    MsgManager.ShowMsgByID(25493)
    ROVoice.Logout(function(msg)
      self:DebugLog("ROVoice.Logout2 msg:" .. msg)
      self.curChannel = nil
      self.roomid = nil
    end)
  end
end
function GVoiceProxy:LeaveGVoiceRoomAtChannel(targetChannel)
  if self:IsOpenByCeHua() == false then
    return
  end
  if self.curChannel == nil then
  elseif self.curChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index and targetChannel == self.curChannel then
    MsgManager.ShowMsgByID(25489)
  elseif self.curChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index and targetChannel == self.curChannel then
    MsgManager.ShowMsgByID(25493)
  end
  if self.roomid ~= nil then
    self.roomid = nil
  end
  self.curChannel = nil
end
function GVoiceProxy:GetCurChannel()
  return self.curChannel or nil
end
function GVoiceProxy:RecvQueryRealtimeVoiceIDCmd(data)
  self:DebugLog("!!!!!!!!!!!!!!GVoiceProxy--> RecvQueryRealtimeVoiceIDCmd data.channel" .. data.channel)
  if self:IsOpenByCeHua() == false then
    return
  end
  if self.hasInit == false then
    self:DebugLog("!!!!!!!!!!!!!!\230\178\161\230\156\137\229\136\157\229\167\139\229\140\150")
    return
  end
  if self.curChannel == data.channel then
    self:DebugLog("\229\183\178\229\156\168\229\144\140\231\177\187\229\158\139\231\154\132\230\136\191\233\151\180\233\135\140\233\157\162")
    return
  end
  if self.curChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index then
    EventManager.Me():PassEvent(TeamEvent.VoiceChange, nil)
  elseif self.curChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index then
    EventManager.Me():PassEvent(GuildEvent.VoiceChange, nil)
  end
  self.curChannel = data.channel
  self.roomid = data.id
  self:DebugLog("+++++Game.Myself.data.id\239\188\154" .. Game.Myself.data.id .. "++++++++self.roomid:" .. self.roomid)
  EventManager.Me():PassEvent(MyselfEvent.EnterVoiceChannel, nil)
  if self.curTarget == GVoiceTarget.BuildTeamAndCloseMic then
    self:DebugLog("----1")
    MsgManager.FloatMsg(nil, ZhString.VoiceString.Team_MicPhoneHasAlreadyClosed)
    if self.hasInit then
      ROVoice.ChatSDKLogin(Game.Myself.data.id, self.roomid, function(msg)
        ROVoice.ChatMic(false, function(msg)
          self:DebugLog("++++1")
        end)
      end)
    end
  elseif self.curTarget == GVoiceTarget.BuildTeamAndOpenMic then
    self:DebugLog("----2")
    MsgManager.FloatMsg(nil, ZhString.VoiceString.Team_MicPhoneHasAlreadyOpened)
    self:DebugLog("----21")
    if self.hasInit then
      self:DebugLog("----22")
      ROVoice.ChatSDKLogin(Game.Myself.data.id, self.roomid, function(msg)
        self:DebugLog("----23")
        ROVoice.ChatMic(true, function(msg)
          self:DebugLog("++++2")
        end)
      end)
    end
  elseif self.curTarget == GVoiceTarget.EnterGuildChannelAndOpenMic then
    self:DebugLog("----3")
    MsgManager.FloatMsg(nil, ZhString.VoiceString.Guild_MicPhoneHasAlreadyOpened)
    if self.hasInit then
      ROVoice.ChatSDKLogin(Game.Myself.data.id, self.roomid, function(msg)
        ROVoice.ChatMic(true, function(msg)
          self:DebugLog("++++3")
        end)
      end)
    end
  elseif self.curTarget == GVoiceTarget.EnterGuildChannelAndCloseMic then
    self:DebugLog("----4")
    MsgManager.FloatMsg(nil, ZhString.VoiceString.Guild_MicPhoneHasAlreadyClosed)
    if self.hasInit then
      ROVoice.ChatSDKLogin(Game.Myself.data.id, self.roomid, function(msg)
        ROVoice.ChatMic(false, function(msg)
          self:DebugLog("++++4")
        end)
      end)
    end
  elseif self.curTarget == GVoiceTarget.EnterGuildChannelAndNotAuthorized then
    self:DebugLog("----5")
    MsgManager.FloatMsg(nil, ZhString.VoiceString.Guild_MicPhoneHasAlreadyClosed)
    MsgManager.FloatMsg(nil, ZhString.VoiceString.YouAreNotGuildAuthorized)
    if self.hasInit then
      ROVoice.ChatSDKLogin(Game.Myself.data.id, self.roomid, function(msg)
        ROVoice.ChatMic(false, function(msg)
          self:DebugLog("++++5")
        end)
      end)
    end
  elseif self.curTarget == GVoiceTarget.BuildTeamAndKeepLastMicState then
    self:DebugLog("----6")
    if self.hasInit then
      ROVoice.ChatSDKLogin(Game.Myself.data.id, self.roomid, function(msg)
        if self.LastMicState_IsMicOpen then
          ROVoice.ChatMic(true, function(msg)
            self:DebugLog("++++6")
            MsgManager.FloatMsg(nil, ZhString.VoiceString.Team_MicPhoneHasAlreadyOpened)
          end)
        else
          ROVoice.ChatMic(false, function(msg)
            self:DebugLog("++++7")
            MsgManager.FloatMsg(nil, ZhString.VoiceString.Team_MicPhoneHasAlreadyClosed)
          end)
        end
      end)
    end
  else
    self:DebugLog("----7")
    if self.hasInit then
      ROVoice.ChatSDKLogin(Game.Myself.data.id, self.roomid, function(msg)
        if self.LastMicState_IsMicOpen then
          ROVoice.ChatMic(true, function(msg)
            self:DebugLog("++++8")
            MsgManager.FloatMsg(nil, ZhString.VoiceString.Team_MicPhoneHasAlreadyOpened)
          end)
        else
          ROVoice.ChatMic(false, function(msg)
            self:DebugLog("++++9")
            MsgManager.FloatMsg(nil, ZhString.VoiceString.Team_MicPhoneHasAlreadyClosed)
          end)
        end
      end)
    end
  end
  self.curTarget = nil
end
function GVoiceProxy:GetPlayerChooseToJoinGuildVoice()
  return self.ChooseToJoinGuildVoice or false
end
function GVoiceProxy:SetPlayerChooseToJoinGuildVoice(b)
  self.ChooseToJoinGuildVoice = b
end
function GVoiceProxy:ActiveEnterChannel(channel)
  if ExternalInterfaces.DoIHaveRecordPermission ~= nil and ExternalInterfaces.DoIHaveRecordPermission() == false then
    MsgManager.ConfirmMsgByID(25859, function()
    end, function()
    end, nil)
  elseif ExternalInterfaces.DoIHaveRecordPermission == nil then
    self:DebugLog("ExternalInterfaces.DoIHaveRecordPermission==nil")
  end
  if self.curChannel == channel then
    self:DebugLog("\229\183\178\229\156\168\229\144\140\231\177\187\229\158\139\231\154\132\230\136\191\233\151\180\233\135\140")
    return
  end
  self:DebugLog("===============function GVoiceProxy:ActiveEnterChannel(channel)=========== channel:" .. channel)
  ServiceChatCmdProxy.Instance:CallQueryRealtimeVoiceIDCmd(channel, nil)
end
function GVoiceProxy:UseGVoiceInReal(channelIndex, roomid)
  if not self:HaveInitSuccess() then
    MsgManager.FloatMsg(nil, "\233\148\153\232\175\175\228\187\163\231\160\129\239\188\154013")
    return
  end
  if channelIndex == nil then
    MsgManager.FloatMsg(nil, "\233\148\153\232\175\175\228\187\163\231\160\129\239\188\154012")
  elseif channelIndex == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index then
  elseif channelIndex == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index then
  end
end
function GVoiceProxy:ConfirmMicState()
  if not self:IsMaiOpen() then
    self:DebugLog("\229\133\179\233\151\173mic")
    return
  end
end
function GVoiceProxy:ConfirmYangState()
  if not self:IsYangOpen() then
    self:DebugLog("\229\133\179\233\151\173\230\137\172\229\163\176\229\153\168")
    return
  end
end
function GVoiceProxy:HaveInitSuccess()
  if not self.haveInitSuccess then
    MsgManager.FloatMsg(nil, "\233\148\153\232\175\175\228\187\163\231\160\129\239\188\154014")
    return false
  else
    return true
  end
end
function GVoiceProxy:RecvBanRealtimeVoiceGuildCmd(data)
  self:DebugLog("GVoiceProxy--> RecvBanRealtimeVoiceGuildCmd")
end
function GVoiceProxy:RecvOpenRealtimeVoiceGuildCmd(data)
  helplog("GVoiceProxy--> RecvOpenRealtimeVoiceGuildCmd")
end
function GVoiceProxy:RecvOpenRealtimeVoiceTeamCmd(data)
  helplog("GVoiceProxy--> RecvOpenRealtimeVoiceTeamCmd")
end
function GVoiceProxy:RecvGuildMemberDataUpdateGuildCmd(data)
  self:DebugLog("GVoiceProxy--> RecvGuildMemberDataUpdateGuildCmd")
  for i = 1, #data.updates do
    local updateData = data.updates[i]
    if updateData.type == 27 and data.charid == Game.Myself.data.id then
      if updateData.value == 0 then
        self:DebugLog("\230\136\145\232\162\171\231\166\129\232\168\1281")
        if self.curChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index and self.roomid ~= nil and self.hasInit then
          ROVoice.ChatMic(false, function(msg)
          end)
        end
      elseif updateData.value == 1 then
        self:DebugLog("\230\136\145\230\178\161\232\162\171\231\166\129\232\168\1281")
      end
    end
  end
end
function GVoiceProxy:RecvMemberDataUpdate(data)
  self:DebugLog("function GVoiceProxy:RecvGuildMemberDataUpdateGuildCmd(data)")
  if TeamProxy.Instance.myTeam ~= nil then
    local myMembers = TeamProxy.Instance.myTeam:GetMembersList()
    for i = 1, #myMembers do
      local memberData = myMembers[i]
      if memberData.id == data.id and data.id == Game.Myself.data.id then
        if memberData:GetRealTimeVoice() == 0 then
          self:DebugLog("\232\162\171\231\166\129\232\168\1283")
          if self.curChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index and self.roomid ~= nil and self.hasInit then
            ROVoice.ChatMic(false, function(msg)
            end)
          end
        elseif memberData:GetRealTimeVoice() == 1 then
          self:DebugLog("\230\178\161\232\162\171\231\166\129\232\168\1283")
        end
      else
      end
      local note = {}
      note.userId = userId
      if memberData:GetRealTimeVoice() == 0 then
        note.ban = true
      else
        note.ban = false
      end
      EventManager.Me():PassEvent(MyselfEvent.EnterVoiceChannel, note)
    end
  end
end
function GVoiceProxy:IsMySelfGongHuiJinYan()
  if not GuildProxy.Instance:IHaveGuild() then
    self:DebugLog("\230\178\161\229\138\160\229\133\165\229\183\165\228\188\154")
    return false
  end
  local data = GuildProxy.Instance:GetMyGuildMemberData()
  if data then
    if data:IsRealtimevoice() == false then
      self:DebugLog("\229\183\178\232\162\171\231\166\129\232\168\1282")
      return true
    elseif data:IsRealtimevoice() == true then
      self:DebugLog("\230\178\161\232\162\171\231\166\129\232\168\1282")
      return false
    else
      self:DebugLog("\230\178\161\230\159\165\229\136\1762")
    end
  else
    self:DebugLog("\230\178\161\232\175\187\229\136\176\229\183\165\228\188\154\230\149\176\230\141\174")
    return false
  end
  return false
end
function GVoiceProxy:IsMySelfTeamJinYan()
  if TeamProxy.Instance.myTeam ~= nil then
    local myMembers = TeamProxy.Instance.myTeam:GetMembersList()
    for i = 1, #myMembers do
      local memberData = myMembers[i]
      if memberData.id == Game.Myself.data.id then
        if memberData:GetRealTimeVoice() == 0 then
          self:DebugLog("\229\183\178\232\162\171\231\166\129\232\168\1284")
          return true
        elseif memberData:GetRealTimeVoice() == 1 then
          self:DebugLog("\230\178\161\232\162\171\231\166\129\232\168\1284")
          return false
        end
      end
    end
  end
  self:DebugLog("\230\178\161\233\152\159\228\188\141")
  return false
end
function GVoiceProxy:IsTeamVoiceOpen()
  return self:IsThisFuncOpen(0)
end
function GVoiceProxy:GetBitByInt(num, index)
  return num >> index & 1 == 0
end
function GVoiceProxy:IsYangOpen()
  return self:IsThisFuncOpen(2)
end
function GVoiceProxy:IsMaiOpen()
  return self:IsThisFuncOpen(3)
end
function GVoiceProxy:IsThisFuncOpen(funcId)
  local setting = FunctionPerformanceSetting.Me()
  local gvoice = setting:GetSetting().gvoice
  local value = self:GetBitByInt(gvoice, funcId)
  return value
end
function GVoiceProxy:SetAllSetViewToGou()
  local gvoice = 0
  for i = 0, #self.gvoiceToggle do
    gvoice = self:GetIntByBit(gvoice, i, false)
  end
  local setting = FunctionPerformanceSetting.Me()
  setting:SetGVoice(gvoice)
end
function GVoiceProxy:GetIntByBit(num, index, b)
  if b then
    num = num + (1 << index)
  end
  return num
end
function GVoiceProxy:RecvEnterGuildGuildCmd(data)
end
function GVoiceProxy:IsThisCharIdRealtimeVoiceAvailable(charid)
  if self:IsOpenByCeHua() == false then
    return false
  end
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData == nil then
    return false
  end
  local guildMemberData = myGuildData:GetMemberByGuid(charid)
  if guildMemberData == nil then
    return false
  end
  if guildMemberData:IsRealtimevoice() then
    return true
  else
    return false
  end
end
function GVoiceProxy:SetCurGuildRealTimeVoiceCount(count)
  if count > GameConfig.Guild.realtime_voice_limit then
    self.curGuildRealTimeVoiceCount = 9
  else
    self.curGuildRealTimeVoiceCount = count
  end
end
function GVoiceProxy:GetCurGuildRealTimeVoiceCount()
  local curGuildRealTimeVoiceCount = 0
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData then
    local memberList = GuildProxy.Instance.myGuildData:GetMemberList()
    for i = 1, #memberList do
      if memberList[i]:IsRealtimevoice() == true then
        curGuildRealTimeVoiceCount = curGuildRealTimeVoiceCount + 1
      else
      end
    end
  end
  helplog("curGuildRealTimeVoiceCount:" .. curGuildRealTimeVoiceCount)
  return curGuildRealTimeVoiceCount
end
function GVoiceProxy:CloseMicEnterChannel()
  self.LastMicState_IsMicOpen = false
  if self.curChannel == nil then
    MsgManager.ConfirmMsgByID(25850, function()
      if GuildProxy.Instance:IHaveGuild() then
        self:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
        self.curTarget = GVoiceTarget.EnterGuildChannelAndCloseMic
        if self:IsMySelfGongHuiJinYan() then
          MsgManager.FloatMsg(nil, ZhString.VoiceString.YouAreNotGuildAuthorized)
        end
      else
        MsgManager.FloatMsg(nil, ZhString.VoiceString.YouDontHaveGuild)
      end
    end, function()
      if TeamProxy.Instance:IHaveTeam() then
        self:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)
        self.curTarget = GVoiceTarget.BuildTeamAndCloseMic
      else
        MsgManager.ConfirmMsgByID(25851, function()
          if not TeamProxy.Instance:IHaveTeam() then
            self:sendNotification(UIEvent.JumpPanel, {
              view = PanelConfig.TeamFindPopUp
            })
          else
            self:sendNotification(UIEvent.JumpPanel, {
              view = PanelConfig.TeamMemberListPopUp
            })
          end
          self.curTarget = GVoiceTarget.BuildTeamAndCloseMic
        end, function()
          self.curTarget = nil
        end, nil)
      end
    end, nil)
  else
    MsgManager.FloatMsg(nil, ZhString.VoiceString.MicPhoneHasAlreadyClosed)
    self.LastMicState_IsMicOpen = false
    if self.hasInit then
      ROVoice.ChatMic(false, function(msg)
      end)
    end
  end
end
function GVoiceProxy:OpenMicEnterChannel()
  self.LastMicState_IsMicOpen = true
  if self.curChannel == nil then
    MsgManager.ConfirmMsgByID(25850, function()
      if GuildProxy.Instance:IHaveGuild() then
        if self:IsMySelfGongHuiJinYan() then
          self:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
          self.curTarget = GVoiceTarget.EnterGuildChannelAndNotAuthorized
          MsgManager.FloatMsg(nil, ZhString.VoiceString.YouAreNotGuildAuthorized)
        else
          self:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
          self.curTarget = GVoiceTarget.EnterGuildChannelAndOpenMic
        end
      else
        MsgManager.FloatMsg(nil, ZhString.VoiceString.YouDontHaveGuild)
      end
    end, function()
      if TeamProxy.Instance:IHaveTeam() then
        self:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)
        self.curTarget = GVoiceTarget.BuildTeamAndOpenMic
        if self:IsMySelfTeamJinYan() == true then
          MsgManager.FloatMsg(nil, ZhString.VoiceString.YouAreNotAuthorizedByTeam)
        end
      else
        MsgManager.ConfirmMsgByID(25851, function()
          if not TeamProxy.Instance:IHaveTeam() then
            self:sendNotification(UIEvent.JumpPanel, {
              view = PanelConfig.TeamFindPopUp
            })
          else
            self:sendNotification(UIEvent.JumpPanel, {
              view = PanelConfig.TeamMemberListPopUp
            })
          end
          self.curTarget = GVoiceTarget.BuildTeamAndOpenMic
        end, function()
        end, nil)
      end
    end, nil)
  elseif self.curChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index then
    MsgManager.FloatMsg(nil, ZhString.VoiceString.MicPhoneHasAlreadyOpened)
    if self.hasInit then
      ROVoice.ChatMic(true, function(msg)
      end)
    end
  elseif self.curChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index then
    if self:IsMySelfGongHuiJinYan() then
      MsgManager.FloatMsg(nil, ZhString.VoiceString.YouAreNotAuthorized)
      if self.hasInit then
        ROVoice.ChatMic(false, function(msg)
        end)
      end
    else
      MsgManager.FloatMsg(nil, ZhString.VoiceString.MicPhoneHasAlreadyOpened)
      if self.hasInit then
        ROVoice.ChatMic(true, function(msg)
        end)
      end
    end
  end
end
function GVoiceProxy:SwitchChannel(toChannel)
  if self.curChannel == nil then
    self:DebugLog("GVoiceProxy:SwitchChannel(toChannel) toChannel: nil")
    MsgManager.ConfirmMsgByID(25850, function()
      if GuildProxy.Instance:IHaveGuild() then
        if self.LastMicState_IsMicOpen then
          if self:IsMySelfGongHuiJinYan() == false then
            self:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
            self.curTarget = GVoiceTarget.EnterGuildChannelAndOpenMic
          else
            self:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
            self.curTarget = GVoiceTarget.EnterGuildChannelAndNotAuthorized
          end
        else
          self:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
          self.curTarget = GVoiceTarget.EnterGuildChannelAndCloseMic
        end
      else
        MsgManager.FloatMsg(nil, ZhString.VoiceString.YouDontHaveGuild)
      end
    end, function()
      if TeamProxy.Instance:IHaveTeam() then
        self:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)
        self.curTarget = GVoiceTarget.BuildTeamAndKeepLastMicState
      else
        MsgManager.ConfirmMsgByID(25851, function()
          if not TeamProxy.Instance:IHaveTeam() then
            self:sendNotification(UIEvent.JumpPanel, {
              view = PanelConfig.TeamFindPopUp
            })
          else
            self:sendNotification(UIEvent.JumpPanel, {
              view = PanelConfig.TeamMemberListPopUp
            })
          end
          self.curTarget = GVoiceTarget.BuildTeamAndKeepLastMicState
        end, function()
        end, nil)
      end
    end, nil)
  else
    self:DebugLog("@@@@GVoiceProxy:SwitchChannel(toChannel) toChannel:" .. toChannel)
    self.toChannel = toChannel
    self:DebugLog("@@@@GVoiceProxy:SwitchChannel1")
    if self.hasInit then
      ROVoice.Logout(function(msg)
      end)
    end
    self:DebugLog("@@@@GVoiceProxy:SwitchChannel2")
    local sysData = Table_Sysmsg[25861]
    if sysData then
      MsgManager.WarnPopupParam(sysData.Title, sysData.Text, {
        confirmHandler = function()
          self:DebugLog("GVoice1")
          self.curChannel = nil
          self.roomid = nil
          self:DebugLog("GVoice3")
          FunctionPerformanceSetting.Me():Load()
          self:DebugLog("GVoice4")
          EventManager.Me():PassEvent(MyselfEvent.EnterVoiceChannel, nil)
          EventManager.Me():PassEvent(TeamEvent.VoiceChange, nil)
          EventManager.Me():PassEvent(GuildEvent.VoiceChange, nil)
          self:DebugLog("GVoice5")
          self:DebugLog("GVoiceProxy:SwitchChannel2")
          if self.toChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index then
            self:DebugLog("GVoiceProxy:SwitchChannel3")
            if TeamProxy.Instance:IHaveTeam() then
              self:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_TEAM_ENUM.index)
              self.curTarget = GVoiceTarget.BuildTeamAndKeepLastMicState
              self:DebugLog("GVoiceProxy:SwitchChannel4")
            else
              MsgManager.ConfirmMsgByID(25851, function()
                if not TeamProxy.Instance:IHaveTeam() then
                  self:sendNotification(UIEvent.JumpPanel, {
                    view = PanelConfig.TeamFindPopUp
                  })
                else
                  self:sendNotification(UIEvent.JumpPanel, {
                    view = PanelConfig.TeamMemberListPopUp
                  })
                end
                self.curTarget = GVoiceTarget.BuildTeamAndKeepLastMicState
              end, function()
              end, nil)
            end
          elseif self.toChannel == ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index then
            self:DebugLog("GVoiceProxy:SwitchChannel11")
            if GuildProxy.Instance:IHaveGuild() then
              self:DebugLog("GVoiceProxy:SwitchChannel22")
              if self.LastMicState_IsMicOpen then
                if self:IsMySelfGongHuiJinYan() == false then
                  self:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
                  self.curTarget = GVoiceTarget.EnterGuildChannelAndOpenMic
                else
                  self:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
                  self.curTarget = GVoiceTarget.EnterGuildChannelAndNotAuthorized
                end
              else
                self:ActiveEnterChannel(ChatCmd_pb.EGAMECHATCHANNEL_ECHAT_CHANNEL_GUILD_ENUM.index)
                self.curTarget = GVoiceTarget.EnterGuildChannelAndCloseMic
              end
            else
              MsgManager.FloatMsg(nil, ZhString.VoiceString.YouDontHaveGuild)
            end
          else
            self:DebugLog("GVoiceProxy:SwitchChannel33")
          end
          self.toChannel = nil
        end
      }, nil, sysData)
    end
  end
end
function GVoiceProxy:QuitVoice(logoutCallBack)
  self.curChannel = nil
  self.roomid = nil
  FunctionPerformanceSetting.Me():Load()
  EventManager.Me():PassEvent(MyselfEvent.EnterVoiceChannel, nil)
  EventManager.Me():PassEvent(TeamEvent.VoiceChange, nil)
  EventManager.Me():PassEvent(GuildEvent.VoiceChange, nil)
  self:DebugLog("function GVoiceProxy:QuitVoice( logoutCallBack)")
  if self.hasInit then
    ROVoice.Logout(function(msg)
      self:DebugLog("QuitVoice:" .. msg)
      if logoutCallBack ~= nil then
        logoutCallBack()
      end
    end)
  else
    self:DebugLog("if self.hasInit then not not")
  end
end
function GVoiceProxy:CompatibleWithAndroidVersionNineZero(doitFunc)
  if not BackwardCompatibilityUtil.CompatibilityMode_V26 then
    if ExternalInterfaces.GetAndroidVersion() < 28 then
      if doitFunc ~= nil then
        doitFunc()
      end
    else
      local sysData = Table_Sysmsg[25862]
      if sysData then
        MsgManager.WarnPopupParam(sysData.Title, sysData.Text, {
          confirmHandler = function()
          end
        }, nil, sysData)
      end
    end
  elseif doitFunc ~= nil then
    doitFunc()
  end
end
return GVoiceProxy
