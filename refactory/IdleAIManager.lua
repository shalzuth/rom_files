
autoImport ("MissionCommand")
autoImport ("MissionCommandMove")
autoImport ("MissionCommandVisitNpc")
autoImport ("MissionCommandSkill")
autoImport ("MissionCommandFactory")

autoImport ("IdleAI_PlayShow")
autoImport ("IdleAI_HandInHand")
autoImport ("IdleAI_BeHolded")
autoImport ("IdleAI_DoubleAction")
autoImport ("IdleAI_Photographer")
autoImport ("IdleAI_Attack")
autoImport ("IdleAI_FearRun")
autoImport ("IdleAI_FlyFollow")
autoImport ("IdleAI_WalkFollow")
autoImport ("IdleAI_AutoBattle")
autoImport ("IdleAI_MissionCommand")
autoImport ("IdleAI_FollowLeader")
autoImport ("IdleAI_LookAt")
autoImport ("IdleAI_FakeDead")
autoImport ("IdleAI_EndlessTowerSweep")

IdleAIManager = class("IdleAIManager")

function IdleAIManager:ctor()
	self.ais = {}
	self.currentAI = nil
	self.pausing = 0
end

function IdleAIManager:Clear(idleElapsed, time, deltaTime, creature)
	self:Break(idleElapsed, time, deltaTime, creature)
	for i=1, #self.ais do
		self.ais[i]:Clear(idleElapsed, time, deltaTime, creature)
	end
end

function IdleAIManager:PushAI(ai)
	TableUtility.ArrayPushBack(self.ais, ai)
end

function IdleAIManager:Break(idleElapsed, time, deltaTime, creature)
	if nil ~= self.currentAI then
		self.currentAI:End(idleElapsed, time, deltaTime, creature)
		self.currentAI = nil
	end
end

function IdleAIManager:Pause(creature)
	self.pausing = self.pausing+1
	LogUtility.InfoFormat("<color=yellow>IdleAIManager:Pause: </color>{0}", self.pausing)
end

function IdleAIManager:Resume(creature)
	self.pausing = self.pausing-1
	LogUtility.InfoFormat("<color=yellow>IdleAIManager:Resume: </color>{0}", self.pausing)
end

function IdleAIManager:Update(idleElapsed, time, deltaTime, creature)
	if 0 < self.pausing then
		self:_SwitchAI(nil, idleElapsed, time, deltaTime, creature)
		return
	end

	local newAI = nil

	local ais = self.ais
	for i=1, #ais do
		local ai = ais[i]
		if ai:Prepare(idleElapsed, time, deltaTime, creature) then
			newAI = ai
			break
		end
	end

	self:_SwitchAI(newAI, idleElapsed, time, deltaTime, creature)

	if nil ~= self.currentAI then
		local currentAI = self.currentAI -- mabe Update call Break
		if not currentAI:Update(idleElapsed, time, deltaTime, creature) then
			if self.currentAI == currentAI then
				currentAI:End(idleElapsed, time, deltaTime, creature)
				self.currentAI = nil
			end
		end
	end
	return nil ~= self.currentAI
end

function IdleAIManager:UpdateCurrentAI(idleElapsed, time, deltaTime, creature)
	if nil ~= self.currentAI then
		local currentAI = self.currentAI -- mabe Update call Break
		if not currentAI:Prepare(idleElapsed, time, deltaTime, creature) 
			or not currentAI:Update(idleElapsed, time, deltaTime, creature) then
			if self.currentAI == currentAI then
				currentAI:End(idleElapsed, time, deltaTime, creature)
				self.currentAI = nil
			end
		end
		
	end
	return nil ~= self.currentAI
end

function IdleAIManager:GetCurrentAI()
	return self.currentAI
end

function IdleAIManager:_SwitchAI(newAI, idleElapsed, time, deltaTime, creature)
	if self.currentAI == newAI then
		return
	end
	if nil ~= self.currentAI then
		self.currentAI:End(idleElapsed, time, deltaTime, creature)
	end
	self.currentAI = newAI
	if nil ~= self.currentAI then
		self.currentAI:Start(idleElapsed, time, deltaTime, creature)
	end
end

