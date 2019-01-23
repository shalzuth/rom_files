SuperGvgProxy = class('SuperGvgProxy', pm.Proxy)
SuperGvgProxy.Instance = nil;
SuperGvgProxy.NAME = "SuperGvgProxy"

function SuperGvgProxy:ctor(proxyName, data)
	self.proxyName = proxyName or SuperGvgProxy.NAME
	if(SuperGvgProxy.Instance == nil) then
		SuperGvgProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self:InitProxy();
end

function SuperGvgProxy:InitProxy()
	self:InitGvg()
end

function SuperGvgProxy:InitGvg()
	self.towersMap = {}
	self.towers = {}

	self.guildsMap = {}
	self.guildIndexMap = {}

	self.userDetailDatas = {}
	self.userDetailDatasIndexMap = {}

	for k,v in pairs(GvgFinalFightTip.EGvgTowerType) do
		local towerData = {etype = k}
		towerData.info = {}
		twdata = ClientGvgTowerData.new(towerData)
		self.towersMap[towerData.etype] = twdata
		self.towers[#self.towers+1] = twdata
	end

	self.isGvgNewInit = true
end

function SuperGvgProxy:WardInfos()
end

function SuperGvgProxy:GetGuildInfos()
	return self.guildIndexMap
end


ClientGvgTowerData = class("ClientGvgTowerData")
function ClientGvgTowerData:ctor(data)
	self:updata(data)
end

function ClientGvgTowerData:updata(data)
	self.etype = data.etype
	self.estate = data.estate;
	self.owner_guild = data.owner_guild;
	local info = data.info
	-- if(not self.infos)then
		self.infos = {}
	-- end
	for i=1,#info do
		local single = info[i]
		self.infos[#self.infos+1] = {guildid = single.guildid, value = single.value}
	end
end

UserDetailData = class("UserDetailData")
function UserDetailData:ctor(data, guildId)
	self:updata(data, guildId)
end

function UserDetailData:updata(data, guildId)
	if not self.detailData then
		self.detailData = {}
	end
	self.detailData[1] = data.username
	self.detailData[2] = data.killusernum
	self.detailData[3] = data.dienum
	self.detailData[4] = data.chipnum
	self.detailData[5] = data.towertime
	self.detailData[6] = data.healhp
	self.detailData[7] = data.relivenum
	self.detailData[8] = data.metaldamage
	self.detailData[9] = data.profession
	self.detailData[10] = guildId
end

ClientGvgGuildInfo = class("ClientGvgGuildInfo")
function ClientGvgGuildInfo:ctor(data)
	self:updata(data)
end

function ClientGvgGuildInfo:updata(data)
	self.index = data.index
	self.guildid = data.guildid;
	self.guildname = data.guildname;
	self.icon = data.icon;
	self.metal_live = data.metal_live;

	self:setCrystalData(data.crystal)
end

function ClientGvgGuildInfo:updateCrystalData( data )
	self.crystalData.rank = data.rank
	self.crystalData.guildid = data.guildid
	self.crystalData.crystalnum = data.crystalnum
	self.crystalData.chipnum = data.chipnum
end

function ClientGvgGuildInfo:getCrystalData( data )
	return self.crystalData
end

function ClientGvgGuildInfo:setCrystalData( data )
	-- body
	if(not self.crystalData)then
		self.crystalData = {}
	end
	self:updateCrystalData(data)
end


function SuperGvgProxy:HandleRecvSuperGvgSyncFubenCmd(data) 
	if not self.isGvgNewInit then
		self:InitGvg()
	end

	local guildinfo = data.guildinfo
	self.fireBeginTime = data.firebegintime

	self:HandleRecvGvgTowerUpdateFubenCmd(data)

	if(guildinfo and #guildinfo>0)then
		for i=1,#guildinfo do
			local guild = guildinfo[i].crystal.guildid
			local gddata = self.guildsMap[guild]
			if(not gddata)then
				gddata = ClientGvgGuildInfo.new(guildinfo[i])
				self.guildsMap[guild] = gddata
				self.guildIndexMap[guildinfo[i].index] = gddata
			else
				gddata:updata(guildinfo[i])
			end
		end
	end

	self.isGvgNewInit = false
end

function SuperGvgProxy:HandleRecvGvgTowerUpdateFubenCmd(data)
	local towers = data.towers
	if(towers and #towers>0)then
		for i=1,#towers do
			local twdata = self.towersMap[towers[i].etype]
			if(not twdata)then
				twdata = ClientGvgTowerData.new(towers[i])
				self.towersMap[towers[i].etype] = twdata
				self.towers[#self.towers+1] = twdata
			else
				twdata:updata(towers[i])
			end
		end
	end
end

function SuperGvgProxy:HandleRecvGvgUserDetailFubenCmd(data)
	local guilduserdatas = data.guilduserdata
	-- helplog("<<<======guilduserdatas=======>>>", #guilduserdatas)
	if(guilduserdatas and #guilduserdatas>0)then
		for i=1, #guilduserdatas do
			local oneGuildUserData = guilduserdatas[i]
			local userDatas = oneGuildUserData.userdatas
			for j=1, #userDatas do
				local newData = userDatas[j]
				local oldData = self.userDetailDatas[newData.username]
				if(not oldData)then
					userdata = UserDetailData.new(newData, oneGuildUserData.guildid)
					self.userDetailDatas[newData.username] = userdata
					self.userDetailDatasIndexMap[#self.userDetailDatasIndexMap+1] = userdata
				else
					oldData:updata(newData, oneGuildUserData.guildid)
				end
			end	
		end
	end
end

function SuperGvgProxy:HandleRecvGvgMetalDieFubenCmd(data)
	local guildInfo = self.guildIndexMap[data.index]
	if(guildInfo)then
		guildInfo.metal_live = false
	end
end

function SuperGvgProxy:HandleRecvGvgCrystalUpdateFubenCmd(data)
	local crystals = data.crystals
	if(not crystals or #crystals == 0)then

	end
	for i=1,#crystals do
		local gldata = self.guildsMap[crystals[i].guildid]
		if(gldata)then
			gldata:setCrystalData(crystals[i])
		end
	end
end

-- function SuperGvgProxy:HandleRecvQueryGvgTowerInfoFubenCmd(data) 
-- end

function SuperGvgProxy:ShowGvgFinalFightTip( stick )
	-- body
	TipManager.Instance:ShowGvgFinalFightTip(stick,NGUIUtil.AnchorSide.Right,{-450,0})
end

-- 获取占领台子数据
function SuperGvgProxy:GetClientTowerData(index)
	return self.towersMap[index]
end

function SuperGvgProxy:GetGuildInfoByGuildId(guildid)
	return self.guildsMap[guildid]
end

-- 根据公会id获取决战副本中公会的index
function SuperGvgProxy:GetIndexByGuildId(guildid)
	local guildInfo  = self.guildsMap[guildid]
	if(guildInfo)then
		return guildInfo.index
	end
end

function SuperGvgProxy:GetTowers()
	return self.towers
end

function SuperGvgProxy:GetGuildsMap()
	return self.guildsMap;
end

function SuperGvgProxy:GetTowersMap()
	return self.towersMap;
end

function SuperGvgProxy:GetUserDetails()
	return self.userDetailDatasIndexMap;
end

local QueryTowerInfo_TagMap = {};
function SuperGvgProxy:Active_QueryTowerInfo(k, b)
	if(QueryTowerInfo_TagMap[k] == nil)then
		QueryTowerInfo_TagMap[k] = 0;
	end


	local oldRef = QueryTowerInfo_TagMap[k];

	if(b)then
		if(oldRef == 0)then
			ServiceFuBenCmdProxy.Instance:CallQueryGvgTowerInfoFubenCmd(k, b);
		end

		QueryTowerInfo_TagMap[k] = oldRef + 1;
	else
		if(oldRef > 0)then
			QueryTowerInfo_TagMap[k] = oldRef - 1;
		end
		if(oldRef == 1)then
			ServiceFuBenCmdProxy.Instance:CallQueryGvgTowerInfoFubenCmd(k, b);
		end
	end
end

function SuperGvgProxy:GetFinalFightTimeDiff()
	local nowtime = os.date("*t", ServerTime.CurServerTime()/1000);
	local nowTimeSec = os.time(nowtime)
	--local starTimeSec = os.time({year= nowtime.year, month= nowtime.month, day= nowtime.day, hour= GameConfig.GVGConfig.start_time[2].hour, min= GameConfig.GVGConfig.start_time[2].min})
	local secDiff = 0
	if self.fireBeginTime then
		secDiff = self.fireBeginTime - nowTimeSec --starTimeSec + GameConfig.GvgDroiyan.BeginTime + GameConfig.GvgDroiyan.NoticeTime - nowTimeSec
	end
	return secDiff;
end