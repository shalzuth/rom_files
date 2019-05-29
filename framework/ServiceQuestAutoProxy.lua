ServiceQuestAutoProxy = class("ServiceQuestAutoProxy", ServiceProxy)
ServiceQuestAutoProxy.Instance = nil
ServiceQuestAutoProxy.NAME = "ServiceQuestAutoProxy"
function ServiceQuestAutoProxy:ctor(proxyName)
  if ServiceQuestAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceQuestAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceQuestAutoProxy.Instance = self
  end
end
function ServiceQuestAutoProxy:Init()
end
function ServiceQuestAutoProxy:onRegister()
  self:Listen(8, 1, function(data)
    self:RecvQuestList(data)
  end)
  self:Listen(8, 2, function(data)
    self:RecvQuestUpdate(data)
  end)
  self:Listen(8, 5, function(data)
    self:RecvQuestStepUpdate(data)
  end)
  self:Listen(8, 3, function(data)
    self:RecvQuestAction(data)
  end)
  self:Listen(8, 4, function(data)
    self:RecvRunQuestStep(data)
  end)
  self:Listen(8, 6, function(data)
    self:RecvQuestTrace(data)
  end)
  self:Listen(8, 7, function(data)
    self:RecvQuestDetailList(data)
  end)
  self:Listen(8, 8, function(data)
    self:RecvQuestDetailUpdate(data)
  end)
  self:Listen(8, 9, function(data)
    self:RecvQuestRaidCmd(data)
  end)
  self:Listen(8, 10, function(data)
    self:RecvQuestCanAcceptListChange(data)
  end)
  self:Listen(8, 11, function(data)
    self:RecvVisitNpcUserCmd(data)
  end)
  self:Listen(8, 12, function(data)
    self:RecvQueryOtherData(data)
  end)
  self:Listen(8, 13, function(data)
    self:RecvQueryWantedInfoQuestCmd(data)
  end)
  self:Listen(8, 14, function(data)
    self:RecvInviteHelpAcceptQuestCmd(data)
  end)
  self:Listen(8, 16, function(data)
    self:RecvInviteAcceptQuestCmd(data)
  end)
  self:Listen(8, 15, function(data)
    self:RecvReplyHelpAccelpQuestCmd(data)
  end)
  self:Listen(8, 17, function(data)
    self:RecvQueryWorldQuestCmd(data)
  end)
  self:Listen(8, 18, function(data)
    self:RecvQuestGroupTraceQuestCmd(data)
  end)
  self:Listen(8, 19, function(data)
    self:RecvHelpQuickFinishBoardQuestCmd(data)
  end)
  self:Listen(8, 21, function(data)
    self:RecvQueryManualQuestCmd(data)
  end)
  self:Listen(8, 22, function(data)
    self:RecvOpenPuzzleQuestCmd(data)
  end)
