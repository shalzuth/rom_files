autoImport('ServiceSceneInterlocutionAutoProxy')
ServiceSceneInterlocutionProxy = class('ServiceSceneInterlocutionProxy', ServiceSceneInterlocutionAutoProxy)
ServiceSceneInterlocutionProxy.Instance = nil
ServiceSceneInterlocutionProxy.NAME = 'ServiceSceneInterlocutionProxy'

function ServiceSceneInterlocutionProxy:ctor(proxyName)
	if ServiceSceneInterlocutionProxy.Instance == nil then
		self.proxyName = proxyName or ServiceSceneInterlocutionProxy.NAME
		ServiceProxy.ctor(self, self.proxyName)
		self:Init()
		ServiceSceneInterlocutionProxy.Instance = self
	end
end

function ServiceSceneInterlocutionProxy:CallAnswer(npcid, guid, interid, answer) 
	ServiceSceneInterlocutionProxy.super.CallAnswer(self, npcid, guid, interid, nil, answer) 
end

function ServiceSceneInterlocutionProxy:RecvNewInter(data)
	FunctionXO.Me():NewInter( data.inter, data.npcid )
end

function ServiceSceneInterlocutionProxy:RecvAnswer(data)
	FunctionXO.Me():AnswerResult( data.correct, data.npcid, data.source )
end

function ServiceSceneInterlocutionProxy:RecvQuery(data) 
	FunctionXO.Me():QueryQuestionResult(  data.ret, data.npcid )
end
