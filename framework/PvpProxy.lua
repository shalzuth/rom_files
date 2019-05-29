autoImport("PvpRoomData")
autoImport("YoyoRoomData")
autoImport("MvpBattleTeamData")
autoImport("TeamPwsData")
PvpProxy = class("PvpProxy", pm.Proxy)
PvpProxy.Instance = nil
PvpProxy.NAME = "PvpProxy"
PvpProxy.Type = {
  Yoyo = MatchCCmd_pb.EPVPTYPE_LLH,
  DesertWolf = MatchCCmd_pb.EPVPTYPE_SMZL,
  GorgeousMetal = MatchCCmd_pb.EPVPTYPE_HLJS,
  PoringFight = MatchCCmd_pb.EPVPTYPE_POLLY,
  MvpFight = MatchCCmd_pb.EPVPTYPE_MVP,
  SuGVG = MatchCCmd_pb.EPVPTYPE_SUGVG,
  TutorMatch = MatchCCmd_pb.EPVPTYPE_TUTOR,
  TeamPws = MatchCCmd_pb.EPVPTYPE_TEAMPWS,
  FreeBattle = MatchCCmd_pb.EPVPTYPE_TEAMPWS_RELAX,
  ExpRaid = MatchCCmd_pb.EPVPTYPE_TEAMEXP,
  Tower = MatchCCmd_pb.EPVPTYPE_TOWER,
  PVECard = MatchCCmd_pb.EPVPTYPE_PVECARD,
  Seal = MatchCCmd_pb.EPVPTYPE_SEAL,
  Laboratory = MatchCCmd_pb.EPVPTYPE_LABORATORY
}
PvpProxy.RoomStatus = {
  WaitJoin = MatchCCmd_pb.EROOMSTATE_WAIT_JOIN,
  ReadyForFight = MatchCCmd_pb.EROOMSTATE_READY_FOR_FIGHT,
  Fighting = MatchCCmd_pb.EROOMSTATE_FIGHTING,
  Success = MatchCCmd_pb.EROOMSTATE_MATCH_SUCCESS,
  End = MatchCCmd_pb.EROOMSTATE_END
}
PvpProxy.TeamPws = {
  TeamColor = {
    Red = FuBenCmd_pb.ETEAMPWS_RED,
    Blue = FuBenCmd_pb.ETEAMPWS_BLUE
  }
}
function PvpProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PvpProxy.NAME
  if PvpProxy.Instance == nil then
    PvpProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end
function PvpProxy:Init()
  self.pvpStatusMap = {}
  self.roomListMap = {}
  self.detail_roomid_map = {}
  self.server_teamPwsInfo = {}
  self.fightStatInfo = {}
  self.fightStatInfo.ranks = {}
  self:ClearBosses()
end
function PvpProxy:ClearBosses()
  self.bosses = {}
end
function PvpProxy:ResetMyRoomInfo()
  if self.myRoomData then
    self.myRoomData = nil
  end
