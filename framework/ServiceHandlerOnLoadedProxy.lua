ServiceHandlerOnLoadedProxy = class('ServiceHandlerOnLoadedProxy', pm.Proxy)

ServiceHandlerOnLoadedProxy.Instance = nil;

ServiceHandlerOnLoadedProxy.NAME = "ServiceHandlerOnLoadedProxy"

function ServiceHandlerOnLoadedProxy:ctor(proxyName)	
	self.proxyName = proxyName or SceneObjectProxy.NAME
	if(ServiceHandlerOnLoadedProxy.Instance == nil) then
		ServiceHandlerOnLoadedProxy.Instance = self
	end
	self.cachedCalls = {}
end

function ServiceHandlerOnLoadedProxy:TryCall(func,data)	
	if(SceneProxy.Instance.currentScene == nil or SceneProxy.Instance.currentScene.loaded==false) then
		self.cachedCalls[#self.cachedCalls+1] = {func,data}
	else
		func(data)
	end
end

function ServiceHandlerOnLoadedProxy:Call()
	if(#self.cachedCalls>0) then
		local call
		for i=1,#self.cachedCalls do
			call = self.cachedCalls[i]
			call[1](call[2])
		end
		self.cachedCalls = {}
	end
end