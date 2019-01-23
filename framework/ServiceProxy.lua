ServiceProxy = class('ServiceProxy', pm.Proxy)

ServiceProxy.NAME = "ServiceProxy"

function ServiceProxy.NumberToServer(value)
	return math.floor(value * 1000);
end

function ServiceProxy.ServerToNumber(value)
	return value / 1000;
end

function ServiceProxy:ctor(proxyName)
	self.proxyName = proxyName or ServiceProxy.NAME
	self.listeners = {}
end

function ServiceProxy:InitMediator(config)	
	self.mediator = pm.Mediator:new()
	self.mediator.mediatorName = self.proxyName
	self.mediator.viewComponent = self
	self.mediator.listNotificationInterests = self.listNotificationInterests
	self.mediator.handleNotification = self.handleNotification
	self.mediator.interests = {} 
	self.mediator.interestListeners = {}
	if config ~= nil then
		for k, v in pairs(config) do
			table.insert(self.mediator.interests, k)			
			self.mediator.interestListeners[k] = v
		end
	end
	GameFacade.Instance:registerMediator(self.mediator)
end

function ServiceProxy:listNotificationInterests()
	return self.interests
end

function ServiceProxy:handleNotification(note)	
	local evt = self.interestListeners[note.name]
	if evt ~= nil then
		evt(self.viewComponent, note.data)
	end	
end

function ServiceProxy:Call()
end

-- send protocol id1 id2
function ServiceProxy:Send(id1, id2, data)
	NetProtocol.Send(id1, id2, data)
end

function ServiceProxy:SendProto(data)
	NetProtocol.SendProto(data)
end

function ServiceProxy:Operation3(bool, a, b)
	if bool then
		return a 
	else
		return b
	end
end

function ServiceProxy:ToServerFloat(value)
	return ServiceProxy.NumberToServer(value);
end

function ServiceProxy:ToFloat(value)
	return ServiceProxy.ServerToNumber(value);
end

-- notify event
function ServiceProxy:Notify(event, data,type)
	if event == nil then
		NetLog.LogE("ServiceProxy::Notify Error: event is nil")
		return
	end

	GameFacade.Instance:sendNotification(event, data,type)
end

-- listen protocol down id1 id2
function ServiceProxy:Listen(id1, id2, func)
	if func == nil then
		return
	end

	-- log
	NetLog.Log("ServiceProxy:Listen called: "..self.proxyName.." id1_"..id1.." id2_"..id2)

	local listener = {
		id1 = id1,
		id2 = id2,
		func = function (id1, id2, data) 
			if(self.handleOnLoaded and self.handleOnLoaded[id1] and self.handleOnLoaded[id1][id2]) then
				ServiceHandlerOnLoadedProxy.Instance:TryCall(func,data)
			else
				func(data)
			end
		end
	}

	table.insert(self.listeners, listener)
	NetProtocol.AddListener(id1, id2, listener.func)
end

-- remove listener
function ServiceProxy:RemoveListener(id1, id2)
	for i, v in ipairs(self.listeners) do
		if v.id1 == id1 and v.id2 == id2 then			
			NetProtocol.RemoveListener(v.id1, v.id2, v.func)
			table.remove(self.listeners, i)
			return
		end
	end
end

-- remove all listeners
function ServiceProxy:RemoveListeners()
	for i, v in ipairs(self.listeners) do		
		NetProtocol.RemoveListener(v.id1, v.id2, v.func)		
		table.remove(self.listeners, i)
	end
end