end
function PvpProxy:SetMyRoomBriefInfo(type, brief_info)
  if brief_info == nil or brief_info.type == nil then
    redlog("PvpProxy-->ReSetMyRoomBriefInfo", brief_info.roomid)
    self:ResetMyRoomInfo()
  else
    local roomid = brief_info.roomid
    redlog("PvpProxy-->SetMyRoomBriefInfo", string.format("reqType:%s Roomid:%s Type:%s State:%s", type, roomid, brief_info.type, brief_info.state))
    self.myRoomData = PvpRoomData.new(roomid)
    self.myRoomData:SetData(brief_info)
    local roomlist = self:GetRoomList(type)
    if roomlist then
      local find = false
      for i = 1, #roomlist do
        if roomlist[i].guid == roomid then
          roomlist[i]:SetData(brief_info)
          find = true
          break
        end
      end
      if not find and type == PvpProxy.Type.DesertWolf then
        local myRoom = PvpRoomData.new(roomid)
        myRoom:SetData(brief_info)
        roomlist[#roomlist + 1] = myRoom
        table.sort(roomlist, function(l, r)
          return self:SortDesertRoomData(l, r)
        end)
      end
    end
  end
end
function PvpProxy:UpdateMyRoomStatus(pvp_type, roomid, state, endtime)
  if self.myRoomData and self.myRoomData.guid == roomid then
    redlog("PvpProxy-->UpdateMyRoomStatus", string.format("Type:%s Roomid:%s State:%s", pvp_type, roomid, state))
    self.myRoomData.state = state
    self.myRoomData:SetEndTime(endtime)
  end
end
function PvpProxy:GetMyRoomType()
  if self.myRoomData then
    return self.myRoomData.type
  end
end
function PvpProxy:GetMyRoomState(type)
  if self.myRoomData and self.myRoomData.type == type then
    return self.myRoomData.state
  end
  return PvpProxy.RoomStatus.WaitJoin
end
function PvpProxy:GetMyRoomGuid()
  if self.myRoomData then
    return self.myRoomData.roomid
  end
end
function PvpProxy:SetRoomList(type, room_lists)
  local detailRoomData
  local detail_roomid = self.detail_roomid_map[type]
  if detail_roomid then
    detailRoomData = self:GetRoomData(type, detail_roomid)
  end
  helplog("SetRoomList", type, detail_roomid, detailRoomData)
  local roomlist = {}
  local roomids = ""
  for i = 1, #room_lists do
    local list = room_lists[i]
    roomids = roomids .. " " .. list.roomid
    if detailRoomData and list.roomid == detailRoomData.guid then
      detailRoomData:SetData(list)
      detailRoomData:SetIndex(i)
      table.insert(roomlist, detailRoomData)
    else
      local roomdata = PvpRoomData.new(list.roomid)
      roomdata:SetData(list)
      roomdata:SetIndex(i)
      table.insert(roomlist, roomdata)
    end
  end
  if type == PvpProxy.Type.DesertWolf then
    table.sort(roomlist, function(l, r)
      return self:SortDesertRoomData(l, r)
    end)
  end
  self.roomListMap[type] = roomlist
end
function PvpProxy:SetYoyoRoomList(type, roomList)
  local yoyoRoomData = YoyoRoomData.new()
  yoyoRoomData:SetData(roomList)
  self.roomListMap[type] = yoyoRoomData:GetyoyoRoomData()
end
function PvpProxy:SortDesertRoomData(l, r)
  if l.roomid == self:GetMyRoomGuid() then
    return true
  elseif r.roomid == self:GetMyRoomGuid() then
    return false
  else
    return l.roomid < r.roomid
  end
end
function PvpProxy:GetRoomList(type)
  local roomlist = self.roomListMap[type]
  if roomlist then
    if type == PvpProxy.Type.GorgeousMetal then
      if self.gorgeousMetal_SortFunc == nil then
        function self.gorgeousMetal_SortFunc(a, b)
          local ina = false
          local inb = false
          if self.myRoomData ~= nil and self.myRoomData.type == type then
            ina = a.guid == self.myRoomData.guid
            inb = b.guid == self.myRoomData.guid
          end
          if ina ~= inb then
            return ina == true
          end
          return a.index < b.index
        end
      end
      table.sort(roomlist, self.gorgeousMetal_SortFunc)
    end
    return roomlist
  end
end
function PvpProxy:GetRoomData(type, guid)
  local roomlist = self.roomListMap[type]
  local roomData
  if roomlist then
    for i = 1, #roomlist do
      if roomlist[i].guid == guid then
        roomData = roomlist[i]
        break
      end
    end
  end
  return roomData
end
function PvpProxy:SetRoomDetailInfo(type, guid, detail_info)
  if type == nil then
    return
  end
  local roomData = self:GetRoomData(type, guid)
  if roomData then
    roomData:SetRoomDetailInfo(detail_info)
  else
    helplog("Not Find RoomData:" .. tostring(guid))
  end
  self.detail_roomid_map[type] = guid
end
function PvpProxy:GetFightStatInfo()
  return self.fightStatInfo
end
function PvpProxy:RecvNtfRankChangeCCmd(data)
  local ranks = data.ranks
  local rankDatas = {}
  for i = 1, #ranks do
    local tb = {}
    tb.name = ranks[i].name
    tb.apple = ranks[i].apple
    rankDatas[#rankDatas + 1] = tb
  end
  self.fightStatInfo.ranks = rankDatas
end
function PvpProxy:NtfFightStatCCmd(data)
  self.fightStatInfo.pvp_type = data.pvp_type
  self.fightStatInfo.starttime = data.starttime
  self.fightStatInfo.player_num = data.player_num
  self.fightStatInfo.score = data.score
  self.fightStatInfo.my_teamscore = data.my_teamscore
  self.fightStatInfo.enemy_teamscore = data.enemy_teamscore
  self.fightStatInfo.remain_hp = data.remain_hp
  if data.myrank == 9999 then
    self.fightStatInfo.myrank = nil
  else
    self.fightStatInfo.myrank = data.myrank
  end
end
function PvpProxy:HandlePvpResult(result)
  local data = {}
  data.result = result
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.UIVictoryView,
    viewdata = data
  })
end
function PvpProxy:IsSelfInPvp()
  local mapid = Game.MapManager:GetMapID()
  if mapid then
    local mapRaid = Table_MapRaid[mapid]
    if mapRaid and (mapRaid.Type == FunctionDungen.YoyoType or mapRaid.Type == FunctionDungen.DesertWolfType or mapRaid.Type == FunctionDungen.GorgeousMetalType) then
      return true
    end
  end
  return false
end
function PvpProxy:IsSelfInGuildBase()
  return Game.MapManager:GetMapID() == 10001 or DojoProxy.Instance:IsSelfInDojo()
