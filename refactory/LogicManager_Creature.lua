autoImport ("SimplePlayer")
autoImport ("NCreature")
autoImport ("NCreatureWithPropUserdata")
autoImport ("NNpc")
autoImport ("NPlayer")
autoImport ("NMyselfPlayer")
autoImport ("NPet")
autoImport ("NPartner")
autoImport ("NHandNpc")
autoImport ("NExpressNpc")
autoImport ("LogicManager_Creature_Userdata")
autoImport ("LogicManager_Npc_Userdata")
autoImport ("LogicManager_Player_Userdata")
autoImport ("LogicManager_Myself_Userdata")
autoImport ("LogicManager_Creature_Props")
autoImport ("LogicManager_Player_Props")
autoImport ("LogicManager_Myself_Props")
autoImport ("LogicManager_Npc_Props")
autoImport ("LogicManager_RoleDress")
autoImport ("LogicManager_HandInHand")
autoImport ("LogicManager_Hatred")
autoImport ("LogicManager_Pet_Props")

LogicManager_Creature = class("LogicManager_Creature")

function LogicManager_Creature:ctor()
	self.npcUserDataManager = LogicManager_Npc_Userdata.new()
	self.playerUserDataManager = LogicManager_Player_Userdata.new()
	self.myselfUserDataManager = LogicManager_Myself_Userdata.new()
	self.npcPropsManager = LogicManager_Npc_Props.new()
	self.petPropsManager = LogicManager_Pet_Props.new()
	self.playerPropsManager = LogicManager_Player_Props.new()
	self.myselfPropsManager = LogicManager_Myself_Props.new()
	self.roleDressManager = LogicManager_RoleDress.new()
	self.handInHandManager = LogicManager_HandInHand.new()
	self.hatredManager = LogicManager_Hatred.new()

	-- set global objects
	Game.LogicManager_Npc_Userdata = self.npcUserDataManager
	Game.LogicManager_Player_Userdata = self.playerUserDataManager
	Game.LogicManager_Player_Props = self.playerPropsManager
	Game.LogicManager_Myself_Props = self.myselfPropsManager
	Game.LogicManager_Npc_Props = self.npcPropsManager
	Game.LogicManager_Pet_Props = self.petPropsManager
	Game.LogicManager_Myself_Userdata = self.myselfUserDataManager
	Game.LogicManager_RoleDress = self.roleDressManager
	Game.LogicManager_HandInHand = self.handInHandManager
	Game.LogicManager_Hatred = self.hatredManager

	-- init
	self:SetSceneNpcProxy(NSceneNpcProxy.Instance)
	self:SetSceneUserProxy(NSceneUserProxy.Instance)
	self:SetScenePetProxy(NScenePetProxy.Instance)
end

function LogicManager_Creature:SetSceneNpcProxy(sceneNpcs)
	if(sceneNpcs) then
		self.sceneNpcs = sceneNpcs
	end
end

function LogicManager_Creature:SetSceneUserProxy(scenePlayers)
	if(scenePlayers) then
		self.scenePlayers = scenePlayers
	end
end

function LogicManager_Creature:SetScenePetProxy(scenePets)
	if(scenePets) then
		self.scenePets = scenePets
	end
end

function LogicManager_Creature:Update(time, deltaTime)
	self:UpdateNpc(time,deltaTime)
	self:UpdatePets(time,deltaTime)
	self:UpdatePlayer(time,deltaTime)
	self:UpdateMyself(time,deltaTime)

	self.roleDressManager:Update(time, deltaTime)
	self.hatredManager:Update(time, deltaTime)
end

function LogicManager_Creature:LateUpdate(time, deltaTime)
	self.handInHandManager:LateUpdate(time, deltaTime)
end

function LogicManager_Creature:UpdateNpc(time, deltaTime)
	local userDataManager = self.npcUserDataManager
	local npcPropsManager = self.npcPropsManager
	local npcs = self.sceneNpcs.userMap

	-- 1. npcs Update
	for k,v in pairs(npcs) do
		--user data
		userDataManager:CheckDirtyDatas(v)
		npcPropsManager:CheckDirtyDatas(v)
		--
		v:Update(time,deltaTime)
	end

	-- 2. 
	NNpc.StaticUpdate(time, deltaTime)
	NExpressNpc.StaticUpdate(time, deltaTime)
end

function LogicManager_Creature:UpdatePets(time, deltaTime)
	local userDataManager = self.npcUserDataManager
	local petPropsManager = self.petPropsManager
	local pets = self.scenePets.userMap

	-- 1. npcs Update
	for k,v in pairs(pets) do
		--
		userDataManager:CheckDirtyDatas(v)
		petPropsManager:CheckDirtyDatas(v)

		v:Update(time,deltaTime)
	end
end

function LogicManager_Creature:UpdatePlayer(time, deltaTime)
	local userDataManager = self.playerUserDataManager
	local playerPropsManager = self.playerPropsManager
	local users = self.scenePlayers.userMap

	-- 1. player Update
	for k,v in pairs(users) do
		--user data
		userDataManager:CheckDirtyDatas(v)
		playerPropsManager:CheckDirtyDatas(v)
		v:Update(time,deltaTime)
	end

	-- 2. 
	NPlayer.StaticUpdate(time, deltaTime)
end

function LogicManager_Creature:UpdateMyself(time, deltaTime)
	local userDataManager = self.myselfUserDataManager
	local myselfPropsManager = self.myselfPropsManager
	local myself = Game.Myself
	if(myself) then
		userDataManager:CheckDirtyDatas(myself)
		myselfPropsManager:CheckDirtyDatas(myself)
		myself:Update(time,deltaTime)
	end
end