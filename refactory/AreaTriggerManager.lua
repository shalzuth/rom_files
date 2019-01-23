
autoImport ("AreaTrigger_ExitPoint")
autoImport ("AreaTrigger_Mission")
autoImport ("AreaTrigger_Common")
autoImport ("AreaTrigger_Skill")

AreaTriggerManager = class("AreaTriggerManager")

function AreaTriggerManager:ctor()
	self.atExitPoint = AreaTrigger_ExitPoint.new()
	self.atMission = AreaTrigger_Mission.new()
	self.atCommon = AreaTrigger_Common.new()
	self.atSkill = AreaTrigger_Skill.CreateAsTable()

	Game.AreaTrigger_ExitPoint = self.atExitPoint
	Game.AreaTrigger_Mission = self.atMission
	Game.AreaTrigger_Common = self.atCommon
	Game.AreaTrigger_Skill = self.atSkill

	self.ignoreCount = 0
	self:SetIgnore(true)
end

function AreaTriggerManager:SetIgnore(ignore)
	if ignore then
		self.ignoreCount = self.ignoreCount + 1
	else
		self.ignoreCount = self.ignoreCount - 1
	end
	LuaLuancher.Instance.ignoreAreaTrigger = ignore
	
	-- old way
	-- Player.Me.ignoreAreaTrigger = ignore
end

function AreaTriggerManager:Launch()
	if self.running then
		return
	end
	self.running = true
	self:SetIgnore(false)

	self.atExitPoint:Launch()
	self.atMission:Launch()
	self.atCommon:Launch()
	self.atSkill:Launch()
end

function AreaTriggerManager:Shutdown()
	if not self.running then
		return
	end
	self.running = false
	self:SetIgnore(true)

	self.atExitPoint:Shutdown()
	self.atMission:Shutdown()
	self.atCommon:Shutdown()
	self.atSkill:Shutdown()
end

function AreaTriggerManager:Update(time, deltaTime)
	if not self.running then
		return
	end

	self.atMission:Update(time, deltaTime)
	self.atCommon:Update(time, deltaTime)
	self.atSkill:Update(time, deltaTime)

	if 0 < self.ignoreCount then
		return
	end
	
	self.atExitPoint:Update(time, deltaTime)
end