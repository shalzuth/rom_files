
autoImport ("GOLuaPoolManager")
autoImport ("AssetManagerRefactory")
autoImport ("LogicManager")
autoImport ("MapManager")
autoImport ("CreatureUIManager")
autoImport ("UILongPressManager")
autoImport ("SocialManager")
autoImport ("EffectManager")
autoImport ("ChatSystemManager")
autoImport ("LuaFarmlandManager")
autoImport ("FunctionTextureScale")
autoImport ("SkillManager")
autoImport ("WWWRequestManager")
autoImport ("QuestGuildManager")
autoImport ("QuestCountDownManager")

FunctionSystemManager = class("FunctionSystemManager")

function FunctionSystemManager:ctor()
	self.luaGOPoolManager = GOLuaPoolManager.new()
	self.assetManager = AssetManagerRefactory.new()
	self.logicManager = LogicManager.new()
	self.mapManager = MapManager.new()
	self.creatureUIManager = CreatureUIManager.new()
	self.uiLongPressManager = UILongPressManager.new()
	self.textureScale = FunctionTextureScale.new()
	self.socialManager = SocialManager.new()
	self.effectManager = EffectManager.new()
	self.chatSystemManager = ChatSystemManager.new()
	self.skillManager = SkillManager.new()
	self.wwwRequestManager = WWWRequestManager.new()
	self.questGuildManager = QuestGuildManager.new()
	self.questCountDownManager = QuestCountDownManager.new()

	-- set global objects
	Game.GOLuaPoolManager = self.luaGOPoolManager
	Game.AssetManager = self.assetManager
	Game.LogicManager = self.logicManager
	Game.MapManager = self.mapManager
	Game.CreatureUIManager = self.creatureUIManager
	Game.UILongPressManager = self.uiLongPressManager
	Game.SocialManager = self.socialManager
	Game.EffectManager = self.effectManager
	Game.ChatSystemManager = self.chatSystemManager
	Game.SkillManager = self.skillManager
	Game.WWWRequestManager = self.wwwRequestManager
	Game.QuestGuildManager = self.questGuildManager
	Game.QuestCountDownManager = self.questCountDownManager
end

function FunctionSystemManager:Update(time, deltaTime)
	self.assetManager:Update(time, deltaTime)
	self.skillManager:Update(time, deltaTime)
	self.logicManager:Update(time, deltaTime)
	self.creatureUIManager:Update(time, deltaTime)
	self.mapManager:Update(time, deltaTime)
	self.uiLongPressManager:Update(time, deltaTime)
	self.textureScale:Update()
	self.wwwRequestManager:Update(time, deltaTime)
	self.questGuildManager:Update(time, deltaTime)
	self.questCountDownManager:Update(time, deltaTime)
	LuaFarmlandManager.Ins():Update()
end

function FunctionSystemManager:LateUpdate(time, deltaTime)
	-- self.assetManager:LateUpdate(time, deltaTime)
	self.logicManager:LateUpdate(time, deltaTime)
	-- self.creatureUIManager:LateUpdate(time, deltaTime)
	self.mapManager:LateUpdate(time, deltaTime)
end