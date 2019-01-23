autoImport("DojoData")
autoImport("DojoMsgData")
autoImport("DojoRewardData")

DojoProxy = class('DojoProxy', pm.Proxy)
DojoProxy.Instance = nil;
DojoProxy.NAME = "DojoProxy"

DojoCellType = "DojoMsg"

DojoProxy.PassType = {
	First = Dojo_pb.EPASSTYPE_FIRST,
	Help = Dojo_pb.EPASSTYPE_HELP,
	Normal = Dojo_pb.EPASSTYPE_NORMAL,
}

function DojoProxy:ctor(proxyName, data)
	self.proxyName = proxyName or DojoProxy.NAME
	if(DojoProxy.Instance == nil) then
		DojoProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:Init()
end

function DojoProxy:Init()
	self.maxCompletedId = 0
	self.msgData = {}
	self.rewardItems = {}
	self.chatMaxNums = 50
end

function DojoProxy:RecvDojoPrivateInfo(data)

	local groupid = data.groupid
	if groupid == nil then
		errorLog("DojoProxy RecvDojoPrivateInfo groupId == nil")
		return
	end

	self:HandleDojoData(groupid)
	self.maxCompletedId = 0

	for i=1,#self.dojoData[groupid] do
		local dojo = self.dojoData[groupid][i]
		if i == 1 then
			dojo:SetLock(false)
		end
		for j=1,#data.completed_id do
			if dojo.id == data.completed_id[j] then
				self.dojoData[groupid][i]:SetComplete(true)
				if dojo.id > self.maxCompletedId then
					self.maxCompletedId = dojo.id
				end
			end
		end
	end
end

function DojoProxy:RecvDojoPublicInfo(data)
	if data == nil then
		errorLog("DojoProxy RecvDojoPublicInfo data == nil")
		return		
	end
	if data.dojoid == nil then
		errorLog("DojoProxy RecvDojoPublicInfo data.dojoid == nil")
		return			
	end
	if data.msgblob == nil then
		errorLog("DojoProxy RecvDojoPublicInfo data.msgblob == nil")
		return		
	end
	if data.msgblob.msgs == nil then
		errorLog("DojoProxy RecvDojoPublicInfo data.msgblob.msgs == nil")
		return		
	end

	self.msgData[data.dojoid] = {}

	for i=1,#data.msgblob.msgs do
		if data.msgblob.msgs[i] then
			local msg = DojoMsgData.new(data.msgblob.msgs[i])
			table.insert(self.msgData[data.dojoid] , 1 , msg)
		else
			errorLog(string.format("DojoProxy RecvDojoPublicInfo data.msgblob.msgs[%s] == nil",tostring(i)))
		end
	end
end

