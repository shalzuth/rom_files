
autoImport ("Logic_Transform")
autoImport ("AI")
autoImport ("SpecialEffects")
autoImport ("LogicManager_Creature")
autoImport ("LogicManager_Skill")
autoImport ("LogicManager_RolePart")

LogicManager = class("LogicManager")

function LogicManager:ctor()
	self.logicCreature = LogicManager_Creature.new()
	self.logicSkill = LogicManager_Skill.new()
	self.logicRolePart = LogicManager_RolePart.new()

	-- set global objects
	Game.LogicManager_Creature = self.logicCreature
	Game.LogicManager_Skill = self.logicSkill
	Game.LogicManager_RolePart = self.logicRolePart
end

function LogicManager:Update(time, deltaTime)
	self.logicCreature:Update(time, deltaTime)
	self.logicSkill:Update(time, deltaTime)
end

function LogicManager:LateUpdate(time, deltaTime)
	self.logicCreature:LateUpdate(time, deltaTime)
	-- self.logicSkill:LateUpdate(time, deltaTime)
	self.logicRolePart:LateUpdate(time, deltaTime)
end