end
function ServiceQuestAutoProxy:CallQuestList(type, id, list, clear)
  local msg = SceneQuest_pb.QuestList()
  if type ~= nil then
    msg.type = type
  end
  if id ~= nil then
    msg.id = id
  end
  if list ~= nil then
    for i = 1, #list do
      table.insert(msg.list, list[i])
    end
  end
  if clear ~= nil then
    msg.clear = clear
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallQuestUpdate(items)
  local msg = SceneQuest_pb.QuestUpdate()
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallQuestStepUpdate(id, step, data)
  local msg = SceneQuest_pb.QuestStepUpdate()
  if id ~= nil then
    msg.id = id
  end
  if step ~= nil then
    msg.step = step
  end
  if data ~= nil and data.process ~= nil then
    msg.data.process = data.process
  end
  if data ~= nil and data.params ~= nil then
    for i = 1, #data.params do
      table.insert(msg.data.params, data.params[i])
    end
  end
  if data ~= nil and data.names ~= nil then
    for i = 1, #data.names do
      table.insert(msg.data.names, data.names[i])
    end
  end
  if data.config ~= nil and data.config.RewardGroup ~= nil then
    msg.data.config.RewardGroup = data.config.RewardGroup
  end
  if data.config ~= nil and data.config.SubGroup ~= nil then
    msg.data.config.SubGroup = data.config.SubGroup
  end
  if data.config ~= nil and data.config.FinishJump ~= nil then
    msg.data.config.FinishJump = data.config.FinishJump
  end
  if data.config ~= nil and data.config.FailJump ~= nil then
    msg.data.config.FailJump = data.config.FailJump
  end
  if data.config ~= nil and data.config.Map ~= nil then
    msg.data.config.Map = data.config.Map
  end
  if data.config ~= nil and data.config.WhetherTrace ~= nil then
    msg.data.config.WhetherTrace = data.config.WhetherTrace
  end
  if data.config ~= nil and data.config.Auto ~= nil then
    msg.data.config.Auto = data.config.Auto
  end
  if data.config ~= nil and data.config.FirstClass ~= nil then
    msg.data.config.FirstClass = data.config.FirstClass
  end
  if data.config ~= nil and data.config.Class ~= nil then
    msg.data.config.Class = data.config.Class
  end
  if data.config ~= nil and data.config.Level ~= nil then
    msg.data.config.Level = data.config.Level
  end
  if data.config ~= nil and data.config.PreNoShow ~= nil then
    msg.data.config.PreNoShow = data.config.PreNoShow
  end
  if data.config ~= nil and data.config.Risklevel ~= nil then
    msg.data.config.Risklevel = data.config.Risklevel
  end
  if data.config ~= nil and data.config.Joblevel ~= nil then
    msg.data.config.Joblevel = data.config.Joblevel
  end
  if data.config ~= nil and data.config.CookerLv ~= nil then
    msg.data.config.CookerLv = data.config.CookerLv
  end
  if data.config ~= nil and data.config.TasterLv ~= nil then
    msg.data.config.TasterLv = data.config.TasterLv
  end
  if data.config ~= nil and data.config.Icon ~= nil then
    msg.data.config.Icon = data.config.Icon
  end
  if data.config ~= nil and data.config.Color ~= nil then
    msg.data.config.Color = data.config.Color
  end
  if data.config ~= nil and data.config.QuestName ~= nil then
    msg.data.config.QuestName = data.config.QuestName
  end
  if data.config ~= nil and data.config.Name ~= nil then
    msg.data.config.Name = data.config.Name
  end
  if data.config ~= nil and data.config.Type ~= nil then
    msg.data.config.Type = data.config.Type
  end
  if data.config ~= nil and data.config.Content ~= nil then
    msg.data.config.Content = data.config.Content
  end
  if data.config ~= nil and data.config.TraceInfo ~= nil then
    msg.data.config.TraceInfo = data.config.TraceInfo
  end
  if data.config ~= nil and data.config.Prefixion ~= nil then
    msg.data.config.Prefixion = data.config.Prefixion
  end
  if data ~= nil and data.config.params.params ~= nil then
    for i = 1, #data.config.params.params do
      table.insert(msg.data.config.params.params, data.config.params.params[i])
    end
  end
  if data ~= nil and data.config.allrewardid ~= nil then
    for i = 1, #data.config.allrewardid do
      table.insert(msg.data.config.allrewardid, data.config.allrewardid[i])
    end
  end
  if data ~= nil and data.config.PreQuest ~= nil then
    for i = 1, #data.config.PreQuest do
      table.insert(msg.data.config.PreQuest, data.config.PreQuest[i])
    end
  end
  if data ~= nil and data.config.MustPreQuest ~= nil then
    for i = 1, #data.config.MustPreQuest do
      table.insert(msg.data.config.MustPreQuest, data.config.MustPreQuest[i])
    end
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallQuestAction(action, questid)
  local msg = SceneQuest_pb.QuestAction()
  if action ~= nil then
    msg.action = action
  end
  if questid ~= nil then
    msg.questid = questid
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallRunQuestStep(questid, starid, subgroup, step)
  local msg = SceneQuest_pb.RunQuestStep()
  if questid ~= nil then
    msg.questid = questid
  end
  if starid ~= nil then
    msg.starid = starid
  end
  if subgroup ~= nil then
    msg.subgroup = subgroup
  end
  if step ~= nil then
    msg.step = step
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallQuestTrace(questid, trace)
  local msg = SceneQuest_pb.QuestTrace()
  if questid ~= nil then
    msg.questid = questid
  end
  if trace ~= nil then
    msg.trace = trace
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallQuestDetailList(details)
  local msg = SceneQuest_pb.QuestDetailList()
  if details ~= nil then
    for i = 1, #details do
      table.insert(msg.details, details[i])
    end
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallQuestDetailUpdate(detail, del)
  local msg = SceneQuest_pb.QuestDetailUpdate()
  if detail ~= nil then
    for i = 1, #detail do
      table.insert(msg.detail, detail[i])
    end
  end
  if del ~= nil then
    for i = 1, #del do
      table.insert(msg.del, del[i])
    end
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallQuestRaidCmd(questid)
  local msg = SceneQuest_pb.QuestRaidCmd()
  if questid ~= nil then
    msg.questid = questid
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallQuestCanAcceptListChange()
  local msg = SceneQuest_pb.QuestCanAcceptListChange()
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallVisitNpcUserCmd(npctempid)
  local msg = SceneQuest_pb.VisitNpcUserCmd()
  if npctempid ~= nil then
    msg.npctempid = npctempid
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallQueryOtherData(type, data)
  local msg = SceneQuest_pb.QueryOtherData()
  if type ~= nil then
    msg.type = type
  end
  if data ~= nil and data.data ~= nil then
    msg.data.data = data.data
  end
  if data ~= nil and data.param1 ~= nil then
    msg.data.param1 = data.param1
  end
  if data ~= nil and data.param2 ~= nil then
    msg.data.param2 = data.param2
  end
  if data ~= nil and data.param3 ~= nil then
    msg.data.param3 = data.param3
  end
  if data ~= nil and data.param4 ~= nil then
    msg.data.param4 = data.param4
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallQueryWantedInfoQuestCmd(maxcount)
  local msg = SceneQuest_pb.QueryWantedInfoQuestCmd()
  if maxcount ~= nil then
    msg.maxcount = maxcount
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallInviteHelpAcceptQuestCmd(leaderid, questid, time, sign, leadername, issubmit)
  local msg = SceneQuest_pb.InviteHelpAcceptQuestCmd()
  if leaderid ~= nil then
    msg.leaderid = leaderid
  end
  if questid ~= nil then
    msg.questid = questid
  end
  if time ~= nil then
    msg.time = time
  end
  if sign ~= nil then
    msg.sign = sign
  end
  if leadername ~= nil then
    msg.leadername = leadername
  end
  if issubmit ~= nil then
    msg.issubmit = issubmit
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallInviteAcceptQuestCmd(leaderid, questid, time, sign, leadername, issubmit, isquickfinish)
  local msg = SceneQuest_pb.InviteAcceptQuestCmd()
  if leaderid ~= nil then
    msg.leaderid = leaderid
  end
  if questid ~= nil then
    msg.questid = questid
  end
  if time ~= nil then
    msg.time = time
  end
  if sign ~= nil then
    msg.sign = sign
  end
  if leadername ~= nil then
    msg.leadername = leadername
  end
  if issubmit ~= nil then
    msg.issubmit = issubmit
  end
  if isquickfinish ~= nil then
    msg.isquickfinish = isquickfinish
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallReplyHelpAccelpQuestCmd(leaderid, questid, time, sign, agree, issubmit)
  local msg = SceneQuest_pb.ReplyHelpAccelpQuestCmd()
  if leaderid ~= nil then
    msg.leaderid = leaderid
  end
  if questid ~= nil then
    msg.questid = questid
  end
  if time ~= nil then
    msg.time = time
  end
  if sign ~= nil then
    msg.sign = sign
  end
  if agree ~= nil then
    msg.agree = agree
  end
  if issubmit ~= nil then
    msg.issubmit = issubmit
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallQueryWorldQuestCmd(quests)
  local msg = SceneQuest_pb.QueryWorldQuestCmd()
  if quests ~= nil then
    for i = 1, #quests do
      table.insert(msg.quests, quests[i])
    end
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallQuestGroupTraceQuestCmd(id, trace)
  local msg = SceneQuest_pb.QuestGroupTraceQuestCmd()
  if id ~= nil then
    msg.id = id
  end
  if trace ~= nil then
    msg.trace = trace
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallHelpQuickFinishBoardQuestCmd(questid, leadername)
  local msg = SceneQuest_pb.HelpQuickFinishBoardQuestCmd()
  if questid ~= nil then
    msg.questid = questid
  end
  if leadername ~= nil then
    msg.leadername = leadername
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallQueryManualQuestCmd(version, manual)
  local msg = SceneQuest_pb.QueryManualQuestCmd()
  if version ~= nil then
    msg.version = version
  end
  if manual ~= nil and manual.version ~= nil then
    msg.manual.version = manual.version
  end
  if manual ~= nil and manual.main.items ~= nil then
    for i = 1, #manual.main.items do
      table.insert(msg.manual.main.items, manual.main.items[i])
    end
  end
  if manual.main.puzzle ~= nil and manual.main.puzzle.version ~= nil then
    msg.manual.main.puzzle.version = manual.main.puzzle.version
  end
  if manual ~= nil and manual.main.puzzle.open_puzzles ~= nil then
    for i = 1, #manual.main.puzzle.open_puzzles do
      table.insert(msg.manual.main.puzzle.open_puzzles, manual.main.puzzle.open_puzzles[i])
    end
  end
  if manual ~= nil and manual.main.puzzle.unlock_puzzles ~= nil then
    for i = 1, #manual.main.puzzle.unlock_puzzles do
      table.insert(msg.manual.main.puzzle.unlock_puzzles, manual.main.puzzle.unlock_puzzles[i])
    end
  end
  if manual.main ~= nil and manual.main.mainstoryid ~= nil then
    msg.manual.main.mainstoryid = manual.main.mainstoryid
  end
  if manual ~= nil and manual.main.previews ~= nil then
    for i = 1, #manual.main.previews do
      table.insert(msg.manual.main.previews, manual.main.previews[i])
    end
  end
  if manual ~= nil and manual.branch.shops ~= nil then
    for i = 1, #manual.branch.shops do
      table.insert(msg.manual.branch.shops, manual.branch.shops[i])
    end
  end
  if manual ~= nil and manual.story.previews ~= nil then
    for i = 1, #manual.story.previews do
      table.insert(msg.manual.story.previews, manual.story.previews[i])
    end
  end
  if manual ~= nil and manual.story.submit_ids ~= nil then
    for i = 1, #manual.story.submit_ids do
      table.insert(msg.manual.story.submit_ids, manual.story.submit_ids[i])
    end
  end
  if manual ~= nil and manual.prequest ~= nil then
    for i = 1, #manual.prequest do
      table.insert(msg.manual.prequest, manual.prequest[i])
    end
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:CallOpenPuzzleQuestCmd(version, id)
  local msg = SceneQuest_pb.OpenPuzzleQuestCmd()
  if version ~= nil then
    msg.version = version
  end
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
function ServiceQuestAutoProxy:RecvQuestList(data)
  self:Notify(ServiceEvent.QuestQuestList, data)
