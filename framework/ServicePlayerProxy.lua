-- player
local ServicePlayerProxy = class('ServicePlayerProxy', ServiceProxy)

ServicePlayerProxy.Instance = nil;

ServicePlayerProxy.NAME = "ServicePlayerProxy"

function ServicePlayerProxy:ctor(proxyName)	
	if ServicePlayerProxy.Instance == nil then		
		self.proxyName = proxyName or ServicePlayerProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)

		ServicePlayerProxy.Instance = self
	end
end

function ServicePlayerProxy:onRegister()
	self:Listen(5, 22, function (data)
		self:ChangeDress(data)
	end)

	self:Listen(5, 13, function (data)
		self:AddMapNpc(data)
	end)

	self:Listen(5, 16, function (data)
		self:MoveTo(data)
	end)

	-- self:Listen(3, 1, function (data)
	-- 	self:OldUserAttrSyncCmd(data)
	-- end)

	self:Listen(5, 1, function (data)
		self:UserAttrSyncCmd(data)
	end)

	self:Listen(5, 27, function (data)
		self:SkillBroadcast(data)
	end)

	-- region map 
	self:Listen(5, 12, function (data)
		self:MapOtherUserIn(data)
	end)

	self:Listen(5, 23, function (data)
		self:MapChange(data)
	end)	

	self:Listen(5, 18, function (data)
		self:MapOtherUserOut(data)
	end)

	self:Listen(5, 38, function (data)
		self:MapObjectData(data)
	end)
	-- endregion
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
	-- msg.target = ProtoCommon_pb.ScenePos()
	msg.target.x = self:ToServerFloat(tx)
	msg.target.y = self:ToServerFloat(ty)
	msg.target.z = self:ToServerFloat(tz)
	self:SendProto(msg)
end

function ServicePlayerProxy:CallSkillBroadcast(random, data, creature, targetCreatureGUID)
	local msg = SceneUser_pb.SkillBroadcastUserCmd()
	msg.charid = Game.Myself.data.id
	msg.random = random or 0
	-- pos
	
	-- print(roleID.." call use skill.."..skillID.." number "..data.number)

	-- for i=1, #msg.data.rotation do 
	-- 	print("send "..msg.data.rotation[i])
	-- end
	data:ToServerData(msg, creature, targetCreatureGUID)
	-- TableUtil.Print(msg)
	self:SendProto(msg)

	-- test bug begin
	-- LogUtility.InfoFormat("<color=yellow>CallSkillBroadcast: </color>{0}, {1}", 
	-- 	LogUtility.StringFormat("skillID={0}, number={1}", 
	-- 		msg.skillID, 
	-- 		msg.data.number),
	-- 	LogUtility.StringFormat("pos={0}, dir={1}", 
	-- 		msg.data.pos and LogUtility.StringFormat("({0}, {1}, {2})", msg.data.pos.x, msg.data.pos.y, msg.data.pos.z) or "nil", 
	-- 		LogUtility.ToString(msg.data.dir)))
	-- if nil ~= msg.data.hitedTargets and 0 < #msg.data.hitedTargets then
	-- 	local targetCount = #msg.data.hitedTargets
	-- 	local logString = LogUtility.StringFormat("<color=yellow>CallSkillBroadcast Targets: </color>{0}\n", targetCount)
	-- 	for i=1, targetCount do
	-- 		local targetInfo = msg.data.hitedTargets[i]
	-- 		logString = LogUtility.StringFormat("{0}charid={1}, {2}\n", 
	-- 			logString, 
	-- 			targetInfo.charid,
	-- 			LogUtility.StringFormat("damageType={0}, damage={1}", 
	-- 				targetInfo.type, 
	-- 				targetInfo.damage))
	-- 	end
	-- 	LogUtility.Info(logString)
	-- else
	-- 	LogUtility.Info("<color=yellow>CallSkillBroadcast Targets: </color>0")
	-- end
	-- local msgStr = msg:SerializeToString()
	-- local testMsg = SceneUser_pb.SkillBroadcastUserCmd()
	-- testMsg:ParseFromString(msgStr)
	-- test bug end
end

function ServicePlayerProxy:CallUserAttrPointCmd(Ptype , etype)
	msg = SceneUser_pb.UserAttrPointCmd()
	msg.type = etype or SceneUser_pb.POINTTYPE_ADD
	msg.ptype = Ptype
	self:SendProto(msg)
end

