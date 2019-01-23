UIStackProxy = class ("UIStackProxy",pm.Proxy)

UIStackProxy.Instance = nil;

UIStackProxy.NAME = "UIStackProxy"

function UIStackProxy:ctor(proxyName, data)
	self.proxyName = proxyName or UIStackProxy.NAME
	if(UIStackProxy.Instance == nil) then
		UIStackProxy.Instance = self
	end
	if data ~= nil then
		self:setData(data)
	end

	self.uiStack = {};
end

function UIStackProxy:Peek(layerType)
	if(layerType)then
		local layerStack = self.uiStack[layerType];
		if(layerStack and type(layerStack)=="table")then
			return layerStack[#layerStack];
		end
	end
end

function UIStackProxy:Pop(layerType)
	if(layerType)then
		local layerStack = self.uiStack[layerType];
		if(layerStack and type(layerStack)=="table")then
			return table.remove(layerStack, #layerStack);
		end
	end
end

function UIStackProxy:Push(layerType, viewData)
	if(layerType)then
		if(not self.uiStack[layerType])then
			self.uiStack[layerType] = {};
		end
		table.insert(self.uiStack[layerType], viewData);
	end
end

function UIStackProxy:Clear(layerType)
	
end












