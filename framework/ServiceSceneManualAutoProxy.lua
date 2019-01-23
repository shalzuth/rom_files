ServiceSceneManualAutoProxy = class('ServiceSceneManualAutoProxy', ServiceProxy)

ServiceSceneManualAutoProxy.Instance = nil

ServiceSceneManualAutoProxy.NAME = 'ServiceSceneManualAutoProxy'

function ServiceSceneManualAutoProxy:ctor(proxyName)
	if ServiceSceneManualAutoProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSceneManualAutoProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()

		ServiceSceneManualAutoProxy.Instance = self
	end
end

function ServiceSceneManualAutoProxy:Init()
end

function ServiceSceneManualAutoProxy:onRegister()
	self:Listen(23, 1, function (data)
		self:RecvQueryVersion(data) 
	end)
	self:Listen(23, 2, function (data)
		self:RecvQueryManualData(data) 
	end)
	self:Listen(23, 3, function (data)
		self:RecvPointSync(data) 
	end)
	self:Listen(23, 4, function (data)
		self:RecvManualUpdate(data) 
	end)
	self:Listen(23, 5, function (data)
		self:RecvGetAchieveReward(data) 
	end)
	self:Listen(23, 6, function (data)
		self:RecvUnlock(data) 
	end)
	self:Listen(23, 7, function (data)
		self:RecvSkillPointSync(data) 
	end)
	self:Listen(23, 8, function (data)
		self:RecvLevelSync(data) 
	end)
	self:Listen(23, 9, function (data)
		self:RecvGetQuestReward(data) 
	end)
	self:Listen(23, 10, function (data)
		self:RecvStoreManualCmd(data) 
	end)
	self:Listen(23, 11, function (data)
		self:RecvGetManualCmd(data) 
	end)
	self:Listen(23, 12, function (data)
		self:RecvGroupActionManualCmd(data) 
	end)
	self:Listen(23, 13, function (data)
		self:RecvQueryUnsolvedPhotoManualCmd(data) 
	end)
	self:Listen(23, 14, function (data)
		self:RecvUpdateSolvedPhotoManualCmd(data) 
	end)
end

-- *********************************************** Call ***********************************************
function ServiceSceneManualAutoProxy:CallQueryVersion(versions) 
	local msg = SceneManual_pb.QueryVersion()
	if( versions ~= nil )then
		for i=1,#versions do 
			table.insert(msg.versions, versions[i])
		end
	end
	self:SendProto(msg)
end

function ServiceSceneManualAutoProxy:CallQueryManualData(type, item) 
	local msg = SceneManual_pb.QueryManualData()
	if(type ~= nil )then
		msg.type = type
	end
	if(item ~= nil )then
		if(item.type ~= nil )then
			msg.item.type = item.type
		end
	end
	if(item ~= nil )then
		if(item.version ~= nil )then
			msg.item.version = item.version
		end
	end
	if(item ~= nil )then
		if(item.items ~= nil )then
			for i=1,#item.items do 
				table.insert(msg.item.items, item.items[i])
			end
		end
	end
	if(item ~= nil )then
		if(item.quests ~= nil )then
			for i=1,#item.quests do 
				table.insert(msg.item.quests, item.quests[i])
			end
		end
	end
	self:SendProto(msg)
end

function ServiceSceneManualAutoProxy:CallPointSync(point) 
	local msg = SceneManual_pb.PointSync()
	if(point ~= nil )then
		msg.point = point
	end
	self:SendProto(msg)
end

function ServiceSceneManualAutoProxy:CallManualUpdate(update) 
	local msg = SceneManual_pb.ManualUpdate()
	if(update ~= nil )then
		if(update.type ~= nil )then
			msg.update.type = update.type
		end
	end
	if(update ~= nil )then
		if(update.version ~= nil )then
			msg.update.version = update.version
		end
	end
	if(update ~= nil )then
		if(update.items ~= nil )then
			for i=1,#update.items do 
				table.insert(msg.update.items, update.items[i])
			end
		end
	end
	if(update ~= nil )then
		if(update.quests ~= nil )then
			for i=1,#update.quests do 
				table.insert(msg.update.quests, update.quests[i])
			end
		end
	end
	self:SendProto(msg)
end

function ServiceSceneManualAutoProxy:CallGetAchieveReward(id) 
	local msg = SceneManual_pb.GetAchieveReward()
	if(id ~= nil )then
		msg.id = id
	end
	self:SendProto(msg)
end

function ServiceSceneManualAutoProxy:CallUnlock(type, id) 
	local msg = SceneManual_pb.Unlock()
	if(type ~= nil )then
		msg.type = type
	end
	if(id ~= nil )then
		msg.id = id
	end
	self:SendProto(msg)
end

function ServiceSceneManualAutoProxy:CallSkillPointSync(skillpoint) 
	local msg = SceneManual_pb.SkillPointSync()
	if(skillpoint ~= nil )then
		msg.skillpoint = skillpoint
	end
	self:SendProto(msg)
end

function ServiceSceneManualAutoProxy:CallLevelSync(level) 
	local msg = SceneManual_pb.LevelSync()
	if(level ~= nil )then
		msg.level = level
	end
	self:SendProto(msg)
end

function ServiceSceneManualAutoProxy:CallGetQuestReward(appendid) 
	local msg = SceneManual_pb.GetQuestReward()
	if(appendid ~= nil )then
		msg.appendid = appendid
	end
	self:SendProto(msg)
end

function ServiceSceneManualAutoProxy:CallStoreManualCmd(type, guid) 
	local msg = SceneManual_pb.StoreManualCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(guid ~= nil )then
		msg.guid = guid
	end
	self:SendProto(msg)
