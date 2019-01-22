autoImport("PVEFactory")
autoImport("PVPFactory")
DungeonManager = class("DungeonManager")

DungeonManager.Event = {
	Launched = "DungeonManager_Launched",
}

-- PVE START -------
local PVERaidConfig = {
	Pve_Card = {Type = 28, DungeonSpawner = PVEFactory.GetPveCard},
	AltMan = {Type = 31, DungeonSpawner = PVEFactory.GetAltMan},
}
-- PVE END -------


--      PVP START-----
--type???mapraid??????type, DungeonSpawner ???PVP??????????????????
local PVPRaidConfig = {
--??????????????????
	PVP_ChaosFight = {Type = 21, DungeonSpawner = PVPFactory.GetSinglePVP},
--????????????????????????
	PVP_TwoTeamFight = {Type = 22, DungeonSpawner = PVPFactory.GetTwoTeamPVP},
--??????????????????????????????
	PVP_TeamsFight = {Type = 23, DungeonSpawner = PVPFactory.GetTeamsPVP},

	PVP_PoringFight = {Type = 25, DungeonSpawner = PVPFactory.GetPoringFight},
	PVP_MvpFight = {Type = 29, DungeonSpawner = PVPFactory.GetMvpFight},
}

local GVGRaidConfig = {
	--GVG?????????
	GVG_GuildMetalFight = {Type = 14, DungeonSpawner = PVPFactory.GetGuildMetalGVG},
	-- Gvg??????
	GVG_Droiyan = {Type = 30, DungeonSpawner = PVPFactory.GetGvgDroiyan},
}

--      PVP END-------


-------- Guild --------
local GuildArea_DungeonID = 10001;
-------- Guild --------



local EndlessTowerType = FuBenCmd_pb.ERAIDTYPE_TOWER


function DungeonManager:ctor()
	self.dungeons = {}

	-- register dungeons
	-- self.dungeons[1] = Dungeon_Test.new()

	self:_InitPVEDungeons();
	--for pvp
	self:_InitPVPDungeons()

	self:_Reset()
end

function DungeonManager:_InitPVEDungeons()
	self.pveType = {};

	-- pve
	for k,v in pairs(PVERaidConfig)do
		self.dungeons[v.Type] = v.DungeonSpawner()
		self.pveType[v.Type] = 1
	end
end

function DungeonManager:_InitPVPDungeons()
	self.pvpType = {}

	--pvp
	for k,v in pairs(PVPRaidConfig) do
		self.dungeons[v.Type] = v.DungeonSpawner()
		self.pvpType[v.Type] = 1
	end

	--gvg
	for k,v in pairs(GVGRaidConfig) do
		self.dungeons[v.Type] = v.DungeonSpawner()
		self.pvpType[v.Type] = 1
	end
end

function DungeonManager:_Reset()
	self.running = false
	self.raidID = 0
	self.currentDungeon = nil
	self.isPVPRaid = false
	self.isEndlessTower = false
end

function DungeonManager:IsPVPRaidMode()
	return self.currentDungeon~=nil and self.isPVPRaid
end

function DungeonManager:IsGVG_Detailed()
	return self.currentDungeon~=nil and self.currentDungeon.isGVG
end

function DungeonManager:IsPVPMode_PoringFight()
	return self.currentDungeon~=nil and self.currentDungeon.isPoringFight or false;
end

function DungeonManager:IsPVPMode_MvpFight()
	return self.currentDungeon~=nil and self.currentDungeon.isMvpFight or false;
end

function DungeonManager:IsPveMode_PveCard()
	return self.currentDungeon~=nil and self.currentDungeon.isPveCard or false;
end

function DungeonManager:IsGvgMode_Droiyan()
	return self.currentDungeon~=nil and self.currentDungeon.isGvgDroiyan or false;
end

function DungeonManager:IsPveMode_AltMan()
	return self.currentDungeon~=nil and self.currentDungeon.isAltman or false;
end

function DungeonManager:IsNoSelectTarget()
	if(self.currentDungeon~=nil) then
		return self.currentDungeon.noSelectTarget or false
	end
	return false
end

function DungeonManager:IsEndlessTower()
	return self.isEndlessTower
end

function DungeonManager:SetRaidID(raidID)
	Debug_AssertFormat(not self.running, "Dungeon is running: SetRaidID({0})", raidID)
	
	local raidInfo = Table_MapRaid[raidID]
	local raidType = raidInfo.Type

	self.raidID = raidID
	self.currentDungeon = self.dungeons[raidType]
	if(self.pvpType[raidType]) then
		self.isPVPRaid = true
	else
		self.isPVPRaid = false
	end
	self.isEndlessTower = raidType == EndlessTowerType
end

function DungeonManager:Launch()
	if self.running then
		return
	end
	self.running = true

	if(self.raidID and self.raidID == 60702) then
		self:CameraDisable({0})
		self:CameraEnable({1})
	end

	if nil ~= self.currentDungeon then
		self.currentDungeon:Launch(self.raidID)
	end

	if(self.raidID == GuildArea_DungeonID)then
		self:EnterGuildAreaHandle();
	end
	EventManager.Me():PassEvent(DungeonManager.Event.Launched)
end

function DungeonManager:Shutdown()
	if not self.running then
		return
	end
	self.running = false

	if nil ~= self.currentDungeon then
		self.currentDungeon:Shutdown()
	end

	if(self.raidID == GuildArea_DungeonID)then
		self:ExitGuildAreaHandle();
	end
	
	self:_Reset()
end

function DungeonManager:Update(time, deltaTime)
	if not self.running then
		return
	end

	-- update dungeon
	if nil ~= self.currentDungeon then
		self.currentDungeon:Update(time, deltaTime)
	end
end

function DungeonManager:CameraEnable(grp)
	if(grp) then
		local cameraPointManager = CameraPointManager.Instance
		for i=1,#grp do
			cameraPointManager:EnableGroup(grp[i])
		end
	end
end

function DungeonManager:CameraDisable(grp)
	if(grp) then
		local cameraPointManager = CameraPointManager.Instance
		for i=1,#grp do
			cameraPointManager:DisableGroup(grp[i])
		end
	end
end

function DungeonManager:EnterGuildAreaHandle()
end

function DungeonManager:ExitGuildAreaHandle()
	GuildProxy.Instance:ClearGuildGateInfo()
end
