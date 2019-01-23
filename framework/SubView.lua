SubView = class("SubView", CoreView)

function SubView:ctor(container, initParama,subViewData)
	self.container = container;
	if(self.container) then
		self.viewdata = self.container.viewdata
	end
	self.subViewData = subViewData
	SubView.super.ctor(self, container.gameObject);
	self:Init(initParama);
end

function SubView:ReLoadPerferb(path)
	local preferb = self:LoadPreferb(path);
	preferb.transform:SetParent(self.container.trans, false);

	self.trans = preferb.transform
	self.gameObject = preferb;
	
	-- init panel depth
	local panel = GameObjectUtil.Instance:FindCompInParents(self.gameObject, UIPanel);
	local uipanels = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, UIPanel, true)
	for i=1,#uipanels do
		uipanels[i].depth = uipanels[i].depth + panel.depth;
	end
end

function SubView:OpenHelpView(data)
	if(data == nil)then
		local id = self.viewdata.view.id
		if(self.subViewData) then
			id = self.subViewData.id
		end
		data=Table_Help[id]
	end
	
	if(data)then
		TipsView.Me():ShowGeneralHelp(data.Desc, data.Title)
	else
		-- errorLog("can not find Table_Help content,id is "..id)
	end
end

function SubView:Init()
end

-- AddListenEvt
function SubView:AddListenEvt(evt, func)
	self.container:AddPageListenEvt(self, evt, func)
end

function SubView:AddSubView(key, view, initParama)
	if(key ~=nil and view ~=nil)then
		if(self.viewMap ==nil) then
			self.viewMap = {};
		end
		self.viewMap[key] = view.new(self.container, initParama);
	end
	return self.viewMap[key]
end

function SubView:RemoveSubView(key)
	if(nil~=key)then
		local subView = self.viewMap[key];
		if(subView)then
			self.viewMap[key] = nil;
			if(subView.OnExit)then
				subView:OnExit();
			end
			if(self.ListenerEvtMap)then
				for evtname, pageEvts in pairs(self.ListenerEvtMap)do
					if(type(pageEvts) == "table")then
						pageEvts[subView] = nil;
					end
				end	
			end

			if(not self:ObjIsNil(subView.gameObject))then
				GameObject.Destroy(subView.gameObject);
			end
		end
	end
end

function SubView:AddButtonEvent(name, evt)
	self.container:AddButtonEvent(name, evt)
end

function SubView:AddDispatcherEvt(evtname, func)
	self.disPatherEvt = self.disPatherEvt or {};
	self.disPatherEvt[evtname] = func;
end

function SubView:sendNotification(notificationName, body, type)
	self.container:sendNotification(notificationName, body, type);
end

function SubView:RegisterRedTipCheck(id,uiwidget,depth,offset,side)
	self.container:RegisterRedTipCheck(id,uiwidget,depth,offset,side)
end

function SubView:RegisterRedTipCheckByIds( ids,uiwidget,depth,offset,side )
	-- body
	self.container:RegisterRedTipCheckByIds(ids,uiwidget,depth,offset,side)
end

function SubView:OnEnter()
	if(self.container) then
		self.viewdata = self.container.viewdata
	end
	if(self.disPatherEvt~=nil)then
		for evt,func in pairs(self.disPatherEvt) do
			EventManager.Me():AddEventListener(evt, func, self);
		end
	end
end

function SubView:OnExit()
	if(self.disPatherEvt~=nil)then
		for evt,func in pairs(self.disPatherEvt) do
			EventManager.Me():RemoveEventListener(evt, func, self);
		end
		self.disPatherEvt = nil;
	end
end