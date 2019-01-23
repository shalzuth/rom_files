UIMediator = class('UIMediator', pm.Mediator)

function UIMediator:ctor(mediatorName, viewComponent)
	self.mediatorName = mediatorName
	self.viewComponent = viewComponent
	self:initializeNotifier(GameFacade.Instance.multitonKey)
end

function UIMediator:SetView(viewComponent)
	self.viewComponent = viewComponent
end

function UIMediator:listNotificationInterests()
	if(self.viewComponent ~= nil) then
		result = self.viewComponent:listNotificationInterests()
		return result
	end
	return {}
end

function UIMediator:handleNotification(notification)
	if(self.viewComponent ~= nil) then
		return self.viewComponent:handleNotification(notification)
	end
end

function UIMediator:onRegister()
end

function UIMediator:onRemove()
	-- if(self.viewComponent ~= nil) then
	-- 	self.viewComponent:Destroy()
	-- end
end

function UIMediator:Dispose()
	self.facade:removeMediator(self.mediatorName)
end