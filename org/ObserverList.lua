ObserverList = class('ObserverList')

function ObserverList:ctor(notificationName)
	self.notificationName = notificationName;
	self.observers = {}
end

function ObserverList:AddObserver(observer)
	self.observers[#self.observers + 1] = observer
end

function ObserverList:RemoveObserver(notifyContext)
	local observers = self.observers
	for i=#observers,1,-1 do
		local o = observers[i];
 		if o:compareNotifyContext(notifyContext) then
 			if(not self.running) then
	 			table.remove(observers, i)
	 		else
				self.dirtyRemoves = self.dirtyRemoves or {};
				self.dirtyRemoves[o] = 1;
	 		end
 			break
 		end
	end
end

function ObserverList:Notify(notification)
	self.running = true

	for _, o in ipairs(self.observers) do
		if(self.dirtyRemoves)then
			if(not self.dirtyRemoves[o])then
				o:notifyObserver(notification)
			end
		else
			o:notifyObserver(notification)
		end
	end

	self:RemoveDirty()
	self.running = false
end

function ObserverList:RemoveDirty()
	if(self.dirtyRemoves == nil)then
		return;
	end

	for o,_ in pairs(self.dirtyRemoves)do
		for i=#self.observers,1,-1 do
			if(self.observers[i] == o)then
				table.remove(self.observers, i);
				break;
			end
		end
	end
	self.dirtyRemoves = nil;
end