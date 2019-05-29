local ServicePlayerProxy = class("ServicePlayerProxy", ServiceProxy)
ServicePlayerProxy.Instance = nil
ServicePlayerProxy.NAME = "ServicePlayerProxy"
function ServicePlayerProxy:ctor(proxyName)
  if ServicePlayerProxy.Instance == nil then
    self.proxyName = proxyName or ServicePlayerProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    ServicePlayerProxy.Instance = self
  end
end
function ServicePlayerProxy:onRegister()
  self:Listen(5, 22, function(data)
    self:ChangeDress(data)
  end)
  self:Listen(5, 13, function(data)
    self:AddMapNpc(data)
  end)
  self:Listen(5, 16, function(data)
    self:MoveTo(data)
  end)
  self:Listen(5, 1, function(data)
    self:UserAttrSyncCmd(data)
  end)
  self:Listen(5, 27, function(data)
    self:SkillBroadcast(data)
  end)
  self:Listen(5, 12, function(data)
    self:MapOtherUserIn(data)
  end)
  self:Listen(5, 23, function(data)
    self:MapChange(data)
  end)
  self:Listen(5, 18, function(data)
    self:MapOtherUserOut(data)
  end)
  self:Listen(5, 38, function(data)
    self:MapObjectData(data)
  end)
end
function ServicePlayerProxy:CallChangeMap(mapName, x, y, z, mapID)
  msg = SceneUser_pb.ChangeSceneUserCmd()
  msg.mapID = mapID
  msg.mapName = mapName
  msg.pos.x = x
  msg.pos.y = y
  msg.pos.z = z
  self:SendProto(msg)
end
function ServicePlayerProxy:CallChangeDress(charid, male, body, hair, rightHand, profession, accessory, wing)
  local msg = SceneUser_pb.ChangeBodyUserCmd()
  msg.charid = charid
  msg.male = male
  msg.body = body
  msg.hair = hair
  msg.rightHand = rightHand
  msg.profession = profession
  msg.accessory = accessory
  msg.wing = wing
  self:SendProto(msg)
end
function ServicePlayerProxy:CallMoveTo(tx, ty, tz)
  local msg = SceneUser_pb.ReqMoveUserCmd()
  msg.target.x = self:ToServerFloat(tx)
  msg.target.y = self:ToServerFloat(ty)
  msg.target.z = self:ToServerFloat(tz)
  self:SendProto(msg)
end
function ServicePlayerProxy:CallSkillBroadcast(random, data, creature, targetCreatureGUID)
  local msg = SceneUser_pb.SkillBroadcastUserCmd()
  msg.charid = Game.Myself.data.id
  msg.random = random or 0
  data:ToServerData(msg, creature, targetCreatureGUID)
  self:SendProto(msg)
end
function ServicePlayerProxy:CallUserAttrPointCmd(Ptype, etype)
  msg = SceneUser_pb.UserAttrPointCmd()
  msg.type = etype or SceneUser_pb.POINTTYPE_ADD
  msg.ptype = Ptype
  self:SendProto(msg)
end
function ServicePlayerProxy:CallMapObjectData(guid)
  msg = SceneUser_pb.MapObjectData()
  msg.guid = guid
  self:SendProto(msg)
end
function ServicePlayerProxy:MapOtherUserOut(data)
  SceneObjectProxy.RemoveObjs(data.list, data.delay_del, data.fadeout)
  self:Notify(ServiceEvent.PlayerMapOtherUserOut, data)
end
ServicePlayerProxy.mapChangeForCreateRole = false
function ServicePlayerProxy:MapChange(data)
  self.map_imageid = data.imageid
  if ServicePlayerProxy.mapChangeForCreateRole then
    local cloneData = SceneUser_pb.ChangeSceneUserCmd()
    cloneData:MergeFrom(data)
    EventManager.Me():PassEvent(CreateRoleViewEvent.PlayerMapChange, cloneData)
    return
  end
  self:Notify(ServiceEvent.PlayerMapChange, data, LoadSceneEvent.StartLoad)
end
function ServicePlayerProxy:GetCurMapImageId()
  return self.map_imageid
end
function ServicePlayerProxy:MapObjectData(data)
  self:Notify(ServiceEvent.PlayerMapObjectData, data, LoadSceneEvent.StartLoad)
end
function ServicePlayerProxy:ChangeDress(data)
  UserProxy.Instance:ChangeDress(data)
  self:Notify(ServiceEvent.PlayerChangeDress, data)
end
function ServicePlayerProxy:MoveTo(data)
  data.pos.x = self:ToFloat(data.pos.x)
  data.pos.y = self:ToFloat(data.pos.y)
  data.pos.z = self:ToFloat(data.pos.z)
  NSceneUserProxy.Instance:SyncMove(data)
  if not NSceneNpcProxy.Instance:SyncMove(data) then
    NScenePetProxy.Instance:SyncMove(data)
  end
end
function ServicePlayerProxy:AddMapNpc(data)
  SceneNpcProxy.Instance:AddSome(data.list)
  self:Notify(ServiceEvent.PlayerAddMapNpc, data)
end
function ServicePlayerProxy:UserAttrSyncCmd(data)
  self:Notify(ServiceEvent.PlayerSAttrSyncData, data)
end
function ServicePlayerProxy:SkillBroadcast(data)
  if not NSceneUserProxy.Instance:SyncServerSkill(data) and not NSceneNpcProxy.Instance:SyncServerSkill(data) then
    NScenePetProxy.Instance:SyncServerSkill(data)
  end
end
return ServicePlayerProxy