end
function ServiceQuestAutoProxy:RecvQuestUpdate(data)
  self:Notify(ServiceEvent.QuestQuestUpdate, data)
end
function ServiceQuestAutoProxy:RecvQuestStepUpdate(data)
  self:Notify(ServiceEvent.QuestQuestStepUpdate, data)
end
function ServiceQuestAutoProxy:RecvQuestAction(data)
  self:Notify(ServiceEvent.QuestQuestAction, data)
end
function ServiceQuestAutoProxy:RecvRunQuestStep(data)
  self:Notify(ServiceEvent.QuestRunQuestStep, data)
end
function ServiceQuestAutoProxy:RecvQuestTrace(data)
  self:Notify(ServiceEvent.QuestQuestTrace, data)
end
function ServiceQuestAutoProxy:RecvQuestDetailList(data)
  self:Notify(ServiceEvent.QuestQuestDetailList, data)
end
function ServiceQuestAutoProxy:RecvQuestDetailUpdate(data)
  self:Notify(ServiceEvent.QuestQuestDetailUpdate, data)
end
function ServiceQuestAutoProxy:RecvQuestRaidCmd(data)
  self:Notify(ServiceEvent.QuestQuestRaidCmd, data)
end
function ServiceQuestAutoProxy:RecvQuestCanAcceptListChange(data)
  self:Notify(ServiceEvent.QuestQuestCanAcceptListChange, data)