end
function PvpProxy:RecvSyncMvpInfoFubenCmd(initInfo)
  self:ClearBosses()
  self.usernum = initInfo.usernum
  local liveBosses = initInfo.liveboss
  local deadBosses = initInfo.dieboss
  for i = 1, #liveBosses do
    local single = liveBosses[i]
    local data = self.bosses[single]
    if not data then
      data = {live = 1, total = 1}
      self.bosses[single] = data
    else
      data.live = data.live + 1
      data.total = data.total + 1
    end
  end
  for i = 1, #deadBosses do
    local single = deadBosses[i]
    local data = self.bosses[single]
    if not data then
      data = {live = 0, total = 1}
      self.bosses[single] = data
    else
      data.total = data.total + 1
    end
  end
end
local SortMvpResult = function(l, r)
  local lMvpCount = l:GetKillMvpCount()
  local rMvpCount = r:GetKillMvpCount()
  if lMvpCount == rMvpCount then
    local lMiniCount = l:GetKillMiniCount()
    local rMiniCount = r:GetKillMiniCount()
    if lMiniCount == rMiniCount then
      return l.teamid < r.teamid
    else
      return lMiniCount > rMiniCount
    end
  else
    return lMvpCount > rMvpCount
  end
end
function PvpProxy:RecvMvpBattleReportFubenCmd(data)
  if self.mvpResultList == nil then
    self.mvpResultList = {}
  else
    TableUtility.ArrayClear(self.mvpResultList)
  end
  for i = 1, #data.datas do
    local mvpData = MvpBattleTeamData.new(data.datas[i])
    self.mvpResultList[#self.mvpResultList + 1] = mvpData
  end
  table.sort(self.mvpResultList, SortMvpResult)
  for i = 1, #self.mvpResultList do
    self.mvpResultList[i]:SetIndex(i)
  end
end
function PvpProxy:RecvUpdateUserNumFubenCmd(data)
  self.usernum = data.usernum
end
function PvpProxy:RecvBossDieFubenCmd(data)
  local data = self.bosses[data.npcid]
  if not data then
    data = {live = 0, total = 1}
    self.bosses[data.npcid] = data
  else
    local live = data.live
    if live and live > 0 then
      data.live = data.live - 1
    else
      data.live = 0
    end
  end
end
function PvpProxy:PvpTeamMemberUpdateCCmd(matchTeamMemUpdateInfo)
  if matchTeamMemUpdateInfo == nil then
    return
  end
  local roomid = matchTeamMemUpdateInfo.roomid
  local teamid = matchTeamMemUpdateInfo.teamid
  local isfirst = matchTeamMemUpdateInfo.isfirst
  local index = matchTeamMemUpdateInfo.index
  if roomid and teamid then
    local roomData = self:GetRoomData(PvpProxy.Type.GorgeousMetal, roomid)
    if roomData then
      local teamData = roomData:GetRoomTeamDataByPos(index)
      if teamData then
        teamData.id = teamid
        teamData.roomid = roomid
        teamData.zoneid = zoneid
        local updates = matchTeamMemUpdateInfo.updates
        if updates then
          teamData:SetMembers(updates)
        end
        local deletes = matchTeamMemUpdateInfo.deletes
        if deletes then
          teamData:RemoveMembers(deletes)
        end
        local myTeam = TeamProxy.Instance.myTeam
        if myTeam == nil or myTeam.id == teamData.id and teamData.memberNum == 0 then
          self:ResetMyRoomInfo()
        end
      else
        redlog("PVP: Pos Is illegal", index, tostring(teamData))
      end
    end
  end
  local myID = Game.Myself.data.id
  local deletesId = matchTeamMemUpdateInfo.deletes
  for _, v in pairs(deletesId) do
    if v == myID then
      self:ResetMyRoomInfo()
      break
    end
  end
end
function PvpProxy:PvpMemberDataUpdate(matchTeamMemDataUpdateInfo)
  if matchTeamMemDataUpdateInfo == nil then
    return
  end
  local roomid = matchTeamMemDataUpdateInfo.roomid
  local teamid = matchTeamMemDataUpdateInfo.teamid
  local charid = matchTeamMemDataUpdateInfo.charid
  local members = matchTeamMemDataUpdateInfo.members
  if roomid and teamid and charid and members then
    local roomData = self:GetRoomData(PvpProxy.Type.GorgeousMetal, roomid)
    if roomData then
      local teamData = roomData:GetTeamByGuid(teamid)
      if teamData then
        local teamMemberData = teamData:GetMemberByGuid(charid)
        if teamMemberData then
          teamMemberData:SetMemberData(members)
        end
      end
    end
  end
end
function PvpProxy:DoKickTeamCCmd(type, roomid, zoneid, teamid)
  local roomList = self:GetRoomList(type)
  if roomList then
    for i = 1, #roomList do
      local roomData = roomList[i]
      if roomData and roomData.guid == roomid then
        roomData:RemoveTeamByGuid(teamid)
      end
    end
  end
  if self.myRoomData and self.myRoomData.guid == roomid then
    local myTeam = TeamProxy.Instance.myTeam
    if myTeam and myTeam.id == teamid then
      self:ResetMyRoomInfo()
    end
  end
  if type == PvpProxy.Type.DesertWolf then
    ServiceMatchCCmdProxy.Instance:CallReqRoomDetailCCmd(type, roomid)
  end
end
function PvpProxy:Req_Server_MyRoomMatchCCmd()
  if not self.reqMyRoom then
    self.reqMyRoom = true
    ServiceMatchCCmdProxy.Instance:CallReqMyRoomMatchCCmd()
  end
end
function PvpProxy:PoringFightResult(server_rank, server_rewards, server_apple)
  if server_rank == nil then
    return
  end
  self.poringFight_viewdata = {}
  self.poringFight_viewdata.rank = {}
  local myRank = 1
  local myCharid = Game.Myself.data.id
  local poringList = GameConfig.PoliFire and GameConfig.PoliFire.trans_buffid
  local npclist = {}
  for i = 1, #server_rank do
    local info = {}
    info.charid = server_rank[i].charid
    info.index = server_rank[i].index
    info.rank = server_rank[i].rank
    info.name = server_rank[i].name
    table.insert(self.poringFight_viewdata.rank, info)
    if info.charid == myCharid then
      myRank = info.rank
    end
    local listdata = {}
    listdata.npcid = poringList and poringList[info.index].monster or 10001
    listdata.name = info.name
    npclist[info.rank] = listdata
  end
  self.poringFight_viewdata.myRank = myRank or 1
  if server_rewards then
    self.poringFight_viewdata.rewards = {}
    for i = 1, #server_rewards do
      local reward = server_rewards[i]
      local item = ItemData.new(nil, reward.itemid)
      item.num = reward.count
      table.insert(self.poringFight_viewdata.rewards, item)
    end
  end
  self.poringFight_viewdata.apple = server_apple
  if myRank == 9999 then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PoringFightResultView
    })
  else
    Game.PlotStoryManager:Start(1, nil, nil, PlotConfig_Prefix.Anim, npclist)
  end
