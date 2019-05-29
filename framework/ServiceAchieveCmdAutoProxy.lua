ServiceAchieveCmdAutoProxy = class("ServiceAchieveCmdAutoProxy", ServiceProxy)
ServiceAchieveCmdAutoProxy.Instance = nil
ServiceAchieveCmdAutoProxy.NAME = "ServiceAchieveCmdAutoProxy"
function ServiceAchieveCmdAutoProxy:ctor(proxyName)
  if ServiceAchieveCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceAchieveCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceAchieveCmdAutoProxy.Instance = self
  end
end
function ServiceAchieveCmdAutoProxy:Init()
end
function ServiceAchieveCmdAutoProxy:onRegister()
  self:Listen(17, 1, function(data)
    self:RecvQueryUserResumeAchCmd(data)
  end)
  self:Listen(17, 2, function(data)
    self:RecvQueryAchieveDataAchCmd(data)
  end)
  self:Listen(17, 3, function(data)
    self:RecvNewAchieveNtfAchCmd(data)
  end)
  self:Listen(17, 4, function(data)
    self:RecvRewardGetAchCmd(data)
  end)
end
function ServiceAchieveCmdAutoProxy:CallQueryUserResumeAchCmd(data)
  local msg = AchieveCmd_pb.QueryUserResumeAchCmd()
  if data ~= nil and data.createtime ~= nil then
    msg.data.createtime = data.createtime
  end
  if data ~= nil and data.logintime ~= nil then
    msg.data.logintime = data.logintime
  end
  if data ~= nil and data.bepro_1_time ~= nil then
    msg.data.bepro_1_time = data.bepro_1_time
  end
  if data ~= nil and data.bepro_2_time ~= nil then
    msg.data.bepro_2_time = data.bepro_2_time
  end
  if data ~= nil and data.bepro_3_time ~= nil then
    msg.data.bepro_3_time = data.bepro_3_time
  end
  if data ~= nil and data.walk_distance ~= nil then
    msg.data.walk_distance = data.walk_distance
  end
  if data ~= nil and data.max_team ~= nil then
    msg.data.max_team = data.max_team
  end
  if data ~= nil and data.max_hand ~= nil then
    msg.data.max_hand = data.max_hand
  end
  if data ~= nil and data.max_wheel ~= nil then
    msg.data.max_wheel = data.max_wheel
  end
  if data ~= nil and data.max_chat ~= nil then
    msg.data.max_chat = data.max_chat
  end
  if data ~= nil and data.max_teams ~= nil then
    for i = 1, #data.max_teams do
      table.insert(msg.data.max_teams, data.max_teams[i])
    end
  end
  if data ~= nil and data.max_hands ~= nil then
    for i = 1, #data.max_hands do
      table.insert(msg.data.max_hands, data.max_hands[i])
    end
  end
  if data ~= nil and data.max_wheels ~= nil then
    for i = 1, #data.max_wheels do
      table.insert(msg.data.max_wheels, data.max_wheels[i])
    end
  end
  if data ~= nil and data.max_chats ~= nil then
    for i = 1, #data.max_chats do
      table.insert(msg.data.max_chats, data.max_chats[i])
    end
  end
  if data ~= nil and data.max_music ~= nil then
    for i = 1, #data.max_music do
      table.insert(msg.data.max_music, data.max_music[i])
    end
  end
  if data ~= nil and data.max_save ~= nil then
    for i = 1, #data.max_save do
      table.insert(msg.data.max_save, data.max_save[i])
    end
  end
  if data ~= nil and data.max_besave ~= nil then
    for i = 1, #data.max_besave do
      table.insert(msg.data.max_besave, data.max_besave[i])
    end
  end
  self:SendProto(msg)
end
function ServiceAchieveCmdAutoProxy:CallQueryAchieveDataAchCmd(type, items)
  local msg = AchieveCmd_pb.QueryAchieveDataAchCmd()
  if type ~= nil then
    msg.type = type
  end
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceAchieveCmdAutoProxy:CallNewAchieveNtfAchCmd(type, items)
  local msg = AchieveCmd_pb.NewAchieveNtfAchCmd()
  if type ~= nil then
    msg.type = type
  end
  if items ~= nil then
    for i = 1, #items do
      table.insert(msg.items, items[i])
    end
  end
  self:SendProto(msg)
end
function ServiceAchieveCmdAutoProxy:CallRewardGetAchCmd(id)
  local msg = AchieveCmd_pb.RewardGetAchCmd()
  if id ~= nil then
    msg.id = id
  end
  self:SendProto(msg)
end
function ServiceAchieveCmdAutoProxy:RecvQueryUserResumeAchCmd(data)
  self:Notify(ServiceEvent.AchieveCmdQueryUserResumeAchCmd, data)
end
function ServiceAchieveCmdAutoProxy:RecvQueryAchieveDataAchCmd(data)
  self:Notify(ServiceEvent.AchieveCmdQueryAchieveDataAchCmd, data)
end
function ServiceAchieveCmdAutoProxy:RecvNewAchieveNtfAchCmd(data)
  self:Notify(ServiceEvent.AchieveCmdNewAchieveNtfAchCmd, data)
end
function ServiceAchieveCmdAutoProxy:RecvRewardGetAchCmd(data)
  self:Notify(ServiceEvent.AchieveCmdRewardGetAchCmd, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.AchieveCmdQueryUserResumeAchCmd = "ServiceEvent_AchieveCmdQueryUserResumeAchCmd"
ServiceEvent.AchieveCmdQueryAchieveDataAchCmd = "ServiceEvent_AchieveCmdQueryAchieveDataAchCmd"
ServiceEvent.AchieveCmdNewAchieveNtfAchCmd = "ServiceEvent_AchieveCmdNewAchieveNtfAchCmd"
ServiceEvent.AchieveCmdRewardGetAchCmd = "ServiceEvent_AchieveCmdRewardGetAchCmd"