------------------------------- Map -------------------------------
function ServicePlayerProxy:CallMapObjectData(guid)
	msg = SceneUser_pb.MapObjectData()
	msg.guid = guid
	self:SendProto(msg)
end

function ServicePlayerProxy:MapOtherUserOut(data)
	SceneObjectProxy.RemoveObjs(data.list,data.delay_del,data.fadeout)
	-- print("FUN >>> ServicePlayerProxy:MapOtherUserOut",#data.list)
	self:Notify(ServiceEvent.PlayerMapOtherUserOut, data)
end

ServicePlayerProxy.mapChangeForCreateRole = false
function ServicePlayerProxy:MapChange(data)
	self.map_imageid = data.imageid;
	
	if ServicePlayerProxy.mapChangeForCreateRole then
		local cloneData = SceneUser_pb.ChangeSceneUserCmd()
		cloneData:MergeFrom(data)
		EventManager.Me():PassEvent(CreateRoleViewEvent.PlayerMapChange, cloneData)
		return
	end

	self:Notify(ServiceEvent.PlayerMapChange, data,LoadSceneEvent.StartLoad)
	--test 
	-- local t = SceneUser_pb.ChangeSceneUserCmd()
	-- t.mapID = 5
	-- t.mapName = ""
	-- self:Notify(ServiceEvent.PlayerMapChange, t,LoadSceneEvent.StartLoad)

	-- local t2 = SceneUser_pb.ChangeSceneUserCmd()
	-- t2.mapID = 2
	-- t2.mapName = ""
	-- self:Notify(ServiceEvent.PlayerMapChange, t2,LoadSceneEvent.StartLoad)
end

function ServicePlayerProxy:GetCurMapImageId()
	return self.map_imageid;
end

function ServicePlayerProxy:MapObjectData(data)
	self:Notify(ServiceEvent.PlayerMapObjectData, data,LoadSceneEvent.StartLoad)
end
------------------------------- End Map -------------------------------

function ServicePlayerProxy:ChangeDress(data)
	UserProxy.Instance:ChangeDress(data)
	self:Notify(ServiceEvent.PlayerChangeDress, data)
end

function ServicePlayerProxy:MoveTo(data)
	data.pos.x = self:ToFloat(data.pos.x)
	data.pos.y = self:ToFloat(data.pos.y)
	data.pos.z = self:ToFloat(data.pos.z)

	NSceneUserProxy.Instance:SyncMove(data)
	if(not NSceneNpcProxy.Instance:SyncMove(data)) then
		NScenePetProxy.Instance:SyncMove(data)
	end
end

function ServicePlayerProxy:AddMapNpc(data)	
	SceneNpcProxy.Instance:AddSome(data.list)
	self:Notify(ServiceEvent.PlayerAddMapNpc, data)
end

function ServicePlayerProxy:UserAttrSyncCmd(data)
	-- LogUtility.Info("<color=green>ServicePlayerProxy:UserAttrSyncCmd(data)</color>")
	self:Notify(ServiceEvent.PlayerSAttrSyncData, data)
end

-- function ServicePlayerProxy:OldUserAttrSyncCmd(data)	
-- 	self:Notify(ServiceEvent.PlayerSAttrSyncData, data)
-- end

function ServicePlayerProxy:SkillBroadcast(data)
	-- for i=1, #data.data.rotation do 
	-- 	data.data.rotation[i] = self:ToFloat(data.data.rotation[i])
	-- 	-- print("rec "..data.data.rotation[i])
	-- end
	-- print(data.charid.." serverUser use skill "..data.skillID.." number."..data.data.number)

	-- local hitedTargets = data.data.hitedTarget
	-- if(hitedTargets~=nil) then
	-- 	-- hitedTargets
	-- 	local t = ""
	-- 	for i = 1, #hitedTargets do
	-- 		t = t.." "..hitedTargets[i]
	-- 	end
	-- 	print("玩家"..data.charid.."尝试攻击"..t)
	-- end
	
	-- LogUtility.InfoFormat("<color=yellow>SyncServerSkill: </color>{0}, {1}, {2}", 
	-- 	data.charid,
	-- 	data.skillID,
	-- 	data.data.number)
	if(not NSceneUserProxy.Instance:SyncServerSkill(data)) then
		if( not NSceneNpcProxy.Instance:SyncServerSkill(data)) then
			NScenePetProxy.Instance:SyncServerSkill(data)
		end
	end
	-- self:Notify(ServiceEvent.PlayerSkillBroadcast, data)
end

return ServicePlayerProxy