end
function ServiceQuestAutoProxy:RecvVisitNpcUserCmd(data)
  self:Notify(ServiceEvent.QuestVisitNpcUserCmd, data)
end
function ServiceQuestAutoProxy:RecvQueryOtherData(data)
  self:Notify(ServiceEvent.QuestQueryOtherData, data)
end
function ServiceQuestAutoProxy:RecvQueryWantedInfoQuestCmd(data)
  self:Notify(ServiceEvent.QuestQueryWantedInfoQuestCmd, data)
end
function ServiceQuestAutoProxy:RecvInviteHelpAcceptQuestCmd(data)
  self:Notify(ServiceEvent.QuestInviteHelpAcceptQuestCmd, data)
end
function ServiceQuestAutoProxy:RecvInviteAcceptQuestCmd(data)
  self:Notify(ServiceEvent.QuestInviteAcceptQuestCmd, data)
end
function ServiceQuestAutoProxy:RecvReplyHelpAccelpQuestCmd(data)
  self:Notify(ServiceEvent.QuestReplyHelpAccelpQuestCmd, data)
end
function ServiceQuestAutoProxy:RecvQueryWorldQuestCmd(data)
  self:Notify(ServiceEvent.QuestQueryWorldQuestCmd, data)
end
function ServiceQuestAutoProxy:RecvQuestGroupTraceQuestCmd(data)
  self:Notify(ServiceEvent.QuestQuestGroupTraceQuestCmd, data)
