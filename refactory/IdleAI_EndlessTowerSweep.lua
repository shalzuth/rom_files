IdleAI_EndlessTowerSweep = class("IdleAI_EndlessTowerSweep")

function IdleAI_EndlessTowerSweep:ctor()
	self.requestOn = nil
	self.on = false

	self._MapManager = Game.MapManager
	self._EndlessTowerProxy = EndlessTowerProxy.Instance
end

function IdleAI_EndlessTowerSweep:Prepare(idleElapsed, time, deltaTime, creature)
	if not self.requestOn then
		return false
	end

	if not self._MapManager:IsEndlessTower() then
		return false
	end

	if not self._EndlessTowerProxy:CheckClearAll() then
		return false
	end

	return true
end

function IdleAI_EndlessTowerSweep:Start(idleElapsed, time, deltaTime, creature)
	self.on = true

	local ep = self._MapManager:FindExitPoint(1)
	if ep then
		Game.Myself:Client_MoveXYZTo(ep.position[1], ep.position[2], ep.position[3])
	end
end

function IdleAI_EndlessTowerSweep:End(idleElapsed, time, deltaTime, creature)
	self.on = false
end

function IdleAI_EndlessTowerSweep:Update(idleElapsed, time, deltaTime, creature)
	return true
end

function IdleAI_EndlessTowerSweep:Clear(idleElapsed, time, deltaTime, creature)
	self.requestOn = nil
	self.on = false
end

function IdleAI_EndlessTowerSweep:Request_Set(on)
	self.requestOn = on

	if self.on == true and on == false then
		self:StopMove()
	end
end

function IdleAI_EndlessTowerSweep:StopMove()
	local Myself = Game.Myself
	Myself:Logic_StopMove()
	Myself:Logic_PlayAction_Idle()
end