end

function ServiceSceneManualAutoProxy:CallGetManualCmd(type, itemid) 
	local msg = SceneManual_pb.GetManualCmd()
	if(type ~= nil )then
		msg.type = type
	end
	if(itemid ~= nil )then
		msg.itemid = itemid
	end
	self:SendProto(msg)
end

function ServiceSceneManualAutoProxy:CallGroupActionManualCmd(action, group_id) 
	local msg = SceneManual_pb.GroupActionManualCmd()
	if(action ~= nil )then
		msg.action = action
	end
	if(group_id ~= nil )then
		msg.group_id = group_id
	end
	self:SendProto(msg)
end

function ServiceSceneManualAutoProxy:CallQueryUnsolvedPhotoManualCmd(photos, time) 
	local msg = SceneManual_pb.QueryUnsolvedPhotoManualCmd()
	if( photos ~= nil )then
		for i=1,#photos do 
			table.insert(msg.photos, photos[i])
		end
	end
	if(time ~= nil )then
		msg.time = time
	end
	self:SendProto(msg)
end

function ServiceSceneManualAutoProxy:CallUpdateSolvedPhotoManualCmd(charid, sceneryid) 
	local msg = SceneManual_pb.UpdateSolvedPhotoManualCmd()
	if(charid ~= nil )then
		msg.charid = charid
	end
	if(sceneryid ~= nil )then
		msg.sceneryid = sceneryid
	end
	self:SendProto(msg)
end

-- *********************************************** Recv ***********************************************
function ServiceSceneManualAutoProxy:RecvQueryVersion(data) 
	self:Notify(ServiceEvent.SceneManualQueryVersion, data)
end

function ServiceSceneManualAutoProxy:RecvQueryManualData(data) 
	self:Notify(ServiceEvent.SceneManualQueryManualData, data)
end

function ServiceSceneManualAutoProxy:RecvPointSync(data) 
	self:Notify(ServiceEvent.SceneManualPointSync, data)
end

function ServiceSceneManualAutoProxy:RecvManualUpdate(data) 
	self:Notify(ServiceEvent.SceneManualManualUpdate, data)
end

function ServiceSceneManualAutoProxy:RecvGetAchieveReward(data) 
	self:Notify(ServiceEvent.SceneManualGetAchieveReward, data)
end

function ServiceSceneManualAutoProxy:RecvUnlock(data) 
	self:Notify(ServiceEvent.SceneManualUnlock, data)
end

function ServiceSceneManualAutoProxy:RecvSkillPointSync(data) 
	self:Notify(ServiceEvent.SceneManualSkillPointSync, data)
end

function ServiceSceneManualAutoProxy:RecvLevelSync(data) 
	self:Notify(ServiceEvent.SceneManualLevelSync, data)
end

function ServiceSceneManualAutoProxy:RecvGetQuestReward(data) 
	self:Notify(ServiceEvent.SceneManualGetQuestReward, data)
end

function ServiceSceneManualAutoProxy:RecvStoreManualCmd(data) 
	self:Notify(ServiceEvent.SceneManualStoreManualCmd, data)
end

function ServiceSceneManualAutoProxy:RecvGetManualCmd(data) 
	self:Notify(ServiceEvent.SceneManualGetManualCmd, data)
end

function ServiceSceneManualAutoProxy:RecvGroupActionManualCmd(data) 
	self:Notify(ServiceEvent.SceneManualGroupActionManualCmd, data)
end

function ServiceSceneManualAutoProxy:RecvQueryUnsolvedPhotoManualCmd(data) 
	self:Notify(ServiceEvent.SceneManualQueryUnsolvedPhotoManualCmd, data)
end

function ServiceSceneManualAutoProxy:RecvUpdateSolvedPhotoManualCmd(data) 
	self:Notify(ServiceEvent.SceneManualUpdateSolvedPhotoManualCmd, data)
end

ServiceEvent = _G["ServiceEvent"] or {}
ServiceEvent.SceneManualQueryVersion = "ServiceEvent_SceneManualQueryVersion"
ServiceEvent.SceneManualQueryManualData = "ServiceEvent_SceneManualQueryManualData"
ServiceEvent.SceneManualPointSync = "ServiceEvent_SceneManualPointSync"
ServiceEvent.SceneManualManualUpdate = "ServiceEvent_SceneManualManualUpdate"
ServiceEvent.SceneManualGetAchieveReward = "ServiceEvent_SceneManualGetAchieveReward"
ServiceEvent.SceneManualUnlock = "ServiceEvent_SceneManualUnlock"
ServiceEvent.SceneManualSkillPointSync = "ServiceEvent_SceneManualSkillPointSync"
ServiceEvent.SceneManualLevelSync = "ServiceEvent_SceneManualLevelSync"
ServiceEvent.SceneManualGetQuestReward = "ServiceEvent_SceneManualGetQuestReward"
ServiceEvent.SceneManualStoreManualCmd = "ServiceEvent_SceneManualStoreManualCmd"
ServiceEvent.SceneManualGetManualCmd = "ServiceEvent_SceneManualGetManualCmd"
ServiceEvent.SceneManualGroupActionManualCmd = "ServiceEvent_SceneManualGroupActionManualCmd"
ServiceEvent.SceneManualQueryUnsolvedPhotoManualCmd = "ServiceEvent_SceneManualQueryUnsolvedPhotoManualCmd"
ServiceEvent.SceneManualUpdateSolvedPhotoManualCmd = "ServiceEvent_SceneManualUpdateSolvedPhotoManualCmd"