end
function ServiceQuestAutoProxy:RecvHelpQuickFinishBoardQuestCmd(data)
  self:Notify(ServiceEvent.QuestHelpQuickFinishBoardQuestCmd, data)
end
function ServiceQuestAutoProxy:RecvQueryManualQuestCmd(data)
  self:Notify(ServiceEvent.QuestQueryManualQuestCmd, data)
end
function ServiceQuestAutoProxy:RecvOpenPuzzleQuestCmd(data)
  self:Notify(ServiceEvent.QuestOpenPuzzleQuestCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.QuestQuestList = "ServiceEvent_QuestQuestList"
ServiceEvent.QuestQuestUpdate = "ServiceEvent_QuestQuestUpdate"
ServiceEvent.QuestQuestStepUpdate = "ServiceEvent_QuestQuestStepUpdate"
ServiceEvent.QuestQuestAction = "ServiceEvent_QuestQuestAction"
ServiceEvent.QuestRunQuestStep = "ServiceEvent_QuestRunQuestStep"
ServiceEvent.QuestQuestTrace = "ServiceEvent_QuestQuestTrace"
ServiceEvent.QuestQuestDetailList = "ServiceEvent_QuestQuestDetailList"
ServiceEvent.QuestQuestDetailUpdate = "ServiceEvent_QuestQuestDetailUpdate"
ServiceEvent.QuestQuestRaidCmd = "ServiceEvent_QuestQuestRaidCmd"
ServiceEvent.QuestQuestCanAcceptListChange = "ServiceEvent_QuestQuestCanAcceptListChange"
ServiceEvent.QuestVisitNpcUserCmd = "ServiceEvent_QuestVisitNpcUserCmd"
ServiceEvent.QuestQueryOtherData = "ServiceEvent_QuestQueryOtherData"
ServiceEvent.QuestQueryWantedInfoQuestCmd = "ServiceEvent_QuestQueryWantedInfoQuestCmd"
ServiceEvent.QuestInviteHelpAcceptQuestCmd = "ServiceEvent_QuestInviteHelpAcceptQuestCmd"
ServiceEvent.QuestInviteAcceptQuestCmd = "ServiceEvent_QuestInviteAcceptQuestCmd"
ServiceEvent.QuestReplyHelpAccelpQuestCmd = "ServiceEvent_QuestReplyHelpAccelpQuestCmd"
ServiceEvent.QuestQueryWorldQuestCmd = "ServiceEvent_QuestQueryWorldQuestCmd"
ServiceEvent.QuestQuestGroupTraceQuestCmd = "ServiceEvent_QuestQuestGroupTraceQuestCmd"
ServiceEvent.QuestHelpQuickFinishBoardQuestCmd = "ServiceEvent_QuestHelpQuickFinishBoardQuestCmd"
ServiceEvent.QuestQueryManualQuestCmd = "ServiceEvent_QuestQueryManualQuestCmd"
ServiceEvent.QuestOpenPuzzleQuestCmd = "ServiceEvent_QuestOpenPuzzleQuestCmd"
