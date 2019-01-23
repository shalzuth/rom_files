EventDispatcher = class("EventDispatcher")

function EventDispatcher:DispatchEvent(eventType,obj)
	if(self.handlers ~= nil and eventType ~=nil) then
		local eventHandlers = self.handlers[eventType]
		if(eventHandlers~=nil) then
			local evt = ReusableTable.CreateTable()
			evt.target, evt.data = self,obj
			for i=1,#eventHandlers do
				local e= eventHandlers[i]
				if(e.owners) then
					for j=1,#e.owners do
						e.func(e.owners[j],evt)
					end
				end
			end
			ReusableTable.DestroyAndClearTable(evt)
		end
	end
end

function EventDispatcher:PassEvent(eventType,obj)
	if(self.handlers ~= nil and eventType ~=nil) then
		local eventHandlers = self.handlers[eventType]
		if(eventHandlers~=nil) then
			for i=1,#eventHandlers do
				local e= eventHandlers[i]
				if(e.owners) then
					for j=1,#e.owners do
						e.func(e.owners[j],obj)
					end
				end
			end
		end
	end
end

function EventDispatcher:AddEventListener(eventType,handler,handlerOwner)
	if(self.handlers == nil) then
		self.handlers = {}
	end
	local eventHandlers = self.handlers[eventType]
	if(eventHandlers==nil) then
		eventHandlers = {}
		self.handlers[eventType] = eventHandlers
	end
	local index,ownerIndex = EventDispatcher.IndexOf(eventHandlers,handler,handlerOwner)
	if(index==0) then
		eventHandlers[#eventHandlers + 1] = {func = handler,owners = {handlerOwner}}
		-- table.insert( eventHandlers, {func = handler,owner = handlerOwner} )
	elseif(ownerIndex==0 and handlerOwner~=nil) then
		 table.insert( eventHandlers[index].owners,handlerOwner)
	end
end

function EventDispatcher.IndexOf(tab,obj,owner)
    for _, o in pairs(tab) do
        if o.func == obj then
        	if(owner) then
	        	for i=1,#o.owners do
	        		if(o.owners[i] == owner) then
	        			return _,i
	        		end
	        	end
	        end
            return _,0
        end
    end
    return 0,0
end

function EventDispatcher:RemoveEventListener(eventType,handler,handlerOwner)
	if(self.handlers ~= nil) then
		local eventHandlers = self.handlers[eventType]
		if(eventHandlers~=nil) then
			if(handler==nil) then
				self.handlers[eventType] = {}
			else
				local index,ownerIndex = EventDispatcher.IndexOf(eventHandlers,handler,handlerOwner)
				if(ownerIndex==0) then
					if(index > 0)then
						table.remove(eventHandlers,index)
					end
				else
					table.remove(eventHandlers[index].owners,ownerIndex)
				end
				-- TableUtil.Remove(eventHandlers,handler)
			end
		end
	end
end

function EventDispatcher:ClearEvent()
	self.handlers = nil
end