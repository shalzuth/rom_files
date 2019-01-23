autoImport('ServiceSceneSkillAutoProxy')
ServiceSceneSkillProxy = class('ServiceSceneSkillProxy', ServiceSceneSkillAutoProxy)
ServiceSceneSkillProxy.Instance = nil
ServiceSceneSkillProxy.NAME = 'ServiceSceneSkillProxy'

function ServiceSceneSkillProxy:ctor(proxyName)
	if ServiceSceneSkillProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSceneSkillProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceSceneSkillProxy.Instance = self
	end
end
