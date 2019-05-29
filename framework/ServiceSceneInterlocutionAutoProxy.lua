ServiceSceneInterlocutionAutoProxy = class("ServiceSceneInterlocutionAutoProxy", ServiceProxy)
ServiceSceneInterlocutionAutoProxy.Instance = nil
ServiceSceneInterlocutionAutoProxy.NAME = "ServiceSceneInterlocutionAutoProxy"
function ServiceSceneInterlocutionAutoProxy:ctor(proxyName)
  if ServiceSceneInterlocutionAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneInterlocutionAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneInterlocutionAutoProxy.Instance = self
  end
end
function ServiceSceneInterlocutionAutoProxy:Init()
end
function ServiceSceneInterlocutionAutoProxy:onRegister()
  self:Listen(22, 1, function(data)
    self:RecvNewInter(data)
  end)
  self:Listen(22, 2, function(data)
    self:RecvAnswer(data)
  end)
  self:Listen(22, 3, function(data)
    self:RecvQuery(data)
  end)
end
function ServiceSceneInterlocutionAutoProxy:CallNewInter(inter, npcid, answerid)
  local msg = SceneInterlocution_pb.NewInter()
  if inter ~= nil and inter.guid ~= nil then
    msg.inter.guid = inter.guid
  end
  if inter ~= nil and inter.interid ~= nil then
    msg.inter.interid = inter.interid
  end
  if inter ~= nil and inter.source ~= nil then
    msg.inter.source = inter.source
  end
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if answerid ~= nil then
    msg.answerid = answerid
  end
  self:SendProto(msg)
end
function ServiceSceneInterlocutionAutoProxy:CallAnswer(npcid, guid, interid, source, answer, correct)
  local msg = SceneInterlocution_pb.Answer()
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if guid ~= nil then
    msg.guid = guid
  end
  if interid ~= nil then
    msg.interid = interid
  end
  if source ~= nil then
    msg.source = source
  end
  if answer ~= nil then
    msg.answer = answer
  end
  if correct ~= nil then
    msg.correct = correct
  end
  self:SendProto(msg)
end
function ServiceSceneInterlocutionAutoProxy:CallQuery(npcid, ret)
  local msg = SceneInterlocution_pb.Query()
  if npcid ~= nil then
    msg.npcid = npcid
  end
  if ret ~= nil then
    msg.ret = ret
  end
  self:SendProto(msg)
end
function ServiceSceneInterlocutionAutoProxy:RecvNewInter(data)
  self:Notify(ServiceEvent.SceneInterlocutionNewInter, data)
end
function ServiceSceneInterlocutionAutoProxy:RecvAnswer(data)
  self:Notify(ServiceEvent.SceneInterlocutionAnswer, data)
end
function ServiceSceneInterlocutionAutoProxy:RecvQuery(data)
  self:Notify(ServiceEvent.SceneInterlocutionQuery, data)
end
ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.SceneInterlocutionNewInter = "ServiceEvent_SceneInterlocutionNewInter"
ServiceEvent.SceneInterlocutionAnswer = "ServiceEvent_SceneInterlocutionAnswer"
ServiceEvent.SceneInterlocutionQuery = "ServiceEvent_SceneInterlocutionQuery"