end
function PvpProxy:GetPoringFight_viewdata()
  return self.poringFight_viewdata
end
function PvpProxy:NtfMatchInfo(etype, ismatch, isfighting)
  if etype == nil then
    return
  end
  if self.matchStateMap == nil then
    self.matchStateMap = {}
  end
  self.matchStateMap[etype] = {}
  self.matchStateMap[etype].ismatch = ismatch
  self.matchStateMap[etype].isfighting = isfighting
  self.matchStateMap[etype].startMatchTime = ismatch and ServerTime.CurServerTime() or nil
  if etype == PvpProxy.Type.TeamPws or etype == PvpProxy.Type.FreeBattle then
    if not ismatch then
      self:ClearTeamPwsPreInfo()
    end
    self.matchStateMap[etype].isprepare = false
  else
    self.latestEtype = etype
    self.latestMatchInfo = self.matchStateMap[etype]
  end
end
function PvpProxy:GetStartMatchTime(etype)
  if self.matchStateMap == nil then
    return nil
  end
  return self.matchStateMap[etype].startMatchTime
end
function PvpProxy:GetMatchState(etype)
  if self.matchStateMap == nil then
    return nil
  end
  return self.matchStateMap[etype]
end
function PvpProxy:GetNowMatchInfo()
  return self.latestEtype, self.latestMatchInfo
end
function PvpProxy:Is_polly_match()
  local matchStatus = self:GetMatchState(PvpProxy.Type.PoringFight)
  if matchStatus == nil then
    return false
  end
  return matchStatus.ismatch
end
function PvpProxy:ClearMatchInfo(pvpType)
  if self.matchStateMap == nil then
    return
  end
  if pvpType and self.matchStateMap[pvpType] then
    TableUtility.TableClear(self.matchStateMap[pvpType])
  end
  TableUtility.TableClear(self.matchStateMap)
  self.latestEtype = nil
  self.latestMatchInfo = nil
end
function PvpProxy:RecvGodEndTime(endtime)
  self.godendtime = endtime
end
function PvpProxy:GetGodEndTime()
  return self.godendtime
end
function PvpProxy:GetMvpResult()
  return self.mvpResultList
end
function PvpProxy:GetCurMatchStatus()
  if not self.matchStateMap then
    return
  end
  for etype, status in pairs(self.matchStateMap) do
    if status.ismatch == true then
      return status, etype
    end
  end
