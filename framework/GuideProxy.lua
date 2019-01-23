GuideProxy = class('GuideProxy', pm.Proxy)
GuideProxy.Instance = nil;
GuideProxy.NAME = "GuideProxy"


function GuideProxy:ctor(proxyName, data)
	self.proxyName = proxyName or GuideProxy.NAME
	if(GuideProxy.Instance == nil) then
		GuideProxy.Instance = self
	end
	self:initData()
end

function GuideProxy:initData(  )
	-- body
	self.sameViewGuide = {}
	self.eventList = {}
	for k,v in pairs(Table_GuideID) do		
		if(v.uiID)then
			local list = self.sameViewGuide[v.uiID] or {}
			table.insert(list,v)
			self.sameViewGuide[v.uiID] = list
		end

		if(v.ServerEvent)then
			table.insert(self.eventList,v.ServerEvent)
		end
	end
end

function GuideProxy:getGuideListByViewName( viewName )
	-- body
	return self.sameViewGuide[viewName]
end

function GuideProxy:getGuideListeners(  )
	-- body
	return self.eventList
end
