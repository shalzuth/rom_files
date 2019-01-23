autoImport("CoreView")
TabView = class("TabView",CoreView)

--标签页开始
function TabView:AddTabChangeEvent(obj,target,openCheck,callback)
	if(not self.coreTabMap) then self.coreTabMap = {} end
	local key = openCheck
	if(type(openCheck)=="table" and openCheck.tab) then key = openCheck.tab end
	if(not self.coreTabMap[key]) then
		local toggle; 
		if(obj)then
			local togs = GameObjectUtil.Instance:GetAllComponentsInChildren(obj,UIToggle,true);
			if(#togs > 0)then
				toggle = togs[1];
			end
		end
		self.coreTabMap[key] = {check = openCheck,go = obj,tog = toggle,tar = target}
		if(obj~=nil) then
			self:AddClickEvent(obj,self:GetToggleEvent(callback))
		end
	end
end

function TabView:GetToggleEvent(callback)
	if(not self.coreToggleEvent) then
		self.coreToggleEvent = function(obj)
			if(self.coreTabMap) then
				for k,v in pairs(self.coreTabMap) do
					if(v.go == obj) then
						if(self:TabChangeHandler(k) and type(callback)=="function")then
							callback();
						end
						return
					end
				end
			end
		end
	end
	return self.coreToggleEvent
end

function TabView:TabChangeHandler(key)
	if(self.coreTabMap) then
		local tabObj = self.coreTabMap[key]
		if(type(tabObj.check)=="table" and tabObj.check.id) then
			if(not FunctionUnLockFunc.Me():CheckCanOpenByPanelId(tabObj.check.id,true)) then
				if(tabObj.tog~=nil) then
					tabObj.tog.value = false
				end
				return false
			end
		end
		if(tabObj.tog~=nil) then
			tabObj.tog.value = true
		end
		for k,v in pairs(self.coreTabMap) do
			if(v.tar) then
				v.tar.gameObject:SetActive(k==key)
			end
		end
		return true
	end
	return nil
end

--标签页结束