end
function PvpProxy:RecvTeamPwsPreInfoMatchCCmd(serverData)
  self:ClearTeamPwsPreInfo()
  if not self.matchStateMap then
    self.matchStateMap = {}
  end
  if not self.matchStateMap[serverData.etype] then
    self.matchStateMap[serverData.etype] = {ismatch = true, isfighting = false}
  end
  self.matchStateMap[serverData.etype].isprepare = true
  self.teamPwsPreInfo = ReusableTable.CreateTable()
  self.teamPwsPreInfo.type = serverData.etype
  for i = 1, #serverData.teaminfos do
    local list, isMyTeam = self:ProcessPreInfo(serverData.teaminfos[i].charids)
    if isMyTeam then
      if self.teamPwsPreInfo.myTeam then
        LogUtility.Error("\230\142\146\228\189\141\232\181\155/\228\188\145\233\151\178\232\181\155\229\135\134\229\164\135\230\149\176\230\141\174\229\135\186\233\148\153\239\188\129")
        self:ClearTeamPwsPreInfo()
        self.teamPwsPreInfo = ReusableTable.CreateTable()
      end
      self.teamPwsPreInfo.myTeam = list
    else
      if self.teamPwsPreInfo.enemyTeam then
        LogUtility.Error("\230\142\146\228\189\141\232\181\155/\228\188\145\233\151\178\232\181\155\229\135\134\229\164\135\230\149\176\230\141\174\229\135\186\233\148\153\239\188\129")
        self:ClearTeamPwsPreInfo()
        self.teamPwsPreInfo = ReusableTable.CreateTable()
      end
      self.teamPwsPreInfo.enemyTeam = list
    end
  end
  self.teamPwsPreStartTime = ServerTime.CurServerTime()
  self.teamPwsPreInfo.startPrepareTime = self.teamPwsPreStartTime
  local useless, config
  if serverData.etype == PvpProxy.Type.TeamPws then
    useless, config = next(GameConfig.PvpTeamRaid)
  elseif serverData.etype == PvpProxy.Type.FreeBattle then
    useless, config = next(GameConfig.PvpTeamRaid_Relax)
  end
  self.teamPwsPreInfo.maxPrepareTime = config and config.MaxPrepareTime or 60
  if serverData.etype == PvpProxy.Type.ExpRaid then
    self.teamPwsPreInfo.maxPrepareTime = GameConfig.TeamExpRaid.max_prepare_time
  end
  if not MatchPreparePopUp then
    autoImport("MatchPreparePopUp")
  end
  MatchPreparePopUp.Show(serverData.etype, serverData.goodmatch)
  MatchPreparePopUp.SetPrepareData(self.teamPwsPreInfo)
  if self:CheckNeedProcessFake(serverData.etype) then
    local fakeList = ReusableTable.CreateArray()
    for i = 1, #self.teamPwsPreInfo.enemyTeam do
      fakeList[i] = i
    end
    local index, index2
    for i = 1, #fakeList do
      index = math.random(1, #fakeList)
      index2 = math.random(1, #fakeList)
      if index ~= index2 then
        fakeList[index], fakeList[index2] = fakeList[index2], fakeList[index]
      end
    end
    self.teamPwsPreInfo.enemyFakeData = fakeList
    self.teamPwsPreInfo.enemyFakePreCount = -1
    self:ProcessFakeEnemyPreInfo()
  end
end
function PvpProxy:CheckNeedProcessFake(serverType)
  return serverType == PvpProxy.Type.FreeBattle or serverType == PvpProxy.Type.TeamPws
end
function PvpProxy:ProcessPreInfo(datas)
  local isMyTeam = false
  local list = ReusableTable.CreateArray()
  local preData
  for i = 1, #datas do
    preData = ReusableTable.CreateTable()
    list[#list + 1] = TeamPwsData.ParsePrepareData(preData, datas[i])
    if preData.charID == Game.Myself.data.id then
      isMyTeam = true
    end
  end
  return list, isMyTeam
end
function PvpProxy:GetTeamPwsPreStartTime()
  return self.teamPwsPreStartTime
end
function PvpProxy:RecvUpdatePreInfoMatchCCmd(serverData)
  if not self.teamPwsPreInfo or self.teamPwsPreInfo.type ~= serverData.etype and serverData.etype ~= 0 then
    return
  end
  local charID = serverData.charid
  local datas = self.teamPwsPreInfo.myTeam
  local found = false
  for i = 1, #datas do
    if datas[i].charID == charID then
      datas[i].isReady = true
      found = true
      break
    end
  end
  if found then
    MatchPreparePopUp.UpdatePrepareStatus(charID)
  else
    datas = self.teamPwsPreInfo.enemyTeam
    for i = 1, #datas do
      if datas[i].charID == charID then
        datas[i].isReady = true
        break
      end
    end
  end
  if self:CheckNeedProcessFake(serverData.etype) then
    self:ProcessFakeEnemyPreInfo()
  end
end
function PvpProxy:GetTeamPwsPreInfo()
  return self.teamPwsPreInfo
end
function PvpProxy:ClearTeamPwsPreInfo()
  if not self.teamPwsPreInfo then
    return
  end
  if self.teamPwsPreInfo.myTeam then
    for i = 1, #self.teamPwsPreInfo.myTeam do
      ReusableTable.DestroyAndClearTable(self.teamPwsPreInfo.myTeam[i])
    end
    ReusableTable.DestroyAndClearArray(self.teamPwsPreInfo.myTeam)
  end
  if self.teamPwsPreInfo.enemyTeam then
    for i = 1, #self.teamPwsPreInfo.enemyTeam do
      ReusableTable.DestroyAndClearTable(self.teamPwsPreInfo.enemyTeam[i])
    end
    ReusableTable.DestroyAndClearArray(self.teamPwsPreInfo.enemyTeam)
  end
  if self.teamPwsPreInfo.enemyFakeData then
    ReusableTable.DestroyAndClearArray(self.teamPwsPreInfo.enemyFakeData)
  end
  ReusableTable.DestroyAndClearTable(self.teamPwsPreInfo)
  self.teamPwsPreInfo = nil
end
function PvpProxy:ClearTeamPwsMatchInfo()
  if not self.matchStateMap then
    return
  end
  if self.matchStateMap[PvpProxy.Type.TeamPws] then
    TableUtility.TableClear(self.matchStateMap[PvpProxy.Type.TeamPws])
  end
  if self.matchStateMap[PvpProxy.Type.FreeBattle] then
    TableUtility.TableClear(self.matchStateMap[PvpProxy.Type.FreeBattle])
  end
end
function PvpProxy:ProcessFakeEnemyPreInfo()
  local preCount = 0
  for i = 1, #self.teamPwsPreInfo.enemyTeam do
    if self.teamPwsPreInfo.enemyTeam[i].isReady then
      preCount = preCount + 1
    end
  end
  if preCount < #self.teamPwsPreInfo.enemyTeam then
    if not self.ltFakeEnemyPre then
      self:RandomFakeEnemyPreInfo()
    end
  else
    preCount = 0
    for i = 1, #self.teamPwsPreInfo.myTeam do
      if self.teamPwsPreInfo.myTeam[i].isReady then
        preCount = preCount + 1
      end
    end
    if preCount >= #self.teamPwsPreInfo.myTeam then
      if self.ltFakeEnemyPre then
        self.ltFakeEnemyPre:cancel()
        self.ltFakeEnemyPre = nil
      end
      self.teamPwsPreInfo.enemyFakePreCount = #self.teamPwsPreInfo.enemyTeam
      if 1 > self.teamPwsPreInfo.enemyFakePreCount then
        return
      end
      MatchPreparePopUp.UpdatePrepareStatus(self.teamPwsPreInfo.enemyTeam[self.teamPwsPreInfo.enemyFakePreCount].charID)
    end
  end
end
function PvpProxy:RandomFakeEnemyPreInfo()
  if self.teamPwsPreInfo.enemyFakePreCount >= #self.teamPwsPreInfo.enemyTeam - 1 then
    self.ltFakeEnemyPre = nil
    return
  end
  self.teamPwsPreInfo.enemyFakePreCount = self.teamPwsPreInfo.enemyFakePreCount + 1
  self.ltFakeEnemyPre = LeanTween.delayedCall(math.random(0.3, 5), function()
    self:RandomFakeEnemyPreInfo()
  end)
  if self.teamPwsPreInfo.enemyFakePreCount < 1 then
    return
  end
  MatchPreparePopUp.UpdatePrepareStatus(self.teamPwsPreInfo.enemyTeam[self.teamPwsPreInfo.enemyFakePreCount].charID)
end
function PvpProxy:RecvQueryTeamPwsUserInfoFubenCmd(serverData)
  self:CreateTeamPwsReportData(serverData.teaminfo)
end
function PvpProxy:RecvTeamPwsReportFubenCmd(serverData)
  self:CreateTeamPwsReportData(serverData.teaminfo, serverData.mvpuserinfo.charid)
  local data = {
    winTeamColor = serverData.winteam,
    mvpUserInfo = serverData.mvpuserinfo
  }
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TeamPwsFightResultPopUp,
    viewdata = data
  })
end
function PvpProxy:CreateTeamPwsReportData(serverTeamInfos, mvpID)
  self:ClearTeamPwsReportData()
  self.teamPwsReportMap = ReusableTable.CreateTable()
  self.teamPwsReportMap.aveScores = ReusableTable.CreateTable()
  local reports = ReusableTable.CreateArray()
  local teamInfo, teamID, color, userInfos, data
  for i = 1, #serverTeamInfos do
    teamInfo = serverTeamInfos[i]
    teamID = teamInfo.teamid
    color = teamInfo.color
    userInfos = teamInfo.userinfos
    self.teamPwsReportMap.aveScores[color] = teamInfo.avescore
    for i = 1, #userInfos do
      data = TeamPwsData.ParseReportData(ReusableTable.CreateTable(), userInfos[i], teamID, color)
      if mvpID and mvpID == data.charID then
        data.isMvp = true
      end
      reports[#reports + 1] = data
    end
  end
  self.teamPwsReportMap.reports = reports
end
function PvpProxy:GetTeamPwsReportData()
  return self.teamPwsReportMap
end
function PvpProxy:ClearTeamPwsReportData()
  if self.teamPwsReportMap then
    for i = 1, #self.teamPwsReportMap.reports do
      ReusableTable.DestroyAndClearTable(self.teamPwsReportMap.reports[i])
    end
    ReusableTable.DestroyAndClearArray(self.teamPwsReportMap.reports)
    ReusableTable.DestroyAndClearTable(self.teamPwsReportMap.aveScores)
    ReusableTable.DestroyAndClearTable(self.teamPwsReportMap)
    self.teamPwsReportMap = nil
  end
end
function PvpProxy:RecvQueryTeamPwsRankMatchCCmd(serverData)
  self:ClearTeamPwsRankData()
  self.teamPwsRankData = ReusableTable.CreateArray()
  local datas = serverData.rankinfo
  local rankData
  for i = 1, #datas do
    rankData = ReusableTable.CreateTable()
    self.teamPwsRankData[#self.teamPwsRankData + 1] = TeamPwsData.ParseRankData(rankData, datas[i])
  end
  self.teamPwsDataProtect = true
  TimeTickManager.Me():CreateTick(30000, 30000, self.ClearTeamPwsRankDataProtect, self, 1)
end
function PvpProxy:GetTeamPwsRankData()
  self.teamPwsDataIsUsing = self.teamPwsRankData ~= nil
  return self.teamPwsRankData
end
function PvpProxy:ClearTeamPwsRankDataProtect()
  TimeTickManager.Me():ClearTick(self, 1)
  self.teamPwsDataProtect = nil
  if not self.teamPwsDataIsUsing then
    self:ClearTeamPwsRankData()
  end
end
function PvpProxy:GetTeamPwsRankSearchResult(keyword)
  if not self.teamPwsRankSearchResult then
    self.teamPwsRankSearchResult = ReusableTable.CreateArray()
  end
  TableUtility.ArrayClear(self.teamPwsRankSearchResult)
  keyword = string.lower(keyword)
  for i = 1, #self.teamPwsRankData do
    local data = self.teamPwsRankData[i]
    if data.name and string.find(string.lower(data.name), keyword) then
      self.teamPwsRankSearchResult[#self.teamPwsRankSearchResult + 1] = data
    end
  end
  return self.teamPwsRankSearchResult
end
function PvpProxy:TeamPwsRankDataUseOver()
  self.teamPwsDataIsUsing = nil
  if not self.teamPwsDataProtect then
    self:ClearTeamPwsRankData()
  end
end
function PvpProxy:ClearTeamPwsRankData()
  if self.teamPwsRankData then
    for i = 1, #self.teamPwsRankData do
      ReusableTable.DestroyAndClearTable(self.teamPwsRankData[i])
    end
    ReusableTable.DestroyAndClearArray(self.teamPwsRankData)
    self.teamPwsRankData = nil
  end
  if self.teamPwsRankSearchResult then
    ReusableTable.DestroyAndClearArray(self.teamPwsRankSearchResult)
    self.teamPwsRankSearchResult = nil
  end
  self.teamPwsDataIsUsing = nil
  self.teamPwsDataProtect = nil
end
function PvpProxy:UpdateTeamPwsInfos(syncdata, sparetime)
  local mt = self.server_teamPwsInfo
  if mt == nil then
    mt = {}
    self.server_teamPwsInfo = mt
  end
  if syncdata then
    local sd, d
    local ballDirty = false
    for i = 1, #syncdata do
      sd = syncdata[i]
      d = mt[sd.color]
      if d == nil then
        d = {}
        mt[sd.color] = d
      end
      d.teamid = sd.teamid
      d.teamname = sd.teamname
      d.color = sd.color
      d.score = sd.score
      local oldballs = d.balls
      if not ballDirty and oldballs == nil then
        ballDirty = true
      end
      d.balls = {}
      for i = 1, #sd.balls do
        local id = sd.balls[i]
        d.balls[id] = 1
        if not ballDirty and not oldballs[id] then
          ballDirty = true
        end
      end
      ballDirty = ballDirty or next(oldballs) ~= nil
    end
    for i = 1, #syncdata do
      sd = syncdata[i]
      for k, v in pairs(mt) do
        if k ~= sd.color then
          v.effectcd = sd.effectcd
          v.effectid = sd.magicid
        end
      end
    end
    if ballDirty then
      GameFacade.Instance:sendNotification(PVPEvent.TeamPws_PlayerBuffBallChange)
    end
  end
  if sparetime then
    self.sparetime = sparetime
  end
end
function PvpProxy:GetTeamPwsInfo(color)
  return self.server_teamPwsInfo[color]
end
function PvpProxy:GetSpareTime()
  return self.sparetime or 0
end
function PvpProxy:ClearTeamPwsInfos()
  helplog("ClearTeamPwsInfos")
  self.sparetime = nil
  self.server_teamPwsInfo = nil
end
function PvpProxy:CheckMvpMatchValid()
  local tipActID = GameConfig.MvpBattle.ActivityID or 4000000
  local running = FunctionActivity.Me():IsActivityRunning(tipActID)
  if not running then
    MsgManager.ShowMsgByIDTable(7300)
    return
  end
  local baselv = GameConfig.MvpBattle.BaseLevel
  local rolelv = MyselfProxy.Instance:RoleLevel()
  if baselv > rolelv then
    MsgManager.ShowMsgByID(7301, baselv)
    return
  end
  if not TeamProxy.Instance:IHaveTeam() then
    MsgManager.ShowMsgByID(332)
    return
  end
  local mblsts = TeamProxy.Instance.myTeam:GetMembersListExceptMe()
  for i = 1, #mblsts do
    if baselv > mblsts[i].baselv then
      MsgManager.ShowMsgByID(7305, baselv)
      return
    end
  end
  local matchStatus = self:GetMatchState(PvpProxy.Type.MvpFight)
  if matchStatus and matchStatus.ismatch then
    MsgManager.ShowMsgByIDTable(3609)
    return
  end
  return true
end
function PvpProxy:CheckExpRaidValid()
  if ExpRaidProxy.Instance:GetExpRaidTimesLeft() <= 0 then
    MsgManager.ShowMsgByID(25902)
    return
  end
  return true
end
local PWS_TYPE, PWS_CONFIG
function PvpProxy:CheckPwsMatchValid(isRelax, roomid)
  PWS_TYPE = isRelax and PvpProxy.Type.FreeBattle or PvpProxy.Type.TeamPws
  PWS_CONFIG = isRelax and GameConfig.PvpTeamRaid_Relax[roomid] or GameConfig.PvpTeamRaid[roomid]
  if not isRelax then
    if not FunctionActivity.Me():IsActivityRunning(PWS_CONFIG.ActivityID) then
      MsgManager.ShowMsgByID(365)
      return
    end
    local teamPwsCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_TEAMPWS_COUNT) or 0
    if teamPwsCount >= GameConfig.teamPVP.Maxtime then
      MsgManager.ShowMsgByID(25906)
      return
    end
  end
  if Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) < PWS_CONFIG.RequireLv then
    MsgManager.ShowMsgByID(25900)
    return
  end
  return true
end
function PvpProxy:CheckMatchValid(type, roomid)
  if self:GetCurMatchStatus() then
    MsgManager.ShowMsgByID(25917)
    return
  end
  if type == PvpProxy.Type.MvpFight then
    return self:CheckMvpMatchValid()
  elseif type == PvpProxy.Type.TeamPws then
    return self:CheckPwsMatchValid(false, roomid)
  elseif type == PvpProxy.Type.FreeBattle then
    return self:CheckPwsMatchValid(true, roomid)
  elseif type == PvpProxy.Type.ExpRaid then
    return self:CheckExpRaidValid()
  end
  return true
end
local typeStr
function PvpProxy:GetTypeName()
  local _, type = PvpProxy.Instance:GetCurMatchStatus()
  if type == PvpProxy.Type.PoringFight then
    typeStr = ZhString.PvpTypeName_Polly
  elseif type == PvpProxy.Type.MvpFight then
    typeStr = ZhString.PvpTypeName_Mvp
  elseif type == PvpProxy.Type.TeamPws then
    typeStr = ZhString.PvpTypeName_TeamPws
  elseif type == PvpProxy.Type.FreeBattle then
    typeStr = ZhString.PvpTypeName_TeamPwsRelax
  elseif type == PvpProxy.Type.ExpRaid then
    typeStr = ZhString.PvpTypeName_TeamExp
  elseif type == PvpProxy.Type.Tower then
    typeStr = ZhString.PvpTypeName_Tower
  elseif type == PvpProxy.Type.PVECard then
    typeStr = ZhString.PvpTypeName_PveCard
  elseif type == PvpProxy.Type.Seal then
    typeStr = ZhString.PvpTypeName_Seal
  elseif type == PvpProxy.Type.Laboratory then
    typeStr = ZhString.PvpTypeName_Laboratory
  else
    typeStr = ZhString.PvpTypeName_Default
  end
  return string.format(ZhString.PvpTypeName_Format, typeStr)
end