function DojoProxy:RecvAddMsg(data)
	if data == nil then
		errorLog("DojoProxy RecvAddMsg data == nil")
		return		
	end

	if(#self.msgData[data.dojoid] >= self.chatMaxNums)then
		table.remove(self.msgData[data.dojoid] , 1)
	end

	local msg = DojoMsgData.new(data.dojomsg)
	table.insert(self.msgData[data.dojoid] , 1 , msg)
end

function DojoProxy:RecvDojoReward(data)
	TableUtility.ArrayClear(self.rewardItems)
	if data and data.items then
		for i=1,#data.items do
			local itemInfo = DojoRewardData.new(data.items[i])
			table.insert(self.rewardItems , itemInfo)
		end
	end
end

function DojoProxy:InitGroupData()
	self.groupData = {}
	for k,v in ipairs(GameConfig.GuildDojo.Dojo) do
		table.insert(self.groupData , v)
	end
	table.sort( self.groupData, function(l,r)
		return l.DojoGroupId < r.DojoGroupId
	end)
end

function DojoProxy:InitDojoData()
	self.dojoData = {}
	for k,v in ipairs(Table_Guild_Dojo) do
		local groupId = v.DojoGroupId
		if groupId then
			if self.dojoData[groupId] == nil then
				self.dojoData[groupId] = {}
			end
			table.insert(self.dojoData[groupId],DojoData.new(v))
		else
			errorLog("DojoProxy InitDojoData groupId = nil")
		end
	end
	for k,v in ipairs(self.dojoData) do
		table.sort( v, function(l,r)
			return l.id < r.id
		end)
	end
end

function DojoProxy:InitGuildInfo()
	self.guildInfo = {}
	for k,v in ipairs(Table_Guild) do
		for i=1,#v.DojoGroup do
			local groupid = v.DojoGroup[i]
			if self.guildInfo[groupid] == nil then
				self.guildInfo[groupid] = {}
			end
			table.insert(self.guildInfo[groupid] , v.id)
		end
	end
end

function DojoProxy:HandleDojoData(groupId)
	if groupId == nil then
		errorLog("DojoProxy HandleDojoData groupId == nil")
		return
	end
	if self.dojoData == nil then
		self:InitDojoData()
	end
	if self.dojoData[groupId] == nil then
		self.dojoData[groupId] = {}
	end
end

function DojoProxy:GetGroupData()
	if self.groupData == nil then
		self:InitGroupData()
	end
	return self.groupData
end

function DojoProxy:GetDojoData(groupId)
	if groupId == nil then
		errorLog("DojoProxy GetDojoData groupId == nil")
		return
	end

	self:HandleDojoData(groupId)

	return self.dojoData[groupId]
end

function DojoProxy:GetMsgData(dojoid)
	if self.msgData[dojoid] == nil then
		self.msgData[dojoid] = {}
	end
	return self.msgData[dojoid]
end

function DojoProxy:GetWaitData()
	local result = {}
	local members = TeamProxy.Instance.myTeam:GetPlayerMemberList(false, true)
	for i=1,#members do
		local id = members[i].id
		if GuildProxy.Instance:CheckPlayerInMyGuild(id) then
			local data = {}
			data.id = id
			data.name = members[i].name

			if id == Game.Myself.data.id then
				data.agree = true
			end

			table.insert(result , data)
		end
	end
	return result
end

function DojoProxy:IsSelfInDojo()
	local mapid = Game.MapManager:GetMapID();
	if mapid then
		local mapRaid = Table_MapRaid[mapid]
		if mapRaid then
			if mapRaid.Type == 9 then
				return true
			end
		end
	end
	return false
end

function DojoProxy:RecvCountdownUserCmd(data)
	TimeTickManager.Me():ClearTick(self)
	self.TicData = {}
	if(data and data.tick and data.tick ~=0)then
		self.TicData.tick = data.tick
		TimeTickManager.Me():CreateTick(0,50,self.UpdateTip,self)
	end
end

function DojoProxy:UpdateTip(deltaTime)
	-- body
	if(self.TicData.tick <=0)then
		TimeTickManager.Me():ClearTick(self)
		return
	end
	self.TicData.tick = self.TicData.tick - deltaTime/1000
end

function DojoProxy:GetCountdownUserCmd()
	if(self.TicData and self.TicData.tick)then
		self.TicData.tick = math.floor(self.TicData.tick)
	end
	return self.TicData
end

function DojoProxy:CheckCanOpenGroup(groupId)
	local myGuildData = GuildProxy.Instance.myGuildData
	if myGuildData == nil then
		return false
	end

	if self.guildInfo == nil then
		self:InitGuildInfo()
	end

	if self.guildInfo[groupId] == nil then
		return false
	end

	for i=1,#self.guildInfo[groupId] do
		local guildLevel = self.guildInfo[groupId][i]
		if guildLevel and myGuildData.level >= guildLevel then
			return true
		end
	end
	
	return false
end

function DojoProxy:GetGuildDataByGroupId(groupId)
	if self.guildInfo == nil then
		self:InitGuildInfo()
	end
	return self.guildInfo[groupId]
end

function DojoProxy:GetReward()
	return self.rewardItems
end

function DojoProxy:IsLockById(id)
	if id > self.maxCompletedId + 1 then
		return true
	end

	return false
end

function DojoProxy:GetGroupLvreq(dojoid)
	local data = Table_Guild_Dojo[dojoid]
	local lvreq
	if data and data.DojoGroupId then		
		for k,v in ipairs(GameConfig.GuildDojo.Dojo) do
			if v.DojoGroupId == data.DojoGroupId then
				lvreq = v.lvreq
				break
			end
		end
	end
	return lvreq
end