autoImport('ServiceSceneManualAutoProxy')
ServiceSceneManualProxy = class('ServiceSceneManualProxy', ServiceSceneManualAutoProxy)
ServiceSceneManualProxy.Instance = nil
ServiceSceneManualProxy.NAME = 'ServiceSceneManualProxy'

function ServiceSceneManualProxy:ctor(proxyName)
	if ServiceSceneManualProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSceneManualProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceSceneManualProxy.Instance = self
	end
end

function ServiceSceneManualProxy:RecvPointSync(data) 
	-- printRed("RecvPointSync")
	AdventureDataProxy.Instance:setPointData(data.point)
	self:Notify(ServiceEvent.SceneManualPointSync, data)
end

function ServiceSceneManualProxy:RecvQueryManualData(data) 
	self:Notify(ServiceEvent.SceneManualQueryManualData, data)
	AdventureDataProxy.Instance:checkSceneryRedTips(data.item.type)
end

function ServiceSceneManualProxy:RecvLevelSync(data) 
	-- printRed("RecvPointSync")
	AdventureDataProxy.Instance:setManualLevel(data.level)
	self:Notify(ServiceEvent.SceneManualPointSync, data)
end

function ServiceSceneManualProxy:RecvSkillPointSync(data) 
	AdventureDataProxy.Instance:setSkillPoint(data.skillpoint)
	self:Notify(ServiceEvent.SceneManualSkillPointSync, data)
end

function ServiceSceneManualProxy:RecvManualUpdate(data) 
	self:Notify(ServiceEvent.SceneManualManualUpdate, data)
	AdventureDataProxy.Instance:checkSceneryRedTips(data.update.type)
end

function ServiceSceneManualProxy:RecvQueryUnsolvedPhotoManualCmd(data)
	AdventureDataProxy.Instance:QueryUnresolvedPhotoManualCmd(data)
	self:Notify(ServiceEvent.SceneManualQueryUnsolvedPhotoManualCmd, data)
end

function ServiceSceneManualProxy:RecvUpdateSolvedPhotoManualCmd(data)
	AdventureDataProxy.Instance:UpdateResolvedPhotoManualCmd(data)
	self:Notify(ServiceEvent.SceneManualUpdateSolvedPhotoManualCmd, data)
end