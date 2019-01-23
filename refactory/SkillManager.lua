autoImport ("SkillClickUseManager")
autoImport ("SkillOptionManager")

SkillManager = class("SkillManager")

function SkillManager:ctor()
	self.skillClickUseManager = SkillClickUseManager.new()
	self.skillOptionManager = SkillOptionManager.new()

	-- set global objects
	Game.SkillClickUseManager = self.skillClickUseManager
	Game.SkillOptionManager = self.skillOptionManager

	self.skillClickUseManager:Launch()
end

function SkillManager:Update(time, deltaTime)
	self.skillClickUseManager:Update(time,deltaTime)
end