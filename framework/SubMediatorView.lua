SubMediatorView = class("SubMediatorView", SubView)

function SubMediatorView:ctor(container, initParama,subViewData)
	SubMediatorView.super.ctor(self, container, initParama,subViewData);
end

function SubMediatorView:OnEnter()
	-- 注册mediator
	self.subMediator = UIMediator.new(self.__cname, self);
	GameFacade.Instance:registerMediator(self.subMediator)
	
	SubMediatorView.super.OnEnter(self);
end

function SubMediatorView:OnExit()
	if self.subMediator then
	self.subMediator:Dispose();
	self.subMediator = nil;
	end
	SubMediatorView.super.OnExit(self);
end

-- 添加监听事件
function SubMediatorView:AddListenEvt(interest, func)
	if(interest)then
		self.interests = self.interests or {};
		table.insert(self.interests, interest);

		self.ListenerEvtMap = self.ListenerEvtMap or {};
		self.ListenerEvtMap[interest] = func;
	else
		printRed("Event name is nil");
	end
end

function SubMediatorView:listNotificationInterests()
	return self.interests or {};
end

function SubMediatorView:handleNotification(note)
	if(self.ListenerEvtMap ~= nil) then
		local evt = self.ListenerEvtMap[note.name]
		if(evt~=nil) then
			evt(self,note)
		end
	end
end